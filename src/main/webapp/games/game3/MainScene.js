// --- 전역 변수 --- 
let bestScore = 0;

class MainScene extends Phaser.Scene {
  constructor() {
    super("MainScene");

    this.unlockedAchievements = new Set();
    this.deathCount = 0;
    this.restartCount = 0;
    this.afkTime = 0;
    this.movingTime = 0;
    this.justDodgedClose = false;
    this.patternsSeen = 0;
    this.totalPatterns = 7; // single, circle, spiral, down, up, left, right
  }

  preload() {
    this.load.image("background", "assets/background_body.png");
    this.load.image("player", "assets/player.png");
    this.load.image("arrow", "assets/arrow.png");
  }

  init() {
    this.startTime = this.time.now; // 항상 새로 시작
    this.score = 0;                 // 점수 리셋
    this.isGameOver = false;        // 상태 리셋
    this.elapsed = 0;
  }

  create() {
    this.matter.world.resume(); // 다시 시작할 때 월드 재개
    // 리트라이 횟수 기록
    this.restartCount = (this.restartCount || 0) + 1;

    // 기존 이벤트 리스너 제거 후 새로 등록
    this.matter.world.off("collisionstart");
    this.matter.world.on("collisionstart", (event, bodyA, bodyB) => {
      if (bodyA.gameObject === this.player || bodyB.gameObject === this.player) {
        this.gameOver();
      }
    });

    // 배경/텍스트
    // 배경 (800x800 기준으로 중앙 배치)
    this.background = this.add.image(400, 400, "background").setDisplaySize(800, 800).setDepth(-1);

    // 게임 플레이 구역 (600x600, 중앙 400,400 기준)
    this.playArea = new Phaser.Geom.Rectangle(100, 100, 600, 600);

    // 👉 흰색 배경 그리기
    const graphics = this.add.graphics();
    graphics.fillStyle(0xffffff, 1); // 흰색, 불투명
    graphics.fillRectShape(this.playArea);

    // 배경은 항상 뒤로 보내기
    graphics.setDepth(-0.5);

    // 플레이어 생성 (중앙에 위치)
    this.player = this.matter.add.image(400, 400, "player");

    // 크기 줄이기 (가로세로 48픽셀)
    this.player.setDisplaySize(48, 48);

    // 다시 원형 충돌체 설정 (이미지가 리사이즈 되었으니 hitbox도 갱신)
    this.player.setCircle(16); // 반지름 24px
    this.player.setFrictionAir(0.05);
    this.player.setFixedRotation();

    // 👉 플레이어 움직임이 playArea 밖으로 안 나가게 하기 위해 이벤트 추가
    this.events.on("update", () => {
      if (!Phaser.Geom.Rectangle.Contains(this.playArea, this.player.x, this.player.y)) {
        // 벗어나면 강제로 안쪽으로 되돌리기
        this.player.x = Phaser.Math.Clamp(this.player.x, 100, 700);
        this.player.y = Phaser.Math.Clamp(this.player.y, 100, 700);
      }
    });

    // 예시: 점수 텍스트는 playArea 위쪽에 배치
    this.scoreText = this.add.text(110, 110, "Score: 0", {
      fontSize: "20px",
      color: "#000",
    });

    // 경과 시간
    this.startTime = this.time.now;
    this.timeText = this.add.text(110, 140, "Time: 0s", {
      fontSize: "20px",
      color: "#000",
    });

    // 게임 시작
    this.startTime = this.time.now;
    this.score = 0;
    this.elapsed = 0;
    this.isGameOver = false;

    this.arrows = [];
    this.seenPatterns = new Set();

    // 스코어 텍스트
    this.scoreText = this.add.text(10, 10, "점수: 0", { fontSize: "20px", fill: "#fff" });
    this.timerText = this.add.text(10, 40, "시간: 00:00", { fontSize: "20px", fill: "#fff" });

    // 재시작 카운트
    this.restartCount++;

    // 입력
    this.cursors = this.input.keyboard.createCursorKeys();

    // 충돌 이벤트 (플레이어 vs 화살)
    this.matter.world.on("collisionstart", (event, bodyA, bodyB) => {
      if (bodyA.gameObject === this.player || bodyB.gameObject === this.player) {
        this.gameOver();
      }
    });

    // 화살 저장용 배열 (Matter는 group 개념이 달라서 직접 관리)
    this.arrows = [];
    // 난이도 변수
    this.arrowSpeed = 120;
    this.spawnDelay = 1600;
    this.diffTimer = 0;

    // 패턴 생성 타이머
    this.spawnEvent = this.time.addEvent({
      delay: this.spawnDelay,
      loop: true,
      callback: () => this.spawnPattern(),
    });

    // 카테고리 정의
    this.arrowCategory = this.matter.world.nextCategory();
    this.playerCategory = this.matter.world.nextCategory();

    // 플레이어 충돌 설정
    this.player.setCollisionCategory(this.playerCategory);
    this.player.setCollidesWith(this.arrowCategory);

    // 이미 달성한 업적 저장
    this.unlockedAchievements = new Set();

    // 업적 체크용 상태 값들
    this.afkTime = 0;
    this.movingTime = 0;
    this.justDodgedClose = false;
    this.patternsSeen = 0;
    this.totalPatterns = 4;
    this.deathCount = 0;
    this.restartCount = 0;
    this.hitCount = 0;
  }

