class Object {
  float obsx;
  float obsy;
  float obsl;
  float obsw;
  float obsh;
  
  float suntheta;
  
  Object() {
    suntheta = 0;
  }
  
  
  /**************************************************************************************************************************************************
  The placement of the shape is defined by the x,y,z coordinates of the drone.
  Then a large surface is defined and is set to reflect some light.
  **************************************************************************************************************************************************/
  void base(float w) {
    float translatex = -drone.x;
    float translatey = -drone.y;
    float translatez = -drone.z;
    fill(0,150,0,100);
    noStroke();
    translate(translatex,translatey,translatez);
    beginShape();
    shininess(0.3);
    rect(0,0,w,w);
    endShape();
    translate(-translatex,-translatey,-translatez);
  }
  
  
  /**************************************************************************************************************************************************
  The placement of the shape is defined by the x,y,z coordinates of the drone. It's also defined by the height of the object so it'll be in the middle.
  Drawing the shape and is set to reflect some light.
  **************************************************************************************************************************************************/
  void obstical(float x, float y, float l, float w, float h) {
    obsx = x;
    obsy = y;
    obsl = l;
    obsw = w;
    obsh = h;
    float translatex = obsx-drone.x;
    float translatey = obsy-drone.y;
    float translatez = obsh/2-drone.z;
    fill(155,155,155,100);
    noStroke();
    translate(translatex,translatey,translatez);
    beginShape();
    shininess(0.5);
    box(obsl,obsw,obsh);
    endShape();
    translate(-translatex,-translatey,-translatez);
  }
  
  
  /**************************************************************************************************************************************************
  Rotating the path of the sun 60 degrees and the placement is defined by the x,y,z coordinates of the drone.
  A sphere (the sun) is drawn and a spotlight is set to add light from the direction of the sun.
  **************************************************************************************************************************************************/
  void sun(float dist, float cyclespeed, float r) {
    suntheta-=radians(1/cyclespeed);
    float y = dist*cos(-suntheta);
    float z = dist*sin(-suntheta);
    float translatex = -drone.x;
    float translatey = y-drone.y;
    float translatez = z-drone.z;
    rotateZ(PI/3);
    translate(translatex,translatey,translatez);
    spotLight(245,245,80,0,0,0,0,cos(suntheta),sin(suntheta),-suntheta,4);
    fill(245,245,45,100);
    noStroke();
    beginShape();
    shininess(1);
    sphere(r);
    endShape();
    translate(-translatex,-translatey,-translatez);
    rotateZ(-PI/3);
  }
}
