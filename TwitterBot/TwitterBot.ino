/*
  DHCP-based IP printer
 
 This sketch uses the DHCP extensions to the Ethernet library
 to get an IP address via DHCP and print the address obtained.
 using an Arduino Wiznet Ethernet shield. 
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 created 12 April 2011
 by Tom Igoe
 
 */

#include <SPI.h>
#include <Ethernet.h>

// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = {  
  0x90, 0xA2, 0xDA, 0x00, 0x3A, 0x17 };
IPAddress server(74,125,224,82); // Google




// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client;

void setup() {
  // start the serial library:
  Serial.begin(9600);
  
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
  Serial.println("connecting...");

  // if you get a connection, report back via serial:
  if (client.connect(server,80)) {
    Serial.println("connected");
    // Make a HTTP request:
    //    client.println("GET /search?q=arduino HTTP/1.0");
    client.println("GET /robots.txt HTTP/1.0");
    client.println();
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
  }

}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    delay(60000);
    Serial.println("Trying to connect again...");
    if (client.connect(server,80)) {
      Serial.println("connected");
      // Make a HTTP request:
      //    client.println("GET /search?q=arduino HTTP/1.0");
      client.println("GET /robots.txt HTTP/1.0");
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