  update(time, delta) {
    if (this.isGameOver) return;

    // 이동
    const speed = 3; // Matter.js는 픽셀/프레임 단위라 Arcade보다 값이 작아야 함
    this.player.setVelocity(0, 0);
    if (this.cursors.left.isDown) this.player.setVelocityX(-speed);
    if (this.cursors.right.isDown) this.player.setVelocityX(speed);
    if (this.cursors.up.isDown) this.player.setVelocityY(-speed);
    if (this.cursors.down.isDown) this.player.setVelocityY(speed);

    // --- 점수 (시간 기반) ---
    // --- 경과 시간 ---
    const elapsed = this.time.now - this.startTime;
    const minutes = Math.floor(elapsed / 60000);
    const seconds = Math.floor((elapsed % 60000) / 1000);

    // 시간 텍스트 (매 프레임 갱신)
    const formatted = `${minutes}:${seconds.toString().padStart(2, "0")}`;
    this.timeText.setText("Time: " + formatted);

    // --- 점수 ---
    // 프레임마다 점수 증가
    this.score += minutes + 1;
    this.scoreText.setText("Score: " + this.score);

    // 난이도 점진 상승 (10초마다)
    this.diffTimer += delta;
    if (this.diffTimer >= 10000) {
      // 10초
      this.diffTimer = 0;

      // 0 또는 1 랜덤 선택
      if (Phaser.Math.Between(0, 1) === 0) {
        // 속도 증가 (최대 300까지만)
        if (this.arrowSpeed < 300) {
          this.arrowSpeed += 20;
          if (this.arrowSpeed > 300) this.arrowSpeed = 300; // 초과 방지
        }
      } else {
        // 생성 간격 감소 (최소 500까지만)
        if (this.spawnDelay > 500) {
          this.spawnDelay -= 150;
          if (this.spawnDelay < 500) this.spawnDelay = 500; // 이하 방지

          this.spawnEvent.remove(false);
          this.spawnEvent = this.time.addEvent({
            delay: this.spawnDelay,
            loop: true,
            callback: () => this.spawnPattern(),
          });
        }
      }

      // 업적 달성
      // --- 간발의 차 회피 체크 ---
      for (const arrow of this.arrows) {
        if (!arrow.active) continue;
        const dist = Phaser.Math.Distance.Between(this.player.x, this.player.y, arrow.x, arrow.y);
        if (dist <= 5) this.justDodgedClose = true;
      }

      // --- AFK 체크 ---
      if (!this.cursors.left.isDown && !this.cursors.right.isDown &&
        !this.cursors.up.isDown && !this.cursors.down.isDown) {
        this.afkTime += delta;
      } else {
        this.afkTime = 0;
      }

      // --- 계속 움직이기 체크 ---
      if (this.cursors.left.isDown || this.cursors.right.isDown ||
        this.cursors.up.isDown || this.cursors.down.isDown) {
        this.movingTime += delta;
      } else {
        this.movingTime = 0;
      }

      // --- 업적 검사 ---
      for (const id in achievements) {
        const ach = achievements[id];
        if (!this.unlockedAchievements.has(id) && ach.condition(this)) {
          this.unlockAchievement(id);
          if (id === "close_dodge") this.justDodgedClose = false; // 중복 방지
        }
      }
    }
  }

