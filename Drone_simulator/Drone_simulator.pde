/**
Andreas Skiby Andersen
Aarhus Gymnaisum Aarhus C
17xad
Programmering C
Eksamensprojekt
**/

float cameraangle = PI/2-PI/8;


//Global variables DO NOT TOUCH!
import peasy.*;
PeasyCam cam;

Drone drone = new Drone();
Object[] object = new Object[5];
Programming programming = new Programming();
Block[] block = new Block[100];

float cameradrag = 0;
boolean programmingShow = true;
float programmingMovex;

int numofchosenblocks = 0;
int blockpressed = 0;

boolean colision = false;

float framerate = 60;


void setup() {
  fullScreen(P3D);
  if (programmingShow == true) {
    programmingMovex = (width-height)/2;
  }
  else {
    programmingMovex = 0;
  }
  
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  shapeMode(CENTER);
  colorMode(RGB,255,255,255,100);
  frameRate(framerate);
  
  drone.drone = loadShape("Drone.obj");
  
  for (int i = 0; i < object.length; i++) {
    object[i] = new Object();
  }
  for (int i = 0; i < block.length; i++) {
    block[i] = new Block();
  }
  
  cam = new PeasyCam(this,width/2-programmingMovex,height/2,(height/2)/tan(PI/6),50); //Note with PeasyCam the camera orientation can be moved and you can zoom in and out.
  cam.setSuppressRollRotationMode(); //Camera can only be Yawed and Pitched for a more controlled camera movement.
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(2000);
}


void draw() {
  background(0,0,0);
  lights();
  
  //camera(width/2, height/2, (height/2)/tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  drone.display();
  landscape();
  
  /**
  hint(DISABLE_DEPTH_TEST);
  drone.info();
  if (programmingShow == true) {
    programming.display();
  }
  hint(ENABLE_DEPTH_TEST);
  **/
  cam.beginHUD(); //Creating a 2D HUD on top of the 3D render
  drone.info();
  if (programmingShow == true) {
    programming.display();
  }
  cam.endHUD();
  
  programming.perform(); 
  
  drone.move();
  drone.colision();
}


/**************************************************************************************************************************************************
First the center of the screen is defined to be at (0,0,0)
The screen is rotated around the x-axis for depth perspective and it's rotated around the z-axis according to where the drone is looking.
Then it's moved down accordingly to the height of the drone.
Then any objects are drawn in an x-,y-,z-distance from the center.
Then their size are determined.
Finally every coordinate is moved back to default position.
**************************************************************************************************************************************************/
void landscape() {
  translate(width/2,height/2+drone.z,0);
  rotateX(cameraangle);
  rotateZ(drone.theta);
  rotateZ(cameradrag);
  
  object[0].sun(drone.meter*20,10,drone.meter/2);
  object[1].base(20*drone.meter);
  object[2].obstical(-2*drone.meter,-2*drone.meter,drone.meter/2,drone.meter/2,drone.meter);
  object[3].obstical(0*drone.meter,-5*drone.meter,2*drone.meter,2*drone.meter,2*drone.meter);
  object[4].obstical(5*drone.meter,-1*drone.meter,1*drone.meter,8*drone.meter,1*drone.meter);
  
  rotateZ(-cameradrag);
  rotateZ(-drone.theta);
  rotateX(-cameraangle);
  translate(-width/2,-height/2-drone.z,0);
}


/**************************************************************************************************************************************************
Checking if any keys for movement are pressed, if yes then the movement is set true.
**************************************************************************************************************************************************/
void keyPressed() {
  if (programming.perform == false && colision == false) {
    //moving drone freely
    if (key == 'a') {
      drone.keyA = true;
    }
    if (key == 's') {
      drone.keyS = true;
    }
    if (key == 'd') {
      drone.keyD = true;
    }
    if (key == 'w') {
      drone.keyW = true;
    }
    if (keyCode == LEFT) {
      drone.keyLeft = true;
    }
    if (keyCode == DOWN) {
      drone.keyDown = true;
    }
    if (keyCode == RIGHT) {
      drone.keyRight = true;
    }
    if (keyCode == UP) {
      drone.keyUp = true;
    }
    
    //Adding text to a block.
    if (keyCode >= 48 && keyCode <= 57) {
      block[blockpressed].text = append(block[blockpressed].text,keyCode-48);
    }
    
    //Deleting text from a block.
    if (keyCode == 8 && block[blockpressed].text.length > 0) {
      block[blockpressed].text = shorten(block[blockpressed].text);
    }
  }
}


/**************************************************************************************************************************************************
Checking if any keys for movement are released, if yes then the movement is set false.
**************************************************************************************************************************************************/
void keyReleased() {
  //moving drone freely
  if (key == 'a') {
    drone.keyA = false;
  }
  if (key == 's') {
    drone.keyS = false;
  }
  if (key == 'd') {
    drone.keyD = false;
  }
  if (key == 'w') {
    drone.keyW = false;
  }
  if (keyCode == LEFT) {
    drone.keyLeft = false;
  }
  if (keyCode == DOWN) {
    drone.keyDown = false;
  }
  if (keyCode == RIGHT) {
    drone.keyRight = false;
  }
  if (keyCode == UP) {
    drone.keyUp = false;
  }
}


/**************************************************************************************************************************************************
Checking if any of the blocks are being clicked, if yes the next block will recieve an indextext corresponding to which indexblock has been clicked. 
The value is from 0 to the number of blocks to choose from.
**************************************************************************************************************************************************/
void mouseClicked() {
  //Adding blocks
  int nextblock = numofchosenblocks+programming.indexblock.length;
  for (int i = 0; i < programming.indexblock.length; i++) {
    if (mouseX <= block[i].len && mouseY >= block[i].y-0.5*block[i].wid && mouseY <= block[i].y+0.5*block[i].wid) {
      block[nextblock].indextext = i; //Determining which action it has to perform
      blockpressed = nextblock;
      numofchosenblocks++;
    }
  }
  
  //Clicking GO
  if (sq(programming.xgo-mouseX)+sq(programming.ygo-mouseY) <= sq(programming.rgo)) {
    programming.perform = true;
  }
  
  //Clicking STOP
  if (sq(programming.xstop-mouseX)+sq(programming.ystop-mouseY) <= sq(programming.rstop)) {
    programming.currentBlock = numofchosenblocks+programming.indexblock.length;
  }
  
  //Clicking on a chosen block from the number 0'th to the number of chosen blocks
  for (int i = programming.indexblock.length; i < numofchosenblocks+programming.indexblock.length; i++) {
    if (mouseX >= block[i].x-0.5*block[i].len && mouseX <= block[i].x+0.5*block[i].len) { //Checking if the cursor is within the x-range of the chosen programming blocks.
      if (mouseY >= block[i].y-0.5*block[i].wid && mouseY <= block[i].y+0.5*block[i].wid) { //Checking if the cursor is within the y-range of the cohosen programming blocks.
        blockpressed = i;
      }
    }
  }
}


/**************************************************************************************************************************************************
Allowing the user to get a 360 degree view of the drone.
**************************************************************************************************************************************************/
void mouseDragged() {
  if (mouseY >= height/2) {
    cam.setActive(false);
    cameradrag+=radians(mouseX-pmouseX);
  }
  else {
    cam.setActive(true);
  }
}
