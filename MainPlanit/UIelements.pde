color colorPick1 = color(0, 195, 255);
color colorPick2 = color(200, 200, 200);
boolean isColor1Visible = false;
PVector PVcannonTip = new PVector();
float angle = 45;
int count = 1;

//Variables for moving planets
Attractor selected;
boolean lockedToMouse;
float xOffset = 0.0; 
float yOffset = 0.0;
int selectionOffset = 20;

//Columns ||
final float c1 = 0.05;
final float c2 = 0.17;
final float c3 = 0.33;
final float c4 = 0.85;
//Rows --
final float r1 = 0.135;
final float r2 = 0.095;
final float r3 = 0.06;

void createInputControllers() {
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Arial", 11));
  cp5.setColorBackground(color(45, 45, 45));

  //cp5.addTextfield("NAME").setPosition(width*c1, height - height*r1).setSize(125, 20);

  cp5.addButton("ATTRACTOR COLOR").setValue(0).setPosition(width*c2, height - height*r1).setSize(125, 20); 
  cp5.addSlider("MASS").setValue(1).setPosition(width*c2, height - height*r2).setSize(125, 20).setRange(0.5, 5); 

  cp5.addSlider("RADIUS").setValue(1.5).setPosition(width*c2, height - height*r3).setSize(125, 20).setRange(1, 4);

  //cp5.addLabel("TXT_GRAVITY").setValue("GRAVITY(m/s^2)").setPosition(width*c1, height - height*r2).setSize(125, 15);
  //cp5.addLabel("TXT_RADIUS").setValue("RADIUS(km)").setPosition(width*c1, height - height*r3).setSize(125, 15);

  cp5.addSlider("Initial Velocity").setValue(3).setPosition(width*c3, height - height*r2).setSize(125, 20).setRange(1, 8); 
  cp5.addKnob("ANGLE").setPosition(width*c4, height - height*r1).setSize(80, 80).setRange(0, 360)
    .setValue(45).setNumberOfTickMarks(10).setTickMarkLength(4).setViewStyle(Knob.ELLIPSE).setAngleRange(PI*2);

  cp5.addColorWheel("COLORPICK").setPosition(width/2.5, height/4.5).hide().setColorValue(color(255, 128, 0));  
  cp5.addButton("reset").setPosition(width*0.92, height - height *0.98).setColorBackground(color(45, 45, 45)).setSize(85, 25);

  addListBox();
}

float halfWidth() {
  return width - width/2;
}
float halfHeight() {
  return height - height/2;
}

void addListBox() {
  cp5.addListBox("HELP").setPosition(0, height - height).setColorBackground(color(45, 45, 45)).setSize(325, 750)
    .setBarHeight(20).setItemHeight(20).setOpen(false).addItem("right click -> (place attractor)", 0).addItem("s -> (shoot projectile)", 1)
    .addItem("r -> (reset)", 2).addItem("mouse scrool -> (adjust vector angle)", 3).addItem("? How to get started ?", 4);
}
void addListBox2() {
  cp5.addListBox("HELP").setPosition(0, height - height).setColorBackground(color(45, 45, 45)).setSize(325, 750)
    .setBarHeight(20).setItemHeight(20).setOpen(true).addItem("1. Select a color for the attractor", 1)
    .addItem("2. Ajust the attractor's gravity", 2).addItem("3. Adjust the projectiles initial velocity", 3).addItem("4. Place an attractor", 4).addItem("5. Shoot projectiles around the attractor", 3).addItem("6. Observe!", 5).addItem("< Back", 6);
}

void drawBackUI() {
  //Left
  float relativeH = height/6;  
  fill(20, 20, 20);
  translate(0, -relativeH); 
  rect(0, height, width, relativeH);
  translate(0, relativeH);
}

void drawIntro() {
  background(0);
  pushMatrix();
  tint(255-(frameCount*2)%155);
  image(clickImg, width/2, height-height/8);
  popMatrix();
  tint(255);
  image(logoImg, width/2, height/2-10);
}

