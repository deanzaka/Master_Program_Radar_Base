
#include <mega16.h>
#include <delay.h>

#include "global.h"  
#include "motor.h"
#include "button.h"  
    
start()
{ 

    motor_set();
    button_set();
    

    loop()
    {
  
        if (button(push_4) == 1)
        {
           if(pwm < 254)
           {
                pwm++;
                delay_ms(100);
           } 
        }
        if (button(push_3) == 1)
        {
           if(pwm > 0)
           {
                pwm--;
                delay_ms(100);
           }      
        }
        if (button(push_2) == 1)
        {
           dir = CW;  
        } 
        if (button(push_1) == 1)
        {
           dir = CCW;
        }
        motor(dir,pwm);
    }
} 