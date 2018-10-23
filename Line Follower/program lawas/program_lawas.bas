$regfile "M16def.dat"
$crystal = 12000000

Dim Ngerem As Bit
Dim Pengerem As Single
Dim Chanel As Byte
Dim Urutan As Byte
Dim Cacah_turun As Byte
Dim Alamat_sens As Byte
Dim Reg As Byte
Dim Reg_kir As Byte
Dim Reg_kan As Byte
Dim Nilai As Integer
Dim Jaga_kir As Integer
Dim Jaga_kan As Integer
Dim Analog As Word
Dim Ambang_sens(8) As Word
Dim Tampilan As String * 7


   Dim Auto_mode As Bit                                     ' Regulator on ?
   Dim Manual_value As Single                               ' Output if not regulating
   Dim Sp As Single                                         ' Setpoint
   Dim Pv As Single                                         ' Process Value
   Dim Cv As Single                                         ' PID output
   Dim Propotional As Single
   Dim Integral As Single
   Dim Derivative As Single
   Dim Last_error As Single                                 ' Startup difference
   Dim Sum_error As Single                                  ' Derrivated delta PV
   Dim Error As Single                                      ' Difference between SP and PV
   Dim Integral_error As Single
   Dim Pterm As Single                                      ' Proportional calculated part
   Dim Iterm As Single                                      ' Integrated calculated part
   Dim Dterm As Single                                      ' Derivated calculated part

   Dim Speed_max As Byte
   Dim Data_speed As Single
   Dim Hasil_kir As Single
   Dim Kecepatan_kir As Byte
   Dim Hasil_kan As Single
   Dim Kecepatan_kan As Byte

   Manual_value = 255                                       ' Output if not regulating = on
   Sp = 0
   Pengerem = 1

Config Adc = Single , Prescaler = Auto
Start Adc
Config Timer1 = Pwm , Pwm = 8 , Prescale = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up
Config Lcd = 16 * 2 ,
Cursor Off Blink
Config Lcdpin = Pin , Rs = Portc.0 , E = Portc.2 , Db4 = Portc.4 , Db5 = Portc.5 , Db6 = Portc.6 , Db7 = Portc.7

Declare Sub Kalibrasi_sens
Declare Sub Cek_sens
Declare Sub Baca_sens
Declare Sub Regulator
Declare Sub Maju
Declare Sub Mundur
Declare Sub Kanan
Declare Sub Kiri
Declare Sub Diam
Declare Sub Seting_propotional
Declare Sub Seting_integral
Declare Sub Seting_derivative

Config Portd.7 = Output
Config Portd.6 = Output
Config Portd.3 = Output
Config Portd.2 = Output

Const Koreksi = 1
Const Alamat_kecepatan = 21
Const Alamat_cacah = 20
Const Alamat_propotional = 22
Const Alamat_integral = 26
Const Alamat_derivative = 30

Reset Portd.7
Pwm1a = 0                                                   'Pwm kanan
Pwm1b = 0                                                   'Pwm kiri
Perdana:
Cls
Upperline
Lcd "    Seting ?    "
Lowerline
Lcd " Yes  |  No "
Waitms 10
Config Pinb.7 = Input                                       'dari pinc ke pinb
Config Pinb.6 = Input
Config Pinb.5 = Input
Config Pinb.4 = Input
Config Pinb.3 = Input
Config Pinb.2 = Input
Config Pinb.1 = Input
Config Pinb.0 = Input

  Set Portb.7                                               'dari portc ke portb
  Set Portb.6
  Set Portb.5
  Set Portb.4
  Set Portb.3
  Set Portb.2
  Set Portb.1
  Set Portb.0
 Do

  If Pinb.5 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Awalnya
  End If

  If Pind.3 = 0 Then
  Waitms 100
  Bitwait Pind.3 , Set
  Goto Set_sens
  End If

  Loop

  Set_sens:
  Cls
  Upperline
  Lcd "Speed | No | PID"                                    ' speed = pinc.3 | No = pinc.4 | PID = pinc.5
  Lowerline
  Lcd "Sensor | Counter"                                    ' Sensor = pinc.2 | counter = Pinc.0
  Waitms 10

  Do
  If Pinb.3 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.3 , Set
  Goto Op_speed
  End If

  If Pinb.5 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Perdana
  End If


  If Pinb.7 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.7 , Set
  Goto Op_pid
  End If

  If Pinb.2 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.2 , Set
  Goto Op_sens
  End If

  If Pinb.6 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.6 , Set
  Goto Op_cacah
  End If

  Loop

  Op_speed:
  Cls
  Upperline
  Lcd "Cancel |      UP"                                    ' cancel = pinb | up = pinb.7
  Lowerline
  Lcd "Ok |      | Down"                                    ' ok = pinb.2     | down = pinb.6
  Waitms 10

  Do
  If Pinb.3 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.3 , Set
  Goto Set_sens
  End If

  If Pinb.7 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.7 , Set
  Incr Speed_max
  Locate 2 , 6
  Lcd Speed_max ; "  "
  Waitms 20
  End If


  If Pinb.6 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.6 , Set
  Decr Speed_max
  Locate 2 , 6
  Lcd Speed_max ; "  "
  Waitms 20
  End If

  If Pinb.2 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.2 , Set
  Writeeeprom Speed_max , Alamat_kecepatan
  Cls
  Upperline
  Lcd "  Speed Maximum "
  Lowerline
  Lcd "Telah Tersimpan "
  Wait 2
  Goto Op_speed
  End If
  Loop

 Op_pid:

   Cls
  Upperline
  Lcd "KP||KI||KD"                                          ' KP = pinc.3 | KI = pinc.4 | KD = pinc.5
  Lowerline
  Lcd "   Exit   "                                          ' Exit = pinc.1
  Waitms 10

  Do

  If Pinb.3 = 0 Then                                        'dari pinc ke pinb
  Waitms 100
  Bitwait Pinb.3 , Set
  Call Seting_propotional
  Goto Op_pid
  End If

  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Call Seting_integral
  Goto Op_pid
  End If


  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Call Seting_derivative
  Goto Op_pid
  End If

  If Pinb.1 = 0 Then
  Waitms 100
  Bitwait Pinb.1 , Set
  Goto Set_sens
  End If
 Loop


  Op_cacah:

  Cls
  Upperline
  Lcd "Cancel |      UP"                                    ' cancel = pinc.3 | up = pinc.7
  Lowerline
  Lcd "Ok |   |    Down"                                    ' ok = pinc.2     | down = pinc.6
  Waitms 10

  Do

  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Goto Set_sens
  End If

  If Pinb.7 = 0 Then
  Waitms 100
  Bitwait Pinb.7 , Set
  If Cacah_turun > 14 Then
  Cacah_turun = 1
  Else
  Incr Cacah_turun
  End If
  Locate 2 , 5
  Lcd Cacah_turun ; " "
  Waitms 20
  End If


  If Pinb.6 = 0 Then
  Waitms 100
  Bitwait Pinb.6 , Set
  If Cacah_turun < 2 Then
  Cacah_turun = 15
  Else
  Decr Cacah_turun
  End If
  Locate 2 , 5
  Lcd Cacah_turun ; " "
  Waitms 20
  End If

  If Pinb.2 = 0 Then
  Waitms 100
  Bitwait Pinb.2 , Set
  Writeeeprom Cacah_turun , Alamat_cacah
  Cls
  Upperline
  Lcd "Penghitung Start"
  Lowerline
  Lcd "Telah Tersimpan "
  Wait 2
  Goto Op_cacah
  End If

  Loop

Op_sens:
  Cls
Lowerline
Lcd " <==   Ok   ==> "
Call Kalibrasi_sens

Awalnya:
Cls
Upperline
Lcd "      Cek ?     "
Lowerline
Lcd " Yes  |  No "
Waitms 10
Do
If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Pertamanya
  End If

  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
Readeeprom Speed_max , Alamat_kecepatan
Readeeprom Cacah_turun , Alamat_cacah
Readeeprom Propotional , Alamat_propotional
Readeeprom Integral , Alamat_integral
Readeeprom Derivative , Alamat_derivative
Goto Pilih_cek
  End If
  Loop

Pilih_cek:
Cls
  Upperline
  Lcd "Speed | NO | PID"                                    ' speed = pinc.3 | no = pinc.5 | PID = pinc.7
  Lowerline
  Lcd "Sensor | Counter"                                    ' Sensor = pinc.2 | counter = Pinc.0
  Waitms 10

  Do
  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Goto Lihat_speed
  End If

  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Awalnya
  End If


  If Pinb.7 = 0 Then
  Waitms 100
  Bitwait Pinb.7 , Set
  Goto Lihat_pid
  End If

  If Pinb.2 = 0 Then
  Waitms 100
  Bitwait Pinb.2 , Set
  Goto Lihat_sens
  End If

  If Pinb.6 = 0 Then
  Waitms 100
  Bitwait Pinb.6 , Set
  Goto Lihat_cacah
  End If

  Loop

Lihat_speed:
 Cls
  Upperline
  Lcd "     " ; Speed_max ; "    "                          ' KP = pinc.3 | KI = pinc.4 | KD = pinc.5
  Lowerline
  Lcd "   Exit   "                                          ' Exit = pinc.0
  Waitms 10

  Do
  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Goto Pilih_cek
  End If
  Loop

Lihat_cacah:
 Cls
  Upperline
  Lcd "     " ; Cacah_turun ; "    "                        ' KP = pinc.3 | KI = pinc.4 | KD = pinc.5
  Lowerline
  Lcd "   Exit  "                                           ' Exit = pinc.0
  Waitms 10

  Do
  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Goto Pilih_cek
  End If
  Loop

  Lihat_pid:

  Tampilan = Fusing(propotional , "#.#####")

 Cls
  Upperline
  Lcd " KP = " ; Tampilan ; "    "
  Lowerline
  Lcd "   Exit| KI  ==>"                                    ' ki = pinc.0
  Waitms 10

  Do
  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Lihat_ki
  End If

  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Goto Pilih_cek
  End If
  Loop

  Lihat_ki:

  Tampilan = Fusing(integral , "#.#####")

 Cls
  Upperline
  Lcd " KI = " ; Tampilan ; "    "
  Lowerline
  Lcd " <==KP | KD  ==>"                                    ' ki = pinc.0
  Waitms 10

  Do
  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Lihat_kd
  End If

  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Goto Lihat_pid
  End If
  Loop

Lihat_kd:

  Tampilan = Fusing(derivative , "#.#####")

 Cls
  Upperline
  Lcd " KD = " ; Tampilan ; "    "
  Lowerline
  Lcd " <==KI | KP  ==>"                                    ' ki = pinc.0
  Waitms 10

  Do
  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Lihat_pid
  End If

  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Goto Lihat_ki
  End If
  Loop

Lihat_sens:
  Chanel = 0
  For Chanel = 0 To 7
  Alamat_sens = Chanel * 2
  Alamat_sens = Alamat_sens + 1
  Urutan = Chanel + 1
  Readeeprom Ambang_sens(urutan) , Alamat_sens
  Next Chanel
  Call Cek_sens
  Goto Pilih_cek

Pertamanya:
Cls
Upperline
Lcd "   Counter ?    "
Lowerline
Lcd " Yes  |  No "
Waitms 10
Readeeprom Cacah_turun , Alamat_cacah

Do
If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Dimulai
  End If

  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Reset Portb.7
  Cls
  While Cacah_turun <> 0
  Locate 1 , 8
  Lcd ; Cacah_turun ; " "
  Wait 1
  Decr Cacah_turun
  Wend
  Goto Dimulai
  End If
