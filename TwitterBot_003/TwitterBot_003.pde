#include <NewSoftSerial.h>
#include <TextFinder.h>
#include <SPI.h>
#include <Ethernet.h>

/*
  Web client
 
 This sketch connects to a website using an Arduino Wiznet Ethernet shield. 
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 created 18 Dec 2009
 by David A. Mellis
 
 */


boolean DEBUG = false;
char tweet[150];
String tweetcopy;
String lastID;
String tweetMessage;
String tweetSender;
String tweetDate;
int segmentCounter = 0;
boolean printFlag = false;


NewSoftSerial Thermal(2, 3); //Soft RX from printer on D2, soft TX out to printer on D3

#define FALSE  0
#define TRUE  1
int printOnBlack = FALSE;
int printUpSideDown = FALSE;

int ledPin = 13;
int heatTime = 255; //80 is default from page 23 of datasheet. Controls speed of printing and darkness
int heatInterval = 255; //2 is default from page 23 of datasheet. Controls speed of printing and darkness
char printDensity = 15; //Not sure what the defaut is. Testing shows the max helps darken text. From page 23.
char printBreakTime = 15; //Not sure what the defaut is. Testing shows the max helps darken text. From page 23.




// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {  
  0x90, 0xA2, 0xDA, 0x00, 0x3A, 0x17 };
byte ip[] = { 
  192,168,1,125 };
byte server[] = { 
  216,119,67,135 }; // spurgeonworld
byte gateway[] = { 
  192,168,1,1};	
byte subnet[] = { 
  255, 255, 255, 0 };

// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client(server, 80);
TextFinder  finder(client); 

void setup() {
  delay(2000);
  Thermal.begin(19200); //Setup soft serial for ThermalPrinter control

  printOnBlack = FALSE;
  printUpSideDown = FALSE;

  //Modify the print speed and heat
  Thermal.print(27, BYTE);
  Thermal.print(55, BYTE);
  Thermal.print(7, BYTE); //Default 64 dots = 8*('7'+1)
  Thermal.print(heatTime, BYTE); //Default 80 or 800us
  Thermal.print(heatInterval, BYTE); //Default 2 or 20us

  //Modify the print density and timeout
  Thermal.print(18, BYTE);
  Thermal.print(35, BYTE);
  int printSetting = (printDensity<<4) | printBreakTime;
  Thermal.print(printSetting, BYTE); //Combination of printDensity and printBreakTime



  Thermal.println(10, BYTE);
  Thermal.println("Parameters set!");
  Thermal.println(10, BYTE);
  Thermal.println(10, BYTE);
  Thermal.println(10, BYTE);

  lastID = "0";

  delay(2000);
  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  if (DEBUG) {
    // start the serial library:
    Serial.begin(9600);
  }
  // give the Ethernet shield time to initialize:
  delay(5000);
}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    int stringLength = finder.getString("|","|",tweet,150);
    if (DEBUG) {
      Serial.print("I got here! The length is ");
      Serial.println(stringLength);
    }
    if (stringLength > 0) {
      switch (segmentCounter) {
      case 0:
        printFlag = true;
        lastID = tweet;
        break;
      case 1:
        tweetSender = tweet;
        break;
      case 2:
        tweetMessage = tweet;
        break;
      case 3:
        tweetDate = tweet;
        break;
      }
    }
    if (DEBUG) {
      Serial.print(tweet);
      Serial.println();
    }
    segmentCounter++;
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    if (printFlag == true) {
      firePrinter();
      printFlag = false;
    }
    if (DEBUG) {
      Serial.println();
      Serial.println("disconnecting.");
    }
    client.flush();
    client.stop();
    segmentCounter = 0;


    delay(10000);
    if (DEBUG) {
      Serial.println("Let's connect.");
    }
    if (client.connect()) {
      if (DEBUG) {
        Serial.println("Connection established.");
        Serial.println("Hitting the server with a last ID of " + lastID);
      }
      client.print("GET /twitterfeed/tweets.php?rpp=6&q=thehousebot&since_id=");
      client.print(lastID);
      client.println(" HTTP/1.0");
      client.println();
    } 
    else {
      if (DEBUG) {
        Serial.println("Connection failed.");
      }
    }
  }
}


void firePrinter() {
  if (DEBUG) {
    Serial.println("I've triggered firePrinter!");
  }
  Thermal.println(10, BYTE);
  Thermal.print("FROM: ");
  Thermal.println(tweetSender);
  Thermal.println(10, BYTE);
  Thermal.println(tweetMessage);
  Thermal.println(10, BYTE);
  Thermal.print("SENT: ");
  Thermal.println(tweetDate);
  Thermal.println(10, BYTE);
  Thermal.println(10, BYTE);
  Thermal.println(10, BYTE);

}


















