
class Bullet {
  float xPos, yPos;
  float speed = 10; 

  Bullet(float x, float y) {
    xPos = x;
    yPos = y;
  }

  void update() {
      yPos -= speed;
  }
  
  void draw() {
    stroke(255); 
    strokeWeight(4);
    line(xPos, yPos, xPos, yPos + 6); 
  }
}
