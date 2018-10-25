
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _i=R10
	.DEF _j=R12
_50:
	.DB  0x80,0xC0
_0:
	.DB  0x53,0x65,0x72,0x69,0x61,0x6C,0x20,0x57
	.DB  0x69,0x74,0x68,0x20,0x41,0x20,0x42,0x61
	.DB  0x75,0x64,0x20,0x44,0x61,0x74,0x61,0x20
	.DB  0x52,0x61,0x74,0x65,0x20,0x4F,0x66,0x20
	.DB  0x34,0x2C,0x38,0x30,0x30,0x62,0x70,0x73
	.DB  0x2E,0x20,0x20,0x4E,0x6F,0x74,0x65,0x20
	.DB  0x41,0x20,0x55,0x53,0x42,0x20,0x49,0x6E
	.DB  0x74,0x65,0x72,0x66,0x61,0x63,0x65,0x20
	.DB  0x50,0x6F,0x72,0x74,0x20,0x43,0x61,0x6E
	.DB  0x6E,0x6F,0x74,0x20,0x53,0x75,0x70,0x70
	.DB  0x6F,0x72,0x74,0x20,0x54,0x68,0x69,0x73
	.DB  0x20,0x53,0x74,0x61,0x6E,0x64,0x61,0x72
	.DB  0x64,0x21,0x20,0x20,0x49,0x66,0x20,0x47
	.DB  0x50,0x53,0x2D,0x45,0x6E,0x61,0x62,0x6C
	.DB  0x65,0x64,0x20,0x4D,0x61,0x70,0x70,0x69
	.DB  0x6E,0x67,0x20,0x50,0x72,0x6F,0x67,0x72
	.DB  0x61,0x6D,0x73,0x20,0x41,0x72,0x65,0x20
	.DB  0x54,0x6F,0x20,0x42,0x65,0x20,0x55,0x73
	.DB  0x65,0x64,0x2C,0x20,0x54,0x68,0x65,0x20
	.DB  0x42,0x65,0x73,0x74,0x20,0x43,0x68,0x6F
	.DB  0x69,0x63,0x65,0x20,0x49,0x73,0x20,0x54
	.DB  0x6F,0x20,0x4F,0x62,0x74,0x61,0x69,0x6E
	.DB  0x20,0x41,0x20,0x53,0x65,0x72,0x69,0x61
	.DB  0x6C,0x20,0x49,0x6E,0x74,0x65,0x72,0x66
	.DB  0x61,0x63,0x65,0x64,0x20,0x47,0x50,0x53
	.DB  0x20,0x53,0x79,0x73,0x74,0x65,0x6D,0x2E
	.DB  0x20,0x20,0x41,0x20,0x47,0x50,0x53,0x20
	.DB  0x53,0x79,0x73,0x74,0x65,0x6D,0x20,0x57
	.DB  0x69,0x74,0x68,0x20,0x41,0x20,0x53,0x65
	.DB  0x72,0x69,0x61,0x6C,0x20,0x50,0x6F,0x72
	.DB  0x74,0x20,0x41,0x6E,0x64,0x20,0x4E,0x4D
	.DB  0x45,0x41,0x20,0x53,0x75,0x70,0x70,0x6F
	.DB  0x72,0x74,0x20,0x57,0x69,0x6C,0x6C,0x20
	.DB  0x50,0x72,0x6F,0x76,0x69,0x64,0x65,0x20
	.DB  0x54,0x68,0x65,0x20,0x4D,0x6F,0x73,0x74
	.DB  0x20,0x55,0x6E,0x69,0x76,0x65,0x72,0x73
	.DB  0x61,0x6C,0x6C,0x79,0x20,0x41,0x63,0x63
	.DB  0x65,0x70,0x74,0x61,0x62,0x6C,0x65,0x20
	.DB  0x53,0x79,0x73,0x74,0x65,0x6D,0x2E,0x20
	.DB  0x20,0x4F,0x75,0x74,0x20,0x4F,0x66,0x20
	.DB  0x41,0x6C,0x6C,0x20,0x54,0x68,0x65,0x20
	.DB  0x4D,0x61,0x6E,0x75,0x66,0x61,0x63,0x74
	.DB  0x75,0x72,0x65,0x73,0x20,0x41,0x6E,0x64
	.DB  0x20,0x42,0x72,0x61,0x6E,0x64,0x20,0x4D
	.DB  0x61,0x72,0x6B,0x65,0x74,0x65,0x64,0x20
	.DB  0x50,0x72,0x6F,0x64,0x75,0x63,0x74,0x73
	.DB  0x2C,0x0,0x6D,0x65,0x6E,0x67,0x69,0x72
	.DB  0x69,0x6D,0x20,0x70,0x65,0x73,0x61,0x6E
	.DB  0x2E,0x2E,0x2E,0x0,0x42,0x65,0x72,0x68
	.DB  0x61,0x73,0x69,0x6C,0x20,0x74,0x65,0x72
	.DB  0x6B,0x69,0x72,0x69,0x6D,0x20,0x21,0x0

__GLOBAL_INI_TBL:
	.DW  0x172
	.DW  _kalimat2
	.DW  _0*2

	.DW  0x02
	.DW  __base_y_G2
	.DW  _50*2

	.DW  0
_0x3D: