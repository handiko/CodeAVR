
	.DEF _huruf=R5
	.DEF _rx_wr_index=R4
	.DEF _rx_rd_index=R7
	.DEF _rx_counter=R6
	.DEF _tx_wr_index=R9
	.DEF _tx_rd_index=R8
	.DEF _tx_counter=R11
_24:
	.DB  0x80,0xC0
	.DEF __lcd_x=R10
	.DEF __lcd_y=R13
	.DEF __lcd_maxx=R12
_0:
	.DB  0x46,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G2
	.DW  _24*2

	.DW  0
_0x22:
