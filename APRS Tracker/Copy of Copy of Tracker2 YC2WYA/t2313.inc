
	.DEF _rx_wr_index=R3
	.DEF _rx_rd_index=R2
	.DEF _rx_counter=R5
_flag:
	.DB  0x7E
_ssid_2:
	.DB  0x64
_ssid_9:
	.DB  0x72
_ssid_2final:
	.DB  0x65
_10:
	.DB  0x41,0x50,0x55,0x32,0x35,0x4D,0x0
_11:
	.DB  0x59,0x44,0x32,0x58,0x42,0x43,0x0
_12:
	.DB  0x57,0x49,0x44,0x45,0x32,0x20,0x0
_control_field:
	.DB  0x3
_protocol_id:
	.DB  0xF0
_data_type:
	.DB  0x21
_symbol_table:
	.DB  0x2F
_symbol_code:
	.DB  0x3E
_comment:
	.DB  0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20
	.DB  0x46,0x4F,0x52,0x20,0x45,0x4D,0x45,0x52
	.DB  0x47,0x45,0x4E,0x43,0x59,0x20,0x42,0x45
	.DB  0x41,0x43,0x4F,0x4E,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20
	.DEF _fcshi=R4
	.DEF _fcslo=R7
	.DEF _count_1=R6
	.DEF _x_counter=R9
_matrix:
	.DB  0x7,0xA,0xD,0xE,0xF,0xE,0xD,0xA
	.DB  0x7,0x5,0x2,0x1,0x0,0x1,0x2,0x5

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _destination
	.DW  _10*2

	.DW  0x07
	.DW  _source
	.DW  _11*2

	.DW  0x07
	.DW  _digi
	.DW  _12*2

	.DW  0
_0x72: