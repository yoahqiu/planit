import controlP5.*;

ArrayList<Projectile> projectiles;
ArrayList<Attractor> attractors;
float vectorAngle = 0;
boolean introOn = true;
PImage clickImg; 
PImage logoImg;
PShape vectorShape;

ControlP5 cp5;
ColorPicker cp;

void setup() {
  //size(960,540,P3D);
  fullScreen(P3D);
  colorMode(RGB);
  noStroke();
  beginCamera();

  imageMode(CENTER);
  shapeMode(CENTER);
  clickImg = loadImage("clickText.png");
  logoImg = loadImage("planitLogo.png");
  vectorShape = loadShape("vector.svg");

  createInputControllers();

  attractors = new ArrayList<Attractor>();
  //attractors.add(new Attractor());

  projectiles = new ArrayList<Projectile>();
  //projectiles.add(new Projectile());
}

void draw() {

  if (introOn == true) {
    drawIntro();
    cp5.hide();
  } else {
    cp5.show();
    background(0, 0, 0);
    lights();
    drawArrow();
    drawBackUI();
    for (int i = attractors.size()-1; i >= 0; i--) {
      Attractor attractor = attractors.get(i);
      attractor.display();
    }
    for (int i = projectiles.size()-1; i >= 0; i--) {
      Projectile projectile = projectiles.get(i);
      projectile.update();
      //projectile[i].checkEdges();
      projectile.display();
    }
    cp5.addLabel("TXT_GRAVITY").setValue("Gravity: "+ calcGravity() + " m/s^2").setPosition(width*c1, height - height*r2).setSize(125, 20);
    cp5.addLabel("TXT_RADIUS").setValue("Radius: " +calcRadius() + " km").setPosition(width*c1, height - height*r3).setSize(125, 20);
    cp5.getController("TXT_GRAVITY");
  }
}

float calcGravity() {
  return (float)(6.674 * Math.pow(10, -11) * getMass() * 5.972 * Math.pow(10, 24) / Math.pow(calcRadius() * 1000, 2)) ;
}

//this is the radius of the planet (to be added on UI as info only) in KM
float calcRadius() {
  return 12742 / 2 * getSize();
}

float posX() {
  float x = mouseX;
  return x;
}

float posY() {
  float y = mouseY;
  return y;
}

float pos2X() {
  float x = mouseX/2;
  return x;
}

float pos2Y() {
  float y = mouseY/2;
  return y;
}
