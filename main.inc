
	.DEF _i=R5
	.DEF _tipe_garis=R4
	.DEF _data_adc=R7
	.DEF _code=R6
	.DEF _address=R9
_179:
	.DB  0x80,0xC0
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10
_0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x41,0x56,0x2D
	.DB  0x30,0x31,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_GA
	.DW  _179*2

	.DW  0
_0xCE:
