/**
 * Based on oscP5sendreceive by andreas schlegel
 */

import oscP5.*;
import netP5.*;
import java.net.InetAddress;
import java.net.UnknownHostException;

public String HostAddress;
public String HostName;

OscP5 oscP5;
NetAddress nodejsServer;

int number=0;
String receivedString="";

void setup() {
  size(500, 200);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 3333);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  try {
    InetAddress addr = InetAddress.getLocalHost();
    byte[] ipAddr = addr.getAddress();
    String raw_addr = addr.toString();
    String[] list = split(raw_addr, '/');
    HostAddress = list[1];
    HostName = addr.getHostName();
  }     
  catch (UnknownHostException e) {
  }
  println(HostAddress + ":"+HostName);
  nodejsServer = new NetAddress(HostAddress, 3334);
}


void draw() {
  background(0);
  fill(255);
  text(number++, 10, 100);
  text(receivedString, 30, 120);
}

void receive(String s) {
  receivedString=s;
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/oscClient");

  myMessage.add("This is a test message from the oscClient. Number is: " + number);

  /* send the message */
  oscP5.send(myMessage, nodejsServer);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/clientMsg")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("s")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      receivedString=theOscMessage.get(0).stringValue();
    }
  }
}

