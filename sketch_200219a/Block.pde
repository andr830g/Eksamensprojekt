class Block {
  float x;
  float y;
  float len;
  float space;
  int textsize;
  color a;
  int[] text = new int[0];
  int value;
  
  int indextext;
  
  
  Block() {
    x = programming_movex;
    len = 40;
    space = 5;
    textsize = 16;
  }
  
  
  /**************************************************************************************************************************************************
  Creating a block at the location of the i'th number.
  The indextext is choosing which text from the indexblocks to show.
  **************************************************************************************************************************************************/
  void displayChosen(int i) {
    
    //Choosing the y-position
    y = (0.5+i)*(len+2*space);
    
    //Creating the number from the textarray.
    value = 0;
    for (int j = 0; j < text.length; j++) {
      value+=reverse(text)[j]*pow(10,j);
    }
    
    //Creating an array with the nvalue and the corresponding unit.
    String[] unit = new String[2];
    unit[0] = str(value);
    if (indextext < 6) {
      unit[1] = "m";
    }
    else {
      unit[1] = "deg";
    }
    
    //Merging the indextext from the indexblock with the value and the corresponding unit.
    String[] textdisplay = new String[2];
    textdisplay[0] = programming.indexblock[indextext];
    textdisplay[1] = join(unit,"");
    String joinedTextdisplay = join(textdisplay,"\n"); //"\n” is short for new line
    
    //Determining the stroke color by checking if the block is performed or not.
    if (programming.perform == true && programming.currentblock == i) {
      a = color(255,255,255,100);
    }
    else {
      a = color(155,155,155,100);
    }
    
    //Displaying the block
    programming.blockDisplay("rect",x,y,3*len,len,true,a,false,color(0),joinedTextdisplay,color(255,255,255,100),x,y,textsize);
  }
}
