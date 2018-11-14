/***************************************************************************************
*
*				HANYA UNTUK TUJUAN EDUKASIONAL
*				FOR EDUCATION PURPOSE ONLY
*
*				COPYRIGHT (c)2012, HANDIKO GESANG ANUGRAH SEJATI
*				(handikogesang@gmail.com)
*
*				2 FEBRUARY 2012
*
*				BASIC APRS BEACON, GPS PARSER, & APRS ENCODER ONLY
*				TANPA FITUR SMART BEACONING(TM), TELEMETRY, DAN PC CONFIG
*
*				LAST REVISION 30 SEPTEMBER 2012
*
*				DOKUMEN INI BEBAS UNTUK DISEBARLUASKAN.
*				HARAP TIDAK MELAKUKAN PERUBAHAN APAPUN ATAS ISI DOKUMEN INI
*				DAN MENCANTUMKAN NAMA DAN EMAIL PENULIS JIKA INGIN MENYEBAR-
*				LUASKAN DOKUMEN INI.
*
* Project 		: 	APRS BEACON
* Version 		: 	GPS SUPPORTED, EEPROM DATA PROTECTOR SUPPORTED
* Date    		: 	02/02/2012
* Author  		: 	HANDIKO GESANG ANUGRAH S.
* Company 		: 	TIM INSTRUMENTASI TELEMETRI DAN TELEKONTROL
* 	  			LABORATORIUM SENSOR DAN SISTEM TELEKONTROL
* 	  			JURUSAN TEKNIK FISIKA
*           			FAKULTAS TEKNIK
*           			UNIVERSITAS GADJAH MADA
*
* Chip type           	: 	ATtiny2313
* Program type        	: 	Application
* Clock frequency     	: 	11.059200 MHz
* Memory model        	: 	Tiny
* External SRAM size  	: 	0
* Data Stack size     	: 	32
*
* File			:	final.c
*
* Fungsi - fungsi	: 	void set_dac(char value)
* 				void set_nada(char i_nada)
* 				void kirim_karakter(unsigned char input)
* 				void kirim_paket(void)
* 				void ubah_nada(void)
* 				void hitung_crc(char in_crc)
* 				void kirim_crc(void)
* 				void ekstrak_gps(void)
*
* Variabel global	:	char rx_buffer[RX_BUFFER_SIZE]
* 				bit rx_buffer_overflow
*                               flash char matrix[ ]
*				eeprom char data_1[ ]
*				eeprom char posisi_lat[ ]
*				eeprom char posisi_long[ ]
*				eeprom char data_extension[ ]
*				eeprom char komentar[ ]
*				eeprom char status[ ]
*				eeprom char beacon_stat
*				char xcount
*				bit nada
*				static char bit_stuff
*				unsigned short crc;
*
* Konstanta custom	:	_1200
* 				_2200
* 				CONST_1200
* 				CONST_2200
* 				GAP_TIME_
*				FLAG_
*				CONTROL_FIELD_
*				PROTOCOL_ID_
*				TD_POSISI_
*				TD_STATUS_
*				SYM_TAB_OVL_
*				SYM_CODE_
*
* Chip I/O		:	TX_NOW  PIND.3
* 				PTT     PORTB.3
* 				DAC_0   PORTB.7
* 				DAC_1   PORTB.6
* 				DAC_2   PORTB.5
* 				DAC_3   PORTB.4
* 				L_BUSY	PORTD.5
* 				L_STBY  PORTD.4
*
* Vektor		:	RJMP __RESET
*				RJMP _ext_int1_isr
*				RJMP _timer1_ovf_isr
*
* Fuse bit		:	BODLEVEL1 = 0
*
*
***************************************************************************************/

// header firmware
#include <tiny2313.h>
#include <stdio.h>
#include <tiny4313_bits.h>



/***************************************************************************************
*
*	DEFINISI KONSTANTA - KONSTANTA CUSTOM
*
*/
// definisi konstanta kondisi tone yang dikirimkan
#define _1200		0
#define _2200		1

