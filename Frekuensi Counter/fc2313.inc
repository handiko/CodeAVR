
_10:
	.DB  0x80,0xC0
	.DEF __lcd_x=R3
	.DEF __lcd_y=R2
	.DEF __lcd_maxx=R5

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G2
	.DW  _10*2

	.DW  0
_0x14:
