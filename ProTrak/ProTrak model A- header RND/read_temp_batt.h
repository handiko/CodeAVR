

#include <mega8.h>
#include <delay.h>

//#define ADC_VREF_TYPE 0x00
//#define VSENSE_ADC_	0
//#define TEMP_ADC_	1

void read_temp(void);
void read_volt(void);

char temp[7]={"020.0C"};
char volt[7]={"013.8V"};

unsigned int read_adc(unsigned char adc_input)
{
	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	delay_us(10);
	ADCSRA|=0x40;
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCW;
}

void read_temp(void)
{
	int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*read_adc(TEMP_ADC_)/1.024);
        //itoa(adc,temp);

        adc_r = (adc/1000);
        adc_p = ((adc%1000)/100);
        adc_s = ((adc%100)/10);
        adc_d = (adc%10);

        if(adc_r==0)temp[0]=' ';
        else temp[0] = adc_r + '0';
        if((adc_p==0)&&(adc_r==0)) temp[1]=' ';
        else temp[1] = adc_p + '0';
        temp[2] = adc_s + '0';
        temp[4] = adc_d + '0';
}

void read_volt(void)
{
	int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*22*read_adc(VSENSE_ADC_))/102.4;
        //itoa(adc,volt);

        adc_r = (adc/1000);
        adc_p = ((adc%1000)/100);
        adc_s = ((adc%100)/10);
        adc_d = (adc%10);

        if(adc_r==0)	volt[0]=' ';
        else volt[0] = adc_r + '0';
        if((adc_p==0)&&(adc_r==0)) volt[1]=' ';
        else volt[1] = adc_p + '0';
        volt[2] = adc_s + '0';
        volt[4] = adc_d + '0';
}