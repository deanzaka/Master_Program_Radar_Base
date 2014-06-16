#ifndef _SENSOR_INCLUDED_
#define _SENSOR_INCLUDED_

// ADC setting
#define ADC_VREF_TYPE 0x20

#define ANALOG      1
#define DIGITAL     2 

#define WHITE       1
#define BLACK       2

#pragma used+
unsigned char read_adc(unsigned char adc_input);
void sensor_set(unsigned char color, unsigned char threshold);
void sensor_read(unsigned char type);
unsigned char sensor(unsigned char no);
 
#pragma used-
#endif