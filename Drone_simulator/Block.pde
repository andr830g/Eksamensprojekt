class Block {
  float x;
  float y;
  float len;
  float wid;
  int textsize;
  color stroke;
  float[] text = new float[0];
  float value;
  
  int indextext;
  String[] indexunit = {"m","m","m","m","m","m","deg","deg","","m/s","m/s","deg/s"};
  
  int repeatTimes;
  int repeatBlocks;
  
  
  Block() {
    textsize = 16;
  }
  
  
  /**************************************************************************************************************************************************
  Creating a block at the location of the i'th number.
  The indextext is choosing which text from the indexblocks to show.
  **************************************************************************************************************************************************/
  void displayChosen(int iin) {
    int i = iin-programming.indexblock.length;
    x = programmingMovex;
    wid = 40;
    len = 3*wid;
    y = wid+i*1.5*wid;
    
    if (indextext == 8) {
      if (text.length > 0) {
        repeatBlocks = int(text[0]); //determines the amount of blocks within the repeat block
      }
      repeatTimes = 0;
      for (int j = 0; j < text.length-1; j++) {
        repeatTimes+=reverse(text)[j]*pow(10,j); //determines the amount of times to repeat
      }
    }
    else {
      //Creating the number from the textarray.
      value = 0;
      for (int j = 0; j < text.length; j++) {
        value+=reverse(text)[j]*pow(10,j); //calculating the value from the input
      }
    }
    
    //Creating an array with the value and the corresponding unit.
    String[] unit;
    if (indextext == 8) { //repeat
      unit = new String[4];
      unit[0] = nf(repeatBlocks,1,0); //converts the number of blocks to be repeated to a number at least with 1 digit.
      unit[1] = " blocks ";
      unit[2] = nf(repeatTimes,1,0); //converts the number of times to be repeated to a number with at least 1 digit.
      unit[3] = " times";
    }
    else {
      unit = new String[2];
      unit[0] = nf(value,1,1); //converts variabel value to text with at least 1 digits and 1 decimalplaces
      unit[1] = indexunit[indextext];
    }
    
    
    //Merging the indextext from the indexblock with the value and the corresponding unit.
    String[] textdisplay = new String[2];
    textdisplay[0] = programming.indexblock[indextext];
    textdisplay[1] = join(unit,"");
    String joinedTextdisplay = join(textdisplay,"\n"); //"\n” is short for new line
    
    //Determining the stroke color by checking if the block is performed or not.
    if (programming.perform == true && programming.currentBlock-programming.indexblock.length == i) {
      stroke = color(255,255,255,100);
    }
    else {
      stroke = color(155,155,155,100);
    }
    
    //Displaying the block
    if (indextext == 8) {
      programming.blockDisplay("repeat",x,y,len,wid,true,stroke,false,color(0),joinedTextdisplay,color(255,255,255,100),textsize);
    }
    else {
      programming.blockDisplay("dynamic",x,y,len,wid,true,stroke,false,color(0),joinedTextdisplay,color(255,255,255,100),textsize);
    }
  }
  
  
  void displayIndex(int i) {
    wid = (height)/(programming.indexblock.length);
    len = 2*wid;
    x = len/2;
    y = (0.5+i)*wid;
    programming.blockDisplay("index",x,y,len,wid,true,color(155,155,155,100),false,color(0),programming.indexblock[i],color(255,255,255,100),16);
  }
}
