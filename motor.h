#ifndef _MOTOR_INCLUDED_
#define _MOTOR_INCLUDED_

#define PWM_R OCR1B
#define CS0_R PORTD.3
#define CS1_R PORTD.2 
#define PWM_L OCR1A
#define CS0_L PORTD.6
#define CS1_L PORTD.7

#define CW        1
#define CCW       2 

#pragma used+

void motor_set();
void motor(unsigned char dir, unsigned int speed);
 
#pragma used-
#endif