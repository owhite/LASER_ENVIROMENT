EESchema Schematic File Version 4
LIBS:laser_flow-cache
EELAYER 30 0
EELAYER END
$Descr User 7000 6000
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
Text GLabel 1155 1070 0    50   Input ~ 0
GND
Text GLabel 1155 1970 0    50   Input ~ 0
GP_3
Text GLabel 1155 2070 0    50   Input ~ 0
GP_1
Wire Wire Line
	1230 1070 1155 1070
Wire Wire Line
	1230 1970 1155 1970
Wire Wire Line
	1230 2070 1155 2070
$Comp
L Switch:SW_Push PB1
U 1 1 5E615932
P 5960 3210
F 0 "PB1" H 5960 3495 50  0000 C CNN
F 1 "SW_Push" H 5960 3404 50  0000 C CNN
F 2 "Button_Switch_SMD:SW_SPST_TL3342" H 5960 3410 50  0001 C CNN
F 3 "~" H 5960 3410 50  0001 C CNN
	1    5960 3210
	1    0    0    -1  
$EndComp
Text GLabel 5710 3210 0    50   Input ~ 0
+3.3v
$Comp
L Device:R R4
U 1 1 5E6163C4
P 5830 3570
F 0 "R4" H 5680 3615 50  0000 L CNN
F 1 "10k" H 5645 3520 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 5760 3570 50  0001 C CNN
F 3 "https://www.mouser.com/ProductDetail/ROHM-Semiconductor/ESR10EZPF5102?qs=DyUWGjl%252BcVsMTSBF51O24w%3D%3D" H 5830 3570 50  0001 C CNN
F 4 "755-ESR10EZPF5102" H 5830 3570 50  0001 C CNN "P/N"
F 5 "11" H 5830 3570 50  0001 C CNN "Group#"
	1    5830 3570
	1    0    0    -1  
$EndComp
Wire Wire Line
	5760 3210 5710 3210
Text GLabel 1160 3070 0    50   Input ~ 0
PB_IN
Text GLabel 1195 3670 0    50   Input ~ 0
LED1
Wire Wire Line
	1195 3670 1230 3670
Wire Wire Line
	1230 3070 1160 3070
Text GLabel 1155 1570 0    50   Input ~ 0
F_DATA
Wire Wire Line
	1230 1570 1155 1570
Text GLabel 1155 2170 0    50   Input ~ 0
GP_4
Wire Wire Line
	1230 2170 1155 2170
Text GLabel 1155 3770 0    50   Input ~ 0
SPK_SIG
Wire Wire Line
	1230 3770 1155 3770
$Comp
L teensy:Teensy3.2 U1
U 1 1 5E2C5940
P 2230 2420
F 0 "U1" H 2230 4057 60  0000 C CNN
F 1 "Teensy3.2" H 2230 3951 60  0000 C CNN
F 2 "teensy:Teensy32" H 2230 1670 60  0000 C CNN
F 3 "" H 2230 1670 60  0000 C CNN
	1    2230 2420
	1    0    0    -1  
$EndComp
Text GLabel 5820 1170 2    50   Input ~ 0
GND
Wire Wire Line
	5820 1170 5740 1170
$Comp
L Device:R R1
U 1 1 5E39B165
P 5590 1170
F 0 "R1" H 5440 1215 50  0000 L CNN
F 1 "4.7k" H 5405 1120 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 5520 1170 50  0001 C CNN
F 3 "https://www.mouser.com/ProductDetail/ROHM-Semiconductor/ESR10EZPF5102?qs=DyUWGjl%252BcVsMTSBF51O24w%3D%3D" H 5590 1170 50  0001 C CNN
F 4 "755-ESR10EZPF5102" H 5590 1170 50  0001 C CNN "P/N"
F 5 "11" H 5590 1170 50  0001 C CNN "Group#"
	1    5590 1170
	0    1    1    0   
$EndComp
Text GLabel 5010 1170 0    50   Input ~ 0
+3.3v
Wire Wire Line
	5010 1170 5050 1170
$Comp
L Connector_Generic:Conn_01x03 NEOPIX1
U 1 1 5E667E5C
P 3830 1185
F 0 "NEOPIX1" V 3940 1350 50  0000 R CNN
F 1 "Conn_01x03" V 3703 897 50  0001 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 3830 1185 50  0001 C CNN
F 3 "~" H 3830 1185 50  0001 C CNN
	1    3830 1185
	-1   0    0    -1  
