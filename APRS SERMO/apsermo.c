/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/31/2013
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <stdint.h>

#define _1200           0
#define _2200           1

#ifdef        _OPTIMIZE_SIZE_
        #define CONST_1200      46
        #define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz
#else
        #define CONST_1200      50
        #define CONST_2200      25
#endif

#define GAP_TIME_       30
#define TX_DELAY_       45
#define FLAG_           0x7E
#define CONTROL_FIELD_  0x03
#define PROTOCOL_ID_    0xF0
#define TD_POSISI_      '!'
#define TD_TELEM_       'T'
#define TELEM_NUM_      '#'
#define SEPARATOR_      ','
#define SYM_TAB_OVL_    '/'
#define SYM_CODE_       'r'
#define TX_TAIL_        15

#include <delay.h>
#include <stdarg.h>

#define PTT     PORTB.7

#define ON      1

void set_nada(char i_nada);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_crc(char in_crc);
void kirim_crc(void);
unsigned char read_adc(unsigned char adc_input);
void read_sensor(void);
void _itoa_(void);

flash unsigned char data_1[21] =
{
        ('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),(' '<<1),
        ('V'<<1),('H'<<1),('O'<<1),('M'<<1),('O'<<1),(' '<<1),(' '<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
};
flash char posisi_lat[8] =
{
        '0','7','4','9','.','4','8','S'
};
flash char posisi_long[9] =
{
        '1','1','0','0','7','.','4','0','E'
};
flash unsigned char def_t[43] =
{      
        ":SERMO    :PARM.Piezo1,Piezo2,W_Lvl,Cahaya"
};
flash unsigned char unit_t[37] = 
{       
        ":SERMO    :UNIT.Volt,Volt,meter,Volt"
};
flash unsigned char eqn_t[62] =
{
        ":SERMO    :EQNS.0,0.019,0,0,0.019,0,0,0.004,0,0,0.019,0,0,1,0"
};
eeprom char beacon_stat = 0;
char xcount = 0;
bit nada = _1200;
static char bit_stuff = 0;
unsigned short crc;

#ifndef        _1200
#error        "KONSTANTA _1200 BELUM TERDEFINISI"
#endif

#ifndef        _2200
#error        "KONSTANTA _2200 BELUM TERDEFINISI"
#endif

#ifndef        CONST_1200
#error        "KONSTANTA CONST_1200 BELUM TERDEFINISI"
#endif

#ifndef        CONST_2200
#error        "KONSTANTA CONST_2200 BELUM TERDEFINISI"
#endif

#ifndef        GAP_TIME_
#error        "KONSTANTA GAP_TIME_ BELUM TERDEFINISI"
#endif

#if        (GAP_TIME_ < 15)
//#error        "GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu singkat menyebabkan kepadatan traffic"
#endif
#if        (GAP_TIME_ > 60)
#error        "GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu panjang menyebabkan 'loose of track'  "
#endif

//        AKHIR DARI KONSTANTA EVALUATOR

eeprom static uint16_t idx = 0;
eeprom static int _idx[3];
eeprom static unsigned char s1 = 0;
eeprom static unsigned char s2 = 0;
eeprom static unsigned char s3 = 0;
eeprom static unsigned char s4 = 0;
eeprom static unsigned char _ch1[3];
eeprom static unsigned char _ch2[3];
eeprom static unsigned char _ch3[3];
eeprom static unsigned char _ch4[3];

void read_sensor(void)
{
        s1 = (s1 + read_adc(0))/2;
        s2 = (s2 + read_adc(1))/2;
        s3 = (s3 + read_adc(2))/2;
        s4 = (s4 + read_adc(3))/2;
        
        idx++;
        if(idx > 255) idx = 0;    
}

void _itoa_(void)
{
        static int rat,pul,sat;
        
        rat = s1 / 100;
        s1 = s1 % 100;
        pul = s1 / 10;
        sat = s1 % 10;
        
        _ch1[0] = rat + '0';
        _ch1[1] = pul + '0';
        _ch1[2] = sat + '0';
        
        rat = s2 / 100;
        s2 = s2 % 100;
        pul = s2 / 10;
        sat = s2 % 10;
        
        _ch2[0] = rat + '0';
        _ch2[1] = pul + '0';
        _ch2[2] = sat + '0';
        
        rat = s3 / 100;
        s3 = s3 % 100;
        pul = s3 / 10;
        sat = s3 % 10;
        
        _ch3[0] = rat + '0';
        _ch3[1] = pul + '0';
        _ch3[2] = sat + '0';
        
        rat = s4 / 100;
        s4 = s4 % 100;
        pul = s4 / 10;
        sat = s4 % 10;
        
        _ch4[0] = rat + '0';
        _ch4[1] = pul + '0';
        _ch4[2] = sat + '0'; 
        
        rat = idx / 100;
        idx = s4 % 100;
        pul = idx / 10;
        sat = idx % 10;
        
        _idx[0] = rat + '0';
        _idx[1] = pul + '0';
        _idx[2] = sat + '0'; 
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
        xcount++;  
        
        read_sensor(); 
        _itoa_();

        if(xcount==1)
        {        
                delay_ms(500);
                kirim_paket();
                xcount = 0;
        }
        
        TCNT1H = 0xAB;
        TCNT1L = 0xA0;

}       // EndOf interrupt [TIM1_OVF] void timer1_ovf_isr(void)


void kirim_paket(void)
{
        char i;      
        
        crc = 0xFFFF;
        beacon_stat++;
        PTT = ON;
        delay_ms(100);
        
        for(i=0;i<TX_DELAY_;i++)        kirim_karakter(FLAG_);

        bit_stuff = 0;

        for(i=0;i<21;i++)               kirim_karakter(data_1[i]);

        kirim_karakter(CONTROL_FIELD_);

        kirim_karakter(PROTOCOL_ID_);

        if(beacon_stat == 20)
        {
                kirim_karakter(TD_POSISI_);

                for(i=0;i<8;i++)        kirim_karakter(posisi_lat[i]);

                kirim_karakter(SYM_TAB_OVL_);

                for(i=0;i<9;i++)        kirim_karakter(posisi_long[i]);

                kirim_karakter(SYM_CODE_); 
        }  
        
        else if(beacon_stat == 21)
                for(i=0;i<43;i++)       kirim_karakter(def_t[i]);
        
        else if(beacon_stat == 22)
                for(i=0;i<62;i++)       kirim_karakter(eqn_t[i]);
        
        else if(beacon_stat == 23)
                for(i=0;i<37;i++)       kirim_karakter(unit_t[i]); 
                
        else if(beacon_stat == 100)
                beacon_stat = 0;
        else 
        {
                        kirim_karakter(TD_TELEM_);
                        kirim_karakter(TELEM_NUM_); 
                for(i=0;i<3;i++)
                        kirim_karakter(_idx[i]); 
                kirim_karakter(SEPARATOR_);
                for(i=0;i<3;i++)
                        kirim_karakter(_ch1[i]); 
                kirim_karakter(SEPARATOR_);
                for(i=0;i<3;i++)
                        kirim_karakter(_ch2[i]); 
                kirim_karakter(SEPARATOR_);
                for(i=0;i<3;i++)
                        kirim_karakter(_ch3[i]); 
                kirim_karakter(SEPARATOR_);
                for(i=0;i<3;i++)
                        kirim_karakter(_ch4[i]);
                kirim_karakter(SEPARATOR_);
                for(i=0;i<3;i++)
                        kirim_karakter('0');   
                kirim_karakter(SEPARATOR_);
                for(i=0;i<8;i++)
                        kirim_karakter('0');

        }

        kirim_crc();

        for(i=0;i<TX_TAIL_;i++)         kirim_karakter(FLAG_);

        delay_ms(50);
        PTT = 0;


}       // EndOf void kirim_paket(void)


/***************************************************************************************/
        void                         kirim_crc(void)
/***************************************************************************************
*        ABSTRAKSI          :         Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
*                                nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
*                                Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
*                                leading one.
*
*        INPUT                :        tak ada
*        OUTPUT                :       tak ada
*        RETURN                :       tak ada
*/
{
        static unsigned char crc_lo;
        static unsigned char crc_hi;

        // Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 LSB
        crc_lo = crc ^ 0xFF;

        // geser kanan 8 bit dan Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 MSB
        crc_hi = (crc >> 8) ^ 0xFF;

        // kirim 8 LSB
        kirim_karakter(crc_lo);

        // kirim 8 MSB
        kirim_karakter(crc_hi);

}       // EndOf void kirim_crc(void)


/***************************************************************************************/
        void                         kirim_karakter(unsigned char input)
/***************************************************************************************
*        ABSTRAKSI          :         mengirim data APRS karakter-demi-karakter, menghitung FCS
*                                field dan melakukan bit stuffing. Polarisasi data adalah
*                                NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
*                                bit terakhir yang ditahan jika bit masukan adalah bit 1.
*                                Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
*                                masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
*                                 merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
*                                tone adalah tidak penting dalam polarisasi data NRZI.
*
*              INPUT                :        byte data protokol APRS
*        OUTPUT                :       tak ada
*        RETURN                :       tak ada
*/
{
        char i;
        bit in_bit;

        // kirimkan setiap byte data (8 bit)
        for(i=0;i<8;i++)
        {
                // ambil 1 bit berurutan dari LSB ke MSB setiap perulangan for 0 - 7
                in_bit = (input >> i) & 0x01;

                // jika data adalah flag, nol-kan pengingat bit stuffing
                if(input==0x7E)        {bit_stuff = 0;}

                // jika bukan flag, hitung nilai CRC dari bit data saat ini
                else                {hitung_crc(in_bit);}

                // jika bit data saat ini adalah
                // nol
                if(!in_bit)
                {        // jika ya
                        // ubah tone dan bentuk gelombang sinus
                        ubah_nada();

                        // nol-kan pengingat bit stuffing
                        bit_stuff = 0;
                }
                // satu
                else
                {        // jika ya
                        // jaga tone dan bentuk gelombang sinus
                        set_nada(nada);

                        // hitung sebagai bit stuffing (bit satu berurut) tambahkan 1 nilai bit stuffing
                        bit_stuff++;

                        // jika sudah terjadi bit satu berurut sebanyak 5 kali
                        if(bit_stuff==5)
                        {
                                // kirim bit nol :
                                // ubah tone dan bentuk gelombang sinus
                                ubah_nada();

                                // nol-kan pengingat bit stuffing
                                bit_stuff = 0;

                        }
                }
        }

}      // EndOf void kirim_karakter(unsigned char input)


/***************************************************************************************/
        void                         hitung_crc(char in_crc)
/***************************************************************************************
*        ABSTRAKSI          :         menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
*                                generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
*                                leading one
*
*              INPUT                :        bit data yang terkirim
*        OUTPUT                :       tak ada
*        RETURN                :       tak ada
*/
{
        static unsigned short xor_in;

        // simpan nilai Exor dari CRC sementara dengan bit data yang baru terkirim
        xor_in = crc ^ in_crc;

        // geser kanan nilai CRC sebanyak 1 bit
        crc >>= 1;

        // jika hasil nilai Exor di-and-kan dengan satu bernilai satu
        if(xor_in & 0x01)
                // maka nilai CRC di-Exor-kan dengan generator polinomial
                crc ^= 0x8408;

}      // EndOf void hitung_crc(char in_crc)


/***************************************************************************************/
        void                         ubah_nada(void)
/***************************************************************************************
*        ABSTRAKSI          :         Menukar seting tone terakhir dengan tone yang baru. Tone
*                                1200Hz dan 2200Hz masing - masing merepresentasikan bit
*                                0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
*                                penting dalam polarisasi data NRZI.
*
*              INPUT                :        tak ada
*        OUTPUT                :       tak ada
*        RETURN                :       tak ada
*/
{
        // jika tone terakhir adalah :
        // 1200Hz
        if(nada ==_1200)
        {        // jika ya
                // ubah tone saat ini menjadi 2200Hz
                nada = _2200;

                // bangkitkan gelombang sinus 2200Hz
                set_nada(nada);
        }
        // 2200Hz
        else
        {        // jika ya
                // ubah tone saat ini menjadi 1200Hz
                nada = _1200;

                // bangkitkan gelombang sinus 1200Hz
                set_nada(nada);
        }

}       // EndOf void ubah_nada(void)



/***************************************************************************************/
        void                         set_nada(char i_nada)
/***************************************************************************************
*        ABSTRAKSI          :         Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
*                                dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
*                                tuning pada jumlah masing - masing perulangan for dan
*                                konstanta waktu untuk meng-adjust parameter baudrate dan
*                                frekuensi tone.
*
*              INPUT                :        nilai frekuensi tone yang akan ditransmisikan
*        OUTPUT                :       nilai DAC
*        RETURN                :       tak ada
*/
{
        char i;

        // jika frekuensi tone yang akan segera dipancarkan adalah :
        // 1200Hz
        if(i_nada == _1200)
        {
                // jika ya
                for(i=0; i<16; i++)
                {
                        PORTD.1 = 1;
                        delay_us(CONST_1200);
                }
        }
        // 2200Hz
        else
        {
                // jika ya
                for(i=0; i<16; i++)
                {
                        PORTD.1 = 0;
                        delay_us(CONST_1200);
                }
        }

}         // EndOf void set_nada(char i_nada)


#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
        ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
        // Delay needed for the stabilization of the ADC input voltage
        delay_us(10);
        // Start the AD conversion
        ADCSRA|=0x40;
        // Wait for the AD conversion to complete
        while ((ADCSRA & 0x10)==0);
        ADCSRA|=0x10;
        return ADCH;
}

// Declare your global variables here

void main(void)
{
        PORTA=0x00;
        DDRA=0x00;

        PORTB=0x00;
        DDRB=0xFF;
 
        PORTC=0x00;
        DDRC=0xFF;
        
        PORTD=0xFF;
        DDRD=0xFF;
        
        // set register Timer 1, System clock 10.8kHz, Timer 1 overflow
	TCCR1B=0x05;

        // set konstanta waktu 5 detik sebagai awalan
        //timer_detik(INITIAL_TIME_C); 
        TCNT1H = 0xAB;
        TCNT1L = 0xA0;

        // set interupsi timer untuk Timer 1
        TIMSK=0x04;

        xcount = 0;
                                                                    
        
        delay_ms(500);

        // aktifkan interupsi global (berdasar setting register)
        #asm("sei")

        // tidak lakukan apapun selain menunggu interupsi timer1_ovf_isr
        while (1)
        {
        	// blok ini kosong
        }; 
}
