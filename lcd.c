#include <mega16.h>
#include <delay.h>
#include <stdlib.h>
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

void lcd_set()
{    
     lcd_init(16);
}

void lcd_text(char flash *str)
{
   char k;
   while (k = *str++) 
   lcd_putchar(k);
}
  
void lcd_number(int num)
{
     char lcd_buff[15];
     itoa(num, lcd_buff);
     lcd_puts(lcd_buff);
}

void lcd_reset()
{
     lcd_clear();
}

void lcd_enter()
{
     lcd_gotoxy(0,1);
}




