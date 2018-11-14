
	.DEF _fcshi=R5
	.DEF _fcslo=R4
	.DEF _rx_wr_index=R7
	.DEF _rx_rd_index=R6
	.DEF _rx_counter=R9
	.DEF _tx_wr_index=R8
	.DEF _tx_rd_index=R11
	.DEF _tx_counter=R10
	.DEF _count_1=R13
_20:
	.DB  0xB0,0x4

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _tone
	.DW  _20*2

	.DW  0
_0x41:
