class Drone {
  float x;
  float y;
  float z;
  
  PShape drone;
  float zmin;
  float zmax;
  float scale;
  
  float theta;
  float hspeed;
  float vspeed;
  float thetaspeed;
  float hSpeedParameter;
  float vSpeedParameter;
  float thetaSpeedParameter;
  
  float rotationZ;
  float rotationX;
  float tiltspeed;
  float tiltangle;
  
  boolean keyA;
  boolean keyS;
  boolean keyD;
  boolean keyW;
  boolean keyDown;
  boolean keyUp;
  boolean keyLeft;
  boolean keyRight;
  
  float meter;
  
  
  Drone() {
    x = 0;
    y = 0;
    z = 50;
    theta = 0;
    
    rotationZ = 0;
    rotationX = 0;
    tiltspeed = 2*radians(1);
    tiltangle = PI/6;
    
    hSpeedParameter = 2;
    vSpeedParameter = 1;
    thetaSpeedParameter = 60;
    
    scale = 2;
  }
  
  /**************************************************************************************************************************************************
  The center of the screen is defined as (0,0,0)
  It's rotated around the x-axis for depth perspective and for the correct orientation of the drone.
  It's rotated around the y-axis if you want to look at the drone from another perspective.
  It's rotated around the x-axis and/or the z-axis if it's moving in the x- or z-direction.
  The drone is drawn and everything is moved back to default.
  **************************************************************************************************************************************************/
  void display() {
    translate(width/2,height/2,0);
    rotateX(cameraangle+PI/2);
    
    rotateY(cameradrag);
    rotateX(rotationX);
    rotateZ(-rotationZ);
    droneship();
    rotateZ(rotationZ);
    rotateX(-rotationX);
    rotateY(-cameradrag);
    
    rotateX(-cameraangle-PI/2);
    translate(-width/2,-height/2,0);
  }
  
  void droneship() {
    drone.setFill(color(255,255,255));
    shape(drone,64*scale/2,0,64*scale,12*scale);
    zmin = scale*drone.height;
    zmax = zmin+10*meter;
    meter = 2*scale*drone.width; //Defining the drone to be 1/2 unit wide.
  }
  
  
  /**************************************************************************************************************************************************
  Velocities are set.
  If any movement is true then the drone is tilted and the x,y,z coordinates of the drone are changes.
  Notice that the y-axis is invertede due to the computers definition. This means that a forward move is equivalent to the "backward" function.
  **************************************************************************************************************************************************/
  void move() {
    hspeed = hSpeedParameter*meter/framerate;
    vspeed = vSpeedParameter*meter/framerate;
    thetaspeed = radians(thetaSpeedParameter/framerate);
    
    //Left
    if (keyA == true) { //a 65
      x-=hspeed*cos(theta);
      y+=hspeed*sin(theta);
      if (rotationZ > -tiltangle) { //Tilting the drone slowly until the tiltangle has been reached.
        rotationZ -= tiltspeed;
      }
    }
    else if (rotationZ < 0) { //Tilting the drone until the default angle has been reached.
      rotationZ += tiltspeed;
    }
    
    //Right
    if (keyD == true) { //d 68
      x+=hspeed*cos(theta);
      y-=hspeed*sin(theta);
      if (rotationZ < tiltangle) {
        rotationZ += tiltspeed;
      }
    }
    else if (rotationZ > 0) {
      rotationZ -= tiltspeed;
    }
    
    //Backwards
    if (keyS == true) { //s 83
      y+=hspeed*cos(theta);
      x+=hspeed*sin(theta);
      if (rotationX > -tiltangle) {
        rotationX -= tiltspeed;
      }
    }
    else if (rotationX < 0) {
      rotationX += tiltspeed;
    }
    
    //Forwards
    if (keyW == true) { //w 87
      y-=hspeed*cos(theta);
      x-=hspeed*sin(theta);
      if (rotationX < tiltangle) {
        rotationX += tiltspeed;
      }
    }
    else if (rotationX > 0) {
      rotationX -= tiltspeed;
    }
    
    //Yaw left
    if (keyLeft == true) {
      theta+=thetaspeed;
      if (theta >= 2*PI) {
        theta = 0;
      }
    }
    
    //Yaw right
    if (keyRight == true) {
      theta-=thetaspeed;
      if (theta < 0) {
        theta = 2*PI;
      }
    }
    
    //Up
    if (keyUp == true && z < zmax) {
      z+=vspeed;
    }
    
    //Down
    if (keyDown == true && z > zmin) {
      z-=vspeed;
    }
  }
  
  
  void info() {
    textAlign(LEFT,CENTER);
    float textx = 20+2*programmingMovex;
    float texty = 0;
    float textsize = 20;
    fill(255,255,255,100);
    textSize(textsize);
    text("Altitude: "+nf(abs((z-scale*drone.height)/meter),1,1)+"m",textx,texty+2*textsize);
    text("X-Coordinate: "+nf(x/meter,1,1)+"m",textx,texty+3*textsize);
    text("Y-Coordinate: "+nf(y/meter,1,1)+"m",textx,texty+4*textsize);
    text("Orientation: "+nf(abs(degrees(theta))%360,1,1)+"deg",textx,texty+5*textsize);
    text("Horizontal Speed: "+(hspeed*framerate/meter)+"m/s",textx,texty+6*textsize);
    text("Vertical Speed: "+(vspeed*framerate/meter)+"m/s",textx,texty+7*textsize);
    text("Theta Speed: "+(round(degrees(thetaspeed*framerate)))+"deg/s",textx,texty+8*textsize);
  }
  
  
  /**************************************************************************************************************************************************
  Checking for colision between drone and objects.
  If colision is true all movements will be set false and performColision() in Programming class will be initiated
  **************************************************************************************************************************************************/
  void colision() {
    for (int i = 2; i < object.length; i++) {
      float a = object[i].obsl/2+scale*drone.width/2;
      float b = object[i].obsw/2+scale*drone.width/2;
      
      if (x <= object[i].obsx+a && x >= object[i].obsx-a && y <= object[i].obsy+b && y >= object[i].obsy-b && z <= object[i].obsh/2+scale*drone.height) { //Yes colision
        colision = true;
        for (int j = 0; j < 8; j++) {
          keyState(j,false);
        }
      }
      else { //NO colision
      }
    }
  }
  
  
  /**************************************************************************************************************************************************
  Changing the state of a specific key
  **************************************************************************************************************************************************/
  void keyState(int i, boolean state) {
    if (i == 0) {
      keyW = state;
    }
    else if (i == 1) {
      keyS = state;
    }
    else if (i == 2) {
      keyA = state;
    }
    else if (i == 3) {
      keyD = state;
    }
    else if (i == 4) {
      keyUp = state;
    }
    else if (i == 5) {
      keyDown = state;
    }
    else if (i == 6) {
      keyLeft = state;
    }
    else if (i == 7) {
      keyRight = state;
    }
  }
}
