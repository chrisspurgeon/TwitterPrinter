#include <TextFinder.h>

/*
  Web client
 
 This sketch connects to a website using an Arduino Wiznet Ethernet shield. 
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 created 18 Dec 2009
 by David A. Mellis
 
 */

#include <SPI.h>
#include <Ethernet.h>



char tweet[150];
String tweetcopy;
String lastID;
String tweetMessage;
String tweetSender;
String tweetDate;
int segmentCounter = 0;
boolean printFlag = false;



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

  lastID = "0";


  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  // start the serial library:
  Serial.begin(9600);
  // give the Ethernet shield a second to initialize:
  delay(5000);
}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    int stringLength = finder.getString("|","|",tweet,150);
    Serial.print("I got here! The length is ");
    Serial.println(stringLength);
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
    Serial.print(tweet);
    Serial.println();
    //    char c = client.read();
    //    Serial.print(c);
    segmentCounter++;
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.flush();
    client.stop();
    segmentCounter = 0;
    if (printFlag == true) {
      firePrinter();
      printFlag = false;
    }


    delay(10000);
    Serial.println("Let's connect.");
    if (client.connect()) {
      Serial.println("Connection established.");
      Serial.println("Hitting the server with a last ID of " + lastID);
      client.print("GET /twitterfeed/tweets.php?rpp=6&q=%40chrisspurgeon&since_id=");
      //      client.print("95493525780709376");
      client.print(lastID);
      client.println(" HTTP/1.0");
      client.println();
    } 
    else {
      Serial.println("Connection failed.");
    }
  }
}


void firePrinter() {
  Serial.println("I've triggered firePrinter!");
}









