// 사과 피하기 게임에 무적 시간 추가

int appleX;
float appleY; // 사과(유성) y좌표 실수형으로 변경.
int basketX;
int basketW = 300; // 바구니 너비 변수로 추가. 60 -> 200 -> 300
int score = 0;
boolean gameOver = false;
float speed = 0.3; // 유성 속도 증가

// 무적 변수
boolean invincible = false; // 무적 유무
int invStart = 0;
int invLastUsed = -12000;
int invCD = 12000;  // 12초 쿨타임
int invDur = 3000;  // 3초 지속

// 제한 시간 추가 <- X
//int startTime;
//int gameTime = 30;


void setup() {
  size(800, 400); // 맵 크기 변경
  resetApple();
  basketX = 250; // 바구니 시작 위치 조정.
}

void draw() {
  background(255);
  int now = millis(); // 시간 계산.

  if (!gameOver) {
    appleY += 4; // 이게 틱마다 애플 Y좌표 변화시키는 거잖음;; 

    // 무적 상태 해제 조건.
    if (invincible && now - invStart > invDur) {
      invincible = false;
    }

    // 충돌 시 게임 오버(사과 피하기)
    if (!invincible && appleY >= 370 && appleX >= basketX && appleX <= basketX + basketW) {
      gameOver = true;
    }
    
    // 사과 피하면 점수 +1
    if (appleY > height) {
      score++;
      resetApple();
    }
    
    // 점수 추가되면 유성(사과) 속도 증가
    if (score >= 5) {
      appleY += speed;
    }
    if (score >= 10) {
      appleY += speed;
      basketW = 350; // 바구니 크기 증가
    }
    if (score >= 15) {
      appleY += speed;
    }
    if (score >= 20) {
      appleY += speed;
    }
    if (score >= 30) { // 난이도 기하급수적 증가
      appleY ++;
      basketW = 400; // 바구니 크기 증가
    }
    if (score >= 40) {
      appleY ++;
    }
  }

  // 사과
  fill(int(random(0, 255)), int(random(0, 255)), int(random(0, 255))); // 사과에서 유성으로 변경.
  ellipse(appleX, appleY, 55, 55); // 유성(사과) 크기 대폭 증가

  // 바구니
  fill(invincible ? color(0, 0, 255) : color(0));
  rect(basketX, 370, basketW, 20);

  // 점수
  fill(0);
  textSize(20);
  text("score : " + score, width / 2 - 30, 30);
  
  // 현재 속도 -> 점수가 증가하면 변하는 속도를 기록하고 싶었는데 역량 이슈로 실패.
  //fill(0);
  //textSize(12);
  //text("now speed : " + speed, 10, 70);

  // 무적 상태 | 쿨타임 표시
  textSize(14);
  if (invincible) {
    int left = (invDur - (now - invStart)) / 1000;
    text("mujak (" + left + "sec namum)", 10, 50);
  } else {
    int cdLeft = (invCD - (now - invLastUsed)) / 1000;
    if (cdLeft > 0) {
      text("cooldown (" + cdLeft + "sec)", 10, 50);
    } else {
      text("Shift key press ssak ssak mujak", 10, 50);
    }
  }

  // 게임 오버
  if (gameOver) {
    textSize(32);
    text("GAME OVER!", width / 2 - 80, height / 2);
    textSize(20);
    text("SCORE : " + score, width / 2 - 35, height / 2 - 40);
    textSize(20);
    fill(128);
    text("Press Enter SSAK SSAK Game ReStart", width / 2 - 155, height / 2 - 70);
    if (keyCode == ENTER) { // 게임 오버 시 엔터 키 누르면 게임 다시 시작, 지금 게임 재시작하면 무적 쿨타임이 없어지는 버그 발생 -> 해결
      invLastUsed = -12000; // 무적 쿨타임 초기화
      now = 0;
      score = 0; // 점수 초기화
      gameOver = false; // 게임 오버 상태 복귀
    }
  }
}

void keyPressed() {
  int now = millis(); // 시간 계산 싹싹.
  if (key == 'a' || keyCode == LEFT) {
    basketX -= 3;
  } else if (key == 'd' || keyCode == RIGHT) {
    basketX += 3;
  } else if (keyCode == SHIFT && !invincible && now - invLastUsed >= invCD) { // SHIFT 누르면 무적, 쿨타임도 함꼐 계산.
    invincible = true;
    invStart = now;
    invLastUsed = now;
  }
}

// 사과 초기 위치 싹싹 계산.
void resetApple() {
  appleX = int(random(50, 750));
  appleY = 0;
}
