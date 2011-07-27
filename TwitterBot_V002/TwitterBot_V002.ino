#include <SPI.h>
#include <Ethernet.h>
#include <WProgram.h>
#include <TextFinder.h>

/*
  Web client
 
 This sketch connects to a website (http://www.google.com)
 using an Arduino Wiznet Ethernet shield. 
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 created 18 Dec 2009
 by David A. Mellis
 
 */



// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = {  
  0x90, 0xA2, 0xDA, 0x00, 0x3A, 0x17 };
//IPAddress server(74,125,224,145); // Google
IPAddress server(216,119,67,135); // spurgeonworld.com

char twitterID[16];


// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client;
TextFinder finder(client);

void setup() {
  // start the serial library:
  Serial.begin(9600);
  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    for(;;) {
      ;
    }
  }
  // print your local IP address:
  Serial.print("My IP address: ");
  for (byte thisByte = 0; thisByte < 4; thisByte++) {
    // print the value of each byte of the IP address:
    Serial.print(Ethernet.localIP()[thisByte], DEC);
    Serial.print("."); 
  }
  Serial.println();

  // give the Ethernet shield a second to initialize:
  delay(4000);
  Serial.println("connecting...");
} // end of setup()



void loop() {

  // if you get a connection, report back via serial:
  if (client.connect("www.spurgeonworld.com", 80)) {
    Serial.println("connected");
    // Make a HTTP request:
    //    client.println("GET /robots.txt HTTP/1.0");
    client.println("GET /twitterfeed/tweets.php?rpp=4&q=%40chrisspurgeon&since_id=95164107203952640 HTTP/1.0");
    client.println();
  } 
  else {
    // if you didn't get a connection to the server:
    Serial.println("connection failed");
  }

  if (client.connected()) {
    int theCount = finder.getString("\n","|",twitterID, 18);
    Serial.print("the twitterID is ");
    Serial.println(twitterID);
  }  
  else {
    Serial.println();
    Serial.println("Not connected.");
    client.flush();
    client.stop();
    delay(10000);
  }
}








