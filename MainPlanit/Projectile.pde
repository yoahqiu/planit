class Projectile {
  // The Projectile tracks location, velocity, and acceleration 
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxspeed;
  float size;
  // Projectile trail's variables
  int trailSize = 32; 
  float trailX[] = new float[trailSize];
  float trailY[] = new float[trailSize];

  Projectile() {
    location = new PVector(mouseX, mouseY);
    //velocity = new PVector(getInVelocity(), getInVelocity()); // the initial velocity 
    //velocity.rotate(getAngle()-90);
   // if (0 getAngle() ){
    //}
    velocity = new PVector(sin(radians(getAngle()))*getInVelocity(), cos(radians(getAngle()))*(-getInVelocity())); // 10 being the velocity 
    maxspeed = 20;
    size = 8;
  }

  void update() {
    // Compute the vector that points from location to closest attractor
    PVector planet = new PVector(attractors.get(closestIndx()).location.x, attractors.get(closestIndx()).location.y);
    PVector dir = PVector.sub(planet, location);

    dir.normalize();
    
    dir.mult((attractors.get(closestIndx()).calcInfoGravity())/10); // scale
    //dir.mult(getGravity()/10); // scale
    acceleration = dir;

    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
  }

  // return the index of the closest 
  int closestIndx() {
    int closest_i = 0;
    float closestDistance = 99999;
    for (int i = attractors.size()-1; i >= 0; i--) {
      Attractor attractor = attractors.get(i);
      float distance_i = dist(attractor.location.x, attractor.location.y, this.location.x, this.location.y);
      if (distance_i < closestDistance) {
        closestDistance = distance_i;
        closest_i = i;
      }
    }
    return closest_i;
  }

  void display() {
    // draw projectiles
    fill(110, 110, 110);
    translate(location.x, location.y, -size);
    sphere(size);
    translate(-location.x, -location.y, size);

    translate(0, 0, -size);
    drawTrails();
    translate(0, 0, size);
  }  

  void drawTrails() {
    fill(200, 200, 200);
    int point = frameCount % trailSize;
    trailX[point] = location.x;
    trailY[point] = location.y;

    for (int i = 0; i < trailSize; i++) {
      // which+1 is the smallest (the oldest in the array)
      int index = (point+1 + i) % trailSize;
      ellipse(trailX[index], trailY[index], i/2, i/2);
    }
  }

  //method to check collisons with planets
  void checkImpact() {
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    }  else if (location.y < 0) {
      location.y = height;
    }
  }
}