Loop

Dimulai:
Cls
Upperline
Lcd "    PADMANABA   "
Lowerline
Lcd "  Robotic Club  "
Waitms 20
Config Portb.7 = Output
Config Portb.6 = Output
Config Portb.5 = Output
Config Portb.4 = Output
Config Portb.3 = Output
Config Portb.2 = Output
Config Portb.1 = Output
Config Portb.0 = Output
Set Portb.7
Chanel = 0
For Chanel = 0 To 7
Alamat_sens = Chanel * 2
Alamat_sens = Alamat_sens + 1
Urutan = Chanel + 1
Readeeprom Ambang_sens(urutan) , Alamat_sens
Next Chanel

Readeeprom Speed_max , Alamat_kecepatan
Data_speed = Speed_max
Readeeprom Propotional , Alamat_propotional
Readeeprom Integral , Alamat_integral
Readeeprom Derivative , Alamat_derivative

Do
Ulang:
Call Baca_sens
Sp = Nilai * 34
If Sp = 0 Then
Call Maju
Waitms 10
Sp = 1
Goto Ulang
End If

Manual_value = Nilai * 17
Manual_value = Abs(manual_value)
Call Regulator
Pv = Pv + Cv                                                ' linear function used
Hasil_kan = 255 - Pv
Hasil_kir = 255 + Pv
'Hasil_kan = 255 - Sp
'Hasil_kir = 255 + Sp
'Print Pv

   If Hasil_kir < 0 Then
   Set Portd.3
   Hasil_kir = Hasil_kir * -1
   Else
   Reset Portd.3
   End If

   If Hasil_kan < 0 Then
   Set Portd.6
   Hasil_kan = Hasil_kan * -1
   Else
   Reset Portd.6
   End If

   If Hasil_kir > Data_speed Then
   Hasil_kir = Data_speed
   'Else
   'Hasil_kir = Manual_value
   End If

   If Hasil_kan > Data_speed Then
   Hasil_kan = Data_speed
   'Else
   'Hasil_kan = Manual_value
   End If

   Kecepatan_kir = Hasil_kir
   Kecepatan_kan = Hasil_kan
   Pwm1a = Kecepatan_kan
   Pwm1b = Kecepatan_kir
   Waitms 20

Loop


'========================Pid====================================
Sub Regulator:

      Error = Sp - Pv
      Pterm = Propotional * Error
      Sum_error = Error - Last_error
      Dterm = Derivative * Sum_error
      Last_error = Error
      Iterm = Integral * Integral_error                     '

      Cv = Pterm + Iterm                                    ' Summing of the tree
      Cv = Cv + Dterm                                       ' calculated terms

     If Cv > 255 Then
       Cv = 255
    Elseif Cv < -255 Then
       Cv = -255
    Else
        Error = Error + Integral_error
        If Error > 255 Then
            Error = 255
        Elseif Error < -255 Then
            Error = -255
        End If
      Integral_error = Error
    End If
End Sub

Sub Maju:
Reset Portd.6
Reset Portd.3
Pwm1a = 255                                                 'Speed_max
Pwm1b = 255                                                 'Speed_max
If Pengerem > 1000 Then Goto Abis_maju
Pengerem = Pengerem * 2
Abis_maju:
End Sub

Sub Mundur:
Set Portd.7
Reset Portd.6
Set Portd.3
Reset Portd.2
Pwm1a = 255
Pwm1b = 255
End Sub

Sub Kiri:
Reset Portd.7
Set Portd.6
Set Portd.3
Reset Portd.2
Pwm1a = 255
Pwm1b = 255
End Sub

Sub Kanan:
Set Portd.7
Reset Portd.6
Reset Portd.3
Set Portd.2
Pwm1a = 255
Pwm1b = 255
End Sub


Sub Baca_sens
Reg = 0
Reg_kir = 0
Reg_kan = 0
Chanel = 0
For Chanel = 0 To 7
Analog = Getadc(chanel)
Urutan = Chanel + 1

