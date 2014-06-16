#include <mega16.h>
#include <delay.h>
#include <lcd.h>
#include <stdlib.h>
#include "sensor.h"

unsigned char line_type, data_adc = 0;

void sensor_set(unsigned char color, unsigned char threshold)
{
     ADMUX=ADC_VREF_TYPE & 0xff;
     ADCSRA=0x86;
     data_adc = threshold; 
     line_type = color;
}

unsigned char read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    delay_us(10);
    ADCSRA|=0x40;
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    return ADCH;
}

void sensor_read(unsigned char type)
{
     unsigned char j = 0;
     char buff[15]; 
     lcd_clear();
     while(1)
     {
          if(type == ANALOG)
          {
               for(j=0;j<8;j++)
               {
                    if(j<4)
                         lcd_gotoxy(j*4,0);
                    else
                         lcd_gotoxy((j-4)*4,1);
               itoa(read_adc(j),buff);
               lcd_puts(buff);
               }
          }
          else if(type == DIGITAL)
          { 
               for(j=8;j>0;j--)
               {    
                    if(read_adc(j-1)<=data_adc)
                    {
                         if(line_type == WHITE)
                              lcd_putchar('1');
                         else
                              lcd_putchar('0');
                    }
                    else
                    {
                         if(line_type == WHITE)
                              lcd_putchar('0');
                         else
                              lcd_putchar('1');
                    }
               }
          }
          delay_ms(100);
          lcd_clear();
     }
}  
   

unsigned char sensor(unsigned char no)
{
     unsigned char logic;
     if(read_adc(no-1) <= data_adc)
     { 
           if(line_type == WHITE)
               logic = 1;
           else
               logic = 0;                                                 
     }
     else
     {
           if(line_type == WHITE)
               logic = 0;
           else
               logic = 1; 
     }
     return logic;            
}


