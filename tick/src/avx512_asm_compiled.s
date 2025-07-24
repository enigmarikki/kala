avx512_Xx_1: .intel_syntax noprefix      # asm_function:64          .intel_syntax noprefix
avx512_Xx_2: .global asm_avx512_func_to_avx512_integer_9_12 # asm_function:74          .global asm_avx512_func_to_avx512_integer_9_12
avx512_Xx_3: asm_avx512_func_to_avx512_integer_9_12: # asm_function:75          asm_avx512_func_to_avx512_integer_9_12:
avx512_Xx_4: VPBROADCASTQ ZMM4, RDI      # to_avx512_integer:254    VPBROADCASTQ `in_num_limbs_vector, `in_num_limbs
avx512_Xx_5: VPABSQ ZMM4, ZMM4           # to_avx512_integer:255    VPABSQ `in_num_limbs_vector, `in_num_limbs_vector
avx512_Xx_6: MOV RAX, RDI                # to_avx512_integer:258    MOV `out_sign, `in_num_limbs
avx512_Xx_7: SAR RAX, 63                 # to_avx512_integer:259    SAR `out_sign, 63
avx512_Xx_8: .text 1                     # to_avx512_integer:142    .text 1
avx512_Xx_9: .balign 64                  # to_avx512_integer:144    .balign 64
avx512_Xx_10: _avx512_label_0:           # to_avx512_integer:145    _avx512_label_0:
avx512_Xx_11: .quad 0x0                  # to_avx512_integer:147    .quad 0x0
avx512_Xx_12: .quad 0x1                  # to_avx512_integer:147    .quad 0x1
avx512_Xx_13: .quad 0x2                  # to_avx512_integer:147    .quad 0x2
avx512_Xx_14: .quad 0x3                  # to_avx512_integer:147    .quad 0x3
avx512_Xx_15: .quad 0x4                  # to_avx512_integer:147    .quad 0x4
avx512_Xx_16: .quad 0x5                  # to_avx512_integer:147    .quad 0x5
avx512_Xx_17: .quad 0x6                  # to_avx512_integer:147    .quad 0x6
avx512_Xx_18: .quad 0x7                  # to_avx512_integer:147    .quad 0x7
avx512_Xx_19: .text                      # to_avx512_integer:149    .text
avx512_Xx_20: VPCMPUQ k1, ZMM4, ZMMWORD PTR [_avx512_label_0], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_0], 6
avx512_Xx_21: VMOVDQU64 ZMM0 {k1}{z}, [RSI+0] # to_avx512_integer:271    VMOVDQU64 `input_registers_0 {k1}{z}, [`in_data+0]
avx512_Xx_22: .text 1                    # to_avx512_integer:142    .text 1
avx512_Xx_23: .balign 64                 # to_avx512_integer:144    .balign 64
avx512_Xx_24: _avx512_label_1:           # to_avx512_integer:145    _avx512_label_1:
avx512_Xx_25: .quad 0x8                  # to_avx512_integer:147    .quad 0x8
avx512_Xx_26: .quad 0x9                  # to_avx512_integer:147    .quad 0x9
avx512_Xx_27: .quad 0xa                  # to_avx512_integer:147    .quad 0xa
avx512_Xx_28: .quad 0xb                  # to_avx512_integer:147    .quad 0xb
avx512_Xx_29: .quad 0xc                  # to_avx512_integer:147    .quad 0xc
avx512_Xx_30: .quad 0xd                  # to_avx512_integer:147    .quad 0xd
avx512_Xx_31: .quad 0xe                  # to_avx512_integer:147    .quad 0xe
avx512_Xx_32: .quad 0xf                  # to_avx512_integer:147    .quad 0xf
avx512_Xx_33: .text                      # to_avx512_integer:149    .text
avx512_Xx_34: VPCMPUQ k1, ZMM4, ZMMWORD PTR [_avx512_label_1], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_1], 6
avx512_Xx_35: VMOVDQU64 ZMM1 {k1}{z}, [RSI+64] # to_avx512_integer:271    VMOVDQU64 `input_registers_1 {k1}{z}, [`in_data+64]
avx512_Xx_36: VPXORQ ZMM2, ZMM2, ZMM2    # to_avx512_integer:275    VPXORQ `temp_vector, `temp_vector, `temp_vector
avx512_Xx_37: VMOVDQU64 [RDX-64], ZMM2   # to_avx512_integer:276    VMOVDQU64 [`out_data-64], `temp_vector
avx512_Xx_38: VMOVDQU64 [RDX+128], ZMM2  # to_avx512_integer:277    VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_39: .text 1                    # to_avx512_integer:142    .text 1
avx512_Xx_40: .balign 64                 # to_avx512_integer:144    .balign 64
avx512_Xx_41: _avx512_label_2:           # to_avx512_integer:145    _avx512_label_2:
avx512_Xx_42: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_43: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_44: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_45: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_46: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_47: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_48: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_49: .quad 0xfffffffffffff      # to_avx512_integer:147    .quad 0xfffffffffffff
avx512_Xx_50: .text                      # to_avx512_integer:149    .text
avx512_Xx_51: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_2] # to_avx512_integer:279    VMOVDQU64 `mask_vector, ZMMWORD PTR [_avx512_label_2]
avx512_Xx_52: .text 1                    # apply_shifts:142         .text 1
avx512_Xx_53: .balign 64                 # apply_shifts:144         .balign 64
avx512_Xx_54: _avx512_label_3:           # apply_shifts:145         _avx512_label_3:
avx512_Xx_55: .quad 0x0                  # apply_shifts:147         .quad 0x0
avx512_Xx_56: .quad 0x0                  # apply_shifts:147         .quad 0x0
avx512_Xx_57: .quad 0x1                  # apply_shifts:147         .quad 0x1
avx512_Xx_58: .quad 0x2                  # apply_shifts:147         .quad 0x2
avx512_Xx_59: .quad 0x3                  # apply_shifts:147         .quad 0x3
avx512_Xx_60: .quad 0x4                  # apply_shifts:147         .quad 0x4
avx512_Xx_61: .quad 0x4                  # apply_shifts:147         .quad 0x4
avx512_Xx_62: .quad 0x5                  # apply_shifts:147         .quad 0x5
avx512_Xx_63: .text                      # apply_shifts:149         .text
avx512_Xx_64: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_3] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_3]
avx512_Xx_65: VPERMI2Q ZMM5, ZMM0, ZMM0  # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_66: .text 1                    # apply_shifts:142         .text 1
avx512_Xx_67: .balign 64                 # apply_shifts:144         .balign 64
avx512_Xx_68: _avx512_label_4:           # apply_shifts:145         _avx512_label_4:
avx512_Xx_69: .quad 0x0                  # apply_shifts:147         .quad 0x0
avx512_Xx_70: .quad 0x34                 # apply_shifts:147         .quad 0x34
avx512_Xx_71: .quad 0x28                 # apply_shifts:147         .quad 0x28
avx512_Xx_72: .quad 0x1c                 # apply_shifts:147         .quad 0x1c
avx512_Xx_73: .quad 0x10                 # apply_shifts:147         .quad 0x10
avx512_Xx_74: .quad 0x4                  # apply_shifts:147         .quad 0x4
avx512_Xx_75: .quad 0x38                 # apply_shifts:147         .quad 0x38
avx512_Xx_76: .quad 0x2c                 # apply_shifts:147         .quad 0x2c
avx512_Xx_77: .text                      # apply_shifts:149         .text
avx512_Xx_78: VPSRLVQ ZMM2, ZMM5, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_79: .text 1                    # apply_shifts:142         .text 1
avx512_Xx_80: .balign 64                 # apply_shifts:144         .balign 64
avx512_Xx_81: _avx512_label_5:           # apply_shifts:145         _avx512_label_5:
avx512_Xx_82: .quad 0x0                  # apply_shifts:147         .quad 0x0
avx512_Xx_83: .quad 0x1                  # apply_shifts:147         .quad 0x1
avx512_Xx_84: .quad 0x2                  # apply_shifts:147         .quad 0x2
avx512_Xx_85: .quad 0x3                  # apply_shifts:147         .quad 0x3
avx512_Xx_86: .quad 0x4                  # apply_shifts:147         .quad 0x4
avx512_Xx_87: .quad 0x5                  # apply_shifts:147         .quad 0x5
avx512_Xx_88: .quad 0x5                  # apply_shifts:147         .quad 0x5
avx512_Xx_89: .quad 0x6                  # apply_shifts:147         .quad 0x6
avx512_Xx_90: .text                      # apply_shifts:149         .text
avx512_Xx_91: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_5] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_5]
avx512_Xx_92: VPERMI2Q ZMM5, ZMM0, ZMM0  # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_93: .text 1                    # apply_shifts:142         .text 1
avx512_Xx_94: .balign 64                 # apply_shifts:144         .balign 64
avx512_Xx_95: _avx512_label_6:           # apply_shifts:145         _avx512_label_6:
avx512_Xx_96: .quad 0x40                 # apply_shifts:147         .quad 0x40
avx512_Xx_97: .quad 0xc                  # apply_shifts:147         .quad 0xc
avx512_Xx_98: .quad 0x18                 # apply_shifts:147         .quad 0x18
avx512_Xx_99: .quad 0x24                 # apply_shifts:147         .quad 0x24
avx512_Xx_100: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_101: .quad 0x3c                # apply_shifts:147         .quad 0x3c
avx512_Xx_102: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_103: .quad 0x14                # apply_shifts:147         .quad 0x14
avx512_Xx_104: .text                     # apply_shifts:149         .text
avx512_Xx_105: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_106: VPORQ ZMM2, ZMM2, ZMM5    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_107: VPANDQ ZMM2, ZMM2, ZMM3   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_108: VMOVDQU64 [RDX+0], ZMM2   # to_avx512_integer:303    VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_109: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_110: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_111: _avx512_label_7:          # apply_shifts:145         _avx512_label_7:
avx512_Xx_112: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_113: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_114: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_115: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_116: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_117: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_118: .quad 0xb                 # apply_shifts:147         .quad 0xb
avx512_Xx_119: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_120: .text                     # apply_shifts:149         .text
avx512_Xx_121: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_7] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_7]
avx512_Xx_122: VPERMI2Q ZMM5, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_123: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_124: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_125: _avx512_label_8:          # apply_shifts:145         _avx512_label_8:
avx512_Xx_126: .quad 0x20                # apply_shifts:147         .quad 0x20
avx512_Xx_127: .quad 0x14                # apply_shifts:147         .quad 0x14
avx512_Xx_128: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_129: .quad 0x3c                # apply_shifts:147         .quad 0x3c
avx512_Xx_130: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_131: .quad 0x24                # apply_shifts:147         .quad 0x24
avx512_Xx_132: .quad 0x18                # apply_shifts:147         .quad 0x18
avx512_Xx_133: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_134: .text                     # apply_shifts:149         .text
avx512_Xx_135: VPSRLVQ ZMM2, ZMM5, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_136: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_137: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_138: _avx512_label_9:          # apply_shifts:145         _avx512_label_9:
avx512_Xx_139: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_140: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_141: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_142: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_143: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_144: .quad 0xb                 # apply_shifts:147         .quad 0xb
avx512_Xx_145: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_146: .quad 0xd                 # apply_shifts:147         .quad 0xd
avx512_Xx_147: .text                     # apply_shifts:149         .text
avx512_Xx_148: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_9] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_9]
avx512_Xx_149: VPERMI2Q ZMM5, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_150: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_151: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_152: _avx512_label_10:         # apply_shifts:145         _avx512_label_10:
avx512_Xx_153: .quad 0x20                # apply_shifts:147         .quad 0x20
avx512_Xx_154: .quad 0x2c                # apply_shifts:147         .quad 0x2c
avx512_Xx_155: .quad 0x38                # apply_shifts:147         .quad 0x38
avx512_Xx_156: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_157: .quad 0x10                # apply_shifts:147         .quad 0x10
avx512_Xx_158: .quad 0x1c                # apply_shifts:147         .quad 0x1c
avx512_Xx_159: .quad 0x28                # apply_shifts:147         .quad 0x28
avx512_Xx_160: .quad 0x34                # apply_shifts:147         .quad 0x34
avx512_Xx_161: .text                     # apply_shifts:149         .text
avx512_Xx_162: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_163: VPORQ ZMM2, ZMM2, ZMM5    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_164: VPANDQ ZMM2, ZMM2, ZMM3   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_165: VMOVDQU64 [RDX+64], ZMM2  # to_avx512_integer:303    VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_166: _avx512_label_11:         # ~asm_function:121        _avx512_label_11:
avx512_Xx_167: RET                       # ~asm_function:130        RET
avx512_Xx_168: .global asm_avx512_func_to_avx512_integer_17_21 # asm_function:74          .global asm_avx512_func_to_avx512_integer_17_21
avx512_Xx_169: asm_avx512_func_to_avx512_integer_17_21: # asm_function:75          asm_avx512_func_to_avx512_integer_17_21:
avx512_Xx_170: VPBROADCASTQ ZMM5, RDI    # to_avx512_integer:254    VPBROADCASTQ `in_num_limbs_vector, `in_num_limbs
avx512_Xx_171: VPABSQ ZMM5, ZMM5         # to_avx512_integer:255    VPABSQ `in_num_limbs_vector, `in_num_limbs_vector
avx512_Xx_172: MOV RAX, RDI              # to_avx512_integer:258    MOV `out_sign, `in_num_limbs
avx512_Xx_173: SAR RAX, 63               # to_avx512_integer:259    SAR `out_sign, 63
avx512_Xx_174: VPCMPUQ k1, ZMM5, ZMMWORD PTR [_avx512_label_0], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_0], 6
avx512_Xx_175: VMOVDQU64 ZMM0 {k1}{z}, [RSI+0] # to_avx512_integer:271    VMOVDQU64 `input_registers_0 {k1}{z}, [`in_data+0]
avx512_Xx_176: VPCMPUQ k1, ZMM5, ZMMWORD PTR [_avx512_label_1], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_1], 6
avx512_Xx_177: VMOVDQU64 ZMM1 {k1}{z}, [RSI+64] # to_avx512_integer:271    VMOVDQU64 `input_registers_1 {k1}{z}, [`in_data+64]
avx512_Xx_178: .text 1                   # to_avx512_integer:142    .text 1
avx512_Xx_179: .balign 64                # to_avx512_integer:144    .balign 64
avx512_Xx_180: _avx512_label_12:         # to_avx512_integer:145    _avx512_label_12:
avx512_Xx_181: .quad 0x10                # to_avx512_integer:147    .quad 0x10
avx512_Xx_182: .quad 0x11                # to_avx512_integer:147    .quad 0x11
avx512_Xx_183: .quad 0x12                # to_avx512_integer:147    .quad 0x12
avx512_Xx_184: .quad 0x13                # to_avx512_integer:147    .quad 0x13
avx512_Xx_185: .quad 0x14                # to_avx512_integer:147    .quad 0x14
avx512_Xx_186: .quad 0x15                # to_avx512_integer:147    .quad 0x15
avx512_Xx_187: .quad 0x16                # to_avx512_integer:147    .quad 0x16
avx512_Xx_188: .quad 0x17                # to_avx512_integer:147    .quad 0x17
avx512_Xx_189: .text                     # to_avx512_integer:149    .text
avx512_Xx_190: VPCMPUQ k1, ZMM5, ZMMWORD PTR [_avx512_label_12], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_12], 6
avx512_Xx_191: VMOVDQU64 ZMM2 {k1}{z}, [RSI+128] # to_avx512_integer:271    VMOVDQU64 `input_registers_2 {k1}{z}, [`in_data+128]
avx512_Xx_192: VPXORQ ZMM3, ZMM3, ZMM3   # to_avx512_integer:275    VPXORQ `temp_vector, `temp_vector, `temp_vector
avx512_Xx_193: VMOVDQU64 [RDX-64], ZMM3  # to_avx512_integer:276    VMOVDQU64 [`out_data-64], `temp_vector
avx512_Xx_194: VMOVDQU64 [RDX+192], ZMM3 # to_avx512_integer:277    VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_195: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_2] # to_avx512_integer:279    VMOVDQU64 `mask_vector, ZMMWORD PTR [_avx512_label_2]
avx512_Xx_196: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_3] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_3]
avx512_Xx_197: VPERMI2Q ZMM6, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_198: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_199: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_5] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_5]
avx512_Xx_200: VPERMI2Q ZMM6, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_201: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_202: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_203: VPANDQ ZMM3, ZMM3, ZMM4   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_204: VMOVDQU64 [RDX+0], ZMM3   # to_avx512_integer:303    VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_205: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_7] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_7]
avx512_Xx_206: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_207: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_208: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_9] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_9]
avx512_Xx_209: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_210: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_211: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_212: VPANDQ ZMM3, ZMM3, ZMM4   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_213: VMOVDQU64 [RDX+64], ZMM3  # to_avx512_integer:303    VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_214: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_215: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_216: _avx512_label_13:         # apply_shifts:145         _avx512_label_13:
avx512_Xx_217: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_218: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_219: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_220: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_221: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_222: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_223: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_224: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_225: .text                     # apply_shifts:149         .text
avx512_Xx_226: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_13] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_13]
avx512_Xx_227: VPERMI2Q ZMM6, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_228: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_229: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_230: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_231: _avx512_label_14:         # apply_shifts:145         _avx512_label_14:
avx512_Xx_232: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_233: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_234: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_235: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_236: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_237: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_238: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_239: .quad 0xb                 # apply_shifts:147         .quad 0xb
avx512_Xx_240: .text                     # apply_shifts:149         .text
avx512_Xx_241: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_14] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_14]
avx512_Xx_242: VPERMI2Q ZMM6, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_243: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_244: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_245: VPANDQ ZMM3, ZMM3, ZMM4   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_246: VMOVDQU64 [RDX+128], ZMM3 # to_avx512_integer:303    VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_247: _avx512_label_15:         # ~asm_function:121        _avx512_label_15:
avx512_Xx_248: RET                       # ~asm_function:130        RET
avx512_Xx_249: .global asm_avx512_func_to_avx512_integer_25_31 # asm_function:74          .global asm_avx512_func_to_avx512_integer_25_31
avx512_Xx_250: asm_avx512_func_to_avx512_integer_25_31: # asm_function:75          asm_avx512_func_to_avx512_integer_25_31:
avx512_Xx_251: VPBROADCASTQ ZMM6, RDI    # to_avx512_integer:254    VPBROADCASTQ `in_num_limbs_vector, `in_num_limbs
avx512_Xx_252: VPABSQ ZMM6, ZMM6         # to_avx512_integer:255    VPABSQ `in_num_limbs_vector, `in_num_limbs_vector
avx512_Xx_253: MOV RAX, RDI              # to_avx512_integer:258    MOV `out_sign, `in_num_limbs
avx512_Xx_254: SAR RAX, 63               # to_avx512_integer:259    SAR `out_sign, 63
avx512_Xx_255: VPCMPUQ k1, ZMM6, ZMMWORD PTR [_avx512_label_0], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_0], 6
avx512_Xx_256: VMOVDQU64 ZMM0 {k1}{z}, [RSI+0] # to_avx512_integer:271    VMOVDQU64 `input_registers_0 {k1}{z}, [`in_data+0]
avx512_Xx_257: VPCMPUQ k1, ZMM6, ZMMWORD PTR [_avx512_label_1], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_1], 6
avx512_Xx_258: VMOVDQU64 ZMM1 {k1}{z}, [RSI+64] # to_avx512_integer:271    VMOVDQU64 `input_registers_1 {k1}{z}, [`in_data+64]
avx512_Xx_259: VPCMPUQ k1, ZMM6, ZMMWORD PTR [_avx512_label_12], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_12], 6
avx512_Xx_260: VMOVDQU64 ZMM2 {k1}{z}, [RSI+128] # to_avx512_integer:271    VMOVDQU64 `input_registers_2 {k1}{z}, [`in_data+128]
avx512_Xx_261: .text 1                   # to_avx512_integer:142    .text 1
avx512_Xx_262: .balign 64                # to_avx512_integer:144    .balign 64
avx512_Xx_263: _avx512_label_16:         # to_avx512_integer:145    _avx512_label_16:
avx512_Xx_264: .quad 0x18                # to_avx512_integer:147    .quad 0x18
avx512_Xx_265: .quad 0x19                # to_avx512_integer:147    .quad 0x19
avx512_Xx_266: .quad 0x1a                # to_avx512_integer:147    .quad 0x1a
avx512_Xx_267: .quad 0x1b                # to_avx512_integer:147    .quad 0x1b
avx512_Xx_268: .quad 0x1c                # to_avx512_integer:147    .quad 0x1c
avx512_Xx_269: .quad 0x1d                # to_avx512_integer:147    .quad 0x1d
avx512_Xx_270: .quad 0x1e                # to_avx512_integer:147    .quad 0x1e
avx512_Xx_271: .quad 0x1f                # to_avx512_integer:147    .quad 0x1f
avx512_Xx_272: .text                     # to_avx512_integer:149    .text
avx512_Xx_273: VPCMPUQ k1, ZMM6, ZMMWORD PTR [_avx512_label_16], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_16], 6
avx512_Xx_274: VMOVDQU64 ZMM3 {k1}{z}, [RSI+192] # to_avx512_integer:271    VMOVDQU64 `input_registers_3 {k1}{z}, [`in_data+192]
avx512_Xx_275: VPXORQ ZMM4, ZMM4, ZMM4   # to_avx512_integer:275    VPXORQ `temp_vector, `temp_vector, `temp_vector
avx512_Xx_276: VMOVDQU64 [RDX-64], ZMM4  # to_avx512_integer:276    VMOVDQU64 [`out_data-64], `temp_vector
avx512_Xx_277: VMOVDQU64 [RDX+256], ZMM4 # to_avx512_integer:277    VMOVDQU64 [`out_data+256], `temp_vector
avx512_Xx_278: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_2] # to_avx512_integer:279    VMOVDQU64 `mask_vector, ZMMWORD PTR [_avx512_label_2]
avx512_Xx_279: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_3] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_3]
avx512_Xx_280: VPERMI2Q ZMM7, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_281: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_282: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_5] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_5]
avx512_Xx_283: VPERMI2Q ZMM7, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_284: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_285: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_286: VPANDQ ZMM4, ZMM4, ZMM5   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_287: VMOVDQU64 [RDX+0], ZMM4   # to_avx512_integer:303    VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_288: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_7] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_7]
avx512_Xx_289: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_290: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_291: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_9] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_9]
avx512_Xx_292: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_293: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_294: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_295: VPANDQ ZMM4, ZMM4, ZMM5   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_296: VMOVDQU64 [RDX+64], ZMM4  # to_avx512_integer:303    VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_297: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_13] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_13]
avx512_Xx_298: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_299: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_300: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_14] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_14]
avx512_Xx_301: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_302: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_303: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_304: VPANDQ ZMM4, ZMM4, ZMM5   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_305: VMOVDQU64 [RDX+128], ZMM4 # to_avx512_integer:303    VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_306: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_307: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_308: _avx512_label_17:         # apply_shifts:145         _avx512_label_17:
avx512_Xx_309: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_310: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_311: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_312: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_313: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_314: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_315: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_316: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_317: .text                     # apply_shifts:149         .text
avx512_Xx_318: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_17] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_17]
avx512_Xx_319: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_320: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_321: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_322: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_323: _avx512_label_18:         # apply_shifts:145         _avx512_label_18:
avx512_Xx_324: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_325: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_326: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_327: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_328: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_329: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_330: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_331: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_332: .text                     # apply_shifts:149         .text
avx512_Xx_333: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_18] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_18]
avx512_Xx_334: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_335: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_336: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_337: VPANDQ ZMM4, ZMM4, ZMM5   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_338: VMOVDQU64 [RDX+192], ZMM4 # to_avx512_integer:303    VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_339: _avx512_label_19:         # ~asm_function:121        _avx512_label_19:
avx512_Xx_340: RET                       # ~asm_function:130        RET
avx512_Xx_341: .global asm_avx512_func_to_avx512_integer_33_41 # asm_function:74          .global asm_avx512_func_to_avx512_integer_33_41
avx512_Xx_342: asm_avx512_func_to_avx512_integer_33_41: # asm_function:75          asm_avx512_func_to_avx512_integer_33_41:
avx512_Xx_343: VPBROADCASTQ ZMM7, RDI    # to_avx512_integer:254    VPBROADCASTQ `in_num_limbs_vector, `in_num_limbs
avx512_Xx_344: VPABSQ ZMM7, ZMM7         # to_avx512_integer:255    VPABSQ `in_num_limbs_vector, `in_num_limbs_vector
avx512_Xx_345: MOV RAX, RDI              # to_avx512_integer:258    MOV `out_sign, `in_num_limbs
avx512_Xx_346: SAR RAX, 63               # to_avx512_integer:259    SAR `out_sign, 63
avx512_Xx_347: VPCMPUQ k1, ZMM7, ZMMWORD PTR [_avx512_label_0], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_0], 6
avx512_Xx_348: VMOVDQU64 ZMM0 {k1}{z}, [RSI+0] # to_avx512_integer:271    VMOVDQU64 `input_registers_0 {k1}{z}, [`in_data+0]
avx512_Xx_349: VPCMPUQ k1, ZMM7, ZMMWORD PTR [_avx512_label_1], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_1], 6
avx512_Xx_350: VMOVDQU64 ZMM1 {k1}{z}, [RSI+64] # to_avx512_integer:271    VMOVDQU64 `input_registers_1 {k1}{z}, [`in_data+64]
avx512_Xx_351: VPCMPUQ k1, ZMM7, ZMMWORD PTR [_avx512_label_12], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_12], 6
avx512_Xx_352: VMOVDQU64 ZMM2 {k1}{z}, [RSI+128] # to_avx512_integer:271    VMOVDQU64 `input_registers_2 {k1}{z}, [`in_data+128]
avx512_Xx_353: VPCMPUQ k1, ZMM7, ZMMWORD PTR [_avx512_label_16], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_16], 6
avx512_Xx_354: VMOVDQU64 ZMM3 {k1}{z}, [RSI+192] # to_avx512_integer:271    VMOVDQU64 `input_registers_3 {k1}{z}, [`in_data+192]
avx512_Xx_355: .text 1                   # to_avx512_integer:142    .text 1
avx512_Xx_356: .balign 64                # to_avx512_integer:144    .balign 64
avx512_Xx_357: _avx512_label_20:         # to_avx512_integer:145    _avx512_label_20:
avx512_Xx_358: .quad 0x20                # to_avx512_integer:147    .quad 0x20
avx512_Xx_359: .quad 0x21                # to_avx512_integer:147    .quad 0x21
avx512_Xx_360: .quad 0x22                # to_avx512_integer:147    .quad 0x22
avx512_Xx_361: .quad 0x23                # to_avx512_integer:147    .quad 0x23
avx512_Xx_362: .quad 0x24                # to_avx512_integer:147    .quad 0x24
avx512_Xx_363: .quad 0x25                # to_avx512_integer:147    .quad 0x25
avx512_Xx_364: .quad 0x26                # to_avx512_integer:147    .quad 0x26
avx512_Xx_365: .quad 0x27                # to_avx512_integer:147    .quad 0x27
avx512_Xx_366: .text                     # to_avx512_integer:149    .text
avx512_Xx_367: VPCMPUQ k1, ZMM7, ZMMWORD PTR [_avx512_label_20], 6 # to_avx512_integer:268    VPCMPUQ k1, `in_num_limbs_vector, ZMMWORD PTR [_avx512_label_20], 6
avx512_Xx_368: VMOVDQU64 ZMM4 {k1}{z}, [RSI+256] # to_avx512_integer:271    VMOVDQU64 `input_registers_4 {k1}{z}, [`in_data+256]
avx512_Xx_369: VPXORQ ZMM5, ZMM5, ZMM5   # to_avx512_integer:275    VPXORQ `temp_vector, `temp_vector, `temp_vector
avx512_Xx_370: VMOVDQU64 [RDX-64], ZMM5  # to_avx512_integer:276    VMOVDQU64 [`out_data-64], `temp_vector
avx512_Xx_371: VMOVDQU64 [RDX+384], ZMM5 # to_avx512_integer:277    VMOVDQU64 [`out_data+384], `temp_vector
avx512_Xx_372: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_2] # to_avx512_integer:279    VMOVDQU64 `mask_vector, ZMMWORD PTR [_avx512_label_2]
avx512_Xx_373: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_3] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_3]
avx512_Xx_374: VPERMI2Q ZMM8, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_375: VPSRLVQ ZMM5, ZMM8, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_376: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_5] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_5]
avx512_Xx_377: VPERMI2Q ZMM8, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_378: VPSLLVQ ZMM8, ZMM8, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_379: VPORQ ZMM5, ZMM5, ZMM8    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_380: VPANDQ ZMM5, ZMM5, ZMM6   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_381: VMOVDQU64 [RDX+0], ZMM5   # to_avx512_integer:303    VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_382: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_7] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_7]
avx512_Xx_383: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_384: VPSRLVQ ZMM5, ZMM8, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_385: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_9] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_9]
avx512_Xx_386: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_387: VPSLLVQ ZMM8, ZMM8, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_388: VPORQ ZMM5, ZMM5, ZMM8    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_389: VPANDQ ZMM5, ZMM5, ZMM6   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_390: VMOVDQU64 [RDX+64], ZMM5  # to_avx512_integer:303    VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_391: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_13] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_13]
avx512_Xx_392: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_393: VPSRLVQ ZMM5, ZMM8, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_394: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_14] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_14]
avx512_Xx_395: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_396: VPSLLVQ ZMM8, ZMM8, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_397: VPORQ ZMM5, ZMM5, ZMM8    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_398: VPANDQ ZMM5, ZMM5, ZMM6   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_399: VMOVDQU64 [RDX+128], ZMM5 # to_avx512_integer:303    VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_400: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_17] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_17]
avx512_Xx_401: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_402: VPSRLVQ ZMM5, ZMM8, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_403: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_18] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_18]
avx512_Xx_404: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_405: VPSLLVQ ZMM8, ZMM8, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_406: VPORQ ZMM5, ZMM5, ZMM8    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_407: VPANDQ ZMM5, ZMM5, ZMM6   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_408: VMOVDQU64 [RDX+192], ZMM5 # to_avx512_integer:303    VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_409: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_410: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_411: _avx512_label_21:         # apply_shifts:145         _avx512_label_21:
avx512_Xx_412: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_413: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_414: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_415: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_416: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_417: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_418: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_419: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_420: .text                     # apply_shifts:149         .text
avx512_Xx_421: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_21] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_21]
avx512_Xx_422: VPERMI2Q ZMM8, ZMM3, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_3
avx512_Xx_423: VPSRLVQ ZMM5, ZMM8, ZMMWORD PTR [_avx512_label_4] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_4]
avx512_Xx_424: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_425: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_426: _avx512_label_22:         # apply_shifts:145         _avx512_label_22:
avx512_Xx_427: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_428: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_429: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_430: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_431: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_432: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_433: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_434: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_435: .text                     # apply_shifts:149         .text
avx512_Xx_436: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_22] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_22]
avx512_Xx_437: VPERMI2Q ZMM8, ZMM3, ZMM4 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_4
avx512_Xx_438: VPSLLVQ ZMM8, ZMM8, ZMMWORD PTR [_avx512_label_6] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_6]
avx512_Xx_439: VPORQ ZMM5, ZMM5, ZMM8    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_440: VPANDQ ZMM5, ZMM5, ZMM6   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_441: VMOVDQU64 [RDX+256], ZMM5 # to_avx512_integer:303    VMOVDQU64 [`out_data+256], `temp_vector
avx512_Xx_442: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_443: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_444: _avx512_label_23:         # apply_shifts:145         _avx512_label_23:
avx512_Xx_445: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_446: .quad 0x1                 # apply_shifts:147         .quad 0x1
avx512_Xx_447: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_448: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_449: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_450: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_451: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_452: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_453: .text                     # apply_shifts:149         .text
avx512_Xx_454: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_23] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_23]
avx512_Xx_455: VPERMI2Q ZMM8, ZMM4, ZMM4 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_4, `inputs_4
avx512_Xx_456: VPSRLVQ ZMM5, ZMM8, ZMMWORD PTR [_avx512_label_8] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_8]
avx512_Xx_457: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_458: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_459: _avx512_label_24:         # apply_shifts:145         _avx512_label_24:
avx512_Xx_460: .quad 0x1                 # apply_shifts:147         .quad 0x1
avx512_Xx_461: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_462: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_463: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_464: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_465: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_466: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_467: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_468: .text                     # apply_shifts:149         .text
avx512_Xx_469: VMOVDQU64 ZMM8, ZMMWORD PTR [_avx512_label_24] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_24]
avx512_Xx_470: VPERMI2Q ZMM8, ZMM4, ZMM4 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_4, `inputs_4
avx512_Xx_471: VPSLLVQ ZMM8, ZMM8, ZMMWORD PTR [_avx512_label_10] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_10]
avx512_Xx_472: VPORQ ZMM5, ZMM5, ZMM8    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_473: VPANDQ ZMM5, ZMM5, ZMM6   # to_avx512_integer:302    VPANDQ `temp_vector, `temp_vector, `mask_vector
avx512_Xx_474: VMOVDQU64 [RDX+320], ZMM5 # to_avx512_integer:303    VMOVDQU64 [`out_data+320], `temp_vector
avx512_Xx_475: _avx512_label_25:         # ~asm_function:121        _avx512_label_25:
avx512_Xx_476: RET                       # ~asm_function:130        RET
avx512_Xx_477: .global asm_avx512_func_to_gmp_integer_12_9 # asm_function:74          .global asm_avx512_func_to_gmp_integer_12_9
avx512_Xx_478: asm_avx512_func_to_gmp_integer_12_9: # asm_function:75          asm_avx512_func_to_gmp_integer_12_9:
avx512_Xx_479: VMOVDQU64 ZMM0, [RSI+0]   # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_480: VMOVDQU64 ZMM1, [RSI+64]  # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_481: VPXORQ ZMM3, ZMM3, ZMM3   # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_482: VPXORQ ZMM4, ZMM4, ZMM4   # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_483: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_484: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_485: _avx512_label_26:         # apply_shifts:145         _avx512_label_26:
avx512_Xx_486: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_487: .quad 0x1                 # apply_shifts:147         .quad 0x1
avx512_Xx_488: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_489: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_490: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_491: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_492: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_493: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_494: .text                     # apply_shifts:149         .text
avx512_Xx_495: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_496: VPERMI2Q ZMM5, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_497: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_498: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_499: _avx512_label_27:         # apply_shifts:145         _avx512_label_27:
avx512_Xx_500: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_501: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_502: .quad 0x18                # apply_shifts:147         .quad 0x18
avx512_Xx_503: .quad 0x24                # apply_shifts:147         .quad 0x24
avx512_Xx_504: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_505: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_506: .quad 0x14                # apply_shifts:147         .quad 0x14
avx512_Xx_507: .quad 0x20                # apply_shifts:147         .quad 0x20
avx512_Xx_508: .text                     # apply_shifts:149         .text
avx512_Xx_509: VPSRLVQ ZMM2, ZMM5, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_510: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_511: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_512: _avx512_label_28:         # apply_shifts:145         _avx512_label_28:
avx512_Xx_513: .quad 0x1                 # apply_shifts:147         .quad 0x1
avx512_Xx_514: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_515: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_516: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_517: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_518: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_519: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_520: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_521: .text                     # apply_shifts:149         .text
avx512_Xx_522: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_523: VPERMI2Q ZMM5, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_524: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_525: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_526: _avx512_label_29:         # apply_shifts:145         _avx512_label_29:
avx512_Xx_527: .quad 0x34                # apply_shifts:147         .quad 0x34
avx512_Xx_528: .quad 0x28                # apply_shifts:147         .quad 0x28
avx512_Xx_529: .quad 0x1c                # apply_shifts:147         .quad 0x1c
avx512_Xx_530: .quad 0x10                # apply_shifts:147         .quad 0x10
avx512_Xx_531: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_532: .quad 0x2c                # apply_shifts:147         .quad 0x2c
avx512_Xx_533: .quad 0x20                # apply_shifts:147         .quad 0x20
avx512_Xx_534: .quad 0x14                # apply_shifts:147         .quad 0x14
avx512_Xx_535: .text                     # apply_shifts:149         .text
avx512_Xx_536: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_537: VPORQ ZMM2, ZMM2, ZMM5    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_538: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_539: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_540: _avx512_label_30:         # apply_shifts:145         _avx512_label_30:
avx512_Xx_541: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_542: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_543: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_544: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_545: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_546: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_547: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_548: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_549: .text                     # apply_shifts:149         .text
avx512_Xx_550: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_551: VPERMI2Q ZMM5, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_552: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_553: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_554: _avx512_label_31:         # apply_shifts:145         _avx512_label_31:
avx512_Xx_555: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_556: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_557: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_558: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_559: .quad 0x38                # apply_shifts:147         .quad 0x38
avx512_Xx_560: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_561: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_562: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_563: .text                     # apply_shifts:149         .text
avx512_Xx_564: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_565: VPORQ ZMM2, ZMM2, ZMM5    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_566: VMOVDQU64 [RDX+0], ZMM2   # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_567: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_568: .text 1                   # to_gmp_integer:142       .text 1
avx512_Xx_569: .balign 64                # to_gmp_integer:144       .balign 64
avx512_Xx_570: _avx512_label_32:         # to_gmp_integer:145       _avx512_label_32:
avx512_Xx_571: .quad 0x1                 # to_gmp_integer:147       .quad 0x1
avx512_Xx_572: .quad 0x2                 # to_gmp_integer:147       .quad 0x2
avx512_Xx_573: .quad 0x3                 # to_gmp_integer:147       .quad 0x3
avx512_Xx_574: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_575: .quad 0x5                 # to_gmp_integer:147       .quad 0x5
avx512_Xx_576: .quad 0x6                 # to_gmp_integer:147       .quad 0x6
avx512_Xx_577: .quad 0x7                 # to_gmp_integer:147       .quad 0x7
avx512_Xx_578: .quad 0x8                 # to_gmp_integer:147       .quad 0x8
avx512_Xx_579: .text                     # to_gmp_integer:149       .text
avx512_Xx_580: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_581: VPMAXUQ ZMM4, ZMM4, ZMM2  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_582: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_583: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_584: _avx512_label_33:         # apply_shifts:145         _avx512_label_33:
avx512_Xx_585: .quad 0x1                 # apply_shifts:147         .quad 0x1
avx512_Xx_586: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_587: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_588: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_589: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_590: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_591: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_592: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_593: .text                     # apply_shifts:149         .text
avx512_Xx_594: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_33] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_33]
avx512_Xx_595: VPERMI2Q ZMM5, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_596: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_597: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_598: _avx512_label_34:         # apply_shifts:145         _avx512_label_34:
avx512_Xx_599: .quad 0x2c                # apply_shifts:147         .quad 0x2c
avx512_Xx_600: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_601: .quad 0x10                # apply_shifts:147         .quad 0x10
avx512_Xx_602: .quad 0x1c                # apply_shifts:147         .quad 0x1c
avx512_Xx_603: .quad 0x28                # apply_shifts:147         .quad 0x28
avx512_Xx_604: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_605: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_606: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_607: .text                     # apply_shifts:149         .text
avx512_Xx_608: VPSRLVQ ZMM2, ZMM5, ZMMWORD PTR [_avx512_label_34] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_34]
avx512_Xx_609: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_610: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_611: _avx512_label_35:         # apply_shifts:145         _avx512_label_35:
avx512_Xx_612: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_613: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_614: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_615: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_616: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_617: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_618: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_619: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_620: .text                     # apply_shifts:149         .text
avx512_Xx_621: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_35] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_35]
avx512_Xx_622: VPERMI2Q ZMM5, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_623: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_624: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_625: _avx512_label_36:         # apply_shifts:145         _avx512_label_36:
avx512_Xx_626: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_627: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_628: .quad 0x24                # apply_shifts:147         .quad 0x24
avx512_Xx_629: .quad 0x18                # apply_shifts:147         .quad 0x18
avx512_Xx_630: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_631: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_632: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_633: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_634: .text                     # apply_shifts:149         .text
avx512_Xx_635: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_36] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_36]
avx512_Xx_636: VPORQ ZMM2, ZMM2, ZMM5    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_637: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_638: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_639: _avx512_label_37:         # apply_shifts:145         _avx512_label_37:
avx512_Xx_640: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_641: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_642: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_643: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_644: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_645: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_646: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_647: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_648: .text                     # apply_shifts:149         .text
avx512_Xx_649: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_650: VPERMI2Q ZMM5, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_651: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_652: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_653: _avx512_label_38:         # apply_shifts:145         _avx512_label_38:
avx512_Xx_654: .quad 0x3c                # apply_shifts:147         .quad 0x3c
avx512_Xx_655: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_656: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_657: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_658: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_659: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_660: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_661: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_662: .text                     # apply_shifts:149         .text
avx512_Xx_663: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_664: VPORQ ZMM2, ZMM2, ZMM5    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_665: VMOVDQU64 [RDX+64], ZMM2  # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_666: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_667: .text 1                   # to_gmp_integer:142       .text 1
avx512_Xx_668: .balign 64                # to_gmp_integer:144       .balign 64
avx512_Xx_669: _avx512_label_39:         # to_gmp_integer:145       _avx512_label_39:
avx512_Xx_670: .quad 0x9                 # to_gmp_integer:147       .quad 0x9
avx512_Xx_671: .quad 0xa                 # to_gmp_integer:147       .quad 0xa
avx512_Xx_672: .quad 0xb                 # to_gmp_integer:147       .quad 0xb
avx512_Xx_673: .quad 0xc                 # to_gmp_integer:147       .quad 0xc
avx512_Xx_674: .quad 0xd                 # to_gmp_integer:147       .quad 0xd
avx512_Xx_675: .quad 0xe                 # to_gmp_integer:147       .quad 0xe
avx512_Xx_676: .quad 0xf                 # to_gmp_integer:147       .quad 0xf
avx512_Xx_677: .quad 0x10                # to_gmp_integer:147       .quad 0x10
avx512_Xx_678: .text                     # to_gmp_integer:149       .text
avx512_Xx_679: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_680: VPMAXUQ ZMM4, ZMM4, ZMM2  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_681: .text 1                   # to_gmp_integer:142       .text 1
avx512_Xx_682: .balign 64                # to_gmp_integer:144       .balign 64
avx512_Xx_683: _avx512_label_40:         # to_gmp_integer:145       _avx512_label_40:
avx512_Xx_684: .quad 0x1                 # to_gmp_integer:147       .quad 0x1
avx512_Xx_685: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_686: .quad 0x3                 # to_gmp_integer:147       .quad 0x3
avx512_Xx_687: .quad 0x2                 # to_gmp_integer:147       .quad 0x2
avx512_Xx_688: .quad 0x5                 # to_gmp_integer:147       .quad 0x5
avx512_Xx_689: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_690: .quad 0x7                 # to_gmp_integer:147       .quad 0x7
avx512_Xx_691: .quad 0x6                 # to_gmp_integer:147       .quad 0x6
avx512_Xx_692: .text                     # to_gmp_integer:149       .text
avx512_Xx_693: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_694: VPERMQ ZMM2, ZMM2, ZMM4   # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_695: VPMAXUQ ZMM4, ZMM4, ZMM2  # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_696: .text 1                   # to_gmp_integer:142       .text 1
avx512_Xx_697: .balign 64                # to_gmp_integer:144       .balign 64
avx512_Xx_698: _avx512_label_41:         # to_gmp_integer:145       _avx512_label_41:
avx512_Xx_699: .quad 0x2                 # to_gmp_integer:147       .quad 0x2
avx512_Xx_700: .quad 0x2                 # to_gmp_integer:147       .quad 0x2
avx512_Xx_701: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_702: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_703: .quad 0x6                 # to_gmp_integer:147       .quad 0x6
avx512_Xx_704: .quad 0x6                 # to_gmp_integer:147       .quad 0x6
avx512_Xx_705: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_706: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_707: .text                     # to_gmp_integer:149       .text
avx512_Xx_708: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_709: VPERMQ ZMM2, ZMM2, ZMM4   # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_710: VPMAXUQ ZMM4, ZMM4, ZMM2  # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_711: .text 1                   # to_gmp_integer:142       .text 1
avx512_Xx_712: .balign 64                # to_gmp_integer:144       .balign 64
avx512_Xx_713: _avx512_label_42:         # to_gmp_integer:145       _avx512_label_42:
avx512_Xx_714: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_715: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_716: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_717: .quad 0x4                 # to_gmp_integer:147       .quad 0x4
avx512_Xx_718: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_719: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_720: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_721: .quad 0x0                 # to_gmp_integer:147       .quad 0x0
avx512_Xx_722: .text                     # to_gmp_integer:149       .text
avx512_Xx_723: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_724: VPERMQ ZMM2, ZMM2, ZMM4   # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_725: VPMAXUQ ZMM4, ZMM4, ZMM2  # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_726: VMOVQ RAX, XMM4           # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_727: MOV R8, RAX               # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_728: NEG R8                    # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_729: TEST RDI, RDI             # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_730: CMOVNZ RAX, R8            # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_731: _avx512_label_43:         # ~asm_function:121        _avx512_label_43:
avx512_Xx_732: RET                       # ~asm_function:130        RET
avx512_Xx_733: .global asm_avx512_func_to_gmp_integer_21_17 # asm_function:74          .global asm_avx512_func_to_gmp_integer_21_17
avx512_Xx_734: asm_avx512_func_to_gmp_integer_21_17: # asm_function:75          asm_avx512_func_to_gmp_integer_21_17:
avx512_Xx_735: VMOVDQU64 ZMM0, [RSI+0]   # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_736: VMOVDQU64 ZMM1, [RSI+64]  # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_737: VMOVDQU64 ZMM2, [RSI+128] # to_gmp_integer:336       VMOVDQU64 `input_registers_2, [`in_data+128]
avx512_Xx_738: VPXORQ ZMM4, ZMM4, ZMM4   # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_739: VPXORQ ZMM5, ZMM5, ZMM5   # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_740: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_741: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_742: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_743: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_744: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_745: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_746: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_747: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_748: VPERMI2Q ZMM6, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_749: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_750: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_751: VMOVDQU64 [RDX+0], ZMM3   # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_752: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_753: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_754: VPMAXUQ ZMM5, ZMM5, ZMM3  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_755: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_756: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_757: _avx512_label_44:         # apply_shifts:145         _avx512_label_44:
avx512_Xx_758: .quad 0x1                 # apply_shifts:147         .quad 0x1
avx512_Xx_759: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_760: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_761: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_762: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_763: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_764: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_765: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_766: .text                     # apply_shifts:149         .text
avx512_Xx_767: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_44] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_44]
avx512_Xx_768: VPERMI2Q ZMM6, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_769: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_770: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_771: _avx512_label_45:         # apply_shifts:145         _avx512_label_45:
avx512_Xx_772: .quad 0x2c                # apply_shifts:147         .quad 0x2c
avx512_Xx_773: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_774: .quad 0x10                # apply_shifts:147         .quad 0x10
avx512_Xx_775: .quad 0x1c                # apply_shifts:147         .quad 0x1c
avx512_Xx_776: .quad 0x28                # apply_shifts:147         .quad 0x28
avx512_Xx_777: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_778: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_779: .quad 0x18                # apply_shifts:147         .quad 0x18
avx512_Xx_780: .text                     # apply_shifts:149         .text
avx512_Xx_781: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_45] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_45]
avx512_Xx_782: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_783: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_784: _avx512_label_46:         # apply_shifts:145         _avx512_label_46:
avx512_Xx_785: .quad 0x2                 # apply_shifts:147         .quad 0x2
avx512_Xx_786: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_787: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_788: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_789: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_790: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_791: .quad 0xa                 # apply_shifts:147         .quad 0xa
avx512_Xx_792: .quad 0xb                 # apply_shifts:147         .quad 0xb
avx512_Xx_793: .text                     # apply_shifts:149         .text
avx512_Xx_794: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_46] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_46]
avx512_Xx_795: VPERMI2Q ZMM6, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_796: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_797: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_798: _avx512_label_47:         # apply_shifts:145         _avx512_label_47:
avx512_Xx_799: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_800: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_801: .quad 0x24                # apply_shifts:147         .quad 0x24
avx512_Xx_802: .quad 0x18                # apply_shifts:147         .quad 0x18
avx512_Xx_803: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_804: .quad 0x34                # apply_shifts:147         .quad 0x34
avx512_Xx_805: .quad 0x28                # apply_shifts:147         .quad 0x28
avx512_Xx_806: .quad 0x1c                # apply_shifts:147         .quad 0x1c
avx512_Xx_807: .text                     # apply_shifts:149         .text
avx512_Xx_808: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_47] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_47]
avx512_Xx_809: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_810: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_811: VPERMI2Q ZMM6, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_812: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_813: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_814: VMOVDQU64 [RDX+64], ZMM3  # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_815: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_816: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_817: VPMAXUQ ZMM5, ZMM5, ZMM3  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_818: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_819: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_820: _avx512_label_48:         # apply_shifts:145         _avx512_label_48:
avx512_Xx_821: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_822: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_823: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_824: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_825: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_826: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_827: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_828: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_829: .text                     # apply_shifts:149         .text
avx512_Xx_830: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_48] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_48]
avx512_Xx_831: VPERMI2Q ZMM6, ZMM2, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_2
avx512_Xx_832: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_833: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_834: _avx512_label_49:         # apply_shifts:145         _avx512_label_49:
avx512_Xx_835: .quad 0x24                # apply_shifts:147         .quad 0x24
avx512_Xx_836: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_837: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_838: .quad 0x14                # apply_shifts:147         .quad 0x14
avx512_Xx_839: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_840: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_841: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_842: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_843: .text                     # apply_shifts:149         .text
avx512_Xx_844: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_49] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_49]
avx512_Xx_845: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_846: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_847: _avx512_label_50:         # apply_shifts:145         _avx512_label_50:
avx512_Xx_848: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_849: .quad 0x5                 # apply_shifts:147         .quad 0x5
avx512_Xx_850: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_851: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_852: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_853: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_854: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_855: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_856: .text                     # apply_shifts:149         .text
avx512_Xx_857: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_50] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_50]
avx512_Xx_858: VPERMI2Q ZMM6, ZMM2, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_2
avx512_Xx_859: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_860: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_861: _avx512_label_51:         # apply_shifts:145         _avx512_label_51:
avx512_Xx_862: .quad 0x10                # apply_shifts:147         .quad 0x10
avx512_Xx_863: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_864: .quad 0x2c                # apply_shifts:147         .quad 0x2c
avx512_Xx_865: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_866: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_867: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_868: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_869: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_870: .text                     # apply_shifts:149         .text
avx512_Xx_871: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_51] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_51]
avx512_Xx_872: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_873: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_874: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_875: _avx512_label_52:         # apply_shifts:145         _avx512_label_52:
avx512_Xx_876: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_877: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_878: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_879: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_880: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_881: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_882: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_883: .quad 0x0                 # apply_shifts:147         .quad 0x0
avx512_Xx_884: .text                     # apply_shifts:149         .text
avx512_Xx_885: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_52] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_52]
avx512_Xx_886: VPERMI2Q ZMM6, ZMM2, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_2
avx512_Xx_887: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_888: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_889: _avx512_label_53:         # apply_shifts:145         _avx512_label_53:
avx512_Xx_890: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_891: .quad 0x38                # apply_shifts:147         .quad 0x38
avx512_Xx_892: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_893: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_894: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_895: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_896: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_897: .quad 0x40                # apply_shifts:147         .quad 0x40
avx512_Xx_898: .text                     # apply_shifts:149         .text
avx512_Xx_899: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_53] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_53]
avx512_Xx_900: VPORQ ZMM3, ZMM3, ZMM6    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_901: VMOVDQU64 [RDX+128], ZMM3 # to_gmp_integer:368       VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_902: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_903: .text 1                   # to_gmp_integer:142       .text 1
avx512_Xx_904: .balign 64                # to_gmp_integer:144       .balign 64
avx512_Xx_905: _avx512_label_54:         # to_gmp_integer:145       _avx512_label_54:
avx512_Xx_906: .quad 0x11                # to_gmp_integer:147       .quad 0x11
avx512_Xx_907: .quad 0x12                # to_gmp_integer:147       .quad 0x12
avx512_Xx_908: .quad 0x13                # to_gmp_integer:147       .quad 0x13
avx512_Xx_909: .quad 0x14                # to_gmp_integer:147       .quad 0x14
avx512_Xx_910: .quad 0x15                # to_gmp_integer:147       .quad 0x15
avx512_Xx_911: .quad 0x16                # to_gmp_integer:147       .quad 0x16
avx512_Xx_912: .quad 0x17                # to_gmp_integer:147       .quad 0x17
avx512_Xx_913: .quad 0x18                # to_gmp_integer:147       .quad 0x18
avx512_Xx_914: .text                     # to_gmp_integer:149       .text
avx512_Xx_915: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_54] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_54]
avx512_Xx_916: VPMAXUQ ZMM5, ZMM5, ZMM3  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_917: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_918: VPERMQ ZMM3, ZMM3, ZMM5   # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_919: VPMAXUQ ZMM5, ZMM5, ZMM3  # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_920: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_921: VPERMQ ZMM3, ZMM3, ZMM5   # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_922: VPMAXUQ ZMM5, ZMM5, ZMM3  # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_923: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_924: VPERMQ ZMM3, ZMM3, ZMM5   # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_925: VPMAXUQ ZMM5, ZMM5, ZMM3  # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_926: VMOVQ RAX, XMM5           # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_927: MOV R8, RAX               # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_928: NEG R8                    # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_929: TEST RDI, RDI             # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_930: CMOVNZ RAX, R8            # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_931: _avx512_label_55:         # ~asm_function:121        _avx512_label_55:
avx512_Xx_932: RET                       # ~asm_function:130        RET
avx512_Xx_933: .global asm_avx512_func_to_gmp_integer_31_25 # asm_function:74          .global asm_avx512_func_to_gmp_integer_31_25
avx512_Xx_934: asm_avx512_func_to_gmp_integer_31_25: # asm_function:75          asm_avx512_func_to_gmp_integer_31_25:
avx512_Xx_935: VMOVDQU64 ZMM0, [RSI+0]   # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_936: VMOVDQU64 ZMM1, [RSI+64]  # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_937: VMOVDQU64 ZMM2, [RSI+128] # to_gmp_integer:336       VMOVDQU64 `input_registers_2, [`in_data+128]
avx512_Xx_938: VMOVDQU64 ZMM3, [RSI+192] # to_gmp_integer:336       VMOVDQU64 `input_registers_3, [`in_data+192]
avx512_Xx_939: VPXORQ ZMM5, ZMM5, ZMM5   # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_940: VPXORQ ZMM6, ZMM6, ZMM6   # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_941: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_942: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_943: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_944: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_945: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_946: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_947: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_948: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_949: VPERMI2Q ZMM7, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_950: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_951: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_952: VMOVDQU64 [RDX+0], ZMM4   # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_953: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_954: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_955: VPMAXUQ ZMM6, ZMM6, ZMM4  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_956: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_44] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_44]
avx512_Xx_957: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_958: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_45] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_45]
avx512_Xx_959: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_46] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_46]
avx512_Xx_960: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_961: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_47] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_47]
avx512_Xx_962: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_963: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_964: VPERMI2Q ZMM7, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_965: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_966: VPORQ ZMM4, ZMM4, ZMM7    # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_967: VMOVDQU64 [RDX+64], ZMM4  # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_968: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_969: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_970: VPMAXUQ ZMM6, ZMM6, ZMM4  # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_971: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_972: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_973: _avx512_label_56:         # apply_shifts:145         _avx512_label_56:
avx512_Xx_974: .quad 0x3                 # apply_shifts:147         .quad 0x3
avx512_Xx_975: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_976: .quad 0x6                 # apply_shifts:147         .quad 0x6
avx512_Xx_977: .quad 0x7                 # apply_shifts:147         .quad 0x7
avx512_Xx_978: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_979: .quad 0x9                 # apply_shifts:147         .quad 0x9
avx512_Xx_980: .quad 0xb                 # apply_shifts:147         .quad 0xb
avx512_Xx_981: .quad 0xc                 # apply_shifts:147         .quad 0xc
avx512_Xx_982: .text                     # apply_shifts:149         .text
avx512_Xx_983: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_56] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_56]
avx512_Xx_984: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_985: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_986: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_987: _avx512_label_57:         # apply_shifts:145         _avx512_label_57:
avx512_Xx_988: .quad 0x24                # apply_shifts:147         .quad 0x24
avx512_Xx_989: .quad 0x30                # apply_shifts:147         .quad 0x30
avx512_Xx_990: .quad 0x8                 # apply_shifts:147         .quad 0x8
avx512_Xx_991: .quad 0x14                # apply_shifts:147         .quad 0x14
avx512_Xx_992: .quad 0x20                # apply_shifts:147         .quad 0x20
avx512_Xx_993: .quad 0x2c                # apply_shifts:147         .quad 0x2c
avx512_Xx_994: .quad 0x4                 # apply_shifts:147         .quad 0x4
avx512_Xx_995: .quad 0x10                # apply_shifts:147         .quad 0x10
avx512_Xx_996: .text                     # apply_shifts:149         .text
avx512_Xx_997: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_57] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_57]
avx512_Xx_998: .text 1                   # apply_shifts:142         .text 1
avx512_Xx_999: .balign 64                # apply_shifts:144         .balign 64
avx512_Xx_1000: _avx512_label_58:        # apply_shifts:145         _avx512_label_58:
avx512_Xx_1001: .quad 0x4                # apply_shifts:147         .quad 0x4
avx512_Xx_1002: .quad 0x5                # apply_shifts:147         .quad 0x5
avx512_Xx_1003: .quad 0x7                # apply_shifts:147         .quad 0x7
avx512_Xx_1004: .quad 0x8                # apply_shifts:147         .quad 0x8
avx512_Xx_1005: .quad 0x9                # apply_shifts:147         .quad 0x9
avx512_Xx_1006: .quad 0xa                # apply_shifts:147         .quad 0xa
avx512_Xx_1007: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1008: .quad 0xd                # apply_shifts:147         .quad 0xd
avx512_Xx_1009: .text                    # apply_shifts:149         .text
avx512_Xx_1010: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_58] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_58]
avx512_Xx_1011: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1012: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1013: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1014: _avx512_label_59:        # apply_shifts:145         _avx512_label_59:
avx512_Xx_1015: .quad 0x10               # apply_shifts:147         .quad 0x10
avx512_Xx_1016: .quad 0x4                # apply_shifts:147         .quad 0x4
avx512_Xx_1017: .quad 0x2c               # apply_shifts:147         .quad 0x2c
avx512_Xx_1018: .quad 0x20               # apply_shifts:147         .quad 0x20
avx512_Xx_1019: .quad 0x14               # apply_shifts:147         .quad 0x14
avx512_Xx_1020: .quad 0x8                # apply_shifts:147         .quad 0x8
avx512_Xx_1021: .quad 0x30               # apply_shifts:147         .quad 0x30
avx512_Xx_1022: .quad 0x24               # apply_shifts:147         .quad 0x24
avx512_Xx_1023: .text                    # apply_shifts:149         .text
avx512_Xx_1024: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_59] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_59]
avx512_Xx_1025: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1026: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1027: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1028: _avx512_label_60:        # apply_shifts:145         _avx512_label_60:
avx512_Xx_1029: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1030: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1031: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1032: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1033: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1034: .quad 0xb                # apply_shifts:147         .quad 0xb
avx512_Xx_1035: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1036: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1037: .text                    # apply_shifts:149         .text
avx512_Xx_1038: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_60] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_60]
avx512_Xx_1039: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1040: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1041: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1042: _avx512_label_61:        # apply_shifts:145         _avx512_label_61:
avx512_Xx_1043: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1044: .quad 0x38               # apply_shifts:147         .quad 0x38
avx512_Xx_1045: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1046: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1047: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1048: .quad 0x3c               # apply_shifts:147         .quad 0x3c
avx512_Xx_1049: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1050: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1051: .text                    # apply_shifts:149         .text
avx512_Xx_1052: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_61] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_61]
avx512_Xx_1053: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1054: VMOVDQU64 [RDX+128], ZMM4 # to_gmp_integer:368       VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_1055: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1056: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_54] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_54]
avx512_Xx_1057: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1058: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1059: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1060: _avx512_label_62:        # apply_shifts:145         _avx512_label_62:
avx512_Xx_1061: .quad 0x5                # apply_shifts:147         .quad 0x5
avx512_Xx_1062: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1063: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1064: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1065: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1066: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1067: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1068: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1069: .text                    # apply_shifts:149         .text
avx512_Xx_1070: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_62] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_62]
avx512_Xx_1071: VPERMI2Q ZMM7, ZMM3, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_3
avx512_Xx_1072: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1073: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1074: _avx512_label_63:        # apply_shifts:145         _avx512_label_63:
avx512_Xx_1075: .quad 0x1c               # apply_shifts:147         .quad 0x1c
avx512_Xx_1076: .quad 0x28               # apply_shifts:147         .quad 0x28
avx512_Xx_1077: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1078: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1079: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1080: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1081: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1082: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1083: .text                    # apply_shifts:149         .text
avx512_Xx_1084: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_63] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_63]
avx512_Xx_1085: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1086: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1087: _avx512_label_64:        # apply_shifts:145         _avx512_label_64:
avx512_Xx_1088: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1089: .quad 0x7                # apply_shifts:147         .quad 0x7
avx512_Xx_1090: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1091: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1092: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1093: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1094: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1095: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1096: .text                    # apply_shifts:149         .text
avx512_Xx_1097: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_64] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_64]
avx512_Xx_1098: VPERMI2Q ZMM7, ZMM3, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_3
avx512_Xx_1099: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1100: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1101: _avx512_label_65:        # apply_shifts:145         _avx512_label_65:
avx512_Xx_1102: .quad 0x18               # apply_shifts:147         .quad 0x18
avx512_Xx_1103: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1104: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1105: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1106: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1107: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1108: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1109: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1110: .text                    # apply_shifts:149         .text
avx512_Xx_1111: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_65] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_65]
avx512_Xx_1112: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1113: VMOVDQU64 [RDX+192], ZMM4 # to_gmp_integer:368       VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_1114: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1115: .text 1                  # to_gmp_integer:142       .text 1
avx512_Xx_1116: .balign 64               # to_gmp_integer:144       .balign 64
avx512_Xx_1117: _avx512_label_66:        # to_gmp_integer:145       _avx512_label_66:
avx512_Xx_1118: .quad 0x19               # to_gmp_integer:147       .quad 0x19
avx512_Xx_1119: .quad 0x1a               # to_gmp_integer:147       .quad 0x1a
avx512_Xx_1120: .quad 0x1b               # to_gmp_integer:147       .quad 0x1b
avx512_Xx_1121: .quad 0x1c               # to_gmp_integer:147       .quad 0x1c
avx512_Xx_1122: .quad 0x1d               # to_gmp_integer:147       .quad 0x1d
avx512_Xx_1123: .quad 0x1e               # to_gmp_integer:147       .quad 0x1e
avx512_Xx_1124: .quad 0x1f               # to_gmp_integer:147       .quad 0x1f
avx512_Xx_1125: .quad 0x20               # to_gmp_integer:147       .quad 0x20
avx512_Xx_1126: .text                    # to_gmp_integer:149       .text
avx512_Xx_1127: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_66] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_66]
avx512_Xx_1128: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1129: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1130: VPERMQ ZMM4, ZMM4, ZMM6  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1131: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1132: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1133: VPERMQ ZMM4, ZMM4, ZMM6  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1134: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1135: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1136: VPERMQ ZMM4, ZMM4, ZMM6  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1137: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1138: VMOVQ RAX, XMM6          # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_1139: MOV R8, RAX              # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_1140: NEG R8                   # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_1141: TEST RDI, RDI            # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_1142: CMOVNZ RAX, R8           # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_1143: _avx512_label_67:        # ~asm_function:121        _avx512_label_67:
avx512_Xx_1144: RET                      # ~asm_function:130        RET
avx512_Xx_1145: .global asm_avx512_func_to_gmp_integer_41_33 # asm_function:74          .global asm_avx512_func_to_gmp_integer_41_33
avx512_Xx_1146: asm_avx512_func_to_gmp_integer_41_33: # asm_function:75          asm_avx512_func_to_gmp_integer_41_33:
avx512_Xx_1147: VMOVDQU64 ZMM0, [RSI+0]  # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_1148: VMOVDQU64 ZMM1, [RSI+64] # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_1149: VMOVDQU64 ZMM2, [RSI+128] # to_gmp_integer:336       VMOVDQU64 `input_registers_2, [`in_data+128]
avx512_Xx_1150: VMOVDQU64 ZMM3, [RSI+192] # to_gmp_integer:336       VMOVDQU64 `input_registers_3, [`in_data+192]
avx512_Xx_1151: VMOVDQU64 ZMM4, [RSI+256] # to_gmp_integer:336       VMOVDQU64 `input_registers_4, [`in_data+256]
avx512_Xx_1152: VMOVDQU64 ZMM5, [RSI+320] # to_gmp_integer:336       VMOVDQU64 `input_registers_5, [`in_data+320]
avx512_Xx_1153: VPXORQ ZMM7, ZMM7, ZMM7  # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1154: VPXORQ ZMM8, ZMM8, ZMM8  # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_1155: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_1156: VPERMI2Q ZMM9, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1157: VPSRLVQ ZMM6, ZMM9, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_1158: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_1159: VPERMI2Q ZMM9, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1160: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_1161: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1162: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_1163: VPERMI2Q ZMM9, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_1164: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_1165: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1166: VMOVDQU64 [RDX+0], ZMM6  # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_1167: VPCMPUQ k1, ZMM6, ZMM7, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1168: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_1169: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1170: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_44] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_44]
avx512_Xx_1171: VPERMI2Q ZMM9, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_1172: VPSRLVQ ZMM6, ZMM9, ZMMWORD PTR [_avx512_label_45] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_45]
avx512_Xx_1173: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_46] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_46]
avx512_Xx_1174: VPERMI2Q ZMM9, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_1175: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_47] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_47]
avx512_Xx_1176: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1177: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_1178: VPERMI2Q ZMM9, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_1179: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_1180: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1181: VMOVDQU64 [RDX+64], ZMM6 # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_1182: VPCMPUQ k1, ZMM6, ZMM7, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1183: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_1184: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1185: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_56] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_56]
avx512_Xx_1186: VPERMI2Q ZMM9, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1187: VPSRLVQ ZMM6, ZMM9, ZMMWORD PTR [_avx512_label_57] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_57]
avx512_Xx_1188: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_58] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_58]
avx512_Xx_1189: VPERMI2Q ZMM9, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1190: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_59] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_59]
avx512_Xx_1191: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1192: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_60] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_60]
avx512_Xx_1193: VPERMI2Q ZMM9, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1194: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_61] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_61]
avx512_Xx_1195: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1196: VMOVDQU64 [RDX+128], ZMM6 # to_gmp_integer:368       VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_1197: VPCMPUQ k1, ZMM6, ZMM7, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1198: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_54] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_54]
avx512_Xx_1199: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1200: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1201: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1202: _avx512_label_68:        # apply_shifts:145         _avx512_label_68:
avx512_Xx_1203: .quad 0x5                # apply_shifts:147         .quad 0x5
avx512_Xx_1204: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1205: .quad 0x8                # apply_shifts:147         .quad 0x8
avx512_Xx_1206: .quad 0x9                # apply_shifts:147         .quad 0x9
avx512_Xx_1207: .quad 0xa                # apply_shifts:147         .quad 0xa
avx512_Xx_1208: .quad 0xb                # apply_shifts:147         .quad 0xb
avx512_Xx_1209: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1210: .quad 0xe                # apply_shifts:147         .quad 0xe
avx512_Xx_1211: .text                    # apply_shifts:149         .text
avx512_Xx_1212: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_68] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_68]
avx512_Xx_1213: VPERMI2Q ZMM9, ZMM3, ZMM4 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_4
avx512_Xx_1214: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1215: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1216: _avx512_label_69:        # apply_shifts:145         _avx512_label_69:
avx512_Xx_1217: .quad 0x1c               # apply_shifts:147         .quad 0x1c
avx512_Xx_1218: .quad 0x28               # apply_shifts:147         .quad 0x28
avx512_Xx_1219: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1220: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1221: .quad 0x18               # apply_shifts:147         .quad 0x18
avx512_Xx_1222: .quad 0x24               # apply_shifts:147         .quad 0x24
avx512_Xx_1223: .quad 0x30               # apply_shifts:147         .quad 0x30
avx512_Xx_1224: .quad 0x8                # apply_shifts:147         .quad 0x8
avx512_Xx_1225: .text                    # apply_shifts:149         .text
avx512_Xx_1226: VPSRLVQ ZMM6, ZMM9, ZMMWORD PTR [_avx512_label_69] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_69]
avx512_Xx_1227: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1228: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1229: _avx512_label_70:        # apply_shifts:145         _avx512_label_70:
avx512_Xx_1230: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1231: .quad 0x7                # apply_shifts:147         .quad 0x7
avx512_Xx_1232: .quad 0x9                # apply_shifts:147         .quad 0x9
avx512_Xx_1233: .quad 0xa                # apply_shifts:147         .quad 0xa
avx512_Xx_1234: .quad 0xb                # apply_shifts:147         .quad 0xb
avx512_Xx_1235: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1236: .quad 0xd                # apply_shifts:147         .quad 0xd
avx512_Xx_1237: .quad 0xf                # apply_shifts:147         .quad 0xf
avx512_Xx_1238: .text                    # apply_shifts:149         .text
avx512_Xx_1239: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_70] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_70]
avx512_Xx_1240: VPERMI2Q ZMM9, ZMM3, ZMM4 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_4
avx512_Xx_1241: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1242: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1243: _avx512_label_71:        # apply_shifts:145         _avx512_label_71:
avx512_Xx_1244: .quad 0x18               # apply_shifts:147         .quad 0x18
avx512_Xx_1245: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1246: .quad 0x34               # apply_shifts:147         .quad 0x34
avx512_Xx_1247: .quad 0x28               # apply_shifts:147         .quad 0x28
avx512_Xx_1248: .quad 0x1c               # apply_shifts:147         .quad 0x1c
avx512_Xx_1249: .quad 0x10               # apply_shifts:147         .quad 0x10
avx512_Xx_1250: .quad 0x4                # apply_shifts:147         .quad 0x4
avx512_Xx_1251: .quad 0x2c               # apply_shifts:147         .quad 0x2c
avx512_Xx_1252: .text                    # apply_shifts:149         .text
avx512_Xx_1253: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_71] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_71]
avx512_Xx_1254: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1255: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1256: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1257: _avx512_label_72:        # apply_shifts:145         _avx512_label_72:
avx512_Xx_1258: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1259: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1260: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1261: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1262: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1263: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1264: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1265: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1266: .text                    # apply_shifts:149         .text
avx512_Xx_1267: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_72] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_72]
avx512_Xx_1268: VPERMI2Q ZMM9, ZMM4, ZMM4 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_4, `inputs_4
avx512_Xx_1269: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1270: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1271: _avx512_label_73:        # apply_shifts:145         _avx512_label_73:
avx512_Xx_1272: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1273: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1274: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1275: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1276: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1277: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1278: .quad 0x38               # apply_shifts:147         .quad 0x38
avx512_Xx_1279: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1280: .text                    # apply_shifts:149         .text
avx512_Xx_1281: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_73] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_73]
avx512_Xx_1282: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1283: VMOVDQU64 [RDX+192], ZMM6 # to_gmp_integer:368       VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_1284: VPCMPUQ k1, ZMM6, ZMM7, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1285: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_66] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_66]
avx512_Xx_1286: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1287: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1288: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1289: _avx512_label_74:        # apply_shifts:145         _avx512_label_74:
avx512_Xx_1290: .quad 0x7                # apply_shifts:147         .quad 0x7
avx512_Xx_1291: .quad 0x8                # apply_shifts:147         .quad 0x8
avx512_Xx_1292: .quad 0x9                # apply_shifts:147         .quad 0x9
avx512_Xx_1293: .quad 0xb                # apply_shifts:147         .quad 0xb
avx512_Xx_1294: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1295: .quad 0xd                # apply_shifts:147         .quad 0xd
avx512_Xx_1296: .quad 0xe                # apply_shifts:147         .quad 0xe
avx512_Xx_1297: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1298: .text                    # apply_shifts:149         .text
avx512_Xx_1299: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_74] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_74]
avx512_Xx_1300: VPERMI2Q ZMM9, ZMM4, ZMM5 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_4, `inputs_5
avx512_Xx_1301: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1302: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1303: _avx512_label_75:        # apply_shifts:145         _avx512_label_75:
avx512_Xx_1304: .quad 0x14               # apply_shifts:147         .quad 0x14
avx512_Xx_1305: .quad 0x20               # apply_shifts:147         .quad 0x20
avx512_Xx_1306: .quad 0x2c               # apply_shifts:147         .quad 0x2c
avx512_Xx_1307: .quad 0x4                # apply_shifts:147         .quad 0x4
avx512_Xx_1308: .quad 0x10               # apply_shifts:147         .quad 0x10
avx512_Xx_1309: .quad 0x1c               # apply_shifts:147         .quad 0x1c
avx512_Xx_1310: .quad 0x28               # apply_shifts:147         .quad 0x28
avx512_Xx_1311: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1312: .text                    # apply_shifts:149         .text
avx512_Xx_1313: VPSRLVQ ZMM6, ZMM9, ZMMWORD PTR [_avx512_label_75] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_75]
avx512_Xx_1314: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1315: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1316: _avx512_label_76:        # apply_shifts:145         _avx512_label_76:
avx512_Xx_1317: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1318: .quad 0x1                # apply_shifts:147         .quad 0x1
avx512_Xx_1319: .quad 0x2                # apply_shifts:147         .quad 0x2
avx512_Xx_1320: .quad 0x4                # apply_shifts:147         .quad 0x4
avx512_Xx_1321: .quad 0x5                # apply_shifts:147         .quad 0x5
avx512_Xx_1322: .quad 0x6                # apply_shifts:147         .quad 0x6
avx512_Xx_1323: .quad 0x7                # apply_shifts:147         .quad 0x7
avx512_Xx_1324: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1325: .text                    # apply_shifts:149         .text
avx512_Xx_1326: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_76] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_76]
avx512_Xx_1327: VPERMI2Q ZMM9, ZMM5, ZMM5 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_5, `inputs_5
avx512_Xx_1328: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1329: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1330: _avx512_label_77:        # apply_shifts:145         _avx512_label_77:
avx512_Xx_1331: .quad 0x20               # apply_shifts:147         .quad 0x20
avx512_Xx_1332: .quad 0x14               # apply_shifts:147         .quad 0x14
avx512_Xx_1333: .quad 0x8                # apply_shifts:147         .quad 0x8
avx512_Xx_1334: .quad 0x30               # apply_shifts:147         .quad 0x30
avx512_Xx_1335: .quad 0x24               # apply_shifts:147         .quad 0x24
avx512_Xx_1336: .quad 0x18               # apply_shifts:147         .quad 0x18
avx512_Xx_1337: .quad 0xc                # apply_shifts:147         .quad 0xc
avx512_Xx_1338: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1339: .text                    # apply_shifts:149         .text
avx512_Xx_1340: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_77] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_77]
avx512_Xx_1341: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1342: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1343: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1344: _avx512_label_78:        # apply_shifts:145         _avx512_label_78:
avx512_Xx_1345: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1346: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1347: .quad 0x3                # apply_shifts:147         .quad 0x3
avx512_Xx_1348: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1349: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1350: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1351: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1352: .quad 0x0                # apply_shifts:147         .quad 0x0
avx512_Xx_1353: .text                    # apply_shifts:149         .text
avx512_Xx_1354: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_78] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_78]
avx512_Xx_1355: VPERMI2Q ZMM9, ZMM5, ZMM5 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_5, `inputs_5
avx512_Xx_1356: .text 1                  # apply_shifts:142         .text 1
avx512_Xx_1357: .balign 64               # apply_shifts:144         .balign 64
avx512_Xx_1358: _avx512_label_79:        # apply_shifts:145         _avx512_label_79:
avx512_Xx_1359: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1360: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1361: .quad 0x3c               # apply_shifts:147         .quad 0x3c
avx512_Xx_1362: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1363: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1364: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1365: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1366: .quad 0x40               # apply_shifts:147         .quad 0x40
avx512_Xx_1367: .text                    # apply_shifts:149         .text
avx512_Xx_1368: VPSLLVQ ZMM9, ZMM9, ZMMWORD PTR [_avx512_label_79] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_79]
avx512_Xx_1369: VPORQ ZMM6, ZMM6, ZMM9   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1370: VMOVDQU64 [RDX+256], ZMM6 # to_gmp_integer:368       VMOVDQU64 [`out_data+256], `temp_vector
avx512_Xx_1371: VPCMPUQ k1, ZMM6, ZMM7, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1372: .text 1                  # to_gmp_integer:142       .text 1
avx512_Xx_1373: .balign 64               # to_gmp_integer:144       .balign 64
avx512_Xx_1374: _avx512_label_80:        # to_gmp_integer:145       _avx512_label_80:
avx512_Xx_1375: .quad 0x21               # to_gmp_integer:147       .quad 0x21
avx512_Xx_1376: .quad 0x22               # to_gmp_integer:147       .quad 0x22
avx512_Xx_1377: .quad 0x23               # to_gmp_integer:147       .quad 0x23
avx512_Xx_1378: .quad 0x24               # to_gmp_integer:147       .quad 0x24
avx512_Xx_1379: .quad 0x25               # to_gmp_integer:147       .quad 0x25
avx512_Xx_1380: .quad 0x26               # to_gmp_integer:147       .quad 0x26
avx512_Xx_1381: .quad 0x27               # to_gmp_integer:147       .quad 0x27
avx512_Xx_1382: .quad 0x28               # to_gmp_integer:147       .quad 0x28
avx512_Xx_1383: .text                    # to_gmp_integer:149       .text
avx512_Xx_1384: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_80] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_80]
avx512_Xx_1385: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1386: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1387: VPERMQ ZMM6, ZMM6, ZMM8  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1388: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1389: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1390: VPERMQ ZMM6, ZMM6, ZMM8  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1391: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1392: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1393: VPERMQ ZMM6, ZMM6, ZMM8  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1394: VPMAXUQ ZMM8, ZMM8, ZMM6 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1395: VMOVQ RAX, XMM8          # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_1396: MOV R8, RAX              # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_1397: NEG R8                   # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_1398: TEST RDI, RDI            # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_1399: CMOVNZ RAX, R8           # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_1400: _avx512_label_81:        # ~asm_function:121        _avx512_label_81:
avx512_Xx_1401: RET                      # ~asm_function:130        RET
avx512_Xx_1402: .global asm_avx512_func_to_gmp_integer_12_33 # asm_function:74          .global asm_avx512_func_to_gmp_integer_12_33
avx512_Xx_1403: asm_avx512_func_to_gmp_integer_12_33: # asm_function:75          asm_avx512_func_to_gmp_integer_12_33:
avx512_Xx_1404: VMOVDQU64 ZMM0, [RSI+0]  # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_1405: VMOVDQU64 ZMM1, [RSI+64] # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_1406: VPXORQ ZMM3, ZMM3, ZMM3  # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1407: VPXORQ ZMM4, ZMM4, ZMM4  # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_1408: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_1409: VPERMI2Q ZMM5, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1410: VPSRLVQ ZMM2, ZMM5, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_1411: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_1412: VPERMI2Q ZMM5, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1413: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_1414: VPORQ ZMM2, ZMM2, ZMM5   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1415: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_1416: VPERMI2Q ZMM5, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_1417: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_1418: VPORQ ZMM2, ZMM2, ZMM5   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1419: VMOVDQU64 [RDX+0], ZMM2  # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_1420: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1421: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_1422: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1423: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_33] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_33]
avx512_Xx_1424: VPERMI2Q ZMM5, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_1425: VPSRLVQ ZMM2, ZMM5, ZMMWORD PTR [_avx512_label_34] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_34]
avx512_Xx_1426: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_35] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_35]
avx512_Xx_1427: VPERMI2Q ZMM5, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_1428: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_36] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_36]
avx512_Xx_1429: VPORQ ZMM2, ZMM2, ZMM5   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1430: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_1431: VPERMI2Q ZMM5, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_1432: VPSLLVQ ZMM5, ZMM5, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_1433: VPORQ ZMM2, ZMM2, ZMM5   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1434: VMOVDQU64 [RDX+64], ZMM2 # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_1435: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1436: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_1437: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1438: VPXORQ ZMM2, ZMM2, ZMM2  # apply_shifts:222         VPXORQ `output, `output, `output
avx512_Xx_1439: VMOVDQU64 [RDX+128], ZMM2 # to_gmp_integer:368       VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_1440: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1441: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_54] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_54]
avx512_Xx_1442: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1443: VPXORQ ZMM2, ZMM2, ZMM2  # apply_shifts:222         VPXORQ `output, `output, `output
avx512_Xx_1444: VMOVDQU64 [RDX+192], ZMM2 # to_gmp_integer:368       VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_1445: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1446: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_66] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_66]
avx512_Xx_1447: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1448: VPXORQ ZMM2, ZMM2, ZMM2  # apply_shifts:222         VPXORQ `output, `output, `output
avx512_Xx_1449: VMOVDQU64 [RDX+256], ZMM2 # to_gmp_integer:368       VMOVDQU64 [`out_data+256], `temp_vector
avx512_Xx_1450: VPCMPUQ k1, ZMM2, ZMM3, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1451: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_80] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_80]
avx512_Xx_1452: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1453: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1454: VPERMQ ZMM2, ZMM2, ZMM4  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1455: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1456: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1457: VPERMQ ZMM2, ZMM2, ZMM4  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1458: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1459: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1460: VPERMQ ZMM2, ZMM2, ZMM4  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1461: VPMAXUQ ZMM4, ZMM4, ZMM2 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1462: VMOVQ RAX, XMM4          # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_1463: MOV R8, RAX              # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_1464: NEG R8                   # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_1465: TEST RDI, RDI            # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_1466: CMOVNZ RAX, R8           # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_1467: _avx512_label_82:        # ~asm_function:121        _avx512_label_82:
avx512_Xx_1468: RET                      # ~asm_function:130        RET
avx512_Xx_1469: .global asm_avx512_func_to_gmp_integer_21_33 # asm_function:74          .global asm_avx512_func_to_gmp_integer_21_33
avx512_Xx_1470: asm_avx512_func_to_gmp_integer_21_33: # asm_function:75          asm_avx512_func_to_gmp_integer_21_33:
avx512_Xx_1471: VMOVDQU64 ZMM0, [RSI+0]  # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_1472: VMOVDQU64 ZMM1, [RSI+64] # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_1473: VMOVDQU64 ZMM2, [RSI+128] # to_gmp_integer:336       VMOVDQU64 `input_registers_2, [`in_data+128]
avx512_Xx_1474: VPXORQ ZMM4, ZMM4, ZMM4  # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1475: VPXORQ ZMM5, ZMM5, ZMM5  # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_1476: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_1477: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1478: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_1479: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_1480: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1481: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_1482: VPORQ ZMM3, ZMM3, ZMM6   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1483: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_1484: VPERMI2Q ZMM6, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_1485: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_1486: VPORQ ZMM3, ZMM3, ZMM6   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1487: VMOVDQU64 [RDX+0], ZMM3  # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_1488: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1489: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_1490: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1491: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_44] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_44]
avx512_Xx_1492: VPERMI2Q ZMM6, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_1493: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_45] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_45]
avx512_Xx_1494: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_46] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_46]
avx512_Xx_1495: VPERMI2Q ZMM6, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_1496: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_47] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_47]
avx512_Xx_1497: VPORQ ZMM3, ZMM3, ZMM6   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1498: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_1499: VPERMI2Q ZMM6, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_1500: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_1501: VPORQ ZMM3, ZMM3, ZMM6   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1502: VMOVDQU64 [RDX+64], ZMM3 # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_1503: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1504: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_1505: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1506: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_48] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_48]
avx512_Xx_1507: VPERMI2Q ZMM6, ZMM2, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_2
avx512_Xx_1508: VPSRLVQ ZMM3, ZMM6, ZMMWORD PTR [_avx512_label_49] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_49]
avx512_Xx_1509: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_50] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_50]
avx512_Xx_1510: VPERMI2Q ZMM6, ZMM2, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_2
avx512_Xx_1511: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_51] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_51]
avx512_Xx_1512: VPORQ ZMM3, ZMM3, ZMM6   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1513: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_52] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_52]
avx512_Xx_1514: VPERMI2Q ZMM6, ZMM2, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_2
avx512_Xx_1515: VPSLLVQ ZMM6, ZMM6, ZMMWORD PTR [_avx512_label_53] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_53]
avx512_Xx_1516: VPORQ ZMM3, ZMM3, ZMM6   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1517: VMOVDQU64 [RDX+128], ZMM3 # to_gmp_integer:368       VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_1518: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1519: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_54] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_54]
avx512_Xx_1520: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1521: VPXORQ ZMM3, ZMM3, ZMM3  # apply_shifts:222         VPXORQ `output, `output, `output
avx512_Xx_1522: VMOVDQU64 [RDX+192], ZMM3 # to_gmp_integer:368       VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_1523: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1524: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_66] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_66]
avx512_Xx_1525: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1526: VPXORQ ZMM3, ZMM3, ZMM3  # apply_shifts:222         VPXORQ `output, `output, `output
avx512_Xx_1527: VMOVDQU64 [RDX+256], ZMM3 # to_gmp_integer:368       VMOVDQU64 [`out_data+256], `temp_vector
avx512_Xx_1528: VPCMPUQ k1, ZMM3, ZMM4, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1529: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_80] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_80]
avx512_Xx_1530: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1531: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1532: VPERMQ ZMM3, ZMM3, ZMM5  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1533: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1534: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1535: VPERMQ ZMM3, ZMM3, ZMM5  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1536: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1537: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1538: VPERMQ ZMM3, ZMM3, ZMM5  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1539: VPMAXUQ ZMM5, ZMM5, ZMM3 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1540: VMOVQ RAX, XMM5          # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_1541: MOV R8, RAX              # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_1542: NEG R8                   # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_1543: TEST RDI, RDI            # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_1544: CMOVNZ RAX, R8           # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_1545: _avx512_label_83:        # ~asm_function:121        _avx512_label_83:
avx512_Xx_1546: RET                      # ~asm_function:130        RET
avx512_Xx_1547: .global asm_avx512_func_to_gmp_integer_31_33 # asm_function:74          .global asm_avx512_func_to_gmp_integer_31_33
avx512_Xx_1548: asm_avx512_func_to_gmp_integer_31_33: # asm_function:75          asm_avx512_func_to_gmp_integer_31_33:
avx512_Xx_1549: VMOVDQU64 ZMM0, [RSI+0]  # to_gmp_integer:336       VMOVDQU64 `input_registers_0, [`in_data+0]
avx512_Xx_1550: VMOVDQU64 ZMM1, [RSI+64] # to_gmp_integer:336       VMOVDQU64 `input_registers_1, [`in_data+64]
avx512_Xx_1551: VMOVDQU64 ZMM2, [RSI+128] # to_gmp_integer:336       VMOVDQU64 `input_registers_2, [`in_data+128]
avx512_Xx_1552: VMOVDQU64 ZMM3, [RSI+192] # to_gmp_integer:336       VMOVDQU64 `input_registers_3, [`in_data+192]
avx512_Xx_1553: VPXORQ ZMM5, ZMM5, ZMM5  # to_gmp_integer:339       VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1554: VPXORQ ZMM6, ZMM6, ZMM6  # to_gmp_integer:340       VPXORQ `num_limbs_vector, `num_limbs_vector, `num_limbs_vector
avx512_Xx_1555: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_26] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_26]
avx512_Xx_1556: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1557: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_27] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_27]
avx512_Xx_1558: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_28] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_28]
avx512_Xx_1559: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_1
avx512_Xx_1560: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_29] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_29]
avx512_Xx_1561: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1562: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_30] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_30]
avx512_Xx_1563: VPERMI2Q ZMM7, ZMM0, ZMM0 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_0, `inputs_0
avx512_Xx_1564: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_31] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_31]
avx512_Xx_1565: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1566: VMOVDQU64 [RDX+0], ZMM4  # to_gmp_integer:368       VMOVDQU64 [`out_data+0], `temp_vector
avx512_Xx_1567: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1568: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_32] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_32]
avx512_Xx_1569: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1570: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_44] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_44]
avx512_Xx_1571: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_1572: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_45] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_45]
avx512_Xx_1573: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_46] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_46]
avx512_Xx_1574: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_2
avx512_Xx_1575: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_47] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_47]
avx512_Xx_1576: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1577: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_37] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_37]
avx512_Xx_1578: VPERMI2Q ZMM7, ZMM1, ZMM1 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_1, `inputs_1
avx512_Xx_1579: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_38] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_38]
avx512_Xx_1580: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1581: VMOVDQU64 [RDX+64], ZMM4 # to_gmp_integer:368       VMOVDQU64 [`out_data+64], `temp_vector
avx512_Xx_1582: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1583: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_39] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_39]
avx512_Xx_1584: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1585: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_56] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_56]
avx512_Xx_1586: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1587: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_57] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_57]
avx512_Xx_1588: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_58] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_58]
avx512_Xx_1589: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1590: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_59] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_59]
avx512_Xx_1591: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1592: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_60] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_60]
avx512_Xx_1593: VPERMI2Q ZMM7, ZMM2, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_2, `inputs_3
avx512_Xx_1594: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_61] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_61]
avx512_Xx_1595: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1596: VMOVDQU64 [RDX+128], ZMM4 # to_gmp_integer:368       VMOVDQU64 [`out_data+128], `temp_vector
avx512_Xx_1597: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1598: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_54] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_54]
avx512_Xx_1599: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1600: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_62] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_62]
avx512_Xx_1601: VPERMI2Q ZMM7, ZMM3, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_3
avx512_Xx_1602: VPSRLVQ ZMM4, ZMM7, ZMMWORD PTR [_avx512_label_63] # apply_shifts:206         VPSRLVQ `output, `buffer_0, ZMMWORD PTR [_avx512_label_63]
avx512_Xx_1603: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_64] # apply_shifts:177         VMOVDQU64 `buffer_0, ZMMWORD PTR [_avx512_label_64]
avx512_Xx_1604: VPERMI2Q ZMM7, ZMM3, ZMM3 # apply_shifts:178         VPERMI2Q `buffer_0, `inputs_3, `inputs_3
avx512_Xx_1605: VPSLLVQ ZMM7, ZMM7, ZMMWORD PTR [_avx512_label_65] # apply_shifts:206         VPSLLVQ `buffer_0, `buffer_0, ZMMWORD PTR [_avx512_label_65]
avx512_Xx_1606: VPORQ ZMM4, ZMM4, ZMM7   # apply_shifts:215         VPORQ `output, `output, `buffer_0
avx512_Xx_1607: VMOVDQU64 [RDX+192], ZMM4 # to_gmp_integer:368       VMOVDQU64 [`out_data+192], `temp_vector
avx512_Xx_1608: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1609: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_66] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_66]
avx512_Xx_1610: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1611: VPXORQ ZMM4, ZMM4, ZMM4  # apply_shifts:222         VPXORQ `output, `output, `output
avx512_Xx_1612: VMOVDQU64 [RDX+256], ZMM4 # to_gmp_integer:368       VMOVDQU64 [`out_data+256], `temp_vector
avx512_Xx_1613: VPCMPUQ k1, ZMM4, ZMM5, 4 # to_gmp_integer:371       VPCMPUQ k1, `temp_vector, `zero_vector, 4
avx512_Xx_1614: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_80] # to_gmp_integer:379       VMOVDQU64 `temp_vector {k1}{z}, ZMMWORD PTR [_avx512_label_80]
avx512_Xx_1615: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:382       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1616: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_40] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1617: VPERMQ ZMM4, ZMM4, ZMM6  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1618: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1619: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_41] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1620: VPERMQ ZMM4, ZMM4, ZMM6  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1621: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1622: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_42] # to_gmp_integer:387       VMOVDQU64 `temp_vector, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1623: VPERMQ ZMM4, ZMM4, ZMM6  # to_gmp_integer:388       VPERMQ `temp_vector, `temp_vector, `num_limbs_vector
avx512_Xx_1624: VPMAXUQ ZMM6, ZMM6, ZMM4 # to_gmp_integer:389       VPMAXUQ `num_limbs_vector, `num_limbs_vector, `temp_vector
avx512_Xx_1625: VMOVQ RAX, XMM6          # to_gmp_integer:395       VMOVQ `out_num_limbs, `num_limbs_vector_128
avx512_Xx_1626: MOV R8, RAX              # to_gmp_integer:397       MOV `temp_scalar, `out_num_limbs
avx512_Xx_1627: NEG R8                   # to_gmp_integer:398       NEG `temp_scalar
avx512_Xx_1628: TEST RDI, RDI            # to_gmp_integer:399       TEST `in_sign, `in_sign
avx512_Xx_1629: CMOVNZ RAX, R8           # to_gmp_integer:400       CMOVNZ `out_num_limbs, `temp_scalar
avx512_Xx_1630: _avx512_label_84:        # ~asm_function:121        _avx512_label_84:
avx512_Xx_1631: RET                      # ~asm_function:130        RET
avx512_Xx_1632: .global asm_avx512_func_add_12_12_12 # asm_function:74          .global asm_avx512_func_add_12_12_12
avx512_Xx_1633: asm_avx512_func_add_12_12_12: # asm_function:75          asm_avx512_func_add_12_12_12:
avx512_Xx_1634: VPXORQ ZMM4, ZMM4, ZMM4  # add:521                  VPXORQ `pivot_index_vector, `pivot_index_vector, `pivot_index_vector
avx512_Xx_1635: VMOVDQU64 ZMM0, [RSI+0]  # add:532                  VMOVDQU64 `a_registers_0, [`in_a_data+0]
avx512_Xx_1636: VMOVDQU64 ZMM6, [RCX+0]  # add:541                  VMOVDQU64 `b_registers_0, [`in_b_data+0]
avx512_Xx_1637: VPCMPUQ k1, ZMM0, ZMM6, 4 # add:550                  VPCMPUQ k1, `a_registers_0, `b_registers_0, 4
avx512_Xx_1638: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_0] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_0]
avx512_Xx_1639: VPMAXUQ ZMM4, ZMM4, ZMM2 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1640: VMOVDQU64 ZMM1, [RSI+64] # add:532                  VMOVDQU64 `a_registers_1, [`in_a_data+64]
avx512_Xx_1641: VMOVDQU64 ZMM7, [RCX+64] # add:541                  VMOVDQU64 `b_registers_1, [`in_b_data+64]
avx512_Xx_1642: VPCMPUQ k1, ZMM1, ZMM7, 4 # add:550                  VPCMPUQ k1, `a_registers_1, `b_registers_1, 4
avx512_Xx_1643: VMOVDQU64 ZMM2 {k1}{z}, ZMMWORD PTR [_avx512_label_1] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_1]
avx512_Xx_1644: VPMAXUQ ZMM4, ZMM4, ZMM2 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1645: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_40] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1646: VPERMQ ZMM2, ZMM2, ZMM4  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1647: VPMAXUQ ZMM4, ZMM4, ZMM2 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1648: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_41] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1649: VPERMQ ZMM2, ZMM2, ZMM4  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1650: VPMAXUQ ZMM4, ZMM4, ZMM2 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1651: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_42] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1652: VPERMQ ZMM2, ZMM2, ZMM4  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1653: VPMAXUQ ZMM4, ZMM4, ZMM2 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1654: VMOVQ R9, XMM4           # add:575                  VMOVQ `temp_0, `pivot_index_vector_128
avx512_Xx_1655: MOV R10, [RSI+R9*8]      # add:576                  MOV `temp_1, [`in_a_data+`temp_0*8]
avx512_Xx_1656: CMP R10, [RCX+R9*8]      # add:577                  CMP `temp_1, [`in_b_data+`temp_0*8]
avx512_Xx_1657: .text 1                  # add:599                  .text 1
avx512_Xx_1658: .balign 8                # add:604                  .balign 8
avx512_Xx_1659: avx512_add_table:        # add:605                  avx512_add_table:
avx512_Xx_1660: .quad 0xffffffffffffffff, 0, 0, 0 # add:606                  .quad 0xffffffffffffffff, 0, 0, 0
avx512_Xx_1661: .quad 0, 0xffffffffffffffff, 0, 1 # add:607                  .quad 0, 0xffffffffffffffff, 0, 1
avx512_Xx_1662: .quad 0xffffffffffffffff, 0xffffffffffffffff, 0, 1 # add:608                  .quad 0xffffffffffffffff, 0xffffffffffffffff, 0, 1
avx512_Xx_1663: .quad 0, 0, 0, 0         # add:609                  .quad 0, 0, 0, 0
avx512_Xx_1664: .quad 0xffffffffffffffff, 0, 0, 0 # add:610                  .quad 0xffffffffffffffff, 0, 0, 0
avx512_Xx_1665: .quad 0xffffffffffffffff, 0, 0xffffffffffffffff, 1 # add:611                  .quad 0xffffffffffffffff, 0, 0xffffffffffffffff, 1
avx512_Xx_1666: .quad 0, 0, 0xffffffffffffffff, 1 # add:612                  .quad 0, 0, 0xffffffffffffffff, 1
avx512_Xx_1667: .quad 0, 0, 0, 0         # add:613                  .quad 0, 0, 0, 0
avx512_Xx_1668: .text                    # add:614                  .text
avx512_Xx_1669: LEA R9, [RDI*2+RDX+3]    # add:620                  LEA `temp_0, [`in_a_sign*2+`in_b_sign+3]
avx512_Xx_1670: LEA R10, [R9+4]          # add:621                  LEA `temp_1, [`temp_0+4]
avx512_Xx_1671: CMOVAE R9, R10           # add:622                  CMOVAE `temp_0, `temp_1
avx512_Xx_1672: SHL R9, 5                # add:625                  SHL `temp_0, 5
avx512_Xx_1673: LEA R10, [avx512_add_table+R9] # add:630                  LEA `temp_1, [avx512_add_table+`temp_0]
avx512_Xx_1674: MOV RAX, [R10]           # add:633                  MOV `out_sign, [`temp_1]
avx512_Xx_1675: VPBROADCASTQ ZMM2, [R10+8] # add:634                  VPBROADCASTQ `A, [`temp_1+8]
avx512_Xx_1676: VPBROADCASTQ ZMM3, [R10+16] # add:635                  VPBROADCASTQ `B, [`temp_1+16]
avx512_Xx_1677: VPBROADCASTQ ZMM4, [R10+24] # add:636                  VPBROADCASTQ `C, [`temp_1+24]
avx512_Xx_1678: VPXORQ ZMM5, ZMM0, ZMM2  # add:651                  VPXORQ `temp_vector, `a_registers_0, `A
avx512_Xx_1679: VPADDQ ZMM0, ZMM5, ZMM4  # add:652                  VPADDQ `out_registers_0, `temp_vector, `C
avx512_Xx_1680: VPXORQ ZMM5, ZMM6, ZMM3  # add:653                  VPXORQ `temp_vector, `b_registers_0, `B
avx512_Xx_1681: VPADDQ ZMM0, ZMM0, ZMM5  # add:654                  VPADDQ `out_registers_0, `out_registers_0, `temp_vector
avx512_Xx_1682: VPXORQ ZMM5, ZMM1, ZMM2  # add:651                  VPXORQ `temp_vector, `a_registers_1, `A
avx512_Xx_1683: VPADDQ ZMM1, ZMM5, ZMM4  # add:652                  VPADDQ `out_registers_1, `temp_vector, `C
avx512_Xx_1684: VPXORQ ZMM5, ZMM7, ZMM3  # add:653                  VPXORQ `temp_vector, `b_registers_1, `B
avx512_Xx_1685: VPADDQ ZMM1, ZMM1, ZMM5  # add:654                  VPADDQ `out_registers_1, `out_registers_1, `temp_vector
avx512_Xx_1686: .text 1                  # apply_carry:142          .text 1
avx512_Xx_1687: .balign 64               # apply_carry:144          .balign 64
avx512_Xx_1688: _avx512_label_85:        # apply_carry:145          _avx512_label_85:
avx512_Xx_1689: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1690: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1691: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1692: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1693: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1694: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1695: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1696: .quad 0xfff0000000000000 # apply_carry:147          .quad 0xfff0000000000000
avx512_Xx_1697: .text                    # apply_carry:149          .text
avx512_Xx_1698: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_1699: .text 1                  # apply_carry:142          .text 1
avx512_Xx_1700: .balign 64               # apply_carry:144          .balign 64
avx512_Xx_1701: _avx512_label_86:        # apply_carry:145          _avx512_label_86:
avx512_Xx_1702: .quad 0x7                # apply_carry:147          .quad 0x7
avx512_Xx_1703: .quad 0x8                # apply_carry:147          .quad 0x8
avx512_Xx_1704: .quad 0x9                # apply_carry:147          .quad 0x9
avx512_Xx_1705: .quad 0xa                # apply_carry:147          .quad 0xa
avx512_Xx_1706: .quad 0xb                # apply_carry:147          .quad 0xb
avx512_Xx_1707: .quad 0xc                # apply_carry:147          .quad 0xc
avx512_Xx_1708: .quad 0xd                # apply_carry:147          .quad 0xd
avx512_Xx_1709: .quad 0xe                # apply_carry:147          .quad 0xe
avx512_Xx_1710: .text                    # apply_carry:149          .text
avx512_Xx_1711: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_1712: VPXORQ ZMM4, ZMM4, ZMM4  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1713: _avx512_label_87:        # apply_carry:429          _avx512_label_87:
avx512_Xx_1714: VMOVDQU64 ZMM6, ZMM3     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1715: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_1716: VPSRAQ ZMM6, ZMM6, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1717: VPANDNQ ZMM1, ZMM2, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_1718: VPADDQ ZMM1, ZMM1, ZMM6  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_1719: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_1720: VMOVDQA64 ZMM5, ZMM1     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_1
avx512_Xx_1721: VMOVDQU64 ZMM6, ZMM3     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1722: VPERMI2Q ZMM6, ZMM4, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_1723: VPSRAQ ZMM6, ZMM6, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1724: VPANDNQ ZMM0, ZMM2, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_1725: VPADDQ ZMM0, ZMM0, ZMM6  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_1726: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_1727: VPORQ ZMM5, ZMM5, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_1728: VMOVDQU64 [R8-64], ZMM4  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_1729: VMOVDQU64 [R8+128], ZMM4 # apply_carry:460          VMOVDQU64 [`in_data+128], `zero_vector
avx512_Xx_1730: VPTESTMQ k1, ZMM5, ZMM2  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_1731: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_1732: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_1733: JNZ _avx512_label_87     # apply_carry:466          JNZ _avx512_label_87
avx512_Xx_1734: _avx512_label_88:        # ~asm_function:121        _avx512_label_88:
avx512_Xx_1735: RET                      # ~asm_function:130        RET
avx512_Xx_1736: .global asm_avx512_func_add_21_21_21 # asm_function:74          .global asm_avx512_func_add_21_21_21
avx512_Xx_1737: asm_avx512_func_add_21_21_21: # asm_function:75          asm_avx512_func_add_21_21_21:
avx512_Xx_1738: VPXORQ ZMM5, ZMM5, ZMM5  # add:521                  VPXORQ `pivot_index_vector, `pivot_index_vector, `pivot_index_vector
avx512_Xx_1739: VMOVDQU64 ZMM0, [RSI+0]  # add:532                  VMOVDQU64 `a_registers_0, [`in_a_data+0]
avx512_Xx_1740: VMOVDQU64 ZMM7, [RCX+0]  # add:541                  VMOVDQU64 `b_registers_0, [`in_b_data+0]
avx512_Xx_1741: VPCMPUQ k1, ZMM0, ZMM7, 4 # add:550                  VPCMPUQ k1, `a_registers_0, `b_registers_0, 4
avx512_Xx_1742: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_0] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_0]
avx512_Xx_1743: VPMAXUQ ZMM5, ZMM5, ZMM3 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1744: VMOVDQU64 ZMM1, [RSI+64] # add:532                  VMOVDQU64 `a_registers_1, [`in_a_data+64]
avx512_Xx_1745: VMOVDQU64 ZMM8, [RCX+64] # add:541                  VMOVDQU64 `b_registers_1, [`in_b_data+64]
avx512_Xx_1746: VPCMPUQ k1, ZMM1, ZMM8, 4 # add:550                  VPCMPUQ k1, `a_registers_1, `b_registers_1, 4
avx512_Xx_1747: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_1] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_1]
avx512_Xx_1748: VPMAXUQ ZMM5, ZMM5, ZMM3 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1749: VMOVDQU64 ZMM2, [RSI+128] # add:532                  VMOVDQU64 `a_registers_2, [`in_a_data+128]
avx512_Xx_1750: VMOVDQU64 ZMM9, [RCX+128] # add:541                  VMOVDQU64 `b_registers_2, [`in_b_data+128]
avx512_Xx_1751: VPCMPUQ k1, ZMM2, ZMM9, 4 # add:550                  VPCMPUQ k1, `a_registers_2, `b_registers_2, 4
avx512_Xx_1752: VMOVDQU64 ZMM3 {k1}{z}, ZMMWORD PTR [_avx512_label_12] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_12]
avx512_Xx_1753: VPMAXUQ ZMM5, ZMM5, ZMM3 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1754: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_40] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1755: VPERMQ ZMM3, ZMM3, ZMM5  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1756: VPMAXUQ ZMM5, ZMM5, ZMM3 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1757: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_41] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1758: VPERMQ ZMM3, ZMM3, ZMM5  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1759: VPMAXUQ ZMM5, ZMM5, ZMM3 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1760: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_42] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1761: VPERMQ ZMM3, ZMM3, ZMM5  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1762: VPMAXUQ ZMM5, ZMM5, ZMM3 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1763: VMOVQ R9, XMM5           # add:575                  VMOVQ `temp_0, `pivot_index_vector_128
avx512_Xx_1764: MOV R10, [RSI+R9*8]      # add:576                  MOV `temp_1, [`in_a_data+`temp_0*8]
avx512_Xx_1765: CMP R10, [RCX+R9*8]      # add:577                  CMP `temp_1, [`in_b_data+`temp_0*8]
avx512_Xx_1766: LEA R9, [RDI*2+RDX+3]    # add:620                  LEA `temp_0, [`in_a_sign*2+`in_b_sign+3]
avx512_Xx_1767: LEA R10, [R9+4]          # add:621                  LEA `temp_1, [`temp_0+4]
avx512_Xx_1768: CMOVAE R9, R10           # add:622                  CMOVAE `temp_0, `temp_1
avx512_Xx_1769: SHL R9, 5                # add:625                  SHL `temp_0, 5
avx512_Xx_1770: LEA R10, [avx512_add_table+R9] # add:630                  LEA `temp_1, [avx512_add_table+`temp_0]
avx512_Xx_1771: MOV RAX, [R10]           # add:633                  MOV `out_sign, [`temp_1]
avx512_Xx_1772: VPBROADCASTQ ZMM3, [R10+8] # add:634                  VPBROADCASTQ `A, [`temp_1+8]
avx512_Xx_1773: VPBROADCASTQ ZMM4, [R10+16] # add:635                  VPBROADCASTQ `B, [`temp_1+16]
avx512_Xx_1774: VPBROADCASTQ ZMM5, [R10+24] # add:636                  VPBROADCASTQ `C, [`temp_1+24]
avx512_Xx_1775: VPXORQ ZMM6, ZMM0, ZMM3  # add:651                  VPXORQ `temp_vector, `a_registers_0, `A
avx512_Xx_1776: VPADDQ ZMM0, ZMM6, ZMM5  # add:652                  VPADDQ `out_registers_0, `temp_vector, `C
avx512_Xx_1777: VPXORQ ZMM6, ZMM7, ZMM4  # add:653                  VPXORQ `temp_vector, `b_registers_0, `B
avx512_Xx_1778: VPADDQ ZMM0, ZMM0, ZMM6  # add:654                  VPADDQ `out_registers_0, `out_registers_0, `temp_vector
avx512_Xx_1779: VPXORQ ZMM6, ZMM1, ZMM3  # add:651                  VPXORQ `temp_vector, `a_registers_1, `A
avx512_Xx_1780: VPADDQ ZMM1, ZMM6, ZMM5  # add:652                  VPADDQ `out_registers_1, `temp_vector, `C
avx512_Xx_1781: VPXORQ ZMM6, ZMM8, ZMM4  # add:653                  VPXORQ `temp_vector, `b_registers_1, `B
avx512_Xx_1782: VPADDQ ZMM1, ZMM1, ZMM6  # add:654                  VPADDQ `out_registers_1, `out_registers_1, `temp_vector
avx512_Xx_1783: VPXORQ ZMM6, ZMM2, ZMM3  # add:651                  VPXORQ `temp_vector, `a_registers_2, `A
avx512_Xx_1784: VPADDQ ZMM2, ZMM6, ZMM5  # add:652                  VPADDQ `out_registers_2, `temp_vector, `C
avx512_Xx_1785: VPXORQ ZMM6, ZMM9, ZMM4  # add:653                  VPXORQ `temp_vector, `b_registers_2, `B
avx512_Xx_1786: VPADDQ ZMM2, ZMM2, ZMM6  # add:654                  VPADDQ `out_registers_2, `out_registers_2, `temp_vector
avx512_Xx_1787: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_1788: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_1789: VPXORQ ZMM5, ZMM5, ZMM5  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1790: _avx512_label_89:        # apply_carry:429          _avx512_label_89:
avx512_Xx_1791: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1792: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_1793: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1794: VPANDNQ ZMM2, ZMM3, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_1795: VPADDQ ZMM2, ZMM2, ZMM7  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_1796: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_1797: VMOVDQA64 ZMM6, ZMM2     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_2
avx512_Xx_1798: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1799: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_1800: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1801: VPANDNQ ZMM1, ZMM3, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_1802: VPADDQ ZMM1, ZMM1, ZMM7  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_1803: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_1804: VPORQ ZMM6, ZMM6, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_1805: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1806: VPERMI2Q ZMM7, ZMM5, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_1807: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1808: VPANDNQ ZMM0, ZMM3, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_1809: VPADDQ ZMM0, ZMM0, ZMM7  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_1810: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_1811: VPORQ ZMM6, ZMM6, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_1812: VMOVDQU64 [R8-64], ZMM5  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_1813: VMOVDQU64 [R8+192], ZMM5 # apply_carry:460          VMOVDQU64 [`in_data+192], `zero_vector
avx512_Xx_1814: VPTESTMQ k1, ZMM6, ZMM3  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_1815: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_1816: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_1817: JNZ _avx512_label_89     # apply_carry:466          JNZ _avx512_label_89
avx512_Xx_1818: _avx512_label_90:        # ~asm_function:121        _avx512_label_90:
avx512_Xx_1819: RET                      # ~asm_function:130        RET
avx512_Xx_1820: .global asm_avx512_func_add_31_31_31 # asm_function:74          .global asm_avx512_func_add_31_31_31
avx512_Xx_1821: asm_avx512_func_add_31_31_31: # asm_function:75          asm_avx512_func_add_31_31_31:
avx512_Xx_1822: VPXORQ ZMM6, ZMM6, ZMM6  # add:521                  VPXORQ `pivot_index_vector, `pivot_index_vector, `pivot_index_vector
avx512_Xx_1823: VMOVDQU64 ZMM0, [RSI+0]  # add:532                  VMOVDQU64 `a_registers_0, [`in_a_data+0]
avx512_Xx_1824: VMOVDQU64 ZMM8, [RCX+0]  # add:541                  VMOVDQU64 `b_registers_0, [`in_b_data+0]
avx512_Xx_1825: VPCMPUQ k1, ZMM0, ZMM8, 4 # add:550                  VPCMPUQ k1, `a_registers_0, `b_registers_0, 4
avx512_Xx_1826: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_0] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_0]
avx512_Xx_1827: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1828: VMOVDQU64 ZMM1, [RSI+64] # add:532                  VMOVDQU64 `a_registers_1, [`in_a_data+64]
avx512_Xx_1829: VMOVDQU64 ZMM9, [RCX+64] # add:541                  VMOVDQU64 `b_registers_1, [`in_b_data+64]
avx512_Xx_1830: VPCMPUQ k1, ZMM1, ZMM9, 4 # add:550                  VPCMPUQ k1, `a_registers_1, `b_registers_1, 4
avx512_Xx_1831: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_1] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_1]
avx512_Xx_1832: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1833: VMOVDQU64 ZMM2, [RSI+128] # add:532                  VMOVDQU64 `a_registers_2, [`in_a_data+128]
avx512_Xx_1834: VMOVDQU64 ZMM10, [RCX+128] # add:541                  VMOVDQU64 `b_registers_2, [`in_b_data+128]
avx512_Xx_1835: VPCMPUQ k1, ZMM2, ZMM10, 4 # add:550                  VPCMPUQ k1, `a_registers_2, `b_registers_2, 4
avx512_Xx_1836: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_12] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_12]
avx512_Xx_1837: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1838: VMOVDQU64 ZMM3, [RSI+192] # add:532                  VMOVDQU64 `a_registers_3, [`in_a_data+192]
avx512_Xx_1839: VMOVDQU64 ZMM11, [RCX+192] # add:541                  VMOVDQU64 `b_registers_3, [`in_b_data+192]
avx512_Xx_1840: VPCMPUQ k1, ZMM3, ZMM11, 4 # add:550                  VPCMPUQ k1, `a_registers_3, `b_registers_3, 4
avx512_Xx_1841: VMOVDQU64 ZMM4 {k1}{z}, ZMMWORD PTR [_avx512_label_16] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_16]
avx512_Xx_1842: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1843: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_40] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1844: VPERMQ ZMM4, ZMM4, ZMM6  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1845: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1846: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_41] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1847: VPERMQ ZMM4, ZMM4, ZMM6  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1848: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1849: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_42] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1850: VPERMQ ZMM4, ZMM4, ZMM6  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1851: VPMAXUQ ZMM6, ZMM6, ZMM4 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1852: VMOVQ R9, XMM6           # add:575                  VMOVQ `temp_0, `pivot_index_vector_128
avx512_Xx_1853: MOV R10, [RSI+R9*8]      # add:576                  MOV `temp_1, [`in_a_data+`temp_0*8]
avx512_Xx_1854: CMP R10, [RCX+R9*8]      # add:577                  CMP `temp_1, [`in_b_data+`temp_0*8]
avx512_Xx_1855: LEA R9, [RDI*2+RDX+3]    # add:620                  LEA `temp_0, [`in_a_sign*2+`in_b_sign+3]
avx512_Xx_1856: LEA R10, [R9+4]          # add:621                  LEA `temp_1, [`temp_0+4]
avx512_Xx_1857: CMOVAE R9, R10           # add:622                  CMOVAE `temp_0, `temp_1
avx512_Xx_1858: SHL R9, 5                # add:625                  SHL `temp_0, 5
avx512_Xx_1859: LEA R10, [avx512_add_table+R9] # add:630                  LEA `temp_1, [avx512_add_table+`temp_0]
avx512_Xx_1860: MOV RAX, [R10]           # add:633                  MOV `out_sign, [`temp_1]
avx512_Xx_1861: VPBROADCASTQ ZMM4, [R10+8] # add:634                  VPBROADCASTQ `A, [`temp_1+8]
avx512_Xx_1862: VPBROADCASTQ ZMM5, [R10+16] # add:635                  VPBROADCASTQ `B, [`temp_1+16]
avx512_Xx_1863: VPBROADCASTQ ZMM6, [R10+24] # add:636                  VPBROADCASTQ `C, [`temp_1+24]
avx512_Xx_1864: VPXORQ ZMM7, ZMM0, ZMM4  # add:651                  VPXORQ `temp_vector, `a_registers_0, `A
avx512_Xx_1865: VPADDQ ZMM0, ZMM7, ZMM6  # add:652                  VPADDQ `out_registers_0, `temp_vector, `C
avx512_Xx_1866: VPXORQ ZMM7, ZMM8, ZMM5  # add:653                  VPXORQ `temp_vector, `b_registers_0, `B
avx512_Xx_1867: VPADDQ ZMM0, ZMM0, ZMM7  # add:654                  VPADDQ `out_registers_0, `out_registers_0, `temp_vector
avx512_Xx_1868: VPXORQ ZMM7, ZMM1, ZMM4  # add:651                  VPXORQ `temp_vector, `a_registers_1, `A
avx512_Xx_1869: VPADDQ ZMM1, ZMM7, ZMM6  # add:652                  VPADDQ `out_registers_1, `temp_vector, `C
avx512_Xx_1870: VPXORQ ZMM7, ZMM9, ZMM5  # add:653                  VPXORQ `temp_vector, `b_registers_1, `B
avx512_Xx_1871: VPADDQ ZMM1, ZMM1, ZMM7  # add:654                  VPADDQ `out_registers_1, `out_registers_1, `temp_vector
avx512_Xx_1872: VPXORQ ZMM7, ZMM2, ZMM4  # add:651                  VPXORQ `temp_vector, `a_registers_2, `A
avx512_Xx_1873: VPADDQ ZMM2, ZMM7, ZMM6  # add:652                  VPADDQ `out_registers_2, `temp_vector, `C
avx512_Xx_1874: VPXORQ ZMM7, ZMM10, ZMM5 # add:653                  VPXORQ `temp_vector, `b_registers_2, `B
avx512_Xx_1875: VPADDQ ZMM2, ZMM2, ZMM7  # add:654                  VPADDQ `out_registers_2, `out_registers_2, `temp_vector
avx512_Xx_1876: VPXORQ ZMM7, ZMM3, ZMM4  # add:651                  VPXORQ `temp_vector, `a_registers_3, `A
avx512_Xx_1877: VPADDQ ZMM3, ZMM7, ZMM6  # add:652                  VPADDQ `out_registers_3, `temp_vector, `C
avx512_Xx_1878: VPXORQ ZMM7, ZMM11, ZMM5 # add:653                  VPXORQ `temp_vector, `b_registers_3, `B
avx512_Xx_1879: VPADDQ ZMM3, ZMM3, ZMM7  # add:654                  VPADDQ `out_registers_3, `out_registers_3, `temp_vector
avx512_Xx_1880: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_1881: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_1882: VPXORQ ZMM6, ZMM6, ZMM6  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_1883: _avx512_label_91:        # apply_carry:429          _avx512_label_91:
avx512_Xx_1884: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1885: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_1886: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1887: VPANDNQ ZMM3, ZMM4, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_1888: VPADDQ ZMM3, ZMM3, ZMM8  # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_1889: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_1890: VMOVDQA64 ZMM7, ZMM3     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_3
avx512_Xx_1891: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1892: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_1893: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1894: VPANDNQ ZMM2, ZMM4, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_1895: VPADDQ ZMM2, ZMM2, ZMM8  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_1896: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_1897: VPORQ ZMM7, ZMM7, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_1898: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1899: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_1900: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1901: VPANDNQ ZMM1, ZMM4, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_1902: VPADDQ ZMM1, ZMM1, ZMM8  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_1903: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_1904: VPORQ ZMM7, ZMM7, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_1905: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_1906: VPERMI2Q ZMM8, ZMM6, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_1907: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_1908: VPANDNQ ZMM0, ZMM4, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_1909: VPADDQ ZMM0, ZMM0, ZMM8  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_1910: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_1911: VPORQ ZMM7, ZMM7, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_1912: VMOVDQU64 [R8-64], ZMM6  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_1913: VMOVDQU64 [R8+256], ZMM6 # apply_carry:460          VMOVDQU64 [`in_data+256], `zero_vector
avx512_Xx_1914: VPTESTMQ k1, ZMM7, ZMM4  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_1915: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_1916: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_1917: JNZ _avx512_label_91     # apply_carry:466          JNZ _avx512_label_91
avx512_Xx_1918: _avx512_label_92:        # ~asm_function:121        _avx512_label_92:
avx512_Xx_1919: RET                      # ~asm_function:130        RET
avx512_Xx_1920: .global asm_avx512_func_add_41_41_41 # asm_function:74          .global asm_avx512_func_add_41_41_41
avx512_Xx_1921: asm_avx512_func_add_41_41_41: # asm_function:75          asm_avx512_func_add_41_41_41:
avx512_Xx_1922: VPXORQ ZMM8, ZMM8, ZMM8  # add:521                  VPXORQ `pivot_index_vector, `pivot_index_vector, `pivot_index_vector
avx512_Xx_1923: VMOVDQU64 ZMM0, [RSI+0]  # add:532                  VMOVDQU64 `a_registers_0, [`in_a_data+0]
avx512_Xx_1924: VMOVDQU64 ZMM10, [RCX+0] # add:541                  VMOVDQU64 `b_registers_0, [`in_b_data+0]
avx512_Xx_1925: VPCMPUQ k1, ZMM0, ZMM10, 4 # add:550                  VPCMPUQ k1, `a_registers_0, `b_registers_0, 4
avx512_Xx_1926: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_0] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_0]
avx512_Xx_1927: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1928: VMOVDQU64 ZMM1, [RSI+64] # add:532                  VMOVDQU64 `a_registers_1, [`in_a_data+64]
avx512_Xx_1929: VMOVDQU64 ZMM11, [RCX+64] # add:541                  VMOVDQU64 `b_registers_1, [`in_b_data+64]
avx512_Xx_1930: VPCMPUQ k1, ZMM1, ZMM11, 4 # add:550                  VPCMPUQ k1, `a_registers_1, `b_registers_1, 4
avx512_Xx_1931: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_1] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_1]
avx512_Xx_1932: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1933: VMOVDQU64 ZMM2, [RSI+128] # add:532                  VMOVDQU64 `a_registers_2, [`in_a_data+128]
avx512_Xx_1934: VMOVDQU64 ZMM12, [RCX+128] # add:541                  VMOVDQU64 `b_registers_2, [`in_b_data+128]
avx512_Xx_1935: VPCMPUQ k1, ZMM2, ZMM12, 4 # add:550                  VPCMPUQ k1, `a_registers_2, `b_registers_2, 4
avx512_Xx_1936: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_12] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_12]
avx512_Xx_1937: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1938: VMOVDQU64 ZMM3, [RSI+192] # add:532                  VMOVDQU64 `a_registers_3, [`in_a_data+192]
avx512_Xx_1939: VMOVDQU64 ZMM13, [RCX+192] # add:541                  VMOVDQU64 `b_registers_3, [`in_b_data+192]
avx512_Xx_1940: VPCMPUQ k1, ZMM3, ZMM13, 4 # add:550                  VPCMPUQ k1, `a_registers_3, `b_registers_3, 4
avx512_Xx_1941: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_16] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_16]
avx512_Xx_1942: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1943: VMOVDQU64 ZMM4, [RSI+256] # add:532                  VMOVDQU64 `a_registers_4, [`in_a_data+256]
avx512_Xx_1944: VMOVDQU64 ZMM14, [RCX+256] # add:541                  VMOVDQU64 `b_registers_4, [`in_b_data+256]
avx512_Xx_1945: VPCMPUQ k1, ZMM4, ZMM14, 4 # add:550                  VPCMPUQ k1, `a_registers_4, `b_registers_4, 4
avx512_Xx_1946: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_20] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_20]
avx512_Xx_1947: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1948: VMOVDQU64 ZMM5, [RSI+320] # add:532                  VMOVDQU64 `a_registers_5, [`in_a_data+320]
avx512_Xx_1949: VMOVDQU64 ZMM15, [RCX+320] # add:541                  VMOVDQU64 `b_registers_5, [`in_b_data+320]
avx512_Xx_1950: VPCMPUQ k1, ZMM5, ZMM15, 4 # add:550                  VPCMPUQ k1, `a_registers_5, `b_registers_5, 4
avx512_Xx_1951: .text 1                  # add:142                  .text 1
avx512_Xx_1952: .balign 64               # add:144                  .balign 64
avx512_Xx_1953: _avx512_label_93:        # add:145                  _avx512_label_93:
avx512_Xx_1954: .quad 0x28               # add:147                  .quad 0x28
avx512_Xx_1955: .quad 0x29               # add:147                  .quad 0x29
avx512_Xx_1956: .quad 0x2a               # add:147                  .quad 0x2a
avx512_Xx_1957: .quad 0x2b               # add:147                  .quad 0x2b
avx512_Xx_1958: .quad 0x2c               # add:147                  .quad 0x2c
avx512_Xx_1959: .quad 0x2d               # add:147                  .quad 0x2d
avx512_Xx_1960: .quad 0x2e               # add:147                  .quad 0x2e
avx512_Xx_1961: .quad 0x2f               # add:147                  .quad 0x2f
avx512_Xx_1962: .text                    # add:149                  .text
avx512_Xx_1963: VMOVDQU64 ZMM6 {k1}{z}, ZMMWORD PTR [_avx512_label_93] # add:558                  VMOVDQU64 `A {k1}{z}, ZMMWORD PTR [_avx512_label_93]
avx512_Xx_1964: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:561                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1965: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_40] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_40]
avx512_Xx_1966: VPERMQ ZMM6, ZMM6, ZMM8  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1967: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1968: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_41] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_41]
avx512_Xx_1969: VPERMQ ZMM6, ZMM6, ZMM8  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1970: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1971: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_42] # add:566                  VMOVDQU64 `A, ZMMWORD PTR [_avx512_label_42]
avx512_Xx_1972: VPERMQ ZMM6, ZMM6, ZMM8  # add:567                  VPERMQ `A, `A, `pivot_index_vector
avx512_Xx_1973: VPMAXUQ ZMM8, ZMM8, ZMM6 # add:568                  VPMAXUQ `pivot_index_vector, `pivot_index_vector, `A
avx512_Xx_1974: VMOVQ R9, XMM8           # add:575                  VMOVQ `temp_0, `pivot_index_vector_128
avx512_Xx_1975: MOV R10, [RSI+R9*8]      # add:576                  MOV `temp_1, [`in_a_data+`temp_0*8]
avx512_Xx_1976: CMP R10, [RCX+R9*8]      # add:577                  CMP `temp_1, [`in_b_data+`temp_0*8]
avx512_Xx_1977: LEA R9, [RDI*2+RDX+3]    # add:620                  LEA `temp_0, [`in_a_sign*2+`in_b_sign+3]
avx512_Xx_1978: LEA R10, [R9+4]          # add:621                  LEA `temp_1, [`temp_0+4]
avx512_Xx_1979: CMOVAE R9, R10           # add:622                  CMOVAE `temp_0, `temp_1
avx512_Xx_1980: SHL R9, 5                # add:625                  SHL `temp_0, 5
avx512_Xx_1981: LEA R10, [avx512_add_table+R9] # add:630                  LEA `temp_1, [avx512_add_table+`temp_0]
avx512_Xx_1982: MOV RAX, [R10]           # add:633                  MOV `out_sign, [`temp_1]
avx512_Xx_1983: VPBROADCASTQ ZMM6, [R10+8] # add:634                  VPBROADCASTQ `A, [`temp_1+8]
avx512_Xx_1984: VPBROADCASTQ ZMM7, [R10+16] # add:635                  VPBROADCASTQ `B, [`temp_1+16]
avx512_Xx_1985: VPBROADCASTQ ZMM8, [R10+24] # add:636                  VPBROADCASTQ `C, [`temp_1+24]
avx512_Xx_1986: VPXORQ ZMM9, ZMM0, ZMM6  # add:651                  VPXORQ `temp_vector, `a_registers_0, `A
avx512_Xx_1987: VPADDQ ZMM0, ZMM9, ZMM8  # add:652                  VPADDQ `out_registers_0, `temp_vector, `C
avx512_Xx_1988: VPXORQ ZMM9, ZMM10, ZMM7 # add:653                  VPXORQ `temp_vector, `b_registers_0, `B
avx512_Xx_1989: VPADDQ ZMM0, ZMM0, ZMM9  # add:654                  VPADDQ `out_registers_0, `out_registers_0, `temp_vector
avx512_Xx_1990: VPXORQ ZMM9, ZMM1, ZMM6  # add:651                  VPXORQ `temp_vector, `a_registers_1, `A
avx512_Xx_1991: VPADDQ ZMM1, ZMM9, ZMM8  # add:652                  VPADDQ `out_registers_1, `temp_vector, `C
avx512_Xx_1992: VPXORQ ZMM9, ZMM11, ZMM7 # add:653                  VPXORQ `temp_vector, `b_registers_1, `B
avx512_Xx_1993: VPADDQ ZMM1, ZMM1, ZMM9  # add:654                  VPADDQ `out_registers_1, `out_registers_1, `temp_vector
avx512_Xx_1994: VPXORQ ZMM9, ZMM2, ZMM6  # add:651                  VPXORQ `temp_vector, `a_registers_2, `A
avx512_Xx_1995: VPADDQ ZMM2, ZMM9, ZMM8  # add:652                  VPADDQ `out_registers_2, `temp_vector, `C
avx512_Xx_1996: VPXORQ ZMM9, ZMM12, ZMM7 # add:653                  VPXORQ `temp_vector, `b_registers_2, `B
avx512_Xx_1997: VPADDQ ZMM2, ZMM2, ZMM9  # add:654                  VPADDQ `out_registers_2, `out_registers_2, `temp_vector
avx512_Xx_1998: VPXORQ ZMM9, ZMM3, ZMM6  # add:651                  VPXORQ `temp_vector, `a_registers_3, `A
avx512_Xx_1999: VPADDQ ZMM3, ZMM9, ZMM8  # add:652                  VPADDQ `out_registers_3, `temp_vector, `C
avx512_Xx_2000: VPXORQ ZMM9, ZMM13, ZMM7 # add:653                  VPXORQ `temp_vector, `b_registers_3, `B
avx512_Xx_2001: VPADDQ ZMM3, ZMM3, ZMM9  # add:654                  VPADDQ `out_registers_3, `out_registers_3, `temp_vector
avx512_Xx_2002: VPXORQ ZMM9, ZMM4, ZMM6  # add:651                  VPXORQ `temp_vector, `a_registers_4, `A
avx512_Xx_2003: VPADDQ ZMM4, ZMM9, ZMM8  # add:652                  VPADDQ `out_registers_4, `temp_vector, `C
avx512_Xx_2004: VPXORQ ZMM9, ZMM14, ZMM7 # add:653                  VPXORQ `temp_vector, `b_registers_4, `B
avx512_Xx_2005: VPADDQ ZMM4, ZMM4, ZMM9  # add:654                  VPADDQ `out_registers_4, `out_registers_4, `temp_vector
avx512_Xx_2006: VPXORQ ZMM9, ZMM5, ZMM6  # add:651                  VPXORQ `temp_vector, `a_registers_5, `A
avx512_Xx_2007: VPADDQ ZMM5, ZMM9, ZMM8  # add:652                  VPADDQ `out_registers_5, `temp_vector, `C
avx512_Xx_2008: VPXORQ ZMM9, ZMM15, ZMM7 # add:653                  VPXORQ `temp_vector, `b_registers_5, `B
avx512_Xx_2009: VPADDQ ZMM5, ZMM5, ZMM9  # add:654                  VPADDQ `out_registers_5, `out_registers_5, `temp_vector
avx512_Xx_2010: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_2011: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2012: VPXORQ ZMM8, ZMM8, ZMM8  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2013: _avx512_label_94:        # apply_carry:429          _avx512_label_94:
avx512_Xx_2014: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2015: VPERMI2Q ZMM10, ZMM4, ZMM5 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_4, `in_registers_5
avx512_Xx_2016: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2017: VPANDNQ ZMM5, ZMM6, ZMM5 # apply_carry:442          VPANDNQ `in_registers_5, `carry_mask, `in_registers_5
avx512_Xx_2018: VPADDQ ZMM5, ZMM5, ZMM10 # apply_carry:445          VPADDQ `in_registers_5, `in_registers_5, `temp_vector
avx512_Xx_2019: VMOVDQU64 [R8+320], ZMM5 # apply_carry:448          VMOVDQU64 [`in_data+320], `in_registers_5
avx512_Xx_2020: VMOVDQA64 ZMM9, ZMM5     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_5
avx512_Xx_2021: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2022: VPERMI2Q ZMM10, ZMM3, ZMM4 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_3, `in_registers_4
avx512_Xx_2023: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2024: VPANDNQ ZMM4, ZMM6, ZMM4 # apply_carry:442          VPANDNQ `in_registers_4, `carry_mask, `in_registers_4
avx512_Xx_2025: VPADDQ ZMM4, ZMM4, ZMM10 # apply_carry:445          VPADDQ `in_registers_4, `in_registers_4, `temp_vector
avx512_Xx_2026: VMOVDQU64 [R8+256], ZMM4 # apply_carry:448          VMOVDQU64 [`in_data+256], `in_registers_4
avx512_Xx_2027: VPORQ ZMM9, ZMM9, ZMM4   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_4
avx512_Xx_2028: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2029: VPERMI2Q ZMM10, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_2030: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2031: VPANDNQ ZMM3, ZMM6, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_2032: VPADDQ ZMM3, ZMM3, ZMM10 # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_2033: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_2034: VPORQ ZMM9, ZMM9, ZMM3   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_3
avx512_Xx_2035: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2036: VPERMI2Q ZMM10, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_2037: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2038: VPANDNQ ZMM2, ZMM6, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_2039: VPADDQ ZMM2, ZMM2, ZMM10 # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_2040: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_2041: VPORQ ZMM9, ZMM9, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_2042: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2043: VPERMI2Q ZMM10, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_2044: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2045: VPANDNQ ZMM1, ZMM6, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_2046: VPADDQ ZMM1, ZMM1, ZMM10 # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_2047: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_2048: VPORQ ZMM9, ZMM9, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_2049: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2050: VPERMI2Q ZMM10, ZMM8, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_2051: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2052: VPANDNQ ZMM0, ZMM6, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_2053: VPADDQ ZMM0, ZMM0, ZMM10 # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_2054: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_2055: VPORQ ZMM9, ZMM9, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_2056: VMOVDQU64 [R8-64], ZMM8  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_2057: VMOVDQU64 [R8+384], ZMM8 # apply_carry:460          VMOVDQU64 [`in_data+384], `zero_vector
avx512_Xx_2058: VPTESTMQ k1, ZMM9, ZMM6  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_2059: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_2060: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_2061: JNZ _avx512_label_94     # apply_carry:466          JNZ _avx512_label_94
avx512_Xx_2062: _avx512_label_95:        # ~asm_function:121        _avx512_label_95:
avx512_Xx_2063: RET                      # ~asm_function:130        RET
avx512_Xx_2064: .global asm_avx512_func_multiply_12_12_12 # asm_function:74          .global asm_avx512_func_multiply_12_12_12
avx512_Xx_2065: asm_avx512_func_multiply_12_12_12: # asm_function:75          asm_avx512_func_multiply_12_12_12:
avx512_Xx_2066: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_2067: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_2068: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_2069: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_2070: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_2071: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_2072: VPBROADCASTQ ZMM4, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_2073: VMOVDQU64 ZMM5, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2074: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2075: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2076: VMOVDQU64 ZMM5, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2077: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2078: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2079: VPBROADCASTQ ZMM4, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_2080: VMOVDQU64 ZMM5, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2081: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2082: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2083: VMOVDQU64 ZMM5, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2084: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2085: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2086: VPBROADCASTQ ZMM4, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_2087: VMOVDQU64 ZMM5, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2088: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2089: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2090: VMOVDQU64 ZMM5, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2091: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2092: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2093: VPBROADCASTQ ZMM4, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_2094: VMOVDQU64 ZMM5, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2095: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2096: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2097: VMOVDQU64 ZMM5, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2098: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2099: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2100: VPBROADCASTQ ZMM4, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_2101: VMOVDQU64 ZMM5, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2102: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2103: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2104: VMOVDQU64 ZMM5, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2105: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2106: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2107: VPBROADCASTQ ZMM4, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_2108: VMOVDQU64 ZMM5, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2109: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2110: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2111: VMOVDQU64 ZMM5, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2112: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2113: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2114: VPBROADCASTQ ZMM4, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_2115: VMOVDQU64 ZMM5, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2116: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2117: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2118: VMOVDQU64 ZMM5, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2119: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2120: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2121: VPBROADCASTQ ZMM4, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_2122: VMOVDQU64 ZMM5, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2123: VPMADD52LUQ ZMM0, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2124: VPMADD52HUQ ZMM2, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2125: VMOVDQU64 ZMM5, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2126: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2127: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2128: VPBROADCASTQ ZMM4, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_2129: VMOVDQU64 ZMM5, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2130: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2131: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2132: VPBROADCASTQ ZMM4, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_2133: VMOVDQU64 ZMM5, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2134: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2135: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2136: VPBROADCASTQ ZMM4, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_2137: VMOVDQU64 ZMM5, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2138: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2139: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2140: VPBROADCASTQ ZMM4, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_2141: VMOVDQU64 ZMM5, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2142: VPMADD52LUQ ZMM1, ZMM4, ZMM5 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2143: VPMADD52HUQ ZMM3, ZMM4, ZMM5 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2144: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2145: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2146: VMOVDQU64 ZMM4, ZMM5     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2147: VPERMI2Q ZMM4, ZMM2, ZMM3 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_2148: VPADDQ ZMM1, ZMM1, ZMM4  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_2149: VMOVDQU64 ZMM4, ZMM5     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2150: VPERMI2Q ZMM4, ZMM6, ZMM2 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_2151: VPADDQ ZMM0, ZMM0, ZMM4  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_2152: VMOVDQU64 ZMM2, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_2153: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2154: VPXORQ ZMM4, ZMM4, ZMM4  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2155: _avx512_label_96:        # apply_carry:429          _avx512_label_96:
avx512_Xx_2156: VMOVDQU64 ZMM6, ZMM3     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2157: VPERMI2Q ZMM6, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_2158: VPSRAQ ZMM6, ZMM6, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2159: VPANDNQ ZMM1, ZMM2, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_2160: VPADDQ ZMM1, ZMM1, ZMM6  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_2161: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_2162: VMOVDQA64 ZMM5, ZMM1     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_1
avx512_Xx_2163: VMOVDQU64 ZMM6, ZMM3     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2164: VPERMI2Q ZMM6, ZMM4, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_2165: VPSRAQ ZMM6, ZMM6, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2166: VPANDNQ ZMM0, ZMM2, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_2167: VPADDQ ZMM0, ZMM0, ZMM6  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_2168: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_2169: VPORQ ZMM5, ZMM5, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_2170: VMOVDQU64 [R8-64], ZMM4  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_2171: VMOVDQU64 [R8+128], ZMM4 # apply_carry:460          VMOVDQU64 [`in_data+128], `zero_vector
avx512_Xx_2172: VPTESTMQ k1, ZMM5, ZMM2  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_2173: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_2174: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_2175: JNZ _avx512_label_96     # apply_carry:466          JNZ _avx512_label_96
avx512_Xx_2176: _avx512_label_97:        # ~asm_function:121        _avx512_label_97:
avx512_Xx_2177: RET                      # ~asm_function:130        RET
avx512_Xx_2178: .global asm_avx512_func_multiply_12_12_21 # asm_function:74          .global asm_avx512_func_multiply_12_12_21
avx512_Xx_2179: asm_avx512_func_multiply_12_12_21: # asm_function:75          asm_avx512_func_multiply_12_12_21:
avx512_Xx_2180: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_2181: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_2182: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_2183: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_2184: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_2185: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_2186: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_2187: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_2188: VPBROADCASTQ ZMM6, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_2189: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2190: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2191: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2192: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2193: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2194: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2195: VPBROADCASTQ ZMM6, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_2196: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2197: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2198: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2199: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2200: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2201: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2202: VPBROADCASTQ ZMM6, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_2203: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2204: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2205: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2206: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2207: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2208: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2209: VPBROADCASTQ ZMM6, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_2210: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2211: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2212: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2213: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2214: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2215: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2216: VPBROADCASTQ ZMM6, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_2217: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2218: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2219: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2220: VMOVDQU64 ZMM7, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2221: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2222: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2223: VPBROADCASTQ ZMM6, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_2224: VMOVDQU64 ZMM7, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2225: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2226: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2227: VMOVDQU64 ZMM7, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2228: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2229: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2230: VMOVDQU64 ZMM7, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_2231: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2232: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2233: VPBROADCASTQ ZMM6, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_2234: VMOVDQU64 ZMM7, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2235: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2236: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2237: VMOVDQU64 ZMM7, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2238: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2239: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2240: VMOVDQU64 ZMM7, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_2241: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2242: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2243: VPBROADCASTQ ZMM6, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_2244: VMOVDQU64 ZMM7, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2245: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2246: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2247: VMOVDQU64 ZMM7, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2248: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2249: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2250: VMOVDQU64 ZMM7, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_2251: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2252: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2253: VPBROADCASTQ ZMM6, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_2254: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2255: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2256: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2257: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2258: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2259: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2260: VPBROADCASTQ ZMM6, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_2261: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2262: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2263: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2264: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2265: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2266: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2267: VPBROADCASTQ ZMM6, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_2268: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2269: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2270: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2271: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2272: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2273: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2274: VPBROADCASTQ ZMM6, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_2275: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2276: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2277: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2278: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2279: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2280: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2281: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2282: VPXORQ ZMM8, ZMM8, ZMM8  # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2283: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2284: VPERMI2Q ZMM6, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_2285: VPADDQ ZMM2, ZMM2, ZMM6  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_2286: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2287: VPERMI2Q ZMM6, ZMM3, ZMM4 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_2288: VPADDQ ZMM1, ZMM1, ZMM6  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_2289: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2290: VPERMI2Q ZMM6, ZMM8, ZMM3 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_2291: VPADDQ ZMM0, ZMM0, ZMM6  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_2292: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_2293: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2294: VPXORQ ZMM5, ZMM5, ZMM5  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2295: _avx512_label_98:        # apply_carry:429          _avx512_label_98:
avx512_Xx_2296: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2297: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_2298: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2299: VPANDNQ ZMM2, ZMM3, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_2300: VPADDQ ZMM2, ZMM2, ZMM7  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_2301: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_2302: VMOVDQA64 ZMM6, ZMM2     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_2
avx512_Xx_2303: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2304: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_2305: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2306: VPANDNQ ZMM1, ZMM3, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_2307: VPADDQ ZMM1, ZMM1, ZMM7  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_2308: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_2309: VPORQ ZMM6, ZMM6, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_2310: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2311: VPERMI2Q ZMM7, ZMM5, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_2312: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2313: VPANDNQ ZMM0, ZMM3, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_2314: VPADDQ ZMM0, ZMM0, ZMM7  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_2315: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_2316: VPORQ ZMM6, ZMM6, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_2317: VMOVDQU64 [R8-64], ZMM5  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_2318: VMOVDQU64 [R8+192], ZMM5 # apply_carry:460          VMOVDQU64 [`in_data+192], `zero_vector
avx512_Xx_2319: VPTESTMQ k1, ZMM6, ZMM3  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_2320: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_2321: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_2322: JNZ _avx512_label_98     # apply_carry:466          JNZ _avx512_label_98
avx512_Xx_2323: _avx512_label_99:        # ~asm_function:121        _avx512_label_99:
avx512_Xx_2324: RET                      # ~asm_function:130        RET
avx512_Xx_2325: .global asm_avx512_func_multiply_12_21_21 # asm_function:74          .global asm_avx512_func_multiply_12_21_21
avx512_Xx_2326: asm_avx512_func_multiply_12_21_21: # asm_function:75          asm_avx512_func_multiply_12_21_21:
avx512_Xx_2327: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_2328: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_2329: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_2330: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_2331: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_2332: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_2333: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_2334: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_2335: VPBROADCASTQ ZMM6, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_2336: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2337: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2338: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2339: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2340: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2341: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2342: VMOVDQU64 ZMM7, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_2343: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2344: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2345: VPBROADCASTQ ZMM6, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_2346: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2347: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2348: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2349: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2350: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2351: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2352: VMOVDQU64 ZMM7, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_2353: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2354: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2355: VPBROADCASTQ ZMM6, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_2356: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2357: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2358: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2359: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2360: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2361: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2362: VMOVDQU64 ZMM7, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_2363: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2364: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2365: VPBROADCASTQ ZMM6, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_2366: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2367: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2368: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2369: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2370: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2371: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2372: VMOVDQU64 ZMM7, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_2373: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2374: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2375: VPBROADCASTQ ZMM6, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_2376: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2377: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2378: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2379: VMOVDQU64 ZMM7, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2380: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2381: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2382: VMOVDQU64 ZMM7, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_2383: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2384: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2385: VPBROADCASTQ ZMM6, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_2386: VMOVDQU64 ZMM7, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2387: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2388: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2389: VMOVDQU64 ZMM7, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2390: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2391: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2392: VMOVDQU64 ZMM7, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_2393: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2394: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2395: VPBROADCASTQ ZMM6, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_2396: VMOVDQU64 ZMM7, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2397: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2398: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2399: VMOVDQU64 ZMM7, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2400: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2401: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2402: VMOVDQU64 ZMM7, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_2403: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2404: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2405: VPBROADCASTQ ZMM6, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_2406: VMOVDQU64 ZMM7, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2407: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2408: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2409: VMOVDQU64 ZMM7, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2410: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2411: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2412: VMOVDQU64 ZMM7, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_2413: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2414: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2415: VPBROADCASTQ ZMM6, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_2416: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2417: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2418: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2419: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2420: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2421: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2422: VPBROADCASTQ ZMM6, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_2423: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2424: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2425: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2426: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2427: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2428: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2429: VPBROADCASTQ ZMM6, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_2430: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2431: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2432: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2433: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2434: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2435: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2436: VPBROADCASTQ ZMM6, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_2437: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2438: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2439: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2440: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2441: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2442: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2443: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2444: VPXORQ ZMM8, ZMM8, ZMM8  # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2445: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2446: VPERMI2Q ZMM6, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_2447: VPADDQ ZMM2, ZMM2, ZMM6  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_2448: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2449: VPERMI2Q ZMM6, ZMM3, ZMM4 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_2450: VPADDQ ZMM1, ZMM1, ZMM6  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_2451: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2452: VPERMI2Q ZMM6, ZMM8, ZMM3 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_2453: VPADDQ ZMM0, ZMM0, ZMM6  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_2454: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_2455: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2456: VPXORQ ZMM5, ZMM5, ZMM5  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2457: _avx512_label_100:       # apply_carry:429          _avx512_label_100:
avx512_Xx_2458: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2459: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_2460: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2461: VPANDNQ ZMM2, ZMM3, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_2462: VPADDQ ZMM2, ZMM2, ZMM7  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_2463: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_2464: VMOVDQA64 ZMM6, ZMM2     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_2
avx512_Xx_2465: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2466: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_2467: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2468: VPANDNQ ZMM1, ZMM3, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_2469: VPADDQ ZMM1, ZMM1, ZMM7  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_2470: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_2471: VPORQ ZMM6, ZMM6, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_2472: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2473: VPERMI2Q ZMM7, ZMM5, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_2474: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2475: VPANDNQ ZMM0, ZMM3, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_2476: VPADDQ ZMM0, ZMM0, ZMM7  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_2477: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_2478: VPORQ ZMM6, ZMM6, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_2479: VMOVDQU64 [R8-64], ZMM5  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_2480: VMOVDQU64 [R8+192], ZMM5 # apply_carry:460          VMOVDQU64 [`in_data+192], `zero_vector
avx512_Xx_2481: VPTESTMQ k1, ZMM6, ZMM3  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_2482: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_2483: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_2484: JNZ _avx512_label_100    # apply_carry:466          JNZ _avx512_label_100
avx512_Xx_2485: _avx512_label_101:       # ~asm_function:121        _avx512_label_101:
avx512_Xx_2486: RET                      # ~asm_function:130        RET
avx512_Xx_2487: .global asm_avx512_func_multiply_12_21_31 # asm_function:74          .global asm_avx512_func_multiply_12_21_31
avx512_Xx_2488: asm_avx512_func_multiply_12_21_31: # asm_function:75          asm_avx512_func_multiply_12_21_31:
avx512_Xx_2489: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_2490: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_2491: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_2492: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_2493: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_2494: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_2495: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_2496: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_2497: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:690             VPXORQ `out_registers_low_3, `out_registers_low_3, `out_registers_low_3
avx512_Xx_2498: VPXORQ ZMM7, ZMM7, ZMM7  # multiply:691             VPXORQ `out_registers_high_3, `out_registers_high_3, `out_registers_high_3
avx512_Xx_2499: VPBROADCASTQ ZMM8, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_2500: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2501: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2502: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2503: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2504: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2505: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2506: VMOVDQU64 ZMM9, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_2507: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2508: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2509: VPBROADCASTQ ZMM8, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_2510: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2511: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2512: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2513: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2514: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2515: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2516: VMOVDQU64 ZMM9, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_2517: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2518: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2519: VPBROADCASTQ ZMM8, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_2520: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2521: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2522: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2523: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2524: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2525: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2526: VMOVDQU64 ZMM9, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_2527: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2528: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2529: VPBROADCASTQ ZMM8, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_2530: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2531: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2532: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2533: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2534: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2535: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2536: VMOVDQU64 ZMM9, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_2537: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2538: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2539: VPBROADCASTQ ZMM8, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_2540: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2541: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2542: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2543: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2544: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2545: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2546: VMOVDQU64 ZMM9, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_2547: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2548: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2549: VMOVDQU64 ZMM9, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_2550: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2551: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2552: VPBROADCASTQ ZMM8, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_2553: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2554: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2555: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2556: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2557: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2558: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2559: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_2560: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2561: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2562: VMOVDQU64 ZMM9, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_2563: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2564: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2565: VPBROADCASTQ ZMM8, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_2566: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2567: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2568: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2569: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2570: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2571: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2572: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_2573: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2574: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2575: VMOVDQU64 ZMM9, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_2576: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2577: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2578: VPBROADCASTQ ZMM8, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_2579: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2580: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2581: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2582: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2583: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2584: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2585: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_2586: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2587: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2588: VMOVDQU64 ZMM9, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_2589: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2590: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2591: VPBROADCASTQ ZMM8, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_2592: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2593: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2594: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2595: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2596: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2597: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2598: VMOVDQU64 ZMM9, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_2599: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2600: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2601: VPBROADCASTQ ZMM8, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_2602: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2603: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2604: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2605: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2606: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2607: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2608: VMOVDQU64 ZMM9, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_2609: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2610: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2611: VPBROADCASTQ ZMM8, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_2612: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2613: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2614: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2615: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2616: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2617: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2618: VMOVDQU64 ZMM9, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_2619: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2620: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2621: VPBROADCASTQ ZMM8, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_2622: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2623: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2624: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2625: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2626: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2627: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2628: VMOVDQU64 ZMM9, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_2629: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_2630: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_2631: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2632: VPXORQ ZMM10, ZMM10, ZMM10 # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2633: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2634: VPERMI2Q ZMM8, ZMM6, ZMM7 # multiply:723             VPERMI2Q `a, `out_registers_high_2, `out_registers_high_3
avx512_Xx_2635: VPADDQ ZMM3, ZMM3, ZMM8  # multiply:726             VPADDQ `out_registers_low_3, `out_registers_low_3, `a
avx512_Xx_2636: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2637: VPERMI2Q ZMM8, ZMM5, ZMM6 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_2638: VPADDQ ZMM2, ZMM2, ZMM8  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_2639: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2640: VPERMI2Q ZMM8, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_2641: VPADDQ ZMM1, ZMM1, ZMM8  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_2642: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2643: VPERMI2Q ZMM8, ZMM10, ZMM4 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_2644: VPADDQ ZMM0, ZMM0, ZMM8  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_2645: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_2646: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2647: VPXORQ ZMM6, ZMM6, ZMM6  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2648: _avx512_label_102:       # apply_carry:429          _avx512_label_102:
avx512_Xx_2649: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2650: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_2651: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2652: VPANDNQ ZMM3, ZMM4, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_2653: VPADDQ ZMM3, ZMM3, ZMM8  # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_2654: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_2655: VMOVDQA64 ZMM7, ZMM3     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_3
avx512_Xx_2656: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2657: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_2658: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2659: VPANDNQ ZMM2, ZMM4, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_2660: VPADDQ ZMM2, ZMM2, ZMM8  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_2661: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_2662: VPORQ ZMM7, ZMM7, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_2663: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2664: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_2665: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2666: VPANDNQ ZMM1, ZMM4, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_2667: VPADDQ ZMM1, ZMM1, ZMM8  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_2668: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_2669: VPORQ ZMM7, ZMM7, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_2670: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2671: VPERMI2Q ZMM8, ZMM6, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_2672: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2673: VPANDNQ ZMM0, ZMM4, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_2674: VPADDQ ZMM0, ZMM0, ZMM8  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_2675: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_2676: VPORQ ZMM7, ZMM7, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_2677: VMOVDQU64 [R8-64], ZMM6  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_2678: VMOVDQU64 [R8+256], ZMM6 # apply_carry:460          VMOVDQU64 [`in_data+256], `zero_vector
avx512_Xx_2679: VPTESTMQ k1, ZMM7, ZMM4  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_2680: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_2681: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_2682: JNZ _avx512_label_102    # apply_carry:466          JNZ _avx512_label_102
avx512_Xx_2683: _avx512_label_103:       # ~asm_function:121        _avx512_label_103:
avx512_Xx_2684: RET                      # ~asm_function:130        RET
avx512_Xx_2685: .global asm_avx512_func_multiply_21_12_21 # asm_function:74          .global asm_avx512_func_multiply_21_12_21
avx512_Xx_2686: asm_avx512_func_multiply_21_12_21: # asm_function:75          asm_avx512_func_multiply_21_12_21:
avx512_Xx_2687: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_2688: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_2689: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_2690: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_2691: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_2692: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_2693: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_2694: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_2695: VPBROADCASTQ ZMM6, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_2696: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2697: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2698: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2699: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2700: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2701: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2702: VPBROADCASTQ ZMM6, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_2703: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2704: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2705: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2706: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2707: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2708: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2709: VPBROADCASTQ ZMM6, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_2710: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2711: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2712: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2713: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2714: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2715: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2716: VPBROADCASTQ ZMM6, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_2717: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2718: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2719: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2720: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2721: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2722: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2723: VPBROADCASTQ ZMM6, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_2724: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2725: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2726: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2727: VMOVDQU64 ZMM7, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2728: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2729: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2730: VPBROADCASTQ ZMM6, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_2731: VMOVDQU64 ZMM7, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2732: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2733: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2734: VMOVDQU64 ZMM7, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2735: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2736: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2737: VMOVDQU64 ZMM7, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_2738: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2739: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2740: VPBROADCASTQ ZMM6, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_2741: VMOVDQU64 ZMM7, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2742: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2743: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2744: VMOVDQU64 ZMM7, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2745: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2746: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2747: VMOVDQU64 ZMM7, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_2748: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2749: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2750: VPBROADCASTQ ZMM6, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_2751: VMOVDQU64 ZMM7, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2752: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2753: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2754: VMOVDQU64 ZMM7, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2755: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2756: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2757: VMOVDQU64 ZMM7, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_2758: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2759: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2760: VPBROADCASTQ ZMM6, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_2761: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2762: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2763: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2764: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2765: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2766: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2767: VPBROADCASTQ ZMM6, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_2768: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2769: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2770: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2771: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2772: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2773: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2774: VPBROADCASTQ ZMM6, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_2775: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2776: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2777: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2778: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2779: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2780: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2781: VPBROADCASTQ ZMM6, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_2782: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2783: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2784: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2785: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2786: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2787: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2788: VPBROADCASTQ ZMM6, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_2789: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2790: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2791: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2792: VMOVDQU64 ZMM7, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2793: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2794: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2795: VPBROADCASTQ ZMM6, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_2796: VMOVDQU64 ZMM7, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2797: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2798: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2799: VMOVDQU64 ZMM7, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2800: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2801: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2802: VPBROADCASTQ ZMM6, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_2803: VMOVDQU64 ZMM7, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2804: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2805: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2806: VMOVDQU64 ZMM7, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2807: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2808: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2809: VPBROADCASTQ ZMM6, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_2810: VMOVDQU64 ZMM7, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2811: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2812: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2813: VMOVDQU64 ZMM7, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2814: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2815: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2816: VPBROADCASTQ ZMM6, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_2817: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2818: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2819: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2820: VPBROADCASTQ ZMM6, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_2821: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2822: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2823: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2824: VPBROADCASTQ ZMM6, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_2825: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2826: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2827: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2828: VPBROADCASTQ ZMM6, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_2829: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2830: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2831: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2832: VPBROADCASTQ ZMM6, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_2833: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2834: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2835: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2836: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2837: VPXORQ ZMM8, ZMM8, ZMM8  # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2838: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2839: VPERMI2Q ZMM6, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_2840: VPADDQ ZMM2, ZMM2, ZMM6  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_2841: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2842: VPERMI2Q ZMM6, ZMM3, ZMM4 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_2843: VPADDQ ZMM1, ZMM1, ZMM6  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_2844: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_2845: VPERMI2Q ZMM6, ZMM8, ZMM3 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_2846: VPADDQ ZMM0, ZMM0, ZMM6  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_2847: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_2848: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_2849: VPXORQ ZMM5, ZMM5, ZMM5  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_2850: _avx512_label_104:       # apply_carry:429          _avx512_label_104:
avx512_Xx_2851: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2852: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_2853: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2854: VPANDNQ ZMM2, ZMM3, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_2855: VPADDQ ZMM2, ZMM2, ZMM7  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_2856: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_2857: VMOVDQA64 ZMM6, ZMM2     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_2
avx512_Xx_2858: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2859: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_2860: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2861: VPANDNQ ZMM1, ZMM3, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_2862: VPADDQ ZMM1, ZMM1, ZMM7  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_2863: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_2864: VPORQ ZMM6, ZMM6, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_2865: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_2866: VPERMI2Q ZMM7, ZMM5, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_2867: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_2868: VPANDNQ ZMM0, ZMM3, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_2869: VPADDQ ZMM0, ZMM0, ZMM7  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_2870: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_2871: VPORQ ZMM6, ZMM6, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_2872: VMOVDQU64 [R8-64], ZMM5  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_2873: VMOVDQU64 [R8+192], ZMM5 # apply_carry:460          VMOVDQU64 [`in_data+192], `zero_vector
avx512_Xx_2874: VPTESTMQ k1, ZMM6, ZMM3  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_2875: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_2876: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_2877: JNZ _avx512_label_104    # apply_carry:466          JNZ _avx512_label_104
avx512_Xx_2878: _avx512_label_105:       # ~asm_function:121        _avx512_label_105:
avx512_Xx_2879: RET                      # ~asm_function:130        RET
avx512_Xx_2880: .global asm_avx512_func_multiply_21_21_21 # asm_function:74          .global asm_avx512_func_multiply_21_21_21
avx512_Xx_2881: asm_avx512_func_multiply_21_21_21: # asm_function:75          asm_avx512_func_multiply_21_21_21:
avx512_Xx_2882: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_2883: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_2884: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_2885: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_2886: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_2887: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_2888: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_2889: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_2890: VPBROADCASTQ ZMM6, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_2891: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2892: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2893: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2894: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2895: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2896: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2897: VMOVDQU64 ZMM7, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_2898: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2899: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2900: VPBROADCASTQ ZMM6, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_2901: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2902: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2903: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2904: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2905: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2906: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2907: VMOVDQU64 ZMM7, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_2908: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2909: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2910: VPBROADCASTQ ZMM6, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_2911: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2912: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2913: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2914: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2915: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2916: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2917: VMOVDQU64 ZMM7, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_2918: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2919: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2920: VPBROADCASTQ ZMM6, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_2921: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2922: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2923: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2924: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2925: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2926: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2927: VMOVDQU64 ZMM7, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_2928: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2929: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2930: VPBROADCASTQ ZMM6, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_2931: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_2932: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2933: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2934: VMOVDQU64 ZMM7, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_2935: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2936: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2937: VMOVDQU64 ZMM7, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_2938: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2939: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2940: VPBROADCASTQ ZMM6, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_2941: VMOVDQU64 ZMM7, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_2942: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2943: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2944: VMOVDQU64 ZMM7, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_2945: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2946: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2947: VMOVDQU64 ZMM7, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_2948: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2949: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2950: VPBROADCASTQ ZMM6, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_2951: VMOVDQU64 ZMM7, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_2952: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2953: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2954: VMOVDQU64 ZMM7, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_2955: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2956: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2957: VMOVDQU64 ZMM7, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_2958: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2959: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2960: VPBROADCASTQ ZMM6, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_2961: VMOVDQU64 ZMM7, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_2962: VPMADD52LUQ ZMM0, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_2963: VPMADD52HUQ ZMM3, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_2964: VMOVDQU64 ZMM7, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_2965: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2966: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2967: VMOVDQU64 ZMM7, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_2968: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2969: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2970: VPBROADCASTQ ZMM6, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_2971: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_2972: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2973: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2974: VMOVDQU64 ZMM7, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_2975: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2976: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2977: VPBROADCASTQ ZMM6, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_2978: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_2979: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2980: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2981: VMOVDQU64 ZMM7, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_2982: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2983: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2984: VPBROADCASTQ ZMM6, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_2985: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_2986: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2987: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2988: VMOVDQU64 ZMM7, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_2989: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2990: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2991: VPBROADCASTQ ZMM6, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_2992: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_2993: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_2994: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_2995: VMOVDQU64 ZMM7, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_2996: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_2997: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_2998: VPBROADCASTQ ZMM6, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_2999: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3000: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3001: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3002: VMOVDQU64 ZMM7, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3003: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3004: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3005: VPBROADCASTQ ZMM6, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_3006: VMOVDQU64 ZMM7, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3007: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3008: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3009: VMOVDQU64 ZMM7, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3010: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3011: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3012: VPBROADCASTQ ZMM6, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_3013: VMOVDQU64 ZMM7, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3014: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3015: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3016: VMOVDQU64 ZMM7, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3017: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3018: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3019: VPBROADCASTQ ZMM6, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_3020: VMOVDQU64 ZMM7, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3021: VPMADD52LUQ ZMM1, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3022: VPMADD52HUQ ZMM4, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3023: VMOVDQU64 ZMM7, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3024: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3025: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3026: VPBROADCASTQ ZMM6, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_3027: VMOVDQU64 ZMM7, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3028: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3029: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3030: VPBROADCASTQ ZMM6, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_3031: VMOVDQU64 ZMM7, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3032: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3033: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3034: VPBROADCASTQ ZMM6, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_3035: VMOVDQU64 ZMM7, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3036: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3037: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3038: VPBROADCASTQ ZMM6, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_3039: VMOVDQU64 ZMM7, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3040: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3041: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3042: VPBROADCASTQ ZMM6, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_3043: VMOVDQU64 ZMM7, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3044: VPMADD52LUQ ZMM2, ZMM6, ZMM7 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3045: VPMADD52HUQ ZMM5, ZMM6, ZMM7 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3046: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3047: VPXORQ ZMM8, ZMM8, ZMM8  # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3048: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3049: VPERMI2Q ZMM6, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_3050: VPADDQ ZMM2, ZMM2, ZMM6  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_3051: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3052: VPERMI2Q ZMM6, ZMM3, ZMM4 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_3053: VPADDQ ZMM1, ZMM1, ZMM6  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_3054: VMOVDQU64 ZMM6, ZMM7     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3055: VPERMI2Q ZMM6, ZMM8, ZMM3 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_3056: VPADDQ ZMM0, ZMM0, ZMM6  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_3057: VMOVDQU64 ZMM3, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_3058: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3059: VPXORQ ZMM5, ZMM5, ZMM5  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3060: _avx512_label_106:       # apply_carry:429          _avx512_label_106:
avx512_Xx_3061: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3062: VPERMI2Q ZMM7, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_3063: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3064: VPANDNQ ZMM2, ZMM3, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_3065: VPADDQ ZMM2, ZMM2, ZMM7  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_3066: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_3067: VMOVDQA64 ZMM6, ZMM2     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_2
avx512_Xx_3068: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3069: VPERMI2Q ZMM7, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_3070: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3071: VPANDNQ ZMM1, ZMM3, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_3072: VPADDQ ZMM1, ZMM1, ZMM7  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_3073: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_3074: VPORQ ZMM6, ZMM6, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_3075: VMOVDQU64 ZMM7, ZMM4     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3076: VPERMI2Q ZMM7, ZMM5, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_3077: VPSRAQ ZMM7, ZMM7, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3078: VPANDNQ ZMM0, ZMM3, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_3079: VPADDQ ZMM0, ZMM0, ZMM7  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_3080: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_3081: VPORQ ZMM6, ZMM6, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_3082: VMOVDQU64 [R8-64], ZMM5  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_3083: VMOVDQU64 [R8+192], ZMM5 # apply_carry:460          VMOVDQU64 [`in_data+192], `zero_vector
avx512_Xx_3084: VPTESTMQ k1, ZMM6, ZMM3  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_3085: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_3086: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_3087: JNZ _avx512_label_106    # apply_carry:466          JNZ _avx512_label_106
avx512_Xx_3088: _avx512_label_107:       # ~asm_function:121        _avx512_label_107:
avx512_Xx_3089: RET                      # ~asm_function:130        RET
avx512_Xx_3090: .global asm_avx512_func_multiply_21_21_31 # asm_function:74          .global asm_avx512_func_multiply_21_21_31
avx512_Xx_3091: asm_avx512_func_multiply_21_21_31: # asm_function:75          asm_avx512_func_multiply_21_21_31:
avx512_Xx_3092: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_3093: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_3094: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_3095: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_3096: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_3097: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_3098: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_3099: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_3100: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:690             VPXORQ `out_registers_low_3, `out_registers_low_3, `out_registers_low_3
avx512_Xx_3101: VPXORQ ZMM7, ZMM7, ZMM7  # multiply:691             VPXORQ `out_registers_high_3, `out_registers_high_3, `out_registers_high_3
avx512_Xx_3102: VPBROADCASTQ ZMM8, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_3103: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3104: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3105: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3106: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3107: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3108: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3109: VMOVDQU64 ZMM9, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3110: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3111: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3112: VPBROADCASTQ ZMM8, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_3113: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3114: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3115: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3116: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3117: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3118: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3119: VMOVDQU64 ZMM9, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3120: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3121: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3122: VPBROADCASTQ ZMM8, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_3123: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3124: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3125: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3126: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3127: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3128: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3129: VMOVDQU64 ZMM9, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3130: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3131: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3132: VPBROADCASTQ ZMM8, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_3133: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3134: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3135: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3136: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3137: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3138: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3139: VMOVDQU64 ZMM9, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3140: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3141: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3142: VPBROADCASTQ ZMM8, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_3143: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3144: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3145: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3146: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3147: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3148: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3149: VMOVDQU64 ZMM9, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3150: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3151: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3152: VMOVDQU64 ZMM9, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_3153: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3154: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3155: VPBROADCASTQ ZMM8, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_3156: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3157: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3158: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3159: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3160: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3161: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3162: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_3163: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3164: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3165: VMOVDQU64 ZMM9, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_3166: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3167: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3168: VPBROADCASTQ ZMM8, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_3169: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3170: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3171: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3172: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3173: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3174: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3175: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_3176: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3177: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3178: VMOVDQU64 ZMM9, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_3179: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3180: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3181: VPBROADCASTQ ZMM8, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_3182: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3183: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3184: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3185: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3186: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3187: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3188: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_3189: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3190: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3191: VMOVDQU64 ZMM9, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_3192: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3193: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3194: VPBROADCASTQ ZMM8, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_3195: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3196: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3197: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3198: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3199: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3200: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3201: VMOVDQU64 ZMM9, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3202: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3203: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3204: VPBROADCASTQ ZMM8, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_3205: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3206: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3207: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3208: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3209: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3210: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3211: VMOVDQU64 ZMM9, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3212: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3213: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3214: VPBROADCASTQ ZMM8, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_3215: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3216: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3217: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3218: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3219: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3220: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3221: VMOVDQU64 ZMM9, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3222: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3223: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3224: VPBROADCASTQ ZMM8, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_3225: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3226: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3227: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3228: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3229: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3230: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3231: VMOVDQU64 ZMM9, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3232: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3233: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3234: VPBROADCASTQ ZMM8, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_3235: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3236: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3237: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3238: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3239: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3240: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3241: VMOVDQU64 ZMM9, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3242: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3243: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3244: VPBROADCASTQ ZMM8, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_3245: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3246: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3247: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3248: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3249: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3250: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3251: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_3252: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3253: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3254: VPBROADCASTQ ZMM8, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_3255: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3256: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3257: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3258: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3259: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3260: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3261: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_3262: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3263: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3264: VPBROADCASTQ ZMM8, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_3265: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3266: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3267: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3268: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3269: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3270: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3271: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_3272: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3273: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3274: VPBROADCASTQ ZMM8, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_3275: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3276: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3277: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3278: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3279: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3280: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3281: VPBROADCASTQ ZMM8, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_3282: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3283: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3284: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3285: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3286: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3287: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3288: VPBROADCASTQ ZMM8, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_3289: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3290: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3291: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3292: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3293: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3294: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3295: VPBROADCASTQ ZMM8, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_3296: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3297: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3298: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3299: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3300: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3301: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3302: VPBROADCASTQ ZMM8, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_3303: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3304: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3305: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3306: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3307: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3308: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3309: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3310: VPXORQ ZMM10, ZMM10, ZMM10 # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3311: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3312: VPERMI2Q ZMM8, ZMM6, ZMM7 # multiply:723             VPERMI2Q `a, `out_registers_high_2, `out_registers_high_3
avx512_Xx_3313: VPADDQ ZMM3, ZMM3, ZMM8  # multiply:726             VPADDQ `out_registers_low_3, `out_registers_low_3, `a
avx512_Xx_3314: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3315: VPERMI2Q ZMM8, ZMM5, ZMM6 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_3316: VPADDQ ZMM2, ZMM2, ZMM8  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_3317: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3318: VPERMI2Q ZMM8, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_3319: VPADDQ ZMM1, ZMM1, ZMM8  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_3320: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3321: VPERMI2Q ZMM8, ZMM10, ZMM4 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_3322: VPADDQ ZMM0, ZMM0, ZMM8  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_3323: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_3324: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3325: VPXORQ ZMM6, ZMM6, ZMM6  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3326: _avx512_label_108:       # apply_carry:429          _avx512_label_108:
avx512_Xx_3327: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3328: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_3329: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3330: VPANDNQ ZMM3, ZMM4, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_3331: VPADDQ ZMM3, ZMM3, ZMM8  # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_3332: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_3333: VMOVDQA64 ZMM7, ZMM3     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_3
avx512_Xx_3334: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3335: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_3336: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3337: VPANDNQ ZMM2, ZMM4, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_3338: VPADDQ ZMM2, ZMM2, ZMM8  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_3339: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_3340: VPORQ ZMM7, ZMM7, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_3341: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3342: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_3343: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3344: VPANDNQ ZMM1, ZMM4, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_3345: VPADDQ ZMM1, ZMM1, ZMM8  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_3346: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_3347: VPORQ ZMM7, ZMM7, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_3348: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3349: VPERMI2Q ZMM8, ZMM6, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_3350: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3351: VPANDNQ ZMM0, ZMM4, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_3352: VPADDQ ZMM0, ZMM0, ZMM8  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_3353: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_3354: VPORQ ZMM7, ZMM7, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_3355: VMOVDQU64 [R8-64], ZMM6  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_3356: VMOVDQU64 [R8+256], ZMM6 # apply_carry:460          VMOVDQU64 [`in_data+256], `zero_vector
avx512_Xx_3357: VPTESTMQ k1, ZMM7, ZMM4  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_3358: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_3359: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_3360: JNZ _avx512_label_108    # apply_carry:466          JNZ _avx512_label_108
avx512_Xx_3361: _avx512_label_109:       # ~asm_function:121        _avx512_label_109:
avx512_Xx_3362: RET                      # ~asm_function:130        RET
avx512_Xx_3363: .global asm_avx512_func_multiply_21_21_41 # asm_function:74          .global asm_avx512_func_multiply_21_21_41
avx512_Xx_3364: asm_avx512_func_multiply_21_21_41: # asm_function:75          asm_avx512_func_multiply_21_21_41:
avx512_Xx_3365: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_3366: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_3367: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_3368: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_3369: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_3370: VPXORQ ZMM7, ZMM7, ZMM7  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_3371: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_3372: VPXORQ ZMM8, ZMM8, ZMM8  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_3373: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:690             VPXORQ `out_registers_low_3, `out_registers_low_3, `out_registers_low_3
avx512_Xx_3374: VPXORQ ZMM9, ZMM9, ZMM9  # multiply:691             VPXORQ `out_registers_high_3, `out_registers_high_3, `out_registers_high_3
avx512_Xx_3375: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:690             VPXORQ `out_registers_low_4, `out_registers_low_4, `out_registers_low_4
avx512_Xx_3376: VPXORQ ZMM10, ZMM10, ZMM10 # multiply:691             VPXORQ `out_registers_high_4, `out_registers_high_4, `out_registers_high_4
avx512_Xx_3377: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:690             VPXORQ `out_registers_low_5, `out_registers_low_5, `out_registers_low_5
avx512_Xx_3378: VPXORQ ZMM11, ZMM11, ZMM11 # multiply:691             VPXORQ `out_registers_high_5, `out_registers_high_5, `out_registers_high_5
avx512_Xx_3379: VPBROADCASTQ ZMM12, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_3380: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3381: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3382: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3383: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3384: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3385: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3386: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3387: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3388: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3389: VPBROADCASTQ ZMM12, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_3390: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3391: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3392: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3393: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3394: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3395: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3396: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3397: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3398: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3399: VPBROADCASTQ ZMM12, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_3400: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3401: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3402: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3403: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3404: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3405: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3406: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3407: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3408: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3409: VPBROADCASTQ ZMM12, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_3410: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3411: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3412: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3413: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3414: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3415: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3416: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3417: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3418: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3419: VPBROADCASTQ ZMM12, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_3420: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3421: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3422: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3423: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3424: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3425: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3426: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3427: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3428: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3429: VMOVDQU64 ZMM13, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_3430: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3431: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3432: VPBROADCASTQ ZMM12, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_3433: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3434: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3435: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3436: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3437: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3438: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3439: VMOVDQU64 ZMM13, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_3440: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3441: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3442: VMOVDQU64 ZMM13, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_3443: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3444: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3445: VPBROADCASTQ ZMM12, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_3446: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3447: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3448: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3449: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3450: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3451: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3452: VMOVDQU64 ZMM13, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_3453: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3454: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3455: VMOVDQU64 ZMM13, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_3456: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3457: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3458: VPBROADCASTQ ZMM12, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_3459: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3460: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3461: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3462: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3463: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3464: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3465: VMOVDQU64 ZMM13, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_3466: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3467: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3468: VMOVDQU64 ZMM13, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_3469: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3470: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3471: VPBROADCASTQ ZMM12, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_3472: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3473: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3474: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3475: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3476: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3477: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3478: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3479: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3480: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3481: VPBROADCASTQ ZMM12, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_3482: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3483: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3484: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3485: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3486: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3487: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3488: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3489: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3490: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3491: VPBROADCASTQ ZMM12, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_3492: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3493: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3494: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3495: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3496: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3497: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3498: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3499: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3500: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3501: VPBROADCASTQ ZMM12, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_3502: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3503: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3504: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3505: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3506: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3507: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3508: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3509: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3510: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3511: VPBROADCASTQ ZMM12, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_3512: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3513: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3514: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3515: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3516: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3517: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3518: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3519: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3520: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3521: VMOVDQU64 ZMM13, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_3522: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3523: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3524: VPBROADCASTQ ZMM12, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_3525: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3526: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3527: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3528: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3529: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3530: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3531: VMOVDQU64 ZMM13, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_3532: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3533: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3534: VMOVDQU64 ZMM13, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_3535: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3536: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3537: VPBROADCASTQ ZMM12, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_3538: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3539: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3540: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3541: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3542: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3543: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3544: VMOVDQU64 ZMM13, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_3545: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3546: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3547: VMOVDQU64 ZMM13, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_3548: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3549: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3550: VPBROADCASTQ ZMM12, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_3551: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3552: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3553: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3554: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3555: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3556: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3557: VMOVDQU64 ZMM13, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_3558: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3559: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3560: VMOVDQU64 ZMM13, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_3561: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3562: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3563: VPBROADCASTQ ZMM12, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_3564: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3565: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3566: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3567: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3568: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3569: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3570: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3571: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3572: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3573: VPBROADCASTQ ZMM12, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_3574: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3575: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3576: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3577: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3578: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3579: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3580: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3581: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3582: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3583: VPBROADCASTQ ZMM12, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_3584: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3585: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3586: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3587: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3588: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3589: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3590: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3591: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3592: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3593: VPBROADCASTQ ZMM12, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_3594: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3595: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3596: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3597: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3598: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3599: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3600: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3601: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3602: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3603: VPBROADCASTQ ZMM12, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_3604: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3605: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3606: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3607: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3608: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3609: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3610: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3611: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_3612: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_3613: VMOVDQU64 ZMM13, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_3614: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_3615: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_3616: VMOVDQU64 ZMM13, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3617: VPXORQ ZMM14, ZMM14, ZMM14 # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3618: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3619: VPERMI2Q ZMM12, ZMM10, ZMM11 # multiply:723             VPERMI2Q `a, `out_registers_high_4, `out_registers_high_5
avx512_Xx_3620: VPADDQ ZMM5, ZMM5, ZMM12 # multiply:726             VPADDQ `out_registers_low_5, `out_registers_low_5, `a
avx512_Xx_3621: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3622: VPERMI2Q ZMM12, ZMM9, ZMM10 # multiply:723             VPERMI2Q `a, `out_registers_high_3, `out_registers_high_4
avx512_Xx_3623: VPADDQ ZMM4, ZMM4, ZMM12 # multiply:726             VPADDQ `out_registers_low_4, `out_registers_low_4, `a
avx512_Xx_3624: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3625: VPERMI2Q ZMM12, ZMM8, ZMM9 # multiply:723             VPERMI2Q `a, `out_registers_high_2, `out_registers_high_3
avx512_Xx_3626: VPADDQ ZMM3, ZMM3, ZMM12 # multiply:726             VPADDQ `out_registers_low_3, `out_registers_low_3, `a
avx512_Xx_3627: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3628: VPERMI2Q ZMM12, ZMM7, ZMM8 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_3629: VPADDQ ZMM2, ZMM2, ZMM12 # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_3630: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3631: VPERMI2Q ZMM12, ZMM6, ZMM7 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_3632: VPADDQ ZMM1, ZMM1, ZMM12 # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_3633: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3634: VPERMI2Q ZMM12, ZMM14, ZMM6 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_3635: VPADDQ ZMM0, ZMM0, ZMM12 # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_3636: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_3637: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3638: VPXORQ ZMM8, ZMM8, ZMM8  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3639: _avx512_label_110:       # apply_carry:429          _avx512_label_110:
avx512_Xx_3640: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3641: VPERMI2Q ZMM10, ZMM4, ZMM5 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_4, `in_registers_5
avx512_Xx_3642: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3643: VPANDNQ ZMM5, ZMM6, ZMM5 # apply_carry:442          VPANDNQ `in_registers_5, `carry_mask, `in_registers_5
avx512_Xx_3644: VPADDQ ZMM5, ZMM5, ZMM10 # apply_carry:445          VPADDQ `in_registers_5, `in_registers_5, `temp_vector
avx512_Xx_3645: VMOVDQU64 [R8+320], ZMM5 # apply_carry:448          VMOVDQU64 [`in_data+320], `in_registers_5
avx512_Xx_3646: VMOVDQA64 ZMM9, ZMM5     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_5
avx512_Xx_3647: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3648: VPERMI2Q ZMM10, ZMM3, ZMM4 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_3, `in_registers_4
avx512_Xx_3649: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3650: VPANDNQ ZMM4, ZMM6, ZMM4 # apply_carry:442          VPANDNQ `in_registers_4, `carry_mask, `in_registers_4
avx512_Xx_3651: VPADDQ ZMM4, ZMM4, ZMM10 # apply_carry:445          VPADDQ `in_registers_4, `in_registers_4, `temp_vector
avx512_Xx_3652: VMOVDQU64 [R8+256], ZMM4 # apply_carry:448          VMOVDQU64 [`in_data+256], `in_registers_4
avx512_Xx_3653: VPORQ ZMM9, ZMM9, ZMM4   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_4
avx512_Xx_3654: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3655: VPERMI2Q ZMM10, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_3656: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3657: VPANDNQ ZMM3, ZMM6, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_3658: VPADDQ ZMM3, ZMM3, ZMM10 # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_3659: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_3660: VPORQ ZMM9, ZMM9, ZMM3   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_3
avx512_Xx_3661: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3662: VPERMI2Q ZMM10, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_3663: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3664: VPANDNQ ZMM2, ZMM6, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_3665: VPADDQ ZMM2, ZMM2, ZMM10 # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_3666: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_3667: VPORQ ZMM9, ZMM9, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_3668: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3669: VPERMI2Q ZMM10, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_3670: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3671: VPANDNQ ZMM1, ZMM6, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_3672: VPADDQ ZMM1, ZMM1, ZMM10 # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_3673: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_3674: VPORQ ZMM9, ZMM9, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_3675: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3676: VPERMI2Q ZMM10, ZMM8, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_3677: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3678: VPANDNQ ZMM0, ZMM6, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_3679: VPADDQ ZMM0, ZMM0, ZMM10 # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_3680: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_3681: VPORQ ZMM9, ZMM9, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_3682: VMOVDQU64 [R8-64], ZMM8  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_3683: VMOVDQU64 [R8+384], ZMM8 # apply_carry:460          VMOVDQU64 [`in_data+384], `zero_vector
avx512_Xx_3684: VPTESTMQ k1, ZMM9, ZMM6  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_3685: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_3686: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_3687: JNZ _avx512_label_110    # apply_carry:466          JNZ _avx512_label_110
avx512_Xx_3688: _avx512_label_111:       # ~asm_function:121        _avx512_label_111:
avx512_Xx_3689: RET                      # ~asm_function:130        RET
avx512_Xx_3690: .global asm_avx512_func_multiply_31_31_31 # asm_function:74          .global asm_avx512_func_multiply_31_31_31
avx512_Xx_3691: asm_avx512_func_multiply_31_31_31: # asm_function:75          asm_avx512_func_multiply_31_31_31:
avx512_Xx_3692: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_3693: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_3694: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_3695: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_3696: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_3697: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_3698: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_3699: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_3700: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:690             VPXORQ `out_registers_low_3, `out_registers_low_3, `out_registers_low_3
avx512_Xx_3701: VPXORQ ZMM7, ZMM7, ZMM7  # multiply:691             VPXORQ `out_registers_high_3, `out_registers_high_3, `out_registers_high_3
avx512_Xx_3702: VPBROADCASTQ ZMM8, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_3703: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3704: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3705: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3706: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3707: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3708: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3709: VMOVDQU64 ZMM9, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3710: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3711: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3712: VMOVDQU64 ZMM9, [RCX+192] # multiply:708             VMOVDQU64 `b, [`in_b_data+192]
avx512_Xx_3713: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3714: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3715: VPBROADCASTQ ZMM8, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_3716: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3717: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3718: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3719: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3720: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3721: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3722: VMOVDQU64 ZMM9, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3723: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3724: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3725: VMOVDQU64 ZMM9, [RCX+184] # multiply:708             VMOVDQU64 `b, [`in_b_data+184]
avx512_Xx_3726: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3727: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3728: VPBROADCASTQ ZMM8, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_3729: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3730: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3731: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3732: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3733: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3734: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3735: VMOVDQU64 ZMM9, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3736: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3737: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3738: VMOVDQU64 ZMM9, [RCX+176] # multiply:708             VMOVDQU64 `b, [`in_b_data+176]
avx512_Xx_3739: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3740: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3741: VPBROADCASTQ ZMM8, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_3742: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3743: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3744: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3745: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3746: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3747: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3748: VMOVDQU64 ZMM9, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3749: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3750: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3751: VMOVDQU64 ZMM9, [RCX+168] # multiply:708             VMOVDQU64 `b, [`in_b_data+168]
avx512_Xx_3752: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3753: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3754: VPBROADCASTQ ZMM8, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_3755: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3756: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3757: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3758: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3759: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3760: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3761: VMOVDQU64 ZMM9, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3762: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3763: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3764: VMOVDQU64 ZMM9, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_3765: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3766: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3767: VPBROADCASTQ ZMM8, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_3768: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3769: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3770: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3771: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3772: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3773: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3774: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_3775: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3776: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3777: VMOVDQU64 ZMM9, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_3778: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3779: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3780: VPBROADCASTQ ZMM8, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_3781: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3782: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3783: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3784: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3785: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3786: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3787: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_3788: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3789: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3790: VMOVDQU64 ZMM9, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_3791: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3792: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3793: VPBROADCASTQ ZMM8, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_3794: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3795: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_3796: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_3797: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3798: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3799: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3800: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_3801: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3802: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3803: VMOVDQU64 ZMM9, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_3804: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3805: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3806: VPBROADCASTQ ZMM8, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_3807: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3808: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3809: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3810: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3811: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3812: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3813: VMOVDQU64 ZMM9, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_3814: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3815: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3816: VPBROADCASTQ ZMM8, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_3817: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3818: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3819: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3820: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3821: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3822: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3823: VMOVDQU64 ZMM9, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_3824: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3825: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3826: VPBROADCASTQ ZMM8, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_3827: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3828: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3829: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3830: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3831: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3832: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3833: VMOVDQU64 ZMM9, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_3834: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3835: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3836: VPBROADCASTQ ZMM8, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_3837: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3838: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3839: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3840: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3841: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3842: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3843: VMOVDQU64 ZMM9, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_3844: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3845: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3846: VPBROADCASTQ ZMM8, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_3847: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3848: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3849: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3850: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3851: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3852: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3853: VMOVDQU64 ZMM9, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_3854: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3855: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3856: VPBROADCASTQ ZMM8, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_3857: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3858: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3859: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3860: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3861: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3862: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3863: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_3864: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3865: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3866: VPBROADCASTQ ZMM8, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_3867: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3868: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3869: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3870: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3871: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3872: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3873: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_3874: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3875: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3876: VPBROADCASTQ ZMM8, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_3877: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3878: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_3879: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_3880: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3881: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3882: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3883: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_3884: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3885: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3886: VPBROADCASTQ ZMM8, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_3887: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3888: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3889: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3890: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_3891: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3892: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3893: VPBROADCASTQ ZMM8, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_3894: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3895: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3896: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3897: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_3898: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3899: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3900: VPBROADCASTQ ZMM8, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_3901: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3902: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3903: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3904: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_3905: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3906: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3907: VPBROADCASTQ ZMM8, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_3908: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3909: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3910: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3911: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_3912: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3913: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3914: VPBROADCASTQ ZMM8, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_3915: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3916: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3917: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3918: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_3919: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3920: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3921: VPBROADCASTQ ZMM8, [RSI+168] # multiply:699             VPBROADCASTQ `a, [`in_a_data+168]
avx512_Xx_3922: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3923: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3924: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3925: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_3926: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3927: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3928: VPBROADCASTQ ZMM8, [RSI+176] # multiply:699             VPBROADCASTQ `a, [`in_a_data+176]
avx512_Xx_3929: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3930: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3931: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3932: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_3933: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3934: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3935: VPBROADCASTQ ZMM8, [RSI+184] # multiply:699             VPBROADCASTQ `a, [`in_a_data+184]
avx512_Xx_3936: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_3937: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_3938: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_3939: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_3940: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3941: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3942: VPBROADCASTQ ZMM8, [RSI+192] # multiply:699             VPBROADCASTQ `a, [`in_a_data+192]
avx512_Xx_3943: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_3944: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3945: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3946: VPBROADCASTQ ZMM8, [RSI+200] # multiply:699             VPBROADCASTQ `a, [`in_a_data+200]
avx512_Xx_3947: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_3948: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3949: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3950: VPBROADCASTQ ZMM8, [RSI+208] # multiply:699             VPBROADCASTQ `a, [`in_a_data+208]
avx512_Xx_3951: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_3952: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3953: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3954: VPBROADCASTQ ZMM8, [RSI+216] # multiply:699             VPBROADCASTQ `a, [`in_a_data+216]
avx512_Xx_3955: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_3956: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3957: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3958: VPBROADCASTQ ZMM8, [RSI+224] # multiply:699             VPBROADCASTQ `a, [`in_a_data+224]
avx512_Xx_3959: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_3960: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3961: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3962: VPBROADCASTQ ZMM8, [RSI+232] # multiply:699             VPBROADCASTQ `a, [`in_a_data+232]
avx512_Xx_3963: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_3964: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3965: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3966: VPBROADCASTQ ZMM8, [RSI+240] # multiply:699             VPBROADCASTQ `a, [`in_a_data+240]
avx512_Xx_3967: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_3968: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_3969: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_3970: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3971: VPXORQ ZMM10, ZMM10, ZMM10 # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3972: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3973: VPERMI2Q ZMM8, ZMM6, ZMM7 # multiply:723             VPERMI2Q `a, `out_registers_high_2, `out_registers_high_3
avx512_Xx_3974: VPADDQ ZMM3, ZMM3, ZMM8  # multiply:726             VPADDQ `out_registers_low_3, `out_registers_low_3, `a
avx512_Xx_3975: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3976: VPERMI2Q ZMM8, ZMM5, ZMM6 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_3977: VPADDQ ZMM2, ZMM2, ZMM8  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_3978: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3979: VPERMI2Q ZMM8, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_3980: VPADDQ ZMM1, ZMM1, ZMM8  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_3981: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_3982: VPERMI2Q ZMM8, ZMM10, ZMM4 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_3983: VPADDQ ZMM0, ZMM0, ZMM8  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_3984: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_3985: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_3986: VPXORQ ZMM6, ZMM6, ZMM6  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_3987: _avx512_label_112:       # apply_carry:429          _avx512_label_112:
avx512_Xx_3988: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3989: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_3990: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3991: VPANDNQ ZMM3, ZMM4, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_3992: VPADDQ ZMM3, ZMM3, ZMM8  # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_3993: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_3994: VMOVDQA64 ZMM7, ZMM3     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_3
avx512_Xx_3995: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_3996: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_3997: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_3998: VPANDNQ ZMM2, ZMM4, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_3999: VPADDQ ZMM2, ZMM2, ZMM8  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_4000: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_4001: VPORQ ZMM7, ZMM7, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_4002: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4003: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_4004: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4005: VPANDNQ ZMM1, ZMM4, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_4006: VPADDQ ZMM1, ZMM1, ZMM8  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_4007: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_4008: VPORQ ZMM7, ZMM7, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_4009: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4010: VPERMI2Q ZMM8, ZMM6, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_4011: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4012: VPANDNQ ZMM0, ZMM4, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_4013: VPADDQ ZMM0, ZMM0, ZMM8  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_4014: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_4015: VPORQ ZMM7, ZMM7, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_4016: VMOVDQU64 [R8-64], ZMM6  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_4017: VMOVDQU64 [R8+256], ZMM6 # apply_carry:460          VMOVDQU64 [`in_data+256], `zero_vector
avx512_Xx_4018: VPTESTMQ k1, ZMM7, ZMM4  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_4019: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_4020: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_4021: JNZ _avx512_label_112    # apply_carry:466          JNZ _avx512_label_112
avx512_Xx_4022: _avx512_label_113:       # ~asm_function:121        _avx512_label_113:
avx512_Xx_4023: RET                      # ~asm_function:130        RET
avx512_Xx_4024: .global asm_avx512_func_multiply_41_12_31 # asm_function:74          .global asm_avx512_func_multiply_41_12_31
avx512_Xx_4025: asm_avx512_func_multiply_41_12_31: # asm_function:75          asm_avx512_func_multiply_41_12_31:
avx512_Xx_4026: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_4027: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_4028: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_4029: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_4030: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_4031: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_4032: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_4033: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_4034: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:690             VPXORQ `out_registers_low_3, `out_registers_low_3, `out_registers_low_3
avx512_Xx_4035: VPXORQ ZMM7, ZMM7, ZMM7  # multiply:691             VPXORQ `out_registers_high_3, `out_registers_high_3, `out_registers_high_3
avx512_Xx_4036: VPBROADCASTQ ZMM8, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_4037: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4038: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4039: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4040: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4041: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4042: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4043: VPBROADCASTQ ZMM8, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_4044: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4045: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4046: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4047: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4048: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4049: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4050: VPBROADCASTQ ZMM8, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_4051: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4052: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4053: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4054: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4055: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4056: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4057: VPBROADCASTQ ZMM8, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_4058: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4059: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4060: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4061: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4062: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4063: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4064: VPBROADCASTQ ZMM8, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_4065: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4066: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4067: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4068: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4069: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4070: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4071: VPBROADCASTQ ZMM8, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_4072: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4073: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4074: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4075: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4076: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4077: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4078: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_4079: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4080: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4081: VPBROADCASTQ ZMM8, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_4082: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4083: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4084: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4085: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4086: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4087: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4088: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_4089: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4090: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4091: VPBROADCASTQ ZMM8, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_4092: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4093: VPMADD52LUQ ZMM0, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4094: VPMADD52HUQ ZMM4, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4095: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4096: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4097: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4098: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_4099: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4100: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4101: VPBROADCASTQ ZMM8, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_4102: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4103: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4104: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4105: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4106: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4107: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4108: VPBROADCASTQ ZMM8, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_4109: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4110: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4111: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4112: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4113: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4114: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4115: VPBROADCASTQ ZMM8, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_4116: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4117: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4118: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4119: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4120: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4121: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4122: VPBROADCASTQ ZMM8, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_4123: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4124: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4125: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4126: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4127: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4128: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4129: VPBROADCASTQ ZMM8, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_4130: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4131: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4132: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4133: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4134: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4135: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4136: VPBROADCASTQ ZMM8, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_4137: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4138: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4139: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4140: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4141: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4142: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4143: VMOVDQU64 ZMM9, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_4144: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4145: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4146: VPBROADCASTQ ZMM8, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_4147: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4148: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4149: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4150: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4151: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4152: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4153: VMOVDQU64 ZMM9, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_4154: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4155: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4156: VPBROADCASTQ ZMM8, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_4157: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4158: VPMADD52LUQ ZMM1, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4159: VPMADD52HUQ ZMM5, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4160: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4161: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4162: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4163: VMOVDQU64 ZMM9, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_4164: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4165: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4166: VPBROADCASTQ ZMM8, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_4167: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4168: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4169: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4170: VMOVDQU64 ZMM9, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4171: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4172: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4173: VPBROADCASTQ ZMM8, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_4174: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4175: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4176: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4177: VMOVDQU64 ZMM9, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4178: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4179: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4180: VPBROADCASTQ ZMM8, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_4181: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4182: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4183: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4184: VMOVDQU64 ZMM9, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4185: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4186: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4187: VPBROADCASTQ ZMM8, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_4188: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4189: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4190: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4191: VMOVDQU64 ZMM9, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4192: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4193: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4194: VPBROADCASTQ ZMM8, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_4195: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4196: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4197: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4198: VMOVDQU64 ZMM9, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4199: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4200: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4201: VPBROADCASTQ ZMM8, [RSI+168] # multiply:699             VPBROADCASTQ `a, [`in_a_data+168]
avx512_Xx_4202: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4203: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4204: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4205: VMOVDQU64 ZMM9, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4206: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4207: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4208: VPBROADCASTQ ZMM8, [RSI+176] # multiply:699             VPBROADCASTQ `a, [`in_a_data+176]
avx512_Xx_4209: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4210: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4211: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4212: VMOVDQU64 ZMM9, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4213: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4214: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4215: VPBROADCASTQ ZMM8, [RSI+184] # multiply:699             VPBROADCASTQ `a, [`in_a_data+184]
avx512_Xx_4216: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4217: VPMADD52LUQ ZMM2, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4218: VPMADD52HUQ ZMM6, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4219: VMOVDQU64 ZMM9, [RCX+8]  # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4220: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4221: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4222: VPBROADCASTQ ZMM8, [RSI+192] # multiply:699             VPBROADCASTQ `a, [`in_a_data+192]
avx512_Xx_4223: VMOVDQU64 ZMM9, [RCX+0]  # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4224: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4225: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4226: VPBROADCASTQ ZMM8, [RSI+200] # multiply:699             VPBROADCASTQ `a, [`in_a_data+200]
avx512_Xx_4227: VMOVDQU64 ZMM9, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4228: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4229: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4230: VPBROADCASTQ ZMM8, [RSI+208] # multiply:699             VPBROADCASTQ `a, [`in_a_data+208]
avx512_Xx_4231: VMOVDQU64 ZMM9, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4232: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4233: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4234: VPBROADCASTQ ZMM8, [RSI+216] # multiply:699             VPBROADCASTQ `a, [`in_a_data+216]
avx512_Xx_4235: VMOVDQU64 ZMM9, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4236: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4237: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4238: VPBROADCASTQ ZMM8, [RSI+224] # multiply:699             VPBROADCASTQ `a, [`in_a_data+224]
avx512_Xx_4239: VMOVDQU64 ZMM9, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4240: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4241: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4242: VPBROADCASTQ ZMM8, [RSI+232] # multiply:699             VPBROADCASTQ `a, [`in_a_data+232]
avx512_Xx_4243: VMOVDQU64 ZMM9, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4244: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4245: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4246: VPBROADCASTQ ZMM8, [RSI+240] # multiply:699             VPBROADCASTQ `a, [`in_a_data+240]
avx512_Xx_4247: VMOVDQU64 ZMM9, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4248: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4249: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4250: VPBROADCASTQ ZMM8, [RSI+248] # multiply:699             VPBROADCASTQ `a, [`in_a_data+248]
avx512_Xx_4251: VMOVDQU64 ZMM9, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4252: VPMADD52LUQ ZMM3, ZMM8, ZMM9 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4253: VPMADD52HUQ ZMM7, ZMM8, ZMM9 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4254: VPBROADCASTQ ZMM8, [RSI+256] # multiply:699             VPBROADCASTQ `a, [`in_a_data+256]
avx512_Xx_4255: VPBROADCASTQ ZMM8, [RSI+264] # multiply:699             VPBROADCASTQ `a, [`in_a_data+264]
avx512_Xx_4256: VPBROADCASTQ ZMM8, [RSI+272] # multiply:699             VPBROADCASTQ `a, [`in_a_data+272]
avx512_Xx_4257: VPBROADCASTQ ZMM8, [RSI+280] # multiply:699             VPBROADCASTQ `a, [`in_a_data+280]
avx512_Xx_4258: VPBROADCASTQ ZMM8, [RSI+288] # multiply:699             VPBROADCASTQ `a, [`in_a_data+288]
avx512_Xx_4259: VPBROADCASTQ ZMM8, [RSI+296] # multiply:699             VPBROADCASTQ `a, [`in_a_data+296]
avx512_Xx_4260: VPBROADCASTQ ZMM8, [RSI+304] # multiply:699             VPBROADCASTQ `a, [`in_a_data+304]
avx512_Xx_4261: VPBROADCASTQ ZMM8, [RSI+312] # multiply:699             VPBROADCASTQ `a, [`in_a_data+312]
avx512_Xx_4262: VPBROADCASTQ ZMM8, [RSI+320] # multiply:699             VPBROADCASTQ `a, [`in_a_data+320]
avx512_Xx_4263: VMOVDQU64 ZMM9, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_4264: VPXORQ ZMM10, ZMM10, ZMM10 # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_4265: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4266: VPERMI2Q ZMM8, ZMM6, ZMM7 # multiply:723             VPERMI2Q `a, `out_registers_high_2, `out_registers_high_3
avx512_Xx_4267: VPADDQ ZMM3, ZMM3, ZMM8  # multiply:726             VPADDQ `out_registers_low_3, `out_registers_low_3, `a
avx512_Xx_4268: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4269: VPERMI2Q ZMM8, ZMM5, ZMM6 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_4270: VPADDQ ZMM2, ZMM2, ZMM8  # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_4271: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4272: VPERMI2Q ZMM8, ZMM4, ZMM5 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_4273: VPADDQ ZMM1, ZMM1, ZMM8  # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_4274: VMOVDQU64 ZMM8, ZMM9     # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4275: VPERMI2Q ZMM8, ZMM10, ZMM4 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_4276: VPADDQ ZMM0, ZMM0, ZMM8  # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_4277: VMOVDQU64 ZMM4, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_4278: VMOVDQU64 ZMM5, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_4279: VPXORQ ZMM6, ZMM6, ZMM6  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_4280: _avx512_label_114:       # apply_carry:429          _avx512_label_114:
avx512_Xx_4281: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4282: VPERMI2Q ZMM8, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_4283: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4284: VPANDNQ ZMM3, ZMM4, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_4285: VPADDQ ZMM3, ZMM3, ZMM8  # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_4286: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_4287: VMOVDQA64 ZMM7, ZMM3     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_3
avx512_Xx_4288: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4289: VPERMI2Q ZMM8, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_4290: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4291: VPANDNQ ZMM2, ZMM4, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_4292: VPADDQ ZMM2, ZMM2, ZMM8  # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_4293: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_4294: VPORQ ZMM7, ZMM7, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_4295: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4296: VPERMI2Q ZMM8, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_4297: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4298: VPANDNQ ZMM1, ZMM4, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_4299: VPADDQ ZMM1, ZMM1, ZMM8  # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_4300: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_4301: VPORQ ZMM7, ZMM7, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_4302: VMOVDQU64 ZMM8, ZMM5     # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4303: VPERMI2Q ZMM8, ZMM6, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_4304: VPSRAQ ZMM8, ZMM8, 52    # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4305: VPANDNQ ZMM0, ZMM4, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_4306: VPADDQ ZMM0, ZMM0, ZMM8  # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_4307: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_4308: VPORQ ZMM7, ZMM7, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_4309: VMOVDQU64 [R8-64], ZMM6  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_4310: VMOVDQU64 [R8+256], ZMM6 # apply_carry:460          VMOVDQU64 [`in_data+256], `zero_vector
avx512_Xx_4311: VPTESTMQ k1, ZMM7, ZMM4  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_4312: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_4313: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_4314: JNZ _avx512_label_114    # apply_carry:466          JNZ _avx512_label_114
avx512_Xx_4315: _avx512_label_115:       # ~asm_function:121        _avx512_label_115:
avx512_Xx_4316: RET                      # ~asm_function:130        RET
avx512_Xx_4317: .global asm_avx512_func_multiply_41_41_41 # asm_function:74          .global asm_avx512_func_multiply_41_41_41
avx512_Xx_4318: asm_avx512_func_multiply_41_41_41: # asm_function:75          asm_avx512_func_multiply_41_41_41:
avx512_Xx_4319: MOV RAX, RDI             # multiply:678             MOV `out_sign, `in_a_sign
avx512_Xx_4320: XOR RAX, RDX             # multiply:679             XOR `out_sign, `in_b_sign
avx512_Xx_4321: VPXORQ ZMM0, ZMM0, ZMM0  # multiply:690             VPXORQ `out_registers_low_0, `out_registers_low_0, `out_registers_low_0
avx512_Xx_4322: VPXORQ ZMM6, ZMM6, ZMM6  # multiply:691             VPXORQ `out_registers_high_0, `out_registers_high_0, `out_registers_high_0
avx512_Xx_4323: VPXORQ ZMM1, ZMM1, ZMM1  # multiply:690             VPXORQ `out_registers_low_1, `out_registers_low_1, `out_registers_low_1
avx512_Xx_4324: VPXORQ ZMM7, ZMM7, ZMM7  # multiply:691             VPXORQ `out_registers_high_1, `out_registers_high_1, `out_registers_high_1
avx512_Xx_4325: VPXORQ ZMM2, ZMM2, ZMM2  # multiply:690             VPXORQ `out_registers_low_2, `out_registers_low_2, `out_registers_low_2
avx512_Xx_4326: VPXORQ ZMM8, ZMM8, ZMM8  # multiply:691             VPXORQ `out_registers_high_2, `out_registers_high_2, `out_registers_high_2
avx512_Xx_4327: VPXORQ ZMM3, ZMM3, ZMM3  # multiply:690             VPXORQ `out_registers_low_3, `out_registers_low_3, `out_registers_low_3
avx512_Xx_4328: VPXORQ ZMM9, ZMM9, ZMM9  # multiply:691             VPXORQ `out_registers_high_3, `out_registers_high_3, `out_registers_high_3
avx512_Xx_4329: VPXORQ ZMM4, ZMM4, ZMM4  # multiply:690             VPXORQ `out_registers_low_4, `out_registers_low_4, `out_registers_low_4
avx512_Xx_4330: VPXORQ ZMM10, ZMM10, ZMM10 # multiply:691             VPXORQ `out_registers_high_4, `out_registers_high_4, `out_registers_high_4
avx512_Xx_4331: VPXORQ ZMM5, ZMM5, ZMM5  # multiply:690             VPXORQ `out_registers_low_5, `out_registers_low_5, `out_registers_low_5
avx512_Xx_4332: VPXORQ ZMM11, ZMM11, ZMM11 # multiply:691             VPXORQ `out_registers_high_5, `out_registers_high_5, `out_registers_high_5
avx512_Xx_4333: VPBROADCASTQ ZMM12, [RSI+0] # multiply:699             VPBROADCASTQ `a, [`in_a_data+0]
avx512_Xx_4334: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4335: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4336: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4337: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4338: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4339: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4340: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_4341: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4342: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4343: VMOVDQU64 ZMM13, [RCX+192] # multiply:708             VMOVDQU64 `b, [`in_b_data+192]
avx512_Xx_4344: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4345: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4346: VMOVDQU64 ZMM13, [RCX+256] # multiply:708             VMOVDQU64 `b, [`in_b_data+256]
avx512_Xx_4347: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4348: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4349: VMOVDQU64 ZMM13, [RCX+320] # multiply:708             VMOVDQU64 `b, [`in_b_data+320]
avx512_Xx_4350: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4351: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4352: VPBROADCASTQ ZMM12, [RSI+8] # multiply:699             VPBROADCASTQ `a, [`in_a_data+8]
avx512_Xx_4353: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4354: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4355: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4356: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4357: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4358: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4359: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_4360: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4361: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4362: VMOVDQU64 ZMM13, [RCX+184] # multiply:708             VMOVDQU64 `b, [`in_b_data+184]
avx512_Xx_4363: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4364: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4365: VMOVDQU64 ZMM13, [RCX+248] # multiply:708             VMOVDQU64 `b, [`in_b_data+248]
avx512_Xx_4366: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4367: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4368: VMOVDQU64 ZMM13, [RCX+312] # multiply:708             VMOVDQU64 `b, [`in_b_data+312]
avx512_Xx_4369: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4370: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4371: VPBROADCASTQ ZMM12, [RSI+16] # multiply:699             VPBROADCASTQ `a, [`in_a_data+16]
avx512_Xx_4372: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4373: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4374: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4375: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4376: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4377: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4378: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_4379: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4380: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4381: VMOVDQU64 ZMM13, [RCX+176] # multiply:708             VMOVDQU64 `b, [`in_b_data+176]
avx512_Xx_4382: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4383: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4384: VMOVDQU64 ZMM13, [RCX+240] # multiply:708             VMOVDQU64 `b, [`in_b_data+240]
avx512_Xx_4385: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4386: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4387: VMOVDQU64 ZMM13, [RCX+304] # multiply:708             VMOVDQU64 `b, [`in_b_data+304]
avx512_Xx_4388: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4389: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4390: VPBROADCASTQ ZMM12, [RSI+24] # multiply:699             VPBROADCASTQ `a, [`in_a_data+24]
avx512_Xx_4391: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4392: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4393: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4394: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4395: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4396: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4397: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_4398: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4399: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4400: VMOVDQU64 ZMM13, [RCX+168] # multiply:708             VMOVDQU64 `b, [`in_b_data+168]
avx512_Xx_4401: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4402: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4403: VMOVDQU64 ZMM13, [RCX+232] # multiply:708             VMOVDQU64 `b, [`in_b_data+232]
avx512_Xx_4404: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4405: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4406: VMOVDQU64 ZMM13, [RCX+296] # multiply:708             VMOVDQU64 `b, [`in_b_data+296]
avx512_Xx_4407: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4408: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4409: VPBROADCASTQ ZMM12, [RSI+32] # multiply:699             VPBROADCASTQ `a, [`in_a_data+32]
avx512_Xx_4410: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4411: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4412: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4413: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4414: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4415: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4416: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_4417: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4418: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4419: VMOVDQU64 ZMM13, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_4420: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4421: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4422: VMOVDQU64 ZMM13, [RCX+224] # multiply:708             VMOVDQU64 `b, [`in_b_data+224]
avx512_Xx_4423: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4424: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4425: VMOVDQU64 ZMM13, [RCX+288] # multiply:708             VMOVDQU64 `b, [`in_b_data+288]
avx512_Xx_4426: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4427: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4428: VPBROADCASTQ ZMM12, [RSI+40] # multiply:699             VPBROADCASTQ `a, [`in_a_data+40]
avx512_Xx_4429: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4430: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4431: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4432: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4433: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4434: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4435: VMOVDQU64 ZMM13, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_4436: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4437: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4438: VMOVDQU64 ZMM13, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_4439: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4440: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4441: VMOVDQU64 ZMM13, [RCX+216] # multiply:708             VMOVDQU64 `b, [`in_b_data+216]
avx512_Xx_4442: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4443: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4444: VMOVDQU64 ZMM13, [RCX+280] # multiply:708             VMOVDQU64 `b, [`in_b_data+280]
avx512_Xx_4445: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4446: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4447: VPBROADCASTQ ZMM12, [RSI+48] # multiply:699             VPBROADCASTQ `a, [`in_a_data+48]
avx512_Xx_4448: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4449: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4450: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4451: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4452: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4453: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4454: VMOVDQU64 ZMM13, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_4455: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4456: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4457: VMOVDQU64 ZMM13, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_4458: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4459: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4460: VMOVDQU64 ZMM13, [RCX+208] # multiply:708             VMOVDQU64 `b, [`in_b_data+208]
avx512_Xx_4461: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4462: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4463: VMOVDQU64 ZMM13, [RCX+272] # multiply:708             VMOVDQU64 `b, [`in_b_data+272]
avx512_Xx_4464: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4465: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4466: VPBROADCASTQ ZMM12, [RSI+56] # multiply:699             VPBROADCASTQ `a, [`in_a_data+56]
avx512_Xx_4467: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4468: VPMADD52LUQ ZMM0, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_0, `a, `b
avx512_Xx_4469: VPMADD52HUQ ZMM6, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_0, `a, `b
avx512_Xx_4470: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4471: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4472: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4473: VMOVDQU64 ZMM13, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_4474: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4475: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4476: VMOVDQU64 ZMM13, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_4477: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4478: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4479: VMOVDQU64 ZMM13, [RCX+200] # multiply:708             VMOVDQU64 `b, [`in_b_data+200]
avx512_Xx_4480: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4481: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4482: VMOVDQU64 ZMM13, [RCX+264] # multiply:708             VMOVDQU64 `b, [`in_b_data+264]
avx512_Xx_4483: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4484: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4485: VPBROADCASTQ ZMM12, [RSI+64] # multiply:699             VPBROADCASTQ `a, [`in_a_data+64]
avx512_Xx_4486: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4487: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4488: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4489: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4490: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4491: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4492: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_4493: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4494: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4495: VMOVDQU64 ZMM13, [RCX+192] # multiply:708             VMOVDQU64 `b, [`in_b_data+192]
avx512_Xx_4496: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4497: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4498: VMOVDQU64 ZMM13, [RCX+256] # multiply:708             VMOVDQU64 `b, [`in_b_data+256]
avx512_Xx_4499: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4500: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4501: VPBROADCASTQ ZMM12, [RSI+72] # multiply:699             VPBROADCASTQ `a, [`in_a_data+72]
avx512_Xx_4502: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4503: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4504: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4505: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4506: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4507: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4508: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_4509: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4510: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4511: VMOVDQU64 ZMM13, [RCX+184] # multiply:708             VMOVDQU64 `b, [`in_b_data+184]
avx512_Xx_4512: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4513: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4514: VMOVDQU64 ZMM13, [RCX+248] # multiply:708             VMOVDQU64 `b, [`in_b_data+248]
avx512_Xx_4515: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4516: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4517: VPBROADCASTQ ZMM12, [RSI+80] # multiply:699             VPBROADCASTQ `a, [`in_a_data+80]
avx512_Xx_4518: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4519: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4520: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4521: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4522: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4523: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4524: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_4525: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4526: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4527: VMOVDQU64 ZMM13, [RCX+176] # multiply:708             VMOVDQU64 `b, [`in_b_data+176]
avx512_Xx_4528: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4529: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4530: VMOVDQU64 ZMM13, [RCX+240] # multiply:708             VMOVDQU64 `b, [`in_b_data+240]
avx512_Xx_4531: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4532: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4533: VPBROADCASTQ ZMM12, [RSI+88] # multiply:699             VPBROADCASTQ `a, [`in_a_data+88]
avx512_Xx_4534: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4535: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4536: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4537: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4538: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4539: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4540: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_4541: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4542: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4543: VMOVDQU64 ZMM13, [RCX+168] # multiply:708             VMOVDQU64 `b, [`in_b_data+168]
avx512_Xx_4544: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4545: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4546: VMOVDQU64 ZMM13, [RCX+232] # multiply:708             VMOVDQU64 `b, [`in_b_data+232]
avx512_Xx_4547: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4548: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4549: VPBROADCASTQ ZMM12, [RSI+96] # multiply:699             VPBROADCASTQ `a, [`in_a_data+96]
avx512_Xx_4550: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4551: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4552: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4553: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4554: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4555: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4556: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_4557: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4558: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4559: VMOVDQU64 ZMM13, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_4560: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4561: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4562: VMOVDQU64 ZMM13, [RCX+224] # multiply:708             VMOVDQU64 `b, [`in_b_data+224]
avx512_Xx_4563: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4564: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4565: VPBROADCASTQ ZMM12, [RSI+104] # multiply:699             VPBROADCASTQ `a, [`in_a_data+104]
avx512_Xx_4566: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4567: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4568: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4569: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4570: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4571: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4572: VMOVDQU64 ZMM13, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_4573: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4574: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4575: VMOVDQU64 ZMM13, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_4576: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4577: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4578: VMOVDQU64 ZMM13, [RCX+216] # multiply:708             VMOVDQU64 `b, [`in_b_data+216]
avx512_Xx_4579: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4580: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4581: VPBROADCASTQ ZMM12, [RSI+112] # multiply:699             VPBROADCASTQ `a, [`in_a_data+112]
avx512_Xx_4582: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4583: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4584: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4585: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4586: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4587: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4588: VMOVDQU64 ZMM13, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_4589: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4590: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4591: VMOVDQU64 ZMM13, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_4592: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4593: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4594: VMOVDQU64 ZMM13, [RCX+208] # multiply:708             VMOVDQU64 `b, [`in_b_data+208]
avx512_Xx_4595: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4596: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4597: VPBROADCASTQ ZMM12, [RSI+120] # multiply:699             VPBROADCASTQ `a, [`in_a_data+120]
avx512_Xx_4598: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4599: VPMADD52LUQ ZMM1, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_1, `a, `b
avx512_Xx_4600: VPMADD52HUQ ZMM7, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_1, `a, `b
avx512_Xx_4601: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4602: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4603: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4604: VMOVDQU64 ZMM13, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_4605: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4606: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4607: VMOVDQU64 ZMM13, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_4608: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4609: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4610: VMOVDQU64 ZMM13, [RCX+200] # multiply:708             VMOVDQU64 `b, [`in_b_data+200]
avx512_Xx_4611: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4612: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4613: VPBROADCASTQ ZMM12, [RSI+128] # multiply:699             VPBROADCASTQ `a, [`in_a_data+128]
avx512_Xx_4614: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4615: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4616: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4617: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4618: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4619: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4620: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_4621: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4622: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4623: VMOVDQU64 ZMM13, [RCX+192] # multiply:708             VMOVDQU64 `b, [`in_b_data+192]
avx512_Xx_4624: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4625: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4626: VPBROADCASTQ ZMM12, [RSI+136] # multiply:699             VPBROADCASTQ `a, [`in_a_data+136]
avx512_Xx_4627: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4628: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4629: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4630: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4631: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4632: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4633: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_4634: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4635: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4636: VMOVDQU64 ZMM13, [RCX+184] # multiply:708             VMOVDQU64 `b, [`in_b_data+184]
avx512_Xx_4637: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4638: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4639: VPBROADCASTQ ZMM12, [RSI+144] # multiply:699             VPBROADCASTQ `a, [`in_a_data+144]
avx512_Xx_4640: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4641: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4642: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4643: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4644: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4645: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4646: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_4647: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4648: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4649: VMOVDQU64 ZMM13, [RCX+176] # multiply:708             VMOVDQU64 `b, [`in_b_data+176]
avx512_Xx_4650: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4651: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4652: VPBROADCASTQ ZMM12, [RSI+152] # multiply:699             VPBROADCASTQ `a, [`in_a_data+152]
avx512_Xx_4653: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4654: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4655: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4656: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4657: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4658: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4659: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_4660: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4661: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4662: VMOVDQU64 ZMM13, [RCX+168] # multiply:708             VMOVDQU64 `b, [`in_b_data+168]
avx512_Xx_4663: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4664: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4665: VPBROADCASTQ ZMM12, [RSI+160] # multiply:699             VPBROADCASTQ `a, [`in_a_data+160]
avx512_Xx_4666: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4667: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4668: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4669: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4670: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4671: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4672: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_4673: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4674: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4675: VMOVDQU64 ZMM13, [RCX+160] # multiply:708             VMOVDQU64 `b, [`in_b_data+160]
avx512_Xx_4676: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4677: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4678: VPBROADCASTQ ZMM12, [RSI+168] # multiply:699             VPBROADCASTQ `a, [`in_a_data+168]
avx512_Xx_4679: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4680: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4681: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4682: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4683: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4684: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4685: VMOVDQU64 ZMM13, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_4686: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4687: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4688: VMOVDQU64 ZMM13, [RCX+152] # multiply:708             VMOVDQU64 `b, [`in_b_data+152]
avx512_Xx_4689: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4690: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4691: VPBROADCASTQ ZMM12, [RSI+176] # multiply:699             VPBROADCASTQ `a, [`in_a_data+176]
avx512_Xx_4692: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4693: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4694: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4695: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4696: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4697: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4698: VMOVDQU64 ZMM13, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_4699: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4700: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4701: VMOVDQU64 ZMM13, [RCX+144] # multiply:708             VMOVDQU64 `b, [`in_b_data+144]
avx512_Xx_4702: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4703: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4704: VPBROADCASTQ ZMM12, [RSI+184] # multiply:699             VPBROADCASTQ `a, [`in_a_data+184]
avx512_Xx_4705: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4706: VPMADD52LUQ ZMM2, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_2, `a, `b
avx512_Xx_4707: VPMADD52HUQ ZMM8, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_2, `a, `b
avx512_Xx_4708: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4709: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4710: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4711: VMOVDQU64 ZMM13, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_4712: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4713: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4714: VMOVDQU64 ZMM13, [RCX+136] # multiply:708             VMOVDQU64 `b, [`in_b_data+136]
avx512_Xx_4715: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4716: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4717: VPBROADCASTQ ZMM12, [RSI+192] # multiply:699             VPBROADCASTQ `a, [`in_a_data+192]
avx512_Xx_4718: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4719: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4720: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4721: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4722: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4723: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4724: VMOVDQU64 ZMM13, [RCX+128] # multiply:708             VMOVDQU64 `b, [`in_b_data+128]
avx512_Xx_4725: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4726: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4727: VPBROADCASTQ ZMM12, [RSI+200] # multiply:699             VPBROADCASTQ `a, [`in_a_data+200]
avx512_Xx_4728: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4729: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4730: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4731: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4732: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4733: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4734: VMOVDQU64 ZMM13, [RCX+120] # multiply:708             VMOVDQU64 `b, [`in_b_data+120]
avx512_Xx_4735: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4736: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4737: VPBROADCASTQ ZMM12, [RSI+208] # multiply:699             VPBROADCASTQ `a, [`in_a_data+208]
avx512_Xx_4738: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4739: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4740: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4741: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4742: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4743: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4744: VMOVDQU64 ZMM13, [RCX+112] # multiply:708             VMOVDQU64 `b, [`in_b_data+112]
avx512_Xx_4745: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4746: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4747: VPBROADCASTQ ZMM12, [RSI+216] # multiply:699             VPBROADCASTQ `a, [`in_a_data+216]
avx512_Xx_4748: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4749: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4750: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4751: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4752: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4753: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4754: VMOVDQU64 ZMM13, [RCX+104] # multiply:708             VMOVDQU64 `b, [`in_b_data+104]
avx512_Xx_4755: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4756: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4757: VPBROADCASTQ ZMM12, [RSI+224] # multiply:699             VPBROADCASTQ `a, [`in_a_data+224]
avx512_Xx_4758: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4759: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4760: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4761: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4762: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4763: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4764: VMOVDQU64 ZMM13, [RCX+96] # multiply:708             VMOVDQU64 `b, [`in_b_data+96]
avx512_Xx_4765: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4766: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4767: VPBROADCASTQ ZMM12, [RSI+232] # multiply:699             VPBROADCASTQ `a, [`in_a_data+232]
avx512_Xx_4768: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4769: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4770: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4771: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4772: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4773: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4774: VMOVDQU64 ZMM13, [RCX+88] # multiply:708             VMOVDQU64 `b, [`in_b_data+88]
avx512_Xx_4775: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4776: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4777: VPBROADCASTQ ZMM12, [RSI+240] # multiply:699             VPBROADCASTQ `a, [`in_a_data+240]
avx512_Xx_4778: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4779: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4780: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4781: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4782: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4783: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4784: VMOVDQU64 ZMM13, [RCX+80] # multiply:708             VMOVDQU64 `b, [`in_b_data+80]
avx512_Xx_4785: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4786: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4787: VPBROADCASTQ ZMM12, [RSI+248] # multiply:699             VPBROADCASTQ `a, [`in_a_data+248]
avx512_Xx_4788: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4789: VPMADD52LUQ ZMM3, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_3, `a, `b
avx512_Xx_4790: VPMADD52HUQ ZMM9, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_3, `a, `b
avx512_Xx_4791: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4792: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4793: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4794: VMOVDQU64 ZMM13, [RCX+72] # multiply:708             VMOVDQU64 `b, [`in_b_data+72]
avx512_Xx_4795: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4796: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4797: VPBROADCASTQ ZMM12, [RSI+256] # multiply:699             VPBROADCASTQ `a, [`in_a_data+256]
avx512_Xx_4798: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4799: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4800: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4801: VMOVDQU64 ZMM13, [RCX+64] # multiply:708             VMOVDQU64 `b, [`in_b_data+64]
avx512_Xx_4802: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4803: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4804: VPBROADCASTQ ZMM12, [RSI+264] # multiply:699             VPBROADCASTQ `a, [`in_a_data+264]
avx512_Xx_4805: VMOVDQU64 ZMM13, [RCX+-8] # multiply:708             VMOVDQU64 `b, [`in_b_data+-8]
avx512_Xx_4806: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4807: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4808: VMOVDQU64 ZMM13, [RCX+56] # multiply:708             VMOVDQU64 `b, [`in_b_data+56]
avx512_Xx_4809: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4810: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4811: VPBROADCASTQ ZMM12, [RSI+272] # multiply:699             VPBROADCASTQ `a, [`in_a_data+272]
avx512_Xx_4812: VMOVDQU64 ZMM13, [RCX+-16] # multiply:708             VMOVDQU64 `b, [`in_b_data+-16]
avx512_Xx_4813: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4814: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4815: VMOVDQU64 ZMM13, [RCX+48] # multiply:708             VMOVDQU64 `b, [`in_b_data+48]
avx512_Xx_4816: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4817: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4818: VPBROADCASTQ ZMM12, [RSI+280] # multiply:699             VPBROADCASTQ `a, [`in_a_data+280]
avx512_Xx_4819: VMOVDQU64 ZMM13, [RCX+-24] # multiply:708             VMOVDQU64 `b, [`in_b_data+-24]
avx512_Xx_4820: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4821: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4822: VMOVDQU64 ZMM13, [RCX+40] # multiply:708             VMOVDQU64 `b, [`in_b_data+40]
avx512_Xx_4823: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4824: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4825: VPBROADCASTQ ZMM12, [RSI+288] # multiply:699             VPBROADCASTQ `a, [`in_a_data+288]
avx512_Xx_4826: VMOVDQU64 ZMM13, [RCX+-32] # multiply:708             VMOVDQU64 `b, [`in_b_data+-32]
avx512_Xx_4827: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4828: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4829: VMOVDQU64 ZMM13, [RCX+32] # multiply:708             VMOVDQU64 `b, [`in_b_data+32]
avx512_Xx_4830: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4831: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4832: VPBROADCASTQ ZMM12, [RSI+296] # multiply:699             VPBROADCASTQ `a, [`in_a_data+296]
avx512_Xx_4833: VMOVDQU64 ZMM13, [RCX+-40] # multiply:708             VMOVDQU64 `b, [`in_b_data+-40]
avx512_Xx_4834: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4835: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4836: VMOVDQU64 ZMM13, [RCX+24] # multiply:708             VMOVDQU64 `b, [`in_b_data+24]
avx512_Xx_4837: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4838: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4839: VPBROADCASTQ ZMM12, [RSI+304] # multiply:699             VPBROADCASTQ `a, [`in_a_data+304]
avx512_Xx_4840: VMOVDQU64 ZMM13, [RCX+-48] # multiply:708             VMOVDQU64 `b, [`in_b_data+-48]
avx512_Xx_4841: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4842: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4843: VMOVDQU64 ZMM13, [RCX+16] # multiply:708             VMOVDQU64 `b, [`in_b_data+16]
avx512_Xx_4844: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4845: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4846: VPBROADCASTQ ZMM12, [RSI+312] # multiply:699             VPBROADCASTQ `a, [`in_a_data+312]
avx512_Xx_4847: VMOVDQU64 ZMM13, [RCX+-56] # multiply:708             VMOVDQU64 `b, [`in_b_data+-56]
avx512_Xx_4848: VPMADD52LUQ ZMM4, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_4, `a, `b
avx512_Xx_4849: VPMADD52HUQ ZMM10, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_4, `a, `b
avx512_Xx_4850: VMOVDQU64 ZMM13, [RCX+8] # multiply:708             VMOVDQU64 `b, [`in_b_data+8]
avx512_Xx_4851: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4852: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4853: VPBROADCASTQ ZMM12, [RSI+320] # multiply:699             VPBROADCASTQ `a, [`in_a_data+320]
avx512_Xx_4854: VMOVDQU64 ZMM13, [RCX+0] # multiply:708             VMOVDQU64 `b, [`in_b_data+0]
avx512_Xx_4855: VPMADD52LUQ ZMM5, ZMM12, ZMM13 # multiply:710             VPMADD52LUQ `out_registers_low_5, `a, `b
avx512_Xx_4856: VPMADD52HUQ ZMM11, ZMM12, ZMM13 # multiply:711             VPMADD52HUQ `out_registers_high_5, `a, `b
avx512_Xx_4857: VMOVDQU64 ZMM13, ZMMWORD PTR [_avx512_label_86] # multiply:715             VMOVDQU64 `b, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_4858: VPXORQ ZMM14, ZMM14, ZMM14 # multiply:716             VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_4859: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4860: VPERMI2Q ZMM12, ZMM10, ZMM11 # multiply:723             VPERMI2Q `a, `out_registers_high_4, `out_registers_high_5
avx512_Xx_4861: VPADDQ ZMM5, ZMM5, ZMM12 # multiply:726             VPADDQ `out_registers_low_5, `out_registers_low_5, `a
avx512_Xx_4862: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4863: VPERMI2Q ZMM12, ZMM9, ZMM10 # multiply:723             VPERMI2Q `a, `out_registers_high_3, `out_registers_high_4
avx512_Xx_4864: VPADDQ ZMM4, ZMM4, ZMM12 # multiply:726             VPADDQ `out_registers_low_4, `out_registers_low_4, `a
avx512_Xx_4865: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4866: VPERMI2Q ZMM12, ZMM8, ZMM9 # multiply:723             VPERMI2Q `a, `out_registers_high_2, `out_registers_high_3
avx512_Xx_4867: VPADDQ ZMM3, ZMM3, ZMM12 # multiply:726             VPADDQ `out_registers_low_3, `out_registers_low_3, `a
avx512_Xx_4868: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4869: VPERMI2Q ZMM12, ZMM7, ZMM8 # multiply:723             VPERMI2Q `a, `out_registers_high_1, `out_registers_high_2
avx512_Xx_4870: VPADDQ ZMM2, ZMM2, ZMM12 # multiply:726             VPADDQ `out_registers_low_2, `out_registers_low_2, `a
avx512_Xx_4871: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4872: VPERMI2Q ZMM12, ZMM6, ZMM7 # multiply:723             VPERMI2Q `a, `out_registers_high_0, `out_registers_high_1
avx512_Xx_4873: VPADDQ ZMM1, ZMM1, ZMM12 # multiply:726             VPADDQ `out_registers_low_1, `out_registers_low_1, `a
avx512_Xx_4874: VMOVDQU64 ZMM12, ZMM13   # multiply:722             VMOVDQU64 `a, `b
avx512_Xx_4875: VPERMI2Q ZMM12, ZMM14, ZMM6 # multiply:723             VPERMI2Q `a, `zero_vector, `out_registers_high_0
avx512_Xx_4876: VPADDQ ZMM0, ZMM0, ZMM12 # multiply:726             VPADDQ `out_registers_low_0, `out_registers_low_0, `a
avx512_Xx_4877: VMOVDQU64 ZMM6, ZMMWORD PTR [_avx512_label_85] # apply_carry:424          VMOVDQU64 `carry_mask, ZMMWORD PTR [_avx512_label_85]
avx512_Xx_4878: VMOVDQU64 ZMM7, ZMMWORD PTR [_avx512_label_86] # apply_carry:425          VMOVDQU64 `permutate_indexes, ZMMWORD PTR [_avx512_label_86]
avx512_Xx_4879: VPXORQ ZMM8, ZMM8, ZMM8  # apply_carry:426          VPXORQ `zero_vector, `zero_vector, `zero_vector
avx512_Xx_4880: _avx512_label_116:       # apply_carry:429          _avx512_label_116:
avx512_Xx_4881: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4882: VPERMI2Q ZMM10, ZMM4, ZMM5 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_4, `in_registers_5
avx512_Xx_4883: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4884: VPANDNQ ZMM5, ZMM6, ZMM5 # apply_carry:442          VPANDNQ `in_registers_5, `carry_mask, `in_registers_5
avx512_Xx_4885: VPADDQ ZMM5, ZMM5, ZMM10 # apply_carry:445          VPADDQ `in_registers_5, `in_registers_5, `temp_vector
avx512_Xx_4886: VMOVDQU64 [R8+320], ZMM5 # apply_carry:448          VMOVDQU64 [`in_data+320], `in_registers_5
avx512_Xx_4887: VMOVDQA64 ZMM9, ZMM5     # apply_carry:452          VMOVDQA64 `accumulator, `in_registers_5
avx512_Xx_4888: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4889: VPERMI2Q ZMM10, ZMM3, ZMM4 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_3, `in_registers_4
avx512_Xx_4890: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4891: VPANDNQ ZMM4, ZMM6, ZMM4 # apply_carry:442          VPANDNQ `in_registers_4, `carry_mask, `in_registers_4
avx512_Xx_4892: VPADDQ ZMM4, ZMM4, ZMM10 # apply_carry:445          VPADDQ `in_registers_4, `in_registers_4, `temp_vector
avx512_Xx_4893: VMOVDQU64 [R8+256], ZMM4 # apply_carry:448          VMOVDQU64 [`in_data+256], `in_registers_4
avx512_Xx_4894: VPORQ ZMM9, ZMM9, ZMM4   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_4
avx512_Xx_4895: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4896: VPERMI2Q ZMM10, ZMM2, ZMM3 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_2, `in_registers_3
avx512_Xx_4897: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4898: VPANDNQ ZMM3, ZMM6, ZMM3 # apply_carry:442          VPANDNQ `in_registers_3, `carry_mask, `in_registers_3
avx512_Xx_4899: VPADDQ ZMM3, ZMM3, ZMM10 # apply_carry:445          VPADDQ `in_registers_3, `in_registers_3, `temp_vector
avx512_Xx_4900: VMOVDQU64 [R8+192], ZMM3 # apply_carry:448          VMOVDQU64 [`in_data+192], `in_registers_3
avx512_Xx_4901: VPORQ ZMM9, ZMM9, ZMM3   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_3
avx512_Xx_4902: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4903: VPERMI2Q ZMM10, ZMM1, ZMM2 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_1, `in_registers_2
avx512_Xx_4904: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4905: VPANDNQ ZMM2, ZMM6, ZMM2 # apply_carry:442          VPANDNQ `in_registers_2, `carry_mask, `in_registers_2
avx512_Xx_4906: VPADDQ ZMM2, ZMM2, ZMM10 # apply_carry:445          VPADDQ `in_registers_2, `in_registers_2, `temp_vector
avx512_Xx_4907: VMOVDQU64 [R8+128], ZMM2 # apply_carry:448          VMOVDQU64 [`in_data+128], `in_registers_2
avx512_Xx_4908: VPORQ ZMM9, ZMM9, ZMM2   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_2
avx512_Xx_4909: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4910: VPERMI2Q ZMM10, ZMM0, ZMM1 # apply_carry:436          VPERMI2Q `temp_vector, `in_registers_0, `in_registers_1
avx512_Xx_4911: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4912: VPANDNQ ZMM1, ZMM6, ZMM1 # apply_carry:442          VPANDNQ `in_registers_1, `carry_mask, `in_registers_1
avx512_Xx_4913: VPADDQ ZMM1, ZMM1, ZMM10 # apply_carry:445          VPADDQ `in_registers_1, `in_registers_1, `temp_vector
avx512_Xx_4914: VMOVDQU64 [R8+64], ZMM1  # apply_carry:448          VMOVDQU64 [`in_data+64], `in_registers_1
avx512_Xx_4915: VPORQ ZMM9, ZMM9, ZMM1   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_1
avx512_Xx_4916: VMOVDQU64 ZMM10, ZMM7    # apply_carry:435          VMOVDQU64 `temp_vector, `permutate_indexes
avx512_Xx_4917: VPERMI2Q ZMM10, ZMM8, ZMM0 # apply_carry:436          VPERMI2Q `temp_vector, `zero_vector, `in_registers_0
avx512_Xx_4918: VPSRAQ ZMM10, ZMM10, 52  # apply_carry:439          VPSRAQ `temp_vector, `temp_vector, 52
avx512_Xx_4919: VPANDNQ ZMM0, ZMM6, ZMM0 # apply_carry:442          VPANDNQ `in_registers_0, `carry_mask, `in_registers_0
avx512_Xx_4920: VPADDQ ZMM0, ZMM0, ZMM10 # apply_carry:445          VPADDQ `in_registers_0, `in_registers_0, `temp_vector
avx512_Xx_4921: VMOVDQU64 [R8+0], ZMM0   # apply_carry:448          VMOVDQU64 [`in_data+0], `in_registers_0
avx512_Xx_4922: VPORQ ZMM9, ZMM9, ZMM0   # apply_carry:454          VPORQ `accumulator, `accumulator, `in_registers_0
avx512_Xx_4923: VMOVDQU64 [R8-64], ZMM8  # apply_carry:459          VMOVDQU64 [`in_data-64], `zero_vector
avx512_Xx_4924: VMOVDQU64 [R8+384], ZMM8 # apply_carry:460          VMOVDQU64 [`in_data+384], `zero_vector
avx512_Xx_4925: VPTESTMQ k1, ZMM9, ZMM6  # apply_carry:463          VPTESTMQ k1, `accumulator, `carry_mask
avx512_Xx_4926: KMOVQ R9, k1             # apply_carry:464          KMOVQ `temp_scalar, k1
avx512_Xx_4927: TEST R9, R9              # apply_carry:465          TEST `temp_scalar, `temp_scalar
avx512_Xx_4928: JNZ _avx512_label_116    # apply_carry:466          JNZ _avx512_label_116
avx512_Xx_4929: _avx512_label_117:       # ~asm_function:121        _avx512_label_117:
avx512_Xx_4930: RET                      # ~asm_function:130        RET