If Chanel = 0 And Analog < Ambang_sens(urutan) Then
Set Reg.7
Set Reg_kir.3
End If

If Chanel = 1 And Analog < Ambang_sens(urutan) Then
Set Reg.6
Set Reg_kir.2
End If

If Chanel = 2 And Analog < Ambang_sens(urutan) Then
Set Reg.5
Set Reg_kir.1
End If

If Chanel = 3 And Analog < Ambang_sens(urutan) Then
Set Reg.4
Set Reg_kir.0
End If

If Chanel = 4 And Analog < Ambang_sens(urutan) Then
Set Reg.3
Set Reg_kan.0
End If

If Chanel = 5 And Analog < Ambang_sens(urutan) Then
Set Reg.2
Set Reg_kan.1
End If

If Chanel = 6 And Analog < Ambang_sens(urutan) Then
Set Reg.1
Set Reg_kan.2
End If

If Chanel = 7 And Analog < Ambang_sens(urutan) Then
Set Reg.0
Set Reg_kan.3
End If

Next Chanel

If Reg_kir > 0 Then

End If

If Reg_kan > 0 Then
End If

If Reg_kir > Reg_kan Then Nilai = -15
If Reg_kan > Reg_kir Then Nilai = 15
If Reg_kan = Reg_kir Then Nilai = 1

If Reg = &B00001000 Then Nilai = 1
If Reg = &B00111100 Then Nilai = 1
If Reg = &B00011110 Then Nilai = 3
If Reg = &B00001111 Then Nilai = 5
If Reg = &B00000100 Then Nilai = 5
If Reg = &B00000111 Then Nilai = 7
If Reg = &B00000011 Then Nilai = 9
If Reg = &B00000010 Then Nilai = 8
If Reg = &B00000011 Then Nilai = 11
If Reg = &B00000001 Then Nilai = 13

If Reg = &B00010000 Then Nilai = -1
If Reg = &B00111100 Then Nilai = -1
If Reg = &B01111000 Then Nilai = -3
If Reg = &B11110000 Then Nilai = -5
If Reg = &B00100000 Then Nilai = -5
If Reg = &B11100000 Then Nilai = -7
If Reg = &B11000000 Then Nilai = -9
If Reg = &B01000000 Then Nilai = -8
If Reg = &B11000000 Then Nilai = -11
If Reg = &B10000000 Then Nilai = -13

If Reg_kir > Reg_kan Then Nilai = -15
If Reg_kan > Reg_kir Then Nilai = 15

If Reg = &B00011000 Or Reg = &B11111111 Or Reg = &B00111100 Then
Nilai = 0
Ngerem = 1
End If

If Reg > &B00000000 And Reg < &B11111111 Then
Jaga_kir = Reg_kir
Jaga_kan = Reg_kan
End If

If Nilai = 0 Then                                           '
Ngerem = 1
If Pengerem >= 1000 Then Goto Abis_ngerem
Incr Pengerem
Else
If Pengerem <= 0 Then
Pengerem = 0
Goto Abis_ngerem
End If
Pengerem = Pengerem - 100
Abis_ngerem:
End If

If Reg = &B00000000 Then
'If Jaga_kir > Jaga_kan Then Nilai = -13
'If Jaga_kan > Jaga_kir Then Nilai = 13
If Ngerem = 1 Then
Set Portd.6
Set Portd.3
Pengerem = Abs(pengerem)
Pwm1a = Speed_max
Pwm1b = Speed_max
'While Pengerem <> 0
'Decr Pengerem
Waitms 50
'Wend
Pwm1a = 0
Pwm1b = 0
Waitms 20
End If
Ngerem = 0
Reset Portb.7
Else
Set Portb.7
End If
End Sub

Sub Kalibrasi_sens:

