class Attractor {
  String name; // add textield
  PVector location;
  float mass; //in earth mass (ie. 1 earth mass = 5.9 *10^24 kg)
  float radius; //in earth radius
  float sizeSphere; //in pixel scaling the real radius
  color rgb;

  Attractor() {
    location = new PVector(200, 150);
    //mass = 1; //mass in earth 
    sizeSphere = 15;
  }

//default planet create -> earth
  Attractor(String name, float x, float y) {
    this.name = name;
    location = new PVector(x, y);
    mass = getMass(); //to add slider
    radius = getSize(); //to link with size slider
    sizeSphere = 9 * radius;  
    rgb = colorPick1;
  }

  void display() {
    //draw attractor 
    fill(rgb);
    translate(location.x, location.y, -sizeSphere);
    sphere(sizeSphere);
    translate(-location.x, -location.y, sizeSphere);
  }  

  //this is the gravitational acceleration at surface (to be added on UI as info only) in m/(s^2)
  float calcInfoGravity() {
    return (float)(6.674 * Math.pow(10, -11) * mass * 5.972 * Math.pow(10, 24) / Math.pow(calcInfoRadius() * 1000, 2)) ;
  }
  
  //this is the radius of the planet (to be added on UI as info only) in KM
  float calcInfoRadius() {
    return 12742 / 2 * radius;
  }

  float getX() {
    return location.x;
  }
    
  float getY() {
    return location.y;
  }
  
  void setX(float x) {
    this.location.x = x;
  }
  
  void setY(float y) {
    this.location.y = y;
  }
}
