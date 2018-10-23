

			0123456789ABCDEF
			
		0	 255 255			//1,0   5,0
		1	   01100000			//3,1 - 10,1
		
		
			0123456789ABCDEF
			
		0	 255 255			//1,0   5,0
		1	   01100000			//3,1 - 10,1

======================================================================		
			 0123456789ABCDEF
			__________________
		0	|   Blue Biru	 |
		1	| 	   by : 	 |
			------------------

			 0123456789ABCDEF
			__________________
		0	| Dionysius Ivan |
		1	| Handiko Gesang |
			------------------
		
			 0123456789ABCDEF
			__________________
		0	|   LPKTA - UGM	 |
		1	| 	  2011	     |
			------------------
======================================================================
menu();
	
			0123456789ABCDEF
			
		0	 Start..!!						UP
		1	 Y:OK   N:UP	

			0123456789ABCDEF
			
		0	>> Set PID						OK
		1	   Set Speed	

				0123456789ABCDEF
			
			0	>>Kp   Ki   Kd				OK
			1	 020  020  020

					0123456789ABCDEF
			
				0	 Set Kp:				OK
				1	 020

					0123456789ABCDEF
			
				0	 Rekam EEPROM..	
				1	
		
				0123456789ABCDEF
			
			0	  Kp >>Ki   Kd				OK
			1	 020  020  020
		
					0123456789ABCDEF
			
				0	 Set Ki:				OK
				1	 020
		
					0123456789ABCDEF
			
				0	 Rekam EEPROM..	
				1	
			
				0123456789ABCDEF
			
			0	  Kp   Ki >>Kd				OK
			1	 020  020  020
		
					0123456789ABCDEF
			
				0	 Set Kd:				OK
				1	 020

					0123456789ABCDEF
			
				0	 Rekam EEPROM..
				1	
		
				0123456789ABCDEF
			
			0	>>Kp   Ki   Kd				BACK
			1	 020  020  020
		
			0123456789ABCDEF
			
		0	>> Set PID						DOWN
		1	   Set Speed

			0123456789ABCDEF
			
		0	   Set PID						OK
		1	>> Set Speed	

				0123456789ABCDEF
			
			0	>>Makz   Minz 				OK
			1	  255    000

					0123456789ABCDEF
			
				0	  Makz :				OK
				1	  255	

					0123456789ABCDEF
			
				0	 Rekam EEPROM..
				1	
		
				0123456789ABCDEF
			
			0	  Makz >>Minz 				OK
			1	  255    000

					0123456789ABCDEF
			
				0	  Minz :				OK
				1	  000

					0123456789ABCDEF
			
				0	 Rekam EEPROM..
				1	
				
				0123456789ABCDEF
			
			0	>>Makz   Minz 				BACK
			1	  255    000

			0123456789ABCDEF
			
		0	   Set PID						DOWN
		1	>> Set Speed	
		
			0123456789ABCDEF
			
		0	>> Set Garis					OK
		1	   Test Mode

				0123456789ABCDEF
			
			0	>> Warna : Putih			OK
			1	   Sensor: 1

					0123456789ABCDEF
			
				0	 Warna Garis :			OK
				1	 Putih

					0123456789ABCDEF
			
				0	 Rekam EEPROM..
				1	

				0123456789ABCDEF
			
			0	   Warna : Putih			OK
			1	>> Sensor: 1

					0123456789ABCDEF
			
				0	 Sensor Garis :			OK
				1	 1		

					0123456789ABCDEF
			
				0	 Rekam EEPROM..
				1	
		
				0123456789ABCDEF
			
			0	>> Warna : Putih			BACK
			1	   Sensor: 1
		
			0123456789ABCDEF
			
		0	>> Set Garis					DOWN
		1	   Test Mode


			0123456789ABCDEF
			
		0	   Set Garis					OK		
		1	>> Test Mode	

				0123456789ABCDEF
			
			0	>> Auto Scan				OK
			1	   Sens Test
			
					0123456789ABCDEF
			
				0							OK
				1	 00011000  0000
				
					0123456789ABCDEF
			
				0	 Rekam EEPROM 			OK
				1	

				0123456789ABCDEF
			
			0	>> Auto Scan				DOWN
			1	   Sens Test
			
				0123456789ABCDEF
			
			0	   Auto Scan				OK
			1	>> Sens Test

					0123456789ABCDEF
			
				0							OK
				1	 00011000  0000
				
				0123456789ABCDEF
			
			0	   Auto Scan				DOWN
			1	>> Sens Test
		
				0123456789ABCDEF
			
			0	>> PWM Test					OK
			1	   Cek ADC
			
					0123456789ABCDEF
			
				0	 255 255				OK
				1	 
				
				0123456789ABCDEF
			
			0	>> PWM Test					DOWN
			1	   Cek ADC

				0123456789ABCDEF
			
			0	   PWM Test					OK
			1	>> Cek ADC
			
					0123456789ABCDEF
			
				0	155 105 198 188			OK
				1    150 122 178 135

				0123456789ABCDEF
			
			0	   PWM Test					DOWN
			1	>> Cek ADC
			
				0123456789ABCDEF
			
			0   >> Maintenance				OK
			1      Expandable
			
					0123456789ABCDEF
			
				0	 000 100				OK/DELAY 3 DETIK
				1	 Pivot kiri
		
					0123456789ABCDEF
			
				0	 100 000				OK/DELAY 3 DETIK
				1	 Pivot kanan
		
					0123456789ABCDEF
			
				0	 100 100				OK/DELAY 3 DETIK
				1	 Maju
		
					0123456789ABCDEF
			
				0	 050 050				OK/DELAY 3 DETIK
				1	 Mundur
		
					0123456789ABCDEF
			
				0	 Led Blink 2 X			OK/DELAY 
				1	
		
					0123456789ABCDEF
			
				0	 Line Following			
				1	
		
					0123456789ABCDEF
			
				0	 255 255				OK/DELAY 1 MENIT
				1	 00011000  0000	
		
				0123456789ABCDEF
			
			0   >> Maintenance				DOWN
			1      Expandable
		
				0123456789ABCDEF
			
			0      Maintenance				OK
			1   >> Expandable
		
					0123456789ABCDEF
			
				0	 Masih Kosong			BACK
				1	 ............
		
				0123456789ABCDEF
			
			0      Maintenance				BACK
			1   >> Expandable

			0123456789ABCDEF
			
		0	   Set Garis					DOWN
		1	>> Test mode		

			0123456789ABCDEF
			
		0	 Start..!!						OK
		1	 Y:OK   N:UP		

				0123456789ABCDEF
			
			0	 Line Following			
			1	

				0123456789ABCDEF
			
			0	 255 255					
			1	 00011000  0000

			
			
			
			
			
			
			
			
			
			