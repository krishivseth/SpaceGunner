import ddf.minim.*;

Minim minim;
AudioPlayer[] sounds;
AudioPlayer pew_sound;

// Constants for game states and difficulty levels
final int START_SCREEN = 0, GAME_SCREEN = 1;
int gameState = START_SCREEN;

final int EASY = 0, MEDIUM = 1, HARD = 2;
int difficulty = EASY;

final int WINDOW_WIDTH = 300;
final int WINDOW_HEIGHT = 600;
PImage alienImage;

// Game Variables
Player player;
ArrayList<Alien> aliens;
ArrayList<Bullet> bullets;
int score;
int health;
boolean gameOver;

void setup() {
  size(300, 600);
  
  // img for alien
  alienImage = loadImage("alien.png");
  alienImage.resize(50, 50);
  
  minim = new Minim(this);
  sounds = new AudioPlayer[3];
  sounds[0] = minim.loadFile("s1.mp3");
  sounds[1] = minim.loadFile("s2.mp3");
  sounds[2] = minim.loadFile("s3.mp3");
  pew_sound = minim.loadFile("pew.mp3");
  
  player = new Player(WINDOW_WIDTH / 2, WINDOW_HEIGHT - 50); // Start the player at the bottom center
  aliens = new ArrayList<Alien>();
  bullets = new ArrayList<Bullet>();
  score = 0;
  health = 100;
  gameOver = false;
  spawnAliens(8);

}
 
void drawStartScreen() {
  // initializes start screen
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Select Difficulty", width / 2, height / 4);
  
  textSize(20);
  text("Easy", width / 2, height / 2 - 30);
  text("Medium", width / 2, height / 2);
  text("Hard", width / 2, height / 2 + 30);
}

void mousePressed() {
  if (gameState == START_SCREEN) {
    // Checks to see which difficulty is selected
    if (mouseY > height / 2 - 45 && mouseY < height / 2 - 15) {
      difficulty = EASY;
      gameState = GAME_SCREEN;
      startGame();
    } else if (mouseY > height / 2 - 15 && mouseY < height / 2 + 15) {
      difficulty = MEDIUM;
      gameState = GAME_SCREEN;
      startGame();
    } else if (mouseY > height / 2 + 15 && mouseY < height / 2 + 45) {
      difficulty = HARD;
      gameState = GAME_SCREEN;
      startGame();
    }
  } 
}

void startGame() {
  player = new Player(WINDOW_WIDTH / 2, WINDOW_HEIGHT - 50);
  aliens.clear();
  bullets.clear();
  score = 0;
  health = 100;
  gameOver = false;
  
  // difficulty spawns different number of aliens! Hard is super difficult lmfao
  switch (difficulty) {
    case EASY:
      spawnAliens(6); 
      break;
    case MEDIUM:
      spawnAliens(10);
      break;
    case HARD:
      spawnAliens(20); 
      break;
  }
}

void spawnAliens(int numberOfAliens) {
  for (int i = 0; i < numberOfAliens; i++) {
    float x = random(8, WINDOW_WIDTH - 50); // Random x position
    float y = random(0, 50); // Random y position within the upper part of the screen
    aliens.add(new Alien(x, y));
  }
}

void draw() {
  background(0); 
  
  if (gameState == START_SCREEN) {
    drawStartScreen();
  } else if (!gameOver) {
  player.update();
  for (Alien alien : aliens) {
    alien.update();
    if (alien.yPos > WINDOW_HEIGHT) {
      health -= 10;
      aliens.remove(alien);
      spawnAliens(1); // Spawn a new alien to replace it
      break;
    } 
  }

    for (Bullet bullet : bullets) {
      bullet.update();
    }

    for (Alien alien : aliens) {
      alien.checkCollision(bullets);
    }
    
    // Remove dead aliens
    for (int i = aliens.size() - 1; i >= 0; i--) {
      if (aliens.get(i).isDead()) {
        aliens.remove(i);
        score += 10; // For example, increase the score by 10 for each alien destroyed
        spawnAliens(1);
      }
    }
    
    checkAlienPlayerCollision();

    player.draw();
    for (Alien alien : aliens) {
      alien.draw();
    }
    for (Bullet bullet : bullets) {
      bullet.draw();
    }
    displayHUD();
    checkGameOver();
  } 
  else {
    displayGameOverScreen();
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    player.moveLeft();
  } else if (key == 'd' || key == 'D') {
    player.moveRight();
  } else if (key == ' ') { // Spacebar to shoot
    bullets.add(player.shoot());
    pew_sound.play();
    pew_sound.rewind();
  }
}

void displayHUD() {
  fill(255); // Set text color to white
  textSize(16);
  text("Score: " + score, 40, 20);
  text("Health: " + health, 40, 40);
}

void checkGameOver() {
  if (health <= 0) {
    gameOver = true;
  }
}


void checkAlienPlayerCollision() {
    for (Alien alien : aliens) {
        // Check for rectangle-rectangle collision
        if (rectRectCollision(player.xPos, player.yPos, player.width, player.height, alien.xPos, alien.yPos, 50, 50)) {
            gameOver = true;
            break;
        }
    }
}

boolean rectRectCollision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    // Check if the rectangles are overlapping
    return (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2);
}


void displayGameOverScreen() {
  fill(255); // Set text color to white
  textSize(32);
  text("Game Over", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2);
  textSize(16);
  text("Final Score: " + score, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2 + 30);
}

void exit() {
    // Close each sound file
    for (AudioPlayer sound : sounds) {
        sound.close();
    }
    minim.stop();
    super.exit();
}