Config Pinb.4 = Input
  Set Portb.4
  Do

  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Incr Chanel
  If Chanel >= 8 And Chanel <= 10 Then
  Chanel = 0
  End If
  End If

  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Decr Chanel
  If Chanel >= 253 Then
  Chanel = 7
  End If
  End If

  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Analog = Getadc(chanel)
  Alamat_sens = Chanel * 2
  Alamat_sens = Alamat_sens + 1
  Analog = Analog + 20
  Writeeeprom Analog , Alamat_sens
   Upperline
   Lcd " <==  Exit  ==> "
   Waitms 200
Do
  If Pinb.4 = 0 Then
  Waitms 100
  Bitwait Pinb.4 , Set
  Goto Usai_kalibrasi
  End If

  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Incr Chanel
  If Chanel = 8 Then
  Chanel = 0
  End If
  Upperline
   Lcd "                "
   Waitms 20
  Goto Usai_simpan
  End If

  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Decr Chanel
  If Chanel = 255 Then
  Chanel = 7
  End If
  Upperline
   Lcd "                "
   Waitms 20
  Goto Usai_simpan
  End If
Loop
  End If

Usai_simpan:
   Analog = Getadc(chanel)

   Upperline
   Lcd Analog ; "    " ; Chanel ; "    "
   Waitms 20

Loop
Usai_kalibrasi:
End Sub

'========================Cek==================
Sub Cek_sens :
Cls
Upperline
Lcd "    00000000    "
Lowerline
Lcd "    76543210 Ex>"
Waitms 20                                                   '
  Do

  If Pinb.5 = 0 Then
  Waitms 100
  Bitwait Pinb.5 , Set
  Goto Usai_cek
  End If
Chanel = 0
For Chanel = 0 To 7
Analog = Getadc(chanel)
Urutan = Chanel + 1
If Chanel = 0 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 12
Lcd "1"
Waitms 10
Else
Locate 1 , 12
Lcd "0"
Waitms 10
End If
End If

If Chanel = 1 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 11
Lcd "1"
Waitms 10
Else
Locate 1 , 11
Lcd "0"
Waitms 10
End If
End If

If Chanel = 2 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 10
Lcd "1"
Waitms 10
Else
Locate 1 , 10
Lcd "0"
Waitms 10
End If
End If

If Chanel = 3 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 9
Lcd "1"
Waitms 10
Else
Locate 1 , 9
Lcd "0"
Waitms 10
End If
End If

If Chanel = 4 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 8
Lcd "1"
Waitms 10
Else
Locate 1 , 8
Lcd "0"
Waitms 10
End If
End If

If Chanel = 5 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 7
Lcd "1"
Waitms 10
Else
Locate 1 , 7
Lcd "0"
Waitms 10
End If
End If

If Chanel = 6 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 6
Lcd "1"
Waitms 10
Else
Locate 1 , 6
Lcd "0"
Waitms 10
End If
End If

If Chanel = 7 Then
If Analog < Ambang_sens(urutan) Then
Locate 1 , 5
Lcd "1"
Waitms 10
Else
Locate 1 , 5
Lcd "0"
Waitms 10
End If
End If

Next Chanel

Loop
Usai_cek:
End Sub
'===================================Seting Propotional============================================
Sub Seting_propotional:
Awal_propotional:
 Cls
  Upperline
  Lcd "Cancel | KP | UP"                                    ' cancel = pinc.3 | up = pinc.7
  Lowerline
  Lcd "Ok |      | Down"                                    ' ok = pinc.2     | down = pinc.6
  Waitms 10


  Do
  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Goto Abis_propotional
  End If

  If Pinb.7 = 0 Then
  Incr Propotional
  Locate 2 , 5
  Lcd "." ; Propotional ; " "
  Waitms 20
  End If


  If Pinb.6 = 0 Then
  Decr Propotional
  Locate 2 , 5
  Lcd "." ; Propotional ; " "
  Waitms 20
  End If

  If Pinb.2 = 0 Then
  Waitms 100
  Bitwait Pinb.2 , Set
  If Propotional > 0 And Propotional < 10 Then
  Propotional = Propotional / 10
  End If

  If Propotional >= 10 And Propotional < 100 Then
  Propotional = Propotional / 100
  End If

  If Propotional >= 100 And Propotional < 1000 Then
  Propotional = Propotional / 1000
  End If

  If Propotional >= 1000 And Propotional < 10000 Then
  Propotional = Propotional / 10000
  End If

  Writeeeprom Propotional , Alamat_propotional
  Cls
  Upperline
  Lcd "   Propotional  "
  Lowerline
  Lcd "Telah Tersimpan "
  Wait 2
  Goto Awal_propotional
  End If
  Loop

  Abis_propotional:
  End Sub

