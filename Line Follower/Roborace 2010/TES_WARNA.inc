
	.DEF _sensor=R4
_36:
	.DB  0x80,0xC0
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9
_tbl10_G3:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G3:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
_230:
	.DW  0x00
_0:
	.DB  0x20,0x53,0x45,0x4C,0x41,0x4D,0x41,0x54
	.DB  0x20,0x44,0x41,0x54,0x41,0x4E,0x47,0x20
	.DB  0x0,0x20,0x44,0x49,0x4D,0x41,0x4E,0x41
	.DB  0x20,0x41,0x4A,0x41,0x20,0x4B,0x45,0x4B
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x4D,0x45
	.DB  0x52,0x41,0x48,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x4B,0x55
	.DB  0x4E,0x49,0x4E,0x47,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x48,0x49
	.DB  0x4A,0x41,0x55,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x43,0x59
	.DB  0x41,0x4E,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x42,0x49
	.DB  0x52,0x55,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x25,0x64,0x20,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G2
	.DW  _36*2

	.DW  0x02
	.DW  _p_S59
	.DW  _230*2

	.DW  0
_0xF1:
