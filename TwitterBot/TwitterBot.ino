#include <SPI.h>
#include <Ethernet.h>
#include <icrmacros.h>
#include <SoftwareSerial.h>

// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = {  
  0x90, 0xA2, 0xDA, 0x00, 0x3A, 0x17 };
//IPAddress server(199,59,148,201); // search.twitter.com
//IPAddress server(174,120,152,186); // whatsmyuseragent.com
//IPAddress server(216,119,67,135); // www.spurgeonworld.com


int checkDelay = 10000;


SoftwareSerial Thermal(2, 3); //Soft RX from printer on D2, soft TX out to printer on D3


// Printer inits
#define FALSE  0
#define TRUE  1
int printOnBlack = FALSE;
int printUpSideDown = FALSE;

int ledPin = 13;
int heatTime = 255; //80 is default from page 23 of datasheet. Controls speed of printing and darkness
int heatInterval = 255; //2 is default from page 23 of datasheet. Controls speed of printing and darkness
char printDensity = 15; //Not sure what the defaut is. Testing shows the max helps darken text. From page 23.
char printBreakTime = 15; //Not sure what the defaut is. Testing shows the max helps darken text. From page 23.




// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client;

void setup() {
  Serial.begin(38400); //Use hardware serial for debugging
  Thermal.begin(19200); //Setup soft serial for ThermalPrinter control

  printOnBlack = FALSE;
  printUpSideDown = FALSE;

  //Modify the print speed and heat
  Thermal.write(27);
  Thermal.write(55);
  Thermal.write(7); //Default 64 dots = 8*('7'+1)
  Thermal.write(heatTime); //Default 80 or 800us
  Thermal.write(heatInterval); //Default 2 or 20us

  //Modify the print density and timeout
  Thermal.write(18);
  Thermal.write(35);
  int printSetting = (printDensity<<4) | printBreakTime;
  Thermal.write(printSetting); //Combination of printDensity and printBreakTime

  Serial.println();
  Serial.println("Printer parameters set");  
  Serial.println("Attempting to get an IP address...");
  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    for(;;)
      ;
  }
  // print your local IP address:
  Serial.print("My IP address: ");
  for (byte thisByte = 0; thisByte < 4; thisByte++) {
    // print the value of each byte of the IP address:
    Serial.print(Ethernet.localIP()[thisByte], DEC);
    Serial.print("."); 
  }
  Serial.println();
  delay(1000);
/*  Serial.println("connecting...");

  // if you get a connection, report back via serial:
  if (client.connect("www.spurgeonworld.com",80)) {
    Serial.println("connected");
    // Make a HTTP request:
    //    client.println("GET /search.atom?rpp=1&q=%40chrisspurgeon&since_id= HTTP/1.0");
    client.println("GET / HTTP/1.0");
    client.println();
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
  }
*/
}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
    // Thermal.print(c);
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    client.flush();
    delay(checkDelay);
    Serial.println("Trying to connect again...");
    if (client.connect("www.spurgeonworld.com",80)) {
      Serial.println("connected");
      // Make a HTTP request:
      //    client.println("GET /search?q=arduino HTTP/1.0");
      client.println("GET / HTTP/1.0");
      client.println();
    } 
    else {
      // kf you didn't get a connection to the server:
      Serial.println("connection failed");
    }

    // do nothing forevermore:
    //   for(;;)
    //     ;

  }
}