$EndComp
Text GLabel 4080 1185 2    50   Input ~ 0
NP_DATA
Wire Wire Line
	4080 1185 4030 1185
Text GLabel 1160 2270 0    50   Input ~ 0
GP_2
Text GLabel 1165 1770 0    50   Input ~ 0
T_DATA
Text GLabel 1165 1670 0    50   Input ~ 0
NP_DATA
Wire Wire Line
	1165 1770 1230 1770
Wire Wire Line
	1165 1670 1230 1670
$Comp
L CDS-13138-SMT-TR:CDS-13138-SMT-TR LS1
U 1 1 5EA88990
P 4470 2350
F 0 "LS1" H 5170 2615 50  0000 C CNN
F 1 "CDS-13138-SMT-TR" H 5170 2524 50  0000 C CNN
F 2 "CDS13138SMTTR" H 5720 2450 50  0001 L CNN
F 3 "" H 5720 2350 50  0001 L CNN
F 4 "Speakers & Transducers 0.7W 8 Ohm 850Hz SMT 13mm sq mylar SM2CO" H 5720 2250 50  0001 L CNN "Description"
F 5 "4.2" H 5720 2150 50  0001 L CNN "Height"
F 6 "" H 5720 2050 50  0001 L CNN "Mouser2 Part Number"
F 7 "" H 5720 1950 50  0001 L CNN "Mouser2 Price/Stock"
F 8 "CUI Devices" H 5720 1850 50  0001 L CNN "Manufacturer_Name"
F 9 "CDS-13138-SMT-TR" H 5720 1750 50  0001 L CNN "Manufacturer_Part_Number"
	1    4470 2350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5EADF974
P 5200 1170
F 0 "D1" H 5193 1386 50  0001 C CNN
F 1 "LED" H 5193 1295 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5200 1170 50  0001 C CNN
F 3 "~" H 5200 1170 50  0001 C CNN
	1    5200 1170
	-1   0    0    1   
$EndComp
$Comp
L Connector:RJ45 J1
U 1 1 5EAE2741
P 4260 3360
F 0 "J1" H 4317 4027 50  0000 C CNN
F 1 "RJ45" H 4317 3936 50  0000 C CNN
F 2 "Connector_RJ:my_RJ45_Amphenol" V 4260 3385 50  0001 C CNN
F 3 "~" V 4260 3385 50  0001 C CNN
	1    4260 3360
	1    0    0    1   
$EndComp
Text GLabel 4080 1085 2    50   Input ~ 0
+5v
Wire Wire Line
	4080 1085 4030 1085
Text GLabel 4080 1285 2    50   Input ~ 0
GND
Wire Wire Line
	4080 1285 4030 1285
$Comp
L Connector_Generic:Conn_01x03 TEMP1
U 1 1 5EAF2293
P 3830 1535
F 0 "TEMP1" V 3940 1670 50  0000 R CNN
F 1 "Conn_01x03" V 3703 1247 50  0001 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 3830 1535 50  0001 C CNN
F 3 "~" H 3830 1535 50  0001 C CNN
	1    3830 1535
	-1   0    0    -1  
$EndComp
Text GLabel 4080 1535 2    50   Input ~ 0
+5v
Wire Wire Line
	4080 1535 4030 1535
Text GLabel 4080 1435 2    50   Input ~ 0
T_DATA
Wire Wire Line
	4080 1435 4030 1435
Text GLabel 4080 1635 2    50   Input ~ 0
GND
Wire Wire Line
	4080 1635 4030 1635
$Comp
L Connector_Generic:Conn_01x03 FLOW1
U 1 1 5EAF40EA
P 3830 1885
F 0 "FLOW1" V 3940 2020 50  0000 R CNN
F 1 "Conn_01x03" V 3703 1597 50  0001 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 3830 1885 50  0001 C CNN
F 3 "~" H 3830 1885 50  0001 C CNN
	1    3830 1885
	-1   0    0    -1  
$EndComp
Text GLabel 4080 1885 2    50   Input ~ 0
F_DATA
Wire Wire Line
	4080 1885 4030 1885
Text GLabel 4080 1785 2    50   Input ~ 0
+5v
Wire Wire Line
	4080 1785 4030 1785
Text GLabel 4080 1985 2    50   Input ~ 0
GND
Wire Wire Line
	4080 1985 4030 1985
Wire Wire Line
	5830 3420 5830 3370