void drawArrow() {
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(radians(getAngle()));
  translate(-mouseX, -mouseY);
  vectorShape.setStroke(color(255)); 

  shape(vectorShape, mouseX-30, mouseY-10);
  popMatrix();
}

void showColorPicker() {
  cp5.getController("GRAVITY").show();
}

//--EVENT HANDLERS:
void controlEvent(ControlEvent event) {
  if (event.isFrom(cp5.getController("ATTRACTOR COLOR"))) {
    if (isColor1Visible == true) {
      cp5.getController("COLORPICK").hide();
      isColor1Visible = false;
      colorPick1 = cp5.get(ColorWheel.class, "COLORPICK").getRGB();
      cp5.getController("ATTRACTOR COLOR").setColorLabel(colorPick1);
      //println(cp5.get(ColorWheel.class, "COLORPICK").getRGB());
    } else {
      cp5.getController("COLORPICK").setVisible(true);
      isColor1Visible = true;
    }
  }

  if (event.isFrom(cp5.getController("HELP"))) {
    if (cp5.getController("HELP").getValue() == 6) {
      resetLb();
      addListBox();
    } else if (cp5.getController("HELP").getValue() == 4) {
      resetLb();
      addListBox2();
    } else {
      resetLb();
      addListBox();
    }
  }
}
void resetLb() {
  cp5.getController("HELP").remove();
}

boolean overAttractor() {
  for (Attractor attractor : attractors) {
    if (mouseX >= attractor.getX() - selectionOffset && mouseX <= attractor.getX() + attractor.sizeSphere + selectionOffset
      && mouseY >= attractor.getY() - selectionOffset && mouseY <= attractor.getY() + attractor.sizeSphere + selectionOffset) {
      selected = attractor;
      return true;
    }
  }
  return false;
}

void mousePressed() {
  introOn = false;
  //attractors.add(new Attractor());
  if (mouseButton == LEFT) {
    if (attractors.size() != 0) {
      if (overAttractor()) {
        lockedToMouse = true;
      } else {
        lockedToMouse = false;
      }

      if (selected != null) {
        xOffset = mouseX - selected.getX(); 
        yOffset = mouseY - selected.getY();
      }
    }
  } else if (mouseButton == RIGHT) {
    attractors.add(new Attractor("New planet " + count, mouseX, mouseY));
  }
}

void mouseDragged() {
  if (lockedToMouse) {
    selected.setX(mouseX - xOffset);
    selected.setY(mouseY - yOffset);
  }
}

void mouseReleased() {
  lockedToMouse = false;
}

void keyPressed() { 
  if (key == 'r') {
    reset();
  }
  if (key == 's') {
    if (!attractors.isEmpty()) {
      projectiles.add(new Projectile());
    }
  }
  if (key == 'n') {
    print(6.674 * Math.pow(10, -11) * getMass() * 5.972 * Math.pow(10, 24) / Math.pow((12742 / 2 * getSize()) * 1000, 2));
  }
  if (key == ENTER) {
    if (isColor1Visible == true) {
      cp5.getController("COLORPICK").hide();
      isColor1Visible = false;
      colorPick1 = cp5.get(ColorWheel.class, "COLORPICK").getRGB();
      cp5.getController("ATTRACTOR COLOR").setColorLabel(colorPick1);
      //println(cp5.get(ColorWheel.class, "COLORPICK").getRGB());
    }
  }
}

void reset() {
  projectiles.clear();
  attractors.clear();
  count = 1;
}

void mouseWheel(MouseEvent event) {
  angle += 2*event.getCount();
  angle = angle % 360;
  cp5.getController("ANGLE").setValue(angle);
}

// --GETTERS--
float getGravity() {
  return cp5.getController("GRAVITY").getValue();
}
float getAngle() {
  return cp5.getController("ANGLE").getValue();
}
float getSize() {
  return cp5.getController("RADIUS").getValue();
}
float getMass() {
  return cp5.getController("MASS").getValue();
}
float getInVelocity() {
  return cp5.getController("Initial Velocity").getValue();
}