// definisi konstanta waktu de-sampling (rekonstruksi) diskrit gelombang sinus untuk tone
	// 1200Hz dan 2200Hz dalam microsecond (us). Silahkan fine tune konstanta ini untuk
        // adjusting baudrate dan cek hasilnya dengan menginputkan audio dari hardware APRS
        // pada PC / Laptop lalu cek hasil tone dan baudrate dengan Cool Edit pro pada
        // tampilan waveform atau spektral.


        // Konstanta untuk kompilasi dalam mode optimasi ukuran
#ifdef	_OPTIMIZE_SIZE_
	#define CONST_1200      46
	#define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz

        // Konstanta untuk kompilasi dalam mode optimasi kecepatan
#else
	#define CONST_1200      50
	#define CONST_2200      25
#endif

// waktu jeda antara transmisi data dalam detik (s)
#define GAP_TIME_	12

// konstanta waktu opening flag
#define TX_DELAY_	45

// definisi konstanta karakter Flag
#define FLAG_		0x7E

// definisi konstanta karakter Control Field
#define	CONTROL_FIELD_	0x03

// definisi konstanta karakter PID
#define PROTOCOL_ID_	0xF0

// definisi konstanta karakter Tipe Data posisi
#define TD_POSISI_	'!'

// definisi konstanta karakter Tipe Data status
#define TD_STATUS_	'>'

// definisi konstanta karakter simbol tabel dan overlay (\)
#define SYM_TAB_OVL_	'\\'

// definisi konstanta karakter simbol station (Area Locns)
#define SYM_CODE_	'l'

// konstanta waktu closing flag
#define TX_TAIL_	15

//	AKHIR DARI DEFINISI KONSTANTA - KONSTANTA CUSTOM


/**************************************************************************************/

// header firmware
#include <delay.h>
#include <stdarg.h>

/***************************************************************************************
*
*	DEFINISI INPUT - OUTPUT ATTINY2313
*
*/
// definisi input TX manual (request interupsi eksternal) INT1
#define TX_NOW  PIND.3

// definisi output LED TX dan transistor sebagai switch TX (Hi = TX, Lo = waiting)
#define PTT     PORTB.3

// definisi output tegangan DAC ladder resistor sebagai generator sinusoid ( DAC_0 = LSB,
	// DAC_3 = MSB )
#define DAC_0   PORTB.7
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4

// definisi output LED saat terima dan ekstrak data GPS (Hi = parsing, Lo = waiting)
#define L_BUSY	PORTD.5

// definisi output LED saat menunggu interupsi (Hi = waiting, Lo = ada proses)
#define L_STBY  PORTD.4

//	AKHIR DARI DEFINISI INPUT - OUTPUT ATTINY2313


/***************************************************************************************
*
*	DEKLARASI PROTOTYPE FUNGSI - FUNGSI
*
*/
void set_dac(char value);
void set_nada(char i_nada);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_crc(char in_crc);
void kirim_crc(void);
void ekstrak_gps(void);


//	AKHIR DARI DEKLARASI PROTOTYPE FUNGSI - FUNGSI


/***************************************************************************************
*
*	DEKLARASI VARIABEL GLOBAL
*
*/

// variabel penyimpan nilai rekonstruksi diskrit gelombang sinusoid (matrix 16 ele.)
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};

