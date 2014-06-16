/****************************************************************

@author : saripudin
@ver    : 30 Jan 2011
@desc   : AV01

****************************************************************/

/* HEADER */
#include "av01.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include "motor.h"
#include "lcd.h"
#include "bumper.h"
#include "remote.h"
#include "buzzer.h"
#include "sensor.h"

mulai()
{

/* INISIALISASI */
lcd_set();
motor_set();
bumper_set();
buzzer_set();
remote_set();
sensor_set(PUTIH, 60);

lcd_kalimat("     AV-01");
delay_ms(500);
lcd_hapus();

sensor_baca(ANALOG);

looping()
{
     if(sensor(1) == 1)      //kanan
     {
          motor(100,0);
     }
     else if(sensor(8) == 1)  //kiri
     {
          motor(0,100);
     }
     else
     {
          motor(0,0);
     }
}


/*
buzzer(ON);
delay_ms(100);
buzzer(OFF);
delay_ms(100);
buzzer(ON);
delay_ms(100);
buzzer(OFF);
*/
/*
looping()
{
     motor(100,100);
     delay_ms(1000);

     motor(0,0);
     delay_ms(1000);

     motor(-100,-100);
     delay_ms(1000);

     motor(0,0);
     delay_ms(1000);
}
*/


looping()
{
     if(bumper(RIGHT) == 1)   //kanan
     {
          motor(0,100);
          PORTD.1 = 0;
          delay_ms(500);

          motor(0,-100);
          PORTD.1 = 1;
          delay_ms(500);
          motor(0,0);

     }
     else if(bumper(LEFT) == 1) //kiri
     {
          motor(100,0);
          PORTD.1 = 0;
          delay_ms(500);

          motor(-100,0);
          PORTD.1 = 1;
          delay_ms(500);
          motor(0,0);
     }
}


looping()
{
     lcd_angka(sensor(8));
     lcd_pindahbaris();
     lcd_angka(sensor(1));

     if(sensor(8) == 1)
     {

          motor_kanan(MAJU,50);
     }
     else
     {
          motor_kanan(STOP,0);

     }

     if(sensor(1) == 1)
     {
           motor_kiri(MAJU,50);
     }
     else
     {
          motor_kiri(STOP,0);

     }
     delay_ms(50);
     lcd_hapus();
}


/* PROGRAM UTAMA */
/*repeat(2)
{
     lcd_angka(j);
     j++;
     delay_ms(1000);
}
*/


looping();


}
#include <stdlib.h>
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

void lcd_set()
{
     lcd_init(16);
}

void lcd_kalimat(char flash *str)
{
   char k;
   while (k = *str++)
   lcd_putchar(k);
}
void lcd_angka(int num)
{
     char lcd_buff[15];
     itoa(num, lcd_buff);
     lcd_puts(lcd_buff);
}

void lcd_hapus()
{
     lcd_clear();
}

void lcd_pindahbaris()
{
     lcd_gotoxy(0,1);
}




#include "buzzer.h"

void buzzer_set()
{
     PORTD.1 = 1;
     DDRD.1 = 1;
}

void buzzer(unsigned char kondisi)
{
     if(kondisi == ON)
     {
          PORTD.1 = 0;
     }
     else if(kondisi == OFF)
     {
          PORTD.1 = 1;
     }
}
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
void motor_kiri(unsigned char arah, char kecepatan)
{
     int pwm = (int)kecepatan*180.0/100.0;

     if(arah==MAJU)
     {
          CS0_L=0;
          CS1_L=1;

     }
     else if(arah==MUNDUR)
     {
          CS0_L=1;
          CS1_L=0;
     }
     else
     {
          CS0_L=1;
          CS1_L=1;
     }

     PWM_L = pwm;
}
void motor_kanan(unsigned char arah, char kecepatan)
{
     int pwm = (int)kecepatan*255.0/100.0;

     if(arah == MAJU)
     {
          CS0_R=0;
          CS1_R=1;

     }
     else if(arah == MUNDUR)
     {
          CS0_R=1;
          CS1_R=0;
     }
     else
     {
          CS0_R=1;
          CS1_R=1;
     }

     PWM_R = pwm;
}

void motor(int kecepatan_kiri, int kecepatan_kanan)
{
     if(kecepatan_kanan>0)
     {
          motor_kanan(MAJU,kecepatan_kanan);
     }
     else
     {
          motor_kanan(MUNDUR,-kecepatan_kanan);
     }

     if(kecepatan_kiri>0)
     {
          motor_kiri(MAJU,kecepatan_kiri);
     }
     else
     {
          motor_kiri(MUNDUR,-kecepatan_kiri);
     }

}

void motor_stop()
{
     motor_kanan(STOP,0);
     motor_kiri(STOP,0);

}

#include "sensor.h"

unsigned char tipe_garis, data_adc = 0;

