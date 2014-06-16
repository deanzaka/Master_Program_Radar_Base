#ifndef _LCD_INCLUDED_
#define _LCD_INCLUDED_  

#pragma used+
void lcd_set(); 
void lcd_text(char flash *str);
void lcd_number(int num);
void lcd_enter();  
void lcd_reset();
#pragma used-
#endif