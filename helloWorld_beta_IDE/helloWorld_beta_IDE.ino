#include <icrmacros.h>
#include <SoftwareSerial.h>

SoftwareSerial Thermal(2, 3); //Soft RX from printer on D2, soft TX out to printer on D3


void setup() {
  Serial.begin(9600); //Use hardware serial for debugging
  Thermal.begin(19200); //Setup soft serial for ThermalPrinter control
  Serial.println("Before print");
  Thermal.println(" ");
  Thermal.println("Hello there 1!");
  Thermal.write(20);
  Thermal.println("Hello there 2!");
  for (int i = 1; i < 4; i++) {
    Thermal.println(" ");
  }
  Serial.println("After print");

}
void loop() {

}