  // --- 업적 달성 ---
  unlockAchievement(achievementId) {
    if (loginId === "") return;
    // 화면 밖 화살 제거
    this.arrows = this.arrows.filter((a) => {
      if (!a.active) return false;
      if (a.x < -80 || a.x > 680 || a.y < -80 || a.y > 680) {
        a.destroy();
        return false;
      }
      return true;
    });
  }

  // 랜덤 패턴
  spawnPattern() {
    const patterns = ["single", "circle", "spiral", "down", "up", "left", "right"];
    const pick = Phaser.Utils.Array.GetRandom(patterns);

    this.seenPatterns.add(pick);
    this.patternsSeen = this.seenPatterns.size;

    switch (pick) {
      case "single": this.spawnSingle(); break;
      case "circle": this.spawnCircle(); break;
      case "spiral": this.spawnSpiral(); break;
      case "down": this.spawnDown(); break;
      case "up": this.spawnUp(); break;
      case "left": this.spawnLeft(); break;
      case "right": this.spawnRight(); break;
    }
  }

  // 공통: 화살 생성 (Matter.js)
  createArrow(x, y, vx, vy) {
    const arrow = this.matter.add.image(x, y, "arrow");
    arrow.setDisplaySize(48, 20);
    arrow.setFrictionAir(0);
    arrow.setVelocity(vx / 60, vy / 60);

    // 회전 각도 계산
    const angleRad = Math.atan2(vy, vx);

    // 👉 히트박스 모양 정의
    // 히트박스 (항상 같은 모양, 예: 가로 방향)
    const verts = Phaser.Physics.Matter.Matter.Vertices.fromPath(
      "0 0  32 4  48 6  32 8  0 12"
    );

    // 👉 바디 설정
    arrow.setBody({
      type: "fromVertices",
      verts: verts,
      flagInternal: true,
    });

    // 바디에도 회전 적용
    this.matter.body.setAngle(arrow.body, angleRad);

    // 👉 이미지 회전도 적용 (동기화)
    arrow.setRotation(angleRad);

    // 👉 충돌 설정 (화살 ↔ 플레이어만 충돌)
    arrow.setCollisionCategory(this.arrowCategory);
    arrow.setCollidesWith(this.playerCategory);

    this.arrows.push(arrow);
    return arrow;
  }


  // 1) 랜덤 싱글
  spawnSingle() {
    const x = Phaser.Math.Between(this.playArea.x, this.playArea.x + this.playArea.width);
    const y = Phaser.Math.Between(this.playArea.y, this.playArea.y + this.playArea.height);
    const vx = Phaser.Math.Between(-this.arrowSpeed, this.arrowSpeed);
    const vy = Phaser.Math.Between(-this.arrowSpeed, this.arrowSpeed);

    if (vx === 0 && vy === 0) vy = this.arrowSpeed;
    this.createArrow(x, y, vx, vy);
  }

  // 2) 원형 (가장자리 → 중앙)
  spawnCircle() {
    const cx = this.playArea.centerX;
    const cy = this.playArea.centerY;
    const n = 14;

    for (let i = 0; i < n; i++) {
      let x, y;
      const side = Phaser.Math.Between(0, 3);

      if (side === 0) {
        // 위쪽
        x = Phaser.Math.Between(this.playArea.x, this.playArea.right);
        y = this.playArea.y - 20;
      } else if (side === 1) {
        // 오른쪽
        x = this.playArea.right + 20;
        y = Phaser.Math.Between(this.playArea.y, this.playArea.bottom);
      } else if (side === 2) {
        // 아래쪽
        x = Phaser.Math.Between(this.playArea.x, this.playArea.right);
        y = this.playArea.bottom + 20;
      } else {
        // 왼쪽
        x = this.playArea.x - 20;
        y = Phaser.Math.Between(this.playArea.y, this.playArea.bottom);
      }

      const dx = cx - x;
      const dy = cy - y;
      const len = Math.sqrt(dx * dx + dy * dy);

      const speedFactor = Phaser.Math.FloatBetween(0.7, 1.3);
      const vx = (dx / len) * this.arrowSpeed * speedFactor;
      const vy = (dy / len) * this.arrowSpeed * speedFactor;

      this.createArrow(x, y, vx, vy);
    }
  }

  // 3) 나선형 (가장자리 → 중앙)
  spawnSpiral() {
    const cx = this.playArea.centerX;
    const cy = this.playArea.centerY;
    const n = 20;

    let angle = Math.random() * Phaser.Math.PI2;
    for (let i = 0; i < n; i++) {
      angle += 0.3;

      const radius = Math.max(this.playArea.width, this.playArea.height) / 2 + 50;
      const x = cx + Math.cos(angle) * radius;
      const y = cy + Math.sin(angle) * radius;

      const dx = cx - x;
      const dy = cy - y;
      const len = Math.sqrt(dx * dx + dy * dy);

      // 속도 랜덤 보정
      const speedFactor = Phaser.Math.FloatBetween(0.6, 1.4);
      const vx = (dx / len) * this.arrowSpeed * speedFactor;
      const vy = (dy / len) * this.arrowSpeed * speedFactor;

      this.createArrow(x, y, vx, vy);
    }
  }

  // 4) 위 → 아래
  spawnDown() {
    const step = this.playArea.width / 7; // 균등 간격
    for (let i = 1; i <= 6; i++) {
      const x = this.playArea.x + step * i;
      this.createArrow(x, this.playArea.y - 20, 0, this.arrowSpeed);
    }
  }

  // 5) 아래 → 위
  spawnUp() {
    const step = this.playArea.width / 7;
    for (let i = 1; i <= 6; i++) {
      const x = this.playArea.x + step * i;
      this.createArrow(x, this.playArea.bottom + 20, 0, -this.arrowSpeed);
    }
  }

  // 6) 왼 → 오
  spawnRight() {
    const step = this.playArea.height / 7;
    for (let i = 1; i <= 6; i++) {
      const y = this.playArea.y + step * i;
      this.createArrow(this.playArea.x - 20, y, this.arrowSpeed, 0);
    }
  }

  // 7) 오 → 왼
  spawnLeft() {
    const step = this.playArea.height / 7;
    for (let i = 1; i <= 6; i++) {
      const y = this.playArea.y + step * i;
      this.createArrow(this.playArea.right + 20, y, -this.arrowSpeed, 0);
    }
  }

  gameOver() {
    if (this.isGameOver) return;
    this.isGameOver = true;

    // ✅ 경과 시간 저장
    this.elapsed = this.time.now - this.startTime;

    // ✅ 최고 점수 갱신
    if (this.score > bestScore) {
      bestScore = this.score;
    }

    // ✅ GameOverScene 으로 점수 + 시간 넘겨주기
    this.scene.start("GameOverScene", {
      score: this.score,
      time: this.elapsed,
    });
  }

  unlockAchievement(achievementId) {

    if (loginId === "") return;

    console.log(this.unlockedAchievements);

    if (this.unlockedAchievements.has(achievementId)) return;

    this.unlockedAchievements.add(achievementId);

    $.ajax({
      url: "/api/achievement/unlock",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        userId: loginId,
        achievementId: achievementId,
        unlocked_at: Date.now()
      })
    }).done((resp) => {
      if (resp.status === "success") {

        console.log("🎉 업적 달성: " + resp.title + "업적 설명:" + resp.description)
        showAchievementPopup("🎉 업적 달성: " + resp.title, resp.description);
      }
    }).fail((err) => {
      console.error("업적 서버 오류:", err);
    });

  }

  formatTime(ms) {
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;

    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  }

  spawnPattern() {
    const patterns = ["single", "circle", "spiral", "down", "up", "left", "right"];
    const pick = Phaser.Utils.Array.GetRandom(patterns);

    // 패턴 경험 카운트
    if (!this.seenPatterns) this.seenPatterns = new Set();
    this.seenPatterns.add(pick);
    this.patternsSeen = this.seenPatterns.size;

    // 기존 패턴 실행
    switch (pick) {
      case "single": this.spawnSingle(); break;
      case "circle": this.spawnCircle(); break;
      case "spiral": this.spawnSpiral(); break;
      case "down": this.spawnDown(); break;
      case "up": this.spawnUp(); break;
      case "left": this.spawnLeft(); break;
      case "right": this.spawnRight(); break;
    }
  }
}
