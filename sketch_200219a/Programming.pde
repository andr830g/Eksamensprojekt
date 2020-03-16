class Programming {
  float frametarget;
  float thetatarget;
  boolean setTarget;
  boolean perform;
  int currentblock;
  
  float xchoose;
  float rchoose;
  float spacechoose;
  String[] indexblock = {"FORWARD","BACKWARD","LEFT","RIGHT","UP","DOWN","YAW LEFT","YAW RIGHT"};
  
  float rgo;
  float xgo;
  float ygo;
  
  
  Programming() {
    setTarget = true;
    thetatarget = drone.theta;
    perform = false;
    currentblock = 0;
  }
  
  
  /**************************************************************************************************************************************************
  Creating a black surface with the purpose of being a programming workspace.
  Creating static programming blocks from the block function.
  Creating a go button to start the program.
  Showing the array of chosen programming blocks.
  **************************************************************************************************************************************************/
  void display() {
    fill(0,0,0,100);
    noStroke();
    rect(programming_movex,height/2,2*programming_movex,height);
    
    //Displaying the index blocks
    rchoose = (height*4/(indexblock.length*10)); //(height/8)*(4/10)
    spacechoose = (height/(indexblock.length*10)); //(height/8)*(1/10)
    xchoose = 60;
    for (int i = 0; i < indexblock.length; i++) {
      float ychoose = (1+2*i)*(spacechoose+rchoose);
      blockDisplay("ellipse",xchoose,ychoose,rchoose,rchoose,true,color(155,155,155,100),false,color(0),indexblock[i],color(255,255,255,100),xchoose,ychoose,16);
    }
    
    //Displaying the GO button
    rgo = 50;
    xgo = 2*programming_movex-rgo-10;
    ygo = rgo+10;
    blockDisplay("ellipse",xgo,ygo,rgo,rgo,false,color(0),true,color(0,255,0,100),"GO",color(0,0,0,100),xgo,ygo,40);
    
    //Displaying the chosen programming blocks
    for(int i = 0; i < numofchosenblocks; i++) {
      block[i].displayChosen(i);
    }
  }
  
  
  /**************************************************************************************************************************************************
  Performing the number of chosen programming blocks or reseting the them.
  **************************************************************************************************************************************************/
  void choose() {
    if (perform == true) { //Performing the programming blocks
      if (currentblock < numofchosenblocks) {
        perform(currentblock);
      }
      else { //reseting the programming blocks.
        perform = false;
        currentblock = 0;
        numofchosenblocks = 0;
        
        for (int i = 0; i < block.length; i++) {
          block[i] = new Block();
        }
      }
    }
  }
  
  
  /**************************************************************************************************************************************************
  The value at the i'th place in the programming array is determining which action tp perform.
  **************************************************************************************************************************************************/
  void perform(int i) {
    if (block[i].indextext == 0) {
      blockW(block[i].value);
    }
    else if (block[i].indextext == 1) {
      blockS(block[i].value);
    }
    else if (block[i].indextext == 2) {
      blockA(block[i].value);
    }
    else if (block[i].indextext == 3) {
      blockD(block[i].value);
    }
    else if (block[i].indextext == 4) {
      blockUp(block[i].value);
    }
    else if (block[i].indextext == 5) {
      blockDown(block[i].value);
    }
    else if (block[i].indextext == 6) {
      blockYl(block[i].value);
    }
    else if (block[i].indextext == 7) {
      blockYr(block[i].value);
    }
  }
  
  
  /**************************************************************************************************************************************************
  Visually showing a block defined by a set of placement, size, stroke, fill and text parameters.
  **************************************************************************************************************************************************/
  void blockDisplay(String a, float x, float y, float l, float w, boolean stroke, color strokecolor, boolean fill, color fillcolor, String text, color textcolor, float textx, float texty, float textsize) {
   if (stroke == true) {
     stroke(strokecolor);
   }
   else {
     noStroke();
   }
   
   if (fill == true) {
     fill(fillcolor);
   }
   else {
     noFill();
   }
   
   if (a == "rect") {
     rect(x,y,l,w);
   }
   else if (a == "ellipse") {
     ellipse(x,y,l,w);
   }
   
   textAlign(CENTER,CENTER);
   fill(textcolor);
   textSize(textsize);
   textLeading(textsize);
   text(text,textx,texty);
 }
  
  
  /**************************************************************************************************************************************************
  The performing part of the block.
  It sets a target based on how many frames it has to move and then it moves until the target is reached.
  Then it moves on to the next chosen programming block by increasing the currentblock variable.
  **************************************************************************************************************************************************/
  void blockW(float a) {
    if (setTarget == true) {
      setTarget = false;
      frametarget = float(frameCount)+a*drone.meter/drone.hspeed;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyW = true;
    }
    else {
      drone.keyW = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockS(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+a*drone.meter/drone.hspeed;
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyS = true;
    }
    else {
      drone.keyS = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockA(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+a*drone.meter/drone.hspeed;
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyA = true;
    }
    else {
      drone.keyA = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockD(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+a*drone.meter/drone.hspeed;
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyD = true;
    }
    else {
      drone.keyD = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockUp(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+a*drone.meter/drone.vspeed;
      if (drone.z+a*drone.meter >= drone.zmax) {
        frametarget = float(frameCount)+((drone.zmax-drone.z)/drone.vspeed);
      }
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyUp = true;
    }
    else {
      drone.keyUp = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockDown(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+a*drone.meter/drone.vspeed;
      if (drone.z-a*drone.meter <= drone.zmin) {
        frametarget = float(frameCount)+abs((drone.zmin-drone.z)/drone.vspeed);
      }
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyDown = true;
    }
    else {
      drone.keyDown = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockYl(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+radians(a)/drone.thetaspeed;
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyLeft = true;
    }
    else {
      drone.keyLeft = false;
      setTarget = true;
      currentblock++;
    }
  }
  
  void blockYr(float a) {
    if (setTarget == true) {
      frametarget = float(frameCount)+radians(a)/drone.thetaspeed;
      setTarget = false;
    }
    else if (float(frameCount) <= frametarget) {
      drone.keyRight = true;
    }
    else {
      drone.keyRight = false;
      setTarget = true;
      currentblock++;
    }
  }
}
