#ifndef _MOTOR_INCLUDED_
#define _MOTOR_INCLUDED_

#define PWM_R OCR1A
#define CS0_R PORTD.6
#define CS1_R PORTD.7

#define CW        1
#define CCW       2 

#pragma used+

void motor_set();
void motor(unsigned char dir, unsigned int speed);
 
#pragma used-
#endif

