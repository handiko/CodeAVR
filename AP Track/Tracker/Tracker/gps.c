/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 9/29/2012
Author  :
Company :
Comments:


Chip type               : ATtiny2313
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <stdio.h>

#define _1200		0
#define _2200		1

#ifdef	_OPTIMIZE_SIZE_
	#define CONST_1200      46
	#define CONST_2200      22
#else
	#define CONST_1200      50
	#define CONST_2200      25
#endif

#define GAP_TIME_	18
#define INITIAL_TIME_C	5
#define FWD_TIME_C	2
#define TX_DELAY_	40
#define FLAG_		0x7E
#define	CONTROL_FIELD_	0x03
#define PROTOCOL_ID_	0xF0
#define TD_POSISI_	'!'
#define TD_STATUS_	'>'
#define SYM_TAB_OVL_	'/'
#define SYM_CODE_	'l'
#define TX_TAIL_	2

#include <delay.h>
#include <stdarg.h>

#define TX_NOW  PIND.3
#define PTT     PORTB.3
#define DAC_0   PORTB.7
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4
#define L_BUSY	PORTD.5
#define L_STBY  PORTD.4

void set_dac(char value);
void set_nada(char i_nada);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_crc(char in_crc);
void kirim_crc(void);
void ekstrak_gps(void);
void init_usart(void);
void clear_usart(void);
void timer_detik(char detik);

flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
eeprom char data_1[28] =
{
	('A'<<1),('P'<<1),('Z'<<1),('T'<<1),('2'<<1),('3'<<1),0b11100000,
    ('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('A'<<1),('C'<<1),('9'<<1),
    ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),('1'<<1),
    ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
};
eeprom char posisi_lat[8] =
{
	'0','7','4','5','.','3','1','S'
};
eeprom char posisi_long[9] =
{
	'1','1','0','2','2','.','5','2','E'
};
eeprom char data_extension[7] =
{
	'P','H','G','2','0','0','0'
};
eeprom char komentar[14] =
{
	'L','a','b','.','S','S','T','K',' ','T','i','m','-','1'

};
eeprom char status[47] =
{
	'A','T','t','i','n','y','2','3','1','3',' ',
    'A','P','R','S',' ','t','r','a','c','k','e','r',' ',
    'h','a','n','d','i','k','o','g','e','s','a','n','g','@','g','m','a','i','l','.','c','o','m'
};
eeprom char beacon_stat = 0;
eeprom char xcount = 0;
bit nada = _1200;
static char bit_stuff = 0;
unsigned short crc;

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    L_STBY = 0;
    delay_ms(250);
    kirim_paket();
    L_STBY = 1;
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
    L_STBY = 0;
    xcount++;
    if(xcount == 1)
    {
        kirim_paket();
    }

    else if((xcount%2) == 0)
    {
        L_BUSY = 1;
        ekstrak_gps();
        L_BUSY = 0;
    }

    else if(xcount == GAP_TIME_)
    {
        xcount = 0;
    }

    L_STBY = 1;

    timer_detik(FWD_TIME_C);
}

/***************************************************************************************/
    void             kirim_paket(void)
