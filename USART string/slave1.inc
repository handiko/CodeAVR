
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _i=R10
	.DEF _j=R12
_37:
	.DB  0x80,0xC0
_0:
	.DB  0x66,0x69,0x6E,0x69,0x73,0x68,0x20,0x72
	.DB  0x65,0x63,0x65,0x69,0x76,0x69,0x6E,0x67
	.DB  0x0,0x61,0x6C,0x67,0x6F,0x72,0x69,0x74
	.DB  0x68,0x6D,0x20,0x73,0x65,0x6C,0x65,0x73
	.DB  0x61,0x69,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G2
	.DW  _37*2

	.DW  0
_0x30: