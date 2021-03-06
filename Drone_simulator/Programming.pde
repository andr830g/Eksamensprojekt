class Programming {
  float frameTarget;
  boolean setTarget;
  boolean perform;
  int currentBlock;
  
  String[] indexblock = {"FORWARD","BACKWARD","LEFT","RIGHT","UP","DOWN","YAW LEFT","YAW RIGHT","REPEAT","HSPEED","VSPEED","THETASPEED"};
  
  float rgo;
  float xgo;
  float ygo;
  float rstop;
  float xstop;
  float ystop;
  
  int repeatIndex;
  int repeatTimesIndex;
  int repeatTimes;
  int itemsInRepeat;
  boolean setRepeat;
  
  
  Programming() {
    setTarget = true;
    perform = false;
    currentBlock = indexblock.length;
    
    repeatIndex = 1;
    repeatTimesIndex = 1;
    setRepeat = true;
  }
  
  
  /**************************************************************************************************************************************************
  Creating a black surface with the purpose of being a programming workspace.
  Creating a go button to start the program.
  Creating a stop button to stop the program.
  Showing the array of the index blocks.
  Showing the array of chosen programming blocks.
  **************************************************************************************************************************************************/
  void display() {
    fill(0,0,0,100);
    noStroke();
    rect(programmingMovex,height/2,2*programmingMovex,height);
    
    //Displaying the GO button and the STOP button
    rgo = 50;
    xgo = 2*programmingMovex-rgo-10;
    ygo = rgo+10;
    blockDisplay("GO",xgo,ygo,rgo,rgo,false,color(0,0,0),true,color(0,255,0,100),"GO",color(0,0,0,100),40);
    
    rstop = rgo;
    xstop = xgo;
    ystop = ygo+2.5*rgo;
    blockDisplay("STOP",xstop,ystop,rstop,rstop,false,color(0,0,0),true,color(255,0,0,100),"STOP",color(0,0,0,100),40);
    
    //Displaying the index blocks
    for (int i = 0; i < indexblock.length; i++) {
      block[i].displayIndex(i);
    }
    
    //Displaying the chosen programming blocks
    for(int i = indexblock.length; i < numofchosenblocks+indexblock.length; i++) {
      block[i].displayChosen(i);
    }
  }
  
  
  /**************************************************************************************************************************************************
  If perform is true then the program will perform the number of chosen programming blocks or reset the them.
  If perform is false and colision is true then the performColision() will perform.
  **************************************************************************************************************************************************/
  void perform() {
    if (perform == true) { //Performing the programming blocks
      if (currentBlock < numofchosenblocks+indexblock.length) {
        performProgramming(currentBlock,false);
      }
      else { //reseting the programming blocks.
        perform = false;
        currentBlock = indexblock.length;
        numofchosenblocks = 0;
        setTarget = true;
        setRepeat = true;
        
        for (int i = indexblock.length; i < block.length; i++) {
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
    if (block[i].indextext <= 7) {
      blockWASDUpDownLeftRight(block[i].indextext,block[i].value,repeat);
    }
    else if (indexblock[block[i].indextext] == "REPEAT") {
      blockRepeat(block[i].repeatTimes,block[i].repeatBlocks,i);
    }
    else if (block[i].indextext <= 11) {
      blockSpeed(block[i].indextext,block[i].value,repeat);
    }
  }
  
  
  /**************************************************************************************************************************************************
  Defines a blockarray which moves the drone back to the original starting position.
  **************************************************************************************************************************************************/
  void performColision() {
    //Rotating the drone to theta = 0
    int start = indexblock.length;
    if (drone.theta % (2*PI) > PI) {
      block[start].indextext = 6;
      block[start].text = append(block[start].text,degrees(2*PI-drone.theta));
      numofchosenblocks++;
    }
    else {
      block[start].indextext = 7;
      block[start].text = append(block[start].text,degrees(drone.theta));
      numofchosenblocks++;
    }
    
    //Correcting the y position to y = 0
    if (drone.y > 0) {
      block[start+1].indextext = 0;
      block[start+1].text = append(block[start+1].text,abs(drone.y/drone.meter));
      numofchosenblocks++;
    }
    else {
      block[start+1].indextext = 1;
      block[start+1].text = append(block[start+1].text,abs(drone.y/drone.meter));
      numofchosenblocks++;
    }
    
    //Correcting the x position to x = 0
    if (drone.x < 0) {
      block[start+2].indextext = 3;
      block[start+2].text = append(block[start+2].text,abs(drone.x/drone.meter));
      numofchosenblocks++;
    }
    else {
      block[start+2].indextext = 2;
      block[start+2].text = append(block[start+2].text,abs(drone.x/drone.meter));
      numofchosenblocks++;
    }
    
    //Correcting the altitude to z = the minimum height of the drone
    if (drone.z > drone.zmin) {
      block[start+3].indextext = 5;
      block[start+3].text = append(block[start+3].text,abs((drone.z-drone.zmin)/drone.meter));
      numofchosenblocks++;
    }
    
    colision = false;
    perform = true;
  }
  
  
  /**************************************************************************************************************************************************
  Visually showing a block defined by a set of placement, size, stroke, fill and text parameters.
  **************************************************************************************************************************************************/
  void blockDisplay(String a, float x, float y, float l, float w, boolean stroke, color strokecolor, boolean fill, color fillcolor, String text, color textcolor, float textsize) {
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
   
   textAlign(CENTER,CENTER);
   textSize(textsize);
   textLeading(textsize);
   
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
     
     fill(textcolor);
     text(text,x,y,l,w);
   }
   else if (a == "GO" || a == "STOP") { //The index blocks to choose from
     ellipse(x,y,l,w);
     
     fill(textcolor);
     text(text,x,y);
   }
   else if (a == "index") {
     rect(x,y,l,w);
     
     fill(textcolor);
     text(text,x,y,l,w);
   }
   else if (a == "repeat") { //The repeat block which is adding a marker besides it to show the number of blocks within the repeat block.
     int i = int((y-w)/(1.5*w))+indexblock.length; //calculates which place in the object array the repeat block is.
     float repeatblocklength = (block[i].repeatBlocks)*1.5*w; //Calculates the length of the marker
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
     
     fill(textcolor);
     text(text,x,y);
   }
 }
  
  
  /**************************************************************************************************************************************************
  The performing part of the block.
  It sets a target based on how many frames it has to move and then it moves until the target is reached.
  Then it moves on to the next chosen programming block by increasing the currentblock variable.
  **************************************************************************************************************************************************/
  void blockWASDUpDownLeftRight(int i, float a, boolean repeat) {
    if (setTarget == true) {
      frameTarget(i,a);
      setTarget = false;
    }
    else if (float(frameCount) <= frameTarget) {
      drone.keyState(i,true);
    }
    else {
      drone.keyState(i,false);
      setTarget = true;
      
      repeatIndex++;
      if (repeatIndex > itemsInRepeat && repeatTimesIndex > repeatTimes && repeat == true) {
        currentBlock++;
      }
      else if (repeat == false) {
        currentBlock++;
      }
    }
  }
  
  void frameTarget(int i, float a) {
    if (i <= 3) {
      frameTarget = float(frameCount)+a*drone.meter/drone.hspeed;
    }
    else if (i <= 5) {
      frameTarget = float(frameCount)+a*drone.meter/drone.vspeed;
      if (drone.z+a*drone.meter >= drone.zmax) {
        frameTarget = float(frameCount)+((drone.zmax-drone.z)/drone.vspeed);
      }
      if (drone.z+a*drone.meter <= drone.zmin) {
       frameTarget = float(frameCount)+((drone.z-drone.zmin)/drone.vspeed);
      }
    }
    else if (i <= 7) {
      a = radians(a)%(2*PI);
      frameTarget = float(frameCount)+a/drone.thetaspeed;
    }
  }
  
  /**************************************************************************************************************************************************
  First it's skipped if it's set to repeat 0 times.
  Then it resets parameters.
  Then it checks if it's valid to perform a new action, if it is the action is performed from performProgramming().
  If it's not valid because the number of actions has overseeded what's allowed then the repeatindex resets and the repeattimesindex adds 1.
  When the repeattimesindex is the number of times it should be repeated the repeat block stops and currentblock adds 1.
  **************************************************************************************************************************************************/
  void blockRepeat(int repeatTimesin, int itemsInRepeatin, int repeatBlockId) {
    repeatTimes = repeatTimesin;
    itemsInRepeat = itemsInRepeatin;
    if (repeatTimes == 0) { //Making sure that the repeat block is skipped if it's set to repeat 0 times
      currentBlock += itemsInRepeat+1;
    }
    if (setRepeat == true) { //Initiates the repeat parameters.
      repeatIndex = 1;
      repeatTimesIndex = 1;
      setRepeat = false;
    }
    
    if (repeatIndex <= itemsInRepeat && repeatTimesIndex <= repeatTimes) { //A block will be performed if the block that has to be performed isn't larger than the amount of blocks to be repeated.
      int a = repeatBlockId+repeatIndex; //And the amount of times the blocks has been repeated isn't larger than the amount of times they should be repeated.
      performProgramming(a,true);
    }
    else if (repeatTimesIndex <= repeatTimes) { //The amount of times it has been repeated adds 1 and the block to be repeated starts over from 1
      repeatIndex = 1;
      repeatTimesIndex++;
    }
    else if (repeatTimesIndex > repeatTimes) { //If the blocks has been repeated the amount of times it should be repeated then the repeat block will stop and the blocks will be run as normal
      currentBlock = repeatBlockId+itemsInRepeat+1;
      setRepeat = true;
    }
  }
  
  /**************************************************************************************************************************************************
  Changes the horizontal, vertical or rotational speed for the drone.
  **************************************************************************************************************************************************/
  void blockSpeed(int i,float a, boolean repeat) {
    if (indexblock[i] == "HSPEED") {
      drone.hSpeedParameter = a;
    }
    else if (indexblock[i] == "VSPEED") {
      drone.vSpeedParameter = a;
    }
    else if (indexblock[i] == "THETASPEED") {
      drone.thetaSpeedParameter = a;
    }
    if (repeatIndex > itemsInRepeat && repeatTimesIndex > repeatTimes && repeat == true) {
      currentBlock++;
    }
    else if (repeat == false) {
      currentBlock++;
    }
  }
}
