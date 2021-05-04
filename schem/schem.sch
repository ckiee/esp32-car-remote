EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Driver_Motor:DRV8833PW U2
U 1 1 605F436D
P 4600 3300
F 0 "U2" H 4600 2511 50  0000 C CNN
F 1 "DRV8833PW" H 4600 2420 50  0000 C CNN
F 2 "Package_SO:TSSOP-16_4.4x5mm_P0.65mm" H 5050 3750 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/drv8833.pdf" H 4450 3850 50  0001 C CNN
	1    4600 3300
	1    0    0    -1  
$EndComp
$Comp
L RF_Module:ESP32-WROOM-32 U1
U 1 1 605F4B4D
P 3000 3550
F 0 "U1" H 3000 5131 50  0000 C CNN
F 1 "ESP32-WROOM-32" H 3000 5040 50  0000 C CNN
F 2 "RF_Module:ESP32-WROOM-32" H 3000 2050 50  0001 C CNN
F 3 "https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32_datasheet_en.pdf" H 2700 3600 50  0001 C CNN
	1    3000 3550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 605F9458
P 3000 4950
F 0 "#PWR0101" H 3000 4700 50  0001 C CNN
F 1 "GND" H 3005 4777 50  0000 C CNN
F 2 "" H 3000 4950 50  0001 C CNN
F 3 "" H 3000 4950 50  0001 C CNN
	1    3000 4950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 605F96AE
P 4600 4000
F 0 "#PWR0102" H 4600 3750 50  0001 C CNN
F 1 "GND" H 4605 3827 50  0000 C CNN
F 2 "" H 4600 4000 50  0001 C CNN
F 3 "" H 4600 4000 50  0001 C CNN
	1    4600 4000
	1    0    0    -1  
$EndComp
$Comp
L Motor:Motor_DC M1
U 1 1 605F9CE3
P 5750 3400
F 0 "M1" V 6045 3350 50  0000 C CNN
F 1 "Motor_DC" V 5954 3350 50  0000 C CNN
F 2 "" H 5750 3310 50  0001 C CNN
F 3 "~" H 5750 3310 50  0001 C CNN
	1    5750 3400
	0    -1   -1   0   
$EndComp
$Comp
L Motor:Motor_DC M2
U 1 1 605FB575
P 5750 3650
F 0 "M2" V 6045 3600 50  0000 C CNN
F 1 "Motor_DC" V 5954 3600 50  0000 C CNN
F 2 "" H 5750 3560 50  0001 C CNN
F 3 "~" H 5750 3560 50  0001 C CNN
	1    5750 3650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5200 3400 5550 3400
Wire Wire Line
	5200 3500 5550 3500
Wire Wire Line
	5550 3500 5550 3650
$Comp
L power:GND #PWR0103
U 1 1 605FCB8B
P 6050 3400
F 0 "#PWR0103" H 6050 3150 50  0001 C CNN
F 1 "GND" H 6055 3227 50  0000 C CNN
F 2 "" H 6050 3400 50  0001 C CNN
F 3 "" H 6050 3400 50  0001 C CNN
	1    6050 3400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 605FCEA5
P 6050 3650
F 0 "#PWR0104" H 6050 3400 50  0001 C CNN
F 1 "GND" H 6055 3477 50  0000 C CNN
F 2 "" H 6050 3650 50  0001 C CNN
F 3 "" H 6050 3650 50  0001 C CNN
	1    6050 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 4050 3850 4050
Wire Wire Line
	3850 4050 3850 3400
Wire Wire Line
	3850 3400 4000 3400
Wire Wire Line
	4000 3500 3900 3500
Wire Wire Line
	3900 3500 3900 4150
Wire Wire Line
	3900 4150 3600 4150
Wire Wire Line
	4800 2600 4850 2600
Wire Wire Line
	4850 2600 4850 2550
Connection ~ 4850 2600
Wire Wire Line
	4850 2600 4900 2600
$Comp
L power:VCC #PWR0105
U 1 1 606039A0
P 4850 2550
F 0 "#PWR0105" H 4850 2400 50  0001 C CNN
F 1 "VCC" H 4865 2723 50  0000 C CNN
F 2 "" H 4850 2550 50  0001 C CNN
F 3 "" H 4850 2550 50  0001 C CNN
	1    4850 2550
	1    0    0    -1  
$EndComp
$Comp
L pspice:DIODE D1
U 1 1 606097AD
P 3200 2150
F 0 "D1" H 3200 1885 50  0000 C CNN
F 1 "DIODE" H 3200 1976 50  0000 C CNN
F 2 "" H 3200 2150 50  0001 C CNN
F 3 "~" H 3200 2150 50  0001 C CNN
	1    3200 2150
	-1   0    0    1   
$EndComp
$Comp
L power:VCC #PWR0106
U 1 1 60609D06
P 3400 2150
F 0 "#PWR0106" H 3400 2000 50  0001 C CNN
F 1 "VCC" H 3415 2323 50  0000 C CNN
F 2 "" H 3400 2150 50  0001 C CNN
F 3 "" H 3400 2150 50  0001 C CNN
	1    3400 2150
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0107
U 1 1 6060E075
P 4000 2900
F 0 "#PWR0107" H 4000 2750 50  0001 C CNN
F 1 "VCC" H 4015 3073 50  0000 C CNN
F 2 "" H 4000 2900 50  0001 C CNN
F 3 "" H 4000 2900 50  0001 C CNN
	1    4000 2900
	1    0    0    -1  
$EndComp
NoConn ~ 4000 3000
Wire Wire Line
	4000 3100 4000 3200
$Comp
L power:GND #PWR0108
U 1 1 60610679
P 4000 3200
F 0 "#PWR0108" H 4000 2950 50  0001 C CNN
F 1 "GND" H 4005 3027 50  0000 C CNN
F 2 "" H 4000 3200 50  0001 C CNN
F 3 "" H 4000 3200 50  0001 C CNN
	1    4000 3200
	1    0    0    -1  
$EndComp
Connection ~ 4000 3200
NoConn ~ 5200 3200
$EndSCHEMATC