// variabel penyimpan data adresses
eeprom unsigned char data_1[21] =
{
	// destination field, tergeser kiri 1 bit
        ('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1),

        // source field, tergeser kiri 1 bit
	('Y'<<1),('C'<<1),('2'<<1),('W'<<1),('Y'<<1),('A'<<1),('0'<<1),

        // path, tergeser kiri 1 bit
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
};

// variabel penyimpan data awal posisi lintang dan update data gps
eeprom char posisi_lat[8] =
{
	// latitude
        '0','0','0','0','.','0','0','0'
};

// variabel penyimpan data awal posisi bujur dan update data gps
eeprom char posisi_long[9] =
{
	// longitude
        '0','0','0','0','0','.','0','0','E'
};

eeprom char altitude[6];

// variabel penyimpan data extensi tipe PHGD
eeprom char data_extension[7] =
{
	// header tipe data ekstensi
        'P','H','G',

        /************************************************************************************************
        |-----------------------------------------------------------------------------------------------|
	|	PHGD CODE (Power Height Gain Directivity)						|
        |-----------------------------------------------------------------------------------------------|
        |	P		|	H		|	G		|	D		|
        |-----------------------|-----------------------|-----------------------|-----------------------|
        |  0 rep.of  0 watts	|  0 rep.of  10 ft.	|  0 rep.of   0dBi	|  0 rep.of  omni.	|
        |  1 rep.of  1 watts	|  1 rep.of  20 ft.	|  1 rep.of   1dBi	|  1 rep.of  NE		|
        |  2 rep.of  4 watts	|  2 rep.of  40 ft.	|  2 rep.of   2dBi	|  2 rep.of  E		|
        |  3 rep.of  9 watts	|  3 rep.of  80 ft.	|  3 rep.of   3dBi	|  3 rep.of  SE		|
        |  4 rep.of  16 watts   |  4 rep.of  160 ft.	|  4 rep.of   4dBi	|  4 rep.of  S		|
        |  5 rep.of  25 watts 	|  5 rep.of  320 ft.	|  5 rep.of   5dBi	|  5 rep.of  SW		|
        |  6 rep.of  36 watts	|  6 rep.of  640 ft.	|  6 rep.of   6dBi	|  6 rep.of  W		|
        |  7 rep.of  49 watts	|  7 rep.of  1280 ft.	|  7 rep.of   7dBi	|  7 rep.of  NW		|
        |  8 rep.of  64 watts	|  8 rep.of  2560 ft.	|  8 rep.of   8dBi	|  8 rep.of  N		|
        |  9 rep.of  81 watts	|  9 rep.of  5120 ft.	|  9 rep.of   9dBi	|-----------------------|
        *************************************************************************************************/


        // nilai representasi dari PHGD
        // power : 4 watts, P = 2
        '2',

        // height above average terrain : 10 feet, H = 0
        '0',

        // antenna gain : 2dBi, G = 2
        '2',

        // antenna directivity : omnidirectional, D = 0
        '0'

};

// variabel penyimpan konstanta string komentar
eeprom char komentar[28] =
{
	'C','O','R','E',' ','O','R','D','A',' ','D','I','Y',' ','M','o','b','i','l','e',' ','T','r','a','c','k','e','r'

};

eeprom char status[47] =
{
	'A','T','t','i','n','y','2','3','1','3',' ',
        'A','P','R','S',' ','t','r','a','c','k','e','r',' ',
        'h','a','n','d','i','k','o','g','e','s','a','n','g','@','g','m','a','i','l','.','c','o','m'
};

// variabel pengingat urutan beacon dan status
eeprom char beacon_stat = 0;

// variabel penyimpan nilai urutan interupsi, 0 ketika inisialisasi dan reset, 1 ketika TX,
	// 2 - GAP_TIME_ ketika parsing data gps
char xcount = 0;

// variabel penyimpan tone terakhir, _1200 = 0, _2200 = 1, inisialisasi sebagai 1200Hz
bit nada = _1200;

// variabel penyimpan enablisasi bit stuffing, 0 = disable bit stuffing, 1 = enable bit stuffing
static char bit_stuff = 0;

// variabel penyimpan nilai sementara dan nilai akhir CRC-16 CCITT
unsigned short crc;

//	AKHIR DARI DEKLARASI VARIABEL GLOBAL


/***************************************************************************************
*
*	KONSTANTA EVALUATOR
*
*/
// cek define _1200
#ifndef	_1200
#error	"KONSTANTA _1200 BELUM TERDEFINISI"
#endif

// cek define _2200
#ifndef	_2200
#error	"KONSTANTA _2200 BELUM TERDEFINISI"
#endif

// cek define CONST_1200
#ifndef	CONST_1200
#error	"KONSTANTA CONST_1200 BELUM TERDEFINISI"
#endif

// cek define CONST_2200
#ifndef	CONST_2200
#error	"KONSTANTA CONST_2200 BELUM TERDEFINISI"
#endif

// cek define GAP_TIME_
#ifndef	GAP_TIME_
#error	"KONSTANTA GAP_TIME_ BELUM TERDEFINISI"
#endif

// cek nilai GAP_TIME_ (harus antara 15 - 30)
#if	(GAP_TIME_ < 15)
//#error	"GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu singkat menyebabkan kepadatan traffic"
#endif
#if	(GAP_TIME_ > 60)
#error	"GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu panjang menyebabkan 'loose of track'  "
#endif

//	AKHIR DARI KONSTANTA EVALUATOR


/***************************************************************************************/
	interrupt 		[EXT_INT1] void ext_int1_isr(void)
/***************************************************************************************
*	ABSTRAKSI	:	interupsi eksternal, ketika input TX_NOW bernilai LOW,
*				[EXT_INT1] aktif
*
*      	INPUT		:	input TX_NOW
*	OUTPUT		:       LED standby dan LED busy
*	RETURN		:       tak ada
*/
{
	// matikan LED standby
        L_STBY = 0;

        // tunggu 250ms (bounce switch)
        delay_ms(250);

        // kirim paket data
        kirim_paket();

        // nyalakan LED standby
        L_STBY = 1;

} 	// EndOf interrupt [EXT_INT1] void ext_int1_isr(void)


/***************************************************************************************/
	interrupt 		[TIM1_OVF] void timer1_ovf_isr(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	interupsi overflow TIMER 1 [TIM1_OVF], di-set overflow
*				ketika waktu telah mencapai 1 detik. Pengendali urutan
*				waktu (timeline)antara transmisi data APRS dan parsing
*				data gps
*
*      	INPUT		:	tak ada
*	OUTPUT		:       kondisi LED standby dan LED busy
*	RETURN		:       tak ada
*/
{
	// matikan LED stanby
        L_STBY = 0;

        // tambahkan 1 nilai variabel xcount
        xcount++;

        // seleksi nilai variabel xcount
        if((xcount%2) == 0)
        {	// jika ya
        	// nyalakan LED busy
                L_BUSY = 1;

                // dapatkan data koordinat sekarang
                ekstrak_gps();

                //matikan LED busy
                L_BUSY = 0;
        }

        // terima dan ekstrak data gps ketika timer detik bernilai genap saja
        if((xcount%8) == 0)
        {	// jika ya
        	// nyalakan LED busy
                L_BUSY = 1;

                // dapatkan data koordinat sekarang
                ekstrak_gps();

                //matikan LED busy
                L_BUSY = 0;

                // berikan delay sebentar
                delay_ms(500);

                // kirim paket data
                kirim_paket();

                // reset variable counter
                xcount = 0;
        }

        // nyalakan LED standby
        L_STBY = 1;

        // reset kembali konstanta waktu timer
        TCNT1H = 0xAB;
        TCNT1L = 0xA0;

}       // EndOf interrupt [TIM1_OVF] void timer1_ovf_isr(void)


/***************************************************************************************/
	void 			kirim_paket(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	pengendali urutan pengiriman data APRS
*				penyusun protokol APRS
*
*      	INPUT		:	tak ada
*	OUTPUT		:       kondisi LED dan output transistor switch TX
*	RETURN		:       tak ada
*/
{
	char i;

        // inisialisasi nilai CRC dengan 0xFFFF
	crc = 0xFFFF;

        // tambahkan 1 nilai counter pancar
        beacon_stat++;

        // nyalakan LED TX dan PTT switch
	PTT = 1;

        // tunggu 300ms
        delay_ms(100);

        /**********************************************************************************

        			APRS AX.25 PROTOCOL

        |------------------------------------------------------------------------
        |   opn. FLAG	|	DESTINATION	|	SOURCE	|	DIGI'S	| CONTROL...
        |---------------|-----------------------|---------------|---------------|
        |   0x7E 1Bytes |	7 Bytes		|       7 Bytes |  0 - 56 Bytes	|
        |------------------------------------------------------------------------

        	-----------------------------------------------------------------
        DIGI'S..|	CONTROL FIELD	|	PROTOCOL ID	|	INFO	| FCS...
                |-----------------------|-----------------------|---------------|
                |    0x03 1 Bytes	|     0xF0 1 Bytes	|  0 - 256 Bytes|
                -----------------------------------------------------------------

        	--------------------------------|
        INFO... |	FCS	|   cls. FLAG	|
                |---------------|---------------|
                |	2 Bytes	|   0x7E 1Bytes |
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
        for(i=0;i<21;i++)
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

        kirim_karakter('/');
        kirim_karakter('A');
        kirim_karakter('=');

        for(i=0;i<6;i++)
                kirim_karakter(altitude[i]);

        // hanya kirim PHGD code dan komentar pada pancaran ke-5
        if(beacon_stat == 5)
        {
        	// kirimkan field informasi : data ekstensi tipe PHGD
        	//for(i=0;i<7;i++)
        	//	kirim_karakter(data_extension[i]);

                // kirimkan field informasi : comment
       		for(i=0;i<28;i++)
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
        delay_ms(50);
        PTT = 0;


}       // EndOf void kirim_paket(void)


/***************************************************************************************/
	void 			kirim_crc(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
*				nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
*				Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
*				leading one.
*
*      	INPUT		:	tak ada
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
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
	void 			kirim_karakter(unsigned char input)
/***************************************************************************************
*	ABSTRAKSI  	: 	mengirim data APRS karakter-demi-karakter, menghitung FCS
*				field dan melakukan bit stuffing. Polarisasi data adalah
*				NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
*				bit terakhir yang ditahan jika bit masukan adalah bit 1.
*				Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
*				masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
* 				merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
*				tone adalah tidak penting dalam polarisasi data NRZI.
*
*      	INPUT		:	byte data protokol APRS
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
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
                if(input==0x7E)	{bit_stuff = 0;}

                // jika bukan flag, hitung nilai CRC dari bit data saat ini
                else		{hitung_crc(in_bit);}

                // jika bit data saat ini adalah
                // nol
                if(!in_bit)
                {	// jika ya
                	// ubah tone dan bentuk gelombang sinus
                        ubah_nada();

                        // nol-kan pengingat bit stuffing
                        bit_stuff = 0;
                }
                // satu
                else
                {	// jika ya
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
	void 			hitung_crc(char in_crc)
/***************************************************************************************
*	ABSTRAKSI  	: 	menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
*				generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
*				leading one
*
*      	INPUT		:	bit data yang terkirim
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
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
	void 			ubah_nada(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	Menukar seting tone terakhir dengan tone yang baru. Tone
*				1200Hz dan 2200Hz masing - masing merepresentasikan bit
*				0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
*				penting dalam polarisasi data NRZI.
*
*      	INPUT		:	tak ada
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{
	// jika tone terakhir adalah :
        // 1200Hz
        if(nada ==_1200)
	{	// jika ya
        	// ubah tone saat ini menjadi 2200Hz
                nada = _2200;

                // bangkitkan gelombang sinus 2200Hz
        	set_nada(nada);
	}
        // 2200Hz
        else
        {	// jika ya
        	// ubah tone saat ini menjadi 1200Hz
                nada = _1200;

                // bangkitkan gelombang sinus 1200Hz
        	set_nada(nada);
        }

}       // EndOf void ubah_nada(void)


/***************************************************************************************/
	void 			set_dac(char value)
/***************************************************************************************
*	ABSTRAKSI  	: 	Men-set dan reset output DAC sebagai bilangan biner yang
*				merepresentasikan nilai diskrit dari gelombang sinus yang
*				sedang dibentuk saat ini sehingga membentuk tegangan sampling
*				dari gelombang.
*
*      	INPUT		:	nilai matrix rekonstruksi diskrit gelombang sinusoid
*	OUTPUT		:       DAC 0 - 3, tegangan kontinyu pada output Low Pass Filter
*	RETURN		:       tak ada
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

}      	// EndOf void set_dac(char value)


/***************************************************************************************/
	void 			set_nada(char i_nada)
/***************************************************************************************
*	ABSTRAKSI  	: 	Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
*				dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
*				tuning pada jumlah masing - masing perulangan for dan
*				konstanta waktu untuk meng-adjust parameter baudrate dan
*				frekuensi tone.
*
*      	INPUT		:	nilai frekuensi tone yang akan ditransmisikan
*	OUTPUT		:       nilai DAC
*	RETURN		:       tak ada
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
        	for(i=0; i<15; i++)
        	{
                	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
                		// dan urutan perulangan for 0 - 15
                	set_dac(matrix[i]);

                        // bangkitkan frekuensi 2200Hz dari konstanta waktu
                	delay_us(CONST_2200);
                }
                // sekali lagi, untuk mengatur baudrate lakukan fine tune pada jumlah for
                for(i=0; i<12; i++)
                {
                	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
                		// dan urutan perulangan for
                	set_dac(matrix[i]);

                        // bangkitkan frekuensi 2200Hz dari konstanta waktu
                	delay_us(CONST_2200);
                }
    	}

} 	// EndOf void set_nada(char i_nada)


/***************************************************************************************/
	void 			getComma(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	Menunggu data RX serial berupa karakter koma dan segera
*				kembali pada fungsi yang memanggilnya.
*
*      	INPUT		:	RX data serial $GPGLL gps
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{
	// jika data yang diterima bukan karakter koma, terima terus
        	// jika data yang diterima adalah koma, keluar
        while(getchar() != ',');

}      	// EndOf void getComma(void)


/***************************************************************************************/
	void 			ekstrak_gps(void)
/***************************************************************************************
*	ABSTRAKSI  	: 	Menunggu interupsi RX data serial dari USART, memparsing
*				data $GPGLL yang diterima menjadi data posisi, dan mengupdate
*				data variabel posisi.
*
*      	INPUT		:	RX data serial $GPGLL gps
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{
	int i,j;
        static char buff_posisi[17], buff_altitude[9];
        unsigned int n_altitude[6];

        /************************************************************************************************
        	$GPGLL - GLL - Geographic Position Latitude / Longitude

                Contoh : $GPGLL,3723.2475,N,12158.3416,W,161229.487,A*2C

        |-----------------------------------------------------------------------------------------------|
        |	Nama		| 	Contoh		|		Deskripsi			|
        |-----------------------|-----------------------|-----------------------------------------------|
        |	Message ID	|	$GPGLL		|	header protokol GLL			|
        |	Latitude	|	3723.2475	|	ddmm.mmmm 	, d=degree, m=minute	|
        |	N/S indicator	|	N		|	N=utara, S=selatan			|
        |	Longitude	|	12158.3416	|	dddmm.mmmm	, d=degree, m=minute	|
        |	W/E indicator	|	W		|	W=barat, E=timur			|
        |	Waktu UTC (GMT)	|	161229.487	|	HHMMSS.SS  ,H=hour, M=minute, S=second	|
        |	Status		|	A		|	A=data valid, V=data invalid		|
        |	Checksum	|	*2C		|						|
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
        if(getchar() == 'G')
        {
        	// maka
        	// tunggu data, jika yang diterima adalah karakter G
                if(getchar() == 'G')
        	{
                	// maka
                        // tunggu data, jika yang diterima adalah karakter A
                        if(getchar() == 'A')
                	{
                        	// maka
                                // tunggu koma dan lanjutkan
                                getComma();
                                getComma();

                                // ambil 7 byte data berurut dan masukkan dalam buffer data
                        	for(i=0; i<7; i++)	buff_posisi[i] = getchar();

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

                                // tunggu dan lewatkan 3 koma
                                getComma();
                                getComma();
                                getComma();
                                getComma();

                                // ambil 8 byte data ketinggian dalam meter
                                for(i=0;i<8;i++)        buff_altitude[i] = getchar();

                                // pindahkan data dari buffer kedalam variabel posisi
                                for(i=0;i<8;i++)	{posisi_lat[i]=buff_posisi[i];}
        			for(i=0;i<9;i++)	{posisi_long[i]=buff_posisi[i+8];}

                                // nol-kan variable ketinggian
                                for(i=0;i<6;i++)        n_altitude[i] = '0';

                                // pindahkan data dari variable buffer ke variable numerik
                                for(i=0;i<8;i++)
                                {
                                        if(buff_altitude[i] == '.')     goto selesai;
                                        if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
                                        {
                                                // geser dari satuan ke puluhan dst.
                                                for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];

                                                // isi nilai satuan dengan variable buffer
                                                n_altitude[5] = buff_altitude[i];
                                        }
                                }

                                selesai:

                                // atoi
                                for(i=0;i<6;i++)        n_altitude[i] -= '0';

                                // 'string' to num.
                                n_altitude[0] *= 100000;
                                n_altitude[1] *=  10000;
                                n_altitude[2] *=   1000;
                                n_altitude[3] *=    100;
                                n_altitude[4] *=     10;

                                // jumlahkan satuan + puluhan + ratusan dst.
                                n_altitude[5] += (n_altitude[0] + n_altitude[1] + n_altitude[2] + n_altitude[3] + n_altitude[4]);

                                // meter to feet
                                n_altitude[5] *= 3;

                                // num to 'string'
                                n_altitude[0] = n_altitude[5] / 100000;
                                n_altitude[5] %= 100000;

                                n_altitude[1] = n_altitude[5] / 10000;
                                n_altitude[5] %= 10000;

                                n_altitude[2] = n_altitude[5] / 1000;
                                n_altitude[5] %= 1000;

                                n_altitude[3] = n_altitude[5] / 100;
                                n_altitude[5] %= 100;

                                n_altitude[4] = n_altitude[5] / 10;
                                n_altitude[5] %= 10;

                                // itoa, pindahkan dari variable numerik ke eeprom
                                for(i=0;i<6;i++)        altitude[i] = (char)(n_altitude[i] + '0');
                        }
                }
        }

} 	// EndOf void ekstrak_gps(void)


/***************************************************************************************/
	void main(void)
/***************************************************************************************
*
*	MAIN PROGRAM
*
*/
{
	// pengaturan clock CPU dan menjaga agar kompatibel dengan versi code vision terdahulu
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

        // set parameter 4800baud, 8, N, 1
        UCSRA=0x00;
	UCSRB=0x10;
	UCSRC=0x06;
	UBRRH=0x00;
	UBRRL=0x8F;

        // set register Analog Comparator
        ACSR=0x80;

        // set register EXT_IRQ_1 (External Interrupt 1 Request), Low Interrupt
	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80;

        // set register Timer 1, System clock 10.8kHz, Timer 1 overflow
	TCCR1B=0x05;

        // set konstanta waktu 5 detik sebagai awalan
        //timer_detik(INITIAL_TIME_C);
        TCNT1H = 0xAB;
        TCNT1L = 0xA0;

        // set interupsi timer untuk Timer 1
        TIMSK=0x80;

        xcount = 0;

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

        // aktifkan interupsi global (berdasar setting register)
        #asm("sei")

        // tidak lakukan apapun selain menunggu interupsi timer1_ovf_isr
        while (1)
        {
        	// blok ini kosong
        };

}	// END OF MAIN PROGRAM
/*
*
*	END OF FILE
*
****************************************************************************************/