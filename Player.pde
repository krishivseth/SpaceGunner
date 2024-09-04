
class Player {
  float xPos, yPos;
  float width = 10; 
  float height = 20; 
  int health;
  float speed = 10;

  Player(float x, float y) {
    xPos = x;
    yPos = y;
    health = 100; 
  }

  void moveLeft() {
    xPos -= speed;
    xPos = max(xPos, width / 2);
  }
  
  void moveRight() {
    xPos += speed;
    xPos = min(xPos, WINDOW_WIDTH - width / 2);
  }


  Bullet shoot() {
    return new Bullet(xPos, yPos - height / 2);
  }

  void update() {
    // nothing to update
  }

  void draw() {
    fill(255);
    rectMode(CENTER);
    rect(xPos, yPos, width, height); 
  }

  void checkCollision() {
    // check globally for now
  }
}
