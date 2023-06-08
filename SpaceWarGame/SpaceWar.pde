PImage jetImage;
PImage enemyImage;
PImage bulletImage;
PImage spaceImage;

boolean gameStarted = false;
boolean gameRestarted = false;

ArrayList<PVector> stars;
int numStars = 100;
boolean[] starStates;
int minBrightness = 50;
int maxBrightness = 255;
int fadeSpeed = 5;

int enemyX, enemyY, enemySpeed;

int userX;

int bulletX, bulletY, bulletSpeed;
boolean bulletFired;

int gameTime;
int gameEndTime;

int score;

void setup() {
  fullScreen();
  stars = new ArrayList<PVector>();
  starStates = new boolean[numStars];
  
  for (int i = 0; i < numStars; i++) {
    float x = random(width);
    float y = random(height);
    stars.add(new PVector(x, y));
    starStates[i] = true;
  }
  
  jetImage = loadImage("fighter-jet.png");
  enemyImage = loadImage("enemy-jet.png");
  bulletImage = loadImage("bullet-image.png");
  spaceImage = loadImage("space-image.png");
  
  enemyX = floor(random(width*0.05,width*0.90)); 
  enemyY = 0;
  enemySpeed = 4;
  userX = width/2; 
  bulletX = userX;
  bulletY = height;
  bulletSpeed = 12;
  bulletFired = false;
  gameTime = 0;
  gameEndTime = 60; 
  score = 0;
}

void draw() {
  background(0);
  
  if (gameStarted) {
    
  drawStars();
  
  gameTime = millis()/1000;

  if (gameTime >= gameEndTime) {
    endGame();
    return;
  }
  
  fill(0, 255, 0);
  image(jetImage, userX+10, height-140, 180, 150);
  
  fill(255, 0, 0);
  image(enemyImage, enemyX+50, enemyY-20, 100, 100);
  
  if (bulletFired) {
    image(bulletImage, bulletX, bulletY-110, bulletImage.width/2 , bulletImage.height /2);
  }
  
  enemyY += enemySpeed;
  if (enemyY > height) {
    endGame();
    return;
  }
  
  if (bulletFired) {
    bulletY -= bulletSpeed;
    if (bulletY < 0) {
      bulletFired = false;
    } else if (bulletY > enemyY && bulletY < enemyY + 80 && bulletX > enemyX && bulletX < enemyX + 120 ) {
      enemyX = round(random(width*0.1,width*0.90));
      enemyY = 0;
      score += 50;
      bulletFired = false;
    }
  }
  
  if (keyPressed) {
    if (keyCode == LEFT || key == 'a' || key == 'A') {
      userX -= 7;
    } else if (keyCode == RIGHT ||key == 'd' || key == 'D') {
      userX += 7;
    }
  }
  
  textSize(24);
  fill(255);
  text("Score: " + score, width*0.03, height*0.05);
  
  int timeLeft = gameEndTime - gameTime;
  text("Time Left: " + timeLeft, width*0.95, height*0.05);
  } else if(gameRestarted) {
    drawRestartScreen();
  }
  else{
    drawStartScreen();
  }
  

  
}

void drawStars(){
  for (int i = 0; i < numStars; i++) {
    PVector star = stars.get(i);
    boolean state = starStates[i];
    
    if (state) {
      fill(83, 158, 212);
      ellipse(star.x, star.y, 5,5);
      
      if (random(1) < 0.01) { 
        starStates[i] = false;
      }
    } else {
      fill(minBrightness);
      ellipse(star.x, star.y, 2, 2);
      
      if (random(1) < 0.01) { 
        starStates[i] = true;
      }
    }
  }
}

void drawStartScreen() {
  drawStars();
  textAlign(CENTER);
  textSize(220);
  
  fill(252, 161, 3);
  text("SPACE WAR", width/2-20, height/3 - 20);
  image(jetImage , width/2-250, height/2);
  image(spaceImage,0,0);


  drawButton("Start", width/2, height/2-50, 300, 90, color(252, 161, 3), color(18,15,102));
}
void drawRestartScreen() {
  drawStars();
  textSize(66);
  fill(252, 161, 3);
  textAlign(CENTER, height);
  if (enemyY >= height) {
    text("Game Over!\nEnemy aircraft crossed the lower border.\nYour Score: " + score, width/2, height/5);
    text("Press ESC button for exit.", width/2, height/2+150); 
  } else {
    text("Game Over!\nTime's Up!\nYour Score: " + score, width/2, height/5);
    
  }

  drawButton("Restart", width/2, height/2+20, 350, 100, color(252, 161, 3), color(18,15,102));
}

void drawButton(String label, float x, float y, float width, float height, color bgColor, color textColor) {

  fill(bgColor);
  textSize(70);
  rectMode(CENTER);
  color(textColor);
  rect(x,y,width,height,80);


  fill(textColor);
  textAlign(CENTER, CENTER);
  text(label, x, y);
}
void mouseClicked() {
  if (!gameStarted && !gameRestarted) {
    
    if (mouseX >= width/2 - 150 && mouseX <= width/2 + 150 &&
        mouseY >= height/2 - 95 && mouseY <= height/2 - 5) {
      gameStarted = true;
      // Additional game initialization logic can be added here
    }
  } else if (gameRestarted) {
    
    if (mouseX >= width/2 - 175 && mouseX <= width/2 + 175 &&
        mouseY >= height/2 - 50 && mouseY <= height/2 + 50) {
      gameRestarted = false;
      gameStarted = true;
      setup();
      
    }
  }
  
}

void keyPressed() {
  if (gameStarted) {
    if (keyCode == ENTER) {
    setup();
  }
  
  }
}

void mousePressed() {
  
    bulletX = userX+60 ;
    bulletY = height-50;
    bulletFired = true;
 
}

void endGame() {
  
  gameStarted = false;
  gameRestarted = true;
  drawRestartScreen();
}
