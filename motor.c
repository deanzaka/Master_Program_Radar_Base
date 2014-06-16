#include <mega16.h>
#include <delay.h>
#include "motor.h"
void motor_set()
{
 
PORTD.2 = 0;
PORTD.3 = 0;
PORTD.4 = 0;
PORTD.5 = 0;
PORTD.6 = 0;
PORTD.7 = 0;

DDRD.2 = 1;
DDRD.3 = 1;
DDRD.4 = 1;
DDRD.5 = 1;
DDRD.6 = 1;
DDRD.7 = 1;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 10.800 kHz
// Mode: Fast PWM top=00FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
}

void motor(unsigned char dir, unsigned int speed)
{
     
     if(dir == CW)
     {
          CS0_R=0;
          CS1_R=1;
          
     }
     else if(dir == CCW)
     {
          CS0_R=1;
          CS1_R=0;
     }
     else
     {
          CS0_R=1;
          CS1_R=1;   
     }   
     
     PWM_R = speed;  
}  
 