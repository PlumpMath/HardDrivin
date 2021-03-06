import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation; 
long lastTweetTime = 0;
long displayResetTime = 30000;

void setup() {
  size(900, 930, P3D);
  // receive OSC messages from HardDrivin.py
  oscP5 = new OscP5(this,9002);
  // Load the font from the sketch's data directory
  textFont(loadFont("Ceriph0756-32.vlw"));

  displayInfo();
}

void draw() {
  if ((millis() - lastTweetTime) > displayResetTime) {
    println(millis() - lastTweetTime);
    displayInfo();
  } 
}

void drawTweet(String user, String tweet) {
  background(0);
  fill(255);
  text("@"+user, 24, 100);
  fill(0,255,0);
  text(tweet, 24, 160, 630, 676);
  lastTweetTime = millis()+1000;
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  if (theOscMessage.checkAddrPattern("/tweet")==true || theOscMessage.checkAddrPattern("/hashtag")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("sis")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      String user = theOscMessage.get(0).stringValue();  
      int tweetLength = theOscMessage.get(1).intValue();
      String tweet = theOscMessage.get(2).stringValue();
      //print("### received an osc message /tweet with typetag sis.");
      //println(" values: "+firstValue+", "+secondValue+", "+thirdValue);
      
      lastTweetTime = millis()+1000;
      drawTweet(user, tweet);

      
      return;
    }      
  }
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}

void displayInfo() {
  drawTweet("harddrivin","Control the cars with Twitter! Use the hashtags #harddrivin, or #tweak -– or get the cars to follow a user: @harddrivin follow @tweakfestival");
}

