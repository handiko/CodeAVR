#include <tiny2313.h>              
#include <delay.h>

#define on      1 
#define ON      1
#define off     0
#define OFF     0  

#define CONST_1200      52
#define CONST_2200      28

#define TX_NOW  PIND.0
#define L_STBY  PORTD.5
#define PTT     PORTD.6 
#define DAC_0   PORTB.0
#define DAC_1   PORTB.1
#define DAC_2   PORTB.2
#define DAC_3   PORTB.3

void protocol(); 
void send_data(char input);
void fliptone();
void set_dac(char value);
void send_tone(int nada);
void send_fcs(char infcs);
void calc_fcs(char in);
void init_clock();
void init_ports();

flash char flag[24] = {               
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E 
        // FLAG
};  
flash char ssid_2 = 0b01100100;
flash char ssid_9 = 0b01110010;
flash char ssid_2final = 0b01100101;
flash char ssid_9final = 0b01110011;
char destination[7] = {         
        0x41,0x50,0x55,0x32,0x35,0x4D,
        0               // SSID 
        // APU25N-2     // 0b011SSSSx format, SSSS = 2 = 0b0010
}; 
char source[7] = {              
        0x59,0x44,0x32,0x58,0x42,0x43,
        0               // SSID    
        // YD2XBC-9     // 0b011SSSSx format, SSSS = 9 = 0b1001
};                                  
char digi[7] = {                
        //0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
        0x57,0x49,0x44,0x45,0x32,
        0,              // SSID
        0x20 
        // WIDE2-2      // 0b011SSSSx format, SSSS = 2 = 0b0010
};
flash char control_field = 0x03;
flash char protocol_id = 0xF0;
flash char data_type = 0x21;
flash char latitude[8] = {
        0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53
        // 0745.79S
};
flash char symbol_table = 0x2F;
flash char longitude[9] = {
        0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
        // 11005.21E
};
flash char symbol_code = 0x3E;
flash char comment[43] = {
        0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
        0x46,0x4F,0x52,0x20,                                    // for(spasi)
        0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
        0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
        0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
        0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
        // testing for emergency beacon
};   
char fcshi;
char fcslo;
char count_1 = 0;
int tone = 1200;
bit flag_state;

void protocol() {
        int i;
            
        for(i=0;i<7;i++) {      
                digi[i] = digi[i] << 1;
                destination[i] = destination[i] << 1;
                source[i] = source[i] << 1;
        }  
        
        destination[6] = ssid_2;
        source[6] = ssid_9;
        digi[5] = ssid_2final;
        
        PTT = on;
        delay_ms(250);
        
        flag_state = 1;
        for(i=0;i<24;i++)       send_data(flag[i]);             // kirim flag 24 kali 
        flag_state = 0;
        for(i=0;i<7;i++)        send_data(destination[i]);      // kirim callsign tujuan
        for(i=0;i<7;i++)        send_data(source[i]);           // kirim callsign asal 
        send_data(ssid_9);
        for(i=0;i<7;i++)        send_data(digi[i]);             // kirim path digi
        send_data(control_field);                               // kirim data control field
        send_data(protocol_id);                                 // kirim data PID
        send_data(data_type);                                   // kirim data type info
        for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
        send_data(symbol_table);                                // kirim simbol tabel
        for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
        send_data(symbol_code);                                 // kirim simbol kode    
        for(i=0;i<43;i++);      send_data(comment[i]);          // kirim komen                            
        send_fcs(fcshi);                                        // kirim 8 MSB dari FCS 
        send_fcs(fcslo);                                        // kirim 8 LSB dari FCS   
        flag_state = 1;
        for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali 
        flag_state = 0; 
        PTT = off;
}

void send_data(char input) {
        int i;
        bit x;
        for(i=0;i<8;i++) {
                x = (input >> i) & 0x01;
                if(!flag_state) calc_fcs(x);
                if(x) {
                        if(!flag_state) count_1++;
                        if(count_1==5)  fliptone();
                        send_tone(tone);
                } 
                if(!x)  fliptone();
        }
}     

