#include <mega16.h>
#include <delay.h>
#include "button.h"

void button_set()
{
     PORTB.0 = 1;
     DDRB.0 = 0;

     PORTB.1 = 1;
     DDRB.1 = 0;
     
     PORTB.2 = 1;
     DDRB.2 = 0;
     
     PORTB.3 = 1;
     DDRB.3 = 0;
}   

unsigned char button(unsigned char a)
{
     if(a == push_1)
     {
          return !PINB.0;
     } 
     if(a == push_2)
     {    
          return !PINB.1;
     }
     if(a == push_3)
     {    
          return !PINB.2;
     }
     if(a == push_4)
     {
          return !PINB.3;
     }
}          