/***************************************************************************************
*    ABSTRAKSI      :     pengendali urutan pengiriman data APRS
*                penyusun protokol APRS
*
*          INPUT        :    tak ada
*    OUTPUT        :       kondisi LED dan output transistor switch TX
*    RETURN        :       tak ada
*/
{
    char i;

        // inisialisasi nilai CRC dengan 0xFFFF
    crc = 0xFFFF;

        // tambahkan 1 nilai counter pancar
        beacon_stat++;

        // nyalakan LED TX dan PTT switch
    PTT = 1;

        // tunggu 500ms
        delay_ms(500);

        /**********************************************************************************

                    APRS AX.25 PROTOCOL

        |------------------------------------------------------------------------
        |   opn. FLAG    |    DESTINATION    |    SOURCE    |    DIGI'S    | CONTROL...
        |---------------|-----------------------|---------------|---------------|
        |   0x7E 1Bytes |    7 Bytes        |       7 Bytes |  0 - 56 Bytes    |
        |------------------------------------------------------------------------

            -----------------------------------------------------------------
        DIGI'S..|    CONTROL FIELD    |    PROTOCOL ID    |    INFO    | FCS...
                |-----------------------|-----------------------|---------------|
                |    0x03 1 Bytes    |     0xF0 1 Bytes    |  0 - 256 Bytes|
                -----------------------------------------------------------------

            --------------------------------|
        INFO... |    FCS    |   cls. FLAG    |
                |---------------|---------------|
                |    2 Bytes    |   0x7E 1Bytes |
                --------------------------------|

        Sumber : APRS101, Tucson Amateur Packet Radio Club. www.tapr.org
        ************************************************************************************/

        // kirim karakter opening flag
        for(i=0;i<TX_DELAY_;i++)
            kirim_karakter(FLAG_);

        // reset nilai variabel bit stuffing
        bit_stuff = 0;

        // kirimkan field : destination, source, PATH 1, PATH 2, control, Protocol ID, dan
            // data type ID
        for(i=0;i<28;i++)
            kirim_karakter(data_1[i]);

        // kirimkan field control
        kirim_karakter(CONTROL_FIELD_);

        // krimkan protocol ID
        kirim_karakter(PROTOCOL_ID_);

        // jika sudah 20 kali memancar,
        if(beacon_stat == 20)
        {
            // jika ya
                // kirim tipe data status
                kirim_karakter(TD_STATUS_);

                // kirim teks status
                for(i=0;i<47;i++)
                    kirim_karakter(status[i]);

                // reset nilai beacon_stat
                beacon_stat = 0;

                // lompat ke kirim crc
                goto lompat;
        }

        // krimkan tipe data posisi
        kirim_karakter(TD_POSISI_);

        // kirimkan posisi lintang
        for(i=0;i<8;i++)
            kirim_karakter(posisi_lat[i]);

        // kirimkan simbol tabel (overlay)
        kirim_karakter(SYM_TAB_OVL_);

        // kirimkan posisi bujur
    for(i=0;i<9;i++)
            kirim_karakter(posisi_long[i]);

        // kirimkan simbol kode (simbol station)
        kirim_karakter(SYM_CODE_);

        // hanya kirim PHGD code dan komentar pada pancaran ke-5
        if(beacon_stat == 5)
        {
            // kirimkan field informasi : data ekstensi tipe PHGD
            for(i=0;i<7;i++)
                kirim_karakter(data_extension[i]);

                // kirimkan field informasi : comment
               for(i=0;i<14;i++)
                kirim_karakter(komentar[i]);
        }


        // label lompatan
        lompat:

        // kirimkan field : FCS (CRC-16 CCITT)
        kirim_crc();

        // kirimkan karakter closing flag
        for(i=0;i<TX_TAIL_;i++)
            kirim_karakter(FLAG_);

        // matikan LED TX dan PTT switch
        PTT = 0;


}       // EndOf void kirim_paket(void)


/***************************************************************************************/
    void             kirim_crc(void)
