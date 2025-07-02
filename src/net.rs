use tokio::{net::UdpSocket, sync::mpsc};
use flatbuffers::{FlatBufferBuilder};
use anyhow::Result;
use std::net::SocketAddr;

mod wire;            // generated

/// Frame you pass to / receive from business code
#[derive(Debug)]
pub struct Frame {
    pub seq: u32,
    pub ack: u32,
    pub bytes: Vec<u8>,
}

/// spawn_io() gives you (tx_to_net, rx_from_net)
pub async fn spawn_io(
    bind: SocketAddr,
    peer: SocketAddr,
) -> Result<(mpsc::Sender<Frame>, mpsc::Receiver<Frame>)> {
    let sock = UdpSocket::bind(bind).await?;
    sock.connect(peer).await?;
    let (tx_net, mut rx_logic) = mpsc::channel::<Frame>(128);
    let (tx_logic, rx_net)    = mpsc::channel::<Frame>(128);

    // ── TX task ────────────────────────────────
    let s = sock.clone();
    tokio::spawn(async move {
        while let Some(f) = rx_logic.recv().await {
            let mut fbb = FlatBufferBuilder::new();
            let payload = fbb.create_vector(&f.bytes);
            let hdr = wire::Header::create(&mut fbb, &wire::HeaderArgs {
                seq: f.seq, ack: f.ack, flags: 0,
            });
            let body = wire::Payload::create(&mut fbb, &wire::PayloadArgs { data: Some(payload) });
            let pkt  = wire::Packet::create(&mut fbb, &wire::PacketArgs { hdr: Some(hdr), body: Some(body) });
            fbb.finish(pkt, None);
            // ignore send errors for brevity
            let _ = s.send(fbb.finished_data()).await;
        }
    });

    // ── RX task ────────────────────────────────
    tokio::spawn(async move {
        let mut buf = [0u8; 1500];
        loop {
            let n = sock.recv(&mut buf).await.expect("udp recv");
            let pkt = wire::get_root_as_packet(&buf[..n]);
            let frame = Frame {
                seq: pkt.hdr().seq(),
                ack: pkt.hdr().ack(),
                bytes: pkt.body().unwrap().data().unwrap().to_vec(),
            };
            if tx_logic.send(frame).await.is_err() {
                break; // business layer hung up
            }
        }
    });

    Ok((tx_net, rx_net))
}
