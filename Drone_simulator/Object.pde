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
    fill(0,150,0,100);
    noStroke();
    translate(drone.x,drone.y,-drone.z);
    beginShape();
    shininess(0.3);
    rect(0,0,w,w);
    endShape();
    translate(-drone.x,-drone.y,drone.z);
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
    fill(155,155,155,100);
    noStroke();
    translate(-obsx+drone.x,-obsy+drone.y,-drone.z+obsh/2);
    beginShape();
    shininess(0.5);
    box(obsl,obsw,obsh);
    endShape();
    translate(obsx-drone.x,obsy-drone.y,drone.z-obsh/2);
  }
  
  
  /**************************************************************************************************************************************************
  Rotating the path of the sun 60 degrees and the placement is defined by the x,y,z coordinates of the drone.
  A sphere (the sun) is drawn and a spotlight is set to add light from the direction of the sun.
  **************************************************************************************************************************************************/
  void sun(float dist, float cyclespeed, float r) {
    suntheta-=2*PI/(360*cyclespeed);
    float y = dist*cos(-suntheta);
    float z = dist*sin(-suntheta);
    rotateZ(PI/3);
    translate(drone.x,-y+drone.y,z-drone.z);
    spotLight(245,245,80,0,0,0,0,cos(suntheta),sin(suntheta),-suntheta,4);
    fill(245,245,45,100);
    noStroke();
    beginShape();
    shininess(1);
    sphere(r);
    endShape();
    translate(-drone.x,y-drone.y,-z+drone.z);
    rotateZ(-PI/3);
  }
}
