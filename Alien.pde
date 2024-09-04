
class Alien {
  float xPos, yPos;
  float speed = 5;
  float dropDownSpeed = 0.7;
  int health = 2; // how many hits needed to kill
  boolean isAlive = true; // track if the alien is still active

  // Alien constructor
  Alien(float x, float y) {
    xPos = x;
    yPos = y;
  }

  void move() {
    yPos += dropDownSpeed;
    
    if (xPos > width - 10 || xPos < 10) {
      speed *= -1; 
      yPos += dropDownSpeed;
    }
  }

  void update() {
    move();
  }

  void draw() {
    image(alienImage, xPos, yPos);
  }

    void checkCollision(ArrayList<Bullet> bullets) {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            Bullet bullet = bullets.get(i);
            // Check if bullet is within the rectang bounds of the alien image
            if (bullet.xPos >= xPos && bullet.xPos <= xPos + 50 && 
                bullet.yPos >= yPos && bullet.yPos <= yPos + 50) {
                
                health--;
                bullets.remove(i); // Remove the bullt that hit the alien

                if (health <= 0) {
                    isAlive = false;
                    int soundIndex = (int) random(0, 3);
                    sounds[soundIndex].play();
                    sounds[soundIndex].rewind();
                    break; 
                }
            }
        }
    }

  boolean isDead() {
    return !isAlive;
  
  
  }
}