/***************************************************************************************
*    ABSTRAKSI      :     Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
*                nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
*                Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
*                leading one.
*
*          INPUT        :    tak ada
*    OUTPUT        :       tak ada
*    RETURN        :       tak ada
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
    void             kirim_karakter(unsigned char input)
/***************************************************************************************
*    ABSTRAKSI      :     mengirim data APRS karakter-demi-karakter, menghitung FCS
*                field dan melakukan bit stuffing. Polarisasi data adalah
*                NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
*                bit terakhir yang ditahan jika bit masukan adalah bit 1.
*                Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
*                masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
*                 merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
*                tone adalah tidak penting dalam polarisasi data NRZI.
*
*          INPUT        :    byte data protokol APRS
*    OUTPUT        :       tak ada
*    RETURN        :       tak ada
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
                if(input==0x7E)    {bit_stuff = 0;}

                // jika bukan flag, hitung nilai CRC dari bit data saat ini
                else        {hitung_crc(in_bit);}

                // jika bit data saat ini adalah
                // nol
                if(!in_bit)
                {    // jika ya
                    // ubah tone dan bentuk gelombang sinus
                        ubah_nada();

                        // nol-kan pengingat bit stuffing
                        bit_stuff = 0;
                }
                // satu
                else
                {    // jika ya
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
    void             hitung_crc(char in_crc)
/***************************************************************************************
*    ABSTRAKSI      :     menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
*                generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
*                leading one
*
*          INPUT        :    bit data yang terkirim
*    OUTPUT        :       tak ada
*    RETURN        :       tak ada
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
    void             ubah_nada(void)
/***************************************************************************************
*    ABSTRAKSI      :     Menukar seting tone terakhir dengan tone yang baru. Tone
*                1200Hz dan 2200Hz masing - masing merepresentasikan bit
*                0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
*                penting dalam polarisasi data NRZI.
*
*          INPUT        :    tak ada
*    OUTPUT        :       tak ada
*    RETURN        :       tak ada
*/
{
    // jika tone terakhir adalah :
        // 1200Hz
        if(nada ==_1200)
    {    // jika ya
            // ubah tone saat ini menjadi 2200Hz
                nada = _2200;

                // bangkitkan gelombang sinus 2200Hz
            set_nada(nada);
    }
        // 2200Hz
        else
        {    // jika ya
            // ubah tone saat ini menjadi 1200Hz
                nada = _1200;

                // bangkitkan gelombang sinus 1200Hz
            set_nada(nada);
        }

}       // EndOf void ubah_nada(void)


/***************************************************************************************/
    void             set_dac(char value)
/***************************************************************************************
*    ABSTRAKSI      :     Men-set dan reset output DAC sebagai bilangan biner yang
*                merepresentasikan nilai diskrit dari gelombang sinus yang
*                sedang dibentuk saat ini sehingga membentuk tegangan sampling
*                dari gelombang.
*
*          INPUT        :    nilai matrix rekonstruksi diskrit gelombang sinusoid
*    OUTPUT        :       DAC 0 - 3, tegangan kontinyu pada output Low Pass Filter
*    RETURN        :       tak ada
*/
{
    // ambil nilai LSB dari matrix rekonstruksi dan set sebagai DAC-0
        DAC_0 = value & 0x01;

        // ambil nilai dari matrix rekonstruksi, geser kanan 1 bit, ambil bit paling kanan
            // dan set sebagai DAC-1
        DAC_1 =( value >> 1 ) & 0x01;

        // ambil nilai dari matrix rekonstruksi, geser kanan 2 bit, ambil bit paling kanan
            // dan set sebagai DAC-2
        DAC_2 =( value >> 2 ) & 0x01;

        // ambil nilai dari matrix rekonstruksi, geser kanan 3 bit, ambil bit tersebut dan
            // set sebagai DAC-3 (MSB)
        DAC_3 =( value >> 3 ) & 0x01;

}          // EndOf void set_dac(char value)


/***************************************************************************************/
    void             set_nada(char i_nada)
/***************************************************************************************
*    ABSTRAKSI      :     Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
*                dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
*                tuning pada jumlah masing - masing perulangan for dan
*                konstanta waktu untuk meng-adjust parameter baudrate dan
*                frekuensi tone.
*
*          INPUT        :    nilai frekuensi tone yang akan ditransmisikan
*    OUTPUT        :       nilai DAC
*    RETURN        :       tak ada
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
                    // set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
                        // dan urutan perulangan for 0 - 15
                    set_dac(matrix[i]);

                        // bangkitkan frekuensi 1200Hz dari konstanta waktu
                delay_us(CONST_1200);
            }
        }
        // 2200Hz
        else
        {
            // jika ya
            for(i=0; i<16; i++)
            {
                    // set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
                        // dan urutan perulangan for 0 - 15
                    set_dac(matrix[i]);

                        // bangkitkan frekuensi 2200Hz dari konstanta waktu
                    delay_us(CONST_2200);
                }
                // sekali lagi, untuk mengatur baudrate lakukan fine tune pada jumlah for
                for(i=0; i<13; i++)
                {
                    // set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
                        // dan urutan perulangan for
                    set_dac(matrix[i]);

                        // bangkitkan frekuensi 2200Hz dari konstanta waktu
                    delay_us(CONST_2200);
                }
        }

}     // EndOf void set_nada(char i_nada)


/***************************************************************************************/
    void             getComma(void)
