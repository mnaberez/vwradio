;MB89677AR
;   175
;9911  K10

    .F2MC8L
    .area CODE1 (ABS)
    .org 0x8000

    pdr0 = 0x00             ;port 0 data register
    ddr0 = 0x01             ;port 0 data direction register
    pdr1 = 0x02             ;port 1 data register
    ddr1 = 0x03             ;port 1 data direction register
    pdr2 = 0x04             ;port 2 data register
    sycc = 0x07             ;system clock control register
    stbc = 0x08             ;standby control register
    tbtc = 0x0a             ;timebase timer control register
    pdr3 = 0x0c             ;port 3 data register
    ddr3 = 0x0d             ;port 3 data direction register
    pdr4 = 0x0e             ;port 4 data register
    ddr4 = 0x0f             ;port 4 data direction register
    pdr5 = 0x10             ;port 5 data register
    pdr6 = 0x11             ;port 6 data register
    ppcr = 0x12             ;port 6 pull-up control register
    pdr7 = 0x13             ;port 7 data register
    pdr8 = 0x14             ;port 8 data / port 7 change register
    cntr = 0x16             ;pwm control register #3
    comp = 0x17             ;pwm compare register #3
    tmcr = 0x18             ;16-bit timer control register
    tchr = 0x19             ;16-bit timer count register high
    smr = 0x1c              ;serial mode register
    sdr = 0x1d              ;serial data register
    adc1 = 0x20             ;adc control register 1
    adc2 = 0x21             ;adc control register 2
    adch = 0x22             ;adc data register high
    t2cr = 0x24             ;timer 2 control register
    cntr1 = 0x28            ;pwm-timer control register 1
    cntr2 = 0x29            ;pwm-timer control register 2
    cntr3 = 0x2a            ;pwm-timer control register 3
    comr1 = 0x2c            ;pwm-timer compare register 1
    udcr1 = 0x30            ;read: updown counter register 1, write: reload compare register 1
    ccra1 = 0x32            ;counter control register a1
    ccrb1 = 0x34            ;counter control register b1
    ccrb2 = 0x35            ;counter contorl register b2
    csr1 = 0x36             ;counter status register 1
    csr2 = 0x37             ;counter status register 2
    eic1 = 0x38             ;external-interrupt control register 1
    eic2 = 0x39             ;external-interrupt control register 2
    eie2 = 0x3a             ;external-interrupt control register 2
    eif2 = 0x3b             ;external-interrupt flag register 2
    usmr = 0x40             ;uart mode register
    uscr = 0x41             ;uart control register
    ustr = 0x42             ;uart status register
    rxdr = 0x43             ;read: uart receive data register
    txdr = 0x43             ;write: uart transmit data register
    rrdr = 0x45             ;baud-rate generate reload data register
    cntr4 = 0x48            ;pwm-control register 4
    comp4 = 0x49            ;pwm-compare register 4
    cntr5 = 0x4a            ;pwm-control register 5
    cntr6 = 0x4c            ;pwm-control register 6
    ilr1 = 0x7c             ;interrupt-level setting register 1
    ilr2 = 0x7d             ;interrupt-level setting register 2
    ilr3 = 0x7e             ;interrupt-level setting register 3

    mem_0080 = 0x80
    mem_0081 = 0x81
    mem_0082 = 0x82
    mem_0083 = 0x83
    mem_0084 = 0x84
    mem_0086 = 0x86
    mem_0088 = 0x88
    mem_0089 = 0x89
    mem_008a = 0x8a
    mem_008b = 0x8b
    mem_008c = 0x8c
    mem_008d = 0x8d
    mem_008e = 0x8e
    mem_008f = 0x8f
    mem_0091 = 0x91
    mem_0092 = 0x92
    mem_0093 = 0x93
    mem_0094 = 0x94
    mem_0095 = 0x95
    mem_0096 = 0x96
    mem_0097 = 0x97
    mem_0098 = 0x98
    mem_0099 = 0x99
    mem_009c = 0x9c
    mem_009d = 0x9d
    mem_009e = 0x9e
    mem_009f = 0x9f
    mem_00a0 = 0xa0
    mem_00a1 = 0xa1
    mem_00a2 = 0xa2
    mem_00a3 = 0xa3
    mem_00a4 = 0xa4
    mem_00a5 = 0xa5
    mem_00a6 = 0xa6
    mem_00a8 = 0xa8
    mem_00a9 = 0xa9
    mem_00aa = 0xaa
    mem_00ac = 0xac
    mem_00ae = 0xae
    mem_00af = 0xaf
    mem_00b0 = 0xb0
    mem_00b1 = 0xb1
    mem_00b2 = 0xb2
    mem_00b3 = 0xb3
    mem_00b4 = 0xb4
    mem_00b5 = 0xb5
    mem_00b6 = 0xb6
    mem_00b7 = 0xb7
    mem_00b8 = 0xb8
    mem_00b9 = 0xb9
    mem_00ba = 0xba
    mem_00bb = 0xbb
    mem_00bc = 0xbc
    mem_00bd = 0xbd
    mem_00be = 0xbe
    mem_00c0 = 0xc0
    mem_00c1 = 0xc1
    mem_00c2 = 0xc2
    mem_00c3 = 0xc3
    mem_00c5 = 0xc5
    mem_00c6 = 0xc6
    mem_00c7 = 0xc7
    mem_00c8 = 0xc8
    mem_00c9 = 0xc9
    mem_00ca = 0xca
    mem_00cb = 0xcb
    mem_00cc = 0xcc
    mem_00cd = 0xcd
    mem_00ce = 0xce
    mem_00cf = 0xcf
    mem_00d0 = 0xd0
    mem_00d2 = 0xd2
    mem_00d3 = 0xd3
    mem_00d4 = 0xd4
    mem_00d5 = 0xd5
    mem_00d6 = 0xd6
    mem_00d7 = 0xd7
    mem_00d8 = 0xd8
    mem_00d9 = 0xd9
    mem_00da = 0xda
    mem_00db = 0xdb
    mem_00dc = 0xdc
    mem_00dd = 0xdd
    mem_00de = 0xde
    mem_00df = 0xdf
    mem_00e0 = 0xe0
    mem_00e1 = 0xe1
    mem_00e2 = 0xe2
    mem_00e3 = 0xe3
    mem_00e4 = 0xe4
    mem_00e5 = 0xe5
    mem_00e6 = 0xe6
    mem_00e7 = 0xe7
    mem_00e8 = 0xe8
    mem_00e9 = 0xe9
    mem_00ea = 0xea
    mem_00eb = 0xeb
    mem_00ed = 0xed
    mem_00ee = 0xee
    mem_00ef = 0xef
    mem_00f1 = 0xf1
    mem_00f2 = 0xf2
    mem_00f3 = 0xf3
    mem_00f4 = 0xf4
    mem_00f5 = 0xf5
    mem_00f6 = 0xf6
    mem_00f7 = 0xf7
    mem_00f8 = 0xf8
    mem_00f9 = 0xf9
    mem_00fa = 0xfa
    mem_00fb = 0xfb
    mem_00fc = 0xfc
    mem_00fd = 0xfd
    mem_00fe = 0xfe
    mem_0110 = 0x110
    mem_0111 = 0x111
    mem_0112 = 0x112
    mem_0113 = 0x113
    mem_0114 = 0x114
    mem_0115 = 0x115
    mem_0116 = 0x116
    mem_0117 = 0x117
    mem_0118 = 0x118
    mem_0119 = 0x119
    mem_011a = 0x11a
    mem_011b = 0x11b
    mem_011c = 0x11c
    mem_011d = 0x11d
    mem_011e = 0x11e
    mem_011f = 0x11f
    mem_012b = 0x12b
    mem_012c = 0x12c
    mem_012d = 0x12d
    mem_012e = 0x12e
    mem_012f = 0x12f
    mem_0130 = 0x130
    mem_0131 = 0x131
    mem_0133 = 0x133
    mem_0134 = 0x134
    mem_0136 = 0x136
    mem_0137 = 0x137
    mem_0139 = 0x139
    mem_013a = 0x13a
    mem_013e = 0x13e
    mem_013f = 0x13f
    mem_0140 = 0x140
    mem_0141 = 0x141
    mem_0142 = 0x142
    mem_0143 = 0x143
    mem_0144 = 0x144
    mem_0145 = 0x145
    mem_0146 = 0x146
    mem_0147 = 0x147
    mem_0148 = 0x148
    mem_0149 = 0x149
    mem_014d = 0x14d
    mem_0151 = 0x151
    mem_0155 = 0x155
    mem_0159 = 0x159
    mem_015b = 0x15b
    mem_015d = 0x15d
    mem_015f = 0x15f
    mem_0161 = 0x161
    mem_0163 = 0x163
    mem_0165 = 0x165
    mem_0167 = 0x167
    mem_016d = 0x16d
    mem_016e = 0x16e
    mem_016f = 0x16f
    mem_0170 = 0x170
    mem_0171 = 0x171
    mem_0172 = 0x172
    mem_0173 = 0x173
    mem_0174 = 0x174
    mem_0175 = 0x175
    mem_0176 = 0x176
    mem_0177 = 0x177
    mem_0178 = 0x178
    mem_017c = 0x17c
    mem_0182 = 0x182
    mem_0183 = 0x183
    mem_0186 = 0x186
    mem_0187 = 0x187
    mem_018d = 0x18d
    mem_018e = 0x18e
    mem_0190 = 0x190
    mem_0191 = 0x191
    mem_0192 = 0x192
    mem_0194 = 0x194
    mem_0196 = 0x196
    mem_0197 = 0x197
    mem_019b = 0x19b
    mem_019c = 0x19c
    mem_019d = 0x19d
    mem_019e = 0x19e
    mem_019f = 0x19f
    mem_01a1 = 0x1a1
    mem_01a4 = 0x1a4
    mem_01a5 = 0x1a5
    mem_01a6 = 0x1a6
    mem_01a7 = 0x1a7
    mem_01a8 = 0x1a8
    mem_01a9 = 0x1a9
    mem_01aa = 0x1aa
    mem_01ab = 0x1ab
    mem_01ac = 0x1ac
    mem_01ad = 0x1ad
    mem_01ae = 0x1ae
    mem_01af = 0x1af
    mem_01b0 = 0x1b0
    mem_01b1 = 0x1b1
    mem_01b2 = 0x1b2
    mem_01b3 = 0x1b3
    mem_01b4 = 0x1b4
    mem_01b5 = 0x1b5
    mem_01b6 = 0x1b6
    mem_01b7 = 0x1b7
    mem_01b8 = 0x1b8
    mem_01b9 = 0x1b9
    mem_01ba = 0x1ba
    mem_01bb = 0x1bb
    mem_01bc = 0x1bc
    mem_01bd = 0x1bd
    mem_01bf = 0x1bf
    mem_01c1 = 0x1c1
    mem_01c3 = 0x1c3
    mem_01c5 = 0x1c5
    mem_01c6 = 0x1c6
    mem_01c7 = 0x1c7
    mem_01c8 = 0x1c8
    mem_01c9 = 0x1c9
    mem_01cb = 0x1cb
    mem_01cc = 0x1cc
    mem_01cd = 0x1cd
    mem_01ce = 0x1ce
    mem_01cf = 0x1cf
    mem_01d0 = 0x1d0
    mem_01d1 = 0x1d1
    mem_01d2 = 0x1d2
    mem_01d3 = 0x1d3
    mem_01d4 = 0x1d4
    mem_01d6 = 0x1d6
    mem_01d8 = 0x1d8
    mem_01d9 = 0x1d9
    mem_01da = 0x1da
    mem_01db = 0x1db
    mem_01dc = 0x1dc
    mem_01dd = 0x1dd
    mem_01de = 0x1de
    mem_01df = 0x1df
    mem_01e0 = 0x1e0
    mem_01e1 = 0x1e1
    mem_01e2 = 0x1e2
    mem_01e3 = 0x1e3
    mem_01eb = 0x1eb
    mem_01ec = 0x1ec
    mem_01ed = 0x1ed
    mem_01ee = 0x1ee
    mem_01ef = 0x1ef
    mem_01f0 = 0x1f0
    mem_01f1 = 0x1f1
    mem_01f2 = 0x1f2
    mem_01f3 = 0x1f3
    mem_01f4 = 0x1f4
    mem_01f5 = 0x1f5
    mem_01f6 = 0x1f6
    mem_01f7 = 0x1f7
    mem_01f8 = 0x1f8
    mem_01f9 = 0x1f9
    mem_01fa = 0x1fa
    mem_01fb = 0x1fb
    mem_01fc = 0x1fc
    mem_01fd = 0x1fd
    mem_01fe = 0x1fe
    mem_01ff = 0x1ff
    mem_0200 = 0x200
    mem_0201 = 0x201
    mem_0202 = 0x202
    mem_0203 = 0x203
    mem_0205 = 0x205
    mem_0206 = 0x206
    mem_0208 = 0x208
    mem_020d = 0x20d
    mem_020e = 0x20e
    mem_020f = 0x20f
    mem_0211 = 0x211
    mem_0213 = 0x213
    mem_0214 = 0x214
    mem_0215 = 0x215
    mem_0216 = 0x216
    mem_0217 = 0x217
    mem_0218 = 0x218
    mem_0219 = 0x219
    mem_021a = 0x21a
    mem_021b = 0x21b
    mem_0222 = 0x222
    mem_0224 = 0x224
    mem_0226 = 0x226
    mem_0228 = 0x228
    mem_022f = 0x22f
    mem_0230 = 0x230
    mem_0231 = 0x231
    mem_0232 = 0x232
    mem_0233 = 0x233
    mem_0236 = 0x236
    mem_0237 = 0x237
    mem_0238 = 0x238
    mem_023e = 0x23e
    mem_0242 = 0x242
    mem_0243 = 0x243
    mem_0244 = 0x244
    mem_0245 = 0x245
    mem_0247 = 0x247
    mem_0249 = 0x249
    mem_024b = 0x24b
    mem_024d = 0x24d
    mem_024f = 0x24f
    mem_0251 = 0x251
    mem_0253 = 0x253
    mem_0254 = 0x254
    mem_0255 = 0x255
    mem_0265 = 0x265
    mem_026b = 0x26b
    mem_026c = 0x26c
    mem_026d = 0x26d
    mem_026e = 0x26e
    mem_0270 = 0x270
    mem_0271 = 0x271
    mem_0272 = 0x272
    mem_0273 = 0x273
    mem_0274 = 0x274
    mem_0275 = 0x275
    mem_0277 = 0x277
    mem_0281 = 0x281
    mem_0282 = 0x282
    mem_0283 = 0x283
    mem_0285 = 0x285
    mem_0286 = 0x286
    mem_0287 = 0x287
    mem_0288 = 0x288
    mem_0289 = 0x289
    mem_028a = 0x28a
    mem_028b = 0x28b
    mem_028c = 0x28c
    mem_028f = 0x28f
    mem_0290 = 0x290
    mem_0291 = 0x291
    mem_0292 = 0x292
    mem_0293 = 0x293
    mem_0294 = 0x294
    mem_0296 = 0x296
    mem_0297 = 0x297
    mem_0298 = 0x298
    mem_0299 = 0x299
    mem_029a = 0x29a
    mem_029b = 0x29b
    mem_029c = 0x29c
    mem_029d = 0x29d
    mem_029e = 0x29e
    mem_029f = 0x29f
    mem_02a0 = 0x2a0
    mem_02a1 = 0x2a1
    mem_02a3 = 0x2a3
    mem_02a4 = 0x2a4
    mem_02a5 = 0x2a5
    mem_02a7 = 0x2a7
    mem_02a9 = 0x2a9
    mem_02aa = 0x2aa
    mem_02ab = 0x2ab
    mem_02ac = 0x2ac
    mem_02ad = 0x2ad
    mem_02af = 0x2af
    mem_02b0 = 0x2b0
    mem_02b2 = 0x2b2
    mem_02b6 = 0x2b6
    mem_02b7 = 0x2b7
    mem_02c1 = 0x2c1
    mem_02c2 = 0x2c2
    mem_02c3 = 0x2c3
    mem_02c4 = 0x2c4
    mem_02c7 = 0x2c7
    mem_02c8 = 0x2c8
    mem_02cb = 0x2cb
    mem_02cc = 0x2cc
    mem_02cd = 0x2cd
    mem_02ce = 0x2ce
    mem_02cf = 0x2cf
    mem_02d1 = 0x2d1
    mem_02d2 = 0x2d2
    mem_02d3 = 0x2d3
    mem_02d4 = 0x2d4
    mem_02d5 = 0x2d5
    mem_02d6 = 0x2d6
    mem_02da = 0x2da
    mem_02de = 0x2de
    mem_02e0 = 0x2e0
    mem_02e1 = 0x2e1
    mem_02e2 = 0x2e2
    mem_02e4 = 0x2e4
    mem_02e5 = 0x2e5
    mem_02e6 = 0x2e6
    mem_02e8 = 0x2e8
    mem_02e9 = 0x2e9
    mem_02ee = 0x2ee
    mem_02f6 = 0x2f6
    mem_02fa = 0x2fa
    mem_02fb = 0x2fb
    mem_02fc = 0x2fc
    mem_02fd = 0x2fd
    mem_02fe = 0x2fe
    mem_02ff = 0x2ff
    mem_0300 = 0x300
    mem_0302 = 0x302
    mem_0303 = 0x303
    mem_0304 = 0x304
    mem_0305 = 0x305
    mem_0307 = 0x307
    mem_0308 = 0x308
    mem_0309 = 0x309
    mem_030a = 0x30a
    mem_030b = 0x30b
    mem_030c = 0x30c
    mem_030d = 0x30d
    mem_030e = 0x30e
    mem_030f = 0x30f
    mem_0310 = 0x310
    mem_0311 = 0x311
    mem_0312 = 0x312
    mem_0313 = 0x313
    mem_031b = 0x31b
    mem_031c = 0x31c
    mem_031d = 0x31d
    mem_031e = 0x31e
    mem_031f = 0x31f
    mem_0320 = 0x320
    mem_0321 = 0x321
    mem_0322 = 0x322
    mem_0323 = 0x323
    mem_0324 = 0x324
    mem_0325 = 0x325
    mem_0327 = 0x327
    mem_0328 = 0x328
    mem_0329 = 0x329
    mem_032a = 0x32a
    mem_032b = 0x32b
    mem_032c = 0x32c
    mem_032e = 0x32e
    mem_0330 = 0x330
    mem_0331 = 0x331
    mem_0332 = 0x332
    mem_0333 = 0x333
    mem_0334 = 0x334
    mem_0335 = 0x335
    mem_0336 = 0x336
    mem_0337 = 0x337
    mem_0339 = 0x339
    mem_033a = 0x33a
    mem_033b = 0x33b
    mem_033d = 0x33d
    mem_033e = 0x33e
    mem_033f = 0x33f
    mem_0341 = 0x341
    mem_0342 = 0x342
    mem_0343 = 0x343
    mem_0344 = 0x344
    mem_0345 = 0x345
    mem_0347 = 0x347
    mem_0349 = 0x349
    mem_034a = 0x34a
    mem_034b = 0x34b
    mem_034c = 0x34c
    mem_034d = 0x34d
    mem_034e = 0x34e
    mem_034f = 0x34f
    mem_0350 = 0x350
    mem_0351 = 0x351
    mem_0352 = 0x352
    mem_0355 = 0x355
    mem_0356 = 0x356
    mem_0357 = 0x357
    mem_0358 = 0x358
    mem_0359 = 0x359
    mem_035a = 0x35a
    mem_035b = 0x35b
    mem_035d = 0x35d
    mem_0360 = 0x360
    mem_0362 = 0x362
    mem_0364 = 0x364
    mem_0365 = 0x365
    mem_0367 = 0x367
    mem_0368 = 0x368
    mem_0369 = 0x369
    mem_036a = 0x36a
    mem_036b = 0x36b
    mem_036d = 0x36d
    mem_036e = 0x36e
    mem_0381 = 0x381
    mem_0384 = 0x384
    mem_0385 = 0x385
    mem_0386 = 0x386
    mem_0387 = 0x387
    mem_0388 = 0x388
    mem_0389 = 0x389
    mem_038a = 0x38a
    mem_038b = 0x38b
    mem_038c = 0x38c
    mem_038d = 0x38d
    mem_038f = 0x38f
    mem_0390 = 0x390
    mem_0391 = 0x391
    mem_0392 = 0x392
    mem_0393 = 0x393
    mem_0394 = 0x394
    mem_0395 = 0x395
    mem_0396 = 0x396
    mem_0397 = 0x397
    mem_0398 = 0x398
    mem_039a = 0x39a
    mem_039b = 0x39b
    mem_039c = 0x39c
    mem_039d = 0x39d
    mem_039f = 0x39f
    mem_03a0 = 0x3a0
    mem_03a1 = 0x3a1
    mem_03a2 = 0x3a2
    mem_03a3 = 0x3a3
    mem_03a5 = 0x3a5
    mem_03a7 = 0x3a7
    mem_03a9 = 0x3a9
    mem_03ab = 0x3ab
    mem_03ac = 0x3ac
    mem_03ad = 0x3ad
    mem_03ae = 0x3ae
    mem_03af = 0x3af
    mem_03b0 = 0x3b0
    mem_03b2 = 0x3b2
    mem_03b4 = 0x3b4
    mem_03b5 = 0x3b5
    mem_03b6 = 0x3b6
    mem_03b7 = 0x3b7
    mem_03b8 = 0x3b8
    mem_03c5 = 0x3c5
    mem_03c6 = 0x3c6
    mem_03c7 = 0x3c7
    mem_03cc = 0x3cc
    mem_03cd = 0x3cd
    mem_03ce = 0x3ce
    mem_03cf = 0x3cf
    mem_03d0 = 0x3d0
    mem_03d1 = 0x3d1
    mem_03d2 = 0x3d2
    mem_03d3 = 0x3d3
    mem_03d4 = 0x3d4
    mem_03d9 = 0x3d9
    mem_03da = 0x3da
    mem_03db = 0x3db
    mem_03dc = 0x3dc
    mem_03dd = 0x3dd
    mem_03de = 0x3de
    mem_03df = 0x3df
    mem_03e0 = 0x3e0
    mem_03e1 = 0x3e1
    mem_03e2 = 0x3e2
    mem_03e3 = 0x3e3
    mem_03e4 = 0x3e4

    .byte 0xFF              ;8000  ff          DATA '\xff'
    .byte 0xFF              ;8001  ff          DATA '\xff'
    .byte 0xFF              ;8002  ff          DATA '\xff'
    .byte 0xFF              ;8003  ff          DATA '\xff'
    .byte 0xFF              ;8004  ff          DATA '\xff'
    .byte 0xFF              ;8005  ff          DATA '\xff'
    .byte 0xFF              ;8006  ff          DATA '\xff'
    .byte 0x98              ;8007  98          DATA '\x98'
    .byte 0x12              ;8008  12          DATA '\x12'
    .byte 0x18              ;8009  18          DATA '\x18'

mem_800a:
    .byte 0x00              ;800a  00          DATA '\x00'
    .byte 0x06              ;800b  06          DATA '\x06'
    .byte 0x07              ;800c  07          DATA '\x07'
    .byte 0x14              ;800d  14          DATA '\x14'
    .byte 0xDF              ;800e  df          DATA '\xdf'
    .byte 0xEF              ;800f  ef          DATA '\xef'

reset_8010:
    movw a, #0x047f         ;8010  e4 04 7f
    movw sp, a              ;8013  e1
    movw a, #0x0030         ;8014  e4 00 30
    movw ps, a              ;8017  71
    setb sycc:0             ;8018  a8 07
    setb sycc:1             ;801a  a9 07
    clrb pdr2:4             ;801c  a4 04        audio mute = low (muted)
    mov pdr2, #0x80         ;801e  85 04 80
    mov pdr4, #0x77         ;8021  85 0e 77
    mov ddr4, #0xb9         ;8024  85 0f b9
    mov pdr0, #0x4f         ;8027  85 00 4f
    mov ddr0, #0xb2         ;802a  85 01 b2
    mov pdr1, #0x86         ;802d  85 02 86
    mov ddr1, #0x79         ;8030  85 03 79
    mov pdr3, #0x0f         ;8033  85 0c 0f
    mov ddr3, #0x6f         ;8036  85 0d 6f
    mov pdr5, #0xff         ;8039  85 10 ff
    mov pdr6, #0xff         ;803c  85 11 ff
    mov ppcr, #0x00         ;803f  85 12 00
    mov pdr7, #0x7e         ;8042  85 13 7e
    mov pdr8, #0x68         ;8045  85 14 68

    movw ix, #mem_0080      ;8048  e6 00 80
lab_804b:
    mov a, #0x00            ;804b  04 00
    mov @ix+0x00, a         ;804d  46 00
    incw ix                 ;804f  c2
    movw a, ix              ;8050  f2
    movw a, #0x047f         ;8051  e4 04 7f
    cmpw a                  ;8054  13
    bne lab_804b            ;8055  fc f4

    movw a, #0x010e         ;8057  e4 01 0e
    movw mem_01bd, a        ;805a  d4 01 bd
    movw a, #0x0212         ;805d  e4 02 12
    movw mem_01bf, a        ;8060  d4 01 bf
    call sub_8135           ;8063  31 81 35

    jmp reset_8010          ;8066  21 80 10

;XXX 8069 looks unreachable
lab_8069:
    nop                     ;8069  00
    jmp lab_8069            ;806a  21 80 69


irq0_806d:
;irq0 (external interrupt 1)
;edge-detect pins INT0-3
    pushw a                 ;806d  40
    xchw a, t               ;806e  43
    pushw a                 ;806f  40
    pushw ix                ;8070  41
    movw a, ep              ;8071  f3
    pushw a                 ;8072  40
    bbc eic2:7, lab_807e    ;8073  b7 39 08     Branch if edge not detected on INT3 pin (/SCA_CLK_IN)
    clrb eic2:7             ;8076  a7 39        Clear INT3 pin edge detect status (/SCA_CLK_IN)
    call sub_d9c4           ;8078  31 d9 c4
    call sub_c259           ;807b  31 c2 59

lab_807e:
    bbc eic1:7, lab_8086    ;807e  b7 38 05     Branch if edge not detected on INT1 pin (/S2M_CLK_IN)
    clrb eic1:7             ;8081  a7 38        Clear INT1 pin edge detect status (/S2M_CLK_IN)
    call sub_e87b           ;8083  31 e8 7b

lab_8086:
    mov a, mem_0385         ;8086  60 03 85
    mov a, #0x01            ;8089  04 01
    cmp a                   ;808b  12
    beq lab_8093            ;808c  fd 05
    bbc eic2:3, lab_8093    ;808e  b3 39 02     Branch if edge not detected on INT2 pin (/DIAG_RX)
    clrb eic2:3             ;8091  a3 39        Clear INT2 pin edge detect status (/DIAG_RX)

lab_8093:
    bbc eic1:3, lab_809b    ;8093  b3 38 05     Branch if edge not detected on INT0 pin (/VOLUME_IN)
    clrb eic1:3             ;8096  a3 38        Clear INT0 pin edge detect status (/VOLUME_IN)
    call sub_fa5d           ;8098  31 fa 5d

lab_809b:
    jmp finish_isr          ;809b  21 81 2e


irq1_809e:
;irq1 (external interrupt 2)
;level-detect pins INT4-7
    pushw a                 ;809e  40
    xchw a, t               ;809f  43
    pushw a                 ;80a0  40
    pushw ix                ;80a1  41
    movw a, ep              ;80a2  f3
    pushw a                 ;80a3  40
    bbc eif2:0, lab_80a9    ;80a4  b0 3b 02     Branch if level not detected on INT4 pin (SCA_SWITCH)
    clrb eif2:0             ;80a7  a0 3b        Clear INT4 level detect status (SCA_SWITCH)

lab_80a9:
    bbc eif2:1, lab_80b1    ;80a9  b1 3b 05     Branch if level not detected on INT5 pin (/S2M_ENABLE)
    clrb eif2:1             ;80ac  a1 3b        Clear INT5 level detect status (/S2M_ENABLE)
    call sub_e8e0           ;80ae  31 e8 e0

lab_80b1:
    bbc eif2:2, lab_80b6    ;80b1  b2 3b 02     Branch if level not detected on INT6 pin (/ACC_IN)
    clrb eif2:2             ;80b4  a2 3b        Clear INT6 level detect status (/ACC_IN)

lab_80b6:
    bbc eif2:3, lab_80bb    ;80b6  b3 3b 02     Branch if level not detected on INT7 pin (/POWER_OR_EJECT)
    clrb eif2:3             ;80b9  a3 3b        Clear INT7 level detect status (/POWER_OR_EJECT)

lab_80bb:
    jmp finish_isr          ;80bb  21 81 2e


irq2_80be:
;irq2 (16-bit timer counter)
    pushw a                 ;80be  40
    xchw a, t               ;80bf  43
    pushw a                 ;80c0  40
    mov tmcr, #0x00         ;80c1  85 18 00
    movw a, #0xf855         ;80c4  e4 f8 55
    movw tchr, a            ;80c7  d5 19        16-bit timer count register
    mov tmcr, #0x23         ;80c9  85 18 23
    clrb tmcr:2             ;80cc  a2 18
    pushw ix                ;80ce  41
    movw a, ep              ;80cf  f3
    pushw a                 ;80d0  40
    call sub_a914           ;80d1  31 a9 14
    jmp finish_isr          ;80d4  21 81 2e


irq5_80d7:
;irq5 (2ch 8-bit pwm timer)
    pushw a                 ;80d7  40
    xchw a, t               ;80d8  43
    pushw a                 ;80d9  40
    pushw ix                ;80da  41
    movw a, ep              ;80db  f3
    pushw a                 ;80dc  40
    bbc cntr:2, lab_80e5    ;80dd  b2 16 05
    clrb cntr:2             ;80e0  a2 16
    call sub_ef56           ;80e2  31 ef 56

lab_80e5:
    bbc cntr4:2, lab_80ed   ;80e5  b2 48 05
    clrb cntr4:2            ;80e8  a2 48
    call submcu_send_packet ;80ea  31 e8 3a

lab_80ed:
    bbc cntr5:2, lab_80f2   ;80ed  b2 4a 02
    clrb cntr5:2            ;80f0  a2 4a

lab_80f2:
    bbc cntr6:2, lab_80f7   ;80f2  b2 4c 02
    clrb cntr6:2            ;80f5  a2 4c

lab_80f7:
    jmp finish_isr          ;80f7  21 81 2e


irq6_80fa:
;irq6 (8-bit pwm timer #3 (#4, #5, #6))
    pushw a                 ;80fa  40
    xchw a, t               ;80fb  43
    pushw a                 ;80fc  40
    pushw ix                ;80fd  41
    movw a, ep              ;80fe  f3
    pushw a                 ;80ff  40
    bbc cntr2:3, finish_isr ;8100  b3 29 2b
    clrb cntr2:3            ;8103  a3 29
    call sub_ef8b           ;8105  31 ef 8b
    jmp finish_isr          ;8108  21 81 2e


irq8_810b:
;irq8 (uart)
    pushw a                 ;810b  40
    xchw a, t               ;810c  43
    pushw a                 ;810d  40
    pushw ix                ;810e  41
    movw a, ep              ;810f  f3
    pushw a                 ;8110  40
    bbc mem_008c:7, lab_811a ;8111  b7 8c 06
    call sub_b280           ;8114  31 b2 80
    jmp finish_isr          ;8117  21 81 2e

lab_811a:
    call sub_e0f3           ;811a  31 e0 f3
    jmp finish_isr            ;811d  21 81 2e


irq7_8120:
;irq7 (8-bit serial i/o)
    pushw a                 ;8120  40
    xchw a, t               ;8121  43
    pushw a                 ;8122  40
    pushw ix                ;8123  41
    movw a, ep              ;8124  f3
    pushw a                 ;8125  40
    bbc smr:7, finish_isr   ;8126  b7 1c 05
    clrb smr:7              ;8129  a7 1c
    call sub_ef32           ;812b  31 ef 32


finish_isr:
    popw a                  ;812e  50
    movw ep, a              ;812f  e3
    popw ix                 ;8130  51
    popw a                  ;8131  50
    xchw a, t               ;8132  43
    popw a                  ;8133  50
    reti                    ;8134  30

sub_8135:
    call sub_826e           ;8135  31 82 6e


main_loop:
    call sub_8225           ;8138  31 82 25
    call sub_a526           ;813b  31 a5 26
    call sub_e790           ;813e  31 e7 90    Build and schedule Main-to-Sub packet
    call sub_e81b           ;8141  31 e8 1b    Process Sub-to-Main packet
    call sub_843f           ;8144  31 84 3f
    cmp mem_0096, #0x01     ;8147  95 96 01
    beq lab_816c            ;814a  fd 20
    bbc mem_0098:1, lab_8160 ;814c  b1 98 11
    bbs mem_008c:7, lab_815a ;814f  bf 8c 08
    clrb mem_0098:1         ;8152  a1 98
    call sub_85c5           ;8154  31 85 c5
    jmp lab_8160            ;8157  21 81 60

lab_815a:
    mov a, mem_0236         ;815a  60 02 36
    mov mem_0323, a         ;815d  61 03 23

lab_8160:
    call sub_9582           ;8160  31 95 82
    call sub_9a40           ;8163  31 9a 40
    call sub_9ed8           ;8166  31 9e d8
    call sub_e8fb           ;8169  31 e8 fb

lab_816c:
    call sub_d9d3           ;816c  31 d9 d3
    cmp mem_0096, #0x01     ;816f  95 96 01
    bne lab_8179            ;8172  fc 05
    mov a, #0x01            ;8174  04 01
    mov mem_0303, a         ;8176  61 03 03

lab_8179:
    mov a, mem_0303         ;8179  60 03 03
    incw a                  ;817c  c0
    mov mem_0303, a         ;817d  61 03 03

    mov a, mem_0303         ;8180  60 03 03     A = table index
    movw a, #mem_81a8       ;8183  e4 81 a8     A = table base address
    call sub_e73c           ;8186  31 e7 3c     Call address in table

    bbc mem_008c:7, lab_818f ;8189  b7 8c 03
    call sub_abf6           ;818c  31 ab f6

lab_818f:
    call sub_cbea           ;818f  31 cb ea
    call sub_824d           ;8192  31 82 4d
    cmp mem_0096, #0x01     ;8195  95 96 01
    beq lab_819d            ;8198  fd 03
    call sub_8d2f           ;819a  31 8d 2f

lab_819d:
    bbc mem_00d0:6, lab_81a5 ;819d  b6 d0 05
    clrb mem_00d0:6         ;81a0  a6 d0
    call sub_dad3           ;81a2  31 da d3

lab_81a5:
    jmp main_loop            ;81a5  21 81 38


mem_81a8:
;case table for mem_0303
    .word lab_81fa          ;81a8  81 fa       VECTOR
    .word lab_81b4          ;81aa  81 b4       VECTOR
    .word lab_81f7          ;81ac  81 f7       VECTOR
    .word lab_81fb          ;81ae  81 fb       VECTOR
    .word lab_820d          ;81b0  82 0d       VECTOR
    .word lab_821c          ;81b2  82 1c       VECTOR

lab_81b4:
    bbc mem_0098:4, lab_81bc ;81b4  b4 98 05
    clrb mem_0098:4         ;81b7  a4 98
    jmp lab_81da            ;81b9  21 81 da

lab_81bc:
    bbs mem_00df:4, lab_81da ;81bc  bc df 1b
    cmp mem_0095, #0x01     ;81bf  95 95 01
    bne lab_81d5            ;81c2  fc 11
    mov a, mem_00f6         ;81c4  05 f6
    mov a, mem_0330         ;81c6  60 03 30
    cmp a                   ;81c9  12
    beq lab_81d5            ;81ca  fd 09
    callv #5                ;81cc  ed          CALLV #5 = callv5_8d0d
    mov a, mem_00f6         ;81cd  05 f6
    mov mem_0330, a         ;81cf  61 03 30
    jmp lab_81da            ;81d2  21 81 da

lab_81d5:
    mov a, mem_02c1         ;81d5  60 02 c1
    bne lab_81f6            ;81d8  fc 1c

lab_81da:
    cmp mem_0096, #0x0b     ;81da  95 96 0b
    beq lab_81f6            ;81dd  fd 17
    cmp mem_0096, #0x0a     ;81df  95 96 0a
    bne lab_81e7            ;81e2  fc 03
    bbc mem_008c:7, lab_81f6 ;81e4  b7 8c 0f

lab_81e7:
    call sub_c5d2           ;81e7  31 c5 d2
    mov a, mem_02b7         ;81ea  60 02 b7
    bne lab_81f1            ;81ed  fc 02
    clrb mem_0097:2         ;81ef  a2 97

lab_81f1:
    mov a, #0x05            ;81f1  04 05
    mov mem_02c1, a         ;81f3  61 02 c1

lab_81f6:
    ret                     ;81f6  20

lab_81f7:
    call sub_9fdd           ;81f7  31 9f dd

lab_81fa:
    ret                     ;81fa  20

lab_81fb:
    bbs mem_0098:6, lab_8207 ;81fb  be 98 09
    bbs mem_008c:7, lab_820c ;81fe  bf 8c 0b
    bbs mem_00da:0, lab_8207 ;8201  b8 da 03
    bbc mem_00e5:1, lab_820c ;8204  b1 e5 05

lab_8207:
    clrb mem_0098:6         ;8207  a6 98
    call sub_aa0e           ;8209  31 aa 0e

lab_820c:
    ret                     ;820c  20

lab_820d:
    mov a, mem_0095         ;820d  05 95
    bne lab_821b            ;820f  fc 0a
    mov a, mem_00c5         ;8211  05 c5
    beq lab_821b            ;8213  fd 06
    bbs mem_008c:7, lab_821b ;8215  bf 8c 03
    call sub_f2e5           ;8218  31 f2 e5

lab_821b:
    ret                     ;821b  20

lab_821c:
    call sub_c30d           ;821c  31 c3 0d
    mov a, #0x00            ;821f  04 00
    mov mem_0303, a         ;8221  61 03 03
    ret                     ;8224  20

sub_8225:
    mov a, mem_00d3         ;8225  05 d3
    mov a, mem_00d4         ;8227  05 d4
    or a                    ;8229  72
    mov mem_00d4, a         ;822a  45 d4
    bbc mem_00d4:4, lab_8233 ;822c  b4 d4 04
    clrb mem_00d4:4         ;822f  a4 d4
    setb mem_0097:3         ;8231  ab 97

lab_8233:
    bbc mem_00d4:5, lab_823a ;8233  b5 d4 04
    clrb mem_00d4:5         ;8236  a5 d4
    setb mem_0097:4         ;8238  ac 97

lab_823a:
    bbc mem_00d4:6, lab_8241 ;823a  b6 d4 04
    clrb mem_00d4:6         ;823d  a6 d4
    setb mem_0098:6         ;823f  ae 98

lab_8241:
    bbc mem_00d4:7, lab_8248 ;8241  b7 d4 04
    clrb mem_00d4:7         ;8244  a7 d4
    setb mem_00d9:4         ;8246  ac d9

lab_8248:
    mov a, #0x00            ;8248  04 00
    mov mem_00d3, a         ;824a  45 d3
    ret                     ;824c  20

sub_824d:
    bbc mem_0097:0, lab_8256 ;824d  b0 97 06
    call sub_c846           ;8250  31 c8 46
    clrb mem_0097:0         ;8253  a0 97
    ret                     ;8255  20

lab_8256:
    bbc mem_0098:7, lab_825f ;8256  b7 98 06
    call sub_c941           ;8259  31 c9 41
    clrb mem_0098:7         ;825c  a7 98
    ret                     ;825e  20

lab_825f:
    bbc mem_0097:1, lab_826d ;825f  b1 97 0b
    call sub_c9e3           ;8262  31 c9 e3
    bbc mem_00c0:7, lab_826d ;8265  b7 c0 05
    call sub_cb09           ;8268  31 cb 09
    clrb mem_00c0:7         ;826b  a7 c0

lab_826d:
    ret                     ;826d  20

sub_826e:
    mov ilr1, #0xe0         ;826e  85 7c e0
    mov ilr2, #0x0b         ;8271  85 7d 0b
    mov ilr3, #0xbc         ;8274  85 7e bc
    movw a, #0xf855         ;8277  e4 f8 55
    movw tchr, a            ;827a  d5 19        16-bit timer count register
    mov tmcr, #0x23         ;827c  85 18 23
    mov eic1, #0x37         ;827f  85 38 37
    mov eic2, #0b01000000   ;8282  85 39 40
    mov eie2, #0b00000010   ;8285  85 3a 02
    mov eif2, #0x00         ;8288  85 3b 00
    mov uscr, #0b00001000   ;828b  85 41 08     Set UART's TXOE to serial data output enabled,
                            ;                   everything else diabled

    movw a, #0xffff         ;828e  e4 ff ff
    movw mem_008f, a        ;8291  d5 8f

    movw mem_0398, a        ;8293  d4 03 98

    mov a, #0x01            ;8296  04 01
    mov mem_0113, a         ;8298  61 01 13

    mov smr, #0x4f          ;829b  85 1c 4f
    mov a, #0x00            ;829e  04 00
    mov mem_0095, a         ;82a0  45 95
    mov mem_02c2, a         ;82a2  61 02 c2
    mov mem_02c4, a         ;82a5  61 02 c4
    mov a, #0x01            ;82a8  04 01
    mov mem_00c5, a         ;82aa  45 c5
    mov mem_00c6, a         ;82ac  45 c6
    setb mem_00c9:5         ;82ae  ad c9
    call sub_8380           ;82b0  31 83 80
    mov a, #0x43            ;82b3  04 43
    mov mem_00f7, a         ;82b5  45 f7
    mov a, #0x02            ;82b7  04 02
    mov mem_03ce, a         ;82b9  61 03 ce
    call sub_83f8           ;82bc  31 83 f8
    mov a, #0x04            ;82bf  04 04
    mov mem_01f0, a         ;82c1  61 01 f0
    mov a, #0x08            ;82c4  04 08
    mov mem_01f1, a         ;82c6  61 01 f1
    mov a, #0x0b            ;82c9  04 0b
    mov mem_01f2, a         ;82cb  61 01 f2
    mov a, #0x0b            ;82ce  04 0b
    mov mem_01f3, a         ;82d0  61 01 f3
    mov a, #0x0d            ;82d3  04 0d
    mov mem_01f4, a         ;82d5  61 01 f4
    mov a, #0x0f            ;82d8  04 0f
    mov mem_01f5, a         ;82da  61 01 f5
    mov a, #0x98            ;82dd  04 98
    mov mem_01f6, a         ;82df  61 01 f6
    mov a, #0x50            ;82e2  04 50
    mov mem_01f7, a         ;82e4  61 01 f7
    mov a, #0x30            ;82e7  04 30
    mov mem_01f8, a         ;82e9  61 01 f8
    mov a, #0x75            ;82ec  04 75
    mov mem_02a5, a         ;82ee  61 02 a5
    mov a, #0x0d            ;82f1  04 0d
    mov mem_0292, a         ;82f3  61 02 92
    mov a, #0x15            ;82f6  04 15
    mov mem_0291, a         ;82f8  61 02 91
    movw a, #0x0800         ;82fb  e4 08 00
    movw mem_0294, a        ;82fe  d4 02 94
    call sub_83d1           ;8301  31 83 d1
    mov mem_00e9, #0xff     ;8304  85 e9 ff
    setb mem_00ca:6         ;8307  ae ca
    clrb mem_00e9:6         ;8309  a6 e9
    clrb mem_008d:0         ;830b  a0 8d
    call sub_8421           ;830d  31 84 21
    call sub_b9dd           ;8310  31 b9 dd
    call sub_ba0e           ;8313  31 ba 0e

    mov mem_0091, #0b00001000 ;8316  85 91 08

    movw a, #0x0000         ;8319  e4 00 00     Clear fault:
    movw mem_0161, a        ;831c  d4 01 61     KW1281 Fault 65535 Internal Memory Error
    movw a, #0x8800         ;831f  e4 88 00
    movw mem_0163, a        ;8322  d4 01 63

    mov a, #0x00            ;8325  04 00
    mov mem_0307, a         ;8327  61 03 07
    movw a, #0x0000         ;832a  e4 00 00
    movw mem_039f, a        ;832d  d4 03 9f

    call sub_e5ae           ;8330  31 e5 ae     Unknown, uses mem_e5aa table

    movw a, mem_03ab        ;8333  c4 03 ab
    movw mem_03b0, a        ;8336  d4 03 b0
    movw a, mem_03ad        ;8339  c4 03 ad
    movw mem_03b2, a        ;833c  d4 03 b2
    mov a, #0x20            ;833f  04 20
    mov mem_00ae, a         ;8341  45 ae
    mov mem_00cb, a         ;8343  45 cb
    mov mem_02cb, a         ;8345  61 02 cb
    setb mem_00c9:0         ;8348  a8 c9
    setb mem_0099:0         ;834a  a8 99
    setb mem_00d0:7         ;834c  af d0
    setb mem_00d0:3         ;834e  ab d0
    mov a, #0x05            ;8350  04 05
    mov mem_02a7, a         ;8352  61 02 a7
    mov a, #0x05            ;8355  04 05
    mov mem_02a9, a         ;8357  61 02 a9
    mov a, #0x02            ;835a  04 02
    mov mem_02aa, a         ;835c  61 02 aa
    mov a, #0x0a            ;835f  04 0a
    mov mem_02ab, a         ;8361  61 02 ab
    mov mem_0096, #0x01     ;8364  85 96 01
    mov a, #0x01            ;8367  04 01
    mov mem_00cd, a         ;8369  45 cd
    mov mem_0214, a         ;836b  61 02 14
    call sub_dbba           ;836e  31 db ba
    mov mem_0095, #0x0f     ;8371  85 95 0f
    mov a, #0x00            ;8374  04 00
    mov mem_02ff, a         ;8376  61 02 ff
    call sub_cdbf           ;8379  31 cd bf
    setb mem_00cf:7         ;837c  af cf
    seti                    ;837e  90
    ret                     ;837f  20

sub_8380:
    movw ix, #mem_01a5      ;8380  e6 01 a5
    mov @ix+0x00, #0x00     ;8383  86 00 00
    mov @ix+0x01, #0x00     ;8386  86 01 00
    mov @ix+0x02, #0x07     ;8389  86 02 07
    mov @ix+0x03, #0x2f     ;838c  86 03 2f
    mov @ix+0x04, #0x34     ;838f  86 04 34
    mov @ix+0x05, #0x57     ;8392  86 05 57
    mov @ix+0x06, #0x76     ;8395  86 06 76

    movw ix, #mem_01ac      ;8398  e6 01 ac
    mov @ix+0x00, #0x02     ;839b  86 00 02
    mov @ix+0x01, #0x06     ;839e  86 01 06
    mov @ix+0x02, #0x1f     ;83a1  86 02 1f
    mov @ix+0x03, #0x38     ;83a4  86 03 38
    mov @ix+0x04, #0x5b     ;83a7  86 04 5b
    mov @ix+0x05, #0x64     ;83aa  86 05 64
    mov @ix+0x06, #0x64     ;83ad  86 06 64

    movw ix, #mem_01b3      ;83b0  e6 01 b3
    mov @ix+0x00, #0x00     ;83b3  86 00 00
    mov @ix+0x01, #0x00     ;83b6  86 01 00
    mov @ix+0x02, #0x01     ;83b9  86 02 01
    mov @ix+0x03, #0x33     ;83bc  86 03 33
    mov @ix+0x04, #0x51     ;83bf  86 04 51
    mov @ix+0x05, #0x64     ;83c2  86 05 64
    mov @ix+0x06, #0x64     ;83c5  86 06 64

    mov a, mem_01ac         ;83c8  60 01 ac
    mov mem_00c7, a         ;83cb  45 c7
    call sub_c2a2           ;83cd  31 c2 a2
    ret                     ;83d0  20

sub_83d1:
    mov a, #0x00            ;83d1  04 00
    mov mem_00b1, a         ;83d3  45 b1
    mov mem_00b3, a         ;83d5  45 b3
    mov mem_00b4, a         ;83d7  45 b4
    mov mem_00b5, a         ;83d9  45 b5
    mov mem_00b6, a         ;83db  45 b6
    mov a, #0x00            ;83dd  04 00
    mov mem_0296, a         ;83df  61 02 96
    mov mem_0297, a         ;83e2  61 02 97
    mov mem_0298, a         ;83e5  61 02 98
    mov mem_0299, a         ;83e8  61 02 99
    mov mem_029a, a         ;83eb  61 02 9a
    mov mem_029b, a         ;83ee  61 02 9b
    mov mem_029c, a         ;83f1  61 02 9c
    mov mem_029d, a         ;83f4  61 02 9d
    ret                     ;83f7  20

sub_83f8:
    mov a, #0x32            ;83f8  04 32
    mov mem_0290, a         ;83fa  61 02 90
    setb mem_00de:2         ;83fd  aa de
    setb mem_00de:1         ;83ff  a9 de
    ret                     ;8401  20

sub_8402:
    call sub_ba0e           ;8402  31 ba 0e

    movw a, #0x0414         ;8405  e4 04 14     KW1281 Fault 01044 Control Module Incorrectly Coded
    movw mem_0165, a        ;8408  d4 01 65
    movw a, #0x2332         ;840b  e4 23 32
    movw mem_0167, a        ;840e  d4 01 67

    mov mem_0091, #0b00001000     ;8411  85 91 08

    movw a, #0xffff         ;8414  e4 ff ff     KW1281 Fault 65535 Internal Memory Error
    movw mem_0161, a        ;8417  d4 01 61
    movw a, #0x8800         ;841a  e4 88 00
    movw mem_0163, a        ;841d  d4 01 63

    ret                     ;8420  20

sub_8421:
    movw a, #0x0320         ;8421  e4 03 20
    movw mem_0175, a        ;8424  d4 01 75
    movw a, #0x0000         ;8427  e4 00 00
    movw mem_0177, a        ;842a  d4 01 77
    mov a, #0x00            ;842d  04 00
    mov mem_019d, a         ;842f  61 01 9d
    mov a, #0x04            ;8432  04 04
    mov mem_019e, a         ;8434  61 01 9e
    mov a, #0x00            ;8437  04 00
    mov mem_019f, a         ;8439  61 01 9f
    clrb mem_008d:1         ;843c  a1 8d
    ret                     ;843e  20

sub_843f:
    call sub_8477           ;843f  31 84 77
    call sub_84b8           ;8442  31 84 b8
    clrc                    ;8445  81
    bbc pdr4:2, lab_844a    ;8446  b2 0e 01     /CONTROL+
    setc                    ;8449  91

lab_844a:
    mov a, mem_0242         ;844a  60 02 42
    movw ix, #mem_0242      ;844d  e6 02 42
    mov mem_009e, #0x0a     ;8450  85 9e 0a
    call sub_852d           ;8453  31 85 2d
    ret                     ;8456  20

sub_8457:
    mov mem_00a2, #0x05     ;8457  85 a2 05
    mov mem_00a0, #0x00     ;845a  85 a0 00

lab_845d:
    mov a, mem_00c5         ;845d  05 c5
    bne lab_8471            ;845f  fc 10
    bbc pdr0:3, lab_8470    ;8461  b3 00 0c     AM_SD

lab_8464:
    mov a, mem_00a2         ;8464  05 a2
    decw a                  ;8466  d0
    mov mem_00a2, a         ;8467  45 a2
    cmp a, #0x00            ;8469  14 00
    bne lab_845d            ;846b  fc f0
    mov mem_00a0, #0x03     ;846d  85 a0 03

lab_8470:
    ret                     ;8470  20

lab_8471:
    bbc pdr0:2, lab_8470    ;8471  b2 00 fc     FM_SD
    jmp lab_8464            ;8474  21 84 64

sub_8477:
    call sub_8512           ;8477  31 85 12
    bhs lab_8496            ;847a  f8 1a
    mov a, mem_00d2         ;847c  05 d2
    beq lab_8484            ;847e  fd 04
    cmp a, #0x08            ;8480  14 08
    bne lab_8496            ;8482  fc 12

lab_8484:
    mov a, mem_00ea         ;8484  05 ea
    mov a, pdr6             ;8486  05 11
    and a, #0b01000000      ;8488  64 40    mask off all except bit 6 (pdr6:6 = /ACC_IN)
    mov mem_00ea, a         ;848a  45 ea
    xor a                   ;848c  52
    beq lab_8497            ;848d  fd 08
    mov a, #0x02            ;848f  04 02
    mov mem_0251, a         ;8491  61 02 51
    setb mem_00eb:3         ;8494  ab eb

lab_8496:
    ret                     ;8496  20

lab_8497:
    bbc mem_00eb:3, lab_8496 ;8497  b3 eb fc
    movw a, #0x0000         ;849a  e4 00 00
    mov a, mem_0251         ;849d  60 02 51
    decw a                  ;84a0  d0
    mov mem_0251, a         ;84a1  61 02 51
    bne lab_8496            ;84a4  fc f0
    clrb mem_00eb:3         ;84a6  a3 eb
    clrb mem_00eb:6         ;84a8  a6 eb
    mov a, mem_00ea         ;84aa  05 ea
    or a, mem_00eb          ;84ac  75 eb
    mov mem_00eb, a         ;84ae  45 eb
    bbs mem_008c:7, lab_8496 ;84b0  bf 8c e3
    setb mem_00eb:0         ;84b3  a8 eb
    jmp lab_8496            ;84b5  21 84 96

sub_84b8:
    call sub_8512           ;84b8  31 85 12
    bhs lab_8511            ;84bb  f8 54
    mov a, mem_00d2         ;84bd  05 d2
    beq lab_84c5            ;84bf  fd 04
    cmp a, #0x08            ;84c1  14 08
    bne lab_8511            ;84c3  fc 4c

lab_84c5:
    clrc                    ;84c5  81
    bbc pdr7:5, lab_84ca    ;84c6  b5 13 01     /POWER_OR_EJECT
    setc                    ;84c9  91

lab_84ca:
    mov a, mem_0243         ;84ca  60 02 43
    movw ix, #mem_0243      ;84cd  e6 02 43
    mov mem_009e, #0x03     ;84d0  85 9e 03
    call sub_852d           ;84d3  31 85 2d
    clrc                    ;84d6  81
    bbc pdr6:7, lab_84db    ;84d7  b7 11 01     /POWER_EJECT_SW
    setc                    ;84da  91

lab_84db:
    mov a, mem_0254         ;84db  60 02 54
    movw ix, #mem_0254      ;84de  e6 02 54
    mov mem_009e, #0x06     ;84e1  85 9e 06
    call sub_852d           ;84e4  31 85 2d
    and a, #0x80            ;84e7  64 80
    bne lab_8506            ;84e9  fc 1b
    mov a, mem_0253         ;84eb  60 02 53
    bne lab_8511            ;84ee  fc 21
    mov a, mem_0243         ;84f0  60 02 43
    and a, #0x80            ;84f3  64 80
    beq lab_8500            ;84f5  fd 09
    bbs mem_008c:7, lab_8511 ;84f7  bf 8c 17
    setb mem_00ed:1         ;84fa  a9 ed
    mov a, #0x02            ;84fc  04 02
    bne lab_850e            ;84fe  fc 0e        BRANCH_ALWAYS_TAKEN

lab_8500:
    setb mem_00ed:0         ;8500  a8 ed
    mov a, #0x01            ;8502  04 01
    bne lab_850e            ;8504  fc 08        BRANCH_ALWAYS_TAKEN

lab_8506:
    bbs mem_00ed:1, lab_8511 ;8506  b9 ed 08
    bbs mem_00ed:0, lab_8511 ;8509  b8 ed 05
    mov a, #0x00            ;850c  04 00

lab_850e:
    mov mem_0253, a         ;850e  61 02 53

lab_8511:
    ret                     ;8511  20

sub_8512:
    mov a, mem_0096         ;8512  05 96
    cmp mem_0096, #0x05     ;8514  95 96 05
    bne lab_8527            ;8517  fc 0e
    mov a, mem_00cd         ;8519  05 cd
    cmp a, #0x01            ;851b  14 01
    beq lab_8525            ;851d  fd 06
    cmp a, #0x02            ;851f  14 02
    beq lab_8525            ;8521  fd 02

lab_8523:
    setc                    ;8523  91
    ret                     ;8524  20

lab_8525:
    clrc                    ;8525  81
    ret                     ;8526  20

lab_8527:
    cmp a, #0x01            ;8527  14 01
    beq lab_8525            ;8529  fd fa
    bne lab_8523            ;852b  fc f6        BRANCH_ALWAYS_TAKEN

sub_852d:
    bnc lab_853f            ;852d  f8 10
    rolc a                  ;852f  02
    bc lab_8538             ;8530  f9 06
    rorc a                  ;8532  03
    decw a                  ;8533  d0
    cmp a, #0xff            ;8534  14 ff
    bne lab_854a            ;8536  fc 12

lab_8538:
    mov a, mem_009e         ;8538  05 9e
    xor a, #0xff            ;853a  54 ff
    jmp lab_854a            ;853c  21 85 4a

lab_853f:
    rolc a                  ;853f  02
    bhs lab_8548            ;8540  f8 06
    rorc a                  ;8542  03
    incw a                  ;8543  c0
    cmp a, #0x00            ;8544  14 00
    bne lab_854a            ;8546  fc 02

lab_8548:
    mov a, mem_009e         ;8548  05 9e

lab_854a:
    mov @ix+0x00, a         ;854a  46 00
    ret                     ;854c  20

sub_854d:
    mov adc2, #0x01         ;854d  85 21 01
    mov a, #0x00            ;8550  04 00
    movw ix, #mem_024f      ;8552  e6 02 4f
    call sub_8571           ;8555  31 85 71
    mov a, #0x10            ;8558  04 10
    movw ix, #mem_0247      ;855a  e6 02 47
    call sub_8571           ;855d  31 85 71
    mov a, #0x20            ;8560  04 20
    movw ix, #mem_0245      ;8562  e6 02 45
    call sub_8571           ;8565  31 85 71
    mov a, #0x30            ;8568  04 30
    movw ix, #mem_024b      ;856a  e6 02 4b
    call sub_8571           ;856d  31 85 71
    ret                     ;8570  20

sub_8571:
    mov adc1, a             ;8571  45 20
    setb adc1:0             ;8573  a8 20

lab_8575:
    bbc adc1:3, lab_8575    ;8575  b3 20 fd
    clrb adc1:3             ;8578  a3 20
    movw a, adch            ;857a  c5 22
    movw @ix+0x00, a        ;857c  d6 00
    ret                     ;857e  20

sub_857f:
    mov a, #0x10            ;857f  04 10
    call sub_8591           ;8581  31 85 91
    movw mem_01c3, a        ;8584  d4 01 c3
    ret                     ;8587  20

sub_8588:
    mov a, #0x20            ;8588  04 20
    call sub_8591           ;858a  31 85 91
    movw mem_01c1, a        ;858d  d4 01 c1
    ret                     ;8590  20

sub_8591:
    mov adc1, a             ;8591  45 20
    movw a, #0x0000         ;8593  e4 00 00
    movw mem_00ac, a        ;8596  d5 ac
    mov mem_009f, #0x04     ;8598  85 9f 04

lab_859b:
    clrb adc1:3             ;859b  a3 20
    setb adc1:0             ;859d  a8 20
    nop                     ;859f  00
    nop                     ;85a0  00
    nop                     ;85a1  00

lab_85a2:
    bbc adc1:3, lab_85a2    ;85a2  b3 20 fd
    movw a, adch            ;85a5  c5 22
    movw a, mem_00ac        ;85a7  c5 ac
    clrc                    ;85a9  81
    addcw a                 ;85aa  23
    movw mem_00ac, a        ;85ab  d5 ac
    mov a, mem_009f         ;85ad  05 9f
    decw a                  ;85af  d0
    mov mem_009f, a         ;85b0  45 9f
    cmp a, #0x00            ;85b2  14 00
    bne lab_859b            ;85b4  fc e5
    movw a, mem_00ac        ;85b6  c5 ac
    clrc                    ;85b8  81
    swap                    ;85b9  10
    rorc a                  ;85ba  03
    swap                    ;85bb  10
    rorc a                  ;85bc  03
    clrc                    ;85bd  81
    swap                    ;85be  10
    rorc a                  ;85bf  03
    swap                    ;85c0  10
    rorc a                  ;85c1  03
    movw mem_00ac, a        ;85c2  d5 ac
    ret                     ;85c4  20

sub_85c5:
    mov a, mem_0236         ;85c5  60 02 36
    mov mem_0323, a         ;85c8  61 03 23
    and a, #0x7f            ;85cb  64 7f
    mov a, mem_00ae         ;85cd  05 ae
    xor a                   ;85cf  52
    bne lab_85ff            ;85d0  fc 2d
    mov a, mem_00ae         ;85d2  05 ae
    cmp a, #0x1c            ;85d4  14 1c    0x1c = mfsw vol down key
    beq lab_85e6            ;85d6  fd 0e
    cmp a, #0x1d            ;85d8  14 1d    0x1d = mfsw vol up key
    beq lab_85e6            ;85da  fd 0a
    cmp a, #0x20            ;85dc  14 20    0x20 = no key?
    beq lab_85e5            ;85de  fd 05
    mov a, #0x3c            ;85e0  04 3c
    mov mem_02fa, a         ;85e2  61 02 fa

lab_85e5:
    ret                     ;85e5  20

lab_85e6:
    mov a, mem_02cd         ;85e6  60 02 cd
    bne lab_85e5            ;85e9  fc fa
    bbs mem_00af:7, lab_85f8 ;85eb  bf af 0a
    setb mem_00af:7         ;85ee  af af

lab_85f0:
    mov a, #0x0b            ;85f0  04 0b
    mov mem_02ce, a         ;85f2  61 02 ce
    jmp lab_8636            ;85f5  21 86 36

lab_85f8:
    mov a, mem_02ce         ;85f8  60 02 ce
    bne lab_85e5            ;85fb  fc e8
    beq lab_85f0            ;85fd  fd f1        BRANCH_ALWAYS_TAKEN

lab_85ff:
    mov a, mem_0236         ;85ff  60 02 36
    bbs mem_00b2:1, lab_8612 ;8602  b9 b2 0d    bit set means "initial"
    and a, #0x7f            ;8605  64 7f
    cmp a, #0x19            ;8607  14 19        0x19 = INITIAL key
    bne lab_8612            ;8609  fc 07
    mov a, #0x20            ;860b  04 20
    mov mem_00ae, a         ;860d  45 ae
    jmp lab_8620            ;860f  21 86 20

lab_8612:
    cmp a, #0x20            ;8612  14 20
    bne lab_8620            ;8614  fc 0a

lab_8616:
    mov a, mem_00ae         ;8616  05 ae
    and a, #0x7f            ;8618  64 7f
    mov mem_0236, a         ;861a  61 02 36
    jmp lab_8636            ;861d  21 86 36

lab_8620:
    mov a, mem_00ae         ;8620  05 ae
    cmp a, #0x20            ;8622  14 20        0x20 = no key?
    bne lab_8629            ;8624  fc 03
    jmp lab_8636            ;8626  21 86 36

lab_8629:
    movw a, #0x0000         ;8629  e4 00 00
    mov a, mem_0236         ;862c  60 02 36
    mov a, mem_00ae         ;862f  05 ae
    xorw a                  ;8631  53
    beq lab_8648            ;8632  fd 14
    bne lab_8616            ;8634  fc e0        BRANCH_ALWAYS_TAKEN

lab_8636:
    movw a, #0x0000         ;8636  e4 00 00
    mov a, mem_0236         ;8639  60 02 36
    movw a, #0x007f         ;863c  e4 00 7f
    andw a                  ;863f  63
    movw a, #0x0020         ;8640  e4 00 20
    cmpw a                  ;8643  13
    beq lab_8649            ;8644  fd 03
    blt lab_8649            ;8646  ff 01

lab_8648:
    ret                     ;8648  20

lab_8649:
    movw a, #0x0000         ;8649  e4 00 00
    mov a, mem_0236         ;864c  60 02 36
    bn lab_8654             ;864f  fb 03
    jmp lab_8716            ;8651  21 87 16

lab_8654:
    mov a, mem_0236         ;8654  60 02 36
    and a, #0x7f            ;8657  64 7f
    mov mem_00ae, a         ;8659  45 ae
    bbc mem_00e3:7, lab_866a ;865b  b7 e3 0c
    bbc mem_00e3:6, lab_8666 ;865e  b6 e3 05
    cmp mem_00ae, #0x18     ;8661  95 ae 18     0x18 = no code key
    beq lab_8689            ;8664  fd 23

lab_8666:
    mov mem_00ae, #0x20     ;8666  85 ae 20
    ret                     ;8669  20

lab_866a:
    cmp mem_0096, #0x02     ;866a  95 96 02
    bne lab_867a            ;866d  fc 0b
    mov a, mem_00ae         ;866f  05 ae
    cmp a, #0x12            ;8671  14 12       0x12 = tape side key
    beq lab_8689            ;8673  fd 14
    movw ix, #mem_868e      ;8675  e6 86 8e
    bne lab_8682            ;8678  fc 08        BRANCH_ALWAYS_TAKEN

lab_867a:
    cmp mem_0096, #0x03     ;867a  95 96 03
    bne lab_8694            ;867d  fc 15
    movw ix, #mem_868c      ;867f  e6 86 8c

lab_8682:
    mov a, mem_00ae         ;8682  05 ae
    call sub_e76c           ;8684  31 e7 6c
    bhs lab_8666            ;8687  f8 dd       branch if not found in table

lab_8689:
    jmp lab_86e5            ;8689  21 86 e5

mem_868c:
;Used when mem_0096 = 03
;Lookup table used with sub_e76c
;Falls through into next table
    .byte 0x0A              ;868c  0a          DATA '\n'    0x0a = tune up key
    .byte 0x13              ;868d  13          DATA '\x13'  0x0b = seek up key

mem_868e:
;Lookup table used with sub_e76c
;Used when mem_0096 = 0x02
;Falls through into next table
    .byte 0x19              ;868e  19          DATA '\x19'  0x19 = initial key

mem_868f:
;Lookup table used with sub_e76c
;Used when mem_0096 = 0x02 or 0x03
    .byte 0x02              ;868f  02          DATA '\x02'  0x02 = preset 4 key
    .byte 0x04              ;8690  04          DATA '\x04'  0x04 = preset 3 key
    .byte 0x05              ;8691  05          DATA '\x05'  0x05 = preset 2 key
    .byte 0x06              ;8692  06          DATA '\x06'  0x06 = preset 1 key
    .byte 0xFF              ;8693  ff          DATA '\xff'

lab_8694:
    cmp mem_0096, #0x04     ;8694  95 96 04
    bne lab_86a2            ;8697  fc 09
    movw ix, #mem_869e      ;8699  e6 86 9e
    beq lab_8682            ;869c  fd e4        BRANCH_ALWAYS_TAKEN

mem_869e:
;Lookup table used with sub_e76c
;Used when mem_0096 = 0x04
    .byte 0x19              ;869e  19          DATA '\x19'  0x19 = HIDDEN_INITIAL
    .byte 0x08              ;869f  08          DATA '\x08'  0x08 = MODE_FM
    .byte 0x09              ;86a0  09          DATA '\t'    0x09 = MODE_AM
    .byte 0xFF              ;86a1  ff          DATA '\xff'

lab_86a2:
    cmp mem_0096, #0x0a     ;86a2  95 96 0a
    bne lab_86b3            ;86a5  fc 0c
    movw ix, #mem_86ac      ;86a7  e6 86 ac
    beq lab_8682            ;86aa  fd d6        BRANCH_ALWAYS_TAKEN

mem_86ac:
;Lookup table used with sub_e76c
;Used when mem_0096 = 0x0a
    .byte 0x0A              ;86ac  0a          DATA '\n'    0x0A = TUNE_UP
    .byte 0x0E              ;86ad  0e          DATA '\x0e'  0x0E = TUNE_DOWN
    .byte 0x13              ;86ae  13          DATA '\x13'  0x13 = SEEK_UP
    .byte 0x17              ;86af  17          DATA '\x17'  0x17 = SEEK_DOWN
    .byte 0x16              ;86b0  16          DATA '\x16'  0x16 = SCAN
    .byte 0x19              ;86b1  19          DATA '\x19'  0x19 = HIDDEN_INITIAL
    .byte 0xFF              ;86b2  ff          DATA '\xff'

lab_86b3:
    mov a, mem_030b         ;86b3  60 03 0b
    mov a, #0x00            ;86b6  04 00
    cmp a                   ;86b8  12
    beq lab_86e5            ;86b9  fd 2a
    mov a, mem_00ae         ;86bb  05 ae
    mov mem_00cb, a         ;86bd  45 cb
    cmp mem_0095, #0x02     ;86bf  95 95 02
    bne lab_86d4            ;86c2  fc 10
    mov a, mem_00ae         ;86c4  05 ae
    cmp a, #0x0a            ;86c6  14 0a        0x0a = tune up key
    beq lab_86d0            ;86c8  fd 06
    cmp a, #0x0e            ;86ca  14 0e        0x0e = tune down key
    beq lab_86d0            ;86cc  fd 02
    bne lab_86e5            ;86ce  fc 15        BRANCH_ALWAYS_TAKEN

lab_86d0:
    mov a, #0x20            ;86d0  04 20
    bne lab_86e3            ;86d2  fc 0f        BRANCH_ALWAYS_TAKEN

lab_86d4:
    cmp mem_0095, #0x01     ;86d4  95 95 01
    bne lab_86e5            ;86d7  fc 0c
    movw ix, #mem_8737      ;86d9  e6 87 37
    mov a, mem_00ae         ;86dc  05 ae
    call sub_e746           ;86de  31 e7 46
    beq lab_86e5            ;86e1  fd 02

lab_86e3:
    mov mem_00ae, a         ;86e3  45 ae

lab_86e5:
    clrb mem_0099:2         ;86e5  a2 99
    clrb mem_0099:3         ;86e7  a3 99

    mov a, mem_00ae         ;86e9  05 ae        A = table index
    movw a, #mem_fe00       ;86eb  e4 fe 00     A = table base address
    call sub_e73c           ;86ee  31 e7 3c     Call address in table

    mov a, mem_030b         ;86f1  60 03 0b
    mov a, #0x00            ;86f4  04 00
    cmp a                   ;86f6  12
    beq lab_8715            ;86f7  fd 1c
    mov a, mem_0096         ;86f9  05 96
    bne lab_8715            ;86fb  fc 18
    cmp mem_0095, #0x01     ;86fd  95 95 01
    beq lab_8707            ;8700  fd 05
    cmp mem_0095, #0x02     ;8702  95 95 02
    bne lab_8715            ;8705  fc 0e

lab_8707:
    cmp mem_00ae, #0x20     ;8707  95 ae 20     0x20 = no key
    beq lab_8715            ;870a  fd 09
    mov a, mem_00cb         ;870c  05 cb
    mov a, mem_00ae         ;870e  05 ae
    mov mem_00cb, a         ;8710  45 cb
    xch a, t                ;8712  42
    mov mem_00ae, a         ;8713  45 ae

lab_8715:
    ret                     ;8715  20

lab_8716:
    cmp mem_00cb, #0x20     ;8716  95 cb 20
    beq lab_871f            ;8719  fd 04
    mov a, mem_00cb         ;871b  05 cb
    mov mem_00ae, a         ;871d  45 ae

lab_871f:
    mov a, mem_00ae         ;871f  05 ae
    and a, #0x7f            ;8721  64 7f
    mov mem_00ae, a         ;8723  45 ae

    mov a, mem_00ae         ;8725  05 ae        A = table index
    movw a, #mem_fe42       ;8727  e4 fe 42     A = table base address
    call sub_e73c           ;872a  31 e7 3c     Call address in table

    mov a, #0x20            ;872d  04 20
    mov mem_00ae, a         ;872f  45 ae
    mov mem_00cb, a         ;8731  45 cb
    mov mem_0236, a         ;8733  61 02 36

lab_8736:
    ret                     ;8736  20

mem_8737:
;table of byte pairs used with sub_e746
    .byte 0x0A              ;8737  0a          DATA '\n'
    .byte 0x11              ;8738  11          DATA '\x11'

    .byte 0x0E              ;8739  0e          DATA '\x0e'
    .byte 0x10              ;873a  10          DATA '\x10'

    .byte 0x13              ;873b  13          DATA '\x13'
    .byte 0x0A              ;873c  0a          DATA '\n'

    .byte 0x17              ;873d  17          DATA '\x17'
    .byte 0x0E              ;873e  0e          DATA '\x0e'

    .byte 0x14              ;873f  14          DATA '\x14'
    .byte 0x15              ;8740  15          DATA '\x15'

    .byte 0x11              ;8741  11          DATA '\x11'
    .byte 0x20              ;8742  20          DATA ' '

    .byte 0x10              ;8743  10          DATA '\x10'
    .byte 0x20              ;8744  20          DATA ' '

    .byte 0x15              ;8745  15          DATA '\x15'
    .byte 0x20              ;8746  20          DATA ' '

    .byte 0xFF              ;8747  ff          DATA '\xff'
    .byte 0x00              ;8748  00          DATA '\x00'

lab_8749:
;mem_fe00 table case for fm
    mov a, mem_0331         ;8749  60 03 31
    bne lab_87ad            ;874c  fc 5f
    mov a, mem_02cc         ;874e  60 02 cc
    bne lab_87ad            ;8751  fc 5a
    cmp mem_0096, #0x0b     ;8753  95 96 0b
    beq lab_87ad            ;8756  fd 55
    call sub_87c5           ;8758  31 87 c5
    bhs lab_8736            ;875b  f8 d9
    callv #4                ;875d  ec          CALLV #4 = callv4_8c84
    setb mem_00af:2         ;875e  aa af
    mov a, mem_0095         ;8760  05 95
    beq lab_876d            ;8762  fd 09
    cmp a, #0x01            ;8764  14 01
    beq lab_8799            ;8766  fd 31
    cmp a, #0x02            ;8768  14 02
    beq lab_87a3            ;876a  fd 37
    ret                     ;876c  20

lab_876d:
    mov a, mem_00c5         ;876d  05 c5
    mov mem_01a4, a         ;876f  61 01 a4
    mov a, mem_00c5         ;8772  05 c5
    bne lab_877d            ;8774  fc 07
    mov a, mem_00c6         ;8776  05 c6
    mov mem_00c5, a         ;8778  45 c5
    jmp lab_8796            ;877a  21 87 96

lab_877d:
    cmp mem_00c5, #0x01     ;877d  95 c5 01
    bne lab_878b            ;8780  fc 09
    mov mem_00c5, #0x02     ;8782  85 c5 02
    mov mem_00c6, #0x02     ;8785  85 c6 02
    jmp lab_8796            ;8788  21 87 96

lab_878b:
    cmp mem_00c5, #0x02     ;878b  95 c5 02
    bne lab_8796            ;878e  fc 06
    mov mem_00c5, #0x01     ;8790  85 c5 01
    mov mem_00c6, #0x01     ;8793  85 c6 01

lab_8796:
    jmp lab_87aa            ;8796  21 87 aa

lab_8799:
    call sub_8842           ;8799  31 88 42
    mov a, mem_00c6         ;879c  05 c6
    mov mem_00c5, a         ;879e  45 c5
    jmp lab_87aa            ;87a0  21 87 aa

lab_87a3:
    mov mem_00ce, #0x04     ;87a3  85 ce 04
    mov a, mem_00c6         ;87a6  05 c6
    mov mem_00c5, a         ;87a8  45 c5

lab_87aa:
    mov mem_00c2, #0x06     ;87aa  85 c2 06

lab_87ad:
    ret                     ;87ad  20

sub_87ae:
    mov a, mem_00cc         ;87ae  05 cc
    beq lab_87c1            ;87b0  fd 0f
    cmp a, #0x04            ;87b2  14 04
    beq lab_87be            ;87b4  fd 08
    cmp a, #0x1f            ;87b6  14 1f
    beq lab_87be            ;87b8  fd 04
    cmp a, #0x05            ;87ba  14 05
    bne lab_87c3            ;87bc  fc 05

lab_87be:
    call sub_9b02           ;87be  31 9b 02

lab_87c1:
    setc                    ;87c1  91
    ret                     ;87c2  20

lab_87c3:
    clrc                    ;87c3  81
    ret                     ;87c4  20

sub_87c5:
    mov a, mem_00cc         ;87c5  05 cc
    beq lab_87d4            ;87c7  fd 0b
    cmp a, #0x05            ;87c9  14 05
    bne lab_87d6            ;87cb  fc 09
    mov a, #0x00            ;87cd  04 00
    mov mem_00cc, a         ;87cf  45 cc
    mov mem_0313, a         ;87d1  61 03 13

lab_87d4:
    setc                    ;87d4  91
    ret                     ;87d5  20

lab_87d6:
    clrc                    ;87d6  81
    ret                     ;87d7  20

lab_87d8:
;mem_fe00 table case for am
    mov a, mem_0331         ;87d8  60 03 31
    bne lab_881f            ;87db  fc 42
    mov a, mem_02cc         ;87dd  60 02 cc
    bne lab_881f            ;87e0  fc 3d
    call sub_87c5           ;87e2  31 87 c5
    bhs lab_881f            ;87e5  f8 38
    cmp mem_0096, #0x0b     ;87e7  95 96 0b
    bne lab_87ed            ;87ea  fc 01
    ret                     ;87ec  20

lab_87ed:
    callv #4                ;87ed  ec          CALLV #4 = callv4_8c84
    setb mem_00af:2         ;87ee  aa af
    mov a, mem_0095         ;87f0  05 95
    beq lab_87fd            ;87f2  fd 09
    cmp a, #0x01            ;87f4  14 01
    beq lab_880d            ;87f6  fd 15
    cmp a, #0x02            ;87f8  14 02
    beq lab_8816            ;87fa  fd 1a
    ret                     ;87fc  20

lab_87fd:
    mov a, mem_00c5         ;87fd  05 c5
    mov mem_01a4, a         ;87ff  61 01 a4
    bne lab_8807            ;8802  fc 03
    jmp lab_881c            ;8804  21 88 1c

lab_8807:
    mov mem_00c2, #0x01     ;8807  85 c2 01
    jmp lab_881c            ;880a  21 88 1c

lab_880d:
    call sub_8842           ;880d  31 88 42
    mov mem_00c2, #0x06     ;8810  85 c2 06
    jmp lab_881c            ;8813  21 88 1c

lab_8816:
    mov mem_00ce, #0x04     ;8816  85 ce 04
    mov mem_00c2, #0x01     ;8819  85 c2 01

lab_881c:
    mov mem_00c5, #0x00     ;881c  85 c5 00

lab_881f:
    ret                     ;881f  20

lab_8820:
;mem_fe00 table case for cd
    call sub_87c5           ;8820  31 87 c5
    bhs lab_8841            ;8823  f8 1c
    cmp mem_0096, #0x0b     ;8825  95 96 0b
    bne lab_882d            ;8828  fc 03
    setb mem_00d9:2         ;882a  aa d9
    ret                     ;882c  20

lab_882d:
    callv #4                ;882d  ec          CALLV #4 = callv4_8c84
    setb mem_00af:2         ;882e  aa af
    mov a, mem_0095         ;8830  05 95
    beq lab_883e            ;8832  fd 0a
    cmp a, #0x01            ;8834  14 01
    beq lab_8839            ;8836  fd 01
    ret                     ;8838  20

lab_8839:
    mov r0, #0x00           ;8839  88 00
    call sub_8844           ;883b  31 88 44

lab_883e:
    mov mem_00ce, #0x01     ;883e  85 ce 01

lab_8841:
    ret                     ;8841  20

sub_8842:
    mov r0, #0x01           ;8842  88 01

sub_8844:
    mov a, mem_00f6         ;8844  05 f6
    and a, #0x0f            ;8846  64 0f
    cmp a, #0x05            ;8848  14 05
    bhs lab_885b            ;884a  f8 0f
    call sub_9e1d           ;884c  31 9e 1d
    blo lab_885a            ;884f  f9 09

lab_8851:
    call sub_9cf7           ;8851  31 9c f7
    call sub_8d22           ;8854  31 8d 22
    call sub_8d1a           ;8857  31 8d 1a

lab_885a:
    ret                     ;885a  20

lab_885b:
    cmp r0, #0x00           ;885b  98 00
    beq lab_885a            ;885d  fd fb
    bne lab_8851            ;885f  fc f0        BRANCH_ALWAYS_TAKEN

lab_8861:
;mem_fe00 table case for tape
    mov a, mem_00cc         ;8861  05 cc
    bne lab_88b6            ;8863  fc 51
    mov a, mem_0322         ;8865  60 03 22
    mov a, mem_0321         ;8868  60 03 21
    and a                   ;886b  62
    bne lab_88b6            ;886c  fc 48
    cmp mem_0096, #0x0b     ;886e  95 96 0b
    bne lab_8876            ;8871  fc 03
    setb mem_00d9:5         ;8873  ad d9
    ret                     ;8875  20

lab_8876:
    mov a, mem_0369         ;8876  60 03 69
    cmp a, #0x02            ;8879  14 02
    beq lab_88b6            ;887b  fd 39
    cmp a, #0x10            ;887d  14 10
    beq lab_88b6            ;887f  fd 35
    cmp a, #0x65            ;8881  14 65
    beq lab_88b6            ;8883  fd 31
    cmp a, #0x63            ;8885  14 63
    beq lab_88b6            ;8887  fd 2d
    callv #4                ;8889  ec          CALLV #4 = callv4_8c84
    call sub_8d00           ;888a  31 8d 00
    setb mem_00af:2         ;888d  aa af
    mov a, mem_0095         ;888f  05 95
    cmp a, #0x0f            ;8891  14 0f
    beq lab_88b6            ;8893  fd 21
    cmp a, #0x01            ;8895  14 01
    beq lab_889f            ;8897  fd 06
    call sub_9e34           ;8899  31 9e 34
    jmp lab_88b3            ;889c  21 88 b3

lab_889f:
    mov a, mem_00f6         ;889f  05 f6
    cmp a, #0x21            ;88a1  14 21
    beq lab_88b7            ;88a3  fd 12
    cmp a, #0x61            ;88a5  14 61
    beq lab_88b7            ;88a7  fd 0e
    mov a, mem_00f6         ;88a9  05 f6
    and a, #0x0f            ;88ab  64 0f
    cmp a, #0x01            ;88ad  14 01
    beq lab_88b6            ;88af  fd 05
    clrb mem_00e9:1         ;88b1  a1 e9

lab_88b3:
    mov mem_00cc, #0x06     ;88b3  85 cc 06

lab_88b6:
    ret                     ;88b6  20

lab_88b7:
    mov a, #0x01            ;88b7  04 01
    mov mem_0349, a         ;88b9  61 03 49
    ret                     ;88bc  20

sub_88bd:
;mem_fe00 table case for seek up
    mov mem_009e, #0x01     ;88bd  85 9e 01

lab_88c0:
    mov a, mem_0096         ;88c0  05 96
    cmp a, #0x0a            ;88c2  14 0a
    bne lab_88cf            ;88c4  fc 09
    bbc mem_009e:0, lab_88cc ;88c6  b0 9e 03
    setb mem_00d9:0         ;88c9  a8 d9
    ret                     ;88cb  20

lab_88cc:
    setb mem_00d9:1         ;88cc  a9 d9
    ret                     ;88ce  20

lab_88cf:
    cmp a, #0x0b            ;88cf  14 0b
    beq lab_88de            ;88d1  fd 0b
    bbc mem_009e:0, lab_88df ;88d3  b0 9e 09
    cmp mem_0096, #0x03     ;88d6  95 96 03
    bne lab_88df            ;88d9  fc 04
    call sub_8cee           ;88db  31 8c ee

lab_88de:
    ret                     ;88de  20

lab_88df:
    cmp mem_0095, #0x01     ;88df  95 95 01
    beq lab_88e5            ;88e2  fd 01
    callv #4                ;88e4  ec          CALLV #4 = callv4_8c84

lab_88e5:
    mov a, mem_0095         ;88e5  05 95
    beq lab_88ee            ;88e7  fd 05
    cmp a, #0x02            ;88e9  14 02
    beq lab_8920            ;88eb  fd 33
    ret                     ;88ed  20

lab_88ee:
    mov mem_00c8, #0x00     ;88ee  85 c8 00
    mov a, mem_00c1         ;88f1  05 c1
    cmp a, #0x01            ;88f3  14 01
    beq lab_88fd            ;88f5  fd 06
    cmp a, #0x02            ;88f7  14 02
    beq lab_890a            ;88f9  fd 0f
    bne lab_890d            ;88fb  fc 10        BRANCH_ALWAYS_TAKEN

lab_88fd:
    bbc mem_009e:0, lab_8907 ;88fd  b0 9e 07
    bbc mem_00c9:5, lab_890a ;8900  b5 c9 07

lab_8903:
    mov mem_00c2, #0x31     ;8903  85 c2 31
    ret                     ;8906  20

lab_8907:
    bbc mem_00c9:5, lab_8903 ;8907  b5 c9 f9

lab_890a:
    call sub_9a02           ;890a  31 9a 02

lab_890d:
    setb mem_00c9:5         ;890d  ad c9
    bbs mem_009e:0, lab_8914 ;890f  b8 9e 02
    clrb mem_00c9:5         ;8912  a5 c9

lab_8914:
    setb mem_00af:5         ;8914  ad af
    mov mem_00c1, #0x01     ;8916  85 c1 01
    mov mem_00c2, #0x0b     ;8919  85 c2 0b
    call sub_8cf3           ;891c  31 8c f3
    ret                     ;891f  20

lab_8920:
    mov a, mem_030b         ;8920  60 03 0b
    mov a, #0x00            ;8923  04 00
    cmp a                   ;8925  12
    bne lab_8932            ;8926  fc 0a
    mov a, #0x0c            ;8928  04 0c

lab_892a:
    bbs mem_009e:0, lab_892e ;892a  b8 9e 01
    incw a                  ;892d  c0

lab_892e:
    mov mem_01c6, a         ;892e  61 01 c6
    ret                     ;8931  20

lab_8932:
    mov a, #0x0e            ;8932  04 0e
    bne lab_892a            ;8934  fc f4        BRANCH_ALWAYS_TAKEN

sub_8936:
;mem_fe00 table case for seek down
    mov mem_009e, #0x00     ;8936  85 9e 00
    jmp lab_88c0            ;8939  21 88 c0

sub_893c:
;mem_fe42 table case for seek up, seek down
    mov a, mem_0096         ;893c  05 96
    cmp a, #0x0b            ;893e  14 0b
    bne lab_8945            ;8940  fc 03
    clrb mem_00af:5         ;8942  a5 af
    ret                     ;8944  20

lab_8945:
    cmp a, #0x0a            ;8945  14 0a
    beq lab_8959            ;8947  fd 10
    mov a, mem_0095         ;8949  05 95
    bne lab_8950            ;894b  fc 03
    clrb mem_00af:5         ;894d  a5 af
    ret                     ;894f  20

lab_8950:
    cmp a, #0x02            ;8950  14 02
    bne lab_8959            ;8952  fc 05
    mov a, #0x8c            ;8954  04 8c
    mov mem_01c6, a         ;8956  61 01 c6

lab_8959:
    ret                     ;8959  20

sub_895a:
;mem_fe00 table case for tune up
    cmp mem_0096, #0x03     ;895a  95 96 03
    bne lab_8963            ;895d  fc 04
    call sub_8cee           ;895f  31 8c ee
    ret                     ;8962  20

lab_8963:
    callv #4                ;8963  ec          CALLV #4 = callv4_8c84
    setb mem_00d8:2         ;8964  aa d8
    mov mem_009e, #0x01     ;8966  85 9e 01

lab_8969:
    mov a, mem_0096         ;8969  05 96
    cmp a, #0x0a            ;896b  14 0a
    beq lab_8973            ;896d  fd 04
    cmp a, #0x0b            ;896f  14 0b
    bne lab_8974            ;8971  fc 01

lab_8973:
    ret                     ;8973  20

lab_8974:
    mov a, mem_0095         ;8974  05 95
    bne lab_899d            ;8976  fc 25
    setb mem_00c9:5         ;8978  ad c9
    bbs mem_009e:0, lab_897f ;897a  b8 9e 02
    clrb mem_00c9:5         ;897d  a5 c9

lab_897f:
    mov a, mem_00c1         ;897f  05 c1
    cmp a, #0x01            ;8981  14 01
    beq lab_898b            ;8983  fd 06
    cmp a, #0x02            ;8985  14 02
    beq lab_898b            ;8987  fd 02
    bne lab_898e            ;8989  fc 03        BRANCH_ALWAYS_TAKEN

lab_898b:
    call sub_9a02           ;898b  31 9a 02

lab_898e:
    mov mem_00c1, #0x00     ;898e  85 c1 00
    setb mem_00af:4         ;8991  ac af
    mov mem_00c8, #0x00     ;8993  85 c8 00
    call sub_8cf3           ;8996  31 8c f3
    mov mem_00c2, #0x15     ;8999  85 c2 15
    ret                     ;899c  20

lab_899d:
    cmp a, #0x01            ;899d  14 01
    bne lab_89b5            ;899f  fc 14
    call sub_9ea3           ;89a1  31 9e a3
    blo lab_89c2            ;89a4  f9 1c
    mov a, #0x0d            ;89a6  04 0d
    bbs mem_009e:0, lab_89ad ;89a8  b8 9e 02
    mov a, #0x0e            ;89ab  04 0e

lab_89ad:
    mov a, mem_00cc         ;89ad  05 cc
    bne lab_89c2            ;89af  fc 11
    xch a, t                ;89b1  42
    mov mem_00cc, a         ;89b2  45 cc
    ret                     ;89b4  20

lab_89b5:
    cmp a, #0x02            ;89b5  14 02
    bne lab_89c2            ;89b7  fc 09
    mov a, #0x0a            ;89b9  04 0a
    bbs mem_009e:0, lab_89bf ;89bb  b8 9e 01
    incw a                  ;89be  c0

lab_89bf:
    mov mem_01c6, a         ;89bf  61 01 c6

lab_89c2:
    ret                     ;89c2  20

sub_89c3:
;mem_fe00 table case for tune down
    callv #4                ;89c3  ec          CALLV #4 = callv4_8c84
    setb mem_00d8:3         ;89c4  ab d8
    mov mem_009e, #0x00     ;89c6  85 9e 00
    jmp lab_8969            ;89c9  21 89 69

sub_89cc:
;mem_fe42 table case for tune up, tune down
    mov a, mem_0096         ;89cc  05 96
    cmp a, #0x0b            ;89ce  14 0b
    beq lab_89e8            ;89d0  fd 16
    cmp a, #0x0a            ;89d2  14 0a
    beq lab_89e8            ;89d4  fd 12
    mov a, mem_0095         ;89d6  05 95
    bne lab_89e8            ;89d8  fc 0e
    movw a, #0x0001         ;89da  e4 00 01
    movw mem_02ad, a        ;89dd  d4 02 ad
    clrb mem_00af:4         ;89e0  a4 af
    bbc mem_0099:2, lab_89e8 ;89e2  b2 99 03
    mov mem_00c2, #0x1b     ;89e5  85 c2 1b

lab_89e8:
    ret                     ;89e8  20

lab_89e9:
;mem_fe00 table case for scan
    bbs mem_00e4:3, lab_89fa ;89e9  bb e4 0e
    bbc mem_00de:7, lab_89fa ;89ec  b7 de 0b
    bbs mem_00de:6, lab_89fa ;89ef  be de 08
    setb mem_00ca:7         ;89f2  af ca
    mov a, mem_00ae         ;89f4  05 ae
    mov mem_0205, a         ;89f6  61 02 05
    ret                     ;89f9  20

lab_89fa:
    bbs mem_00de:7, lab_8a09 ;89fa  bf de 0c
    mov a, mem_00d2         ;89fd  05 d2
    beq lab_8a09            ;89ff  fd 08
    setb mem_00ca:7         ;8a01  af ca
    mov a, #0x30            ;8a03  04 30
    mov mem_0205, a         ;8a05  61 02 05
    ret                     ;8a08  20

lab_8a09:
    call sub_8cee           ;8a09  31 8c ee
    ret                     ;8a0c  20

lab_8a0d:
    callv #4                ;8a0d  ec          CALLV #4 = callv4_8c84
    bbc mem_00ca:7, lab_8a14 ;8a0e  b7 ca 03
    clrb mem_00ca:7         ;8a11  a7 ca
    ret                     ;8a13  20

lab_8a14:
    setb mem_00d8:7         ;8a14  af d8
    mov a, mem_0096         ;8a16  05 96
    bne lab_8a5e            ;8a18  fc 44
    clrb mem_0099:3         ;8a1a  a3 99
    mov a, mem_0095         ;8a1c  05 95
    beq lab_8a29            ;8a1e  fd 09
    cmp a, #0x01            ;8a20  14 01
    beq lab_8a4f            ;8a22  fd 2b
    cmp a, #0x02            ;8a24  14 02
    beq lab_8a59            ;8a26  fd 31
    ret                     ;8a28  20

lab_8a29:
    clrb mem_00c9:6         ;8a29  a6 c9
    cmp mem_00c1, #0x02     ;8a2b  95 c1 02
    bne lab_8a3e            ;8a2e  fc 0e
    call sub_9a02           ;8a30  31 9a 02
    mov mem_00c1, #0x00     ;8a33  85 c1 00
    setb mem_00c9:0         ;8a36  a8 c9
    mov mem_00c2, #0x1c     ;8a38  85 c2 1c
    setb mem_0098:4         ;8a3b  ac 98
    ret                     ;8a3d  20

lab_8a3e:
    cmp mem_00c1, #0x01     ;8a3e  95 c1 01
    bne lab_8a46            ;8a41  fc 03
    call sub_9a02           ;8a43  31 9a 02

lab_8a46:
    setb mem_00c9:5         ;8a46  ad c9
    mov mem_00c1, #0x02     ;8a48  85 c1 02
    mov mem_00c2, #0x0b     ;8a4b  85 c2 0b
    ret                     ;8a4e  20

lab_8a4f:
    call sub_9ea3           ;8a4f  31 9e a3
    blo lab_8a5e            ;8a52  f9 0a
    mov a, #0x11            ;8a54  04 11
    jmp lab_89ad            ;8a56  21 89 ad

lab_8a59:
    mov a, #0x08            ;8a59  04 08
    mov mem_01c6, a         ;8a5b  61 01 c6

lab_8a5e:
    ret                     ;8a5e  20

lab_8a5f:
;mem_fe00 table case for mix/dolby
    cmp mem_0095, #0x02     ;8a5f  95 95 02
    bne lab_8a6a            ;8a62  fc 06
    callv #4                ;8a64  ec          CALLV #4 = callv4_8c84
    mov a, #0x09            ;8a65  04 09
    mov mem_01c6, a         ;8a67  61 01 c6

lab_8a6a:
    ret                     ;8a6a  20

lab_8a6b:
;mem_fe42 table case for beetle_tape_ff
    clrb mem_0099:3         ;8a6b  a3 99
    mov mem_009e, #0x0f     ;8a6d  85 9e 0f

lab_8a70:
    cmp mem_0096, #0x0b     ;8a70  95 96 0b
    beq lab_8a85            ;8a73  fd 10
    cmp mem_0095, #0x01     ;8a75  95 95 01
    bne lab_8a85            ;8a78  fc 0b
    call sub_9ea3           ;8a7a  31 9e a3
    blo lab_8a85            ;8a7d  f9 06
    callv #4                ;8a7f  ec          CALLV #4 = callv4_8c84
    mov a, mem_009e         ;8a80  05 9e
    jmp lab_89ad            ;8a82  21 89 ad

lab_8a85:
;mem_fe00 table case for beetle_tape_rew, beetle_tape_ff
    ret                     ;8a85  20

lab_8a86:
;mem_fe42 table case for beetle_tape_rew
    mov mem_009e, #0x10     ;8a86  85 9e 10
    jmp lab_8a70            ;8a89  21 8a 70

lab_8a8c:
;mem_fe00 table case for tape side
    call sub_8cee           ;8a8c  31 8c ee
    ret                     ;8a8f  20

lab_8a90:
;mem_fe42 table case for tape side
    bbc mem_00e4:2, lab_8a96 ;8a90  b2 e4 03
    clrb mem_00e4:2         ;8a93  a2 e4
    ret                     ;8a95  20

lab_8a96:
    cmp mem_0096, #0x02     ;8a96  95 96 02
    bne lab_8aa1            ;8a99  fc 06
    mov a, mem_00ae         ;8a9b  05 ae
    mov mem_0205, a         ;8a9d  61 02 05
    ret                     ;8aa0  20

lab_8aa1:
    mov mem_009e, #0x12     ;8aa1  85 9e 12
    jmp lab_8a70            ;8aa4  21 8a 70

lab_8aa7:
;mem_fe00 table case for beetle_dolby
    mov mem_009e, #0x13     ;8aa7  85 9e 13
    jmp lab_8a70            ;8aaa  21 8a 70

lab_8aad:
;mem_fe00 table case for treb
    setb mem_00d8:4         ;8aad  ac d8
    ret                     ;8aaf  20

lab_8ab0:
;mem_fe42 table case for treb
    mov mem_009e, #0x02     ;8ab0  85 9e 02

lab_8ab3:
    mov a, mem_00cc         ;8ab3  05 cc
    beq lab_8ac5            ;8ab5  fd 0e
    cmp a, #0x04            ;8ab7  14 04
    beq lab_8ac5            ;8ab9  fd 0a
    cmp a, #0x1f            ;8abb  14 1f
    beq lab_8ac5            ;8abd  fd 06
    cmp a, #0x05            ;8abf  14 05
    beq lab_8ac5            ;8ac1  fd 02
    bne lab_8b15            ;8ac3  fc 50        BRANCH_ALWAYS_TAKEN

lab_8ac5:
    cmp mem_0096, #0x0b     ;8ac5  95 96 0b
    beq lab_8b15            ;8ac8  fd 4b
    mov a, mem_0095         ;8aca  05 95
    beq lab_8ad6            ;8acc  fd 08
    cmp a, #0x01            ;8ace  14 01
    beq lab_8ad6            ;8ad0  fd 04
    cmp a, #0x02            ;8ad2  14 02
    bne lab_8b15            ;8ad4  fc 3f

lab_8ad6:
    mov a, mem_009e         ;8ad6  05 9e
    cmp a, mem_00b1         ;8ad8  15 b1
    bne lab_8ae0            ;8ada  fc 04
    callv #4                ;8adc  ec          CALLV #4 = callv4_8c84
    jmp lab_8b13            ;8add  21 8b 13

lab_8ae0:
    mov mem_00b1, a         ;8ae0  45 b1
    call sub_8c79           ;8ae2  31 8c 79
    mov a, mem_0095         ;8ae5  05 95
    bne lab_8af9            ;8ae7  fc 10
    cmp mem_00c1, #0x01     ;8ae9  95 c1 01
    beq lab_8af3            ;8aec  fd 05
    cmp mem_00c1, #0x02     ;8aee  95 c1 02
    bne lab_8b13            ;8af1  fc 20

lab_8af3:
    mov mem_00c2, #0x04     ;8af3  85 c2 04
    jmp lab_8b13            ;8af6  21 8b 13

lab_8af9:
    cmp a, #0x01            ;8af9  14 01
    bne lab_8b0b            ;8afb  fc 0e
    call sub_9ea3           ;8afd  31 9e a3
    blo lab_8b13            ;8b00  f9 11
    bbs mem_00d7:2, lab_8b13 ;8b02  ba d7 0e
    mov mem_00cc, #0x17     ;8b05  85 cc 17
    jmp lab_8b13            ;8b08  21 8b 13

lab_8b0b:
    cmp a, #0x02            ;8b0b  14 02
    bne lab_8b13            ;8b0d  fc 04
    clrb mem_00df:3         ;8b0f  a3 df
    clrb mem_00df:4         ;8b11  a4 df

lab_8b13:
    setb mem_0098:4         ;8b13  ac 98

lab_8b15:
    ret                     ;8b15  20

lab_8b16:
;mem_fe00 table case for bass
    ret                     ;8b16  20

lab_8b17:
;mem_fe42 table case for bass
    mov mem_009e, #0x01     ;8b17  85 9e 01
    jmp lab_8ab3            ;8b1a  21 8a b3

lab_8b1d:
;mem_fe00 table case for bal
    cmp mem_0096, #0x0b     ;8b1d  95 96 0b
    beq lab_8b39            ;8b20  fd 17
    mov a, mem_0095         ;8b22  05 95
    bne lab_8b2c            ;8b24  fc 06
    mov a, mem_00c5         ;8b26  05 c5
    beq lab_8b38            ;8b28  fd 0e
    bne lab_8b31            ;8b2a  fc 05        BRANCH_ALWAYS_TAKEN

lab_8b2c:
    cmp a, #0x02            ;8b2c  14 02
    beq lab_8b31            ;8b2e  fd 01
    ret                     ;8b30  20

lab_8b31:
    mov a, mem_0096         ;8b31  05 96
    bne lab_8b38            ;8b33  fc 03
    call sub_8cdf           ;8b35  31 8c df

lab_8b38:
    ret                     ;8b38  20

lab_8b39:
    call sub_8ce4           ;8b39  31 8c e4
    ret                     ;8b3c  20

lab_8b3d:
;mem_fe42 table case for bal
    bbc mem_00af:6, lab_8b43 ;8b3d  b6 af 03
    clrb mem_00af:6         ;8b40  a6 af
    ret                     ;8b42  20

lab_8b43:
    clrb mem_0099:3         ;8b43  a3 99
    mov mem_009e, #0x03     ;8b45  85 9e 03
    jmp lab_8ab3            ;8b48  21 8a b3

lab_8b4b:
;mem_fe00 table case for fade
    ret                     ;8b4b  20

lab_8b4c:
;mem_fe42 table case for fade
    mov mem_009e, #0x04     ;8b4c  85 9e 04
    jmp lab_8ab3            ;8b4f  21 8a b3

lab_8b52:
;mem_fe42 table case for fm, am, cd, tape, mix/dolby, beetle_dolby, mfsw vol up, mfsw vol down
    clrb mem_0099:3         ;8b52  a3 99
    mov a, #0x20            ;8b54  04 20
    mov mem_0205, a         ;8b56  61 02 05
    mov a, #0x00            ;8b59  04 00
    mov mem_02ce, a         ;8b5b  61 02 ce
    mov mem_02cd, a         ;8b5e  61 02 cd
    clrb mem_00af:7         ;8b61  a7 af
    ret                     ;8b63  20

lab_8b64:
;mem_fe00 table case presets 1-6
    mov a, mem_0096         ;8b64  05 96
    cmp a, #0x02            ;8b66  14 02
    beq lab_8b78            ;8b68  fd 0e
    cmp a, #0x03            ;8b6a  14 03
    beq lab_8b78            ;8b6c  fd 0a
    cmp a, #0x05            ;8b6e  14 05
    beq lab_8b8a            ;8b70  fd 18
    cmp a, #0x0b            ;8b72  14 0b
    bne lab_8b99            ;8b74  fc 23
    beq lab_8bc1            ;8b76  fd 49        BRANCH_ALWAYS_TAKEN

lab_8b78:
    movw ix, #mem_868f      ;8b78  e6 86 8f
    mov a, mem_00ae         ;8b7b  05 ae
    call sub_e76c           ;8b7d  31 e7 6c
    bhs lab_8b98            ;8b80  f8 16

lab_8b82:
    mov a, mem_00ae         ;8b82  05 ae
    mov mem_0205, a         ;8b84  61 02 05
    jmp lab_8bce            ;8b87  21 8b ce

lab_8b8a:
    mov a, mem_00ae         ;8b8a  05 ae
    cmp a, #0x00            ;8b8c  14 00    0x00 = preset 6 key
    beq lab_8b82            ;8b8e  fd f2
    cmp a, #0x04            ;8b90  14 04    0x04 = preset 4 key
    beq lab_8b82            ;8b92  fd ee
    cmp a, #0x06            ;8b94  14 06    0x06 = preset 1 key
    beq lab_8b82            ;8b96  fd ea

lab_8b98:
    ret                     ;8b98  20

lab_8b99:
    mov a, mem_0095         ;8b99  05 95
    beq lab_8ba2            ;8b9b  fd 05
    cmp a, #0x02            ;8b9d  14 02
    beq lab_8bc1            ;8b9f  fd 20
    ret                     ;8ba1  20

lab_8ba2:
    call sub_9a02           ;8ba2  31 9a 02
    mov mem_00c1, #0x00     ;8ba5  85 c1 00
    movw ix, #mem_8bd0      ;8ba8  e6 8b d0
    mov a, mem_00ae         ;8bab  05 ae
    call sub_e746           ;8bad  31 e7 46
    beq lab_8bcf            ;8bb0  fd 1d
    mov mem_00c8, a         ;8bb2  45 c8
    mov mem_02fe, a         ;8bb4  61 02 fe
    call sub_8cee           ;8bb7  31 8c ee
    mov mem_00c2, #0x24     ;8bba  85 c2 24
    call sub_8c91           ;8bbd  31 8c 91
    ret                     ;8bc0  20

lab_8bc1:
    movw ix, #mem_8bd0      ;8bc1  e6 8b d0
    mov a, mem_00ae         ;8bc4  05 ae
    call sub_e746           ;8bc6  31 e7 46
    beq lab_8bcf            ;8bc9  fd 04
    mov mem_01c6, a         ;8bcb  61 01 c6

lab_8bce:
    callv #4                ;8bce  ec          CALLV #4 = callv4_8c84

lab_8bcf:
    ret                     ;8bcf  20

mem_8bd0:
;table of byte pairs used with sub_e746
    .byte 0x00              ;8bd0  00          DATA '\x00'
    .byte 0x06              ;8bd1  06          DATA '\x06'

    .byte 0x01              ;8bd2  01          DATA '\x01'
    .byte 0x05              ;8bd3  05          DATA '\x05'

    .byte 0x02              ;8bd4  02          DATA '\x02'
    .byte 0x04              ;8bd5  04          DATA '\x04'

    .byte 0x04              ;8bd6  04          DATA '\x04'
    .byte 0x03              ;8bd7  03          DATA '\x03'

    .byte 0x05              ;8bd8  05          DATA '\x05'
    .byte 0x02              ;8bd9  02          DATA '\x02'

    .byte 0x06              ;8bda  06          DATA '\x06'
    .byte 0x01              ;8bdb  01          DATA '\x01'

    .byte 0xFF              ;8bdc  ff          DATA '\xff'
    .byte 0x00              ;8bdd  00          DATA '\x00'

lab_8bde:
;mem_fe42 table case for presets 1-6
    mov a, mem_0095         ;8bde  05 95
    bne lab_8bec            ;8be0  fc 0a
    mov a, mem_0096         ;8be2  05 96
    bne lab_8bec            ;8be4  fc 06
    bbc mem_0099:2, lab_8bed ;8be6  b2 99 04
    mov mem_00c2, #0x20     ;8be9  85 c2 20

lab_8bec:
    ret                     ;8bec  20

lab_8bed:
    mov a, mem_02fe         ;8bed  60 02 fe
    mov mem_00c8, a         ;8bf0  45 c8
    mov mem_00c2, #0x21     ;8bf2  85 c2 21
    ret                     ;8bf5  20

lab_8bf6:
;mem_fe00 table case for initial
    setb mem_00b2:1         ;8bf6  a9 b2

lab_8bf8:
;mem_fe00 table case for no code
    call sub_8ce9           ;8bf8  31 8c e9
    ret                     ;8bfb  20

lab_8bfc:
;mem_fe42 table case for initial
    clrb mem_00b2:1         ;8bfc  a1 b2

lab_8bfe:
;mem_fe42 table case for no code
    clrb mem_0099:3         ;8bfe  a3 99
    ret                     ;8c00  20

lab_8c01:
;mem_fe00 table case for mfsw vol down
    bbs pdr2:4, lab_8c0a    ;8c01  bc 04 06     branch if audio not muted
    mov a, mem_00e9         ;8c04  05 e9
    cmp a, #0xf7            ;8c06  14 f7
    bne lab_8c36            ;8c08  fc 2c

lab_8c0a:
    setb mem_0097:4         ;8c0a  ac 97
    jmp lab_8c1a            ;8c0c  21 8c 1a

lab_8c0f:
;mem_fe00 table case for mfsw vol up
    bbs pdr2:4, lab_8c18    ;8c0f  bc 04 06     branch if audio not muted
    mov a, mem_00e9         ;8c12  05 e9
    cmp a, #0xf7            ;8c14  14 f7
    bne lab_8c36            ;8c16  fc 1e

lab_8c18:
    setb mem_0097:3         ;8c18  ab 97

lab_8c1a:
    cmp mem_0095, #0x00     ;8c1a  95 95 00
    bne lab_8c25            ;8c1d  fc 06
    mov a, mem_00c5         ;8c1f  05 c5
    beq lab_8c25            ;8c21  fd 02
    setb mem_00dc:4         ;8c23  ac dc

lab_8c25:
    setb mem_0098:6         ;8c25  ae 98
    mov a, mem_00b1         ;8c27  05 b1
    beq lab_8c2e            ;8c29  fd 03
    callv #4                ;8c2b  ec          CALLV #4 = callv4_8c84
    setb mem_0098:4         ;8c2c  ac 98

lab_8c2e:
    bbs mem_00af:7, lab_8c36 ;8c2e  bf af 05
    mov a, #0x36            ;8c31  04 36
    mov mem_02cd, a         ;8c33  61 02 cd

lab_8c36:
    ret                     ;8c36  20

lab_8c37:
;mem_fe00 table case for up
    mov a, mem_0095         ;8c37  05 95
    beq lab_8c44            ;8c39  fd 09
    cmp a, #0x01            ;8c3b  14 01
    beq lab_8c48            ;8c3d  fd 09
    cmp a, #0x02            ;8c3f  14 02
    beq lab_8c48            ;8c41  fd 05
    ret                     ;8c43  20

lab_8c44:
    call sub_88bd           ;8c44  31 88 bd
    ret                     ;8c47  20

lab_8c48:
    call sub_895a           ;8c48  31 89 5a
    ret                     ;8c4b  20

lab_8c4c:
;mem_fe00 table case for down
    mov a, mem_0095         ;8c4c  05 95
    beq lab_8c59            ;8c4e  fd 09
    cmp a, #0x01            ;8c50  14 01
    beq lab_8c5d            ;8c52  fd 09
    cmp a, #0x02            ;8c54  14 02
    beq lab_8c5d            ;8c56  fd 05
    ret                     ;8c58  20

lab_8c59:
    call sub_8936           ;8c59  31 89 36
    ret                     ;8c5c  20

lab_8c5d:
    call sub_89c3           ;8c5d  31 89 c3
    ret                     ;8c60  20

lab_8c61:
;mem_fe42 table case for mfsw up, mfsw down
    mov a, mem_0095         ;8c61  05 95
    beq lab_8c6e            ;8c63  fd 09
    cmp a, #0x01            ;8c65  14 01
    beq lab_8c72            ;8c67  fd 09
    cmp a, #0x02            ;8c69  14 02
    beq lab_8c72            ;8c6b  fd 05
    ret                     ;8c6d  20

lab_8c6e:
    call sub_893c           ;8c6e  31 89 3c
    ret                     ;8c71  20

lab_8c72:
    call sub_89cc           ;8c72  31 89 cc
    ret                     ;8c75  20

lab_8c76:
;mem_fe00 table case for 0x1a, 0x1b, 0x20
;mem_fe42 table case for 0x1a, 0x1b, 0x20
    clrb mem_0099:3         ;8c76  a3 99
    ret                     ;8c78  20

sub_8c79:
    mov a, #0x32            ;8c79  04 32
    mov mem_02af, a         ;8c7b  61 02 af
    setb mem_0099:4         ;8c7e  ac 99
    setb mem_00b2:4         ;8c80  ac b2
    callv #5                ;8c82  ed          CALLV #5 = callv5_8d0d
    ret                     ;8c83  20

callv4_8c84:
;CALLV #4
    clrb mem_0099:4         ;8c84  a4 99
    mov mem_00b1, #0x00     ;8c86  85 b1 00
    mov a, #0xe2            ;8c89  04 e2
    and a, mem_00b2         ;8c8b  65 b2
    mov mem_00b2, a         ;8c8d  45 b2
    callv #5                ;8c8f  ed          CALLV #5 = callv5_8d0d
    ret                     ;8c90  20

sub_8c91:
    clrb mem_0099:4         ;8c91  a4 99
    mov mem_00b1, #0x00     ;8c93  85 b1 00
    clrb mem_00b2:4         ;8c96  a4 b2
    clrb mem_00b2:0         ;8c98  a0 b2
    ret                     ;8c9a  20

sub_8c9b:
    mov a, mem_02cc         ;8c9b  60 02 cc
    beq lab_8cde            ;8c9e  fd 3e
    cmp a, #0x01            ;8ca0  14 01
    bne lab_8cab            ;8ca2  fc 07
    setb mem_00af:1         ;8ca4  a9 af
    movw a, #0x0a02         ;8ca6  e4 0a 02
    bne lab_8cd7            ;8ca9  fc 2c        BRANCH_ALWAYS_TAKEN

lab_8cab:
    movw ix, #mem_02ac      ;8cab  e6 02 ac     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;8cae  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_8cde            ;8cb1  fc 2b
    mov a, mem_02cc         ;8cb3  60 02 cc
    cmp a, #0x02            ;8cb6  14 02
    bne lab_8cc2            ;8cb8  fc 08
    mov mem_00ee, #0x80     ;8cba  85 ee 80
    movw a, #0x0a03         ;8cbd  e4 0a 03
    bne lab_8cd7            ;8cc0  fc 15        BRANCH_ALWAYS_TAKEN

lab_8cc2:
    cmp a, #0x03            ;8cc2  14 03
    bne lab_8cce            ;8cc4  fc 08
    mov mem_00ee, #0x00     ;8cc6  85 ee 00
    movw a, #0x0a04         ;8cc9  e4 0a 04
    bne lab_8cd7            ;8ccc  fc 09        BRANCH_ALWAYS_TAKEN

lab_8cce:
    cmp a, #0x04            ;8cce  14 04
    bne lab_8cde            ;8cd0  fc 0c
    clrb mem_00af:1         ;8cd2  a1 af
    movw a, #0x0000         ;8cd4  e4 00 00

lab_8cd7:
    mov mem_02cc, a         ;8cd7  61 02 cc
    swap                    ;8cda  10
    mov mem_02ac, a         ;8cdb  61 02 ac

lab_8cde:
    ret                     ;8cde  20

sub_8cdf:
    movw a, #0x03e8         ;8cdf  e4 03 e8
    bne lab_8cf6            ;8ce2  fc 12        BRANCH_ALWAYS_TAKEN

sub_8ce4:
    movw a, #0x01f4         ;8ce4  e4 01 f4
    bne lab_8cf6            ;8ce7  fc 0d        BRANCH_ALWAYS_TAKEN

sub_8ce9:
    movw a, #0x012c         ;8ce9  e4 01 2c
    bne lab_8cf6            ;8cec  fc 08        BRANCH_ALWAYS_TAKEN

sub_8cee:
    movw a, #0x00c8         ;8cee  e4 00 c8
    bne lab_8cf6            ;8cf1  fc 03        BRANCH_ALWAYS_TAKEN

sub_8cf3:
    movw a, #0x001e         ;8cf3  e4 00 1e

lab_8cf6:
    clrb mem_0099:3         ;8cf6  a3 99
    clrb mem_0099:2         ;8cf8  a2 99
    movw mem_02ad, a        ;8cfa  d4 02 ad
    setb mem_0099:3         ;8cfd  ab 99
    ret                     ;8cff  20

sub_8d00:
    cmp mem_0096, #0x0b     ;8d00  95 96 0b
    bne lab_8d0c            ;8d03  fc 07
    mov a, #0x00            ;8d05  04 00
    mov mem_0096, a         ;8d07  45 96
    mov mem_01ef, a         ;8d09  61 01 ef

lab_8d0c:
    ret                     ;8d0c  20

callv5_8d0d:
;CALLV #5
    mov a, mem_0293         ;8d0d  60 02 93
    bne lab_8d19            ;8d10  fc 07
    mov a, #0x3c            ;8d12  04 3c
    mov mem_02fa, a         ;8d14  61 02 fa
    clrb mem_00b2:3         ;8d17  a3 b2

lab_8d19:
    ret                     ;8d19  20

sub_8d1a:
    setb mem_00d5:0         ;8d1a  a8 d5
    setb mem_00f7:7         ;8d1c  af f7
    mov mem_00cc, #0x0a     ;8d1e  85 cc 0a
    ret                     ;8d21  20

sub_8d22:
    movw a, #0x0000         ;8d22  e4 00 00
    movw mem_034a, a        ;8d25  d4 03 4a
    movw mem_034c, a        ;8d28  d4 03 4c
    mov mem_036e, a         ;8d2b  61 03 6e
    ret                     ;8d2e  20

sub_8d2f:
    call sub_8d66           ;8d2f  31 8d 66
    call sub_8e3c           ;8d32  31 8e 3c
    call sub_8e6e           ;8d35  31 8e 6e
    call sub_8f3b           ;8d38  31 8f 3b
    call sub_dbbd           ;8d3b  31 db bd
    ret                     ;8d3e  20

sub_8d3f:
    bbc mem_008c:7, lab_8d60 ;8d3f  b7 8c 1e
    bbc mem_00eb:6, lab_8d61 ;8d42  b6 eb 1c
    bbc mem_008e:1, lab_8d4e ;8d45  b1 8e 06
    bbs mem_00cf:5, lab_8d60 ;8d48  bd cf 15
    bbs mem_008e:0, lab_8d57 ;8d4b  b8 8e 09

lab_8d4e:
    bbs mem_00cf:5, lab_8d60 ;8d4e  bd cf 0f
    bbc mem_008d:4, lab_8d57 ;8d51  b4 8d 03
    bbs mem_008e:3, lab_8d60 ;8d54  bb 8e 09

lab_8d57:
    mov a, mem_00d2         ;8d57  05 d2
    bne lab_8d60            ;8d59  fc 05
    setb mem_00eb:0         ;8d5b  a8 eb
    call sub_8d83           ;8d5d  31 8d 83

lab_8d60:
    ret                     ;8d60  20

lab_8d61:
    setb mem_00d0:3         ;8d61  ab d0
    clrb mem_00cf:5         ;8d63  a5 cf
    ret                     ;8d65  20

sub_8d66:
    bbs mem_00ed:1, lab_8d7b ;8d66  b9 ed 12
    bbs mem_00ed:0, lab_8d77 ;8d69  b8 ed 0b
    bbs mem_00eb:0, lab_8d73 ;8d6c  b8 eb 04
    bbs mem_008c:7, lab_8d7f ;8d6f  bf 8c 0d
    ret                     ;8d72  20

lab_8d73:
    call sub_8d83           ;8d73  31 8d 83
    ret                     ;8d76  20

lab_8d77:
    call sub_8dcb           ;8d77  31 8d cb
    ret                     ;8d7a  20

lab_8d7b:
    call sub_8e0a           ;8d7b  31 8e 0a
    ret                     ;8d7e  20

lab_8d7f:
    call sub_8d3f           ;8d7f  31 8d 3f
    ret                     ;8d82  20

sub_8d83:
    clrb mem_00eb:0         ;8d83  a0 eb
    mov a, mem_00d2         ;8d85  05 d2
    beq lab_8d8d            ;8d87  fd 04
    cmp a, #0x08            ;8d89  14 08
    bne lab_8dca            ;8d8b  fc 3d

lab_8d8d:
    bbs mem_00eb:6, lab_8db4 ;8d8d  be eb 24
    bbc mem_00cf:5, lab_8d9b ;8d90  b5 cf 08
    setb mem_00d0:3         ;8d93  ab d0
    clrb mem_00cf:5         ;8d95  a5 cf
    call sub_dd72           ;8d97  31 dd 72
    ret                     ;8d9a  20

lab_8d9b:
    call sub_dd72           ;8d9b  31 dd 72
    bbc mem_00ed:2, lab_8dca ;8d9e  b2 ed 29
    mov a, mem_0336         ;8da1  60 03 36
    mov a, #0x01            ;8da4  04 01
    cmp a                   ;8da6  12
    beq lab_8db0            ;8da7  fd 07
    mov a, mem_0095         ;8da9  05 95
    mov a, #0x0f            ;8dab  04 0f
    cmp a                   ;8dad  12
    bne lab_8dca            ;8dae  fc 1a

lab_8db0:
    mov mem_00d2, #0x01     ;8db0  85 d2 01
    ret                     ;8db3  20

lab_8db4:
    callv #7                ;8db4  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    bbc mem_00cf:0, lab_8dca ;8db5  b0 cf 12
    mov a, mem_0336         ;8db8  60 03 36
    mov a, #0x00            ;8dbb  04 00
    cmp a                   ;8dbd  12
    beq lab_8dc7            ;8dbe  fd 07
    mov a, mem_0095         ;8dc0  05 95
    mov a, #0x0f            ;8dc2  04 0f
    cmp a                   ;8dc4  12
    beq lab_8dca            ;8dc5  fd 03

lab_8dc7:
    mov mem_00d2, #0x05     ;8dc7  85 d2 05

lab_8dca:
    ret                     ;8dca  20

sub_8dcb:
    cmp mem_0096, #0x01     ;8dcb  95 96 01
    beq lab_8dca            ;8dce  fd fa
    clrb mem_00ed:0         ;8dd0  a0 ed
    cmp mem_0095, #0x0f     ;8dd2  95 95 0f
    bne lab_8dd9            ;8dd5  fc 02
    clrb mem_00ed:2         ;8dd7  a2 ed

lab_8dd9:
    bbs mem_00eb:6, lab_8df1 ;8dd9  be eb 15
    bbc mem_00ed:2, lab_8de5 ;8ddc  b2 ed 06

lab_8ddf:
    clrb mem_00ed:2         ;8ddf  a2 ed
    mov mem_00d2, #0x05     ;8de1  85 d2 05
    ret                     ;8de4  20

lab_8de5:
    bbc mem_008c:7, lab_8deb ;8de5  b7 8c 03
    bbs mem_00cf:0, lab_8ddf ;8de8  b8 cf f4

lab_8deb:
    setb mem_00ed:2         ;8deb  aa ed
    mov mem_00d2, #0x01     ;8ded  85 d2 01
    ret                     ;8df0  20

lab_8df1:
    bbc mem_00cf:5, lab_8dfe ;8df1  b5 cf 0a
    clrb mem_00ed:2         ;8df4  a2 ed
    setb mem_00d0:3         ;8df6  ab d0
    clrb mem_00cf:5         ;8df8  a5 cf
    mov mem_00d2, #0x05     ;8dfa  85 d2 05
    ret                     ;8dfd  20

lab_8dfe:
    setb mem_00cf:5         ;8dfe  ad cf
    movw a, #0x0e10         ;8e00  e4 0e 10
    movw mem_0211, a        ;8e03  d4 02 11
    clrb mem_00d0:3         ;8e06  a3 d0
    bne lab_8deb            ;8e08  fc e1        BRANCH_ALWAYS_TAKEN

sub_8e0a:
    clrb mem_00ed:1         ;8e0a  a1 ed
    bbc mem_00cf:0, lab_8e38 ;8e0c  b0 cf 29
    mov a, mem_00f6         ;8e0f  05 f6
    and a, #0x0f            ;8e11  64 0f
    cmp a, #0x05            ;8e13  14 05
    beq lab_8e37            ;8e15  fd 20
    cmp mem_0096, #0x0a     ;8e17  95 96 0a
    beq lab_8e37            ;8e1a  fd 1b
    cmp mem_0095, #0x01     ;8e1c  95 95 01
    beq lab_8e26            ;8e1f  fd 05
    call sub_9e1d           ;8e21  31 9e 1d
    blo lab_8e32            ;8e24  f9 0c

lab_8e26:
    call sub_9e34           ;8e26  31 9e 34
    mov a, #0x00            ;8e29  04 00
    mov mem_033a, a         ;8e2b  61 03 3a
    mov a, #0x0b            ;8e2e  04 0b
    bne lab_8e34            ;8e30  fc 02        BRANCH_ALWAYS_TAKEN

lab_8e32:
    mov a, #0x0a            ;8e32  04 0a

lab_8e34:
    mov mem_0322, a         ;8e34  61 03 22

lab_8e37:
    ret                     ;8e37  20

lab_8e38:
    mov mem_00d2, #0x09     ;8e38  85 d2 09
    ret                     ;8e3b  20

sub_8e3c:
    mov a, mem_00f6         ;8e3c  05 f6
    and a, #0x0f            ;8e3e  64 0f
    cmp a, #0x05            ;8e40  14 05
    bne lab_8e46            ;8e42  fc 02
    setb mem_00d7:7         ;8e44  af d7

lab_8e46:
    mov a, mem_00cc         ;8e46  05 cc
    bne lab_8e6d            ;8e48  fc 23
    call sub_9e6e           ;8e4a  31 9e 6e
    bhs lab_8e6d            ;8e4d  f8 1e
    mov a, mem_0322         ;8e4f  60 03 22
    mov mem_0321, a         ;8e52  61 03 21
    mov a, #0x00            ;8e55  04 00
    mov mem_0322, a         ;8e57  61 03 22
    mov a, mem_0321         ;8e5a  60 03 21
    beq lab_8e6d            ;8e5d  fd 0e
    cmp a, #0x0a            ;8e5f  14 0a
    beq lab_8e68            ;8e61  fd 05
    cmp a, #0x0b            ;8e63  14 0b
    beq lab_8e68            ;8e65  fd 01
    ret                     ;8e67  20

lab_8e68:
    mov a, mem_00cc         ;8e68  05 cc
    xch a, t                ;8e6a  42
    mov mem_00cc, a         ;8e6b  45 cc

lab_8e6d:
    ret                     ;8e6d  20

sub_8e6e:
    cmp mem_0095, #0x01     ;8e6e  95 95 01
    bne lab_8e82            ;8e71  fc 0f
    bbs mem_00cf:0, lab_8e82 ;8e73  b8 cf 0c
    call sub_8e83           ;8e76  31 8e 83
    blo lab_8e82            ;8e79  f9 07
    mov a, mem_00cc         ;8e7b  05 cc
    bne lab_8e82            ;8e7d  fc 03
    mov mem_00cc, #0x0a     ;8e7f  85 cc 0a

lab_8e82:
    ret                     ;8e82  20

sub_8e83:
    movw ix, #mem_8e8c      ;8e83  e6 8e 8c
    mov a, mem_0369         ;8e86  60 03 69
    jmp sub_e76c            ;8e89  21 e7 6c

mem_8e8c:
;Lookup table used with sub_e76c
    .byte 0x03              ;8e8c  03          DATA '\x03'
    .byte 0x01              ;8e8d  01          DATA '\x01'
    .byte 0x09              ;8e8e  09          DATA '\t'
    .byte 0x71              ;8e8f  71          DATA 'q'
    .byte 0xFF              ;8e90  ff          DATA '\xff'

sub_8e91:
    bbc mem_00cf:0, lab_8ecd ;8e91  b0 cf 39
    bbs mem_00e3:7, lab_8ec7 ;8e94  bf e3 30
    bbs mem_008c:7, lab_8ec7 ;8e97  bf 8c 2d
    mov a, mem_0096         ;8e9a  05 96
    cmp a, #0x0b            ;8e9c  14 0b
    beq lab_8ec7            ;8e9e  fd 27
    cmp a, #0x03            ;8ea0  14 03
    beq lab_8ec7            ;8ea2  fd 23
    cmp a, #0x02            ;8ea4  14 02
    beq lab_8ec7            ;8ea6  fd 1f
    cmp a, #0x04            ;8ea8  14 04
    beq lab_8ec7            ;8eaa  fd 1b
    cmp a, #0x01            ;8eac  14 01
    beq lab_8ec7            ;8eae  fd 17
    bbs mem_00cf:5, lab_8eb6 ;8eb0  bd cf 03
    bbs mem_00eb:6, lab_8ec7 ;8eb3  be eb 11

lab_8eb6:
    mov a, mem_0322         ;8eb6  60 03 22
    beq lab_8eca            ;8eb9  fd 0f
    cmp a, #0x0b            ;8ebb  14 0b
    bne lab_8eca            ;8ebd  fc 0b
    bbc mem_00d7:7, lab_8eca ;8ebf  b7 d7 08
    mov a, #0x00            ;8ec2  04 00
    mov mem_0321, a         ;8ec4  61 03 21

lab_8ec7:
    setb mem_00f7:7         ;8ec7  af f7
    ret                     ;8ec9  20

lab_8eca:
    clrb mem_00f7:7         ;8eca  a7 f7
    ret                     ;8ecc  20

lab_8ecd:
    bbs mem_00eb:6, lab_8ec7 ;8ecd  be eb f7
    mov a, mem_00de         ;8ed0  05 de
    and a, #0xe0            ;8ed2  64 e0
    cmp a, #0xc0            ;8ed4  14 c0
    beq lab_8eca            ;8ed6  fd f2
    bne lab_8ec7            ;8ed8  fc ed        BRANCH_ALWAYS_TAKEN

sub_8eda:
    mov a, mem_02c3         ;8eda  60 02 c3
    cmp a, mem_0095         ;8edd  15 95
    beq lab_8f05            ;8edf  fd 24
    mov a, mem_02c2         ;8ee1  60 02 c2
    mov mem_02c4, a         ;8ee4  61 02 c4
    mov a, mem_0095         ;8ee7  05 95
    mov mem_02c2, a         ;8ee9  61 02 c2
    mov a, mem_02c3         ;8eec  60 02 c3
    mov mem_0095, a         ;8eef  45 95
    callv #4                ;8ef1  ec          CALLV #4 = callv4_8c84
    mov a, mem_02c2         ;8ef2  60 02 c2
    mov a, #0x0f            ;8ef5  04 0f
    cmp a                   ;8ef7  12
    bne lab_8f05            ;8ef8  fc 0b
    mov a, mem_02c4         ;8efa  60 02 c4
    mov mem_02c2, a         ;8efd  61 02 c2
    mov a, #0x00            ;8f00  04 00
    mov mem_02c4, a         ;8f02  61 02 c4

lab_8f05:
    ret                     ;8f05  20

sub_8f06:
    mov a, mem_02c2         ;8f06  60 02 c2
    mov mem_0095, a         ;8f09  45 95
    mov a, mem_02c4         ;8f0b  60 02 c4
    mov mem_02c2, a         ;8f0e  61 02 c2
    mov a, #0x00            ;8f11  04 00
    mov mem_02c4, a         ;8f13  61 02 c4
    callv #4                ;8f16  ec          CALLV #4 = callv4_8c84
    cmp mem_0095, #0x01     ;8f17  95 95 01
    bne lab_8f28            ;8f1a  fc 0c
    mov a, mem_00f6         ;8f1c  05 f6
    and a, #0x0f            ;8f1e  64 0f
    cmp a, #0x05            ;8f20  14 05
    bne lab_8f27            ;8f22  fc 03

lab_8f24:
    call sub_8f06           ;8f24  31 8f 06

lab_8f27:
    ret                     ;8f27  20

lab_8f28:
    cmp mem_0095, #0x02     ;8f28  95 95 02
    bne lab_8f27            ;8f2b  fc fa
    bbc mem_00e0:1, lab_8f24 ;8f2d  b1 e0 f4
    mov a, mem_03ce         ;8f30  60 03 ce
    beq lab_8f24            ;8f33  fd ef
    mov a, mem_03d1         ;8f35  60 03 d1
    bne lab_8f24            ;8f38  fc ea
    ret                     ;8f3a  20

sub_8f3b:
    mov a, mem_00d2         ;8f3b  05 d2        A = table index
    movw a, #mem_8f44       ;8f3d  e4 8f 44     A = table base address
    call sub_e73c           ;8f40  31 e7 3c     Call address in table

lab_8f43:
;mem_8f44 table case 0
    ret                     ;8f43  20

mem_8f44:
    .word lab_8f43          ;8f44  8f 43       VECTOR 0
    .word lab_8f60          ;8f46  8f 60       VECTOR 1
    .word lab_8f90          ;8f48  8f 90       VECTOR 2
    .word lab_8fc0          ;8f4a  8f c0       VECTOR 3
    .word lab_8fdd          ;8f4c  8f dd       VECTOR 4
    .word lab_8fee          ;8f4e  8f ee       VECTOR 5
    .word lab_901a          ;8f50  90 1a       VECTOR 6
    .word lab_902b          ;8f52  90 2b       VECTOR 7
    .word lab_906b          ;8f54  90 6b       VECTOR 8
    .word lab_9081          ;8f56  90 81       VECTOR 9
    .word lab_9091          ;8f58  90 91       VECTOR 0
    .word lab_909a          ;8f5a  90 9a       VECTOR a
    .word lab_90ad          ;8f5c  90 ad       VECTOR b
    .word lab_90b5          ;8f5e  90 b5       VECTOR c

lab_8f60:
;mem_8f44 table case 1
    setb mem_00cf:0         ;8f60  a8 cf
    mov a, #0x14            ;8f62  04 14
    mov mem_02c1, a         ;8f64  61 02 c1
    clrb pdr8:4             ;8f67  a4 14        AMP_ON=low
    clrb pdr2:5             ;8f69  a5 04        REM_AMP_ON=low
    movw a, #0x0000         ;8f6b  e4 00 00
    mov mem_031e, a         ;8f6e  61 03 1e
    mov mem_031d, a         ;8f71  61 03 1d
    movw mem_0305, a        ;8f74  d4 03 05
    setb pdr4:0             ;8f77  a8 0e        CD_DATA_OUT=high
    setb pdr2:7             ;8f79  af 04        MAIN_5V=high
    setb pdr2:5             ;8f7b  ad 04        REM_AMP_ON=high
    bbs mem_00d0:1, lab_8f82 ;8f7d  b9 d0 02
    clrb pdr4:3             ;8f80  a3 0e        /SUB_RESET = low

lab_8f82:
    clrb mem_00d0:1         ;8f82  a1 d0
    clrb mem_00e1:7         ;8f84  a7 e1
    clrb mem_00e9:6         ;8f86  a6 e9
    call sub_90cb           ;8f88  31 90 cb
    movw a, #0x0a02         ;8f8b  e4 0a 02
    bne lab_8fb9            ;8f8e  fc 29        BRANCH_ALWAYS_TAKEN

lab_8f90:
;mem_8f44 table case 2
    mov a, mem_0213         ;8f90  60 02 13
    bne lab_8fed            ;8f93  fc 58
    mov a, #0x20            ;8f95  04 20
    mov mem_00ae, a         ;8f97  45 ae
    mov mem_0205, a         ;8f99  61 02 05
    mov mem_02cb, a         ;8f9c  61 02 cb
    setb pdr4:4             ;8f9f  ac 0e        M2S_DAT_OUT = high
    setb pdr4:5             ;8fa1  ad 0e        /M2S_CLK_OUT = high
    setb pdr2:6             ;8fa3  ae 04        MAIN_14V = high
    setb pdr4:3             ;8fa5  ab 0e        /SUB_RESET = high
    movw a, #0x000a         ;8fa7  e4 00 0a

lab_8faa:
    decw a                  ;8faa  d0
    bne lab_8faa            ;8fab  fc fd
    setb eie2:2             ;8fad  aa 3a
    setb eie2:3             ;8faf  ab 3a
    clrb eif2:2             ;8fb1  a2 3b
    mov mem_00f1, #0xb3     ;8fb3  85 f1 b3
    movw a, #0x1e03         ;8fb6  e4 1e 03

lab_8fb9:
    mov mem_00d2, a         ;8fb9  45 d2
    swap                    ;8fbb  10
    mov mem_0213, a         ;8fbc  61 02 13
    ret                     ;8fbf  20

lab_8fc0:
;mem_8f44 table case 3
    mov a, mem_0213         ;8fc0  60 02 13
    bne lab_8fed            ;8fc3  fc 28
    clrb mem_00e2:0         ;8fc5  a0 e2
    setb mem_00d0:0         ;8fc7  a8 d0
    call sub_9235           ;8fc9  31 92 35
    call sub_9250           ;8fcc  31 92 50
    call sub_92d1           ;8fcf  31 92 d1
    call sub_90f7           ;8fd2  31 90 f7
    call sub_9346           ;8fd5  31 93 46
    mov a, #0x00            ;8fd8  04 00
    mov mem_0238, a         ;8fda  61 02 38

lab_8fdd:
;mem_8f44 table case 5
    call sub_911e           ;8fdd  31 91 1e
    mov a, #0x05            ;8fe0  04 05
    mov mem_02c1, a         ;8fe2  61 02 c1
    mov mem_00d2, #0x00     ;8fe5  85 d2 00
    mov a, #0x00            ;8fe8  04 00
    mov mem_0336, a         ;8fea  61 03 36

lab_8fed:
    ret                     ;8fed  20

lab_8fee:
;mem_8f44 table case 6
    clrb mem_00d0:1         ;8fee  a1 d0
    call sub_9e34           ;8ff0  31 9e 34
    mov a, #0x0f            ;8ff3  04 0f
    mov mem_02c3, a         ;8ff5  61 02 c3
    call sub_8eda           ;8ff8  31 8e da
    mov a, mem_00e9         ;8ffb  05 e9
    cmp a, #0xff            ;8ffd  14 ff
    beq lab_9003            ;8fff  fd 02
    clrb mem_00e9:6         ;9001  a6 e9

lab_9003:
    mov a, #0x00            ;9003  04 00
    mov mem_0321, a         ;9005  61 03 21
    mov mem_0322, a         ;9008  61 03 22
    mov mem_0337, a         ;900b  61 03 37
    setb mem_00d7:6         ;900e  ae d7
    setb pdr2:1             ;9010  a9 04        /TAPE_ON=high
    call sub_c18a           ;9012  31 c1 8a
    movw a, #0x0a0d         ;9015  e4 0a 0d
    bne lab_8fb9            ;9018  fc 9f        BRANCH_ALWAYS_TAKEN

lab_901a:
;mem_8f44 table case 7
    mov a, mem_0213         ;901a  60 02 13
    bne lab_9080            ;901d  fc 61
    clrb mem_00e9:6         ;901f  a6 e9
    clrb mem_00d7:6         ;9021  a6 d7
    setb mem_00dc:7         ;9023  af dc
    setb mem_0098:6         ;9025  ae 98
    mov mem_00d2, #0x07     ;9027  85 d2 07
    ret                     ;902a  20

lab_902b:
;mem_8f44 table case 8
    mov a, mem_00f1         ;902b  05 f1
    bne lab_9080            ;902d  fc 51
    mov mem_00f1, #0x8f     ;902f  85 f1 8f
    mov a, mem_0213         ;9032  60 02 13
    bne lab_9080            ;9035  fc 49
    mov a, mem_00c2         ;9037  05 c2
    bne lab_9080            ;9039  fc 45
    mov a, mem_00cc         ;903b  05 cc
    bne lab_9080            ;903d  fc 41
    mov a, mem_00ce         ;903f  05 ce
    bne lab_9080            ;9041  fc 3d
    call sub_8e83           ;9043  31 8e 83
    blo lab_9053            ;9046  f9 0b
    setb mem_00f7:7         ;9048  af f7
    mov mem_00cc, #0x0a     ;904a  85 cc 0a
    mov a, #0x32            ;904d  04 32
    mov mem_0213, a         ;904f  61 02 13
    ret                     ;9052  20

lab_9053:
    call sub_91e0           ;9053  31 91 e0
    mov a, #0x00            ;9056  04 00
    mov mem_02ff, a         ;9058  61 02 ff
    mov a, #0x01            ;905b  04 01
    mov mem_0214, a         ;905d  61 02 14
    mov a, #0x01            ;9060  04 01
    mov mem_0336, a         ;9062  61 03 36
    movw a, #lab_c808       ;9065  e4 c8 08
    jmp lab_8fb9            ;9068  21 8f b9

lab_906b:
;mem_8f44 table case 9
    mov a, mem_0213         ;906b  60 02 13
    bne lab_9080            ;906e  fc 10
    mov a, mem_00f1         ;9070  05 f1
    bne lab_9080            ;9072  fc 0c
    movw a, mem_0305        ;9074  c4 03 05
    bne lab_9080            ;9077  fc 07
    clrb mem_00cf:0         ;9079  a0 cf
    clrb pdr2:6             ;907b  a6 04        MAIN_14V=low
    mov mem_00d2, #0x00     ;907d  85 d2 00

lab_9080:
    ret                     ;9080  20

lab_9081:
;mem_8f44 table case 0x0a
    clrb mem_00e9:6         ;9081  a6 e9
    setb pdr2:7             ;9083  af 04        MAIN_5V=high
    mov a, #0x28            ;9085  04 28
    mov mem_0213, a         ;9087  61 02 13
    mov mem_00d2, #0x0a     ;908a  85 d2 0a
    mov mem_00cc, #0x0c     ;908d  85 cc 0c
    ret                     ;9090  20

lab_9091:
;mem_8f44 table case 0x0b
    mov a, mem_0213         ;9091  60 02 13
    bne lab_9080            ;9094  fc ea
    mov mem_00d2, #0x00     ;9096  85 d2 00
    ret                     ;9099  20

lab_909a:
;mem_8f44 table case 0x0c
    mov mem_0096, #0x00     ;909a  85 96 00
    clrb mem_00e9:6         ;909d  a6 e9
    clrb mem_00de:5         ;909f  a5 de

    mov a, #0x00            ;90a1  04 00        A = 0 attempts
    mov mem_020e, a         ;90a3  61 02 0e     Store SAFE attempts

    mov mem_00f1, #0xa6     ;90a6  85 f1 a6
    mov mem_00d2, #0x0c     ;90a9  85 d2 0c
    ret                     ;90ac  20

lab_90ad:
;mem_8f44 table case 0x0d
    mov a, mem_00f1         ;90ad  05 f1
    bne lab_90b4            ;90af  fc 03
    mov mem_00d2, #0x05     ;90b1  85 d2 05

lab_90b4:
    ret                     ;90b4  20

lab_90b5:
;mem_8f44 table case 0x0e
    mov a, mem_0213         ;90b5  60 02 13
    bne lab_90b4            ;90b8  fc fa
    clrb pdr8:4             ;90ba  a4 14        AMP_ON=low
    clrb pdr2:5             ;90bc  a5 04        REM_AMP_ON=low
    setb mem_00e2:0         ;90be  a8 e2
    clrb mem_00d0:0         ;90c0  a0 d0
    call sub_91b1           ;90c2  31 91 b1
    movw a, #0x2806         ;90c5  e4 28 06
    jmp lab_8fb9            ;90c8  21 8f b9

sub_90cb:
    clrb mem_00e3:0         ;90cb  a0 e3
    clrb mem_00e5:1         ;90cd  a1 e5
    clrb mem_00e5:2         ;90cf  a2 e5
    clrb mem_00e5:3         ;90d1  a3 e5
    mov a, #0x20            ;90d3  04 20
    mov mem_0236, a         ;90d5  61 02 36
    mov a, #0x00            ;90d8  04 00
    mov mem_0096, a         ;90da  45 96
    mov mem_01ef, a         ;90dc  61 01 ef
    mov mem_00e8, a         ;90df  45 e8
    mov mem_0255, a         ;90e1  61 02 55
    mov mem_03b5, a         ;90e4  61 03 b5
    mov mem_0313, a         ;90e7  61 03 13
    mov mem_0183, a         ;90ea  61 01 83
    mov mem_0182, a         ;90ed  61 01 82
    mov mem_0302, a         ;90f0  61 03 02
    call sub_9e34           ;90f3  31 9e 34
    ret                     ;90f6  20

sub_90f7:
    mov a, #0x96            ;90f7  04 96
    mov mem_01eb, a         ;90f9  61 01 eb
    clrb mem_00e1:1         ;90fc  a1 e1
    setb mem_00e1:0         ;90fe  a8 e1
    mov a, #0x78            ;9100  04 78
    mov mem_0327, a         ;9102  61 03 27
    mov a, #0x02            ;9105  04 02
    mov mem_0332, a         ;9107  61 03 32
    mov mem_0333, a         ;910a  61 03 33
    mov mem_0334, a         ;910d  61 03 34
    mov a, #0x0b            ;9110  04 0b
    mov mem_0335, a         ;9112  61 03 35
    call sub_c2df           ;9115  31 c2 df
    mov a, #0x14            ;9118  04 14
    mov mem_0329, a         ;911a  61 03 29
    ret                     ;911d  20

sub_911e:
    bbc mem_00de:3, lab_9130 ;911e  b3 de 0f
    movw a, #0x0e10         ;9121  e4 0e 10
    movw mem_0325, a        ;9124  d4 03 25
    bbc mem_00cf:5, lab_9130 ;9127  b5 cf 06
    movw a, mem_0211        ;912a  c4 02 11
    movw mem_0325, a        ;912d  d4 03 25

lab_9130:
    mov a, mem_01ed         ;9130  60 01 ed
    beq lab_913b            ;9133  fd 06
    mov a, mem_03dc         ;9135  60 03 dc
    mov mem_0291, a         ;9138  61 02 91

lab_913b:
    mov a, #0x00            ;913b  04 00
    mov mem_01ed, a         ;913d  61 01 ed
    mov a, #0x0d            ;9140  04 0d
    mov mem_0292, a         ;9142  61 02 92
    mov a, mem_0291         ;9145  60 02 91
    cmp a, #0x0d            ;9148  14 0d
    beq lab_914e            ;914a  fd 02
    bhs lab_9154            ;914c  f8 06

lab_914e:
    mov a, mem_0291         ;914e  60 02 91
    mov mem_0292, a         ;9151  61 02 92

lab_9154:
    mov a, #0x00            ;9154  04 00
    mov mem_0293, a         ;9156  61 02 93
    clrb mem_00e2:4         ;9159  a4 e2
    mov a, mem_0290         ;915b  60 02 90
    mov mem_03d9, a         ;915e  61 03 d9
    clrb mem_00e2:3         ;9161  a3 e2
    bbc mem_00d7:5, lab_916e ;9163  b5 d7 08
    mov a, mem_0095         ;9166  05 95
    cmp a, #0x0f            ;9168  14 0f
    bne lab_9173            ;916a  fc 07
    clrb mem_00d7:5         ;916c  a5 d7

lab_916e:
    setb mem_00ca:6         ;916e  ae ca
    call sub_8f06           ;9170  31 8f 06

lab_9173:
    mov a, mem_0095         ;9173  05 95
    cmp a, #0x02            ;9175  14 02
    bne lab_9183            ;9177  fc 0a
    clrb mem_00e9:2         ;9179  a2 e9
    clrb mem_00ca:6         ;917b  a6 ca
    mov mem_00ce, #0x01     ;917d  85 ce 01
    jmp lab_91a8            ;9180  21 91 a8

lab_9183:
    cmp a, #0x01            ;9183  14 01
    bne lab_91a0            ;9185  fc 19
    clrb mem_00e9:1         ;9187  a1 e9
    bbs mem_00d7:5, lab_9192 ;9189  bd d7 06
    movw a, #mem_cfe1       ;918c  e4 cf e1
    call sub_cdb6           ;918f  31 cd b6

lab_9192:
    call sub_d9d0           ;9192  31 d9 d0
    mov mem_00cc, #0x06     ;9195  85 cc 06
    mov a, #0x01            ;9198  04 01
    mov mem_0337, a         ;919a  61 03 37
    jmp lab_91a8            ;919d  21 91 a8

lab_91a0:
    clrb mem_00e9:0         ;91a0  a0 e9
    mov mem_0095, #0x00     ;91a2  85 95 00
    mov mem_00c2, #0x01     ;91a5  85 c2 01

lab_91a8:
    clrb mem_00d7:5         ;91a8  a5 d7
    call sub_9265           ;91aa  31 92 65
    setb mem_00e9:6         ;91ad  ae e9
    callv #5                ;91af  ed          CALLV #5 = callv5_8d0d
    ret                     ;91b0  20

sub_91b1:
    clrb mem_0099:7         ;91b1  a7 99
    clrb mem_00d7:4         ;91b3  a4 d7
    callv #4                ;91b5  ec          CALLV #4 = callv4_8c84
    mov a, #0x00            ;91b6  04 00
    mov mem_0096, a         ;91b8  45 96
    mov mem_01ef, a         ;91ba  61 01 ef
    mov mem_00c2, #0x00     ;91bd  85 c2 00
    call sub_8d22           ;91c0  31 8d 22
    call sub_8d1a           ;91c3  31 8d 1a
    mov mem_00ce, #0x04     ;91c6  85 ce 04
    mov mem_00c8, #0x00     ;91c9  85 c8 00
    call sub_91f1           ;91cc  31 91 f1
    mov a, #0x20            ;91cf  04 20
    mov mem_0205, a         ;91d1  61 02 05
    bbc mem_00e4:3, lab_91df ;91d4  b3 e4 08
    movw a, #0x0000         ;91d7  e4 00 00
    movw mem_0206, a        ;91da  d4 02 06
    clrb mem_00e4:3         ;91dd  a3 e4

lab_91df:
    ret                     ;91df  20

sub_91e0:
    clrb mem_00df:3         ;91e0  a3 df
    clrb mem_00df:4         ;91e2  a4 df
    clrb mem_00df:5         ;91e4  a5 df
    clrb mem_00df:6         ;91e6  a6 df
    clrb mem_0098:4         ;91e8  a4 98
    clrb mem_0097:2         ;91ea  a2 97
    clrb mem_00cf:5         ;91ec  a5 cf
    setb mem_00d0:3         ;91ee  ab d0
    ret                     ;91f0  20

sub_91f1:
    bbc mem_008c:7, lab_91fa ;91f1  b7 8c 06
    movw a, #0x04e2         ;91f4  e4 04 e2
    movw mem_0305, a        ;91f7  d4 03 05

lab_91fa:
    clrb mem_008c:3         ;91fa  a3 8c
    call sub_ac86           ;91fc  31 ac 86
    mov a, #0x00            ;91ff  04 00
    mov mem_02d1, a         ;9201  61 02 d1
    mov mem_00ee, a         ;9204  45 ee
    clrb mem_00af:1         ;9206  a1 af
    mov mem_02cc, a         ;9208  61 02 cc
    mov mem_0096, a         ;920b  45 96
    mov mem_0201, a         ;920d  61 02 01
    mov a, mem_00fd         ;9210  05 fd
    and a, #0xf0            ;9212  64 f0
    bne lab_9234            ;9214  fc 1e
    mov a, #0x00            ;9216  04 00
    mov mem_0385, a         ;9218  61 03 85
    callv #7                ;921b  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    call sub_ac7a           ;921c  31 ac 7a
    bbs mem_008c:7, lab_9234 ;921f  bf 8c 12

    movw a, #0xffff         ;9222  e4 ff ff
    movw mem_008f, a        ;9225  d5 8f

    mov a, #0x00            ;9227  04 00
    mov mem_0110, a         ;9229  61 01 10
    mov mem_0111, a         ;922c  61 01 11

    mov a, #0x01            ;922f  04 01
    mov mem_0113, a         ;9231  61 01 13

lab_9234:
    ret                     ;9234  20

sub_9235:
    mov a, mem_00e8         ;9235  05 e8
    and a, #0x03            ;9237  64 03
    beq lab_923d            ;9239  fd 02
    bne lab_924a            ;923b  fc 0d        BRANCH_ALWAYS_TAKEN

lab_923d:
    mov a, mem_019f         ;923d  60 01 9f
    rorc a                  ;9240  03
    rorc a                  ;9241  03
    rorc a                  ;9242  03
    rorc a                  ;9243  03
    and a, #0x0f            ;9244  64 0f
    cmp a, #0x01            ;9246  14 01
    bne lab_924c            ;9248  fc 02

lab_924a:
    mov a, #0x00            ;924a  04 00

lab_924c:
    mov mem_030a, a         ;924c  61 03 0a
    ret                     ;924f  20

sub_9250:
    mov a, mem_030a         ;9250  60 03 0a
    cmp a, #0x01            ;9253  14 01
    beq lab_9260            ;9255  fd 09
    cmp a, #0x02            ;9257  14 02
    beq lab_9260            ;9259  fd 05
    clrb mem_008d:0         ;925b  a0 8d
    setb pdr8:4             ;925d  ac 14        AMP_ON=high
    ret                     ;925f  20

lab_9260:
    clrb mem_008d:0         ;9260  a0 8d
    clrb pdr8:4             ;9262  a4 14        AMP_ON=low
    ret                     ;9264  20

sub_9265:
    bbs mem_00e3:7, lab_92bd ;9265  bf e3 55
    bbc mem_00de:7, lab_92be ;9268  b7 de 53
    mov a, mem_0205         ;926b  60 02 05
    mov a, #0x16            ;926e  04 16
    cmp a                   ;9270  12
    bne lab_9296            ;9271  fc 23
    mov a, #0x20            ;9273  04 20
    mov mem_0205, a         ;9275  61 02 05
    bbs mem_00de:6, lab_92bd ;9278  be de 42
    bbs mem_00de:4, lab_9296 ;927b  bc de 18

    mov a, mem_0208         ;927e  60 02 08
    mov a, #0x32            ;9281  04 32
    cmp a                   ;9283  12
    beq lab_9296            ;9284  fd 10

    mov a, mem_0208         ;9286  60 02 08
    incw a                  ;9289  c0
    mov mem_0208, a         ;928a  61 02 08

    setb mem_00e4:3         ;928d  ab e4
    mov mem_0096, #0x06     ;928f  85 96 06
    mov mem_00cd, #0x01     ;9292  85 cd 01
    ret                     ;9295  20

lab_9296:
    bbc mem_00de:5, lab_92a2 ;9296  b5 de 09

    mov a, #0x02            ;9299  04 02        A = 2 attempts
    mov mem_020e, a         ;929b  61 02 0e     Store SAFE attempts

    mov a, #0x04            ;929e  04 04
    bne lab_92b8            ;92a0  fc 16        BRANCH_ALWAYS_TAKEN

lab_92a2:
    bbs mem_00de:6, lab_92bd ;92a2  be de 18
    mov a, mem_00fd         ;92a5  05 fd
    and a, #0x0f            ;92a7  64 0f
    cmp a, #0x02            ;92a9  14 02
    bne lab_92b6            ;92ab  fc 09
    mov a, #0x03            ;92ad  04 03
    mov mem_0096, a         ;92af  45 96
    mov a, #0x07            ;92b1  04 07
    mov mem_00cd, a         ;92b3  45 cd
    ret                     ;92b5  20

lab_92b6:
    mov a, #0x03            ;92b6  04 03

lab_92b8:
    mov mem_0096, a         ;92b8  45 96
    mov mem_00cd, #0x01     ;92ba  85 cd 01

lab_92bd:
    ret                     ;92bd  20

lab_92be:
    mov a, mem_0205         ;92be  60 02 05
    mov a, #0x30            ;92c1  04 30
    cmp a                   ;92c3  12
    bne lab_92ca            ;92c4  fc 04
    mov a, #0x0c            ;92c6  04 0c
    bne lab_92b8            ;92c8  fc ee        BRANCH_ALWAYS_TAKEN

lab_92ca:
    mov mem_0096, #0x05     ;92ca  85 96 05
    mov mem_00cd, #0x06     ;92cd  85 cd 06
    ret                     ;92d0  20

sub_92d1:
    mov a, mem_030e         ;92d1  60 03 0e
    and a, #0xc0            ;92d4  64 c0
    mov mem_030e, a         ;92d6  61 03 0e
    mov a, mem_030f         ;92d9  60 03 0f
    and a, #0xc0            ;92dc  64 c0
    mov mem_030f, a         ;92de  61 03 0f
    mov a, mem_0310         ;92e1  60 03 10
    and a, #0xc0            ;92e4  64 c0
    mov mem_0310, a         ;92e6  61 03 10
    mov a, mem_0311         ;92e9  60 03 11
    and a, #0xc0            ;92ec  64 c0
    mov mem_0311, a         ;92ee  61 03 11
    jmp lab_92f9            ;92f1  21 92 f9

sub_92f4:
    cmp mem_0095, #0x0f     ;92f4  95 95 0f
    beq lab_9309            ;92f7  fd 10

lab_92f9:
    mov a, mem_030a         ;92f9  60 03 0a
    mov a, #0x00            ;92fc  04 00
    cmp a                   ;92fe  12
    beq lab_930a            ;92ff  fd 09
    clrb pdr3:0             ;9301  a0 0c        FL_CLIP_ON=low
    clrb pdr3:3             ;9303  a3 0c        FR_CLIP_ON=low
    clrb pdr3:1             ;9305  a1 0c        RL_CLIP_ON=low
    clrb pdr3:2             ;9307  a2 0c        RR_CLIP_ON=low

lab_9309:
    ret                     ;9309  20

lab_930a:
    mov a, mem_0311         ;930a  60 03 11
    beq lab_9317            ;930d  fd 08
    and a, #0x3f            ;930f  64 3f
    bne lab_9319            ;9311  fc 06
    clrb pdr3:0             ;9313  a0 0c        FL_CLIP_ON=low
    beq lab_9319            ;9315  fd 02        BRANCH_ALWAYS_TAKEN

lab_9317:
    setb pdr3:0             ;9317  a8 0c        FL_CLIP_ON=high

lab_9319:
    mov a, mem_0310         ;9319  60 03 10
    beq lab_9326            ;931c  fd 08
    and a, #0x3f            ;931e  64 3f
    bne lab_9328            ;9320  fc 06
    clrb pdr3:3             ;9322  a3 0c        FR_CLIP_ON=low
    beq lab_9328            ;9324  fd 02        BRANCH_ALWAYS_TAKEN

lab_9326:
    setb pdr3:3             ;9326  ab 0c        FR_CLIP_ON=high

lab_9328:
    mov a, mem_030f         ;9328  60 03 0f
    beq lab_9335            ;932b  fd 08
    and a, #0x3f            ;932d  64 3f
    bne lab_9337            ;932f  fc 06
    clrb pdr3:1             ;9331  a1 0c        RL_CLIP_ON=low
    beq lab_9337            ;9333  fd 02        BRANCH_ALWAYS_TAKEN

lab_9335:
    setb pdr3:1             ;9335  a9 0c        RL_CLIP_ON=high

lab_9337:
    mov a, mem_030e         ;9337  60 03 0e
    beq lab_9343            ;933a  fd 07
    and a, #0x3f            ;933c  64 3f
    bne lab_9345            ;933e  fc 05
    clrb pdr3:2             ;9340  a2 0c        RR_CLIP_ON=low
    ret                     ;9342  20

lab_9343:
    setb pdr3:2             ;9343  aa 0c        RR_CLIP_ON=high

lab_9345:
    ret                     ;9345  20

sub_9346:
    mov a, mem_00e8         ;9346  05 e8
    and a, #0xc0            ;9348  64 c0
    beq lab_9355            ;934a  fd 09
    cmp a, #0x40            ;934c  14 40
    beq lab_9359            ;934e  fd 09
    cmp a, #0x80            ;9350  14 80
    beq lab_935d            ;9352  fd 09
    ret                     ;9354  20

lab_9355:
    mov a, #0x00            ;9355  04 00
    beq lab_935f            ;9357  fd 06        BRANCH_ALWAYS_TAKEN

lab_9359:
    mov a, #0x01            ;9359  04 01
    bne lab_935f            ;935b  fc 02        BRANCH_ALWAYS_TAKEN

lab_935d:
    mov a, #0x02            ;935d  04 02

lab_935f:
    mov mem_030b, a         ;935f  61 03 0b
    ret                     ;9362  20

sub_9363:
    mov a, mem_0095         ;9363  05 95
    bne lab_936b            ;9365  fc 04
    mov mem_00c2, #0x01     ;9367  85 c2 01
    ret                     ;936a  20

lab_936b:
    cmp a, #0x01            ;936b  14 01
    bne lab_9373            ;936d  fc 04
    mov mem_00cc, #0x01     ;936f  85 cc 01
    ret                     ;9372  20

lab_9373:
    cmp a, #0x02            ;9373  14 02
    bne lab_937b            ;9375  fc 04
    mov mem_00ce, #0x01     ;9377  85 ce 01
    ret                     ;937a  20

lab_937b:
    cmp a, #0x0f            ;937b  14 0f
    bne lab_9384            ;937d  fc 05
    clrb mem_00ed:2         ;937f  a2 ed
    mov mem_00d2, #0x05     ;9381  85 d2 05

lab_9384:
    ret                     ;9384  20

sub_9385:
    movw ix, #mem_030e      ;9385  e6 03 0e
    mov a, mem_03b5         ;9388  60 03 b5
    jmp lab_93ac            ;938b  21 93 ac

sub_938e:
    movw ix, #mem_030f      ;938e  e6 03 0f
    mov a, mem_03b5         ;9391  60 03 b5
    jmp lab_93aa            ;9394  21 93 aa

sub_9397:
    movw ix, #mem_0310      ;9397  e6 03 10
    mov a, mem_03b5         ;939a  60 03 b5
    jmp lab_93a8            ;939d  21 93 a8

sub_93a0:
    movw ix, #mem_0311      ;93a0  e6 03 11
    mov a, mem_03b5         ;93a3  60 03 b5
    rolc a                  ;93a6  02
    rolc a                  ;93a7  02

lab_93a8:
    rolc a                  ;93a8  02
    rolc a                  ;93a9  02

lab_93aa:
    rolc a                  ;93aa  02
    rolc a                  ;93ab  02

lab_93ac:
    and a, #0xc0            ;93ac  64 c0
    mov mem_0307, a         ;93ae  61 03 07
    mov a, @ix+0x00         ;93b1  06 00
    and a, #0xc0            ;93b3  64 c0
    xor a                   ;93b5  52
    bne lab_93c4            ;93b6  fc 0c
    mov a, @ix+0x00         ;93b8  06 00
    and a, #0x3f            ;93ba  64 3f
    beq lab_93c3            ;93bc  fd 05
    mov a, @ix+0x00         ;93be  06 00
    decw a                  ;93c0  d0
    mov @ix+0x00, a         ;93c1  46 00

lab_93c3:
    ret                     ;93c3  20

lab_93c4:
    mov a, mem_0307         ;93c4  60 03 07
    or a, #0x14             ;93c7  74 14
    mov @ix+0x00, a         ;93c9  46 00
    ret                     ;93cb  20

sub_93cc:
    bbc mem_00cf:0, lab_93fd ;93cc  b0 cf 2e

sub_93cf:
    mov a, #0x40            ;93cf  04 40
    movw ix, #mem_0300      ;93d1  e6 03 00
    call sub_8571           ;93d4  31 85 71
    movw a, mem_0300        ;93d7  c4 03 00
    movw a, #0x0174         ;93da  e4 01 74
    cmpw a                  ;93dd  13
    bhs lab_93ef            ;93de  f8 0f
    xchw a, t               ;93e0  43
    movw a, #0x0104         ;93e1  e4 01 04
    cmpw a                  ;93e4  13
    bhs lab_93eb            ;93e5  f8 04
    mov a, #0x02            ;93e7  04 02
    bne lab_93f1            ;93e9  fc 06        BRANCH_ALWAYS_TAKEN

lab_93eb:
    mov a, #0x01            ;93eb  04 01
    bne lab_93f1            ;93ed  fc 02        BRANCH_ALWAYS_TAKEN

lab_93ef:
    mov a, #0x00            ;93ef  04 00

lab_93f1:
    mov mem_0302, a         ;93f1  61 03 02
    mov a, mem_0302         ;93f4  60 03 02
    beq lab_93fd            ;93f7  fd 04
    call sub_d9d0           ;93f9  31 d9 d0
    ret                     ;93fc  20

lab_93fd:
    ret                     ;93fd  20

sub_93fe:
    mov a, mem_0182         ;93fe  60 01 82
    and a, #0x0f            ;9401  64 0f
    mov a, mem_0302         ;9403  60 03 02
    cmp a                   ;9406  12
    beq lab_9467            ;9407  fd 5e
    mov a, mem_0182         ;9409  60 01 82
    mov mem_0183, a         ;940c  61 01 83
    mov a, mem_0302         ;940f  60 03 02
    mov mem_0182, a         ;9412  61 01 82
    beq lab_9420            ;9415  fd 09
    cmp a, #0x02            ;9417  14 02
    beq lab_9474            ;9419  fd 59
    cmp a, #0x01            ;941b  14 01
    beq lab_947e            ;941d  fd 5f
    ret                     ;941f  20

lab_9420:
    clrb mem_00d7:6         ;9420  a6 d7
    clrb mem_00f7:7         ;9422  a7 f7
    mov a, mem_0183         ;9424  60 01 83
    mov a, #0x11            ;9427  04 11
    cmp a                   ;9429  12
    bne lab_9462            ;942a  fc 36
    mov a, #0x04            ;942c  04 04
    mov mem_031e, a         ;942e  61 03 1e
    mov a, #0x00            ;9431  04 00
    mov mem_031d, a         ;9433  61 03 1d
    bbs mem_008c:7, lab_9462 ;9436  bf 8c 29
    mov a, #0x3c            ;9439  04 3c
    mov mem_02fa, a         ;943b  61 02 fa
    call sub_d9d0           ;943e  31 d9 d0
    mov a, mem_0095         ;9441  05 95
    cmp a, #0x01            ;9443  14 01
    beq lab_944d            ;9445  fd 06
    cmp a, #0x0f            ;9447  14 0f
    bne lab_945a            ;9449  fc 0f
    beq lab_9462            ;944b  fd 15        BRANCH_ALWAYS_TAKEN

lab_944d:
    clrb mem_00d7:6         ;944d  a6 d7
    clrb mem_00f7:7         ;944f  a7 f7
    call sub_d9d0           ;9451  31 d9 d0
    mov mem_00cc, #0x17     ;9454  85 cc 17
    jmp lab_9462            ;9457  21 94 62

lab_945a:
    cmp mem_0095, #0x02     ;945a  95 95 02
    bne lab_9462            ;945d  fc 03
    mov mem_00ce, #0x01     ;945f  85 ce 01

lab_9462:
    mov a, #0x00            ;9462  04 00
    mov mem_0182, a         ;9464  61 01 82

lab_9467:
    mov a, mem_0182         ;9467  60 01 82
    bne lab_9473            ;946a  fc 07
    mov a, mem_031e         ;946c  60 03 1e
    bne lab_9473            ;946f  fc 02
    setb mem_00e9:4         ;9471  ac e9

lab_9473:
    ret                     ;9473  20

lab_9474:
    call set_00fd_hi_nib_0  ;9474  31 e3 8a    Store 0x0 in mem_00fd high nibble
    callv #7                ;9477  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    mov a, #0x12            ;9478  04 12
    mov mem_0182, a         ;947a  61 01 82
    ret                     ;947d  20

lab_947e:
    mov a, #0x01            ;947e  04 01
    mov mem_031e, a         ;9480  61 03 1e
    call set_00fd_hi_nib_0  ;9483  31 e3 8a    Store 0x0 in mem_00fd high nibble
    callv #7                ;9486  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    cmp mem_0095, #0x00     ;9487  95 95 00
    bne lab_949d            ;948a  fc 11
    call sub_9a02           ;948c  31 9a 02
    clrb mem_00c9:6         ;948f  a6 c9
    clrb mem_00ba:1         ;9491  a1 ba
    setb mem_0097:0         ;9493  a8 97
    setb mem_00e9:0         ;9495  a8 e9
    mov mem_00c1, #0x00     ;9497  85 c1 00
    mov mem_00c2, #0x00     ;949a  85 c2 00

lab_949d:
    mov a, mem_0095         ;949d  05 95
    cmp a, #0x01            ;949f  14 01
    beq lab_94a8            ;94a1  fd 05
    setb mem_00f7:7         ;94a3  af f7
    mov mem_00cc, #0x0a     ;94a5  85 cc 0a

lab_94a8:
    mov a, #0x00            ;94a8  04 00
    mov mem_031d, a         ;94aa  61 03 1d
    mov mem_00ce, #0x04     ;94ad  85 ce 04
    mov a, #0x11            ;94b0  04 11
    mov mem_0182, a         ;94b2  61 01 82
    ret                     ;94b5  20

sub_94b6:
    mov a, mem_031d         ;94b6  60 03 1d
    bne lab_94f3            ;94b9  fc 38
    mov a, mem_031e         ;94bb  60 03 1e
    cmp a, #0x01            ;94be  14 01
    beq lab_94d7            ;94c0  fd 15
    cmp a, #0x02            ;94c2  14 02
    beq lab_94f4            ;94c4  fd 2e
    cmp a, #0x03            ;94c6  14 03
    beq lab_9503            ;94c8  fd 39
    cmp a, #0x04            ;94ca  14 04
    beq lab_9508            ;94cc  fd 3a
    cmp a, #0x05            ;94ce  14 05
    beq lab_951f            ;94d0  fd 4d
    cmp a, #0x06            ;94d2  14 06
    beq lab_952d            ;94d4  fd 57
    ret                     ;94d6  20

lab_94d7:
    setb pdr2:1             ;94d7  a9 04        /TAPE_ON=high
    mulu a                  ;94d9  01
    mulu a                  ;94da  01
    mulu a                  ;94db  01
    setb mem_00d7:6         ;94dc  ae d7
    clrb pdr8:4             ;94de  a4 14        AMP_ON=low
    clrb pdr2:5             ;94e0  a5 04        REM_AMP_ON=low
    clrb mem_00e9:4         ;94e2  a4 e9
    bbc pdr2:4, lab_94e9    ;94e4  b4 04 02     branch if audio muted
    setb mem_00e9:4         ;94e7  ac e9

lab_94e9:
    movw a, #0x2802         ;94e9  e4 28 02

lab_94ec:
    mov mem_031e, a         ;94ec  61 03 1e
    swap                    ;94ef  10
    mov mem_031d, a         ;94f0  61 03 1d

lab_94f3:
    ret                     ;94f3  20

lab_94f4:
    clrb mem_00e9:4         ;94f4  a4 e9
    call sub_8e83           ;94f6  31 8e 83
    blo lab_94fe            ;94f9  f9 03
    mov mem_00cc, #0x0a     ;94fb  85 cc 0a

lab_94fe:
    movw a, #0x0a03         ;94fe  e4 0a 03
    bne lab_94ec            ;9501  fc e9        BRANCH_ALWAYS_TAKEN

lab_9503:
    movw a, #0x0000         ;9503  e4 00 00
    beq lab_94ec            ;9506  fd e4        BRANCH_ALWAYS_TAKEN

lab_9508:
    bbs mem_00cf:5, lab_9514 ;9508  bd cf 09
    bbs mem_00eb:6, lab_9511 ;950b  be eb 03
    bbs mem_00ed:2, lab_9514 ;950e  ba ed 03

lab_9511:
    jmp lab_94f3            ;9511  21 94 f3

lab_9514:
    clrb pdr8:4             ;9514  a4 14        AMP_ON=low
    setb pdr2:5             ;9516  ad 04        REM_AMP_ON=high
    clrb mem_00e9:4         ;9518  a4 e9
    movw a, #0x1e05         ;951a  e4 1e 05
    bne lab_94ec            ;951d  fc cd        BRANCH_ALWAYS_TAKEN

lab_951f:
    clrb pdr8:4             ;951f  a4 14        AMP_ON=low
    mov a, mem_030a         ;9521  60 03 0a
    bne lab_9528            ;9524  fc 02
    setb pdr8:4             ;9526  ac 14        AMP_ON=high

lab_9528:
    movw a, #0x1406         ;9528  e4 14 06
    bne lab_94ec            ;952b  fc bf        BRANCH_ALWAYS_TAKEN

lab_952d:
    setb mem_00e9:4         ;952d  ac e9
    jmp lab_94fe            ;952f  21 94 fe

sub_9532:
    mov a, #0x40            ;9532  04 40
    movw ix, #mem_0300      ;9534  e6 03 00
    call sub_8571           ;9537  31 85 71
    movw a, mem_0300        ;953a  c4 03 00
    movw a, #0x01ad         ;953d  e4 01 ad
    cmpw a                  ;9540  13
    bhs lab_9552            ;9541  f8 0f
    xchw a, t               ;9543  43
    movw a, #0x0174         ;9544  e4 01 74
    cmpw a                  ;9547  13
    bhs lab_954e            ;9548  f8 04
    mov a, #0x02            ;954a  04 02
    bne lab_9554            ;954c  fc 06        BRANCH_ALWAYS_TAKEN

lab_954e:
    mov a, #0x01            ;954e  04 01
    bne lab_9554            ;9550  fc 02        BRANCH_ALWAYS_TAKEN

lab_9552:
    mov a, #0x00            ;9552  04 00

lab_9554:
    mov mem_0334, a         ;9554  61 03 34
    ret                     ;9557  20

sub_9558:
    mov a, mem_0333         ;9558  60 03 33
    mov a, mem_0334         ;955b  60 03 34
    cmp a                   ;955e  12
    beq lab_956d            ;955f  fd 0c
    mov a, mem_0333         ;9561  60 03 33
    mov mem_0332, a         ;9564  61 03 32
    mov a, mem_0334         ;9567  60 03 34
    mov mem_0333, a         ;956a  61 03 33

lab_956d:
    cmp a, #0x01            ;956d  14 01
    bne lab_957a            ;956f  fc 09
    mov a, mem_0332         ;9571  60 03 32
    cmp a, #0x02            ;9574  14 02
    bne lab_957e            ;9576  fc 06
    mov a, #0x11            ;9578  04 11

lab_957a:
    mov mem_0335, a         ;957a  61 03 35
    ret                     ;957d  20

lab_957e:
    mov a, #0x01            ;957e  04 01
    bne lab_957a            ;9580  fc f8        BRANCH_ALWAYS_TAKEN

sub_9582:
    mov a, mem_00c2         ;9582  05 c2        A = table index
    movw a, #mem_958a       ;9584  e4 95 8a     A = table base address
    jmp sub_e73c            ;9587  21 e7 3c     Jump to address in table

mem_958a:
    .word lab_966a          ;958a  96 6a       VECTOR 00
    .word lab_95f4          ;958c  95 f4       VECTOR 01
    .word lab_966b          ;958e  96 6b       VECTOR 02
    .word lab_967a          ;9590  96 7a       VECTOR 03
    .word lab_9683          ;9592  96 83       VECTOR 04
    .word sub_968c          ;9594  96 8c       VECTOR 05
    .word lab_95f0          ;9596  95 f0       VECTOR 06
    .word lab_982f          ;9598  98 2f       VECTOR 07
    .word lab_9840          ;959a  98 40       VECTOR 08
    .word lab_966a          ;959c  96 6a       VECTOR 09
    .word lab_966a          ;959e  96 6a       VECTOR 0a
    .word lab_9697          ;95a0  96 97       VECTOR 0b
    .word lab_96a0          ;95a2  96 a0       VECTOR 0c
    .word lab_96b6          ;95a4  96 b6       VECTOR 0d
    .word lab_96cf          ;95a6  96 cf       VECTOR 0e
    .word lab_96e0          ;95a8  96 e0       VECTOR 0f
    .word lab_9723          ;95aa  97 23       VECTOR 10
    .word lab_9730          ;95ac  97 30       VECTOR 11
    .word lab_973b          ;95ae  97 3b       VECTOR 12
    .word lab_975a          ;95b0  97 5a       VECTOR 13
    .word lab_9763          ;95b2  97 63       VECTOR 14
    .word sub_977c          ;95b4  97 7c       VECTOR 15
    .word lab_9788          ;95b6  97 88       VECTOR 16
    .word lab_978f          ;95b8  97 8f       VECTOR 17
    .word lab_9795          ;95ba  97 95       VECTOR 18
    .word lab_97a1          ;95bc  97 a1       VECTOR 19
    .word lab_97ae          ;95be  97 ae       VECTOR 1a
    .word lab_97ba          ;95c0  97 ba       VECTOR 1b
    .word lab_97c3          ;95c2  97 c3       VECTOR 1c
    .word lab_966a          ;95c4  96 6a       VECTOR 1d
    .word lab_966a          ;95c6  96 6a       VECTOR 1e
    .word lab_97cc          ;95c8  97 cc       VECTOR 1f
    .word lab_97d8          ;95ca  97 d8       VECTOR 20
    .word lab_97e0          ;95cc  97 e0       VECTOR 21
    .word lab_97e7          ;95ce  97 e7       VECTOR 22
    .word lab_97f3          ;95d0  97 f3       VECTOR 23
    .word lab_97ff          ;95d2  97 ff       VECTOR 24
    .word lab_9805          ;95d4  98 05       VECTOR 25
    .word lab_9811          ;95d6  98 11       VECTOR 26
    .word lab_966a          ;95d8  96 6a       VECTOR 27
    .word lab_9821          ;95da  98 21       VECTOR 28
    .word lab_9846          ;95dc  98 46       VECTOR 29
    .word lab_9855          ;95de  98 55       VECTOR 2a
    .word lab_985f          ;95e0  98 5f       VECTOR 2b
    .word lab_986c          ;95e2  98 6c       VECTOR 2c
    .word lab_9878          ;95e4  98 78       VECTOR 2d
    .word lab_987f          ;95e6  98 7f       VECTOR 2e
    .word lab_98aa          ;95e8  98 aa       VECTOR 2f
    .word lab_98d4          ;95ea  98 d4       VECTOR 30
    .word lab_98ef          ;95ec  98 ef       VECTOR 31
    .word lab_966a          ;95ee  96 6a       VECTOR 32

lab_95f0:
    mov a, mem_00cc         ;95f0  05 cc
    bne lab_966a            ;95f2  fc 76

lab_95f4:
    mov mem_00ce, #0x04     ;95f4  85 ce 04
    call sub_9e34           ;95f7  31 9e 34
    mov a, #0x00            ;95fa  04 00
    mov mem_028a, a         ;95fc  61 02 8a
    mov a, mem_00c5         ;95ff  05 c5
    bne lab_960b            ;9601  fc 08
    movw a, mem_0296        ;9603  c4 02 96
    movw a, #0x0c00         ;9606  e4 0c 00
    bne lab_961a            ;9609  fc 0f        BRANCH_ALWAYS_TAKEN

lab_960b:
    clrb mem_00dc:0         ;960b  a0 dc
    clrb mem_00dc:5         ;960d  a5 dc
    mov a, #0x00            ;960f  04 00
    mov mem_0288, a         ;9611  61 02 88
    movw a, mem_0298        ;9614  c4 02 98
    movw a, #0x0800         ;9617  e4 08 00

lab_961a:
    movw mem_0294, a        ;961a  d4 02 94
    xchw a, t               ;961d  43
    movw mem_00b3, a        ;961e  d5 b3
    mov a, mem_02c2         ;9620  60 02 c2
    bne lab_963a            ;9623  fc 15
    mov a, mem_01a4         ;9625  60 01 a4
    beq lab_9634            ;9628  fd 0a
    mov a, mem_00c5         ;962a  05 c5
    beq lab_9634            ;962c  fd 06
    setb mem_00dc:0         ;962e  a8 dc
    setb mem_00dc:5         ;9630  ad dc
    bne lab_9642            ;9632  fc 0e        BRANCH_ALWAYS_TAKEN

lab_9634:
    mov a, mem_00c5         ;9634  05 c5
    beq lab_9647            ;9636  fd 0f
    bne lab_963e            ;9638  fc 04        BRANCH_ALWAYS_TAKEN

lab_963a:
    mov a, mem_00c5         ;963a  05 c5
    beq lab_9647            ;963c  fd 09

lab_963e:
    clrb mem_00dc:0         ;963e  a0 dc
    clrb mem_00dc:5         ;9640  a5 dc

lab_9642:
    mov a, #0x00            ;9642  04 00
    mov mem_0288, a         ;9644  61 02 88

lab_9647:
    call sub_9a02           ;9647  31 9a 02
    mov a, #0x00            ;964a  04 00
    mov mem_02c3, a         ;964c  61 02 c3
    call sub_8eda           ;964f  31 8e da
    mov mem_00c1, #0x00     ;9652  85 c1 00
    clrb mem_00e9:0         ;9655  a0 e9

lab_9657:
    mov mem_00c8, #0x00     ;9657  85 c8 00
    setb mem_00c9:1         ;965a  a9 c9
    setb mem_0098:4         ;965c  ac 98
    clrb mem_0098:6         ;965e  a6 98
    clrb mem_00b2:5         ;9660  a5 b2
    clrb mem_00b2:6         ;9662  a6 b2
    call sub_99cb           ;9664  31 99 cb
    mov mem_00c2, #0x02     ;9667  85 c2 02

lab_966a:
    ret                     ;966a  20

lab_966b:
    bbc mem_00c9:0, lab_966a ;966b  b0 c9 fc
    setb mem_0097:0         ;966e  a8 97
    call sub_9ed1           ;9670  31 9e d1
    call sub_99cb           ;9673  31 99 cb
    mov mem_00c2, #0x03     ;9676  85 c2 03
    ret                     ;9679  20

lab_967a:
    bbc mem_00c9:0, lab_966a ;967a  b0 c9 ed
    setb mem_0097:0         ;967d  a8 97
    mov mem_00c2, #0x11     ;967f  85 c2 11
    ret                     ;9682  20

lab_9683:
    call sub_9a02           ;9683  31 9a 02
    mov mem_00c1, #0x00     ;9686  85 c1 00
    jmp lab_9657            ;9689  21 96 57

sub_968c:
    mov a, #0x00            ;968c  04 00
    mov mem_00c2, a         ;968e  45 c2
    mov mem_00c1, a         ;9690  45 c1
    setb mem_00d0:5         ;9692  ad d0
    setb mem_0097:0         ;9694  a8 97
    ret                     ;9696  20

lab_9697:
    clrb mem_00e9:0         ;9697  a0 e9
    call sub_99cb           ;9699  31 99 cb
    mov mem_00c2, #0x0c     ;969c  85 c2 0c
    ret                     ;969f  20

lab_96a0:
    bbc mem_00c9:0, lab_96a9 ;96a0  b0 c9 06
    mov mem_00c2, #0x0d     ;96a3  85 c2 0d
    jmp lab_96b5            ;96a6  21 96 b5

lab_96a9:
    movw a, mem_00c3        ;96a9  c5 c3
    movw a, #0x0003         ;96ab  e4 00 03
    cmpw a                  ;96ae  13
    bne lab_96b5            ;96af  fc 04
    setb mem_00ba:1         ;96b1  a9 ba
    setb mem_0097:0         ;96b3  a8 97

lab_96b5:
    ret                     ;96b5  20

lab_96b6:
    call sub_9a06           ;96b6  31 9a 06
    cmp mem_00c1, #0x01     ;96b9  95 c1 01
    bne lab_96c4            ;96bc  fc 06
    call sub_99c3           ;96be  31 99 c3
    jmp lab_96c7            ;96c1  21 96 c7

lab_96c4:
    call sub_99ba           ;96c4  31 99 ba

lab_96c7:
    setb mem_0097:0         ;96c7  a8 97
    setb mem_0098:4         ;96c9  ac 98
    mov mem_00c2, #0x0e     ;96cb  85 c2 0e
    ret                     ;96ce  20

lab_96cf:
    bbc mem_00c9:0, lab_96df ;96cf  b0 c9 0d
    mov a, #0x10            ;96d2  04 10
    bbs mem_00af:5, lab_96dd ;96d4  bd af 06
    setb mem_0098:7         ;96d7  af 98
    clrb mem_00c9:3         ;96d9  a3 c9
    mov a, #0x0f            ;96db  04 0f

lab_96dd:
    mov mem_00c2, a         ;96dd  45 c2

lab_96df:
    ret                     ;96df  20

lab_96e0:
    bbc mem_00c9:3, lab_9722 ;96e0  b3 c9 3f
    clrb mem_00c9:2         ;96e3  a2 c9
    mov mem_00c2, #0x14     ;96e5  85 c2 14
    mov a, mem_00c5         ;96e8  05 c5
    bne lab_96fd            ;96ea  fc 11
    bbs mem_00b9:0, lab_96fa ;96ec  b8 b9 0b
    call sub_8457           ;96ef  31 84 57
    cmp mem_00a0, #0x03     ;96f2  95 a0 03
    bne lab_96fa            ;96f5  fc 03
    mov mem_00c2, #0x29     ;96f7  85 c2 29

lab_96fa:
    jmp lab_9722            ;96fa  21 97 22

lab_96fd:
    bbs mem_00b9:0, lab_9722 ;96fd  b8 b9 22
    call sub_8457           ;9700  31 84 57
    cmp mem_00a0, #0x03     ;9703  95 a0 03
    bne lab_9722            ;9706  fc 1a
    call sub_857f           ;9708  31 85 7f
    call sub_8588           ;970b  31 85 88
    movw a, mem_01c1        ;970e  c4 01 c1
    movw a, mem_01bd        ;9711  c4 01 bd
    cmpw a                  ;9714  13
    bhs lab_9722            ;9715  f8 0b
    movw a, mem_01c3        ;9717  c4 01 c3
    movw a, mem_01bf        ;971a  c4 01 bf
    cmpw a                  ;971d  13
    bhs lab_9722            ;971e  f8 02
    setb mem_00c9:2         ;9720  aa c9

lab_9722:
    ret                     ;9722  20

lab_9723:
    call sub_9a06           ;9723  31 9a 06
    bbc mem_00af:5, lab_972b ;9726  b5 af 02
    clrb mem_00c9:4         ;9729  a4 c9

lab_972b:
    call sub_99ba           ;972b  31 99 ba
    beq lab_96c7            ;972e  fd 97

lab_9730:
    setb mem_00c9:1         ;9730  a9 c9
    setb mem_0098:4         ;9732  ac 98
    call sub_99ac           ;9734  31 99 ac
    mov mem_00c2, #0x12     ;9737  85 c2 12
    ret                     ;973a  20

lab_973b:
    bbc mem_0099:0, lab_9759 ;973b  b0 99 1b
    clrb mem_00c9:6         ;973e  a6 c9
    setb mem_00e9:0         ;9740  a8 e9
    setb mem_0098:4         ;9742  ac 98
    cmp mem_00c1, #0x02     ;9744  95 c1 02
    bne lab_9753            ;9747  fc 0a
    call sub_99a7           ;9749  31 99 a7
    setb mem_00c9:6         ;974c  ae c9
    mov a, #0x13            ;974e  04 13
    jmp lab_9757            ;9750  21 97 57

lab_9753:
    mov a, #0x00            ;9753  04 00
    mov mem_00c1, a         ;9755  45 c1

lab_9757:
    mov mem_00c2, a         ;9757  45 c2

lab_9759:
    ret                     ;9759  20

lab_975a:
    bbc mem_0099:0, lab_9762 ;975a  b0 99 05
    mov mem_00c2, #0x0b     ;975d  85 c2 0b
    clrb mem_00c9:6         ;9760  a6 c9

lab_9762:
    ret                     ;9762  20

lab_9763:
    mov a, #0x10            ;9763  04 10
    bbc mem_00c9:2, lab_9779 ;9765  b2 c9 11
    call sub_99da           ;9768  31 99 da
    clrb mem_00ba:1         ;976b  a1 ba
    setb mem_0097:0         ;976d  a8 97
    cmp mem_00c1, #0x01     ;976f  95 c1 01
    bne lab_9777            ;9772  fc 03
    mov mem_00c1, #0x00     ;9774  85 c1 00

lab_9777:
    mov a, #0x11            ;9777  04 11

lab_9779:
    mov mem_00c2, a         ;9779  45 c2
    ret                     ;977b  20

sub_977c:
    call sub_9a06           ;977c  31 9a 06
    call sub_99da           ;977f  31 99 da
    setb mem_0098:4         ;9782  ac 98
    mov mem_00c2, #0x16     ;9784  85 c2 16
    ret                     ;9787  20

lab_9788:
    bbc mem_0099:2, lab_978e ;9788  b2 99 03
    mov mem_00c2, #0x17     ;978b  85 c2 17

lab_978e:
    ret                     ;978e  20

lab_978f:
    mov mem_00c2, #0x18     ;978f  85 c2 18
    jmp lab_97bd            ;9792  21 97 bd

lab_9795:
    bbc mem_00c9:0, lab_97a0 ;9795  b0 c9 08
    setb mem_0097:0         ;9798  a8 97
    call sub_99cb           ;979a  31 99 cb
    mov mem_00c2, #0x19     ;979d  85 c2 19

lab_97a0:
    ret                     ;97a0  20

lab_97a1:
    bbc mem_00c9:0, lab_97ad ;97a1  b0 c9 09
    mov a, #0x11            ;97a4  04 11
    bbc mem_00af:4, lab_97ab ;97a6  b4 af 02
    mov a, #0x1a            ;97a9  04 1a

lab_97ab:
    mov mem_00c2, a         ;97ab  45 c2

lab_97ad:
    ret                     ;97ad  20

lab_97ae:
    call sub_977c           ;97ae  31 97 7c
    call sub_99c7           ;97b1  31 99 c7
    setb mem_0097:0         ;97b4  a8 97
    mov mem_00c2, #0x19     ;97b6  85 c2 19
    ret                     ;97b9  20

lab_97ba:
    mov mem_00c2, #0x1c     ;97ba  85 c2 1c

lab_97bd:
    clrb mem_00e9:0         ;97bd  a0 e9
    call sub_99cb           ;97bf  31 99 cb
    ret                     ;97c2  20

lab_97c3:
    bbc mem_00c9:0, lab_97cb ;97c3  b0 c9 05
    setb mem_0097:0         ;97c6  a8 97
    mov mem_00c2, #0x11     ;97c8  85 c2 11

lab_97cb:
    ret                     ;97cb  20

lab_97cc:
    bbc mem_0099:2, lab_97d7 ;97cc  b2 99 08
    mov a, mem_02fe         ;97cf  60 02 fe
    mov mem_00c8, a         ;97d2  45 c8
    mov mem_00c2, #0x25     ;97d4  85 c2 25

lab_97d7:
    ret                     ;97d7  20

lab_97d8:
    callv #4                ;97d8  ec          CALLV #4 = callv4_8c84
    call sub_99b1           ;97d9  31 99 b1
    mov mem_00c2, #0x26     ;97dc  85 c2 26
    ret                     ;97df  20

lab_97e0:
    call sub_9906           ;97e0  31 99 06
    mov mem_00c2, #0x22     ;97e3  85 c2 22
    ret                     ;97e6  20

lab_97e7:
    clrb mem_00e9:0         ;97e7  a0 e9
    callv #4                ;97e9  ec          CALLV #4 = callv4_8c84
    setb mem_0098:4         ;97ea  ac 98
    call sub_99cb           ;97ec  31 99 cb
    mov mem_00c2, #0x23     ;97ef  85 c2 23
    ret                     ;97f2  20

lab_97f3:
    bbc mem_00c9:0, lab_97fe ;97f3  b0 c9 08
    setb mem_0097:0         ;97f6  a8 97
    mov mem_00c2, #0x26     ;97f8  85 c2 26
    call sub_99ac           ;97fb  31 99 ac

lab_97fe:
    ret                     ;97fe  20

lab_97ff:
    setb mem_0098:4         ;97ff  ac 98
    mov mem_00c2, #0x1f     ;9801  85 c2 1f
    ret                     ;9804  20

lab_9805:
    callv #4                ;9805  ec          CALLV #4 = callv4_8c84
    setb mem_0098:4         ;9806  ac 98
    call sub_9954           ;9808  31 99 54
    clrb mem_00e9:0         ;980b  a0 e9
    mov mem_00c2, #0x28     ;980d  85 c2 28
    ret                     ;9810  20

lab_9811:
    bbc mem_0099:0, lab_9820 ;9811  b0 99 0c
    clrb mem_00c9:6         ;9814  a6 c9
    setb mem_00e9:0         ;9816  a8 e9
    setb mem_0098:4         ;9818  ac 98

lab_981a:
    mov a, #0x00            ;981a  04 00
    mov mem_00c2, a         ;981c  45 c2
    mov mem_00c1, a         ;981e  45 c1

lab_9820:
    ret                     ;9820  20

lab_9821:
    bbc mem_00c9:0, lab_9820 ;9821  b0 c9 fc
    setb mem_0097:0         ;9824  a8 97
    cmp mem_00c5, #0x01     ;9826  95 c5 01
    bne lab_981a            ;9829  fc ef
    mov mem_00c2, #0x07     ;982b  85 c2 07

lab_982e:
    ret                     ;982e  20

lab_982f:
    mov a, mem_0274         ;982f  60 02 74
    bne lab_982e            ;9832  fc fa
    call sub_c2a2           ;9834  31 c2 a2
    mov mem_00c2, #0x08     ;9837  85 c2 08
    mov a, #0xb2            ;983a  04 b2
    mov mem_00f1, a         ;983c  45 f1
    bne lab_9820            ;983e  fc e0        BRANCH_ALWAYS_TAKEN

lab_9840:
    mov a, mem_00f1         ;9840  05 f1
    bne lab_982e            ;9842  fc ea
    beq lab_981a            ;9844  fd d4        BRANCH_ALWAYS_TAKEN

lab_9846:
    movw a, #0x0000         ;9846  e4 00 00
    movw mem_01ba, a        ;9849  d4 01 ba
    mov a, #0x32            ;984c  04 32
    mov mem_01bc, a         ;984e  61 01 bc
    mov mem_00c2, #0x2a     ;9851  85 c2 2a
    ret                     ;9854  20

lab_9855:
    clrb mem_00c9:7         ;9855  a7 c9
    clrb mem_00ca:0         ;9857  a0 ca
    setb mem_0097:0         ;9859  a8 97
    mov mem_00c2, #0x2b     ;985b  85 c2 2b
    ret                     ;985e  20

lab_985f:
    bbc mem_00c9:7, lab_986b ;985f  b7 c9 09
    clrb mem_00c9:7         ;9862  a7 c9
    setb mem_00ca:0         ;9864  a8 ca
    setb mem_0097:0         ;9866  a8 97
    mov mem_00c2, #0x2c     ;9868  85 c2 2c

lab_986b:
    ret                     ;986b  20

lab_986c:
    bbc mem_00c9:7, lab_9877 ;986c  b7 c9 08
    clrb mem_00c9:3         ;986f  a3 c9
    call sub_c98d           ;9871  31 c9 8d
    mov mem_00c2, #0x2d     ;9874  85 c2 2d

lab_9877:
    ret                     ;9877  20

lab_9878:
    bbc mem_00c9:3, lab_987e ;9878  b3 c9 03
    mov mem_00c2, #0x2e     ;987b  85 c2 2e

lab_987e:
    ret                     ;987e  20

lab_987f:
    mov a, mem_01bc         ;987f  60 01 bc
    beq lab_98a1            ;9882  fd 1d
    bbs pdr0:6, lab_98a0    ;9884  be 00 19     PLL_DI
    nop                     ;9887  00
    nop                     ;9888  00
    nop                     ;9889  00
    bbs pdr0:6, lab_98a0    ;988a  be 00 13     PLL_DI
    nop                     ;988d  00
    nop                     ;988e  00
    nop                     ;988f  00
    bbs pdr0:6, lab_98a0    ;9890  be 00 0d     PLL_DI
    nop                     ;9893  00
    nop                     ;9894  00
    nop                     ;9895  00
    bbs pdr0:6, lab_98a0    ;9896  be 00 07     PLL_DI
    setb mem_0098:7         ;9899  af 98
    clrb mem_00c9:3         ;989b  a3 c9
    mov mem_00c2, #0x2f     ;989d  85 c2 2f

lab_98a0:
    ret                     ;98a0  20

lab_98a1:
    mov a, #0x02            ;98a1  04 02
    mov mem_01bb, a         ;98a3  61 01 bb
    mov mem_00c2, #0x30     ;98a6  85 c2 30
    ret                     ;98a9  20

lab_98aa:
    bbc mem_00c9:3, lab_98d3 ;98aa  b3 c9 26
    mov a, mem_0282         ;98ad  60 02 82
    cmp a, #0x2a            ;98b0  14 2a
    bne lab_98c9            ;98b2  fc 15
    mov a, mem_0283         ;98b4  60 02 83
    cmp a, #0x0c            ;98b7  14 0c
    blo lab_98c9            ;98b9  f9 0e
    cmp a, #0x55            ;98bb  14 55
    bhs lab_98c9            ;98bd  f8 0a
    mov a, mem_01ba         ;98bf  60 01 ba
    incw a                  ;98c2  c0
    mov mem_01ba, a         ;98c3  61 01 ba
    jmp lab_98d0            ;98c6  21 98 d0

lab_98c9:
    mov a, mem_01bb         ;98c9  60 01 bb
    incw a                  ;98cc  c0
    mov mem_01bb, a         ;98cd  61 01 bb

lab_98d0:
    mov mem_00c2, #0x30     ;98d0  85 c2 30

lab_98d3:
    ret                     ;98d3  20

lab_98d4:
    mov a, mem_01bb         ;98d4  60 01 bb
    cmp a, #0x02            ;98d7  14 02
    blo lab_98df            ;98d9  f9 04
    clrb mem_00c9:2         ;98db  a2 c9
    bhs lab_98ea            ;98dd  f8 0b        BRANCH_ALWAYS_TAKEN

lab_98df:
    mov a, mem_01ba         ;98df  60 01 ba
    cmp a, #0x04            ;98e2  14 04
    mov a, #0x2a            ;98e4  04 2a
    blo lab_98ec            ;98e6  f9 04
    setb mem_00c9:2         ;98e8  aa c9

lab_98ea:
    mov a, #0x14            ;98ea  04 14

lab_98ec:
    mov mem_00c2, a         ;98ec  45 c2
    ret                     ;98ee  20

lab_98ef:
    call sub_9a02           ;98ef  31 9a 02
    mov mem_00c1, #0x00     ;98f2  85 c1 00
    setb mem_00c9:0         ;98f5  a8 c9
    mov mem_00c2, #0x1c     ;98f7  85 c2 1c
    setb mem_0098:4         ;98fa  ac 98
    ret                     ;98fc  20

sub_98fd:
    movw a, #0x0000         ;98fd  e4 00 00
    mov a, mem_00c8         ;9900  05 c8
    decw a                  ;9902  d0
    clrc                    ;9903  81
    rolc a                  ;9904  02
    ret                     ;9905  20

sub_9906:
    mov a, mem_00c5         ;9906  05 c5
    bne lab_991a            ;9908  fc 10
    call sub_98fd           ;990a  31 98 fd
    clrc                    ;990d  81
    movw a, #mem_fe84       ;990e  e4 fe 84
    addcw a                 ;9911  23
    movw a, @a              ;9912  93
    mov a, @a               ;9913  92
    mov mem_01a5, a         ;9914  61 01 a5
    mov mem_00c7, a         ;9917  45 c7
    ret                     ;9919  20

lab_991a:
    cmp a, #0x01            ;991a  14 01
    bne lab_9937            ;991c  fc 19
    movw a, #0x0000         ;991e  e4 00 00
    mov a, mem_00c8         ;9921  05 c8
    beq lab_9934            ;9923  fd 0f
    decw a                  ;9925  d0
    clrc                    ;9926  81
    rolc a                  ;9927  02
    clrc                    ;9928  81
    movw a, #mem_fe90       ;9929  e4 fe 90
    addcw a                 ;992c  23
    movw a, @a              ;992d  93
    mov a, @a               ;992e  92
    mov mem_01ac, a         ;992f  61 01 ac
    mov mem_00c7, a         ;9932  45 c7

lab_9934:
    jmp lab_994a            ;9934  21 99 4a

lab_9937:
    cmp a, #0x02            ;9937  14 02
    bne lab_9953            ;9939  fc 18
    call sub_98fd           ;993b  31 98 fd
    clrc                    ;993e  81
    movw a, #mem_fe9c       ;993f  e4 fe 9c
    addcw a                 ;9942  23
    movw a, @a              ;9943  93
    mov a, @a               ;9944  92
    mov mem_01b3, a         ;9945  61 01 b3
    mov mem_00c7, a         ;9948  45 c7

lab_994a:
    setb mem_00dc:0         ;994a  a8 dc
    setb mem_00dc:5         ;994c  ad dc
    mov a, #0x00            ;994e  04 00
    mov mem_0288, a         ;9950  61 02 88

lab_9953:
    ret                     ;9953  20

sub_9954:
    mov a, mem_00c5         ;9954  05 c5
    bne lab_996b            ;9956  fc 13
    call sub_98fd           ;9958  31 98 fd
    clrc                    ;995b  81
    movw a, #mem_fe84       ;995c  e4 fe 84
    addcw a                 ;995f  23
    movw a, @a              ;9960  93
    movw ep, a              ;9961  e3
    mov a, mem_00c8         ;9962  05 c8
    decw a                  ;9964  d0
    clrc                    ;9965  81
    addc a, #0x0c           ;9966  24 0c
    jmp lab_9993            ;9968  21 99 93

lab_996b:
    cmp a, #0x01            ;996b  14 01
    bne lab_997f            ;996d  fc 10
    call sub_98fd           ;996f  31 98 fd
    clrc                    ;9972  81
    movw a, #mem_fe90       ;9973  e4 fe 90
    addcw a                 ;9976  23
    movw a, @a              ;9977  93
    movw ep, a              ;9978  e3
    mov a, mem_00c8         ;9979  05 c8
    decw a                  ;997b  d0
    jmp lab_9993            ;997c  21 99 93

lab_997f:
    cmp a, #0x02            ;997f  14 02
    bne lab_9993            ;9981  fc 10
    call sub_98fd           ;9983  31 98 fd
    clrc                    ;9986  81
    movw a, #mem_fe9c       ;9987  e4 fe 9c
    addcw a                 ;998a  23
    movw a, @a              ;998b  93
    movw ep, a              ;998c  e3
    mov a, mem_00c8         ;998d  05 c8
    decw a                  ;998f  d0
    clrc                    ;9990  81
    addc a, #0x06           ;9991  24 06

lab_9993:
    mov a, mem_00c7         ;9993  05 c7
    mov @ep, a              ;9995  47
    xch a, t                ;9996  42
    mov mem_026c, a         ;9997  61 02 6c
    setb mem_00c0:1         ;999a  a9 c0
    setb mem_0097:1         ;999c  a9 97
    mov a, #0x01            ;999e  04 01
    mov mem_0274, a         ;99a0  61 02 74
    mov mem_02cc, a         ;99a3  61 02 cc
    ret                     ;99a6  20

sub_99a7:
    movw a, #0x01f4         ;99a7  e4 01 f4
    bne lab_99b4            ;99aa  fc 08        BRANCH_ALWAYS_TAKEN

sub_99ac:
    movw a, #0x006e         ;99ac  e4 00 6e
    bne lab_99b4            ;99af  fc 03        BRANCH_ALWAYS_TAKEN

sub_99b1:
    movw a, #0x0003         ;99b1  e4 00 03

lab_99b4:
    movw mem_02b0, a        ;99b4  d4 02 b0
    clrb mem_0099:0         ;99b7  a0 99
    ret                     ;99b9  20

sub_99ba:
    bbc mem_00c9:4, sub_99cb ;99ba  b4 c9 0e
    clrb mem_00c9:4         ;99bd  a4 c9
    mov a, #0x14            ;99bf  04 14
    bne lab_99d1            ;99c1  fc 0e        BRANCH_ALWAYS_TAKEN

sub_99c3:
    mov a, #0x19            ;99c3  04 19
    bne lab_99d1            ;99c5  fc 0a        BRANCH_ALWAYS_TAKEN

sub_99c7:
    mov a, #0x0a            ;99c7  04 0a
    bne lab_99d1            ;99c9  fc 06        BRANCH_ALWAYS_TAKEN

sub_99cb:
    mov a, #0x05            ;99cb  04 05
    bne lab_99d1            ;99cd  fc 02        BRANCH_ALWAYS_TAKEN

    ;XXX 99cf looks unreachable
    mov a, #0x03            ;99cf  04 03

lab_99d1:
    movw a, #0x0000         ;99d1  e4 00 00
    xch a, t                ;99d4  42
    movw mem_00c3, a        ;99d5  d5 c3
    clrb mem_00c9:0         ;99d7  a0 c9
    ret                     ;99d9  20

sub_99da:
    mov a, #0x00            ;99da  04 00

lab_99dc:
    mov a, mem_00c5         ;99dc  05 c5
    bne lab_99e5            ;99de  fc 05
    movw ep, #mem_01a5      ;99e0  e7 01 a5
    beq lab_99f5            ;99e3  fd 10        BRANCH_ALWAYS_TAKEN

lab_99e5:
    cmp a, #0x01            ;99e5  14 01
    bne lab_99ee            ;99e7  fc 05
    movw ep, #mem_01ac      ;99e9  e7 01 ac
    beq lab_99f5            ;99ec  fd 07        BRANCH_ALWAYS_TAKEN

lab_99ee:
    cmp a, #0x02            ;99ee  14 02
    bne lab_9a01            ;99f0  fc 0f
    movw ep, #mem_01b3      ;99f2  e7 01 b3

lab_99f5:
    xch a, t                ;99f5  42
    cmp a, #0x00            ;99f6  14 00
    bne lab_99fe            ;99f8  fc 04
    mov a, mem_00c7         ;99fa  05 c7
    mov @ep, a              ;99fc  47
    ret                     ;99fd  20

lab_99fe:
    mov a, @ep              ;99fe  07
    mov mem_00c7, a         ;99ff  45 c7

lab_9a01:
    ret                     ;9a01  20

sub_9a02:
    mov a, #0x01            ;9a02  04 01
    bne lab_99dc            ;9a04  fc d6        BRANCH_ALWAYS_TAKEN

sub_9a06:
    bbc mem_00c9:5, lab_9a39 ;9a06  b5 c9 30
    mov a, #0x00            ;9a09  04 00
    movw a, #0x0001         ;9a0b  e4 00 01

lab_9a0e:
    clrb mem_00c9:4         ;9a0e  a4 c9
    clrc                    ;9a10  81
    addc a, mem_00c7        ;9a11  25 c7
    mov mem_00c7, a         ;9a13  45 c7
    xch a, t                ;9a15  42
    mov a, mem_00c5         ;9a16  05 c5
    bne lab_9a25            ;9a18  fc 0b
    cmp mem_00c7, #0x77     ;9a1a  95 c7 77
    blo lab_9a38            ;9a1d  f9 19
    xch a, t                ;9a1f  42
    mov mem_00c7, a         ;9a20  45 c7
    setb mem_00c9:4         ;9a22  ac c9
    ret                     ;9a24  20

lab_9a25:
    cmp mem_00c7, #0x65     ;9a25  95 c7 65
    blo lab_9a2f            ;9a28  f9 05
    swap                    ;9a2a  10
    mov mem_00c7, a         ;9a2b  45 c7
    setb mem_00c9:4         ;9a2d  ac c9

lab_9a2f:
    setb mem_00dc:0         ;9a2f  a8 dc
    setb mem_00dc:5         ;9a31  ad dc
    mov a, #0x00            ;9a33  04 00
    mov mem_0288, a         ;9a35  61 02 88

lab_9a38:
    ret                     ;9a38  20

lab_9a39:
    mov a, #0x76            ;9a39  04 76
    movw a, #0x64ff         ;9a3b  e4 64 ff
    bne lab_9a0e            ;9a3e  fc ce        BRANCH_ALWAYS_TAKEN

sub_9a40:
    call sub_9eb0           ;9a40  31 9e b0
    mov a, mem_00cc         ;9a43  05 cc
    cmp a, #0x21            ;9a45  14 21
    bhs lab_9a93            ;9a47  f8 4a

    mov a, mem_00cc         ;9a49  05 cc        A = table index
    movw a, #mem_9a51       ;9a4b  e4 9a 51     A = table base address
    jmp sub_e73c            ;9a4e  21 e7 3c     Jump to address in table

mem_9a51:
    .word lab_9a93          ;9a51  9a 93       VECTOR
    .word lab_9aac          ;9a53  9a ac       VECTOR
    .word lab_9ab7          ;9a55  9a b7       VECTOR
    .word lab_9ab8          ;9a57  9a b8       VECTOR
    .word lab_9ad7          ;9a59  9a d7       VECTOR
    .word lab_9afd          ;9a5b  9a fd       VECTOR
    .word lab_9a99          ;9a5d  9a 99       VECTOR
    .word lab_9ab7          ;9a5f  9a b7       VECTOR
    .word lab_9ace          ;9a61  9a ce       VECTOR
    .word lab_9ba2          ;9a63  9b a2       VECTOR
    .word lab_9b26          ;9a65  9b 26       VECTOR
    .word lab_9b45          ;9a67  9b 45       VECTOR
    .word lab_9b8e          ;9a69  9b 8e       VECTOR
    .word lab_9c3d          ;9a6b  9c 3d       VECTOR
    .word lab_9c59          ;9a6d  9c 59       VECTOR
    .word lab_9c60          ;9a6f  9c 60       VECTOR
    .word lab_9c64          ;9a71  9c 64       VECTOR
    .word lab_9c68          ;9a73  9c 68       VECTOR
    .word lab_9ca3          ;9a75  9c a3       VECTOR
    .word lab_9cb3          ;9a77  9c b3       VECTOR
    .word lab_9b57          ;9a79  9b 57       VECTOR
    .word lab_9bff          ;9a7b  9b ff       VECTOR
    .word lab_9ac2          ;9a7d  9a c2       VECTOR
    .word lab_9b18          ;9a7f  9b 18       VECTOR
    .word lab_9a94          ;9a81  9a 94       VECTOR
    .word lab_9cb7          ;9a83  9c b7       VECTOR
    .word lab_9d05          ;9a85  9d 05       VECTOR
    .word lab_9d3b          ;9a87  9d 3b       VECTOR
    .word lab_9d47          ;9a89  9d 47       VECTOR
    .word lab_9c0d          ;9a8b  9c 0d       VECTOR
    .word lab_9c28          ;9a8d  9c 28       VECTOR
    .word lab_9af4          ;9a8f  9a f4       VECTOR
    .word lab_9be8          ;9a91  9b e8       VECTOR

lab_9a93:
    ret                     ;9a93  20

lab_9a94:
    setb mem_00d7:0         ;9a94  a8 d7
    jmp lab_9aa5            ;9a96  21 9a a5

lab_9a99:
    call sub_9e74           ;9a99  31 9e 74
    bhs lab_9ab7            ;9a9c  f8 19
    setb mem_00d7:0         ;9a9e  a8 d7
    cmp mem_0095, #0x01     ;9aa0  95 95 01
    beq lab_9aac            ;9aa3  fd 07

lab_9aa5:
    call sub_9e1d           ;9aa5  31 9e 1d
    bhs lab_9aac            ;9aa8  f8 02
    setb mem_00d7:1         ;9aaa  a9 d7

lab_9aac:
    mov a, #0x03            ;9aac  04 03
    mov mem_02fd, a         ;9aae  61 02 fd
    call sub_9df8           ;9ab1  31 9d f8
    ret                     ;9ab4  20

lab_9ab5:
    mov mem_00cc, a         ;9ab5  45 cc

lab_9ab7:
    ret                     ;9ab7  20

lab_9ab8:
    call sub_9d61           ;9ab8  31 9d 61
    call sub_9ec3           ;9abb  31 9e c3
    mov a, #0x16            ;9abe  04 16
    bne lab_9ab5            ;9ac0  fc f3        BRANCH_ALWAYS_TAKEN

lab_9ac2:
    mov a, mem_0312         ;9ac2  60 03 12
    bne lab_9af3            ;9ac5  fc 2c
    call sub_9da9           ;9ac7  31 9d a9
    mov a, #0x08            ;9aca  04 08
    bne lab_9ab5            ;9acc  fc e7        BRANCH_ALWAYS_TAKEN

lab_9ace:
    mov a, mem_0312         ;9ace  60 03 12
    bne lab_9af3            ;9ad1  fc 20
    call sub_9dc4           ;9ad3  31 9d c4
    ret                     ;9ad6  20

lab_9ad7:
    call sub_9e34           ;9ad7  31 9e 34
    mov a, #0x00            ;9ada  04 00
    mov mem_033a, a         ;9adc  61 03 3a
    mov a, mem_0313         ;9adf  60 03 13
    bne lab_9af3            ;9ae2  fc 0f
    setb mem_0098:4         ;9ae4  ac 98
    mov a, #0x1e            ;9ae6  04 1e
    mov mem_0313, a         ;9ae8  61 03 13
    mov a, #0x01            ;9aeb  04 01
    mov mem_02cc, a         ;9aed  61 02 cc
    mov mem_00cc, #0x1f     ;9af0  85 cc 1f

lab_9af3:
    ret                     ;9af3  20

lab_9af4:
    mov a, mem_02cc         ;9af4  60 02 cc
    bne lab_9af3            ;9af7  fc fa
    mov mem_00cc, #0x05     ;9af9  85 cc 05
    ret                     ;9afc  20

lab_9afd:
    mov a, mem_0313         ;9afd  60 03 13
    bne lab_9af3            ;9b00  fc f1

sub_9b02:
    mov a, #0x00            ;9b02  04 00
    mov mem_0313, a         ;9b04  61 03 13
    call sub_8f06           ;9b07  31 8f 06
    cmp mem_0095, #0x01     ;9b0a  95 95 01
    bne lab_9b12            ;9b0d  fc 03
    mov mem_0095, #0x00     ;9b0f  85 95 00

lab_9b12:
    call sub_9363           ;9b12  31 93 63
    jmp lab_9b8a            ;9b15  21 9b 8a

lab_9b18:
    mov a, #0x01            ;9b18  04 01
    mov mem_0349, a         ;9b1a  61 03 49
    clrb mem_00d7:6         ;9b1d  a6 d7
    clrb mem_00d7:1         ;9b1f  a1 d7
    clrb mem_00d7:0         ;9b21  a0 d7
    jmp lab_9b8a            ;9b23  21 9b 8a

lab_9b26:
    .byte 0x60, 0x00, 0xf6  ;9b26  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    and a, #0x0f            ;9b29  64 0f
    cmp a, #0x05            ;9b2b  14 05
    bhs lab_9b42            ;9b2d  f8 13
    cmp a, #0x04            ;9b2f  14 04
    beq lab_9b42            ;9b31  fd 0f
    cmp mem_0095, #0x01     ;9b33  95 95 01
    beq lab_9b3d            ;9b36  fd 05
    cmp mem_0095, #0x0f     ;9b38  95 95 0f
    beq lab_9b3d            ;9b3b  fd 00

lab_9b3d:
    mov a, #0x0a            ;9b3d  04 0a
    mov mem_0349, a         ;9b3f  61 03 49

lab_9b42:
    jmp lab_9b8a            ;9b42  21 9b 8a

lab_9b45:
    mov a, #0x07            ;9b45  04 07
    mov mem_0349, a         ;9b47  61 03 49
    .byte 0x60, 0x00, 0xf6  ;9b4a  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    and a, #0x0f            ;9b4d  64 0f
    cmp a, #0x01            ;9b4f  14 01
    beq lab_9b93            ;9b51  fd 40
    mov mem_00cc, #0x14     ;9b53  85 cc 14
    ret                     ;9b56  20

lab_9b57:
    mov a, mem_0369         ;9b57  60 03 69
    cmp a, #0x03            ;9b5a  14 03
    beq lab_9b70            ;9b5c  fd 12
    cmp a, #0x01            ;9b5e  14 01
    beq lab_9b70            ;9b60  fd 0e
    cmp a, #0x09            ;9b62  14 09
    beq lab_9b70            ;9b64  fd 0a
    cmp a, #0x71            ;9b66  14 71
    beq lab_9b70            ;9b68  fd 06
    mov a, mem_0308         ;9b6a  60 03 08
    bne lab_9b70            ;9b6d  fc 01
    ret                     ;9b6f  20

lab_9b70:
    cmp mem_0095, #0x01     ;9b70  95 95 01
    bne lab_9b81            ;9b73  fc 0c
    mov a, mem_0308         ;9b75  60 03 08
    beq lab_9b93            ;9b78  fd 19
    mov a, #0x02            ;9b7a  04 02
    mov mem_0308, a         ;9b7c  61 03 08
    bne lab_9b8a            ;9b7f  fc 09        BRANCH_ALWAYS_TAKEN

lab_9b81:
    call sub_9e41           ;9b81  31 9e 41
    mov a, mem_00cc         ;9b84  05 cc
    cmp a, #0x15            ;9b86  14 15
    beq lab_9b8d            ;9b88  fd 03

lab_9b8a:
    mov mem_00cc, #0x00     ;9b8a  85 cc 00

lab_9b8d:
    ret                     ;9b8d  20

lab_9b8e:
    mov a, #0x07            ;9b8e  04 07
    mov mem_0349, a         ;9b90  61 03 49

lab_9b93:
    setb pdr3:5             ;9b93  ad 0c        /TAPE_DOLBY_ON=high
    mov a, mem_0095         ;9b95  05 95
    cmp a, #0x01            ;9b97  14 01
    bne lab_9b9f            ;9b99  fc 04
    mov mem_00cc, #0x09     ;9b9b  85 cc 09
    ret                     ;9b9e  20

lab_9b9f:
    jmp lab_9c55            ;9b9f  21 9c 55

lab_9ba2:
    mov a, mem_0369         ;9ba2  60 03 69
    cmp a, #0x03            ;9ba5  14 03
    beq lab_9bb2            ;9ba7  fd 09
    cmp a, #0x01            ;9ba9  14 01
    beq lab_9bb2            ;9bab  fd 05
    cmp a, #0x09            ;9bad  14 09
    beq lab_9bb2            ;9baf  fd 01
    ret                     ;9bb1  20

lab_9bb2:
    bbs mem_00d7:2, lab_9be5 ;9bb2  ba d7 30
    call sub_8f06           ;9bb5  31 8f 06
    cmp mem_0095, #0x0f     ;9bb8  95 95 0f
    bne lab_9bc0            ;9bbb  fc 03
    call sub_8f06           ;9bbd  31 8f 06

lab_9bc0:
    mov a, mem_0095         ;9bc0  05 95
    beq lab_9bcc            ;9bc2  fd 08
    cmp a, #0x01            ;9bc4  14 01
    bne lab_9bd1            ;9bc6  fc 09
    mov mem_00cc, #0x06     ;9bc8  85 cc 06
    ret                     ;9bcb  20

lab_9bcc:
    mov mem_00c2, #0x01     ;9bcc  85 c2 01
    bne lab_9be5            ;9bcf  fc 14        BRANCH_NEVER_TAKEN

lab_9bd1:
    cmp a, #0x02            ;9bd1  14 02
    bne lab_9bdc            ;9bd3  fc 07
    clrb mem_00ca:6         ;9bd5  a6 ca
    mov mem_00ce, #0x01     ;9bd7  85 ce 01
    beq lab_9be5            ;9bda  fd 09        BRANCH_ALWAYS_TAKEN

lab_9bdc:
    cmp a, #0x0f            ;9bdc  14 0f
    bne lab_9be5            ;9bde  fc 05
    mov mem_0095, #0x00     ;9be0  85 95 00
    bne lab_9bcc            ;9be3  fc e7        BRANCH_NEVER_TAKEN

lab_9be5:
    jmp lab_9c55            ;9be5  21 9c 55

lab_9be8:
    cmp mem_0095, #0x0f     ;9be8  95 95 0f
    beq lab_9c37            ;9beb  fd 4a
    mov a, mem_033a         ;9bed  60 03 3a
    cmp a, #0x02            ;9bf0  14 02
    beq lab_9c37            ;9bf2  fd 43
    cmp mem_0095, #0x01     ;9bf4  95 95 01
    bne lab_9bff            ;9bf7  fc 06
    mov a, #0x00            ;9bf9  04 00
    mov a, #0x14            ;9bfb  04 14
    bne lab_9c21            ;9bfd  fc 22        BRANCH_ALWAYS_TAKEN

lab_9bff:
    mov a, #0x01            ;9bff  04 01
    mov mem_02c3, a         ;9c01  61 02 c3
    call sub_8eda           ;9c04  31 8e da
    mov a, #0x05            ;9c07  04 05
    mov a, #0x1d            ;9c09  04 1d
    bne lab_9c21            ;9c0b  fc 14        BRANCH_ALWAYS_TAKEN

lab_9c0d:
    mov a, mem_0312         ;9c0d  60 03 12
    bne lab_9c27            ;9c10  fc 15
    call sub_9ebd           ;9c12  31 9e bd
    mov a, #0x00            ;9c15  04 00
    mov mem_028a, a         ;9c17  61 02 8a
    call sub_9ed1           ;9c1a  31 9e d1
    mov a, #0x06            ;9c1d  04 06
    mov a, #0x1e            ;9c1f  04 1e

lab_9c21:
    mov mem_00cc, a         ;9c21  45 cc
    xch a, t                ;9c23  42
    mov mem_0312, a         ;9c24  61 03 12

lab_9c27:
    ret                     ;9c27  20

lab_9c28:
    mov a, mem_0312         ;9c28  60 03 12
    bne lab_9c27            ;9c2b  fc fa
    mov a, mem_02cc         ;9c2d  60 02 cc
    bne lab_9c37            ;9c30  fc 05
    mov a, #0x01            ;9c32  04 01
    mov mem_02cc, a         ;9c34  61 02 cc

lab_9c37:
    mov a, #0x00            ;9c37  04 00
    mov a, #0x00            ;9c39  04 00
    beq lab_9c21            ;9c3b  fd e4        BRANCH_ALWAYS_TAKEN

lab_9c3d:
    call sub_9c7b           ;9c3d  31 9c 7b
    mov a, #0x02            ;9c40  04 02

lab_9c42:
    pushw a                 ;9c42  40
    call sub_9e74           ;9c43  31 9e 74
    bhs lab_9c54            ;9c46  f8 0c
    mov a, #0x03            ;9c48  04 03
    mov mem_02fd, a         ;9c4a  61 02 fd
    popw a                  ;9c4d  50

lab_9c4e:
    mov mem_0349, a         ;9c4e  61 03 49
    jmp lab_9c55            ;9c51  21 9c 55

lab_9c54:
    popw a                  ;9c54  50

lab_9c55:
    mov mem_00cc, #0x00     ;9c55  85 cc 00
    ret                     ;9c58  20

lab_9c59:
    call sub_9c7b           ;9c59  31 9c 7b
    mov a, #0x03            ;9c5c  04 03
    bne lab_9c42            ;9c5e  fc e2        BRANCH_ALWAYS_TAKEN

lab_9c60:
    mov a, #0x04            ;9c60  04 04
    bne lab_9c42            ;9c62  fc de        BRANCH_ALWAYS_TAKEN

lab_9c64:
    mov a, #0x05            ;9c64  04 05
    bne lab_9c42            ;9c66  fc da        BRANCH_ALWAYS_TAKEN

lab_9c68:
    call sub_9c6f           ;9c68  31 9c 6f
    mov a, #0x06            ;9c6b  04 06
    bne lab_9c42            ;9c6d  fc d3        BRANCH_ALWAYS_TAKEN

sub_9c6f:
    .byte 0x60, 0x00, 0xf6  ;9c6f  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    cmp a, #0x12            ;9c72  14 12
    beq lab_9c90            ;9c74  fd 1a
    cmp a, #0x52            ;9c76  14 52
    bne lab_9c91            ;9c78  fc 17
    ret                     ;9c7a  20

sub_9c7b:
    .byte 0x60, 0x00, 0xf6  ;9c7b  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    cmp a, #0x02            ;9c7e  14 02
    beq lab_9c90            ;9c80  fd 0e
    cmp a, #0x42            ;9c82  14 42
    beq lab_9c90            ;9c84  fd 0a
    and a, #0xf0            ;9c86  64 f0
    cmp a, #0x20            ;9c88  14 20
    beq lab_9c90            ;9c8a  fd 04
    cmp a, #0x60            ;9c8c  14 60
    bne lab_9c91            ;9c8e  fc 01

lab_9c90:
    ret                     ;9c90  20

lab_9c91:
    mov a, #0x00            ;9c91  04 00
    mov mem_0351, a         ;9c93  61 03 51
    mov mem_0352, a         ;9c96  61 03 52
    mov mem_036a, a         ;9c99  61 03 6a
    mov a, mem_00f8         ;9c9c  05 f8
    and a, #0xf7            ;9c9e  64 f7
    mov mem_00f8, a         ;9ca0  45 f8
    ret                     ;9ca2  20

lab_9ca3:
    bbc mem_00f7:1, lab_9cad ;9ca3  b1 f7 07
    bbc pdr3:6, lab_9c55    ;9ca6  b6 0c ac     TAPE_TRACK_SW

lab_9ca9:
    mov a, #0x08            ;9ca9  04 08
    bne lab_9c42            ;9cab  fc 95        BRANCH_ALWAYS_TAKEN

lab_9cad:
    bbs pdr3:6, lab_9c55    ;9cad  be 0c a5     TAPE_TRACK_SW
    jmp lab_9ca9            ;9cb0  21 9c a9

lab_9cb3:
    mov a, #0x09            ;9cb3  04 09
    bne lab_9c4e            ;9cb5  fc 97        BRANCH_ALWAYS_TAKEN

lab_9cb7:
    mov a, mem_034b         ;9cb7  60 03 4b
    cmp a, #0x01            ;9cba  14 01
    beq lab_9ce2            ;9cbc  fd 24
    mov a, mem_0182         ;9cbe  60 01 82
    bne lab_9ce2            ;9cc1  fc 1f
    bbs mem_00f7:7, lab_9ce6 ;9cc3  bf f7 20
    call sub_9df8           ;9cc6  31 9d f8
    mov a, mem_0095         ;9cc9  05 95
    beq lab_9cd1            ;9ccb  fd 04
    cmp a, #0x02            ;9ccd  14 02
    bne lab_9cf1            ;9ccf  fc 20

lab_9cd1:
    .byte 0x60, 0x00, 0xf6  ;9cd1  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    cmp a, #0x22            ;9cd4  14 22
    beq lab_9cdc            ;9cd6  fd 04
    cmp a, #0x62            ;9cd8  14 62
    bne lab_9cf1            ;9cda  fc 15

lab_9cdc:
    mov a, #0x00            ;9cdc  04 00
    mov mem_00ce, a         ;9cde  45 ce
    setb mem_00f7:7         ;9ce0  af f7

lab_9ce2:
    mov mem_00cc, #0x00     ;9ce2  85 cc 00
    ret                     ;9ce5  20

lab_9ce6:
    mov a, mem_0095         ;9ce6  05 95
    mov a, #0x01            ;9ce8  04 01
    cmp a                   ;9cea  12
    bne lab_9ce2            ;9ceb  fc f5
    mov mem_00cc, #0x09     ;9ced  85 cc 09
    ret                     ;9cf0  20

lab_9cf1:
    clrb mem_00d7:7         ;9cf1  a7 d7
    mov a, mem_00cc         ;9cf3  05 cc
    bne lab_9d00            ;9cf5  fc 09

sub_9cf7:
    mov a, #0x00            ;9cf7  04 00
    mov mem_0321, a         ;9cf9  61 03 21
    mov mem_0322, a         ;9cfc  61 03 22
    ret                     ;9cff  20

lab_9d00:
    mov a, #0x1a            ;9d00  04 1a

lab_9d02:
    mov mem_00cc, a         ;9d02  45 cc

lab_9d04:
    ret                     ;9d04  20

lab_9d05:
    mov a, mem_00d2         ;9d05  05 d2
    bne lab_9d04            ;9d07  fc fb
    bbc mem_00cf:0, lab_9d31 ;9d09  b0 cf 25
    bbs mem_00e4:3, lab_9d1e ;9d0c  bb e4 0f
    bbs mem_00e3:7, lab_9d2e ;9d0f  bf e3 1c
    mov a, mem_00de         ;9d12  05 de
    and a, #0xe0            ;9d14  64 e0
    cmp a, #0xc0            ;9d16  14 c0
    beq lab_9d1e            ;9d18  fd 04
    cmp a, #0x80            ;9d1a  14 80
    beq lab_9d2e            ;9d1c  fd 10

lab_9d1e:
    clrb mem_00cf:0         ;9d1e  a0 cf
    setb mem_00d0:1         ;9d20  a9 d0
    bbc mem_00eb:6, lab_9d27 ;9d22  b6 eb 02
    setb mem_00d0:4         ;9d25  ac d0

lab_9d27:
    call sub_9d61           ;9d27  31 9d 61
    mov a, #0x1b            ;9d2a  04 1b
    bne lab_9d02            ;9d2c  fc d4        BRANCH_ALWAYS_TAKEN

lab_9d2e:
    jmp lab_9b3d            ;9d2e  21 9b 3d

lab_9d31:
    mov a, mem_00de         ;9d31  05 de
    and a, #0xe0            ;9d33  64 e0
    cmp a, #0xc0            ;9d35  14 c0
    bne lab_9d2e            ;9d37  fc f5
    beq lab_9d27            ;9d39  fd ec        BRANCH_ALWAYS_TAKEN

lab_9d3b:
    mov a, mem_0312         ;9d3b  60 03 12
    bne lab_9d04            ;9d3e  fc c4
    call sub_9da9           ;9d40  31 9d a9
    mov a, #0x1c            ;9d43  04 1c
    bne lab_9d02            ;9d45  fc bb        BRANCH_ALWAYS_TAKEN

lab_9d47:
    mov a, mem_0312         ;9d47  60 03 12
    bne lab_9d04            ;9d4a  fc b8
    mov a, mem_0369         ;9d4c  60 03 69
    cmp a, #0x05            ;9d4f  14 05
    beq lab_9d5b            ;9d51  fd 08
    cmp a, #0x04            ;9d53  14 04
    beq lab_9d5b            ;9d55  fd 04
    cmp a, #0x06            ;9d57  14 06
    bne lab_9d5d            ;9d59  fc 02

lab_9d5b:
    setb mem_00d7:1         ;9d5b  a9 d7

lab_9d5d:
    call sub_9dc4           ;9d5d  31 9d c4
    ret                     ;9d60  20

sub_9d61:
    mov a, #0x06            ;9d61  04 06
    mov mem_0312, a         ;9d63  61 03 12
    mov a, #0x01            ;9d66  04 01
    mov mem_02c3, a         ;9d68  61 02 c3
    call sub_8eda           ;9d6b  31 8e da
    bbs mem_00cf:0, lab_9d89 ;9d6e  b8 cf 18
    mov a, mem_02c2         ;9d71  60 02 c2
    mov a, #0x01            ;9d74  04 01
    cmp a                   ;9d76  12
    bne lab_9d89            ;9d77  fc 10
    mov a, mem_02c2         ;9d79  60 02 c2
    mov mem_0095, a         ;9d7c  45 95
    mov a, mem_02c4         ;9d7e  60 02 c4
    mov mem_02c2, a         ;9d81  61 02 c2
    mov a, #0x00            ;9d84  04 00
    mov mem_02c4, a         ;9d86  61 02 c4

lab_9d89:
    bbc mem_00d0:4, lab_9d91 ;9d89  b4 d0 05
    clrb mem_00d0:4         ;9d8c  a4 d0
    jmp lab_9d94            ;9d8e  21 9d 94

lab_9d91:
    bbs mem_00eb:6, lab_9da6 ;9d91  be eb 12

lab_9d94:
    bbs mem_00cf:0, lab_9da6 ;9d94  b8 cf 0f
    setb mem_00ed:2         ;9d97  aa ed
    bbs mem_00d0:1, lab_9da4 ;9d99  b9 d0 08
    setb mem_00d7:5         ;9d9c  ad d7
    mov mem_00d2, #0x01     ;9d9e  85 d2 01
    setb pdr2:7             ;9da1  af 04        MAIN_5V=high
    ret                     ;9da3  20

lab_9da4:
    setb mem_00cf:0         ;9da4  a8 cf

lab_9da6:
    clrb mem_00d0:1         ;9da6  a1 d0
    ret                     ;9da8  20

sub_9da9:
    call sub_9ebd           ;9da9  31 9e bd
    mov a, #0x00            ;9dac  04 00
    mov mem_028a, a         ;9dae  61 02 8a
    call sub_9ece           ;9db1  31 9e ce
    bbc mem_00f7:3, lab_9dbc ;9db4  b3 f7 05
    clrb pdr3:5             ;9db7  a5 0c        /TAPE_DOLBY_ON=low
    jmp lab_9dbe            ;9db9  21 9d be

lab_9dbc:
    setb pdr3:5             ;9dbc  ad 0c        /TAPE_DOLBY_ON=high

lab_9dbe:
    mov a, #0x06            ;9dbe  04 06
    mov mem_0312, a         ;9dc0  61 03 12
    ret                     ;9dc3  20

sub_9dc4:
    mov a, mem_0369         ;9dc4  60 03 69
    cmp a, #0x03            ;9dc7  14 03
    beq lab_9df4            ;9dc9  fd 29
    cmp a, #0x01            ;9dcb  14 01
    beq lab_9df4            ;9dcd  fd 25
    bbs mem_00d7:0, lab_9de2 ;9dcf  b8 d7 10
    bbs mem_00f7:7, lab_9dec ;9dd2  bf f7 17
    .byte 0x60, 0x00, 0xf6  ;9dd5  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    and a, #0xf0            ;9dd8  64 f0
    cmp a, #0x20            ;9dda  14 20
    beq lab_9dec            ;9ddc  fd 0e
    cmp a, #0x60            ;9dde  14 60
    beq lab_9dec            ;9de0  fd 0a

lab_9de2:
    bbs mem_00d7:1, lab_9dec ;9de2  b9 d7 07
    mov a, #0x01            ;9de5  04 01
    mov mem_0349, a         ;9de7  61 03 49
    clrb mem_00d7:6         ;9dea  a6 d7

lab_9dec:
    clrb mem_00d7:1         ;9dec  a1 d7
    clrb mem_00d7:0         ;9dee  a0 d7
    mov mem_00cc, #0x00     ;9df0  85 cc 00
    ret                     ;9df3  20

lab_9df4:
    mov mem_00cc, #0x04     ;9df4  85 cc 04
    ret                     ;9df7  20

sub_9df8:
    clrb mem_00af:4         ;9df8  a4 af
    call sub_8e91           ;9dfa  31 8e 91
    bbc mem_00f7:7, lab_9e13 ;9dfd  b7 f7 13
    mov a, mem_02b7         ;9e00  60 02 b7
    cmp a, #0x5a            ;9e03  14 5a
    bne lab_9e0a            ;9e05  fc 03
    call sub_9b02           ;9e07  31 9b 02

lab_9e0a:
    cmp mem_0095, #0x01     ;9e0a  95 95 01
    beq lab_9e13            ;9e0d  fd 04
    mov mem_00cc, #0x00     ;9e0f  85 cc 00
    ret                     ;9e12  20

lab_9e13:
    clrb mem_00e9:1         ;9e13  a1 e9
    mov mem_00ce, #0x04     ;9e15  85 ce 04
    mov a, #0x03            ;9e18  04 03
    mov mem_00cc, a         ;9e1a  45 cc
    ret                     ;9e1c  20

sub_9e1d:
    .byte 0x60, 0x00, 0xf6  ;9e1d  60 00 f6     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00f6
    cmp a, #0x02            ;9e20  14 02
    beq lab_9e30            ;9e22  fd 0c
    cmp a, #0x03            ;9e24  14 03
    beq lab_9e30            ;9e26  fd 08
    cmp a, #0x42            ;9e28  14 42
    beq lab_9e30            ;9e2a  fd 04
    cmp a, #0x43            ;9e2c  14 43
    bne lab_9e32            ;9e2e  fc 02

lab_9e30:
    setc                    ;9e30  91
    ret                     ;9e31  20

lab_9e32:
    clrc                    ;9e32  81
    ret                     ;9e33  20

sub_9e34:
    mov a, #0x00            ;9e34  04 00
    mov mem_0308, a         ;9e36  61 03 08
    clrb mem_00f7:5         ;9e39  a5 f7
    mov mem_0309, a         ;9e3b  61 03 09
    clrb mem_00d7:2         ;9e3e  a2 d7
    ret                     ;9e40  20

sub_9e41:
    mov a, mem_0308         ;9e41  60 03 08
    bne lab_9e4c            ;9e44  fc 06
    mov a, mem_033a         ;9e46  60 03 3a
    bne lab_9e5e            ;9e49  fc 13
    ret                     ;9e4b  20

lab_9e4c:
    mov a, mem_0309         ;9e4c  60 03 09
    mov a, #0x02            ;9e4f  04 02
    cmp a                   ;9e51  12
    beq lab_9e59            ;9e52  fd 05
    setb mem_00d7:2         ;9e54  aa d7
    mov mem_00cc, #0x15     ;9e56  85 cc 15

lab_9e59:
    mov a, #0x02            ;9e59  04 02
    mov mem_0309, a         ;9e5b  61 03 09

lab_9e5e:
    mov a, #0x00            ;9e5e  04 00
    mov mem_0308, a         ;9e60  61 03 08
    movw ix, #mem_02b6      ;9e63  e6 02 b6
    mov @ix+0x01, #0x5b     ;9e66  86 01 5b     0x5b 'TAPE.ERROR.'
    mov a, #0b00100000      ;9e69  04 20        Pictographs = Bit 5 only (HIDDEN_MODE_TAPE)
    mov @ix+0x00, a         ;9e6b  46 00
    ret                     ;9e6d  20

sub_9e6e:
    mov a, mem_0369         ;9e6e  60 03 69
    jmp lab_9e7f            ;9e71  21 9e 7f

sub_9e74:
    mov a, mem_0369         ;9e74  60 03 69

    cmp a, #0x03            ;9e77  14 03
    beq lab_9ea1            ;9e79  fd 26

    cmp a, #0x01            ;9e7b  14 01
    beq lab_9ea1            ;9e7d  fd 22

lab_9e7f:
    cmp a, #0x05            ;9e7f  14 05
    beq lab_9ea1            ;9e81  fd 1e

    cmp a, #0x24            ;9e83  14 24
    beq lab_9ea1            ;9e85  fd 1a

    cmp a, #0x25            ;9e87  14 25
    beq lab_9ea1            ;9e89  fd 16

    cmp a, #0x29            ;9e8b  14 29
    beq lab_9ea1            ;9e8d  fd 12

    cmp a, #0x30            ;9e8f  14 30
    beq lab_9ea1            ;9e91  fd 0e

    cmp a, #0x28            ;9e93  14 28
    beq lab_9ea1            ;9e95  fd 0a

    cmp a, #0x09            ;9e97  14 09
    beq lab_9ea1            ;9e99  fd 06

    cmp a, #0x71            ;9e9b  14 71
    beq lab_9ea1            ;9e9d  fd 02

lab_9e9f:
    clrc                    ;9e9f  81
    ret                     ;9ea0  20

lab_9ea1:
    setc                    ;9ea1  91
    ret                     ;9ea2  20

sub_9ea3:
    mov a, mem_0369         ;9ea3  60 03 69
    cmp a, #0x03            ;9ea6  14 03
    beq lab_9ea1            ;9ea8  fd f7
    cmp a, #0x01            ;9eaa  14 01
    beq lab_9ea1            ;9eac  fd f3
    bne lab_9e9f            ;9eae  fc ef        BRANCH_ALWAYS_TAKEN

sub_9eb0:
    mov a, mem_0095         ;9eb0  05 95
    beq lab_9eb9            ;9eb2  fd 05
    cmp a, #0x02            ;9eb4  14 02
    beq lab_9eb9            ;9eb6  fd 01
    ret                     ;9eb8  20

lab_9eb9:
    call sub_9e41           ;9eb9  31 9e 41
    ret                     ;9ebc  20

sub_9ebd:
    movw a, #0x0400         ;9ebd  e4 04 00
    movw mem_0294, a        ;9ec0  d4 02 94

sub_9ec3:
    mov a, mem_029a         ;9ec3  60 02 9a
    mov mem_00b3, a         ;9ec6  45 b3
    mov a, mem_029b         ;9ec8  60 02 9b
    mov mem_00b4, a         ;9ecb  45 b4
    ret                     ;9ecd  20

sub_9ece:
    call sub_968c           ;9ece  31 96 8c

sub_9ed1:
    setb mem_00b2:6         ;9ed1  ae b2

sub_9ed3:
    setb mem_00b2:5         ;9ed3  ad b2
    setb mem_0098:6         ;9ed5  ae 98
    ret                     ;9ed7  20

sub_9ed8:
    mov a, mem_00ce         ;9ed8  05 ce        A = table index
    movw a, #mem_9ee0       ;9eda  e4 9e e0     A = table base address
    jmp sub_e73c            ;9edd  21 e7 3c     Jump to address in table

mem_9ee0:
    .word lab_9f06          ;9ee0  9f 06       VECTOR
    .word lab_9ef6          ;9ee2  9e f6       VECTOR
    .word lab_9f07          ;9ee4  9f 07       VECTOR
    .word lab_9f12          ;9ee6  9f 12       VECTOR
    .word lab_9f35          ;9ee8  9f 35       VECTOR
    .word lab_9f3f          ;9eea  9f 3f       VECTOR
    .word lab_9f56          ;9eec  9f 56       VECTOR
    .word lab_9f98          ;9eee  9f 98       VECTOR
    .word lab_9fa8          ;9ef0  9f a8       VECTOR
    .word lab_9fc3          ;9ef2  9f c3       VECTOR
    .word lab_9fd0          ;9ef4  9f d0       VECTOR

lab_9ef6:
    call sub_9e1d           ;9ef6  31 9e 1d
    blo lab_9f03            ;9ef9  f9 08
    cmp mem_0095, #0x01     ;9efb  95 95 01
    bne lab_9f03            ;9efe  fc 03
    mov mem_00cc, #0x0a     ;9f00  85 cc 0a

lab_9f03:
    mov mem_00ce, #0x06     ;9f03  85 ce 06

lab_9f06:
    ret                     ;9f06  20

lab_9f07:
    mov a, mem_0312         ;9f07  60 03 12
    bne lab_9f06            ;9f0a  fc fa
    setb mem_00ca:6         ;9f0c  ae ca
    mov mem_00ce, #0x03     ;9f0e  85 ce 03
    ret                     ;9f11  20

lab_9f12:
    bbc mem_00df:2, lab_9f06 ;9f12  b2 df f1
    call sub_8f06           ;9f15  31 8f 06
    mov a, mem_0095         ;9f18  05 95
    cmp a, #0x01            ;9f1a  14 01
    bne lab_9f2f            ;9f1c  fc 11
    call sub_9e1d           ;9f1e  31 9e 1d
    blo lab_9f29            ;9f21  f9 06
    mov mem_00cc, #0x06     ;9f23  85 cc 06
    jmp lab_9f42            ;9f26  21 9f 42

lab_9f29:
    mov mem_00cc, #0x18     ;9f29  85 cc 18
    jmp lab_9f42            ;9f2c  21 9f 42

lab_9f2f:
    mov mem_00c2, #0x01     ;9f2f  85 c2 01
    jmp lab_9f42            ;9f32  21 9f 42

lab_9f35:
    setb mem_00df:1         ;9f35  a9 df
    clrb mem_00df:3         ;9f37  a3 df
    clrb mem_00df:4         ;9f39  a4 df
    mov mem_00ce, #0x05     ;9f3b  85 ce 05
    ret                     ;9f3e  20

lab_9f3f:
    bbc mem_00df:2, lab_9f06 ;9f3f  b2 df c4

lab_9f42:
    clrb mem_00df:2         ;9f42  a2 df
    mov a, mem_00df         ;9f44  05 df
    and a, #0x80            ;9f46  64 80
    mov mem_00df, a         ;9f48  45 df
    mov a, mem_00e0         ;9f4a  05 e0
    and a, #0x42            ;9f4c  64 42
    mov mem_00e0, a         ;9f4e  45 e0
    setb mem_00ca:6         ;9f50  ae ca
    mov mem_00ce, #0x00     ;9f52  85 ce 00
    ret                     ;9f55  20

lab_9f56:
    cmp mem_00cc, #0x00     ;9f56  95 cc 00
    bne lab_9f06            ;9f59  fc ab
    clrb mem_00ca:6         ;9f5b  a6 ca
    mov a, #0x00            ;9f5d  04 00
    mov mem_028a, a         ;9f5f  61 02 8a
    mov a, #0x02            ;9f62  04 02
    mov mem_02c3, a         ;9f64  61 02 c3
    call sub_8eda           ;9f67  31 8e da
    call sub_9e34           ;9f6a  31 9e 34
    mov a, #0x07            ;9f6d  04 07
    mov mem_01c6, a         ;9f6f  61 01 c6
    mov a, #0x16            ;9f72  04 16
    mov mem_0331, a         ;9f74  61 03 31
    clrb mem_00df:2         ;9f77  a2 df
    clrb mem_00df:1         ;9f79  a1 df
    movw a, #0x0000         ;9f7b  e4 00 00
    movw mem_0294, a        ;9f7e  d4 02 94
    mov a, mem_029c         ;9f81  60 02 9c
    mov mem_00b3, a         ;9f84  45 b3
    mov a, mem_029d         ;9f86  60 02 9d
    mov mem_00b4, a         ;9f89  45 b4
    setb mem_0098:4         ;9f8b  ac 98
    mov a, #0x07            ;9f8d  04 07
    mov a, #0x08            ;9f8f  04 08

lab_9f91:
    mov mem_0312, a         ;9f91  61 03 12
    xch a, t                ;9f94  42

lab_9f95:
    mov mem_00ce, a         ;9f95  45 ce

lab_9f97:
    ret                     ;9f97  20

lab_9f98:
    mov a, mem_0312         ;9f98  60 03 12
    bne lab_9f97            ;9f9b  fc fa
    call sub_9ece           ;9f9d  31 9e ce
    setb mem_00b2:7         ;9fa0  af b2
    mov a, #0x08            ;9fa2  04 08
    mov a, #0x05            ;9fa4  04 05
    bne lab_9f91            ;9fa6  fc e9        BRANCH_ALWAYS_TAKEN

lab_9fa8:
    mov a, mem_0312         ;9fa8  60 03 12
    bne lab_9f97            ;9fab  fc ea
    mov a, #0x00            ;9fad  04 00
    mov mem_01c7, a         ;9faf  61 01 c7
    mov mem_01ce, a         ;9fb2  61 01 ce
    clrb mem_00df:1         ;9fb5  a1 df
    clrb mem_00df:2         ;9fb7  a2 df
    setb mem_00df:1         ;9fb9  a9 df
    clrb mem_00df:3         ;9fbb  a3 df
    clrb mem_00df:4         ;9fbd  a4 df
    mov a, #0x09            ;9fbf  04 09
    bne lab_9f95            ;9fc1  fc d2        BRANCH_ALWAYS_TAKEN

lab_9fc3:
    bbc mem_00df:2, lab_9f97 ;9fc3  b2 df d1
    clrb mem_00df:1         ;9fc6  a1 df
    clrb mem_00df:2         ;9fc8  a2 df
    mov a, #0x0a            ;9fca  04 0a
    mov a, #0x14            ;9fcc  04 14
    bne lab_9f91            ;9fce  fc c1        BRANCH_ALWAYS_TAKEN

lab_9fd0:
    mov a, mem_0312         ;9fd0  60 03 12
    bne lab_9f97            ;9fd3  fc c2
    setb mem_00df:0         ;9fd5  a8 df
    mov a, #0x02            ;9fd7  04 02
    mov a, #0x14            ;9fd9  04 14
    bne lab_9f91            ;9fdb  fc b4        BRANCH_ALWAYS_TAKEN

sub_9fdd:
    mov a, mem_00fd         ;9fdd  05 fd
    and a, #0x0f            ;9fdf  64 0f
    cmp a, #0x02            ;9fe1  14 02
    bne lab_a00b            ;9fe3  fc 26
    mov a, mem_0096         ;9fe5  05 96
    mov a, #0x03            ;9fe7  04 03
    cmp a                   ;9fe9  12
    bne lab_9ff8            ;9fea  fc 0c
    mov a, mem_00cd         ;9fec  05 cd
    cmp a, #0x07            ;9fee  14 07
    beq lab_a00b            ;9ff0  fd 19
    cmp a, #0x04            ;9ff2  14 04
    beq lab_a00b            ;9ff4  fd 15
    bne lab_a003            ;9ff6  fc 0b        BRANCH_ALWAYS_TAKEN

lab_9ff8:
    mov a, mem_0096         ;9ff8  05 96
    mov a, #0x04            ;9ffa  04 04
    cmp a                   ;9ffc  12
    bne lab_a00b            ;9ffd  fc 0c
    mov a, #0x03            ;9fff  04 03
    mov mem_0096, a         ;a001  45 96

lab_a003:
    mov a, #0x03            ;a003  04 03
    mov mem_0096, a         ;a005  45 96
    mov a, #0x07            ;a007  04 07
    mov mem_00cd, a         ;a009  45 cd

lab_a00b:
    movw a, #0x0000         ;a00b  e4 00 00
    movw a, #0x0000         ;a00e  e4 00 00
    mov a, mem_0096         ;a011  05 96
    beq lab_a06d            ;a013  fd 58
    movw ix, #mem_a04d      ;a015  e6 a0 4d
    mov a, #0x0a            ;a018  04 0a
    and a                   ;a01a  62
    cmp a, #0x0a            ;a01b  14 0a
    xchw a, t               ;a01d  43
    beq lab_a046            ;a01e  fd 26
    cmp a, #0x07            ;a020  14 07
    beq lab_a046            ;a022  fd 22
    cmp a, #0x08            ;a024  14 08
    beq lab_a046            ;a026  fd 1e
    clrc                    ;a028  81
    rolc a                  ;a029  02
    movw a, #mem_a04d       ;a02a  e4 a0 4d
    addcw a                 ;a02d  23
    movw ix, a              ;a02e  e2
    movw a, #0x0000         ;a02f  e4 00 00
    mov a, mem_00cd         ;a032  05 cd
    clrc                    ;a034  81
    rolc a                  ;a035  02
    movw a, @ix+0x00        ;a036  c6 00

lab_a038:
    addcw a                 ;a038  23
    movw a, @a              ;a039  93
    clrc                    ;a03a  81
    mov a, mem_00f1         ;a03b  05 f1
    bne lab_a040            ;a03d  fc 01
    setc                    ;a03f  91

lab_a040:
    xchw a, t               ;a040  43
    mov a, mem_0202         ;a041  60 02 02
    xchw a, t               ;a044  43
    jmp @a                  ;a045  e0

lab_a046:
    clrc                    ;a046  81
    rolc a                  ;a047  02
    movw a, #mem_a04d       ;a048  e4 a0 4d
    bne lab_a038            ;a04b  fc eb        BRANCH_ALWAYS_TAKEN

mem_a04d:
    .word lab_a06d          ;a04d VECTOR
    .word lab_a072          ;a04e VECTOR

;TODO appears to be jump table of jump tables
    .word lab_a12b          ;VECTOR     jump table
    .word lab_a1c7          ;VECTOR     jump table
    .word lab_a2bb          ;VECTOR     jump table
    .word lab_a303          ;VECTOR     jump table
    .word lab_a3a7          ;VECTOR     jump table

    .word lab_a06d          ;VECTOR
    .word lab_a06d          ;VECTOR
    .word lab_a3e9          ;VECTOR     jump table

    .word lab_a067          ;VECTOR
    .word lab_a06e          ;VECTOR
    .word lab_a3c4          ;VECTOR     jump table

lab_a067:
    bbs mem_008c:7, lab_a06d ;a067  bf 8c 03
    call sub_f488           ;a06a  31 f4 88

lab_a06d:
    ret                     ;a06d  20

lab_a06e:
    call sub_fcea           ;a06e  31 fc ea
    ret                     ;a071  20

lab_a072:
    .word lab_a09c          ;a072  a0 9c       VECTOR
    .word lab_a07e          ;a074  a0 7e       VECTOR
    .word lab_a08d          ;a076  a0 8d       VECTOR
    .word lab_a09d          ;a078  a0 9d       VECTOR
    .word lab_a0db          ;a07a  a0 db       VECTOR
    .word lab_a10b          ;a07c  a1 0b       VECTOR

lab_a07e:
    mov a, #0x00            ;a07e  04 00
    mov mem_0339, a         ;a080  61 03 39

lab_a083:
    mov a, #0x59            ;a083  04 59
    mov mem_0275, a         ;a085  61 02 75
    movw a, #0xab02         ;a088  e4 ab 02
    bne lab_a097            ;a08b  fc 0a        BRANCH_ALWAYS_TAKEN

lab_a08d:
    bhs lab_a09c            ;a08d  f8 0d
    mov a, #0x00            ;a08f  04 00
    mov mem_0275, a         ;a091  61 02 75
    movw a, #0xac03         ;a094  e4 ac 03

lab_a097:
    mov mem_00cd, a         ;a097  45 cd
    swap                    ;a099  10
    mov mem_00f1, a         ;a09a  45 f1

lab_a09c:
    ret                     ;a09c  20

lab_a09d:
    bhs lab_a09c            ;a09d  f8 fd
    mov a, mem_0275         ;a09f  60 02 75
    mov a, #0x59            ;a0a2  04 59
    cmp a                   ;a0a4  12
    call sub_a0ca           ;a0a5  31 a0 ca
    bne lab_a083            ;a0a8  fc d9
    cmp a, #0x01            ;a0aa  14 01
    bne lab_a0c3            ;a0ac  fc 15
    setb mem_00e3:6         ;a0ae  ae e3
    mov a, #0x00            ;a0b0  04 00
    mov mem_0339, a         ;a0b2  61 03 39

lab_a0b5:
    movw a, #0x0000         ;a0b5  e4 00 00
    movw mem_0275, a        ;a0b8  d4 02 75
    movw mem_0277, a        ;a0bb  d4 02 77
    movw a, #0x8204         ;a0be  e4 82 04
    bne lab_a097            ;a0c1  fc d4        BRANCH_ALWAYS_TAKEN

lab_a0c3:
    setb mem_00e3:7         ;a0c3  af e3
    clrb mem_00e3:6         ;a0c5  a6 e3
    jmp lab_a104            ;a0c7  21 a1 04

sub_a0ca:
    bne lab_a0d0            ;a0ca  fc 04
    mov a, #0x01            ;a0cc  04 01
    bne lab_a0d2            ;a0ce  fc 02        BRANCH_ALWAYS_TAKEN

lab_a0d0:
    mov a, #0x02            ;a0d0  04 02

lab_a0d2:
    mov a, mem_0339         ;a0d2  60 03 39
    xor a                   ;a0d5  52
    xch a, t                ;a0d6  42
    mov mem_0339, a         ;a0d7  61 03 39
    ret                     ;a0da  20

lab_a0db:
    bhs lab_a09c            ;a0db  f8 bf
    movw a, mem_0275        ;a0dd  c4 02 75
    movw a, #0x5a5a         ;a0e0  e4 5a 5a
    cmpw a                  ;a0e3  13
    bne lab_a0ea            ;a0e4  fc 04
    movw a, mem_0277        ;a0e6  c4 02 77
    cmpw a                  ;a0e9  13

lab_a0ea:
    call sub_a0ca           ;a0ea  31 a0 ca
    bne lab_a0b5            ;a0ed  fc c6
    cmp a, #0x01            ;a0ef  14 01
    bne lab_a0f8            ;a0f1  fc 05
    movw a, #0x9405         ;a0f3  e4 94 05
    bne lab_a097            ;a0f6  fc 9f        BRANCH_ALWAYS_TAKEN

lab_a0f8:
    setb mem_00e3:7         ;a0f8  af e3

lab_a0fa:
    mov a, mem_0298         ;a0fa  60 02 98
    mov mem_00b3, a         ;a0fd  45 b3
    mov a, mem_0299         ;a0ff  60 02 99
    mov mem_00b4, a         ;a102  45 b4

lab_a104:
    mov a, #0x00            ;a104  04 00
    mov mem_0096, a         ;a106  45 96
    mov mem_00cd, a         ;a108  45 cd
    ret                     ;a10a  20

lab_a10b:
    bhs lab_a09c            ;a10b  f8 8f
    call sub_b974           ;a10d  31 b9 74

    movw a, mem_03b0        ;a110  c4 03 b0
    movw mem_03ab, a        ;a113  d4 03 ab

    movw a, mem_03b2        ;a116  c4 03 b2
    movw mem_03ad, a        ;a119  d4 03 ad

    call sub_e61f           ;a11c  31 e6 1f     Unknown, uses mem_e5aa table

    movw a, mem_03a1        ;a11f  c4 03 a1
    movw mem_039f, a        ;a122  d4 03 9f
    call sub_dd72           ;a125  31 dd 72
    jmp lab_a0fa            ;a128  21 a0 fa

lab_a12b:
    .word lab_a14f          ;a12b  a1 4f       VECTOR
    .word lab_a135          ;a12d  a1 35       VECTOR
    .word lab_a150          ;a12f  a1 50       VECTOR
    .word lab_a161          ;a131  a1 61       VECTOR
    .word lab_a183          ;a133  a1 83       VECTOR

lab_a135:
    mov a, #0x02            ;a135  04 02        A = mem_0201 value for CODE
    mov mem_0201, a         ;a137  61 02 01
    mov a, #0x1e            ;a13a  04 1e
    mov mem_0202, a         ;a13c  61 02 02
    mov a, #0xff            ;a13f  04 ff
    mov mem_0205, a         ;a141  61 02 05

    mov a, #0x00            ;a144  04 00        A = 0 attempts
    mov mem_020e, a         ;a146  61 02 0e     Store SAFE attempts

    mov a, #0x02            ;a149  04 02

lab_a14b:
    setb mem_0098:4         ;a14b  ac 98

lab_a14d:
    mov mem_00cd, a         ;a14d  45 cd

lab_a14f:
    ret                     ;a14f  20

lab_a150:
    bne lab_a14f            ;a150  fc fd

    movw a, #0x1000         ;a152  e4 10 00     A = 1000 for SAFE code (16-bit BCD)
    movw mem_0203, a        ;a155  d4 02 03     Store entered SAFE code

    mov a, #0x07            ;a158  04 07        A = mem_0201 value for BLANK
    mov mem_0201, a         ;a15a  61 02 01
    mov a, #0x03            ;a15d  04 03
    bne lab_a14b            ;a15f  fc ea        BRANCH_ALWAYS_TAKEN

lab_a161:
    mov a, mem_0205         ;a161  60 02 05
    cmp a, #0x12            ;a164  14 12
    beq lab_a174            ;a166  fd 0c
    call sub_a18c           ;a168  31 a1 8c
    mov a, #0xff            ;a16b  04 ff
    mov mem_0205, a         ;a16d  61 02 05
    mov a, #0x03            ;a170  04 03
    bne lab_a14d            ;a172  fc d9        BRANCH_ALWAYS_TAKEN

lab_a174:
    movw a, mem_0203        ;a174  c4 02 03     A = entered SAFE code (16-bit BCD)
    movw mem_020f, a        ;a177  d4 02 0f     Store as actual SAFE code

    setb mem_00de:7         ;a17a  af de
    mov mem_00f1, #0x9e     ;a17c  85 f1 9e
    mov a, #0x04            ;a17f  04 04
    bne lab_a14b            ;a181  fc c8        BRANCH_ALWAYS_TAKEN

lab_a183:
    bhs lab_a14f            ;a183  f8 ca
    mov mem_0096, #0x03     ;a185  85 96 03
    mov mem_00cd, #0x01     ;a188  85 cd 01
    ret                     ;a18b  20

sub_a18c:
    movw ix, #mem_0203      ;a18c  e6 02 03     IX = pointer to entered SAFE code (16-bit BCD)
    mov a, mem_0205         ;a18f  60 02 05
    cmp a, #0x06            ;a192  14 06
    beq lab_a1ad            ;a194  fd 17
    cmp a, #0x05            ;a196  14 05
    beq lab_a1a4            ;a198  fd 0a
    incw ix                 ;a19a  c2
    cmp a, #0x04            ;a19b  14 04
    beq lab_a1ad            ;a19d  fd 0e
    cmp a, #0x02            ;a19f  14 02
    beq lab_a1a4            ;a1a1  fd 01
    ret                     ;a1a3  20

lab_a1a4:
    movw ep, #0xf00f        ;a1a4  e7 f0 0f
    mov r0, #0x0a           ;a1a7  88 0a
    mov a, #0x01            ;a1a9  04 01
    bne lab_a1b4            ;a1ab  fc 07        BRANCH_ALWAYS_TAKEN

lab_a1ad:
    movw ep, #0x0ff0      ;a1ad  e7 0f f0
    mov r0, #0xa0           ;a1b0  88 a0
    mov a, #0x10            ;a1b2  04 10

lab_a1b4:
    mov a, @ix+0x00         ;a1b4  06 00
    clrc                    ;a1b6  81
    addc a                  ;a1b7  22
    mov @ix+0x00, a         ;a1b8  46 00
    xchw a, t               ;a1ba  43
    movw a, ep              ;a1bb  f3
    and a                   ;a1bc  62
    cmp a, r0               ;a1bd  18
    bne lab_a1c4            ;a1be  fc 04
    swap                    ;a1c0  10
    and a                   ;a1c1  62
    mov @ix+0x00, a         ;a1c2  46 00

lab_a1c4:
    setb mem_0098:4         ;a1c4  ac 98
    ret                     ;a1c6  20

lab_a1c7:
    .word lab_a1e7          ;a1c7  a1 e7       VECTOR
    .word lab_a1d7          ;a1c9  a1 d7       VECTOR
    .word lab_a1e8          ;a1cb  a1 e8       VECTOR
    .word lab_a1ff          ;a1cd  a1 ff       VECTOR
    .word lab_a254          ;a1cf  a2 54       VECTOR
    .word lab_a286          ;a1d1  a2 86       VECTOR
    .word lab_a29e          ;a1d3  a2 9e       VECTOR
    .word sub_a239          ;a1d5  a2 39       VECTOR

lab_a1d7:
    mov a, #0x05            ;a1d7  04 05        A = mem_0201 value for SAFE
    mov mem_0201, a         ;a1d9  61 02 01
    mov a, #0x1e            ;a1dc  04 1e
    mov mem_0202, a         ;a1de  61 02 02
    mov a, #0x02            ;a1e1  04 02        A = value to store in mem_00cd

lab_a1e3:
    setb mem_0098:4         ;a1e3  ac 98

lab_a1e5:
    mov mem_00cd, a         ;a1e5  45 cd

lab_a1e7:
    ret                     ;a1e7  20

lab_a1e8:
    bne lab_a1e7            ;a1e8  fc fd
    mov a, mem_00fd         ;a1ea  05 fd
    and a, #0xf0            ;a1ec  64 f0
    bne lab_a1e7            ;a1ee  fc f7

    movw a, #0x1000         ;a1f0  e4 10 00     A = 1000 for SAFE code (16-bit BCD)
    movw mem_0203, a        ;a1f3  d4 02 03     Store as entered SAFE code

    mov a, #0x07            ;a1f6  04 07        A = mem_0201 value for BLANK
    mov mem_0201, a         ;a1f8  61 02 01

    mov a, #0x03            ;a1fb  04 03        A = value to store in mem_00cd
    bne lab_a1e3            ;a1fd  fc e4        BRANCH_ALWAYS_TAKEN

lab_a1ff:
    mov a, mem_0205         ;a1ff  60 02 05
    cmp a, #0x19            ;a202  14 19
    beq lab_a212            ;a204  fd 0c
    call sub_a18c           ;a206  31 a1 8c
    mov a, #0xff            ;a209  04 ff
    mov mem_0205, a         ;a20b  61 02 05
    mov a, #0x03            ;a20e  04 03        A = value ot store in mem_00cd
    bne lab_a1e5            ;a210  fc d3        BRANCH_ALWAYS_TAKEN

lab_a212:
    mov a, #0xff            ;a212  04 ff
    mov mem_0205, a         ;a214  61 02 05
    mov a, #0x01            ;a217  04 01
    mov mem_02cc, a         ;a219  61 02 cc

    mov a, mem_020e         ;a21c  60 02 0e     A = SAFE attempts
    incw a                  ;a21f  c0           Increment attempts
    mov mem_020e, a         ;a220  61 02 0e     Store incremented attempts

    mov a, mem_020e         ;a223  60 02 0e     A = SAFE attempts
    mov a, #0x02            ;a226  04 02        A = 2 maximum attempts
    cmp a                   ;a228  12           Compare attempts with max
    blo lab_a22d            ;a229  f9 02        Branch if fewer attempts than max

    setb mem_00de:5         ;a22b  ad de

lab_a22d:
    mov mem_00f1, #0xa6     ;a22d  85 f1 a6
    movw a, mem_020f        ;a230  c4 02 0f     A = actual SAFE code
    movw a, mem_0203        ;a233  c4 02 03     A = entered SAFE code (16-bit BCD)
    cmpw a                  ;a236  13
    bne lab_a250            ;a237  fc 17

sub_a239:
    mov a, #0x0a            ;a239  04 0a
    mov mem_02c1, a         ;a23b  61 02 c1

    mov a, #0x00            ;a23e  04 00        A = 0 attempts
    mov mem_020e, a         ;a240  61 02 0e     Store SAFE attempts

    clrb mem_00de:5         ;a243  a5 de
    setb mem_00de:6         ;a245  ae de
    setb mem_00de:4         ;a247  ac de
    mov mem_00f1, #0xa6     ;a249  85 f1 a6
    mov a, #0x04            ;a24c  04 04        A = value to store in mem_00cd
    bne lab_a1e5            ;a24e  fc 95        BRANCH_ALWAYS_TAKEN

lab_a250:
    mov a, #0x05            ;a250  04 05        A = value to store in mem_00cd
    bne lab_a1e3            ;a252  fc 8f        BRANCH_ALWAYS_TAKEN

lab_a254:
    bhs lab_a1e7            ;a254  f8 91
    call sub_dd72           ;a256  31 dd 72
    mov a, mem_00fd         ;a259  05 fd
    and a, #0x0f            ;a25b  64 0f
    cmp a, #0x03            ;a25d  14 03
    bne lab_a269            ;a25f  fc 08
    mov a, #0x02            ;a261  04 02        A = value to store in mem_00fd low nibble
    call set_00fd_lo_nib    ;a263  31 e3 ac     Store low nibble of A in mem_00fd low nibble
    mov mem_00f1, #0x81     ;a266  85 f1 81

lab_a269:
    mov mem_00ce, #0x04     ;a269  85 ce 04
    mov mem_00cc, #0x0a     ;a26c  85 cc 0a
    mov mem_00c5, #0x01     ;a26f  85 c5 01
    mov mem_00c6, #0x01     ;a272  85 c6 01
    mov mem_00c2, #0x01     ;a275  85 c2 01
    mov a, #0x00            ;a278  04 00
    mov mem_02c3, a         ;a27a  61 02 c3
    call sub_8eda           ;a27d  31 8e da
    mov a, #0x00            ;a280  04 00
    mov mem_0096, a         ;a282  45 96
    beq lab_a29b            ;  BRANCH_ALWAYS_TAKEN

lab_a286:
    bhs lab_a2b5            ;a286  f8 2d
    mov a, #0x06            ;a288  04 06        A = mem_0201 value for BLANK or SAFE
    mov mem_0201, a         ;a28a  61 02 01
    mov a, #0x05            ;a28d  04 05
    mov mem_020d, a         ;a28f  61 02 0d
    setb mem_00e4:1         ;a292  a9 e4
    mov a, #0x1e            ;a294  04 1e
    mov mem_0202, a         ;a296  61 02 02
    mov a, #0x06            ;a299  04 06        A = value to store in mem_00cd

lab_a29b:
    jmp lab_a1e3            ;a29b  21 a1 e3

lab_a29e:
    bne lab_a2b5            ;a29e  fc 15
    mov a, #0x05            ;a2a0  04 05        A = mem_0201 value for SAFE
    mov mem_0201, a         ;a2a2  61 02 01

    mov a, mem_020e         ;a2a5  60 02 0e     A = SAFE attempts
    mov a, #0x02            ;a2a8  04 02
    cmp a                   ;a2aa  12
    blo lab_a2b6            ;a2ab  f9 09

    clrb mem_00e4:1         ;a2ad  a1 e4
    mov mem_0096, #0x04     ;a2af  85 96 04
    mov mem_00cd, #0x01     ;a2b2  85 cd 01

lab_a2b5:
    ret                     ;a2b5  20

lab_a2b6:
    mov a, #0x02            ;a2b6  04 02        A = value to store in mem_00cd
    jmp lab_a1e5            ;a2b8  21 a1 e5

lab_a2bb:
    .word lab_a2e1          ;a2bb  a2 e1       VECTOR
    .word lab_a2c5          ;a2bd  a2 c5       VECTOR
    .word lab_a2e2          ;a2bf  a2 e2       VECTOR
    .word lab_a2e8          ;a2c1  a2 e8       VECTOR
    .word lab_a2fb          ;a2c3  a2 fb       VECTOR

lab_a2c5:
    movw a, #0x0e10         ;a2c5  e4 0e 10
    bbc mem_00cf:5, lab_a2ce ;a2c8  b5 cf 03
    movw mem_0211, a        ;a2cb  d4 02 11

lab_a2ce:
    movw mem_0206, a        ;a2ce  d4 02 06
    setb mem_00de:5         ;a2d1  ad de
    mov a, #0x05            ;a2d3  04 05        A = mem_0201 value for SAFE
    mov mem_0201, a         ;a2d5  61 02 01
    setb mem_0098:4         ;a2d8  ac 98
    mov mem_00f1, #0x9e     ;a2da  85 f1 9e

lab_a2dd:
    mov a, #0x02            ;a2dd  04 02

lab_a2df:
    mov mem_00cd, a         ;a2df  45 cd

lab_a2e1:
    ret                     ;a2e1  20

lab_a2e2:
    bhs lab_a2e1            ;a2e2  f8 fd

lab_a2e4:
    mov a, #0x03            ;a2e4  04 03
    bne lab_a2df            ;a2e6  fc f7        BRANCH_ALWAYS_TAKEN

lab_a2e8:
    movw a, mem_0206        ;a2e8  c4 02 06
    bne lab_a2e4            ;a2eb  fc f7
    clrb mem_00de:5         ;a2ed  a5 de

    mov a, #0x00            ;a2ef  04 00        A = 0 attempts
    mov mem_020e, a         ;a2f1  61 02 0e     Store SAFE attempts

    mov mem_00f1, #0xa6     ;a2f4  85 f1 a6
    mov a, #0x04            ;a2f7  04 04
    bne lab_a2df            ;a2f9  fc e4        BRANCH_ALWAYS_TAKEN

lab_a2fb:
    bhs lab_a2e1            ;a2fb  f8 e4
    mov mem_0096, #0x03     ;a2fd  85 96 03
    jmp lab_a2dd            ;a300  21 a2 dd

lab_a303:
    .word lab_a33b          ;a303  a3 3b       VECTOR
    .word lab_a319          ;a305  a3 19       VECTOR
    .word lab_a33c          ;a307  a3 3c       VECTOR
    .word lab_a33b          ;a309  a3 3b       VECTOR
    .word lab_a39f          ;a30b  a3 9f       VECTOR
    .word lab_a343          ;a30d  a3 43       VECTOR
    .word lab_a34a          ;a30f  a3 4a       VECTOR
    .word lab_a36d          ;a311  a3 6d       VECTOR
    .word lab_a38b          ;a313  a3 8b       VECTOR
    .word lab_a394          ;a315  a3 94       VECTOR
    .word lab_a39d          ;a317  a3 9d       VECTOR

lab_a319:
    mov a, #0x03            ;a319  04 03        A = mem_0201 value for INITIAL
    mov mem_0201, a         ;a31b  61 02 01
    clrb mem_00de:7         ;a31e  a7 de
    clrb mem_00de:6         ;a320  a6 de

    movw a, #0xffff         ;a322  e4 ff ff     A = 0xFFFF (no code)
    movw mem_020f, a        ;a325  d4 02 0f     Store as actual SAFE code

    mov mem_00f1, #0xa1     ;a328  85 f1 a1
    mov a, #0x0a            ;a32b  04 0a
    mov mem_0202, a         ;a32d  61 02 02
    mov a, #0xff            ;a330  04 ff
    mov mem_0205, a         ;a332  61 02 05
    mov a, #0x02            ;a335  04 02

lab_a337:
    setb mem_0098:4         ;a337  ac 98

lab_a339:
    mov mem_00cd, a         ;a339  45 cd

lab_a33b:
    ret                     ;a33b  20

lab_a33c:
    bne lab_a33b            ;a33c  fc fd
    bhs lab_a33b            ;a33e  f8 fb
    jmp reset_8010            ;a340  21 80 10

lab_a343:
    mov mem_00f1, #0x82     ;a343  85 f1 82
    mov a, #0x06            ;a346  04 06
    bne lab_a339            ;a348  fc ef        BRANCH_ALWAYS_TAKEN

lab_a34a:
    bhs lab_a33b            ;a34a  f8 ef
    mov a, #0x01            ;a34c  04 01        A = mem_0201 value for NO CODE
    mov mem_0201, a         ;a34e  61 02 01
    mov a, #0x1e            ;a351  04 1e
    mov mem_0202, a         ;a353  61 02 02
    movw a, mem_0275        ;a356  c4 02 75
    movw a, #0x5a5a         ;a359  e4 5a 5a
    cmpw a                  ;a35c  13
    bne lab_a369            ;a35d  fc 0a
    movw a, mem_0277        ;a35f  c4 02 77
    cmpw a                  ;a362  13
    bne lab_a369            ;a363  fc 04
    mov a, #0x04            ;a365  04 04
    bne lab_a337            ;a367  fc ce        BRANCH_ALWAYS_TAKEN

lab_a369:
    mov a, #0x07            ;a369  04 07
    bne lab_a337            ;a36b  fc ca        BRANCH_ALWAYS_TAKEN

lab_a36d:
    call sub_c1a7           ;a36d  31 c1 a7
    call sub_c2a2           ;a370  31 c2 a2
    mov a, #0x00            ;a373  04 00
    mov mem_03af, a         ;a375  61 03 af

    movw a, #0x0414         ;a378  e4 04 14     KW1281 Fault 01044 Control Module Incorrectly Coded
    movw mem_0165, a        ;a37b  d4 01 65
    movw a, #0x2332         ;a37e  e4 23 32
    movw mem_0167, a        ;a381  d4 01 67

    mov mem_00f1, #0x86     ;a384  85 f1 86
    mov a, #0x08            ;a387  04 08
    bne lab_a337            ;a389  fc ac        BRANCH_ALWAYS_TAKEN

lab_a38b:
    bhs lab_a33b            ;a38b  f8 ae
    mov mem_00f1, #0xa7     ;a38d  85 f1 a7
    mov a, #0x09            ;a390  04 09
    bne lab_a339            ;a392  fc a5        BRANCH_ALWAYS_TAKEN

lab_a394:
    bhs lab_a33b            ;a394  f8 a5
    mov mem_00f1, #0x9f     ;a396  85 f1 9f
    mov a, #0x0a            ;a399  04 0a
    bne lab_a339            ;a39b  fc 9c        BRANCH_ALWAYS_TAKEN

lab_a39d:
    bhs lab_a33b            ;a39d  f8 9c

lab_a39f:
    bne lab_a33b            ;a39f  fc 9a
    mov a, #0x00            ;a3a1  04 00
    mov mem_0096, a         ;a3a3  45 96
    beq lab_a339            ;a3a5  fd 92        BRANCH_ALWAYS_TAKEN

lab_a3a7:
    .word lab_a3bd          ;a3a7  a3 bd       VECTOR
    .word lab_a3ad          ;a3a9  a3 ad       VECTOR
    .word lab_a3be          ;a3ab  a3 be       VECTOR

lab_a3ad:
    mov a, #0x08            ;a3ad  04 08        A = mem_0201 value for SAFE
    mov mem_0201, a         ;a3af  61 02 01
    movw a, #0x0384         ;a3b2  e4 03 84
    movw mem_0206, a        ;a3b5  d4 02 06
    mov mem_00f1, #0x9f     ;a3b8  85 f1 9f
    bne lab_a3d3            ;a3bb  fc 16        BRANCH_ALWAYS_TAKEN

lab_a3bd:
    ret                     ;a3bd  20

lab_a3be:
    bne lab_a3da            ;a3be  fc 1a
    bhs lab_a3da            ;a3c0  f8 18
    blo lab_a3e1            ;a3c2  f9 1d        BRANCH_ALWAYS_TAKEN

lab_a3c4:
    .word lab_a3de          ;a3c4  a3 de       VECTOR
    .word lab_a3ca          ;a3c6  a3 ca       VECTOR
    .word lab_a3df          ;a3c8  a3 df       VECTOR

lab_a3ca:
    setb mem_0099:7         ;a3ca  af 99
    setb mem_00d7:4         ;a3cc  ac d7
    mov a, #0x09            ;a3ce  04 09        A = mem_0201 value for VER
    mov mem_0201, a         ;a3d0  61 02 01

lab_a3d3:
    setb mem_0098:4         ;a3d3  ac 98
    mov a, #0x0a            ;a3d5  04 0a
    mov mem_0202, a         ;a3d7  61 02 02

lab_a3da:
    mov a, #0x02            ;a3da  04 02

lab_a3dc:
    mov mem_00cd, a         ;a3dc  45 cd

lab_a3de:
    ret                     ;a3de  20

;lab_a3c4 case 2
lab_a3df:
    bne lab_a3da            ;a3df  fc f9

lab_a3e1:
    setb mem_0098:4         ;a3e1  ac 98
    mov a, #0x00            ;a3e3  04 00
    mov mem_0096, a         ;a3e5  45 96
    beq lab_a3dc            ;a3e7  fd f3        BRANCH_ALWAYS_TAKEN

lab_a3e9:
    .word lab_a437          ;a3e9  a4 37       VECTOR
    .word lab_a3f3          ;a3eb  a3 f3       VECTOR
    .word lab_a438          ;a3ed  a4 38       VECTOR
    .word lab_a441          ;a3ef  a4 41       VECTOR
    .word lab_a44a          ;a3f1  a4 4a       VECTOR

;lab_a3e9 case 1
lab_a3f3:
    mov a, #0x0a            ;a3f3  04 0a        A = mem_0201 value for CLEAR
    mov mem_0201, a         ;a3f5  61 02 01
    setb mem_0098:4         ;a3f8  ac 98
    mov a, #0x1e            ;a3fa  04 1e
    mov mem_0202, a         ;a3fc  61 02 02
    call sub_8380           ;a3ff  31 83 80
    call sub_83d1           ;a402  31 83 d1
    call sub_83f8           ;a405  31 83 f8
    call sub_8421           ;a408  31 84 21
    call sub_8402           ;a40b  31 84 02
    movw a, #0x0000         ;a40e  e4 00 00
    movw mem_0206, a        ;a411  d4 02 06
    mov mem_020e, a         ;a414  61 02 0e     Reset SAFE attempts
    mov mem_0208, a         ;a417  61 02 08
    movw mem_0325, a        ;a41a  d4 03 25
    clrb mem_00de:3         ;a41d  a3 de
    clrb mem_00de:4         ;a41f  a4 de
    clrb mem_00de:5         ;a421  a5 de
    clrb mem_00de:6         ;a423  a6 de
    mov mem_03af, a         ;a425  61 03 af
    mov mem_00fd, a         ;a428  45 fd
    movw mem_03b0, a        ;a42a  d4 03 b0
    movw mem_03b2, a        ;a42d  d4 03 b2
    mov mem_00f1, #0x88     ;a430  85 f1 88
    mov a, #0x02            ;a433  04 02

lab_a435:
    mov mem_00cd, a         ;a435  45 cd

;lab_a3e9 case 0
lab_a437:
    ret                     ;a437  20

;lab_a438 case 2
lab_a438:
    bhs lab_a437            ;a438  f8 fd
    mov mem_00f1, #0x9e     ;a43a  85 f1 9e
    mov a, #0x03            ;a43d  04 03
    bne lab_a435            ;a43f  fc f4        BRANCH_ALWAYS_TAKEN

;lab_a438 case 3
lab_a441:
    bhs lab_a437            ;a441  f8 f4
    mov mem_00f1, #0x9f     ;a443  85 f1 9f
    mov a, #0x04            ;a446  04 04
    bne lab_a435            ;a448  fc eb        BRANCH_ALWAYS_TAKEN

;lab_a438 case 4
lab_a44a:
    bhs lab_a437            ;a44a  f8 eb
    bne lab_a437            ;a44c  fc e9
    setb mem_0098:4         ;a44e  ac 98
    mov mem_0096, #0x00     ;a450  85 96 00
    mov mem_00cd, #0x00     ;a453  85 cd 00
    clrb mem_00ed:2         ;a456  a2 ed
    setb mem_00d0:3         ;a458  ab d0
    clrb mem_00cf:5         ;a45a  a5 cf
    mov mem_00d2, #0x05     ;a45c  85 d2 05
    ret                     ;a45f  20

sub_a460:
    cmp mem_0095, #0x0f     ;a460  95 95 0f
    beq lab_a493            ;a463  fd 2e
    mov a, mem_00fd         ;a465  05 fd
    and a, #0xf0            ;a467  64 f0
    bne lab_a493            ;a469  fc 28
    setc                    ;a46b  91
    bbc pdr4:6, lab_a470    ;a46c  b6 0e 01     branch if /EE_INITIAL = low
    clrc                    ;a46f  81

lab_a470:
    mov a, mem_0244         ;a470  60 02 44
    movw ix, #mem_0244      ;a473  e6 02 44
    mov mem_009e, #0x28     ;a476  85 9e 28
    call sub_852d           ;a479  31 85 2d
    mov a, mem_0244         ;a47c  60 02 44
    and a, #0x80            ;a47f  64 80
    beq lab_a494            ;a481  fd 11
    cmp mem_0096, #0x09     ;a483  95 96 09
    beq lab_a493            ;a486  fd 0b
    bbc mem_00e3:0, lab_a493 ;a488  b0 e3 08
    clrb mem_00e3:0         ;a48b  a0 e3
    mov mem_0096, #0x09     ;a48d  85 96 09
    mov mem_00cd, #0x01     ;a490  85 cd 01

lab_a493:
    ret                     ;a493  20

lab_a494:
    setb mem_00e3:0         ;a494  a8 e3
    ret                     ;a496  20

sub_a497:
    mov a, mem_0201         ;a497  60 02 01     A = table index
    movw a, #mem_a4a0       ;a49a  e4 a4 a0     A = table base address
    jmp sub_e73c            ;a49d  21 e7 3c     Jump to address in table

mem_a4a0:
;case table for mem_0201
    .word lab_a4b9          ;a4a0  a4 b9       VECTOR   0
    .word lab_a4b6          ;a4a2  a4 b6       VECTOR   1 no code
    .word lab_a4ba          ;a4a4  a4 ba       VECTOR   2 code
    .word lab_a4c1          ;a4a6  a4 c1       VECTOR   3 initial
    .word lab_a4be          ;a4a8  a4 be       VECTOR   4 blank or initial
    .word lab_a4cc          ;a4aa  a4 cc       VECTOR   5 safe
    .word lab_a4c9          ;a4ac  a4 c9       VECTOR   6 blank or safe
    .word lab_a4d9          ;a4ae  a4 d9       VECTOR   7 blank
    .word lab_a4e8          ;a4b0  a4 e8       VECTOR   8 safe
    .word lab_a4f1          ;a4b2  a4 f1       VECTOR   9 ver
    .word lab_a4f5          ;a4b4  a4 f5       VECTOR   a clear

lab_a4b6:
    mov @ix+0x01, #0x80     ;a4b6  86 01 80     Display number = 0x80 '....NO.CODE'

lab_a4b9:
    ret                     ;a4b9  20

lab_a4ba:
    mov @ix+0x01, #0x81     ;a4ba  86 01 81     Display number = 0x81 '.....CODE..'
    ret                     ;a4bd  20

lab_a4be:
    bbs mem_00e4:0, lab_a4c5 ;a4be  b8 e4 04

lab_a4c1:
    mov @ix+0x01, #0x84     ;a4c1  86 01 84     Display number = 0x84 '....INITIAL'
    ret                     ;a4c4  20

lab_a4c5:
    mov @ix+0x01, #0xc1     ;a4c5  86 01 c1     Display number = 0xC1 '...........'
    ret                     ;a4c8  20

lab_a4c9:
    bbs mem_00e4:0, lab_a4d5 ;a4c9  b8 e4 09    blank or safe?

lab_a4cc:
    mov @ix+0x01, #0x83     ;a4cc  86 01 83     Display number = 0x83 '.....SAFE..'
    mov a, mem_020e         ;a4cf  60 02 0e     A = SAFE attempts
    mov @ix+0x02, a         ;a4d2  46 02        Display param 0 = SAFE attampt number
    ret                     ;a4d4  20

lab_a4d5:
    mov @ix+0x01, #0xc1     ;a4d5  86 01 c1     Display number = 0xC1 '...........'
    ret                     ;a4d8  20

lab_a4d9:
    mov a, #0x82            ;a4d9  04 82
    mov @ix+0x01, a         ;a4db  46 01        Display number = 0x82 '...........' (code entry)

    mov a, mem_020e         ;a4dd  60 02 0e     A = SAFE attempts
    mov @ix+0x02, a         ;a4e0  46 02        Display param 0 = SAFE attempts

    movw a, mem_0203        ;a4e2  c4 02 03     A = entered SAFE code (16-bit BCD)
    movw @ix+0x03, a        ;a4e5  d6 03        Display param 1, 2 = SAFE code BCD
    ret                     ;a4e7  20

lab_a4e8:
    mov @ix+0x01, #0x86     ;a4e8  86 01 86     Display number = 0x86 '.....SAFE..'
    mov a, mem_0208         ;a4eb  60 02 08
    mov @ix+0x02, a         ;a4ee  46 02        Display param 0 = SAFE attempts (binary)
    ret                     ;a4f0  20

lab_a4f1:
    call sub_fd7d           ;a4f1  31 fd 7d     Display number = 0x21 'VER........'
    ret                     ;a4f4  20

lab_a4f5:
    mov @ix+0x01, #0x87     ;a4f5  86 01 87     Display number = 0x87 '....CLEAR..'
    ret                     ;a4f8  20

sub_a4f9:
    bbc mem_00e4:1, lab_a515 ;a4f9  b1 e4 19
    movw ix, #mem_020d      ;a4fc  e6 02 0d     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a4ff  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a515            ;a502  fc 11
    bbc mem_00e4:0, lab_a50c ;a504  b0 e4 05
    clrb mem_00e4:0         ;a507  a0 e4
    jmp lab_a50e            ;a509  21 a5 0e

lab_a50c:
    setb mem_00e4:0         ;a50c  a8 e4

lab_a50e:
    mov a, #0x05            ;a50e  04 05
    mov mem_020d, a         ;a510  61 02 0d
    setb mem_0098:4         ;a513  ac 98

lab_a515:
    ret                     ;a515  20

sub_a516:
    mov a, mem_0096         ;a516  05 96
    cmp a, #0x05            ;a518  14 05
    beq lab_a525            ;a51a  fd 09
    cmp a, #0x09            ;a51c  14 09
    beq lab_a525            ;a51e  fd 05
    mov mem_00f4, #0x10     ;a520  85 f4 10
    setb mem_00f1:7         ;a523  af f1

lab_a525:
    ret                     ;a525  20

sub_a526:
    bbs mem_00dd:3, lab_a533 ;a526  bb dd 0a
    bbs mem_00dd:2, lab_a538 ;a529  ba dd 0c
    bbs mem_00dd:1, lab_a53d ;a52c  b9 dd 0e
    bbs mem_00dd:0, lab_a542 ;a52f  b8 dd 10
    ret                     ;a532  20

lab_a533:
    clrb mem_00dd:3         ;a533  a3 dd
    jmp lab_a88e            ;a535  21 a8 8e

lab_a538:
    clrb mem_00dd:2         ;a538  a2 dd
    jmp lab_a7db            ;a53a  21 a7 db

lab_a53d:
    clrb mem_00dd:1         ;a53d  a1 dd
    jmp lab_a75f            ;a53f  21 a7 5f

lab_a542:
    clrb mem_00dd:0         ;a542  a0 dd
    jmp lab_a547            ;a544  21 a5 47

lab_a547:
    movw ix, #mem_02a9      ;a547  e6 02 a9     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a54a  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a574            ;a54d  fc 25
    mov a, #0x05            ;a54f  04 05
    mov mem_02a9, a         ;a551  61 02 a9
    setb mem_00dd:1         ;a554  a9 dd
    movw ix, #mem_02aa      ;a556  e6 02 aa     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a559  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a574            ;a55c  fc 16
    mov a, #0x02            ;a55e  04 02
    mov mem_02aa, a         ;a560  61 02 aa
    setb mem_00dd:2         ;a563  aa dd
    movw ix, #mem_02ab      ;a565  e6 02 ab     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a568  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a574            ;a56b  fc 07
    mov a, #0x0a            ;a56d  04 0a
    mov mem_02ab, a         ;a56f  61 02 ab
    setb mem_00dd:3         ;a572  ab dd

lab_a574:
    bbc mem_0099:3, lab_a586 ;a574  b3 99 0f
    movw ix, #mem_02ad      ;a577  e6 02 ad     IX = pointer to 16-bit value to decrement
    call dec16_at_ix        ;a57a  31 e7 8a     Decrement 16-bit value @IX.  Wraps from 0 to 0xFFFF.
    bne lab_a586            ;a57d  fc 07
    clrb mem_0099:3         ;a57f  a3 99
    setb mem_0099:2         ;a581  aa 99
    call sub_a68d           ;a583  31 a6 8d

lab_a586:
    movw ix, #mem_02ce      ;a586  e6 02 ce     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a589  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    bne lab_a594            ;a58c  fc 06
    movw ix, #mem_02cd      ;a58e  e6 02 cd     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a591  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

lab_a594:
    call sub_8c9b           ;a594  31 8c 9b
    call sub_854d           ;a597  31 85 4d
    movw ix, #mem_031d      ;a59a  e6 03 1d     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a59d  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    call sub_93cc           ;a5a0  31 93 cc
    call sub_93fe           ;a5a3  31 93 fe
    call sub_94b6           ;a5a6  31 94 b6
    call sub_9532           ;a5a9  31 95 32
    call sub_9558           ;a5ac  31 95 58
    movw ix, #mem_0213      ;a5af  e6 02 13     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a5b2  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    clrc                    ;a5b5  81
    bbc pdr6:4, lab_a5ba    ;a5b6  b4 11 01     SCA_SWITCH
    setc                    ;a5b9  91

lab_a5ba:
    mov a, mem_023e         ;a5ba  60 02 3e
    movw ix, #mem_023e      ;a5bd  e6 02 3e
    mov mem_009e, #0x03     ;a5c0  85 9e 03
    call sub_852d           ;a5c3  31 85 2d
    mov a, mem_023e         ;a5c6  60 02 3e
    cmp a, #0x03            ;a5c9  14 03
    beq lab_a5d6            ;a5cb  fd 09
    cmp a, #0xfc            ;a5cd  14 fc
    beq lab_a5d6            ;a5cf  fd 05
    mov a, #0x3c            ;a5d1  04 3c
    mov mem_02ff, a         ;a5d3  61 02 ff

lab_a5d6:
    bbc mem_00df:5, lab_a5e5 ;a5d6  b5 df 0c
    movw ix, #mem_01cb      ;a5d9  e6 01 cb     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a5dc  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a5e5            ;a5df  fc 04
    clrb mem_00df:5         ;a5e1  a5 df
    setb mem_00df:6         ;a5e3  ae df

lab_a5e5:
    bbc mem_00df:3, lab_a5f4 ;a5e5  b3 df 0c
    movw ix, #mem_01cc      ;a5e8  e6 01 cc     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a5eb  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a5f4            ;a5ee  fc 04
    clrb mem_00df:3         ;a5f0  a3 df
    setb mem_00df:4         ;a5f2  ac df

lab_a5f4:
    bbc mem_00e1:0, lab_a603 ;a5f4  b0 e1 0c
    movw ix, #mem_01eb      ;a5f7  e6 01 eb     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a5fa  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a603            ;a5fd  fc 04
    clrb mem_00e1:0         ;a5ff  a0 e1
    setb mem_00e1:1         ;a601  a9 e1

lab_a603:
    bbs mem_00c9:0, lab_a610 ;a603  b8 c9 0a
    movw ix, #mem_00c3      ;a606  e6 00 c3     IX = pointer to 16-bit value to decrement
    call dec16_at_ix        ;a609  31 e7 8a     Decrement 16-bit value @IX.  Wraps from 0 to 0xFFFF.
    bne lab_a610            ;a60c  fc 02
    setb mem_00c9:0         ;a60e  a8 c9

lab_a610:
    bbs mem_0099:0, lab_a61d ;a610  b8 99 0a
    movw ix, #mem_02b0      ;a613  e6 02 b0     IX = pointer to 16-bit value to decrement
    call dec16_at_ix        ;a616  31 e7 8a     Decrement 16-bit value @IX.  Wraps from 0 to 0xFFFF.
    bne lab_a61d            ;a619  fc 02
    setb mem_0099:0         ;a61b  a8 99

lab_a61d:
    mov a, mem_032b         ;a61d  60 03 2b
    beq lab_a62c            ;a620  fd 0a
    decw a                  ;a622  d0
    mov mem_032b, a         ;a623  61 03 2b
    cmp a, #0x00            ;a626  14 00
    bne lab_a62c            ;a628  fc 02
    setb pdr2:1             ;a62a  a9 04        /TAPE_ON=high

lab_a62c:
    mov a, mem_032a         ;a62c  60 03 2a
    beq lab_a63b            ;a62f  fd 0a
    decw a                  ;a631  d0
    mov mem_032a, a         ;a632  61 03 2a
    cmp a, #0x00            ;a635  14 00
    bne lab_a63b            ;a637  fc 02
    setb mem_00e9:1         ;a639  a9 e9

lab_a63b:
    call sub_f0a8           ;a63b  31 f0 a8
    bbs mem_008c:7, lab_a644 ;a63e  bf 8c 03
    call sub_f03b           ;a641  31 f0 3b

lab_a644:
    call sub_f6fe           ;a644  31 f6 fe
    bbc mem_00e5:6, lab_a656 ;a647  b6 e5 0c
    movw ix, #mem_02a0      ;a64a  e6 02 a0     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a64d  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a656            ;a650  fc 04
    clrb mem_00e5:6         ;a652  a6 e5
    setb mem_00e5:7         ;a654  af e5

lab_a656:
    bbc mem_00e2:6, lab_a665 ;a656  b6 e2 0c
    movw ix, #mem_02a1      ;a659  e6 02 a1     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a65c  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a665            ;a65f  fc 04
    clrb mem_00e2:6         ;a661  a6 e2
    setb mem_00e2:7         ;a663  af e2

lab_a665:
    movw ix, #mem_0200      ;a665  e6 02 00     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a668  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    bbc mem_00e7:1, lab_a67a ;a66b  b1 e7 0c
    movw ix, #mem_0237      ;a66e  e6 02 37     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a671  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a67a            ;a674  fc 04
    clrb mem_00e7:1         ;a676  a1 e7
    setb mem_00e7:2         ;a678  aa e7

lab_a67a:
    movw ix, #mem_02d3      ;a67a  e6 02 d3     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a67d  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    movw ix, #mem_0187      ;a680  e6 01 87     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a683  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    movw ix, #mem_0312      ;a686  e6 03 12     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a689  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    ret                     ;a68c  20

sub_a68d:
    mov a, mem_00ae         ;a68d  05 ae
    cmp a, #0x0b            ;a68f  14 0b    0x0b = bal key
    beq lab_a6bb            ;a691  fd 28
    cmp a, #0x16            ;a693  14 16    0x16 = scan key
    beq lab_a6e1            ;a695  fd 4a
    cmp a, #0x12            ;a697  14 12    0x12 = tape side key
    bne lab_a69e            ;a699  fc 03
    jmp lab_a72b            ;a69b  21 a7 2b

lab_a69e:
    cmp a, #0x18            ;a69e  14 18    0x18 = no code key
    bne lab_a6a5            ;a6a0  fc 03
    jmp lab_a73b            ;a6a2  21 a7 3b

lab_a6a5:
    cmp a, #0x19            ;a6a5  14 19    0x19 = initial key
    bne lab_a6ac            ;a6a7  fc 03
    jmp lab_a74d            ;a6a9  21 a7 4d

lab_a6ac:
    cmp a, #0x0a            ;a6ac  14 0a    0x0a = tune up key
    bne lab_a6b3            ;a6ae  fc 03
    jmp lab_a754            ;a6b0  21 a7 54

lab_a6b3:
    cmp a, #0x13            ;a6b3  14 13    0x13 = seek up key
    bne lab_a6ba            ;a6b5  fc 03
    jmp lab_a754            ;a6b7  21 a7 54

lab_a6ba:
    ret                     ;a6ba  20

lab_a6bb:
;bal key
    cmp mem_0096, #0x0b     ;a6bb  95 96 0b
    bne lab_a6cf            ;a6be  fc 0f
    call sub_8d00           ;a6c0  31 8d 00
    clrb mem_00df:5         ;a6c3  a5 df
    clrb mem_00df:6         ;a6c5  a6 df
    setb mem_00af:6         ;a6c7  ae af
    mov mem_00ae, #0x20     ;a6c9  85 ae 20

lab_a6cc:
    setb mem_0098:4         ;a6cc  ac 98
    ret                     ;a6ce  20

lab_a6cf:
    mov a, mem_0095         ;a6cf  05 95
    bne lab_a6d9            ;a6d1  fc 06
    mov a, mem_00c5         ;a6d3  05 c5
    beq lab_a6e0            ;a6d5  fd 09
    bne lab_a6dd            ;a6d7  fc 04        BRANCH_ALWAYS_TAKEN

lab_a6d9:
    cmp a, #0x02            ;a6d9  14 02
    bne lab_a6e0            ;a6db  fc 03

lab_a6dd:
    mov mem_0096, #0x0b     ;a6dd  85 96 0b

lab_a6e0:
    ret                     ;a6e0  20

lab_a6e1:
;scan key
    cmp mem_0096, #0x0a     ;a6e1  95 96 0a
    bne lab_a6eb            ;a6e4  fc 05
    setb mem_00af:2         ;a6e6  aa af
    setb mem_00ca:7         ;a6e8  af ca
    ret                     ;a6ea  20

lab_a6eb:
    cmp mem_0096, #0x0b     ;a6eb  95 96 0b
    beq lab_a6e0            ;a6ee  fd f0
    clrb mem_00af:2         ;a6f0  a2 af
    mov mem_0096, #0x0a     ;a6f2  85 96 0a
    setb mem_00ca:7         ;a6f5  af ca
    mov a, mem_0095         ;a6f7  05 95
    cmp a, #0x00            ;a6f9  14 00
    bne lab_a70e            ;a6fb  fc 11
    cmp mem_00c1, #0x02     ;a6fd  95 c1 02
    beq lab_a70a            ;a700  fd 08
    cmp mem_00c1, #0x01     ;a702  95 c1 01
    beq lab_a70a            ;a705  fd 03
    jmp lab_a6cc            ;a707  21 a6 cc

lab_a70a:
    mov mem_00c2, #0x31     ;a70a  85 c2 31
    ret                     ;a70d  20

lab_a70e:
    cmp a, #0x01            ;a70e  14 01
    bne lab_a6cc            ;a710  fc ba
    mov a, mem_00cc         ;a712  05 cc
    cmp a, #0x04            ;a714  14 04
    beq lab_a720            ;a716  fd 08
    cmp a, #0x1f            ;a718  14 1f
    beq lab_a720            ;a71a  fd 04
    cmp a, #0x05            ;a71c  14 05
    bne lab_a727            ;a71e  fc 07

lab_a720:
    mov a, #0x0a            ;a720  04 0a
    mov mem_0313, a         ;a722  61 03 13
    bne lab_a72a            ;a725  fc 03        BRANCH_ALWAYS_TAKEN

lab_a727:
    mov mem_00cc, #0x17     ;a727  85 cc 17

lab_a72a:
    ret                     ;a72a  20

lab_a72b:
;tape side key
    mov a, mem_0096         ;a72b  05 96
    bne lab_a73a            ;a72d  fc 0b
    bbs mem_00de:7, lab_a73a ;a72f  bf de 08
    setb mem_00e4:2         ;a732  aa e4
    mov mem_0096, #0x02     ;a734  85 96 02
    mov mem_00cd, #0x01     ;a737  85 cd 01

lab_a73a:
    ret                     ;a73a  20

lab_a73b:
;no code key
    mov a, mem_0096         ;a73b  05 96
    bne lab_a74c            ;a73d  fc 0d
    bbc mem_00de:7, lab_a743 ;a73f  b7 de 01
    ret                     ;a742  20

lab_a743:
    clrb mem_00e3:7         ;a743  a7 e3
    mov mem_0096, #0x05     ;a745  85 96 05
    mov a, #0x06            ;a748  04 06
    mov mem_00cd, a         ;a74a  45 cd

lab_a74c:
    ret                     ;a74c  20

lab_a74d:
;initial key
    mov mem_0096, #0x05     ;a74d  85 96 05
    mov mem_00cd, #0x01     ;a750  85 cd 01
    ret                     ;a753  20

lab_a754:
;tune up key or seek up key
    cmp mem_0096, #0x03     ;a754  95 96 03
    bne lab_a75e            ;a757  fc 05
    mov a, #0x19            ;a759  04 19
    mov mem_0205, a         ;a75b  61 02 05

lab_a75e:
    ret                     ;a75e  20

lab_a75f:
    mov a, #0x00            ;a75f  04 00
    mov mem_02cf, a         ;a761  61 02 cf
    bbc mem_00dc:1, lab_a773 ;a764  b1 dc 0c
    movw ix, #mem_0289      ;a767  e6 02 89     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a76a  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a773            ;a76d  fc 04
    clrb mem_00dc:1         ;a76f  a1 dc
    setb mem_00dc:2         ;a771  aa dc

lab_a773:
    bbc mem_00da:1, lab_a782 ;a773  b1 da 0c
    movw ix, #mem_02a3      ;a776  e6 02 a3     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a779  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a782            ;a77c  fc 04
    clrb mem_00da:1         ;a77e  a1 da
    setb mem_00da:2         ;a780  aa da

lab_a782:
    movw ix, #mem_03de      ;a782  e6 03 de     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a785  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    movw ix, #mem_03cd      ;a788  e6 03 cd     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a78b  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    bbc mem_00da:3, lab_a79d ;a78e  b3 da 0c
    movw ix, #mem_02a4      ;a791  e6 02 a4     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a794  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a79d            ;a797  fc 04
    clrb mem_00da:3         ;a799  a3 da
    setb mem_00da:4         ;a79b  ac da

lab_a79d:
    movw ix, #mem_03e4      ;a79d  e6 03 e4     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a7a0  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    call sub_a4f9           ;a7a3  31 a4 f9
    mov a, mem_0292         ;a7a6  60 02 92
    bne lab_a7c5            ;a7a9  fc 1a
    cmp mem_0096, #0x00     ;a7ab  95 96 00
    bne lab_a7c5            ;a7ae  fc 15
    bbs mem_0099:3, lab_a7c5 ;a7b0  bb 99 12
    movw a, #0x0000         ;a7b3  e4 00 00
    mov a, mem_02fa         ;a7b6  60 02 fa
    beq lab_a7c5            ;a7b9  fd 0a
    decw a                  ;a7bb  d0
    mov mem_02fa, a         ;a7bc  61 02 fa
    bne lab_a7c5            ;a7bf  fc 04
    setb mem_00b2:3         ;a7c1  ab b2
    setb mem_0098:4         ;a7c3  ac 98

lab_a7c5:
    movw ix, #mem_02ff      ;a7c5  e6 02 ff     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a7c8  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    call sub_a460           ;a7cb  31 a4 60

    movw ix, #mem_0327      ;a7ce  e6 03 27     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a7d1  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    movw ix, #mem_0331      ;a7d4  e6 03 31     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a7d7  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    ret                     ;a7da  20

lab_a7db:
    bbc mem_0099:4, lab_a7eb ;a7db  b4 99 0d
    movw ix, #mem_02af      ;a7de  e6 02 af     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a7e1  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a7eb            ;a7e4  fc 05
    clrb mem_0099:4         ;a7e6  a4 99
    setb mem_0098:4         ;a7e8  ac 98
    callv #4                ;a7ea  ec           CALLV #4 = callv4_8c84

lab_a7eb:
    bbc mem_00d7:3, lab_a7fb ;a7eb  b3 d7 0d
    movw ix, #mem_01c5      ;a7ee  e6 01 c5     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a7f1  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a7fb            ;a7f4  fc 05
    clrb mem_00d7:3         ;a7f6  a3 d7
    callv #5                ;a7f8  ed           CALLV #5 = callv5_8d0d
    setb mem_0098:4         ;a7f9  ac 98

lab_a7fb:
    movw a, #0x0000         ;a7fb  e4 00 00
    mov a, mem_0313         ;a7fe  60 03 13
    beq lab_a80c            ;a801  fd 09
    decw a                  ;a803  d0
    mov mem_0313, a         ;a804  61 03 13
    bne lab_a80c            ;a807  fc 03
    callv #5                ;a809  ed           CALLV #5 = callv5_8d0d
    setb mem_0098:4         ;a80a  ac 98

lab_a80c:
    bbc mem_008c:7, lab_a81e ;a80c  b7 8c 0f
    bbc mem_008c:5, lab_a81e ;a80f  b5 8c 0c
    movw ix, #mem_0117      ;a812  e6 01 17     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a815  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a81e            ;a818  fc 04
    clrb mem_008c:5         ;a81a  a5 8c
    setb mem_008c:6         ;a81c  ae 8c

lab_a81e:
    mov a, mem_00fd         ;a81e  05 fd
    and a, #0xf0            ;a820  64 f0
    beq lab_a837            ;a822  fd 13
    cmp a, #0x30            ;a824  14 30
    blo lab_a837            ;a826  f9 0f
    bbc mem_00f9:5, lab_a837 ;a828  b5 f9 0c
    movw ix, #mem_039b      ;a82b  e6 03 9b     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a82e  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a837            ;a831  fc 04
    clrb mem_00f9:5         ;a833  a5 f9
    setb mem_00fa:0         ;a835  a8 fa

lab_a837:
    bbc mem_00e0:2, lab_a846 ;a837  b2 e0 0c
    movw ix, #mem_01cd      ;a83a  e6 01 cd     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a83d  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a846            ;a840  fc 04
    clrb mem_00e0:2         ;a842  a2 e0
    setb mem_00e0:3         ;a844  ab e0

lab_a846:
    movw ix, #mem_0202      ;a846  e6 02 02     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a849  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    bbc mem_00e5:4, lab_a85b ;a84c  b4 e5 0c
    movw ix, #mem_029e      ;a84f  e6 02 9e     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a852  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a85b            ;a855  fc 04
    clrb mem_00e5:4         ;a857  a4 e5
    setb mem_00e5:5         ;a859  ad e5

lab_a85b:
    bbc mem_00da:6, lab_a86a ;a85b  b6 da 0c
    movw ix, #mem_01ec      ;a85e  e6 01 ec     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a861  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a86a            ;a864  fc 04
    clrb mem_00da:6         ;a866  a6 da
    setb mem_00da:7         ;a868  af da

lab_a86a:
    call sub_c0f5           ;a86a  31 c0 f5
    mov a, mem_018e         ;a86d  60 01 8e
    cmp a, #0x01            ;a870  14 01
    bne lab_a881            ;a872  fc 0d
    movw ix, #mem_018d      ;a874  e6 01 8d     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a877  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a881            ;a87a  fc 05
    mov a, #0x00            ;a87c  04 00
    mov mem_018e, a         ;a87e  61 01 8e

lab_a881:
    movw ix, #mem_02c1      ;a881  e6 02 c1     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a884  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.

    movw ix, #mem_03c5      ;a887  e6 03 c5     IX = pointer to 8-bit value to decrement
    call dec8_at_ix_nowrap  ;a88a  31 e7 7d     Decrement 8-bit value @IX.  No wrap past 0.
    ret                     ;a88d  20

lab_a88e:
    call sub_c1b6           ;a88e  31 c1 b6
    call sub_c229           ;a891  31 c2 29
    bbs mem_008c:7, lab_a8a6 ;a894  bf 8c 0f
    bbc mem_00db:6, lab_a8a6 ;a897  b6 db 0c
    movw ix, #mem_01ee      ;a89a  e6 01 ee     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;a89d  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_a8a6            ;a8a0  fc 04
    clrb mem_00db:6         ;a8a2  a6 db
    setb mem_00db:7         ;a8a4  af db

lab_a8a6:
    movw a, mem_0325        ;a8a6  c4 03 25
    beq lab_a8b6            ;a8a9  fd 0b
    decw a                  ;a8ab  d0
    movw mem_0325, a        ;a8ac  d4 03 25
    bne lab_a8b6            ;a8af  fc 05
    clrb mem_00de:3         ;a8b1  a3 de
    mov mem_00f1, #0x8d     ;a8b3  85 f1 8d

lab_a8b6:
    movw a, mem_0206        ;a8b6  c4 02 06
    beq lab_a8eb            ;a8b9  fd 30
    decw a                  ;a8bb  d0
    movw mem_0206, a        ;a8bc  d4 02 06
    bne lab_a8eb            ;a8bf  fc 2a
    bbc mem_00e4:3, lab_a8eb ;a8c1  b3 e4 27
    clrb mem_00e4:3         ;a8c4  a3 e4
    mov mem_00cc, #0x0a     ;a8c6  85 cc 0a
    mov mem_00ce, #0x04     ;a8c9  85 ce 04
    call sub_8f06           ;a8cc  31 8f 06
    cmp mem_0095, #0x0f     ;a8cf  95 95 0f
    bne lab_a8d7            ;a8d2  fc 03
    mov mem_0095, #0x00     ;a8d4  85 95 00

lab_a8d7:
    call sub_9363           ;a8d7  31 93 63
    bbc mem_00de:5, lab_a8e1 ;a8da  b5 de 04
    mov a, #0x04            ;a8dd  04 04
    bne lab_a8e6            ;a8df  fc 05        BRANCH_ALWAYS_TAKEN

lab_a8e1:
    bbs mem_00de:6, lab_a8eb ;a8e1  be de 07
    mov a, #0x03            ;a8e4  04 03

lab_a8e6:
    mov mem_0096, a         ;a8e6  45 96
    mov mem_00cd, #0x01     ;a8e8  85 cd 01

lab_a8eb:
    bbs mem_00d0:3, lab_a913 ;a8eb  bb d0 25
    bbc mem_00cf:5, lab_a913 ;a8ee  b5 cf 22
    movw ix, #mem_0211      ;a8f1  e6 02 11     IX = pointer to 16-bit value to decrement
    call dec16_at_ix        ;a8f4  31 e7 8a     Decrement 16-bit value @IX.  Wraps from 0 to 0xFFFF.
    bne lab_a913            ;a8f7  fc 1a
    clrb mem_00cf:5         ;a8f9  a5 cf
    setb mem_00d0:3         ;a8fb  ab d0
    movw a, mem_0206        ;a8fd  c4 02 06
    bne lab_a910            ;a900  fc 0e
    cmp mem_0096, #0x04     ;a902  95 96 04
    bne lab_a910            ;a905  fc 09
    mov mem_0096, #0x00     ;a907  85 96 00
    mov mem_00d2, #0x0b     ;a90a  85 d2 0b
    jmp lab_a913            ;a90d  21 a9 13

lab_a910:
    mov mem_00d2, #0x05     ;a910  85 d2 05

lab_a913:
    ret                     ;a913  20


sub_a914:
;Called from ISR for IRQ2 (16-bit timer counter)
    mov a, mem_03df         ;a914  60 03 df
    beq lab_a91d            ;a917  fd 04
    decw a                  ;a919  d0
    mov mem_03df, a         ;a91a  61 03 df

lab_a91d:
    movw a, #0x0000         ;a91d  e4 00 00
    mov a, mem_0320         ;a920  60 03 20
    beq lab_a930            ;a923  fd 0b
    decw a                  ;a925  d0
    mov mem_0320, a         ;a926  61 03 20
    bne lab_a93d            ;a929  fc 12
    mov a, #0x10            ;a92b  04 10
    mov mem_0320, a         ;a92d  61 03 20

lab_a930:
    bbc mem_00ee:7, lab_a936 ;a930  b7 ee 03
    bbc pdr7:0, lab_a93b    ;a933  b0 13 05     BEEP

lab_a936:
    clrb pdr7:0             ;a936  a0 13        BEEP=low
    jmp lab_a93d            ;a938  21 a9 3d

lab_a93b:
    setb pdr7:0             ;a93b  a8 13        BEEP=high

lab_a93d:
    mov a, mem_009c         ;a93d  05 9c
    incw a                  ;a93f  c0
    mov mem_009c, a         ;a940  45 9c
    cmp a, #0x09            ;a942  14 09
    bne lab_a960            ;a944  fc 1a
    mov a, #0x01            ;a946  04 01
    mov mem_009c, a         ;a948  45 9c
    movw a, mem_0305        ;a94a  c4 03 05
    beq lab_a955            ;a94d  fd 06
    decw a                  ;a94f  d0
    movw mem_0305, a        ;a950  d4 03 05
    bne lab_a960            ;a953  fc 0b

lab_a955:
    mov a, mem_00fd         ;a955  05 fd
    and a, #0xf0            ;a957  64 f0
    cmp a, #0x20            ;a959  14 20
    bhs lab_a960            ;a95b  f8 03
    call sub_afca           ;a95d  31 af ca

lab_a960:
    bbs mem_008c:7, lab_a969 ;a960  bf 8c 06
    call sub_de01           ;a963  31 de 01
    call sub_e12e           ;a966  31 e1 2e

lab_a969:
    call sub_ab7a           ;a969  31 ab 7a
    mov a, mem_032e         ;a96c  60 03 2e
    beq lab_a975            ;a96f  fd 04
    decw a                  ;a971  d0
    mov mem_032e, a         ;a972  61 03 2e

lab_a975:
    mov a, mem_0390         ;a975  60 03 90
    beq lab_a97e            ;a978  fd 04
    decw a                  ;a97a  d0
    mov mem_0390, a         ;a97b  61 03 90

lab_a97e:
    call sub_d448           ;a97e  31 d4 48
    mov a, mem_0308         ;a981  60 03 08
    beq lab_a98b            ;a984  fd 05
    mov a, #0x02            ;a986  04 02
    mov mem_033a, a         ;a988  61 03 3a

lab_a98b:
    mov a, mem_0302         ;a98b  60 03 02
    beq lab_a994            ;a98e  fd 04
    setb mem_00f7:7         ;a990  af f7
    bne lab_a9a1            ;a992  fc 0d        BRANCH_ALWAYS_TAKEN

lab_a994:
    mov a, mem_0369         ;a994  60 03 69
    cmp a, #0x03            ;a997  14 03
    beq lab_a99f            ;a999  fd 04
    cmp a, #0x01            ;a99b  14 01
    bne lab_a9a1            ;a99d  fc 02

lab_a99f:
    clrb mem_00f7:7         ;a99f  a7 f7

lab_a9a1:
    bbs mem_008c:7, lab_a9a7 ;a9a1  bf 8c 03
    call sub_de60           ;a9a4  31 de 60

lab_a9a7:
    mov a, mem_009c         ;a9a7  05 9c
    and a, #0x03            ;a9a9  64 03
    cmp a, #0x03            ;a9ab  14 03
    bne lab_a9b1            ;a9ad  fc 02
    beq lab_a9ca            ;a9af  fd 19        BRANCH_ALWAYS_TAKEN

lab_a9b1:
    rorc a                  ;a9b1  03
    blo lab_a9c9            ;a9b2  f9 15
    bhs lab_a9b6            ;a9b4  f8 00        BRANCH_ALWAYS_TAKEN

lab_a9b6:
    movw a, #0x0000         ;a9b6  e4 00 00
    mov a, mem_02a7         ;a9b9  60 02 a7
    decw a                  ;a9bc  d0
    mov mem_02a7, a         ;a9bd  61 02 a7
    bne lab_a9c9            ;a9c0  fc 07
    mov a, #0x05            ;a9c2  04 05
    mov mem_02a7, a         ;a9c4  61 02 a7
    setb mem_00dd:0         ;a9c7  a8 dd

lab_a9c9:
    ret                     ;a9c9  20

lab_a9ca:
    bbs mem_00c0:0, lab_a9da ;a9ca  b8 c0 0d
    mov a, mem_0271         ;a9cd  60 02 71
    decw a                  ;a9d0  d0
    mov mem_0271, a         ;a9d1  61 02 71
    cmp a, #0x00            ;a9d4  14 00
    bne lab_a9da            ;a9d6  fc 02
    setb mem_00c0:0         ;a9d8  a8 c0

lab_a9da:
    mov a, mem_01bc         ;a9da  60 01 bc
    beq lab_a9e3            ;a9dd  fd 04
    decw a                  ;a9df  d0
    mov mem_01bc, a         ;a9e0  61 01 bc

lab_a9e3:
    bbc mem_00e6:1, lab_a9f4 ;a9e3  b1 e6 0e
    movw a, #0x0000         ;a9e6  e4 00 00

    mov a, mem_02c7         ;a9e9  60 02 c7
    decw a                  ;a9ec  d0
    mov mem_02c7, a         ;a9ed  61 02 c7

    bne lab_a9f4            ;a9f0  fc 02
    clrb mem_00e6:1         ;a9f2  a1 e6

lab_a9f4:
    mov a, mem_038c         ;a9f4  60 03 8c
    beq lab_a9fd            ;a9f7  fd 04
    decw a                  ;a9f9  d0
    mov mem_038c, a         ;a9fa  61 03 8c

lab_a9fd:
    ret                     ;a9fd  20

mem_a9fe:
    .byte 0x00              ;a9fe  00          DATA '\x00'
    .byte 0xB3              ;a9ff  b3          DATA '\xb3'
    .byte 0x08              ;aa00  08          DATA '\x08'
    .byte 0x80              ;aa01  80          DATA '\x80'

    .byte 0x00              ;aa02  00          DATA '\x00'
    .byte 0xB4              ;aa03  b4          DATA '\xb4'
    .byte 0x08              ;aa04  08          DATA '\x08'
    .byte 0x80              ;aa05  80          DATA '\x80'

    .byte 0x00              ;aa06  00          DATA '\x00'
    .byte 0xB5              ;aa07  b5          DATA '\xb5'
    .byte 0x10              ;aa08  10          DATA '\x10'
    .byte 0x20              ;aa09  20          DATA ' '

    .byte 0x00              ;aa0a  00          DATA '\x00'
    .byte 0xB6              ;aa0b  b6          DATA '\xb6'
    .byte 0x08              ;aa0c  08          DATA '\x08'
    .byte 0x40              ;aa0d  40          DATA '@'

sub_aa0e:
    movw a, #0x0000         ;aa0e  e4 00 00
    mov a, mem_00b1         ;aa11  05 b1
    decw a                  ;aa13  d0
    bn lab_aa54             ;aa14  fb 3e
    cmp a, #0x04            ;aa16  14 04
    bhs lab_aa54            ;aa18  f8 3a
    setb mem_0098:4         ;aa1a  ac 98
    clrc                    ;aa1c  81
    rolc a                  ;aa1d  02
    rolc a                  ;aa1e  02
    movw a, #mem_a9fe       ;aa1f  e4 a9 fe
    clrc                    ;aa22  81
    addcw a                 ;aa23  23
    movw ix, a              ;aa24  e2
    movw a, @ix+0x00        ;aa25  c6 00
    movw ep, a              ;aa27  e3
    mov a, @ix+0x02         ;aa28  06 02
    mov a, mem_0097         ;aa2a  05 97
    and a                   ;aa2c  62
    beq lab_aa5f            ;aa2d  fd 30
    mov a, #0x01            ;aa2f  04 01

lab_aa31:
    clrb mem_0097:3         ;aa31  a3 97
    clrb mem_0097:4         ;aa33  a4 97
    clrc                    ;aa35  81
    addc a, @ep             ;aa36  27
    cmp a, #0xf6            ;aa37  14 f6
    bhs lab_aa45            ;aa39  f8 0a
    mov a, #0x80            ;aa3b  04 80
    and a                   ;aa3d  62
    bne lab_aa46            ;aa3e  fc 06
    xch a, t                ;aa40  42
    cmp a, #0x0b            ;aa41  14 0b
    bhs lab_aa46            ;aa43  f8 01

lab_aa45:
    mov @ep, a              ;aa45  47

lab_aa46:
    pushw ix                ;aa46  41
    call sub_8c79           ;aa47  31 8c 79
    popw ix                 ;aa4a  51
    mov a, @ix+0x03         ;aa4b  06 03
    or a, mem_00b2          ;aa4d  75 b2
    mov mem_00b2, a         ;aa4f  45 b2
    call sub_aa6a           ;aa51  31 aa 6a

lab_aa54:
    call sub_f889           ;aa54  31 f8 89
    call sub_aaa7           ;aa57  31 aa a7
    clrb mem_0097:3         ;aa5a  a3 97
    clrb mem_0097:4         ;aa5c  a4 97
    ret                     ;aa5e  20

lab_aa5f:
    xch a, t                ;aa5f  42
    xor a, #0x18            ;aa60  54 18
    and a, mem_0097         ;aa62  65 97
    beq lab_aa54            ;aa64  fd ee
    mov a, #0xff            ;aa66  04 ff
    bne lab_aa31            ;aa68  fc c7        BRANCH_ALWAYS_TAKEN

sub_aa6a:
    movw a, mem_00b3        ;aa6a  c5 b3
    mov a, mem_0095         ;aa6c  05 95
    bne lab_aa7e            ;aa6e  fc 0e
    xch a, t                ;aa70  42
    mov a, mem_00c5         ;aa71  05 c5
    xch a, t                ;aa73  42
    bne lab_aa7a            ;aa74  fc 04
    movw mem_0296, a        ;aa76  d4 02 96
    ret                     ;aa79  20

lab_aa7a:
    movw mem_0298, a        ;aa7a  d4 02 98
    ret                     ;aa7d  20

lab_aa7e:
    cmp a, #0x01            ;aa7e  14 01
    bne lab_aa87            ;aa80  fc 05
    xch a, t                ;aa82  42
    movw mem_029a, a        ;aa83  d4 02 9a
    ret                     ;aa86  20

lab_aa87:
    cmp a, #0x02            ;aa87  14 02
    bne lab_aa8f            ;aa89  fc 04
    xch a, t                ;aa8b  42
    movw mem_029c, a        ;aa8c  d4 02 9c

lab_aa8f:
    ret                     ;aa8f  20

sub_aa90:
    cmp a, #0x80            ;aa90  14 80
    blo lab_aa97            ;aa92  f9 03
    xor a, #0xff            ;aa94  54 ff
    incw a                  ;aa96  c0

lab_aa97:
    ret                     ;aa97  20

sub_aa98:
    call sub_aa90           ;aa98  31 aa 90

sub_aa9b:
    swap                    ;aa9b  10
    mov a, #0x00            ;aa9c  04 00
    swap                    ;aa9e  10
    movw a, #0x0000         ;aa9f  e4 00 00
    movw a, ep              ;aaa2  f3
    clrc                    ;aaa3  81
    addcw a                 ;aaa4  23
    mov a, @a               ;aaa5  92
    ret                     ;aaa6  20

sub_aaa7:
    bbc mem_00b2:7, lab_aaae ;aaa7  b7 b2 04
    clrb mem_00b2:7         ;aaaa  a7 b2
    bne lab_aab8            ;aaac  fc 0a

lab_aaae:
    bbc mem_00da:0, lab_aab5 ;aaae  b0 da 04
    clrb mem_00da:0         ;aab1  a0 da
    bne lab_aab8            ;aab3  fc 03

lab_aab5:
    bbc mem_00b2:5, lab_aabe ;aab5  b5 b2 06

lab_aab8:
    call sub_fb46           ;aab8  31 fb 46
    call sub_fc81           ;aabb  31 fc 81

lab_aabe:
    bbc mem_00b2:5, lab_ab12 ;aabe  b5 b2 51
    clrb mem_00b2:5         ;aac1  a5 b2
    mov a, mem_0293         ;aac3  60 02 93
    movw ep, #mem_fea8      ;aac6  e7 fe a8
    call sub_aa9b           ;aac9  31 aa 9b
    bbc mem_00e2:5, lab_aad0 ;aacc  b5 e2 01
    incw a                  ;aacf  c0

lab_aad0:
    mov mem_00b7, a         ;aad0  45 b7
    mov mem_00b8, a         ;aad2  45 b8
    mov r4, a               ;aad4  4c
    mov a, mem_00b5         ;aad5  05 b5
    movw ep, #mem_fee1      ;aad7  e7 fe e1
    call sub_aa98           ;aada  31 aa 98
    mov a, r4               ;aadd  0c
    xch a, t                ;aade  42
    clrc                    ;aadf  81
    subc a                  ;aae0  32
    cmp a, #0x80            ;aae1  14 80
    bhs lab_aae9            ;aae3  f8 04
    cmp a, #0x0c            ;aae5  14 0c
    bhs lab_aaeb            ;aae7  f8 02

lab_aae9:
    mov a, #0x00            ;aae9  04 00

lab_aaeb:
    bbc mem_00b5:7, lab_aaf2 ;aaeb  b7 b5 04
    mov mem_00b8, a         ;aaee  45 b8
    bne lab_aaf4            ;aaf0  fc 02

lab_aaf2:
    mov mem_00b7, a         ;aaf2  45 b7

lab_aaf4:
    movw a, #0x0000         ;aaf4  e4 00 00
    mov a, mem_00b7         ;aaf7  05 b7
    movw mem_00a8, a        ;aaf9  d5 a8
    movw a, #0x0202         ;aafb  e4 02 02
    movw mem_00aa, a        ;aafe  d5 aa
    call sub_ab31           ;ab00  31 ab 31
    movw a, #0x0000         ;ab03  e4 00 00
    mov a, mem_00b8         ;ab06  05 b8
    movw mem_00a8, a        ;ab08  d5 a8
    movw a, #0x0203         ;ab0a  e4 02 03
    movw mem_00aa, a        ;ab0d  d5 aa
    call sub_ab31           ;ab0f  31 ab 31

lab_ab12:
    bbc mem_00b2:6, lab_ab30 ;ab12  b6 b2 1b
    clrb mem_00b2:6         ;ab15  a6 b2
    mov a, mem_00b6         ;ab17  05 b6
    movw ep, #mem_fed6      ;ab19  e7 fe d6
    call sub_aa98           ;ab1c  31 aa 98
    swap                    ;ab1f  10
    mov a, #0x00            ;ab20  04 00
    movw a, #0x3099         ;ab22  e4 30 99
    bbc mem_00b6:7, lab_ab2c ;ab25  b7 b6 04
    xchw a, t               ;ab28  43
    movw a, #0x2099         ;ab29  e4 20 99

lab_ab2c:
    orw a                   ;ab2c  73
    call sub_ab4c           ;ab2d  31 ab 4c

lab_ab30:
    ret                     ;ab30  20

sub_ab31:
    bbc mem_00a9:0, lab_ab36 ;ab31  b0 a9 02
    setb mem_00a9:7         ;ab34  af a9

lab_ab36:
    bbc mem_00a9:1, lab_ab3b ;ab36  b1 a9 02
    setb mem_00a8:0         ;ab39  a8 a8

lab_ab3b:
    movw a, mem_00a8        ;ab3b  c5 a8
    movw a, #0xfffc         ;ab3d  e4 ff fc
    andw a                  ;ab40  63
    movw a, mem_00aa        ;ab41  c5 aa
    orw a                   ;ab43  73
    movw a, mem_0294        ;ab44  c4 02 94
    orw a                   ;ab47  73
    call sub_ab4c           ;ab48  31 ab 4c
    ret                     ;ab4b  20

sub_ab4c:
    mov r4, #0x00           ;ab4c  8c 00

lab_ab4e:
    swap                    ;ab4e  10
    rorc a                  ;ab4f  03
    swap                    ;ab50  10
    rorc a                  ;ab51  03
    bhs lab_ab58            ;ab52  f8 04
    setb pdr2:3             ;ab54  ab 04        VOL_DATA=high
    blo lab_ab5a            ;ab56  f9 02        BRANCH_ALWAYS_TAKEN

lab_ab58:
    clrb pdr2:3             ;ab58  a3 04        VOL_DATA=low

lab_ab5a:
    cmpw a                  ;ab5a  13
    cmpw a                  ;ab5b  13
    setb pdr2:2             ;ab5c  aa 04        /VOL_CLK=high
    cmpw a                  ;ab5e  13
    cmpw a                  ;ab5f  13
    cmp r4, #0x0d           ;ab60  9c 0d
    bne lab_ab68            ;ab62  fc 04
    setb pdr2:3             ;ab64  ab 04        VOL_DATA=high
    beq lab_ab6a            ;ab66  fd 02        BRANCH_ALWAYS_TAKEN

lab_ab68:
    clrb pdr2:3             ;ab68  a3 04        VOL_DATA=low

lab_ab6a:
    nop                     ;ab6a  00
    nop                     ;ab6b  00
    nop                     ;ab6c  00
    nop                     ;ab6d  00
    clrb pdr2:2             ;ab6e  a2 04        /VOL_CLK=low
    inc r4                  ;ab70  cc
    cmp r4, #0x0e           ;ab71  9c 0e
    blo lab_ab4e            ;ab73  f9 d9
    cmpw a                  ;ab75  13
    cmpw a                  ;ab76  13
    clrb pdr2:3             ;ab77  a3 04        VOL_DATA=low
    ret                     ;ab79  20

sub_ab7a:
    mov a, mem_0095         ;ab7a  05 95
    bne lab_ab84            ;ab7c  fc 06
    cmp mem_00c1, #0x01     ;ab7e  95 c1 01
    bne lab_ab94            ;ab81  fc 11

lab_ab83:
    ret                     ;ab83  20

lab_ab84:
    cmp a, #0x01            ;ab84  14 01
    bne lab_ab90            ;ab86  fc 08
    mov a, mem_0369         ;ab88  60 03 69
    cmp a, #0x05            ;ab8b  14 05
    beq lab_ab94            ;ab8d  fd 05
    ret                     ;ab8f  20

lab_ab90:
    cmp a, #0x02            ;ab90  14 02
    bne lab_ab83            ;ab92  fc ef

lab_ab94:
    bbs pdr2:4, lab_ab9d    ;ab94  bc 04 06     branch if audio not muted
    mov a, mem_00e9         ;ab97  05 e9
    cmp a, #0xf7            ;ab99  14 f7
    bne lab_ab83            ;ab9b  fc e6

lab_ab9d:
    mov a, pdr1             ;ab9d  05 02
    rorc a                  ;ab9f  03
    and a, #0x03            ;aba0  64 03
    mov mem_00b0, a         ;aba2  45 b0
    mov a, mem_0286         ;aba4  60 02 86
    xch a, t                ;aba7  42
    cmp a                   ;aba8  12
    beq lab_abaf            ;aba9  fd 04
    mov mem_0286, a         ;abab  61 02 86

lab_abae:
    ret                     ;abae  20

lab_abaf:
    mov a, mem_0287         ;abaf  60 02 87
    xch a, t                ;abb2  42
    cmp a                   ;abb3  12
    beq lab_abae            ;abb4  fd f8
    mov mem_0287, a         ;abb6  61 02 87
    mov a, mem_0285         ;abb9  60 02 85
    rolc a                  ;abbc  02
    rolc a                  ;abbd  02
    and a, #0x3c            ;abbe  64 3c
    or a                    ;abc0  72
    mov mem_0285, a         ;abc1  61 02 85
    cmp a, #0x38            ;abc4  14 38        ;TODO 0x38 = 56 is this KW1281 radio address?
    beq lab_abcc            ;abc6  fd 04
    cmp a, #0x07            ;abc8  14 07
    bne lab_abe3            ;abca  fc 17

lab_abcc:
    setb mem_00d8:0         ;abcc  a8 d8
    cmp mem_0096, #0x0a     ;abce  95 96 0a
    beq lab_abe2            ;abd1  fd 0f
    setb mem_00d3:4         ;abd3  ac d3

lab_abd5:
    setb mem_00d3:6         ;abd5  ae d3
    cmp mem_0095, #0x00     ;abd7  95 95 00
    bne lab_abe2            ;abda  fc 06
    mov a, mem_00c5         ;abdc  05 c5
    beq lab_abe2            ;abde  fd 02
    setb mem_00dc:4         ;abe0  ac dc

lab_abe2:
    ret                     ;abe2  20

lab_abe3:
    cmp a, #0x34            ;abe3  14 34
    beq lab_abeb            ;abe5  fd 04
    cmp a, #0x0b            ;abe7  14 0b
    bne lab_abe2            ;abe9  fc f7

lab_abeb:
    setb mem_00d8:1         ;abeb  a9 d8
    cmp mem_0096, #0x0a     ;abed  95 96 0a
    beq lab_abe2            ;abf0  fd f0
    setb mem_00d3:5         ;abf2  ad d3
    bne lab_abd5            ;abf4  fc df        BRANCH_ALWAYS_TAKEN

sub_abf6:
    call sub_ac25           ;abf6  31 ac 25
    call sub_ade1           ;abf9  31 ad e1
    call sub_ae6a           ;abfc  31 ae 6a
    call sub_af89           ;abff  31 af 89     Send KW1281 byte at 9615.38 bps or do nothing
    ret                     ;ac02  20

mem_ac03:
;KW1281 block title entry points
    .word mem_0080_is_00          ;ac03  b0 94       VECTOR     Initial Connection
    .word mem_0080_is_01          ;ac05  b3 10       VECTOR     ID code request/ECU Info
    .word mem_0080_is_02          ;ac07  b1 da       VECTOR     ? Sends No Acknowledge
    .word mem_0080_is_03          ;ac09  b1 77       VECTOR     Acknowledge
    .word mem_0080_is_04          ;ac0b  b4 5f       VECTOR     Read Faults
    .word mem_0080_is_05          ;ac0d  b5 9c       VECTOR     Clear Faults
    .word mem_0080_is_06          ;ac0f  b6 54       VECTOR     Actuator/Output Tests
    .word mem_0080_is_07          ;ac11  b7 5a       VECTOR     Group Reading
    .word mem_0080_is_08          ;ac13  b9 3a       VECTOR     Recoding
    .word mem_0080_is_09          ;ac15  ba 7a       VECTOR     Login
    .word mem_0080_is_0a          ;ac17  bb 23       VECTOR     Protected: Read RAM
    .word mem_0080_is_0b_or_0c    ;ac19  bb 17       VECTOR     Protected: Read ROM
    .word mem_0080_is_0b_or_0c    ;ac1b  bb 17       VECTOR     Protected: Read EEPROM
    .word mem_0080_is_0d          ;ac1d  b1 89       VECTOR     No Acknowledge
    .word mem_0080_is_0e          ;ac1f  b1 ec       VECTOR     Unrecognized Block Title
    .word mem_0080_is_0f          ;ac21  bb 9e       VECTOR     End Session
    .word mem_0080_is_10          ;ac23  b2 b9       VECTOR     Read or write SAFE code word

sub_ac25:
    bbs mem_008b:2, lab_ac2e ;ac25  ba 8b 06
    call sub_ace2           ;ac28  31 ac e2
    jmp lab_ac3e            ;ac2b  21 ac 3e

lab_ac2e:
    mov a, mem_0080         ;ac2e  05 80
    cmp a, #0x10            ;ac30  14 10        0x10 = Last index in mem_ac03 table
    beq lab_ac36            ;ac32  fd 02
    bhs lab_ac3e            ;ac34  f8 08

lab_ac36:
;mem_0080 is 0x00 - 0x10
    mov a, mem_0080         ;ac36  05 80        A = table index
    movw a, #mem_ac03       ;ac38  e4 ac 03     A = table base address
    call sub_e73c           ;ac3b  31 e7 3c     Call address in table

lab_ac3e:
;mem_0080 is > 0x010
    bbc mem_008c:6, lab_ac6f ;ac3e  b6 8c 2e
    call sub_ac83           ;ac41  31 ac 83
    mov smr, #0x4f          ;ac44  85 1c 4f
    mov a, mem_01a1         ;ac47  60 01 a1
    mov a, #0x01            ;ac4a  04 01
    cmp a                   ;ac4c  12
    bne lab_ac53            ;ac4d  fc 04
    mov mem_00d2, #0x05     ;ac4f  85 d2 05
    ret                     ;ac52  20

lab_ac53:
    mov a, mem_0095         ;ac53  05 95
    bne lab_ac5c            ;ac55  fc 05
    mov mem_00c2, #0x01     ;ac57  85 c2 01
    beq lab_ac6c            ;ac5a  fd 10        BRANCH_ALWAYS_TAKEN

lab_ac5c:
    cmp a, #0x01            ;ac5c  14 01
    bne lab_ac65            ;ac5e  fc 05
    mov mem_00cc, #0x06     ;ac60  85 cc 06
    beq lab_ac6c            ;ac63  fd 07        BRANCH_ALWAYS_TAKEN

lab_ac65:
    cmp a, #0x02            ;ac65  14 02
    bne lab_ac6c            ;ac67  fc 03
    mov mem_00ce, #0x01     ;ac69  85 ce 01

lab_ac6c:
    setb mem_0098:4         ;ac6c  ac 98
    ret                     ;ac6e  20

lab_ac6f:
    bbs mem_008c:5, lab_ac79 ;ac6f  bd 8c 07
    mov a, #0x0d            ;ac72  04 0d
    mov mem_0117, a         ;ac74  61 01 17
    setb mem_008c:5         ;ac77  ad 8c

lab_ac79:
    ret                     ;ac79  20

sub_ac7a:
    call reset_kw_counts    ;ac7a  31 e0 b8     Reset counts of KW1281 bytes received, sent
    movw a, #0x0000         ;ac7d  e4 00 00
    movw mem_0088, a        ;ac80  d5 88        Clear KW1281 byte received, KW1281 byte to send
    ret                     ;ac82  20

sub_ac83:
    call sub_ac7a           ;ac83  31 ac 7a

sub_ac86:
    clrb mem_00e1:7         ;ac86  a7 e1
    clrb mem_008d:4         ;ac88  a4 8d
    mov a, #0x6c            ;ac8a  04 6c
    and a, mem_008e         ;ac8c  65 8e
    mov mem_008e, a         ;ac8e  45 8e
    clrb mem_00e4:6         ;ac90  a6 e4
    clrb mem_00e6:1         ;ac92  a1 e6
    movw a, #0x0000         ;ac94  e4 00 00
    mov mem_019b, a         ;ac97  61 01 9b
    mov mem_033f, a         ;ac9a  61 03 3f
    movw mem_008b, a        ;ac9d  d5 8b
    mov mem_017c, a         ;ac9f  61 01 7c
    mov mem_0112, a         ;aca2  61 01 12     KW1281 9615.38 bps transmit state = Do nothing
    movw mem_0080, a        ;aca5  d5 80        New KW1281 state = Initial Connection
    movw mem_0114, a        ;aca7  d4 01 14
    mov mem_02d2, a         ;acaa  61 02 d2
    mov mem_033e, a         ;acad  61 03 3e
    mov mem_02d4, a         ;acb0  61 02 d4
    mov mem_0341, a         ;acb3  61 03 41
    mov a, mem_00fd         ;acb6  05 fd
    and a, #0xf0            ;acb8  64 f0
    bne lab_acbf            ;acba  fc 03
    call sub_acdb           ;acbc  31 ac db     UART transmit enabled, BRG enabled, rest disabled, send 0xFF

lab_acbf:
    setb mem_008b:3         ;acbf  ab 8b

    mov a, #0x01            ;acc1  04 01
    mov mem_0113, a         ;acc3  61 01 13

    movw a, #0xffff         ;acc6  e4 ff ff
    movw mem_008f, a        ;acc9  d5 8f

    mov mem_008a, a         ;accb  45 8a
    bbs mem_00e4:3, lab_acda ;accd  bb e4 0a
    bbc mem_00de:5, lab_acda ;acd0  b5 de 07
    mov a, #0x04            ;acd3  04 04
    mov mem_0096, a         ;acd5  45 96
    mov mem_00cd, #0x01     ;acd7  85 cd 01

lab_acda:
    ret                     ;acda  20

sub_acdb:
    mov uscr, #0b00110000   ;acdb  85 41 30     UART transmit enabled, baud rate generator started
                            ;                   everything else disabled
    mov txdr, #0xff         ;acde  85 43 ff     TODO what does sending 0xFF mean?
    ret                     ;ace1  20

sub_ace2:
    bbc mem_008b:0, lab_aced ;ace2  b0 8b 08
    clrb mem_008b:0          ;ace5  a0 8b
    bbc mem_008b:7, lab_acee ;ace7  b7 8b 04
    call sub_b20c_no_ack     ;acea  31 b2 0c

lab_aced:
    ret                     ;aced  20

lab_acee:
    call sub_ad15           ;acee  31 ad 15     KW1281 block title request dispatch
    mov mem_0080, a         ;acf1  45 80
    cmp a, #0x0d            ;acf3  14 0d        Block title = No Acknowledge?
    beq lab_ad02            ;acf5  fd 0b
    mov a, #0x00            ;acf7  04 00
    mov mem_033d, a         ;acf9  61 03 3d

lab_acfc:
    mov mem_0081, #0x01     ;acfc  85 81 01
    setb mem_008b:2         ;acff  aa 8b
    ret                     ;ad01  20

lab_ad02:
;Handle No Acknowledge
    mov a, mem_033d         ;ad02  60 03 3d
    cmp a, #0x05            ;ad05  14 05
    blo lab_acfc            ;ad07  f9 f3
    movw a, #0x0000         ;ad09  e4 00 00
    movw mem_0080, a        ;ad0c  d5 80        New KW1281 state = Initial Connection
    movw mem_0114, a        ;ad0e  d4 01 14
    mov mem_033d, a         ;ad11  61 03 3d
    ret                     ;ad14  20

sub_ad15:
;KW1281 block title request dispatch
    movw ix, #mem_ad1f      ;ad15  e6 ad 1f
    mov a, mem_0118+2       ;ad18  60 01 1a     KW1281 RX Buffer byte 2: Block title
    call sub_e757           ;ad1b  31 e7 57
    ret                     ;ad1e  20

mem_ad1f:
;KW1281 Block title request dispatch table
;
;mem_0080    Block title     Description
;0x01        0x00            ID code request/ECU Info
;0x03        0x09            Acknowledge
;0x04        0x07            Read Faults
;0x05        0x05            Clear Faults
;0x06        0x04            Actuator/Output Tests
;0x07        0x29            Group Reading
;0x08        0x10            Recoding
;0x09        0x2B            Login
;0x0A        0x01            Protected: Read RAM
;0x0B        0x03            Protected: Read ROM
;0x0C        0x19            Protected: Read EEPROM
;0x0D        0x0A            No Acknowledge
;0x0F        0x06            End Session
;0x10        0xF0            Read or write SAFE code word
;
    ;ID code request/ECU Info
    .byte 0x00              ;ad1f  00          DATA '\x00'  Block title 0x00
    .byte 0x01              ;ad20  01          DATA '\x01'  mem_0080 = 0x01
    .word lab_ad9f

    ;Protected: Read RAM
    .byte 0x01              ;ad23  01          DATA '\x01'  Block title 0x01
    .byte 0x0A              ;ad24  0a          DATA '\n'    mem_0080 = 0x0a
    .word lab_ada4

    ;Protected: Read ROM
    .byte 0x03              ;ad27  03          DATA '\x03'  Block title 0x03
    .byte 0x0B              ;ad28  0b          DATA '\x0b'  mem_0080 = 0x0b
    .word lab_ada4

    ;Actuator/Output Tests
    .byte 0x04              ;ad2b  04          DATA '\x04'  Block title 0x04
    .byte 0x06              ;ad2c  06          DATA '\x06'  mem_0080 = 0x06
    .word lab_ad82

    ;Clear Faults
    .byte 0x05              ;ad2f  05          DATA '\x05'  Block title 0x05
    .byte 0x05              ;ad30  05          DATA '\x05'  mem_0080 = 0x05
    .word lab_ad9f

    ;End Session
    .byte 0x06              ;ad33  06          DATA '\x06'  Block title 0x06
    .byte 0x0F              ;ad34  0f          DATA '\x0f'  mem_0080 = 0x0f
    .word lab_ad9f

    ;Read Faults
    .byte 0x07              ;ad37  07          DATA '\x07'  Block title 0x07
    .byte 0x04              ;ad38  04          DATA '\x04'  mem_0080 = 0x04
    .word lab_ad9f

    ;Acknowledge
    .byte 0x09              ;ad3b  09          DATA '\t'    Block title 0x09
    .byte 0x03              ;ad3c  03          DATA '\x03'  mem_0080 = 0x03
    .word lab_ad5e

    ;Recoding
    .byte 0x10              ;ad3f  10          DATA '\x10'  Block title 0x10
    .byte 0x08              ;ad40  08          DATA '\x08'  mem_0080 = 0x03
    .word lab_ad9f

    ;Protected: Read EEPROM
    .byte 0x19              ;ad43  19          DATA '\x19'  Block title 0x19
    .byte 0x0C              ;ad44  0c          DATA '\x0c'  mem_0080 = 0x0c
    .word lab_ada4

    ;Group Reading
    .byte 0x29              ;ad47  29          DATA ')'     Block title 0x29
    .byte 0x07              ;ad48  07          DATA '\x07'  mem_0080 = 0x07
    .word lab_ad8b

    ;Login
    .byte 0x2B              ;ad4b  2b          DATA '+'     Block title 0x2b
    .byte 0x09              ;ad4c  09          DATA '\t'    mem_0080 = 0x09
    .word lab_ad9f

    ;No Acknowledge
    .byte 0x0A              ;ad4f  0a          DATA '\n'    Block title 0x0a
    .byte 0x0D              ;ad50  0d          DATA '\r'    mem_0080 = 0x0d
    .word lab_ad9f

    ;Read or write SAFE code word
    .byte 0xF0              ;ad53  f0          DATA '\xf0'  Block title 0x0f
    .byte 0x10              ;ad54  10          DATA '\x10'  mem_0080 = 0x10
    .word lab_ad9f

    ;End of table (Not a block title)
    .byte 0xFF              ;ad57  ff          DATA '\xff'  0xFF = End of table marker
    .byte 0x0E              ;ad58  0e          DATA '\x0e'  mem_0080 = 0x0E
    .word lab_ad5b

lab_ad5b:
;Table mem_ad1f case for end of table
    mov a, #0x0e            ;ad5b  04 0e
    ret                     ;ad5d  20

lab_ad5e:
;Table mem_ad1f case for:
;  Block title 0x09: Acknowledge
    mov a, mem_033f         ;ad5e  60 03 3f
    mov a, #0x03            ;ad61  04 03
    cmp a                   ;ad63  12
    bne lab_ad69            ;ad64  fc 03
    call sub_adac           ;ad66  31 ad ac

lab_ad69:
    mov a, #0x00            ;ad69  04 00
    mov mem_0341, a         ;ad6b  61 03 41
    mov mem_033f, a         ;ad6e  61 03 3f
    mov mem_019b, a         ;ad71  61 01 9b
    clrb mem_008e:4         ;ad74  a4 8e
    clrb mem_008d:4         ;ad76  a4 8d
    clrb mem_008e:3         ;ad78  a3 8e
    bbc mem_008e:0, lab_ad7f ;ad7a  b0 8e 02
    setb mem_008e:1         ;ad7d  a9 8e

lab_ad7f:
    mov a, #0x03            ;ad7f  04 03
    ret                     ;ad81  20

lab_ad82:
;Table mem_ad1f case for:
;  Block title 0x04: Actuator/Output Tests
    xchw a, t               ;ad82  43
    bbc mem_008c:1, lab_ad8a ;ad83  b1 8c 04
    clrb mem_008c:1         ;ad86  a1 8c
    mov a, #0x03            ;ad88  04 03

lab_ad8a:
    ret                     ;ad8a  20

lab_ad8b:
;Table mem_ad1f case for:
;  Block title 0x29: Group Reading
    xchw a, t               ;ad8b  43
    pushw a                 ;ad8c  40
    mov a, mem_0118+3       ;ad8d  60 01 1b     KW1281 RX Buffer byte 3: Group number
    cmp a, #0x02            ;ad90  14 02
    beq lab_ad99            ;ad92  fd 05
    mov a, #0x00            ;ad94  04 00
    mov mem_019b, a         ;ad96  61 01 9b

lab_ad99:
;Group 2 (Speakers)
    setb mem_008d:4         ;ad99  ac 8d
    clrb mem_008e:1         ;ad9b  a1 8e
    popw a                  ;ad9d  50
    ret                     ;ad9e  20

lab_ad9f:
;Table mem_ad1f case for unprotected functions:
;
;  Block title 0x00: ID code request/ECU Info
;  Block title 0x05: Clear Faults
;  Block title 0x06: End Session
;  Block title 0x07: Read Faults
;  Block title 0x10: Recoding
;  Block title 0x2b: Login
;  Block title 0x0a: No Acknowledge
;  Block title 0xf0: Read or write SAFE code word
;
    xchw a, t               ;ad9f  43
    ret                     ;ada0  20

lab_ada1:
    mov a, #0x0e            ;ada1  04 0e        0x0E = mem_0080 value for No Acknowledge
    ret                     ;ada3  20

lab_ada4:
;Table mem_ad1f case for protected functions:
;
;  Block title 0x01: Protected: Read RAM
;  Block title 0x03: Protected: Read ROM
;  Block title 0x19: Protected: Read EEPROM
;
    bbc mem_008c:3, lab_ada1 ;ada4  b3 8c fa    Bit is set after Group Reading of Group 25 (0x19)
    bbc mem_00e4:6, lab_ada1 ;ada7  b6 e4 f7    Bit is set after successful KW1281 Login
    xchw a, t                ;adaa  43
    ret                      ;adab  20

sub_adac:
    bbs mem_008d:1, lab_add6 ;adac  b9 8d 27
    mov a, mem_02e0         ;adaf  60 02 e0
    beq lab_adc1            ;adb2  fd 0d
    cmp a, #0xff            ;adb4  14 ff
    beq lab_add3            ;adb6  fd 1b
    cmp a, #0x02            ;adb8  14 02
    beq lab_adcb            ;adba  fd 0f
    cmp a, #0x01            ;adbc  14 01
    beq lab_adcb            ;adbe  fd 0b
    ret                     ;adc0  20

lab_adc1:
    mov a, mem_0329         ;adc1  60 03 29
    bne lab_add3            ;adc4  fc 0d
    mov a, mem_031f         ;adc6  60 03 1f
    beq lab_add3            ;adc9  fd 08

lab_adcb:
    clrb pdr2:0             ;adcb  a0 04        PHANTON_ON=low
    mov a, #0x14            ;adcd  04 14
    mov mem_02e1, a         ;adcf  61 02 e1
    ret                     ;add2  20

lab_add3:
    setb pdr2:0             ;add3  a8 04        PHANTON_ON=high
    ret                     ;add5  20

lab_add6:
    mov a, mem_02e0         ;add6  60 02 e0
    beq lab_add3            ;add9  fd f8
    cmp a, #0xff            ;addb  14 ff
    beq lab_add3            ;addd  fd f4
    bne lab_adcb            ;addf  fc ea        BRANCH_ALWAYS_TAKEN

sub_ade1:
    mov a, mem_0114         ;ade1  60 01 14
    cmp a, #0x02            ;ade4  14 02
    beq lab_aded            ;ade6  fd 05
    cmp a, #0x03            ;ade8  14 03
    beq lab_ae44            ;adea  fd 58

lab_adec:
    ret                     ;adec  20

lab_aded:
    mov a, mem_0082         ;aded  05 82        A = count of KW1281 bytes received
    beq lab_adf6            ;adef  fd 05
    mov a, mem_032e         ;adf1  60 03 2e
    beq lab_ae35            ;adf4  fd 3f

lab_adf6:
    bbc mem_008b:4, lab_adec ;adf6  b4 8b f3
    clrb mem_008b:4         ;adf9  a4 8b
    mov a, #0x00            ;adfb  04 00
    mov mem_033e, a         ;adfd  61 03 3e
    call sub_b235           ;ae00  31 b2 35     Store byte received in KW1281 RX Buffer
    bbc mem_008b:6, lab_adec ;ae03  b6 8b e6

    mov a, mem_0118+0       ;ae06  60 01 18     KW1281 RX Buffer byte 0: Block length
    cmp a, #0x10            ;ae09  14 10
    bhs lab_ae35            ;ae0b  f8 28

    mov a, mem_0118+0       ;ae0d  60 01 18     KW1281 RX Buffer byte 0: Block length
    cmp a, mem_0082         ;ae10  15 82        Compare to count of KW1281 bytes received
    bhs lab_ae2a            ;ae12  f8 16

    mov a, mem_0088         ;ae14  05 88        A = KW1281 byte received
    cmp a, #0x03            ;ae16  14 03
    beq lab_ae1c            ;ae18  fd 02
    setb mem_008b:7         ;ae1a  af 8b

lab_ae1c:
    clrb uscr:1             ;ae1c  a1 41        Disable UART receive interrupt
    mov a, mem_0118+1       ;ae1e  60 01 19     KW1281 RX Buffer byte 1: Block counter
    mov mem_0116, a         ;ae21  61 01 16     Copy block counter into mem_0116
    setb mem_008b:0         ;ae24  a8 8b
    mov a, #0x00            ;ae26  04 00
    beq lab_ae31            ;ae28  fd 07        BRANCH_ALWAYS_TAKEN

lab_ae2a:
    mov a, #0x05            ;ae2a  04 05
    mov mem_032e, a         ;ae2c  61 03 2e
    mov a, #0x03            ;ae2f  04 03

lab_ae31:
    mov mem_0114, a         ;ae31  61 01 14
    ret                     ;ae34  20

lab_ae35:
    mov mem_0082, #0x00     ;ae35  85 82 00     Reset count of KW1281 bytes received
    clrb mem_008c:4         ;ae38  a4 8c
    clrb mem_008b:6         ;ae3a  a6 8b
    clrb mem_008b:7         ;ae3c  a7 8b
    mov a, #0x66            ;ae3e  04 66
    mov mem_032e, a         ;ae40  61 03 2e
    ret                     ;ae43  20

lab_ae44:
    mov a, mem_032e         ;ae44  60 03 2e
    bne lab_adec            ;ae47  fc a3

    mov a, mem_0088         ;ae49  05 88        A = KW1281 byte received
    xor a, #0xff            ;ae4b  54 ff        Complement it
    mov mem_0089, a         ;ae4d  45 89        KW1281 byte to send = A

    mov a, #0x02            ;ae4f  04 02
    mov mem_0114, a         ;ae51  61 01 14
    setb mem_008c:4         ;ae54  ac 8c
    clrb mem_008b:6         ;ae56  a6 8b
    clrb mem_008b:7         ;ae58  a7 8b

    mov rrdr, #0x0d         ;ae5a  85 45 0d     UART Baud Rate = 9615.38 bps @ 8.0 MHz

    mov usmr, #0b00001011   ;ae5d  85 40 0b     UART Parameters = 8-N-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 0   Parity unavailable
                            ;                   5   Parity polarity = 0   Even parity (don't care)
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 1   8-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

    mov a, mem_0089         ;ae60  05 89        A = KW1281 byte to send
    mov txdr, a             ;ae62  45 43        Send KW1281 byte out UART

    mov a, #0x33            ;ae64  04 33
    mov mem_032e, a         ;ae66  61 03 2e
    ret                     ;ae69  20

sub_ae6a:
    mov a, mem_0115         ;ae6a  60 01 15     A = table index
    movw a, #mem_ae73       ;ae6d  e4 ae 73     A = table base address
    jmp sub_e73c            ;ae70  21 e7 3c     Jump to address in table

mem_ae73:
    .word lab_ae98          ;ae73  ae 98       VECTOR
    .word lab_ae83          ;ae75  ae 83       VECTOR
    .word lab_ae99          ;ae77  ae 99       VECTOR
    .word lab_aefe          ;ae79  ae fe       VECTOR
    .word lab_af0a          ;ae7b  af 0a       VECTOR
    .word lab_af1e          ;ae7d  af 1e       VECTOR
    .word lab_af65          ;ae7f  af 65       VECTOR
    .word lab_af7d          ;ae81  af 7d       VECTOR

lab_ae83:
;(mem_0115 = 1)
    mov a, mem_032e         ;ae83  60 03 2e
    bne lab_ae98            ;ae86  fc 10
    call sub_b24b           ;ae88  31 b2 4b
    mov a, #0x36            ;ae8b  04 36
    mov mem_032e, a         ;ae8d  61 03 2e

    mov a, #0x02            ;ae90  04 02
    mov mem_0112, a         ;ae92  61 01 12     KW1281 9615.38 bps transmit state = Send byte, 8-N-1

    mov mem_0115, a         ;ae95  61 01 15

lab_ae98:
;(mem_0115 = 0)
    ret                     ;ae98  20

lab_ae99:
;(mem_0115 = 2)
    mov a, mem_032e         ;ae99  60 03 2e
    beq lab_aed6            ;ae9c  fd 38
    bbc mem_008b:4, lab_ae98 ;ae9e  b4 8b f7
    clrb mem_008b:4         ;aea1  a4 8b
    call sub_b235           ;aea3  31 b2 35     Store byte received in KW1281 RX Buffer

    mov a, mem_012b+0       ;aea6  60 01 2b     KW1281 TX Buffer byte 0: Block length
    cmp a, mem_0083         ;aea9  15 83        Compare to count of KW1281 bytes sent
    bhs lab_aeb5            ;aeab  f8 08

    setb mem_008b:1         ;aead  a9 8b
    mov a, #0x00            ;aeaf  04 00        A = value to store in mem_0082 and mem_0115
    mov mem_0082, a         ;aeb1  45 82        Reset count of KW1281 bytes received
    beq lab_af1a            ;aeb3  fd 65        BRANCH_ALWAYS_TAKEN

lab_aeb5:
    mov a, mem_0089         ;aeb5  05 89        A = KW1281 byte to send
    mov a, mem_0088         ;aeb7  05 88        A = KW1281 byte received
    xor a                   ;aeb9  52
    cmp a, #0xff            ;aeba  14 ff        Is mem_0089 the complement of mem_0088?
    bne lab_aec7            ;aebc  fc 09          No: KW1281 byte check error

    ;KW1281 byte check passed
    mov a, #0x05            ;aebe  04 05
    mov mem_032e, a         ;aec0  61 03 2e
    mov a, #0x01            ;aec3  04 01        A = value to store in mem_0115
    bne lab_af1a            ;aec5  fc 53        BRANCH_ALWAYS_TAKEN

lab_aec7:
;KW1281 byte check error
    mov a, mem_033e         ;aec7  60 03 3e
    incw a                  ;aeca  c0
    mov mem_033e, a         ;aecb  61 03 3e
    cmp a, #0x0b            ;aece  14 0b
    bhs lab_aef6            ;aed0  f8 24
    mov a, #0x61            ;aed2  04 61
    bne lab_aeef            ;aed4  fc 19        BRANCH_ALWAYS_TAKEN

lab_aed6:
    mov a, mem_033e         ;aed6  60 03 3e
    bne lab_aee2            ;aed9  fc 07
    mov a, mem_033e         ;aedb  60 03 3e
    incw a                  ;aede  c0
    mov mem_033e, a         ;aedf  61 03 3e

lab_aee2:
    mov a, mem_033e         ;aee2  60 03 3e
    incw a                  ;aee5  c0
    mov mem_033e, a         ;aee6  61 03 3e
    cmp a, #0x0b            ;aee9  14 0b
    bhs lab_aef6            ;aeeb  f8 09
    mov a, #0x2d            ;aeed  04 2d

lab_aeef:
    mov mem_032e, a         ;aeef  61 03 2e
    mov a, #0x07            ;aef2  04 07        A = value to store in mem_0115
    bne lab_af1a            ;aef4  fc 24        BRANCH_ALWAYS_TAKEN

lab_aef6:
    mov a, #0x00            ;aef6  04 00
    mov mem_0080, a         ;aef8  45 80        New KW1281 state = Initial Connection
    mov mem_0115, a         ;aefa  61 01 15
    ret                     ;aefd  20

lab_aefe:
;(mem_0115 = 3)
    call sub_b24b           ;aefe  31 b2 4b

    mov a, #0x02            ;af01  04 02
    mov mem_0112, a         ;af03  61 01 12     KW1281 9615.38 bps transmit state = Send byte, 8-N-1

    mov a, #0x04            ;af06  04 04        A = value to store in mem_0115
    bne lab_af1a            ;af08  fc 10        BRANCH_ALWAYS_TAKEN

lab_af0a:
;(mem_0115 = 4)
    bbc mem_008b:4, lab_af1d ;af0a  b4 8b 10
    clrb mem_008b:4         ;af0d  a4 8b
    cmp mem_0083, #0x03     ;af0f  95 83 03     Count of KW1281 bytes sent = 3?
    bne lab_af18            ;af12  fc 04
    mov a, #0x05            ;af14  04 05        A = value to store in mem_0115
    bne lab_af1a            ;af16  fc 02        BRANCH_ALWAYS_TAKEN

lab_af18:
    mov a, #0x03            ;af18  04 03        A = value to store in mem_0115

lab_af1a:
    mov mem_0115, a         ;af1a  61 01 15

lab_af1d:
    ret                     ;af1d  20

lab_af1e:
;(mem_0115 = 5)
    mov a, mem_012b+0       ;af1e  60 01 2b     KW1281 TX Buffer byte 0: Block length
    cmp a, mem_0083         ;af21  15 83        Compare to count of KW1281 bytes sent
    bne lab_af34            ;af23  fc 0f

    clrb mem_008c:4         ;af25  a4 8c

    movw a, #mem_012b+3     ;af27  e4 01 2e     A = Pointer to KW1281 TX Buffer byte 3
    movw mem_0147, a        ;af2a  d4 01 47     Store pointer in mem_0147

    mov a, #0x0a            ;af2d  04 0a        New KW1281 state = Protected: Read RAM
    mov mem_0080, a         ;af2f  45 80

    jmp lab_af36            ;af31  21 af 36

lab_af34:
    setb mem_008c:4         ;af34  ac 8c

lab_af36:
    clrb mem_008b:4         ;af36  a4 8b
    setb uscr:1             ;af38  a9 41        Enable UART receive interrupt

    mov a, mem_0080         ;af3a  05 80
    cmp a, #0x0c            ;af3c  14 0c        0x0C = mem_0080 value for KW1281 Protected: Read EEPROM
    bne lab_af46            ;af3e  fc 06

    ;mem_0080 = 0x0c: read eeprom
    call sub_cb72           ;af40  31 cb 72     Read byte from EEPROM, store it in mem_0089
    jmp lab_af50            ;af43  21 af 50

lab_af46:
    ;mem_0080 != 0x0c: read memory
    movw a, mem_0147        ;af46  c4 01 47     A = pointer to memory to dump

    movw mem_0086, a        ;af49  d5 86        Store pointer in mem_0086
    movw a, mem_0086        ;af4b  c5 86        A = Reload pointer again (why?)

    mov a, @a               ;af4d  92           A = Read memory to dump at pointer
    mov mem_0089, a         ;af4e  45 89        KW1281 byte to send = A

lab_af50:
    mov a, mem_0083         ;af50  05 83        Increment count of KW1281 bytes sent
    incw a                  ;af52  c0
    mov mem_0083, a         ;af53  45 83

    movw a, mem_0147        ;af55  c4 01 47     Increment pointer to memory being dumped
    incw a                  ;af58  c0
    movw mem_0147, a        ;af59  d4 01 47

    mov a, #0x02            ;af5c  04 02
    mov mem_0112, a         ;af5e  61 01 12     KW1281 9615.38 bps transmit state = Send byte, 8-N-1

    mov a, #0x06            ;af61  04 06        A = value to store in mem_0115
    bne lab_af1a            ;af63  fc b5        BRANCH_ALWAYS_TAKEN

lab_af65:
;(mem_0115 = 6)
    bbc mem_008b:4, lab_af1d ;af65  b4 8b b5
    clrb mem_008b:4         ;af68  a4 8b

    mov a, mem_012b+0       ;af6a  60 01 2b     KW1281 TX Buffer byte 0: Block length
    cmp a, mem_0083         ;af6d  15 83        Compare to count of KW1281 bytes sent
    bhs lab_af79            ;af6f  f8 08

    mov a, #0x00            ;af71  04 00        A = value to store in mem_0082 and mem_0115
    mov mem_0082, a         ;af73  45 82        Reset count of KW1281 bytes received
    setb mem_008b:1         ;af75  a9 8b
    beq lab_af1a            ;af77  fd a1        BRANCH_ALWAYS_TAKEN

lab_af79:
    mov a, #0x05            ;af79  04 05        A = value to store in mem_0115
    bne lab_af1a            ;af7b  fc 9d        BRANCH_ALWAYS_TAKEN

lab_af7d:
;(mem_0115 = 7)
    mov a, mem_032e         ;af7d  60 03 2e
    beq lab_af1d            ;af80  fd 9b
    call reset_kw_counts    ;af82  31 e0 b8     Reset counts of KW1281 bytes received, sent
    mov a, #0x01            ;af85  04 01        A = value to store in mem_0115
    bne lab_af1a            ;af87  fc 91        BRANCH_ALWAYS_TAKEN

sub_af89:
;Send KW1281 byte at 9615.38 bps or do nothing
    mov a, mem_0112         ;af89  60 01 12
    cmp a, #0x01            ;af8c  14 01        Send byte at 9615.38 bps, 7-O-1
    beq lab_af95            ;af8e  fd 05
    cmp a, #0x02            ;af90  14 02        Send byte at 9615.38 bps, 8-N-1
    beq lab_afa2            ;af92  fd 0e
    ret                     ;af94  20           Otherwise, do nothing

lab_af95:
;(mem_0112=1)
    mov rrdr, #0x0d         ;af95  85 45 0d     UART Baud Rate = 9615.38 bps @ 8.0 MHz

    mov usmr, #0b01100011   ;af98  85 40 63     UART Parameters = 7-O-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 1   Parity available
                            ;                   5   Parity polarity = 1   Odd parity
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 0   7-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

    mov a, rxdr             ;af9b  05 43        A = KW1281 byte received from UART
    mov mem_009e, a         ;af9d  45 9e
    jmp lab_afa8            ;af9f  21 af a8

lab_afa2:
;(mem_0112=2)
    mov rrdr, #0x0d         ;afa2  85 45 0d     UART Baud Rate = 9615.38 bps @ 8.0 MHz

    mov usmr, #0b00001011   ;afa5  85 40 0b     UART Parameters = 8-N-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 0   Parity unavailable
                            ;                   5   Parity polarity = 0   Even parity (don't care)
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 1   8-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

lab_afa8:
    clrb uscr:7             ;afa8  a7 41        Clear all UART receive error flags
    setb uscr:6             ;afaa  ae 41        Enable UART receiving
    setb uscr:5             ;afac  ad 41        Enable UART transmitting
    setb uscr:4             ;afae  ac 41        Start baud rate generator
    setb uscr:3             ;afb0  ab 41        UART TXOE = Serial data output enabled

    mov a, mem_0089         ;afb2  05 89        A = KW1281 byte to send
    mov txdr, a             ;afb4  45 43        Send KW1281 byte out UART

    clrb mem_008b:6         ;afb6  a6 8b
    clrb mem_008b:7         ;afb8  a7 8b
    setb uscr:1             ;afba  a9 41        Enable UART receive interrupt

    mov a, #0x00            ;afbc  04 00
    mov mem_0112, a         ;afbe  61 01 12     KW1281 9615.38 bps transmit state = Do nothing

    ret                     ;afc1  20

sub_afc2:
    clrb mem_00e6:1         ;afc2  a1 e6
    mov mem_02c7, a         ;afc4  61 02 c7
    setb mem_00e6:1         ;afc7  a9 e6
    ret                     ;afc9  20

sub_afca:
    bbc mem_008c:7, lab_afce ;afca  b7 8c 01
    ret                     ;afcd  20

lab_afce:
    clrb mem_008b:3         ;afce  a3 8b
    bbc pdr7:3, lab_afd5    ;afd0  b3 13 02     Branch if UART RX=low
    setb mem_008b:3         ;afd3  ab 8b

lab_afd5:
    mov a, mem_0113         ;afd5  60 01 13
    cmp a, #0x01            ;afd8  14 01
    bne lab_afdf            ;afda  fc 03
    jmp lab_afeb            ;afdc  21 af eb

lab_afdf:
    cmp a, #0x02            ;afdf  14 02
    bne lab_afe6            ;afe1  fc 03
    jmp lab_affe            ;afe3  21 af fe

lab_afe6:
    cmp a, #0x03            ;afe6  14 03
    beq lab_b02c            ;afe8  fd 42
    ret                     ;afea  20

lab_afeb:
;(mem_0113 = 1)
    bbs mem_008b:3, lab_affd ;afeb  bb 8b 0f
    mov a, #0x09            ;afee  04 09
    mov mem_0110, a         ;aff0  61 01 10
    mov a, #0x0a            ;aff3  04 0a
    mov mem_0111, a         ;aff5  61 01 11
    mov a, #0x02            ;aff8  04 02
    mov mem_0113, a         ;affa  61 01 13

lab_affd:
    ret                     ;affd  20

lab_affe:
;(mem_0113 = 2)
    mov a, mem_0110         ;affe  60 01 10
    decw a                  ;b001  d0
    mov mem_0110, a         ;b002  61 01 10

    cmp a, #0x00            ;b005  14 00
    bne lab_b02b            ;b007  fc 22

    mov a, #0x19            ;b009  04 19
    mov mem_0110, a         ;b00b  61 01 10

    clrc                    ;b00e  81
    bbc mem_008b:3, lab_b013 ;b00f  b3 8b 01
    setc                    ;b012  91

lab_b013:
    ;16-bit rotate right from carry into word at mem_008f
    movw a, mem_008f        ;b013  c5 8f
    swap                    ;b015  10       Swap:   AH<->AL
    rorc a                  ;b016  03       Rotate: carry -> AL -> carry
    swap                    ;b017  10       Swap:   AH<->AL
    rorc a                  ;b018  03       Rotate: carry -> AL -> carry
    movw mem_008f, a        ;b019  d5 8f

    mov a, mem_0111         ;b01b  60 01 11
    decw a                  ;b01e  d0
    mov mem_0111, a         ;b01f  61 01 11

    cmp a, #0x00            ;b022  14 00
    bne lab_b02b            ;b024  fc 05

    mov a, #0x03            ;b026  04 03
    mov mem_0113, a         ;b028  61 01 13

lab_b02b:
    ret                     ;b02b  20

lab_b02c:
;(mem_0113=3)
    movw a, mem_008f        ;b02c  c5 8f
    movw a, #0xffc0         ;b02e  e4 ff c0
    andw a                  ;b031  63
    movw a, #0xeb00         ;b032  e4 eb 00
    cmpw a                  ;b035  13
    bne lab_b07f            ;b036  fc 47

    clrb uscr:7             ;b038  a7 41        Clear all UART receive error flags
    mov a, rxdr             ;b03a  05 43        A = KW1281 byte received from UART (thrown away)

    mov a, #0x00            ;b03c  04 00
    mov mem_01a1, a         ;b03e  61 01 a1

    bbs mem_00cf:5, lab_b052 ;b041  bd cf 0e
    bbs mem_00eb:6, lab_b081 ;b044  be eb 3a
    bbs mem_00ed:2, lab_b052 ;b047  ba ed 08
    mov mem_00d2, #0x01     ;b04a  85 d2 01
    mov a, #0x01            ;b04d  04 01
    mov mem_01a1, a         ;b04f  61 01 a1

lab_b052:
    mov mem_0080, #0x00     ;b052  85 80 00     New KW1281 state = Initial Connection
    setb mem_008c:7         ;b055  af 8c
    mov a, #0x00            ;b057  04 00
    mov mem_017c, a         ;b059  61 01 7c
    setb mem_008b:2         ;b05c  aa 8b
    mov mem_0081, #0x01     ;b05e  85 81 01
    mov a, #0x00            ;b061  04 00
    mov mem_031b, a         ;b063  61 03 1b
    mov a, #0x02            ;b066  04 02
    mov mem_031c, a         ;b068  61 03 1c

    mov a, #0x41            ;b06b  04 41        A = value to store in mem_02c7
    call sub_afc2           ;b06d  31 af c2

    mov mem_00cc, #0x0a     ;b070  85 cc 0a

    mov a, mem_0095         ;b073  05 95
    cmp a, #0x02            ;b075  14 02
    bne lab_b081            ;b077  fc 08

    mov mem_00ce, #0x04     ;b079  85 ce 04
    jmp lab_b081            ;b07c  21 b0 81

lab_b07f:
    setb mem_008b:7         ;b07f  af 8b

lab_b081:
    mov a, #0x01            ;b081  04 01
    mov mem_0113, a         ;b083  61 01 13

    movw a, #0xffff         ;b086  e4 ff ff
    movw mem_008f, a        ;b089  d5 8f

    setb mem_008b:3         ;b08b  ab 8b

    movw a, #0x0000         ;b08d  e4 00 00
    movw mem_0110, a        ;b090  d4 01 10

    ret                     ;b093  20


mem_0080_is_00:
;KW1281 Initial Connection
    mov a, mem_0081         ;b094  05 81
    cmp a, #0x01            ;b096  14 01        Send 0x55
    beq lab_b0a7_tx_0x55    ;b098  fd 0d
    cmp a, #0x02            ;b09a  14 02        Send 0x01
    beq lab_b0a7_tx_0x01    ;b09c  fd 1c
    cmp a, #0x03            ;b09e  14 03        Send 0x0A
    beq lab_b0a7_tx_0x0a    ;b0a0  fd 30
    cmp a, #0x04            ;b0a2  14 04        Check if 0x75 received
    beq lab_b0a7_rx_0x75    ;b0a4  fd 46
    ret                     ;b0a6  20

lab_b0a7_tx_0x55:
;Initial Connection related: Send 0x55
;(mem_0080=0, mem_0081=1)
    bbs mem_00e6:1, lab_b0d1 ;b0a7  b9 e6 27

    mov mem_0089, #0x55     ;b0aa  85 89 55     KW1281 byte to send = 0x55

    mov a, #0x02            ;b0ad  04 02
    mov mem_0112, a         ;b0af  61 01 12     KW1281 9615.38 bps transmit state = Send byte, 8-N-1

    clrb mem_008c:4         ;b0b2  a4 8c

    mov mem_0081, a         ;b0b4  45 81        Set mem_0081 = 2

    mov a, #0x03            ;b0b6  04 03        A = value to store in mem_02c7
    bne lab_b0ce            ;b0b8  fc 14        BRANCH_ALWAYS_TAKEN

lab_b0a7_tx_0x01:
;Initial Connection related: Send 0x01
;(mem_0080=0, mem_0081=2)
    bbs mem_00e6:1, lab_b0d1 ;b0ba  b9 e6 14
    bbc mem_008b:4, lab_b0d1 ;b0bd  b4 8b 11

    mov a, #0x01            ;b0c0  04 01
    mov mem_0089, a         ;b0c2  45 89        KW1281 byte to send = 0x01
    mov mem_0112, a         ;b0c4  61 01 12     KW1281 9615.38 bps transmit state = Send byte, 7-O-1

    clrb mem_008c:4         ;b0c7  a4 8c

    mov mem_0081, #0x03     ;b0c9  85 81 03     Set mem_0081 = 3

    mov a, #0x03            ;b0cc  04 03        A = value to store in mem_02c7

lab_b0ce:
    call sub_afc2           ;b0ce  31 af c2

lab_b0d1:
    ret                     ;b0d1  20

lab_b0a7_tx_0x0a:
;Initial Connection related: Send 0x0A
;(mem_0080=0, mem_0081=3)
    bbs mem_00e6:1, lab_b0d1 ;b0d2  b9 e6 fc
    bbc mem_008b:4, lab_b0eb ;b0d5  b4 8b 13
    clrb mem_008b:4         ;b0d8  a4 8b

    mov mem_0089, #0x0a     ;b0da  85 89 0a     KW1281 byte to send = 0x0a

    mov a, #0x01            ;b0dd  04 01
    mov mem_0112, a         ;b0df  61 01 12     KW1281 9615.38 bps transmit state = Send byte, 7-O-1

    setb mem_008c:4         ;b0e2  ac 8c

    mov mem_0081, #0x04     ;b0e4  85 81 04     Set mem_0081 = 4

    mov a, #0x0c            ;b0e7  04 0c        A = value to store in mem_02c7
    bne lab_b0ce            ;b0e9  fc e3        BRANCH_ALWAYS_TAKEN

lab_b0eb:
    ret                     ;b0eb  20

lab_b0a7_rx_0x75:
;Initial Connection related: Check if 0x75 received
;(mem_0080=0, mem_0081=4)
    bbc mem_00e6:1, lab_b10a ;b0ec  b1 e6 1b
    bbc mem_008b:4, lab_b0eb ;b0ef  b4 8b f9
    bbc mem_008b:6, lab_b0eb ;b0f2  b6 8b f6

    ;Check for 0x75 response during Initial Connection
    ;  mem_0088 = 0x75
    ;  hex((mem_0088 ^ 0xFF) & 0x7F) #=> 0x0A
    mov a, mem_0088         ;b0f5  05 88        A = KW1281 byte received
    xor a, #0xff            ;b0f7  54 ff
    and a, #0x7f            ;b0f9  64 7f
    cmp a, #0x0a            ;b0fb  14 0a
    bne lab_b10a            ;b0fd  fc 0b        Initial Connection error

    ;Response 0x75 received, Initial Connection is complete
    setb mem_008e:7         ;b0ff  af 8e
    setb mem_0098:4         ;b101  ac 98
    mov a, #0x01            ;b103  04 01        New KW1281 state = ID code request/ECU Info
    mov mem_0080, a         ;b105  45 80
    mov mem_0081, a         ;b107  45 81
    ret                     ;b109  20

lab_b10a:
;Initial Connection error
    movw a, #0x0000         ;b10a  e4 00 00
    mov a, mem_031c         ;b10d  60 03 1c
    decw a                  ;b110  d0
    mov mem_031c, a         ;b111  61 03 1c
    beq lab_b11d            ;b114  fd 07
    call sub_b129           ;b116  31 b1 29     New KW1281 state = Initial Connection
    mov a, #0x34            ;b119  04 34        A = value to store in mem_02c7
    bne lab_b0ce            ;b11b  fc b1        BRANCH_ALWAYS_TAKEN

lab_b11d:
    setb mem_008c:6         ;b11d  ae 8c
    call sub_ac83           ;b11f  31 ac 83
    ret                     ;b122  20

sub_b123:
    mov mem_0080, #0x01     ;b123  85 80 01     New KW1281 state = ID code request/ECU Info
    jmp lab_b12c            ;b126  21 b1 2c

sub_b129:
    mov mem_0080, #0x00     ;b129  85 80 00     New KW1281 state = Initial Connection

lab_b12c:
    mov mem_0081, #0x01     ;b12c  85 81 01
    setb mem_008b:2         ;b12f  aa 8b
    clrb mem_008b:4         ;b131  a4 8b
    clrb mem_008b:6         ;b133  a6 8b
    ret                     ;b135  20

sub_b136:
;Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer
;
;mem_0084 = Pointer to buffer to read
;mem_00a5 = Number of bytes to copy
;
    movw a, #mem_012b       ;b136  e4 01 2b     A = Pointer to KW1281 TX Buffer byte 0
    movw mem_0086, a        ;b139  d5 86        Store pointer in mem_0086
    jmp sub_b13e            ;b13b  21 b1 3e     Copy mem_00a5 bytes from @mem_0084 to @mem_0086

sub_b13e:
;Copy mem_00a5 bytes from @mem_0084 to @mem_0086
;
;mem_0084 = Pointer to buffer to read
;mem_0086 = Pointer to buffer to write
;mem_00a5 = Number of bytes to copy
;
    mov a, mem_00a5         ;b13e  05 a5        A = number of bytes in KW1281 packet
    bne lab_b143            ;b140  fc 01
    ret                     ;b142  20

lab_b143:
    movw a, mem_0084        ;b143  c5 84        A = Pointer to KW1281 packet bytes
    mov a, @a               ;b145  92           A = byte in packet
    movw a, mem_0086        ;b146  c5 86
    mov @a, t               ;b148  82
    incw a                  ;b149  c0
    movw mem_0086, a        ;b14a  d5 86

    movw a, mem_0084        ;b14c  c5 84
    incw a                  ;b14e  c0
    movw mem_0084, a        ;b14f  d5 84        Pointer to KW1281 packet bytes

    mov a, mem_00a5         ;b151  05 a5        A = number of bytes in KW1281 packet
    decw a                  ;b153  d0
    mov mem_00a5, a         ;b154  45 a5

    jmp sub_b13e            ;b156  21 b1 3e     Copy mem_00a5 bytes from @mem_0084 to @mem_0086

lab_b159:
    mov a, @ix+0x00         ;b159  06 00
    mov @ep, a              ;b15b  47
    incw ix                 ;b15c  c2
    incw ep                 ;b15d  c3
    movw a, #0x0000         ;b15e  e4 00 00
    mov a, mem_00a5         ;b161  05 a5        A = number of bytes in KW1281 packet
    decw a                  ;b163  d0
    mov mem_00a5, a         ;b164  45 a5

sub_b166:
    mov a, mem_00a5         ;b166  05 a5        A = number of bytes in KW1281 packet
    bne lab_b159            ;b168  fc ef
    ret                     ;b16a  20

sub_b16b_ack:
    mov mem_00a5, #0x04     ;b16b  85 a5 04     4 bytes in KW1281 packet
    movw a, #kw_ack         ;b16e  e4 ff 40
    movw mem_0084, a        ;b171  d5 84        Pointer to KW1281 packet bytes
    call sub_bbab           ;b173  31 bb ab
    ret                     ;b176  20


mem_0080_is_03:
;KW1281 Acknowledge
    mov a, mem_0081         ;b177  05 81
    cmp a, #0x01            ;b179  14 01
    beq lab_b182            ;b17b  fd 05
    cmp a, #0x02            ;b17d  14 02
    beq lab_b1fe            ;b17f  fd 7d
    ret                     ;b181  20

lab_b182:
;Acknowledge related
;(mem_0080=0x03, mem_0081=1)
    call sub_b16b_ack       ;b182  31 b1 6b
    mov mem_0081, #0x02     ;b185  85 81 02
    ret                     ;b188  20


mem_0080_is_0d:
;KW1281 No Acknowledge
    mov a, mem_0081         ;b189  05 81
    cmp a, #0x01            ;b18b  14 01
    beq lab_b194            ;b18d  fd 05
    cmp a, #0x02            ;b18f  14 02
    beq lab_b1fe            ;b191  fd 6b
    ret                     ;b193  20

lab_b194:
;No Acknowledge related
;(mem_0080=0x0d, mem_0081=1)
    mov a, mem_033d         ;b194  60 03 3d
    incw a                  ;b197  c0
    mov mem_033d, a         ;b198  61 03 3d
    mov a, mem_0118+1       ;b19b  60 01 19     KW1281 RX Buffer byte 1: Block counter
    mov a, mem_0118+3       ;b19e  60 01 1b     KW1281 RX Buffer byte 3
    xor a                   ;b1a1  52
    call sub_bbae           ;b1a2  31 bb ae
    mov a, mem_0118+3       ;b1a5  60 01 1b     KW1281 RX Buffer byte 3
    mov mem_012b+1, a       ;b1a8  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter
    mov mem_0116, a         ;b1ab  61 01 16     Copy block counter into mem_0116
    mov mem_0081, #0x02     ;b1ae  85 81 02
    ret                     ;b1b1  20

sub_b1b2:
    mov mem_0081, a         ;b1b2  45 81
    call sub_bbae           ;b1b4  31 bb ae
    mov a, mem_0118+3       ;b1b7  60 01 1b     KW1281 RX Buffer byte 3
    mov mem_012b+1, a       ;b1ba  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter
    mov mem_0116, a         ;b1bd  61 01 16     Copy block counter into mem_0116
    ret                     ;b1c0  20

sub_b1c1:
    mov mem_0081, a         ;b1c1  45 81
    call call_sub_bbbf      ;b1c3  31 bb bf     Zeroes counts of KW1281 bytes received, sent
    mov a, #0x03            ;b1c6  04 03
    mov mem_012b+3, a       ;b1c8  61 01 2e     KW1281 TX Buffer byte 3
    mov a, #0x03            ;b1cb  04 03
    mov mem_0115, a         ;b1cd  61 01 15
    mov a, mem_0118+3       ;b1d0  60 01 1b     KW1281 RX Buffer byte 3
    mov mem_012b+1, a       ;b1d3  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter
    mov mem_0116, a         ;b1d6  61 01 16     Copy block counter into mem_0116
    ret                     ;b1d9  20


mem_0080_is_02:
    mov a, mem_0081         ;b1da  05 81
    cmp a, #0x01            ;b1dc  14 01
    beq lab_b1e5            ;b1de  fd 05
    cmp a, #0x02            ;b1e0  14 02
    beq lab_b1fe            ;b1e2  fd 1a
    ret                     ;b1e4  20

lab_b1e5:
    call sub_b20e_no_ack    ;b1e5  31 b2 0e
    mov mem_0081, #0x02     ;b1e8  85 81 02
    ret                     ;b1eb  20


mem_0080_is_0e:
;KW1281 Unrecognized Block Title
    mov a, mem_0081         ;b1ec  05 81
    cmp a, #0x01            ;b1ee  14 01
    beq lab_b1f7            ;b1f0  fd 05
    cmp a, #0x02            ;b1f2  14 02
    beq lab_b1fe            ;b1f4  fd 08
    ret                     ;b1f6  20

lab_b1f7:
;Unrecognized Block Title related
;(mem_0080=0x0e, mem_0081=1)
    call sub_b21f_no_ack    ;b1f7  31 b2 1f
    mov mem_0081, #0x02     ;b1fa  85 81 02
    ret                     ;b1fd  20


lab_b1fe:
;Unrecognized Block Title related
;(mem_0080=0x0e, mem_0081=2)
    bbc mem_008b:1, lab_b20b ;b1fe  b1 8b 0a
    clrb mem_008b:1         ;b201  a1 8b
    mov mem_0081, #0x00     ;b203  85 81 00
    clrb mem_008b:2         ;b206  a2 8b
    call sub_b26f           ;b208  31 b2 6f

lab_b20b:
    ret                     ;b20b  20


sub_b20c_no_ack:
    clrb mem_008b:7         ;b20c  a7 8b

sub_b20e_no_ack:
    movw a, #kw_no_ack      ;b20e  e4 ff 3b
    movw mem_0084, a        ;b211  d5 84        Pointer to KW1281 packet bytes
    mov mem_00a5, #0x05     ;b213  85 a5 05     5 bytes in KW1281 packet
    call sub_b136           ;b216  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    mov a, mem_0116         ;b219  60 01 16     A = Block counter copied from KW1281 RX Buffer
    jmp lab_b22e            ;b21c  21 b2 2e

sub_b21f_no_ack:
    movw a, #kw_no_ack      ;b21f  e4 ff 3b
    movw mem_0084, a        ;b222  d5 84        Pointer to KW1281 packet bytes
    mov mem_00a5, #0x05     ;b224  85 a5 05     5 bytes in KW1281 packet
    call sub_b136           ;b227  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    mov a, mem_0116         ;b22a  60 01 16     A = Block counter copied from KW1281 RX Buffer
    incw a                  ;b22d  c0           Increment block counter

lab_b22e:
    mov mem_012b+3, a       ;b22e  61 01 2e     Store block counter in KW1281 TX Buffer byte 3
    call sub_bbae           ;b231  31 bb ae
    ret                     ;b234  20

sub_b235:
;Store KW1281 byte received (mem_0088) in KW1281 RX Buffer
;Increment buffer position (mem_0082)
    movw a, #0x0000         ;b235  e4 00 00
    mov a, mem_0082         ;b238  05 82        A = count of KW1281 bytes received
    pushw a                 ;b23a  40           Push unmodified count on stack
    incw a                  ;b23b  c0           Increment it
    mov mem_0082, a         ;b23c  45 82        Save incremented count

    popw a                  ;b23e  50           Pop original value
    movw a, #mem_0118+0     ;b23f  e4 01 18     A = Pointer to KW1281 RX Buffer byte 0
    clrc                    ;b242  81
    addcw a                 ;b243  23           Add bytes received count to pointer
    pushw a                 ;b244  40           Save buffer pointer on the stack

    mov a, mem_0088         ;b245  05 88        A = KW1281 byte received
    xchw a, t               ;b247  43           Move it to T
    popw a                  ;b248  50           A = Pop buffer pointer
    mov @a, t               ;b249  82           Store byte received in buffer
    ret                     ;b24a  20

sub_b24b:
    mov a, mem_012b+0       ;b24b  60 01 2b     KW1281 TX Buffer byte 0: Block length
    cmp a, mem_0083         ;b24e  15 83        Compare to count of KW1281 bytes sent
    bne lab_b256            ;b250  fc 04

    clrb mem_008c:4         ;b252  a4 8c
    beq lab_b258            ;b254  fd 02        BRANCH_ALWAYS_TAKEN

lab_b256:
    setb mem_008c:4         ;b256  ac 8c

lab_b258:
    clrb mem_008b:4         ;b258  a4 8b

lab_b25a:
;TODO looks like sending a KW1281 packet
    setb uscr:1             ;b25a  a9 41        Enable UART receive interrupt

    movw a, #0x0000         ;b25c  e4 00 00
    mov a, mem_0083         ;b25f  05 83        A = count of KW1281 bytes sent
    movw a, #mem_012b       ;b261  e4 01 2b     A = Pointer to KW1281 TX Buffer byte 0
    clrc                    ;b264  81
    addcw a                 ;b265  23           Add bytes sent count to pointer

    mov a, @a               ;b266  92           A = current byte to send from buffer
    mov mem_0089, a         ;b267  45 89        KW1281 byte to send = A

    mov a, mem_0083         ;b269  05 83        Increment count of KW1281 bytes sent
    incw a                  ;b26b  c0
    mov mem_0083, a         ;b26c  45 83
    ret                     ;b26e  20

sub_b26f:
    mov a, #0x02            ;b26f  04 02
    mov mem_0114, a         ;b271  61 01 14
    call reset_kw_counts    ;b274  31 e0 b8     Reset counts of KW1281 bytes received, sent
    clrb mem_008b:6         ;b277  a6 8b
    clrb mem_008b:7         ;b279  a7 8b
    clrb mem_008b:4         ;b27b  a4 8b
    clrb mem_008c:4         ;b27d  a4 8c
    ret                     ;b27f  20


sub_b280:
;Called from ISR for IRQ8 (UART)
;only if mem_008c:7 = 1
    bbc mem_008c:4, lab_b28e ;b280  b4 8c 0b

    mov a, rxdr             ;b283  05 43
    mov mem_0088, a         ;b285  45 88        KW1281 byte received

    clrb uscr:7             ;b287  a7 41        Clear all UART receive error flags

    clrb mem_008c:4         ;b289  a4 8c
    jmp lab_b2b6            ;b28b  21 b2 b6
lab_b28e:
    mov a, ustr             ;b28e  05 42
    and a, #0xf0            ;b290  64 f0
    jmp lab_b2af            ;b292  21 b2 af
lab_b295:
    mov a, rxdr             ;b295  05 43
    mov mem_0088, a         ;b297  45 88        KW1281 byte received

    setb mem_008b:6         ;b299  ae 8b
    setb mem_008b:4         ;b29b  ac 8b

    clrb uscr:7             ;b29d  a7 41        Clear all UART receive error flags

    jmp lab_b2b6            ;b29f  21 b2 b6
lab_b2a2:
    mov a, rxdr             ;b2a2  05 43
    mov mem_0088, a         ;b2a4  45 88        KW1281 byte received

    setb mem_008b:7         ;b2a6  af 8b

    clrb uscr:7             ;b2a8  a7 41        Clear all UART receive error flags

    setb mem_008b:4         ;b2aa  ac 8b
    jmp lab_b2b6            ;b2ac  21 b2 b6
lab_b2af:
    cmp a, #0x10            ;b2af  14 10
    beq lab_b295            ;b2b1  fd e2
    jmp lab_b2a2            ;b2b3  21 b2 a2
lab_b2b6:
    clrb mem_008c:5         ;b2b6  a5 8c
    ret                     ;b2b8  20


mem_0080_is_10:
;KW1281 Read or write SAFE code word (16-bit BCD)
;
;Request block format for read:
;  0x04 Block length                    mem_0118+0
;  0x3E Block counter                   mem_0118+1
;  0xF0 Block title (0xF0)              mem_0118+2
;  0x00 Mode byte (0=Read)              mem_0118+3
;  0x03 Block end                       mem_0118+4
;
;Request block format for write:
;  0x06 Block length                    mem_0118+0
;  0x3E Block counter                   mem_0118+1
;  0xF0 Block title (0xF0)              mem_0118+2
;  0x01 Mode byte (1=Write)             mem_0118+3
;  0x00 SAFE code high byte (BCD)       mem_0118+4  Writes mem_020f
;  0x00 SAFE code low byte (BCD)        mem_0118+5  Writes mem_020f+1
;  0x03 Block end                       mem_0118+6
;
;Response block format for either:
;  0x05 Block length                    mem_012b+0
;  0x3F Block counter                   mem_012b+1
;  0xF0 Block title (0xF0)              mem_012b+2
;  0x00 SAFE code high byte (BCD)       mem_012b+3  Reads mem_020f
;  0x01 SAFE code low byte (BCD)        mem_012b+4  Reads mem_020f+1
;  0x03 Block end                       mem_012b+5
;
    mov a, mem_0081         ;b2b9  05 81
    cmp a, #0x01            ;b2bb  14 01
    beq lab_b2c4            ;b2bd  fd 05
    cmp a, #0x02            ;b2bf  14 02
    beq lab_b30c            ;b2c1  fd 49
    ret                     ;b2c3  20

lab_b2c4:
;(mem_0080=0x10, mem_0081=1)
;Read mode byte and dispatch to handle that mode.
;
    mov a, mem_0118+3       ;b2c4  60 01 1b     A = Mode byte
    beq lab_b2d4_read       ;b2c7  fd 0b        If Mode=0, branch to do read

    cmp a, #0x01            ;b2c9  14 01
    beq lab_b2d4_write      ;b2cb  fd 1f        If Mode=1, branch to do write

    call sub_b20c_no_ack    ;b2cd  31 b2 0c     If anything else, branch to do No Acknowledge
    mov mem_0081, #0x01     ;b2d0  85 81 01
    ret                     ;b2d3  20

lab_b2d4_read:
;Mode 0: Read SAFE code word and put it in KW1281 TX Buffer
;
    mov mem_00a5, #0x06     ;b2d4  85 a5 06     6 bytes in KW1281 packet
    movw a, #kw_rw_safe     ;b2d7  e4 ff 5d
    movw mem_0084, a        ;b2da  d5 84        Pointer to KW1281 packet bytes
    call sub_b136           ;b2dc  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    movw a, mem_020f        ;b2df  c4 02 0f     Read actual SAFE code word
    movw mem_012b+3, a      ;b2e2  d4 01 2e     Put it into KW1281 TX Buffer bytes 3 and 4

    call sub_bbae           ;b2e5  31 bb ae
    mov mem_0081, #0x02     ;b2e8  85 81 02
    ret                     ;b2eb  20

lab_b2d4_write:
;Mode 1: Write SAFE code word from value in KW1281 RX Buffer
;
    bbs mem_00de:7, lab_b305 ;b2ec  bf de 16
    bbs mem_00e3:7, lab_b305 ;b2ef  bf e3 13

    movw a, mem_0118+4       ;b2f2  c4 01 1c    KW1281 RX Buffer bytes 4 and 5
    movw mem_020f, a         ;b2f5  d4 02 0f    Store word as actual SAFE code

    mov a, #0x00             ;b2f8  04 00       A = 0 attempts for SAFE code
    mov mem_020e, a          ;b2fa  61 02 0e    Reset SAFE attempts to 0

    setb mem_00de:7          ;b2fd  af de
    mov mem_00f1, #0x9e      ;b2ff  85 f1 9e
    jmp lab_b2d4_read        ;b302  21 b2 d4    Response will be same as read mode

lab_b305:
;Mode Unknown: Send No Acknowledge
;
    call sub_b21f_no_ack    ;b305  31 b2 1f
    mov mem_0081, #0x02     ;b308  85 81 02
    ret                     ;b30b  20

lab_b30c:
;(mem_0080=0x10, mem_0081=2)
    call sub_bbc3           ;b30c  31 bb c3
    ret                     ;b30f  20


mem_0080_is_01:
;KW1281 ID code request/ECU info
    mov a, mem_0081         ;b310  05 81        A = table index
    movw a, #mem_b318       ;b312  e4 b3 18     A = table base address
    jmp sub_e73c            ;b315  21 e7 3c     Jump to address in table

mem_b318:
    .word lab_b36c  ;b318  b3 6c       VECTOR 0x00
    .word lab_b33a  ;b31a  b3 3a       VECTOR 0x01  "1J0035180   "
    .word lab_b36d  ;b31c  b3 6d       VECTOR 0x02
    .word lab_b37f  ;b31e  b3 7f       VECTOR 0x03
    .word lab_b38c  ;b320  b3 8c       VECTOR 0x04  " RADIO 3CP  "
    .word lab_b371  ;b322  b3 71       VECTOR 0x05
    .word lab_b39b  ;b324  b3 9b       VECTOR 0x06
    .word lab_b3a8  ;b326  b3 a8       VECTOR 0x07  "       0001"
    .word lab_b375  ;b328  b3 75       VECTOR 0x08
    .word lab_b3b7  ;b32a  b3 b7       VECTOR 0x09
    .word lab_b3c4  ;b32c  b3 c4       VECTOR 0x0a
    .word lab_b3c8  ;b32e  b3 c8       VECTOR 0x0b
    .word lab_b3cc  ;b330  b3 cc       VECTOR 0x0c
    .word lab_b379  ;b332  b3 79       VECTOR 0x0d
    .word lab_b3fe  ;b334  b3 fe       VECTOR 0x0e
    .word lab_b40b  ;b336  b4 0b       VECTOR 0x0f
    .word lab_b412  ;b338  b4 12       VECTOR 0x10

lab_b33a:
;KW1281 ID code request/ECU info related
;(mem_0080=0x00, mem_0081=1)
    clrb mem_00e1:7         ;b33a  a7 e1
    clrb mem_008c:1         ;b33c  a1 8c
    mov a, #0x00            ;b33e  04 00
    mov mem_017c, a         ;b340  61 01 7c
    mov mem_00a5, #0x10     ;b343  85 a5 10     16 bytes in KW1281 packet

    mov a, mem_00e8         ;b346  05 e8
    and a, #0b11000000      ;b348  64 c0

    cmp a, #0b01000000      ;b34a  14 40
    bne cmp_model_1         ;b34c  fc 05

    ;Model is 1J0035180
    movw a, #kw_asc_1j0035180   ;b34e  e4 ff 0c    "1J0035180   "
    bne cmp_model_done          ;b351  fc 0c        BRANCH_ALWAYS_TAKEN

cmp_model_1:
    cmp a, #0b10000000      ;b353  14 80
    bne cmp_model_2         ;b355  fc 05

    ;Model is 1J0035180D
    movw a, #kw_asc_1j0035180d  ;b357  e4 fe fc    "1J0035180D  "
    bne cmp_model_done          ;b35a  fc 03        BRANCH_ALWAYS_TAKEN

cmp_model_2:
    ;Model is 1C0035180E
    movw a, #kw_asc_1c0035180e  ;b35c  e4 fe ec    "1C0035180E  "

cmp_model_done:
    movw mem_0084, a        ;b35f  d5 84        Pointer to KW1281 packet bytes
    call sub_bbab           ;b361  31 bb ab
    mov a, #0x1a            ;b364  04 1a
    mov mem_032e, a         ;b366  61 03 2e
    mov mem_0081, #0x02     ;b369  85 81 02     mem_0081 = 2


lab_b36c:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0)
    ret                     ;b36c  20


lab_b36d:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=2)
    mov a, #0x03            ;b36d  04 03
    bne lab_b37b            ;b36f  fc 0a        BRANCH_ALWAYS_TAKEN


lab_b371:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=5)
    mov a, #0x06            ;b371  04 06
    bne lab_b37b            ;b373  fc 06        BRANCH_ALWAYS_TAKEN


lab_b375:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=8)
    mov a, #0x09            ;b375  04 09
    bne lab_b37b            ;b377  fc 02        BRANCH_ALWAYS_TAKEN


lab_b379:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x0d)
    mov a, #0x0e            ;b379  04 0e

lab_b37b:
    call sub_bbd3           ;b37b  31 bb d3
    ret                     ;b37e  20


lab_b37f:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=3)
    mov mem_00a0, #0x02     ;b37f  85 a0 02
    mov mem_00a1, #0x02     ;b382  85 a1 02
    mov mem_00a2, #0x04     ;b385  85 a2 04
    call sub_bbe0           ;b388  31 bb e0
    ret                     ;b38b  20


lab_b38c:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=4)
    mov mem_00a5, #0x10         ;b38c  85 a5 10     16 bytes in KW1281 packet
    movw a, #kw_asc_radio_3cp   ;b38f  e4 ff 1c     " RADIO 3CP  "
    movw mem_0084, a            ;b392  d5 84        Pointer to KW1281 packet bytes
    call sub_bbab               ;b394  31 bb ab
    mov mem_0081, #0x05         ;b397  85 81 05
    ret                         ;b39a  20


lab_b39b:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=6)
    mov mem_00a0, #0x05     ;b39b  85 a0 05
    mov mem_00a1, #0x05     ;b39e  85 a1 05
    mov mem_00a2, #0x07     ;b3a1  85 a2 07
    call sub_bbe0           ;b3a4  31 bb e0
    ret                     ;b3a7  20


lab_b3a8:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=7)
    mov mem_00a5, #0x0f     ;b3a8  85 a5 0f     15 bytes in KW1281 packet
    movw a, #kw_asc_0001    ;b3ab  e4 ff 2c     "       0001"
    movw mem_0084, a        ;b3ae  d5 84        Pointer to KW1281 packet bytes
    call sub_bbab           ;b3b0  31 bb ab
    mov mem_0081, #0x08     ;b3b3  85 81 08
    ret                     ;b3b6  20


lab_b3b7:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=9)
    mov mem_00a0, #0x08     ;b3b7  85 a0 08
    mov mem_00a1, #0x08     ;b3ba  85 a1 08
    mov mem_00a2, #0x0a     ;b3bd  85 a2 0a
    call sub_bbe0           ;b3c0  31 bb e0
    ret                     ;b3c3  20


lab_b3c4:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x0a)
    mov mem_0081, #0x0b     ;b3c4  85 81 0b
    ret                     ;b3c7  20


lab_b3c8:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x0b)
    mov mem_0081, #0x0c     ;b3c8  85 81 0c
    ret                     ;b3cb  20


lab_b3cc:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x0c)
    mov a, #0x08            ;b3cc  04 08        8 bytes in KW1281 TX Buffer
    mov mem_012b+0, a       ;b3ce  61 01 2b     KW1281 TX Buffer byte 0: Block length

    mov a, #0xf6            ;b3d1  04 f6        0xF6 = KW1281 Block title: ASCII Data/ID code response
    mov mem_012b+2, a       ;b3d3  61 01 2d     KW1281 TX Buffer byte 2: Block title

    mov a, mem_0116         ;b3d6  60 01 16     A = Block counter copied from KW1281 RX Buffer
    incw a                  ;b3d9  c0           Increment block counter
    mov mem_012b+1, a       ;b3da  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter

    mov a, #0x00            ;b3dd  04 00
    mov mem_012b+3, a       ;b3df  61 01 2e     KW1281 TX Buffer byte 3: ? TODO

    mov a, #0x03            ;b3e2  04 03        0x03 = Block End
    mov mem_012b+8, a       ;b3e4  61 01 33     KW1281 TX Buffer byte 8: Block End

    movw a, #mem_0175       ;b3e7  e4 01 75     A = Pointer to KW1281 packet bytes
    movw mem_0084, a        ;b3ea  d5 84
    movw a, #mem_012b+4     ;b3ec  e4 01 2f     A = Pointer to KW1281 TX Buffer byte 4
    movw mem_0086, a        ;b3ef  d5 86
    mov mem_00a5, #0x04     ;b3f1  85 a5 04     4 bytes in KW1281 packet
    call sub_b13e           ;b3f4  31 b1 3e     Copy mem_00a5 bytes from @mem_0084 to @mem_0086

    call sub_bba4           ;b3f7  31 bb a4
    mov mem_0081, #0x0d     ;b3fa  85 81 0d
    ret                     ;b3fd  20


lab_b3fe:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x0e)
    mov mem_00a0, #0x0d     ;b3fe  85 a0 0d
    mov mem_00a1, #0x0d     ;b401  85 a1 0d
    mov mem_00a2, #0x0f     ;b404  85 a2 0f
    call sub_bbe0           ;b407  31 bb e0
    ret                     ;b40a  20


lab_b40b:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x0f)
    call sub_b16b_ack       ;b40b  31 b1 6b
    mov mem_0081, #0x10     ;b40e  85 81 10
    ret                     ;b411  20


lab_b412:
;KW1281 ID code request/ECU info related
;(mem_0080=0x01, mem_0081=0x10)
    call sub_bbc3           ;b412  31 bb c3
    ret                     ;b415  20


sub_b416:
;Determine faults and set fault bits in mem_0093
;Returns EP = number of faults
;
    movw ep, #0             ;b416  e7 00 00     Number of faults = 0
    mov mem_0093, #0x00     ;b419  85 93 00     Clear all fault bits
    mov mem_0094, #0x00     ;b41c  85 94 00     XXX mem_0094 appears unused
    movw ix, #mem_0149      ;b41f  e6 01 49

    ;Check for Fault 00856 Antenna
    mov a, @ix+0x02         ;b422  06 02
    beq lab_b429            ;b424  fd 03        Branch if no fault
    setb mem_0093:0         ;b426  a8 93        KW1281 Fault 00856 Antenna
    incw ep                 ;b428  c3           Increment number of faults

lab_b429:
    ;Check for Fault 00668 Supply terminal 30
    mov a, @ix+0x06         ;b429  06 06
    beq lab_b430            ;b42b  fd 03        Branch if no fault
    setb mem_0093:1         ;b42d  a9 93        KW1281 Fault 00668 Supply terminal 30
    incw ep                 ;b42f  c3           Increment number of faults

lab_b430:
    ;Check for Fault 00850 Radio amplifier
    mov a, @ix+0x0a         ;b430  06 0a
    beq lab_b437            ;b432  fd 03        Branch if no fault
    setb mem_0093:2         ;b434  aa 93        KW1281 Fault 00850 Radio amplifier
    incw ep                 ;b436  c3           Increment number of faults

lab_b437:
    ;Check for Fault 01044 Control Module Incorrectly Coded
    mov a, @ix+0x1e         ;b437  06 1e
    beq lab_b43e            ;b439  fd 03        Branch if no fault
    setb mem_0093:3         ;b43b  ab 93        KW1281 Fault 01044 Control Module Incorrectly Coded
    incw ep                 ;b43d  c3           Increment number of faults

lab_b43e:
    ;Check for Fault 00855 CD changer
    mov a, @ix+0x0e         ;b43e  06 0e
    beq lab_b445            ;b440  fd 03        Branch if no fault
    setb mem_0093:4         ;b442  ac 93        KW1281 Fault 00855 CD changer
    incw ep                 ;b444  c3           Increment number of faults

lab_b445:
    ;Check for Fault 00852 Loudspeaker(s) Front
    mov a, @ix+0x12         ;b445  06 12
    beq lab_b44c            ;b447  fd 03        Branch if no fault
    setb mem_0093:5         ;b449  ad 93        KW1281 Fault 00852 Loudspeaker(s) Front
    incw ep                 ;b44b  c3           Increment number of faults

lab_b44c:
    ;Check for Fault 00853 Loudspeaker(s) Rear
    mov a, @ix+0x16         ;b44c  06 16
    beq lab_b453            ;b44e  fd 03        Branch if no fault
    setb mem_0093:6         ;b450  ae 93        KW1281 Fault 00853 Loudspeaker(s) Rear
    incw ep                 ;b452  c3           Increment number of faults

lab_b453:
    ;Check for Fault 65535 Internal Memory Error
    mov a, @ix+0x1a         ;b453  06 1a
    beq lab_b45b            ;b455  fd 04        Branch if no fault
    cmp a, #0x80            ;b457  14 80
    bne lab_b45e            ;b459  fc 03        Branch if no fault, case 2 (TODO what's 0x80?)

lab_b45b:
    setb mem_0093:7         ;b45b  af 93        KW1281 Fault 65535 Internal Memory Error
    incw ep                 ;b45d  c3           Increment number of faults

lab_b45e:
    ret                     ;b45e  20


mem_0080_is_04:
;KW1281 Read Faults
    mov a, mem_0081         ;b45f  05 81        A = table index
    movw a, #mem_b467       ;b461  e4 b4 67     A = table base address
    jmp sub_e73c            ;b464  21 e7 3c     Jump to address in table

mem_b467:
;case table for mem_0081
    .word lab_b4fe          ;b467  b4 fe       VECTOR
    .word lab_b475          ;b469  b4 75       VECTOR
    .word lab_b480          ;b46b  b4 80       VECTOR
    .word lab_b4fb          ;b46d  b4 fb       VECTOR
    .word lab_b4ff          ;b46f  b4 ff       VECTOR
    .word lab_b505          ;b471  b5 05       VECTOR
    .word lab_b52e          ;b473  b5 2e       VECTOR

lab_b475:
;Read Faults related
    call sub_b416           ;b475  31 b4 16     Determine faults, set fault bits in mem_0093
    movw a, ep              ;b478  f3           A = number of faults
    mov mem_0146, a         ;b479  61 01 46     Store number of faults in mem_0146
    mov mem_0081, #0x02     ;b47c  85 81 02
    ret                     ;b47f  20

lab_b480:
;Read Faults related
    mov a, #0xfc            ;b480  04 fc        0xFC = KW1281 Block title: Response to Read Faults
    mov mem_012b+2, a       ;b482  61 01 2d     KW1281 TX Buffer byte 2: Block title

    movw a, #mem_012b+3     ;b485  e4 01 2e     A = Pointer to KW1281 TX Buffer byte 3
    movw mem_0086, a        ;b488  d5 86

    mov a, mem_0146         ;b48a  60 01 46     A = number of faults
    cmp a, #0x04            ;b48d  14 04        Compare number of faults with 4
    blo lab_b4a3            ;b48f  f9 12        Branch if < 4

    ;4 Faults
    clrc                    ;b491  81
    subc a, #0x04           ;b492  34 04        4 - 4 = 0
    mov mem_0146, a         ;b494  61 01 46     Set number of faults = 0

    call sub_b535           ;b497  31 b5 35     Build KW1281 fragment for 4 faults

    mov a, #0x03            ;b49a  04 03        0x03 = Block end
    mov mem_012b+15, a      ;b49c  61 01 3a     KW1281 TX Buffer byte 15: Block end

    mov a, #0x0f            ;b49f  04 0f        A = Block length of 15 bytes
    bne lab_b4e0            ;b4a1  fc 3d        BRANCH_ALWAYS_TAKEN

lab_b4a3:
    cmp a, #0x03            ;b4a3  14 03        Compare number of faults with 3
    bne lab_b4b9            ;b4a5  fc 12        Branch if != 3

    ;3 Faults
    decw a                  ;b4a7  d0           3->2
    decw a                  ;b4a8  d0           2->1
    decw a                  ;b4a9  d0           1->0
    mov mem_0146, a         ;b4aa  61 01 46     Set number of faults = 0

    call sub_b538           ;b4ad  31 b5 38     Build KW1281 fragment for 3 faults

    mov a, #0x03            ;b4b0  04 03        0x03 = Block end
    mov mem_012b+12, a      ;b4b2  61 01 37     KW1281 TX Buffer byte 12: Block end

    mov a, #0x0c            ;b4b5  04 0c        A = Block length of 12 bytes
    bne lab_b4e0            ;b4b7  fc 27        BRANCH_ALWAYS_TAKEN

lab_b4b9:
    cmp a, #0x02            ;b4b9  14 02        Compare number of faults with 2
    bne lab_b4ce            ;b4bb  fc 11        Branch if != 2

    ;2 Faults
    decw a                  ;b4bd  d0           2->1
    decw a                  ;b4be  d0           1->0
    mov mem_0146, a         ;b4bf  61 01 46     Set number of faults = 0

    call sub_b53b           ;b4c2  31 b5 3b     Build KW1281 fragment for 2 faults

    mov a, #0x03            ;b4c5  04 03        0x03 = Block end
    mov mem_012b+9, a       ;b4c7  61 01 34     KW1281 TX Buffer byte 9: Block end

    mov a, #0x09            ;b4ca  04 09        A = Block length of 9 bytes
    bne lab_b4e0            ;b4cc  fc 12        BRANCH_ALWAYS_TAKEN

lab_b4ce:
    cmp a, #0x01            ;b4ce  14 01        Compare number of faults with 1
    bne lab_b4e9            ;b4d0  fc 17        Branch if != 1

    ;1 Fault
    decw a                  ;b4d2  d0           1->0
    mov mem_0146, a         ;b4d3  61 01 46     Set number of faults = 0

    call sub_b542           ;b4d6  31 b5 42     Build KW1281 fragment for 2 faults

    mov a, #0x03            ;b4d9  04 03        0x03 = Block end
    mov mem_012b+6, a       ;b4db  61 01 31     KW1281 TX Buffer byte 6: Block end

    mov a, #0x06            ;b4de  04 06        A = Block length of 6 bytes

lab_b4e0:
    mov mem_012b+0, a       ;b4e0  61 01 2b     KW1281 TX Buffer byte 0: Block length
    mov mem_0081, #0x04     ;b4e3  85 81 04
    jmp lab_b4f7            ;b4e6  21 b4 f7

lab_b4e9:
    mov mem_00a5, #0x07     ;b4e9  85 a5 07     7 bytes in KW1281 packet
    movw a, #kw_faults_none ;b4ec  e4 ff 44
    movw mem_0084, a        ;b4ef  d5 84        Pointer to KW1281 packet bytes
    call sub_b136           ;b4f1  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    mov mem_0081, #0x03     ;b4f4  85 81 03

lab_b4f7:
    call sub_bbae           ;b4f7  31 bb ae
    ret                     ;b4fa  20

lab_b4fb:
;Read Faults related
    call sub_bbc3           ;b4fb  31 bb c3

lab_b4fe:
    ret                     ;b4fe  20

lab_b4ff:
;Read Faults related
    mov a, #0x05            ;b4ff  04 05
    call sub_bbd3           ;b501  31 bb d3
    ret                     ;b504  20

lab_b505:
;Read Faults related
    bbc mem_008b:0, lab_b52d ;b505  b0 8b 25
    clrb mem_008b:0         ;b508  a0 8b
    bbc mem_008b:7, lab_b514 ;b50a  b7 8b 07
    call sub_b20c_no_ack           ;b50d  31 b2 0c
    mov mem_0081, #0x04     ;b510  85 81 04
    ret                     ;b513  20

lab_b514:
;Read Faults related
    mov a, mem_0118+2       ;b514  60 01 1a     KW1281 RX Buffer byte 2: Block title
    cmp a, #0x0a            ;b517  14 0a        Is it 0x0a (No Acknowledge)?
    bne lab_b521            ;b519  fc 06
    ;Block title = 0x0a (No Acknowledge)
    mov a, #0x04            ;b51b  04 04        A = value to store in mem_0081
    call sub_b1b2           ;b51d  31 b1 b2
    ret                     ;b520  20

lab_b521:
;Read Faults related
;Block title != 0x0a (No Acknowledge)
    mov a, mem_0146         ;b521  60 01 46
    bne lab_b52a            ;b524  fc 04
    mov mem_0081, #0x06     ;b526  85 81 06
    ret                     ;b529  20

lab_b52a:
;Read Faults related
    mov mem_0081, #0x02     ;b52a  85 81 02

lab_b52d:
;Read Faults related
    ret                     ;b52d  20

lab_b52e:
;Read Faults related
    call sub_b16b_ack       ;b52e  31 b1 6b
    mov mem_0081, #0x03     ;b531  85 81 03
    ret                     ;b534  20

sub_b535:
;Build KW1281 fragment for 4 Faults
    call sub_b542           ;b535  31 b5 42     Build KW1281 fragment for 1 Fault

sub_b538:
;Build KW1281 fragment for 3 Faults
    call sub_b542           ;b538  31 b5 42     Build KW1281 fragment for 1 Fault

sub_b53b:
;Build KW1281 fragment for 2 Faults
    call sub_b542           ;b53b  31 b5 42     Build KW1281 fragment for 1 Fault
    call sub_b542           ;b53e  31 b5 42
    ret                     ;b541  20

sub_b542:
;Build KW1281 fragment for 1 Fault
    mov a, mem_0093         ;b542  05 93        A = fault bits
    beq lab_b553            ;b544  fd 0d        Branch to do nothing if no faults

    call sub_b554           ;b546  31 b5 54     Read/clear fault bits, returns A = pointer to KW1281 packet

    movw mem_0084, a        ;b549  d5 84        Pointer to KW1281 packet bytes
    movw mem_0084, a        ;b54b  d5 84        Pointer to KW1281 packet bytes (XXX why?)
    mov mem_00a5, #0x03     ;b54d  85 a5 03     3 bytes in KW1281 packet
    call sub_b13e           ;b550  31 b1 3e     Copy mem_00a5 bytes from @mem_0084 to @mem_0086

lab_b553:
    ret                     ;b553  20


sub_b554:
;Read fault bits in mem_0093.  For the first fault bit set, clear the bit
;and return a pointer in A to KW1281 packet bytes for that fault.
;
    bbc mem_0093:0, lab_b55d ;b554  b0 93 06

    ;KW1281 Fault 00856 Antenna
    clrb mem_0093:0         ;b557  a0 93        Clear fault 00856 bit
    movw a, #mem_0149       ;b559  e4 01 49     A = Address of KW1281 packet bytes
    ret                     ;b55c  20

lab_b55d:
    bbc mem_0093:1, lab_b566 ;b55d  b1 93 06

    ;KW1281 Fault 00668 Supply terminal 30
    clrb mem_0093:1         ;b560  a1 93        Clear fault 00668 bit
    movw a, #mem_014d       ;b562  e4 01 4d     A = Address of KW1281 packet bytes
    ret                     ;b565  20

lab_b566:
    bbc mem_0093:2, lab_b56f ;b566  b2 93 06

    ;KW1281 Fault 00850 Radio amplifier
    clrb mem_0093:2         ;b569  a2 93        Clear fault 00850 bit
    movw a, #mem_0151       ;b56b  e4 01 51     A = Address of KW1281 packet bytes
    ret                     ;b56e  20

lab_b56f:
    bbc mem_0093:3, lab_b578 ;b56f  b3 93 06

    ;KW1281 Fault 01044 Control Module Incorrectly Coded
    clrb mem_0093:3         ;b572  a3 93        Clear fault 01044 bit
    movw a, #mem_0165       ;b574  e4 01 65     A = Address of KW1281 packet bytes
    ret                     ;b577  20

lab_b578:
    bbc mem_0093:4, lab_b581 ;b578  b4 93 06

    ;KW1281 Fault 00855 CD changer
    clrb mem_0093:4         ;b57b  a4 93        Clear fault 00855 bit
    movw a, #mem_0155       ;b57d  e4 01 55     A = Address of KW1281 packet bytes
    ret                     ;b580  20

lab_b581:
    bbc mem_0093:5, lab_b58a ;b581  b5 93 06

    ;KW1281 Fault 00852 Loudspeaker(s) Front
    clrb mem_0093:5         ;b584  a5 93        Clear fault 00852 bit
    movw a, #mem_0159       ;b586  e4 01 59     A = Address of KW1281 packet bytes
    ret                     ;b589  20

lab_b58a:
    bbc mem_0093:6, lab_b593 ;b58a  b6 93 06

    ;KW1281 Fault 00853 Loudspeaker(s) Rear
    clrb mem_0093:6         ;b58d  a6 93        Clear fault 00853 bit
    movw a, #mem_015d       ;b58f  e4 01 5d     A = Address of KW1281 packet bytes
    ret                     ;b592  20

lab_b593:
    bbc mem_0093:7, lab_b59b ;b593  b7 93 05

    ;KW1281 Fault 65535 Internal Memory Error
    clrb mem_0093:7         ;b596  a7 93        Clear fault 65535 bit
    movw a, #mem_0161       ;b598  e4 01 61     A = Address of KW1281 packet bytes

lab_b59b:
    ret                     ;b59b  20


mem_0080_is_05:
;KW1281 Clear Faults
    mov a, mem_0081         ;b59c  05 81        A = table index
    movw a, #mem_b5a4       ;b59e  e4 b5 a4     A = table base address
    jmp sub_e73c            ;b5a1  21 e7 3c     Jump to address in table

mem_b5a4:
;case table for mem_0081
    .word lab_b5ca          ;b5a4  b5 ca       VECTOR   0
    .word lab_b5b2          ;b5a6  b5 b2       VECTOR   1
    .word lab_b5ca          ;b5a8  b5 ca       VECTOR   2
    .word lab_b5cb          ;b5aa  b5 cb       VECTOR   3
    .word lab_b5d7          ;b5ac  b5 d7       VECTOR   4   KW1281 Fault Codes
    .word lab_b5e6          ;b5ae  b5 e6       VECTOR   5
    .word lab_b5ea          ;b5b0  b5 ea       VECTOR   6

lab_b5b2:
;Clear Faults related
;(mem_0080=0x05, mem_0081=1)
    call sub_c2c6           ;b5b2  31 c2 c6
    mov mem_0196, a         ;b5b5  61 01 96
    movw mem_0159, a        ;b5b8  d4 01 59
    movw mem_030c, a        ;b5bb  d4 03 0c
    call sub_b9f9           ;b5be  31 b9 f9
    call sub_a516           ;b5c1  31 a5 16
    call sub_b5f1           ;b5c4  31 b5 f1
    mov mem_0081, #0x03     ;b5c7  85 81 03

lab_b5ca:
;Clear Faults related
;(mem_0080=0x05, mem_0081=0,2)
    ret                     ;b5ca  20

lab_b5cb:
;Clear Faults related
;(mem_0080=0x05, mem_0081=3)
    mov a, mem_0091         ;b5cb  05 91
    bne lab_b5d3            ;b5cd  fc 04
    mov mem_0081, #0x04     ;b5cf  85 81 04
    ret                     ;b5d2  20

lab_b5d3:
    mov mem_0081, #0x06     ;b5d3  85 81 06
    ret                     ;b5d6  20

lab_b5d7:
;Clear Faults related
;(mem_0080=0x05, mem_0081=4)
    mov mem_00a5, #0x07     ;b5d7  85 a5 07     7 bytes in KW1281 packet
    movw a, #kw_faults_none ;b5da  e4 ff 44
    movw mem_0084, a        ;b5dd  d5 84        Pointer to KW1281 packet bytes
    call sub_bba1           ;b5df  31 bb a1

    mov mem_0081, #0x05     ;b5e2  85 81 05
    ret                     ;b5e5  20

lab_b5e6:
;Clear Faults related
;(mem_0080=0x05, mem_0081=5)
    call sub_bbc3           ;b5e6  31 bb c3
    ret                     ;b5e9  20

lab_b5ea:
;Clear Faults related
;(mem_0080=0x05, mem_0081=6)
    mov mem_0080, #0x04     ;b5ea  85 80 04     New KW1281 state = Read Faults
    mov mem_0081, #0x01     ;b5ed  85 81 01
    ret                     ;b5f0  20

sub_b5f1:
    call sub_bc02                       ;b5f1  31 bc 02
    call copy_ix_to_ix1_ix2             ;b5f4  31 b6 4b     Copy byte @IX+0 into @IX+1 and @IX+2
    call sub_c4fe_fault_terminal_30     ;b5f7  31 c4 fe
    mov a, mem_0335                     ;b5fa  60 03 35
    beq lab_b604                        ;b5fd  fd 05
    cmp a, #0x01                        ;b5ff  14 01
    beq lab_b604                        ;b601  fd 01
    ret                                 ;b603  20

lab_b604:
    call sub_c034                       ;b604  31 c0 34
    call copy_ix_to_ix1_ix2             ;b607  31 b6 4b     Copy byte @IX+0 into @IX+1 and @IX+2
    call sub_c50c_fault_amplifier       ;b60a  31 c5 0c
    call sub_bd48                       ;b60d  31 bd 48
    mov a, mem_013f                     ;b610  60 01 3f
    mov a, #0x01                        ;b613  04 01
    cmp a                               ;b615  12
    bne lab_b621                        ;b616  fc 09
    mov a, #0x00                        ;b618  04 00
    mov mem_013f, a                     ;b61a  61 01 3f
    mov @ix+0x00, a                     ;b61d  46 00
    clrb mem_0091:5                     ;b61f  a5 91        KW1281 Fault 00852 - Loudspeaker(s) Front

lab_b621:
    call copy_ix_to_ix1_ix2             ;b621  31 b6 4b     Copy byte @IX+0 into @IX+1 and @IX+2
    call sub_c55d_fault_speakers_front  ;b624  31 c5 5d
    call sub_bdbe                       ;b627  31 bd be
    mov a, mem_0140                     ;b62a  60 01 40
    mov a, #0x01                        ;b62d  04 01
    cmp a                               ;b62f  12
    bne lab_b63b                        ;b630  fc 09
    mov a, #0x00                        ;b632  04 00
    mov mem_0140, a                     ;b634  61 01 40
    mov @ix+0x00, a                     ;b637  46 00
    clrb mem_0091:6                     ;b639  a6 91        KW1281 Fault 00853 - Loudspeaker(s) Rear

lab_b63b:
    call copy_ix_to_ix1_ix2             ;b63b  31 b6 4b     Copy byte @IX+0 into @IX+1 and @IX+2
    call sub_c574_fault_speakers_rear   ;b63e  31 c5 74
    call sub_bc44                       ;b641  31 bc 44
    call copy_ix_to_ix1_ix2             ;b644  31 b6 4b     Copy byte @IX+0 into @IX+1 and @IX+2
    call sub_c51a_fault_cd_changer      ;b647  31 c5 1a
    ret                                 ;b64a  20

copy_ix_to_ix1_ix2:
;Copy byte @IX+0 into @IX+1 and @IX+2
;
    ;Copy byte @IX+0 into @IX+1
    mov a, @ix+0x00         ;b64b  06 00
    mov @ix+0x01, a         ;b64d  46 01

    ;Copy byte @IX+0 into @IX+2
    mov a, @ix+0x00         ;b64f  06 00
    mov @ix+0x02, a         ;b651  46 02
    ret                     ;b653  20


mem_0080_is_06:
;KW1281 Actuator/Output Tests
    mov a, mem_0081         ;b654  05 81
    cmp a, #0x01            ;b656  14 01
    beq lab_b67d            ;b658  fd 23
    cmp a, #0x02            ;b65a  14 02
    beq lab_b6b7            ;b65c  fd 59
    cmp a, #0x03            ;b65e  14 03
    bne lab_b665            ;b660  fc 03
    jmp lab_b6c1            ;b662  21 b6 c1

lab_b665:
;Actuator/Output Tests related
    cmp a, #0x04            ;b665  14 04
    bne lab_b66c            ;b667  fc 03
    jmp lab_b6c7            ;b669  21 b6 c7

lab_b66c:
;Actuator/Output Tests related
    cmp a, #0x05            ;b66c  14 05
    bne lab_b673            ;b66e  fc 03
    jmp lab_b6f9            ;b670  21 b6 f9

lab_b673:
;Actuator/Output Tests related
    cmp a, #0x08            ;b673  14 08
    bne lab_b67a            ;b675  fc 03
    jmp lab_b700            ;b677  21 b7 00

lab_b67a:
;Actuator/Output Tests related
    jmp lab_b703            ;b67a  21 b7 03

lab_b67d:
;Actuator/Output Tests related
    mov a, mem_017c         ;b67d  60 01 7c
    beq lab_b68c            ;b680  fd 0a
    cmp a, #0x01            ;b682  14 01
    beq lab_b6a1            ;b684  fd 1b
    cmp a, #0x02            ;b686  14 02
    beq lab_b6aa            ;b688  fd 20
    bne lab_b6b3            ;b68a  fc 27        BRANCH_ALWAYS_TAKEN

lab_b68c:
;Actuator/Output Tests related
    mov a, mem_0335         ;b68c  60 03 35
    beq lab_b697            ;b68f  fd 06
    cmp a, #0x01            ;b691  14 01
    beq lab_b697            ;b693  fd 02
    bne lab_b69c            ;b695  fc 05        BRANCH_ALWAYS_TAKEN

lab_b697:
;Actuator/Output Tests related
    mov a, #0x01            ;b697  04 01
    mov mem_019c, a         ;b699  61 01 9c

lab_b69c:
;Actuator/Output Tests related
    movw a, #kw_actuator_1  ;b69c  e4 ff 4b     KW1281 TX Buffer to Actuator/Output Tests: Speakers
    bne lab_b6b1            ;b69f  fc 10        BRANCH_ALWAYS_TAKEN

lab_b6a1:
;Actuator/Output Tests related
    setb mem_00e1:7         ;b6a1  af e1
    setb mem_0098:4         ;b6a3  ac 98
    movw a, #kw_actuator_2  ;b6a5  e4 ff 51    KW1281 TX Buffer to Actuator/Output Tests: External Display
    bne lab_b6b1            ;b6a8  fc 07        BRANCH_ALWAYS_TAKEN

lab_b6aa:
;Actuator/Output Tests related
    clrb mem_00e1:7         ;b6aa  a7 e1
    setb mem_0098:4         ;b6ac  ac 98
    movw a, #kw_actuator_3  ;b6ae  e4 ff 57     KW1281 TX Buffer to Actuator/Output Tests: End of Tests

lab_b6b1:
;Actuator/Output Tests related
    movw mem_0084, a        ;b6b1  d5 84        Pointer to KW1281 packet bytes

lab_b6b3:
;Actuator/Output Tests related
    mov mem_0081, #0x02     ;b6b3  85 81 02
    ret                     ;b6b6  20

lab_b6b7:
;Actuator/Output Tests related
    mov mem_00a5, #0x06     ;b6b7  85 a5 06     6 bytes in KW1281 packet
    call sub_bbab           ;b6ba  31 bb ab
    mov mem_0081, #0x03     ;b6bd  85 81 03
    ret                     ;b6c0  20

lab_b6c1:
;Actuator/Output Tests related
    mov a, #0x04            ;b6c1  04 04
    call sub_bbd3           ;b6c3  31 bb d3
    ret                     ;b6c6  20

lab_b6c7:
;Actuator/Output Tests related
    bbc mem_008b:0, lab_b6f8 ;b6c7  b0 8b 2e
    clrb mem_008b:0         ;b6ca  a0 8b
    bbc mem_008b:7, lab_b6d6 ;b6cc  b7 8b 07
    call sub_b20c_no_ack           ;b6cf  31 b2 0c
    mov mem_0081, #0x04     ;b6d2  85 81 04
    ret                     ;b6d5  20

lab_b6d6:
;Actuator/Output Tests related
    mov a, mem_0118+2       ;b6d6  60 01 1a     A = KW1281 RX Buffer byte 2: Block title
    cmp a, #0x0a            ;b6d9  14 0a        Is it 0x0a (No Acknowledge)?
    bne lab_b6e3            ;b6db  fc 06
    ;Block title = 0x0a (No Acknowledge)
    mov a, #0x03            ;b6dd  04 03        A = value to store in mem_0081
    call sub_b1b2           ;b6df  31 b1 b2
    ret                     ;b6e2  20

lab_b6e3:
;Actuator/Output Tests related
;Block title != 0x0a (No Acknowledge)
    mov a, mem_017c         ;b6e3  60 01 7c
    incw a                  ;b6e6  c0
    mov mem_017c, a         ;b6e7  61 01 7c
    cmp a, #0x03            ;b6ea  14 03
    bne lab_b6f5            ;b6ec  fc 07
    setb mem_008c:1         ;b6ee  a9 8c
    mov a, #0x00            ;b6f0  04 00
    mov mem_017c, a         ;b6f2  61 01 7c

lab_b6f5:
;Actuator/Output Tests related
    mov mem_0081, #0x05     ;b6f5  85 81 05

lab_b6f8:
;Actuator/Output Tests related
    ret                     ;b6f8  20

lab_b6f9:
;Actuator/Output Tests related
    call sub_b16b_ack       ;b6f9  31 b1 6b
    mov mem_0081, #0x08     ;b6fc  85 81 08
    ret                     ;b6ff  20

lab_b700:
;Actuator/Output Tests related
    call sub_bbc3           ;b700  31 bb c3

lab_b703:
;Actuator/Output Tests related
    ret                     ;b703  20


kw_group_1:
;KW1281 Group Reading: Group 1 (General)
    .byte 0x10              ;b704  10          DATA '\x10'  Total size of KW1281 packet (block length + 1)
    .byte 0x0F              ;b705  0f          DATA '\x0f'  Block length
    .byte 0x00              ;b706  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b707  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;GALA-Signal
    .byte 0x25              ;b708  25          DATA '%'     type
    .byte 0x00              ;b709  00          DATA '\x00'  value a
    .byte 0x00              ;b70a  00          DATA '\x00'  value b

    ;Supply Voltage (Terminal 30)
    .byte 0x06              ;b70b  06          DATA '\x06'  type
    .byte 0x64              ;b70c  64          DATA 'd'     value a
    .byte 0x00              ;b70d  00          DATA '\x00'  value b

    ;Illumination % (Terminal 5d)
    .byte 0x17              ;b70e  17          DATA '\x17'  type
    .byte 0xFF              ;b70f  ff          DATA '\xff'  value a
    .byte 0x00              ;b710  00          DATA '\x00'  value b

    ;S-Contact Status
    .byte 0x25              ;b711  25          DATA '%'     type
    .byte 0x00              ;b712  00          DATA '\x00'  value a
    .byte 0x00              ;b713  00          DATA '\x00'  value b

    .byte 0x03              ;b714  03          DATA '\x03'  Block end

kw_group_2:
;KW1281 Group Reading: Group 2 (Speakers)
    .byte 0x10              ;b715  10          DATA '\x10'  Number of bytes in KW1281 packet (block length + 1)
    .byte 0x0F              ;b716  0f          DATA '\x0f'  Block length
    .byte 0x00              ;b717  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b718  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;Location/Type (Front)
    .byte 0x25              ;b719  25          DATA '%'     type
    .byte 0x00              ;b71a  00          DATA '\x00'  value a
    .byte 0xF0              ;b71b  f0          DATA '\xf0'  value b

    ;Status
    .byte 0x25              ;b71c  25          DATA '%'     type
    .byte 0x00              ;b71d  00          DATA '\x00'  value a
    .byte 0x00              ;b71e  00          DATA '\x00'  value b

    ;Location/Type (Rear)
    .byte 0x25              ;b71f  25          DATA '%'     type
    .byte 0x00              ;b720  00          DATA '\x00'  value a
    .byte 0xF1              ;b721  f1          DATA '\xf1'  value b

    ;Status
    .byte 0x25              ;b722  25          DATA '%'     type
    .byte 0x00              ;b723  00          DATA '\x00'  value a
    .byte 0x00              ;b724  00          DATA '\x00'  value b

    .byte 0x03              ;b725  03          DATA '\x03'  Block end

kw_group_3:
;KW1281 Group Reading: Group 3 (Antenna)
    .byte 0x0D              ;b726  0d          DATA '\r'    Number of bytes in KW1281 packet (block length + 1)
    .byte 0x0C              ;b727  0c          DATA '\x0c'  Block length
    .byte 0x00              ;b728  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b729  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;Antenna Type
    .byte 0x25              ;b72a  25          DATA '%'     type
    .byte 0x01              ;b72b  01          DATA '\x01'  value a
    .byte 0x00              ;b72c  00          DATA '\x00'  value b

    ;Antenna
    .byte 0x25              ;b72d  25          DATA '%'     type
    .byte 0x00              ;b72e  00          DATA '\x00'  value a
    .byte 0xF4              ;b72f  f4          DATA '\xf4'  value b

    ;Status
    .byte 0x25              ;b730  25          DATA '%'     type
    .byte 0x00              ;b731  00          DATA '\x00'  value a
    .byte 0x00              ;b732  00          DATA '\x00'  value b

    .byte 0x03              ;b733  03          DATA '\x03'  Block end

kw_group_5:
;KW1281 Group Reading: Group 5 (CD Changer)
    .byte 0x0A              ;b734  0a          DATA '\n'    Number of bytes in KW1281 packet (block length + 1)
    .byte 0x09              ;b735  09          DATA '\t'    Block length
    .byte 0x00              ;b736  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b737  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;Component
    .byte 0x25              ;b738  25          DATA '%'     type
    .byte 0x00              ;b739  00          DATA '\x00'  value a
    .byte 0xF6              ;b73a  f6          DATA '\xf6'  value b

    ;Status
    .byte 0x25              ;b73b  25          DATA '%'     type
    .byte 0x00              ;b73c  00          DATA '\x00'  value a
    .byte 0x00              ;b73d  00          DATA '\x00'  value b

    .byte 0x03              ;b73e  03          DATA '\x03'  Block end

kw_group_6:
;KW1281 Group Reading: Group 6 (External Display)
    .byte 0x0A              ;b73f  0a          DATA '\n'    Number of bytes in KW1281 packet (block length + 1)
    .byte 0x09              ;b740  09          DATA '\t'    Block length
    .byte 0x00              ;b741  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b742  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;Component
    .byte 0x25              ;b743  25          DATA '%'     type
    .byte 0x00              ;b744  00          DATA '\x00'  value a
    .byte 0xF7              ;b745  f7          DATA '\xf7'  value b

    ;Status
    .byte 0x25              ;b746  25          DATA '%'     type
    .byte 0x00              ;b747  00          DATA '\x00'  value a
    .byte 0x00              ;b748  00          DATA '\x00'  value b

    .byte 0x03              ;b749  03          DATA '\x03'  Block end

kw_group_7:
;KW1281 Group Reading: Group 7 (Steering Wheel Control)
    .byte 0x07              ;b74a  07          DATA '\x07'  Number of bytes in KW1281 packet (block length + 1)
    .byte 0x06              ;b74b  06          DATA '\x06'  Block length
    .byte 0x00              ;b74c  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b74d  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;Steering Wheel Buttons
    .byte 0x11              ;b74e  11          DATA '\x11'  type
    .byte 0x20              ;b74f  20          DATA ' '     value a
    .byte 0x00              ;b750  00          DATA '\x00'  value b

    .byte 0x03              ;b751  03          DATA '\x03'  Block end

kw_group_4:
;KW1281 Group Reading: Group 4 (Amplifier)
    .byte 0x07              ;b752  07          DATA '\x07'  Number of bytes in KW1281 packet (block length + 1)
    .byte 0x06              ;b753  06          DATA '\x06'  Block length
    .byte 0x00              ;b754  00          DATA '\x00'  Block counter
    .byte 0xE7              ;b755  e7          DATA '\xe7'  Block title (0xE7 = Response to group reading)

    ;Amplifier Output
    .byte 0x10              ;b756  10          DATA '\x10'  type
    .byte 0x01              ;b757  01          DATA '\x01'  value a
    .byte 0x00              ;b758  00          DATA '\x00'  value b

    .byte 0x03              ;b759  03          DATA '\x03'  Block end


mem_0080_is_07:
;KW1281 Group Reading
;
;Group Reading request block:
;   0x04 Block length                   mem_0118+0
;   0x2A Block counter                  mem_0118+1
;   0x29 Block title (Group Reading)    mem_0118+2
;   0x01 Group Number                   mem_0118+3
;   0x03 Block end                      mem_0118+4
;
    mov a, mem_0081         ;b75a  05 81
    cmp a, #0x01            ;b75c  14 01
    beq lab_b773            ;b75e  fd 13
    cmp a, #0x02            ;b760  14 02
    beq lab_b77c            ;b762  fd 18
    cmp a, #0x03            ;b764  14 03
    bne lab_b76b            ;b766  fc 03
    jmp lab_b845            ;b768  21 b8 45

lab_b76b:
;(mem_0080=0x07, mem_0081 != 1,2,3)
;Group Reading related
    cmp a, #0x04            ;b76b  14 04
    bne lab_b772            ;b76d  fc 03
    jmp lab_b919            ;b76f  21 b9 19

lab_b772:
    ret                     ;b772  20

lab_b773:
;(mem_0080=0x07, mem_0081=1)
;Group Reading related
    mov mem_0081, #0x02     ;b773  85 81 02
    mov a, #0x01            ;b776  04 01
    mov mem_0194, a         ;b778  61 01 94
    ret                     ;b77b  20

lab_b77c:
;(mem_0080=0x07, mem_0081=2)
;Group Reading related
    mov a, mem_0118+3       ;b77c  60 01 1b     KW1281 RX Buffer byte 3: Group number
    cmp a, #0x01            ;b77f  14 01
    beq lab_b7a2            ;b781  fd 1f        Group 1 (General)

    cmp a, #0x02            ;b783  14 02
    beq lab_b7b2            ;b785  fd 2b        Group 2 (Speakers)

    cmp a, #0x03            ;b787  14 03
    beq lab_b7d4            ;b789  fd 49        Group 3 (Antenna)

    cmp a, #0x04            ;b78b  14 04
    beq lab_b7ec            ;b78d  fd 5d        Group 4 (Amplifier)

    cmp a, #0x05            ;b78f  14 05
    beq lab_b7f2            ;b791  fd 5f        Group 5 (CD Changer)

    cmp a, #0x06            ;b793  14 06
    beq lab_b804            ;b795  fd 6d        Group 6 (External Display)

    cmp a, #0x07            ;b797  14 07
    beq lab_b811            ;b799  fd 76        Group 7 (Steering Wheel Control)

    cmp a, #0x19            ;b79b  14 19
    beq lab_b81a            ;b79d  fd 7b        Group 25 (Protection)

    jmp lab_b822            ;b79f  21 b8 22

lab_b7a2:
;Group Reading related
;Group 1 (General)
;KW1281 Group Reading: Group 1 (General)
;GALA-Signal, Supply Voltage Terminal 30, Illumumination %, S-Contact)
    setb mem_008e:3         ;b7a2  ab 8e
    call sub_bc02           ;b7a4  31 bc 02
    mov a, #0x00            ;b7a7  04 00
    mov mem_0265, a         ;b7a9  61 02 65
    movw ix, #kw_group_1    ;b7ac  e6 b7 04
    jmp lab_b7fc            ;b7af  21 b7 fc

lab_b7b2:
;Group Reading related: Group 2 (Speakers)
    mov a, mem_02d2         ;b7b2  60 02 d2
    bne lab_b7cc            ;b7b5  fc 15
    mov a, #0x01            ;b7b7  04 01
    mov mem_02d2, a         ;b7b9  61 02 d2
    mov a, mem_019b         ;b7bc  60 01 9b
    incw a                  ;b7bf  c0
    mov mem_019b, a         ;b7c0  61 01 9b
    cmp a, #0x03            ;b7c3  14 03
    blo lab_b7cc            ;b7c5  f9 05
    mov a, #0x02            ;b7c7  04 02
    mov mem_019b, a         ;b7c9  61 01 9b
lab_b7cc:
    setb mem_008e:4         ;b7cc  ac 8e
    movw ix, #kw_group_2    ;b7ce  e6 b7 15
    jmp lab_b7fc            ;b7d1  21 b7 fc

lab_b7d4:
;Group Reading related: Group 3 (Antenna)
    mov a, #0x03            ;b7d4  04 03
    mov mem_033f, a         ;b7d6  61 03 3f
    mov a, mem_02d4         ;b7d9  60 02 d4
    bne lab_b7e3            ;b7dc  fc 05
    mov a, #0x01            ;b7de  04 01
    mov mem_02d4, a         ;b7e0  61 02 d4
lab_b7e3:
    call sub_c10e           ;b7e3  31 c1 0e
    movw ix, #kw_group_3    ;b7e6  e6 b7 26
    jmp lab_b7fc            ;b7e9  21 b7 fc

lab_b7ec:
;Group Reading related: Group 4 (Amplifier)
    movw ix, #kw_group_4    ;b7ec  e6 b7 52
    jmp lab_b7fc            ;b7ef  21 b7 fc

lab_b7f2:
;Group Reading related: Group 5 (CD Changer)
    setb mem_008e:2         ;b7f2  aa 8e
    call sub_bc44           ;b7f4  31 bc 44
    clrb mem_008e:2         ;b7f7  a2 8e
    movw ix, #kw_group_5    ;b7f9  e6 b7 34

lab_b7fc:
    mov a, #0x00            ;b7fc  04 00
    mov mem_0194, a         ;b7fe  61 01 94
    jmp lab_b82a            ;b801  21 b8 2a

lab_b804:
;Group Reading related: Group 6 (External Display)
    setb mem_008e:2         ;b804  aa 8e
    call sub_c019           ;b806  31 c0 19
    clrb mem_008e:2         ;b809  a2 8e
    movw ix, #kw_group_6    ;b80b  e6 b7 3f
    jmp lab_b7fc            ;b80e  21 b7 fc

lab_b811:
;Group Reading related: Group 7 (Steering Wheel Control)
    call sub_c08f           ;b811  31 c0 8f
    movw ix, #kw_group_7    ;b814  e6 b7 4a
    jmp lab_b82a            ;b817  21 b8 2a

lab_b81a:
;Group Reading related: Group 25 (Protection)
    mov a, #0x00            ;b81a  04 00
    mov mem_0194, a         ;b81c  61 01 94
    jmp lab_b841            ;b81f  21 b8 41

lab_b822:
;Group Reading related: Unrecognized Group
    mov a, #0x00            ;b822  04 00
    mov mem_0194, a         ;b824  61 01 94
    jmp lab_b8dd            ;b827  21 b8 dd

lab_b82a:
;Called with IX pointing to a KW1281 TX Buffer template (e.g. kw_group_7)
    mov a, mem_0194         ;b82a  60 01 94
    bne lab_b844            ;b82d  fc 15
    mov a, @ix+0x00         ;b82f  06 00        A = number of bytes from template
    mov mem_00a5, a         ;b831  45 a5        Number of bytes in KW1281 packet

    incw ix                 ;b833  c2           Incrment IX to second byte in template (Block length)
    movw ep, #mem_012b      ;b834  e7 01 2b     EP = Pointer to KW1281 TX Buffer byte 0
    call sub_b166           ;b837  31 b1 66

    mov a, mem_0116         ;b83a  60 01 16     A = Block counter copied from KW1281 RX Buffer
    incw a                  ;b83d  c0           Increment block counter
    mov mem_012b+1, a       ;b83e  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter

lab_b841:
    mov mem_0081, #0x03     ;b841  85 81 03

lab_b844:
    ret                     ;b844  20

lab_b845:
;(mem_0080=0x07, mem_0081=3)
;Group Reading related
    mov a, mem_0118+3       ;b845  60 01 1b     KW1281 RX Buffer byte 3: Group number
    jmp lab_b8e3            ;b848  21 b8 e3


lab_b84b:
;Group 1 (General)
    mov a, mem_013e         ;b84b  60 01 3e
    mov mem_012b+8, a       ;b84e  61 01 33     KW1281 TX Buffer byte 8: Supply Voltage (Terminal 30): value b
    mov a, mem_0255         ;b851  60 02 55
    mov mem_012b+0x0b, a    ;b854  61 01 36     KW1281 TX Buffer byte 11: Illumination % (Terminal 5d): value b
    clrb mem_008e:0         ;b857  a0 8e
    mov a, #0x87            ;b859  04 87
    bbc mem_00eb:6, lab_b862 ;b85b  b6 eb 04
    setb mem_008e:0         ;b85e  a8 8e
    mov a, #0x88            ;b860  04 88

lab_b862:
    mov mem_012b+0xe, a     ;b862  61 01 39     KW1281 TX Buffer byte 14: S-Contact Status: value b
    jmp lab_b912            ;b865  21 b9 12


lab_b868:
;Group 2 (Speakers)
    mov a, mem_019b         ;b868  60 01 9b
    cmp a, #0x02            ;b86b  14 02
    blo lab_b881            ;b86d  f9 12
    mov a, mem_02fb         ;b86f  60 02 fb
    call sub_b91d           ;b872  31 b9 1d
    mov mem_012b+8, a       ;b875  61 01 33     KW1281 TX Buffer byte 8: Front Status: value b
    mov a, mem_02fc         ;b878  60 02 fc
    call sub_b91d           ;b87b  31 b9 1d
    mov mem_012b+0xe, a     ;b87e  61 01 39     KW1281 TX Buffer byte 14: Rear Status: value b

lab_b881:
    jmp lab_b912            ;b881  21 b9 12


lab_b884:
;Group 3 (Antenna)
    bbs mem_008d:1, lab_b88b ;b884  b9 8d 04
    mov a, #0x11            ;b887  04 11
    bne lab_b88d            ;b889  fc 02        BRANCH_ALWAYS_TAKEN

lab_b88b:
    mov a, #0x12            ;b88b  04 12

lab_b88d:
    mov mem_012b+5, a       ;b88d  61 01 30     KW1281 TX Buffer byte 5: Antenna Type: value b
    mov a, mem_0141         ;b890  60 01 41
    call sub_b91d           ;b893  31 b9 1d
    mov mem_012b+0x0b, a    ;b896  61 01 36     KW1281 TX Buffer byte 11: Antenna Status: value b
    jmp lab_b912            ;b899  21 b9 12


lab_b89c:
;Group 5 (CD Changer)
    mov a, mem_0142         ;b89c  60 01 42
    call sub_b930           ;b89f  31 b9 30
    mov mem_012b+8, a       ;b8a2  61 01 33     KW1281 TX Buffer byte 8: Status: value b
    jmp lab_b912            ;b8a5  21 b9 12


lab_b8a8:
;Group 6 (External Display)
    mov a, mem_0143         ;b8a8  60 01 43
    call sub_b930           ;b8ab  31 b9 30
    mov mem_012b+8, a       ;b8ae  61 01 33     KW1281 TX Buffer byte 8: Status: value b
    jmp lab_b912            ;b8b1  21 b9 12


lab_b8b4:
;Group 7 (Steering Wheel Control)
    mov a, mem_02cb         ;b8b4  60 02 cb
    mov mem_012b+5, a       ;b8b7  61 01 30     KW1281 TX Buffer byte 5: Steering Wheel Buttons: value b
    cmp a, #0x20            ;b8ba  14 20
    beq lab_b912            ;b8bc  fd 54
    mov a, #0x30            ;b8be  04 30
    mov mem_012b+4, a       ;b8c0  61 01 2f     KW1281 TX Buffer byte 4: Steering Wheel Buttons: value a
    jmp lab_b912            ;b8c3  21 b9 12


lab_b8c6:
;Group 4 (Amplifier)
    mov a, mem_0145         ;b8c6  60 01 45
    cmp a, #0x02            ;b8c9  14 02
    bne lab_b8cf            ;b8cb  fc 02
    mov a, #0x01            ;b8cd  04 01

lab_b8cf:
    mov mem_012b+5, a       ;b8cf  61 01 30     KW1281 TX Buffer byte 5: Amplifier Output: value b
    jmp lab_b912            ;b8d2  21 b9 12


lab_b8d5:
;Group 25 (Protection)
    setb mem_008c:3         ;b8d5  ab 8c        Set bit to unlock protected functions
    call sub_b16b_ack       ;b8d7  31 b1 6b
    jmp lab_b912            ;b8da  21 b9 12

lab_b8dd:
;Unrecognized Group
    call sub_b21f_no_ack    ;b8dd  31 b2 1f
    jmp lab_b912            ;b8e0  21 b9 12


lab_b8e3:
;Called with A = Group Number
    cmp a, #0x01            ;b8e3  14 01
    bne lab_b8ea            ;b8e5  fc 03
    jmp lab_b84b            ;b8e7  21 b8 4b     Group 1 (General)

lab_b8ea:
    cmp a, #0x02            ;b8ea  14 02
    bne lab_b8f1            ;b8ec  fc 03
    jmp lab_b868            ;b8ee  21 b8 68     Group 2 (Speakers)

lab_b8f1:
    cmp a, #0x03            ;b8f1  14 03
    bne lab_b8f8            ;b8f3  fc 03
    jmp lab_b884            ;b8f5  21 b8 84     Group 3 (Antenna)

lab_b8f8:
    cmp a, #0x05            ;b8f8  14 05
    bne lab_b8ff            ;b8fa  fc 03
    jmp lab_b89c            ;b8fc  21 b8 9c     Group 5 (CD Changer)

lab_b8ff:
    cmp a, #0x06            ;b8ff  14 06
    bne lab_b906            ;b901  fc 03
    jmp lab_b8a8            ;b903  21 b8 a8     Group 6 (External Display)?

lab_b906:
    cmp a, #0x07            ;b906  14 07
    beq lab_b8b4            ;b908  fd aa        Group 7 (Steering Wheel Control)

    cmp a, #0x19            ;b90a  14 19
    beq lab_b8d5            ;b90c  fd c7        Group 25 (Protection)

    cmp a, #0x04            ;b90e  14 04
    beq lab_b8c6            ;b910  fd b4        Group 4 (Amplifier)

lab_b912:
    call sub_bba4           ;b912  31 bb a4
    mov mem_0081, #0x04     ;b915  85 81 04
    ret                     ;b918  20

lab_b919:
    call sub_bbc3           ;b919  31 bb c3
    ret                     ;b91c  20

sub_b91d:
    beq lab_b927            ;b91d  fd 08
    cmp a, #0x01            ;b91f  14 01
    beq lab_b92d            ;b921  fd 0a
    cmp a, #0x02            ;b923  14 02
    beq lab_b92a            ;b925  fd 03

lab_b927:
    mov a, #0xc2            ;b927  04 c2
    ret                     ;b929  20

lab_b92a:
    mov a, #0xf2            ;b92a  04 f2
    ret                     ;b92c  20

lab_b92d:
    mov a, #0xf3            ;b92d  04 f3
    ret                     ;b92f  20

sub_b930:
    beq lab_b927            ;b930  fd f5
    cmp a, #0x03            ;b932  14 03
    beq lab_b937            ;b934  fd 01
    ret                     ;b936  20

lab_b937:
    mov a, #0xc3            ;b937  04 c3
    ret                     ;b939  20

mem_0080_is_08:
;KW1281 Recoding
    mov a, mem_0081         ;b93a  05 81
    cmp a, #0x01            ;b93c  14 01
    beq lab_b945            ;b93e  fd 05
    cmp a, #0x02            ;b940  14 02
    beq lab_b970            ;b942  fd 2c
    ret                     ;b944  20

lab_b945:
;Recoding related
;(mem_0080=0x08, mem_0081=1)
    movw a, mem_0118+3      ;b945  c4 01 1b     KW1281 RX Buffer bytes 3 and 4
    call sub_b977           ;b948  31 b9 77     Unknown, uses bin_bcd_table table
                            ;                   Returns carry set/clear for unknown conditions
    bnc lab_b970            ;b94b  f8 23

    movw a, mem_0118+3      ;b94d  c4 01 1b     KW1281 RX Buffer bytes 3 and 4
    movw mem_0175, a        ;b950  d4 01 75

    movw a, mem_0118+5      ;b953  c4 01 1d     KW1281 RX Buffer bytes 5 and 6
    movw mem_0177, a        ;b956  d4 01 77

    setb mem_00b2:7         ;b959  af b2
    call sub_9ed3           ;b95b  31 9e d3

    movw a, #0x0000         ;b95e  e4 00 00     Clear 4 bytes to clear fault:
    movw mem_0165, a        ;b961  d4 01 65     KW1281 Fault 01044 Control Module Incorrectly Coded
    movw mem_0167, a        ;b964  d4 01 67

    clrb mem_0091:3         ;b967  a3 91
    mov mem_00f1, #0xa0     ;b969  85 f1 a0
    mov mem_0081, #0x02     ;b96c  85 81 02
    ret                     ;b96f  20

lab_b970:
;Recoding related
;(mem_0080=0x08, mem_0081=2)
    call sub_b123           ;b970  31 b1 23     New KW1281 state = ID code request/ECU Info
    ret                     ;b973  20

sub_b974:
    movw a, mem_0175        ;b974  c4 01 75

sub_b977:
;Recoding related
;Returns carry set for some condition, carry clear for another
;
    swap                    ;b977  10
    clrc                    ;b978  81
    rorc a                  ;b979  03
    swap                    ;b97a  10
    rorc a                  ;b97b  03

    movw mem_00a8, a        ;b97c  d5 a8

    mov a, mem_00a8         ;b97e  05 a8
    mov mem_00a3, a         ;b980  45 a3

    mov a, mem_00a9         ;b982  05 a9
    mov mem_00a4, a         ;b984  45 a4

    call bin16_to_bcd16     ;Convert 16-bit binary number to BCD.
                            ;  Input word:  mem_00a3
                            ;  Output word: mem_009f

    mov a, mem_009e         ;b989  05 9e
    bne lab_b9db            ;b98b  fc 4e

    mov a, mem_009f         ;b98d  05 9f
    and a, #0xf0            ;b98f  64 f0
    cmp a, #0xa0            ;b991  14 a0
    bhs lab_b9db            ;b993  f8 46

    mov a, mem_009f         ;b995  05 9f
    and a, #0x0f            ;b997  64 0f
    cmp a, #0x05            ;b999  14 05
    bhs lab_b9db            ;b99b  f8 3e

    mov a, mem_00a0         ;b99d  05 a0
    and a, #0xf0            ;b99f  64 f0
    cmp a, #0x30            ;b9a1  14 30
    bhs lab_b9db            ;b9a3  f8 36

    mov a, mem_00a0         ;b9a5  05 a0
    and a, #0x0f            ;b9a7  64 0f
    cmp a, #0x08            ;b9a9  14 08
    bhs lab_b9db            ;b9ab  f8 2e

    mov a, mem_009e         ;b9ad  05 9e
    mov mem_019d, a         ;b9af  61 01 9d
    mov a, mem_009f         ;b9b2  05 9f
    mov mem_019e, a         ;b9b4  61 01 9e
    mov a, mem_00a0         ;b9b7  05 a0
    mov mem_019f, a         ;b9b9  61 01 9f

    call sub_9235           ;b9bc  31 92 35
    cmp mem_0096, #0x01     ;b9bf  95 96 01
    beq lab_b9c7            ;b9c2  fd 03
    call sub_9250           ;b9c4  31 92 50

lab_b9c7:
    mov a, mem_00a0         ;b9c7  05 a0
    and a, #0x01            ;b9c9  64 01
    cmp a, #0x01            ;b9cb  14 01
    bne lab_b9d4            ;b9cd  fc 05
    setb mem_008d:1         ;b9cf  a9 8d
    jmp lab_b9d6            ;b9d1  21 b9 d6

lab_b9d4:
    clrb mem_008d:1         ;b9d4  a1 8d

lab_b9d6:
    call sub_b9dd           ;b9d6  31 b9 dd
    setc                    ;b9d9  91
    ret                     ;b9da  20

lab_b9db:
    clrc                    ;b9db  81
    ret                     ;b9dc  20

sub_b9dd:
    movw a, #0x0000         ;b9dd  e4 00 00
    mov a, mem_019e         ;b9e0  60 01 9e
    and a, #0x0f            ;b9e3  64 0f
    cmp a, #0x05            ;b9e5  14 05
    blo lab_b9eb            ;b9e7  f9 02
    mov a, #0x00            ;b9e9  04 00

lab_b9eb:
    movw a, #mem_b9f4       ;b9eb  e4 b9 f4
    clrc                    ;b9ee  81
    addcw a                 ;b9ef  23
    mov a, @a               ;b9f0  92
    mov mem_00ef, a         ;b9f1  45 ef
    ret                     ;b9f3  20

mem_b9f4:
    .byte 0x00              ;b9f4  00          DATA '\x00'
    .byte 0x03              ;b9f5  03          DATA '\x03'
    .byte 0x0F              ;b9f6  0f          DATA '\x0f'
    .byte 0xF0              ;b9f7  f0          DATA '\xf0'
    .byte 0xFF              ;b9f8  ff          DATA '\xff'

sub_b9f9:
    movw ix, #mem_02d6      ;b9f9  e6 02 d6
    mov a, #0x14            ;b9fc  04 14
    mov @ix+0x03, a         ;b9fe  46 03
    mov @ix+0x07, a         ;ba00  46 07
    mov @ix+0x0b, a         ;ba02  46 0b
    mov @ix+0x0f, a         ;ba04  46 0f
    mov @ix+0x13, a         ;ba06  46 13
    mov @ix+0x17, a         ;ba08  46 17
    mov @ix+0x1b, a         ;ba0a  46 1b
    bne lab_ba2e            ;ba0c  fc 20        BRANCH_ALWAYS_TAKEN

sub_ba0e:
    mov mem_00a0, #0x09     ;ba0e  85 a0 09
    movw ix, #mem_02d6      ;ba11  e6 02 d6

lab_ba14:
    movw a, #0xffff         ;ba14  e4 ff ff
    movw @ix+0x00, a        ;ba17  d6 00
    movw a, #0xff14         ;ba19  e4 ff 14
    movw @ix+0x02, a        ;ba1c  d6 02
    incw ix                 ;ba1e  c2
    incw ix                 ;ba1f  c2
    incw ix                 ;ba20  c2
    incw ix                 ;ba21  c2
    movw a, #0x0000         ;ba22  e4 00 00
    mov a, mem_00a0         ;ba25  05 a0
    decw a                  ;ba27  d0
    mov mem_00a0, a         ;ba28  45 a0
    cmp a, #0x00            ;ba2a  14 00
    bne lab_ba14            ;ba2c  fc e6

lab_ba2e:
    mov mem_00a0, #0x07     ;ba2e  85 a0 07
    movw ix, #mem_0149      ;ba31  e6 01 49     IX = pointer to first fault

lab_ba34:
    movw a, #0x0000         ;ba34  e4 00 00     Clear 4 bytes at pointer for current fault
    movw @ix+0x00, a        ;ba37  d6 00
    movw @ix+0x02, a        ;ba39  d6 02

    incw ix                 ;ba3b  c2           Increment pointer 4 bytes to next fault
    incw ix                 ;ba3c  c2
    incw ix                 ;ba3d  c2
    incw ix                 ;ba3e  c2

    movw a, #0x0000         ;ba3f  e4 00 00     Decrement mem_00a0
    mov a, mem_00a0         ;ba42  05 a0
    decw a                  ;ba44  d0
    mov mem_00a0, a         ;ba45  45 a0

    cmp a, #0x00            ;ba47  14 00
    bne lab_ba34            ;ba49  fc e9        Keep going until 8 fault areas are cleared

    movw a, #0xffff         ;ba4b  e4 ff ff
    movw mem_0161, a        ;ba4e  d4 01 61     KW1281 Fault 65535 Internal Memory Error
    movw a, #0x8800         ;ba51  e4 88 00
    movw mem_0163, a        ;ba54  d4 01 63

    mov mem_0092, #0x00     ;ba57  85 92 00

    mov a, #0x00            ;ba5a  04 00
    mov mem_0091, a         ;ba5c  45 91

    movw a, mem_0165        ;ba5e  c4 01 65
    movw a, #0x0414         ;ba61  e4 04 14     KW1281 Fault 01044 Control Module Incorrectly Coded
    cmpw a                  ;ba64  13
    bne lab_ba6b            ;ba65  fc 04

    mov a, #0b00001000      ;ba67  04 08
    mov mem_0091, a         ;ba69  45 91

lab_ba6b:
    mov a, #0x00            ;ba6b  04 00
    mov mem_030e, a         ;ba6d  61 03 0e
    mov mem_030f, a         ;ba70  61 03 0f
    mov mem_0310, a         ;ba73  61 03 10
    mov mem_0311, a         ;ba76  61 03 11
    ret                     ;ba79  20


mem_0080_is_09:
;KW1281 Login
;
;The password for login is the same as the SAFE code, except it is binary
;instead of BCD.  For example, if the SAFE code is 1234 (BCD 0x1234) then
;the password for login is 0x04D2.
;
;Login request block:
;  0x08 Block length                    mem_0118+0
;  0x3E Block counter                   mem_0118+1
;  0x2B Block title (Login)             mem_0118+2
;  0x04 SAFE code high byte (binary)    mem_0118+3
;  0xD2 SAFE code low byte (binary)     mem_0118+4
;  0x01 Unknown byte 0                  mem_0118+5
;  0x86 Unknown byte 1                  mem_0118+6
;  0x9F Unknown byte 2                  mem_0118+7
;  0x03 Block end                       mem_0118+8
;
    mov a, mem_0081         ;ba7a  05 81
    cmp a, #0x01            ;ba7c  14 01
    beq lab_ba88            ;ba7e  fd 08
    cmp a, #0x02            ;ba80  14 02
    bne lab_ba87            ;ba82  fc 03
    jmp lab_bb13            ;ba84  21 bb 13

lab_ba87:
;Login related
;(mem_0080=0x01, mem_0081 != 1,2)
    ret                     ;ba87  20

lab_ba88:
;Login related
;(mem_0080=0x01, mem_0081=1)
    bbs mem_00de:3, lab_bb0c_no_ack ;If locked out from too many login attempts
                                    ;branch to No Acknowledge

    mov a, mem_0118+3       ;KW1281 RX Buffer byte 3: SAFE code high byte (bin)
    mov mem_00a3, a

    mov a, mem_0118+4       ;KW1281 RX Buffer byte 4: SAFE code low byte (bin)
    mov mem_00a4, a

    call bin16_to_bcd16     ;Convert 16-bit binary number to BCD.
                            ;  Input word:  mem_00a3
                            ;  Output word: mem_009f

    ;Word at mem_020f (actual SAFE code) must match word at
    ;mem_009f (from KW1281 RX buffer after BCD conversion)

    mov a, mem_020f         ;mem_020f and mem_009f must match or login fails
    mov a, mem_009f
    cmp a
    bne lab_baa8_failed

    mov a, mem_020f+1       ;mem_020f+1 and mem_00a0 must match or login fails
    mov a, mem_00a0
    cmp a
    beq lab_baa8_success

lab_baa8_failed:
;Login failed
    mov a, mem_031b         ;Increment login attempt count
    incw a
    mov mem_031b, a

    cmp a, #0x02            ;If less than 2 attempts,
    blo lab_bb0c_ack        ;branch to do nothing and reply with Acknowledge.

    ;Time limited lock out
    mov a, #0x00
    mov mem_031b, a
    movw a, #0x04e2
    movw mem_0305, a
    setb mem_008c:6
    movw a, #0x0e10
    movw mem_0325, a
    setb mem_00de:3         ;Set bit to indicate locked out
    mov mem_00f1, #0x8d
    ret

lab_bb0c_no_ack:
;Login failed from too many attempts
    call sub_b21f_no_ack
    mov mem_0081, #0x02
    ret

lab_baa8_success:
;Login succeeded
    bbc mem_00de:7, lab_baed ;bad3  b7 de 17
    bbs mem_00de:4, lab_baed ;bad6  bc de 14
    bbc mem_00de:5, lab_baed ;bad9  b5 de 11
    mov mem_0096, #0x03     ;badc  85 96 03
    mov mem_00cd, #0x01     ;badf  85 cd 01
    clrb mem_00de:5         ;bae2  a5 de

    movw a, #0x0000         ;bae4  e4 00 00
    mov mem_020e, a         ;bae7  61 02 0e     Reset SAFE attempts
    movw mem_0206, a        ;baea  d4 02 06

lab_baed:
    setb mem_00e4:6         ;baed  ae e4        Set bit to indicate successful login

    mov a, mem_0118+5       ;baef  60 01 1d     KW1281 RX Buffer byte 5: Unknown byte 0
    and a, #0x01            ;baf2  64 01
    mov a, mem_0176         ;baf4  60 01 76
    and a, #0xfe            ;baf7  64 fe
    or a                    ;baf9  72
    mov mem_0176, a         ;bafa  61 01 76

    mov a, mem_0118+6       ;bafd  60 01 1e     KW1281 RX Buffer byte 6: Unknown byte 1
    mov mem_0177, a         ;bb00  61 01 77

    mov a, mem_0118+7       ;bb03  60 01 1f     KW1281 RX Buffer byte 7: Unknown byte 2
    mov mem_0178, a         ;bb06  61 01 78

    mov mem_00f1, #0xad     ;bb09  85 f1 ad

lab_bb0c_ack:
    call sub_b16b_ack       ;bb0c  31 b1 6b
    mov mem_0081, #0x02     ;bb0f  85 81 02
    ret                     ;bb12  20

lab_bb13:
;Login related
;(mem_0080=0x01, mem_0081=2)
    call sub_bbc3           ;bb13  31 bb c3
    ret                     ;bb16  20


mem_0080_is_0b_or_0c:
;KW1281 Read ROM or Read EEPROM entry point
;
;Request block format:
;  0x06 Block length                    mem_0118+0
;  0x3E Block counter                   mem_0118+1
;  0x03 Block title (0x03 or 0x19)      mem_0118+2  (0x03=ROM, 0x19=EEPROM)
;  0x00 Number of bytes to read         mem_0118+3
;  0x00 Address high                    mem_0118+4  (Only address low byte is
;  0x00 Address low                     mem_0118+5   used in case of EEPROM)
;  0x03 Block end                       mem_0119+6
;
    mov a, mem_0081         ;bb17  05 81
    cmp a, #0x02            ;bb19  14 02
    beq lab_bb1f            ;bb1b  fd 02
    bne lab_bb29            ;bb1d  fc 0a        BRANCH_ALWAYS_TAKEN

lab_bb1f:
    mov a, #0xfd            ;bb1f  04 fd        0xFD = KW1281 Block title: Response to Read EEPROM
    bne lab_bb4a            ;bb21  fc 27        BRANCH_ALWAYS_TAKEN


mem_0080_is_0a:
;KW1281 Read RAM
;
;Request block format:
;  0x06 Block length                    mem_0118+0
;  0x3E Block counter                   mem_0118+1
;  0x01 Block title (0x01)              mem_0118+2
;  0x00 Number of bytes to read         mem_0118+3
;  0x00 Address high                    mem_0118+4
;  0x00 Address low                     mem_0118+5
;  0x03 Block end                       mem_0119+6
;
    mov a, mem_0081         ;bb23  05 81
    cmp a, #0x02            ;bb25  14 02
    beq lab_bb48            ;bb27  fd 1f

lab_bb29:
;Read RAM related
;Read ROM or Read EEPROM related
    cmp a, #0x01            ;bb29  14 01
    beq lab_bb3e            ;bb2b  fd 11
    cmp a, #0x03            ;bb2d  14 03
    beq lab_bb6d            ;bb2f  fd 3c
    cmp a, #0x04            ;bb31  14 04
    beq lab_bb73            ;bb33  fd 3e
    cmp a, #0x05            ;bb35  14 05
    beq lab_bb93            ;bb37  fd 5a
    cmp a, #0x06            ;bb39  14 06
    beq lab_bb9a            ;bb3b  fd 5d
    ret                     ;bb3d  20

lab_bb3e:
;Read RAM related
;Read ROM or Read EEPROM related
;(mem_0080=x, mem_0081=1)
    movw a, mem_0118+6      ;bb3e  c4 01 1e     KW1281 RX Buffer bytes 6 and 7
    movw mem_0147, a        ;bb41  d4 01 47     XXX mem_0147 will be overwritten lab_bb4a,
                            ;                       so RX Buffer bytes 6 and 7 are thrown away.
                            ;                       Is this a bug?
    mov mem_0081, #0x02     ;bb44  85 81 02
    ret                     ;bb47  20

lab_bb48:
;Read RAM related
;(mem_0080=0x0a, mem_0081=2)
    mov a, #0xfe            ;bb48  04 fe        0xFE = KW1281 Block title: Response to Read RAM

lab_bb4a:
;Read RAM related
;Read ROM or Read EEPROM related
    mov mem_012b+2, a       ;bb4a  61 01 2d     KW1281 TX Buffer byte 2: Block title

    movw a, mem_0118+4      ;bb4d  c4 01 1c     KW1281 RX Buffer bytes 4 and 5 (Address to read)
    movw mem_0147, a        ;bb50  d4 01 47

    mov a, mem_0118+3       ;bb53  60 01 1b     KW1281 RX Buffer byte 3 (Number of bytes to read)
    clrc                    ;bb56  81
    addc a, #0x03           ;bb57  24 03        Add 3 for Block counter, Block title, Block end
    mov mem_012b+0, a       ;bb59  61 01 2b     KW1281 TX Buffer byte 0: Block length

    call sub_bbb8           ;bb5c  31 bb b8     Sets KW1281 TX Buffer byte 1: Block counter

    mov a, #0x03            ;bb5f  04 03        0x03 = Block end? TODO
    mov mem_012b+3, a       ;bb61  61 01 2e     KW1281 TX Buffer byte 3

    mov mem_0081, #0x03     ;bb64  85 81 03
    mov a, #0x03            ;bb67  04 03
    mov mem_0115, a         ;bb69  61 01 15
    ret                     ;bb6c  20

lab_bb6d:
;Read RAM related
;Read ROM or Read EEPROM related
;(mem_0080=x, mem_0081=3)
    mov a, #0x04            ;bb6d  04 04
    call sub_bbd3           ;bb6f  31 bb d3
    ret                     ;bb72  20

lab_bb73:
;Read RAM related
;Read ROM or Read EEPROM related
;(mem_0080=x, mem_0081=4)
    bbc mem_008b:0, lab_bb81 ;bb73  b0 8b 0b
    clrb mem_008b:0          ;bb76  a0 8b
    bbc mem_008b:7, lab_bb82 ;bb78  b7 8b 07
    call sub_b20c_no_ack     ;bb7b  31 b2 0c
    mov mem_0081, #0x03      ;bb7e  85 81 03

lab_bb81:
    ret                     ;bb81  20

lab_bb82:
    mov a, mem_0118+2       ;bb82  60 01 1a     KW1281 RX Buffer byte 2: Block title
    cmp a, #0x0a            ;bb85  14 0a        Is it 0x0A (No Acknowledge)?
    bne lab_bb8f            ;bb87  fc 06
    ;Block title = 0x0a (No Acknowledge)
    mov a, #0x03            ;bb89  04 03        A = value to store in mem_0081
    call sub_b1c1           ;bb8b  31 b1 c1
    ret                     ;bb8e  20

lab_bb8f:
;Block title != 0x0a (No Acknowledge)
    mov mem_0081, #0x05     ;bb8f  85 81 05
    ret                     ;bb92  20

lab_bb93:
;Read RAM related
;Read EEPROM related
;(mem_0080=x, mem_0081=5)
    call sub_b16b_ack       ;bb93  31 b1 6b
    mov mem_0081, #0x06     ;bb96  85 81 06
    ret                     ;bb99  20

lab_bb9a:
;Read RAM related
;Read EEPROM related
;(mem_0080=x, mem_0081=6)
    call sub_bbc3           ;bb9a  31 bb c3
    ret                     ;bb9d  20


mem_0080_is_0f:
;KW1281 End Session
    setb mem_008c:6         ;bb9e  ae 8c
    ret                     ;bba0  20


sub_bba1:
    call sub_b136           ;bba1  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

sub_bba4:
    mov a, #0x01            ;bba4  04 01
    mov mem_0115, a         ;bba6  61 01 15
    bne call_sub_bbbf       ;bba9  fc 14        BRANCH_ALWAYS_TAKEN

sub_bbab:
    call sub_b136           ;bbab  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

sub_bbae:
    mov a, #0x01            ;bbae  04 01
    mov mem_0115, a         ;bbb0  61 01 15
    mov a, #0x64            ;bbb3  04 64
    mov mem_032e, a         ;bbb5  61 03 2e

sub_bbb8:
    mov a, mem_0116         ;bbb8  60 01 16     A = Block counter copied from KW1281 RX Buffer
    incw a                  ;bbbb  c0           Increment block counter
    mov mem_012b+1, a       ;bbbc  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter

call_sub_bbbf:
    call reset_kw_counts    ;bbbf  31 e0 b8     Reset counts of KW1281 bytes received, sent
    ret                     ;bbc2  20

sub_bbc3:
    bbc mem_008b:1, lab_bbd2 ;bbc3  b1 8b 0c
    clrb mem_008b:1         ;bbc6  a1 8b
    mov a, #0x02            ;bbc8  04 02
    mov mem_0114, a         ;bbca  61 01 14
    mov mem_0081, #0x00     ;bbcd  85 81 00
    clrb mem_008b:2         ;bbd0  a2 8b

lab_bbd2:
    ret                     ;bbd2  20

sub_bbd3:
    bbc mem_008b:1, lab_bbdf ;bbd3  b1 8b 09
    clrb mem_008b:1         ;bbd6  a1 8b
    mov mem_0081, a         ;bbd8  45 81
    mov a, #0x02            ;bbda  04 02
    mov mem_0114, a         ;bbdc  61 01 14

lab_bbdf:
    ret                     ;bbdf  20

sub_bbe0:
    bbc mem_008b:0, lab_bc01 ;bbe0  b0 8b 1e
    clrb mem_008b:0          ;bbe3  a0 8b
    bbc mem_008b:7, lab_bbf0 ;bbe5  b7 8b 08
    call sub_b20c_no_ack     ;bbe8  31 b2 0c
    mov a, mem_00a0          ;bbeb  05 a0       A = value to store in mem_0081
    mov mem_0081, a          ;bbed  45 81
    ret                      ;bbef  20

lab_bbf0:
    mov a, mem_0118+2       ;bbf0  60 01 1a     KW1281 RX Buffer byte 2: Block title
    cmp a, #0x0a            ;bbf3  14 0a        Is it 0x0A (No Acknowledge)?
    bne lab_bbfd            ;bbf5  fc 06
    ;Block title = 0x0a (No Acknowledge)
    mov a, mem_00a1         ;bbf7  05 a1        A = value to store in mem_0081
    call sub_b1b2           ;bbf9  31 b1 b2
    ret                     ;bbfc  20

lab_bbfd:
;Block title != 0x0a (No Acknowledge)
    mov a, mem_00a2         ;bbfd  05 a2        A = value to store in mem_0081
    mov mem_0081, a         ;bbff  45 81

lab_bc01:
    ret                     ;bc01  20

sub_bc02:
    mov a, #0x40            ;bc02  04 40
    movw ix, #mem_0249      ;bc04  e6 02 49
    call sub_8571           ;bc07  31 85 71
    setb mem_0091:1         ;bc0a  a9 91        KW1281 Fault 00668 - Supply Voltage Terminal 30
    movw ix, #mem_02da      ;bc0c  e6 02 da
    movw a, mem_0249        ;bc0f  c4 02 49
    movw a, #0x01ad         ;bc12  e4 01 ad
    cmpw a                  ;bc15  13
    blo lab_bc1e            ;bc16  f9 06
    clrb mem_0091:1         ;bc18  a1 91        KW1281 Fault 00668 - Supply Voltage Terminal 30
    mov a, #0x00            ;bc1a  04 00
    beq lab_bc31            ;bc1c  fd 13        BRANCH_ALWAYS_TAKEN

lab_bc1e:
    xchw a, t               ;bc1e  43
    movw a, #0x0170         ;bc1f  e4 01 70
    cmpw a                  ;bc22  13
    bhs lab_bc29            ;bc23  f8 04
    mov a, #0x02            ;bc25  04 02
    bne lab_bc31            ;bc27  fc 08        BRANCH_ALWAYS_TAKEN

lab_bc29:
    mov a, #0x14            ;bc29  04 14
    mov @ix+0x03, a         ;bc2b  46 03
    clrb mem_0091:1         ;bc2d  a1 91        KW1281 Fault 00668 - Supply Voltage Terminal 30
    mov a, #0x01            ;bc2f  04 01

lab_bc31:
    mov @ix+0x00, a         ;bc31  46 00
    movw a, mem_0249        ;bc33  c4 02 49
    clrc                    ;bc36  81
    swap                    ;bc37  10
    rorc a                  ;bc38  03
    swap                    ;bc39  10
    rorc a                  ;bc3a  03
    clrc                    ;bc3b  81
    swap                    ;bc3c  10
    rorc a                  ;bc3d  03
    swap                    ;bc3e  10
    rorc a                  ;bc3f  03
    mov mem_013e, a         ;bc40  61 01 3e
    ret                     ;bc43  20

sub_bc44:
    movw ix, #mem_02ee      ;bc44  e6 02 ee
    bbs mem_008e:2, lab_bc51 ;bc47  ba 8e 07
    mov a, mem_019f         ;bc4a  60 01 9f
    and a, #0x02            ;bc4d  64 02
    beq lab_bc54            ;bc4f  fd 03

lab_bc51:
    bbc mem_00e0:1, lab_bc5a ;bc51  b1 e0 06

lab_bc54:
    clrb mem_0091:4         ;bc54  a4 91        KW1281 Fault 00855 - Connection to CD changer
    mov a, #0x00            ;bc56  04 00
    beq lab_bc5e            ;bc58  fd 04        BRANCH_ALWAYS_TAKEN

lab_bc5a:
    setb mem_0091:4         ;bc5a  ac 91        KW1281 Fault 00855 - Connection to CD changer
    mov a, #0x03            ;bc5c  04 03

lab_bc5e:
    mov @ix+0x00, a         ;bc5e  46 00
    mov mem_0142, a         ;bc60  61 01 42
    ret                     ;bc63  20

sub_bc64:
    mov a, mem_02d2         ;bc64  60 02 d2
    cmp a, #0x01            ;bc67  14 01
    beq lab_bc74            ;bc69  fd 09
    cmp a, #0x02            ;bc6b  14 02
    beq lab_bc82            ;bc6d  fd 13
    cmp a, #0x03            ;bc6f  14 03
    beq lab_bc8f            ;bc71  fd 1c
    ret                     ;bc73  20

lab_bc74:
    clrb pdr8:4             ;bc74  a4 14        AMP_ON=low
    mov a, #0x02            ;bc76  04 02
    mov a, #0xc8            ;bc78  04 c8

lab_bc7a:
    mov mem_02d3, a         ;bc7a  61 02 d3
    xch a, t                ;bc7d  42

lab_bc7e:
    mov mem_02d2, a         ;bc7e  61 02 d2

lab_bc81:
    ret                     ;bc81  20

lab_bc82:
    mov a, mem_02d3         ;bc82  60 02 d3
    bne lab_bc81            ;bc85  fc fa
    setb pdr8:4             ;bc87  ac 14        AMP_ON=high
    mov a, #0x03            ;bc89  04 03
    mov a, #0x46            ;bc8b  04 46
    bne lab_bc7a            ;bc8d  fc eb        BRANCH_ALWAYS_TAKEN

lab_bc8f:
    mov a, mem_02d3         ;bc8f  60 02 d3
    bne lab_bc81            ;bc92  fc ed
    call sub_bd00           ;bc94  31 bd 00
    mov mem_02fb, a         ;bc97  61 02 fb
    call sub_bd0e           ;bc9a  31 bd 0e
    mov mem_02fc, a         ;bc9d  61 02 fc
    mov a, mem_02fb         ;bca0  60 02 fb
    cmp a, #0x02            ;bca3  14 02
    bne lab_bcbd            ;bca5  fc 16
    mov a, mem_0341         ;bca7  60 03 41
    and a, #0x01            ;bcaa  64 01
    bne lab_bcc5            ;bcac  fc 17
    mov a, mem_0341         ;bcae  60 03 41
    or a, #0x01             ;bcb1  74 01
    mov mem_0341, a         ;bcb3  61 03 41
    mov a, #0x14            ;bcb6  04 14
    mov mem_02e5, a         ;bcb8  61 02 e5
    bne lab_bcc5            ;bcbb  fc 08        BRANCH_ALWAYS_TAKEN

lab_bcbd:
    mov a, mem_0341         ;bcbd  60 03 41
    and a, #0xfe            ;bcc0  64 fe
    mov mem_0341, a         ;bcc2  61 03 41

lab_bcc5:
    mov a, mem_02fc         ;bcc5  60 02 fc
    cmp a, #0x02            ;bcc8  14 02
    bne lab_bce2            ;bcca  fc 16
    mov a, mem_0341         ;bccc  60 03 41
    and a, #0x02            ;bccf  64 02
    bne lab_bcea            ;bcd1  fc 17
    mov a, mem_0341         ;bcd3  60 03 41
    or a, #0x02             ;bcd6  74 02
    mov mem_0341, a         ;bcd8  61 03 41
    mov a, #0x14            ;bcdb  04 14
    mov mem_02e9, a         ;bcdd  61 02 e9
    bne lab_bcea            ;bce0  fc 08        BRANCH_ALWAYS_TAKEN

lab_bce2:
    mov a, mem_0341         ;bce2  60 03 41
    and a, #0xfd            ;bce5  64 fd
    mov mem_0341, a         ;bce7  61 03 41

lab_bcea:
    mov a, #0x00            ;bcea  04 00
    beq lab_bc7e            ;bcec  fd 90        BRANCH_ALWAYS_TAKEN

;XXX bcee looks unreachable
lab_bcee:
    mov mem_009f, a         ;bcee  45 9f
    cmp a, #0x01            ;bcf0  14 01
    bne lab_bcfd            ;bcf2  fc 09
    mov a, mem_030a         ;bcf4  60 03 0a
    beq lab_bcfd            ;bcf7  fd 04
    mov a, #0x00            ;bcf9  04 00
    mov mem_009f, a         ;bcfb  45 9f

lab_bcfd:
    mov a, mem_009f         ;bcfd  05 9f
    ret                     ;bcff  20

sub_bd00:
    mov a, mem_03b5         ;bd00  60 03 b5

lab_bd03:
    movw a, #0x000f         ;bd03  e4 00 0f
    andw a                  ;bd06  63
    movw a, #mem_bd38       ;bd07  e4 bd 38
    clrc                    ;bd0a  81
    addcw a                 ;bd0b  23
    mov a, @a               ;bd0c  92
    ret                     ;bd0d  20

sub_bd0e:
    mov a, mem_03b5         ;bd0e  60 03 b5

lab_bd11:
    rorc a                  ;bd11  03
    rorc a                  ;bd12  03
    rorc a                  ;bd13  03
    rorc a                  ;bd14  03
    jmp lab_bd03            ;bd15  21 bd 03

sub_bd18:
    mov a, mem_03b5         ;bd18  60 03 b5
    andw a                  ;bd1b  63
    jmp lab_bd03            ;bd1c  21 bd 03

sub_bd1f:
    mov a, mem_03b5         ;bd1f  60 03 b5
    andw a                  ;bd22  63
    jmp lab_bd11            ;bd23  21 bd 11

sub_bd26:
    mov a, mem_00a2         ;bd26  05 a2
    cmp a, #0x01            ;bd28  14 01
    bne lab_bd2e            ;bd2a  fc 02
    mov a, #0x00            ;bd2c  04 00

lab_bd2e:
    mov a, mem_00a1         ;bd2e  05 a1
    or a                    ;bd30  72
    cmp a, #0x03            ;bd31  14 03
    bne lab_bd37            ;bd33  fc 02
    mov a, #0x02            ;bd35  04 02

lab_bd37:
    ret                     ;bd37  20

mem_bd38:
    .byte 0x00              ;bd38  00          DATA '\x00'
    .byte 0x01              ;bd39  01          DATA '\x01'
    .byte 0x02              ;bd3a  02          DATA '\x02'
    .byte 0x00              ;bd3b  00          DATA '\x00'
    .byte 0x01              ;bd3c  01          DATA '\x01'
    .byte 0x01              ;bd3d  01          DATA '\x01'
    .byte 0x02              ;bd3e  02          DATA '\x02'
    .byte 0x01              ;bd3f  01          DATA '\x01'
    .byte 0x02              ;bd40  02          DATA '\x02'
    .byte 0x02              ;bd41  02          DATA '\x02'
    .byte 0x02              ;bd42  02          DATA '\x02'
    .byte 0x02              ;bd43  02          DATA '\x02'
    .byte 0x00              ;bd44  00          DATA '\x00'
    .byte 0x01              ;bd45  01          DATA '\x01'
    .byte 0x02              ;bd46  02          DATA '\x02'
    .byte 0x00              ;bd47  00          DATA '\x00'

sub_bd48:
    mov a, mem_03b5         ;bd48  60 03 b5
    mov mem_0307, a         ;bd4b  61 03 07
    movw ix, #mem_02e2      ;bd4e  e6 02 e2
    bbs mem_008e:6, lab_bd66 ;bd51  be 8e 12
    mov a, mem_030a         ;bd54  60 03 0a
    beq lab_bd66            ;bd57  fd 0d
    mov a, #0x00            ;bd59  04 00
    mov mem_030c, a         ;bd5b  61 03 0c
    mov mem_013f, a         ;bd5e  61 01 3f
    mov @ix+0x00, a         ;bd61  46 00
    clrb mem_0091:5         ;bd63  a5 91        KW1281 Fault 00852 - Loudspeaker(s) Front
    ret                     ;bd65  20

lab_bd66:
    movw a, #0x0000         ;bd66  e4 00 00
    mov a, mem_00ef         ;bd69  05 ef
    bne lab_bd75            ;bd6b  fc 08
    mov a, #0xff            ;bd6d  04 ff
    call sub_bd18           ;bd6f  31 bd 18
    jmp lab_bd88            ;bd72  21 bd 88

lab_bd75:
    mov a, mem_00ef         ;bd75  05 ef
    call sub_bd18           ;bd77  31 bd 18
    mov mem_00a1, a         ;bd7a  45 a1
    mov a, mem_00ef         ;bd7c  05 ef
    xor a, #0xff            ;bd7e  54 ff
    call sub_bd18           ;bd80  31 bd 18
    mov mem_00a2, a         ;bd83  45 a2
    call sub_bd26           ;bd85  31 bd 26

lab_bd88:
    mov @ix+0x00, a         ;bd88  46 00
    mov mem_013f, a         ;bd8a  61 01 3f
    mov a, mem_013f         ;bd8d  60 01 3f
    bne lab_bda6            ;bd90  fc 14
    clrb mem_0091:5         ;bd92  a5 91        KW1281 Fault 00852 - Loudspeaker(s) Front
    mov a, mem_030c         ;bd94  60 03 0c
    beq lab_bdbd            ;bd97  fd 24
    bbs mem_008e:6, lab_bdbd ;bd99  be 8e 21
    mov @ix+0x00, a         ;bd9c  46 00
    mov mem_013f, a         ;bd9e  61 01 3f
    setb mem_0091:5         ;bda1  ad 91        KW1281 Fault 00852 - Loudspeaker(s) Front
    jmp lab_bdbd            ;bda3  21 bd bd

lab_bda6:
    setb mem_0091:5         ;bda6  ad 91        KW1281 Fault 00852 - Loudspeaker(s) Front
    mov a, mem_02e5         ;bda8  60 02 e5
    bne lab_bdbd            ;bdab  fc 10
    mov a, mem_02e4         ;bdad  60 02 e4
    cmp a, #0x01            ;bdb0  14 01
    beq lab_bdb8            ;bdb2  fd 04
    cmp a, #0x02            ;bdb4  14 02
    bne lab_bdbd            ;bdb6  fc 05

lab_bdb8:
    mov a, #0x00            ;bdb8  04 00
    mov mem_030c, a         ;bdba  61 03 0c

lab_bdbd:
    ret                     ;bdbd  20

sub_bdbe:
    movw ix, #mem_02e6      ;bdbe  e6 02 e6
    bbs mem_008e:6, lab_bdd6 ;bdc1  be 8e 12
    mov a, mem_030a         ;bdc4  60 03 0a
    beq lab_bdd6            ;bdc7  fd 0d
    mov a, #0x00            ;bdc9  04 00
    mov mem_030d, a         ;bdcb  61 03 0d
    mov mem_0140, a         ;bdce  61 01 40
    mov @ix+0x00, a         ;bdd1  46 00
    clrb mem_0091:6         ;bdd3  a6 91        KW1281 Fault 00853 - Loudspeaker(s) Rear
    ret                     ;bdd5  20

lab_bdd6:
    movw a, #0x0000         ;bdd6  e4 00 00
    mov a, mem_00ef         ;bdd9  05 ef
    bne lab_bde5            ;bddb  fc 08
    mov a, #0xff            ;bddd  04 ff
    call sub_bd1f           ;bddf  31 bd 1f
    jmp lab_bdf8            ;bde2  21 bd f8

lab_bde5:
    mov a, mem_00ef         ;bde5  05 ef
    call sub_bd1f           ;bde7  31 bd 1f
    mov mem_00a1, a         ;bdea  45 a1
    mov a, mem_00ef         ;bdec  05 ef
    xor a, #0xff            ;bdee  54 ff
    call sub_bd1f           ;bdf0  31 bd 1f
    mov mem_00a2, a         ;bdf3  45 a2
    call sub_bd26           ;bdf5  31 bd 26

lab_bdf8:
    mov @ix+0x00, a         ;bdf8  46 00
    mov mem_0140, a         ;bdfa  61 01 40
    mov a, mem_0140         ;bdfd  60 01 40
    bne lab_be16            ;be00  fc 14
    clrb mem_0091:6         ;be02  a6 91        KW1281 Fault 00853 - Loudspeaker(s) Rear
    mov a, mem_030d         ;be04  60 03 0d
    beq lab_be2d            ;be07  fd 24
    bbs mem_008e:6, lab_be2d ;be09  be 8e 21
    mov @ix+0x00, a         ;be0c  46 00
    mov mem_0140, a         ;be0e  61 01 40
    setb mem_0091:6         ;be11  ae 91        KW1281 Fault 00853 - Loudspeaker(s) Rear
    jmp lab_be2d            ;be13  21 be 2d

lab_be16:
    setb mem_0091:6         ;be16  ae 91        KW1281 Fault 00853 - Loudspeaker(s) Rear
    mov a, mem_02e9         ;be18  60 02 e9
    bne lab_be2d            ;be1b  fc 10
    mov a, mem_02e8         ;be1d  60 02 e8
    cmp a, #0x01            ;be20  14 01
    beq lab_be28            ;be22  fd 04
    cmp a, #0x02            ;be24  14 02
    bne lab_be2d            ;be26  fc 05

lab_be28:
    mov a, #0x00            ;be28  04 00
    mov mem_030d, a         ;be2a  61 03 0d

lab_be2d:
    ret                     ;be2d  20

sub_be2e:
    mov a, @ix+0x00         ;be2e  06 00
    mov a, #0x01            ;be30  04 01
    cmp a                   ;be32  12
    bne lab_be41            ;be33  fc 0c
    mov a, @ix+0x03         ;be35  06 03
    mov a, #0x0e            ;be37  04 0e
    cmp a                   ;be39  12
    beq lab_be3e            ;be3a  fd 02
    bhs lab_be41            ;be3c  f8 03

lab_be3e:
    mov @ix+0x03, #0x01     ;be3e  86 03 01

lab_be41:
    ret                     ;be41  20

mem_be42:
    .byte 0x00              ;be42  00          DATA '\x00'
    .byte 0x00              ;be43  00          DATA '\x00'
    .byte 0x00              ;be44  00          DATA '\x00'
    .byte 0x02              ;be45  02          DATA '\x02'
    .byte 0x00              ;be46  00          DATA '\x00'
    .byte 0x00              ;be47  00          DATA '\x00'
    .byte 0x00              ;be48  00          DATA '\x00'
    .byte 0x02              ;be49  02          DATA '\x02'
    .byte 0x00              ;be4a  00          DATA '\x00'
    .byte 0x00              ;be4b  00          DATA '\x00'
    .byte 0x00              ;be4c  00          DATA '\x00'
    .byte 0x02              ;be4d  02          DATA '\x02'
    .byte 0x02              ;be4e  02          DATA '\x02'
    .byte 0x02              ;be4f  02          DATA '\x02'
    .byte 0x02              ;be50  02          DATA '\x02'
    .byte 0x02              ;be51  02          DATA '\x02'

sub_be52:
    mov a, mem_019c         ;be52  60 01 9c
    cmp a, #0x08            ;be55  14 08
    bhs lab_be87            ;be57  f8 2e

    mov a, mem_019c         ;be59  60 01 9c     A = table index
    movw a, #mem_be62       ;be5c  e4 be 62     A = table base address
    jmp sub_e73c            ;be5f  21 e7 3c     Jump to address in table

mem_be62:
    .word lab_be87          ;be62  be 87       VECTOR
    .word lab_be72          ;be64  be 72       VECTOR
    .word lab_be88          ;be66  be 88       VECTOR
    .word lab_be95          ;be68  be 95       VECTOR
    .word lab_bea5          ;be6a  be a5       VECTOR
    .word lab_bf0e          ;be6c  bf 0e       VECTOR
    .word lab_bf34          ;be6e  bf 34       VECTOR
    .word lab_bf5d          ;be70  bf 5d       VECTOR

lab_be72:
    movw a, mem_0294        ;be72  c4 02 94
    movw mem_032c, a        ;be75  d4 03 2c
    movw a, #0x0400         ;be78  e4 04 00
    movw mem_0294, a        ;be7b  d4 02 94
    setb mem_0098:6         ;be7e  ae 98
    setb mem_00b2:5         ;be80  ad b2
    mov a, #0x02            ;be82  04 02

lab_be84:
    mov mem_019c, a         ;be84  61 01 9c

lab_be87:
    ret                     ;be87  20

lab_be88:
    clrb pdr8:4             ;be88  a4 14        AMP_ON=low
    mov a, #0xc8            ;be8a  04 c8
    mov mem_02d3, a         ;be8c  61 02 d3

lab_be8f:
    mov a, #0x03            ;be8f  04 03

lab_be91:
    mov mem_019c, a         ;be91  61 01 9c
    ret                     ;be94  20

lab_be95:
    mov a, mem_02d3         ;be95  60 02 d3
    bne lab_be8f            ;be98  fc f5
    setb pdr8:4             ;be9a  ac 14        AMP_ON=high
    mov a, #0x50            ;be9c  04 50
    mov mem_02d3, a         ;be9e  61 02 d3

lab_bea1:
    mov a, #0x04            ;bea1  04 04
    bne lab_be91            ;bea3  fc ec        BRANCH_ALWAYS_TAKEN

lab_bea5:
    mov a, mem_02d3         ;bea5  60 02 d3
    bne lab_bea1            ;bea8  fc f7
    setb mem_008e:6         ;beaa  ae 8e
    call sub_bd48           ;beac  31 bd 48
    call sub_bdbe           ;beaf  31 bd be
    clrb mem_008e:6         ;beb2  a6 8e
    mov mem_00d6, #0x03     ;beb4  85 d6 03
    mov a, mem_013f         ;beb7  60 01 3f
    beq lab_bed4            ;beba  fd 18
    clrb mem_00d6:1         ;bebc  a1 d6
    mov a, mem_02e2         ;bebe  60 02 e2
    mov a, #0x01            ;bec1  04 01
    cmp a                   ;bec3  12
    bne lab_becd            ;bec4  fc 07
    mov a, mem_00ef         ;bec6  05 ef
    bne lab_becd            ;bec8  fc 03
    jmp lab_becf            ;beca  21 be cf

lab_becd:
    setb mem_008d:2         ;becd  aa 8d

lab_becf:
    mov a, #0x00            ;becf  04 00
    mov mem_030c, a         ;bed1  61 03 0c

lab_bed4:
    mov a, mem_0140         ;bed4  60 01 40
    beq lab_bef1            ;bed7  fd 18
    clrb mem_00d6:0         ;bed9  a0 d6
    mov a, mem_02e6         ;bedb  60 02 e6
    mov a, #0x01            ;bede  04 01
    cmp a                   ;bee0  12
    bne lab_beea            ;bee1  fc 07
    mov a, mem_00ef         ;bee3  05 ef
    bne lab_beea            ;bee5  fc 03
    jmp lab_beec            ;bee7  21 be ec

lab_beea:
    setb mem_008d:3         ;beea  ab 8d

lab_beec:
    mov a, #0x00            ;beec  04 00
    mov mem_030d, a         ;beee  61 03 0d

lab_bef1:
    mov a, mem_00d6         ;bef1  05 d6
    beq lab_bf00            ;bef3  fd 0b
    setb mem_008d:6         ;bef5  ae 8d
    mov a, #0x0a            ;bef7  04 0a
    mov mem_02d3, a         ;bef9  61 02 d3

lab_befc:
    mov a, #0x05            ;befc  04 05
    bne lab_be91            ;befe  fc 91        BRANCH_ALWAYS_TAKEN

lab_bf00:
    movw a, mem_032c        ;bf00  c4 03 2c
    movw mem_0294, a        ;bf03  d4 02 94
    setb mem_0098:6         ;bf06  ae 98
    setb mem_00b2:5         ;bf08  ad b2
    mov a, #0x00            ;bf0a  04 00
    beq lab_be91            ;bf0c  fd 83        BRANCH_ALWAYS_TAKEN

lab_bf0e:
    mov a, mem_02d3         ;bf0e  60 02 d3
    bne lab_befc            ;bf11  fc e9
    mov a, #0x10            ;bf13  04 10
    mov mem_0320, a         ;bf15  61 03 20
    mov mem_00ee, #0x80     ;bf18  85 ee 80
    mov a, mem_0293         ;bf1b  60 02 93
    mov mem_0192, a         ;bf1e  61 01 92
    mov a, #0x28            ;bf21  04 28
    mov mem_0293, a         ;bf23  61 02 93
    setb mem_0098:6         ;bf26  ae 98
    setb mem_00b2:5         ;bf28  ad b2
    mov a, #0x32            ;bf2a  04 32
    mov mem_02d3, a         ;bf2c  61 02 d3

lab_bf2f:
    mov a, #0x06            ;bf2f  04 06
    jmp lab_be91            ;bf31  21 be 91

lab_bf34:
    mov a, mem_02d3         ;bf34  60 02 d3
    bne lab_bf2f            ;bf37  fc f6
    mov mem_00ee, #0x00     ;bf39  85 ee 00
    mov a, #0x00            ;bf3c  04 00
    mov mem_0320, a         ;bf3e  61 03 20
    mov a, mem_0192         ;bf41  60 01 92
    mov mem_0293, a         ;bf44  61 02 93
    movw a, mem_032c        ;bf47  c4 03 2c
    movw mem_0294, a        ;bf4a  d4 02 94
    setb mem_0097:6         ;bf4d  ae 97
    setb mem_00b2:5         ;bf4f  ad b2
    clrb mem_008d:6         ;bf51  a6 8d
    mov a, #0x8c            ;bf53  04 8c
    mov mem_02d3, a         ;bf55  61 02 d3

lab_bf58:
    mov a, #0x07            ;bf58  04 07
    jmp lab_be91            ;bf5a  21 be 91

lab_bf5d:
    mov a, mem_02d3         ;bf5d  60 02 d3
    bne lab_bf58            ;bf60  fc f6
    bbc mem_00d6:1, lab_bf88 ;bf62  b1 d6 23
    movw a, #0x0000         ;bf65  e4 00 00
    mov a, mem_03b5         ;bf68  60 03 b5
    mov mem_0342, a         ;bf6b  61 03 42
    and a, #0x0f            ;bf6e  64 0f
    movw a, #mem_be42       ;bf70  e4 be 42
    clrc                    ;bf73  81
    addcw a                 ;bf74  23
    mov a, @a               ;bf75  92
    beq lab_bfb7            ;bf76  fd 3f
    setb mem_0091:5         ;bf78  ad 91        KW1281 Fault 00852 - Loudspeaker(s) Front

lab_bf7a:
    mov mem_013f, a         ;bf7a  61 01 3f
    mov mem_030c, a         ;bf7d  61 03 0c
    mov a, #0x05            ;bf80  04 05
    mov mem_0186, a         ;bf82  61 01 86
    call sub_c4c0           ;bf85  31 c4 c0

lab_bf88:
    bbc mem_00d6:0, lab_bfb2 ;bf88  b0 d6 27
    movw a, #0x0000         ;bf8b  e4 00 00
    mov a, mem_03b5         ;bf8e  60 03 b5
    mov mem_0343, a         ;bf91  61 03 43
    rorc a                  ;bf94  03
    rorc a                  ;bf95  03
    rorc a                  ;bf96  03
    rorc a                  ;bf97  03
    and a, #0x0f            ;bf98  64 0f
    movw a, #mem_be42       ;bf9a  e4 be 42
    clrc                    ;bf9d  81
    addcw a                 ;bf9e  23
    mov a, @a               ;bf9f  92
    beq lab_bfe0            ;bfa0  fd 3e
    setb mem_0091:6         ;bfa2  ae 91        KW1281 Fault 00853 - Loudspeaker(s) Rear

lab_bfa4:
    mov mem_0140, a         ;bfa4  61 01 40
    mov mem_030d, a         ;bfa7  61 03 0d
    mov a, #0x06            ;bfaa  04 06
    mov mem_0186, a         ;bfac  61 01 86
    call sub_c4c0           ;bfaf  31 c4 c0

lab_bfb2:
    mov a, #0x00            ;bfb2  04 00
    jmp lab_be84            ;bfb4  21 be 84

lab_bfb7:
    mov a, mem_030a         ;bfb7  60 03 0a
    bne lab_bfc0            ;bfba  fc 04
    mov a, mem_00ef         ;bfbc  05 ef
    bne lab_bfc7            ;bfbe  fc 07

lab_bfc0:
    mov a, mem_015b         ;bfc0  60 01 5b
    cmp a, #0x24            ;bfc3  14 24
    beq lab_bf88            ;bfc5  fd c1

lab_bfc7:
    clrb mem_0091:5         ;bfc7  a5 91        KW1281 Fault 00852 - Loudspeaker(s) Front
    mov a, mem_030c         ;bfc9  60 03 0c
    beq lab_bfda            ;bfcc  fd 0c
    call sub_c011           ;bfce  31 c0 11
    movw a, #0x0000         ;bfd1  e4 00 00
    movw mem_0159, a        ;bfd4  d4 01 59
    movw mem_015b, a        ;bfd7  d4 01 5b

lab_bfda:
    movw a, #0x0000         ;bfda  e4 00 00
    jmp lab_bf7a            ;bfdd  21 bf 7a

lab_bfe0:
    mov a, mem_030a         ;bfe0  60 03 0a
    bne lab_bfe9            ;bfe3  fc 04
    mov a, mem_00ef         ;bfe5  05 ef
    bne lab_bff0            ;bfe7  fc 07

lab_bfe9:
    mov a, mem_015f         ;bfe9  60 01 5f
    cmp a, #0x24            ;bfec  14 24
    beq lab_bfb2            ;bfee  fd c2

lab_bff0:
    clrb mem_0091:6         ;bff0  a6 91        KW1281 Fault 00853 - Loudspeaker(s) Rear
    mov a, mem_030d         ;bff2  60 03 0d
    beq lab_c003            ;bff5  fd 0c
    call sub_c009           ;bff7  31 c0 09
    movw a, #0x0000         ;bffa  e4 00 00
    movw mem_015d, a        ;bffd  d4 01 5d
    movw mem_015f, a        ;c000  d4 01 5f

lab_c003:
    movw a, #0x0000         ;c003  e4 00 00
    jmp lab_bfa4            ;c006  21 bf a4

sub_c009:
    setb mem_008d:3         ;c009  ab 8d
    mov a, #0x00            ;c00b  04 00
    mov mem_030d, a         ;c00d  61 03 0d
    ret                     ;c010  20

sub_c011:
    setb mem_008d:2         ;c011  aa 8d
    mov a, #0x00            ;c013  04 00
    mov mem_030c, a         ;c015  61 03 0c
    ret                     ;c018  20

sub_c019:
    bbs mem_008e:2, lab_c023 ;c019  ba 8e 07
    mov a, mem_019f         ;c01c  60 01 9f
    and a, #0x04            ;c01f  64 04
    beq lab_c026            ;c021  fd 03

lab_c023:
    bbc mem_00e8:3, lab_c02c ;c023  b3 e8 06

lab_c026:
    clrb mem_0092:0         ;c026  a0 92
    mov a, #0x00            ;c028  04 00
    beq lab_c030            ;c02a  fd 04        BRANCH_ALWAYS_TAKEN

lab_c02c:
    setb mem_0092:0         ;c02c  a8 92
    mov a, #0x03            ;c02e  04 03

lab_c030:
    mov mem_0143, a         ;c030  61 01 43
    ret                     ;c033  20

sub_c034:
    movw ix, #mem_02d6      ;c034  e6 02 d6
    mov a, mem_0242         ;c037  60 02 42
    and a, #0x80            ;c03a  64 80
    bne lab_c044            ;c03c  fc 06
    setb mem_0091:2         ;c03e  aa 91        KW1281 Fault 00850 - Control Output Active: Radio Amplifier
    mov a, #0x02            ;c040  04 02
    bne lab_c048            ;c042  fc 04        BRANCH_ALWAYS_TAKEN

lab_c044:
    clrb mem_0091:2         ;c044  a2 91        KW1281 Fault 00850 - Control Output Active: Radio Amplifier
    mov a, #0x00            ;c046  04 00

lab_c048:
    mov @ix+0x00, a         ;c048  46 00
    mov mem_0145, a         ;c04a  61 01 45
    ret                     ;c04d  20

sub_c04e:
    movw ep, #0             ;c04e  e7 00 00
    movw ix, #mem_016d      ;c051  e6 01 6d
    call sub_c268           ;c054  31 c2 68
    movw ix, #mem_016e      ;c057  e6 01 6e
    call sub_c268           ;c05a  31 c2 68
    movw ix, #mem_016f      ;c05d  e6 01 6f
    call sub_c268           ;c060  31 c2 68
    movw ix, #mem_0170      ;c063  e6 01 70
    bbs mem_008c:7, lab_c06e ;c066  bf 8c 05
    cmp mem_0095, #0x01     ;c069  95 95 01
    beq lab_c071            ;c06c  fd 03

lab_c06e:
    mov @ix+0x04, #0x00     ;c06e  86 04 00

lab_c071:
    call sub_c268           ;c071  31 c2 68
    movw ix, #mem_02f6      ;c074  e6 02 f6
    movw a, ep              ;c077  f3
    cmp a, #0x04            ;c078  14 04
    beq lab_c082            ;c07a  fd 06
    swap                    ;c07c  10
    cmp a, #0x00            ;c07d  14 00
    bne lab_c088            ;c07f  fc 07
    ret                     ;c081  20

lab_c082:
    clrb mem_0091:7         ;c082  a7 91        KW1281 Fault 65535 - Internal Control Module Memory Error
    mov a, #0x00            ;c084  04 00
    beq lab_c08c            ;c086  fd 04        BRANCH_ALWAYS_TAKEN

lab_c088:
    setb mem_0091:7         ;c088  af 91        KW1281 Fault 65535 - Internal Control Module Memory Error
    mov a, #0x03            ;c08a  04 03

lab_c08c:
    mov @ix+0x00, a         ;c08c  46 00
    ret                     ;c08e  20

sub_c08f:
    call sub_c0bc           ;c08f  31 c0 bc
    bbc mem_008d:5, lab_c0ac ;c092  b5 8d 17
    mov a, mem_0191         ;c095  60 01 91
    bne lab_c0a6            ;c098  fc 0c
    mov a, #0x20            ;c09a  04 20
    mov mem_0236, a         ;c09c  61 02 36
    mov a, #0x20            ;c09f  04 20
    mov mem_02cb, a         ;c0a1  61 02 cb
    clrb mem_008d:5         ;c0a4  a5 8d

lab_c0a6:
    mov a, #0x00            ;c0a6  04 00
    mov mem_0194, a         ;c0a8  61 01 94
    ret                     ;c0ab  20

lab_c0ac:
    mov a, mem_0236         ;c0ac  60 02 36
    cmp a, #0x20            ;c0af  14 20
    beq lab_c0a6            ;c0b1  fd f3
    mov a, mem_0236         ;c0b3  60 02 36
    mov mem_02cb, a         ;c0b6  61 02 cb
    jmp lab_c0a6            ;c0b9  21 c0 a6

sub_c0bc:
    mov a, mem_0236         ;c0bc  60 02 36
    cmp a, #0x9c            ;c0bf  14 9c
    bne lab_c0c7            ;c0c1  fc 04
    mov a, #0x30            ;c0c3  04 30
    bne lab_c0e5            ;c0c5  fc 1e        BRANCH_ALWAYS_TAKEN

lab_c0c7:
    cmp a, #0x9d            ;c0c7  14 9d
    bne lab_c0cf            ;c0c9  fc 04
    mov a, #0x31            ;c0cb  04 31
    bne lab_c0e5            ;c0cd  fc 16        BRANCH_ALWAYS_TAKEN

lab_c0cf:
    cmp a, #0x9e            ;c0cf  14 9e
    bne lab_c0d7            ;c0d1  fc 04
    mov a, #0x41            ;c0d3  04 41
    bne lab_c0e5            ;c0d5  fc 0e        BRANCH_ALWAYS_TAKEN

lab_c0d7:
    cmp a, #0x9f            ;c0d7  14 9f
    bne lab_c0df            ;c0d9  fc 04
    mov a, #0x42            ;c0db  04 42
    bne lab_c0e5            ;c0dd  fc 06        BRANCH_ALWAYS_TAKEN

lab_c0df:
    cmp a, #0x20            ;c0df  14 20
    beq lab_c0f4            ;c0e1  fd 11
    mov a, #0x20            ;c0e3  04 20

lab_c0e5:
    mov mem_02cb, a         ;c0e5  61 02 cb
    mov a, #0x1e            ;c0e8  04 1e
    mov mem_0190, a         ;c0ea  61 01 90
    mov a, #0x01            ;c0ed  04 01
    mov mem_0191, a         ;c0ef  61 01 91
    setb mem_008d:5         ;c0f2  ad 8d

lab_c0f4:
    ret                     ;c0f4  20

sub_c0f5:
    mov a, mem_0191         ;c0f5  60 01 91
    cmp a, #0x01            ;c0f8  14 01
    bne lab_c10d            ;c0fa  fc 11
    movw a, #0x0000         ;c0fc  e4 00 00
    mov a, mem_0190         ;c0ff  60 01 90
    decw a                  ;c102  d0
    mov mem_0190, a         ;c103  61 01 90
    bne lab_c10d            ;c106  fc 05
    mov a, #0x00            ;c108  04 00
    mov mem_0191, a         ;c10a  61 01 91

lab_c10d:
    ret                     ;c10d  20

sub_c10e:
    mov a, mem_02d4         ;c10e  60 02 d4
    cmp a, #0x01            ;c111  14 01
    beq lab_c11a            ;c113  fd 05
    cmp a, #0x02            ;c115  14 02
    beq lab_c127            ;c117  fd 0e
    ret                     ;c119  20

lab_c11a:
    setb pdr2:0             ;c11a  a8 04        PHANTOM_ON=high
    mov a, #0x05            ;c11c  04 05
    mov mem_02d3, a         ;c11e  61 02 d3

lab_c121:
    mov a, #0x02            ;c121  04 02

lab_c123:
    mov mem_02d4, a         ;c123  61 02 d4
    ret                     ;c126  20

lab_c127:
    mov a, mem_02d3         ;c127  60 02 d3
    bne lab_c121            ;c12a  fc f5
    call sub_c133           ;c12c  31 c1 33
    mov a, #0x00            ;c12f  04 00
    beq lab_c123            ;c131  fd f0        BRANCH_ALWAYS_TAKEN

sub_c133:
    mov a, #0x70            ;c133  04 70
    movw ix, #mem_024d      ;c135  e6 02 4d
    call sub_8571           ;c138  31 85 71
    movw ix, #mem_02de      ;c13b  e6 02 de
    mov a, mem_031f         ;c13e  60 03 1f
    mov mem_0328, a         ;c141  61 03 28
    mov a, #0x00            ;c144  04 00
    mov mem_031f, a         ;c146  61 03 1f
    movw a, mem_024d        ;c149  c4 02 4d
    movw a, #0x00cc         ;c14c  e4 00 cc
    cmpw a                  ;c14f  13
    blo lab_c172            ;c150  f9 20
    xchw a, t               ;c152  43
    movw a, #0x0265         ;c153  e4 02 65
    cmpw a                  ;c156  13
    blo lab_c167            ;c157  f9 0e
    mov a, #0x01            ;c159  04 01
    mov mem_031f, a         ;c15b  61 03 1f
    bbc mem_008d:1, lab_c172 ;c15e  b1 8d 11
    setb mem_0091:0         ;c161  a8 91        KW1281 Fault 00856 - Radio Antenna
    mov a, #0x01            ;c163  04 01
    bne lab_c176            ;c165  fc 0f        BRANCH_ALWAYS_TAKEN

lab_c167:
    mov a, #0x02            ;c167  04 02
    mov mem_031f, a         ;c169  61 03 1f
    setb mem_0091:0         ;c16c  a8 91        KW1281 Fault 00856 - Radio Antenna
    mov a, #0x02            ;c16e  04 02
    bne lab_c176            ;c170  fc 04        BRANCH_ALWAYS_TAKEN

lab_c172:
    clrb mem_0091:0         ;c172  a0 91        KW1281 Fault 00856 - Radio Antenna
    mov a, #0x00            ;c174  04 00

lab_c176:
    mov @ix+0x00, a         ;c176  46 00
    mov mem_0141, a         ;c178  61 01 41
    mov a, mem_0328         ;c17b  60 03 28
    mov a, mem_031f         ;c17e  60 03 1f
    cmp a                   ;c181  12
    beq lab_c189            ;c182  fd 05
    mov a, #0x14            ;c184  04 14
    mov mem_0329, a         ;c186  61 03 29

lab_c189:
    ret                     ;c189  20

sub_c18a:
    mov a, #0xff            ;c18a  04 ff
    mov mem_0171, a         ;c18c  61 01 71
    mov mem_0172, a         ;c18f  61 01 72
    mov mem_0173, a         ;c192  61 01 73
    mov mem_0174, a         ;c195  61 01 74
    mov a, #0x78            ;c198  04 78
    mov mem_0304, a         ;c19a  61 03 04
    mov mem_0344, a         ;c19d  61 03 44
    movw a, #0x05dc         ;c1a0  e4 05 dc
    movw mem_0345, a        ;c1a3  d4 03 45
    ret                     ;c1a6  20

sub_c1a7:
    mov a, #0x00            ;c1a7  04 00
    mov mem_016d, a         ;c1a9  61 01 6d
    mov mem_016e, a         ;c1ac  61 01 6e
    mov mem_016f, a         ;c1af  61 01 6f
    mov mem_0170, a         ;c1b2  61 01 70
    ret                     ;c1b5  20

sub_c1b6:
    mov a, mem_0324         ;c1b6  60 03 24
    mov a, mem_0323         ;c1b9  60 03 23
    cmp a                   ;c1bc  12
    bne lab_c1e5            ;c1bd  fc 26
    mov a, mem_0304         ;c1bf  60 03 04
    beq lab_c1ea            ;c1c2  fd 26
    movw a, #0x0000         ;c1c4  e4 00 00
    mov a, mem_0304         ;c1c7  60 03 04
    decw a                  ;c1ca  d0
    mov mem_0304, a         ;c1cb  61 03 04
    bne lab_c1ea            ;c1ce  fc 1a
    mov a, mem_0323         ;c1d0  60 03 23
    cmp a, #0x20            ;c1d3  14 20
    bne lab_c1de            ;c1d5  fc 07
    mov a, #0x00            ;c1d7  04 00
    mov mem_0171, a         ;c1d9  61 01 71
    beq lab_c1ea            ;c1dc  fd 0c        BRANCH_ALWAYS_TAKEN

lab_c1de:
    mov a, #0x01            ;c1de  04 01
    mov mem_0171, a         ;c1e0  61 01 71
    bne lab_c1ea            ;c1e3  fc 05        BRANCH_ALWAYS_TAKEN

lab_c1e5:
    mov a, #0x78            ;c1e5  04 78
    mov mem_0304, a         ;c1e7  61 03 04

lab_c1ea:
    mov a, mem_0323         ;c1ea  60 03 23
    mov mem_0324, a         ;c1ed  61 03 24
    ret                     ;c1f0  20

sub_c1f1:
    mov a, mem_0172         ;c1f1  60 01 72
    cmp a, #0xff            ;c1f4  14 ff
    bne lab_c228            ;c1f6  fc 30
    pushw ix                ;c1f8  41
    movw a, ep              ;c1f9  f3
    pushw a                 ;c1fa  40
    movw ep, #0             ;c1fb  e7 00 00
    movw ix, #0xffdf        ;c1fe  e6 ff df

lab_c201:
    movw a, #0x0000         ;c201  e4 00 00
    mov a, @ix+0x00         ;c204  06 00
    xchw a, t               ;c206  43
    movw a, ep              ;c207  f3
    clrc                    ;c208  81
    addcw a                 ;c209  23
    movw ep, a              ;c20a  e3
    decw ix                 ;c20b  d2
    movw a, ix              ;c20c  f2
    movw a, #0xffcf         ;c20d  e4 ff cf
    cmpw a                  ;c210  13
    bne lab_c201            ;c211  fc ee
    movw a, #0xffe0         ;c213  e4 ff e0
    movw a, @a              ;c216  93
    xchw a, t               ;c217  43
    movw a, ep              ;c218  f3
    cmpw a                  ;c219  13
    beq lab_c220            ;c21a  fd 04
    mov a, #0x02            ;c21c  04 02
    bne lab_c222            ;c21e  fc 02        BRANCH_ALWAYS_TAKEN

lab_c220:
    mov a, #0x00            ;c220  04 00

lab_c222:
    mov mem_0172, a         ;c222  61 01 72
    popw a                  ;c225  50
    movw ep, a              ;c226  e3
    popw ix                 ;c227  51

lab_c228:
    ret                     ;c228  20

sub_c229:
    bbs mem_008c:7, lab_c256 ;c229  bf 8c 2a
    cmp mem_0095, #0x01     ;c22c  95 95 01
    bne lab_c256            ;c22f  fc 25
    bbc mem_00f2:0, lab_c247 ;c231  b0 f2 13
    movw ix, #mem_0344      ;c234  e6 03 44     IX = pointer to 8-bit value to decrement
    call dec8_at_ix         ;c237  31 e7 81     Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
    bne lab_c258            ;c23a  fc 1c
    mov a, #0x04            ;c23c  04 04
    movw a, mem_0345        ;c23e  c4 03 45
    beq lab_c244            ;c241  fd 01
    xch a, t                ;c243  42

lab_c244:
    mov mem_0174, a         ;c244  61 01 74

lab_c247:
    setb mem_00f2:0         ;c247  a8 f2
    mov a, #0x78            ;c249  04 78
    mov mem_0344, a         ;c24b  61 03 44
    movw a, #0x05dc         ;c24e  e4 05 dc
    movw mem_0345, a        ;c251  d4 03 45
    bne lab_c258            ;c254  fc 02        BRANCH_ALWAYS_TAKEN

lab_c256:
    clrb mem_00f2:0         ;c256  a0 f2

lab_c258:
    ret                     ;c258  20


sub_c259:
;Called from ISR for IRQ0 (external interrupt 1)
;when INT3 pin edge detect status changes (/SCA_CLK_IN)
    bbc mem_00f2:0, lab_c267 ;c259  b0 f2 0b
    movw a, mem_0345        ;c25c  c4 03 45
    beq lab_c267            ;c25f  fd 06
    movw ix, #mem_0345      ;c261  e6 03 45     IX = pointer to 16-bit value to decrement
    call dec16_at_ix        ;c264  31 e7 8a     Decrement 16-bit value @IX.  Wraps from 0 to 0xFFFF.
lab_c267:
    ret                     ;c267  20


sub_c268:
    movw a, #0x0000         ;c268  e4 00 00
    mov a, @ix+0x04         ;c26b  06 04
    cmp a, #0xff            ;c26d  14 ff
    beq lab_c285            ;c26f  fd 14
    cmp a, #0x00            ;c271  14 00
    beq lab_c282            ;c273  fd 0d
    mov a, @ix+0x04         ;c275  06 04
    mov @ix+0x00, a         ;c277  46 00
    movw a, ep              ;c279  f3
    movw a, #0x0100         ;c27a  e4 01 00
    clrc                    ;c27d  81
    addcw a                 ;c27e  23
    jmp lab_c284            ;c27f  21 c2 84

lab_c282:
    movw a, ep              ;c282  f3
    incw a                  ;c283  c0

lab_c284:
    movw ep, a              ;c284  e3

lab_c285:
    ret                     ;c285  20

sub_c286:
    pushw ix                ;c286  41
    movw ix, #mem_01ad      ;c287  e6 01 ad
    mov r0, #0x06           ;c28a  88 06
    movw a, #0x0000         ;c28c  e4 00 00
    movw mem_00a6, a        ;c28f  d5 a6

lab_c291:
    movw a, #0x0000         ;c291  e4 00 00
    mov a, @ix+0x00         ;c294  06 00
    incw ix                 ;c296  c2
    movw a, mem_00a6        ;c297  c5 a6
    clrc                    ;c299  81
    addcw a                 ;c29a  23
    movw mem_00a6, a        ;c29b  d5 a6
    dec r0                  ;c29d  d8
    bne lab_c291            ;c29e  fc f1
    popw ix                 ;c2a0  51
    ret                     ;c2a1  20

sub_c2a2:
    call sub_c286           ;c2a2  31 c2 86
    movw mem_0347, a        ;c2a5  d4 03 47
    ret                     ;c2a8  20

sub_c2a9:
    mov a, mem_0173         ;c2a9  60 01 73
    cmp a, #0xff            ;c2ac  14 ff
    bne lab_c2c5            ;c2ae  fc 15
    call sub_c286           ;c2b0  31 c2 86
    movw a, mem_0347        ;c2b3  c4 03 47
    cmpw a                  ;c2b6  13
    bne lab_c2c0            ;c2b7  fc 07
    bbc mem_00e3:6, lab_c2c0 ;c2b9  b6 e3 04
    mov a, #0x00            ;c2bc  04 00
    beq lab_c2c2            ;c2be  fd 02        BRANCH_ALWAYS_TAKEN

lab_c2c0:
    mov a, #0x03            ;c2c0  04 03

lab_c2c2:
    mov mem_0173, a         ;c2c2  61 01 73

lab_c2c5:
    ret                     ;c2c5  20

sub_c2c6:
    movw a, #0x0000         ;c2c6  e4 00 00
    movw mem_013f, a        ;c2c9  d4 01 3f
    mov mem_013e, a         ;c2cc  61 01 3e
    mov mem_0142, a         ;c2cf  61 01 42
    mov mem_0143, a         ;c2d2  61 01 43
    mov mem_0144, a         ;c2d5  61 01 44
    mov mem_0141, a         ;c2d8  61 01 41
    movw mem_0197, a        ;c2db  d4 01 97
    ret                     ;c2de  20

sub_c2df:
    setb pdr2:0             ;c2df  a8 04        PHANTOM_ON=high
    call sub_c2c6           ;c2e1  31 c2 c6
    mov mem_00a2, #0x09     ;c2e4  85 a2 09
    movw ix, #mem_02d6      ;c2e7  e6 02 d6

lab_c2ea:
    movw a, #0xffff         ;c2ea  e4 ff ff
    movw @ix+0x00, a        ;c2ed  d6 00
    movw a, #0xff14         ;c2ef  e4 ff 14
    movw @ix+0x02, a        ;c2f2  d6 02
    incw ix                 ;c2f4  c2
    incw ix                 ;c2f5  c2
    incw ix                 ;c2f6  c2
    incw ix                 ;c2f7  c2
    movw a, #0x0000         ;c2f8  e4 00 00
    mov a, mem_00a2         ;c2fb  05 a2
    decw a                  ;c2fd  d0
    mov mem_00a2, a         ;c2fe  45 a2
    cmp a, #0x00            ;c300  14 00
    bne lab_c2ea            ;c302  fc e6
    mov a, #0x0a            ;c304  04 0a
    mov mem_02d1, a         ;c306  61 02 d1
    call sub_c18a           ;c309  31 c1 8a
    ret                     ;c30c  20

sub_c30d:
    call sub_be52           ;c30d  31 be 52
    call sub_bc64           ;c310  31 bc 64
    call sub_c31d           ;c313  31 c3 1d
    call sub_c1f1           ;c316  31 c1 f1
    call sub_c2a9           ;c319  31 c2 a9
    ret                     ;c31c  20

sub_c31d:
    mov a, mem_02d1         ;c31d  60 02 d1
    beq lab_c37c            ;c320  fd 5a
    mov a, mem_02cf         ;c322  60 02 cf
    bne lab_c37c            ;c325  fc 55
    incw a                  ;c327  c0
    mov mem_02cf, a         ;c328  61 02 cf
    mov a, mem_02d1         ;c32b  60 02 d1
    incw a                  ;c32e  c0
    mov mem_02d1, a         ;c32f  61 02 d1
    cmp a, #0x0b            ;c332  14 0b
    blo lab_c33b            ;c334  f9 05
    mov a, #0x01            ;c336  04 01
    mov mem_02d1, a         ;c338  61 02 d1

lab_c33b:
    mov a, mem_0335         ;c33b  60 03 35
    beq lab_c34b            ;c33e  fd 0b
    cmp a, #0x01            ;c340  14 01
    beq lab_c34b            ;c342  fd 07
    mov a, mem_02d1         ;c344  60 02 d1
    cmp a, #0x02            ;c347  14 02
    bne lab_c37c            ;c349  fc 31

lab_c34b:
    mov a, mem_02d1         ;c34b  60 02 d1     A = table index
    movw a, #mem_c354       ;c34e  e4 c3 54     A = table base address
    jmp sub_e73c            ;c351  21 e7 3c     Jump to address in table

mem_c354:
    .word lab_c37c          ;c354  c3 7c       VECTOR
    .word lab_c36a          ;c356  c3 6a       VECTOR
    .word lab_c37d          ;c358  c3 7d       VECTOR
    .word lab_c387          ;c35a  c3 87       VECTOR
    .word lab_c3ce          ;c35c  c3 ce       VECTOR
    .word lab_c416          ;c35e  c4 16       VECTOR
    .word lab_c463          ;c360  c4 63       VECTOR
    .word lab_c46e          ;c362  c4 6e       VECTOR
    .word lab_c479          ;c364  c4 79       VECTOR
    .word lab_c47f          ;c366  c4 7f       VECTOR
    .word lab_c48c          ;c368  c4 8c       VECTOR

lab_c36a:
    call sub_c034           ;c36a  31 c0 34
    call sub_c490           ;c36d  31 c4 90
    mov a, #0x03            ;c370  04 03

lab_c372:
    blo lab_c376            ;c372  f9 02
    mov a, #0x00            ;c374  04 00

lab_c376:
    mov mem_0186, a         ;c376  61 01 86
    call sub_c4c0           ;c379  31 c4 c0

lab_c37c:
    ret                     ;c37c  20

lab_c37d:
    call sub_bc02           ;c37d  31 bc 02
    call sub_c490           ;c380  31 c4 90
    mov a, #0x02            ;c383  04 02
    bne lab_c372            ;c385  fc eb        BRANCH_ALWAYS_TAKEN

lab_c387:
    bbc mem_008d:2, lab_c390 ;c387  b2 8d 06
    clrb mem_008d:2         ;c38a  a2 8d
    setc                    ;c38c  91
    jmp lab_c3ca            ;c38d  21 c3 ca

lab_c390:
    mov a, mem_017c         ;c390  60 01 7c
    bne lab_c37c            ;c393  fc e7
    mov a, mem_030a         ;c395  60 03 0a
    bne lab_c37c            ;c398  fc e2
    call sub_bd48           ;c39a  31 bd 48
    mov a, mem_00ef         ;c39d  05 ef
    bne lab_c3b5            ;c39f  fc 14
    cmp @ix+0x00, #0x01     ;c3a1  96 00 01
    beq lab_c37c            ;c3a4  fd d6
    mov a, mem_015b         ;c3a6  60 01 5b
    cmp a, #0x24            ;c3a9  14 24
    bne lab_c3b5            ;c3ab  fc 08
    cmp @ix+0x00, #0x02     ;c3ad  96 00 02
    beq lab_c3b5            ;c3b0  fd 03
    mov @ix+0x03, #0x14     ;c3b2  86 03 14

lab_c3b5:
    call sub_be2e           ;c3b5  31 be 2e
    mov a, @ix+0x00         ;c3b8  06 00
    mov a, #0x01            ;c3ba  04 01
    cmp a                   ;c3bc  12
    bne lab_c3c7            ;c3bd  fc 08
    bbs mem_008e:4, lab_c3c7 ;c3bf  bc 8e 05
    mov a, mem_0327         ;c3c2  60 03 27
    beq lab_c37c            ;c3c5  fd b5

lab_c3c7:
    call sub_c490           ;c3c7  31 c4 90

lab_c3ca:
    mov a, #0x05            ;c3ca  04 05
    bne lab_c372            ;c3cc  fc a4        BRANCH_ALWAYS_TAKEN

lab_c3ce:
    bbc mem_008d:3, lab_c3d7 ;c3ce  b3 8d 06
    clrb mem_008d:3         ;c3d1  a3 8d
    setc                    ;c3d3  91
    jmp lab_c411            ;c3d4  21 c4 11

lab_c3d7:
    mov a, mem_017c         ;c3d7  60 01 7c
    bne lab_c37c            ;c3da  fc a0
    mov a, mem_030a         ;c3dc  60 03 0a
    bne lab_c37c            ;c3df  fc 9b
    call sub_bdbe           ;c3e1  31 bd be
    mov a, mem_00ef         ;c3e4  05 ef
    bne lab_c3fc            ;c3e6  fc 14
    cmp @ix+0x00, #0x01     ;c3e8  96 00 01
    beq lab_c37c            ;c3eb  fd 8f
    mov a, mem_015f         ;c3ed  60 01 5f
    cmp a, #0x24            ;c3f0  14 24
    bne lab_c3fc            ;c3f2  fc 08
    cmp @ix+0x00, #0x02     ;c3f4  96 00 02
    beq lab_c3fc            ;c3f7  fd 03
    mov @ix+0x03, #0x14     ;c3f9  86 03 14

lab_c3fc:
    call sub_be2e           ;c3fc  31 be 2e
    mov a, @ix+0x00         ;c3ff  06 00
    mov a, #0x01            ;c401  04 01
    cmp a                   ;c403  12
    bne lab_c40e            ;c404  fc 08
    bbs mem_008e:4, lab_c40e ;c406  bc 8e 05
    mov a, mem_0327         ;c409  60 03 27
    beq lab_c462            ;c40c  fd 54

lab_c40e:
    call sub_c490           ;c40e  31 c4 90

lab_c411:
    mov a, #0x06            ;c411  04 06
    jmp lab_c372            ;c413  21 c3 72

lab_c416:
    bbc pdr2:0, lab_c462    ;c416  b0 04 49     PHANTOM_ON
    call sub_c432           ;c419  31 c4 32
    call sub_c133           ;c41c  31 c1 33
    bbs mem_008d:1, lab_c42a ;c41f  b9 8d 08
    mov a, mem_02e0         ;c422  60 02 e0
    mov a, #0xff            ;c425  04 ff
    cmp a                   ;c427  12
    bne lab_c462            ;c428  fc 38

lab_c42a:
    call sub_c490           ;c42a  31 c4 90
    mov a, #0x01            ;c42d  04 01
    jmp lab_c372            ;c42f  21 c3 72

sub_c432:
    mov a, mem_0328         ;c432  60 03 28
    mov a, mem_031f         ;c435  60 03 1f
    cmp a                   ;c438  12
    bne lab_c462            ;c439  fc 27
    movw a, #0x0000         ;c43b  e4 00 00
    mov a, mem_0329         ;c43e  60 03 29
    beq lab_c449            ;c441  fd 06
    decw a                  ;c443  d0
    mov mem_0329, a         ;c444  61 03 29
    bne lab_c462            ;c447  fc 19

lab_c449:
    mov a, mem_031f         ;c449  60 03 1f
    beq lab_c462            ;c44c  fd 14
    mov a, mem_02e1         ;c44e  60 02 e1
    bne lab_c462            ;c451  fc 0f
    mov a, mem_033f         ;c453  60 03 3f
    mov a, #0x03            ;c456  04 03
    cmp a                   ;c458  12
    beq lab_c462            ;c459  fd 07
    clrb pdr2:0             ;c45b  a0 04        PHANTOM_ON=low
    mov a, #0x14            ;c45d  04 14
    mov mem_02e1, a         ;c45f  61 02 e1

lab_c462:
    ret                     ;c462  20

lab_c463:
    call sub_bc44           ;c463  31 bc 44
    call sub_c490           ;c466  31 c4 90
    mov a, #0x04            ;c469  04 04
    jmp lab_c372            ;c46b  21 c3 72

lab_c46e:
    call sub_c04e           ;c46e  31 c0 4e
    call sub_c490           ;c471  31 c4 90
    mov a, #0x07            ;c474  04 07
    jmp lab_c372            ;c476  21 c3 72

lab_c479:
    clrc                    ;c479  81
    mov a, #0x08            ;c47a  04 08
    jmp lab_c372            ;c47c  21 c3 72

lab_c47f:
    call sub_9385           ;c47f  31 93 85
    call sub_938e           ;c482  31 93 8e
    call sub_9397           ;c485  31 93 97
    call sub_93a0           ;c488  31 93 a0
    ret                     ;c48b  20

lab_c48c:
    call sub_92f4           ;c48c  31 92 f4
    ret                     ;c48f  20

sub_c490:
    mov a, @ix+0x00         ;c490  06 00
    mov a, @ix+0x01         ;c492  06 01
    cmp a                   ;c494  12
    bne lab_c4b6            ;c495  fc 1f
    mov a, @ix+0x03         ;c497  06 03
    beq lab_c4be            ;c499  fd 23
    movw a, #0x0000         ;c49b  e4 00 00
    mov a, @ix+0x03         ;c49e  06 03
    decw a                  ;c4a0  d0
    mov @ix+0x03, a         ;c4a1  46 03
    bne lab_c4be            ;c4a3  fc 19
    mov a, @ix+0x02         ;c4a5  06 02
    cmp a, #0xff            ;c4a7  14 ff
    beq lab_c4ad            ;c4a9  fd 02
    mov a, #0x00            ;c4ab  04 00

lab_c4ad:
    mov mem_02d5, a         ;c4ad  61 02 d5
    mov a, @ix+0x00         ;c4b0  06 00
    mov @ix+0x02, a         ;c4b2  46 02
    setc                    ;c4b4  91
    ret                     ;c4b5  20

lab_c4b6:
    mov a, @ix+0x00         ;c4b6  06 00
    mov @ix+0x01, a         ;c4b8  46 01
    mov a, #0x14            ;c4ba  04 14
    mov @ix+0x03, a         ;c4bc  46 03

lab_c4be:
    clrc                    ;c4be  81
    ret                     ;c4bf  20

sub_c4c0:
    mov a, mem_0186         ;c4c0  60 01 86     A = table index
    movw a, #mem_c4c9       ;c4c3  e4 c4 c9     A = table base address
    jmp sub_e73c            ;c4c6  21 e7 3c     Jump to address in table

mem_c4c9:
    .word lab_c552                      ;VECTOR 0  Does nothing
    .word lab_c4dd_fault_antenna        ;VECTOR 1  KW1281 Fault 00856 Antenna
    .word sub_c4fe_fault_terminal_30    ;VECTOR 2  KW1281 Fault 00668 Supply terminal 30
    .word sub_c50c_fault_amplifier      ;VECTOR 3  KW1281 Fault 00850 Radio amplifier
    .word sub_c51a_fault_cd_changer     ;VECTOR 4  KW1281 Fault 00855 CD changer
    .word sub_c55d_fault_speakers_front ;VECTOR 5  KW1281 Fault 00852 Loudspeaker(s) Front
    .word sub_c574_fault_speakers_rear  ;VECTOR 6  KW1281 Fault 00853 Loudspeaker(s) Rear
    .word lab_c592_fault_internal_mem   ;VECTOR 7  KW1281 Fault 65535 Internal Memory Error
    .word lab_c5cc                      ;VECTOR 8
    .word lab_c5cf                      ;VECTOR 9

lab_c4dd_fault_antenna:
    movw ix, #mem_0149      ;c4dd  e6 01 49
    bbc mem_0091:0, lab_c528 ;c4e0  b0 91 45
    mov a, mem_0141         ;c4e3  60 01 41
    cmp a, #0x02            ;c4e6  14 02
    bne lab_c4f2            ;c4e8  fc 08
    movw a, #0x0358         ;c4ea  e4 03 58     KW1281 Fault 00856 - Radio Antenna
    movw a, #0x1d32         ;c4ed  e4 1d 32
    bne lab_c53c            ;c4f0  fc 4a        BRANCH_ALWAYS_TAKEN

lab_c4f2:
    cmp a, #0x01            ;c4f2  14 01
    bne lab_c552            ;c4f4  fc 5c
    movw a, #0x0358         ;c4f6  e4 03 58     KW1281 Fault 00856 - Radio Antenna
    movw a, #0x2432         ;c4f9  e4 24 32
    bne lab_c53c            ;c4fc  fc 3e        BRANCH_ALWAYS_TAKEN

sub_c4fe_fault_terminal_30:
    movw ix, #mem_014d      ;c4fe  e6 01 4d
    bbc mem_0091:1, lab_c528 ;c501  b1 91 24
    movw a, #0x029c         ;c504  e4 02 9c     KW1281 Fault 00668 - Supply Voltage Terminal 30
    movw a, #0x0732         ;c507  e4 07 32
    bne lab_c53c            ;c50a  fc 30        BRANCH_ALWAYS_TAKEN

sub_c50c_fault_amplifier:
    movw ix, #mem_0151      ;c50c  e6 01 51
    bbc mem_0091:2, lab_c528 ;c50f  b2 91 16
    movw a, #0x0352         ;c512  e4 03 52     KW1281 Fault 00850 - Control Output Active: Radio Amplifier
    movw a, #0x1d32         ;c515  e4 1d 32
    bne lab_c53c            ;c518  fc 22        BRANCH_ALWAYS_TAKEN

sub_c51a_fault_cd_changer:
    movw ix, #mem_0155      ;c51a  e6 01 55
    bbc mem_0091:4, lab_c528 ;c51d  b4 91 08
    movw a, #0x0357         ;c520  e4 03 57     KW1281 Fault 00855 - Connection to CD changer
    movw a, #0x3132         ;c523  e4 31 32
    bne lab_c53c            ;c526  fc 14        BRANCH_ALWAYS_TAKEN

lab_c528:
    mov a, mem_02d5         ;c528  60 02 d5
    cmp a, #0xff            ;c52b  14 ff
    bne lab_c553            ;c52d  fc 24
    movw a, #0x0000         ;c52f  e4 00 00
    mov a, @ix+0x03         ;c532  06 03
    bne lab_c544            ;c534  fc 0e

lab_c536:
    movw a, #0x0000         ;c536  e4 00 00
    movw a, #0x0000         ;c539  e4 00 00

lab_c53c:
    movw @ix+0x02, a        ;c53c  d6 02        Store KW1281 Fault lower 2 bytes
    xchw a, t               ;c53e  43
    movw @ix+0x00, a        ;c53f  d6 00        Store KW1281 Fault upper 2 bytes
    jmp lab_c54f            ;c541  21 c5 4f

lab_c544:
    decw a                  ;c544  d0
    beq lab_c536            ;c545  fd ef
    mov @ix+0x03, a         ;c547  46 03

lab_c549:
    mov a, @ix+0x02         ;c549  06 02
    or a, #0x80             ;c54b  74 80
    mov @ix+0x02, a         ;c54d  46 02

lab_c54f:
    call sub_a516           ;c54f  31 a5 16

lab_c552:
    ret                     ;c552  20

lab_c553:
    movw a, #0x0000         ;c553  e4 00 00
    mov a, @ix+0x03         ;c556  06 03
    bne lab_c549            ;c558  fc ef
    jmp lab_c536            ;c55a  21 c5 36

sub_c55d_fault_speakers_front:
    movw ix, #mem_0159      ;c55d  e6 01 59
    bbc mem_0091:5, lab_c528 ;c560  b5 91 c5
    mov a, mem_013f         ;c563  60 01 3f
    cmp a, #0x01            ;c566  14 01
    bne lab_c56f            ;c568  fc 05
    movw a, #0x0354         ;c56a  e4 03 54     KW1281 Fault 00852 - Loudspeaker(s) Front
    bne lab_c584            ;c56d  fc 15        BRANCH_ALWAYS_TAKEN

lab_c56f:
    movw a, #0x0354         ;c56f  e4 03 54     KW1281 Fault 00852 - Loudspeaker(s) Front
    bne lab_c58d            ;c572  fc 19        BRANCH_ALWAYS_TAKEN

sub_c574_fault_speakers_rear:
    movw ix, #mem_015d      ;c574  e6 01 5d
    bbc mem_0091:6, lab_c528 ;c577  b6 91 ae
    mov a, mem_0140         ;c57a  60 01 40
    cmp a, #0x01            ;c57d  14 01
    bne lab_c58a            ;c57f  fc 09
    movw a, #0x0355         ;c581  e4 03 55     KW1281 Fault 00853 - Loudspeaker(s) Rear

lab_c584:
    movw a, #0x2432         ;c584  e4 24 32

lab_c587:
    jmp lab_c53c            ;c587  21 c5 3c

lab_c58a:
    movw a, #0x0355         ;c58a  e4 03 55     KW1281 Fault 00853 - Loudspeaker(s) Rear

lab_c58d:
    movw a, #0x2c32         ;c58d  e4 2c 32
    bne lab_c587            ;c590  fc f5        BRANCH_ALWAYS_TAKEN

lab_c592_fault_internal_mem:
    movw ix, #mem_0161      ;c592  e6 01 61
    bbc mem_0091:7, lab_c5a0 ;c595  b7 91 08
    movw a, #0xffff         ;c598  e4 ff ff     KW1281 Fault 65535 - Internal Control Module Memory Error
    movw a, #0x0032         ;c59b  e4 00 32
    bne lab_c587            ;c59e  fc e7        BRANCH_ALWAYS_TAKEN

lab_c5a0:
    mov a, mem_02d5         ;c5a0  60 02 d5
    cmp a, #0xff            ;c5a3  14 ff
    bne lab_c5ba            ;c5a5  fc 13
    movw a, #0x0000         ;c5a7  e4 00 00
    mov a, @ix+0x03         ;c5aa  06 03
    bne lab_c5c4            ;c5ac  fc 16

lab_c5ae:
    call sub_c1a7           ;c5ae  31 c1 a7
    movw a, #0xffff         ;c5b1  e4 ff ff
    movw a, #0x8800         ;c5b4  e4 88 00
    jmp lab_c53c            ;c5b7  21 c5 3c

lab_c5ba:
    movw a, #0x0000         ;c5ba  e4 00 00
    mov a, @ix+0x03         ;c5bd  06 03
    beq lab_c5ae            ;c5bf  fd ed
    jmp lab_c549            ;c5c1  21 c5 49

lab_c5c4:
    decw a                  ;c5c4  d0
    beq lab_c5ae            ;c5c5  fd e7
    mov @ix+0x03, a         ;c5c7  46 03
    jmp lab_c549            ;c5c9  21 c5 49

lab_c5cc:
    jmp lab_c528            ;c5cc  21 c5 28

lab_c5cf:
    jmp lab_c54f            ;c5cf  21 c5 4f

sub_c5d2:
    setb mem_0097:2         ;c5d2  aa 97
    mov a, #0x00            ;c5d4  04 00
    movw ix, #mem_02b6      ;c5d6  e6 02 b6
    call fill_6_bytes_at_ix ;c5d9  31 e6 ed
    mov a, mem_0095         ;c5dc  05 95
    mov mem_02c8, a         ;c5de  61 02 c8
    movw ix, #mem_02b6      ;c5e1  e6 02 b6
    bbc mem_00d0:0, lab_c5f7 ;c5e4  b0 d0 10
    bbc mem_008c:7, lab_c5fc ;c5e7  b7 8c 12
    bbc mem_008e:7, lab_c5fc ;c5ea  b7 8e 0f
    call sub_c839           ;c5ed  31 c8 39     Set display number to 0xB0 '.....DIAG..'
    bbc mem_00e1:7, lab_c5f6 ;c5f0  b7 e1 03
    call sub_c831           ;c5f3  31 c8 31     Set display number to 0xB1 'TESTDISPLAY'

lab_c5f6:
    ret                     ;c5f6  20

lab_c5f7:
    mov a, #0xc1            ;c5f7  04 c1
    mov @ix+0x01, a         ;c5f9  46 01        Display number = 0xC1  '...........'
    ret                     ;c5fb  20

lab_c5fc:
    cmp mem_0096, #0x00     ;c5fc  95 96 00
    beq lab_c60d            ;c5ff  fd 0c

    mov a, mem_0201         ;c601  60 02 01
    mov a, #0x00            ;c604  04 00
    cmp a                   ;c606  12
    beq lab_c60c            ;c607  fd 03

    ;(mem_0201=0)
    call sub_a497           ;c609  31 a4 97     Set display number based on mem_0201:
                            ;                     NO CODE, CODE, INITIAL, BLANK, SAFE
                            ;                     VER, CLEAR
lab_c60c:
    ret                     ;c60c  20

lab_c60d:
    mov a, #0x00            ;c60d  04 00
    mov mem_0201, a         ;c60f  61 02 01
    clrb mem_00e4:1         ;c612  a1 e4
    bbs mem_00b2:4, lab_c61a ;c614  bc b2 03
    jmp lab_c679            ;c617  21 c6 79

lab_c61a:
;(mem_00b2:4 = 1)
    mov a, mem_00b1         ;c61a  05 b1
    cmp a, #0x01            ;c61c  14 01
    bne lab_c62d            ;c61e  fc 0d

    ;(mem_00b1=1)
    mov a, mem_00b3         ;c620  05 b3
    call sub_c744           ;c622  31 c7 44
    mov @ix+0x02, a         ;c625  46 02        Display param 1 = Signed binary number for bass
    mov @ix+0x01, #0x62     ;c627  86 01 62     Display number = 0x62 'BASS.......'
    jmp lab_c63b            ;c62a  21 c6 3b

lab_c62d:
    cmp a, #0x02            ;c62d  14 02
    bne lab_c63f            ;c62f  fc 0e

    ;(mem_00b1=2)
    mov a, mem_00b4         ;c631  05 b4
    call sub_c744           ;c633  31 c7 44
    mov @ix+0x02, a         ;c636  46 02        Display param 1 = Signed binary number for treble
    mov @ix+0x01, #0x63     ;c638  86 01 63     Display number = 0x63 'TREB.......'

lab_c63b:
    mov mem_00f1, #0x8f     ;c63b  85 f1 8f
    ret                     ;c63e  20

lab_c63f:
    cmp a, #0x03            ;c63f  14 03
    bne lab_c65b            ;c641  fc 18

    ;(mem_00b1=3)
    mov a, mem_00b5         ;c643  05 b5
    call sub_c744           ;c645  31 c7 44
    bne lab_c64e            ;c648  fc 04
    mov @ix+0x01, #0x66     ;c64a  86 01 66     Display number = 0x66 'BAL.CENTER.'
    ret                     ;c64d  20

lab_c64e:
    mov @ix+0x01, #0x64     ;c64e  86 01 64     Display number = 0x64 'BAL.LEFT...'
    cmp a, #0x7f            ;c651  14 7f
    blo lab_c658            ;c653  f9 03
    mov @ix+0x01, #0x65     ;c655  86 01 65     Display number = 0x65 'BAL.RIGHT..'

lab_c658:
    mov @ix+0x02, a         ;c658  46 02        Display param 1 = Signed binary number for balance
    ret                     ;c65a  20

lab_c65b:
    cmp a, #0x04            ;c65b  14 04
    bne lab_c677            ;c65d  fc 18

    ;(mem_00b1=4)
    mov a, mem_00b6         ;c65f  05 b6
    call sub_c744           ;c661  31 c7 44
    bne lab_c66a            ;c664  fc 04
    mov @ix+0x01, #0x69     ;c666  86 01 69     Display number = 0x69 'FADECENTER.'
    ret                     ;c669  20

lab_c66a:
    mov @ix+0x01, #0x67     ;c66a  86 01 67     Display number = 0x67 'FADEFRONT..'
    cmp a, #0x7f            ;c66d  14 7f
    blo lab_c674            ;c66f  f9 03
    mov @ix+0x01, #0x68     ;c671  86 01 68     Display number = 0x68 'FADEREAR...'

lab_c674:
    mov @ix+0x02, a         ;c674  46 02        Display param 1 = Signed binary number for fade
    ret                     ;c676  20

lab_c677:
    ;(mem_00b1 != 1,2,3,4)
    clrb mem_00b2:4         ;c677  a4 b2

lab_c679:
    mov a, mem_02c8         ;c679  60 02 c8
    bne lab_c681            ;c67c  fc 03
    jmp lab_c692            ;c67e  21 c6 92

lab_c681:
    cmp a, #0x01            ;c681  14 01
    bne lab_c688            ;c683  fc 03
    jmp lab_c750            ;c685  21 c7 50

lab_c688:
    cmp a, #0x02            ;c688  14 02
    bne lab_c691            ;c68a  fc 05
    clrb mem_0097:2         ;c68c  a2 97
    call sub_ebcc           ;c68e  31 eb cc

lab_c691:
    ret                     ;c691  20

lab_c692:
    movw ix, #mem_02b6      ;c692  e6 02 b6
    mov a, mem_00c7         ;c695  05 c7
    mov @ix+0x03, a         ;c697  46 03
    mov mem_009e, #0x41     ;c699  85 9e 41
    cmp mem_00c1, #0x02     ;c69c  95 c1 02
    bne lab_c6a3            ;c69f  fc 02
    setb mem_009e:1         ;c6a1  a9 9e

lab_c6a3:
    mov a, mem_00c5         ;c6a3  05 c5
    beq lab_c6a9            ;c6a5  fd 02
    clrb mem_009e:0         ;c6a7  a0 9e

lab_c6a9:
    mov a, mem_009e         ;c6a9  05 9e
    mov @ix+0x01, a         ;c6ab  46 01
    clrc                    ;c6ad  81
    mov a, mem_00c5         ;c6ae  05 c5
    rolc a                  ;c6b0  02
    rolc a                  ;c6b1  02
    rolc a                  ;c6b2  02
    rolc a                  ;c6b3  02
    and a, #0xf0            ;c6b4  64 f0
    mov @ix+0x02, a         ;c6b6  46 02
    cmp mem_00c1, #0x02     ;c6b8  95 c1 02
    beq lab_c6c8            ;c6bb  fd 0b
    bbc mem_00c9:1, lab_c6c5 ;c6bd  b1 c9 05
    clrb mem_00c9:1         ;c6c0  a1 c9
    call sub_c6eb           ;c6c2  31 c6 eb

lab_c6c5:
    call sub_c6e3           ;c6c5  31 c6 e3

lab_c6c8:
    mov @ix+0x00, #0x08     ;c6c8  86 00 08
    setb mem_0097:2         ;c6cb  aa 97
    cmp mem_00c1, #0x02     ;c6cd  95 c1 02
    bne lab_c6d8            ;c6d0  fc 06
    bbs mem_00c9:6, lab_c6dd ;c6d2  be c9 08
    jmp lab_c6e1            ;c6d5  21 c6 e1

lab_c6d8:
    cmp mem_00c1, #0x01     ;c6d8  95 c1 01
    beq lab_c6e1            ;c6db  fd 04

lab_c6dd:
    call sub_c71c           ;c6dd  31 c7 1c     'FM....MAX..', 'FM....MIN..',
                            ;                   'AM....MAX..', 'AM....MIN..'
    ret                     ;c6e0  20

lab_c6e1:
    callv #5                ;c6e1  ed          CALLV #5 = callv5_8d0d
    ret                     ;c6e2  20

sub_c6e3:
    mov a, mem_00c8         ;c6e3  05 c8
    mov a, @ix+0x02         ;c6e5  06 02
    or a                    ;c6e7  72
    mov @ix+0x02, a         ;c6e8  46 02
    ret                     ;c6ea  20

sub_c6eb:
    mov a, mem_00c5         ;c6eb  05 c5
    bne lab_c6f4            ;c6ed  fc 05
    movw a, #0x01a6         ;c6ef  e4 01 a6
    bne lab_c700            ;c6f2  fc 0c        BRANCH_ALWAYS_TAKEN

lab_c6f4:
    cmp a, #0x01            ;c6f4  14 01
    bne lab_c6fd            ;c6f6  fc 05
    movw a, #0x01ad         ;c6f8  e4 01 ad
    bne lab_c700            ;c6fb  fc 03        BRANCH_ALWAYS_TAKEN

lab_c6fd:
    movw a, #0x01b4         ;c6fd  e4 01 b4

lab_c700:
    movw ep, a              ;c700  e3
    mov mem_00c8, #0x00     ;c701  85 c8 00
    mov mem_009f, #0x01     ;c704  85 9f 01

lab_c707:
    mov a, @ep              ;c707  07
    cmp a, mem_00c7         ;c708  15 c7
    beq lab_c717            ;c70a  fd 0b
    incw ep                 ;c70c  c3
    mov a, mem_009f         ;c70d  05 9f
    incw a                  ;c70f  c0
    mov mem_009f, a         ;c710  45 9f
    cmp a, #0x07            ;c712  14 07
    blo lab_c707            ;c714  f9 f1
    ret                     ;c716  20

lab_c717:
    mov a, mem_009f         ;c717  05 9f
    mov mem_00c8, a         ;c719  45 c8
    ret                     ;c71b  20

sub_c71c:
    mov a, mem_00c5          ;c71c  05 c5
    beq lab_c72b             ;c71e  fd 0b
    mov a, #0x44             ;c720  04 44       0x44  'FM....MAX..'
    bbs mem_00b2:2, lab_c736 ;c722  ba b2 11
    mov a, #0x45             ;c725  04 45       0x45  'FM....MIN..'
    bbs mem_00b2:3, lab_c736 ;c727  bb b2 0c
    ret                      ;c72a  20

lab_c72b:
    mov a, #0x46             ;c72b  04 46       0x46  'AM....MAX..'
    bbs mem_00b2:2, lab_c736 ;c72d  ba b2 06
    mov a, #0x47             ;c730  04 47       0x47  'AM....MIN..'
    bbs mem_00b2:3, lab_c736 ;c732  bb b2 01
    ret                      ;c735  20

lab_c736:
    mov @ix+0x01, a         ;c736  46 01        Store display number
    ret                     ;c738  20

sub_c739:
    mov a, #0x5c             ;c739  04 5c       0x5C  'TAPE..MAX..'
    bbs mem_00b2:2, lab_c736 ;c73b  ba b2 f8
    mov a, #0x5d             ;c73e  04 5d       0x5D  'TAPE..MIN..'
    bbs mem_00b2:3, lab_c736 ;c740  bb b2 f3
    ret                      ;c743  20


sub_c744:
    beq lab_c74f            ;c744  fd 09
    bp lab_c74c             ;c746  fa 04
    incw a                  ;c748  c0
    jmp lab_c74d            ;c749  21 c7 4d
lab_c74c:
    decw a                  ;c74c  d0
lab_c74d:
    cmp a, #0x00            ;c74d  14 00
lab_c74f:
    ret                     ;c74f  20


lab_c750:
    mov a, mem_00cc         ;c750  05 cc
    cmp a, #0x04            ;c752  14 04
    beq lab_c760            ;c754  fd 0a
    cmp a, #0x05            ;c756  14 05
    beq lab_c760            ;c758  fd 06
    cmp a, #0x1f            ;c75a  14 1f
    beq lab_c760            ;c75c  fd 02
    bne lab_c766            ;c75e  fc 06        BRANCH_ALWAYS_TAKEN

lab_c760:
    mov @ix+0x01, #0x5a     ;c760  86 01 5a     Display number = 0x5a '....NO.TAPE'
    jmp lab_c80f            ;c763  21 c8 0f

lab_c766:
    mov a, mem_02fd         ;c766  60 02 fd
    cmp a, #0x01            ;c769  14 01
    beq lab_c77a            ;c76b  fd 0d
    cmp a, #0x02            ;c76d  14 02
    beq lab_c78b            ;c76f  fd 1a
    cmp a, #0x03            ;c771  14 03
    beq lab_c793            ;c773  fd 1e
    callv #5                ;c775  ed          CALLV #5 = callv5_8d0d
    call sub_9e41           ;c776  31 9e 41
    ret                     ;c779  20

lab_c77a:
    mov a, #0x02            ;c77a  04 02
    mov mem_02fd, a         ;c77c  61 02 fd
    mov a, #0x32            ;c77f  04 32
    mov mem_01c5, a         ;c781  61 01 c5
    setb mem_00d7:3         ;c784  ab d7

lab_c786:
    mov a, #0x58            ;c786  04 58
    mov @ix+0x01, a         ;c788  46 01        Display number = 0x58 'TAPE.METAL.'
    ret                     ;c78a  20

lab_c78b:
    bbs mem_00d7:3, lab_c786 ;c78b  bb d7 f8
    mov a, #0x03            ;c78e  04 03
    mov mem_02fd, a         ;c790  61 02 fd

lab_c793:
    mov a, mem_00f6         ;c793  05 f6
    and a, #0xf0            ;c795  64 f0
    cmp a, #0x20            ;c797  14 20
    beq lab_c7a1            ;c799  fd 06
    cmp a, #0x60            ;c79b  14 60
    beq lab_c7a5            ;c79d  fd 06
    bne lab_c7a9            ;c79f  fc 08        BRANCH_ALWAYS_TAKEN

lab_c7a1:
    mov a, #0x56            ;c7a1  04 56        Display number = 0x56 'TAPE.SCAN.A'
    bne lab_c7c4            ;c7a3  fc 1f        BRANCH_ALWAYS_TAKEN

lab_c7a5:
    mov a, #0x57            ;c7a5  04 57        Display number = 0x57 'TAPE.SCAN.B'
    bne lab_c7c4            ;c7a7  fc 1b        BRANCH_ALWAYS_TAKEN

lab_c7a9:
    mov a, mem_00f6         ;c7a9  05 f6
    cmp a, #0x04            ;c7ab  14 04
    beq lab_c7b3            ;c7ad  fd 04
    cmp a, #0x44            ;c7af  14 44
    bne lab_c7b8            ;c7b1  fc 05

lab_c7b3:
    mov a, mem_0302         ;c7b3  60 03 02
    beq lab_c7c6            ;c7b6  fd 0e

lab_c7b8:
    pushw ix                ;c7b8  41
    movw ix, #mem_c813      ;c7b9  e6 c8 13
    mov a, mem_00f6         ;c7bc  05 f6
    call sub_e746           ;c7be  31 e7 46
    popw ix                 ;c7c1  51
    beq lab_c7c6            ;c7c2  fd 02        Branch if mem_00f6 value not found in table

lab_c7c4:
    mov @ix+0x01, a         ;c7c4  46 01        Store Display number

lab_c7c6:
    mov a, mem_02fd         ;c7c6  60 02 fd
    cmp a, #0x03            ;c7c9  14 03
    bne lab_c7d6            ;c7cb  fc 09
    bbc mem_00f7:2, lab_c7d6 ;c7cd  b2 f7 06

    mov a, @ix+0x00         ;c7d0  06 00        A = Pictograph bits
    or a, #0b00000001       ;c7d2  74 01        Turn on Bit 0 (METAL)
    mov @ix+0x00, a         ;c7d4  46 00        Store updated pictographs

lab_c7d6:
    bbc mem_00f7:3, lab_c7df ;c7d6  b3 f7 06

    mov a, @ix+0x00         ;c7d9  06 00        A = Pictograph bits
    or a, #0b00000100       ;c7db  74 04        Turn on Bit 2 (DOLBY)
    mov @ix+0x00, a         ;c7dd  46 00        Store updated pictographs

lab_c7df:
    mov a, @ix+0x00         ;c7df  06 00        A = Pictograph bits
    or a, #0b00100000       ;c7e1  74 20        Turn on Bit 5 (HIDDEN_MODE_TAPE)
    mov @ix+0x00, a         ;c7e3  46 00        Store updated pictographs

    mov a, @ix+0x01         ;c7e5  06 01
    cmp a, #0x50            ;c7e7  14 50        0x50  'TAPE.PLAY.A'
    beq lab_c80c            ;c7e9  fd 21
    cmp a, #0x51            ;c7eb  14 51        0x51  'TAPE.PLAY.B'
    beq lab_c80c            ;c7ed  fd 1d

    mov a, mem_00f6         ;c7ef  05 f6
    cmp a, #0x22            ;c7f1  14 22
    beq lab_c808            ;c7f3  fd 13
    cmp a, #0x62            ;c7f5  14 62
    beq lab_c808            ;c7f7  fd 0f
    cmp a, #0x21            ;c7f9  14 21
    beq lab_c801            ;c7fb  fd 04
    cmp a, #0x61            ;c7fd  14 61
    bne lab_c808            ;c7ff  fc 07

lab_c801:
    mov a, mem_0369         ;c801  60 03 69
    cmp a, #0x05            ;c804  14 05
    beq lab_c80c            ;c806  fd 04

lab_c808:
    callv #5                ;c808  ed          CALLV #5 = callv5_8d0d
    jmp lab_c80f            ;c809  21 c8 0f

lab_c80c:
    call sub_c739           ;c80c  31 c7 39     'TAPE..MIN..' or 'TAPE..MAX..'

lab_c80f:
    call sub_9e41           ;c80f  31 9e 41
    ret                     ;c812  20

mem_c813:
;table of byte pairs used with sub_e746
    .byte 0x01              ;DATA       mem_00f6 = 0x01
    .byte 0x50              ;DATA       0x50  'TAPE.PLAY.A'

    .byte 0x41              ;DATA       mem_00f6 = 0x41
    .byte 0x51              ;DATA       0x51  'TAPE.PLAY.B'

    .byte 0x02              ;DATA       mem_00f6 = 0x02
    .byte 0x52              ;DATA       0x52  'TAPE..FF...'

    .byte 0x42              ;DATA       mem_00f6 = 0x42
    .byte 0x52              ;DATA       0x52  'TAPE..FF...'

    .byte 0x03              ;DATA       mem_00f6 = 0x03
    .byte 0x53              ;DATA       0x53  'TAPE..REW..'

    .byte 0x43              ;DATA       mem_00f6 = 0x43
    .byte 0x53              ;DATA       0x53  'TAPE..REW..'

    .byte 0x12              ;DATA       mem_00f6 = 0x12
    .byte 0x54              ;DATA       0x54  'TAPEMSS.FF.'

    .byte 0x52              ;DATA       mem_00f6 = 0x52
    .byte 0x54              ;DATA       0x54  'TAPEMSS.FF.'

    .byte 0x13              ;DATA       mem_00f6 = 0x13
    .byte 0x55              ;DATA       0x55  'TAPEMSS.REW'

    .byte 0x53              ;DATA       mem_00f6 = 0x53
    .byte 0x55              ;DATA       0x55  'TAPEMSS.REW'

    .byte 0x32              ;DATA       mem_00f6 = 0x32
    .byte 0x59              ;DATA       0x59  'TAPE..BLS..'

    .byte 0x72              ;DATA       mem_00f6 = 0x72
    .byte 0x59              ;DATA       0x59  'TAPE..BLS..'

    .byte 0x04              ;DATA       mem_00f6 = 0x04
    .byte 0x50              ;DATA       0x50  'TAPE.PLAY.A'

    .byte 0x44              ;DATA       mem_00f6 = 0x44
    .byte 0x51              ;DATA       0x51  'TAPE.PLAY.B'

    .byte 0xFF              ;DATA
    .byte 0x00              ;DATA

sub_c831:
    movw ix, #mem_02b6      ;c831  e6 02 b6
    mov a, #0xb1            ;c834  04 b1        Display number = 0xB1 'TESTDISPLAY'
    mov @ix+0x01, a         ;c836  46 01
    ret                     ;c838  20

sub_c839:
    mov a, #0xb0            ;c839  04 b0        Display number = 0xB0 '.....DIAG..'

lab_c83b:
    mov @ix+0x01, a         ;c83b  46 01        Store display number
    ret                     ;c83d  20

    ;XXX c83e-c844 look unreachable
    mov a, #0x5a            ;c83e  04 5a        0x5A '....NO.TAPE'
    bne lab_c83b            ;c840  fc f9        BRANCH_ALWAYS_TAKEN
    mov a, #0x58            ;c842  04 58        0x5B 'TAPE.ERROR.'
    bne lab_c83b            ;c844  fc f5        BRANCH_ALWAYS_TAKEN

sub_c846:
    mov a, mem_00c5         ;c846  05 c5
    bne lab_c86c            ;c848  fc 22
    call sub_c8f6           ;c84a  31 c8 f6
    movw a, #0x0000         ;c84d  e4 00 00
    mov a, mem_00c7         ;c850  05 c7
    movw a, #0x0062         ;c852  e4 00 62
    clrc                    ;c855  81
    addcw a                 ;c856  23
    mov r0, #0x04           ;c857  88 04

lab_c859:
    clrc                    ;c859  81
    rolc a                  ;c85a  02
    swap                    ;c85b  10
    rolc a                  ;c85c  02
    swap                    ;c85d  10
    dec r0                  ;c85e  d8
    bne lab_c859            ;c85f  fc f8
    movw mem_00be, a        ;c861  d5 be
    mov mem_00bc, #0x81     ;c863  85 bc 81
    call sub_c904           ;c866  31 c9 04
    jmp lab_c87e            ;c869  21 c8 7e

lab_c86c:
    call sub_c8e8           ;c86c  31 c8 e8
    movw a, #0x0000         ;c86f  e4 00 00
    mov a, mem_00c7         ;c872  05 c7
    movw a, #0x01ed         ;c874  e4 01 ed
    clrc                    ;c877  81
    addcw a                 ;c878  23
    movw mem_00be, a        ;c879  d5 be
    mov mem_00bc, #0x50     ;c87b  85 bc 50

lab_c87e:
    mov a, mem_00c1         ;c87e  05 c1
    cmp a, #0x01            ;c880  14 01
    beq lab_c88a            ;c882  fd 06
    cmp a, #0x02            ;c884  14 02
    beq lab_c88a            ;c886  fd 02
    clrb mem_00ba:1         ;c888  a1 ba

lab_c88a:
    clrb mem_00ba:7         ;c88a  a7 ba
    bbc mem_00ca:0, lab_c893 ;c88c  b0 ca 04
    clrb mem_00ca:0         ;c88f  a0 ca
    setb mem_00ba:7         ;c891  af ba

lab_c893:
    mov a, mem_00ba         ;c893  05 ba
    xor a, #0x7f            ;c895  54 7f
    mov mem_00bd, a         ;c897  45 bd
    mov mem_00bb, #0x00     ;c899  85 bb 00
    clrb pdr0:4             ;c89c  a4 00        PLL_CE=low (disabled)
    clrb pdr1:0             ;c89e  a0 02        SK=low
    clrb pdr0:5             ;c8a0  a5 00        EEPROM_CS=low (diabled)
    mov a, mem_00c1         ;c8a2  05 c1
    cmp a, #0x01            ;c8a4  14 01
    beq lab_c8ac            ;c8a6  fd 04
    cmp a, #0x02            ;c8a8  14 02
    bne lab_c8b3            ;c8aa  fc 07

lab_c8ac:
    mov mem_00a3, #0x03     ;c8ac  85 a3 03
    mov a, #0x02            ;c8af  04 02
    bne lab_c8b8            ;c8b1  fc 05        BRANCH_ALWAYS_TAKEN

lab_c8b3:
    mov mem_00a3, #0x05     ;c8b3  85 a3 05
    mov a, #0x01            ;c8b6  04 01

lab_c8b8:
    mov a, #0x04            ;c8b8  04 04
    xch a, t                ;c8ba  42
    call sub_c928           ;c8bb  31 c9 28
    setb pdr0:4             ;c8be  ac 00        PLL_CE=high (enabled)
    mov mem_00a2, #0x00     ;c8c0  85 a2 00
    movw ix, #mem_00be      ;c8c3  e6 00 be
    incw ix                 ;c8c6  c2

lab_c8c7:
    mov a, mem_00a2         ;c8c7  05 a2
    cmp a, #0x04            ;c8c9  14 04
    beq lab_c8d1            ;c8cb  fd 04
    mov a, #0x08            ;c8cd  04 08
    bne lab_c8d3            ;c8cf  fc 02        BRANCH_ALWAYS_TAKEN

lab_c8d1:
    mov a, #0x04            ;c8d1  04 04

lab_c8d3:
    mov a, @ix+0x00         ;c8d3  06 00
    call sub_c928           ;c8d5  31 c9 28
    decw ix                 ;c8d8  d2
    mov a, mem_00a2         ;c8d9  05 a2
    incw a                  ;c8db  c0
    mov mem_00a2, a         ;c8dc  45 a2
    mov a, mem_00a3         ;c8de  05 a3
    cmp a                   ;c8e0  12
    bne lab_c8c7            ;c8e1  fc e4
    clrb pdr0:4             ;c8e3  a4 00        PLL_CE=low (disabled)
    setb mem_00c9:7         ;c8e5  af c9
    ret                     ;c8e7  20

sub_c8e8:
    bbc mem_00d0:5, lab_c8ef ;c8e8  b5 d0 04
    clrb mem_00d0:5         ;c8eb  a5 d0
    setb mem_00ba:5         ;c8ed  ad ba

lab_c8ef:
    bne lab_c8f3            ;c8ef  fc 02
    clrb mem_00ba:5         ;c8f1  a5 ba

lab_c8f3:
    setb mem_00ba:4         ;c8f3  ac ba
    ret                     ;c8f5  20

sub_c8f6:
    bbc mem_00d0:5, lab_c8fd ;c8f6  b5 d0 04
    clrb mem_00d0:5         ;c8f9  a5 d0
    setb mem_00ba:4         ;c8fb  ac ba

lab_c8fd:
    bne lab_c901            ;c8fd  fc 02
    clrb mem_00ba:4         ;c8ff  a4 ba

lab_c901:
    setb mem_00ba:5         ;c901  ad ba
    ret                     ;c903  20

sub_c904:
    mov a, mem_0095         ;c904  05 95
    bne lab_c927            ;c906  fc 1f
    mov a, mem_00c5         ;c908  05 c5
    bne lab_c927            ;c90a  fc 1b
    mov a, mem_00c1         ;c90c  05 c1
    beq lab_c918            ;c90e  fd 08
    cmp mem_00c1, #0x02     ;c910  95 c1 02
    bne lab_c925            ;c913  fc 10
    bbc mem_00c9:6, lab_c925 ;c915  b6 c9 0d

lab_c918:
    mov a, mem_00c7         ;c918  05 c7
    cmp a, #0x25            ;c91a  14 25
    beq lab_c922            ;c91c  fd 04
    cmp a, #0x52            ;c91e  14 52
    bne lab_c925            ;c920  fc 03

lab_c922:
    clrb mem_00ba:0         ;c922  a0 ba
    ret                     ;c924  20

lab_c925:
    setb mem_00ba:0         ;c925  a8 ba

lab_c927:
    ret                     ;c927  20


sub_c928:
    rorc a                  ;c928  03
    bhs lab_c92f            ;c929  f8 04
    setb pdr0:7             ;c92b  af 00        EEPROM_DO=high
    blo lab_c931            ;c92d  f9 02        BRANCH_ALWAYS_TAKEN

lab_c92f:
    clrb pdr0:7             ;c92f  a7 00        EEPROM_DO=low

lab_c931:
    xch a, t                ;c931  42
    dec r0                  ;c932  d8
    setb pdr1:0             ;c933  a8 02        SK=high
    decw a                  ;c935  d0
    cmp a, #0x00            ;c936  14 00
    xch a, t                ;c938  42
    xch a, t                ;c939  42
    nop                     ;c93a  00
    clrb pdr1:0             ;c93b  a0 02        SK=low
    xch a, t                ;c93d  42
    bne sub_c928            ;c93e  fc e8
    ret                     ;c940  20

sub_c941:
    clrb pdr0:4             ;c941  a4 00        PLL_CE=low (disabled)
    clrb pdr0:5             ;c943  a5 00        EEPROM_CS=low (disabled)
    mov a, #0x04            ;c945  04 04
    mov a, #0x03            ;c947  04 03
    call sub_c928           ;c949  31 c9 28
    movw ix, #mem_0281      ;c94c  e6 02 81
    setb pdr0:4             ;c94f  ac 00        PLL_CE=high (enabled)
    mov a, #0x04            ;c951  04 04
    mov mem_00a2, a         ;c953  45 a2

lab_c955:
    cmp a, #0x01            ;c955  14 01
    bne lab_c95e            ;c957  fc 05
    mov a, #0x04            ;c959  04 04
    jmp lab_c960            ;c95b  21 c9 60

lab_c95e:
    mov a, #0x08            ;c95e  04 08

lab_c960:
    call sub_c977           ;c960  31 c9 77
    mov mem_00b9, a         ;c963  45 b9
    mov @ix+0x00, a         ;c965  46 00
    incw ix                 ;c967  c2
    movw a, #0x0000         ;c968  e4 00 00
    mov a, mem_00a2         ;c96b  05 a2
    decw a                  ;c96d  d0
    mov mem_00a2, a         ;c96e  45 a2
    bne lab_c955            ;c970  fc e3
    clrb pdr0:4             ;c972  a4 00        PLL_CE=low (disabled)
    setb mem_00c9:3         ;c974  ab c9
    ret                     ;c976  20

sub_c977:
    movw a, #0x0000         ;c977  e4 00 00

lab_c97a:
    setb pdr1:0             ;c97a  a8 02        SK=high
    dec r0                  ;c97c  d8
    cmp a, r0               ;c97d  18
    clrb pdr1:0             ;c97e  a0 02        SK=low
    inc r0                  ;c980  c8
    clrc                    ;c981  81
    bbc pdr0:6, lab_c986    ;c982  b6 00 01     PLL_DI
    setc                    ;c985  91

lab_c986:
    rolc a                  ;c986  02
    xch a, t                ;c987  42
    decw a                  ;c988  d0
    xch a, t                ;c989  42
    bne lab_c97a            ;c98a  fc ee
    ret                     ;c98c  20

sub_c98d:
    clrb pdr0:4             ;c98d  a4 00        PLL_CE=low (disabled)
    clrb pdr0:5             ;c98f  a5 00        EEPROM_CS=low (disabled)
    mov a, #0x04            ;c991  04 04
    mov a, #0x03            ;c993  04 03
    call sub_c928           ;c995  31 c9 28
    setb mem_00c9:3         ;c998  ab c9
    ret                     ;c99a  20

mem_c99b:
    .word mem_01ad          ;DATA
    .byte 0x00              ;DATA
    .byte 0x01              ;DATA

    .word mem_01ae          ;DATA
    .byte 0x01              ;DATA
    .byte 0x01              ;DATA

    .word mem_01af          ;DATA
    .byte 0x02              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b0          ;DATA
    .byte 0x03              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b1          ;DATA
    .byte 0x04              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b2          ;DATA
    .byte 0x05              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b4          ;DATA
    .byte 0x10              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b5          ;DATA
    .byte 0x11              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b6          ;DATA
    .byte 0x12              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b7          ;DATA
    .byte 0x13              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b8          ;DATA
    .byte 0x14              ;DATA
    .byte 0x01              ;DATA

    .word mem_01b9          ;DATA
    .byte 0x15              ;DATA
    .byte 0x01              ;DATA

    .word mem_01a6          ;DATA
    .byte 0x20              ;DATA
    .byte 0x01              ;DATA

    .word mem_01a7          ;DATA
    .byte 0x21              ;DATA
    .byte 0x01              ;DATA

    .word mem_01a8          ;DATA
    .byte 0x22              ;DATA
    .byte 0x01              ;DATA

    .word mem_01a9          ;DATA
    .byte 0x23              ;DATA
    .byte 0x01              ;DATA

    .word mem_01aa          ;DATA
    .byte 0x24              ;DATA
    .byte 0x01              ;DATA

    .word mem_01ab          ;DATA
    .byte 0x25              ;DATA
    .byte 0x01              ;DATA

sub_c9e3:
    mov a, mem_0274         ;c9e3  60 02 74     A = table index
    movw a, #mem_c9ec       ;c9e6  e4 c9 ec     A = table base address
    jmp sub_e73c            ;c9e9  21 e7 3c     Jump to address in table

mem_c9ec:
    .word lab_ca2c          ;c9ec  ca 2c       VECTOR
    .word lab_c9f8          ;c9ee  c9 f8       VECTOR
    .word lab_ca1d          ;c9f0  ca 1d       VECTOR
    .word lab_ca2d          ;c9f2  ca 2d       VECTOR
    .word lab_cab5          ;c9f4  ca b5       VECTOR
    .word lab_cb01          ;c9f6  cb 01       VECTOR

lab_c9f8:
    movw a, #0x0000         ;c9f8  e4 00 00
    mov a, mem_026c         ;c9fb  60 02 6c
    clrc                    ;c9fe  81
    rolc a                  ;c9ff  02
    swap                    ;ca00  10
    rolc a                  ;ca01  02
    swap                    ;ca02  10
    clrc                    ;ca03  81
    rolc a                  ;ca04  02
    swap                    ;ca05  10
    rolc a                  ;ca06  02
    swap                    ;ca07  10
    movw a, #mem_c99b       ;ca08  e4 c9 9b
    clrc                    ;ca0b  81
    addcw a                 ;ca0c  23
    movw ix, a              ;ca0d  e2
    movw a, @ix+0x00        ;ca0e  c6 00
    movw mem_026e, a        ;ca10  d4 02 6e
    mov a, @ix+0x02         ;ca13  06 02
    mov mem_026d, a         ;ca15  61 02 6d
    mov a, @ix+0x03         ;ca18  06 03
    mov mem_0270, a         ;ca1a  61 02 70

lab_ca1d:
    mov a, #0x04            ;ca1d  04 04
    bbc mem_00c0:1, lab_ca24 ;ca1f  b1 c0 02
    mov a, #0x03            ;ca22  04 03

lab_ca24:
    mov mem_0274, a         ;ca24  61 02 74
    mov a, #0x01            ;ca27  04 01
    mov mem_0273, a         ;ca29  61 02 73

lab_ca2c:
;mem_cb16 table case 0
;also
;mem_c9ec table case 0
    ret                     ;ca2c  20

lab_ca2d:
    mov a, mem_0273         ;ca2d  60 02 73     A = table index
    mov a, mem_0273         ;ca30  60 02 73     A = table index again (XXX useless)
    movw a, #mem_ca39       ;ca33  e4 ca 39     A = table base address
    jmp sub_e73c            ;ca36  21 e7 3c     Jump to address in table

mem_ca39:
    .word lab_ca2c          ;ca39  ca 2c       VECTOR
    .word lab_ca45          ;ca3b  ca 45       VECTOR
    .word lab_ca50          ;ca3d  ca 50       VECTOR
    .word lab_ca70          ;ca3f  ca 70       VECTOR
    .word lab_ca9c          ;ca41  ca 9c       VECTOR
    .word lab_caa7          ;ca43  ca a7       VECTOR

lab_ca45:
    mov a, #0x03            ;ca45  04 03
    mov mem_0272, a         ;ca47  61 02 72
    setb mem_00c0:7         ;ca4a  af c0
    mov a, #0x02            ;ca4c  04 02
    bne lab_cab1            ;ca4e  fc 61        BRANCH_ALWAYS_TAKEN

lab_ca50:
    bbs mem_00c0:7, lab_cab4 ;ca50  bf c0 61
    bbc mem_00c0:2, lab_ca5c ;ca53  b2 c0 06
    clrb mem_00c0:2         ;ca56  a2 c0
    mov a, #0x05            ;ca58  04 05
    bne lab_ca65            ;ca5a  fc 09        BRANCH_ALWAYS_TAKEN

lab_ca5c:
    movw a, mem_026e        ;ca5c  c4 02 6e
    mov a, @a               ;ca5f  92
    mov mem_026b, a         ;ca60  61 02 6b
    mov a, #0x01            ;ca63  04 01

lab_ca65:
    mov mem_0272, a         ;ca65  61 02 72
    setb mem_00c0:7         ;ca68  af c0
    clrb mem_00c0:0         ;ca6a  a0 c0
    mov a, #0x03            ;ca6c  04 03
    bne lab_cab1            ;ca6e  fc 41        BRANCH_ALWAYS_TAKEN

lab_ca70:
    bbs mem_00c0:7, lab_cab4 ;ca70  bf c0 41
    bbs mem_00c0:0, lab_ca79 ;ca73  b8 c0 03
    bbc pdr0:0, lab_cab4     ;ca76  b0 00 3b    EEPROM_DI

lab_ca79:
    clrb pdr0:5             ;ca79  a5 00        EEPROM_CS=low(disabled)
    mov a, mem_0270         ;ca7b  60 02 70
    decw a                  ;ca7e  d0
    mov mem_0270, a         ;ca7f  61 02 70
    cmp a, #0x00            ;ca82  14 00
    bne lab_ca8a            ;ca84  fc 04
    mov a, #0x04            ;ca86  04 04
    bne lab_cab1            ;ca88  fc 27        BRANCH_ALWAYS_TAKEN

lab_ca8a:
    mov a, mem_026d         ;ca8a  60 02 6d
    incw a                  ;ca8d  c0
    mov mem_026d, a         ;ca8e  61 02 6d

    movw a, mem_026e        ;ca91  c4 02 6e
    incw a                  ;ca94  c0
    movw mem_026e, a        ;ca95  d4 02 6e

    mov a, #0x02            ;ca98  04 02
    bne lab_cab1            ;ca9a  fc 15        BRANCH_ALWAYS_TAKEN

lab_ca9c:
    mov a, #0x04            ;ca9c  04 04
    mov mem_0272, a         ;ca9e  61 02 72
    setb mem_00c0:7         ;caa1  af c0
    mov a, #0x05            ;caa3  04 05
    bne lab_cab1            ;caa5  fc 0a        BRANCH_ALWAYS_TAKEN

lab_caa7:
    bbs mem_00c0:7, lab_cab4 ;caa7  bf c0 0a
    mov a, #0x05            ;caaa  04 05
    mov mem_0274, a         ;caac  61 02 74
    mov a, #0x00            ;caaf  04 00

lab_cab1:
    mov mem_0273, a         ;cab1  61 02 73

lab_cab4:
    ret                     ;cab4  20

lab_cab5:
    mov a, mem_0273         ;cab5  60 02 73
    cmp a, #0x01            ;cab8  14 01
    beq lab_cac1            ;caba  fd 05
    cmp a, #0x02            ;cabc  14 02
    beq lab_cacc            ;cabe  fd 0c
    ret                     ;cac0  20

lab_cac1:
    mov a, #0x02            ;cac1  04 02
    mov mem_0272, a         ;cac3  61 02 72
    setb mem_00c0:7         ;cac6  af c0
    mov mem_0273, a         ;cac8  61 02 73
    ret                     ;cacb  20

lab_cacc:
    bbs mem_00c0:7, lab_caec ;cacc  bf c0 1d
    movw a, mem_026e        ;cacf  c4 02 6e
    movw ep, a              ;cad2  e3
    mov a, mem_026b         ;cad3  60 02 6b
    mov @ep, a              ;cad6  47
    mov a, mem_0270         ;cad7  60 02 70
    decw a                  ;cada  d0
    mov mem_0270, a         ;cadb  61 02 70
    cmp a, #0x00            ;cade  14 00
    bne lab_caed            ;cae0  fc 0b
    mov a, #0x00            ;cae2  04 00
    mov mem_0273, a         ;cae4  61 02 73
    mov a, #0x05            ;cae7  04 05
    mov mem_0274, a         ;cae9  61 02 74

lab_caec:
    ret                     ;caec  20

lab_caed:
    mov a, mem_026d         ;caed  60 02 6d
    incw a                  ;caf0  c0
    mov mem_026d, a         ;caf1  61 02 6d

    movw a, mem_026e        ;caf4  c4 02 6e
    incw a                  ;caf7  c0
    movw mem_026e, a        ;caf8  d4 02 6e

    mov a, #0x01            ;cafb  04 01
    mov mem_0273, a         ;cafd  61 02 73
    ret                     ;cb00  20

lab_cb01:
    mov a, #0x00            ;cb01  04 00
    mov mem_0274, a         ;cb03  61 02 74
    clrb mem_0097:1         ;cb06  a1 97
    ret                     ;cb08  20

sub_cb09:
    clrb pdr0:4             ;cb09  a4 00        PLL_CE=low (disabled)
    setb pdr0:5             ;cb0b  ad 00        EEPROM_CS=high (enabled)

    mov a, mem_0272         ;cb0d  60 02 72     A = table index
    movw a, #mem_cb16       ;cb10  e4 cb 16     A = pointer to table
    jmp sub_e73c            ;cb13  21 e7 3c     Jump to address in table

mem_cb16:
    .word lab_ca2c          ;cb16  ca 2c       VECTOR 0
    .word lab_cb50          ;cb18  cb 50       VECTOR 1
    .word lab_cb43          ;cb1a  cb 43       VECTOR 2
    .word lab_cb2d          ;cb1c  cb 2d       VECTOR 3
    .word lab_cb38          ;cb1e  cb 38       VECTOR 4
    .word lab_cb22          ;cb20  cb 22       VECTOR 5

lab_cb22:
;mem_cb16 table case 5
    movw a, #0x8003         ;cb22  e4 80 03
    callv #6                ;cb25  ee           EEPROM related (CALLV #6 = callv6_cb98)
    movw a, #0x8007         ;cb26  e4 80 07
    callv #6                ;cb29  ee           EEPROM related (CALLV #6 = callv6_cb98)
    jmp lab_cb62            ;cb2a  21 cb 62

lab_cb2d:
;mem_cb16 table case 3
    movw a, #0x8003         ;cb2d  e4 80 03
    callv #6                ;cb30  ee           EEPROM related (CALLV #6 = callv6_cb98)
    movw a, #0xc007         ;cb31  e4 c0 07
    callv #6                ;cb34  ee           EEPROM related (CALLV #6 = callv6_cb98)
    jmp lab_cb6f            ;cb35  21 cb 6f

lab_cb38:
;mem_cb16 table case 4
    movw a, #0x8003         ;cb38  e4 80 03
    callv #6                ;cb3b  ee           EEPROM related (CALLV #6 = callv6_cb98)
    movw a, #0x0007         ;cb3c  e4 00 07
    callv #6                ;cb3f  ee           EEPROM related (CALLV #6 = callv6_cb98)
    jmp lab_cb6f            ;cb40  21 cb 6f

lab_cb43:
;mem_cb16 table case 2
    movw a, #0xc003         ;cb43  e4 c0 03
    callv #6                ;cb46  ee           EEPROM related (CALLV #6 = callv6_cb98)
    call sub_cb9c           ;cb47  31 cb 9c     EEPROM related
    call sub_cbc6           ;cb4a  31 cb c6     Read byte from EEPROM, store it in mem_026b
    jmp lab_cb6f            ;cb4d  21 cb 6f

lab_cb50:
;mem_cb16 table case 1
    movw a, #0xa003         ;cb50  e4 a0 03
    callv #6                ;cb53  ee           EEPROM related (CALLV #6 = callv6_cb98)
    call sub_cb9c           ;cb54  31 cb 9c     EEPROM related
    mov a, mem_026b         ;cb57  60 02 6b
    mov mem_009f, a         ;cb5a  45 9f
    mov mem_00a0, #0x08     ;cb5c  85 a0 08
    call sub_cba6           ;cb5f  31 cb a6     EEPROM related

lab_cb62:
    clrb pdr0:5             ;cb62  a5 00        EEPROM_CS=low (disabled)
    nop                     ;cb64  00
    nop                     ;cb65  00
    nop                     ;cb66  00
    setb pdr0:5             ;cb67  ad 00        EEPROM_CS=high (enabled)
    mov a, #0x04            ;cb69  04 04
    mov mem_0271, a         ;cb6b  61 02 71
    ret                     ;cb6e  20

lab_cb6f:
    clrb pdr0:5             ;cb6f  a5 00        EEPROM_CS=low (disabled)
    ret                     ;cb71  20


sub_cb72:
;Read byte from EEPROM, store it in mem_0089 (KW1281 byte to send)
;Used only for KW1281 Block title 0x19 Read EEPROM (mem_0080 = 0xc0)
    mov a, mem_0147+1       ;cb72  60 01 48     A = EEPROM address to read
    mov mem_026d, a         ;cb75  61 02 6d     Copy address into mem_026d

    ;EEPROM addresses 0x0E-0x0F are special and can't be read
    cmp a, #0x0e            ;cb78  14 0e
    beq lab_cb80            ;cb7a  fd 04
    cmp a, #0x0f            ;cb7c  14 0f
    bne lab_cb84            ;cb7e  fc 04

lab_cb80:
;EEPROM address is 0x0E-0x0F
;Do nothing and return 0 as the data byte read
    mov a, #0x00            ;cb80  04 00
    beq lab_cb95            ;cb82  fd 11        BRANCH_ALWAYS_TAKEN

lab_cb84:
;EEPROM address is not 0x0E-0x0F
;Read the data byte from the EEPROM
    setb pdr0:5             ;cb84  ad 00        EEPROM_CS=high (enabled)
    movw a, #0xc003         ;cb86  e4 c0 03
    callv #6                ;cb89  ee           EEPROM related (CALLV #6 = callv6_cb98)
    call sub_cb9c           ;cb8a  31 cb 9c     EEPROM related
    call sub_cbc6           ;cb8d  31 cb c6     Read byte from EEPROM, store it in mem_026b
    clrb pdr0:5             ;cb90  a5 00        EEPROM_CS=low (disabled)
    mov a, mem_026b         ;cb92  60 02 6b     A = byte read from EEPROM

lab_cb95:
    mov mem_0089, a         ;cb95  45 89        KW1281 byte to send = A
    ret                     ;cb97  20


callv6_cb98:
;CALLV #6
    movw mem_009f, a        ;cb98  d5 9f
    bne sub_cba6            ;cb9a  fc 0a        EEPROM related

sub_cb9c:
    mov a, mem_026d         ;cb9c  60 02 6d
    clrc                    ;cb9f  81
    rolc a                  ;cba0  02
    mov mem_009f, a         ;cba1  45 9f
    mov mem_00a0, #0x07     ;cba3  85 a0 07

sub_cba6:
    clrb pdr1:0             ;cba6  a0 02        SK
    mov a, mem_009f         ;cba8  05 9f
    clrc                    ;cbaa  81
    rolc a                  ;cbab  02
    mov mem_009f, a         ;cbac  45 9f
    bc lab_cbb4_carry       ;cbae  f9 04
    clrb pdr0:7             ;cbb0  a7 00        EEPROM_DO=low
    bnc lab_cbb4_no_carry   ;cbb2  f8 02        BRANCH_ALWAYS_TAKEN

lab_cbb4_carry:
    setb pdr0:7             ;cbb4  af 00        EEPROM_DO=high

lab_cbb4_no_carry:
    nop                     ;cbb6  00
    nop                     ;cbb7  00
    setb pdr1:0             ;cbb8  a8 02        SK=high
    mov a, mem_00a0         ;cbba  05 a0
    decw a                  ;cbbc  d0
    mov mem_00a0, a         ;cbbd  45 a0
    cmp a, #0x00            ;cbbf  14 00
    bne sub_cba6            ;cbc1  fc e3        EEPROM related
    clrb pdr1:0             ;cbc3  a0 02        SK=low
    ret                     ;cbc5  20

sub_cbc6:
;Read byte from EEPROM, store it in mem_026b
    clrb pdr1:0             ;cbc6  a0 02        SK=low
    mov mem_00a0, #0x08     ;cbc8  85 a0 08

lab_cbcb:
    setb pdr1:0             ;cbcb  a8 02        SK=high
    cmpw a                  ;cbcd  13
    clrb pdr1:0             ;cbce  a0 02        SK=low
    cmpw a                  ;cbd0  13
    clrc                    ;cbd1  81
    bbc pdr0:0, lab_cbd6    ;cbd2  b0 00 01     EEPROM_DI
    setc                    ;cbd5  91

lab_cbd6:
    mov a, mem_00a1         ;cbd6  05 a1
    rolc a                  ;cbd8  02
    mov mem_00a1, a         ;cbd9  45 a1
    mov a, mem_00a0         ;cbdb  05 a0
    decw a                  ;cbdd  d0
    mov mem_00a0, a         ;cbde  45 a0
    cmp a, #0x00            ;cbe0  14 00
    bne lab_cbcb            ;cbe2  fc e7
    mov a, mem_00a1         ;cbe4  05 a1
    mov mem_026b, a         ;cbe6  61 02 6b
    ret                     ;cbe9  20


sub_cbea:
    mov a, mem_00f5         ;cbea  05 f5
    bne lab_cbf1            ;cbec  fc 03
    call sub_cd97           ;cbee  31 cd 97

lab_cbf1:
    bbs mem_0097:1, lab_cc27 ;cbf1  b9 97 33
    mov a, mem_00f3         ;cbf4  05 f3
    beq lab_cc2b            ;cbf6  fd 33
    cmp a, #0x04            ;cbf8  14 04
    beq lab_cc28            ;cbfa  fd 2c
    cmp a, #0x06            ;cbfc  14 06
    beq lab_cc34            ;cbfe  fd 34
    cmp a, #0x07            ;cc00  14 07
    beq lab_cc34            ;cc02  fd 30
    cmp a, #0x1a            ;cc04  14 1a
    beq lab_cc3f            ;cc06  fd 37
    cmp a, #0x21            ;cc08  14 21
    beq lab_cc2f            ;cc0a  fd 23

lab_cc0c:
    movw a, #0x0000         ;cc0c  e4 00 00
    mov a, mem_00f3         ;cc0f  05 f3
    clrc                    ;cc11  81
    rolc a                  ;cc12  02
    rolc a                  ;cc13  02
    movw a, #mem_cc43       ;cc14  e4 cc 43
    addcw a                 ;cc17  23
    movw ix, a              ;cc18  e2
    movw a, @ix+0x00        ;cc19  c6 00
    movw a, @ix+0x02        ;cc1b  c6 02
    call sub_cd1f           ;cc1d  31 cd 1f
    mov a, #0x02            ;cc20  04 02
    mov mem_0274, a         ;cc22  61 02 74
    setb mem_0097:1         ;cc25  a9 97

lab_cc27:
    ret                     ;cc27  20

lab_cc28:
    mov mem_00f3, #0x00     ;cc28  85 f3 00

lab_cc2b:
    call sub_cd8f           ;cc2b  31 cd 8f
    ret                     ;cc2e  20

lab_cc2f:
    movw a, #0xffff         ;cc2f  e4 ff ff
    bne lab_cc37            ;cc32  fc 03        BRANCH_ALWAYS_TAKEN

lab_cc34:
    movw a, #0x5a5a         ;cc34  e4 5a 5a

lab_cc37:
    movw mem_0275, a        ;cc37  d4 02 75
    movw mem_0277, a        ;cc3a  d4 02 77
    bne lab_cc0c            ;cc3d  fc cd        BRANCH_ALWAYS_TAKEN

lab_cc3f:
    clrb mem_00de:6         ;cc3f  a6 de
    beq lab_cc0c            ;cc41  fd c9        BRANCH_ALWAYS_TAKEN

mem_cc43:
    .word 0
    .word 0

    .word 0x0027
    .word mem_cd67

    .word 0xf003
    .word mem_cd53

    .word 0xf004
    .word mem_cd87

    .word 0
    .word 0

    .word 0x0004
    .word mem_cd7f

    .word 0x0007
    .word mem_cd53

    .word 0x0008
    .word mem_cd87

    .word 0x0009
    .word mem_cd3f

    .word 0x000a
    .word mem_cd5b

    .word 0x000b
    .word mem_cd63

    .word 0x000c
    .word mem_cd5f

    .word 0x0030
    .word mem_cd67

    .word 0x000e
    .word mem_cd43

    .word 0x0004
    .word mem_cd47

    .word 0x0004
    .word mem_cd5f

    .word 0x0013
    .word mem_cd6f

    .word 0x0024
    .word mem_cd6f

    .word 0x000d
    .word mem_cd6b

    .word 0x0034
    .word mem_cd7b

    .word 0xf015
    .word mem_cd3f

    .word 0xf016
    .word mem_cd5b

    .word 0xf017
    .word mem_cd63

    .word 0xf018
    .word mem_cd5f

    .word 0xf019
    .word mem_cd67

    .word 0xf01a
    .word mem_cd43

    .word 0xf01b
    .word mem_cd47

    .word 0xf031
    .word mem_cd57

    .word 0xf01d
    .word mem_cd6f

    .word 0xf035
    .word mem_cd6b

    .word 0x0026
    .word mem_cd57

    .word 0x0004
    .word mem_cd4f

    .word 0x002e
    .word mem_cd6b

    .word 0x0004
    .word mem_cd53

    .word 0xf023
    .word mem_cd4f

    .word 0xf02a
    .word mem_cd7b

    .word 0x0028
    .word mem_cd7b

    .word 0xf004
    .word mem_cd4b

    .word 0x0027
    .word mem_cd43

    .word 0x0004
    .word mem_cd4b

    .word 0x0012
    .word mem_cd77

    .word 0x0004
    .word mem_cd77

    .word 0xf025
    .word mem_cd77

    .word 0x002c
    .word mem_cd8b

    .word 0xf004
    .word mem_cd8b

    .word 0x0026
    .word mem_cd6b

    .word 0x0004
    .word mem_cd73

    .word 0x0004
    .word mem_cd67

    .word 0x0036
    .word mem_cd83

    .word 0xf01c
    .word mem_cd83

    .word 0x0004
    .word mem_cd83

    .word 0xf004
    .word mem_cd83

    .word 0x0029
    .word mem_cd7f

    .word 0xf022
    .word mem_cd7f

    .word 0x0011
    .word mem_cd7f

sub_cd1f:
    movw ix, a              ;cd1f  e2
    xchw a, t               ;cd20  43
    movw ep, a              ;cd21  e3
    movw a, @ix+0x00        ;cd22  c6 00
    movw mem_026e, a        ;cd24  d4 02 6e
    mov a, @ix+0x02         ;cd27  06 02
    mov mem_026d, a         ;cd29  61 02 6d
    mov a, @ix+0x03         ;cd2c  06 03
    mov mem_0270, a         ;cd2e  61 02 70
    movw a, ep              ;cd31  f3
    mov mem_00f3, a         ;cd32  45 f3
    clrb mem_00c0:1         ;cd34  a1 c0
    movw a, #0xf000         ;cd36  e4 f0 00
    andw a                  ;cd39  63
    bne lab_cd3e            ;cd3a  fc 02
    setb mem_00c0:1         ;cd3c  a9 c0

lab_cd3e:
    ret                     ;cd3e  20

mem_cd3f:
    .byte 0x01              ;cd3f  01          DATA '\x01'
    .byte 0xAD              ;cd40  ad          DATA '\xad'
    .byte 0x00              ;cd41  00          DATA '\x00'
    .byte 0x06              ;cd42  06          DATA '\x06'

mem_cd43:
    .byte 0x00              ;cd43  00          DATA '\x00'
    .byte 0xDE              ;cd44  de          DATA '\xde'
    .byte 0x06              ;cd45  06          DATA '\x06'
    .byte 0x01              ;cd46  01          DATA '\x01'

mem_cd47:
    .byte 0x02              ;cd47  02          DATA '\x02'
    .byte 0x90              ;cd48  90          DATA '\x90'
    .byte 0x07              ;cd49  07          DATA '\x07'
    .byte 0x01              ;cd4a  01          DATA '\x01'

mem_cd4b:
    .byte 0x02              ;cd4b  02          DATA '\x02'
    .byte 0x0E              ;cd4c  0e          DATA '\x0e'
    .byte 0x0A              ;cd4d  0a          DATA '\n'
    .byte 0x01              ;cd4e  01          DATA '\x01'

mem_cd4f:
    .byte 0x02              ;cd4f  02          DATA '\x02'
    .byte 0x08              ;cd50  08          DATA '\x08'
    .byte 0x0B              ;cd51  0b          DATA '\x0b'
    .byte 0x01              ;cd52  01          DATA '\x01'

mem_cd53:
    .byte 0x02              ;cd53  02          DATA '\x02'
    .byte 0x75              ;cd54  75          DATA 'u'
    .byte 0x0C              ;cd55  0c          DATA '\x0c'
    .byte 0x02              ;cd56  02          DATA '\x02'

mem_cd57:
    .byte 0x02              ;cd57  02          DATA '\x02'
    .byte 0x0F              ;cd58  0f          DATA '\x0f'
    .byte 0x0E              ;cd59  0e          DATA '\x0e'
    .byte 0x02              ;cd5a  02          DATA '\x02'

mem_cd5b:
    .byte 0x01              ;cd5b  01          DATA '\x01'
    .byte 0xB4              ;cd5c  b4          DATA '\xb4'
    .byte 0x10              ;cd5d  10          DATA '\x10'
    .byte 0x06              ;cd5e  06          DATA '\x06'

mem_cd5f:
    .byte 0x02              ;cd5f  02          DATA '\x02'
    .byte 0x96              ;cd60  96          DATA '\x96'
    .byte 0x16              ;cd61  16          DATA '\x16'
    .byte 0x08              ;cd62  08          DATA '\x08'

mem_cd63:
    .byte 0x01              ;cd63  01          DATA '\x01'
    .byte 0xA6              ;cd64  a6          DATA '\xa6'
    .byte 0x20              ;cd65  20          DATA ' '
    .byte 0x06              ;cd66  06          DATA '\x06'

mem_cd67:
    .byte 0x03              ;cd67  03          DATA '\x03'
    .byte 0xAF              ;cd68  af          DATA '\xaf'
    .byte 0x2B              ;cd69  2b          DATA '+'
    .byte 0x05              ;cd6a  05          DATA '\x05'

mem_cd6b:
    .byte 0x01              ;cd6b  01          DATA '\x01'
    .byte 0x75              ;cd6c  75          DATA 'u'
    .byte 0x3C              ;cd6d  3c          DATA '<'
    .byte 0x04              ;cd6e  04          DATA '\x04'

mem_cd6f:
    .byte 0x01              ;cd6f  01          DATA '\x01'
    .byte 0x49              ;cd70  49          DATA 'I'
    .byte 0x40              ;cd71  40          DATA '@'
    .byte 0x20              ;cd72  20          DATA ' '

mem_cd73:
    .byte 0x01              ;cd73  01          DATA '\x01'
    .byte 0x65              ;cd74  65          DATA 'e'
    .byte 0x5C              ;cd75  5c          DATA '\\'
    .byte 0x04              ;cd76  04          DATA '\x04'

mem_cd77:
    .byte 0x03              ;cd77  03          DATA '\x03'
    .byte 0x0C              ;cd78  0c          DATA '\x0c'
    .byte 0x60              ;cd79  60          DATA '`'
    .byte 0x06              ;cd7a  06          DATA '\x06'

mem_cd7b:
    .byte 0x01              ;cd7b  01          DATA '\x01'
    .byte 0x69              ;cd7c  69          DATA 'i'
    .byte 0x6C              ;cd7d  6c          DATA 'l'
    .byte 0x04              ;cd7e  04          DATA '\x04'

mem_cd7f:
    .byte 0x01              ;cd7f  01          DATA '\x01'
    .byte 0x6D              ;cd80  6d          DATA 'm'
    .byte 0x70              ;cd81  70          DATA 'p'
    .byte 0x04              ;cd82  04          DATA '\x04'

mem_cd83:
    .byte 0x03              ;cd83  03          DATA '\x03'
    .byte 0x47              ;cd84  47          DATA 'G'
    .byte 0x74              ;cd85  74          DATA 't'
    .byte 0x02              ;cd86  02          DATA '\x02'

mem_cd87:
    .byte 0x02              ;cd87  02          DATA '\x02'
    .byte 0x77              ;cd88  77          DATA 'w'
    .byte 0x7C              ;cd89  7c          DATA '|'
    .byte 0x02              ;cd8a  02          DATA '\x02'

mem_cd8b:
    .byte 0x02              ;cd8b  02          DATA '\x02'
    .byte 0x75              ;cd8c  75          DATA 'u'
    .byte 0x7F              ;cd8d  7f          DATA '\x7f'
    .byte 0x01              ;cd8e  01          DATA '\x01'

sub_cd8f:
    mov a, mem_00f5         ;cd8f  05 f5
    beq lab_cda2            ;cd91  fd 0f
    and a, #0x7f            ;cd93  64 7f
    mov mem_00f3, a         ;cd95  45 f3

sub_cd97:
    mov a, mem_00f1         ;cd97  05 f1
    mov mem_00f5, a         ;cd99  45 f5
    clrb mem_00f5:7         ;cd9b  a7 f5
    and a, #0x80            ;cd9d  64 80
    mov mem_00f1, a         ;cd9f  45 f1
    ret                     ;cda1  20

lab_cda2:
    mov a, mem_00f4         ;cda2  05 f4
    beq lab_cdac            ;cda4  fd 06
    mov mem_00f3, a         ;cda6  45 f3
    mov mem_00f4, #0x00     ;cda8  85 f4 00
    ret                     ;cdab  20

lab_cdac:
    mov a, mem_00f1         ;cdac  05 f1
    and a, #0x7f            ;cdae  64 7f
    bne lab_cdb5            ;cdb0  fc 03
    mov mem_00f1, #0x00     ;cdb2  85 f1 00

lab_cdb5:
    ret                     ;cdb5  20

sub_cdb6:
    movw a, #0x0064         ;cdb6  e4 00 64
    movw mem_0360, a        ;cdb9  d4 03 60
    xchw a, t               ;cdbc  43
    bne lab_cdd1            ;cdbd  fc 12        BRANCH_ALWAYS_TAKEN

sub_cdbf:
    movw a, #0x0064         ;cdbf  e4 00 64
    movw mem_0360, a        ;cdc2  d4 03 60
    movw a, #0x0000         ;cdc5  e4 00 00
    movw mem_034a, a        ;cdc8  d4 03 4a
    movw mem_034c, a        ;cdcb  d4 03 4c
    movw a, #mem_d005       ;cdce  e4 d0 05

lab_cdd1:
    movw mem_035b, a        ;cdd1  d4 03 5b
    ret                     ;cdd4  20

    .byte 0x39              ;cdd5  39          DATA '9'
    .byte 0x28              ;cdd6  28          DATA '('
    .byte 0x30              ;cdd7  30          DATA '0'
    .byte 0x02              ;cdd8  02          DATA '\x02'
    .byte 0x40              ;cdd9  40          DATA '@'
    .byte 0xCD              ;cdda  cd          DATA '\xcd'
    .byte 0xE5              ;cddb  e5          DATA '\xe5'
    .byte 0x39              ;cddc  39          DATA '9'
    .byte 0x28              ;cddd  28          DATA '('
    .byte 0x40              ;cdde  40          DATA '@'
    .byte 0xD0              ;cddf  d0          DATA '\xd0'
    .byte 0x53              ;cde0  53          DATA 'S'
    .byte 0x39              ;cde1  39          DATA '9'
    .byte 0x09              ;cde2  09          DATA '\t'
    .byte 0x37              ;cde3  37          DATA '7'
    .byte 0x04              ;cde4  04          DATA '\x04'
    .byte 0x34              ;cde5  34          DATA '4'
    .byte 0x71              ;cde6  71          DATA 'q'
    .byte 0x01              ;cde7  01          DATA '\x01'
    .byte 0xD0              ;cde8  d0          DATA '\xd0'
    .byte 0x53              ;cde9  53          DATA 'S'
    .byte 0x77              ;cdea  77          DATA 'w'
    .byte 0x05              ;cdeb  05          DATA '\x05'
    .byte 0xD3              ;cdec  d3          DATA '\xd3'
    .byte 0x32              ;cded  32          DATA '2'
    .byte 0x40              ;cdee  40          DATA '@'
    .byte 0xD3              ;cdef  d3          DATA '\xd3'
    .byte 0x55              ;cdf0  55          DATA 'U'
    .byte 0x39              ;cdf1  39          DATA '9'
    .byte 0x05              ;cdf2  05          DATA '\x05'
    .byte 0x3D              ;cdf3  3d          DATA '='
    .byte 0x36              ;cdf4  36          DATA '6'
    .byte 0x20              ;cdf5  20          DATA ' '
    .byte 0xCE              ;cdf6  ce          DATA '\xce'
    .byte 0x3E              ;cdf7  3e          DATA '>'
    .byte 0x32              ;cdf8  32          DATA '2'
    .byte 0x04              ;cdf9  04          DATA '\x04'
    .byte 0xD2              ;cdfa  d2          DATA '\xd2'
    .byte 0x20              ;cdfb  20          DATA ' '
    .byte 0x32              ;cdfc  32          DATA '2'
    .byte 0x40              ;cdfd  40          DATA '@'
    .byte 0xCE              ;cdfe  ce          DATA '\xce'
    .byte 0x04              ;cdff  04          DATA '\x04'
    .byte 0x32              ;ce00  32          DATA '2'
    .byte 0x10              ;ce01  10          DATA '\x10'
    .byte 0xCE              ;ce02  ce          DATA '\xce'
    .byte 0x32              ;ce03  32          DATA '2'
    .byte 0x3F              ;ce04  3f          DATA '?'
    .byte 0x95              ;ce05  95          DATA '\x95'
    .byte 0x34              ;ce06  34          DATA '4'
    .byte 0x72              ;ce07  72          DATA 'r'
    .byte 0x12              ;ce08  12          DATA '\x12'
    .byte 0xD2              ;ce09  d2          DATA '\xd2'
    .byte 0x0D              ;ce0a  0d          DATA '\r'
    .byte 0x73              ;ce0b  73          DATA 's'
    .byte 0x13              ;ce0c  13          DATA '\x13'
    .byte 0xD2              ;ce0d  d2          DATA '\xd2'
    .byte 0x63              ;ce0e  63          DATA 'c'
    .byte 0x74              ;ce0f  74          DATA 't'
    .byte 0x02              ;ce10  02          DATA '\x02'
    .byte 0xD2              ;ce11  d2          DATA '\xd2'
    .byte 0x0D              ;ce12  0d          DATA '\r'
    .byte 0x75              ;ce13  75          DATA 'u'
    .byte 0x03              ;ce14  03          DATA '\x03'
    .byte 0xD2              ;ce15  d2          DATA '\xd2'
    .byte 0x63              ;ce16  63          DATA 'c'
    .byte 0x78              ;ce17  78          DATA 'x'
    .byte 0x01              ;ce18  01          DATA '\x01'
    .byte 0xD0              ;ce19  d0          DATA '\xd0'
    .byte 0xC4              ;ce1a  c4          DATA '\xc4'
    .byte 0x76              ;ce1b  76          DATA 'v'
    .byte 0x22              ;ce1c  22          DATA '"'
    .byte 0xD2              ;ce1d  d2          DATA '\xd2'
    .byte 0x0D              ;ce1e  0d          DATA '\r'
    .byte 0x79              ;ce1f  79          DATA 'y'
    .byte 0x01              ;ce20  01          DATA '\x01'
    .byte 0xCE              ;ce21  ce          DATA '\xce'
    .byte 0x2E              ;ce22  2e          DATA '.'
    .byte 0x77              ;ce23  77          DATA 'w'
    .byte 0x04              ;ce24  04          DATA '\x04'
    .byte 0xD2              ;ce25  d2          DATA '\xd2'
    .byte 0x20              ;ce26  20          DATA ' '
    .byte 0x7A              ;ce27  7a          DATA 'z'
    .byte 0x04              ;ce28  04          DATA '\x04'
    .byte 0xD2              ;ce29  d2          DATA '\xd2'
    .byte 0x20              ;ce2a  20          DATA ' '
    .byte 0x40              ;ce2b  40          DATA '@'
    .byte 0xD1              ;ce2c  d1          DATA '\xd1'
    .byte 0xD4              ;ce2d  d4          DATA '\xd4'
    .byte 0x14              ;ce2e  14          DATA '\x14'
    .byte 0x40              ;ce2f  40          DATA '@'
    .byte 0xCE              ;ce30  ce          DATA '\xce'
    .byte 0x2B              ;ce31  2b          DATA '+'
    .byte 0x32              ;ce32  32          DATA '2'
    .byte 0x02              ;ce33  02          DATA '\x02'
    .byte 0xCE              ;ce34  ce          DATA '\xce'
    .byte 0x39              ;ce35  39          DATA '9'
    .byte 0x40              ;ce36  40          DATA '@'
    .byte 0xCE              ;ce37  ce          DATA '\xce'
    .byte 0x06              ;ce38  06          DATA '\x06'
    .byte 0x37              ;ce39  37          DATA '7'
    .byte 0x32              ;ce3a  32          DATA '2'
    .byte 0x40              ;ce3b  40          DATA '@'
    .byte 0xD2              ;ce3c  d2          DATA '\xd2'
    .byte 0x0D              ;ce3d  0d          DATA '\r'
    .byte 0x37              ;ce3e  37          DATA '7'
    .byte 0x21              ;ce3f  21          DATA '!'
    .byte 0x32              ;ce40  32          DATA '2'
    .byte 0x04              ;ce41  04          DATA '\x04'
    .byte 0xD2              ;ce42  d2          DATA '\xd2'
    .byte 0x20              ;ce43  20          DATA ' '
    .byte 0x32              ;ce44  32          DATA '2'
    .byte 0x02              ;ce45  02          DATA '\x02'
    .byte 0xCE              ;ce46  ce          DATA '\xce'
    .byte 0x78              ;ce47  78          DATA 'x'
    .byte 0x34              ;ce48  34          DATA '4'
    .byte 0x72              ;ce49  72          DATA 'r'
    .byte 0x12              ;ce4a  12          DATA '\x12'
    .byte 0xD2              ;ce4b  d2          DATA '\xd2'
    .byte 0x0D              ;ce4c  0d          DATA '\r'
    .byte 0x73              ;ce4d  73          DATA 's'
    .byte 0x13              ;ce4e  13          DATA '\x13'
    .byte 0xD2              ;ce4f  d2          DATA '\xd2'
    .byte 0x63              ;ce50  63          DATA 'c'
    .byte 0x71              ;ce51  71          DATA 'q'
    .byte 0x01              ;ce52  01          DATA '\x01'
    .byte 0xCE              ;ce53  ce          DATA '\xce'
    .byte 0x7D              ;ce54  7d          DATA '}'
    .byte 0x74              ;ce55  74          DATA 't'
    .byte 0x02              ;ce56  02          DATA '\x02'
    .byte 0xD2              ;ce57  d2          DATA '\xd2'
    .byte 0x0D              ;ce58  0d          DATA '\r'
    .byte 0x75              ;ce59  75          DATA 'u'
    .byte 0x03              ;ce5a  03          DATA '\x03'
    .byte 0xD2              ;ce5b  d2          DATA '\xd2'
    .byte 0x63              ;ce5c  63          DATA 'c'
    .byte 0x78              ;ce5d  78          DATA 'x'
    .byte 0x01              ;ce5e  01          DATA '\x01'
    .byte 0xD0              ;ce5f  d0          DATA '\xd0'
    .byte 0xC4              ;ce60  c4          DATA '\xc4'
    .byte 0x76              ;ce61  76          DATA 'v'
    .byte 0x01              ;ce62  01          DATA '\x01'
    .byte 0xCE              ;ce63  ce          DATA '\xce'
    .byte 0x71              ;ce64  71          DATA 'q'
    .byte 0x79              ;ce65  79          DATA 'y'
    .byte 0x21              ;ce66  21          DATA '!'
    .byte 0xCE              ;ce67  ce          DATA '\xce'
    .byte 0x74              ;ce68  74          DATA 't'
    .byte 0x77              ;ce69  77          DATA 'w'
    .byte 0x04              ;ce6a  04          DATA '\x04'
    .byte 0xD2              ;ce6b  d2          DATA '\xd2'
    .byte 0x20              ;ce6c  20          DATA ' '
    .byte 0x7A              ;ce6d  7a          DATA 'z'
    .byte 0x04              ;ce6e  04          DATA '\x04'
    .byte 0xD2              ;ce6f  d2          DATA '\xd2'
    .byte 0x20              ;ce70  20          DATA ' '
    .byte 0x40              ;ce71  40          DATA '@'
    .byte 0xD1              ;ce72  d1          DATA '\xd1'
    .byte 0xD4              ;ce73  d4          DATA '\xd4'
    .byte 0x14              ;ce74  14          DATA '\x14'
    .byte 0x40              ;ce75  40          DATA '@'
    .byte 0xCE              ;ce76  ce          DATA '\xce'
    .byte 0x71              ;ce77  71          DATA 'q'
    .byte 0x37              ;ce78  37          DATA '7'
    .byte 0x22              ;ce79  22          DATA '"'
    .byte 0x40              ;ce7a  40          DATA '@'
    .byte 0xD2              ;ce7b  d2          DATA '\xd2'
    .byte 0x0D              ;ce7c  0d          DATA '\r'
    .byte 0x37              ;ce7d  37          DATA '7'
    .byte 0x01              ;ce7e  01          DATA '\x01'
    .byte 0x40              ;ce7f  40          DATA '@'
    .byte 0xD1              ;ce80  d1          DATA '\xd1'
    .byte 0xD4              ;ce81  d4          DATA '\xd4'
    .byte 0x39              ;ce82  39          DATA '9'
    .byte 0x24              ;ce83  24          DATA '$'
    .byte 0x36              ;ce84  36          DATA '6'
    .byte 0x30              ;ce85  30          DATA '0'
    .byte 0xCF              ;ce86  cf          DATA '\xcf'
    .byte 0x9B              ;ce87  9b          DATA '\x9b'
    .byte 0x36              ;ce88  36          DATA '6'
    .byte 0x20              ;ce89  20          DATA ' '
    .byte 0xCF              ;ce8a  cf          DATA '\xcf'
    .byte 0x67              ;ce8b  67          DATA 'g'
    .byte 0x36              ;ce8c  36          DATA '6'
    .byte 0x10              ;ce8d  10          DATA '\x10'
    .byte 0xCE              ;ce8e  ce          DATA '\xce'
    .byte 0xFC              ;ce8f  fc          DATA '\xfc'
    .byte 0x3D              ;ce90  3d          DATA '='
    .byte 0x3B              ;ce91  3b          DATA ';'
    .byte 0xCE              ;ce92  ce          DATA '\xce'
    .byte 0xC8              ;ce93  c8          DATA '\xc8'
    .byte 0x32              ;ce94  32          DATA '2'
    .byte 0x04              ;ce95  04          DATA '\x04'
    .byte 0xD2              ;ce96  d2          DATA '\xd2'
    .byte 0x34              ;ce97  34          DATA '4'
    .byte 0x34              ;ce98  34          DATA '4'
    .byte 0x72              ;ce99  72          DATA 'r'
    .byte 0x12              ;ce9a  12          DATA '\x12'
    .byte 0xCE              ;ce9b  ce          DATA '\xce'
    .byte 0xC1              ;ce9c  c1          DATA '\xc1'
    .byte 0x73              ;ce9d  73          DATA 's'
    .byte 0x13              ;ce9e  13          DATA '\x13'
    .byte 0xD3              ;ce9f  d3          DATA '\xd3'
    .byte 0x0C              ;cea0  0c          DATA '\x0c'
    .byte 0x71              ;cea1  71          DATA 'q'
    .byte 0x01              ;cea2  01          DATA '\x01'
    .byte 0xD2              ;cea3  d2          DATA '\xd2'
    .byte 0x48              ;cea4  48          DATA 'H'
    .byte 0x74              ;cea5  74          DATA 't'
    .byte 0x01              ;cea6  01          DATA '\x01'
    .byte 0xD2              ;cea7  d2          DATA '\xd2'
    .byte 0x48              ;cea8  48          DATA 'H'
    .byte 0x75              ;cea9  75          DATA 'u'
    .byte 0x03              ;ceaa  03          DATA '\x03'
    .byte 0xD3              ;ceab  d3          DATA '\xd3'
    .byte 0x0C              ;ceac  0c          DATA '\x0c'
    .byte 0x78              ;cead  78          DATA 'x'
    .byte 0x01              ;ceae  01          DATA '\x01'
    .byte 0xD2              ;ceaf  d2          DATA '\xd2'
    .byte 0x3D              ;ceb0  3d          DATA '='
    .byte 0x76              ;ceb1  76          DATA 'v'
    .byte 0x22              ;ceb2  22          DATA '"'
    .byte 0xCE              ;ceb3  ce          DATA '\xce'
    .byte 0xC1              ;ceb4  c1          DATA '\xc1'
    .byte 0x79              ;ceb5  79          DATA 'y'
    .byte 0x02              ;ceb6  02          DATA '\x02'
    .byte 0xCE              ;ceb7  ce          DATA '\xce'
    .byte 0xC4              ;ceb8  c4          DATA '\xc4'
    .byte 0x77              ;ceb9  77          DATA 'w'
    .byte 0x01              ;ceba  01          DATA '\x01'
    .byte 0xD2              ;cebb  d2          DATA '\xd2'
    .byte 0x48              ;cebc  48          DATA 'H'
    .byte 0x7A              ;cebd  7a          DATA 'z'
    .byte 0x04              ;cebe  04          DATA '\x04'
    .byte 0xD2              ;cebf  d2          DATA '\xd2'
    .byte 0x34              ;cec0  34          DATA '4'
    .byte 0x40              ;cec1  40          DATA '@'
    .byte 0xD3              ;cec2  d3          DATA '\xd3'
    .byte 0x6A              ;cec3  6a          DATA 'j'
    .byte 0x14              ;cec4  14          DATA '\x14'
    .byte 0x40              ;cec5  40          DATA '@'
    .byte 0xCE              ;cec6  ce          DATA '\xce'
    .byte 0xC1              ;cec7  c1          DATA '\xc1'
    .byte 0x32              ;cec8  32          DATA '2'
    .byte 0x04              ;cec9  04          DATA '\x04'
    .byte 0xD2              ;ceca  d2          DATA '\xd2'
    .byte 0xCD              ;cecb  cd          DATA '\xcd'
    .byte 0x34              ;cecc  34          DATA '4'
    .byte 0x72              ;cecd  72          DATA 'r'
    .byte 0x12              ;cece  12          DATA '\x12'
    .byte 0xD3              ;cecf  d3          DATA '\xd3'
    .byte 0x1E              ;ced0  1e          DATA '\x1e'
    .byte 0x73              ;ced1  73          DATA 's'
    .byte 0x13              ;ced2  13          DATA '\x13'
    .byte 0xCE              ;ced3  ce          DATA '\xce'
    .byte 0xF5              ;ced4  f5          DATA '\xf5'
    .byte 0x71              ;ced5  71          DATA 'q'
    .byte 0x01              ;ced6  01          DATA '\x01'
    .byte 0xD2              ;ced7  d2          DATA '\xd2'
    .byte 0xD6              ;ced8  d6          DATA '\xd6'
    .byte 0x74              ;ced9  74          DATA 't'
    .byte 0x02              ;ceda  02          DATA '\x02'
    .byte 0xD3              ;cedb  d3          DATA '\xd3'
    .byte 0x1E              ;cedc  1e          DATA '\x1e'
    .byte 0x75              ;cedd  75          DATA 'u'
    .byte 0x01              ;cede  01          DATA '\x01'
    .byte 0xD2              ;cedf  d2          DATA '\xd2'
    .byte 0xD6              ;cee0  d6          DATA '\xd6'
    .byte 0x78              ;cee1  78          DATA 'x'
    .byte 0x01              ;cee2  01          DATA '\x01'
    .byte 0xD2              ;cee3  d2          DATA '\xd2'
    .byte 0xE0              ;cee4  e0          DATA '\xe0'
    .byte 0x76              ;cee5  76          DATA 'v'
    .byte 0x22              ;cee6  22          DATA '"'
    .byte 0xD3              ;cee7  d3          DATA '\xd3'
    .byte 0x1E              ;cee8  1e          DATA '\x1e'
    .byte 0x79              ;cee9  79          DATA 'y'
    .byte 0x03              ;ceea  03          DATA '\x03'
    .byte 0xCE              ;ceeb  ce          DATA '\xce'
    .byte 0xF8              ;ceec  f8          DATA '\xf8'
    .byte 0x77              ;ceed  77          DATA 'w'
    .byte 0x01              ;ceee  01          DATA '\x01'
    .byte 0xD2              ;ceef  d2          DATA '\xd2'
    .byte 0xD6              ;cef0  d6          DATA '\xd6'
    .byte 0x7A              ;cef1  7a          DATA 'z'
    .byte 0x04              ;cef2  04          DATA '\x04'
    .byte 0xD2              ;cef3  d2          DATA '\xd2'
    .byte 0xCD              ;cef4  cd          DATA '\xcd'
    .byte 0x40              ;cef5  40          DATA '@'
    .byte 0xD3              ;cef6  d3          DATA '\xd3'
    .byte 0xD9              ;cef7  d9          DATA '\xd9'
    .byte 0x14              ;cef8  14          DATA '\x14'
    .byte 0x40              ;cef9  40          DATA '@'
    .byte 0xCE              ;cefa  ce          DATA '\xce'
    .byte 0xF5              ;cefb  f5          DATA '\xf5'
    .byte 0x3B              ;cefc  3b          DATA ';'
    .byte 0xCF              ;cefd  cf          DATA '\xcf'
    .byte 0x33              ;cefe  33          DATA '3'
    .byte 0x32              ;ceff  32          DATA '2'
    .byte 0x04              ;cf00  04          DATA '\x04'
    .byte 0xD2              ;cf01  d2          DATA '\xd2'
    .byte 0x34              ;cf02  34          DATA '4'
    .byte 0x34              ;cf03  34          DATA '4'
    .byte 0x72              ;cf04  72          DATA 'r'
    .byte 0x01              ;cf05  01          DATA '\x01'
    .byte 0xD2              ;cf06  d2          DATA '\xd2'
    .byte 0x48              ;cf07  48          DATA 'H'
    .byte 0x73              ;cf08  73          DATA 's'
    .byte 0x01              ;cf09  01          DATA '\x01'
    .byte 0xD2              ;cf0a  d2          DATA '\xd2'
    .byte 0x48              ;cf0b  48          DATA 'H'
    .byte 0x71              ;cf0c  71          DATA 'q'
    .byte 0x01              ;cf0d  01          DATA '\x01'
    .byte 0xD2              ;cf0e  d2          DATA '\xd2'
    .byte 0x48              ;cf0f  48          DATA 'H'
    .byte 0x74              ;cf10  74          DATA 't'
    .byte 0x02              ;cf11  02          DATA '\x02'
    .byte 0xCF              ;cf12  cf          DATA '\xcf'
    .byte 0x2C              ;cf13  2c          DATA ','
    .byte 0x75              ;cf14  75          DATA 'u'
    .byte 0x03              ;cf15  03          DATA '\x03'
    .byte 0xD3              ;cf16  d3          DATA '\xd3'
    .byte 0x0C              ;cf17  0c          DATA '\x0c'
    .byte 0x78              ;cf18  78          DATA 'x'
    .byte 0x01              ;cf19  01          DATA '\x01'
    .byte 0xD2              ;cf1a  d2          DATA '\xd2'
    .byte 0x3D              ;cf1b  3d          DATA '='
    .byte 0x76              ;cf1c  76          DATA 'v'
    .byte 0x22              ;cf1d  22          DATA '"'
    .byte 0xCF              ;cf1e  cf          DATA '\xcf'
    .byte 0x2C              ;cf1f  2c          DATA ','
    .byte 0x79              ;cf20  79          DATA 'y'
    .byte 0x12              ;cf21  12          DATA '\x12'
    .byte 0xCF              ;cf22  cf          DATA '\xcf'
    .byte 0x2F              ;cf23  2f          DATA '/'
    .byte 0x77              ;cf24  77          DATA 'w'
    .byte 0x01              ;cf25  01          DATA '\x01'
    .byte 0xD2              ;cf26  d2          DATA '\xd2'
    .byte 0x48              ;cf27  48          DATA 'H'
    .byte 0x7A              ;cf28  7a          DATA 'z'
    .byte 0x04              ;cf29  04          DATA '\x04'
    .byte 0xD2              ;cf2a  d2          DATA '\xd2'
    .byte 0x34              ;cf2b  34          DATA '4'
    .byte 0x40              ;cf2c  40          DATA '@'
    .byte 0xD3              ;cf2d  d3          DATA '\xd3'
    .byte 0x6A              ;cf2e  6a          DATA 'j'
    .byte 0x14              ;cf2f  14          DATA '\x14'
    .byte 0x40              ;cf30  40          DATA '@'
    .byte 0xCF              ;cf31  cf          DATA '\xcf'
    .byte 0x2C              ;cf32  2c          DATA ','
    .byte 0x32              ;cf33  32          DATA '2'
    .byte 0x04              ;cf34  04          DATA '\x04'
    .byte 0xD2              ;cf35  d2          DATA '\xd2'
    .byte 0xCD              ;cf36  cd          DATA '\xcd'
    .byte 0x34              ;cf37  34          DATA '4'
    .byte 0x72              ;cf38  72          DATA 'r'
    .byte 0x01              ;cf39  01          DATA '\x01'
    .byte 0xD2              ;cf3a  d2          DATA '\xd2'
    .byte 0xD6              ;cf3b  d6          DATA '\xd6'
    .byte 0x73              ;cf3c  73          DATA 's'
    .byte 0x01              ;cf3d  01          DATA '\x01'
    .byte 0xD2              ;cf3e  d2          DATA '\xd2'
    .byte 0xD6              ;cf3f  d6          DATA '\xd6'
    .byte 0x71              ;cf40  71          DATA 'q'
    .byte 0x01              ;cf41  01          DATA '\x01'
    .byte 0xD2              ;cf42  d2          DATA '\xd2'
    .byte 0xD6              ;cf43  d6          DATA '\xd6'
    .byte 0x74              ;cf44  74          DATA 't'
    .byte 0x02              ;cf45  02          DATA '\x02'
    .byte 0xD3              ;cf46  d3          DATA '\xd3'
    .byte 0x1E              ;cf47  1e          DATA '\x1e'
    .byte 0x75              ;cf48  75          DATA 'u'
    .byte 0x03              ;cf49  03          DATA '\x03'
    .byte 0xCF              ;cf4a  cf          DATA '\xcf'
    .byte 0x60              ;cf4b  60          DATA '`'
    .byte 0x78              ;cf4c  78          DATA 'x'
    .byte 0x01              ;cf4d  01          DATA '\x01'
    .byte 0xD2              ;cf4e  d2          DATA '\xd2'
    .byte 0xE0              ;cf4f  e0          DATA '\xe0'
    .byte 0x76              ;cf50  76          DATA 'v'
    .byte 0x22              ;cf51  22          DATA '"'
    .byte 0xD3              ;cf52  d3          DATA '\xd3'
    .byte 0x1E              ;cf53  1e          DATA '\x1e'
    .byte 0x79              ;cf54  79          DATA 'y'
    .byte 0x13              ;cf55  13          DATA '\x13'
    .byte 0xCF              ;cf56  cf          DATA '\xcf'
    .byte 0x63              ;cf57  63          DATA 'c'
    .byte 0x77              ;cf58  77          DATA 'w'
    .byte 0x01              ;cf59  01          DATA '\x01'
    .byte 0xD2              ;cf5a  d2          DATA '\xd2'
    .byte 0xD6              ;cf5b  d6          DATA '\xd6'
    .byte 0x7A              ;cf5c  7a          DATA 'z'
    .byte 0x04              ;cf5d  04          DATA '\x04'
    .byte 0xD2              ;cf5e  d2          DATA '\xd2'
    .byte 0xCD              ;cf5f  cd          DATA '\xcd'
    .byte 0x40              ;cf60  40          DATA '@'
    .byte 0xD3              ;cf61  d3          DATA '\xd3'
    .byte 0xD9              ;cf62  d9          DATA '\xd9'
    .byte 0x14              ;cf63  14          DATA '\x14'
    .byte 0x40              ;cf64  40          DATA '@'
    .byte 0xCF              ;cf65  cf          DATA '\xcf'
    .byte 0x60              ;cf66  60          DATA '`'
    .byte 0x32              ;cf67  32          DATA '2'
    .byte 0x04              ;cf68  04          DATA '\x04'
    .byte 0xD2              ;cf69  d2          DATA '\xd2'
    .byte 0x34              ;cf6a  34          DATA '4'
    .byte 0x34              ;cf6b  34          DATA '4'
    .byte 0x72              ;cf6c  72          DATA 'r'
    .byte 0x12              ;cf6d  12          DATA '\x12'
    .byte 0xCF              ;cf6e  cf          DATA '\xcf'
    .byte 0x94              ;cf6f  94          DATA '\x94'
    .byte 0x73              ;cf70  73          DATA 's'
    .byte 0x13              ;cf71  13          DATA '\x13'
    .byte 0xD3              ;cf72  d3          DATA '\xd3'
    .byte 0x0C              ;cf73  0c          DATA '\x0c'
    .byte 0x71              ;cf74  71          DATA 'q'
    .byte 0x01              ;cf75  01          DATA '\x01'
    .byte 0xD2              ;cf76  d2          DATA '\xd2'
    .byte 0x48              ;cf77  48          DATA 'H'
    .byte 0x74              ;cf78  74          DATA 't'
    .byte 0x02              ;cf79  02          DATA '\x02'
    .byte 0xCF              ;cf7a  cf          DATA '\xcf'
    .byte 0x2C              ;cf7b  2c          DATA ','
    .byte 0x75              ;cf7c  75          DATA 'u'
    .byte 0x03              ;cf7d  03          DATA '\x03'
    .byte 0xD3              ;cf7e  d3          DATA '\xd3'
    .byte 0x0C              ;cf7f  0c          DATA '\x0c'
    .byte 0x78              ;cf80  78          DATA 'x'
    .byte 0x01              ;cf81  01          DATA '\x01'
    .byte 0xD2              ;cf82  d2          DATA '\xd2'
    .byte 0x3D              ;cf83  3d          DATA '='
    .byte 0x76              ;cf84  76          DATA 'v'
    .byte 0x01              ;cf85  01          DATA '\x01'
    .byte 0xD2              ;cf86  d2          DATA '\xd2'
    .byte 0x48              ;cf87  48          DATA 'H'
    .byte 0x79              ;cf88  79          DATA 'y'
    .byte 0x22              ;cf89  22          DATA '"'
    .byte 0xCF              ;cf8a  cf          DATA '\xcf'
    .byte 0x97              ;cf8b  97          DATA '\x97'
    .byte 0x77              ;cf8c  77          DATA 'w'
    .byte 0x01              ;cf8d  01          DATA '\x01'
    .byte 0xD2              ;cf8e  d2          DATA '\xd2'
    .byte 0x48              ;cf8f  48          DATA 'H'
    .byte 0x7A              ;cf90  7a          DATA 'z'
    .byte 0x04              ;cf91  04          DATA '\x04'
    .byte 0xD2              ;cf92  d2          DATA '\xd2'
    .byte 0x34              ;cf93  34          DATA '4'
    .byte 0x40              ;cf94  40          DATA '@'
    .byte 0xD3              ;cf95  d3          DATA '\xd3'
    .byte 0x6A              ;cf96  6a          DATA 'j'
    .byte 0x14              ;cf97  14          DATA '\x14'
    .byte 0x40              ;cf98  40          DATA '@'
    .byte 0xCF              ;cf99  cf          DATA '\xcf'
    .byte 0x94              ;cf9a  94          DATA '\x94'
    .byte 0x32              ;cf9b  32          DATA '2'
    .byte 0x01              ;cf9c  01          DATA '\x01'
    .byte 0xCF              ;cf9d  cf          DATA '\xcf'
    .byte 0xD3              ;cf9e  d3          DATA '\xd3'
    .byte 0x32              ;cf9f  32          DATA '2'
    .byte 0x04              ;cfa0  04          DATA '\x04'
    .byte 0xD2              ;cfa1  d2          DATA '\xd2'
    .byte 0x34              ;cfa2  34          DATA '4'
    .byte 0x34              ;cfa3  34          DATA '4'
    .byte 0x72              ;cfa4  72          DATA 'r'
    .byte 0x12              ;cfa5  12          DATA '\x12'
    .byte 0xCF              ;cfa6  cf          DATA '\xcf'
    .byte 0xCC              ;cfa7  cc          DATA '\xcc'
    .byte 0x73              ;cfa8  73          DATA 's'
    .byte 0x13              ;cfa9  13          DATA '\x13'
    .byte 0xD3              ;cfaa  d3          DATA '\xd3'
    .byte 0x0C              ;cfab  0c          DATA '\x0c'
    .byte 0x71              ;cfac  71          DATA 'q'
    .byte 0x01              ;cfad  01          DATA '\x01'
    .byte 0xD2              ;cfae  d2          DATA '\xd2'
    .byte 0x48              ;cfaf  48          DATA 'H'
    .byte 0x74              ;cfb0  74          DATA 't'
    .byte 0x02              ;cfb1  02          DATA '\x02'
    .byte 0xCF              ;cfb2  cf          DATA '\xcf'
    .byte 0xCC              ;cfb3  cc          DATA '\xcc'
    .byte 0x75              ;cfb4  75          DATA 'u'
    .byte 0x03              ;cfb5  03          DATA '\x03'
    .byte 0xD3              ;cfb6  d3          DATA '\xd3'
    .byte 0x0C              ;cfb7  0c          DATA '\x0c'
    .byte 0x78              ;cfb8  78          DATA 'x'
    .byte 0x01              ;cfb9  01          DATA '\x01'
    .byte 0xD2              ;cfba  d2          DATA '\xd2'
    .byte 0x3D              ;cfbb  3d          DATA '='
    .byte 0x76              ;cfbc  76          DATA 'v'
    .byte 0x22              ;cfbd  22          DATA '"'
    .byte 0xCF              ;cfbe  cf          DATA '\xcf'
    .byte 0xCC              ;cfbf  cc          DATA '\xcc'
    .byte 0x79              ;cfc0  79          DATA 'y'
    .byte 0x32              ;cfc1  32          DATA '2'
    .byte 0xCF              ;cfc2  cf          DATA '\xcf'
    .byte 0xCF              ;cfc3  cf          DATA '\xcf'
    .byte 0x77              ;cfc4  77          DATA 'w'
    .byte 0x01              ;cfc5  01          DATA '\x01'
    .byte 0xD2              ;cfc6  d2          DATA '\xd2'
    .byte 0x48              ;cfc7  48          DATA 'H'
    .byte 0x7A              ;cfc8  7a          DATA 'z'
    .byte 0x04              ;cfc9  04          DATA '\x04'
    .byte 0xD2              ;cfca  d2          DATA '\xd2'
    .byte 0x34              ;cfcb  34          DATA '4'
    .byte 0x40              ;cfcc  40          DATA '@'
    .byte 0xD3              ;cfcd  d3          DATA '\xd3'
    .byte 0x6A              ;cfce  6a          DATA 'j'
    .byte 0x14              ;cfcf  14          DATA '\x14'
    .byte 0x40              ;cfd0  40          DATA '@'
    .byte 0xCF              ;cfd1  cf          DATA '\xcf'
    .byte 0xCC              ;cfd2  cc          DATA '\xcc'
    .byte 0x3E              ;cfd3  3e          DATA '>'
    .byte 0xD3              ;cfd4  d3          DATA '\xd3'
    .byte 0x30              ;cfd5  30          DATA '0'
    .byte 0x40              ;cfd6  40          DATA '@'
    .byte 0xD0              ;cfd7  d0          DATA '\xd0'
    .byte 0x51              ;cfd8  51          DATA 'Q'
    .byte 0x39              ;cfd9  39          DATA '9'
    .byte 0x03              ;cfda  03          DATA '\x03'
    .byte 0x37              ;cfdb  37          DATA '7'
    .byte 0x05              ;cfdc  05          DATA '\x05'
    .byte 0x34              ;cfdd  34          DATA '4'
    .byte 0x40              ;cfde  40          DATA '@'
    .byte 0xD0              ;cfdf  d0          DATA '\xd0'
    .byte 0x3A              ;cfe0  3a          DATA ':'

mem_cfe1:
    .byte 0x39              ;cfe1  39          DATA '9'
    .byte 0x0F              ;cfe2  0f          DATA '\x0f'
    .byte 0x20              ;cfe3  20          DATA ' '
    .byte 0x0F              ;cfe4  0f          DATA '\x0f'
    .byte 0x10              ;cfe5  10          DATA '\x10'
    .byte 0x85              ;cfe6  85          DATA '\x85'
    .byte 0x16              ;cfe7  16          DATA '\x16'
    .byte 0xD0              ;cfe8  d0          DATA '\xd0'
    .byte 0x35              ;cfe9  35          DATA '5'
    .byte 0x90              ;cfea  90          DATA '\x90'
    .byte 0x20              ;cfeb  20          DATA ' '
    .byte 0x59              ;cfec  59          DATA 'Y'
    .byte 0x81              ;cfed  81          DATA '\x81'
    .byte 0x20              ;cfee  20          DATA ' '
    .byte 0xDB              ;cfef  db          DATA '\xdb'
    .byte 0x40              ;cff0  40          DATA '@'
    .byte 0xD0              ;cff1  d0          DATA '\xd0'
    .byte 0x14              ;cff2  14          DATA '\x14'

mem_cff3:
    .byte 0x39              ;cff3  39          DATA '9'
    .byte 0x0F              ;cff4  0f          DATA '\x0f'
    .byte 0x20              ;cff5  20          DATA ' '
    .byte 0x0F              ;cff6  0f          DATA '\x0f'
    .byte 0x10              ;cff7  10          DATA '\x10'
    .byte 0x85              ;cff8  85          DATA '\x85'
    .byte 0x16              ;cff9  16          DATA '\x16'
    .byte 0xD0              ;cffa  d0          DATA '\xd0'
    .byte 0x35              ;cffb  35          DATA '5'
    .byte 0x90              ;cffc  90          DATA '\x90'
    .byte 0x20              ;cffd  20          DATA ' '
    .byte 0x59              ;cffe  59          DATA 'Y'
    .byte 0x81              ;cfff  81          DATA '\x81'
    .byte 0x20              ;d000  20          DATA ' '
    .byte 0xDB              ;d001  db          DATA '\xdb'
    .byte 0x40              ;d002  40          DATA '@'
    .byte 0xD0              ;d003  d0          DATA '\xd0'
    .byte 0x11              ;d004  11          DATA '\x11'

mem_d005:
    .byte 0x39              ;d005  39          DATA '9'
    .byte 0x0F              ;d006  0f          DATA '\x0f'
    .byte 0x20              ;d007  20          DATA ' '
    .byte 0x0F              ;d008  0f          DATA '\x0f'
    .byte 0x10              ;d009  10          DATA '\x10'
    .byte 0x85              ;d00a  85          DATA '\x85'
    .byte 0x90              ;d00b  90          DATA '\x90'
    .byte 0x20              ;d00c  20          DATA ' '
    .byte 0x59              ;d00d  59          DATA 'Y'
    .byte 0x81              ;d00e  81          DATA '\x81'
    .byte 0x20              ;d00f  20          DATA ' '
    .byte 0xDB              ;d010  db          DATA '\xdb'
    .byte 0x15              ;d011  15          DATA '\x15'
    .byte 0xD0              ;d012  d0          DATA '\xd0'
    .byte 0x27              ;d013  27          DATA "'"
    .byte 0x84              ;d014  84          DATA '\x84'
    .byte 0x91              ;d015  91          DATA '\x91'
    .byte 0x16              ;d016  16          DATA '\x16'
    .byte 0xD0              ;d017  d0          DATA '\xd0'
    .byte 0x2E              ;d018  2e          DATA '.'
    .byte 0x20              ;d019  20          DATA ' '
    .byte 0x0F              ;d01a  0f          DATA '\x0f'
    .byte 0x85              ;d01b  85          DATA '\x85'
    .byte 0x20              ;d01c  20          DATA ' '
    .byte 0x00              ;d01d  00          DATA '\x00'
    .byte 0x40              ;d01e  40          DATA '@'
    .byte 0xCD              ;d01f  cd          DATA '\xcd'
    .byte 0xE1              ;d020  e1          DATA '\xe1'
    .byte 0x50              ;d021  50          DATA 'P'
    .byte 0xD3              ;d022  d3          DATA '\xd3'
    .byte 0x4C              ;d023  4c          DATA 'L'
    .byte 0x40              ;d024  40          DATA '@'
    .byte 0xCF              ;d025  cf          DATA '\xcf'
    .byte 0xD9              ;d026  d9          DATA '\xd9'
    .byte 0x32              ;d027  32          DATA '2'
    .byte 0x02              ;d028  02          DATA '\x02'
    .byte 0xD0              ;d029  d0          DATA '\xd0'
    .byte 0x21              ;d02a  21          DATA '!'
    .byte 0x40              ;d02b  40          DATA '@'
    .byte 0xD0              ;d02c  d0          DATA '\xd0'
    .byte 0x11              ;d02d  11          DATA '\x11'
    .byte 0x32              ;d02e  32          DATA '2'
    .byte 0x02              ;d02f  02          DATA '\x02'
    .byte 0xD0              ;d030  d0          DATA '\xd0'
    .byte 0x19              ;d031  19          DATA '\x19'
    .byte 0x40              ;d032  40          DATA '@'
    .byte 0xD0              ;d033  d0          DATA '\xd0'
    .byte 0x16              ;d034  16          DATA '\x16'
    .byte 0x20              ;d035  20          DATA ' '
    .byte 0x00              ;d036  00          DATA '\x00'
    .byte 0x40              ;d037  40          DATA '@'
    .byte 0xCD              ;d038  cd          DATA '\xcd'
    .byte 0xE1              ;d039  e1          DATA '\xe1'
    .byte 0x39              ;d03a  39          DATA '9'
    .byte 0x01              ;d03b  01          DATA '\x01'
    .byte 0x15              ;d03c  15          DATA '\x15'
    .byte 0xCF              ;d03d  cf          DATA '\xcf'
    .byte 0xD9              ;d03e  d9          DATA '\xd9'
    .byte 0x84              ;d03f  84          DATA '\x84'
    .byte 0x15              ;d040  15          DATA '\x15'
    .byte 0xCF              ;d041  cf          DATA '\xcf'
    .byte 0xD9              ;d042  d9          DATA '\xd9'
    .byte 0x39              ;d043  39          DATA '9'
    .byte 0x02              ;d044  02          DATA '\x02'
    .byte 0x20              ;d045  20          DATA ' '
    .byte 0x17              ;d046  17          DATA '\x17'
    .byte 0x83              ;d047  83          DATA '\x83'
    .byte 0x20              ;d048  20          DATA ' '
    .byte 0x35              ;d049  35          DATA '5'
    .byte 0x8C              ;d04a  8c          DATA '\x8c'
    .byte 0x3F              ;d04b  3f          DATA '?'
    .byte 0x1A              ;d04c  1a          DATA '\x1a'
    .byte 0x10              ;d04d  10          DATA '\x10'
    .byte 0x40              ;d04e  40          DATA '@'
    .byte 0xD0              ;d04f  d0          DATA '\xd0'
    .byte 0x51              ;d050  51          DATA 'Q'
    .byte 0x37              ;d051  37          DATA '7'
    .byte 0x01              ;d052  01          DATA '\x01'
    .byte 0x39              ;d053  39          DATA '9'
    .byte 0x02              ;d054  02          DATA '\x02'
    .byte 0x20              ;d055  20          DATA ' '
    .byte 0x15              ;d056  15          DATA '\x15'
    .byte 0x85              ;d057  85          DATA '\x85'
    .byte 0x92              ;d058  92          DATA '\x92'
    .byte 0x16              ;d059  16          DATA '\x16'
    .byte 0xD0              ;d05a  d0          DATA '\xd0'
    .byte 0x63              ;d05b  63          DATA 'c'
    .byte 0x88              ;d05c  88          DATA '\x88'
    .byte 0x20              ;d05d  20          DATA ' '
    .byte 0x55              ;d05e  55          DATA 'U'
    .byte 0x83              ;d05f  83          DATA '\x83'
    .byte 0x40              ;d060  40          DATA '@'
    .byte 0xD0              ;d061  d0          DATA '\xd0'
    .byte 0x6A              ;d062  6a          DATA 'j'
    .byte 0x32              ;d063  32          DATA '2'
    .byte 0x02              ;d064  02          DATA '\x02'
    .byte 0xD0              ;d065  d0          DATA '\xd0'
    .byte 0xF7              ;d066  f7          DATA '\xf7'
    .byte 0x40              ;d067  40          DATA '@'
    .byte 0xD0              ;d068  d0          DATA '\xd0'
    .byte 0x59              ;d069  59          DATA 'Y'
    .byte 0x20              ;d06a  20          DATA ' '
    .byte 0x59              ;d06b  59          DATA 'Y'
    .byte 0x83              ;d06c  83          DATA '\x83'
    .byte 0x20              ;d06d  20          DATA ' '
    .byte 0xDB              ;d06e  db          DATA '\xdb'
    .byte 0x91              ;d06f  91          DATA '\x91'
    .byte 0x15              ;d070  15          DATA '\x15'
    .byte 0xD0              ;d071  d0          DATA '\xd0'
    .byte 0x8B              ;d072  8b          DATA '\x8b'
    .byte 0x84              ;d073  84          DATA '\x84'
    .byte 0x40              ;d074  40          DATA '@'
    .byte 0xD0              ;d075  d0          DATA '\xd0'
    .byte 0x77              ;d076  77          DATA 'w'
    .byte 0x90              ;d077  90          DATA '\x90'
    .byte 0x16              ;d078  16          DATA '\x16'
    .byte 0xD0              ;d079  d0          DATA '\xd0'
    .byte 0x92              ;d07a  92          DATA '\x92'
    .byte 0x20              ;d07b  20          DATA ' '
    .byte 0x43              ;d07c  43          DATA 'C'
    .byte 0x8C              ;d07d  8c          DATA '\x8c'
    .byte 0x3A              ;d07e  3a          DATA ':'
    .byte 0x19              ;d07f  19          DATA '\x19'
    .byte 0x8C              ;d080  8c          DATA '\x8c'
    .byte 0x94              ;d081  94          DATA '\x94'
    .byte 0x35              ;d082  35          DATA '5'
    .byte 0xD1              ;d083  d1          DATA '\xd1'
    .byte 0xC9              ;d084  c9          DATA '\xc9'
    .byte 0x18              ;d085  18          DATA '\x18'
    .byte 0xD0              ;d086  d0          DATA '\xd0'
    .byte 0x99              ;d087  99          DATA '\x99'
    .byte 0x40              ;d088  40          DATA '@'
    .byte 0xD0              ;d089  d0          DATA '\xd0'
    .byte 0xC8              ;d08a  c8          DATA '\xc8'
    .byte 0x32              ;d08b  32          DATA '2'
    .byte 0x02              ;d08c  02          DATA '\x02'
    .byte 0xD0              ;d08d  d0          DATA '\xd0'
    .byte 0xF7              ;d08e  f7          DATA '\xf7'
    .byte 0x40              ;d08f  40          DATA '@'
    .byte 0xD0              ;d090  d0          DATA '\xd0'
    .byte 0x70              ;d091  70          DATA 'p'
    .byte 0x32              ;d092  32          DATA '2'
    .byte 0x02              ;d093  02          DATA '\x02'
    .byte 0xD0              ;d094  d0          DATA '\xd0'
    .byte 0xF7              ;d095  f7          DATA '\xf7'
    .byte 0x40              ;d096  40          DATA '@'
    .byte 0xD0              ;d097  d0          DATA '\xd0'
    .byte 0x78              ;d098  78          DATA 'x'
    .byte 0x39              ;d099  39          DATA '9'
    .byte 0x04              ;d09a  04          DATA '\x04'
    .byte 0x20              ;d09b  20          DATA ' '
    .byte 0xFB              ;d09c  fb          DATA '\xfb'
    .byte 0x83              ;d09d  83          DATA '\x83'
    .byte 0x20              ;d09e  20          DATA ' '
    .byte 0x4A              ;d09f  4a          DATA 'J'
    .byte 0x8A              ;d0a0  8a          DATA '\x8a'
    .byte 0x40              ;d0a1  40          DATA '@'
    .byte 0xD0              ;d0a2  d0          DATA '\xd0'
    .byte 0xA4              ;d0a3  a4          DATA '\xa4'
    .byte 0x93              ;d0a4  93          DATA '\x93'
    .byte 0x17              ;d0a5  17          DATA '\x17'
    .byte 0x03              ;d0a6  03          DATA '\x03'
    .byte 0x89              ;d0a7  89          DATA '\x89'
    .byte 0x32              ;d0a8  32          DATA '2'
    .byte 0x02              ;d0a9  02          DATA '\x02'
    .byte 0xD0              ;d0aa  d0          DATA '\xd0'
    .byte 0xB8              ;d0ab  b8          DATA '\xb8'
    .byte 0x32              ;d0ac  32          DATA '2'
    .byte 0x01              ;d0ad  01          DATA '\x01'
    .byte 0xD0              ;d0ae  d0          DATA '\xd0'
    .byte 0xB3              ;d0af  b3          DATA '\xb3'
    .byte 0x40              ;d0b0  40          DATA '@'
    .byte 0xD0              ;d0b1  d0          DATA '\xd0'
    .byte 0xA8              ;d0b2  a8          DATA '\xa8'
    .byte 0x20              ;d0b3  20          DATA ' '
    .byte 0xFB              ;d0b4  fb          DATA '\xfb'
    .byte 0x80              ;d0b5  80          DATA '\x80'
    .byte 0x20              ;d0b6  20          DATA ' '
    .byte 0x6A              ;d0b7  6a          DATA 'j'
    .byte 0x12              ;d0b8  12          DATA '\x12'
    .byte 0x8C              ;d0b9  8c          DATA '\x8c'
    .byte 0x11              ;d0ba  11          DATA '\x11'
    .byte 0x94              ;d0bb  94          DATA '\x94'
    .byte 0x36              ;d0bc  36          DATA '6'
    .byte 0x20              ;d0bd  20          DATA ' '
    .byte 0xD0              ;d0be  d0          DATA '\xd0'
    .byte 0xC1              ;d0bf  c1          DATA '\xc1'
    .byte 0x95              ;d0c0  95          DATA '\x95'
    .byte 0x40              ;d0c1  40          DATA '@'
    .byte 0xCD              ;d0c2  cd          DATA '\xcd'
    .byte 0xF1              ;d0c3  f1          DATA '\xf1'
    .byte 0x19              ;d0c4  19          DATA '\x19'
    .byte 0xD2              ;d0c5  d2          DATA '\xd2'
    .byte 0x79              ;d0c6  79          DATA 'y'
    .byte 0x13              ;d0c7  13          DATA '\x13'
    .byte 0x39              ;d0c8  39          DATA '9'
    .byte 0x06              ;d0c9  06          DATA '\x06'
    .byte 0x10              ;d0ca  10          DATA '\x10'
    .byte 0x20              ;d0cb  20          DATA ' '
    .byte 0x75              ;d0cc  75          DATA 'u'
    .byte 0x81              ;d0cd  81          DATA '\x81'
    .byte 0x20              ;d0ce  20          DATA ' '
    .byte 0xE7              ;d0cf  e7          DATA '\xe7'
    .byte 0x89              ;d0d0  89          DATA '\x89'
    .byte 0x20              ;d0d1  20          DATA ' '
    .byte 0x46              ;d0d2  46          DATA 'F'
    .byte 0x8A              ;d0d3  8a          DATA '\x8a'
    .byte 0x40              ;d0d4  40          DATA '@'
    .byte 0xD0              ;d0d5  d0          DATA '\xd0'
    .byte 0xD7              ;d0d6  d7          DATA '\xd7'
    .byte 0x93              ;d0d7  93          DATA '\x93'
    .byte 0x17              ;d0d8  17          DATA '\x17'
    .byte 0x03              ;d0d9  03          DATA '\x03'
    .byte 0x89              ;d0da  89          DATA '\x89'
    .byte 0x32              ;d0db  32          DATA '2'
    .byte 0x02              ;d0dc  02          DATA '\x02'
    .byte 0xD0              ;d0dd  d0          DATA '\xd0'
    .byte 0xEB              ;d0de  eb          DATA '\xeb'
    .byte 0x32              ;d0df  32          DATA '2'
    .byte 0x01              ;d0e0  01          DATA '\x01'
    .byte 0xD0              ;d0e1  d0          DATA '\xd0'
    .byte 0xE6              ;d0e2  e6          DATA '\xe6'
    .byte 0x40              ;d0e3  40          DATA '@'
    .byte 0xD0              ;d0e4  d0          DATA '\xd0'
    .byte 0xDB              ;d0e5  db          DATA '\xdb'
    .byte 0x20              ;d0e6  20          DATA ' '
    .byte 0xF7              ;d0e7  f7          DATA '\xf7'
    .byte 0x80              ;d0e8  80          DATA '\x80'
    .byte 0x20              ;d0e9  20          DATA ' '
    .byte 0x66              ;d0ea  66          DATA 'f'
    .byte 0x12              ;d0eb  12          DATA '\x12'
    .byte 0x8C              ;d0ec  8c          DATA '\x8c'
    .byte 0x11              ;d0ed  11          DATA '\x11'
    .byte 0x94              ;d0ee  94          DATA '\x94'
    .byte 0x36              ;d0ef  36          DATA '6'
    .byte 0x20              ;d0f0  20          DATA ' '
    .byte 0xD0              ;d0f1  d0          DATA '\xd0'
    .byte 0xF4              ;d0f2  f4          DATA '\xf4'
    .byte 0x95              ;d0f3  95          DATA '\x95'
    .byte 0x40              ;d0f4  40          DATA '@'
    .byte 0xCD              ;d0f5  cd          DATA '\xcd'
    .byte 0xF1              ;d0f6  f1          DATA '\xf1'
    .byte 0x39              ;d0f7  39          DATA '9'
    .byte 0x10              ;d0f8  10          DATA '\x10'
    .byte 0x20              ;d0f9  20          DATA ' '
    .byte 0x1B              ;d0fa  1b          DATA '\x1b'
    .byte 0x84              ;d0fb  84          DATA '\x84'
    .byte 0x20              ;d0fc  20          DATA ' '
    .byte 0x19              ;d0fd  19          DATA '\x19'
    .byte 0x92              ;d0fe  92          DATA '\x92'
    .byte 0x16              ;d0ff  16          DATA '\x16'
    .byte 0xD1              ;d100  d1          DATA '\xd1'
    .byte 0x07              ;d101  07          DATA '\x07'
    .byte 0x20              ;d102  20          DATA ' '
    .byte 0x17              ;d103  17          DATA '\x17'
    .byte 0x40              ;d104  40          DATA '@'
    .byte 0xD1              ;d105  d1          DATA '\xd1'
    .byte 0x14              ;d106  14          DATA '\x14'
    .byte 0x32              ;d107  32          DATA '2'
    .byte 0x02              ;d108  02          DATA '\x02'
    .byte 0xD1              ;d109  d1          DATA '\xd1'
    .byte 0x0E              ;d10a  0e          DATA '\x0e'
    .byte 0x40              ;d10b  40          DATA '@'
    .byte 0xD0              ;d10c  d0          DATA '\xd0'
    .byte 0xFF              ;d10d  ff          DATA '\xff'
    .byte 0x20              ;d10e  20          DATA ' '
    .byte 0x17              ;d10f  17          DATA '\x17'
    .byte 0x8B              ;d110  8b          DATA '\x8b'
    .byte 0x40              ;d111  40          DATA '@'
    .byte 0xD1              ;d112  d1          DATA '\xd1'
    .byte 0x61              ;d113  61          DATA 'a'
    .byte 0x84              ;d114  84          DATA '\x84'
    .byte 0x90              ;d115  90          DATA '\x90'
    .byte 0x15              ;d116  15          DATA '\x15'
    .byte 0xD1              ;d117  d1          DATA '\xd1'
    .byte 0x22              ;d118  22          DATA '"'
    .byte 0x84              ;d119  84          DATA '\x84'
    .byte 0x92              ;d11a  92          DATA '\x92'
    .byte 0x16              ;d11b  16          DATA '\x16'
    .byte 0xD1              ;d11c  d1          DATA '\xd1'
    .byte 0x29              ;d11d  29          DATA ')'
    .byte 0x86              ;d11e  86          DATA '\x86'
    .byte 0x40              ;d11f  40          DATA '@'
    .byte 0xD1              ;d120  d1          DATA '\xd1'
    .byte 0x30              ;d121  30          DATA '0'
    .byte 0x32              ;d122  32          DATA '2'
    .byte 0x02              ;d123  02          DATA '\x02'
    .byte 0xD1              ;d124  d1          DATA '\xd1'
    .byte 0x61              ;d125  61          DATA 'a'
    .byte 0x40              ;d126  40          DATA '@'
    .byte 0xD1              ;d127  d1          DATA '\xd1'
    .byte 0x16              ;d128  16          DATA '\x16'
    .byte 0x32              ;d129  32          DATA '2'
    .byte 0x02              ;d12a  02          DATA '\x02'
    .byte 0xD1              ;d12b  d1          DATA '\xd1'
    .byte 0x61              ;d12c  61          DATA 'a'
    .byte 0x40              ;d12d  40          DATA '@'
    .byte 0xD1              ;d12e  d1          DATA '\xd1'
    .byte 0x1B              ;d12f  1b          DATA '\x1b'
    .byte 0x20              ;d130  20          DATA ' '
    .byte 0x57              ;d131  57          DATA 'W'
    .byte 0x83              ;d132  83          DATA '\x83'
    .byte 0x20              ;d133  20          DATA ' '
    .byte 0x59              ;d134  59          DATA 'Y'
    .byte 0x83              ;d135  83          DATA '\x83'
    .byte 0x20              ;d136  20          DATA ' '
    .byte 0xDB              ;d137  db          DATA '\xdb'
    .byte 0x91              ;d138  91          DATA '\x91'
    .byte 0x15              ;d139  15          DATA '\x15'
    .byte 0xD1              ;d13a  d1          DATA '\xd1'
    .byte 0x41              ;d13b  41          DATA 'A'
    .byte 0x84              ;d13c  84          DATA '\x84'
    .byte 0x90              ;d13d  90          DATA '\x90'
    .byte 0x40              ;d13e  40          DATA '@'
    .byte 0xD1              ;d13f  d1          DATA '\xd1'
    .byte 0x48              ;d140  48          DATA 'H'
    .byte 0x32              ;d141  32          DATA '2'
    .byte 0x02              ;d142  02          DATA '\x02'
    .byte 0xD1              ;d143  d1          DATA '\xd1'
    .byte 0x76              ;d144  76          DATA 'v'
    .byte 0x40              ;d145  40          DATA '@'
    .byte 0xD1              ;d146  d1          DATA '\xd1'
    .byte 0x39              ;d147  39          DATA '9'
    .byte 0x16              ;d148  16          DATA '\x16'
    .byte 0xD1              ;d149  d1          DATA '\xd1'
    .byte 0x5A              ;d14a  5a          DATA 'Z'
    .byte 0x20              ;d14b  20          DATA ' '
    .byte 0x43              ;d14c  43          DATA 'C'
    .byte 0x3A              ;d14d  3a          DATA ':'
    .byte 0x19              ;d14e  19          DATA '\x19'
    .byte 0x8C              ;d14f  8c          DATA '\x8c'
    .byte 0x94              ;d150  94          DATA '\x94'
    .byte 0x35              ;d151  35          DATA '5'
    .byte 0xD1              ;d152  d1          DATA '\xd1'
    .byte 0xC9              ;d153  c9          DATA '\xc9'
    .byte 0x18              ;d154  18          DATA '\x18'
    .byte 0xD0              ;d155  d0          DATA '\xd0'
    .byte 0x99              ;d156  99          DATA '\x99'
    .byte 0x40              ;d157  40          DATA '@'
    .byte 0xD0              ;d158  d0          DATA '\xd0'
    .byte 0xC8              ;d159  c8          DATA '\xc8'
    .byte 0x32              ;d15a  32          DATA '2'
    .byte 0x02              ;d15b  02          DATA '\x02'
    .byte 0xD1              ;d15c  d1          DATA '\xd1'
    .byte 0x61              ;d15d  61          DATA 'a'
    .byte 0x40              ;d15e  40          DATA '@'
    .byte 0xD1              ;d15f  d1          DATA '\xd1'
    .byte 0x48              ;d160  48          DATA 'H'
    .byte 0x20              ;d161  20          DATA ' '
    .byte 0x1B              ;d162  1b          DATA '\x1b'
    .byte 0x85              ;d163  85          DATA '\x85'
    .byte 0x91              ;d164  91          DATA '\x91'
    .byte 0x16              ;d165  16          DATA '\x16'
    .byte 0xD1              ;d166  d1          DATA '\xd1'
    .byte 0x6F              ;d167  6f          DATA 'o'
    .byte 0x87              ;d168  87          DATA '\x87'
    .byte 0x50              ;d169  50          DATA 'P'
    .byte 0xD3              ;d16a  d3          DATA '\xd3'
    .byte 0x4C              ;d16b  4c          DATA 'L'
    .byte 0x40              ;d16c  40          DATA '@'
    .byte 0xCF              ;d16d  cf          DATA '\xcf'
    .byte 0xD9              ;d16e  d9          DATA '\xd9'
    .byte 0x32              ;d16f  32          DATA '2'
    .byte 0x02              ;d170  02          DATA '\x02'
    .byte 0xD1              ;d171  d1          DATA '\xd1'
    .byte 0x76              ;d172  76          DATA 'v'
    .byte 0x40              ;d173  40          DATA '@'
    .byte 0xD1              ;d174  d1          DATA '\xd1'
    .byte 0x65              ;d175  65          DATA 'e'
    .byte 0x20              ;d176  20          DATA ' '
    .byte 0x0F              ;d177  0f          DATA '\x0f'
    .byte 0x85              ;d178  85          DATA '\x85'
    .byte 0x20              ;d179  20          DATA ' '
    .byte 0x00              ;d17a  00          DATA '\x00'
    .byte 0x40              ;d17b  40          DATA '@'
    .byte 0xCD              ;d17c  cd          DATA '\xcd'
    .byte 0xD5              ;d17d  d5          DATA '\xd5'
    .byte 0x39              ;d17e  39          DATA '9'
    .byte 0x16              ;d17f  16          DATA '\x16'
    .byte 0x10              ;d180  10          DATA '\x10'
    .byte 0x20              ;d181  20          DATA ' '
    .byte 0x0F              ;d182  0f          DATA '\x0f'
    .byte 0x85              ;d183  85          DATA '\x85'
    .byte 0x20              ;d184  20          DATA ' '
    .byte 0x00              ;d185  00          DATA '\x00'
    .byte 0x40              ;d186  40          DATA '@'
    .byte 0xCD              ;d187  cd          DATA '\xcd'
    .byte 0xDC              ;d188  dc          DATA '\xdc'
    .byte 0x39              ;d189  39          DATA '9'
    .byte 0x16              ;d18a  16          DATA '\x16'
    .byte 0x10              ;d18b  10          DATA '\x10'
    .byte 0x20              ;d18c  20          DATA ' '
    .byte 0x0F              ;d18d  0f          DATA '\x0f'
    .byte 0x85              ;d18e  85          DATA '\x85'
    .byte 0x20              ;d18f  20          DATA ' '
    .byte 0x00              ;d190  00          DATA '\x00'
    .byte 0x40              ;d191  40          DATA '@'
    .byte 0xCD              ;d192  cd          DATA '\xcd'
    .byte 0xD5              ;d193  d5          DATA '\xd5'
    .byte 0x39              ;d194  39          DATA '9'
    .byte 0x65              ;d195  65          DATA 'e'
    .byte 0x20              ;d196  20          DATA ' '
    .byte 0x17              ;d197  17          DATA '\x17'
    .byte 0x84              ;d198  84          DATA '\x84'
    .byte 0x20              ;d199  20          DATA ' '
    .byte 0x15              ;d19a  15          DATA '\x15'
    .byte 0x85              ;d19b  85          DATA '\x85'
    .byte 0x92              ;d19c  92          DATA '\x92'
    .byte 0x16              ;d19d  16          DATA '\x16'
    .byte 0xD1              ;d19e  d1          DATA '\xd1'
    .byte 0xA3              ;d19f  a3          DATA '\xa3'
    .byte 0x40              ;d1a0  40          DATA '@'
    .byte 0xD1              ;d1a1  d1          DATA '\xd1'
    .byte 0xAA              ;d1a2  aa          DATA '\xaa'
    .byte 0x32              ;d1a3  32          DATA '2'
    .byte 0x02              ;d1a4  02          DATA '\x02'
    .byte 0xD1              ;d1a5  d1          DATA '\xd1'
    .byte 0xAA              ;d1a6  aa          DATA '\xaa'
    .byte 0x40              ;d1a7  40          DATA '@'
    .byte 0xD1              ;d1a8  d1          DATA '\xd1'
    .byte 0x9D              ;d1a9  9d          DATA '\x9d'
    .byte 0x20              ;d1aa  20          DATA ' '
    .byte 0x1B              ;d1ab  1b          DATA '\x1b'
    .byte 0x85              ;d1ac  85          DATA '\x85'
    .byte 0x92              ;d1ad  92          DATA '\x92'
    .byte 0x16              ;d1ae  16          DATA '\x16'
    .byte 0xD1              ;d1af  d1          DATA '\xd1'
    .byte 0xB8              ;d1b0  b8          DATA '\xb8'
    .byte 0x87              ;d1b1  87          DATA '\x87'
    .byte 0x50              ;d1b2  50          DATA 'P'
    .byte 0xD3              ;d1b3  d3          DATA '\xd3'
    .byte 0x4C              ;d1b4  4c          DATA 'L'
    .byte 0x40              ;d1b5  40          DATA '@'
    .byte 0xCF              ;d1b6  cf          DATA '\xcf'
    .byte 0xD9              ;d1b7  d9          DATA '\xd9'
    .byte 0x32              ;d1b8  32          DATA '2'
    .byte 0x02              ;d1b9  02          DATA '\x02'
    .byte 0xD1              ;d1ba  d1          DATA '\xd1'
    .byte 0xBF              ;d1bb  bf          DATA '\xbf'
    .byte 0x40              ;d1bc  40          DATA '@'
    .byte 0xD1              ;d1bd  d1          DATA '\xd1'
    .byte 0xAE              ;d1be  ae          DATA '\xae'
    .byte 0x20              ;d1bf  20          DATA ' '
    .byte 0x0F              ;d1c0  0f          DATA '\x0f'
    .byte 0x85              ;d1c1  85          DATA '\x85'
    .byte 0x20              ;d1c2  20          DATA ' '
    .byte 0x00              ;d1c3  00          DATA '\x00'
    .byte 0x30              ;d1c4  30          DATA '0'
    .byte 0x02              ;d1c5  02          DATA '\x02'
    .byte 0x40              ;d1c6  40          DATA '@'
    .byte 0xCD              ;d1c7  cd          DATA '\xcd'
    .byte 0xD5              ;d1c8  d5          DATA '\xd5'
    .byte 0x39              ;d1c9  39          DATA '9'
    .byte 0x08              ;d1ca  08          DATA '\x08'
    .byte 0x10              ;d1cb  10          DATA '\x10'
    .byte 0x20              ;d1cc  20          DATA ' '
    .byte 0x0F              ;d1cd  0f          DATA '\x0f'
    .byte 0x85              ;d1ce  85          DATA '\x85'
    .byte 0x20              ;d1cf  20          DATA ' '
    .byte 0x00              ;d1d0  00          DATA '\x00'
    .byte 0x40              ;d1d1  40          DATA '@'
    .byte 0xCD              ;d1d2  cd          DATA '\xcd'
    .byte 0xE1              ;d1d3  e1          DATA '\xe1'
    .byte 0x19              ;d1d4  19          DATA '\x19'
    .byte 0xD1              ;d1d5  d1          DATA '\xd1'
    .byte 0xF2              ;d1d6  f2          DATA '\xf2'
    .byte 0x16              ;d1d7  16          DATA '\x16'
    .byte 0xD1              ;d1d8  d1          DATA '\xd1'
    .byte 0x7E              ;d1d9  7e          DATA '~'
    .byte 0x32              ;d1da  32          DATA '2'
    .byte 0x01              ;d1db  01          DATA '\x01'
    .byte 0xD1              ;d1dc  d1          DATA '\xd1'
    .byte 0xE1              ;d1dd  e1          DATA '\xe1'
    .byte 0x40              ;d1de  40          DATA '@'
    .byte 0xCD              ;d1df  cd          DATA '\xcd'
    .byte 0xF1              ;d1e0  f1          DATA '\xf1'
    .byte 0x32              ;d1e1  32          DATA '2'
    .byte 0x80              ;d1e2  80          DATA '\x80'
    .byte 0xD0              ;d1e3  d0          DATA '\xd0'
    .byte 0xC7              ;d1e4  c7          DATA '\xc7'
    .byte 0x31              ;d1e5  31          DATA '1'
    .byte 0xD1              ;d1e6  d1          DATA '\xd1'
    .byte 0xEB              ;d1e7  eb          DATA '\xeb'
    .byte 0x40              ;d1e8  40          DATA '@'
    .byte 0xD0              ;d1e9  d0          DATA '\xd0'
    .byte 0xC7              ;d1ea  c7          DATA '\xc7'
    .byte 0x38              ;d1eb  38          DATA '8'
    .byte 0x07              ;d1ec  07          DATA '\x07'
    .byte 0x30              ;d1ed  30          DATA '0'
    .byte 0x01              ;d1ee  01          DATA '\x01'
    .byte 0x40              ;d1ef  40          DATA '@'
    .byte 0xD2              ;d1f0  d2          DATA '\xd2'
    .byte 0x20              ;d1f1  20          DATA ' '
    .byte 0x16              ;d1f2  16          DATA '\x16'
    .byte 0xD1              ;d1f3  d1          DATA '\xd1'
    .byte 0x7E              ;d1f4  7e          DATA '~'
    .byte 0x32              ;d1f5  32          DATA '2'
    .byte 0x01              ;d1f6  01          DATA '\x01'
    .byte 0xD1              ;d1f7  d1          DATA '\xd1'
    .byte 0xFC              ;d1f8  fc          DATA '\xfc'
    .byte 0x40              ;d1f9  40          DATA '@'
    .byte 0xCD              ;d1fa  cd          DATA '\xcd'
    .byte 0xF1              ;d1fb  f1          DATA '\xf1'
    .byte 0x32              ;d1fc  32          DATA '2'
    .byte 0x80              ;d1fd  80          DATA '\x80'
    .byte 0xD2              ;d1fe  d2          DATA '\xd2'
    .byte 0x79              ;d1ff  79          DATA 'y'
    .byte 0x31              ;d200  31          DATA '1'
    .byte 0xD2              ;d201  d2          DATA '\xd2'
    .byte 0x06              ;d202  06          DATA '\x06'
    .byte 0x40              ;d203  40          DATA '@'
    .byte 0xD2              ;d204  d2          DATA '\xd2'
    .byte 0x79              ;d205  79          DATA 'y'
    .byte 0x38              ;d206  38          DATA '8'
    .byte 0x07              ;d207  07          DATA '\x07'
    .byte 0x30              ;d208  30          DATA '0'
    .byte 0x01              ;d209  01          DATA '\x01'
    .byte 0x40              ;d20a  40          DATA '@'
    .byte 0xD2              ;d20b  d2          DATA '\xd2'
    .byte 0xB9              ;d20c  b9          DATA '\xb9'
    .byte 0x19              ;d20d  19          DATA '\x19'
    .byte 0xD2              ;d20e  d2          DATA '\xd2'
    .byte 0xFC              ;d20f  fc          DATA '\xfc'
    .byte 0x39              ;d210  39          DATA '9'
    .byte 0x38              ;d211  38          DATA '8'
    .byte 0x10              ;d212  10          DATA '\x10'
    .byte 0x3D              ;d213  3d          DATA '='
    .byte 0x21              ;d214  21          DATA '!'
    .byte 0x03              ;d215  03          DATA '\x03'
    .byte 0x4B              ;d216  4b          DATA 'K'
    .byte 0x84              ;d217  84          DATA '\x84'
    .byte 0x16              ;d218  16          DATA '\x16'
    .byte 0xD1              ;d219  d1          DATA '\xd1'
    .byte 0x7E              ;d21a  7e          DATA '~'
    .byte 0x17              ;d21b  17          DATA '\x17'
    .byte 0x0A              ;d21c  0a          DATA '\n'
    .byte 0x40              ;d21d  40          DATA '@'
    .byte 0xCE              ;d21e  ce          DATA '\xce'
    .byte 0x82              ;d21f  82          DATA '\x82'
    .byte 0x19              ;d220  19          DATA '\x19'
    .byte 0xD2              ;d221  d2          DATA '\xd2'
    .byte 0xB9              ;d222  b9          DATA '\xb9'
    .byte 0x39              ;d223  39          DATA '9'
    .byte 0x54              ;d224  54          DATA 'T'
    .byte 0x10              ;d225  10          DATA '\x10'
    .byte 0x20              ;d226  20          DATA ' '
    .byte 0x4A              ;d227  4a          DATA 'J'
    .byte 0x8C              ;d228  8c          DATA '\x8c'
    .byte 0x20              ;d229  20          DATA ' '
    .byte 0x55              ;d22a  55          DATA 'U'
    .byte 0x89              ;d22b  89          DATA '\x89'
    .byte 0x20              ;d22c  20          DATA ' '
    .byte 0x0F              ;d22d  0f          DATA '\x0f'
    .byte 0x85              ;d22e  85          DATA '\x85'
    .byte 0x20              ;d22f  20          DATA ' '
    .byte 0x00              ;d230  00          DATA '\x00'
    .byte 0x40              ;d231  40          DATA '@'
    .byte 0xCD              ;d232  cd          DATA '\xcd'
    .byte 0xE1              ;d233  e1          DATA '\xe1'
    .byte 0x19              ;d234  19          DATA '\x19'
    .byte 0xD2              ;d235  d2          DATA '\xd2'
    .byte 0xD0              ;d236  d0          DATA '\xd0'
    .byte 0x50              ;d237  50          DATA 'P'
    .byte 0xD2              ;d238  d2          DATA '\xd2'
    .byte 0x52              ;d239  52          DATA 'R'
    .byte 0x40              ;d23a  40          DATA '@'
    .byte 0xCD              ;d23b  cd          DATA '\xcd'
    .byte 0xE1              ;d23c  e1          DATA '\xe1'
    .byte 0x19              ;d23d  19          DATA '\x19'
    .byte 0xD2              ;d23e  d2          DATA '\xd2'
    .byte 0xE3              ;d23f  e3          DATA '\xe3'
    .byte 0x50              ;d240  50          DATA 'P'
    .byte 0xD2              ;d241  d2          DATA '\xd2'
    .byte 0x52              ;d242  52          DATA 'R'
    .byte 0x85              ;d243  85          DATA '\x85'
    .byte 0x13              ;d244  13          DATA '\x13'
    .byte 0x40              ;d245  40          DATA '@'
    .byte 0xD0              ;d246  d0          DATA '\xd0'
    .byte 0x51              ;d247  51          DATA 'Q'
    .byte 0x19              ;d248  19          DATA '\x19'
    .byte 0xD2              ;d249  d2          DATA '\xd2'
    .byte 0xD9              ;d24a  d9          DATA '\xd9'
    .byte 0x50              ;d24b  50          DATA 'P'
    .byte 0xD2              ;d24c  d2          DATA '\xd2'
    .byte 0x52              ;d24d  52          DATA 'R'
    .byte 0x85              ;d24e  85          DATA '\x85'
    .byte 0x40              ;d24f  40          DATA '@'
    .byte 0xD0              ;d250  d0          DATA '\xd0'
    .byte 0x51              ;d251  51          DATA 'Q'
    .byte 0x39              ;d252  39          DATA '9'
    .byte 0x34              ;d253  34          DATA '4'
    .byte 0x20              ;d254  20          DATA ' '
    .byte 0x43              ;d255  43          DATA 'C'
    .byte 0x8C              ;d256  8c          DATA '\x8c'
    .byte 0x20              ;d257  20          DATA ' '
    .byte 0x57              ;d258  57          DATA 'W'
    .byte 0x84              ;d259  84          DATA '\x84'
    .byte 0x20              ;d25a  20          DATA ' '
    .byte 0x43              ;d25b  43          DATA 'C'
    .byte 0x8C              ;d25c  8c          DATA '\x8c'
    .byte 0x20              ;d25d  20          DATA ' '
    .byte 0x0F              ;d25e  0f          DATA '\x0f'
    .byte 0x85              ;d25f  85          DATA '\x85'
    .byte 0x20              ;d260  20          DATA ' '
    .byte 0x00              ;d261  00          DATA '\x00'
    .byte 0x60              ;d262  60          DATA '`'
    .byte 0x19              ;d263  19          DATA '\x19'
    .byte 0xD2              ;d264  d2          DATA '\xd2'
    .byte 0xA6              ;d265  a6          DATA '\xa6'
    .byte 0x39              ;d266  39          DATA '9'
    .byte 0x42              ;d267  42          DATA 'B'
    .byte 0x10              ;d268  10          DATA '\x10'
    .byte 0x3D              ;d269  3d          DATA '='
    .byte 0x21              ;d26a  21          DATA '!'
    .byte 0x03              ;d26b  03          DATA '\x03'
    .byte 0x57              ;d26c  57          DATA 'W'
    .byte 0x83              ;d26d  83          DATA '\x83'
    .byte 0x20              ;d26e  20          DATA ' '
    .byte 0x47              ;d26f  47          DATA 'G'
    .byte 0x84              ;d270  84          DATA '\x84'
    .byte 0x16              ;d271  16          DATA '\x16'
    .byte 0xD1              ;d272  d1          DATA '\xd1'
    .byte 0x7E              ;d273  7e          DATA '~'
    .byte 0x17              ;d274  17          DATA '\x17'
    .byte 0x0A              ;d275  0a          DATA '\n'
    .byte 0x40              ;d276  40          DATA '@'
    .byte 0xCE              ;d277  ce          DATA '\xce'
    .byte 0x82              ;d278  82          DATA '\x82'
    .byte 0x13              ;d279  13          DATA '\x13'
    .byte 0x39              ;d27a  39          DATA '9'
    .byte 0x18              ;d27b  18          DATA '\x18'
    .byte 0x10              ;d27c  10          DATA '\x10'
    .byte 0x20              ;d27d  20          DATA ' '
    .byte 0x79              ;d27e  79          DATA 'y'
    .byte 0x81              ;d27f  81          DATA '\x81'
    .byte 0x20              ;d280  20          DATA ' '
    .byte 0xEB              ;d281  eb          DATA '\xeb'
    .byte 0x89              ;d282  89          DATA '\x89'
    .byte 0x20              ;d283  20          DATA ' '
    .byte 0x4A              ;d284  4a          DATA 'J'
    .byte 0x8A              ;d285  8a          DATA '\x8a'
    .byte 0x40              ;d286  40          DATA '@'
    .byte 0xD2              ;d287  d2          DATA '\xd2'
    .byte 0x89              ;d288  89          DATA '\x89'
    .byte 0x93              ;d289  93          DATA '\x93'
    .byte 0x32              ;d28a  32          DATA '2'
    .byte 0x02              ;d28b  02          DATA '\x02'
    .byte 0xD2              ;d28c  d2          DATA '\xd2'
    .byte 0x9A              ;d28d  9a          DATA '\x9a'
    .byte 0x32              ;d28e  32          DATA '2'
    .byte 0x01              ;d28f  01          DATA '\x01'
    .byte 0xD2              ;d290  d2          DATA '\xd2'
    .byte 0x95              ;d291  95          DATA '\x95'
    .byte 0x40              ;d292  40          DATA '@'
    .byte 0xD2              ;d293  d2          DATA '\xd2'
    .byte 0x8A              ;d294  8a          DATA '\x8a'
    .byte 0x20              ;d295  20          DATA ' '
    .byte 0xFB              ;d296  fb          DATA '\xfb'
    .byte 0x80              ;d297  80          DATA '\x80'
    .byte 0x20              ;d298  20          DATA ' '
    .byte 0x6A              ;d299  6a          DATA 'j'
    .byte 0x12              ;d29a  12          DATA '\x12'
    .byte 0x8C              ;d29b  8c          DATA '\x8c'
    .byte 0x11              ;d29c  11          DATA '\x11'
    .byte 0x94              ;d29d  94          DATA '\x94'
    .byte 0x36              ;d29e  36          DATA '6'
    .byte 0x20              ;d29f  20          DATA ' '
    .byte 0xD2              ;d2a0  d2          DATA '\xd2'
    .byte 0xA3              ;d2a1  a3          DATA '\xa3'
    .byte 0x95              ;d2a2  95          DATA '\x95'
    .byte 0x40              ;d2a3  40          DATA '@'
    .byte 0xCD              ;d2a4  cd          DATA '\xcd'
    .byte 0xF1              ;d2a5  f1          DATA '\xf1'
    .byte 0x39              ;d2a6  39          DATA '9'
    .byte 0x46              ;d2a7  46          DATA 'F'
    .byte 0x10              ;d2a8  10          DATA '\x10'
    .byte 0x3D              ;d2a9  3d          DATA '='
    .byte 0x21              ;d2aa  21          DATA '!'
    .byte 0x03              ;d2ab  03          DATA '\x03'
    .byte 0x5B              ;d2ac  5b          DATA '['
    .byte 0x83              ;d2ad  83          DATA '\x83'
    .byte 0x20              ;d2ae  20          DATA ' '
    .byte 0x4B              ;d2af  4b          DATA 'K'
    .byte 0x84              ;d2b0  84          DATA '\x84'
    .byte 0x16              ;d2b1  16          DATA '\x16'
    .byte 0xD1              ;d2b2  d1          DATA '\xd1'
    .byte 0x7E              ;d2b3  7e          DATA '~'
    .byte 0x17              ;d2b4  17          DATA '\x17'
    .byte 0x0A              ;d2b5  0a          DATA '\n'
    .byte 0x40              ;d2b6  40          DATA '@'
    .byte 0xCE              ;d2b7  ce          DATA '\xce'
    .byte 0x82              ;d2b8  82          DATA '\x82'
    .byte 0x39              ;d2b9  39          DATA '9'
    .byte 0x57              ;d2ba  57          DATA 'W'
    .byte 0x10              ;d2bb  10          DATA '\x10'
    .byte 0x20              ;d2bc  20          DATA ' '
    .byte 0x46              ;d2bd  46          DATA 'F'
    .byte 0x8C              ;d2be  8c          DATA '\x8c'
    .byte 0x20              ;d2bf  20          DATA ' '
    .byte 0x59              ;d2c0  59          DATA 'Y'
    .byte 0x89              ;d2c1  89          DATA '\x89'
    .byte 0x20              ;d2c2  20          DATA ' '
    .byte 0x4f
    .byte 0x84
    .byte 0x20
    .byte 0x0F              ;d2c6  0f          DATA '\x0f'
    .byte 0x85              ;d2c7  85          DATA '\x85'
    .byte 0x20              ;d2c8  20          DATA ' '
    .byte 0x00              ;d2c9  00          DATA '\x00'
    .byte 0x40              ;d2ca  40          DATA '@'
    .byte 0xCD              ;d2cb  cd          DATA '\xcd'
    .byte 0xE1              ;d2cc  e1          DATA '\xe1'
    .byte 0x19              ;d2cd  19          DATA '\x19'
    .byte 0xD2              ;d2ce  d2          DATA '\xd2'
    .byte 0x37              ;d2cf  37          DATA '7'
    .byte 0x50              ;d2d0  50          DATA 'P'
    .byte 0xD2              ;d2d1  d2          DATA '\xd2'
    .byte 0xEB              ;d2d2  eb          DATA '\xeb'
    .byte 0x40              ;d2d3  40          DATA '@'
    .byte 0xCD              ;d2d4  cd          DATA '\xcd'
    .byte 0xE1              ;d2d5  e1          DATA '\xe1'
    .byte 0x19              ;d2d6  19          DATA '\x19'
    .byte 0xD2              ;d2d7  d2          DATA '\xd2'
    .byte 0x4B              ;d2d8  4b          DATA 'K'
    .byte 0x50              ;d2d9  50          DATA 'P'
    .byte 0xD2              ;d2da  d2          DATA '\xd2'
    .byte 0xEB              ;d2db  eb          DATA '\xeb'
    .byte 0x85              ;d2dc  85          DATA '\x85'
    .byte 0x40              ;d2dd  40          DATA '@'
    .byte 0xD0              ;d2de  d0          DATA '\xd0'
    .byte 0x51              ;d2df  51          DATA 'Q'
    .byte 0x19              ;d2e0  19          DATA '\x19'
    .byte 0xD2              ;d2e1  d2          DATA '\xd2'
    .byte 0x40              ;d2e2  40          DATA '@'
    .byte 0x50              ;d2e3  50          DATA 'P'
    .byte 0xD2              ;d2e4  d2          DATA '\xd2'
    .byte 0xEB              ;d2e5  eb          DATA '\xeb'
    .byte 0x85              ;d2e6  85          DATA '\x85'
    .byte 0x13              ;d2e7  13          DATA '\x13'
    .byte 0x40              ;d2e8  40          DATA '@'
    .byte 0xD0              ;d2e9  d0          DATA '\xd0'
    .byte 0x51              ;d2ea  51          DATA 'Q'
    .byte 0x39              ;d2eb  39          DATA '9'
    .byte 0x36              ;d2ec  36          DATA '6'
    .byte 0x20              ;d2ed  20          DATA ' '
    .byte 0x43              ;d2ee  43          DATA 'C'
    .byte 0x8C              ;d2ef  8c          DATA '\x8c'
    .byte 0x20              ;d2f0  20          DATA ' '
    .byte 0x5B              ;d2f1  5b          DATA '['
    .byte 0x84              ;d2f2  84          DATA '\x84'
    .byte 0x20              ;d2f3  20          DATA ' '
    .byte 0x43              ;d2f4  43          DATA 'C'
    .byte 0x8C              ;d2f5  8c          DATA '\x8c'
    .byte 0x20              ;d2f6  20          DATA ' '
    .byte 0x0F              ;d2f7  0f          DATA '\x0f'
    .byte 0x85              ;d2f8  85          DATA '\x85'
    .byte 0x20              ;d2f9  20          DATA ' '
    .byte 0x00              ;d2fa  00          DATA '\x00'
    .byte 0x60              ;d2fb  60          DATA '`'
    .byte 0x39              ;d2fc  39          DATA '9'
    .byte 0x50              ;d2fd  50          DATA 'P'
    .byte 0x10              ;d2fe  10          DATA '\x10'
    .byte 0x3D              ;d2ff  3d          DATA '='
    .byte 0x21              ;d300  21          DATA '!'
    .byte 0x03              ;d301  03          DATA '\x03'
    .byte 0x47              ;d302  47          DATA 'G'
    .byte 0x84              ;d303  84          DATA '\x84'
    .byte 0x16              ;d304  16          DATA '\x16'
    .byte 0xD1              ;d305  d1          DATA '\xd1'
    .byte 0x7E              ;d306  7e          DATA '~'
    .byte 0x17              ;d307  17          DATA '\x17'
    .byte 0x0A              ;d308  0a          DATA '\n'
    .byte 0x40              ;d309  40          DATA '@'
    .byte 0xCE              ;d30a  ce          DATA '\xce'
    .byte 0x82              ;d30b  82          DATA '\x82'
    .byte 0x19              ;d30c  19          DATA '\x19'
    .byte 0xD3              ;d30d  d3          DATA '\xd3'
    .byte 0x21              ;d30e  21          DATA '!'
    .byte 0x39              ;d30f  39          DATA '9'
    .byte 0x59              ;d310  59          DATA 'Y'
    .byte 0x20              ;d311  20          DATA ' '
    .byte 0x43              ;d312  43          DATA 'C'
    .byte 0x8C              ;d313  8c          DATA '\x8c'
    .byte 0x20              ;d314  20          DATA ' '
    .byte 0x57              ;d315  57          DATA 'W'
    .byte 0x83              ;d316  83          DATA '\x83'
    .byte 0x20              ;d317  20          DATA ' '
    .byte 0x47              ;d318  47          DATA 'G'
    .byte 0x89              ;d319  89          DATA '\x89'
    .byte 0x3D              ;d31a  3d          DATA '='
    .byte 0x40              ;d31b  40          DATA '@'
    .byte 0xCE              ;d31c  ce          DATA '\xce'
    .byte 0x82              ;d31d  82          DATA '\x82'
    .byte 0x19              ;d31e  19          DATA '\x19'
    .byte 0xD3              ;d31f  d3          DATA '\xd3'
    .byte 0x0F              ;d320  0f          DATA '\x0f'
    .byte 0x39              ;d321  39          DATA '9'
    .byte 0x61              ;d322  61          DATA 'a'
    .byte 0x20              ;d323  20          DATA ' '
    .byte 0x43              ;d324  43          DATA 'C'
    .byte 0x8C              ;d325  8c          DATA '\x8c'
    .byte 0x20              ;d326  20          DATA ' '
    .byte 0x5B              ;d327  5b          DATA '['
    .byte 0x83              ;d328  83          DATA '\x83'
    .byte 0x20              ;d329  20          DATA ' '
    .byte 0x4B              ;d32a  4b          DATA 'K'
    .byte 0x89              ;d32b  89          DATA '\x89'
    .byte 0x3D              ;d32c  3d          DATA '='
    .byte 0x40              ;d32d  40          DATA '@'
    .byte 0xCE              ;d32e  ce          DATA '\xce'
    .byte 0x82              ;d32f  82          DATA '\x82'
    .byte 0x3A              ;d330  3a          DATA ':'
    .byte 0x0C              ;d331  0c          DATA '\x0c'
    .byte 0x39              ;d332  39          DATA '9'
    .byte 0x63              ;d333  63          DATA 'c'
    .byte 0x20              ;d334  20          DATA ' '
    .byte 0x19              ;d335  19          DATA '\x19'
    .byte 0x84              ;d336  84          DATA '\x84'
    .byte 0x15              ;d337  15          DATA '\x15'
    .byte 0xD1              ;d338  d1          DATA '\xd1'
    .byte 0x89              ;d339  89          DATA '\x89'
    .byte 0x92              ;d33a  92          DATA '\x92'
    .byte 0x16              ;d33b  16          DATA '\x16'
    .byte 0xD3              ;d33c  d3          DATA '\xd3'
    .byte 0x45              ;d33d  45          DATA 'E'
    .byte 0x8A              ;d33e  8a          DATA '\x8a'
    .byte 0x50              ;d33f  50          DATA 'P'
    .byte 0xD3              ;d340  d3          DATA '\xd3'
    .byte 0x4C              ;d341  4c          DATA 'L'
    .byte 0x40              ;d342  40          DATA '@'
    .byte 0xCF              ;d343  cf          DATA '\xcf'
    .byte 0xD9              ;d344  d9          DATA '\xd9'
    .byte 0x32              ;d345  32          DATA '2'
    .byte 0x02              ;d346  02          DATA '\x02'
    .byte 0xD1              ;d347  d1          DATA '\xd1'
    .byte 0x94              ;d348  94          DATA '\x94'
    .byte 0x40              ;d349  40          DATA '@'
    .byte 0xD3              ;d34a  d3          DATA '\xd3'
    .byte 0x3B              ;d34b  3b          DATA ';'
    .byte 0x20              ;d34c  20          DATA ' '
    .byte 0x15              ;d34d  15          DATA '\x15'
    .byte 0x82              ;d34e  82          DATA '\x82'
    .byte 0x20              ;d34f  20          DATA ' '
    .byte 0x0F              ;d350  0f          DATA '\x0f'
    .byte 0x85              ;d351  85          DATA '\x85'
    .byte 0x20              ;d352  20          DATA ' '
    .byte 0x00              ;d353  00          DATA '\x00'
    .byte 0x60              ;d354  60          DATA '`'
    .byte 0x39              ;d355  39          DATA '9'
    .byte 0x71              ;d356  71          DATA 'q'
    .byte 0x85              ;d357  85          DATA '\x85'
    .byte 0x16              ;d358  16          DATA '\x16'
    .byte 0xCD              ;d359  cd          DATA '\xcd'
    .byte 0xE1              ;d35a  e1          DATA '\xe1'
    .byte 0x84              ;d35b  84          DATA '\x84'
    .byte 0x16              ;d35c  16          DATA '\x16'
    .byte 0xCD              ;d35d  cd          DATA '\xcd'
    .byte 0xE1              ;d35e  e1          DATA '\xe1'
    .byte 0x20              ;d35f  20          DATA ' '
    .byte 0x19              ;d360  19          DATA '\x19'
    .byte 0x8A              ;d361  8a          DATA '\x8a'
    .byte 0x50              ;d362  50          DATA 'P'
    .byte 0xD3              ;d363  d3          DATA '\xd3'
    .byte 0x4C              ;d364  4c          DATA 'L'
    .byte 0x3A              ;d365  3a          DATA ':'
    .byte 0x20              ;d366  20          DATA ' '
    .byte 0x40              ;d367  40          DATA '@'
    .byte 0xCF              ;d368  cf          DATA '\xcf'
    .byte 0xD9              ;d369  d9          DATA '\xd9'
    .byte 0x19              ;d36a  19          DATA '\x19'
    .byte 0xD3              ;d36b  d3          DATA '\xd3'
    .byte 0xDC              ;d36c  dc          DATA '\xdc'
    .byte 0x39              ;d36d  39          DATA '9'
    .byte 0x25              ;d36e  25          DATA '%'
    .byte 0x16              ;d36f  16          DATA '\x16'
    .byte 0xD1              ;d370  d1          DATA '\xd1'
    .byte 0x7E              ;d371  7e          DATA '~'
    .byte 0x32              ;d372  32          DATA '2'
    .byte 0x01              ;d373  01          DATA '\x01'
    .byte 0xD3              ;d374  d3          DATA '\xd3'
    .byte 0x80              ;d375  80          DATA '\x80'
    .byte 0x36              ;d376  36          DATA '6'
    .byte 0x00              ;d377  00          DATA '\x00'
    .byte 0xCE              ;d378  ce          DATA '\xce'
    .byte 0x82              ;d379  82          DATA '\x82'
    .byte 0x3C              ;d37a  3c          DATA '<'
    .byte 0xD3              ;d37b  d3          DATA '\xd3'
    .byte 0x9E              ;d37c  9e          DATA '\x9e'
    .byte 0x40              ;d37d  40          DATA '@'
    .byte 0xCE              ;d37e  ce          DATA '\xce'
    .byte 0x82              ;d37f  82          DATA '\x82'
    .byte 0x20              ;d380  20          DATA ' '
    .byte 0x57              ;d381  57          DATA 'W'
    .byte 0x84              ;d382  84          DATA '\x84'
    .byte 0x20              ;d383  20          DATA ' '
    .byte 0x0F              ;d384  0f          DATA '\x0f'
    .byte 0x85              ;d385  85          DATA '\x85'
    .byte 0x20              ;d386  20          DATA ' '
    .byte 0x00              ;d387  00          DATA '\x00'
    .byte 0x32              ;d388  32          DATA '2'
    .byte 0x20              ;d389  20          DATA ' '
    .byte 0xD3              ;d38a  d3          DATA '\xd3'
    .byte 0x97              ;d38b  97          DATA '\x97'
    .byte 0x3B              ;d38c  3b          DATA ';'
    .byte 0xD3              ;d38d  d3          DATA '\xd3'
    .byte 0x94              ;d38e  94          DATA '\x94'
    .byte 0x13              ;d38f  13          DATA '\x13'
    .byte 0x36              ;d390  36          DATA '6'
    .byte 0x30              ;d391  30          DATA '0'
    .byte 0xCE              ;d392  ce          DATA '\xce'
    .byte 0x82              ;d393  82          DATA '\x82'
    .byte 0x40              ;d394  40          DATA '@'
    .byte 0xD3              ;d395  d3          DATA '\xd3'
    .byte 0xD2              ;d396  d2          DATA '\xd2'
    .byte 0x3B              ;d397  3b          DATA ';'
    .byte 0xD3              ;d398  d3          DATA '\xd3'
    .byte 0x9B              ;d399  9b          DATA '\x9b'
    .byte 0x13              ;d39a  13          DATA '\x13'
    .byte 0x40              ;d39b  40          DATA '@'
    .byte 0xCD              ;d39c  cd          DATA '\xcd'
    .byte 0xE1              ;d39d  e1          DATA '\xe1'
    .byte 0x3F              ;d39e  3f          DATA '?'
    .byte 0x3B              ;d39f  3b          DATA ';'
    .byte 0xD3              ;d3a0  d3          DATA '\xd3'
    .byte 0xC1              ;d3a1  c1          DATA '\xc1'
    .byte 0x39              ;d3a2  39          DATA '9'
    .byte 0x80              ;d3a3  80          DATA '\x80'
    .byte 0x20              ;d3a4  20          DATA ' '
    .byte 0x43              ;d3a5  43          DATA 'C'
    .byte 0x8C              ;d3a6  8c          DATA '\x8c'
    .byte 0x20              ;d3a7  20          DATA ' '
    .byte 0x57              ;d3a8  57          DATA 'W'
    .byte 0x83              ;d3a9  83          DATA '\x83'
    .byte 0x20              ;d3aa  20          DATA ' '
    .byte 0xC7              ;d3ab  c7          DATA '\xc7'
    .byte 0x8D              ;d3ac  8d          DATA '\x8d'
    .byte 0x40              ;d3ad  40          DATA '@'
    .byte 0xD3              ;d3ae  d3          DATA '\xd3'
    .byte 0xB0              ;d3af  b0          DATA '\xb0'
    .byte 0x20              ;d3b0  20          DATA ' '
    .byte 0x43              ;d3b1  43          DATA 'C'
    .byte 0x89              ;d3b2  89          DATA '\x89'
    .byte 0x20              ;d3b3  20          DATA ' '
    .byte 0x5B              ;d3b4  5b          DATA '['
    .byte 0x83              ;d3b5  83          DATA '\x83'
    .byte 0x20              ;d3b6  20          DATA ' '
    .byte 0x43              ;d3b7  43          DATA 'C'
    .byte 0x85              ;d3b8  85          DATA '\x85'
    .byte 0x20              ;d3b9  20          DATA ' '
    .byte 0x0F              ;d3ba  0f          DATA '\x0f'
    .byte 0x85              ;d3bb  85          DATA '\x85'
    .byte 0x20              ;d3bc  20          DATA ' '
    .byte 0x00              ;d3bd  00          DATA '\x00'
    .byte 0x40              ;d3be  40          DATA '@'
    .byte 0xD3              ;d3bf  d3          DATA '\xd3'
    .byte 0xD2              ;d3c0  d2          DATA '\xd2'
    .byte 0x20              ;d3c1  20          DATA ' '
    .byte 0x43              ;d3c2  43          DATA 'C'
    .byte 0x8C              ;d3c3  8c          DATA '\x8c'
    .byte 0x20              ;d3c4  20          DATA ' '
    .byte 0x57              ;d3c5  57          DATA 'W'
    .byte 0x83              ;d3c6  83          DATA '\x83'
    .byte 0x20              ;d3c7  20          DATA ' '
    .byte 0x47              ;d3c8  47          DATA 'G'
    .byte 0x84              ;d3c9  84          DATA '\x84'
    .byte 0x20              ;d3ca  20          DATA ' '
    .byte 0x43              ;d3cb  43          DATA 'C'
    .byte 0x8C              ;d3cc  8c          DATA '\x8c'
    .byte 0x20              ;d3cd  20          DATA ' '
    .byte 0x0F              ;d3ce  0f          DATA '\x0f'
    .byte 0x8C              ;d3cf  8c          DATA '\x8c'
    .byte 0x20              ;d3d0  20          DATA ' '
    .byte 0x00              ;d3d1  00          DATA '\x00'
    .byte 0x36              ;d3d2  36          DATA '6'
    .byte 0x20              ;d3d3  20          DATA ' '
    .byte 0xD0              ;d3d4  d0          DATA '\xd0'
    .byte 0x53              ;d3d5  53          DATA 'S'
    .byte 0x40              ;d3d6  40          DATA '@'
    .byte 0xD0              ;d3d7  d0          DATA '\xd0'
    .byte 0x51              ;d3d8  51          DATA 'Q'
    .byte 0x19              ;d3d9  19          DATA '\x19'
    .byte 0xD3              ;d3da  d3          DATA '\xd3'
    .byte 0x6D              ;d3db  6d          DATA 'm'
    .byte 0x39              ;d3dc  39          DATA '9'
    .byte 0x30              ;d3dd  30          DATA '0'
    .byte 0x16              ;d3de  16          DATA '\x16'
    .byte 0xD1              ;d3df  d1          DATA '\xd1'
    .byte 0x7E              ;d3e0  7e          DATA '~'
    .byte 0x32              ;d3e1  32          DATA '2'
    .byte 0x01              ;d3e2  01          DATA '\x01'
    .byte 0xD3              ;d3e3  d3          DATA '\xd3'
    .byte 0xEF              ;d3e4  ef          DATA '\xef'
    .byte 0x36              ;d3e5  36          DATA '6'
    .byte 0x00              ;d3e6  00          DATA '\x00'
    .byte 0xCE              ;d3e7  ce          DATA '\xce'
    .byte 0x82              ;d3e8  82          DATA '\x82'
    .byte 0x3C              ;d3e9  3c          DATA '<'
    .byte 0xD4              ;d3ea  d4          DATA '\xd4'
    .byte 0x0D              ;d3eb  0d          DATA '\r'
    .byte 0x40              ;d3ec  40          DATA '@'
    .byte 0xCE              ;d3ed  ce          DATA '\xce'
    .byte 0x82              ;d3ee  82          DATA '\x82'
    .byte 0x20              ;d3ef  20          DATA ' '
    .byte 0x5B              ;d3f0  5b          DATA '['
    .byte 0x84              ;d3f1  84          DATA '\x84'
    .byte 0x20              ;d3f2  20          DATA ' '
    .byte 0x0F              ;d3f3  0f          DATA '\x0f'
    .byte 0x85              ;d3f4  85          DATA '\x85'
    .byte 0x20              ;d3f5  20          DATA ' '
    .byte 0x00              ;d3f6  00          DATA '\x00'
    .byte 0x32              ;d3f7  32          DATA '2'
    .byte 0x20              ;d3f8  20          DATA ' '
    .byte 0xD4              ;d3f9  d4          DATA '\xd4'
    .byte 0x06              ;d3fa  06          DATA '\x06'
    .byte 0x3B              ;d3fb  3b          DATA ';'
    .byte 0xD4              ;d3fc  d4          DATA '\xd4'
    .byte 0x03              ;d3fd  03          DATA '\x03'
    .byte 0x13              ;d3fe  13          DATA '\x13'
    .byte 0x36              ;d3ff  36          DATA '6'
    .byte 0x30              ;d400  30          DATA '0'
    .byte 0xCE              ;d401  ce          DATA '\xce'
    .byte 0x82              ;d402  82          DATA '\x82'
    .byte 0x40              ;d403  40          DATA '@'
    .byte 0xD4              ;d404  d4          DATA '\xd4'
    .byte 0x41              ;d405  41          DATA 'A'
    .byte 0x3B              ;d406  3b          DATA ';'
    .byte 0xD4              ;d407  d4          DATA '\xd4'
    .byte 0x0A              ;d408  0a          DATA '\n'
    .byte 0x13              ;d409  13          DATA '\x13'
    .byte 0x40              ;d40a  40          DATA '@'
    .byte 0xCD              ;d40b  cd          DATA '\xcd'
    .byte 0xE1              ;d40c  e1          DATA '\xe1'
    .byte 0x3F              ;d40d  3f          DATA '?'
    .byte 0x3B              ;d40e  3b          DATA ';'
    .byte 0xD4              ;d40f  d4          DATA '\xd4'
    .byte 0x30              ;d410  30          DATA '0'
    .byte 0x39              ;d411  39          DATA '9'
    .byte 0x80              ;d412  80          DATA '\x80'
    .byte 0x20              ;d413  20          DATA ' '
    .byte 0x43              ;d414  43          DATA 'C'
    .byte 0x8C              ;d415  8c          DATA '\x8c'
    .byte 0x20              ;d416  20          DATA ' '
    .byte 0x5B              ;d417  5b          DATA '['
    .byte 0x83              ;d418  83          DATA '\x83'
    .byte 0x20              ;d419  20          DATA ' '
    .byte 0xCB              ;d41a  cb          DATA '\xcb'
    .byte 0x8D              ;d41b  8d          DATA '\x8d'
    .byte 0x40              ;d41c  40          DATA '@'
    .byte 0xD4              ;d41d  d4          DATA '\xd4'
    .byte 0x1F              ;d41e  1f          DATA '\x1f'
    .byte 0x20              ;d41f  20          DATA ' '
    .byte 0x43              ;d420  43          DATA 'C'
    .byte 0x89              ;d421  89          DATA '\x89'
    .byte 0x20              ;d422  20          DATA ' '
    .byte 0x57              ;d423  57          DATA 'W'
    .byte 0x83              ;d424  83          DATA '\x83'
    .byte 0x20              ;d425  20          DATA ' '
    .byte 0x43              ;d426  43          DATA 'C'
    .byte 0x85              ;d427  85          DATA '\x85'
    .byte 0x20              ;d428  20          DATA ' '
    .byte 0x0F              ;d429  0f          DATA '\x0f'
    .byte 0x85              ;d42a  85          DATA '\x85'
    .byte 0x20              ;d42b  20          DATA ' '
    .byte 0x00              ;d42c  00          DATA '\x00'
    .byte 0x40              ;d42d  40          DATA '@'
    .byte 0xD4              ;d42e  d4          DATA '\xd4'
    .byte 0x41              ;d42f  41          DATA 'A'
    .byte 0x20              ;d430  20          DATA ' '
    .byte 0x43              ;d431  43          DATA 'C'
    .byte 0x8C              ;d432  8c          DATA '\x8c'
    .byte 0x20              ;d433  20          DATA ' '
    .byte 0x5B              ;d434  5b          DATA '['
    .byte 0x83              ;d435  83          DATA '\x83'
    .byte 0x20              ;d436  20          DATA ' '
    .byte 0x4B              ;d437  4b          DATA 'K'
    .byte 0x84              ;d438  84          DATA '\x84'
    .byte 0x20              ;d439  20          DATA ' '
    .byte 0x43              ;d43a  43          DATA 'C'
    .byte 0x8C              ;d43b  8c          DATA '\x8c'
    .byte 0x20              ;d43c  20          DATA ' '
    .byte 0x0F              ;d43d  0f          DATA '\x0f'
    .byte 0x85              ;d43e  85          DATA '\x85'
    .byte 0x20              ;d43f  20          DATA ' '
    .byte 0x00              ;d440  00          DATA '\x00'
    .byte 0x36              ;d441  36          DATA '6'
    .byte 0x20              ;d442  20          DATA ' '
    .byte 0xD0              ;d443  d0          DATA '\xd0'
    .byte 0x53              ;d444  53          DATA 'S'
    .byte 0x40              ;d445  40          DATA '@'
    .byte 0xD0              ;d446  d0          DATA '\xd0'
    .byte 0x51              ;d447  51          DATA 'Q'

sub_d448:
    pushw a                 ;d448  40
    setb mem_00f8:7         ;d449  af f8
    movw a, mem_036b        ;d44b  c4 03 6b
    beq lab_d456            ;d44e  fd 06
    decw a                  ;d450  d0
    movw mem_036b, a        ;d451  d4 03 6b
    clrb mem_00f8:7         ;d454  a7 f8

lab_d456:
    movw a, mem_0362        ;d456  c4 03 62
    beq lab_d463            ;d459  fd 08
    decw a                  ;d45b  d0
    movw mem_0362, a        ;d45c  d4 03 62
    bne lab_d463            ;d45f  fc 02
    setb mem_00f8:1         ;d461  a9 f8

lab_d463:
    bbc pdr0:1, lab_d491    ;d463  b1 00 2b     /SCA_ENABLE
    mov a, mem_0182         ;d466  60 01 82
    and a, #0x0f            ;d469  64 0f
    bne lab_d491            ;d46b  fc 24
    mov a, mem_0364         ;d46d  60 03 64
    beq lab_d479            ;d470  fd 07
    decw a                  ;d472  d0
    mov mem_0364, a         ;d473  61 03 64
    jmp lab_d49f            ;d476  21 d4 9f

lab_d479:
    mov a, mem_034e         ;d479  60 03 4e
    beq lab_d491            ;d47c  fd 13
    setb mem_00f8:0         ;d47e  a8 f8
    movw a, mem_036b        ;d480  c4 03 6b
    bne lab_d48e            ;d483  fc 09
    call sub_d848           ;d485  31 d8 48
    movw a, #0x2710         ;d488  e4 27 10
    movw mem_036b, a        ;d48b  d4 03 6b

lab_d48e:
    jmp lab_d494            ;d48e  21 d4 94

lab_d491:
    call sub_d9d0           ;d491  31 d9 d0

lab_d494:
    mov a, mem_034f         ;d494  60 03 4f
    mov mem_034e, a         ;d497  61 03 4e
    mov a, #0xc8            ;d49a  04 c8
    mov mem_0364, a         ;d49c  61 03 64

lab_d49f:
    mov a, mem_0384         ;d49f  60 03 84
    beq lab_d4c4            ;d4a2  fd 20
    mov a, mem_0095         ;d4a4  05 95
    cmp a, #0x01            ;d4a6  14 01
    beq lab_d4bf            ;d4a8  fd 15

    mov a, mem_0369         ;d4aa  60 03 69
    cmp a, #0x03            ;d4ad  14 03
    beq lab_d4b9            ;d4af  fd 08

    cmp a, #0x28            ;d4b1  14 28
    beq lab_d4b9            ;d4b3  fd 04

    cmp a, #0x09            ;d4b5  14 09
    bne lab_d4c4            ;d4b7  fc 0b

lab_d4b9:
    movw a, #mem_cff3       ;d4b9  e4 cf f3
    call sub_cdb6           ;d4bc  31 cd b6

lab_d4bf:
    mov a, #0x00            ;d4bf  04 00
    mov mem_0384, a         ;d4c1  61 03 84

lab_d4c4:
    call sub_d9aa           ;d4c4  31 d9 aa
    call sub_d8e3           ;d4c7  31 d8 e3
    call sub_d911           ;d4ca  31 d9 11
    call sub_d97c           ;d4cd  31 d9 7c
    movw a, mem_0360        ;d4d0  c4 03 60
    beq lab_d4dd            ;d4d3  fd 08
    decw a                  ;d4d5  d0
    movw mem_0360, a        ;d4d6  d4 03 60
    beq lab_d4dd            ;d4d9  fd 02

lab_d4db:
    popw a                  ;d4db  50
    ret                     ;d4dc  20

lab_d4dd:
    movw a, mem_035b        ;d4dd  c4 03 5b
    call sub_d804           ;d4e0  31 d8 04
    mov a, @a               ;d4e3  92
    pushw a                 ;d4e4  40
    and a, #0x0f            ;d4e5  64 0f
    mov mem_0359, a         ;d4e7  61 03 59
    popw a                  ;d4ea  50
    and a, #0xf0            ;d4eb  64 f0
    mov mem_035a, a         ;d4ed  61 03 5a
    movw a, #0x0000         ;d4f0  e4 00 00
    mov a, mem_035a         ;d4f3  60 03 5a
    clrc                    ;d4f6  81
    rorc a                  ;d4f7  03
    rorc a                  ;d4f8  03
    rorc a                  ;d4f9  03
    movw a, #mem_d501       ;d4fa  e4 d5 01
    clrc                    ;d4fd  81
    addcw a                 ;d4fe  23
    movw a, @a              ;d4ff  93
    jmp @a                  ;d500  e0

mem_d501:
    .word lab_d4db          ;d501  d4 db       VECTOR
    .word lab_d521          ;d503  d5 21       VECTOR
    .word lab_d548          ;d505  d5 48       VECTOR
    .word lab_d66f          ;d507  d6 6f       VECTOR
    .word lab_d57a          ;d509  d5 7a       VECTOR
    .word lab_d574          ;d50b  d5 74       VECTOR
    .word lab_d58a          ;d50d  d5 8a       VECTOR
    .word lab_d593          ;d50f  d5 93       VECTOR
    .word lab_d655          ;d511  d6 55       VECTOR
    .word lab_d661          ;d513  d6 61       VECTOR
    .word lab_d4db          ;d515  d4 db       VECTOR
    .word lab_d4db          ;d517  d4 db       VECTOR
    .word lab_d4db          ;d519  d4 db       VECTOR
    .word lab_d4db          ;d51b  d4 db       VECTOR
    .word lab_d4db          ;d51d  d4 db       VECTOR
    .word lab_d4db          ;d51f  d4 db       VECTOR

lab_d521:
    movw a, #mem_d528       ;d521  e4 d5 28
    call sub_d80e           ;d524  31 d8 0e
    jmp @a                  ;d527  e0

mem_d528:
    .word lab_d5b0          ;d528  d5 b0       VECTOR
    .word lab_d5bd          ;d52a  d5 bd       VECTOR
    .word lab_d5ce          ;d52c  d5 ce       VECTOR
    .word lab_d5c2          ;d52e  d5 c2       VECTOR
    .word lab_d5de          ;d530  d5 de       VECTOR
    .word lab_d5f2          ;d532  d5 f2       VECTOR
    .word lab_d604          ;d534  d6 04       VECTOR
    .word lab_d63b          ;d536  d6 3b       VECTOR
    .word lab_d616          ;d538  d6 16       VECTOR
    .word lab_d622          ;d53a  d6 22       VECTOR
    .word lab_d62b          ;d53c  d6 2b       VECTOR
    .word lab_d4db          ;d53e  d4 db       VECTOR
    .word lab_d4db          ;d540  d4 db       VECTOR
    .word lab_d4db          ;d542  d4 db       VECTOR
    .word lab_d4db          ;d544  d4 db       VECTOR
    .word lab_d4db          ;d546  d4 db       VECTOR

lab_d548:
    mov a, mem_0359         ;d548  60 03 59
    beq lab_d554            ;d54b  fd 07
    cmp a, #0x01            ;d54d  14 01
    beq lab_d564            ;d54f  fd 13
    jmp lab_d4db            ;d551  21 d4 db

lab_d554:
    movw a, mem_035b        ;d554  c4 03 5b
    call sub_d804           ;d557  31 d8 04
    mov a, @a               ;d55a  92
    mov mem_0355, a         ;d55b  61 03 55
    call sub_d87b           ;d55e  31 d8 7b
    jmp lab_d4db            ;d561  21 d4 db

lab_d564:
    movw a, mem_035b        ;d564  c4 03 5b
    call sub_d801           ;d567  31 d8 01
    movw a, @a              ;d56a  93
    movw mem_0356, a        ;d56b  d4 03 56
    call sub_d854           ;d56e  31 d8 54
    jmp lab_d4db            ;d571  21 d4 db

lab_d574:
    movw a, mem_035b        ;d574  c4 03 5b
    movw mem_035d, a        ;d577  d4 03 5d

lab_d57a:
    movw a, mem_035b        ;d57a  c4 03 5b
    movw mem_0365, a        ;d57d  d4 03 65
    call sub_d801           ;d580  31 d8 01
    movw a, @a              ;d583  93
    movw mem_035b, a        ;d584  d4 03 5b
    jmp lab_d4db            ;d587  21 d4 db

lab_d58a:
    movw a, mem_035d        ;d58a  c4 03 5d
    movw mem_035b, a        ;d58d  d4 03 5b
    jmp lab_d61c            ;d590  21 d6 1c

lab_d593:
    mov a, mem_034b         ;d593  60 03 4b
    and a, #0x0f            ;d596  64 0f
    mov a, mem_0359         ;d598  60 03 59
    cmp a                   ;d59b  12
    beq lab_d5a4            ;d59c  fd 06
    call sub_d804           ;d59e  31 d8 04
    jmp lab_d61c            ;d5a1  21 d6 1c

lab_d5a4:
    call sub_d830           ;d5a4  31 d8 30
    call sub_d84e           ;d5a7  31 d8 4e
    call sub_d848           ;d5aa  31 d8 48
    jmp lab_d57a            ;d5ad  21 d5 7a

lab_d5b0:
    setb mem_00f7:6         ;d5b0  ae f7
    movw a, #0x0000         ;d5b2  e4 00 00
    movw mem_0351, a        ;d5b5  d4 03 51
    clrb mem_00f8:3         ;d5b8  a3 f8
    jmp lab_d4db            ;d5ba  21 d4 db

lab_d5bd:
    clrb mem_00f7:6         ;d5bd  a6 f7
    jmp lab_d4db            ;d5bf  21 d4 db

lab_d5c2:
    mov a, mem_00f7         ;d5c2  05 f7
    xor a, #0x02            ;d5c4  54 02
    mov mem_00f7, a         ;d5c6  45 f7
    call sub_d835           ;d5c8  31 d8 35
    jmp lab_d4db            ;d5cb  21 d4 db

lab_d5ce:
    mov a, mem_00f7         ;d5ce  05 f7
    and a, #0x02            ;d5d0  64 02
    beq lab_d5d9            ;d5d2  fd 05
    setb pdr3:6             ;d5d4  ae 0c        TAPE_TRACK_SW=high
    jmp lab_d4db            ;d5d6  21 d4 db

lab_d5d9:
    clrb pdr3:6             ;d5d9  a6 0c        TAPE_TRACK_SW=low
    jmp lab_d4db            ;d5db  21 d4 db

lab_d5de:
    mov a, mem_00f7         ;d5de  05 f7
    xor a, #0x08            ;d5e0  54 08
    mov mem_00f7, a         ;d5e2  45 f7
    and a, #0x08            ;d5e4  64 08
    beq lab_d5ed            ;d5e6  fd 05
    clrb pdr3:5             ;d5e8  a5 0c        /TAPE_DOLBY_ON=low
    jmp lab_d4db            ;d5ea  21 d4 db

lab_d5ed:
    setb pdr3:5             ;d5ed  ad 0c        /TAPE_DOLBY_ON=high
    jmp lab_d4db            ;d5ef  21 d4 db

lab_d5f2:
    bbs pdr6:4, lab_d5fb    ;d5f2  bc 11 06     SCA_SWITCH
    bbs pdr6:4, lab_d5fb    ;d5f5  bc 11 03     SCA_SWITCH

lab_d5f8:
    jmp lab_d57a            ;d5f8  21 d5 7a

lab_d5fb:
    bbc pdr6:4, lab_d5f2    ;d5fb  b4 11 f4     SCA_SWITCH
    bbc pdr6:4, lab_d5f2    ;d5fe  b4 11 f1     SCA_SWITCH
    jmp lab_d61c            ;d601  21 d6 1c

lab_d604:
    bbc pdr6:4, lab_d60d    ;d604  b4 11 06     SCA_SWITCH
    bbc pdr6:4, lab_d60d    ;d607  b4 11 03     SCA_SWITCH
    jmp lab_d57a            ;d60a  21 d5 7a

lab_d60d:
    bbs pdr6:4, lab_d604    ;d60d  bc 11 f4     SCA_SWITCH
    bbs pdr6:4, lab_d604    ;d610  bc 11 f1     SCA_SWITCH
    jmp lab_d61c            ;d613  21 d6 1c

lab_d616:
    mov a, mem_00f7         ;d616  05 f7
    and a, #0x02            ;d618  64 02
    bne lab_d5f8            ;d61a  fc dc

lab_d61c:
    call sub_d801           ;d61c  31 d8 01
    jmp lab_d4db            ;d61f  21 d4 db

lab_d622:
    mov a, mem_00f7         ;d622  05 f7
    and a, #0x02            ;d624  64 02
    beq lab_d5f8            ;d626  fd d0
    jmp lab_d61c            ;d628  21 d6 1c

lab_d62b:
    mov a, #0x00            ;d62b  04 00
    mov mem_02fd, a         ;d62d  61 02 fd
    mov a, mem_00f7         ;d630  05 f7
    and a, #0xc8            ;d632  64 c8
    or a, #0x03             ;d634  74 03
    mov mem_00f7, a         ;d636  45 f7
    jmp lab_d4db            ;d638  21 d4 db

lab_d63b:
    movw a, mem_035b        ;d63b  c4 03 5b
    call sub_d804           ;d63e  31 d8 04
    mov a, @a               ;d641  92
    mov mem_034f, a         ;d642  61 03 4f
    mov a, #0x00            ;d645  04 00
    mov mem_034e, a         ;d647  61 03 4e
    mov a, #0xc8            ;d64a  04 c8
    mov mem_0364, a         ;d64c  61 03 64
    call sub_d9d0           ;d64f  31 d9 d0
    jmp lab_d4db            ;d652  21 d4 db

lab_d655:
    movw a, #mem_d7b5       ;d655  e4 d7 b5
    call sub_d80e           ;d658  31 d8 0e
    movw mem_0360, a        ;d65b  d4 03 60
    jmp lab_d4db            ;d65e  21 d4 db

lab_d661:
    movw a, #mem_d7d5       ;d661  e4 d7 d5
    call sub_d80e           ;d664  31 d8 0e
    movw mem_0362, a        ;d667  d4 03 62
    clrb mem_00f8:1         ;d66a  a1 f8
    jmp lab_d4db            ;d66c  21 d4 db

lab_d66f:
    movw a, #mem_d7e1       ;d66f  e4 d7 e1
    call sub_d80e           ;d672  31 d8 0e
    jmp @a                  ;d675  e0

lab_d676:
    mov a, mem_00f7         ;d676  05 f7
    and a, #0xfb            ;d678  64 fb
    mov mem_00f7, a         ;d67a  45 f7
    bbc pdr3:7, lab_d685    ;d67c  b7 0c 06     SCA_METAL
    mov a, mem_00f7         ;d67f  05 f7
    or a, #0x04             ;d681  74 04
    mov mem_00f7, a         ;d683  45 f7

lab_d685:
    mov a, mem_02fd         ;d685  60 02 fd
    bne lab_d694            ;d688  fc 0a
    mov a, #0x03            ;d68a  04 03
    bbc mem_00f7:2, lab_d691 ;d68c  b2 f7 02
    mov a, #0x01            ;d68f  04 01

lab_d691:
    mov mem_02fd, a         ;d691  61 02 fd

lab_d694:
    mov a, mem_00f7         ;d694  05 f7
    and a, #0x80            ;d696  64 80
    cmp a, #0x80            ;d698  14 80
    bne lab_d6a1            ;d69a  fc 05
    clrb mem_00f7:7         ;d69c  a7 f7
    jmp lab_d57a            ;d69e  21 d5 7a

lab_d6a1:
    jmp lab_d61c            ;d6a1  21 d6 1c

lab_d6a4:
    call sub_d81f           ;d6a4  31 d8 1f
    and a, #0xb0            ;d6a7  64 b0
    mov a, mem_00f6         ;d6a9  05 f6
    and a, #0xb0            ;d6ab  64 b0
    xor a                   ;d6ad  52
    beq lab_d6bc            ;d6ae  fd 0c

lab_d6b0:
    call sub_d801           ;d6b0  31 d8 01
    jmp lab_d4dd            ;d6b3  21 d4 dd

lab_d6b6:
    call sub_d830           ;d6b6  31 d8 30
    jmp lab_d4db            ;d6b9  21 d4 db

lab_d6bc:
    jmp lab_d57a            ;d6bc  21 d5 7a

lab_d6bf:
    call sub_d81f           ;d6bf  31 d8 1f
    mov a, mem_00f8         ;d6c2  05 f8
    and a                   ;d6c4  62
    beq lab_d6b0            ;d6c5  fd e9
    jmp lab_d57a            ;d6c7  21 d5 7a

lab_d6ca:
    call sub_d81f           ;d6ca  31 d8 1f
    mov mem_0367, a         ;d6cd  61 03 67
    jmp lab_d4db            ;d6d0  21 d4 db

lab_d6d3:
    mov a, mem_0367         ;d6d3  60 03 67
    beq lab_d6e3            ;d6d6  fd 0b
    mov mem_034b, a         ;d6d8  61 03 4b
    mov a, #0x00            ;d6db  04 00
    mov mem_0367, a         ;d6dd  61 03 67
    jmp lab_d4db            ;d6e0  21 d4 db

lab_d6e3:
    call sub_d8ba           ;d6e3  31 d8 ba
    jmp lab_d4db            ;d6e6  21 d4 db

lab_d6e9:
    movw a, #mem_0369       ;d6e9  e4 03 69
    call sub_d827           ;d6ec  31 d8 27
    jmp lab_d4dd            ;d6ef  21 d4 dd

lab_d6f2:
    movw a, #0x00cc         ;d6f2  e4 00 cc
    call sub_d827           ;d6f5  31 d8 27
    jmp lab_d4db            ;d6f8  21 d4 db

lab_d6fb:
    mov a, mem_00f6         ;d6fb  05 f6
    and a, #0x0f            ;d6fd  64 0f
    xor a, #0x03            ;d6ff  54 03
    beq lab_d6bc            ;d701  fd b9
    jmp lab_d6b0            ;d703  21 d6 b0

lab_d706:
    movw a, mem_0381        ;d706  c4 03 81
    bne lab_d73d            ;d709  fc 32
    mov a, mem_00f6         ;d70b  05 f6
    and a, #0x0f            ;d70d  64 0f
    cmp a, #0x03            ;d70f  14 03
    beq lab_d730            ;d711  fd 1d
    cmp a, #0x02            ;d713  14 02
    bne lab_d73d            ;d715  fc 26
    mov a, mem_036a         ;d717  60 03 6a
    bne lab_d726            ;d71a  fc 0a
    bbs mem_00f8:3, lab_d73d ;d71c  bb f8 1e
    mov a, #0x01            ;d71f  04 01
    mov mem_036a, a         ;d721  61 03 6a
    bne lab_d73d            ;d724  fc 17        BRANCH_ALWAYS_TAKEN

lab_d726:
    cmp a, #0x01            ;d726  14 01
    bne lab_d73d            ;d728  fc 13
    bbc mem_00f8:3, lab_d73d ;d72a  b3 f8 10
    jmp lab_d57a            ;d72d  21 d5 7a

lab_d730:
    mov a, mem_036a         ;d730  60 03 6a
    bne lab_d743            ;d733  fc 0e
    bbc mem_00f8:3, lab_d73d ;d735  b3 f8 05
    mov a, #0x01            ;d738  04 01
    mov mem_036a, a         ;d73a  61 03 6a

lab_d73d:
    call sub_d801           ;d73d  31 d8 01
    jmp lab_d4db            ;d740  21 d4 db

lab_d743:
    cmp a, #0x01            ;d743  14 01
    bne lab_d73d            ;d745  fc f6
    bbs mem_00f8:3, lab_d73d ;d747  bb f8 f3
    jmp lab_d57a            ;d74a  21 d5 7a

lab_d74d:
    mov a, #0x00            ;d74d  04 00
    mov mem_036a, a         ;d74f  61 03 6a
    mov a, mem_00f6         ;d752  05 f6
    and a, #0xf0            ;d754  64 f0
    cmp a, #0x10            ;d756  14 10
    beq lab_d75e            ;d758  fd 04
    cmp a, #0x50            ;d75a  14 50
    bne lab_d77c            ;d75c  fc 1e

lab_d75e:
    mov a, mem_0369         ;d75e  60 03 69
    cmp a, #0x38            ;d761  14 38        ;TODO 0x38 = 56 is this KW1281 address?
    beq lab_d776            ;d763  fd 11
    cmp a, #0x50            ;d765  14 50
    beq lab_d776            ;d767  fd 0d
    cmp a, #0x42            ;d769  14 42
    beq lab_d771            ;d76b  fd 04
    cmp a, #0x46            ;d76d  14 46
    bne lab_d77c            ;d76f  fc 0b

lab_d771:
;(mem_0369 = 0x42)
    movw a, #0x0190         ;d771  e4 01 90
    bne lab_d779            ;d774  fc 03        BRANCH_ALWAYS_TAKEN

lab_d776:
;(mem_0369 = 0x38, #0x50)
    movw a, #0x0190         ;d776  e4 01 90

lab_d779:
    movw mem_0381, a        ;d779  d4 03 81

lab_d77c:
    jmp lab_d4db            ;d77c  21 d4 db

lab_d77f:
    mov a, mem_0368         ;d77f  60 03 68
    beq lab_d78b            ;d782  fd 07
    decw a                  ;d784  d0
    mov mem_0368, a         ;d785  61 03 68

lab_d788:
    jmp lab_d61c            ;d788  21 d6 1c

lab_d78b:
    mov a, #0x02            ;d78b  04 02
    mov mem_0368, a         ;d78d  61 03 68
    bne lab_d7a3            ;d790  fc 11        BRANCH_ALWAYS_TAKEN

lab_d792:
    mov a, mem_036d         ;d792  60 03 6d
    beq lab_d79e            ;d795  fd 07
    decw a                  ;d797  d0
    mov mem_036d, a         ;d798  61 03 6d
    jmp lab_d788            ;d79b  21 d7 88

lab_d79e:
    mov a, #0x02            ;d79e  04 02
    mov mem_036d, a         ;d7a0  61 03 6d

lab_d7a3:
    jmp lab_d57a            ;d7a3  21 d5 7a

lab_d7a6:
    call sub_d84e           ;d7a6  31 d8 4e
    jmp lab_d4db            ;d7a9  21 d4 db

lab_d7ac:
    movw a, #0x0308         ;d7ac  e4 03 08
    call sub_d827           ;d7af  31 d8 27
    jmp lab_d4db            ;d7b2  21 d4 db

mem_d7b5:
    .byte 0x00              ;d7b5  00          DATA '\x00'
    .byte 0x05              ;d7b6  05          DATA '\x05'
    .byte 0x00              ;d7b7  00          DATA '\x00'
    .byte 0x0C              ;d7b8  0c          DATA '\x0c'
    .byte 0x00              ;d7b9  00          DATA '\x00'
    .byte 0x14              ;d7ba  14          DATA '\x14'
    .byte 0x00              ;d7bb  00          DATA '\x00'
    .byte 0x19              ;d7bc  19          DATA '\x19'
    .byte 0x00              ;d7bd  00          DATA '\x00'
    .byte 0x32              ;d7be  32          DATA '2'
    .byte 0x00              ;d7bf  00          DATA '\x00'
    .byte 0x64              ;d7c0  64          DATA 'd'
    .byte 0x00              ;d7c1  00          DATA '\x00'
    .byte 0x7D              ;d7c2  7d          DATA '}'
    .byte 0x00              ;d7c3  00          DATA '\x00'
    .byte 0x96              ;d7c4  96          DATA '\x96'
    .byte 0x00              ;d7c5  00          DATA '\x00'
    .byte 0xAF              ;d7c6  af          DATA '\xaf'
    .byte 0x00              ;d7c7  00          DATA '\x00'
    .byte 0xC8              ;d7c8  c8          DATA '\xc8'
    .byte 0x00              ;d7c9  00          DATA '\x00'
    .byte 0xFA              ;d7ca  fa          DATA '\xfa'
    .byte 0x01              ;d7cb  01          DATA '\x01'
    .byte 0x2C              ;d7cc  2c          DATA ','
    .byte 0x01              ;d7cd  01          DATA '\x01'
    .byte 0x90              ;d7ce  90          DATA '\x90'
    .byte 0x03              ;d7cf  03          DATA '\x03'
    .byte 0xE8              ;d7d0  e8          DATA '\xe8'
    .byte 0x06              ;d7d1  06          DATA '\x06'
    .byte 0x40              ;d7d2  40          DATA '@'
    .byte 0x13              ;d7d3  13          DATA '\x13'
    .byte 0x88              ;d7d4  88          DATA '\x88'

mem_d7d5:
    .byte 0x00              ;d7d5  00          DATA '\x00'
    .byte 0xC8              ;d7d6  c8          DATA '\xc8'
    .byte 0x03              ;d7d7  03          DATA '\x03'
    .byte 0xE8              ;d7d8  e8          DATA '\xe8'
    .byte 0x06              ;d7d9  06          DATA '\x06'
    .byte 0x40              ;d7da  40          DATA '@'
    .byte 0x13              ;d7db  13          DATA '\x13'
    .byte 0x88              ;d7dc  88          DATA '\x88'
    .byte 0x27              ;d7dd  27          DATA "'"
    .byte 0x10              ;d7de  10          DATA '\x10'
    .byte 0x3A              ;d7df  3a          DATA ':'
    .byte 0x98              ;d7e0  98          DATA '\x98'

mem_d7e1:
    .word lab_d7ac          ;d7e1  d7 ac       VECTOR
    .word lab_d792          ;d7e3  d7 92       VECTOR
    .word lab_d6bf          ;d7e5  d6 bf       VECTOR
    .word lab_d6ca          ;d7e7  d6 ca       VECTOR
    .word lab_d6d3          ;d7e9  d6 d3       VECTOR
    .word lab_d676          ;d7eb  d6 76       VECTOR
    .word lab_d6a4          ;d7ed  d6 a4       VECTOR
    .word lab_d6b6          ;d7ef  d6 b6       VECTOR
    .word lab_d6ca          ;d7f1  d6 ca       VECTOR
    .word lab_d6e9          ;d7f3  d6 e9       VECTOR
    .word lab_d6f2          ;d7f5  d6 f2       VECTOR
    .word lab_d6fb          ;d7f7  d6 fb       VECTOR
    .word lab_d706          ;d7f9  d7 06       VECTOR
    .word lab_d74d          ;d7fb  d7 4d       VECTOR
    .word lab_d77f          ;d7fd  d7 7f       VECTOR
    .word lab_d7a6          ;d7ff  d7 a6       VECTOR

sub_d801:
    call sub_d804           ;d801  31 d8 04

sub_d804:
    pushw a                 ;d804  40
    movw a, mem_035b        ;d805  c4 03 5b
    incw a                  ;d808  c0
    movw mem_035b, a        ;d809  d4 03 5b
    popw a                  ;d80c  50
    ret                     ;d80d  20

sub_d80e:
    pushw a                 ;d80e  40
    movw a, #0x0000         ;d80f  e4 00 00
    mov a, mem_0359         ;d812  60 03 59
    and a, #0x0f            ;d815  64 0f
    clrc                    ;d817  81
    rolc a                  ;d818  02
    xchw a, t               ;d819  43
    popw a                  ;d81a  50
    clrc                    ;d81b  81
    addcw a                 ;d81c  23
    movw a, @a              ;d81d  93
    ret                     ;d81e  20

sub_d81f:
    movw a, mem_035b        ;d81f  c4 03 5b
    call sub_d804           ;d822  31 d8 04
    mov a, @a               ;d825  92
    ret                     ;d826  20

sub_d827:
    pushw a                 ;d827  40
    call sub_d81f           ;d828  31 d8 1f
    mov a, #0x00            ;d82b  04 00
    popw a                  ;d82d  50
    mov @a, t               ;d82e  82
    ret                     ;d82f  20

sub_d830:
    call sub_d81f           ;d830  31 d8 1f
    mov mem_00f6, a         ;d833  45 f6

sub_d835:
    mov a, mem_00f6         ;d835  05 f6
    and a, #0xbf            ;d837  64 bf
    mov mem_00f6, a         ;d839  45 f6
    mov a, mem_00f7         ;d83b  05 f7
    and a, #0x02            ;d83d  64 02
    bne lab_d847            ;d83f  fc 06
    mov a, mem_00f6         ;d841  05 f6
    or a, #0x40             ;d843  74 40
    mov mem_00f6, a         ;d845  45 f6

lab_d847:
    ret                     ;d847  20

sub_d848:
    mov a, #0x02            ;d848  04 02
    mov mem_036d, a         ;d84a  61 03 6d
    ret                     ;d84d  20

sub_d84e:
    mov a, #0x02            ;d84e  04 02
    mov mem_0368, a         ;d850  61 03 68
    ret                     ;d853  20

sub_d854:
    pushw a                 ;d854  40
    clri                    ;d855  80
    mov a, mem_0356         ;d856  60 03 56
    call sub_d87b           ;d859  31 d8 7b
    mov a, mem_0357         ;d85c  60 03 57
    cmp a, #0x5b            ;d85f  14 5b
    beq lab_d86c            ;d861  fd 09
    cmp a, #0x47            ;d863  14 47
    beq lab_d86c            ;d865  fd 05
    movw a, #mem_0367       ;d867  e4 03 67
    bne lab_d86f            ;d86a  fc 03        BRANCH_ALWAYS_TAKEN

lab_d86c:
    movw a, #0x02c1         ;d86c  e4 02 c1

lab_d86f:
    decw a                  ;d86f  d0
    bne lab_d86f            ;d870  fc fd
    mov a, mem_0357         ;d872  60 03 57
    call sub_d87b           ;d875  31 d8 7b
    seti                    ;d878  90
    popw a                  ;d879  50
    ret                     ;d87a  20

sub_d87b:
    clrb eic2:4             ;d87b  a4 39        Disable INT3 pin edge detect interrupt (/SCA_CLK_IN)
    pushw a                 ;d87d  40
    mov mem_0355, a         ;d87e  61 03 55
    setb pdr8:3             ;d881  ab 14        /SCA_CLK_OUT=high
    clrb pdr0:1             ;d883  a1 00        /SCA_ENABLE
    mov a, #0x08            ;d885  04 08
    mov mem_0358, a         ;d887  61 03 58

lab_d88a:
    mov a, mem_0355         ;d88a  60 03 55
    rorc a                  ;d88d  03
    mov mem_0355, a         ;d88e  61 03 55
    bhs lab_d8b5            ;d891  f8 22
    setb pdr7:1             ;d893  a9 13        SCA_DATA=high
    jmp lab_d898            ;d895  21 d8 98

lab_d898:
    mulu a                  ;d898  01
    clrb pdr8:3             ;d899  a3 14        /SCA_CLK_OUT=low
    mulu a                  ;d89b  01
    mov a, mem_0358         ;d89c  60 03 58
    decw a                  ;d89f  d0
    mov mem_0358, a         ;d8a0  61 03 58
    setb pdr8:3             ;d8a3  ab 14        /SCA_CLK_OUT=high
    mov a, mem_0358         ;d8a5  60 03 58
    bne lab_d88a            ;d8a8  fc e0
    setb pdr0:1             ;d8aa  a9 00        /SCA_ENABLE=high
    mulu a                  ;d8ac  01
    popw a                  ;d8ad  50
    setb pdr7:1             ;d8ae  a9 13        SCA_DATA=high
    clrb eic2:7             ;d8b0  a7 39        Clear INT3 pin edge detect status (/SCA_CLK_IN)
    setb eic2:4             ;d8b2  ac 39        Enable INT3 pin edge detect interrupt (/SCA_CLK_IN)
    ret                     ;d8b4  20

lab_d8b5:
    clrb pdr7:1             ;d8b5  a1 13        SCA_DATA=low
    jmp lab_d898            ;d8b7  21 d8 98

sub_d8ba:
    pushw a                 ;d8ba  40
    mov a, mem_034a         ;d8bb  60 03 4a
    beq lab_d8de            ;d8be  fd 1e
    decw a                  ;d8c0  d0
    mov mem_034a, a         ;d8c1  61 03 4a
    movw a, #0x0000         ;d8c4  e4 00 00
    mov a, mem_034c         ;d8c7  60 03 4c
    movw a, #mem_036e       ;d8ca  e4 03 6e
    clrc                    ;d8cd  81
    addcw a                 ;d8ce  23
    mov a, @a               ;d8cf  92
    mov mem_034b, a         ;d8d0  61 03 4b
    mov a, mem_034c         ;d8d3  60 03 4c
    incw a                  ;d8d6  c0
    and a, #0x0f            ;d8d7  64 0f
    mov mem_034c, a         ;d8d9  61 03 4c
    popw a                  ;d8dc  50
    ret                     ;d8dd  20

lab_d8de:
    mov mem_034b, a         ;d8de  61 03 4b
    popw a                  ;d8e1  50
    ret                     ;d8e2  20

sub_d8e3:
    pushw a                 ;d8e3  40
    mov a, mem_0349         ;d8e4  60 03 49
    beq lab_d90f            ;d8e7  fd 26
    mov a, mem_034a         ;d8e9  60 03 4a
    incw a                  ;d8ec  c0
    mov mem_034a, a         ;d8ed  61 03 4a
    movw a, #0x0000         ;d8f0  e4 00 00
    mov a, mem_034d         ;d8f3  60 03 4d
    movw a, #mem_036e         ;d8f6  e4 03 6e
    clrc                    ;d8f9  81
    addcw a                 ;d8fa  23
    pushw a                 ;d8fb  40
    mov a, mem_0349         ;d8fc  60 03 49
    mov a, #0x00            ;d8ff  04 00
    mov mem_0349, a         ;d901  61 03 49
    popw a                  ;d904  50
    mov @a, t               ;d905  82
    mov a, mem_034d         ;d906  60 03 4d
    incw a                  ;d909  c0
    and a, #0x0f            ;d90a  64 0f
    mov mem_034d, a         ;d90c  61 03 4d

lab_d90f:
    popw a                  ;d90f  50
    ret                     ;d910  20

sub_d911:
    pushw a                 ;d911  40
    movw a, mem_0381        ;d912  c4 03 81
    beq lab_d941            ;d915  fd 2a
    decw a                  ;d917  d0
    movw mem_0381, a        ;d918  d4 03 81
    bne lab_d97a            ;d91b  fc 5d
    mov a, mem_00f6         ;d91d  05 f6
    cmp a, #0x12            ;d91f  14 12
    beq lab_d92f            ;d921  fd 0c
    cmp a, #0x52            ;d923  14 52
    beq lab_d92f            ;d925  fd 08
    cmp a, #0x13            ;d927  14 13
    beq lab_d934            ;d929  fd 09
    cmp a, #0x53            ;d92b  14 53
    beq lab_d934            ;d92d  fd 05

lab_d92f:
    setb mem_00f8:3         ;d92f  ab f8
    jmp lab_d936            ;d931  21 d9 36

lab_d934:
    clrb mem_00f8:3         ;d934  a3 f8

lab_d936:
    mov a, #0x00            ;d936  04 00
    mov mem_0352, a         ;d938  61 03 52
    mov mem_0351, a         ;d93b  61 03 51
    mov mem_036a, a         ;d93e  61 03 6a

lab_d941:
    bbc pdr3:4, lab_d95f    ;d941  b4 0c 1b     APC_DET
    mov a, #0x00            ;d944  04 00
    mov mem_0352, a         ;d946  61 03 52
    mov a, mem_0351         ;d949  60 03 51
    cmp a, #0x0c            ;d94c  14 0c
    beq lab_d957            ;d94e  fd 07
    incw a                  ;d950  c0
    mov mem_0351, a         ;d951  61 03 51
    jmp lab_d97a            ;d954  21 d9 7a

lab_d957:
    mov a, mem_00f8         ;d957  05 f8
    and a, #0xef            ;d959  64 ef
    or a, #0x08             ;d95b  74 08
    bne lab_d978            ;d95d  fc 19

lab_d95f:
    mov a, #0x00            ;d95f  04 00
    mov mem_0351, a         ;d961  61 03 51
    mov a, mem_0352         ;d964  60 03 52
    cmp a, #0x0c            ;d967  14 0c
    beq lab_d972            ;d969  fd 07
    incw a                  ;d96b  c0
    mov mem_0352, a         ;d96c  61 03 52
    jmp lab_d97a            ;d96f  21 d9 7a

lab_d972:
    mov a, mem_00f8         ;d972  05 f8
    and a, #0xf7            ;d974  64 f7
    or a, #0x10             ;d976  74 10

lab_d978:
    mov mem_00f8, a         ;d978  45 f8

lab_d97a:
    popw a                  ;d97a  50
    ret                     ;d97b  20

sub_d97c:
    pushw a                 ;d97c  40
    setb pdr7:1             ;d97d  a9 13        SCA_DATA=high
    bbs pdr7:1, lab_d990    ;d97f  b9 13 0e     SCA_DATA
    mov a, mem_0350         ;d982  60 03 50
    cmp a, #0x0a            ;d985  14 0a
    beq lab_d99f            ;d987  fd 16
    incw a                  ;d989  c0
    mov mem_0350, a         ;d98a  61 03 50
    jmp lab_d99d            ;d98d  21 d9 9d

lab_d990:
    clrb mem_00f8:2         ;d990  a2 f8
    mov a, mem_00f7         ;d992  05 f7
    and a, #0xdf            ;d994  64 df
    mov mem_00f7, a         ;d996  45 f7
    mov a, #0x00            ;d998  04 00
    mov mem_0350, a         ;d99a  61 03 50

lab_d99d:
    popw a                  ;d99d  50
    ret                     ;d99e  20

lab_d99f:
    setb mem_00f8:2         ;d99f  aa f8
    mov a, mem_00f7         ;d9a1  05 f7
    or a, #0x20             ;d9a3  74 20
    mov mem_00f7, a         ;d9a5  45 f7
    jmp lab_d99d            ;d9a7  21 d9 9d

sub_d9aa:
    pushw a                 ;d9aa  40
    mov a, mem_00f8         ;d9ab  05 f8
    and a, #0xbf            ;d9ad  64 bf
    bbs mem_00de:1, lab_d9b5 ;d9af  b9 de 03
    bbc mem_00d7:4, lab_d9b7 ;d9b2  b4 d7 02

lab_d9b5:
    or a, #0x40             ;d9b5  74 40

lab_d9b7:
    mov mem_00f8, a         ;d9b7  45 f8
    clrb mem_00f8:5         ;d9b9  a5 f8
    cmp mem_0095, #0x01     ;d9bb  95 95 01
    beq lab_d9c2            ;d9be  fd 02
    setb mem_00f8:5         ;d9c0  ad f8

lab_d9c2:
    popw a                  ;d9c2  50
    ret                     ;d9c3  20


sub_d9c4:
;Called from ISR for IRQ0 (external interrupt 1)
;when INT3 pin edge detect status changes (/SCA_CLK_IN)
    pushw a                 ;d9c4  40
    mov a, mem_034e         ;d9c5  60 03 4e
    beq lab_d9ce            ;d9c8  fd 04
    decw a                  ;d9ca  d0
    mov mem_034e, a         ;d9cb  61 03 4e
lab_d9ce:
    popw a                  ;d9ce  50
    ret                     ;d9cf  20


sub_d9d0:
    clrb mem_00f8:0         ;d9d0  a0 f8
    ret                     ;d9d2  20

sub_d9d3:
    cmp mem_0095, #0x01     ;d9d3  95 95 01
    beq lab_d9da            ;d9d6  fd 02
    clrb pdr3:5             ;d9d8  a5 0c        /TAPE_DOLBY_ON=low

lab_d9da:
    call sub_daae           ;d9da  31 da ae
    call sub_da01           ;d9dd  31 da 01
    call sub_da0c           ;d9e0  31 da 0c
    call sub_da24           ;d9e3  31 da 24
    call sub_da9b           ;d9e6  31 da 9b
    call sub_daba           ;d9e9  31 da ba
    mov a, mem_00e9         ;d9ec  05 e9
    cmp a, #0xff            ;d9ee  14 ff
    bne lab_d9f5            ;d9f0  fc 03

lab_d9f2:
    setb pdr2:4             ;d9f2  ac 04        unmute audio=high
    ret                     ;d9f4  20

lab_d9f5:
    bbc mem_008c:7, lab_d9fb ;d9f5  b7 8c 03
    bbs mem_008d:6, lab_d9f2 ;d9f8  be 8d f7

lab_d9fb:
    bbs mem_00af:1, lab_d9f2 ;d9fb  b9 af f4
    clrb pdr2:4             ;d9fe  a4 04        mute audio=low
    ret                     ;da00  20

sub_da01:
    bbc mem_008c:7, lab_da09 ;da01  b7 8c 05
    clrb mem_00e9:5         ;da04  a5 e9
    bbc mem_008d:6, lab_da0b ;da06  b6 8d 02

lab_da09:
    setb mem_00e9:5         ;da09  ad e9

lab_da0b:
    ret                     ;da0b  20

sub_da0c:
    cmp mem_0095, #0x00     ;da0c  95 95 00
    bne lab_da1e            ;da0f  fc 0d
    cmp mem_00c1, #0x01     ;da11  95 c1 01
    beq lab_da21            ;da14  fd 0b
    cmp mem_00c1, #0x02     ;da16  95 c1 02
    bne lab_da20            ;da19  fc 05
    bbc mem_00c9:6, lab_da20 ;da1b  b6 c9 02

lab_da1e:
    setb mem_00e9:0         ;da1e  a8 e9

lab_da20:
    ret                     ;da20  20

lab_da21:
    clrb mem_00e9:0         ;da21  a0 e9
    ret                     ;da23  20

sub_da24:
    mov a, mem_00cc         ;da24  05 cc

    cmp a, #0x01            ;da26  14 01
    beq lab_da57            ;da28  fd 2d

    cmp a, #0x02            ;da2a  14 02
    beq lab_da57            ;da2c  fd 29

    cmp a, #0x03            ;da2e  14 03
    beq lab_da57            ;da30  fd 25

    cmp mem_0095, #0x01     ;da32  95 95 01
    bne lab_da7d            ;da35  fc 46

    bbs mem_00f7:6, lab_da57 ;da37  be f7 1d

    mov a, mem_00cc         ;da3a  05 cc

    cmp a, #0x04            ;da3c  14 04
    beq lab_da86            ;da3e  fd 46

    cmp a, #0x05            ;da40  14 05
    beq lab_da86            ;da42  fd 42

    cmp a, #0x15            ;da44  14 15
    beq lab_da86            ;da46  fd 3e

    cmp a, #0x1d            ;da48  14 1d
    beq lab_da86            ;da4a  fd 3a

    cmp a, #0x1e            ;da4c  14 1e
    beq lab_da86            ;da4e  fd 36

    mov a, mem_0369         ;da50  60 03 69

    cmp a, #0x05            ;da53  14 05
    beq lab_da6c            ;da55  fd 15

lab_da57:
    mov a, mem_031d         ;da57  60 03 1d
    bne lab_da6b            ;da5a  fc 0f
    clrb mem_00e9:1         ;da5c  a1 e9
    setb pdr2:1             ;da5e  a9 04        /TAPE_ON=high
    ret                     ;da60  20

lab_da61:
    mov a, mem_032b         ;da61  60 03 2b
    bne lab_da6b            ;da64  fc 05
    mov a, #0x0a            ;da66  04 0a
    mov mem_032b, a         ;da68  61 03 2b

lab_da6b:
    ret                     ;da6b  20

lab_da6c:
    mov a, mem_0308         ;da6c  60 03 08
    cmp a, #0x01            ;da6f  14 01
    beq lab_da86            ;da71  fd 13
    call sub_9e34           ;da73  31 9e 34
    mov a, #0x00            ;da76  04 00
    mov mem_033a, a         ;da78  61 03 3a
    beq lab_da86            ;da7b  fd 09        BRANCH_ALWAYS_TAKEN

lab_da7d:
    cmp mem_0095, #0x0f     ;da7d  95 95 0f
    beq lab_da86            ;da80  fd 04
    setb mem_00e9:1         ;da82  a9 e9
    bne lab_da61            ;da84  fc db        BRANCH_ALWAYS_TAKEN

lab_da86:
    bbs mem_00d7:6, lab_da96 ;da86  be d7 0d
    clrb pdr2:1             ;da89  a1 04        /TAPE_ON=low
    mov a, mem_032a         ;da8b  60 03 2a
    bne lab_da95            ;da8e  fc 05
    mov a, #0x0a            ;da90  04 0a
    mov mem_032a, a         ;da92  61 03 2a

lab_da95:
    ret                     ;da95  20

lab_da96:
    setb pdr2:1             ;da96  a9 04        /TAPE_ON=high
    setb mem_00e9:1         ;da98  a9 e9
    ret                     ;da9a  20

sub_da9b:
    bbc mem_00ca:6, lab_daab ;da9b  b6 ca 0d
    setb mem_00e9:2         ;da9e  aa e9
    cmp mem_0095, #0x02     ;daa0  95 95 02
    bne lab_daad            ;daa3  fc 08
    bbc mem_00ca:6, lab_daab ;daa5  b6 ca 03
    bbs mem_00d9:7, lab_daad ;daa8  bf d9 02

lab_daab:
    clrb mem_00e9:2         ;daab  a2 e9

lab_daad:
    ret                     ;daad  20

sub_daae:
    clrb mem_00e9:3         ;daae  a3 e9
    mov a, mem_0293         ;dab0  60 02 93
    beq lab_dab9            ;dab3  fd 04
    setb mem_00e9:3         ;dab5  ab e9
    clrb mem_00b2:3         ;dab7  a3 b2

lab_dab9:
    ret                     ;dab9  20

sub_daba:
    clrb mem_00e9:7         ;daba  a7 e9
    bbs mem_00e3:7, lab_dacb ;dabc  bf e3 0c
    movw ix, #mem_dacc      ;dabf  e6 da cc
    mov a, mem_0096         ;dac2  05 96
    call sub_e76c           ;dac4  31 e7 6c
    blo lab_dacb            ;dac7  f9 02
    setb mem_00e9:7         ;dac9  af e9

lab_dacb:
    ret                     ;dacb  20

mem_dacc:
;Lookup table used with sub_e76c
    .byte 0x03              ;dacc  03          DATA '\x03'
    .byte 0x02              ;dacd  02          DATA '\x02'
    .byte 0x04              ;dace  04          DATA '\x04'
    .byte 0x01              ;dacf  01          DATA '\x01'
    .byte 0x05              ;dad0  05          DATA '\x05'
    .byte 0x09              ;dad1  09          DATA '\t'
    .byte 0xFF              ;dad2  ff          DATA '\xff'

sub_dad3:
    call sub_dc4e           ;dad3  31 dc 4e
    call sub_dcde           ;dad6  31 dc de
    jmp lab_dadf            ;dad9  21 da df

lab_dadc:
    call sub_dc4e           ;dadc  31 dc 4e

lab_dadf:
    setb mem_00eb:6         ;dadf  ae eb
    bbs pdr6:6, lab_daf5    ;dae1  be 11 11     branch if /ACC_IN = high
    clrb mem_00eb:6         ;dae4  a6 eb
    bbc mem_00ed:2, lab_daf5 ;dae6  b2 ed 0c
    setb mem_00eb:0         ;dae9  a8 eb
    mov a, mem_0182         ;daeb  60 01 82
    mov a, #0x12            ;daee  04 12
    cmp a                   ;daf0  12
    bne lab_db43            ;daf1  fc 50
    clrb mem_00eb:0         ;daf3  a0 eb

lab_daf5:
    mov sycc, #0x14         ;daf5  85 07 14
    cmpw a                  ;daf8  13
    mov a, mem_0182         ;daf9  60 01 82
    mov a, #0x12            ;dafc  04 12
    cmp a                   ;dafe  12
    bne lab_db07            ;daff  fc 06
    mov ilr3, #0xff         ;db01  85 7e ff
    mov tbtc, #0x38         ;db04  85 0a 38

lab_db07:
    mov a, mem_0182         ;db07  60 01 82
    mov a, #0x12            ;db0a  04 12
    cmp a                   ;db0c  12
    bne lab_db1a            ;db0d  fc 0b
    mov a, #0x00            ;db0f  04 00
    mov mem_0182, a         ;db11  61 01 82
    mov mem_0302, a         ;db14  61 03 02
    mov mem_0183, a         ;db17  61 01 83

lab_db1a:
    mov eic1, #0x05         ;db1a  85 38 05
    mov stbc, #0x90         ;db1d  85 08 90
    cmpw a                  ;db20  13
    mov a, #0x00            ;db21  04 00
    mov mem_0308, a         ;db23  61 03 08

    bbc eic1:3, lab_db31    ;db26  b3 38 08     Branch if edge not detected on INT0 pin (/VOLUME_IN)
    clrb eic1:3             ;db29  a3 38        Clear INT0 edge detect status (/VOLUME_IN)
    call sub_db91           ;db2b  31 db 91
    jmp lab_dadc            ;db2e  21 da dc

lab_db31:
    bbc eic2:3, lab_db3b    ;db31  b3 39 07     Branch if edge not detected on INT2 pin (/DIAG_RX)
    mov a, #0x3c            ;db34  04 3c
    mov mem_02ff, a         ;db36  61 02 ff
    bne lab_db48            ;db39  fc 0d        BRANCH_ALWAYS_TAKEN

lab_db3b:
    mov a, eif2             ;db3b  05 3b
    and a, #0x0d            ;db3d  64 0d
    beq lab_dadc            ;db3f  fd 9b
    mov mem_00a4, a         ;db41  45 a4

lab_db43:
    mov a, #0x10            ;db43  04 10
    mov mem_02ff, a         ;db45  61 02 ff

lab_db48:
    setb pdr2:7             ;db48  af 04        MAIN_5V=high
    mov sycc, #0x17         ;db4a  85 07 17
    cmpw a                  ;db4d  13
    clrb eic2:3             ;db4e  a3 39        Clear INT2 pin edge detect status (/DIAG_RX)
    mov eif2, #0x00         ;db50  85 3b 00
    clrb mem_00d7:6         ;db53  a6 d7
    call sub_dcb5           ;db55  31 dc b5
    callv #7                ;db58  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    movw a, #0x0802         ;db59  e4 08 02

lab_db5c:
    decw a                  ;db5c  d0
    bne lab_db5c            ;db5d  fc fd
    call sub_93cf           ;db5f  31 93 cf
    call sub_93fe           ;db62  31 93 fe
    clrb mem_00e0:7         ;db65  a7 e0
    mov a, #0x00            ;db67  04 00
    mov mem_00ce, a         ;db69  45 ce
    mov mem_01c7, a         ;db6b  61 01 c7
    mov mem_01ce, a         ;db6e  61 01 ce
    mov mem_03d0, a         ;db71  61 03 d0
    clrb mem_00e0:2         ;db74  a2 e0
    clrb mem_00e0:3         ;db76  a3 e0
    clrb mem_00da:6         ;db78  a6 da
    clrb mem_00da:7         ;db7a  a7 da
    clrb mem_00e1:5         ;db7c  a5 e1
    clrb mem_00e0:6         ;db7e  a6 e0
    clrb mem_00df:1         ;db80  a1 df
    clrb mem_00df:2         ;db82  a2 df
    mov a, mem_00a4         ;db84  05 a4
    and a, #0x01            ;db86  64 01
    bne lab_db8f            ;db88  fc 05
    mov a, #0x01            ;db8a  04 01
    mov mem_0384, a         ;db8c  61 03 84

lab_db8f:
    seti                    ;db8f  90
    ret                     ;db90  20

sub_db91:
    movw a, #0x0000         ;db91  e4 00 00
    mov a, mem_0214         ;db94  60 02 14
    beq lab_dbbc            ;db97  fd 23
    decw a                  ;db99  d0
    mov mem_0214, a         ;db9a  61 02 14
    bne lab_dbbc            ;db9d  fc 1d
    mov a, #0x02            ;db9f  04 02
    mov mem_0214, a         ;dba1  61 02 14
    bbc mem_00eb:6, lab_dbbc ;dba4  b6 eb 15
    movw a, #0x00bb         ;dba7  e4 00 bb
    movw mem_02b2, a        ;dbaa  d4 02 b2
    setb pdr4:7             ;dbad  af 0e        CATS_LED = high (led on)

lab_dbaf:
    cmp a                   ;dbaf  12
    cmp a                   ;dbb0  12
    movw a, mem_02b2        ;dbb1  c4 02 b2
    decw a                  ;dbb4  d0
    movw mem_02b2, a        ;dbb5  d4 02 b2
    bne lab_dbaf            ;dbb8  fc f5

sub_dbba:
    clrb pdr4:7             ;dbba  a7 0e        CATS_LED = off

lab_dbbc:
    ret                     ;dbbc  20

sub_dbbd:
    mov a, mem_0182         ;dbbd  60 01 82
    mov a, #0x12            ;dbc0  04 12
    cmp a                   ;dbc2  12
    bne lab_dc01            ;dbc3  fc 3c
    mov a, #0x00            ;dbc5  04 00
    mov mem_0302, a         ;dbc7  61 03 02
    mov mem_0183, a         ;dbca  61 01 83
    mov mem_00cc, a         ;dbcd  45 cc
    mov mem_0096, a         ;dbcf  45 96
    mov mem_01ef, a         ;dbd1  61 01 ef
    mov mem_00d2, a         ;dbd4  45 d2
    call sub_d9d0           ;dbd6  31 d9 d0
    call sub_87ae           ;dbd9  31 87 ae
    mov a, #0x0f            ;dbdc  04 0f
    mov mem_02c3, a         ;dbde  61 02 c3
    call sub_8eda           ;dbe1  31 8e da
    mov a, #0x01            ;dbe4  04 01
    mov mem_0336, a         ;dbe6  61 03 36
    setb mem_00d0:3         ;dbe9  ab d0
    clrb mem_00cf:5         ;dbeb  a5 cf
    movw a, #0x07d0         ;dbed  e4 07 d0
    movw mem_033b, a        ;dbf0  d4 03 3b
    clrb mem_00cf:0         ;dbf3  a0 cf
    clrb mem_00d7:5         ;dbf5  a5 d7
    clrb mem_0099:7         ;dbf7  a7 99
    clrb mem_00d7:4         ;dbf9  a4 d7
    call sub_91f1           ;dbfb  31 91 f1
    jmp lab_dc4b            ;dbfe  21 dc 4b

lab_dc01:
    mov a, mem_0369         ;dc01  60 03 69
    cmp a, #0x10            ;dc04  14 10
    beq lab_dc20            ;dc06  fd 18
    cmp a, #0x16            ;dc08  14 16
    beq lab_dc20            ;dc0a  fd 14
    cmp a, #0x65            ;dc0c  14 65
    beq lab_dc20            ;dc0e  fd 10
    cmp a, #0x03            ;dc10  14 03
    beq lab_dc21            ;dc12  fd 0d
    cmp a, #0x01            ;dc14  14 01
    beq lab_dc21            ;dc16  fd 09
    cmp a, #0x09            ;dc18  14 09
    beq lab_dc23            ;dc1a  fd 07
    cmp a, #0x71            ;dc1c  14 71
    beq lab_dc23            ;dc1e  fd 03

lab_dc20:
    ret                     ;dc20  20

lab_dc21:
    clrb mem_00cf:7         ;dc21  a7 cf

lab_dc23:
    movw a, mem_008f        ;dc23  c5 8f
    movw a, #0xffff         ;dc25  e4 ff ff
    cmpw a                  ;dc28  13
    bne lab_dc4d            ;dc29  fc 22

    mov a, mem_00d2         ;dc2b  05 d2
    bne lab_dc20            ;dc2d  fc f1
    .byte 0x60, 0x00, 0xfd  ;dc2f  60 00 fd     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00fd
    and a, #0xf0            ;dc32  64 f0
    bne lab_dc20            ;dc34  fc ea
    mov a, mem_00cf         ;dc36  05 cf
    bne lab_dc20            ;dc38  fc e6
    mov a, mem_00f1         ;dc3a  05 f1
    bne lab_dc20            ;dc3c  fc e2
    cmp mem_0096, #0x01     ;dc3e  95 96 01
    beq lab_dc20            ;dc41  fd dd
    bbs mem_00cf:4, lab_dc4d ;dc43  bc cf 07
    mov a, mem_02ff         ;dc46  60 02 ff
    bne lab_dc4d            ;dc49  fc 02

lab_dc4b:
    setb mem_00d0:6         ;dc4b  ae d0

lab_dc4d:
    ret                     ;dc4d  20

sub_dc4e:
    clri                    ;dc4e  80
    movw a, #0x0000         ;dc4f  e4 00 00
    mov tmcr, a             ;dc52  45 18
    movw t2cr, a            ;dc54  d5 24
    mov cntr, a             ;dc56  45 16
    movw cntr1, a           ;dc58  d5 28
    mov cntr3, a            ;dc5a  45 2a
    mov smr, a              ;dc5c  45 1c
    movw udcr1, a           ;dc5e  d5 30
    movw ccra1, a           ;dc60  d5 32
    movw ccrb1, a           ;dc62  d5 34
    movw csr1, a            ;dc64  d5 36
    mov adc1, a             ;dc66  45 20
    mov adc2, #0x01         ;dc68  85 21 01
    mov ilr1, #0xf0         ;dc6b  85 7c f0
    mov ilr2, #0xff         ;dc6e  85 7d ff
    mov ilr3, #0x3f         ;dc71  85 7e 3f
    mov eic1, #0x00         ;dc74  85 38 00
    mov eic2, #0x00         ;dc77  85 39 00
    bbs pdr6:6, lab_dc80    ;dc7a  be 11 03     branch if /ACC_IN = high
    mov eic2, #0b00000101   ;dc7d  85 39 05

lab_dc80:
    clrb mem_009e:0         ;dc80  a0 9e
    clrb mem_009e:4         ;dc82  a4 9e
    clrb mem_009e:2         ;dc84  a2 9e
    clrb mem_009e:6         ;dc86  a6 9e
    setb mem_009e:1         ;dc88  a9 9e
    bbc pdr6:4, lab_dc8f    ;dc8a  b4 11 02     SCA_SWITCH
    clrb mem_009e:1         ;dc8d  a1 9e

lab_dc8f:
    setb mem_009e:5         ;dc8f  ad 9e
    bbc mem_00eb:6, lab_dc96 ;dc91  b6 eb 02
    clrb mem_009e:5         ;dc94  a5 9e

lab_dc96:
    setb mem_009e:7         ;dc96  af 9e
    mov a, mem_0254         ;dc98  60 02 54
    rolc a                  ;dc9b  02
    bhs lab_dca0            ;dc9c  f8 02
    clrb mem_009e:7         ;dc9e  a7 9e

lab_dca0:
    setb mem_009e:3         ;dca0  ab 9e
    bbc pdr6:5, lab_dca7    ;dca2  b5 11 02     /SUB_ENABLE_IN
    clrb mem_009e:3         ;dca5  a3 9e

lab_dca7:
    setb mem_009e:0         ;dca7  a8 9e
    setb mem_009e:4         ;dca9  ac 9e
    setb mem_009e:6         ;dcab  ae 9e
    mov a, mem_009e         ;dcad  05 9e
    mov eie2, a             ;dcaf  45 3a
    mov eif2, #0x00         ;dcb1  85 3b 00
    ret                     ;dcb4  20

sub_dcb5:
    setb pdr0:1             ;dcb5  a9 00        /SCA_ENABLE=high
    mov ilr1, #0xe0         ;dcb7  85 7c e0
    mov ilr2, #0x0b         ;dcba  85 7d 0b
    mov ilr3, #0xbc         ;dcbd  85 7e bc
    mov tbtc, #0x00         ;dcc0  85 0a 00
    movw a, #0xf855         ;dcc3  e4 f8 55
    movw tchr, a            ;dcc6  d5 19        16-bit timer count register
    mov tmcr, #0x23         ;dcc8  85 18 23
    mov eic1, #0x37         ;dccb  85 38 37
    mov eic2, #0b01000000   ;dcce  85 39 40
    mov eie2, #0b00000010   ;dcd1  85 3a 02
    mov eif2, #0x00         ;dcd4  85 3b 00
    mov smr, #0x4f          ;dcd7  85 1c 4f
    call sub_acdb           ;dcda  31 ac db     UART transmit enabled, BRG enabled, rest disabled, send 0xFF
    ret                     ;dcdd  20

sub_dcde:
    clrb pdr2:5             ;dcde  a5 04        REM_AMP_ON=low
    clrb pdr8:4             ;dce0  a4 14        AMP_ON=low
    mulu a                  ;dce2  01
    mulu a                  ;dce3  01
    setb pdr2:1             ;dce4  a9 04        /TAPE_ON=high
    mov pdr0, #0x4d         ;dce6  85 00 4d
    mov ddr0, #0xb2         ;dce9  85 01 b2
    mov pdr1, #0x86         ;dcec  85 02 86
    mov ddr1, #0x79         ;dcef  85 03 79
    mov pdr3, #0x90         ;dcf2  85 0c 90
    mov ddr3, #0x6f         ;dcf5  85 0d 6f
    mov pdr4, #0x46         ;dcf8  85 0e 46
    mov ddr4, #0xb9         ;dcfb  85 0f b9
    mov pdr5, #0xff         ;dcfe  85 10 ff
    mov pdr7, #0x7e         ;dd01  85 13 7e
    call sub_acdb           ;dd04  31 ac db     UART transmit enabled, BRG enabled, rest disabled, send 0xFF
    mulu a                  ;dd07  01
    clrb pdr2:4             ;dd08  a4 04        mute audio=low
    mulu a                  ;dd0a  01
    mulu a                  ;dd0b  01
    clrb pdr2:1             ;dd0c  a1 04        /TAPE_ON=low
    mulu a                  ;dd0e  01
    mulu a                  ;dd0f  01
    mov pdr2, #0x00         ;dd10  85 04 00
    mov pdr6, #0xff         ;dd13  85 11 ff
    mov ppcr, #0x00         ;dd16  85 12 00
    mov pdr8, #0x68         ;dd19  85 14 68
    ret                     ;dd1c  20


bin16_to_bcd16:
;Convert 16-bit binary number to BCD.
;
;Input word:  mem_00a3
;Output word: mem_009f
;
    mov mem_009e, #0x00     ;dd1d  85 9e 00
    mov mem_009f, #0x00     ;dd20  85 9f 00
    mov mem_00a0, #0x00     ;dd23  85 a0 00

    mov mem_00a1, #16       ;dd26  85 a1 10
    movw ix, #bin_bcd_table ;dd29  e6 ff 63

lab_dd2c:
    mov a, mem_00a3         ;dd2c  05 a3
    rorc a                  ;dd2e  03
    mov mem_00a3, a         ;dd2f  45 a3

    mov a, mem_00a4         ;dd31  05 a4
    rorc a                  ;dd33  03
    mov mem_00a4, a         ;dd34  45 a4

    bnc lab_dd51            ;dd36  f8 19

    mov a, @ix+0            ;dd38  06 00
    mov a, mem_00a0         ;dd3a  05 a0
    clrc                    ;dd3c  81
    addc a                  ;dd3d  22
    daa                     ;dd3e  84
    mov mem_00a0, a         ;dd3f  45 a0

    mov a, @ix+16           ;dd41  06 10
    mov a, mem_009f         ;dd43  05 9f
    addc a                  ;dd45  22
    daa                     ;dd46  84
    mov mem_009f, a         ;dd47  45 9f

    mov a, @ix+32           ;dd49  06 20
    mov a, mem_009e         ;dd4b  05 9e
    addc a                  ;dd4d  22
    daa                     ;dd4e  84
    mov mem_009e, a         ;dd4f  45 9e

lab_dd51:
    incw ix                 ;dd51  c2

    movw a, #0x0000         ;dd52  e4 00 00
    mov a, mem_00a1         ;dd55  05 a1
    decw a                  ;dd57  d0
    mov mem_00a1, a         ;dd58  45 a1

    bne lab_dd2c            ;dd5a  fc d0
    ret                     ;dd5c  20


kw_no_ack_2:
    .byte 0x04              ;dd5d  04          DATA '\x04'  Block length
    .byte 0x00              ;dd5e  00          DATA '\x00'  Block counter
    .byte 0x0A              ;dd5f  0a          DATA '\n'    Block title (0x0a = No Acknowledge)
    .byte 0x00              ;dd60  00          DATA '\x00'
    .byte 0x03              ;dd61  03          DATA '\x03'  Block end

kw_ack_2:
;Appears unused
    .byte 0x03              ;dd62  03          DATA '\x03'  Block length
    .byte 0x00              ;dd63  00          DATA '\x00'  Block counter
    .byte 0x09              ;dd64  09          DATA '\t'    Block title (0x09 = Acknowledge)
    .byte 0x03              ;dd65  03          DATA '\x03'  Block end

kw_title_d7:
;Unknown KW1281 packet
    .byte 0x07              ;dd66  07          DATA '\x07'  Block length
    .byte 0x00              ;dd67  00          DATA '\x00'  Block counter
    .byte 0xD7              ;dd68  d7          DATA '\xd7'  Block title (0xd7 = Security access? TODO what is this?)
    .byte 0x00              ;dd69  00          DATA '\x00'
    .byte 0x00              ;dd6a  00          DATA '\x00'
    .byte 0x00              ;dd6b  00          DATA '\x00'
    .byte 0x00              ;dd6c  00          DATA '\x00'
    .byte 0x03              ;dd6d  03          DATA '\x03'  Block end

kw_end_session:
    .byte 0x03              ;dd6e  03          DATA '\x03'  Block length
    .byte 0x00              ;dd6f  00          DATA '\x00'  Block counter
    .byte 0x06              ;dd70  06          DATA '\x06'  Block title (0x06 = End Session)
    .byte 0x03              ;dd71  03          DATA '\x03'  Block end


sub_dd72:
    cmp mem_0096, #0x09     ;dd72  95 96 09
    beq lab_dda5            ;dd75  fd 2e
    bbs mem_00eb:6, lab_ddad ;dd77  be eb 33
    bbs mem_008c:7, lab_ddad ;dd7a  bf 8c 30
    mov a, mem_00fd         ;dd7d  05 fd
    and a, #0xf0            ;dd7f  64 f0
    cmp a, #0x00            ;dd81  14 00
    bne lab_dda5            ;dd83  fc 20
    mov a, mem_00fd         ;dd85  05 fd
    and a, #0x0f            ;dd87  64 0f
    bne lab_ddb1            ;dd89  fc 26
    bbc mem_00de:7, lab_dda5 ;dd8b  b7 de 17
    mov a, mem_03af         ;dd8e  60 03 af
    bne lab_dd96            ;dd91  fc 03
    bbc mem_00de:6, lab_dda5 ;dd93  b6 de 0f

lab_dd96:
    mov a, mem_0395         ;dd96  60 03 95
    cmp a, #0x15            ;dd99  14 15
    bhs lab_dda6            ;dd9b  f8 09
    mov a, #0x01            ;dd9d  04 01
    mov mem_039a, a         ;dd9f  61 03 9a
    call sub_ddee           ;dda2  31 dd ee

lab_dda5:
    ret                     ;dda5  20

lab_dda6:
    mov a, #0x01            ;dda6  04 01        A = value to store in mem_00fd low nibble
    call set_00fd_lo_nib    ;dda8  31 e3 ac     Store low nibble of A in mem_00fd low nibble
    callv #7                ;ddab  ef           CALLV #7 = callv7_e55c
                            ;                   Resets many KW1281 state variables
    ret                     ;ddac  20

lab_ddad:
    call set_00fd_hi_nib_0  ;ddad  31 e3 8a     Store 0x0 in mem_00fd high nibble
    ret                     ;ddb0  20

lab_ddb1:
    cmp a, #0x01            ;ddb1  14 01
    beq lab_dda5            ;ddb3  fd f0
    cmp a, #0x02            ;ddb5  14 02
    beq lab_dda5            ;ddb7  fd ec
    cmp a, #0x03            ;ddb9  14 03
    beq lab_dda5            ;ddbb  fd e8
    bne lab_dd96            ;ddbd  fc d7        BRANCH_ALWAYS_TAKEN

sub_ddbf:
    mov a, #0x01            ;ddbf  04 01
    mov mem_038f, a         ;ddc1  61 03 8f
    call sub_ddca           ;ddc4  31 dd ca
    jmp lab_ddf6            ;ddc7  21 dd f6

sub_ddca:
    movw a, #0x0000         ;ddca  e4 00 00
    mov mem_00f9, a         ;ddcd  45 f9
    mov mem_0388, a         ;ddcf  61 03 88
    mov mem_0385, a         ;ddd2  61 03 85
    mov mem_038b, a         ;ddd5  61 03 8b
    mov mem_00fb, a         ;ddd8  45 fb        KW1281 10416.67 bps transmit state = Do nothing
    mov mem_00fc, a         ;ddda  45 fc        XXX appears unused
    movw mem_038d, a        ;dddc  d4 03 8d
    movw mem_039d, a        ;dddf  d4 03 9d

    mov a, eic2             ;dde2  05 39
    and a, #0b11110000      ;dde4  64 f0
    or a,  #0b00000100      ;dde6  74 04
    mov eic2, a             ;dde8  45 39

    call reset_kw_counts    ;ddea  31 e0 b8     Reset counts of KW1281 bytes received, sent
    ret                     ;dded  20

sub_ddee:
    call sub_ddca           ;ddee  31 dd ca
    mov a, #0x00            ;ddf1  04 00
    mov mem_038f, a         ;ddf3  61 03 8f

lab_ddf6:
    call set_00fd_hi_nib_1  ;ddf6  31 e3 8e     Store 0x1 in mem_00fd high nibble
    mov a, #0x01            ;ddf9  04 01
    mov mem_0385, a         ;ddfb  61 03 85

    clrb uscr:3             ;ddfe  a3 41        UART TXOE = serial data input (can be used as port)

    ret                     ;de00  20

sub_de01:
    mov a, mem_00fd         ;de01  05 fd
    and a, #0xf0            ;de03  64 f0
    cmp a, #0x20            ;de05  14 20
    blo lab_de0c            ;de07  f9 03
    setb pdr1:6             ;de09  ae 02    BOSE_ON=high
    ret                     ;de0b  20

lab_de0c:
    clrb pdr1:6             ;de0c  a6 02    BOSE_ON=low
    ret                     ;de0e  20

sub_de0f:
    bbs mem_008c:7, lab_de53 ;de0f  bf 8c 41

    movw a, mem_039d        ;de12  c4 03 9d
    incw a                  ;de15  c0
    movw mem_039d, a        ;de16  d4 03 9d

    movw a, mem_038d        ;de19  c4 03 8d
    incw a                  ;de1c  c0
    movw mem_038d, a        ;de1d  d4 03 8d

    bbc pdr7:3, lab_de26    ;de20  b3 13 03     Branch if UART RX=low
    bbc eic2:3, lab_de2e    ;de23  b3 39 08     Branch if edge not detected on INT2 pin (/DIAG_RX)

lab_de26:
    clrb eic2:3             ;de26  a3 39        Clear INT2 pin edge detect status (/DIAG_RX)
    movw a, #0x0000         ;de28  e4 00 00
    movw mem_038d, a        ;de2b  d4 03 8d

lab_de2e:
    movw a, mem_038d        ;de2e  c4 03 8d
    movw a, #0x0bb9         ;de31  e4 0b b9
    cmpw a                  ;de34  13
    bhs sub_de42            ;de35  f8 0b

    movw a, mem_039d        ;de37  c4 03 9d
    movw a, #0x1389         ;de3a  e4 13 89
    cmpw a                  ;de3d  13
    blo lab_de52            ;de3e  f9 12
    bhs lab_de53            ;de40  f8 11        BRANCH_ALWAYS_TAKEN

sub_de42:
    clrb eic2:2             ;de42  a2 39
    mov a, #0x02            ;de44  04 02
    mov mem_0385, a         ;de46  61 03 85
    call set_00fd_hi_nib_2  ;de49  31 e3 92     Store 0x2 in mem_00fd high nibble

lab_de4c:
    movw a, #0x0000         ;de4c  e4 00 00
    movw mem_038d, a        ;de4f  d4 03 8d

lab_de52:
    ret                     ;de52  20

lab_de53:
    clrb eic2:2             ;de53  a2 39
    mov a, #0x00            ;de55  04 00
    mov mem_0385, a         ;de57  61 03 85
    call set_00fd_hi_nib_0  ;de5a  31 e3 8a     Store 0x0 in mem_00fd high nibble
    jmp lab_de4c            ;de5d  21 de 4c

sub_de60:
    mov a, mem_009e         ;de60  05 9e
    pushw a                 ;de62  40
    mov a, mem_00a5         ;de63  05 a5        A = number of bytes in KW1281 packet
    pushw a                 ;de65  40
    call sub_dece           ;de66  31 de ce
    call sub_df28           ;de69  31 df 28
    call sub_dfd7           ;de6c  31 df d7
    call sub_e074           ;de6f  31 e0 74     Send KW1281 byte at 10416.67 bps or do nothing
    popw a                  ;de72  50
    mov mem_00a5, a         ;de73  45 a5        Number of bytes in KW1281 packet
    popw a                  ;de75  50
    mov mem_009e, a         ;de76  45 9e
    ret                     ;de78  20

mem_de79:
;Table used with mem_0388
    .word lab_e21a          ;de79  e2 1a       VECTOR 0
    .word lab_e2df          ;de7b  e2 df       VECTOR 1
    .word lab_e3b4          ;de7d  e3 b4       VECTOR 2  Block title = 0x09 (Acknowledge)
    .word lab_e328          ;de7f  e3 28       VECTOR 3  Block title = 0x00 (ID code request/ECU Info)
                            ;                            or Block title = 0xF6 (ASCII)
    .word lab_e328          ;de81  e3 28       VECTOR 4
    .word lab_e328          ;de83  e3 28       VECTOR 5
    .word lab_e301          ;de85  e3 01       VECTOR 6
    .word lab_e328          ;de87  e3 28       VECTOR 7  Block title = 0x0a (No Acknowledge)
    .word lab_e316          ;de89  e3 16       VECTOR 8  Unrecognized block title

sub_de8b:
    bbc mem_00f9:0, lab_de98 ;de8b  b0 f9 0a
    clrb mem_00f9:0         ;de8e  a0 f9
    bbc mem_00f9:7, lab_de99 ;de90  b7 f9 06
    clrb mem_00f9:7         ;de93  a7 f9
    call sub_e32b           ;de95  31 e3 2b

lab_de98:
    ret                     ;de98  20

lab_de99:
    call sub_deac           ;de99  31 de ac     A = value derived from KW1281 RX Buffer block title
    mov mem_0388, a         ;de9c  61 03 88

    call sub_df07           ;de9f  31 df 07
    bc lab_deab             ;dea2  f9 07

    mov a, #0x01            ;dea4  04 01        A = value to store in mem_038b
                            ;                   In lab_e3d9, this value causes KW1281 TX Buffer
                            ;                   block title 0xD7 to be sent
    mov mem_038b, a         ;dea6  61 03 8b
    setb mem_00f9:2         ;dea9  aa f9

lab_deab:
    ret                     ;deab  20


sub_deac:
;Read block title in KW1281 RX Buffer, return a value in A that will
;later be stored in mem_0388.
;
;Block title    A       Description
;0x00           0x03    ID code request/ECU Info
;0x0A           0x07    No Acknowledge
;0x09           0x02    Acknowledge
;0xF6           0x03    ASCII
;All others     0x08
    mov a, mem_0118+2       ;deac  60 01 1a     KW1281 RX Buffer byte 2: Block title
    cmp a, #0x00            ;deaf  14 00        Is it 0x00 (ID code request/ECU Info)?
    beq lab_dec2            ;deb1  fd 0f
    cmp a, #0x0a            ;deb3  14 0a        Is it 0x0a (No Acknowledge)?
    beq lab_dec5            ;deb5  fd 0e
    cmp a, #0x09            ;deb7  14 09        Is it 0x09 (Acknowledge)?
    beq lab_dec8            ;deb9  fd 0d
    cmp a, #0xf6            ;debb  14 f6        Is it 0xF6 (ASCII)?
    beq lab_decb            ;debd  fd 0c
    mov a, #0x08            ;debf  04 08        A = value to be stored in mem_0388
    ret                     ;dec1  20
lab_dec2:
;Block title = 0x00 (ID code request/ECU Info)
    mov a, #0x03            ;dec2  04 03        A = value to be stored in mem_0388
    ret                     ;dec4  20
lab_dec5:
;Block title = 0x0a (No Acknowledge)
    mov a, #0x07            ;dec5  04 07        A = value to be stored in mem_0388
    ret                     ;dec7  20
lab_dec8:
;Block title = 0x09 (Acknowledge)
    mov a, #0x02            ;dec8  04 02        A = value to be stored in mem_0388
    ret                     ;deca  20
lab_decb:
;Block title = 0xF6 (ASCII)
    mov a, #0x03            ;decb  04 03        A = value to be stored in mem_0388
    ret                     ;decd  20


sub_dece:
    bbs mem_00f9:2, lab_ded7 ;dece  ba f9 06
    call sub_de8b           ;ded1  31 de 8b
    jmp lab_dee9            ;ded4  21 de e9

lab_ded7:
    mov a, mem_0388         ;ded7  60 03 88     A = mem_0388 (value derived from block title)
    cmp a, #0x08            ;deda  14 08        Is in range of mem_de79 table?
    beq lab_dee0            ;dedc  fd 02
    bhs lab_dee9            ;dede  f8 09

lab_dee0:
    mov a, mem_0388         ;dee0  60 03 88     A = table index
    movw a, #mem_de79       ;dee3  e4 de 79     A = table base address
    call sub_e73c           ;dee6  31 e7 3c     Call address in table

lab_dee9:
    mov a, mem_039c         ;dee9  60 03 9c
    beq lab_def9            ;deec  fd 0b
    decw a                  ;deee  d0
    mov mem_039c, a         ;deef  61 03 9c
    cmp a, #0x00            ;def2  14 00
    bne lab_def9            ;def4  fc 03
    call sub_e257           ;def6  31 e2 57

lab_def9:
    bbs mem_00fa:0, lab_df20 ;def9  b8 fa 24
    bbs mem_00f9:5, lab_df06 ;defc  bd f9 07
    mov a, #0x0d            ;deff  04 0d
    mov mem_039b, a         ;df01  61 03 9b
    setb mem_00f9:5         ;df04  ad f9

lab_df06:
    ret                     ;df06  20


sub_df07:
    mov a, mem_0388         ;df07  60 03 88
    cmp a, #0xff            ;df0a  14 ff
    beq lab_df12            ;df0c  fd 04

    mov a, #0x00            ;df0e  04 00
    beq lab_df23            ;df10  fd 11        BRANCH_ALWAYS_TAKEN

lab_df12:
;(mem_0388=0xff)
    mov a, mem_0397         ;df12  60 03 97
    cmp a, #0x01            ;df15  14 01
    beq lab_df20            ;df17  fd 07
    mov a, #0x06            ;df19  04 06        A = value to store in mem_0388
    mov mem_0388, a         ;df1b  61 03 88
    clrc                    ;df1e  81
    ret                     ;df1f  20

lab_df20:
    callv #7                ;df20  ef           CALLV #7 = callv7_e55c
                            ;                   Resets many KW1281 state variables
    setc                    ;df21  91
    ret                     ;df22  20

lab_df23:
    mov mem_0397, a         ;df23  61 03 97
    clrc                    ;df26  81
    ret                     ;df27  20


sub_df28:
    mov a, mem_0389         ;df28  60 03 89
    cmp a, #0x01            ;df2b  14 01
    beq lab_df3d            ;df2d  fd 0e
    cmp a, #0x02            ;df2f  14 02
    beq lab_df38            ;df31  fd 05
    cmp a, #0x03            ;df33  14 03
    beq lab_dfaf            ;df35  fd 78
    ret                     ;df37  20

lab_df38:
;(mem_0389=2)
    mov a, mem_0390         ;df38  60 03 90
    beq lab_dfa0            ;df3b  fd 63

lab_df3d:
;(mem_0389=1)
    bbc mem_00f9:4, lab_df9c ;df3d  b4 f9 5c
    clrb mem_00f9:4         ;df40  a4 f9
    mov a, #0x00            ;df42  04 00
    mov mem_0391, a         ;df44  61 03 91
    mov a, #0x00            ;df47  04 00
    mov mem_039c, a         ;df49  61 03 9c
    mov a, #0x00            ;df4c  04 00
    mov mem_0396, a         ;df4e  61 03 96

    mov a, mem_0082         ;df51  05 82        A = count of KW1281 bytes received
    bne lab_df68            ;df53  fc 13        Branch if not first byte in packet

    ;First byte: might be 0x55 or first byte of packet (block length)
    mov a, mem_0088         ;df55  05 88        A = KW1281 byte received
    mov a, #0x55            ;df57  04 55        TODO what does 0x55 received mean?
    cmp a                   ;df59  12
    bne lab_df68            ;df5a  fc 0c        No: branch to receive block length

    ;First byte: 0x55 byte
    call sub_e1b8           ;df5c  31 e1 b8
    call sub_e242           ;df5f  31 e2 42
    mov a, #0x00            ;df62  04 00
    mov mem_0389, a         ;df64  61 03 89
    ret                     ;df67  20

lab_df68:
;Receiving a new KW1281 packet byte
    call sub_b235           ;df68  31 b2 35     Store byte received in KW1281 RX Buffer
    bbc mem_00f9:6, lab_df9c ;df6b  b6 f9 2e

    mov a, mem_0118+0       ;df6e  60 01 18     KW1281 RX Buffer byte 0: Block length
    cmp a, #0x10            ;df71  14 10
    bhs lab_dfa0            ;df73  f8 2b

    mov a, mem_0118+0       ;df75  60 01 18     KW1281 RX Buffer byte 0: Block length
    cmp a, mem_0082         ;df78  15 82        Compare with count of KW1281 bytes received
    bhs lab_df92            ;df7a  f8 16

    mov a, mem_0088         ;df7c  05 88        A = KW1281 byte received
    cmp a, #0x03            ;df7e  14 03
    beq lab_df84            ;df80  fd 02
    setb mem_00f9:7         ;df82  af f9

lab_df84:
    clrb uscr:1             ;df84  a1 41        Disable UART receive interrupt
    mov a, mem_0118+1       ;df86  60 01 19     KW1281 RX Buffer byte 1: Block counter
    mov mem_0116, a         ;df89  61 01 16     Copy block counter into mem_0116
    setb mem_00f9:0         ;df8c  a8 f9
    mov a, #0x00            ;df8e  04 00        A = value to store in mem_0389
    beq lab_df99            ;df90  fd 07        BRANCH_ALWAYS_TAKEN

lab_df92:
;Block length >= mem_0082
    mov a, #0x03            ;df92  04 03
    mov mem_0390, a         ;df94  61 03 90
    mov a, #0x03            ;df97  04 03        A = value to store in mem_0389

lab_df99:
    mov mem_0389, a         ;df99  61 03 89

lab_df9c:
    ret                     ;df9c  20

    ;df9d looks unreachable
    jmp lab_e04d              ;df9d 21 e0 4d

lab_dfa0:
;Block length >= 16
    mov mem_0082, #0x00     ;dfa0  85 82 00     Reset count of KW1281 bytes received
    clrb mem_00f9:3         ;dfa3  a3 f9
    clrb mem_00f9:6         ;dfa5  a6 f9
    clrb mem_00f9:7         ;dfa7  a7 f9
    mov a, #0x37            ;dfa9  04 37
    mov mem_0390, a         ;dfab  61 03 90
    ret                     ;dfae  20

lab_dfaf:
;(mem_0389=3)
    mov a, mem_0390         ;dfaf  60 03 90
    bne lab_df9c            ;dfb2  fc e8

    mov a, mem_0088         ;dfb4  05 88        A = KW1281 byte received
    xor a, #0xff            ;dfb6  54 ff        Complement it
    mov mem_0089, a         ;dfb8  45 89        KW1281 byte to send = A

    mov a, #0x02            ;dfba  04 02
    mov mem_0389, a         ;dfbc  61 03 89
    setb mem_00f9:3         ;dfbf  ab f9
    clrb mem_00f9:6         ;dfc1  a6 f9
    clrb mem_00f9:7         ;dfc3  a7 f9

    mov rrdr, #0x0c         ;dfc5  85 45 0c     UART Baud Rate = 10416.67 bps @ 8.0 MHz

    mov usmr, #0b00001011   ;dfc8  85 40 0b     UART Parameters = 8-N-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 0   Parity unavailable
                            ;                   5   Parity polarity = 0   Even parity (don't care)
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 1   8-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

    setb uscr:3             ;dfcb  ab 41        UART TXOE = serial data output enabled

    mov a, mem_0089         ;dfcd  05 89        A = KW1281 byte to send
    mov txdr, a             ;dfcf  45 43        Send KW1281 byte out UART

    mov a, #0x20            ;dfd1  04 20
    mov mem_0390, a         ;dfd3  61 03 90
    ret                     ;dfd6  20

sub_dfd7:
    mov a, mem_038a         ;dfd7  60 03 8a
    cmp a, #0x01            ;dfda  14 01
    beq lab_dfea            ;dfdc  fd 0c
    cmp a, #0x02            ;dfde  14 02
    beq lab_e001            ;dfe0  fd 1f
    cmp a, #0x03            ;dfe2  14 03
    bne lab_dfe9            ;dfe4  fc 03
    jmp lab_e063            ;dfe6  21 e0 63

lab_dfe9:
;(mem_038a=3)
    ret                     ;dfe9  20

lab_dfea:
;(mem_038a=1)
    mov a, mem_0390         ;dfea  60 03 90
    bne lab_e000            ;dfed  fc 11

    call sub_e0e1           ;dfef  31 e0 e1

    mov a, #0x18            ;dff2  04 18
    mov mem_0390, a         ;dff4  61 03 90

    mov a, #0x02            ;dff7  04 02
    mov mem_00fb, a         ;dff9  45 fb        KW1281 10416.67 bps transmit state = Send byte, 8-N-1

    mov a, #0x02            ;dffb  04 02
    mov mem_038a, a         ;dffd  61 03 8a

lab_e000:
    ret                     ;e000  20

lab_e001:
;(mem_038a=2)
    mov a, mem_0390         ;e001  60 03 90
    beq lab_e04f            ;e004  fd 49
    bbc mem_00f9:4, lab_e000 ;e006  b4 f9 f7
    clrb mem_00f9:4         ;e009  a4 f9
    mov a, #0x00            ;e00b  04 00
    mov mem_0394, a         ;e00d  61 03 94
    call sub_b235           ;e010  31 b2 35     Store byte received in KW1281 RX Buffer

    mov a, mem_012b+0       ;e013  60 01 2b     KW1281 TX Buffer byte 0: Block length
    cmp a, mem_0083         ;e016  15 83        Compare to count of KW1281 bytes sent
    bhs lab_e023            ;e018  f8 09

    mov mem_0082, #0x00     ;e01a  85 82 00     Reset count of KW1281 bytes received
    setb mem_00f9:1         ;e01d  a9 f9
    mov a, #0x00            ;e01f  04 00
    beq lab_e033            ;e021  fd 10        BRANCH_ALWAYS_TAKEN

lab_e023:
    mov a, mem_0089         ;e023  05 89        A = KW1281 byte to send
    mov a, mem_0088         ;e025  05 88        A = KW1281 byte received
    xor a                   ;e027  52
    cmp a, #0xff            ;e028  14 ff        Is mem_0088 the complement of mem_0089?
    bne lab_e04f            ;e02a  fc 23          No: branch to KW1281 byte check error

    ;KW1281 byte check passed
    mov a, #0x02            ;e02c  04 02
    mov mem_0390, a         ;e02e  61 03 90
    mov a, #0x01            ;e031  04 01

lab_e033:
    mov mem_038a, a         ;e033  61 03 8a
    ret                     ;e036  20

sub_e037:
    mov a, mem_0392         ;e037  60 03 92
    and a, #0x02            ;e03a  64 02
    bne lab_e04d            ;e03c  fc 0f
    mov a, mem_0392         ;e03e  60 03 92
    or a, #0x02             ;e041  74 02
    mov mem_0392, a         ;e043  61 03 92
    call sub_ddbf           ;e046  31 dd bf
    mov a, #0x00            ;e049  04 00
    beq lab_e033            ;e04b  fd e6        BRANCH_ALWAYS_TAKEN

lab_e04d:
    callv #7                ;e04d  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    ret                     ;e04e  20

lab_e04f:
;KW1281 byte check error
    mov a, mem_0396         ;e04f  60 03 96
    incw a                  ;e052  c0
    mov mem_0396, a         ;e053  61 03 96
    cmp a, #0x0b            ;e056  14 0b
    bhs lab_e04d            ;e058  f8 f3
    mov a, #0x37            ;e05a  04 37
    mov mem_0390, a         ;e05c  61 03 90
    mov a, #0x03            ;e05f  04 03
    bne lab_e033            ;e061  fc d0        BRANCH_ALWAYS_TAKEN

lab_e063:
;(mem_038a != 1, 2, 3)
    mov a, mem_0394         ;e063  60 03 94
    bne lab_e06d            ;e066  fc 05
    mov a, #0xff            ;e068  04 ff
    mov mem_0394, a         ;e06a  61 03 94

lab_e06d:
    call reset_kw_counts    ;e06d  31 e0 b8     Reset counts of KW1281 bytes received, sent
    mov a, #0x01            ;e070  04 01
    bne lab_e033            ;e072  fc bf        BRANCH_ALWAYS_TAKEN

sub_e074:
;Send KW1281 byte at 10416.67 bps, 7-O-1 or 8-N-1 depending on mem_00fb
    mov a, mem_00fb         ;e074  05 fb
    cmp a, #0x01            ;e076  14 01        Send KW1281 byte at 10416.67 bps, 7-O-1
    beq lab_e07f            ;e078  fd 05
    cmp a, #0x02            ;e07a  14 02        Send KW1281 byte at 10416.67 bps, 8-N-1
    beq lab_e08c            ;e07c  fd 0e
    ret                     ;e07e  20           Otherwise, do nothing

lab_e07f:
;(mem_00fb=1)
    mov rrdr, #0x0c         ;e07f  85 45 0c     UART Baud Rate = 10416.67 bps @ 8.0 MHz

    mov usmr, #0b01100011   ;e082  85 40 63     UART Parameters = 7-O-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 1   Parity available
                            ;                   5   Parity polarity = 1   Odd parity
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 0   7-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

    mov a, rxdr             ;e085  05 43        A = KW1281 byte received from UART
    mov mem_009e, a         ;e087  45 9e
    jmp lab_e092            ;e089  21 e0 92

lab_e08c:
;(mem_00fb=2)
    mov rrdr, #0x0c         ;e08c  85 45 0c     UART Baud Rate = 10416.67 bps @ 8.0 MHz

    mov usmr, #0b00001011   ;e08f  85 40 0b     UART Parameters = 8-N-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 0   Parity unavailable
                            ;                   5   Parity polarity = 0   Even parity (don't care)
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 1   8-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

lab_e092:
    clrb uscr:7             ;e092  a7 41        Clear all UART receive errors
    setb uscr:6             ;e094  ae 41        Enable UART receiving
    setb uscr:5             ;e096  ad 41        Enable UART transmitting
    setb uscr:4             ;e098  ac 41        Start UART baud rate generator
    setb uscr:3             ;e09a  ab 41        UART TXOE = serial data output enabled

    mov a, mem_0089         ;e09c  05 89        A = KW1281 byte to send
    mov txdr, a             ;e09e  45 43        Send KW1281 byte out UART

    clrb mem_00f9:6         ;e0a0  a6 f9
    clrb mem_00f9:7         ;e0a2  a7 f9

    setb uscr:1             ;e0a4  a9 41        Enable UART receive interrupt

    mov a, #0x00            ;e0a6  04 00
    mov mem_00fb, a         ;e0a8  45 fb        KW1281 10416.67 bps transmit state = Do nothing

    ret                     ;e0aa  20

sub_e0ab:
;Set mem_0389=2, clear unknown bits, reset KW1281 counts
    mov a, #0x02            ;e0ab  04 02
    mov mem_0389, a         ;e0ad  61 03 89     Set mem_0389=2

    clrb mem_00f9:6         ;e0b0  a6 f9
    clrb mem_00f9:7         ;e0b2  a7 f9
    clrb mem_00f9:4         ;e0b4  a4 f9
    clrb mem_00f9:3         ;e0b6  a3 f9

reset_kw_counts:
;Reset counts of KW1281 bytes received and sent
    mov mem_0082, #0x00     ;e0b8  85 82 00     Reset count of KW1281 bytes received
    mov mem_0083, #0x00     ;e0bb  85 83 00     Reset count of KW1281 bytes sent
    ret                     ;e0be  20

sub_e0bf:
;Set up for KW1281 10416.67 bps, 7-O-1 receive
    mov rrdr, #0x0c         ;e0bf  85 45 0c     UART Baud Rate = 10416.67 bps @ 8.0 MHz

    mov usmr, #0b01100011   ;e0c2  85 40 63     UART Parameters = 7-O-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 1   Parity available
                            ;                   5   Parity polarity = 1   Odd parity
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 0   7-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

    mov a, rxdr             ;e0c5  05 43        A = KW1281 byte received from UART (thrown away)
    jmp lab_e0d0            ;e0c7  21 e0 d0

sub_e0ca:
;Set up for KW1281 10416.67 bps, 8-N-1 receive
    mov rrdr, #0x0c         ;e0ca  85 45 0c     UART Baud Rate = 10416.67 bps @ 8.0 MHz

    mov usmr, #0b00001011   ;e0cd  85 40 0b     UART Parameters = 8-N-1
                            ;
                            ;                   7   Mode control    = 0   Clock asynchronous mode
                            ;                   6   Parity control  = 0   Parity unavailable
                            ;                   5   Parity polarity = 0   Even parity (don't care)
                            ;                   4   Stop-bit length = 0   1-bit length
                            ;                   3   Character len   = 1   8-bit length
                            ;                   210 Clock select    = 011 Dedicated baud rate generator

lab_e0d0:
    clrb uscr:7             ;e0d0  a7 41        Clear all UART receive error flags
    setb uscr:6             ;e0d2  ae 41        Enable UART receiving
    setb uscr:4             ;e0d4  ac 41        Start baud rate generator
    setb uscr:3             ;e0d6  ab 41        UART TXOE = serial data output enabled
    clrb mem_00f9:6         ;e0d8  a6 f9
    clrb mem_00f9:7         ;e0da  a7 f9
    setb uscr:1             ;e0dc  a9 41        Enable UART receive interrupt
    mov a, rxdr             ;e0de  05 43        A = KW1281 byte received from UART (thrown away)
    ret                     ;e0e0  20

sub_e0e1:
    mov a, mem_012b+0       ;e0e1  60 01 2b     KW1281 TX Buffer byte 0: Block length
    cmp a, mem_0083         ;e0e4  15 83        Compare to count of KW1281 bytes sent
    bne lab_e0ec            ;e0e6  fc 04
    clrb mem_00f9:3         ;e0e8  a3 f9
    beq lab_e0ee            ;e0ea  fd 02        BRANCH_ALWAYS_TAKEN

lab_e0ec:
    setb mem_00f9:3         ;e0ec  ab f9

lab_e0ee:
    clrb mem_00f9:4         ;e0ee  a4 f9
    jmp lab_b25a            ;e0f0  21 b2 5a


sub_e0f3:
;Called only from ISR for IRQ8 (UART)
;Only called if mem_008c:7 = 0
    bbc mem_00f9:3, lab_e101 ;e0f3  b3 f9 0b
    mov a, rxdr             ;e0f6  05 43
    mov mem_0088, a         ;e0f8  45 88        KW1281 byte received
    clrb uscr:7             ;e0fa  a7 41        Clear all UART receive error flags
    clrb mem_00f9:3         ;e0fc  a3 f9
    jmp lab_e12b            ;e0fe  21 e1 2b

lab_e101:
    mov a, ustr             ;e101  05 42
    and a, #0xf0            ;e103  64 f0
    jmp lab_e125            ;e105  21 e1 25

lab_e108:
    mov a, rxdr             ;e108  05 43
    mov mem_0088, a         ;e10a  45 88        KW1281 byte received
    setb mem_00f9:6         ;e10c  ae f9
    setb mem_00f9:4         ;e10e  ac f9
    clrb uscr:7             ;e110  a7 41        Clear all UART receive error flags
    call sub_e1d6           ;e112  31 e1 d6
    jmp lab_e12b            ;e115  21 e1 2b

lab_e118:
    mov a, rxdr             ;e118  05 43
    mov mem_0088, a         ;e11a  45 88        KW1281 byte received
    setb mem_00f9:7         ;e11c  af f9
    clrb uscr:7             ;e11e  a7 41        Clear all UART receive error flags
    setb mem_00f9:4         ;e120  ac f9
    jmp lab_e12b            ;e122  21 e1 2b

lab_e125:
    cmp a, #0x10            ;e125  14 10
    beq lab_e108            ;e127  fd df
    bne lab_e118            ;e129  fc ed        BRANCH_ALWAYS_TAKEN

lab_e12b:
    clrb mem_00f9:5         ;e12b  a5 f9
    ret                     ;e12d  20

sub_e12e:
    mov a, mem_0385         ;e12e  60 03 85
    cmp a, #0x03            ;e131  14 03
    beq lab_e158            ;e133  fd 23
    cmp a, #0x02            ;e135  14 02
    beq lab_e142            ;e137  fd 09
    cmp a, #0x01            ;e139  14 01
    beq lab_e13e            ;e13b  fd 01
    ret                     ;e13d  20

lab_e13e:
    call sub_de0f           ;e13e  31 de 0f
    ret                     ;e141  20

lab_e142:
    mov a, #0x01            ;e142  04 01
    mov mem_0386, a         ;e144  61 03 86
    mov a, #0x0b            ;e147  04 0b
    mov mem_0387, a         ;e149  61 03 87
    movw a, #0x7ec0         ;e14c  e4 7e c0
    movw mem_0398, a        ;e14f  d4 03 98
    mov a, #0x03            ;e152  04 03        A = value to store in mem_0385

lab_e154:
    mov mem_0385, a         ;e154  61 03 85
    ret                     ;e157  20

lab_e158:
    movw a, #0x0000         ;e158  e4 00 00
    mov a, mem_0386         ;e15b  60 03 86
    decw a                  ;e15e  d0
    mov mem_0386, a         ;e15f  61 03 86
    bne lab_e19a            ;e162  fc 36
    movw a, #0x0000         ;e164  e4 00 00
    mov a, mem_0387         ;e167  60 03 87
    decw a                  ;e16a  d0
    mov mem_0387, a         ;e16b  61 03 87
    beq lab_e1ac            ;e16e  fd 3c
    mov a, mem_0398         ;e170  60 03 98
    rolc a                  ;e173  02
    bhs lab_e180            ;e174  f8 0a
    setb pdr7:2             ;e176  aa 13        UART TX=high
    mov a, mem_0392         ;e178  60 03 92
    or a, #0x01             ;e17b  74 01
    jmp lab_e187            ;e17d  21 e1 87

lab_e180:
    clrb pdr7:2             ;e180  a2 13        UART TX=low
    mov a, mem_0392         ;e182  60 03 92
    and a, #0xfe            ;e185  64 fe

lab_e187:
    mov mem_0392, a         ;e187  61 03 92
    movw a, mem_0398        ;e18a  c4 03 98
    rolc a                  ;e18d  02
    swap                    ;e18e  10
    rolc a                  ;e18f  02
    swap                    ;e190  10
    movw mem_0398, a        ;e191  d4 03 98
    mov a, #0xc8            ;e194  04 c8
    mov mem_0386, a         ;e196  61 03 86
    ret                     ;e199  20

lab_e19a:
    mov a, #0x01            ;e19a  04 01
    bbs pdr7:3, lab_e1a1    ;e19c  bb 13 02     Branch if UART RX=high
    mov a, #0x00            ;e19f  04 00

lab_e1a1:
    mov a, mem_0392         ;e1a1  60 03 92
    xor a                   ;e1a4  52
    and a, #0x01            ;e1a5  64 01
    bne lab_e1aa            ;e1a7  fc 01
    ret                     ;e1a9  20

lab_e1aa:
    callv #7                ;e1aa  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    ret                     ;e1ab  20

lab_e1ac:
    mov a, #0x00            ;e1ac  04 00
    mov mem_039a, a         ;e1ae  61 03 9a
    mov a, mem_038f         ;e1b1  60 03 8f
    incw a                  ;e1b4  c0
    mov mem_038f, a         ;e1b5  61 03 8f

sub_e1b8:
    mov a, #0x00            ;e1b8  04 00        A = value to store in mem_0388
    mov mem_0388, a         ;e1ba  61 03 88

    setb mem_00f9:2         ;e1bd  aa f9
    mov a, #0x01            ;e1bf  04 01        A = value to store in mem_038b
    mov mem_038b, a         ;e1c1  61 03 8b
    call set_00fd_hi_nib_3  ;e1c4  31 e3 96     Store 0x3 in mem_00fd high nibble
    call sub_e0ca           ;e1c7  31 e0 ca     Set up for KW1281 10416.67 bps, 8-N-1 receive
    clrb mem_00f9:3         ;e1ca  a3 f9
    mov a, #0x50            ;e1cc  04 50
    mov mem_038c, a         ;e1ce  61 03 8c
    mov a, #0x00            ;e1d1  04 00        A = value to store in mem_0385
    jmp lab_e154            ;e1d3  21 e1 54


sub_e1d6:
;Called only from sub_e0f3, which itself is called only from UART ISR
;TODO what do 0x01 and 0x0a received mean?
    mov a, mem_0393         ;e1d6  60 03 93

    cmp a, #0x01            ;e1d9  14 01        mem_0393 case 1:
    beq lab_e1e2            ;e1db  fd 05          Check if (KW1281 byte received & 0x7f) = 0x01

    cmp a, #0x02            ;e1dd  14 02        mem_0393 case 2:
    beq lab_e1ff            ;e1df  fd 1e          Check if (KW1281 byte received & 0x7f) = 0x0a

    ret                     ;e1e1  20

lab_e1e2:
;(mem_0393=1)
    mov a, mem_038c         ;e1e2  60 03 8c
    beq lab_e1fe            ;e1e5  fd 17

    mov a, mem_0088         ;e1e7  05 88        A = KW1281 byte received
    and a, #0x7f            ;e1e9  64 7f
    cmp a, #0x01            ;e1eb  14 01
    bne lab_e1fe            ;e1ed  fc 0f

    call sub_e0bf           ;e1ef  31 e0 bf     Set up for KW1281 10416.67 bps, 7-O-1 receive
    clrb mem_00f9:3         ;e1f2  a3 f9
    mov a, #0x05            ;e1f4  04 05
    mov mem_038c, a         ;e1f6  61 03 8c
    mov a, #0x02            ;e1f9  04 02        A = value to store in mem_0393

lab_e1fb:
    mov mem_0393, a         ;e1fb  61 03 93

lab_e1fe:
    ret                     ;e1fe  20

lab_e1ff:
;(mem_0393=2)
    mov a, mem_038c         ;e1ff  60 03 8c
    beq lab_e1fe            ;e202  fd fa

    mov a, mem_0088         ;e204  05 88        A = KW1281 byte received
    and a, #0x7f            ;e206  64 7f
    cmp a, #0x0a            ;e208  14 0a        A = value to store in mem_0393
    bne lab_e1fe            ;e20a  fc f2

    mov a, #0x09            ;e20c  04 09
    mov mem_038c, a         ;e20e  61 03 8c
    mov a, #0x06            ;e211  04 06
    mov mem_038b, a         ;e213  61 03 8b
    mov a, #0x00            ;e216  04 00
    beq lab_e1fb            ;e218  fd e1        BRANCH_ALWAYS_TAKEN


lab_e21a:
;(mem_0388=0)
    mov a, mem_038b         ;e21a  60 03 8b     A = table index
    movw a, #mem_e223       ;e21d  e4 e2 23     A = table base address
    jmp sub_e73c            ;e220  21 e7 3c     Jump to address in table

mem_e223:
;case table for mem_038b
    .word lab_e256          ;VECTOR   0     Does nothing
    .word lab_e231          ;VECTOR   1
    .word lab_e281          ;VECTOR   2
    .word lab_e281          ;VECTOR   3
    .word lab_e2b7          ;VECTOR   4
    .word lab_e282          ;VECTOR   5
    .word lab_e29e          ;VECTOR   6

lab_e231:
;(mem_0388=0, mem_038b=1)
    mov a, mem_038c         ;e231  60 03 8c
    beq lab_e268            ;e234  fd 32
    bbc mem_00f9:4, lab_e256 ;e236  b4 f9 1d
    bbc mem_00f9:6, lab_e256 ;e239  b6 f9 1a

    mov a, mem_0088         ;e23c  05 88        A = KW1281 byte received
    cmp a, #0x55            ;e23e  14 55        TODO what does 0x55 received mean?
    bne lab_e256            ;e240  fc 14

sub_e242:
;KW1281 byte received = 0x55
    call sub_e0bf           ;e242  31 e0 bf     Set up for KW1281 10416.67 bps, 7-O-1 receive
    clrb mem_00f9:3         ;e245  a3 f9
    mov a, #0x05            ;e247  04 05
    mov mem_038c, a         ;e249  61 03 8c
    mov a, #0x01            ;e24c  04 01
    mov mem_0393, a         ;e24e  61 03 93
    mov a, #0x00            ;e251  04 00        A = value to store in mem_038b

lab_e253:
    mov mem_038b, a         ;e253  61 03 8b

lab_e256:
;(mem_0388=0, mem_038b=0)
    ret                     ;e256  20

sub_e257:
    clrb uscr:6             ;e257  a6 41        Disable UART receiving
    clrb uscr:1             ;e259  a1 41        Disable UART receive interrupt
    setb mem_00f9:2         ;e25b  aa f9
    mov a, #0x00            ;e25d  04 00
    mov mem_0389, a         ;e25f  61 03 89
    mov mem_038a, a         ;e262  61 03 8a
    mov mem_0385, a         ;e265  61 03 85

lab_e268:
    mov a, mem_038f         ;e268  60 03 8f
    cmp a, #0x02            ;e26b  14 02
    bhs lab_e278            ;e26d  f8 09
    mov a, #0x64            ;e26f  04 64
    mov mem_038c, a         ;e271  61 03 8c
    mov a, #0x05            ;e274  04 05
    bne lab_e253            ;e276  fc db        BRANCH_ALWAYS_TAKEN

lab_e278:
    mov a, mem_0395         ;e278  60 03 95
    incw a                  ;e27b  c0
    mov mem_0395, a         ;e27c  61 03 95

lab_e27f:
    callv #7                ;e27f  ef          CALLV #7 = callv7_e55c
                            ;                  Resets many KW1281 state variables
    ret                     ;e280  20

lab_e281:
;(mem_0388=0, mem_038b=2 or 3)
    ret                     ;e281  20

lab_e282:
;(mem_0388=0, mem_038b=5)
    mov a, mem_038c         ;e282  60 03 8c
    bne lab_e29d            ;e285  fc 16
    mov a, #0x02            ;e287  04 02
    mov mem_0385, a         ;e289  61 03 85
    mov a, #0x20            ;e28c  04 20        A = value to store in mem_00fd high nibble
    call set_00fd_hi_nib    ;e28e  31 e3 a4     Store high nibble of A in mem_00fd high nibble

    mov a, #0x00            ;e291  04 00        A = value to store in mem_0388 and mem_038b
    mov mem_0388, a         ;e293  61 03 88
    mov mem_038b, a         ;e296  61 03 8b

    clrb mem_00f9:2         ;e299  a2 f9
    clrb uscr:3             ;e29b  a3 41        UART TXOE = serial data input (can be used as port)

lab_e29d:
    ret                     ;e29d  20

lab_e29e:
;(mem_0388=0, mem_038b=6)
    mov a, mem_038c         ;e29e  60 03 8c
    bne lab_e2b6            ;e2a1  fc 13
    mov mem_0089, #0x75     ;e2a3  85 89 75     KW1281 byte to send = 0x75 (TODO what does sending 0x75 mean?)

    mov a, #0x01            ;e2a6  04 01
    mov mem_00fb, a         ;e2a8  45 fb        KW1281 10416.67 bps transmit state = Send byte, 7-O-1

    setb mem_00f9:3         ;e2aa  ab f9
    mov a, #0x0c            ;e2ac  04 0c
    mov mem_038c, a         ;e2ae  61 03 8c
    mov a, #0x04            ;e2b1  04 04        A = value to store in mem_038b

lab_e2b3:
    mov mem_038b, a         ;e2b3  61 03 8b

lab_e2b6:
    ret                     ;e2b6  20

lab_e2b7:
;(mem_0388=0, mem_038b=4)
    mov a, mem_038c         ;e2b7  60 03 8c
    beq lab_e27f            ;e2ba  fd c3
    bbc mem_00f9:4, lab_e2b6 ;e2bc  b4 f9 f7
    clrb mem_00f9:4         ;e2bf  a4 f9

    movw a, #0x003c         ;e2c1  e4 00 3c     Delay loop
lab_e2c4:
    decw a                  ;e2c4  d0
    bne lab_e2c4            ;e2c5  fc fd

    call sub_e0ca           ;e2c7  31 e0 ca     Set up for KW1281 10416.67 bps, 8-N-1 receive
    mov a, #0xff            ;e2ca  04 ff
    mov mem_0390, a         ;e2cc  61 03 90
    mov a, #0x01            ;e2cf  04 01
    mov mem_0389, a         ;e2d1  61 03 89
    clrb mem_00f9:2         ;e2d4  a2 f9
    mov a, #0x35            ;e2d6  04 35
    mov mem_039c, a         ;e2d8  61 03 9c
    mov a, #0x00            ;e2db  04 00        A = value to store in mem_038b
    beq lab_e2b3            ;e2dd  fd d4        BRANCH_ALWAYS_TAKEN

lab_e2df:
;(mem_0388=1)
    mov a, mem_038b         ;e2df  60 03 8b

    cmp a, #0x01            ;e2e2  14 01
    beq lab_e2eb            ;e2e4  fd 05        Calls sub_b16b_ack, sets mem_038b=2

    cmp a, #0x02            ;e2e6  14 02
    beq lab_e2f1            ;e2e8  fd 07        Set mem_038b=0, set mem_0389=2, clear unknown bits, reset KW1281 counts

    ret                     ;e2ea  20

lab_e2eb:
;(mem_0388=1, mem_038b=1)
    call sub_b16b_ack       ;e2eb  31 b1 6b
    jmp lab_e310            ;e2ee  21 e3 10     Set mem_038b=2 and return

lab_e2f1:
    bbc mem_00f9:1, lab_e300 ;e2f1  b1 f9 0c
    clrb mem_00f9:1         ;e2f4  a1 f9

    mov a, #0x00            ;e2f6  04 00
    mov mem_038b, a         ;e2f8  61 03 8b     Set mem_038b=0

    clrb mem_00f9:2         ;e2fb  a2 f9
    call sub_e0ab           ;e2fd  31 e0 ab     Set mem_0389=2, clear unknown bits, reset KW1281 counts

lab_e300:
    ret                     ;e300  20

lab_e301:
;(mem_0388=6)
    mov a, mem_038b         ;e301  60 03 8b
    cmp a, #0x01            ;e304  14 01        Calls sub_e338_no_ack_2
    beq lab_e30d            ;e306  fd 05
    cmp a, #0x02            ;e308  14 02
    beq lab_e2f1            ;e30a  fd e5        Set mem_038b=0, set mem_0389=2, clear unknown bits, reset KW1281 counts
    ret                     ;e30c  20

lab_e30d:
;(mem_0388=6, mem_038b=1)
    call sub_e338_no_ack_2  ;e30d  31 e3 38

lab_e310:
;Set mem_038b=2 and return
    mov a, #0x02            ;e310  04 02        A = value to store in mem_038b
    mov mem_038b, a         ;e312  61 03 8b
    ret                     ;e315  20

lab_e316:
;(mem_0388=8: Unrecognized block title)
    mov a, mem_038b         ;e316  60 03 8b
    cmp a, #0x01            ;e319  14 01
    beq lab_e322            ;e31b  fd 05        Calls sub_e34e_no_ack_2
    cmp a, #0x02            ;e31d  14 02
    beq lab_e2f1            ;e31f  fd d0        Set mem_038b=0, set mem_0389=2, clear unknown bits, reset KW1281 counts
    ret                     ;e321  20

lab_e322:
;(mem_0388=8, mem_038b=1)
    call sub_e34e_no_ack_2  ;e322  31 e3 4e
    jmp lab_e310            ;e325  21 e3 10     Set mem_038b=2 and return

lab_e328:
;(mem_0388 = 3, 4, 5, 7)
;Block title = 0x00 (ID code request/ECU Info)
;or Block title = 0xF6 (ASCII)
    jmp lab_e2df            ;e328  21 e2 df

sub_e32b:
    mov a, mem_0397         ;e32b  60 03 97
    beq lab_e336            ;e32e  fd 06
    mov a, #0x00            ;e330  04 00
    mov mem_0388, a         ;e332  61 03 88
    ret                     ;e335  20

lab_e336:
    clrb mem_00f9:7         ;e336  a7 f9

sub_e338_no_ack_2:
    mov a, #0x01            ;e338  04 01
    mov mem_0397, a         ;e33a  61 03 97

    movw a, #kw_no_ack_2    ;e33d  e4 dd 5d
    movw mem_0084, a        ;e340  d5 84        Pointer to KW1281 packet bytes
    mov mem_00a5, #0x05     ;e342  85 a5 05     5 bytes in KW1281 packet
    call sub_b136           ;e345  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    mov a, mem_0116         ;e348  60 01 16     A = Block counter copied from KW1281 RX Buffer
    jmp lab_e35f            ;e34b  21 e3 5f

sub_e34e_no_ack_2:
    clrb mem_00f9:7         ;e34e  a7 f9

    movw a, #kw_no_ack_2    ;e350  e4 dd 5d
    movw mem_0084, a        ;e353  d5 84        Pointer to KW1281 packet bytes
    mov mem_00a5, #0x05     ;e355  85 a5 05     5 bytes in KW1281 packet
    call sub_b136           ;e358  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    mov a, mem_0116         ;e35b  60 01 16     A = Block counter copied from KW1281 RX Buffer
    incw a                  ;e35e  c0

lab_e35f:
    mov mem_012b+3, a       ;e35f  61 01 2e     KW1281 TX Buffer byte 3
    call sub_e369           ;e362  31 e3 69     Set mem_038a=1, increment block counter, reset KW1281 tx/rx counts
    ret                     ;e365  20

sub_e366:
    call sub_b136           ;e366  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

sub_e369:
;Set mem_038a=1, increment block counter, reset KW1281 tx/rx counts
    mov a, #0x01            ;e369  04 01
    mov mem_038a, a         ;e36b  61 03 8a

    mov a, mem_0116         ;e36e  60 01 16     A = Block counter copied from KW1281 RX Buffer
    incw a                  ;e371  c0           Increment block counter
    mov mem_012b+1, a       ;e372  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter

    jmp reset_kw_counts     ;e375  21 e0 b8     Reset counts of KW1281 bytes received, sent

    ;XXX e378-e389 looks unreachable
    bbc mem_00f9:1, lab_e389 ;e378  b1 f9 0e
    clrb mem_00f9:1         ;e37b  a1 f9
    mov a, #0x02            ;e37d  04 02
    mov mem_0389, a         ;e37f  61 03 89
    mov a, #0x00            ;e382  04 00
    mov mem_038b, a         ;e384  61 03 8b
    clrb mem_00f9:2         ;e387  a2 f9

lab_e389:
    ret                     ;e389  20

set_00fd_hi_nib_0:
;Store 0x0 in mem_00fd high nibble
    mov a, #0x00            ;e38a  04 00        A = value to store in mem_00fd high nibble
    beq set_00fd_hi_nib     ;e38c  fd 16        BRANCH_ALWAYS_TAKEN

set_00fd_hi_nib_1:
;Store 0x1 in mem_00fd high nibble
    mov a, #0x10            ;e38e  04 10        A = value to store in mem_00fd high nibble
    bne set_00fd_hi_nib     ;e390  fc 12        BRANCH_ALWAYS_TAKEN

set_00fd_hi_nib_2:
;Store 0x2 in mem_00fd high nibble
    mov a, #0x20            ;e392  04 20        A = value to store in mem_00fd high nibble
    bne set_00fd_hi_nib     ;e394  fc 0e        BRANCH_ALWAYS_TAKEN

set_00fd_hi_nib_3:
;Store 0x3 in mem_00fd high nibble
    mov a, #0x30            ;e396  04 30        A = value to store in mem_00fd high nibble
    bne set_00fd_hi_nib     ;e398  fc 0a        BRANCH_ALWAYS_TAKEN

set_00fd_hi_nib_9:
;Store 0x9 in mem_00fd high nibble
    mov a, #0x90            ;e39a  04 90        A = value to store in mem_00fd high nibble
    bne set_00fd_hi_nib     ;e39c  fc 06        BRANCH_ALWAYS_TAKEN

;0xe39e looks unreachable
;Store 0xA in mem_00fd high nibble
    mov a, #0xa0            ;e39e  04 a0        A = value to store in mem_00fd high nibble
    bne set_00fd_hi_nib     ;e3a0  fc 02        BRANCH_ALWAYS_TAKEN

set_00fd_hi_nib_b:
;Store 0xB in mem_00fd high nibble
    mov a, #0xb0            ;e3a2  04 b0        A = value to store in mem_00fd high nibble

set_00fd_hi_nib:
;Store high nibble of A in mem_00fd
    mov a, mem_00fd         ;e3a4  05 fd
    and a, #0x0f            ;e3a6  64 0f
    or a                    ;e3a8  72
    mov mem_00fd, a         ;e3a9  45 fd
    ret                     ;e3ab  20

set_00fd_lo_nib:
;Store low nibble of A in mem_00fd
    mov a, mem_00fd         ;e3ac  05 fd
    and a, #0xf0            ;e3ae  64 f0
    or a                    ;e3b0  72
    mov mem_00fd, a         ;e3b1  45 fd
    ret                     ;e3b3  20

lab_e3b4:
;(mem_0388=2: Block title = 0x09 (Acknowledge))
    mov a, mem_038b         ;e3b4  60 03 8b     A = table index
    movw a, #mem_e3bd       ;e3b7  e4 e3 bd     A = table base address
    jmp sub_e73c            ;e3ba  21 e7 3c     Jump to address in table

mem_e3bd:
;
;Flow of mem_038b:
;  0x01 sends kw_title_d7 ->
;  0x0b set unknown counters ->
;  0x02 set unknown values ->
;  0x03 if block title is 0x3d security access ->
;  0x04 read 4 bytes from 4x buffer, call sub_e61f ->
;  0x06 end session
;
    .word lab_e480          ;VECTOR 0       Does nothing
    .word lab_e3d9          ;VECTOR 1       Reads tchr, send kw_title_d7, set mem_038b=0x0b
    .word lab_e42a          ;VECTOR 2       Sets unknown values, set mem_038b=0x03
    .word lab_e442          ;VECTOR 3       If received block title 0x3d (security access), set mem_038b=0x04
                            ;               If received block title 0x0a (no acknowledge), set mem_038b=0x02
                            ;               If other received block title, send no acknowledge, set mem_038b=0x02
    .word lab_e4b5          ;VECTOR 4       Read 4 bytes from RX buffer, call sub_e61f, set mem_038b=0x06
    .word lab_e4e0          ;VECTOR 5       Change mem_00fd, set mem_038b=0x06
    .word lab_e4eb          ;VECTOR 6       Change mem_00fd, send kw_end_session, set mem_038b=0x07
    .word lab_e502          ;VECTOR 7
    .word lab_e547          ;VECTOR 8
    .word lab_e552          ;VECTOR 9
    .word callv7_e55c       ;VECTOR 0x0a    Reset many KW1281 state variables
    .word lab_e41e          ;VECTOR 0x0b
    .word lab_e4a3          ;VECTOR 0x0c
    .word lab_e59c          ;VECTOR 0x0d

lab_e3d9:
;(mem_0388=2, mem_038b=1)
    call set_00fd_hi_nib_9  ;e3d9  31 e3 9a     Store 0x9 in mem_00fd high nibble

    movw a, tchr            ;e3dc  c5 19        16-bit timer count register
    rolc a                  ;e3de  02
    swap                    ;e3df  10
    rolc a                  ;e3e0  02
    swap                    ;e3e1  10
    movw mem_03ab, a        ;e3e2  d4 03 ab

    movw a, tchr            ;e3e5  c5 19        16-bit timer count register
    rorc a                  ;e3e7  03
    swap                    ;e3e8  10
    rorc a                  ;e3e9  03
    swap                    ;e3ea  10
    movw mem_03ad, a        ;e3eb  d4 03 ad

    movw a, #kw_title_d7    ;e3ee  e4 dd 66
    movw mem_0084, a        ;e3f1  d5 84        Pointer to KW1281 packet bytes
    mov mem_00a5, #0x08     ;e3f3  85 a5 08     8 bytes in KW1281 packet
    call sub_b136           ;e3f6  31 b1 36     Copy mem_00a5 bytes from @mem_0084 to KW1281 TX Buffer

    mov a, mem_03ab         ;e3f9  60 03 ab
    mov mem_012b+6, a       ;e3fc  61 01 31     KW1281 TX Buffer byte 6

    mov a, mem_03ac         ;e3ff  60 03 ac
    mov mem_012b+5, a       ;e402  61 01 30     KW1281 TX Buffer byte 5

    mov a, mem_03ad         ;e405  60 03 ad
    mov mem_012b+4, a       ;e408  61 01 2f     KW1281 TX Buffer byte 4

    mov a, mem_03ae         ;e40b  60 03 ae
    mov mem_012b+3, a       ;e40e  61 01 2e     KW1281 TX Buffer byte 3

    mov a, #0x11            ;e411  04 11
    mov mem_038c, a         ;e413  61 03 8c

    mov a, #0x0b            ;e416  04 0b        A = value to store mem_038b
    bne lab_e47d            ;e418  fc 63        BRANCH_ALWAYS_TAKEN

    ;0xea41 looks unreachable
    mov a, #0x0a            ;e41a  04 0a        A = value to store in mem_038b
    bne lab_e47d            ;e41c  fc 5f        BRANCH_ALWAYS_TAKEN

lab_e41e:
;(mem_0388=2, mem_038b=0x0b)
    mov a, mem_038c         ;e41e  60 03 8c
    bne lab_e480            ;e421  fc 5d
    call sub_e369           ;e423  31 e3 69     Set mem_038a=1, increment block counter, reset KW1281 tx/rx counts
    mov a, #0x02            ;e426  04 02        A = value to store in mem_038b
    bne lab_e47d            ;e428  fc 53        BRANCH_ALWAYS_TAKEN

lab_e42a:
;(mem_0388=2, mem_038b=2)
    bbc mem_00f9:1, lab_e480 ;e42a  b1 f9 53
    clrb mem_00f9:1         ;e42d  a1 f9
    mov a, #0x02            ;e42f  04 02
    mov mem_0389, a         ;e431  61 03 89
    mov a, #0x01            ;e434  04 01
    mov mem_0391, a         ;e436  61 03 91
    mov a, #0x19            ;e439  04 19
    mov mem_038c, a         ;e43b  61 03 8c
    mov a, #0x03            ;e43e  04 03        A = value to store in mem_038b
    bne lab_e47d            ;e440  fc 3b        BRANCH_ALWAYS_TAKEN

lab_e442:
;(mem_0388=2, mem_038b=3)
    mov a, mem_0391         ;e442  60 03 91
    beq lab_e44c            ;e445  fd 05
    mov a, mem_038c         ;e447  60 03 8c
    beq lab_e49a            ;e44a  fd 4e

lab_e44c:
    bbc mem_00f9:0, lab_e480 ;e44c  b0 f9 31
    clrb mem_00f9:0         ;e44f  a0 f9
    mov a, #0x11            ;e451  04 11
    mov mem_038c, a         ;e453  61 03 8c
    bbc mem_00f9:7, lab_e460 ;e456  b7 f9 07
    call sub_e32b           ;e459  31 e3 2b

lab_e45c:
    mov a, #0x02            ;e45c  04 02        A = value to store in mem_038b
    bne lab_e47d            ;e45e  fc 1d        BRANCH_ALWAYS_TAKEN

lab_e460:
    mov a, mem_0118+2       ;e460  60 01 1a     KW1281 RX Buffer byte 2: Block title
    cmp a, #0x3d            ;e463  14 3d        Is it 0x3d (??? Security access)?
    beq lab_e47b            ;e465  fd 14
    cmp a, #0x0a            ;e467  14 0a        Is it 0x0a (No Acknowledge)?
    beq lab_e481            ;e469  fd 16

lab_e46b:
    mov a, #0x01            ;e46b  04 01
    mov mem_0391, a         ;e46d  61 03 91
    mov a, #0x11            ;e470  04 11
    mov mem_038c, a         ;e472  61 03 8c
    call sub_e34e_no_ack_2  ;e475  31 e3 4e
    jmp lab_e45c            ;e478  21 e4 5c

lab_e47b:
;Block title 0x3d (??? Security access)
    mov a, #0x04            ;e47b  04 04        A = value to store in mem_038b

lab_e47d:
    mov mem_038b, a         ;e47d  61 03 8b

lab_e480:
;(mem_0388=2, mem_038b=0) and other callers
    ret                     ;e480  20

lab_e481:
;Block title 0x0a (No Acknowledge)
    mov a, mem_0118+1       ;e481  60 01 19     KW1281 RX Buffer byte 1: Block counter
    mov a, mem_0118+3       ;e484  60 01 1b     KW1281 RX Buffer byte 3
    xor a                   ;e487  52
    beq lab_e46b            ;e488  fd e1
    call sub_e369           ;e48a  31 e3 69     Set mem_038a=1, increment block counter, reset KW1281 tx/rx counts
    mov a, mem_0118+3       ;e48d  60 01 1b     KW1281 RX Buffer byte 3
    mov mem_012b+1, a       ;e490  61 01 2c     Store it in KW1281 TX Buffer byte 1: Block counter
    mov mem_0116, a         ;e493  61 01 16     Copy block counter into mem_0116
    mov a, #0x02            ;e496  04 02        A = value to store in mem_038b
    bne lab_e47d            ;e498  fc e3        BRANCH_ALWAYS_TAKEN

lab_e49a:
    mov a, #0x64            ;e49a  04 64
    mov mem_038c, a         ;e49c  61 03 8c
    mov a, #0x0c            ;e49f  04 0c        A = value to store in mem_038b
    bne lab_e47d            ;e4a1  fc da        BRANCH_ALWAYS_TAKEN

lab_e4a3:
;(mem_0388=2, mem_038b=0x0c)
    mov a, mem_038c         ;e4a3  60 03 8c
    bne lab_e480            ;e4a6  fc d8
    call sub_e037           ;e4a8  31 e0 37
    call sub_de42           ;e4ab  31 de 42
    mov a, #0x00            ;e4ae  04 00        A = value to store in mem_0389 and mem_038b
    mov mem_0389, a         ;e4b0  61 03 89
    beq lab_e47d            ;e4b3  fd c8        BRANCH_ALWAYS_TAKEN

lab_e4b5:
;(mem_0388=2, mem_038b=4) (Block title 0x3d: Security access?)
    mov a, mem_0118+6       ;e4b5  60 01 1e     KW1281 RX Buffer byte 6
    mov mem_03ab, a         ;e4b8  61 03 ab

    mov a, mem_0118+5       ;e4bb  60 01 1d     KW1281 RX Buffer byte 5
    mov mem_03ac, a         ;e4be  61 03 ac

    mov a, mem_0118+4       ;e4c1  60 01 1c     KW1281 RX Buffer byte 4
    mov mem_03ad, a         ;e4c4  61 03 ad

    mov a, mem_0118+3       ;e4c7  60 01 1b     KW1281 RX Buffer byte 3
    mov mem_03ae, a         ;e4ca  61 03 ae

    call sub_e61f           ;e4cd  31 e6 1f     Unknown, uses mem_e5aa table
    jmp lab_e4e5            ;e4d0  21 e4 e5

sub_e4d3:
;Copy mem_03a1->mem_039f, mem_03a2->mem_03a0
    mov a, mem_03a1         ;e4d3  60 03 a1
    mov mem_039f, a         ;e4d6  61 03 9f
    mov a, mem_03a2         ;e4d9  60 03 a2
    mov mem_03a0, a         ;e4dc  61 03 a0
    ret                     ;e4df  20

lab_e4e0:
;(mem_0388=2, mem_038b=5)
    mov a, #0x01            ;e4e0  04 01        A = value to store in mem_00fd low nibble
    call set_00fd_lo_nib    ;e4e2  31 e3 ac     Store low nibble of A in mem_00fd low nibble

lab_e4e5:
    mov a, #0x06            ;e4e5  04 06        A = value to store in mem_038b

lab_e4e7:
    mov mem_038b, a         ;e4e7  61 03 8b

lab_e4ea:
    ret                     ;e4ea  20

lab_e4eb:
;(mem_0388=2, mem_038b=6)
    mov a, mem_038c         ;e4eb  60 03 8c
    bne lab_e4ea            ;e4ee  fc fa
    call set_00fd_hi_nib_b  ;e4f0  31 e3 a2     Store 0xb in mem_00fd high nibble

    mov mem_00a5, #0x04     ;e4f3  85 a5 04     4 bytes in KW1281 packet
    movw a, #kw_end_session ;e4f6  e4 dd 6e
    movw mem_0084, a        ;e4f9  d5 84        Pointer to KW1281 packet bytes
    call sub_e366           ;e4fb  31 e3 66

    mov a, #0x07            ;e4fe  04 07        A = value to store in mem_038b
    bne lab_e4e7            ;e500  fc e5        BRANCH_ALWAYS_TAKEN

lab_e502:
;(mem_0388=2, mem_038b=7)
    bbc mem_00f9:1, lab_e55b ;e502  b1 f9 56
    clrb mem_00f9:1         ;e505  a1 f9

    mov a, #0x02            ;e507  04 02
    mov mem_0389, a         ;e509  61 03 89

    mov a, mem_03af         ;e50c  60 03 af
    bne lab_e517            ;e50f  fc 06

    call sub_e4d3           ;e511  31 e4 d3     Copy mem_03a1->mem_039f, mem_03a2->mem_03a0

    jmp lab_e536            ;e514  21 e5 36

lab_e517:
    mov a, mem_03a1         ;e517  60 03 a1
    mov a, mem_039f         ;e51a  60 03 9f
    cmp a                   ;e51d  12
    bne lab_e52b            ;e51e  fc 0b

    mov a, mem_03a2         ;e520  60 03 a2
    mov a, mem_03a0         ;e523  60 03 a0
    cmp a                   ;e526  12
    bne lab_e52b            ;e527  fc 02

    beq lab_e536            ;e529  fd 0b        BRANCH_ALWAYS_TAKEN

lab_e52b:
    call sub_e4d3           ;e52b  31 e4 d3     Copy mem_03a1->mem_039f, mem_03a2->mem_03a0
    mov a, #0x03            ;e52e  04 03        A = value to store in mem_00fd low nibble
    call set_00fd_lo_nib    ;e530  31 e3 ac     Store low nibble of A in mem_00fd low nibble
    bbc mem_00de:6, lab_e544 ;e533  b6 de 0e

lab_e536:
    mov a, #0x02            ;e536  04 02        A = value to store in mem_00fd low nibble
    call set_00fd_lo_nib    ;e538  31 e3 ac     Store low nibble of A in mem_00fd low nibble
    mov a, #0x01            ;e53b  04 01
    mov mem_03af, a         ;e53d  61 03 af
    mov a, #0x08            ;e540  04 08        A = value to store in mem_038b
    bne lab_e4e7            ;e542  fc a3        BRANCH_ALWAYS_TAKEN

lab_e544:
    jmp lab_e556            ;e544  21 e5 56

lab_e547:
;(mem_0388=2, mem_038b=8)
    mov a, mem_00f1         ;e547  05 f1
    bne lab_e55b            ;e549  fc 10
    mov mem_00f1, #0x81     ;e54b  85 f1 81
    mov a, #0x0d            ;e54e  04 0d
    bne lab_e558            ;e550  fc 06        BRANCH_ALWAYS_TAKEN

lab_e552:
;(mem_0388=2, mem_038b=9)
    mov a, mem_00f1         ;e552  05 f1
    bne lab_e55b            ;e554  fc 05

lab_e556:
    mov a, #0x0a            ;e556  04 0a

lab_e558:
    mov mem_038b, a         ;e558  61 03 8b

lab_e55b:
    ret                     ;e55b  20

callv7_e55c:
;Reset many KW1281 state variables
;CALLV #7
;(mem_0388=2, mem_038b=0x0a)
    setb pdr7:2             ;e55c  aa 13        UART TX=high
    setb pdr7:3             ;e55e  ab 13        UART RX=high
    call set_00fd_hi_nib_0  ;e560  31 e3 8a     Store 0x0 in mem_00fd high nibble
    movw a, #0xffff         ;e563  e4 ff ff
    movw mem_0398, a        ;e566  d4 03 98
    movw a, #0x0000         ;e569  e4 00 00
    mov mem_0397, a         ;e56c  61 03 97
    mov mem_0396, a         ;e56f  61 03 96
    mov mem_0385, a         ;e572  61 03 85
    mov mem_0388, a         ;e575  61 03 88
    mov mem_0389, a         ;e578  61 03 89
    mov mem_038a, a         ;e57b  61 03 8a
    mov mem_0392, a         ;e57e  61 03 92
    mov mem_038c, a         ;e581  61 03 8c
    mov mem_0390, a         ;e584  61 03 90
    mov mem_038b, a         ;e587  61 03 8b
    mov mem_00f9, a         ;e58a  45 f9
    mov mem_00fb, a         ;e58c  45 fb        KW1281 10416.67 bps transmit state = Do nothing
    mov mem_00fc, a         ;e58e  45 fc        XXX appears unused
    mov mem_0391, a         ;e590  61 03 91
    mov mem_0393, a         ;e593  61 03 93
    mov mem_00fa, a         ;e596  45 fa
    mov mem_039b, a         ;e598  61 03 9b
    ret                     ;e59b  20

lab_e59c:
;(mem_0388=2, mem_038b=0x0d)
    mov a, mem_00f1         ;e59c  05 f1
    bne lab_e55b            ;e59e  fc bb
    call sub_a239           ;e5a0  31 a2 39
    mov mem_00cd, #0x00     ;e5a3  85 cd 00
    mov a, #0x09            ;e5a6  04 09
    bne lab_e558            ;e5a8  fc ae        BRANCH_ALWAYS_TAKEN

mem_e5aa:
;Table used by sub_e5ae and sub_e61f
;Note: this table is read backwards starting at 0xe5ad
    .byte 0x00              ;e5aa  00          DATA '\x00'
    .byte 0x18              ;e5ab  18          DATA '\x18'
    .byte 0xBD              ;e5ac  bd          DATA '\xbd'
    .byte 0xE7              ;e5ad  e7          DATA '\xe7'

sub_e5ae:
;Unknown, uses mem_e5aa table
    movw a, mem_039f        ;e5ae  c4 03 9f
    movw mem_03a1, a        ;e5b1  d4 03 a1

    movw a, #0x0000         ;e5b4  e4 00 00
    movw mem_03a3, a        ;e5b7  d4 03 a3
    movw mem_03a5, a        ;e5ba  d4 03 a5
    movw mem_03a7, a        ;e5bd  d4 03 a7
    movw mem_03a9, a        ;e5c0  d4 03 a9
    movw mem_03ab, a        ;e5c3  d4 03 ab
    movw mem_03ad, a        ;e5c6  d4 03 ad
    mov mem_03b4, a         ;e5c9  61 03 b4

    movw a, tchr            ;e5cc  c5 19        16-bit timer count register
    movw mem_03a3, a        ;e5ce  d4 03 a3

    movw a, mem_03a1        ;e5d1  c4 03 a1
    movw a, mem_03a3        ;e5d4  c4 03 a3
    xorw a                  ;e5d7  53
    movw mem_03a5, a        ;e5d8  d4 03 a5

    mov r3, #0x00           ;e5db  8b 00
    call sub_e672           ;e5dd  31 e6 72

    movw a, mem_03a5        ;e5e0  c4 03 a5
    movw mem_03a7, a        ;e5e3  d4 03 a7

    movw a, mem_03a3        ;e5e6  c4 03 a3
    movw a, mem_03a7        ;e5e9  c4 03 a7
    xorw a                  ;e5ec  53
    movw mem_03a9, a        ;e5ed  d4 03 a9

    movw a, mem_03a7        ;e5f0  c4 03 a7
    movw mem_03ab, a        ;e5f3  d4 03 ab

    movw a, mem_03a9        ;e5f6  c4 03 a9
    movw mem_03ad, a        ;e5f9  d4 03 ad

    movw ix, #mem_03ae      ;e5fc  e6 03 ae
    movw ep, #mem_e5aa+3    ;e5ff  e7 e5 ad
    call sub_e6ca           ;e602  31 e6 ca     Unknown add 4 bytes IX/EP
    ret                     ;e605  20

sub_e606:
    mov r1, #0x00           ;e606  89 00
    mov r2, #0x02           ;e608  8a 02
    movw a, mem_03a3        ;e60a  c4 03 a3

lab_e60d:
    mov r7, #0x08           ;e60d  8f 08

lab_e60f:
    rolc a                  ;e60f  02
    bc lab_e613             ;e610  f9 01
    inc r1                  ;e612  c9

lab_e613:
    dec r7                  ;e613  df
    bne lab_e60f            ;e614  fc f9
    swap                    ;e616  10
    dec r2                  ;e617  da
    bne lab_e60d            ;e618  fc f3
    mov a, r1               ;e61a  09
    mov mem_03b4, a         ;e61b  61 03 b4
    ret                     ;e61e  20

sub_e61f:
;Unknown, uses e5aa table
;Called from e4cd (Block title 0x3d security related)
;Also called from a11c (unknown)
;
;Inputs:
;  mem_03ab - mem_03ae
;
    movw a, #0x0000         ;e61f  e4 00 00
    movw mem_03a1, a        ;e622  d4 03 a1
    movw mem_03a3, a        ;e625  d4 03 a3
    movw mem_03a5, a        ;e628  d4 03 a5
    movw mem_03a7, a        ;e62b  d4 03 a7
    movw mem_03a9, a        ;e62e  d4 03 a9
    mov mem_03b4, a         ;e631  61 03 b4

    movw a, mem_03ab        ;e634  c4 03 ab
    movw mem_03b0, a        ;e637  d4 03 b0

    movw a, mem_03ad        ;e63a  c4 03 ad
    movw mem_03b2, a        ;e63d  d4 03 b2

    movw ix, #mem_03ae      ;e640  e6 03 ae
    movw ep, #mem_e5aa+3    ;e643  e7 e5 ad
    call sub_e6b3           ;e646  31 e6 b3     Unknown subtract 4 bytes IX/EP

    movw a, mem_03ab        ;e649  c4 03 ab
    movw mem_03a7, a        ;e64c  d4 03 a7

    movw a, mem_03ad        ;e64f  c4 03 ad
    movw mem_03a9, a        ;e652  d4 03 a9

    movw a, mem_03a9        ;e655  c4 03 a9
    movw a, mem_03a7        ;e658  c4 03 a7
    xorw a                  ;e65b  53
    movw mem_03a3, a        ;e65c  d4 03 a3

    mov r3, #0x01           ;e65f  8b 01
    call sub_e672           ;e661  31 e6 72

    movw a, mem_03a7        ;e664  c4 03 a7
    movw mem_03a5, a        ;e667  d4 03 a5

    movw a, mem_03a3        ;e66a  c4 03 a3
    xorw a                  ;e66d  53
    movw mem_03a1, a        ;e66e  d4 03 a1
    ret                     ;e671  20


sub_e672:
    call sub_e606           ;e672  31 e6 06
lab_e675:
    mov a, mem_03b4         ;e675  60 03 b4
    beq lab_e690            ;e678  fd 16
    mov a, r3               ;e67a  0b
    bne lab_e683            ;e67b  fc 06
    call sub_e6a3           ;e67d  31 e6 a3
    jmp lab_e686            ;e680  21 e6 86
lab_e683:
    call sub_e691           ;e683  31 e6 91
lab_e686:
    mov a, mem_03b4         ;e686  60 03 b4
    decw a                  ;e689  d0
    mov mem_03b4, a         ;e68a  61 03 b4
    jmp lab_e675            ;e68d  21 e6 75
lab_e690:
    ret                     ;e690  20


sub_e691:
    movw a, mem_03a7        ;e691  c4 03 a7
    clrc                    ;e694  81
    swap                    ;e695  10
    rorc a                  ;e696  03
    swap                    ;e697  10
    rorc a                  ;e698  03
    bnc lab_e69f            ;e699  f8 04
    swap                    ;e69b  10
    or a, #0b10000000       ;e69c  74 80
    swap                    ;e69e  10
lab_e69f:
    movw mem_03a7, a        ;e69f  d4 03 a7
    ret                     ;e6a2  20


sub_e6a3:
    movw a, mem_03a5        ;e6a3  c4 03 a5
    clrc                    ;e6a6  81
    rolc a                  ;e6a7  02
    swap                    ;e6a8  10
    rolc a                  ;e6a9  02
    swap                    ;e6aa  10
    bnc lab_e6af            ;e6ab  f8 02
    or a, #0b00000001       ;e6ad  74 01
lab_e6af:
    movw mem_03a5, a        ;e6af  d4 03 a5
    ret                     ;e6b2  20


sub_e6b3:
;Unknown subtract 4 bytes IX/EP
    mov mem_009e, #0x04     ;e6b3  85 9e 04
    clrc                    ;e6b6  81
lab_e6b7:
    mov a, @ix+0x00         ;e6b7  06 00
    mov a, @ep              ;e6b9  07
    subc a                  ;e6ba  32
    mov @ix+0x00, a         ;e6bb  46 00

    decw ix                 ;e6bd  d2
    decw ep                 ;e6be  d3

    movw a, #0x0000         ;e6bf  e4 00 00
    mov a, mem_009e         ;e6c2  05 9e
    decw a                  ;e6c4  d0
    mov mem_009e, a         ;e6c5  45 9e

    bne lab_e6b7            ;e6c7  fc ee
    ret                     ;e6c9  20


sub_e6ca:
;Unknown add 4 bytes IX/EP
    mov mem_009e, #0x04     ;e6ca  85 9e 04
    clrc                    ;e6cd  81
lab_e6ce:
    mov a, @ix+0x00         ;e6ce  06 00
    mov a, @ep              ;e6d0  07
    addc a                  ;e6d1  22
    mov @ix+0x00, a         ;e6d2  46 00

    decw ix                 ;e6d4  d2
    decw ep                 ;e6d5  d3

    movw a, #0x0000         ;e6d6  e4 00 00
    mov a, mem_009e         ;e6d9  05 9e
    decw a                  ;e6db  d0
    mov mem_009e, a         ;e6dc  45 9e

    bne lab_e6ce            ;e6de  fc ee
    ret                     ;e6e0  20


fill_12_bytes_at_ix:
    mov @ix+0x0b, a         ;e6e1  46 0b
    mov @ix+0x0a, a         ;e6e3  46 0a
    mov @ix+0x09, a         ;e6e5  46 09
    mov @ix+0x08, a         ;e6e7  46 08

fill_8_bytes_at_ix:
    mov @ix+0x07, a         ;e6e9  46 07
    mov @ix+0x06, a         ;e6eb  46 06

fill_6_bytes_at_ix:
    mov @ix+0x05, a         ;e6ed  46 05

fill_5_bytes_at_ix:
    mov @ix+0x04, a         ;e6ef  46 04
    mov @ix+0x03, a         ;e6f1  46 03

fill_3_bytes_at_ix:
    mov @ix+0x02, a         ;e6f3  46 02
    mov @ix+0x01, a         ;e6f5  46 01
    mov @ix+0x00, a         ;e6f7  46 00
    ret                     ;e6f9  20


    ;XXX e6fa-e70c looks unreachable
    clrc                    ;e6fa  81
    addcw a                 ;e6fb  23
    movw ix, a              ;e6fc  e2
    mov a, @ix+0x00         ;e6fd  06 00
    mov mem_009e, a         ;e6ff  45 9e
    mov a, @ix+0x01         ;e701  06 01
    mov mem_009f, a         ;e703  45 9f
    mov a, @ix+0x02         ;e705  06 02
    mov mem_00a0, a         ;e707  45 a0
    call sub_fba3           ;e709  31 fb a3
    ret                     ;e70c  20


sub_e70d:
    clrb mem_00e5:1         ;e70d  a1 e5
    clrb mem_00e5:4         ;e70f  a4 e5
    clrb mem_00e5:5         ;e711  a5 e5
    ret                     ;e713  20

sub_e714:
    mov a, mem_0292         ;e714  60 02 92
    mov mem_0293, a         ;e717  61 02 93
    movw a, #0x0000         ;e71a  e4 00 00
    mov a, @ep              ;e71d  07
    beq lab_e728            ;e71e  fd 08
    decw a                  ;e720  d0
    mov @ep, a              ;e721  47
    cmp a, #0x00            ;e722  14 00
    beq lab_e728            ;e724  fd 02
    setb mem_00d9:4         ;e726  ac d9
lab_e728:
    ret                     ;e728  20


sub_e729:
    rolc a                  ;e729  02
    swap                    ;e72a  10
    incw a                  ;e72b  c0
    cmp a, #0x05            ;e72c  14 05
    swap                    ;e72e  10
    ret                     ;e72f  20


sub_e730:
    mov a, mem_0292         ;e730  60 02 92
    clrc                    ;e733  81
    addc a                  ;e734  22
    cmp a, #0x2d            ;e735  14 2d
    blo lab_e73b            ;e737  f9 02
    mov a, #0x2d            ;e739  04 2d
lab_e73b:
    ret                     ;e73b  20


sub_e73c:
;Jump to address in table
;
;A = pointer to table
;T = table index
;
    xchw a, t               ;e73c  43       A=table index, T=pointer to table

    ;Clear AH (table index high byte)
    swap                    ;e73d  10       AH <-> AL
    and a, #0x00            ;e73e  64 00    Clear AL
    swap                    ;e740  10       AH <-> AL

    ;Compute address of table entry from the index
    clrc                    ;e741  81
    rolc a                  ;e742  02       Multiply table index by 2 since each
                            ;                 entry is a 2-byte pointer
    addcw a                 ;e743  23       Add to table base address

    ;Jump to address in table
    movw a, @a              ;e744  93       A = value stored at address computed above
    jmp @a                  ;e745  e0       Jump to that address


sub_e746:
    mov a, @ix+0x00         ;e746  06 00
    cmp a, #0xff            ;e748  14 ff
    beq lab_e754            ;e74a  fd 08
    cmp a                   ;e74c  12
    beq lab_e754            ;e74d  fd 05
    incw ix                 ;e74f  c2
    incw ix                 ;e750  c2
    xchw a, t               ;e751  43
    bne sub_e746            ;e752  fc f2        BRANCH_ALWAYS_TAKEN
lab_e754:
    mov a, @ix+0x01         ;e754  06 01
    ret                     ;e756  20


sub_e757:
    mov a, @ix+0x00         ;e757  06 00
    cmp a, #0xff            ;e759  14 ff
    beq lab_e767            ;e75b  fd 0a
    cmp a                   ;e75d  12
    beq lab_e767            ;e75e  fd 07
    incw ix                 ;e760  c2
    incw ix                 ;e761  c2
    incw ix                 ;e762  c2
    incw ix                 ;e763  c2
    xchw a, t               ;e764  43
    bne sub_e757            ;e765  fc f0        BRANCH_ALWAYS_TAKEN
lab_e767:
    mov a, @ix+0x01         ;e767  06 01
    movw a, @ix+0x02        ;e769  c6 02
    jmp @a                  ;e76b  e0


sub_e76c:
    mov a, @ix+0x00         ;e76c  06 00
    cmp a, #0xff            ;e76e  14 ff
    beq lab_e779            ;e770  fd 07
    cmp a                   ;e772  12
    beq lab_e77b            ;e773  fd 06
    incw ix                 ;e775  c2
    xchw a, t               ;e776  43
    bne sub_e76c            ;e777  fc f3        BRANCH_ALWAYS_TAKEN
lab_e779:
    clrc                    ;e779  81
    ret                     ;e77a  20

lab_e77b:
    setc                    ;e77b  91
    ret                     ;e77c  20


dec8_at_ix_nowrap:
;Decrement 8-bit value @IX.  No wrap past 0.
;Returns decremented value in A.
    mov a, @ix+0x00         ;e77d  06 00
    beq lab_e789            ;e77f  fd 08

dec8_at_ix:
;Decrement 8-bit value @IX.  Wraps from 0 to 0xFF.
;Returns decremented value in A.
    movw a, #0x0000         ;e781  e4 00 00
    mov a, @ix+0x00         ;e784  06 00
    decw a                  ;e786  d0
    mov @ix+0x00, a         ;e787  46 00

lab_e789:
    ret                     ;e789  20

dec16_at_ix:
;Decrement 16-bit value @IX.  Wraps from 0 to 0xFFFF.
;Returns decremented value in A.
    movw a, @ix+0x00        ;e78a  c6 00
    decw a                  ;e78c  d0
    movw @ix+0x00, a        ;e78d  d6 00
    ret                     ;e78f  20


sub_e790:
    call sub_e80a           ;e790  31 e8 0a
    bbs mem_00e7:0, lab_e7e8 ;e793  b8 e7 52
    bbc mem_00e7:4, lab_e7e8 ;e796  b4 e7 4f
    clrb mem_00e7:4         ;e799  a4 e7
    bbc mem_00e1:7, lab_e7e9 ;e79b  b7 e1 4b

    mov a, #0x82            ;e79e  04 82        0x82 = Write only to FIS (used during KW1281 output tests)
    mov mem_0215, a         ;e7a0  61 02 15

lab_e7a3:
    movw ix, #mem_02b6      ;e7a3  e6 02 b6

    movw a, @ix+0x00        ;e7a6  c6 00        Copy 0x2b6,0x2b7 -> 0x216,0x217
    movw mem_0216, a        ;e7a8  d4 02 16

    movw a, @ix+0x02        ;e7ab  c6 02        Copy 0x2b8,0x2b9 -> 0x218,0x219
    movw mem_0218, a        ;e7ad  d4 02 18

    mov a, @ix+0x04         ;e7b0  06 04        Copy 0x2ba,0x2bb -> 0x21a,0x21b
    mov mem_021a, a         ;e7b2  61 02 1a

lab_e7b5:
    movw a, mem_0215        ;e7b5  c4 02 15     Copy packet to send to Sub-MCU bytes 0, 1
    movw mem_0222, a        ;e7b8  d4 02 22

    movw a, mem_0217        ;e7bb  c4 02 17     Copy packet to send to Sub-MCU bytes 2, 3
    movw mem_0224, a        ;e7be  d4 02 24

    movw a, mem_0219        ;e7c1  c4 02 19     Copy packet to send to Sub-MCU bytes 4, 5
    movw mem_0226, a        ;e7c4  d4 02 26

    mov a, mem_021b         ;e7c7  60 02 1b
    mov mem_0228, a         ;e7ca  61 02 28

    mov a, #0x06            ;e7cd  04 06        6 bytes to send to Sub-MCU
    mov mem_022f, a         ;e7cf  61 02 2f

    mov a, #0x00            ;e7d2  04 00
    mov mem_03b7, a         ;e7d4  61 03 b7
    setb mem_00e7:0         ;e7d7  a8 e7
    mov comp4, #0x7d        ;e7d9  85 49 7d
    mov cntr4, #0x1c        ;e7dc  85 48 1c
    setb cntr4:0            ;e7df  a8 48
    clrb mem_00e7:7         ;e7e1  a7 e7
    mov a, #0x00            ;e7e3  04 00
    mov mem_03b6, a         ;e7e5  61 03 b6

lab_e7e8:
    ret                     ;e7e8  20

lab_e7e9:
    bbc mem_00e2:0, lab_e802 ;e7e9  b0 e2 16
    clrb mem_00e2:0         ;e7ec  a0 e2

    mov a, #0x83            ;e7ee  04 83        0x83 = Sub-MCU play dead
    mov mem_0215, a         ;e7f0  61 02 15

    movw a, #0x0000         ;e7f3  e4 00 00
    movw mem_0216, a        ;e7f6  d4 02 16
    movw mem_0218, a        ;e7f9  d4 02 18
    mov mem_021a, a         ;e7fc  61 02 1a
    jmp lab_e7b5            ;e7ff  21 e7 b5

lab_e802:
    mov a, #0x81            ;e802  04 81        0x81 = Write to both LCD and FIS
    mov mem_0215, a         ;e804  61 02 15
    jmp lab_e7a3            ;e807  21 e7 a3

sub_e80a:
    bbs mem_00e7:0, lab_e814 ;e80a  b8 e7 07
    bbc mem_0097:2, lab_e815 ;e80d  b2 97 05
    clrb mem_0097:2         ;e810  a2 97
    setb mem_00e7:4         ;e812  ac e7

lab_e814:
    ret                     ;e814  20

lab_e815:
    bbc mem_00e2:0, lab_e814 ;e815  b0 e2 fc
    setb mem_00e7:4         ;e818  ac e7
    ret                     ;e81a  20

sub_e81b:
    bbc mem_00e7:3, lab_e839 ;e81b  b3 e7 1b    Bail out if Sub-to-Main packet not ready
    clrb mem_00e7:3         ;e81e  a3 e7
    setb mem_0098:1         ;e820  a9 98

    mov a, mem_0230         ;e822  60 02 30     Sub-to-Main Byte 0
    mov mem_0236, a         ;e825  61 02 36

    mov a, mem_0231         ;e828  60 02 31     Sub-to-Main Byte 1
    mov mem_00e8, a         ;e82b  45 e8

    mov a, mem_0232         ;e82d  60 02 32     Sub-to-Main Byte 2
    mov mem_0255, a         ;e830  61 02 55

    mov a, mem_0233         ;e833  60 02 33     Sub-to-Main Byte 3
    mov mem_03b5, a         ;e836  61 03 b5

lab_e839:
    ret                     ;e839  20


submcu_send_packet:
;Called from ISR for IRQ5 (2ch 8-bit pwm timer)
    bbc mem_00e7:0, lab_e86a ;e83a  b0 e7 2d
    bbc mem_00e7:7, lab_e86b ;e83d  b7 e7 2b

    movw a, #0x0000         ;e840  e4 00 00     Packet offset = 0
    mov a, mem_03b7         ;e843  60 03 b7

    movw a, #mem_0222       ;e846  e4 02 22     A = pointer to packet to send to Sub-MCU
    clrc                    ;e849  81
    addcw a                 ;e84a  23           Add offset into packet
    mov a, @a               ;e84b  92           A = byte in packet
    call submcu_send_byte   ;e84c  31 e8 bb     Send byte to Sub-MCU

    mov a, mem_03b7         ;e84f  60 03 b7     Increment packet offset
    incw a                  ;e852  c0
    mov mem_03b7, a         ;e853  61 03 b7

    movw a, #0x0000         ;e856  e4 00 00
    mov a, mem_022f         ;e859  60 02 2f
    decw a                  ;e85c  d0           Decrement count of bytes left to send to Sub-MCU
    mov mem_022f, a         ;e85d  61 02 2f

    bne lab_e86a            ;e860  fc 08
    clrb mem_00e7:0         ;e862  a0 e7
    clrb cntr4:3            ;e864  a3 48
    clrb cntr4:0            ;e866  a0 48
    setb pdr8:5             ;e868  ad 14        /M2S_ENABLE = high (disabled)

lab_e86a:
    ret                     ;e86a  20

lab_e86b:
    clrb pdr8:5             ;e86b  a5 14        /M2S_ENABLE = low (enabled)
    mov a, mem_03b6         ;e86d  60 03 b6
    incw a                  ;e870  c0
    mov mem_03b6, a         ;e871  61 03 b6
    cmp a, #0x02            ;e874  14 02
    bne lab_e86a            ;e876  fc f2
    setb mem_00e7:7         ;e878  af e7
    ret                     ;e87a  20

sub_e87b:
    bbc mem_00e7:2, lab_e883 ;e87b  b2 e7 05
    mov a, #0x00            ;e87e  04 00
    mov mem_0238, a         ;e880  61 02 38

lab_e883:
    mov a, #0x04            ;e883  04 04        4 bytes to receive from Sub-MCU
    mov mem_0237, a         ;e885  61 02 37
    setb mem_00e7:1         ;e888  a9 e7
    clrb mem_00e7:2         ;e88a  a2 e7
    clrc                    ;e88c  81
    bbc pdr4:1, lab_e891    ;e88d  b1 0e 01     S2M_DATA_IN
    setc                    ;e890  91

lab_e891:
    movw ix, #mem_0230      ;e891  e6 02 30
    mov a, @ix+0x03         ;e894  06 03
    rolc a                  ;e896  02
    mov @ix+0x03, a         ;e897  46 03
    mov a, @ix+0x02         ;e899  06 02
    rolc a                  ;e89b  02
    mov @ix+0x02, a         ;e89c  46 02
    mov a, @ix+0x01         ;e89e  06 01
    rolc a                  ;e8a0  02
    mov @ix+0x01, a         ;e8a1  46 01
    mov a, @ix+0x00         ;e8a3  06 00
    rolc a                  ;e8a5  02
    mov @ix+0x00, a         ;e8a6  46 00
    mov a, mem_0238         ;e8a8  60 02 38
    incw a                  ;e8ab  c0
    mov mem_0238, a         ;e8ac  61 02 38
    cmp a, #0x20            ;e8af  14 20        32 bits received? (4 bytes * 8)
    bne lab_e8ba            ;e8b1  fc 07
    mov a, #0x00            ;e8b3  04 00
    mov mem_0238, a         ;e8b5  61 02 38
    setb mem_00e7:3         ;e8b8  ab e7        Set Sub-to-Main packet ready flag

lab_e8ba:
    ret                     ;e8ba  20

submcu_send_byte:
;Send a byte to the Sub-MCU
    movw ix, #0x0000        ;e8bb  e6 00 00
lab_e8be:
    rolc a                  ;e8be  02
    bnc lab_e8db            ;e8bf  f8 1a
    setb pdr4:4             ;e8c1  ac 0e        M2S_DAT_OUT = high
lab_e8c3:
    clrb pdr4:5             ;e8c3  a5 0e        /M2S_CLK_OUT = low
    nop                     ;e8c5  00
    nop                     ;e8c6  00
    nop                     ;e8c7  00
    nop                     ;e8c8  00
    nop                     ;e8c9  00
    nop                     ;e8ca  00
    nop                     ;e8cb  00
    nop                     ;e8cc  00
    setb pdr4:5             ;e8cd  ad 0e        /M2S_CLK_OUT = high
    incw ix                 ;e8cf  c2
    movw ep, a              ;e8d0  e3
    movw a, ix              ;e8d1  f2
    cmp a, #0x08            ;e8d2  14 08
    beq lab_e8da            ;e8d4  fd 04
    movw a, ep              ;e8d6  f3
    jmp lab_e8be            ;e8d7  21 e8 be
lab_e8da:
    ret                     ;e8da  20

lab_e8db:
    clrb pdr4:4             ;e8db  a4 0e        M2S_DAT_OUT = low
    jmp lab_e8c3            ;e8dd  21 e8 c3


sub_e8e0:
;Called from ISR for IRQ1 (external interrupt 2)
;when INT5 level detect status changes (/S2M_ENABLE)
    bbc pdr6:5, lab_e8ed    ;e8e0  b5 11 0a     /SCA_CLK_IN
    clrb eie2:3             ;e8e3  a3 3a
    clrb eic1:4             ;e8e5  a4 38
    clrb eic1:7             ;e8e7  a7 38        Clear INT1 pin edge detect status (/S2M_CLK_IN)

lab_e8e9:
    nop                     ;e8e9  00
    clrb eif2:1             ;e8ea  a1 3b
    ret                     ;e8ec  20

lab_e8ed:
    setb eie2:3             ;e8ed  ab 3a
    mov a, #0x00            ;e8ef  04 00
    mov mem_0238, a         ;e8f1  61 02 38
    setb eic1:4             ;e8f4  ac 38
    clrb eic1:7             ;e8f6  a7 38        Clear INT1 edge detect status (/S2M_CLK_IN)
    jmp lab_e8e9            ;e8f8  21 e8 e9

sub_e8fb:
    call sub_e9ad           ;e8fb  31 e9 ad
    mov a, mem_01ef         ;e8fe  60 01 ef
    bne lab_e93b            ;e901  fc 38
    bbc mem_00df:0, lab_e93f ;e903  b0 df 39
    call sub_ef15           ;e906  31 ef 15
    mov a, #0x0a            ;e909  04 0a
    mov mem_03cd, a         ;e90b  61 03 cd
    clrb mem_00df:3         ;e90e  a3 df
    setb mem_00df:4         ;e910  ac df
    mov a, #0x01            ;e912  04 01
    mov mem_03d0, a         ;e914  61 03 d0
    bbc mem_00e1:1, lab_e938 ;e917  b1 e1 1e
    clrb mem_00df:0         ;e91a  a0 df
    setb mem_00e0:7         ;e91c  af e0
    clrb mem_00d9:3         ;e91e  a3 d9
    mov a, #0x00            ;e920  04 00
    mov mem_03cf, a         ;e922  61 03 cf
    mov mem_01c6, a         ;e925  61 01 c6
    mov a, #0x0b            ;e928  04 0b

lab_e92a:
    mov mem_01c7, a         ;e92a  61 01 c7
    mov a, #0x00            ;e92d  04 00
    mov mem_01ce, a         ;e92f  61 01 ce

lab_e932:
    call sub_edc0           ;e932  31 ed c0

lab_e935:
    bbc mem_00e0:7, lab_e93b ;e935  b7 e0 03

lab_e938:
    call sub_e9fa           ;e938  31 e9 fa

lab_e93b:
    call sub_eacd           ;e93b  31 ea cd
    ret                     ;e93e  20

lab_e93f:
    bbc mem_00df:1, lab_e948 ;e93f  b1 df 06
    clrb mem_00df:1         ;e942  a1 df
    mov a, #0x09            ;e944  04 09

lab_e946:
    bne lab_e92a            ;e946  fc e2        BRANCH_ALWAYS_TAKEN

lab_e948:
    mov a, mem_01c6         ;e948  60 01 c6
    cmp a, #0x8c            ;e94b  14 8c
    beq lab_e97d            ;e94d  fd 2e
    mov a, mem_01ce         ;e94f  60 01 ce
    cmp a, #0x0f            ;e952  14 0f
    bne lab_e932            ;e954  fc dc
    mov a, mem_01c7         ;e956  60 01 c7
    cmp a, #0x09            ;e959  14 09
    bne lab_e978            ;e95b  fc 1b
    setb mem_00df:2         ;e95d  aa df
    clrb mem_00e0:7         ;e95f  a7 e0
    mov a, #0x00            ;e961  04 00
    mov mem_01c7, a         ;e963  61 01 c7
    mov mem_01ce, a         ;e966  61 01 ce
    mov mem_03d0, a         ;e969  61 03 d0
    clrb mem_00e0:2         ;e96c  a2 e0
    clrb mem_00e1:5         ;e96e  a5 e1
    call sub_ef1b           ;e970  31 ef 1b
    call sub_ef20           ;e973  31 ef 20
    beq lab_e93b            ;e976  fd c3

lab_e978:
    mov a, mem_01c6         ;e978  60 01 c6
    beq lab_e988            ;e97b  fd 0b

lab_e97d:
    call sub_eafd           ;e97d  31 ea fd
    blo lab_e988            ;e980  f9 06
    call sub_eb28           ;e982  31 eb 28
    jmp lab_e932            ;e985  21 e9 32

lab_e988:
    bbc mem_00d9:3, lab_e99e ;e988  b3 d9 13
    clrb mem_00d9:3         ;e98b  a3 d9
    mov a, mem_01df         ;e98d  60 01 df
    and a, #0x24            ;e990  64 24
    beq lab_e99e            ;e992  fd 0a
    mov a, #0x09            ;e994  04 09
    mov mem_01c6, a         ;e996  61 01 c6
    bne lab_e97d            ;e999  fc e2        BRANCH_ALWAYS_TAKEN

    ;XXX e99b looks unreachable
    jmp lab_e97d              ;e99b 21 e9 7d

lab_e99e:
    mov a, mem_00b1         ;e99e  05 b1
    beq lab_e935            ;e9a0  fd 93
    mov a, mem_01df         ;e9a2  60 01 df
    and a, #0x12            ;e9a5  64 12
    beq lab_e935            ;e9a7  fd 8c
    mov a, #0x06            ;e9a9  04 06
    bne lab_e946            ;e9ab  fc 99        BRANCH_ALWAYS_TAKEN

sub_e9ad:
    bbc mem_00e2:1, lab_e9d9 ;e9ad  b1 e2 29
    clrb mem_00e2:1         ;e9b0  a1 e2
    setb mem_00e0:1         ;e9b2  a9 e0
    mov a, #0x05            ;e9b4  04 05
    mov mem_03c5, a         ;e9b6  61 03 c5

lab_e9b9:
    mov a, mem_01e0         ;e9b9  60 01 e0
    and a, #0xf0            ;e9bc  64 f0
    cmp a, #0xb0            ;e9be  14 b0
    bne lab_e9e2            ;e9c0  fc 20
    mov a, #0x00            ;e9c2  04 00
    mov mem_03ce, a         ;e9c4  61 03 ce

lab_e9c7:
    mov a, mem_03d1         ;e9c7  60 03 d1
    cmp a, #0x01            ;e9ca  14 01
    bne lab_e9d8            ;e9cc  fc 0a
    mov a, mem_03ce         ;e9ce  60 03 ce
    bne lab_e9d8            ;e9d1  fc 05
    mov a, #0x00            ;e9d3  04 00
    mov mem_03d1, a         ;e9d5  61 03 d1

lab_e9d8:
    ret                     ;e9d8  20

lab_e9d9:
    mov a, mem_03c5         ;e9d9  60 03 c5
    bne lab_e9b9            ;e9dc  fc db
    clrb mem_00e0:1         ;e9de  a1 e0
    beq lab_e9b9            ;e9e0  fd d7        BRANCH_ALWAYS_TAKEN

lab_e9e2:
    cmp a, #0x70            ;e9e2  14 70
    bne lab_e9f3            ;e9e4  fc 0d
    mov a, mem_03ce         ;e9e6  60 03 ce
    cmp a, #0x01            ;e9e9  14 01
    bne lab_e9c7            ;e9eb  fc da

lab_e9ed:
    incw a                  ;e9ed  c0
    mov mem_03ce, a         ;e9ee  61 03 ce
    bne lab_e9c7            ;e9f1  fc d4

lab_e9f3:
    mov a, mem_03ce         ;e9f3  60 03 ce
    bne lab_e9c7            ;e9f6  fc cf
    beq lab_e9ed            ;e9f8  fd f3        BRANCH_ALWAYS_TAKEN

sub_e9fa:
    bbc mem_00e0:3, lab_ea19 ;e9fa  b3 e0 1c
    bbs mem_00e1:2, lab_ea0e ;e9fd  ba e1 0e
    bbs mem_00e1:5, lab_ea08 ;ea00  bd e1 05
    clrb mem_00e0:3         ;ea03  a3 e0
    setb mem_00df:1         ;ea05  a9 df

lab_ea07:
    ret                     ;ea07  20

lab_ea08:
    clrb mem_00e1:5         ;ea08  a5 e1
    call sub_ef19           ;ea0a  31 ef 19
    ret                     ;ea0d  20

lab_ea0e:
    mov a, mem_01e0         ;ea0e  60 01 e0
    and a, #0x0e            ;ea11  64 0e
    bne lab_ea07            ;ea13  fc f2
    call sub_ef17           ;ea15  31 ef 17
    ret                     ;ea18  20

lab_ea19:
    call sub_eab3           ;ea19  31 ea b3
    bbc mem_00e0:1, lab_ea27 ;ea1c  b1 e0 08
    mov a, mem_03cd         ;ea1f  60 03 cd
    bne lab_ea07            ;ea22  fc e3
    bbc mem_00df:7, lab_ea07 ;ea24  b7 df e0

lab_ea27:
    mov a, mem_01e0         ;ea27  60 01 e0
    and a, #0xf0            ;ea2a  64 f0
    cmp a, #0x30            ;ea2c  14 30
    bne lab_ea9c            ;ea2e  fc 6c
    mov a, #0x02            ;ea30  04 02
    mov mem_03ce, a         ;ea32  61 03 ce
    mov mem_03cf, a         ;ea35  61 03 cf

lab_ea38:
    mov a, mem_00e0         ;ea38  05 e0
    and a, #0x02            ;ea3a  64 02
    beq lab_ea8a            ;ea3c  fd 4c
    mov a, mem_01e0         ;ea3e  60 01 e0
    and a, #0xf0            ;ea41  64 f0
    cmp a, #0xb0            ;ea43  14 b0
    beq lab_ea92            ;ea45  fd 4b
    bbs mem_00e1:5, lab_ea62 ;ea47  bd e1 18
    mov a, mem_01e0         ;ea4a  60 01 e0
    and a, #0x0e            ;ea4d  64 0e
    beq lab_ea5c            ;ea4f  fd 0b
    cmp a, #0x08            ;ea51  14 08
    bne lab_ea62            ;ea53  fc 0d
    mov a, #0x01            ;ea55  04 01
    mov mem_03d1, a         ;ea57  61 03 d1
    bne lab_ea97            ;ea5a  fc 3b        BRANCH_ALWAYS_TAKEN

lab_ea5c:
    mov a, #0x00            ;ea5c  04 00
    mov mem_03d1, a         ;ea5e  61 03 d1
    ret                     ;ea61  20

lab_ea62:
    bbs mem_00e1:6, lab_ea07 ;ea62  be e1 a2
    bbs mem_00e1:2, lab_ea07 ;ea65  ba e1 9f
    setb mem_00e1:6         ;ea68  ae e1
    bbs mem_00e1:5, lab_ea79 ;ea6a  bd e1 0c
    mov a, mem_01e0         ;ea6d  60 01 e0
    and a, #0x06            ;ea70  64 06
    beq lab_ea79            ;ea72  fd 05
    mov mem_03c6, a         ;ea74  61 03 c6
    setb mem_00e1:2         ;ea77  aa e1

lab_ea79:
    mov a, #0x01            ;ea79  04 01
    mov mem_02cc, a         ;ea7b  61 02 cc
    setb mem_00e0:2         ;ea7e  aa e0
    clrb mem_00e0:3         ;ea80  a3 e0
    mov a, #0x20            ;ea82  04 20
    mov mem_01cd, a         ;ea84  61 01 cd
    jmp lab_ea07            ;ea87  21 ea 07

lab_ea8a:
    mov a, #0x00            ;ea8a  04 00
    movw ix, #mem_01da      ;ea8c  e6 01 da
    call fill_8_bytes_at_ix ;ea8f  31 e6 e9

lab_ea92:
    mov a, #0x00            ;ea92  04 00
    mov mem_03ce, a         ;ea94  61 03 ce

lab_ea97:
    setb mem_00e1:4         ;ea97  ac e1
    jmp lab_ea62            ;ea99  21 ea 62

lab_ea9c:
    cmp a, #0x90            ;ea9c  14 90
    bne lab_ea38            ;ea9e  fc 98
    mov a, mem_03ce         ;eaa0  60 03 ce
    cmp a, #0x02            ;eaa3  14 02
    bne lab_ea38            ;eaa5  fc 91
    mov a, mem_03cf         ;eaa7  60 03 cf
    bne lab_ea38            ;eaaa  fc 8c
    mov a, #0x01            ;eaac  04 01
    mov mem_03ce, a         ;eaae  61 03 ce
    bne lab_ea38            ;eab1  fc 85        BRANCH_ALWAYS_TAKEN

sub_eab3:
    bbc mem_00e0:1, lab_eac1 ;eab3  b1 e0 0b
    mov a, mem_03ce         ;eab6  60 03 ce
    beq lab_eac1            ;eab9  fd 06
    mov a, mem_01e1         ;eabb  60 01 e1
    rolc a                  ;eabe  02
    blo lab_eac4            ;eabf  f9 03

lab_eac1:
    clrb mem_00d9:7         ;eac1  a7 d9
    ret                     ;eac3  20

lab_eac4:
    bbs mem_00e1:6, lab_eac1 ;eac4  be e1 fa
    bbs mem_00e1:2, lab_eac1 ;eac7  ba e1 f7
    setb mem_00d9:7         ;eaca  af d9
    ret                     ;eacc  20

sub_eacd:
    bbc mem_00e1:3, lab_eaef ;eacd  b3 e1 1f
    clrb mem_00e1:3         ;ead0  a3 e1
    movw a, #0x0000         ;ead2  e4 00 00
    mov a, mem_01e3         ;ead5  60 01 e3
    and a, #0x0f            ;ead8  64 0f
    clrc                    ;eada  81
    subc a, #0x01           ;eadb  34 01
    blo lab_eaee            ;eadd  f9 0f
    cmp a, #0x06            ;eadf  14 06
    bhs lab_eaee            ;eae1  f8 0b
    clrc                    ;eae3  81
    rolc a                  ;eae4  02
    movw a, #0x03b8         ;eae5  e4 03 b8
    addcw a                 ;eae8  23
    movw ep, a              ;eae9  e3
    movw a, mem_01e3        ;eaea  c4 01 e3
    movw @ep, a             ;eaed  d7

lab_eaee:
    ret                     ;eaee  20

lab_eaef:
    bbc mem_00e1:4, lab_eaee ;eaef  b4 e1 fc
    clrb mem_00e1:4          ;eaf2  a4 e1
    mov a, #0x00             ;eaf4  04 00
    movw ix, #mem_03b8       ;eaf6  e6 03 b8
    call fill_12_bytes_at_ix ;eaf9  31 e6 e1
    ret                      ;eafc  20

sub_eafd:
    bbc mem_00e1:2, lab_eb1f ;eafd  b2 e1 1f
    mov a, mem_03c6         ;eb00  60 03 c6
    cmp a, #0x06            ;eb03  14 06
    bne lab_eb0e            ;eb05  fc 07

lab_eb07:
    mov a, #0x00            ;eb07  04 00
    mov mem_01c6, a         ;eb09  61 01 c6
    setc                    ;eb0c  91
    ret                     ;eb0d  20

lab_eb0e:
    mov a, mem_01c6         ;eb0e  60 01 c6
    cmp a, #0x07            ;eb11  14 07
    bhs lab_eb07            ;eb13  f8 f2
    call sub_ef13           ;eb15  31 ef 13
    mov a, #0x0a            ;eb18  04 0a
    mov mem_03cd, a         ;eb1a  61 03 cd

lab_eb1d:
    clrc                    ;eb1d  81
    ret                     ;eb1e  20

lab_eb1f:
    bbc mem_00e1:6, lab_eb1d ;eb1f  b6 e1 fb
    bbs mem_00e1:5, lab_eb1d ;eb22  bd e1 f8
    jmp lab_eb07            ;eb25  21 eb 07

sub_eb28:
    mov a, mem_01c6         ;eb28  60 01 c6
    cmp a, #0x07            ;eb2b  14 07
    bhs lab_eb5b            ;eb2d  f8 2c
    call sub_ef20           ;eb2f  31 ef 20
    mov a, #0x01            ;eb32  04 01
    mov mem_03cf, a         ;eb34  61 03 cf
    call sub_ebb2           ;eb37  31 eb b2
    bhs lab_eb4c            ;eb3a  f8 10
    mov a, mem_01c6         ;eb3c  60 01 c6
    mov mem_01cf, a         ;eb3f  61 01 cf
    mov a, #0x01            ;eb42  04 01

lab_eb44:
    mov mem_01c7, a         ;eb44  61 01 c7
    mov a, #0x00            ;eb47  04 00
    mov mem_01ce, a         ;eb49  61 01 ce

lab_eb4c:
    mov a, #0x00            ;eb4c  04 00
    mov mem_01c6, a         ;eb4e  61 01 c6
    clrb mem_00df:4         ;eb51  a4 df
    setb mem_00df:3         ;eb53  ab df
    mov a, #0x10            ;eb55  04 10
    mov mem_01cc, a         ;eb57  61 01 cc
    ret                     ;eb5a  20

lab_eb5b:
    mov a, #0x07            ;eb5b  04 07
    movw ix, #mem_eb97      ;eb5d  e6 eb 97

lab_eb60:
    cmp a, #0x10            ;eb60  14 10
    beq lab_eb70            ;eb62  fd 0c
    cmp a                   ;eb64  12
    beq lab_eb6d            ;eb65  fd 06
    incw ix                 ;eb67  c2
    incw ix                 ;eb68  c2
    incw ix                 ;eb69  c2
    incw a                  ;eb6a  c0
    bne lab_eb60            ;eb6b  fc f3

lab_eb6d:
    movw a, @ix+0x01        ;eb6d  c6 01
    jmp @a                  ;eb6f  e0

lab_eb70:
    xchw a, t               ;eb70  43
    cmp a, #0x8c            ;eb71  14 8c
    bne lab_eb44            ;eb73  fc cf
    setb mem_00e0:0         ;eb75  a8 e0
    beq lab_eb4c            ;eb77  fd d3        BRANCH_ALWAYS_TAKEN

lab_eb79:
    clrb mem_00e0:0         ;eb79  a0 e0

lab_eb7b:
    call sub_ef20           ;eb7b  31 ef 20

lab_eb7e:
    mov a, @ix+0x00         ;eb7e  06 00
    bne lab_eb44            ;eb80  fc c2

lab_eb82:
    bbc mem_00de:2, lab_eb7e ;eb82  b2 de f9
    mov a, @ix+0x00         ;eb85  06 00
    decw a                  ;eb87  d0
    bne lab_eb44            ;eb88  fc ba

lab_eb8a:
    mov a, ccra1            ;eb8a  05 32
    mov mem_01ec, a         ;eb8c  61 01 ec
    setb mem_00da:6         ;eb8f  ae da
    clrb mem_00da:7         ;eb91  a7 da
    clrb mem_00e0:0         ;eb93  a0 e0
    bne lab_eb7e            ;eb95  fc e7

mem_eb97:
    .byte 0x0B              ;DATA '\x0b'
    .word lab_eb7b

    .byte 0x06              ;DATA '\x06'
    .word lab_eb7b

    .byte 0x08              ;DATA '\x08'
    .word lab_eb82

    .byte 0x02              ;DATA '\x02'
    .word lab_eb7b

    .byte 0x03              ;DATA '\x03'
    .word lab_eb7b

    .byte 0x04              ;DATA '\x04'
    .word lab_eb8a

    .byte 0x05              ;DATA '\x05'
    .word lab_eb8a

    .byte 0x0C              ;DATA '\x0c'
    .word lab_eb79

    .byte 0x0D              ;DATA '\r'
    .word lab_eb79

sub_ebb2:
    movw a, #0x0000         ;ebb2  e4 00 00
    mov a, mem_01c6         ;ebb5  60 01 c6
    mov mem_03cc, a         ;ebb8  61 03 cc
    decw a                  ;ebbb  d0
    clrc                    ;ebbc  81
    rolc a                  ;ebbd  02
    movw a, #mem_03b8       ;ebbe  e4 03 b8
    addcw a                 ;ebc1  23
    mov a, @a               ;ebc2  92
    and a, #0x40            ;ebc3  64 40
    setc                    ;ebc5  91
    bne lab_ebcb            ;ebc6  fc 03
    setb mem_00e1:5         ;ebc8  ad e1
    clrc                    ;ebca  81

lab_ebcb:
    ret                     ;ebcb  20

sub_ebcc:
    bbs mem_00df:4, lab_ebd2 ;ebcc  bc df 03
    bbs mem_00df:3, lab_ebfc ;ebcf  bb df 2a

lab_ebd2:
    bbs mem_00e1:0, lab_ebe5 ;ebd2  b8 e1 10
    bbc mem_00e0:1, lab_ebe0 ;ebd5  b1 e0 08
    mov a, mem_03cd         ;ebd8  60 03 cd
    bne lab_ebfc            ;ebdb  fc 1f
    bbc mem_00df:7, lab_ebfc ;ebdd  b7 df 1c

lab_ebe0:
    mov a, mem_03d0         ;ebe0  60 03 d0
    beq lab_ebfc            ;ebe3  fd 17

lab_ebe5:
    setb mem_0097:2         ;ebe5  aa 97
    clrb mem_00df:4         ;ebe7  a4 df
    setb mem_00df:3         ;ebe9  ab df
    mov a, #0x0b            ;ebeb  04 0b
    mov mem_01cc, a         ;ebed  61 01 cc
    movw ix, #mem_02b6      ;ebf0  e6 02 b6
    bbc mem_00e0:6, lab_ec06 ;ebf3  b6 e0 10
    movw ep, #mem_03c7      ;ebf6  e7 03 c7
    call copy_5_bytes_ep_to_ix ;ebf9  31 ef 25

lab_ebfc:
    movw ix, #mem_03d4      ;ebfc  e6 03 d4
    movw ep, #mem_02b6      ;ebff  e7 02 b6
    call copy_5_bytes_ep_to_ix ;ec02  31 ef 25
    ret                     ;ec05  20

lab_ec06:
    movw ix, #mem_02b6      ;ec06  e6 02 b6
    mov a, #0x00            ;ec09  04 00
    call fill_5_bytes_at_ix ;ec0b  31 e6 ef
    mov a, mem_00e0         ;ec0e  05 e0
    and a, #0x02            ;ec10  64 02
    bne lab_ec3b            ;ec12  fc 27
    call no_changer         ;ec14  31 ed 18     Set display number for "NO CHANGER"
    setb mem_00e0:6         ;ec17  ae e0

lab_ec19:
    mov a, mem_01db         ;ec19  60 01 db     A = CD number
    mov mem_03d2, a         ;ec1c  61 03 d2

    mov a, mem_01dc         ;ec1f  60 01 dc     A = track number
    mov mem_03d3, a         ;ec22  61 03 d3

    mov a, mem_01df         ;ec25  60 01 df
    and a, #0x24            ;ec28  64 24
    beq lab_ec32            ;ec2a  fd 06

    mov a, @ix+0x00         ;ec2c  06 00        A = Pictograph bits
    or a, #0b0000010        ;ec2e  74 02        Turn on Bit 1 (MIX)
    mov @ix+0x00, a         ;ec30  46 00        Store updated pictographs

lab_ec32:
    bbc mem_00e0:6, lab_ebfc ;ec32  b6 e0 c7
    call sub_ed0f           ;ec35  31 ed 0f     Copy 5 bytes from IX to mem_03c7+
    jmp lab_ebfc            ;ec38  21 eb fc

lab_ec3b:
    call sub_ec41           ;ec3b  31 ec 41
    jmp lab_ec19            ;ec3e  21 ec 19

sub_ec41:
    mov a, mem_01e0         ;ec41  60 01 e0
    and a, #0xf0            ;ec44  64 f0
    cmp a, #0xb0            ;ec46  14 b0
    bne lab_ec50            ;ec48  fc 06
    call no_magazin         ;ec4a  31 ed 1c     Set display number for "NO MAGAZIN"
    setb mem_00e0:6         ;ec4d  ae e0
    ret                     ;ec4f  20

lab_ec50:
    mov a, mem_01e0         ;ec50  60 01 e0
    and a, #0x0e            ;ec53  64 0e
    cmp a, #0x08            ;ec55  14 08
    bne lab_ec5f            ;ec57  fc 06
    call no_disc           ;ec59  31 ed 26      Set display number for "NO DISC"
    setb mem_00e0:6         ;ec5c  ae e0
    ret                     ;ec5e  20

lab_ec5f:
    bbc mem_00e1:5, lab_ec68 ;ec5f  b5 e1 06
    call cd_no_cd           ;ec62  31 ed 2a     Set display number for "CD x NO CD"
    setb mem_00e0:6         ;ec65  ae e0
    ret                     ;ec67  20

lab_ec68:
    mov a, mem_01e0         ;ec68  60 01 e0
    and a, #0x0e            ;ec6b  64 0e
    beq lab_ec75            ;ec6d  fd 06
    call sub_ed39           ;ec6f  31 ed 39
    setb mem_00e0:6         ;ec72  ae e0
    ret                     ;ec74  20

lab_ec75:
    mov a, mem_03ce         ;ec75  60 03 ce
    cmp a, #0x01            ;ec78  14 01
    bne lab_ec80            ;ec7a  fc 04
    call chk_magazin        ;ec7c  31 ed 20     Set display number for "CHK MAGAZIN"
    ret                     ;ec7f  20

lab_ec80:
    bbc mem_00b2:3, lab_eca4 ;ec80  b3 b2 21
    mov r0, #0x00           ;ec83  88 00

lab_ec85:
    mov a, mem_01db         ;ec85  60 01 db     A = CD number
    mov a, mem_03d2         ;ec88  60 03 d2
    xor a                   ;ec8b  52
    and a, #0x0f            ;ec8c  64 0f        Mask to leave only low nibble (CD number)
    bne lab_eca0            ;ec8e  fc 10
    mov a, mem_01dc         ;ec90  60 01 dc     A = track number
    mov a, mem_03d3         ;ec93  60 03 d3
    xor a                   ;ec96  52
    bne lab_eca0            ;ec97  fc 07
    dec r0                  ;ec99  d8
    beq lab_ecaf            ;ec9a  fd 13        0x0a 'CD....MAX..'
    call sub_ed4d           ;ec9c  31 ed 4d     0x0b 'CD....MIN..'
    ret                     ;ec9f  20

lab_eca0:
    dec r0                  ;eca0  d8
    beq lab_ecb3            ;eca1  fd 10
    callv #5                ;eca3  ed          CALLV #5 = callv5_8d0d

lab_eca4:
    bbc mem_00b2:2, lab_ecb5 ;eca4  b2 b2 0e
    bbc mem_0099:4, lab_ecb5 ;eca7  b4 99 0b
    mov r0, #0x01           ;ecaa  88 01
    jmp lab_ec85            ;ecac  21 ec 85

lab_ecaf:
    call sub_ed5a           ;ecaf  31 ed 5a     0x0a 'CD....MAX..'
    ret                     ;ecb2  20

lab_ecb3:
    clrb mem_0099:4         ;ecb3  a4 99

lab_ecb5:
    bbs mem_00e1:1, lab_ecbc ;ecb5  b9 e1 04
    call sub_ed60           ;ecb8  31 ed 60
    ret                     ;ecbb  20

lab_ecbc:
    mov a, mem_01e0         ;ecbc  60 01 e0
    and a, #0xf0            ;ecbf  64 f0
    cmp a, #0x40            ;ecc1  14 40
    bne lab_ecee            ;ecc3  fc 29
    mov a, mem_01c7         ;ecc5  60 01 c7
    cmp a, #0x04            ;ecc8  14 04
    beq lab_ecd0            ;ecca  fd 04
    cmp a, #0x0c            ;eccc  14 0c
    bne lab_ecdd            ;ecce  fc 0d

lab_ecd0:
    call sub_ed81           ;ecd0  31 ed 81

lab_ecd3:
    mov a, #0x32            ;ecd3  04 32
    mov mem_01ec, a         ;ecd5  61 01 ec
    setb mem_00da:6         ;ecd8  ae da
    clrb mem_00da:7         ;ecda  a7 da
    ret                     ;ecdc  20

lab_ecdd:
    mov a, mem_01c7         ;ecdd  60 01 c7
    cmp a, #0x05            ;ece0  14 05
    beq lab_ece8            ;ece2  fd 04
    cmp a, #0x0d            ;ece4  14 0d
    bne lab_ecee            ;ece6  fc 06

lab_ece8:
    call sub_ed97           ;ece8  31 ed 97
    jmp lab_ecd3            ;eceb  21 ec d3

lab_ecee:
    bbc mem_00da:6, lab_ecf5 ;ecee  b6 da 04
    call sub_ed9d           ;ecf1  31 ed 9d
    ret                     ;ecf4  20

lab_ecf5:
    mov a, mem_01df         ;ecf5  60 01 df
    and a, #0x10            ;ecf8  64 10
    beq lab_ed00            ;ecfa  fd 04
    call sub_edae           ;ecfc  31 ed ae
    ret                     ;ecff  20

lab_ed00:
    mov a, mem_01df         ;ed00  60 01 df
    and a, #0x24            ;ed03  64 24
    beq lab_ed0b            ;ed05  fd 04
    call sub_edaa           ;ed07  31 ed aa
    ret                     ;ed0a  20

lab_ed0b:
    call sub_ed60           ;ed0b  31 ed 60
    ret                     ;ed0e  20

sub_ed0f:
;Copy 5 bytes from IX to mem_03c7+
;Destroys A
    movw a, ix                  ;ed0f  f2           A = IX
    movw ep, a                  ;ed10  e3           EP = A
    movw ix, #mem_03c7          ;ed11  e6 03 c7     IX = #mem_03c7
    call copy_5_bytes_ep_to_ix  ;ed14  31 ef 25
    ret                         ;ed17  20

no_changer:
    mov @ix+0x01, #0x05     ;ed18  86 01 05     Display number = 0x05 'NO..CHANGER'
    ret                     ;ed1b  20

no_magazin:
    mov @ix+0x01, #0x06     ;ed1c  86 01 06     Display number = 0x06 'NO..MAGAZIN'
    ret                     ;ed1f  20

chk_magazin:
    mov @ix+0x01, #0x0c     ;ed20  86 01 0c     Display number = 0x0c 'CHK.MAGAZIN'
    jmp lab_ed32            ;ed23  21 ed 32

no_disc:
    mov @ix+0x01, #0x07     ;ed26  86 01 07     Display number = 0x07 '....NO.DISC'
    ret                     ;ed29  20

cd_no_cd:
    mov @ix+0x01, #0x0f     ;ed2a  86 01 0f     Display number = 0x0f 'CD...NO.CD.'
    mov a, mem_03cc         ;ed2d  60 03 cc     A = CD number
    mov @ix+0x02, a         ;ed30  46 02        Display param 0 = CD number

lab_ed32:
    mov a, @ix+0x00         ;ed32  06 00        A = Pictograph bits
    or a, #0b00010000       ;ed34  74 10        Turn on Bit 4 (HIDDEN_MODE_CD)
    mov @ix+0x00, a         ;ed36  46 00        Store updated pictographs
    ret                     ;ed38  20

sub_ed39:
    mov a, mem_01e0         ;ed39  60 01 e0
    and a, #0x0e            ;ed3c  64 0e
    cmp a, #0x06            ;ed3e  14 06
    bne lab_ed48            ;ed40  fc 06
    mov @ix+0x01, #0x0e     ;ed42  86 01 0e     Display number = 0x0e 'CD...ERROR.'
    jmp lab_ed32            ;ed45  21 ed 32

lab_ed48:
    mov @ix+0x01, #0x0d     ;ed48  86 01 0d     Display number = 0x0d 'CD..CD.ERR.'
    bne lab_ed50            ;ed4b  fc 03        BRANCH_ALWAYS_TAKEN

sub_ed4d:
    mov @ix+0x01, #0x0b     ;ed4d  86 01 0b     Display number = 0x0b 'CD....MIN..'

lab_ed50:
    mov a, mem_01db         ;ed50  60 01 db     A = CD number
    and a, #0x0f            ;ed53  64 0f        Mask to leave only low nibble (CD number)
    mov @ix+0x02, a         ;ed55  46 02        Display param 0 = CD number
    jmp lab_ed32            ;ed57  21 ed 32

sub_ed5a:
    mov @ix+0x01, #0x0a     ;ed5a  86 01 0a     Display number = 0x0a 'CD....MAX..'
    jmp lab_ed50            ;ed5d  21 ed 50

sub_ed60:
    mov a, mem_01dc         ;ed60  60 01 dc     A = track number
    bne lab_ed76            ;ed63  fc 11        Branch if track number is non-zero

    ;(track number = 0)
    mov a, mem_01db         ;ed65  60 01 db     A = CD number
    and a, #0x0f            ;ed68  64 0f        Mask to leave only low nibble (CD number)
    bne lab_ed76            ;ed6a  fc 0a        Branch if CD number is non-zero

    ;(CD number = 0)
    movw ix, #mem_02b6      ;ed6c  e6 02 b6
    movw ep, #mem_03d4      ;ed6f  e7 03 d4
    call copy_5_bytes_ep_to_ix ;ed72  31 ef 25
    ret                     ;ed75  20

lab_ed76:
    ;(track number = non-zero)
    ;or
    ;(CD number = non-zero)
    mov @ix+0x01, #0x01     ;ed76  86 01 01     Display number = 0x01 'CD...TR....'
    mov a, mem_01dc         ;ed79  60 01 dc     A = track number
    mov @ix+0x03, a         ;ed7c  46 03        Display param 1 = track number
    jmp lab_ed50            ;ed7e  21 ed 50

sub_ed81:
    mov @ix+0x01, #0x02     ;ed81  86 01 02     0x02 'CUE........'

lab_ed84:
    mov a, mem_01dd         ;ed84  60 01 dd     A = minutes
    mov @ix+0x03, a         ;ed87  46 03        Display param 1 = minutes
    mov a, mem_01de         ;ed89  60 01 de     A = seconds
    mov @ix+0x04, a         ;ed8c  46 04        Display param 2 = seconds

lab_ed8e:
    mov a, @ix+0x00         ;ed8e  06 00        A = Pictograph bits
    or a, #0b01000000       ;ed90  74 40        Turn on Bit 6 (PERIOD)
    mov @ix+0x00, a         ;ed92  46 00        Store updated pictographs
    jmp lab_ed32            ;ed94  21 ed 32

sub_ed97:
    mov @ix+0x01, #0x03     ;ed97  86 01 03     Display number = 0x03 'REV........'
    jmp lab_ed84            ;ed9a  21 ed 84

sub_ed9d:
    mov @ix+0x01, #0x09     ;ed9d  86 01 09     Display number = 0x09 'CD 6 1234  '
    mov a, mem_01db         ;eda0  60 01 db     A = CD number
    and a, #0x0f            ;eda3  64 0f        Mask to leave only low nibble (CD number)
    mov @ix+0x02, a         ;eda5  46 02        Display param 0 = Store CD number
    jmp lab_ed84            ;eda7  21 ed 84

sub_edaa:
    call sub_ed60           ;edaa  31 ed 60
    ret                     ;edad  20

sub_edae:
    mov @ix+0x01, #0x04     ;edae  86 01 04     Display number = 0x04 'SCANCD.TR..'
    mov a, mem_01db         ;edb1  60 01 db     A = CD number
    and a, #0x0f            ;edb4  64 0f        Mask to leave only low nibble (CD number)
    mov @ix+0x02, a         ;edb6  46 02        Display param 0 = CD number
    mov a, mem_01dc         ;edb8  60 01 dc     A = track number
    mov @ix+0x03, a         ;edbb  46 03        Display param 1 = track number
    jmp lab_ed8e            ;edbd  21 ed 8e

sub_edc0:
    movw ix, #mem_edd8      ;edc0  e6 ed d8
    mov a, #0x0d            ;edc3  04 0d

lab_edc5:
    mov a, mem_01c7         ;edc5  60 01 c7
    cmp a                   ;edc8  12
    beq lab_edd5            ;edc9  fd 0a
    incw ix                 ;edcb  c2
    incw ix                 ;edcc  c2
    incw ix                 ;edcd  c2
    incw ix                 ;edce  c2
    xchw a, t               ;edcf  43
    decw a                  ;edd0  d0
    cmp a, #0x00            ;edd1  14 00
    bne lab_edc5            ;edd3  fc f0

lab_edd5:
    movw a, @ix+0x02        ;edd5  c6 02
    jmp @a                  ;edd7  e0

mem_edd8:
    .word 0xea15            ;DATA
    .word lab_ee4b          ;VECTOR

    .word 0xe916            ;DATA
    .word lab_ee4b          ;VECTOR

    .word 0xd827            ;DATA
    .word lab_ee10          ;VECTOR

    .word 0x0000            ;DATA
    .word lab_ee83          ;VECTOR

    .word 0xf708            ;DATA
    .word lab_ee10          ;VECTOR

    .word 0xf807            ;DATA
    .word lab_ee10          ;VECTOR

    .word 0xf906            ;DATA
    .word lab_ee10          ;VECTOR

    .word 0xfa05            ;DATA
    .word lab_ee10          ;VECTOR

    .word 0xe51a            ;DATA
    .word lab_ee67          ;VECTOR

    .word 0xe41b            ;DATA
    .word lab_ee67          ;VECTOR

    .word 0xe11e
    .word lab_ee10          ;VECTOR

    .word 0xe01f            ;DATA
    .word lab_ee10          ;VECTOR

    .word 0                 ;DATA
    .word lab_ee26          ;VECTOR

    .word 0                 ;DATA
    .word lab_ee83          ;VECTOR


;XXX ee10-ee1f looks unreachable
lab_ee10:
    mov a, mem_01ce         ;ee10  60 01 ce
    mov a, #0x02            ;ee13  04 02
    cmp a                   ;ee15  12
    bhs lab_ee19            ;ee16  f8 01
    xchw a, t               ;ee18  43           A = table index (from mem_01ce)

lab_ee19:
    movw a, #mem_ee20       ;ee19  e4 ee 20     A = table base address
    call sub_e73c           ;ee1c  31 e7 3c     Call address in table
    ret                     ;ee1f  20

mem_ee20:
    .word lab_ee84          ;ee20  ee 84       VECTOR
    .word lab_ee88          ;ee22  ee 88       VECTOR
    .word lab_ee8a          ;ee24  ee 8a       VECTOR

    ;XXX ee26-ee38 looks unreachable
lab_ee26:
    movw ix, #mem_ee47      ;ee26  e6 ee 47
    mov a, mem_01ce         ;ee29  60 01 ce
    mov a, #0x06            ;ee2c  04 06
    cmp a                   ;ee2e  12
    bhs lab_ee32            ;ee2f  f8 01
    xchw a, t               ;ee31  43           A = table index (from mem_01ce)

lab_ee32:
    movw a, #mem_ee39       ;ee32  e4 ee 39     A = table address
    call sub_e73c           ;ee35  31 e7 3c     Call address in table
    ret                     ;ee38  20

mem_ee39:
;Table used with mem_01ce
    .word lab_ee90          ;ee39  ee 90       VECTOR
    .word lab_ee88          ;ee3b  ee 88       VECTOR
    .word lab_ee84          ;ee3d  ee 84       VECTOR
    .word lab_ee88          ;ee3f  ee 88       VECTOR
    .word lab_eed0          ;ee41  ee d0       VECTOR
    .word lab_ee88          ;ee43  ee 88       VECTOR
    .word lab_ee8a          ;ee45  ee 8a       VECTOR

mem_ee47:
    .byte 0xD7              ;ee47  d7          DATA '\xd7'
    .byte 0x28              ;ee48  28          DATA '('
    .byte 0xE3              ;ee49  e3          DATA '\xe3'
    .byte 0x1C              ;ee4a  1c          DATA '\x1c'

lab_ee4b:
    mov a, mem_01ce         ;ee4b  60 01 ce
    mov a, #0x05            ;ee4e  04 05
    cmp a                   ;ee50  12
    bhs lab_ee54            ;ee51  f8 01
    xchw a, t               ;ee53  43           A = table index (from mem_01ce)

lab_ee54:
    movw a, #mem_ee5b       ;ee54  e4 ee 5b     A = table address
    call sub_e73c           ;ee57  31 e7 3c     Call address in table
    ret                     ;ee5a  20

mem_ee5b:
    .word lab_eeae          ;ee5b  ee ae       VECTOR
    .word lab_ee88          ;ee5d  ee 88       VECTOR
    .word lab_eeb4          ;ee5f  ee b4       VECTOR
    .word lab_ee88          ;ee61  ee 88       VECTOR
    .word lab_eeb6          ;ee63  ee b6       VECTOR
    .word lab_eecf          ;ee65  ee cf       VECTOR

    ;XXX ee67-ee76 looks unreachable
lab_ee67:
    mov a, mem_01ce         ;ee67  60 01 ce
    mov a, #0x05            ;ee6a  04 05
    cmp a                   ;ee6c  12
    bhs lab_ee70            ;ee6d  f8 01
    xchw a, t               ;ee6f  43           A = table index (from mem_01ce)

lab_ee70:
    movw a, #mem_ee77       ;ee70  e4 ee 77     A = table address
    call sub_e73c           ;ee73  31 e7 3c     Call address in table
    ret                     ;ee76  20

mem_ee77:
    .word lab_ee84          ;ee77  ee 84       VECTOR
    .word lab_ee88          ;ee79  ee 88       VECTOR
    .word lab_eec5          ;ee7b  ee c5       VECTOR
    .word lab_ee88          ;ee7d  ee 88       VECTOR
    .word lab_ee8a          ;ee7f  ee 8a       VECTOR
    .word lab_eecf          ;ee81  ee cf       VECTOR

    ;XXX ee83 looks unreachable
lab_ee83:
    ret                     ;ee83 20

lab_ee84:
    movw a, @ix+0x00        ;ee84  c6 00
    callv #1                ;ee86  e9          CALLV #1 = callv1_eed4
                            ;                  (Stores word A in mem_01c9, other unknown functions)
    ret                     ;ee87  20

lab_ee88:
    callv #2                ;ee88  ea          CALLV #2 = callv2_eedb
    ret                     ;ee89  20

lab_ee8a:
    mov a, #0x0f            ;ee8a  04 0f
    mov mem_01ce, a         ;ee8c  61 01 ce
    ret                     ;ee8f  20

lab_ee90:
    movw a, #0x0000         ;ee90  e4 00 00
    mov a, mem_01cf         ;ee93  60 01 cf
    clrc                    ;ee96  81
    rolc a                  ;ee97  02
    movw a, #mem_eea0       ;ee98  e4 ee a0
    clrc                    ;ee9b  81
    addcw a                 ;ee9c  23
    movw a, @a              ;ee9d  93
    callv #1                ;ee9e  e9          CALLV #1 = callv1_eed4
                            ;                  (Stores word A in mem_01c9, other unknown functions)
    ret                     ;ee9f  20

mem_eea0:
;unknown data table
    .word 0xC639            ;eea0  DATA         Word stored in mem_01c9 by callv1_eed4
    .word 0xCF30            ;eea2  DATA         Word stored in mem_01c9 by callv1_eed4
    .word 0xCE31            ;eea4  DATA         Word stored in mem_01c9 by callv1_eed4
    .word 0xCD32            ;eea6  DATA         Word stored in mem_01c9 by callv1_eed4
    .word 0xCC33            ;eea8  DATA         Word stored in mem_01c9 by callv1_eed4
    .word 0xCB34            ;eeaa  DATA         Word stored in mem_01c9 by callv1_eed4
    .word 0xCA35            ;eeac  DATA         Word stored in mem_01c9 by callv1_eed4

lab_eeae:
    movw a, @ix+0x00        ;eeae  c6 00
    movw mem_00a6, a        ;eeb0  d5 a6
    callv #1                ;eeb2  e9          CALLV #1 = callv1_eed4
                            ;                  (Stores word A in mem_01c9, other unknown functions)
    ret                     ;eeb3  20

lab_eeb4:
    callv #3                ;eeb4  eb          CALLV #3 = callv3_eeeb
    ret                     ;eeb5  20

lab_eeb6:
    bbc mem_00e0:0, lab_eec1 ;eeb6  b0 e0 08
    clrb mem_00e0:0         ;eeb9  a0 e0
    mov a, #0x0f            ;eebb  04 0f

lab_eebd:
    mov mem_01ce, a         ;eebd  61 01 ce
    ret                     ;eec0  20

lab_eec1:
    mov a, #0x02            ;eec1  04 02
    bne lab_eebd            ;eec3  fc f8        BRANCH_ALWAYS_TAKEN

lab_eec5:
    bbc mem_00e0:0, lab_eece ;eec5  b0 e0 06
    clrb mem_00e0:0         ;eec8  a0 e0
    movw a, #sub_d827       ;eeca  e4 d8 27
    callv #1                ;ee86  e9          CALLV #1 = callv1_eed4
                            ;                  (Stores word A in mem_01c9, other unknown functions)

lab_eece:
    ret                     ;eece  20

lab_eecf:
    ret                     ;eecf  20

lab_eed0:
    movw a, @ix+0x02        ;eed0  c6 02
    callv #1                ;eed2  e9          CALLV #1 = callv1_eed4
                            ;                  (Stores word A in mem_01c9, other unknown functions)
    ret                     ;eed3  20


callv1_eed4:
;CALLV #1
    movw mem_01c9, a        ;eed4  d4 01 c9
    mov a, #0x10            ;eed7  04 10
    bne lab_eeed            ;eed9  fc 12        BRANCH_ALWAYS_TAKEN


callv2_eedb:
;CALLV #2
    mov a, mem_01c8         ;eedb  60 01 c8
    cmp a, #0x70            ;eede  14 70
    bne lab_ef12            ;eee0  fc 30
    bbc mem_00df:6, lab_ef12 ;eee2  b6 df 2d
    clrb mem_00df:6         ;eee5  a6 df
    mov a, #0x00            ;eee7  04 00
    beq lab_ef08            ;eee9  fd 1d        BRANCH_ALWAYS_TAKEN


callv3_eeeb:
;CALLV #3
    mov a, #0x20            ;eeeb  04 20


lab_eeed:
    mov a, #0x0b            ;eeed  04 0b
    mov mem_01cb, a         ;eeef  61 01 cb
    setb mem_00df:5         ;eef2  ad df
    clrb mem_00df:6         ;eef4  a6 df
    mov cntr2, #0x00        ;eef6  85 29 00
    mov cntr1, #0x0f        ;eef9  85 28 0f
    mov cntr3, #0x00        ;eefc  85 2a 00
    mov comr1, #0xff        ;eeff  85 2c ff
    clrb pdr4:0             ;ef02  a0 0e        CD_DATA_OUT=low
    mov cntr2, #0x82        ;ef04  85 29 82
    xchw a, t               ;ef07  43

lab_ef08:
    mov mem_01c8, a         ;ef08  61 01 c8
    mov a, mem_01ce         ;ef0b  60 01 ce
    incw a                  ;ef0e  c0
    mov mem_01ce, a         ;ef0f  61 01 ce

lab_ef12:
    ret                     ;ef12  20

sub_ef13:
    clrb mem_00e0:2         ;ef13  a2 e0

sub_ef15:
    clrb mem_00df:7         ;ef15  a7 df

sub_ef17:
    clrb mem_00e1:2         ;ef17  a2 e1

sub_ef19:
    clrb mem_00e1:6         ;ef19  a6 e1

sub_ef1b:
    clrb mem_00e0:3         ;ef1b  a3 e0
    clrb mem_00e0:6         ;ef1d  a6 e0
    ret                     ;ef1f  20

sub_ef20:
    clrb mem_00da:6         ;ef20  a6 da
    clrb mem_00da:7         ;ef22  a7 da
    ret                     ;ef24  20

copy_5_bytes_ep_to_ix:
    movw a, #0x0005         ;ef25  e4 00 05
lab_ef28:
    mov a, @ep              ;ef28  07
    mov @ix+0x00, a         ;ef29  46 00
    xch a, t                ;ef2b  42
    incw ix                 ;ef2c  c2
    incw ep                 ;ef2d  c3
    decw a                  ;ef2e  d0
    bne lab_ef28            ;ef2f  fc f7
    ret                     ;ef31  20


sub_ef32:
;Called from ISR for IRQ7 (8-bit serial i/o)
    setb smr:0              ;ef32  a8 1c
    mov a, mem_01d3         ;ef34  60 01 d3
    mov mem_01d2, a         ;ef37  61 01 d2
    movw ix, #mem_01d2      ;ef3a  e6 01 d2
    decw ix                 ;ef3d  d2
    call sub_ef7b           ;ef3e  31 ef 7b
    mov a, sdr              ;ef41  05 1d
    mov mem_01d9, a         ;ef43  61 01 d9
    mov cntr, #0x20         ;ef46  85 16 20
    and a, #0x03            ;ef49  64 03
    cmp a, #0x03            ;ef4b  14 03
    bne lab_ef55            ;ef4d  fc 06
    mov comp, #0xff         ;ef4f  85 17 ff
    mov cntr, #0x29         ;ef52  85 16 29

lab_ef55:
    ret                     ;ef55  20


sub_ef56:
;Called from ISR for IRQ5 (2ch 8-bit pwm timer)
    mov a, mem_01d3         ;ef56  60 01 d3
    and a, #0x80            ;ef59  64 80
    bne lab_ef6b            ;ef5b  fc 0e
    movw ix, #mem_01da      ;ef5d  e6 01 da
    call sub_ef76           ;ef60  31 ef 76
    setb mem_00df:7         ;ef63  af df

lab_ef65:
    setb mem_00e2:1         ;ef65  a9 e2
    mov cntr, #0x20         ;ef67  85 16 20
    ret                     ;ef6a  20

lab_ef6b:
    movw ix, #mem_01e2      ;ef6b  e6 01 e2
    call sub_ef76           ;ef6e  31 ef 76
    setb mem_00e1:3         ;ef71  ab e1
    jmp lab_ef65            ;ef73  21 ef 65

sub_ef76:
    movw a, mem_01d2        ;ef76  c4 01 d2
    movw @ix+0x00, a        ;ef79  d6 00

sub_ef7b:
    movw a, mem_01d4        ;ef7b  c4 01 d4
    movw @ix+0x02, a        ;ef7e  d6 02
    movw a, mem_01d6        ;ef80  c4 01 d6
    movw @ix+0x04, a        ;ef83  d6 04
    movw a, mem_01d8        ;ef85  c4 01 d8
    movw @ix+0x06, a        ;ef88  d6 06
    ret                     ;ef8a  20


sub_ef8b:
;TODO ISR
    mov cntr2, #0x00        ;ef8b  85 29 00
    mov a, mem_01c8         ;ef8e  60 01 c8
    cmp a, #0x70            ;ef91  14 70
    bne lab_ef98            ;ef93  fc 03
    setb pdr4:0             ;ef95  a8 0e        CD_DATA_OUT=high
    ret                     ;ef97  20
lab_ef98:
    call sub_ef9f           ;ef98  31 ef 9f
    mov cntr2, #0x82        ;ef9b  85 29 82
    ret                     ;ef9e  20


sub_ef9f:
    movw ix, #mem_efbc     ;ef9f  e6 ef bc

lab_efa2:
    mov a, mem_01c8         ;efa2  60 01 c8
    mov a, @ix+0x00         ;efa5  06 00
    beq lab_efb3            ;efa7  fd 0a
    cmp a                   ;efa9  12
    beq lab_efb6            ;efaa  fd 0a
    incw ix                 ;efac  c2
    incw ix                 ;efad  c2
    incw ix                 ;efae  c2
    incw ix                 ;efaf  c2
    incw ix                 ;efb0  c2
    bne lab_efa2            ;efb1  fc ef        BRANCH_ALWAYS_TAKEN

lab_efb3:
    xchw a, t               ;efb3  43
    cmp a, #0x50            ;efb4  14 50

lab_efb6:
    movw a, @ix+0x01        ;efb6  c6 01
    bhs lab_efbb            ;efb8  f8 01
    incw ix                 ;efba  c2

lab_efbb:
    jmp @a                  ;efbb  e0


mem_efbc:
;CD-related table used by sub_ef9f
    .byte 0x10              ;DATA
    .word lab_efda          ;VECTOR
    .byte 0x8C              ;DATA
    .byte 0x11              ;DATA

    .byte 0x11              ;DATA
    .word lab_efdf          ;VECTOR
    .byte 0x0F              ;DATA
    .byte 0x30              ;DATA

    .byte 0x20              ;DATA
    .word lab_efda          ;VECTOR
    .byte 0x44              ;DATA
    .byte 0x21              ;DATA

    .byte 0x21              ;DATA
    .word lab_efe5          ;VECTOR
    .byte 0x0F              ;DATA
    .byte 0x22              ;DATA

    .byte 0x22              ;DATA
    .word lab_eff1          ;VECTOR
    .byte 0x0C              ;DATA
    .byte 0x70              ;DATA

    .byte 0x00              ;DATA
    .word lab_eff8          ;VECTOR
    .byte 0x70              ;DATA
    .byte 0x50              ;DATA


lab_efda:
    setb pdr4:0             ;efda  a8 0e        CD_DATA_OUT=high
    jmp lab_efe7            ;efdc  21 ef e7

lab_efdf:
    movw a, #0x34ca         ;efdf  e4 34 ca
    movw mem_01d0, a        ;efe2  d4 01 d0

lab_efe5:
    clrb pdr4:0             ;efe5  a0 0e        CD_DATA_OUT=low

lab_efe7:
    mov a, @ix+0x03         ;efe7  06 03
    mov comr1, a            ;efe9  45 2c

lab_efeb:
    mov a, @ix+0x04         ;efeb  06 04
    mov mem_01c8, a         ;efed  61 01 c8
    ret                     ;eff0  20

lab_eff1:
    setb pdr4:0             ;eff1  a8 0e        CD_DATA_OUT=high
    setb cntr2:1            ;eff3  a9 29
    jmp lab_efeb            ;eff5  21 ef eb

lab_eff8:
    mov a, mem_01c8         ;eff8  60 01 c8
    rorc a                  ;effb  03
    blo lab_f033            ;effc  f9 35
    clrc                    ;effe  81
    mov a, mem_01d0         ;efff  60 01 d0
    rorc a                  ;f002  03
    mov mem_01d0, a         ;f003  61 01 d0
    mov a, mem_01d1         ;f006  60 01 d1
    rorc a                  ;f009  03
    mov mem_01d1, a         ;f00a  61 01 d1
    blo lab_f02b            ;f00d  f9 1c
    mov comr1, #0x0f        ;f00f  85 2c 0f
    setb pdr4:0             ;f012  a8 0e        CD_DATA_OUT=high

lab_f014:
    mov a, mem_01c8         ;f014  60 01 c8
    incw a                  ;f017  c0
    mov mem_01c8, a         ;f018  61 01 c8
    cmp a, @ix+0x03         ;f01b  16 03
    bne lab_f02a            ;f01d  fc 0b
    mov comr1, #0x0f        ;f01f  85 2c 0f
    clrb pdr4:0             ;f022  a0 0e        CD_DATA_OUT=low
    movw a, mem_01c9        ;f024  c4 01 c9
    movw mem_01d0, a        ;f027  d4 01 d0

lab_f02a:
    ret                     ;f02a  20

lab_f02b:
    mov comr1, #0x32        ;f02b  85 2c 32
    setb pdr4:0             ;f02e  a8 0e        CD_DATA_OUT=high
    jmp lab_f014            ;f030  21 f0 14

lab_f033:
    mov comr1, #0x0f        ;f033  85 2c 0f
    clrb pdr4:0             ;f036  a0 0e        CD_DATA_OUT=low
    jmp lab_f014            ;f038  21 f0 14

sub_f03b:
    bbc mem_0099:7, lab_f045 ;f03b  b7 99 07

lab_f03e:
    clrb mem_00e5:1         ;f03e  a1 e5
    clrb mem_00e5:4         ;f040  a4 e5
    clrb mem_00e5:5         ;f042  a5 e5
    ret                     ;f044  20

lab_f045:
    mov a, mem_01ed         ;f045  60 01 ed
    bne lab_f03e            ;f048  fc f4
    bbc mem_00e5:1, lab_f07f ;f04a  b1 e5 32
    bbc mem_00e5:7, lab_f06d ;f04d  b7 e5 1d
    clrb mem_00e5:7         ;f050  a7 e5
    mov a, mem_00e8         ;f052  05 e8
    and a, #0x20            ;f054  64 20
    beq lab_f06c            ;f056  fd 14

lab_f058:
    setb mem_00e5:3         ;f058  ab e5
    mov a, #0x1e            ;f05a  04 1e
    mov mem_02a0, a         ;f05c  61 02 a0
    setb mem_00e5:6         ;f05f  ae e5
    clrb mem_00e5:7         ;f061  a7 e5

lab_f063:
    mov a, #0x64            ;f063  04 64
    mov mem_029e, a         ;f065  61 02 9e
    setb mem_00e5:4         ;f068  ac e5
    clrb mem_00e5:5         ;f06a  a5 e5

lab_f06c:
    ret                     ;f06c  20

lab_f06d:
    bbc mem_00e5:5, lab_f075 ;f06d  b5 e5 05
    setb mem_00e5:2         ;f070  aa e5
    jmp lab_f063            ;f072  21 f0 63

lab_f075:
    mov a, mem_00e8         ;f075  05 e8
    and a, #0x20            ;f077  64 20
    beq lab_f06c            ;f079  fd f1
    bbc mem_00e5:6, lab_f058 ;f07b  b6 e5 da
    ret                     ;f07e  20

lab_f07f:
    bbc pdr2:4, lab_f0a1    ;f07f  b4 04 1f     branch if audio muted
    mov a, mem_00e8         ;f082  05 e8
    and a, #0x20            ;f084  64 20
    beq lab_f06c            ;f086  fd e4
    setb mem_00e2:4         ;f088  ac e2
    mov a, mem_0293         ;f08a  60 02 93
    mov mem_0292, a         ;f08d  61 02 92
    mov mem_029f, a         ;f090  61 02 9f
    mov mem_0291, a         ;f093  61 02 91
    mov a, mem_028a         ;f096  60 02 8a
    .byte 0x61, 0x00, 0xfe  ;f099  61 00 fe     EXTENDED_ADDRESS_PAGE_0  mov mem_00fe, a
    setb mem_00e5:1         ;f09c  a9 e5
    jmp lab_f058            ;f09e  21 f0 58

lab_f0a1:
    mov a, mem_00e8         ;f0a1  05 e8
    and a, #0xdf            ;f0a3  64 df
    mov mem_00e8, a         ;f0a5  45 e8
    ret                     ;f0a7  20

sub_f0a8:
    bbs mem_0099:7, lab_f0f9 ;f0a8  bf 99 4e
    mov a, mem_0095         ;f0ab  05 95
    bne lab_f0f9            ;f0ad  fc 4a
    mov a, mem_00c5         ;f0af  05 c5
    beq lab_f0f9            ;f0b1  fd 46
    bbs mem_00dc:5, lab_f0f5 ;f0b3  bd dc 3f
    mov a, mem_0200         ;f0b6  60 02 00
    bne lab_f0f4            ;f0b9  fc 39
    mov a, #0x01            ;f0bb  04 01
    mov mem_0200, a         ;f0bd  61 02 00
    mov a, mem_01ff         ;f0c0  60 01 ff
    mov mem_00a5, a         ;f0c3  45 a5        Number of bytes in KW1281 packet
    call sub_fd87           ;f0c5  31 fd 87
    call sub_f10e           ;f0c8  31 f1 0e
    call sub_f126           ;f0cb  31 f1 26
    call sub_f1d9           ;f0ce  31 f1 d9
    call sub_fd8d           ;f0d1  31 fd 8d
    call sub_f237           ;f0d4  31 f2 37
    call sub_f241           ;f0d7  31 f2 41
    call sub_f266           ;f0da  31 f2 66
    mov a, mem_01fd         ;f0dd  60 01 fd
    mov a, mem_01fe         ;f0e0  60 01 fe
    cmp a                   ;f0e3  12
    blo lab_f0ea            ;f0e4  f9 04
    xchw a, t               ;f0e6  43
    mov a, mem_01fd         ;f0e7  60 01 fd

lab_f0ea:
    mov mem_01ff, a         ;f0ea  61 01 ff
    mov a, mem_00a5         ;f0ed  05 a5        A = number of bytes in KW1281 packet
    cmp a                   ;f0ef  12
    beq lab_f0f4            ;f0f0  fd 02
    setb mem_00da:0         ;f0f2  a8 da

lab_f0f4:
    ret                     ;f0f4  20

lab_f0f5:
    clrb mem_00dc:5         ;f0f5  a5 dc
    setb mem_00da:0         ;f0f7  a8 da

lab_f0f9:
    mov a, #0x00            ;f0f9  04 00
    movw ix, #mem_01f9      ;f0fb  e6 01 f9
    call fill_8_bytes_at_ix ;f0fe  31 e6 e9
    mov a, mem_00da         ;f101  05 da
    and a, #0xe0            ;f103  64 e0
    mov mem_00da, a         ;f105  45 da
    mov a, mem_00db         ;f107  05 db
    and a, #0xc0            ;f109  64 c0
    mov mem_00db, a         ;f10b  45 db
    ret                     ;f10d  20

sub_f10e:
    movw ix, #mem_01f2      ;f10e  e6 01 f2
    movw ep, #mem_01f9      ;f111  e7 01 f9

sub_f114:
    mov r0, #0x06           ;f114  88 06
    mov mem_009e, a         ;f116  45 9e

lab_f118:
    mov a, @ix+0x00         ;f118  06 00
    cmp a                   ;f11a  12
    bhs lab_f123            ;f11b  f8 06
    decw ix                 ;f11d  d2
    dec r0                  ;f11e  d8
    dec r0                  ;f11f  d8
    xchw a, t               ;f120  43
    bne lab_f118            ;f121  fc f5

lab_f123:
    mov a, r0               ;f123  08
    mov @ep, a              ;f124  47
    ret                     ;f125  20

sub_f126:
    movw a, #0x0000         ;f126  e4 00 00
    mov a, mem_01f9         ;f129  60 01 f9
    movw a, #mem_f139       ;f12c  e4 f1 39
    movw ix, #mem_f141      ;f12f  e6 f1 41
    movw ep, #mem_01fb      ;f132  e7 01 fb
    clrc                    ;f135  81
    addcw a                 ;f136  23
    movw a, @a              ;f137  93
    jmp @a                  ;f138  e0

mem_f139:
    .word lab_f19e          ;f139  f1 9e       VECTOR
    .word lab_f17a          ;f13b  f1 7a       VECTOR
    .word lab_f153          ;f13d  f1 53       VECTOR
    .word lab_f14b          ;f13f  f1 4b       VECTOR

mem_f141:
    .byte 0xF9              ;f141  f9          DATA '\xf9'
    .byte 0x01              ;f142  01          DATA '\x01'
    .byte 0xFD              ;f143  fd          DATA '\xfd'
    .byte 0xF9              ;f144  f9          DATA '\xf9'
    .byte 0x03              ;f145  03          DATA '\x03'
    .byte 0x02              ;f146  02          DATA '\x02'
    .byte 0xFB              ;f147  fb          DATA '\xfb'
    .byte 0x07              ;f148  07          DATA '\x07'
    .byte 0x06              ;f149  06          DATA '\x06'
    .byte 0x04              ;f14a  04          DATA '\x04'

lab_f14b:
    mov a, @ix+0x00         ;f14b  06 00
    call sub_f1ca           ;f14d  31 f1 ca
    mov @ep, #0x06          ;f150  87 06
    ret                     ;f152  20

lab_f153:
    mov a, @ep              ;f153  07
    cmp a, #0x06            ;f154  14 06
    bne lab_f165            ;f156  fc 0d
    mov a, @ix+0x01         ;f158  06 01
    call sub_f1cf           ;f15a  31 f1 cf
    mov a, @ix+0x00         ;f15d  06 00
    call sub_f1ca           ;f15f  31 f1 ca

lab_f162:
    mov @ep, #0x04          ;f162  87 04
    ret                     ;f164  20

lab_f165:
    mov a, @ep              ;f165  07
    cmp a, #0x04            ;f166  14 04
    bne lab_f172            ;f168  fc 08
    mov a, @ix+0x02         ;f16a  06 02
    call sub_f1d4           ;f16c  31 f1 d4
    jmp lab_f162            ;f16f  21 f1 62

lab_f172:
    mov a, @ix+0x03         ;f172  06 03
    call sub_f1d4           ;f174  31 f1 d4
    jmp lab_f162            ;f177  21 f1 62

lab_f17a:
    mov a, @ep              ;f17a  07
    cmp a, #0x06            ;f17b  14 06
    bne lab_f18c            ;f17d  fc 0d
    mov a, @ix+0x04         ;f17f  06 04
    call sub_f1cf           ;f181  31 f1 cf
    mov a, @ix+0x00         ;f184  06 00
    call sub_f1ca           ;f186  31 f1 ca

lab_f189:
    mov @ep, #0x02          ;f189  87 02
    ret                     ;f18b  20

lab_f18c:
    mov a, @ep              ;f18c  07
    cmp a, #0x04            ;f18d  14 04
    bne lab_f196            ;f18f  fc 05
    mov a, @ix+0x05         ;f191  06 05
    call sub_f1cf           ;f193  31 f1 cf

lab_f196:
    mov a, @ix+0x06         ;f196  06 06
    call sub_f1d4           ;f198  31 f1 d4
    jmp lab_f189            ;f19b  21 f1 89

lab_f19e:
    mov a, @ep              ;f19e  07
    cmp a, #0x06            ;f19f  14 06
    bne lab_f1b0            ;f1a1  fc 0d
    mov a, @ix+0x07         ;f1a3  06 07
    call sub_f1cf           ;f1a5  31 f1 cf
    mov a, @ix+0x00         ;f1a8  06 00
    call sub_f1ca           ;f1aa  31 f1 ca

lab_f1ad:
    mov @ep, #0x00          ;f1ad  87 00
    ret                     ;f1af  20

lab_f1b0:
    mov a, @ep              ;f1b0  07
    cmp a, #0x04            ;f1b1  14 04
    bne lab_f1bd            ;f1b3  fc 08
    mov a, @ix+0x08         ;f1b5  06 08
    call sub_f1cf           ;f1b7  31 f1 cf
    jmp lab_f1ad            ;f1ba  21 f1 ad

lab_f1bd:
    mov a, @ep              ;f1bd  07
    cmp a, #0x02            ;f1be  14 02
    bne lab_f1ad            ;f1c0  fc eb
    mov a, @ix+0x09         ;f1c2  06 09
    call sub_f1cf           ;f1c4  31 f1 cf
    jmp lab_f1ad            ;f1c7  21 f1 ad

sub_f1ca:
    and a, mem_00da         ;f1ca  65 da
    mov mem_00da, a         ;f1cc  45 da
    ret                     ;f1ce  20

sub_f1cf:
    or a, mem_00db          ;f1cf  75 db
    mov mem_00db, a         ;f1d1  45 db
    ret                     ;f1d3  20

sub_f1d4:
    and a, mem_00db         ;f1d4  65 db
    mov mem_00db, a         ;f1d6  45 db
    ret                     ;f1d8  20

sub_f1d9:
    bbc mem_00db:0, lab_f1e0 ;f1d9  b0 db 04
    call sub_f1f5           ;f1dc  31 f1 f5
    ret                     ;f1df  20

lab_f1e0:
    bbc mem_00db:1, lab_f1e7 ;f1e0  b1 db 04
    call sub_f221           ;f1e3  31 f2 21
    ret                     ;f1e6  20

lab_f1e7:
    bbc mem_00db:2, lab_f1ee ;f1e7  b2 db 04
    call sub_f22c           ;f1ea  31 f2 2c
    ret                     ;f1ed  20

lab_f1ee:
    mov a, mem_01f9         ;f1ee  60 01 f9
    mov mem_01fd, a         ;f1f1  61 01 fd
    ret                     ;f1f4  20

sub_f1f5:
    movw ix, #mem_f21f      ;f1f5  e6 f2 1f
    movw ep, #mem_01f6      ;f1f8  e7 01 f6

lab_f1fb:
    bbc mem_00da:2, lab_f20b ;f1fb  b2 da 0d
    clrb mem_00da:2         ;f1fe  a2 da
    mov a, @ix+0x00         ;f200  06 00
    call sub_f1d4           ;f202  31 f1 d4

lab_f205:
    mov a, @ix+0x01         ;f205  06 01
    mov mem_01fd, a         ;f207  61 01 fd
    ret                     ;f20a  20

lab_f20b:
    bbc mem_00da:1, lab_f211 ;f20b  b1 da 03
    jmp lab_f205            ;f20e  21 f2 05

lab_f211:
    mov a, @ep              ;f211  07
    call sub_f2c4           ;f212  31 f2 c4
    mov mem_02a3, a         ;f215  61 02 a3
    setb mem_00da:1         ;f218  a9 da
    clrb mem_00da:2         ;f21a  a2 da
    jmp lab_f205            ;f21c  21 f2 05

mem_f21f:
    .byte 0xFE              ;f21f  fe          DATA '\xfe'
    .byte 0x06              ;f220  06          DATA '\x06'

sub_f221:
    movw ix, #mem_f22a      ;f221  e6 f2 2a
    movw ep, #mem_01f7      ;f224  e7 01 f7
    jmp lab_f1fb            ;f227  21 f1 fb

mem_f22a:
    .byte 0xFD              ;f22a  fd          DATA '\xfd'
    .byte 0x04              ;f22b  04          DATA '\x04'

sub_f22c:
    movw ix, #mem_f235      ;f22c  e6 f2 35
    movw ep, #mem_01f8      ;f22f  e7 01 f8
    jmp lab_f1fb            ;f232  21 f1 fb

mem_f235:
    .byte 0xFB              ;f235  fb          DATA '\xfb'
    .byte 0x02              ;f236  02          DATA '\x02'

sub_f237:
    movw ix, #mem_01f5      ;f237  e6 01 f5
    movw ep, #mem_01fa      ;f23a  e7 01 fa
    call sub_f114           ;f23d  31 f1 14
    ret                     ;f240  20

sub_f241:
    movw a, #0x0000         ;f241  e4 00 00
    mov a, mem_01fa         ;f244  60 01 fa
    movw a, #mem_f254       ;f247  e4 f2 54
    movw ix, #mem_f25c      ;f24a  e6 f2 5c
    movw ep, #mem_01fc      ;f24d  e7 01 fc
    clrc                    ;f250  81
    addcw a                 ;f251  23
    movw a, @a              ;f252  93
    jmp @a                  ;f253  e0

mem_f254:
    .word lab_f19e          ;f254  f1 9e       VECTOR
    .word lab_f17a          ;f256  f1 7a       VECTOR
    .word lab_f153          ;f258  f1 53       VECTOR
    .word lab_f14b          ;f25a  f1 4b       VECTOR

mem_f25c:
    .byte 0xE7              ;f25c  e7          DATA '\xe7'
    .byte 0x08              ;f25d  08          DATA '\x08'
    .byte 0xEF              ;f25e  ef          DATA '\xef'
    .byte 0xCF              ;f25f  cf          DATA '\xcf'
    .byte 0x18              ;f260  18          DATA '\x18'
    .byte 0x10              ;f261  10          DATA '\x10'
    .byte 0xDF              ;f262  df          DATA '\xdf'
    .byte 0x38              ;f263  38          DATA '8'
    .byte 0x30              ;f264  30          DATA '0'
    .byte 0x20              ;f265  20          DATA ' '

sub_f266:
    bbc mem_00db:3, lab_f26d ;f266  b3 db 04
    call sub_f282           ;f269  31 f2 82
    ret                     ;f26c  20

lab_f26d:
    bbc mem_00db:4, lab_f274 ;f26d  b4 db 04
    call sub_f2ae           ;f270  31 f2 ae
    ret                     ;f273  20

lab_f274:
    bbc mem_00db:5, lab_f27b ;f274  b5 db 04
    call sub_f2b9           ;f277  31 f2 b9
    ret                     ;f27a  20

lab_f27b:
    mov a, mem_01fa         ;f27b  60 01 fa
    mov mem_01fe, a         ;f27e  61 01 fe
    ret                     ;f281  20

sub_f282:
    movw ix, #mem_f2ac      ;f282  e6 f2 ac
    movw ep, #mem_01f6      ;f285  e7 01 f6

lab_f288:
    bbc mem_00da:4, lab_f298 ;f288  b4 da 0d
    clrb mem_00da:4         ;f28b  a4 da
    mov a, @ix+0x00         ;f28d  06 00
    call sub_f1d4           ;f28f  31 f1 d4

lab_f292:
    mov a, @ix+0x01         ;f292  06 01
    mov mem_01fe, a         ;f294  61 01 fe
    ret                     ;f297  20

lab_f298:
    bbc mem_00da:3, lab_f29e ;f298  b3 da 03
    jmp lab_f292            ;f29b  21 f2 92

lab_f29e:
    mov a, @ep              ;f29e  07
    call sub_f2c4           ;f29f  31 f2 c4
    mov mem_02a4, a         ;f2a2  61 02 a4
    setb mem_00da:3         ;f2a5  ab da
    clrb mem_00da:4         ;f2a7  a4 da
    jmp lab_f292            ;f2a9  21 f2 92

mem_f2ac:
    .byte 0xF7              ;f2ac  f7          DATA '\xf7'
    .byte 0x06              ;f2ad  06          DATA '\x06'

sub_f2ae:
    movw ix, #mem_f2b7      ;f2ae  e6 f2 b7
    movw ep, #mem_01f7      ;f2b1  e7 01 f7
    jmp lab_f288            ;f2b4  21 f2 88

mem_f2b7:
    .byte 0xEF              ;f2b7  ef          DATA '\xef'
    .byte 0x04              ;f2b8  04          DATA '\x04'

sub_f2b9:
    movw ix, #mem_f2c2      ;f2b9  e6 f2 c2
    movw ep, #mem_01f8      ;f2bc  e7 01 f8
    jmp lab_f288            ;f2bf  21 f2 88

mem_f2c2:
    .byte 0xDF              ;f2c2  df          DATA '\xdf'
    .byte 0x02              ;f2c3  02          DATA '\x02'

sub_f2c4:
    mov mem_009e, a         ;f2c4  45 9e
    mov mem_009f, #0x00     ;f2c6  85 9f 00

lab_f2c9:
    mov a, mem_009e         ;f2c9  05 9e
    clrc                    ;f2cb  81
    subc a, #0x02           ;f2cc  34 02
    das                     ;f2ce  94
    blo lab_f2db            ;f2cf  f9 0a
    mov mem_009e, a         ;f2d1  45 9e
    mov a, mem_009f         ;f2d3  05 9f
    incw a                  ;f2d5  c0
    mov mem_009f, a         ;f2d6  45 9f
    jmp lab_f2c9            ;f2d8  21 f2 c9

lab_f2db:
    mov a, mem_009f         ;f2db  05 9f
    beq lab_f2e3            ;f2dd  fd 04
    mov a, #0x04            ;f2df  04 04
    mulu a                  ;f2e1  01
    ret                     ;f2e2  20

lab_f2e3:
    incw a                  ;f2e3  c0
    ret                     ;f2e4  20

sub_f2e5:
    bbc mem_0099:7, lab_f2f5 ;f2e5  b7 99 0d
    mov a, #0x00            ;f2e8  04 00
    mov mem_028a, a         ;f2ea  61 02 8a
    mov mem_0288, a         ;f2ed  61 02 88
    clrb mem_00dc:1         ;f2f0  a1 dc
    clrb mem_00dc:2         ;f2f2  a2 dc
    ret                     ;f2f4  20

lab_f2f5:
    bbc mem_00dc:4, lab_f30f ;f2f5  b4 dc 17
    clrb mem_00dc:4         ;f2f8  a4 dc
    mov a, mem_0288         ;f2fa  60 02 88
    mov a, #0x10            ;f2fd  04 10
    cmp a                   ;f2ff  12
    bhs lab_f30f            ;f300  f8 0d

sub_f302:
    mov mem_0288, a         ;f302  61 02 88

sub_f305:
    mov a, #0x14            ;f305  04 14
    mov mem_0289, a         ;f307  61 02 89
    setb mem_00dc:1         ;f30a  a9 dc
    clrb mem_00dc:2         ;f30c  a2 dc
    ret                     ;f30e  20

lab_f30f:
    mov a, mem_0288         ;f30f  60 02 88
    bne lab_f31c            ;f312  fc 08
    mov a, #0x01            ;f314  04 01
    call sub_f302           ;f316  31 f3 02
    bbc mem_00dc:0, lab_f32b ;f319  b0 dc 0f

lab_f31c:
    mov a, mem_0288         ;f31c  60 02 88
    cmp a, #0x10            ;f31f  14 10
    blo lab_f327            ;f321  f9 04
    call sub_f396           ;f323  31 f3 96
    ret                     ;f326  20

lab_f327:
    call sub_f334           ;f327  31 f3 34
    ret                     ;f32a  20

lab_f32b:
    mov a, #0x47            ;f32b  04 47
    mov mem_028b, a         ;f32d  61 02 8b
    setb mem_00dc:0         ;f330  a8 dc
    bne lab_f31c            ;f332  fc e8        BRANCH_ALWAYS_TAKEN

sub_f334:
    bbc mem_00dc:2, lab_f37b ;f334  b2 dc 44
    call sub_f305           ;f337  31 f3 05
    movw ix, #mem_028c      ;f33a  e6 02 8c
    movw a, mem_024f        ;f33d  c4 02 4f
    movw @ix+0x01, a        ;f340  d6 01
    mov a, #0x00            ;f342  04 00
    mov @ix+0x00, a         ;f344  46 00
    mov a, mem_028f         ;f346  60 02 8f
    bbc mem_00dc:0, lab_f34f ;f349  b0 dc 03
    mov a, mem_028b         ;f34c  60 02 8b

lab_f34f:
    mov mem_028b, a         ;f34f  61 02 8b
    call sub_f412           ;f352  31 f4 12
    mov a, mem_009e         ;f355  05 9e
    mov mem_028f, a         ;f357  61 02 8f
    call sub_f37c           ;f35a  31 f3 7c
    mov a, mem_028f         ;f35d  60 02 8f
    mov mem_009e, a         ;f360  45 9e
    call sub_f3fe           ;f362  31 f3 fe
    setb mem_0098:6         ;f365  ae 98
    clrb mem_00dc:0         ;f367  a0 dc
    mov a, mem_0288         ;f369  60 02 88
    incw a                  ;f36c  c0
    mov mem_0288, a         ;f36d  61 02 88
    cmp a, #0x0a            ;f370  14 0a
    bne lab_f37b            ;f372  fc 07
    mov a, #0x10            ;f374  04 10
    mov mem_0288, a         ;f376  61 02 88
    setb mem_00dc:3         ;f379  ab dc

lab_f37b:
    ret                     ;f37b  20

sub_f37c:
    mov a, mem_009e         ;f37c  05 9e
    movw ix, #mem_f388      ;f37e  e6 f3 88
    call sub_f479           ;f381  31 f4 79
    mov mem_028a, a         ;f384  61 02 8a
    ret                     ;f387  20

mem_f388:
    .byte 0x50              ;f388  50          DATA 'P'
    .byte 0xFD              ;f389  fd          DATA '\xfd'
    .byte 0x3F              ;f38a  3f          DATA '?'
    .byte 0xFE              ;f38b  fe          DATA '\xfe'
    .byte 0x32              ;f38c  32          DATA '2'
    .byte 0xFF              ;f38d  ff          DATA '\xff'
    .byte 0x28              ;f38e  28          DATA '('
    .byte 0x00              ;f38f  00          DATA '\x00'
    .byte 0x1F              ;f390  1f          DATA '\x1f'
    .byte 0x01              ;f391  01          DATA '\x01'
    .byte 0x19              ;f392  19          DATA '\x19'
    .byte 0x02              ;f393  02          DATA '\x02'
    .byte 0x00              ;f394  00          DATA '\x00'
    .byte 0x03              ;f395  03          DATA '\x03'

sub_f396:
    bbc mem_00dc:3, lab_f39d ;f396  b3 dc 04
    clrb mem_00dc:3         ;f399  a3 dc
    setb mem_0098:6         ;f39b  ae 98

lab_f39d:
    mov a, mem_0288         ;f39d  60 02 88
    cmp a, #0x10            ;f3a0  14 10
    bne lab_f3ac            ;f3a2  fc 08
    movw ix, #mem_028c      ;f3a4  e6 02 8c
    mov a, #0x00            ;f3a7  04 00
    call fill_3_bytes_at_ix ;f3a9  31 e6 f3

lab_f3ac:
    bbc mem_00dc:2, lab_f3fd ;f3ac  b2 dc 4e
    call sub_f305           ;f3af  31 f3 05
    movw ix, #mem_028c      ;f3b2  e6 02 8c
    movw a, mem_024f        ;f3b5  c4 02 4f
    movw a, @ix+0x01        ;f3b8  c6 01
    clrc                    ;f3ba  81
    addcw a                 ;f3bb  23
    movw @ix+0x01, a        ;f3bc  d6 01
    mov a, mem_0288         ;f3be  60 02 88
    incw a                  ;f3c1  c0
    mov mem_0288, a         ;f3c2  61 02 88
    cmp a, #0x20            ;f3c5  14 20
    bne lab_f3fd            ;f3c7  fc 34
    movw ix, #mem_028c      ;f3c9  e6 02 8c
    mov a, #0x04            ;f3cc  04 04

lab_f3ce:
    mov mem_009e, a         ;f3ce  45 9e
    clrc                    ;f3d0  81
    mov a, @ix+0x00         ;f3d1  06 00
    rorc a                  ;f3d3  03
    mov @ix+0x00, a         ;f3d4  46 00
    mov a, @ix+0x01         ;f3d6  06 01
    rorc a                  ;f3d8  03
    mov @ix+0x01, a         ;f3d9  46 01
    mov a, @ix+0x02         ;f3db  06 02
    rorc a                  ;f3dd  03
    mov @ix+0x02, a         ;f3de  46 02
    mov a, mem_009e         ;f3e0  05 9e
    decw a                  ;f3e2  d0
    cmp a, #0x00            ;f3e3  14 00
    bne lab_f3ce            ;f3e5  fc e7
    mov a, mem_028f         ;f3e7  60 02 8f
    mov mem_028b, a         ;f3ea  61 02 8b
    call sub_f412           ;f3ed  31 f4 12
    mov a, mem_009e         ;f3f0  05 9e
    mov mem_028f, a         ;f3f2  61 02 8f
    call sub_f3fe           ;f3f5  31 f3 fe
    mov a, #0x10            ;f3f8  04 10
    mov mem_0288, a         ;f3fa  61 02 88

lab_f3fd:
    ret                     ;f3fd  20

sub_f3fe:
    mov a, mem_009e         ;f3fe  05 9e
    movw ix, #mem_f40a      ;f400  e6 f4 0a
    call sub_f479           ;f403  31 f4 79
    mov mem_028b, a         ;f406  61 02 8b
    ret                     ;f409  20

mem_f40a:
    .byte 0x32              ;f40a  32          DATA '2'
    .byte 0x5A              ;f40b  5a          DATA 'Z'
    .byte 0x1F              ;f40c  1f          DATA '\x1f'
    .byte 0x47              ;f40d  47          DATA 'G'
    .byte 0x19              ;f40e  19          DATA '\x19'
    .byte 0x38              ;f40f  38          DATA '8'
    .byte 0x00              ;f410  00          DATA '\x00'
    .byte 0x2D              ;f411  2d          DATA '-'

sub_f412:
    movw ix, #mem_028c      ;f412  e6 02 8c
    movw a, @ix+0x01        ;f415  c6 01
    call sub_fda6           ;f417  31 fd a6
    call sub_f442           ;f41a  31 f4 42
    mov mem_009e, a         ;f41d  45 9e
    mov mem_009f, #0x40     ;f41f  85 9f 40
    mov a, mem_009e         ;f422  05 9e
    mov a, mem_009f         ;f424  05 9f
    mulu a                  ;f426  01
    movw mem_00a6, a        ;f427  d5 a6
    mov a, mem_028b         ;f429  60 02 8b
    mov mem_009e, a         ;f42c  45 9e
    mov mem_009f, #0xc0     ;f42e  85 9f c0
    mov a, mem_009e         ;f431  05 9e
    mov a, mem_009f         ;f433  05 9f
    mulu a                  ;f435  01
    movw mem_00a8, a        ;f436  d5 a8
    movw a, mem_00a6        ;f438  c5 a6
    movw a, mem_00a8        ;f43a  c5 a8
    clrc                    ;f43c  81
    addcw a                 ;f43d  23
    swap                    ;f43e  10
    mov mem_009e, a         ;f43f  45 9e
    ret                     ;f441  20

sub_f442:
    movw mem_00aa, a        ;f442  d5 aa
    mov mem_00a3, #0x00     ;f444  85 a3 00
    movw a, mem_00aa        ;f447  c5 aa

lab_f449:
    movw a, #0x0016         ;f449  e4 00 16
    clrc                    ;f44c  81
    subcw a                 ;f44d  33
    bhs lab_f462            ;f44e  f8 12
    movw a, #0x0016         ;f450  e4 00 16
    clrc                    ;f453  81
    addc a                  ;f454  22
    clrc                    ;f455  81
    subc a, #0x10           ;f456  34 10
    blo lab_f471            ;f458  f9 17
    clrc                    ;f45a  81
    addc a, #0x0a           ;f45b  24 0a

lab_f45d:
    mov a, mem_00a3         ;f45d  05 a3
    clrc                    ;f45f  81
    addc a                  ;f460  22
    ret                     ;f461  20

lab_f462:
    das                     ;f462  94
    movw mem_00aa, a        ;f463  d5 aa
    mov a, mem_00a3         ;f465  05 a3
    clrc                    ;f467  81
    addc a, #0x10           ;f468  24 10
    mov mem_00a3, a         ;f46a  45 a3
    movw a, mem_00aa        ;f46c  c5 aa
    jmp lab_f449            ;f46e  21 f4 49

lab_f471:
    movw a, #0x0010         ;f471  e4 00 10
    clrc                    ;f474  81
    addc a                  ;f475  22
    jmp lab_f45d            ;f476  21 f4 5d

sub_f479:
    mov a, @ix+0x00         ;f479  06 00
    beq lab_f485            ;f47b  fd 08
    cmp a                   ;f47d  12
    bhs lab_f485            ;f47e  f8 05
    incw ix                 ;f480  c2
    incw ix                 ;f481  c2
    xchw a, t               ;f482  43
    blo sub_f479            ;f483  f9 f4        BRANCH_ALWAYS_TAKEN

lab_f485:
    mov a, @ix+0x01         ;f485  06 01
    ret                     ;f487  20

sub_f488:
    mov a, mem_01ed         ;f488  60 01 ed
    bne lab_f490            ;f48b  fc 03
    call sub_f4c3           ;f48d  31 f4 c3

lab_f490:
    call sub_f506           ;f490  31 f5 06
    mov a, mem_01ed         ;f493  60 01 ed
    cmp a, #0x04            ;f496  14 04
    bhs lab_f49d            ;f498  f8 03
    call sub_f52b           ;f49a  31 f5 2b

lab_f49d:
    mov a, mem_01ed         ;f49d  60 01 ed     A = table index
    beq lab_f4ac            ;f4a0  fd 0a
    cmp a, #0x06            ;f4a2  14 06
    bhs lab_f4ac            ;f4a4  f8 06
    movw a, #mem_f4b7       ;f4a6  e4 f4 b7     A = table base address
    call sub_e73c           ;f4a9  31 e7 3c     Call address in table

lab_f4ac:
    mov a, mem_00d8         ;f4ac  05 d8
    and a, #0x70            ;f4ae  64 70
    mov mem_00d8, a         ;f4b0  45 d8
    clrb mem_00d9:0         ;f4b2  a0 d9
    clrb mem_00d9:1         ;f4b4  a1 d9

lab_f4b6:
    ret                     ;f4b6  20

mem_f4b7:
    .word lab_f4b6          ;f4b7  f4 b6       VECTOR
    .word lab_f600          ;f4b9  f6 00       VECTOR
    .word lab_f66b          ;f4bb  f6 6b       VECTOR
    .word lab_f68b          ;f4bd  f6 8b       VECTOR
    .word lab_f6ab          ;f4bf  f6 ab       VECTOR
    .word lab_f6d5          ;f4c1  f6 d5       VECTOR

sub_f4c3:
    setb mem_00d7:4         ;f4c3  ac d7
    mov a, #0x01            ;f4c5  04 01
    mov mem_01ed, a         ;f4c7  61 01 ed
    mov a, #0x00            ;f4ca  04 00
    mov mem_03da, a         ;f4cc  61 03 da
    mov a, mem_0292         ;f4cf  60 02 92
    mov mem_03db, a         ;f4d2  61 03 db
    mov mem_03dc, a         ;f4d5  61 03 dc
    mov a, mem_00e2         ;f4d8  05 e2
    mov mem_03dd, a         ;f4da  61 03 dd
    setb 0x0097:2           ;f4dd  aa 97
    mov a, #0x01            ;f4df  04 01
    mov mem_02cc, a         ;f4e1  61 02 cc
    mov a, #0x1e            ;f4e4  04 1e
    mov mem_01ee, a         ;f4e6  61 01 ee
    setb mem_00db:6         ;f4e9  ae db
    clrb 0x00db:7           ;f4eb  a7 db
    clrb mem_00d9:3         ;f4ed  a3 d9
    mov a, mem_0290         ;f4ef  60 02 90
    mov mem_03d9, a         ;f4f2  61 03 d9
    clrb mem_00e2:2         ;f4f5  a2 e2
    bbc mem_00de:2, lab_f4fc ;f4f7  b2 de 02
    setb mem_00e2:2         ;f4fa  aa e2

lab_f4fc:
    clrb mem_00e4:5         ;f4fc  a5 e4
    bbc mem_00de:1, lab_f503 ;f4fe  b1 de 02
    setb mem_00e4:5         ;f501  ad e4

lab_f503:
    jmp lab_f4ac            ;f503  21 f4 ac

sub_f506:
    mov a, mem_00d8         ;f506  05 d8
    and a, #0x8f            ;f508  64 8f
    bne lab_f512            ;f50a  fc 06
    mov a, mem_00d9         ;f50c  05 d9
    and a, #0x03            ;f50e  64 03
    beq lab_f51e            ;f510  fd 0c

lab_f512:
    mov a, #0x1e            ;f512  04 1e
    mov mem_01ee, a         ;f514  61 01 ee
    setb mem_00db:6         ;f517  ae db
    clrb mem_00db:7         ;f519  a7 db

lab_f51b:
    setb mem_0097:2         ;f51b  aa 97

lab_f51d:
    ret                     ;f51d  20

lab_f51e:
    mov a, mem_03de         ;f51e  60 03 de
    bne lab_f51d            ;f521  fc fa
    mov a, #0x0a            ;f523  04 0a
    mov mem_03de, a         ;f525  61 03 de
    jmp lab_f51b            ;f528  21 f5 1b

sub_f52b:
    bbs mem_00d8:2, lab_f538 ;f52b  ba d8 0a
    bbs mem_00d9:0, lab_f538 ;f52e  b8 d9 07
    bbc mem_00d8:7, lab_f54b ;f531  b7 d8 17
    cmp a, #0x03            ;f534  14 03
    beq lab_f55d            ;f536  fd 25

lab_f538:
    incw a                  ;f538  c0
    cmp a, #0x04            ;f539  14 04
    blo lab_f53f            ;f53b  f9 02
    mov a, #0x01            ;f53d  04 01

lab_f53f:
    mov mem_01ed, a         ;f53f  61 01 ed
    mov a, #0x01            ;f542  04 01
    mov mem_02cc, a         ;f544  61 02 cc

lab_f547:
    call sub_f56d           ;f547  31 f5 6d
    ret                     ;f54a  20

lab_f54b:
    bbs mem_00d8:3, lab_f551 ;f54b  bb d8 03
    bbc mem_00d9:1, lab_f55a ;f54e  b1 d9 09

lab_f551:
    decw a                  ;f551  d0
    cmp a, #0x01            ;f552  14 01
    bhs lab_f53f            ;f554  f8 e9
    mov a, #0x03            ;f556  04 03
    bne lab_f53f            ;f558  fc e5        BRANCH_ALWAYS_TAKEN

lab_f55a:
    bbc mem_00db:7, lab_f565 ;f55a  b7 db 08

lab_f55d:
    clrb mem_00db:6         ;f55d  a6 db
    clrb mem_00db:7         ;f55f  a7 db
    mov a, #0x04            ;f561  04 04
    bne lab_f53f            ;f563  fc da        BRANCH_ALWAYS_TAKEN

lab_f565:
    bbc mem_00af:2, lab_f547 ;f565  b2 af df
    clrb mem_00af:2         ;f568  a2 af
    jmp lab_f55d            ;f56a  21 f5 5d

sub_f56d:
    mov a, mem_01ed         ;f56d  60 01 ed
    cmp a, #0x01            ;f570  14 01
    bne lab_f5c2            ;f572  fc 4e
    mov a, mem_03da         ;f574  60 03 da
    cmp a, #0x01            ;f577  14 01
    bne lab_f582            ;f579  fc 07

lab_f57b:
    mov a, mem_01ed         ;f57b  60 01 ed
    mov mem_03da, a         ;f57e  61 03 da
    ret                     ;f581  20

lab_f582:
    call sub_f7b4           ;f582  31 f7 b4
    mov a, mem_009e         ;f585  05 9e
    mov a, mem_0292         ;f587  60 02 92
    cmp a                   ;f58a  12
    blo lab_f599            ;f58b  f9 0c
    bne lab_f593            ;f58d  fc 04
    mov a, mem_009f         ;f58f  05 9f
    bne lab_f599            ;f591  fc 06

lab_f593:
    mov a, #0xff            ;f593  04 ff
    clrb mem_00e2:3         ;f595  a3 e2
    bne lab_f5f4            ;f597  fc 5b        BRANCH_ALWAYS_TAKEN

lab_f599:
    setb mem_00e2:4         ;f599  ac e2
    mov a, mem_009e         ;f59b  05 9e
    mov mem_0292, a         ;f59d  61 02 92
    clrb mem_00e2:5         ;f5a0  a5 e2
    mov a, mem_009f         ;f5a2  05 9f
    beq lab_f5ae            ;f5a4  fd 08
    mov a, mem_009e         ;f5a6  05 9e
    cmp a, #0x1f            ;f5a8  14 1f
    bhs lab_f5b5            ;f5aa  f8 09

lab_f5ac:
    setb mem_00e2:5         ;f5ac  ad e2

lab_f5ae:
    setb mem_0098:6         ;f5ae  ae 98
    setb mem_00b2:5         ;f5b0  ad b2
    jmp lab_f57b            ;f5b2  21 f5 7b

lab_f5b5:
    clrb mem_00e2:5         ;f5b5  a5 e2
    mov a, #0x01            ;f5b7  04 01
    call sub_e730           ;f5b9  31 e7 30
    mov mem_0292, a         ;f5bc  61 02 92
    jmp lab_f5ae            ;f5bf  21 f5 ae

lab_f5c2:
    mov a, mem_03da         ;f5c2  60 03 da
    cmp a, #0x01            ;f5c5  14 01
    bne lab_f57b            ;f5c7  fc b2
    call sub_f7b4           ;f5c9  31 f7 b4
    mov a, mem_009e         ;f5cc  05 9e
    mov a, mem_03db         ;f5ce  60 03 db
    cmp a                   ;f5d1  12
    blo lab_f5ed            ;f5d2  f9 19
    bne lab_f5da            ;f5d4  fc 04
    mov a, mem_009f         ;f5d6  05 9f
    bne lab_f5ed            ;f5d8  fc 13

lab_f5da:
    setb mem_00e2:4         ;f5da  ac e2
    mov a, mem_03db         ;f5dc  60 03 db
    mov mem_0292, a         ;f5df  61 02 92
    clrb mem_00e2:5         ;f5e2  a5 e2
    mov a, mem_03dd         ;f5e4  60 03 dd
    and a, #0x20            ;f5e7  64 20
    beq lab_f5ae            ;f5e9  fd c3
    bne lab_f5ac            ;f5eb  fc bf        BRANCH_ALWAYS_TAKEN

lab_f5ed:
    mov a, mem_03db         ;f5ed  60 03 db
    setb mem_00e2:3         ;f5f0  ab e2
    clrb mem_00e2:5         ;f5f2  a5 e2

lab_f5f4:
    clrb mem_00e2:4         ;f5f4  a4 e2
    mov mem_0291, a         ;f5f6  61 02 91
    clrb mem_00e2:6         ;f5f9  a6 e2
    clrb mem_00e2:7         ;f5fb  a7 e2
    jmp lab_f57b            ;f5fd  21 f5 7b

lab_f600:
    call sub_f651           ;f600  31 f6 51
    mov a, mem_00d8         ;f603  05 d8
    and a, #0x03            ;f605  64 03
    beq lab_f626            ;f607  fd 1d
    bbc mem_00e2:4, lab_f646 ;f609  b4 e2 3a
    call sub_f7b4           ;f60c  31 f7 b4
    mov a, mem_009e         ;f60f  05 9e
    mov mem_0292, a         ;f611  61 02 92
    clrb mem_00e2:5         ;f614  a5 e2
    mov a, mem_009f         ;f616  05 9f
    beq lab_f622            ;f618  fd 08
    mov a, mem_009e         ;f61a  05 9e
    cmp a, #0x1f            ;f61c  14 1f
    bhs lab_f63b            ;f61e  f8 1b
    setb mem_00e2:5         ;f620  ad e2

lab_f622:
    setb mem_0098:6         ;f622  ae 98
    setb mem_00b2:5         ;f624  ad b2

lab_f626:
    movw ix, #mem_02b6      ;f626  e6 02 b6
    mov a, mem_03d9         ;f629  60 03 d9
    clrc                    ;f62c  81
    addc a, #0x0d           ;f62d  24 0d
    mov a, #0x00            ;f62f  04 00
    call fill_5_bytes_at_ix ;f631  31 e6 ef
    xchw a, t               ;f634  43
    mov @ix+0x02, a         ;f635  46 02
    mov @ix+0x01, #0x12     ;f637  86 01 12     0x12 'SET.ONVOL..'
    ret                     ;f63a  20

lab_f63b:
    mov a, #0x01            ;f63b  04 01
    call sub_e730           ;f63d  31 e7 30
    mov mem_0292, a         ;f640  61 02 92
    jmp lab_f622            ;f643  21 f6 22

lab_f646:
    call sub_f6e5           ;f646  31 f6 e5
    mov mem_03d9, a         ;f649  61 03 d9
    clrb mem_00e2:5         ;f64c  a5 e2
    jmp lab_f622            ;f64e  21 f6 22

sub_f651:
    mov a, mem_03d9         ;f651  60 03 d9
    bbc mem_00d8:0, lab_f660 ;f654  b0 d8 09
    cmp a, #0x32            ;f657  14 32
    beq lab_f65f            ;f659  fd 04
    incw a                  ;f65b  c0

lab_f65c:
    mov mem_03d9, a         ;f65c  61 03 d9

lab_f65f:
    ret                     ;f65f  20

lab_f660:
    bbc mem_00d8:1, lab_f65f ;f660  b1 d8 fc
    cmp a, #0x00            ;f663  14 00
    beq lab_f65f            ;f665  fd f8
    decw a                  ;f667  d0
    jmp lab_f65c            ;f668  21 f6 5c

lab_f66b:
    movw ix, #mem_02b6      ;f66b  e6 02 b6
    bbc mem_00d8:0, lab_f683 ;f66e  b0 d8 12
    clrb mem_00e2:2         ;f671  a2 e2

lab_f673:
    mov a, #0x14            ;f673  04 14        0x14 = 'SET.CD.MIX6'

lab_f675:
    bbc mem_00e2:2, lab_f67a ;f675  b2 e2 02
    mov a, #0x13            ;f678  04 13        0x13 = 'SET.CD.MIX1'

lab_f67a:
    mov a, #0x00            ;f67a  04 00
    call fill_5_bytes_at_ix ;f67c  31 e6 ef
    xchw a, t               ;f67f  43
    mov @ix+0x01, a         ;f680  46 01
    ret                     ;f682  20

lab_f683:
    bbc mem_00d8:1, lab_f673 ;f683  b1 d8 ed
    setb mem_00e2:2         ;f686  aa e2
    jmp lab_f675            ;f688  21 f6 75

lab_f68b:
    movw ix, #mem_02b6      ;f68b  e6 02 b6
    bbc mem_00d8:0, lab_f6a3 ;f68e  b0 d8 12
    clrb mem_00e4:5         ;f691  a5 e4

lab_f693:
    mov a, #0x15            ;f693  04 15        0x15 = 'TAPE.SKIP.Y'

lab_f695:
    bbc mem_00e4:5, lab_f69a ;f695  b5 e4 02
    mov a, #0x16            ;f698  04 16        0x16 = 'TAPE.SKIP.N'

lab_f69a:
    mov a, #0x00            ;f69a  04 00
    call fill_5_bytes_at_ix ;f69c  31 e6 ef
    xchw a, t               ;f69f  43
    mov @ix+0x01, a         ;f6a0  46 01
    ret                     ;f6a2  20

lab_f6a3:
    bbc mem_00d8:1, lab_f693 ;f6a3  b1 d8 ed
    setb mem_00e4:5         ;f6a6  ad e4
    jmp lab_f695            ;f6a8  21 f6 95

lab_f6ab:
    mov a, mem_03d9         ;f6ab  60 03 d9
    mov mem_0290, a         ;f6ae  61 02 90
    bbc mem_00e2:2, lab_f6cb ;f6b1  b2 e2 17
    bbs mem_00de:2, lab_f6b9 ;f6b4  ba de 02
    setb mem_00d9:3         ;f6b7  ab d9

lab_f6b9:
    setb mem_00de:2         ;f6b9  aa de

lab_f6bb:
    clrb mem_00de:1         ;f6bb  a1 de
    bbc mem_00e4:5, lab_f6c2 ;f6bd  b5 e4 02
    setb mem_00de:1         ;f6c0  a9 de

lab_f6c2:
    mov mem_00f1, #0x8d     ;f6c2  85 f1 8d
    mov a, #0x05            ;f6c5  04 05
    mov mem_01ed, a         ;f6c7  61 01 ed
    ret                     ;f6ca  20

lab_f6cb:
    bbc mem_00de:2, lab_f6d0 ;f6cb  b2 de 02
    setb mem_00d9:3         ;f6ce  ab d9

lab_f6d0:
    clrb mem_00de:2         ;f6d0  a2 de
    jmp lab_f6bb            ;f6d2  21 f6 bb

lab_f6d5:
    mov a, mem_00f1         ;f6d5  05 f1
    bne lab_f6e4            ;f6d7  fc 0b
    mov a, #0x00            ;f6d9  04 00
    mov mem_0096, a         ;f6db  45 96
    mov mem_01ed, a         ;f6dd  61 01 ed
    setb mem_0098:4         ;f6e0  ac 98
    clrb mem_00d7:4         ;f6e2  a4 d7

lab_f6e4:
    ret                     ;f6e4  20

sub_f6e5:
    clrc                    ;f6e5  81
    mov a, mem_0292         ;f6e6  60 02 92
    mov a, #0x0d            ;f6e9  04 0d
    subc a                  ;f6eb  32
    blo lab_f6fb            ;f6ec  f9 0d
    mov a, #0x13            ;f6ee  04 13
    subc a                  ;f6f0  32
    blo lab_f6f7            ;f6f1  f9 04
    mov a, #0x25            ;f6f3  04 25
    addc a                  ;f6f5  22
    ret                     ;f6f6  20

lab_f6f7:
    clrc                    ;f6f7  81
    xchw a, t               ;f6f8  43
    rolc a                  ;f6f9  02
    ret                     ;f6fa  20

lab_f6fb:
    mov a, #0x00            ;f6fb  04 00
    ret                     ;f6fd  20

sub_f6fe:
    mov a, mem_01ed         ;f6fe  60 01 ed
    bne lab_f706            ;f701  fc 03
    bbs mem_00e5:1, lab_f709 ;f703  b9 e5 03

lab_f706:
    bbc mem_00e2:4, lab_f70a ;f706  b4 e2 01

lab_f709:
    ret                     ;f709  20

lab_f70a:
    mov a, mem_00e9         ;f70a  05 e9
    and a, #0xf7            ;f70c  64 f7
    cmp a, #0xf7            ;f70e  14 f7
    bne lab_f709            ;f710  fc f7
    bbs mem_00e2:3, lab_f726 ;f712  bb e2 11
    call sub_f7b4           ;f715  31 f7 b4
    mov a, mem_009e         ;f718  05 9e
    mov a, mem_0291         ;f71a  60 02 91
    cmp a                   ;f71d  12
    blo lab_f729            ;f71e  f9 09
    bne lab_f726            ;f720  fc 04
    mov a, mem_009f         ;f722  05 9f
    beq lab_f729            ;f724  fd 03

lab_f726:
    call sub_f744           ;f726  31 f7 44

lab_f729:
    bbc mem_00e2:7, lab_f732 ;f729  b7 e2 06
    call sub_f82e           ;f72c  31 f8 2e
    jmp lab_f709            ;f72f  21 f7 09

lab_f732:
    bbc mem_00e2:6, lab_f738 ;f732  b6 e2 03
    jmp lab_f709            ;f735  21 f7 09

lab_f738:
    mov a, #0x07            ;f738  04 07
    mov mem_02a1, a         ;f73a  61 02 a1
    setb mem_00e2:6         ;f73d  ae e2
    clrb mem_00e2:7         ;f73f  a7 e2
    jmp lab_f709            ;f741  21 f7 09

sub_f744:
    movw a, #0x0000         ;f744  e4 00 00
    mov a, mem_0291         ;f747  60 02 91
    clrc                    ;f74a  81
    rolc a                  ;f74b  02
    movw a, #mem_f758       ;f74c  e4 f7 58
    clrc                    ;f74f  81
    addcw a                 ;f750  23
    movw a, @a              ;f751  93
    mov mem_009e, a         ;f752  45 9e
    swap                    ;f754  10
    mov mem_009f, a         ;f755  45 9f
    ret                     ;f757  20

mem_f758:
    .word 0x0000            ;DATA
    .word 0x0001            ;DATA
    .word 0x0002            ;DATA
    .word 0x0003            ;DATA
    .word 0x0004            ;DATA
    .word 0x0005            ;DATA
    .word 0x0006            ;DATA
    .word 0x0007            ;DATA
    .word 0x0008            ;DATA
    .word 0x0009            ;DATA
    .word 0x000a            ;DATA
    .word 0x000b            ;DATA
    .word 0x000c            ;DATA
    .word 0x000d            ;DATA
    .word 0x000e            ;DATA
    .word 0x000f            ;DATA
    .word 0x0010            ;DATA
    .word 0x0011            ;DATA
    .word 0x0012            ;DATA
    .word 0x0013            ;DATA
    .word 0x0014            ;DATA
    .word 0x0015            ;DATA
    .word 0x0016            ;DATA
    .word 0x0017            ;DATA
    .word 0x0018            ;DATA
    .word 0x0019            ;DATA
    .word 0x001a            ;DATA
    .word 0x001b            ;DATA
    .word 0x001c            ;DATA
    .word 0x001d            ;DATA
    .word 0x001e            ;DATA
    .word 0x001f            ;DATA
    .word 0x011f            ;DATA
    .word 0x0021            ;DATA
    .word 0x0121            ;DATA
    .word 0x0023            ;DATA
    .word 0x0123            ;DATA
    .word 0x0025            ;DATA
    .word 0x0125            ;DATA
    .word 0x0027            ;DATA
    .word 0x0127            ;DATA
    .word 0x0029            ;DATA
    .word 0x0129            ;DATA
    .word 0x002b            ;DATA
    .word 0x012b            ;DATA
    .word 0x002d            ;DATA

sub_f7b4:
    movw a, #0x0000         ;f7b4  e4 00 00
    mov a, mem_03d9         ;f7b7  60 03 d9
    clrc                    ;f7ba  81
    rolc a                  ;f7bb  02
    movw a, #mem_f7c8       ;f7bc  e4 f7 c8
    clrc                    ;f7bf  81
    addcw a                 ;f7c0  23
    movw a, @a              ;f7c1  93
    mov mem_009e, a         ;f7c2  45 9e
    swap                    ;f7c4  10
    mov mem_009f, a         ;f7c5  45 9f
    ret                     ;f7c7  20

mem_f7c8:
    .word 0x000d            ;DATA
    .word 0x010d            ;DATA
    .word 0x000e            ;DATA
    .word 0x010e            ;DATA
    .word 0x000f            ;DATA
    .word 0x010f            ;DATA
    .word 0x0010            ;DATA
    .word 0x0110            ;DATA
    .word 0x0011            ;DATA
    .word 0x0111            ;DATA
    .word 0x0012            ;DATA
    .word 0x0112            ;DATA
    .word 0x0013            ;DATA
    .word 0x0113            ;DATA
    .word 0x0014            ;DATA
    .word 0x0114            ;DATA
    .word 0x0015            ;DATA
    .word 0x0115            ;DATA
    .word 0x0016            ;DATA
    .word 0x0116            ;DATA
    .word 0x0017            ;DATA
    .word 0x0117            ;DATA
    .word 0x0018            ;DATA
    .word 0x0118            ;DATA
    .word 0x0019            ;DATA
    .word 0x0119            ;DATA
    .word 0x001a            ;DATA
    .word 0x011a            ;DATA
    .word 0x001b            ;DATA
    .word 0x011b            ;DATA
    .word 0x001c            ;DATA
    .word 0x011c            ;DATA
    .word 0x001d            ;DATA
    .word 0x011d            ;DATA
    .word 0x001e            ;DATA
    .word 0x011e            ;DATA
    .word 0x001f            ;DATA
    .word 0x011f            ;DATA
    .word 0x0021            ;DATA
    .word 0x0121            ;DATA
    .word 0x0023            ;DATA
    .word 0x0123            ;DATA
    .word 0x0025            ;DATA
    .word 0x0125            ;DATA
    .word 0x0027            ;DATA
    .word 0x0127            ;DATA
    .word 0x0029            ;DATA
    .word 0x0129            ;DATA
    .word 0x002b            ;DATA
    .word 0x012b            ;DATA
    .word 0x002d            ;DATA

sub_f82e:
    mov a, #0x07            ;f82e  04 07
    mov mem_02a1, a         ;f830  61 02 a1
    setb mem_00e2:6         ;f833  ae e2
    clrb mem_00e2:7         ;f835  a7 e2
    mov a, mem_0292         ;f837  60 02 92
    mov a, mem_009e         ;f83a  05 9e
    cmp a                   ;f83c  12
    blo lab_f868            ;f83d  f9 29
    clrb mem_00e2:5         ;f83f  a5 e2
    mov a, mem_009f         ;f841  05 9f
    beq lab_f84d            ;f843  fd 08
    mov a, mem_009e         ;f845  05 9e
    cmp a, #0x1f            ;f847  14 1f
    bhs lab_f858            ;f849  f8 0d
    setb mem_00e2:5         ;f84b  ad e2

lab_f84d:
    setb mem_00e2:4         ;f84d  ac e2
    clrb mem_00e2:6         ;f84f  a6 e2
    clrb mem_00e2:7         ;f851  a7 e2

lab_f853:
    setb mem_0098:6         ;f853  ae 98
    setb mem_00b2:5         ;f855  ad b2
    ret                     ;f857  20

lab_f858:
    mov a, mem_0292         ;f858  60 02 92
    incw a                  ;f85b  c0
    cmp a, #0x2d            ;f85c  14 2d
    blo lab_f862            ;f85e  f9 02
    mov a, #0x2d            ;f860  04 2d

lab_f862:
    mov mem_0292, a         ;f862  61 02 92
    jmp lab_f84d            ;f865  21 f8 4d

lab_f868:
    call sub_f87c           ;f868  31 f8 7c
    mov a, mem_0292         ;f86b  60 02 92
    clrc                    ;f86e  81
    addc a                  ;f86f  22
    cmp a, #0x2d            ;f870  14 2d
    blo lab_f876            ;f872  f9 02
    mov a, #0x2d            ;f874  04 2d

lab_f876:
    mov mem_0292, a         ;f876  61 02 92
    jmp lab_f853            ;f879  21 f8 53

sub_f87c:
    mov a, mem_0292         ;f87c  60 02 92
    cmp a, #0x1f            ;f87f  14 1f
    bhs lab_f886            ;f881  f8 03
    mov a, #0x01            ;f883  04 01
    ret                     ;f885  20

lab_f886:
    mov a, #0x02            ;f886  04 02
    ret                     ;f888  20

sub_f889:
    bbs mem_008c:7, lab_f89a ;f889  bf 8c 0e
    bbc mem_00dc:7, lab_f89b ;f88c  b7 dc 0c
    clrb mem_00dc:7         ;f88f  a7 dc
    mov a, #0x00            ;f891  04 00
    mov mem_0293, a         ;f893  61 02 93
    setb mem_00b2:5         ;f896  ad b2
    clrb mem_00d9:4         ;f898  a4 d9

lab_f89a:
    ret                     ;f89a  20

lab_f89b:
    mov a, mem_01ed         ;f89b  60 01 ed
    bne lab_f8b8            ;f89e  fc 18
    bbc mem_00e5:1, lab_f8b3 ;f8a0  b1 e5 10
    call sub_f8d3           ;f8a3  31 f8 d3

lab_f8a6:
    bbs mem_00e5:1, lab_f89a ;f8a6  b9 e5 f1
    bbc mem_00e2:4, lab_f89a ;f8a9  b4 e2 ee
    mov a, mem_0292         ;f8ac  60 02 92
    mov mem_0291, a         ;f8af  61 02 91
    ret                     ;f8b2  20

lab_f8b3:
    call sub_f968           ;f8b3  31 f9 68
    bhs lab_f8a6            ;f8b6  f8 ee

lab_f8b8:
    bbc mem_0097:3, lab_f8c1 ;f8b8  b3 97 06
    call sub_f9b0           ;f8bb  31 f9 b0
    jmp lab_f8a6            ;f8be  21 f8 a6

lab_f8c1:
    bbc mem_0097:4, lab_f8ca ;f8c1  b4 97 06
    call sub_fa06           ;f8c4  31 fa 06
    jmp lab_f8a6            ;f8c7  21 f8 a6

lab_f8ca:
    mov a, mem_0292         ;f8ca  60 02 92
    mov mem_0293, a         ;f8cd  61 02 93
    jmp lab_f8a6            ;f8d0  21 f8 a6

sub_f8d3:
    bbc mem_00e5:2, lab_f90b ;f8d3  b2 e5 35
    clrb mem_00e5:2         ;f8d6  a2 e5
    setb mem_00b2:5         ;f8d8  ad b2
    mov a, mem_0292         ;f8da  60 02 92
    cmp a, #0x2d            ;f8dd  14 2d
    beq lab_f8fb            ;f8df  fd 1a
    incw a                  ;f8e1  c0
    mov mem_0292, a         ;f8e2  61 02 92
    cmp a, #0x2d            ;f8e5  14 2d
    blo lab_f8fb            ;f8e7  f9 12
    mov a, #0x2d            ;f8e9  04 2d
    mov mem_0292, a         ;f8eb  61 02 92
    setb mem_00b2:2         ;f8ee  aa b2
    setb mem_00b2:4         ;f8f0  ac b2
    setb mem_0098:4         ;f8f2  ac 98
    setb mem_0099:4         ;f8f4  ac 99
    mov a, #0x1e            ;f8f6  04 1e
    mov mem_02af, a         ;f8f8  61 02 af

lab_f8fb:
    mov a, mem_0292         ;f8fb  60 02 92
    mov a, mem_029f         ;f8fe  60 02 9f
    cmp a                   ;f901  12
    blo lab_f939            ;f902  f9 35
    call sub_f946           ;f904  31 f9 46
    call sub_e70d           ;f907  31 e7 0d
    ret                     ;f90a  20

lab_f90b:
    bbc mem_00e5:3, lab_f924 ;f90b  b3 e5 16
    clrb mem_00e5:3         ;f90e  a3 e5
    setb mem_00b2:5         ;f910  ad b2
    mov a, mem_0292         ;f912  60 02 92
    cmp a, #0x06            ;f915  14 06
    bhs lab_f91d            ;f917  f8 04
    clrb mem_00b2:5         ;f919  a5 b2
    blo lab_f939            ;f91b  f9 1c        BRANCH_ALWAYS_TAKEN

lab_f91d:
    decw a                  ;f91d  d0
    mov mem_0292, a         ;f91e  61 02 92
    jmp lab_f939            ;f921  21 f9 39

lab_f924:
    mov a, #0x30            ;f924  04 30
    and a, mem_00e5         ;f926  65 e5
    beq lab_f939            ;f928  fd 0f
    mov a, #0x18            ;f92a  04 18
    and a, mem_0097         ;f92c  65 97
    beq lab_f939            ;f92e  fd 09
    bbc mem_0097:3, lab_f940 ;f930  b3 97 0d
    call sub_f9b0           ;f933  31 f9 b0

lab_f936:
    call sub_e70d           ;f936  31 e7 0d

lab_f939:
    mov a, mem_0292         ;f939  60 02 92
    mov mem_0293, a         ;f93c  61 02 93
    ret                     ;f93f  20

lab_f940:
    call sub_fa06           ;f940  31 fa 06
    jmp lab_f936            ;f943  21 f9 36

sub_f946:
    mov a, mem_0292         ;f946  60 02 92
    mov mem_0293, a         ;f949  61 02 93
    .byte 0x60, 0x00, 0xfe  ;f94c  60 00 fe     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00fe
    rolc a                  ;f94f  02
    blo lab_f95c            ;f950  f9 0a
    .byte 0x60, 0x00, 0xfe  ;f952  60 00 fe     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00fe
    call sub_fb3b           ;f955  31 fb 3b

lab_f958:
    mov mem_0292, a         ;f958  61 02 92
    ret                     ;f95b  20

lab_f95c:
    .byte 0x60, 0x00, 0xfe  ;f95c  60 00 fe     EXTENDED_ADDRESS_PAGE_0  mov a, mem_00fe
    xor a, #0xff            ;f95f  54 ff
    incw a                  ;f961  c0
    call sub_e730           ;f962  31 e7 30
    jmp lab_f958            ;f965  21 f9 58

sub_f968:
    mov a, mem_0095         ;f968  05 95
    bne lab_f990            ;f96a  fc 24
    mov a, mem_00c5         ;f96c  05 c5
    beq lab_f990            ;f96e  fd 20
    mov a, mem_0292         ;f970  60 02 92
    cmp a, #0x05            ;f973  14 05
    blo lab_f990            ;f975  f9 19
    bbs mem_00dc:3, lab_f990 ;f977  bb dc 16
    setb mem_00b2:5         ;f97a  ad b2
    call sub_f994           ;f97c  31 f9 94
    mov a, #0x18            ;f97f  04 18
    and a, mem_0097         ;f981  65 97
    beq lab_f992            ;f983  fd 0d
    mov a, mem_0293         ;f985  60 02 93
    mov mem_0292, a         ;f988  61 02 92
    mov a, #0x00            ;f98b  04 00
    mov mem_028a, a         ;f98d  61 02 8a

lab_f990:
    setc                    ;f990  91
    ret                     ;f991  20

lab_f992:
    clrc                    ;f992  81
    ret                     ;f993  20

sub_f994:
    mov a, mem_028a         ;f994  60 02 8a
    rolc a                  ;f997  02
    bhs lab_f9a7            ;f998  f8 0d
    mov a, mem_028a         ;f99a  60 02 8a
    xor a, #0xff            ;f99d  54 ff
    incw a                  ;f99f  c0
    call sub_fb3b           ;f9a0  31 fb 3b

lab_f9a3:
    mov mem_0293, a         ;f9a3  61 02 93
    ret                     ;f9a6  20

lab_f9a7:
    mov a, mem_028a         ;f9a7  60 02 8a
    call sub_e730           ;f9aa  31 e7 30
    jmp lab_f9a3            ;f9ad  21 f9 a3

sub_f9b0:
    clrb mem_0097:3         ;f9b0  a3 97
    setb mem_00b2:5         ;f9b2  ad b2
    clrb mem_00e2:5         ;f9b4  a5 e2
    setb mem_00e2:4         ;f9b6  ac e2
    clrb mem_00e2:3         ;f9b8  a3 e2
    mov a, mem_0292         ;f9ba  60 02 92
    clrc                    ;f9bd  81
    bbc mem_00d9:4, lab_f9e7 ;f9be  b4 d9 26
    clrb mem_00d9:4         ;f9c1  a4 d9
    addc a, #0x02           ;f9c3  24 02

lab_f9c5:
    mov mem_0292, a         ;f9c5  61 02 92
    cmp a, #0x2d            ;f9c8  14 2d
    blo lab_f9ec            ;f9ca  f9 20
    mov a, #0x2d            ;f9cc  04 2d
    mov mem_0292, a         ;f9ce  61 02 92
    setb mem_00b2:2         ;f9d1  aa b2
    setb mem_00b2:4         ;f9d3  ac b2
    setb mem_0098:4         ;f9d5  ac 98
    setb mem_0099:4         ;f9d7  ac 99
    mov a, #0x1e            ;f9d9  04 1e
    mov mem_02af, a         ;f9db  61 02 af

lab_f9de:
    movw ep, #mem_03e0      ;f9de  e7 03 e0
    call sub_e714           ;f9e1  31 e7 14
    bne sub_f9b0            ;f9e4  fc ca
    ret                     ;f9e6  20

lab_f9e7:
    addc a, #0x01           ;f9e7  24 01
    jmp lab_f9c5            ;f9e9  21 f9 c5

lab_f9ec:
    mov a, #0x00            ;f9ec  04 00
    mov mem_02fa, a         ;f9ee  61 02 fa
    bbc mem_00b2:3, lab_f9fa ;f9f1  b3 b2 06
    clrb mem_00b2:3         ;f9f4  a3 b2
    clrb mem_00b2:4         ;f9f6  a4 b2
    setb mem_0098:4         ;f9f8  ac 98

lab_f9fa:
    bbc mem_00b2:2, lab_f9de ;f9fa  b2 b2 e1
    clrb mem_00b2:2         ;f9fd  a2 b2
    clrb mem_00b2:4         ;f9ff  a4 b2
    setb mem_0098:4         ;fa01  ac 98
    jmp lab_f9de            ;fa03  21 f9 de

sub_fa06:
    clrb mem_0097:4         ;fa06  a4 97
    setb mem_00b2:5         ;fa08  ad b2
    setb mem_00e2:4         ;fa0a  ac e2
    clrb mem_00e2:3         ;fa0c  a3 e2
    clrb mem_0099:4         ;fa0e  a4 99
    bbc mem_00e2:5, lab_fa29 ;fa10  b5 e2 16
    clrb mem_00e2:5         ;fa13  a5 e2

lab_fa15:
    bbc mem_00b2:2, lab_fa1e ;fa15  b2 b2 06
    clrb mem_00b2:2         ;fa18  a2 b2
    clrb mem_00b2:4         ;fa1a  a4 b2
    setb mem_0098:4         ;fa1c  ac 98

lab_fa1e:
    clrb mem_00b2:3         ;fa1e  a3 b2

lab_fa20:
    movw ep, #mem_03e1      ;fa20  e7 03 e1
    call sub_e714           ;fa23  31 e7 14
    bne sub_fa06            ;fa26  fc de
    ret                     ;fa28  20

lab_fa29:
    mov a, mem_0292         ;fa29  60 02 92
    clrc                    ;fa2c  81
    bbc mem_00d9:4, lab_fa58 ;fa2d  b4 d9 28
    clrb mem_00d9:4         ;fa30  a4 d9
    subc a, #0x03           ;fa32  34 03

lab_fa34:
    blo lab_fa3d            ;fa34  f9 07
    mov mem_0292, a         ;fa36  61 02 92
    cmp a, #0x00            ;fa39  14 00
    bne lab_fa15            ;fa3b  fc d8

lab_fa3d:
    mov a, #0x00            ;fa3d  04 00
    mov mem_0292, a         ;fa3f  61 02 92
    bbs mem_00b2:3, lab_fa4f ;fa42  bb b2 0a
    mov a, mem_01ef         ;fa45  60 01 ef
    bne lab_fa4f            ;fa48  fc 05
    mov a, #0x01            ;fa4a  04 01
    mov mem_02cc, a         ;fa4c  61 02 cc

lab_fa4f:
    setb mem_00b2:3         ;fa4f  ab b2
    setb mem_00b2:4         ;fa51  ac b2
    setb mem_0098:4         ;fa53  ac 98
    jmp lab_fa20            ;fa55  21 fa 20

lab_fa58:
    subc a, #0x01           ;fa58  34 01
    jmp lab_fa34            ;fa5a  21 fa 34


sub_fa5d:
;Called from ISR for irq0 (external interrupt 1)
;when INT0 /VOLUME_IN changes
;Also called from 0xfade
    mov a, mem_01ed         ;fa5d  60 01 ed
    bne lab_fa98            ;fa60  fc 36
    mov a, mem_00b1         ;fa62  05 b1
    bne lab_fa98            ;fa64  fc 32
    bbs pdr2:4, lab_fa6f    ;fa66  bc 04 06     branch if audio not muted
    mov a, mem_00e9         ;fa69  05 e9
    cmp a, #0xf7            ;fa6b  14 f7
    bne lab_fa98            ;fa6d  fc 29

lab_fa6f:
    mov a, mem_03e2         ;fa6f  60 03 e2
    bne lab_faaa            ;fa72  fc 36
    call sub_fb1f           ;fa74  31 fb 1f
    and a, #0x1f            ;fa77  64 1f
    bne lab_faa6            ;fa79  fc 2b
    mov a, #0x01            ;fa7b  04 01

lab_fa7d:
    mov mem_03e2, a         ;fa7d  61 03 e2
    mov a, #0x0a            ;fa80  04 0a
    mov mem_03df, a         ;fa82  61 03 df
    call sub_fb2d           ;fa85  31 fb 2d
    and a, #0x1f            ;fa88  64 1f
    cmp a, #0x1f            ;fa8a  14 1f
    clrc                    ;fa8c  81
    bne lab_fa90            ;fa8d  fc 01
    setc                    ;fa8f  91

lab_fa90:
    mov a, mem_03e3         ;fa90  60 03 e3
    rolc a                  ;fa93  02
    mov mem_03e3, a         ;fa94  61 03 e3

lab_fa97:
    ret                     ;fa97  20

lab_fa98:
    clrb mem_00d9:4         ;fa98  a4 d9
    mov a, #0x00            ;fa9a  04 00
    mov mem_03e2, a         ;fa9c  61 03 e2
    mov mem_03e0, a         ;fa9f  61 03 e0
    mov mem_03e1, a         ;faa2  61 03 e1
    ret                     ;faa5  20

lab_faa6:
    mov a, #0x08            ;faa6  04 08
    bne lab_fa7d            ;faa8  fc d3        BRANCH_ALWAYS_TAKEN

lab_faaa:
    cmp a, #0x01            ;faaa  14 01
    bne lab_faf4            ;faac  fc 46
    call sub_fb1f           ;faae  31 fb 1f
    and a, #0x1f            ;fab1  64 1f
    cmp a, #0x1f            ;fab3  14 1f
    bne lab_fad9            ;fab5  fc 22
    mov a, mem_03df         ;fab7  60 03 df
    beq lab_fad9            ;faba  fd 1d
    call sub_fb2d           ;fabc  31 fb 2d
    and a, #0x1f            ;fabf  64 1f
    cmp a, #0x1f            ;fac1  14 1f
    bne lab_fae1            ;fac3  fc 1c
    mov a, mem_03e3         ;fac5  60 03 e3
    and a, #0x01            ;fac8  64 01
    bne lab_fad9            ;faca  fc 0d

lab_facc:
    setb mem_00d3:4         ;facc  ac d3
    mov a, mem_03e0         ;face  60 03 e0
    incw a                  ;fad1  c0
    mov mem_03e0, a         ;fad2  61 03 e0

lab_fad5:
    setb mem_00d3:7         ;fad5  af d3
    setb mem_00d3:6         ;fad7  ae d3

lab_fad9:
    mov a, #0x00            ;fad9  04 00
    mov mem_03e2, a         ;fadb  61 03 e2
    jmp sub_fa5d            ;fade  21 fa 5d     Volume related; also called from ISR if /VOLUME_IN changed

lab_fae1:
    mov a, mem_03e3         ;fae1  60 03 e3
    and a, #0x01            ;fae4  64 01
    beq lab_fad9            ;fae6  fd f1

lab_fae8:
    setb mem_00d3:5         ;fae8  ad d3
    mov a, mem_03e1         ;faea  60 03 e1
    incw a                  ;faed  c0
    mov mem_03e1, a         ;faee  61 03 e1
    jmp lab_fad5            ;faf1  21 fa d5

lab_faf4:
    cmp a, #0x08            ;faf4  14 08
    bne lab_fa97            ;faf6  fc 9f
    call sub_fb1f           ;faf8  31 fb 1f
    and a, #0x1f            ;fafb  64 1f
    bne lab_fad9            ;fafd  fc da
    mov a, mem_03df         ;faff  60 03 df
    beq lab_fad9            ;fb02  fd d5
    call sub_fb2d           ;fb04  31 fb 2d
    and a, #0x1f            ;fb07  64 1f
    cmp a, #0x1f            ;fb09  14 1f
    bne lab_fb16            ;fb0b  fc 09
    mov a, mem_03e3         ;fb0d  60 03 e3
    and a, #0x01            ;fb10  64 01
    bne lab_fad9            ;fb12  fc c5
    beq lab_fae8            ;fb14  fd d2        BRANCH_ALWAYS_TAKEN

lab_fb16:
    mov a, mem_03e3         ;fb16  60 03 e3
    and a, #0x01            ;fb19  64 01
    beq lab_fad9            ;fb1b  fd bc
    bne lab_facc            ;fb1d  fc ad        BRANCH_ALWAYS_TAKEN

sub_fb1f:
    movw a, #0x0000         ;fb1f  e4 00 00

lab_fb22:
    setc                    ;fb22  91
    bbc pdr6:0, lab_fb27    ;fb23  b0 11 01     /VOLUME_IN
    clrc                    ;fb26  81

lab_fb27:
    call sub_e729           ;fb27  31 e7 29
    bne lab_fb22            ;fb2a  fc f6
    ret                     ;fb2c  20

sub_fb2d:
    movw a, #0x0000         ;fb2d  e4 00 00

lab_fb30:
    clrc                    ;fb30  81
    bbc pdr1:1, lab_fb35    ;fb31  b1 02 01     VOLUME_1
    setc                    ;fb34  91

lab_fb35:
    call sub_e729           ;fb35  31 e7 29
    bne lab_fb30            ;fb38  fc f6
    ret                     ;fb3a  20

sub_fb3b:
    mov a, mem_0292         ;fb3b  60 02 92
    xch a, t                ;fb3e  42
    clrc                    ;fb3f  81
    subc a                  ;fb40  32
    bhs lab_fb45            ;fb41  f8 02
    mov a, #0x00            ;fb43  04 00

lab_fb45:
    ret                     ;fb45  20

sub_fb46:
    jmp lab_fb5e            ;fb46  21 fb 5e

lab_fb49:
    mov a, mem_01ff         ;fb49  60 01 ff
    clrc                    ;fb4c  81
    rorc a                  ;fb4d  03
    beq lab_fb52            ;fb4e  fd 02
    or a, #0x08             ;fb50  74 08

lab_fb52:
    mov mem_00a0, a         ;fb52  45 a0
    mov mem_009e, #0x32     ;fb54  85 9e 32
    mov mem_009f, #0x16     ;fb57  85 9f 16
    call sub_fba3           ;fb5a  31 fb a3
    ret                     ;fb5d  20

lab_fb5e:
    clrc                    ;fb5e  81
    movw a, #0x0000         ;fb5f  e4 00 00
    mov a, mem_00b3         ;fb62  05 b3
    subc a, #0xf6           ;fb64  34 f6
    clrc                    ;fb66  81
    rolc a                  ;fb67  02
    rolc a                  ;fb68  02
    movw a, #mem_fc03       ;fb69  e4 fc 03
    call sub_fcd7           ;fb6c  31 fc d7
    mov a, mem_0095         ;fb6f  05 95
    bne lab_fb95            ;fb71  fc 22
    mov a, mem_00c5         ;fb73  05 c5
    beq lab_fb95            ;fb75  fd 1e
    clrc                    ;fb77  81
    movw a, #0x0000         ;fb78  e4 00 00
    mov a, mem_00b4         ;fb7b  05 b4
    subc a, #0xf6           ;fb7d  34 f6
    movw a, #mem_fc57       ;fb7f  e4 fc 57
lab_fb82:
    clrc                    ;fb82  81
    addcw a                 ;fb83  23
    movw ix, a              ;fb84  e2
    mov a, @ix+0x00         ;fb85  06 00
    mov mem_00a0, a         ;fb87  45 a0
    mov mem_009e, #0x33     ;fb89  85 9e 33
    mov mem_009f, #0x15     ;fb8c  85 9f 15
    call sub_fba3           ;fb8f  31 fb a3
    jmp lab_fb49            ;fb92  21 fb 49

lab_fb95:
    clrc                    ;fb95  81
    movw a, #0x0000         ;fb96  e4 00 00
    mov a, mem_00b4         ;fb99  05 b4
    subc a, #0xf6           ;fb9b  34 f6
    movw a, #mem_fc6c       ;fb9d  e4 fc 6c
    jmp lab_fb82            ;fba0  21 fb 82

sub_fba3:
    clrb pdr1:5             ;fba3  a5 02        EQ_CE=low
    clrb pdr1:3             ;fba5  a3 02        /EQ_BOSE_CLOCK=low
    clrb pdr1:4             ;fba7  a4 02        EQ_BOSE_DATA=low
    mov mem_00a1, #0x61     ;fba9  85 a1 61
    mov mem_00a2, #0x08     ;fbac  85 a2 08
    call sub_fbdf           ;fbaf  31 fb df
    inc r0                  ;fbb2  c8
    dec r0                  ;fbb3  d8
    setb pdr1:5             ;fbb4  ad 02        EQ_CE=high
    inc r0                  ;fbb6  c8
    dec r0                  ;fbb7  d8
    mov a, mem_009e         ;fbb8  05 9e
    mov mem_00a1, a         ;fbba  45 a1
    mov mem_00a2, #0x08     ;fbbc  85 a2 08
    call sub_fbdf           ;fbbf  31 fb df
    mov a, mem_009f         ;fbc2  05 9f
    mov mem_00a1, a         ;fbc4  45 a1
    mov mem_00a2, #0x08     ;fbc6  85 a2 08
    call sub_fbdf           ;fbc9  31 fb df
    mov a, mem_00a0         ;fbcc  05 a0
    mov mem_00a1, a         ;fbce  45 a1
    mov mem_00a2, #0x04     ;fbd0  85 a2 04
    call sub_fbdf           ;fbd3  31 fb df
    inc r0                  ;fbd6  c8
    dec r0                  ;fbd7  d8
    clrb pdr1:5             ;fbd8  a5 02        EQ_CE=low
    clrb pdr1:3             ;fbda  a3 02        /EQ_BOSE_CLOCK=low
    clrb pdr1:4             ;fbdc  a4 02        EQ_BOSE_DATA=low
    ret                     ;fbde  20

sub_fbdf:
    mov a, mem_00a1         ;fbdf  05 a1
    clrc                    ;fbe1  81
    rorc a                  ;fbe2  03
    mov mem_00a1, a         ;fbe3  45 a1
    bhs lab_fbec            ;fbe5  f8 05
    setb pdr1:4             ;fbe7  ac 02        EQ_BOSE_DATA=high
    jmp lab_fbf0            ;fbe9  21 fb f0

lab_fbec:
    clrb pdr1:4             ;fbec  a4 02        EQ_BOSE_DATA=low
    incw a                  ;fbee  c0
    decw a                  ;fbef  d0

lab_fbf0:
    setb pdr1:3             ;fbf0  ab 02        /EQ_BOSE_CLOCK=high
    incw a                  ;fbf2  c0
    decw a                  ;fbf3  d0
    clrb pdr1:3             ;fbf4  a3 02        /EQ_BOSE_CLOCK=low
    mov a, mem_00a2         ;fbf6  05 a2
    decw a                  ;fbf8  d0
    mov mem_00a2, a         ;fbf9  45 a2
    cmp mem_00a2, #0x00     ;fbfb  95 a2 00
    bne sub_fbdf            ;fbfe  fc df
    ret                     ;fc00  20

    .byte 0x02              ;fc01  02          DATA '\x02'
    .byte 0x02              ;fc02  02          DATA '\x02'

mem_fc03:
;Table used with sub_fcd7
    .byte 0x30              ;fc03  30          DATA '0'
    .byte 0x24              ;fc04  24          DATA '$'
    .byte 0x0C              ;fc05  0c          DATA '\x0c'
    .byte 0x00              ;fc06  00          DATA '\x00'
    .byte 0x30              ;fc07  30          DATA '0'
    .byte 0x24              ;fc08  24          DATA '$'
    .byte 0x0C              ;fc09  0c          DATA '\x0c'
    .byte 0x00              ;fc0a  00          DATA '\x00'
    .byte 0x30              ;fc0b  30          DATA '0'
    .byte 0x24              ;fc0c  24          DATA '$'
    .byte 0x0B              ;fc0d  0b          DATA '\x0b'
    .byte 0x00              ;fc0e  00          DATA '\x00'
    .byte 0x30              ;fc0f  30          DATA '0'
    .byte 0x24              ;fc10  24          DATA '$'
    .byte 0x0B              ;fc11  0b          DATA '\x0b'
    .byte 0x00              ;fc12  00          DATA '\x00'
    .byte 0x30              ;fc13  30          DATA '0'
    .byte 0x24              ;fc14  24          DATA '$'
    .byte 0x0A              ;fc15  0a          DATA '\n'
    .byte 0x00              ;fc16  00          DATA '\x00'
    .byte 0x30              ;fc17  30          DATA '0'
    .byte 0x24              ;fc18  24          DATA '$'
    .byte 0x0A              ;fc19  0a          DATA '\n'
    .byte 0x00              ;fc1a  00          DATA '\x00'
    .byte 0x30              ;fc1b  30          DATA '0'
    .byte 0x24              ;fc1c  24          DATA '$'
    .byte 0x09              ;fc1d  09          DATA '\t'
    .byte 0x00              ;fc1e  00          DATA '\x00'
    .byte 0x30              ;fc1f  30          DATA '0'
    .byte 0x24              ;fc20  24          DATA '$'
    .byte 0x09              ;fc21  09          DATA '\t'
    .byte 0x00              ;fc22  00          DATA '\x00'
    .byte 0x30              ;fc23  30          DATA '0'
    .byte 0x24              ;fc24  24          DATA '$'
    .byte 0x00              ;fc25  00          DATA '\x00'
    .byte 0x00              ;fc26  00          DATA '\x00'
    .byte 0x30              ;fc27  30          DATA '0'
    .byte 0x24              ;fc28  24          DATA '$'
    .byte 0x00              ;fc29  00          DATA '\x00'
    .byte 0x00              ;fc2a  00          DATA '\x00'
    .byte 0x30              ;fc2b  30          DATA '0'
    .byte 0x24              ;fc2c  24          DATA '$'
    .byte 0x00              ;fc2d  00          DATA '\x00'
    .byte 0x00              ;fc2e  00          DATA '\x00'
    .byte 0x30              ;fc2f  30          DATA '0'
    .byte 0x24              ;fc30  24          DATA '$'
    .byte 0x00              ;fc31  00          DATA '\x00'
    .byte 0x00              ;fc32  00          DATA '\x00'
    .byte 0x30              ;fc33  30          DATA '0'
    .byte 0x24              ;fc34  24          DATA '$'
    .byte 0x00              ;fc35  00          DATA '\x00'
    .byte 0x00              ;fc36  00          DATA '\x00'
    .byte 0x30              ;fc37  30          DATA '0'
    .byte 0x24              ;fc38  24          DATA '$'
    .byte 0x01              ;fc39  01          DATA '\x01'
    .byte 0x00              ;fc3a  00          DATA '\x00'
    .byte 0x30              ;fc3b  30          DATA '0'
    .byte 0x24              ;fc3c  24          DATA '$'
    .byte 0x01              ;fc3d  01          DATA '\x01'
    .byte 0x00              ;fc3e  00          DATA '\x00'
    .byte 0x30              ;fc3f  30          DATA '0'
    .byte 0x24              ;fc40  24          DATA '$'
    .byte 0x02              ;fc41  02          DATA '\x02'
    .byte 0x00              ;fc42  00          DATA '\x00'
    .byte 0x30              ;fc43  30          DATA '0'
    .byte 0x24              ;fc44  24          DATA '$'
    .byte 0x02              ;fc45  02          DATA '\x02'
    .byte 0x00              ;fc46  00          DATA '\x00'
    .byte 0x30              ;fc47  30          DATA '0'
    .byte 0x24              ;fc48  24          DATA '$'
    .byte 0x03              ;fc49  03          DATA '\x03'
    .byte 0x00              ;fc4a  00          DATA '\x00'
    .byte 0x30              ;fc4b  30          DATA '0'
    .byte 0x24              ;fc4c  24          DATA '$'
    .byte 0x03              ;fc4d  03          DATA '\x03'
    .byte 0x00              ;fc4e  00          DATA '\x00'
    .byte 0x30              ;fc4f  30          DATA '0'
    .byte 0x24              ;fc50  24          DATA '$'
    .byte 0x04              ;fc51  04          DATA '\x04'
    .byte 0x00              ;fc52  00          DATA '\x00'
    .byte 0x30              ;fc53  30          DATA '0'
    .byte 0x14              ;fc54  14          DATA '\x14'
    .byte 0x04              ;fc55  04          DATA '\x04'
    .byte 0x00              ;fc56  00          DATA '\x00'

mem_fc57:
    .byte 0x0E              ;fc57  0e          DATA '\x0e'
    .byte 0x0E              ;fc58  0e          DATA '\x0e'
    .byte 0x0D              ;fc59  0d          DATA '\r'
    .byte 0x0D              ;fc5a  0d          DATA '\r'
    .byte 0x0C              ;fc5b  0c          DATA '\x0c'
    .byte 0x0C              ;fc5c  0c          DATA '\x0c'
    .byte 0x0B              ;fc5d  0b          DATA '\x0b'
    .byte 0x0B              ;fc5e  0b          DATA '\x0b'
    .byte 0x0A              ;fc5f  0a          DATA '\n'
    .byte 0x0A              ;fc60  0a          DATA '\n'
    .byte 0x0A              ;fc61  0a          DATA '\n'
    .byte 0x0A              ;fc62  0a          DATA '\n'
    .byte 0x0A              ;fc63  0a          DATA '\n'
    .byte 0x09              ;fc64  09          DATA '\t'
    .byte 0x09              ;fc65  09          DATA '\t'
    .byte 0x00              ;fc66  00          DATA '\x00'
    .byte 0x00              ;fc67  00          DATA '\x00'
    .byte 0x01              ;fc68  01          DATA '\x01'
    .byte 0x01              ;fc69  01          DATA '\x01'
    .byte 0x02              ;fc6a  02          DATA '\x02'
    .byte 0x02              ;fc6b  02          DATA '\x02'

mem_fc6c:
    .byte 0x0C              ;fc6c  0c          DATA '\x0c'
    .byte 0x0C              ;fc6d  0c          DATA '\x0c'
    .byte 0x0B              ;fc6e  0b          DATA '\x0b'
    .byte 0x0B              ;fc6f  0b          DATA '\x0b'
    .byte 0x0A              ;fc70  0a          DATA '\n'
    .byte 0x0A              ;fc71  0a          DATA '\n'
    .byte 0x09              ;fc72  09          DATA '\t'
    .byte 0x09              ;fc73  09          DATA '\t'
    .byte 0x00              ;fc74  00          DATA '\x00'
    .byte 0x00              ;fc75  00          DATA '\x00'
    .byte 0x00              ;fc76  00          DATA '\x00'
    .byte 0x00              ;fc77  00          DATA '\x00'
    .byte 0x00              ;fc78  00          DATA '\x00'
    .byte 0x01              ;fc79  01          DATA '\x01'
    .byte 0x01              ;fc7a  01          DATA '\x01'
    .byte 0x02              ;fc7b  02          DATA '\x02'
    .byte 0x02              ;fc7c  02          DATA '\x02'
    .byte 0x03              ;fc7d  03          DATA '\x03'
    .byte 0x03              ;fc7e  03          DATA '\x03'
    .byte 0x04              ;fc7f  04          DATA '\x04'
    .byte 0x04              ;fc80  04          DATA '\x04'

sub_fc81:
    mov a, mem_030a         ;fc81  60 03 0a
    bne lab_fca2            ;fc84  fc 1c
    mov a, mem_019d         ;fc86  60 01 9d
    and a, #0x0f            ;fc89  64 0f
    cmp a, #0x00            ;fc8b  14 00
    bne lab_fcae            ;fc8d  fc 1f
    movw a, #0x0000         ;fc8f  e4 00 00
    mov a, mem_019e         ;fc92  60 01 9e
    and a, #0xf0            ;fc95  64 f0
    clrc                    ;fc97  81
    rorc a                  ;fc98  03
    rorc a                  ;fc99  03
    clrc                    ;fc9a  81
    movw a, #mem_fcaf       ;fc9b  e4 fc af
    call sub_fcd7           ;fc9e  31 fc d7
    ret                     ;fca1  20

lab_fca2:
    mov mem_009e, #0x31     ;fca2  85 9e 31
    mov mem_009f, #0x14     ;fca5  85 9f 14
    mov mem_00a0, #0x00     ;fca8  85 a0 00
    call sub_fba3           ;fcab  31 fb a3

lab_fcae:
    ret                     ;fcae  20

mem_fcaf:
;Table used with sub_fcd7
    .byte 0x31              ;fcaf  31          DATA '1'
    .byte 0x14              ;fcb0  14          DATA '\x14'
    .byte 0x00              ;fcb1  00          DATA '\x00'
    .byte 0x00              ;fcb2  00          DATA '\x00'

    .byte 0x31              ;fcb3  31          DATA '1'
    .byte 0x14              ;fcb4  14          DATA '\x14'
    .byte 0x09              ;fcb5  09          DATA '\t'
    .byte 0x00              ;fcb6  00          DATA '\x00'

    .byte 0x31              ;fcb7  31          DATA '1'
    .byte 0x14              ;fcb8  14          DATA '\x14'
    .byte 0x09              ;fcb9  09          DATA '\t'
    .byte 0x00              ;fcba  00          DATA '\x00'

    .byte 0x31              ;fcbb  31          DATA '1'
    .byte 0x24              ;fcbc  24          DATA '$'
    .byte 0x09              ;fcbd  09          DATA '\t'
    .byte 0x00              ;fcbe  00          DATA '\x00'

    .byte 0x31              ;fcbf  31          DATA '1'
    .byte 0x13              ;fcc0  13          DATA '\x13'
    .byte 0x02              ;fcc1  02          DATA '\x02'
    .byte 0x00              ;fcc2  00          DATA '\x00'

    .byte 0x31              ;fcc3  31          DATA '1'
    .byte 0x13              ;fcc4  13          DATA '\x13'
    .byte 0x02              ;fcc5  02          DATA '\x02'
    .byte 0x00              ;fcc6  00          DATA '\x00'

    .byte 0x31              ;fcc7  31          DATA '1'
    .byte 0x13              ;fcc8  13          DATA '\x13'
    .byte 0x03              ;fcc9  03          DATA '\x03'
    .byte 0x00              ;fcca  00          DATA '\x00'

    .byte 0x31              ;fccb  31          DATA '1'
    .byte 0x14              ;fccc  14          DATA '\x14'
    .byte 0x03              ;fccd  03          DATA '\x03'
    .byte 0x00              ;fcce  00          DATA '\x00'

    .byte 0x31              ;fccf  31          DATA '1'
    .byte 0x53              ;fcd0  53          DATA 'S'
    .byte 0x02              ;fcd1  02          DATA '\x02'
    .byte 0x00              ;fcd2  00          DATA '\x00'

    .byte 0x31              ;fcd3  31          DATA '1'
    .byte 0x22              ;fcd4  22          DATA '"'
    .byte 0x03              ;fcd5  03          DATA '\x03'
    .byte 0x00              ;fcd6  00          DATA '\x00'

sub_fcd7:
    clrc                    ;fcd7  81
    addcw a                 ;fcd8  23
    movw ix, a              ;fcd9  e2
    mov a, @ix+0x00         ;fcda  06 00
    mov mem_009e, a         ;fcdc  45 9e
    mov a, @ix+0x01         ;fcde  06 01
    mov mem_009f, a         ;fce0  45 9f
    mov a, @ix+0x02         ;fce2  06 02
    mov mem_00a0, a         ;fce4  45 a0
    call sub_fba3           ;fce6  31 fb a3
    ret                     ;fce9  20

sub_fcea:
    movw ix, #mem_02b6      ;fcea  e6 02 b6
    mov a, mem_01ef         ;fced  60 01 ef
    bne lab_fcf9            ;fcf0  fc 07
    mov a, #0x10            ;fcf2  04 10
    mov mem_01ef, a         ;fcf4  61 01 ef
    setb mem_0097:2         ;fcf7  aa 97

lab_fcf9:
    call sub_fd31           ;fcf9  31 fd 31
    call sub_fd4d           ;fcfc  31 fd 4d
    bbc mem_0097:2, lab_fd11 ;fcff  b2 97 0f
    mov a, #0x00            ;fd02  04 00
    call fill_5_bytes_at_ix ;fd04  31 e6 ef

    mov a, mem_01ef         ;fd07  60 01 ef
    cmp a, #0x10            ;fd0a  14 10
    bne lab_fd18            ;fd0c  fc 0a

    ;(mem_01ef=0x10)
    mov @ix+0x01, #0x20     ;fd0e  86 01 20     0x20 'RAD.3CP.T7.'

lab_fd11:
    mov a, mem_00d8         ;fd11  05 d8
    and a, #0xf0            ;fd13  64 f0
    mov mem_00d8, a         ;fd15  45 d8
    ret                     ;fd17  20

lab_fd18:
    cmp a, #0x20            ;fd18  14 20
    bne lab_fd22            ;fd1a  fc 06

    ;(mem_01ef=0x20)
    call sub_fd7d           ;fd1c  31 fd 7d     0x21 'VER........'
    jmp lab_fd11            ;fd1f  21 fd 11

lab_fd22:
    cmp a, #0x50            ;fd22  14 50
    bne lab_fd11            ;fd24  fc eb

    ;(mem_01ef=0x50)
    bbc pdr2:0, lab_fd2d    ;fd26  b0 04 04     PHANTOM_ON
    mov @ix+0x01, #0x30     ;fd29  86 01 30     0x30 'FERN...ON..'
    ret                     ;fd2c  20

lab_fd2d:
    mov @ix+0x01, #0x31     ;fd2d  86 01 31     0x31 'FERN...OFF.'
    ret                     ;fd30  20

sub_fd31:
    mov a, mem_00d8         ;fd31  05 d8
    and a, #0x0f            ;fd33  64 0f
    bne lab_fd3d            ;fd35  fc 06
    mov a, mem_00d9         ;fd37  05 d9
    and a, #0x24            ;fd39  64 24
    beq lab_fd40            ;fd3b  fd 03

lab_fd3d:
    setb mem_0097:2         ;fd3d  aa 97

lab_fd3f:
    ret                     ;fd3f  20

lab_fd40:
    mov a, mem_03e4         ;fd40  60 03 e4
    bne lab_fd3f            ;fd43  fc fa
    mov a, #0x0a            ;fd45  04 0a
    mov mem_03e4, a         ;fd47  61 03 e4
    jmp lab_fd3d            ;fd4a  21 fd 3d

sub_fd4d:
    mov a, mem_01ef         ;fd4d  60 01 ef
    and a, #0xf0            ;fd50  64 f0
    clrc                    ;fd52  81
    bbc mem_00d9:2, lab_fd6a ;fd53  b2 d9 14
    clrb mem_00d9:2         ;fd56  a2 d9
    addc a, #0x10           ;fd58  24 10
    cmp a, #0x30            ;fd5a  14 30
    bne lab_fd62            ;fd5c  fc 04

lab_fd5e:
    mov a, #0x50            ;fd5e  04 50
    bne lab_fd79            ;fd60  fc 17        BRANCH_ALWAYS_TAKEN

lab_fd62:
    cmp a, #0x60            ;fd62  14 60
    bne lab_fd79            ;fd64  fc 13
    mov a, #0x10            ;fd66  04 10
    bne lab_fd79            ;fd68  fc 0f        BRANCH_ALWAYS_TAKEN

lab_fd6a:
    bbc mem_00d9:5, lab_fd7c ;fd6a  b5 d9 0f
    clrb mem_00d9:5         ;fd6d  a5 d9
    subc a, #0x10           ;fd6f  34 10
    beq lab_fd5e            ;fd71  fd eb
    cmp a, #0x40            ;fd73  14 40
    bne lab_fd79            ;fd75  fc 02
    mov a, #0x20            ;fd77  04 20

lab_fd79:
    mov mem_01ef, a         ;fd79  61 01 ef

lab_fd7c:
    ret                     ;fd7c  20

sub_fd7d:
    mov @ix+0x01, #0x21     ;fd7d  86 01 21     0x21 'VER........'
    movw a, #mem_800a       ;fd80  e4 80 0a
    movw a, @a              ;fd83  93
    movw @ix+0x02, a        ;fd84  d6 02
    ret                     ;fd86  20

sub_fd87:
;Called with A = number of bytes in KW1281 packet
    movw a, mem_0245        ;fd87  c4 02 45
    jmp lab_fd90            ;fd8a  21 fd 90

sub_fd8d:
    movw a, mem_0247        ;fd8d  c4 02 47

lab_fd90:
    movw ix, a              ;fd90  e2
    mov r0, #0x0f           ;fd91  88 0f
    movw a, #0x031a         ;fd93  e4 03 1a

lab_fd96:
    cmpw a                  ;fd96  13
    bhs lab_fda4            ;fd97  f8 0b
    clrc                    ;fd99  81
    movw a, #0x0035         ;fd9a  e4 00 35
    subcw a                 ;fd9d  33
    xchw a, t               ;fd9e  43
    movw a, ix              ;fd9f  f2
    xchw a, t               ;fda0  43
    dec r0                  ;fda1  d8
    bne lab_fd96            ;fda2  fc f2

lab_fda4:
    mov a, r0               ;fda4  08
    ret                     ;fda5  20

sub_fda6:
    beq lab_fdeb            ;fda6  fd 43
    movw a, #0x0199         ;fda8  e4 01 99
    cmpw a                  ;fdab  13
    bhs lab_fde7            ;fdac  f8 39
    xchw a, t               ;fdae  43
    decw a                  ;fdaf  d0
    clrc                    ;fdb0  81
    swap                    ;fdb1  10
    rorc a                  ;fdb2  03
    swap                    ;fdb3  10
    rorc a                  ;fdb4  03
    cmp a, #0x11            ;fdb5  14 11
    blo lab_fddc            ;fdb7  f9 23
    subc a, #0x11           ;fdb9  34 11
    movw a, #0x0005         ;fdbb  e4 00 05
    divu a                  ;fdbe  11
    clrc                    ;fdbf  81
    rolc a                  ;fdc0  02
    xchw a, t               ;fdc1  43
    mov r0, a               ;fdc2  48
    xchw a, t               ;fdc3  43
    mov mem_00a4, a         ;fdc4  45 a4
    mov mem_00a3, #0x00     ;fdc6  85 a3 00

    call bin16_to_bcd16     ;Convert 16-bit binary number to BCD.
                            ;  Input word:  mem_00a3
                            ;  Output word: mem_009f

    mov a, #0x01            ;fdcc  04 01
    cmp a, r0               ;fdce  18
    mov a, #0x25            ;fdcf  04 25
    bhs lab_fdd4            ;fdd1  f8 01
    incw a                  ;fdd3  c0

lab_fdd4:
    mov a, mem_00a0         ;fdd4  05 a0
    clrc                    ;fdd6  81
    addc a                  ;fdd7  22
    daa                     ;fdd8  84
    jmp lab_fde2            ;fdd9  21 fd e2

lab_fddc:
    movw a, #mem_fdef       ;fddc  e4 fd ef
    clrc                    ;fddf  81
    addcw a                 ;fde0  23
    mov a, @a               ;fde1  92

lab_fde2:
    movw a, #0x00ff         ;fde2  e4 00 ff
    andw a                  ;fde5  63
    ret                     ;fde6  20

lab_fde7:
    movw a, #0x0100         ;fde7  e4 01 00
    ret                     ;fdea  20

lab_fdeb:
    movw a, #0x0000         ;fdeb  e4 00 00
    ret                     ;fdee  20

mem_fdef:
    .byte 0x00              ;fdef  00          DATA '\x00'
    .byte 0x09              ;fdf0  09          DATA '\t'
    .byte 0x12              ;fdf1  12          DATA '\x12'
    .byte 0x15              ;fdf2  15          DATA '\x15'
    .byte 0x17              ;fdf3  17          DATA '\x17'
    .byte 0x18              ;fdf4  18          DATA '\x18'
    .byte 0x19              ;fdf5  19          DATA '\x19'
    .byte 0x20              ;fdf6  20          DATA ' '
    .byte 0x20              ;fdf7  20          DATA ' '
    .byte 0x21              ;fdf8  21          DATA '!'
    .byte 0x21              ;fdf9  21          DATA '!'
    .byte 0x22              ;fdfa  22          DATA '"'
    .byte 0x22              ;fdfb  22          DATA '"'
    .byte 0x23              ;fdfc  23          DATA '#'
    .byte 0x23              ;fdfd  23          DATA '#'
    .byte 0x24              ;fdfe  24          DATA '$'
    .byte 0x24              ;fdff  24          DATA '$'

mem_fe00:
;mem_00ae case table for key codes
    .word lab_8b64          ;fe00  8b 64       VECTOR   0x00 Preset 6
    .word lab_8b64          ;fe02  8b 64       VECTOR   0x01 Preset 5
    .word lab_8b64          ;fe04  8b 64       VECTOR   0x02 Preset 4
    .word lab_8b16          ;fe06  8b 16       VECTOR   0x03 Bass
    .word lab_8b64          ;fe08  8b 64       VECTOR   0x04 Preset 3
    .word lab_8b64          ;fe0a  8b 64       VECTOR   0x05 Preset 2
    .word lab_8b64          ;fe0c  8b 64       VECTOR   0x06 Preset 1
    .word lab_8aad          ;fe0e  8a ad       VECTOR   0x07 Treb
    .word lab_8749          ;fe10  87 49       VECTOR   0x08 FM
    .word lab_87d8          ;fe12  87 d8       VECTOR   0x09 AM
    .word sub_895a          ;fe14  89 5a       VECTOR   0x0a Tune Up
    .word lab_8b1d          ;fe16  8b 1d       VECTOR   0x0b Bal
    .word lab_8820          ;fe18  88 20       VECTOR   0x0c CD
    .word lab_8861          ;fe1a  88 61       VECTOR   0x0d Tape
    .word sub_89c3          ;fe1c  89 c3       VECTOR   0x0e Tune Down
    .word lab_8b4b          ;fe1e  8b 4b       VECTOR   0x0f Fade
    .word lab_8a85          ;fe20  8a 85       VECTOR   0x10 BEETLE_TAPE_REW
    .word lab_8a85          ;fe22  8a 85       VECTOR   0x11 BEETLE_TAPE_FF
    .word lab_8a8c          ;fe24  8a 8c       VECTOR   0x12 Tape Side
    .word sub_88bd          ;fe26  88 bd       VECTOR   0x13 Seek Up
    .word lab_8a5f          ;fe28  8a 5f       VECTOR   0x14 Mix/Dolby
    .word lab_8aa7          ;fe2a  8a a7       VECTOR   0x15 BEETLE_DOLBY
    .word lab_89e9          ;fe2c  89 e9       VECTOR   0x16 Scan
    .word sub_8936          ;fe2e  89 36       VECTOR   0x17 Seek Down
    .word lab_8bf8          ;fe30  8b f8       VECTOR   0x18 no code
    .word lab_8bf6          ;fe32  8b f6       VECTOR   0x19 initial
    .word lab_8c76          ;fe34  8c 76       VECTOR   0x1a ?
    .word lab_8c76          ;fe36  8c 76       VECTOR   0x1b ?
    .word lab_8c01          ;fe38  8c 01       VECTOR   0x1c MFSW:41E850AF VOL DOWN
    .word lab_8c0f          ;fe3a  8c 0f       VECTOR   0x1d MFSW:41E8807F VOL UP
    .word lab_8c4c          ;fe3c  8c 4c       VECTOR   0x1e MFSW:41E850AF DOWN
    .word lab_8c37          ;fe3e  8c 37       VECTOR   0x1f MFSW:41E8D02F UP
    .word lab_8c76          ;fe40  8c 76       VECTOR   0x20 no key?

mem_fe42:
;another mem_00ae case table for key codes
    .word lab_8bde          ;fe42  8b de       VECTOR   0x00 Preset 6
    .word lab_8bde          ;fe44  8b de       VECTOR   0x01 Preset 5
    .word lab_8bde          ;fe46  8b de       VECTOR   0x02 Preset 4
    .word lab_8b17          ;fe48  8b 17       VECTOR   0x03 Bass
    .word lab_8bde          ;fe4a  8b de       VECTOR   0x04 Preset 3
    .word lab_8bde          ;fe4c  8b de       VECTOR   0x05 Preset 2
    .word lab_8bde          ;fe4e  8b de       VECTOR   0x06 Preset 1
    .word lab_8ab0          ;fe50  8a b0       VECTOR   0x07 Treb
    .word lab_8b52          ;fe52  8b 52       VECTOR   0x08 FM
    .word lab_8b52          ;fe54  8b 52       VECTOR   0x09 AM
    .word sub_89cc          ;fe56  89 cc       VECTOR   0x0a Tune Up
    .word lab_8b3d          ;fe58  8b 3d       VECTOR   0x0b Bal
    .word lab_8b52          ;fe5a  8b 52       VECTOR   0x0c CD
    .word lab_8b52          ;fe5c  8b 52       VECTOR   0x0d Tape
    .word sub_89cc          ;fe5e  89 cc       VECTOR   0x0e Tune Down
    .word lab_8b4c          ;fe60  8b 4c       VECTOR   0x0f Fade
    .word lab_8a86          ;fe62  8a 86       VECTOR   0x10 BEETLE_TAPE_REW
    .word lab_8a6b          ;fe64  8a 6b       VECTOR   0x11 BEETLE_TAPE_FF
    .word lab_8a90          ;fe66  8a 90       VECTOR   0x12 Tape Side
    .word sub_893c          ;fe68  89 3c       VECTOR   0x13 Seek Up
    .word lab_8b52          ;fe6a  8b 52       VECTOR   0x14 Mix/Dolby
    .word lab_8b52          ;fe6c  8b 52       VECTOR   0x15 BEETLE_DOLBY
    .word lab_8a0d          ;fe6e  8a 0d       VECTOR   0x16 Scan
    .word sub_893c          ;fe70  89 3c       VECTOR   0x17 Seek Down
    .word lab_8bfe          ;fe72  8b fe       VECTOR   0x18 no code
    .word lab_8bfc          ;fe74  8b fc       VECTOR   0x19 initial
    .word lab_8c76          ;fe76  8c 76       VECTOR   0x1a ?
    .word lab_8c76          ;fe78  8c 76       VECTOR   0x1b ?
    .word lab_8b52          ;fe7a  8b 52       VECTOR   0x1c MFSW:41E850AF VOL DOWN
    .word lab_8b52          ;fe7c  8b 52       VECTOR   0x1d MFSW:41E8807F VOL UP
    .word lab_8c61          ;fe7e  8c 61       VECTOR   0x1e MFSW:41E850AF DOWN
    .word lab_8c61          ;fe80  8c 61       VECTOR   0x1f MFSW:41E8D02F UP
    .word lab_8c76          ;fe82  8c 76       VECTOR   0x20 no key?

mem_fe84:
    .word 0x01a6
    .word 0x01a7
    .word 0x01a8
    .word 0x01a9
    .word 0x01aa
    .word 0x01ab

mem_fe90:
    .word 0x01ad
    .word 0x01ae
    .word 0x01af
    .word 0x01b0
    .word 0x01b1
    .word 0x01b2

mem_fe9c:
    .word 0x01b4
    .word 0x01b5
    .word 0x01b6
    .word 0x01b7
    .word 0x01b8
    .word 0x01b9

mem_fea8:
    .byte 0x00              ;fea8  00          DATA '\x00'
    .byte 0x0D              ;fea9  0d          DATA '\r'
    .byte 0x0F              ;feaa  0f          DATA '\x0f'
    .byte 0x11              ;feab  11          DATA '\x11'
    .byte 0x13              ;feac  13          DATA '\x13'
    .byte 0x15              ;fead  15          DATA '\x15'
    .byte 0x17              ;feae  17          DATA '\x17'
    .byte 0x19              ;feaf  19          DATA '\x19'
    .byte 0x1B              ;feb0  1b          DATA '\x1b'
    .byte 0x1D              ;feb1  1d          DATA '\x1d'
    .byte 0x1F              ;feb2  1f          DATA '\x1f'
    .byte 0x21              ;feb3  21          DATA '!'
    .byte 0x23              ;feb4  23          DATA '#'
    .byte 0x25              ;feb5  25          DATA '%'
    .byte 0x27              ;feb6  27          DATA "'"
    .byte 0x29              ;feb7  29          DATA ')'
    .byte 0x2B              ;feb8  2b          DATA '+'
    .byte 0x2D              ;feb9  2d          DATA '-'
    .byte 0x2F              ;feba  2f          DATA '/'
    .byte 0x31              ;febb  31          DATA '1'
    .byte 0x33              ;febc  33          DATA '3'
    .byte 0x35              ;febd  35          DATA '5'
    .byte 0x37              ;febe  37          DATA '7'
    .byte 0x39              ;febf  39          DATA '9'
    .byte 0x3B              ;fec0  3b          DATA ';'
    .byte 0x3D              ;fec1  3d          DATA '='
    .byte 0x3F              ;fec2  3f          DATA '?'
    .byte 0x41              ;fec3  41          DATA 'A'
    .byte 0x43              ;fec4  43          DATA 'C'
    .byte 0x45              ;fec5  45          DATA 'E'
    .byte 0x47              ;fec6  47          DATA 'G'
    .byte 0x49              ;fec7  49          DATA 'I'
    .byte 0x4A              ;fec8  4a          DATA 'J'
    .byte 0x4B              ;fec9  4b          DATA 'K'
    .byte 0x4C              ;feca  4c          DATA 'L'
    .byte 0x4D              ;fecb  4d          DATA 'M'
    .byte 0x4E              ;fecc  4e          DATA 'N'
    .byte 0x4F              ;fecd  4f          DATA 'O'
    .byte 0x50              ;fece  50          DATA 'P'
    .byte 0x51              ;fecf  51          DATA 'Q'
    .byte 0x52              ;fed0  52          DATA 'R'
    .byte 0x53              ;fed1  53          DATA 'S'
    .byte 0x54              ;fed2  54          DATA 'T'
    .byte 0x55              ;fed3  55          DATA 'U'
    .byte 0x56              ;fed4  56          DATA 'V'
    .byte 0x57              ;fed5  57          DATA 'W'

mem_fed6:
    .byte 0x0F              ;fed6  0f          DATA '\x0f'
    .byte 0x0F              ;fed7  0f          DATA '\x0f'
    .byte 0x0D              ;fed8  0d          DATA '\r'
    .byte 0x0B              ;fed9  0b          DATA '\x0b'
    .byte 0x0A              ;feda  0a          DATA '\n'
    .byte 0x09              ;fedb  09          DATA '\t'
    .byte 0x08              ;fedc  08          DATA '\x08'
    .byte 0x06              ;fedd  06          DATA '\x06'
    .byte 0x04              ;fede  04          DATA '\x04'
    .byte 0x03              ;fedf  03          DATA '\x03'
    .byte 0x00              ;fee0  00          DATA '\x00'

mem_fee1:
    .byte 0x00              ;fee1  00          DATA '\x00'
    .byte 0x00              ;fee2  00          DATA '\x00'
    .byte 0x01              ;fee3  01          DATA '\x01'
    .byte 0x02              ;fee4  02          DATA '\x02'
    .byte 0x04              ;fee5  04          DATA '\x04'
    .byte 0x06              ;fee6  06          DATA '\x06'
    .byte 0x08              ;fee7  08          DATA '\x08'
    .byte 0x0A              ;fee8  0a          DATA '\n'
    .byte 0x0C              ;fee9  0c          DATA '\x0c'
    .byte 0x0E              ;feea  0e          DATA '\x0e'
    .byte 0x10              ;feeb  10          DATA '\x10'

kw_asc_1c0035180e:
;Response to initial connection and recoding
    .byte 0x0F              ;feec  0f          DATA '\x0f'  Block length
    .byte 0x00              ;feed  00          DATA '\x00'  Block counter
    .byte 0xF6              ;feee  f6          DATA '\xf6'  Block title (0xF6 = ASCII Data/ID code response)
    .byte 0x31              ;feef  31          DATA '1'
    .byte 0x43              ;fef0  43          DATA 'C'
    .byte 0x30              ;fef1  30          DATA '0'
    .byte 0x30              ;fef2  30          DATA '0'
    .byte 0x33              ;fef3  33          DATA '3'
    .byte 0x35              ;fef4  35          DATA '5'
    .byte 0x31              ;fef5  31          DATA '1'
    .byte 0x38              ;fef6  38          DATA '8'
    .byte 0x30              ;fef7  30          DATA '0'
    .byte 0x45              ;fef8  45          DATA 'E'
    .byte 0x20              ;fef9  20          DATA ' '
    .byte 0x20              ;fefa  20          DATA ' '
    .byte 0x03              ;fefb  03          DATA '\x03'  Block end

kw_asc_1j0035180d:
;Response to initial connection and recoding
    .byte 0x0F              ;fefc  0f          DATA '\x0f'  Block length
    .byte 0x00              ;fefd  00          DATA '\x00'  Block counter
    .byte 0xF6              ;fefe  f6          DATA '\xf6'  Block title (0xF6 = ASCII Data/ID code response)
    .byte 0x31              ;feff  31          DATA '1'
    .byte 0x4A              ;ff00  4a          DATA 'J'
    .byte 0x30              ;ff01  30          DATA '0'
    .byte 0x30              ;ff02  30          DATA '0'
    .byte 0x33              ;ff03  33          DATA '3'
    .byte 0x35              ;ff04  35          DATA '5'
    .byte 0x31              ;ff05  31          DATA '1'
    .byte 0x38              ;ff06  38          DATA '8'
    .byte 0x30              ;ff07  30          DATA '0'
    .byte 0x44              ;ff08  44          DATA 'D'
    .byte 0x20              ;ff09  20          DATA ' '
    .byte 0x20              ;ff0a  20          DATA ' '
    .byte 0x03              ;ff0b  03          DATA '\x03'  Block end

kw_asc_1j0035180:
;Response to initial connection and recoding
    .byte 0x0F              ;ff0c  0f          DATA '\x0f'  Block length
    .byte 0x00              ;ff0d  00          DATA '\x00'  Block counter
    .byte 0xF6              ;ff0e  f6          DATA '\xf6'  Block title (0xF6 = ASCII Data/ID code response)
    .byte 0x31              ;ff0f  31          DATA '1'
    .byte 0x4A              ;ff10  4a          DATA 'J'
    .byte 0x30              ;ff11  30          DATA '0'
    .byte 0x30              ;ff12  30          DATA '0'
    .byte 0x33              ;ff13  33          DATA '3'
    .byte 0x35              ;ff14  35          DATA '5'
    .byte 0x31              ;ff15  31          DATA '1'
    .byte 0x38              ;ff16  38          DATA '8'
    .byte 0x30              ;ff17  30          DATA '0'
    .byte 0x20              ;ff18  20          DATA ' '
    .byte 0x20              ;ff19  20          DATA ' '
    .byte 0x20              ;ff1a  20          DATA ' '
    .byte 0x03              ;ff1b  03          DATA '\x03'  Block end

kw_asc_radio_3cp:
;Response to initial connection and recoding
    .byte 0x0F              ;ff1c  0f          DATA '\x0f'  Block length
    .byte 0x00              ;ff1d  00          DATA '\x00'  Block counter
    .byte 0xF6              ;ff1e  f6          DATA '\xf6'  Block title (0xF6 = ASCII Data/ID code response)
    .byte 0x20              ;ff1f  20          DATA ' '
    .byte 0x52              ;ff20  52          DATA 'R'
    .byte 0x41              ;ff21  41          DATA 'A'
    .byte 0x44              ;ff22  44          DATA 'D'
    .byte 0x49              ;ff23  49          DATA 'I'
    .byte 0x4F              ;ff24  4f          DATA 'O'
    .byte 0x20              ;ff25  20          DATA ' '
    .byte 0x33              ;ff26  33          DATA '3'
    .byte 0x43              ;ff27  43          DATA 'C'
    .byte 0x50              ;ff28  50          DATA 'P'
    .byte 0x20              ;ff29  20          DATA ' '
    .byte 0x20              ;ff2a  20          DATA ' '
    .byte 0x03              ;ff2b  03          DATA '\x03'  Block end

kw_asc_0001:
;Response to initial connection and recoding
    .byte 0x0E              ;ff2c  0e          DATA '\x0e'  Block length
    .byte 0x00              ;ff2d  00          DATA '\x00'  Block counter
    .byte 0xF6              ;ff2e  f6          DATA '\xf6'  Block title (0xF6 = ASCII Data/ID code response)
    .byte 0x20              ;ff2f  20          DATA ' '
    .byte 0x20              ;ff30  20          DATA ' '
    .byte 0x20              ;ff31  20          DATA ' '
    .byte 0x20              ;ff32  20          DATA ' '
    .byte 0x20              ;ff33  20          DATA ' '
    .byte 0x20              ;ff34  20          DATA ' '
    .byte 0x20              ;ff35  20          DATA ' '
    .byte 0x30              ;ff36  30          DATA '0'
    .byte 0x30              ;ff37  30          DATA '0'
    .byte 0x30              ;ff38  30          DATA '0'
    .byte 0x31              ;ff39  31          DATA '1'
    .byte 0x03              ;ff3a  03          DATA '\x03'  Block end

kw_no_ack:
    .byte 0x04              ;ff3b  04          DATA '\x04'  Block length
    .byte 0x00              ;ff3c  00          DATA '\x00'  Block counter
    .byte 0x0A              ;ff3d  0a          DATA '\n'    Block title (0x0A = No Acknowledge)
    .byte 0x00              ;ff3e  00          DATA '\x00'
    .byte 0x03              ;ff3f  03          DATA '\x03'  Block end

kw_ack:
    .byte 0x03              ;ff40  03          DATA '\x03'  Block length
    .byte 0x00              ;ff41  00          DATA '\x00'  Block counter
    .byte 0x09              ;ff42  09          DATA '\t'    Block title (0x09 = Acknowledge)
    .byte 0x03              ;ff43  03          DATA '\x03'  Block end

kw_faults_none:
;Response to Read Faults or Clear Faults
    .byte 0x06              ;ff44  06          DATA '\x06'  Block length
    .byte 0x00              ;ff45  00          DATA '\x00'  Block counter
    .byte 0xFC              ;ff46  fc          DATA '\xfc'  Block title (0xFC = Response to get fault codes)
    .byte 0xFF              ;ff47  ff          DATA '\xff'  Fault code high byte    \
    .byte 0xFF              ;ff48  ff          DATA '\xff'  Fault code low byte      | [0xFF, 0xFF, 0x88] means no faults
    .byte 0x88              ;ff49  88          DATA '\x88'  Fault code status byte  /
    .byte 0x03              ;ff4a  03          DATA '\x03'  Block end

kw_actuator_1:
;Response to Actuator/Output Tests: Speakers
    .byte 0x05              ;ff4b  05          DATA '\x05'  Block length
    .byte 0x00              ;ff4c  00          DATA '\x00'  Block counter
    .byte 0xF5              ;ff4d  f5          DATA '\xf5'  Block title (0xF5 = Response to actuator test)
    .byte 0x03              ;ff4e  03          DATA '\x03'
    .byte 0x53              ;ff4f  53          DATA 'S'
    .byte 0x03              ;ff50  03          DATA '\x03'  Block end

kw_actuator_2:
;Response to Actuator/Output Tests: External Display
    .byte 0x05              ;ff51  05          DATA '\x05'  Block length
    .byte 0x00              ;ff52  00          DATA '\x00'  Block counter
    .byte 0xF5              ;ff53  f5          DATA '\xf5'  Block title (0xF5 = Response to actuator test)
    .byte 0x03              ;ff54  03          DATA '\x03'
    .byte 0x56              ;ff55  56          DATA 'V'
    .byte 0x03              ;ff56  03          DATA '\x03'  Block end

kw_actuator_3:
;Response to Actuator/Output Tests: End of Tests
    .byte 0x05              ;ff57  05          DATA '\x05'  Block length
    .byte 0x00              ;ff58  00          DATA '\x00'  Block counter
    .byte 0xF5              ;ff59  f5          DATA '\xf5'  Block title (0xF5 = Response to actuator test)
    .byte 0x04              ;ff5a  04          DATA '\x04'
    .byte 0xAB              ;ff5b  ab          DATA '\xab'
    .byte 0x03              ;ff5c  03          DATA '\x03'  Block end

kw_rw_safe:
;Response to Read or write SAFE code word
    .byte 0x05              ;ff5d  05          DATA '\x05'  Block length
    .byte 0x00              ;ff5e  00          DATA '\x00'  Block counter
    .byte 0xF0              ;ff5f  f0          DATA '\xf0'  Block title (0xF0 = Response to R/W SAFE code word)
    .byte 0x00              ;ff60  00          DATA '\x00'
    .byte 0x00              ;ff61  00          DATA '\x00'
    .byte 0x03              ;ff62  03          DATA '\x03'  Block end

bin_bcd_table:
;Table used by bin16_to_bcd16
    .byte 0x01, 0x02, 0x04, 0x08, 0x16, 0x32, 0x64, 0x28, 0x56, 0x12, 0x24
    .byte 0x48, 0x96, 0x92, 0x84, 0x68

    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x05, 0x10
    .byte 0x20, 0x40, 0x81, 0x63, 0x27

    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x00, 0x00, 0x00, 0x01, 0x03

filler:
;Unused space at the end of the ROM
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

    .word 0x0000            ;ffc0  00 00       VECTOR callv #0
    .word callv1_eed4       ;ffc2  ee d4       VECTOR callv #1
    .word callv2_eedb       ;ffc4  ee db       VECTOR callv #2
    .word callv3_eeeb       ;ffc6  ee eb       VECTOR callv #3
    .word callv4_8c84       ;ffc8  8c 84       VECTOR callv #4
    .word callv5_8d0d       ;ffca  8d 0d       VECTOR callv #5
    .word callv6_cb98       ;ffcc  cb 98       VECTOR callv #6
    .word callv7_e55c       ;ffce  e5 5c       VECTOR callv #7
    .word 0xf0e1            ;ffd0  f0 e1       VECTOR irq15 (unused)
    .word 0xd2c3            ;ffd2  d2 c3       VECTOR irq14 (unused)
    .word 0xb4a5            ;ffd4  b4 a5       VECTOR irq13 (unused)
    .word 0x9687            ;ffd6  96 87       VECTOR irq12 (unused)
    .word 0x7869            ;ffd8  78 69       VECTOR irq11 (unused)
    .word 0x5a4b            ;ffda  5a 4b       VECTOR irq10 (unused)
    .word 0x3c2d            ;ffdc  3c 2d       VECTOR irqf (unused)
    .word 0x1e0f            ;ffde  1e 0f       VECTOR irqe (unused)
    .word 0x07f8            ;ffe0  07 f8       VECTOR irqd (unused)
    .word 0x0000            ;ffe2  00 00       VECTOR irqc (unused)
    .word reset_8010        ;ffe4  80 10       VECTOR irqb (timebase timer)
    .word reset_8010        ;ffe6  80 10       VECTOR irqa (a/d converter)
    .word reset_8010        ;ffe8  80 10       VECTOR irq9 (8/16-bit updown counter)
    .word irq8_810b         ;ffea  81 0b       VECTOR irq8 (uart)
    .word irq7_8120         ;ffec  81 20       VECTOR irq7 (8-bit serial i/o)
    .word irq6_80fa         ;ffee  80 fa       VECTOR irq6 (8-bit pwm timer #3 (#4, #5, #6))
    .word irq5_80d7         ;fff0  80 d7       VECTOR irq5 (2ch 8-bit pwm timer)
    .word reset_8010        ;fff2  80 10       VECTOR irq4 (unused)
    .word reset_8010        ;fff4  80 10       VECTOR irq3 (8/16 bit timer #1, #2)
    .word irq2_80be         ;fff6  80 be       VECTOR irq2 (16-bit timer counter)
    .word irq1_809e         ;fff8  80 9e       VECTOR irq1 (external interrupt 2)
    .word irq0_806d         ;fffa  80 6d       VECTOR irq0 (external interrupt 1)
    .byte 0xFF              ;fffc  ff          RESERVED
    .byte 0x00              ;fffd  00          MODE
    .word reset_8010        ;fffe  80 10       VECTOR reset
