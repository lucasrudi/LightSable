int number=0;
String receivedString="";


Maxim maxim;
AudioPlayer playerPulse;
AudioPlayer playerHit;
AudioPlayer playerOn;
AudioPlayer playerOff;
Accelerometer accel;
boolean playit = true;
int maxX=0;

void setup() {
  size(768, 1024);
  maxim = new Maxim(this);
  playerPulse = maxim.loadFile("sounds_light/lightsaberpulse.wav");
  playerHit = maxim.loadFile("sounds_light/ltsaberswing01.wav");
  playerOn = maxim.loadFile("sounds_light/ltsaberon01.wav");
  playerOff = maxim.loadFile("sounds_light/ltsaberoff01.wav");

  accel = new Accelerometer();
  playerPulse.setLooping(true);
  playerHit.setLooping(false);
  playerOn.setLooping(false);
  playerOff.setLooping(false);
  playerPulse.play();
  rectMode(CENTER);
  background(0);
}

void draw() {
  //float speed = map(accel.getX(), -10, 10, 0, 2);
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
  receivedString=s;
}

void mousePressed() {
  send("This is a test message from the web-client. Number is: " + number + ".");
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
  background(0, 0, 0);
}

void stopLaser() {
  playerPulse.stop();
  playerOff.stop();
  playerOff.cue(0);
  playerOff.play();
  background(255, 0, 0);
}

void checkLaserMovement() {
  if (accel.getX() > 10 && playit) {
    playerHit.stop();
    playerHit.cue(0);
    playerHit.play();
  }
}


