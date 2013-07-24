
import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

int number=0;
String receivedString="";

String lastPosition = "";
String currentPosition = "";

Maxim maxim;
AudioPlayer playerPulse;
AudioPlayer[] playerHit;
AudioPlayer[] playerCollition;
AudioPlayer playerOn;
AudioPlayer playerOff;
Accelerometer accel;
//GeoPosition geo;
boolean playit = false;
int maxX=0;
int playerId = 0;
Physics physics;
Body [] playerSable;
CollisionDetector detector;
HashMap usersPositions;

void setup() {
  frameRate(2);
  size(768, 1024);
  maxim = new Maxim(this);
  playerPulse = maxim.loadFile("sounds_light/lightsaberpulse.wav");
  
  playerOn = maxim.loadFile("sounds_light/ltsaberon01.wav");
  playerOff = maxim.loadFile("sounds_light/ltsaberoff01.wav");
  
  playerCollition = new AudioPLayer[4];
  for (int i=1;i<5;i++) {
    String fileName = "sounds_light/ltsaberhit0" + str(i) + ".wav";
    playerCollition[i] = maxim.loadFile(fileName);
    playerCollition[i].setLooping(false);
  }
  
  playerHit = new AudioPLayer[4];
  for (int i=1;i<5;i++) {
    String fileName = "sounds_light/ltsaberswing0" + str(i) + ".wav";
    playerHit[i] = maxim.loadFile(fileName);
    playerHit[i].setLooping(false);
  }
  
  physics = new Physics(this, width, height, 0, 0, width * 10, height * 2, width, height, 100);
  detector = new CollisionDetector (physics, this);
  
  accel = new Accelerometer();
//  geo = new GeoPosition();
  playerPulse.setLooping(true);
  
  playerOn.setLooping(false);
  playerOff.setLooping(false);
  playerPulse.play();
  rectMode(CENTER);
  background(0);
  //TODO identify the player id
  //TODO allow to take the picture

  //TODO get users registered.
  
  playerSable = new Body[7];
  
  startPoint = new Vec2(200, height-150);
  // this converst from processing screen 
  // coordinates to the coordinates used in the
  // physics engine (10 pixels to a meter by default)
  startPoint = physics.screenToWorld(startPoint);
  
  usersPositions = new HashMap();
}

void draw() {
  if (playerId == 0 ) {
     getplayerid(playerId);
   }
  checkLaserMovement();

  fill(100);
  text(number++, 10, 100);
  text(receivedString, 10, 120);

  if (accel.getX() > maxX) {
    maxX = accel.getX();
  }
  //text(accel.getX(), 20, 50);
  //text(accel.getY(), 20, 100);
  //text(accel.getZ(), 20, 150);
  
//  text(geo.getLatitude(), 100, 50);
//  text(geo.getLongitude(), 100, 100);
//  text(geo.getAltitude(), 100, 150);
//  currentPosition = geo.getLatitude() + " - " + geo.getLongitude();
//  
//  if (lastPosition != currentPosition) {
//    println( currentPosition);
//    lastPosition = currentPosition;
//  } 
  

  text(maxX, 20, 200);
}
void receive(String s) {
  //TODO create a routing that allows to receive different kinds of messages
  receivedString=s;
  JSON.stringify(s);
}

void registerPlayerPosition(int playerId, float x, float y, float z) {
  HashMap currentPlayerPosition = new HashMap();
  currentPlayerPosition.put("x", x);
  currentPlayerPosition.put("y", y);
  currentPlayerPosition.put("z", z);
  usersPositions.put(playerId, currentPlayerPosition);
}

void setPlayerId(String id) {
  //TODO get the real user id
  playerId = id;
  println("PlayerId: " + id);
  playerSable[playerId] = physics.createRect(600, height-20, 600+30, height);
}

void mousePressed() {
  playit = !playit;
  if (playit) {
    startLaser();
  }
  else {
    stopLaser();
  }
}

void startLaser() {
  playerPulse.cue(0);
  playerPulse.play();
  playerOn.stop();
  playerOn.cue(0);
  playerOn.play();
  if (playerId == 0) {
    background(0, 0, 255);
  } 
  else {
    background(255, 0, 0);
  }
}

void stopLaser() {
  playerPulse.stop();
  playerOff.stop();
  playerOff.cue(0);
  playerOff.play();
  background(0, 0, 0);
}

void checkLaserMovement() {
  if (playit) {
    //println("playing");
    send(playerId, accel.getX(), accel.getY(), accel.getZ());
    //println("checking movement" + accel.getX() + " - " + accel.getY() + " - "  + accel.getZ());
    if (isACollition() && hasIMoved()) {
      println("collition");
      int collitionSound = ((int)random(4)) + 1; 
      playerCollition[collitionSound].stop();
      playerCollition[collitionSound].cue(0);
      playerCollition[collitionSound].play();
    } else if (hasIMoved()) {
      println("miss");
      int hitSound = ((int)random(4)) + 1; 
      playerHit[hitSound].stop();
      playerHit[hitSound].cue(0);
      playerHit[hitSound].play();
    } else {
      //println("quiet");
    }
  }
}

boolean isACollition() {

  Iterator i = usersPositions.entrySet().iterator();
  println("usersPositions" + usersPositions.size());
  while (i.hasNext()) {
    Map.Entry playerMovement = (Map.Entry)i.next();
    //if (playerMovement.getKey() != playerId) {
      
      Iterator axxess = playerMovement.getValue().entrySet().iterator();
      while (axxess.hasNext()) {
        Map.Entry axxe = (Map.Entry)axxess.next();
        println(axxe.getValue());
        println(abs(axxe.getValue()) > 7 );
        if (abs(axxe.getValue()) > 7) {
          return true;
        }
      }
      
    }
  return false;
}
boolean hasIMoved() {
  if (abs(accel.getX()) > 7 || abs(accel.getY()) > 7 || abs(accel.getZ()) > 7) {
    return true;
  }
  return false;
}
void collision(Body b1, Body b2, float impulse) {
}