'=======================Seting Integral============================
Sub Seting_integral:
Awal_integral:
 Cls
  Upperline
  Lcd "Cancel | KI | UP"                                    ' cancel = pinc.3 | up = pinc.7
  Lowerline
  Lcd "Ok |      | Down"                                    ' ok = pinc.2     | down = pinc.6
  Waitms 10


  Do
  If Pinb.3 = 0 Then
  Waitms 20
  Bitwait Pinb.3 , Set
  Goto Abis_integral
  End If

  If Pinb.7 = 0 Then
  Incr Integral
  Locate 2 , 5
  Lcd "." ; Integral ; " "
  Waitms 20
  End If


  If Pinb.6 = 0 Then
  Decr Integral
  Locate 2 , 5
  Lcd "." ; Integral ; " "
  Waitms 100
  End If

  If Pinb.2 = 0 Then
  Waitms 100
  Bitwait Pinb.2 , Set
  If Integral > 0 And Integral < 10 Then
  Integral = Integral / 10
  End If

  If Integral >= 10 And Integral < 100 Then
  Integral = Integral / 100
  End If

  If Integral >= 100 And Integral < 1000 Then
  Integral = Integral / 1000
  End If

  If Integral >= 1000 And Integral < 10000 Then
  Integral = Integral / 10000
  End If
  Writeeeprom Integral , Alamat_integral
  Cls
  Upperline
  Lcd "    Integral    "
  Lowerline
  Lcd "Telah Tersimpan "
  Wait 2
  Goto Awal_integral
  End If
  Loop

  Abis_integral:
  End Sub

'=======================Seting Derivative============================
Sub Seting_derivative:
Awal_derivative:
 Cls
  Upperline
  Lcd "Cancel | KD | UP"                                    ' cancel = pinc.3 | up = pinc.7
  Lowerline
  Lcd "Ok |      | Down"                                    ' ok = pinc.2     | down = pinc.6
  Waitms 10


  Do
  If Pinb.3 = 0 Then
  Waitms 100
  Bitwait Pinb.3 , Set
  Goto Abis_derivative
  End If

  If Pinb.7 = 0 Then
  Incr Derivative
  Locate 2 , 5
  Lcd "." ; Derivative ; " "
  Waitms 20
  End If


  If Pinb.6 = 0 Then
  Decr Derivative
  Locate 2 , 5
  Lcd "." ; Derivative ; " "
  Waitms 20
  End If

  If Pinb.2 = 0 Then
  Waitms 100
  Bitwait Pinb.2 , Set

  If Derivative > 0 And Derivative < 10 Then
  Derivative = Derivative / 10
  End If

  If Derivative >= 10 And Derivative < 100 Then
  Derivative = Derivative / 100
  End If

  If Derivative >= 100 And Derivative < 1000 Then
  Derivative = Derivative / 1000
  End If

  If Derivative >= 1000 And Derivative < 10000 Then
  Derivative = Derivative / 10000
  End If

  Writeeeprom Derivative , Alamat_derivative
  Cls
  Upperline
  Lcd "   Derivative   "
  Lowerline
  Lcd "Telah Tersimpan "
  Wait 2
  Goto Awal_derivative
  End If
  Loop

  Abis_derivative:
  End Sub