/***************************************************************************************
*    ABSTRAKSI      :     Menunggu data RX serial berupa karakter koma dan segera
*                kembali pada fungsi yang memanggilnya.
*
*          INPUT        :    RX data serial $GPGLL gps
*    OUTPUT        :       tak ada
*    RETURN        :       tak ada
*/
{
    // jika data yang diterima bukan karakter koma, terima terus
            // jika data yang diterima adalah koma, keluar
        while(getchar() != ',');

}          // EndOf void getComma(void)


/***************************************************************************************/
    void             ekstrak_gps(void)
/***************************************************************************************
*    ABSTRAKSI      :     Menunggu interupsi RX data serial dari USART, memparsing
*                data $GPGLL yang diterima menjadi data posisi, dan mengupdate
*                data variabel posisi.
*
*          INPUT        :    RX data serial $GPGLL gps
*    OUTPUT        :       tak ada
*    RETURN        :       tak ada
*/
{
    int i;
        static char buff_posisi[17];

        // aktifkan USART param. : 4800baudrate, 8, N, 1
        init_usart();

        /************************************************************************************************
            $GPGLL - GLL - Geographic Position Latitude / Longitude

                Contoh : $GPGLL,3723.2475,N,12158.3416,W,161229.487,A*2C

        |-----------------------------------------------------------------------------------------------|
        |    Nama        |     Contoh        |        Deskripsi            |
        |-----------------------|-----------------------|-----------------------------------------------|
        |    Message ID    |    $GPGLL        |    header protokol GLL            |
        |    Latitude    |    3723.2475    |    ddmm.mmmm     , d=degree, m=minute    |
        |    N/S indicator    |    N        |    N=utara, S=selatan            |
        |    Longitude    |    12158.3416    |    dddmm.mmmm    , d=degree, m=minute    |
        |    W/E indicator    |    W        |    W=barat, E=timur            |
        |    Waktu UTC (GMT)    |    161229.487    |    HHMMSS.SS  ,H=hour, M=minute, S=second    |
        |    Status        |    A        |    A=data valid, V=data invalid        |
        |    Checksum    |    *2C        |                        |
        |-----------------------------------------------------------------------------------------------|

            Sumber : GPS SiRF EM-406A datasheet

        *************************************************************************************************/

        // jika data yang diterima bukan karakter $, terima terus
            // jika data yang diterima adalah $, lanjutkan
        while(getchar() != '$');

        // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter G)
    getchar();

        // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter P)
        getchar();

        // tunggu data, jika yang diterima adalah karakter G
        if(getchar() == 'R')
        {
            // maka
            // tunggu data, jika yang diterima adalah karakter L
                if(getchar() == 'M')
            {
                    // maka
                        // tunggu data, jika yang diterima adalah karakter L
                        if(getchar() == 'C')
                    {
                            // maka
                                // tunggu koma dan lanjutkan
                                getComma();
                                getComma();
                                getComma();

                                // ambil 7 byte data berurut dan masukkan dalam buffer data
                            for(i=0; i<7; i++)    buff_posisi[i] = getchar();

                                // tunggu koma dan lanjutkan
                                getComma();

                                // ambil 1 byte data dan masukkan dalam buffer data
                                buff_posisi[7] = getchar();

                                // tunggu koma dan lanjutkan
                                getComma();

                                // ambil 8 byte data berurut dan masukkan dalam buffer data
                                for(i=0; i<8; i++)	buff_posisi[i+8] = getchar();

                                // tunggu koma dan lanjutkan
                                getComma();

                                // ambil 1 byte data dan masukkan dalam buffer data
                                buff_posisi[16] = getchar();

                                // segera matikan USART untuk menghindari interupsi [USART_RXC]
                                clear_usart();

                                // pindahkan data dari buffer kedalam variabel posisi
                                for(i=0;i<8;i++)	{posisi_lat[i]=buff_posisi[i];}
        			for(i=0;i<9;i++)	{posisi_long[i]=buff_posisi[i+8];}

                        }
                }
        }

} 	// EndOf void ekstrak_gps(void)


