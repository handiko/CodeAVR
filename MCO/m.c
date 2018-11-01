/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Microcontroller Controlled Oscillator
Version : 
Date    : 12/12/2011
Author  : Handiko Gesang Anugrah S.
Company : LPKTA 11
Comments: 

time_base_freq = 10 MHz

T = 100ns

time_buff       = 10 MHZ / 10000
                = 1 kHz  --> 1ms

time_count

Chip type               : ATmega8535
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#include <mega8535.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>

#define f_up    PINB.0
#define f_down  PINB.1
#define f_set   PINB.2

long error;
long freq_buff;
long freq;
unsigned long time_buff;
char lcd[32];
eeprom long last_freq = 7128;
eeprom long freq_set = 7128;
eeprom int DAC_set = 128;

void ready_to_set();
void init_ports();
void init_ext_interrupt();
void init_lcd();
void set_enable_interrupt();
void clear_interrupt();
void atur_vco();

interrupt [EXT_INT0] void ext_int0_isr(void)
{       freq_buff++;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{       time_buff++;
        if((time_buff%10000) == 0)
        {       freq = freq_buff;
                freq_buff = 0;
                last_freq = freq;
        }     
        
        if(time_buff == 1000000)
        {       time_buff = 0;
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Freq : ");
                lcd_gotoxy(0,1);
                sprintf(lcd, " %l", freq);
                lcd_puts(lcd);
        }
}

void ready_to_set()
{       clear_interrupt();
        
        for(;;)
        {       if(!f_up)
                {       delay_ms(250);
                        if(freq_set == 0)
                        {       freq_set = last_freq + 1000;
                        }
                        else
                        {       freq_set += 1000;
                        }
                } 

                if(!f_down)
                {       delay_ms(250);
                        if(freq_set == 0)
                        {       freq_set = last_freq - 1000;
                        }
                        else
                        {       freq_set -= 1000;
                        }
                } 

                if(!f_set)
                {       delay_ms(250);
                        break;
                }

                lcd_gotoxy(0,0);
                sprintf(lcd, "  %l ", freq_set);
                lcd_puts(lcd);  
              
        }
        
        set_enable_interrupt();
}

void atur_vco()
{       delay_us(100);
        error = last_freq - freq_set; 
        
        if((error > 0) && (error<=10))
        {       DAC_set -= 1;                
        }
        if((error > 10) && (error<=20))
        {       DAC_set -= 5; 
        }
        if(error > 20)
        {       DAC_set -= 10; 
        }  
        
        if((error < 0) && (error>= -10))
        {       DAC_set += 1;                 
        }
        if((error < -10) && (error>= -20))
        {       DAC_set += 5; 
        }
        if(error > -20)
        {       DAC_set += 10; 
        } 
        
        PORTD = DAC_set;
}

void init_ports()
{       PORTA=0x00;
        DDRA=0xFF;
 
        PORTB=0xFF;
        DDRB=0x00;

        PORTC=0x00;
        DDRC=0xFF;

        PORTD=0xFF;
        DDRD=0x00;
}

void init_ext_interrupt()
{       // External Interrupt(s) initialization
        // INT0: On
        // INT0 Mode: Rising Edge
        // INT1: On
        // INT1 Mode: Rising Edge
        // INT2: Off
        GICR|=0xC0;
        MCUCR=0x0F;
        MCUCSR=0x00;
        GIFR=0xC0;
}

void init_lcd()
{       // Alphanumeric LCD initialization
        // Connections specified in the
        // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
        // RS - PORTA Bit 0
        // RD - PORTA Bit 1
        // EN - PORTA Bit 2
        // D4 - PORTA Bit 4
        // D5 - PORTA Bit 5
        // D6 - PORTA Bit 6
        // D7 - PORTA Bit 7
        // Characters/line: 16
        lcd_init(16);
}

void set_enable_interrupt()
{       freq_buff = 0; 
        time_buff = 0;
        #asm("sei")
}

void clear_interrupt()
{       #asm("cli")
}

void main(void)
{       init_ports();
        init_ext_interrupt(); 
        init_lcd();

        ACSR=0x80;
        SFIOR=0x00;

        set_enable_interrupt();
        
        while (1)
        { 
                atur_vco();
                if(!f_set)
                {
                        delay_ms(250);
                        ready_to_set();
                }
        }
}
