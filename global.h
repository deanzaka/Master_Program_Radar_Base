#ifndef _GLOBAL_INCLUDED_
#define _GLOBAL_INCLUDED_  

#include <mega16.h>   
#include <delay.h>

int pwm = 0;
unsigned char dir;

#define start() void main(void)   
#define repeat(n) for(i=0;i<n;i++)
#define loop() while(1)

#pragma used+
 
#pragma used-
#endif