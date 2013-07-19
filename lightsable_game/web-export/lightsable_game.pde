
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


Maxim maxim;
AudioPlayer playerPulse;
AudioPlayer[] playerHit;
AudioPlayer playerOn;
AudioPlayer playerOff;
Accelerometer accel;
boolean playit = false;
int maxX=0;
int playerId = 0;
Physics physics;
Body [] playerSable;
CollisionDetector detector;

void setup() {
  size(768, 1024);
  maxim = new Maxim(this);
  playerPulse = maxim.loadFile("sounds_light/lightsaberpulse.wav");
  
  playerOn = maxim.loadFile("sounds_light/ltsaberon01.wav");
  playerOff = maxim.loadFile("sounds_light/ltsaberoff01.wav");
  
  playerHit = new AudioPLayer[8];
  for (int i=1;i<9;i++) {
    String fileName = "sounds_light/ltsaberswing0" + str(i) + ".wav";
    playerHit[i] = maxim.loadFile(fileName);
    playerHit[i].setLooping(false);
  }
  
  physics = new Physics(this, width, height, 0, 0, width * 10, height * 2, width, height, 100);
  detector = new CollisionDetector (physics, this);
  
  accel = new Accelerometer();
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
  
  setPlayerId();
  startPoint = new Vec2(200, height-150);
  // this converst from processing screen 
  // coordinates to the coordinates used in the
  // physics engine (10 pixels to a meter by default)
  startPoint = physics.screenToWorld(startPoint);
}

void draw() {
  checkLaserMovement();

  fill(100);
  text(number++, 10, 100);
  text(receivedString, 10, 120);

  if (accel.getX() > maxX) {
    maxX = accel.getX();
  }
  text(accel.getX(), 20, 50);
  text(accel.getY(), 20, 100);
  text(accel.getZ(), 20, 150);

  text(maxX, 20, 200);
}
void receive(String s) {
  //TODO create a routing that allows to receive different kinds of messages
  receivedString=s;
}

void setPlayerId() {
  //TODO get the real user id
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
    send(playerId, accel.getX(), accel.getY(), accel.getZ());
    if (accel.getX() > 10 || accel.getY() > 10 || accel.getZ() > 10) {
      int hitSound = ((int)random(8)) + 1; 
      playerHit[hitSound].stop();
      playerHit[hitSound].cue(0);
      playerHit[hitSound].play();
    }
  }
}
//
//void collision(Body b1, Body b2, float impulse) {
//}


