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

#include <SPI.h>
#include <Ethernet.h>



char tweet[140];
String lastID = 0;
String author;
String tweetcopy;
String timestamp;

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
  int loopcounter = 0;
  if (client.available()) {
    Serial.print("Loopcounter is ");
    Serial.println(loopcounter);
    int stringLength = finder.getString("|","|",tweet,140);
    lastID = tweet;
    stringLength = finder.getString("|","|",tweet,140);
    author = tweet;
    stringLength = finder.getString("|","|",tweet,140);
    tweetcopy = tweet;
    stringLength = finder.getString("|","|",tweet,140);
    timestamp = tweet;
    Serial.print("I got here! The length is ");
    Serial.println(stringLength);
    Serial.print(tweet);
    Serial.println();
    /*    switch(loopcounter) {
     case 0:
     lastID = tweet;
     break;
     case 1:
     author = tweet;
     break;
     case 2:
     tweetcopy = tweet;
     break;
     case 3:
     timestamp = tweet;
     break;
     }
     loopcounter++;
     */
    //    char c = client.read();
    //    Serial.print(c);
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.flush();
    client.stop();
    Serial.println("\n\n\nAfter the loops, here's what I got:");
    Serial.println("lastID is " + lastID);
    Serial.println("author is " + author);
    Serial.println("tweetcopy is " + tweetcopy);
    Serial.println("timestamp is " + timestamp);


    delay(10000);
    Serial.println("Let's connect.");
    if (client.connect()) {
      Serial.println("Connection established.");
      client.println("GET /twitterfeed/tweets.php?rpp=4&q=%40chrisspurgeon&since_id=95164107203952640 HTTP/1.0");
      client.println();
    } 
    else {
      Serial.println("Connection failed.");
    }
  }
}