void fliptone() {
        count_1 = 0;
        switch(tone) {
                case 1200:      tone=2200;      send_tone(tone);        break;
                case 2200:      tone=1200;      send_tone(tone);        break;
        }
}        

void set_dac(char value) {
        DAC_0 = value & 0x01;
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;
}

void send_tone(int nada) {
        if(nada==1200) {
                set_dac(7);     delay_us(CONST_1200);     
                          
                set_dac(10);    delay_us(CONST_1200);  
                set_dac(13);    delay_us(CONST_1200);      
                set_dac(14);    delay_us(CONST_1200);    
                        
                set_dac(15);    delay_us(CONST_1200); 
                        
                set_dac(14);    delay_us(CONST_1200);
                set_dac(13);    delay_us(CONST_1200); 
                set_dac(10);    delay_us(CONST_1200);
                        
                set_dac(7);     delay_us(CONST_1200);
                        
                set_dac(5);     delay_us(CONST_1200);
                set_dac(2);     delay_us(CONST_1200);
                set_dac(1);     delay_us(CONST_1200);
                        
                set_dac(0);     delay_us(CONST_1200);
                        
                set_dac(1);     delay_us(CONST_1200);
                set_dac(2);     delay_us(CONST_1200);
                set_dac(5);     delay_us(CONST_1200);
        } 
                                   
        else {               
                set_dac(7);     delay_us(CONST_2200);     
                          
                set_dac(10);    delay_us(CONST_2200);  
                set_dac(13);    delay_us(CONST_2200);      
                set_dac(14);    delay_us(CONST_2200);    
                        
                set_dac(15);    delay_us(CONST_2200); 
                        
                set_dac(14);    delay_us(CONST_2200);
                set_dac(13);    delay_us(CONST_2200); 
                set_dac(10);    delay_us(CONST_2200);
                        
                set_dac(7);     delay_us(CONST_2200);
                        
                set_dac(5);     delay_us(CONST_2200);
                set_dac(2);     delay_us(CONST_2200);
                set_dac(1);     delay_us(CONST_2200);
                        
                set_dac(0);     delay_us(CONST_2200);
                        
                set_dac(1);     delay_us(CONST_2200);
                set_dac(2);     delay_us(CONST_2200);
                set_dac(5);     delay_us(CONST_2200);
                
                set_dac(7);     delay_us(CONST_2200);     
                          
                set_dac(10);    delay_us(CONST_2200);  
                set_dac(13);    delay_us(CONST_2200);      
                set_dac(14);    delay_us(CONST_2200);    
                        
                set_dac(15);    delay_us(CONST_2200); 
                        
                set_dac(14);    delay_us(CONST_2200);
                set_dac(13);    delay_us(CONST_2200); 
                set_dac(10);    delay_us(CONST_2200);
                        
                set_dac(7);     delay_us(CONST_2200);
                        
                set_dac(5);     delay_us(CONST_2200);
                set_dac(2);     delay_us(CONST_2200);
                set_dac(1);     delay_us(CONST_2200);
                        
                set_dac(0);     delay_us(CONST_2200);
                        
                set_dac(1);     delay_us(CONST_2200);
                set_dac(2);     delay_us(CONST_2200);
                set_dac(5);     delay_us(CONST_2200);
        }
}    

void send_fcs(char infcs) {
        int j=7;
        bit x;
        while(j>0) {
                x = (infcs >> j) & 0x01; 
                if(x) {
                        count_1++;
                        if(count_1==5)    fliptone();
                        send_tone(tone);
                } 
                if(!x)  fliptone();
                j--;      
        }
}                   

void calc_fcs(char in) {

}

void init_clock() {
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_ 
#pragma optsize+
#endif
}

void init_ports() {
        PORTB=0x00;
        DDRB=0x0F;
        PORTD=0x01;
        DDRD=0x60;
        ACSR=0x80;
        DIDR=0x00;
}