void sensor_set(unsigned char garis, unsigned char batas)
{
     ADMUX=ADC_VREF_TYPE & 0xff;
     ADCSRA=0x86;
     data_adc = batas;
     tipe_garis = garis;
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

void sensor_baca(unsigned char tipe)
{
     unsigned char j = 0;
     char buff[15];
     lcd_clear();
     while(1)
     {
          if(tipe == ANALOG)
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
          else if(tipe == DIGITAL)
          {
               for(j=8;j>0;j--)
               {
                    if(read_adc(j-1)<=data_adc)
                    {
                         if(tipe_garis == PUTIH)
                              lcd_putchar('1');
                         else
                              lcd_putchar('0');
                    }
                    else
                    {
                         if(tipe_garis == PUTIH)
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

/*
uint8_t i=0, bit_sensor=0;
        unsigned int temp;
        for(i=0;i<=7;i++)
        {
                bit_sensor = bit_sensor << 1;
                if(read_adc(i) >= data_adc)
                {
                        //bit_sensor |= (1 << 0);
                        bit_sensor &= ~(1 << 0);
                }
                else
                {
                        //bit_sensor &= ~(1 << 0);
                        bit_sensor |= (1 << 0);
                }
        }
        return bit_sensor;
*/

unsigned char sensor(unsigned char no)
{
     unsigned char logic;
     if(read_adc(no-1) <= data_adc)
     {
           if(tipe_garis == PUTIH)
               logic = 1;
           else
               logic = 0;
     }
     else
     {
           if(tipe_garis == PUTIH)
               logic = 0;
           else
               logic = 1;
     }
     return logic;
}


#include "bumper.h"

void bumper_set()
{
     PORTB.0 = 1;
     DDRB.0 = 0;

PORTB.1 = 1;
DDRB.1 = 0;
}

unsigned char bumper(unsigned char a)
{
     if(a == RIGHT)
     {
          return !PINB.0;
     }
     else if(a == LEFT)
     {
          return !PINB.1;
     }
}
#include "remote.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include "lcd.h"

unsigned char code, address;

// Declare your global variables here
unsigned int read_IR(void)
{
    unsigned char pulseCount=0,  code = 0, address = 0, timerCount;
    unsigned int IR_input;

	 // Jika data 1:1.2 ms    ____
     //            0:0.6 ms  _|    |_

	// 0...6 command
     while(pulseCount < 7)
	{
	   //jika OUT high menunggu, break apabila OUT low
	   while(PINB & 0x04);
	   TCNT0 = 0;

	   //menunggu OUT LOW
	   while(!(PINB & 0x04));
	   pulseCount++;

	   timerCount = TCNT0;

	   if(timerCount > 50)
	      code = code | (1 << (pulseCount-1));
	   else
	 	 code = code & ~(1 << (pulseCount-1));
	 }

	 // 0...4 address
	 pulseCount = 0;
	 while(pulseCount < 5)
	 {
	     while(PINB & 0x04);
	     TCNT0 = 0;

	     while(!(PINB & 0x04));
	     pulseCount++;

	     timerCount = TCNT0;

	     if(timerCount > 50)
	          address = address | (1 << (pulseCount-1));
	     else
	 	     address = address & ~(1 << (pulseCount-1));
	 }

	 IR_input = (((unsigned int)code) << 8) | address;

	 return(IR_input);
}

interrupt [EXT_INT2] void ext_int2_isr(void)
{
     char lcd[16];
     unsigned char count;
	unsigned int IR_input;

	TCNT0 = 0;

	//menunggu delay selama 2.4 ms
	while(!(PINB & 0x04));
	count = TCNT0;

	if(count < 83) 		  //to verify start pulse (2.4 ms long)
	{                          //jika tidak maka interrupt lagi
	     delay_ms(20);
	     ENABLE_INT0;
	     return;
	}

	//jika data diterima
	IR_input = read_IR ();

	code = (unsigned char) ((IR_input & 0xff00) >> 8);
	address = (unsigned char) (IR_input & 0x00ff);

     //lcd_clear();
     //itoa(code,lcd);
     //lcd_puts(lcd);

	//keluarkan data
	delay_ms(100);

}


void remote_set()
{
     PINB.2 = 0;
     DDRB.2 = 0;

     // Timer/Counter 0 initialization
     // Clock source: System Clock
     // Clock value: 43.200 kHz
     // Mode: Normal top=FFh
     // OC0 output: Disconnected
     TCCR0=0x04;
     TCNT0=0x00;
     OCR0=0x00;

     // External Interrupt(s) initialization
     // INT0: Off
     // INT1: Off
     // INT2: On
     // INT2 Mode: Falling Edge
     GICR|=0x20;
     MCUCR=0x00;
     MCUCSR=0x00;
     GIFR=0x20;

     #asm("sei")

}

unsigned char remote_baca()
{
     return code;
}
