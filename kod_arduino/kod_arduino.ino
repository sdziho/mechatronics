/*------------------------------------------------------------------------------
  LIDARLite Arduino Library
  GetDistancePwm
  This example shows how to read distance from a LIDAR-Lite connected over the
  PWM interface.
  Connections:
  LIDAR-Lite 5 Vdc (red) to Arduino 5v
  LIDAR-Lite Ground (black) to Arduino GND
  LIDAR-Lite Mode control (yellow) to Arduino digital input (pin 3)
  LIDAR-Lite Mode control (yellow) to 1 kOhm resistor lead 1
  1 kOhm resistor lead 2 to Arduino digital output (pin 2)
  (Capacitor recommended to mitigate inrush current when device is enabled)
  680uF capacitor (+) to Arduino 5v
  680uF capacitor (-) to Arduino GND
  See the Operation Manual for wiring diagrams and more information:
  http://static.garmin.com/pumac/LIDAR_Lite_v3_Operation_Manual_and_Technical_Specifications.pdf
------------------------------------------------------------------------------*/
#include <Servo.h>
unsigned long pulseWidth;
Servo motor;
int pozicija=0;
void setup()
{
  Serial.begin(115200); // Start serial communications

  pinMode(2, OUTPUT); // Set pin 2 as trigger pin
  digitalWrite(2, LOW); // Set trigger LOW for continuous read

  pinMode(7, INPUT); // Set pin 3 as monitor pin
  motor.attach(9);
  
}

void loop()
{
  

  for (pozicija = 0; pozicija <= 180; pozicija += 1) { 
    motor.write(pozicija); 
    pulseWidth = pulseIn(7, HIGH);   
    if(pulseWidth != 0){
       pulseWidth = pulseWidth / 10; 
       Serial.print(pozicija); 
       Serial.print(","); 
       Serial.print(pulseWidth); 
       Serial.print("."); 
    }         
    delay(15);                      
  }
  for (pozicija = 180; pozicija >= 0; pozicija -= 1) { 
    motor.write(pozicija); 
    pulseWidth = pulseIn(7, HIGH);    //puls u mikrosekundama
    if(pulseWidth != 0){
       pulseWidth = pulseWidth / 10;  //dobivamo cm
       Serial.print(pozicija); 
       Serial.print(","); 
       Serial.print(pulseWidth); 
       Serial.print(".");  
    }            
    delay(15);                       
  }
}