/***************************************************************************************/
	void 			init_usart(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	Setting parameter USART : RX only, 4800baud, 8, N, 1
*
*      	INPUT		:	tak ada
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{
	// set parameter 4800baud, 8, N, 1
	UCSRA=0x00;
	UCSRB=0x10;
	UCSRC=0x06;
	UBRRH=0x00;
	UBRRL=0x8F;

}       // EndOf void init_usart(void)


/***************************************************************************************/
	void 			clear_usart(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	Me-nonaktifkan dan menghapus parameter USART
*
*      	INPUT		:	tak ada
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{
	// hapus parameter terakhir dari USART
        UCSRA=0;
	UCSRB=0;
	UCSRC=0;
	UBRRH=0;
	UBRRL=0;

}       // EndOf void clear_usart(void)


/***************************************************************************************/
	void 			timer_detik(char detik)
/***************************************************************************************
*	ABSTRAKSI  	: 	Menghitung nilai register TCNT1H dan TCNT1L dari input nilai
*				konstanta timer dalam satuan detik. Formula untuk menghitung
*				nilai register :
*				_TCNT1 = (TCNT1H << 8) + TCNT1L
*				_TCNT1 = (1 + 0xFFFF) - (konstanta_timer_detik * (sys_clock / prescaler))
*
*      	INPUT		:	konstanta timer dalam satuan detik
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{
	unsigned short _TCNT1;

        // hitung nilai vaiabel _TCNT1 dari nilai input berdasarkan formula :
         	// _TCNT1 = (1 + 0xFFFF) - (konstanta_timer_detik * (sys_clock / prescaler))
                // menjadi bilangan 16 bit
	_TCNT1 = (1 + 0xFFFF) - (detik * 10800);

        // ambil 8 bit paling kanan dan jadikan nilai register TCNT1L
        TCNT1L = _TCNT1 & 0xFF;

        // ambil 8 bit paling kiri dan jadikan nilai register TCNT1H
        TCNT1H = _TCNT1 >> 8;

}       // EndOf void timer_detik(char detik)

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// set bit register PORTB
        PORTB=0x00;

        // set bit Data Direction Register PORTB
	DDRB=0xF8;

        // set bit register PORTD
        PORTD=0x09;

        // set bit Data Direction Register PORTD
	DDRD=0x30;

        // set register Analog Comparator
        ACSR=0x80;

        // set register EXT_IRQ_1 (External Interrupt 1 Request), Low Interrupt
	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80;

        // set register Timer 1, System clock 10.8kHz, Timer 1 overflow
	TCCR1B=0x05;

        // set konstanta waktu 5 detik sebagai awalan
        timer_detik(INITIAL_TIME_C);

        // set interupsi timer untuk Timer 1
        TIMSK=0x80;

        // indikator awalan hardware aktif :
        // nyalakan LED busy
        L_BUSY = 1;

        // tunggu 500ms
        delay_ms(500);

        // nyalakan LED standby
        L_STBY = 1;

        // tunggu 500ms
        delay_ms(500);

        // matikan LED busy
        L_BUSY = 0;

        // tunggu 500ms
        delay_ms(500);

    // Global enable interrupts
    #asm("sei")

    while (1)
    {
      // Place your code here

    }
}
