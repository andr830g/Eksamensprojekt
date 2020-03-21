class Programming {
  float frametarget;
  float thetatarget;
  boolean setTarget;
  boolean perform;
  int currentblock;
  
  float xchoose;
  float rchoose;
  float spacechoose;
  String[] indexblock = {"FORWARD","BACKWARD","LEFT","RIGHT","UP","DOWN","YAW LEFT","YAW RIGHT","REPEAT"};
  
  float rgo;
  float xgo;
  float ygo;
  
  int repeatindex;
  int repeattimesindex;
  int repeatTimes;
  int itemsInRepeat;
  boolean setRepeat;
  
  
  Programming() {
    setTarget = true;
    thetatarget = drone.theta;
    perform = false;
    currentblock = 0;
    
    repeatindex = 1;
    repeattimesindex = 1;
    setRepeat = true;
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
      blockDisplay("index",xchoose,ychoose,rchoose,rchoose,true,color(155,155,155,100),false,color(0),indexblock[i],color(255,255,255,100),xchoose,ychoose,16);
    }
    
    //Displaying the GO button
    rgo = 50;
    xgo = 2*programming_movex-rgo-10;
    ygo = rgo+10;
    blockDisplay("index",xgo,ygo,rgo,rgo,false,color(0,0,0),true,color(0,255,0,100),"GO",color(0,0,0,100),xgo,ygo,40);
    
    //Displaying the chosen programming blocks
    for(int i = 0; i < numofchosenblocks; i++) {
      block[i].displayChosen(i);
    }
  }
  
  
  /**************************************************************************************************************************************************
  If perform is true then the program will perform the number of chosen programming blocks or reset the them.
  If perform is false and colision is true then the performColision() will perform.
  **************************************************************************************************************************************************/
  void perform() {
    if (perform == true) { //Performing the programming blocks
      if (currentblock < numofchosenblocks) {
        performProgramming(currentblock,false);
      }
      else { //reseting the programming blocks.
        perform = false;
        currentblock = 0;
        numofchosenblocks = 0;
        setRepeat = true;
        
        for (int i = 0; i < block.length; i++) {
          block[i] = new Block();
        }
      }
    }
    else if (colision == true) {
      performColision();
    }
  }
  
  
  /**************************************************************************************************************************************************
  The value at the i'th place in the programming array is determining which action tp perform.
  **************************************************************************************************************************************************/
  void performProgramming(int i, boolean repeat) {
    if (indexblock[block[i].indextext] == "FORWARD") { //0
      blockW(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "BACKWARD") { //1
      blockS(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "LEFT") { //2
      blockA(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "RIGHT") { //3
      blockD(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "UP") { //4
      blockUp(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "DOWN") { //5
      blockDown(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "YAW LEFT") { //6
      blockYl(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "YAW RIGHT") { //7
      blockYr(block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "REPEAT") { //8
      blockRepeat(block[i].repeatTimes,block[i].repeatBlocks,i);
    }
  }
  
  
  /**************************************************************************************************************************************************
  Defines a blockarray which moves the drone back to the original starting position.
  **************************************************************************************************************************************************/
  void performColision() {
    //Rotating the drone to theta = 0
    if (drone.theta < 0) {
      block[0].indextext = 6;
      block[0].text = append(block[0].text,abs(degrees(drone.theta))%360);
      numofchosenblocks++;
    }
    else {
      block[0].indextext = 7;
      block[0].text = append(block[0].text,abs(degrees(drone.theta)%360));
      numofchosenblocks++;
    }
    
    //Correcting the y position to y = 0
    if (drone.y < 0) {
      block[1].indextext = 0;
      block[1].text = append(block[1].text,abs(drone.y/drone.meter));
      numofchosenblocks++;
    }
    else {
      block[1].indextext = 1;
      block[1].text = append(block[1].text,abs(drone.y/drone.meter));
      numofchosenblocks++;
    }
    
    //Correcting the x position to x = 0
    if (drone.x < 0) {
      block[2].indextext = 2;
      block[2].text = append(block[2].text,abs(drone.x/drone.meter));
      numofchosenblocks++;
    }
    else {
      block[2].indextext = 3;
      block[2].text = append(block[2].text,abs(drone.x/drone.meter));
      numofchosenblocks++;
    }
    
    //Correcting the altitude to z = the minimum height of the drone
    if (drone.z > drone.zmin) {
      block[3].indextext = 5;
      block[3].text = append(block[3].text,abs((drone.z-drone.zmin)/drone.meter));
      numofchosenblocks++;
    }
    
    colision = false;
    perform = true;
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
   
   if (a == "dynamic") { //The blocks to be programmed
     //rect(x,y,l,w);
     beginShape();
     vertex(x-l/2,y-w);
     vertex(x,y-w/2);
     vertex(x+l/2,y-w);
     vertex(x+l/2,y+w/2);
     vertex(x,y+w);
     vertex(x-l/2,y+w/2);
     endShape(CLOSE);
   }
   else if (a == "index") { //The index blocks to choose from
     ellipse(x,y,l,w);
   }
   else if (a == "repeat") { //The repeat block which is adding a marker besides it to show the number of blocks within the repeat block.
     int i = int((y-w)/(1.5*w)); //calculates which place in the object array the repeat block is.
     float repeatblocklength = (block[i].repeatBlocks)*1.5*w; //Calculates the length if the marker
     beginShape();
     vertex(x-l/2,y-w);
     vertex(x,y-w/2);
     vertex(x+l/2,y-w);
     vertex(x+l/2,y+w/2);
     vertex(x,y+w);
     vertex(x-l/2,y+w/2);
     vertex(x-l/2,y+w/2+repeatblocklength);
     vertex(x-l/2-10,y+w/2+repeatblocklength);
     vertex(x-l/2-10,y-w);
     endShape(CLOSE);
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
  void blockW(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {//If the block is within a repeat block then it wont move on the the next block unless
        currentblock++; //The repeat block has repeated the amount of times it should.
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockS(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockA(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockD(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockUp(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockDown(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockYl(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockYr(float a, boolean repeat) {
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
      
      repeatindex++;
      if (repeatindex > itemsInRepeat && repeattimesindex == repeatTimes-1 && repeat == true) {
        currentblock++;
      }
      else if (repeat == false) {
        currentblock++;
      }
    }
  }
  
  void blockRepeat(int repeatTimesin, int itemsInRepeatin, int repeatBlockId) {
    repeatTimes = repeatTimesin;
    itemsInRepeat = itemsInRepeatin;
    if (setRepeat == true) { //Initiates the repeat parameters.
      repeatindex = 1;
      repeattimesindex = 1;
      setRepeat = false;
    }
    
    if (repeatindex <= itemsInRepeat && repeattimesindex < repeatTimes) { //A block will be performed if the block that has to be performed isn't larger than the amount of blocks to be repeated.
      int a = repeatBlockId+repeatindex; //And the amount of times the blocks has been repeated isn't larger than the amount of times they should be repeated.
      performProgramming(a,true);
    }
    else if (repeattimesindex < repeatTimes) { //The amount of times it has been repeated adds 1 and the block to be repeated starts over from 1
      repeatindex = 1;
      repeattimesindex++;
    }
    else if (repeattimesindex == repeatTimes) { //If the blocks has been repeated the amount of times it should be repeated then the repeat block will stop and the blocks will be run as normal
      currentblock = repeatBlockId+1;
      setRepeat = true;
    }
  }
}