Wire Wire Line
	5830 3370 5710 3370
Text GLabel 5710 3370 0    50   Input ~ 0
PB_IN
Wire Wire Line
	5710 3780 5830 3780
Wire Wire Line
	5830 3780 5830 3720
Text GLabel 5710 3780 0    50   Input ~ 0
GND
Wire Wire Line
	6160 3210 6190 3210
Wire Wire Line
	6190 3210 6190 3370
Wire Wire Line
	6190 3370 5830 3370
Connection ~ 5830 3370
Wire Wire Line
	5350 1170 5440 1170
Text GLabel 5820 1410 2    50   Input ~ 0
LED1
Wire Wire Line
	5820 1410 5740 1410
$Comp
L Device:R R2
U 1 1 5EB24990
P 5590 1410
F 0 "R2" H 5440 1455 50  0000 L CNN
F 1 "4.7k" H 5405 1360 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 5520 1410 50  0001 C CNN
F 3 "https://www.mouser.com/ProductDetail/ROHM-Semiconductor/ESR10EZPF5102?qs=DyUWGjl%252BcVsMTSBF51O24w%3D%3D" H 5590 1410 50  0001 C CNN
F 4 "755-ESR10EZPF5102" H 5590 1410 50  0001 C CNN "P/N"
F 5 "11" H 5590 1410 50  0001 C CNN "Group#"
	1    5590 1410
	0    1    1    0   
$EndComp
Text GLabel 5010 1410 0    50   Input ~ 0
+3.3v
Wire Wire Line
	5010 1410 5050 1410
$Comp
L Device:LED D2
U 1 1 5EB24998
P 5200 1410
F 0 "D2" H 5193 1626 50  0001 C CNN
F 1 "LED" H 5193 1535 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5200 1410 50  0001 C CNN
F 3 "~" H 5200 1410 50  0001 C CNN
	1    5200 1410
	-1   0    0    1   
$EndComp
Wire Wire Line
	5350 1410 5440 1410
$Comp
L Device:R R5
U 1 1 5EB28B32
P 4220 2450
F 0 "R5" H 4070 2495 50  0000 L CNN
F 1 "10k" H 4035 2400 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 4150 2450 50  0001 C CNN
F 3 "https://www.mouser.com/ProductDetail/ROHM-Semiconductor/ESR10EZPF5102?qs=DyUWGjl%252BcVsMTSBF51O24w%3D%3D" H 4220 2450 50  0001 C CNN
F 4 "755-ESR10EZPF5102" H 4220 2450 50  0001 C CNN "P/N"
F 5 "11" H 4220 2450 50  0001 C CNN "Group#"
	1    4220 2450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4470 2450 4370 2450
Text GLabel 4000 2450 0    50   Input ~ 0
SPK_SIG
Wire Wire Line
	4070 2450 4000 2450
Text GLabel 5960 2450 2    50   Input ~ 0
GND
Wire Wire Line
	5960 2450 5870 2450
Wire Wire Line
	4660 3060 4760 3060
Wire Wire Line
	4660 3160 4760 3160
Wire Wire Line
	4660 3260 4760 3260
Wire Wire Line
	4660 3360 4760 3360
Wire Wire Line
	4660 3460 4760 3460
Wire Wire Line
	4660 3560 4760 3560
Wire Wire Line
	4660 3660 4760 3660
Wire Wire Line
	4660 3760 4760 3760
Text GLabel 4760 3060 2    50   Input ~ 0
GND
Text GLabel 4760 3160 2    50   Input ~ 0
EXT_PWR
Text GLabel 4760 3260 2    50   Input ~ 0
GP_1
Text GLabel 4760 3360 2    50   Input ~ 0
GP_2
Text GLabel 4760 3460 2    50   Input ~ 0
GP_3
Text GLabel 4760 3560 2    50   Input ~ 0
GP_4
Text GLabel 4760 3660 2    50   Input ~ 0
GND
Text GLabel 4760 3760 2    50   Input ~ 0
+5v
Wire Wire Line
	3280 3570 3230 3570
Text GLabel 3280 3570 2    50   Input ~ 0
+3.3v
Wire Wire Line
	3280 3370 3230 3370
Text GLabel 3280 3370 2    50   Input ~ 0
+5v
Wire Wire Line
	1230 2270 1160 2270
Text Notes 1225 4080 0    50   ~ 0
MISTAKE: T_DATA is not an analog pin. 
$EndSCHEMATC
