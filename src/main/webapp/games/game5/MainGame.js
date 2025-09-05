// ★ 추가: 스코어 업적 매핑 (점수 임계값 → 업적 ID)
const SCORE_ACHIEVEMENTS = [
  { threshold: 5,  id: "NEZUCO_SCORE_10"  }, // 벽력일섬날개
  { threshold: 10,  id: "NEZUCO_SCORE_50"  }, // 천풍의 포효
  { threshold: 15,  id: "NEZUCO_SCORE_80"  }, // 유류무빙
  { threshold: 100, id: "NEZUCO_SCORE_100" }, // 연염양화
  { threshold: 200, id: "NEZUCO_SCORE_200" }, // 히노카미 카구라
];

class MainGame extends Phaser.Scene {
  constructor() {
    super({ key: "MainGame" });
    this.isGameOver = false;
    this.score = 0;
    this.speed = -150;

    this.gapRatio = 0.36;
    this.gameStart = false;
    this.gameOverElems = null;
    this.scoreZones = null;

    // 난이도/간격
    this.baseSpeed = -150;
    this.minSpeed = -500;
    this.spacingPx = 240;

    // 난이도 배너 상태
    this.difficultyTier = 0;
    this.banner = null;

    // 클릭 미션/포인트
    this.clickCount = 0;
    this.clickMilestones = [5, 10, 20, 30, 50, 1000];
    this.milestoneRewards = { 5: 1000, 10: 1000, 20: 2000, 30: 3000, 50: 4000, 1000: 5000 };
    this.reachedMilestones = new Set();
    this.totalPoints = 0;

    // 포인트 알림 배너 옵션
    this.pointsBanner = null;
    this.pointsBannerOpts = { fontSize: 26, holdMs: 1800, blinkRepeat: 6, blinkLowAlpha: 0.2 };

    this.unlockedAchievements = new Set(); // ✅ 업적 중복 방지용(세션 로컬)
  }

  preload() {
    this.load.image('background', IMG_PATH +'assets/image/background.png');
    this.load.image('pillar', IMG_PATH +'assets/image/pillar.png');
    this.load.image('gameover',IMG_PATH + 'assets/image/gameover.png');
    this.load.image('score', IMG_PATH +'assets/image/score.png');
    this.load.spritesheet('me', IMG_PATH + 'assets/image/nezuco.png', { frameWidth: 512, frameHeight: 1024 });
  }

  create() {
    // 상태 초기화
    this.isGameOver = false;
    this.gameStart = true;
    this.score = 0;
    this.clickCount = 0;
    this.totalPoints = 0;
    this.difficultyTier = 0;
    this.reachedMilestones.clear();
    // ★ 추가(선택): 장면 시작마다 로컬 Set 초기화하고 싶다면 주석 해제
    // this.unlockedAchievements = new Set();

    const { width, height } = this.scale;

    // 배경
    this.bg = this.add.tileSprite(0, 0, width, height, "background").setOrigin(0, 0);

    // 플레이어
    this.player = this.physics.add.sprite(width / 4, height / 2, "me");
    this.player.setScale(0.15).setVisible(true);
    this.player.setSize(400, 550);
    this.player.setOffset(50, 200);
    this.player.setCollideWorldBounds(true);
    this.player.body.allowGravity = true;

    // 애니메이션
    this.anims.create({ key: "fly", frames: this.anims.generateFrameNumbers("me", { start: 0, end: 2 }), frameRate: 9, repeat: -1 });
    this.anims.create({ key: "fall", frames: [{ key: "me", frame: 0 }], frameRate: 9, repeat: -1 });
    this.player.anims.play("fly", true);

    // 파이프 그룹
    this.upperPillars = this.physics.add.group();
    this.lowerPillars = this.physics.add.group();

    // 충돌
    this.physics.add.collider(this.player, this.upperPillars, this.hitPillar, null, this);
    this.physics.add.collider(this.player, this.lowerPillars, this.hitPillar, null, this);

    // 바닥
    this.ground = this.add.rectangle(width / 2, height, width, 15, 0x000000, 0);
    this.physics.add.existing(this.ground, true);
    this.physics.add.collider(this.player, this.ground, this.hitPillar, null, this);

    // 점수 UI
    this.scoreText = this.add.text(width / 2, 30, "0", {
      fontSize: "32px", fontFamily: "Fantasy", fill: "white",
    }).setOrigin(0.5).setDepth(1).setVisible(true);

    // 포인트 UI
    this.pointsText = this.add.text(16, 16, "PTS: 0", {
      fontSize: "26px", fontFamily: "Fantasy", fill: "#510499ff",
      stroke: "#ffffffff", strokeThickness: 3,
    }).setDepth(2).setScrollFactor(0);

    // 입력
    this.input.on("pointerdown", () => this.handleInput());
    this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
    this.input.keyboard.on("keydown-SPACE", () => this.handleInput());

    // 스코어 존
    this.scoreZones = this.add.group();
    this.physics.add.overlap(this.player, this.scoreZones, this.onScoreZone, null, this);

    // 스폰 시작
    this.spawnPillarPair();
    this.pillarSpawnTime = this.time.now + this.calcNextSpawnDelayMs();
  }

  handleInput() {
    this.clickCount += 1;
    this.checkClickMissions();

    if (!this.isGameOver) {
      this.player.setVelocityY(-230);
    }
  }

  update() {
    if (this.isGameOver) return;

    if (Phaser.Input.Keyboard.JustDown(this.spaceKey)) {
      this.player.setVelocityY(-230);
    }

    // 파이프/존 정리
    this.upperPillars.children.iterate(p => { if (p && p.x + p.displayWidth / 2 < 0) p.destroy(); });
    this.lowerPillars.children.iterate(p => { if (p && p.x + p.displayWidth / 2 < 0) p.destroy(); });
    this.scoreZones.getChildren().forEach(z => { if (z.x + z.width / 2 < 0) z.destroy(); });

    // 스폰
    if (this.pillarSpawnTime < this.time.now) {
      this.spawnPillarPair();
    }
  }

  // --- 이하 메서드는 원본 그대로 ---
  spawnPillarPair() {
    const pillarImage = this.textures.get("pillar");
    const pillarHeight = pillarImage.getSourceImage().height;

    let Offset = (Math.random() * pillarHeight) / 2;
    let k = Math.floor(Math.random() * 3) - 1;
    Offset = Offset * k;

    const gapHeight = this.scale.height * (this.gapRatio ?? (1 / 3));
    const lowerY = 2 * gapHeight + pillarHeight / 2 + Offset;
    const upperY = gapHeight - pillarHeight / 2 + Offset;

    const upperPillar = this.upperPillars.create(this.scale.width, upperY, "pillar").setAngle(180);
    upperPillar.body.allowGravity = false;
    upperPillar.setVelocityX(this.speed);
    upperPillar.body.setSize(upperPillar.width * 0.2, upperPillar.height * 0.8);
    upperPillar.body.setOffset(upperPillar.width * 0.4, upperPillar.height * 0.05);

    const lowerPillar = this.lowerPillars.create(this.scale.width, lowerY, "pillar");
    lowerPillar.body.allowGravity = false;
    lowerPillar.setVelocityX(this.speed);
    lowerPillar.body.setSize(lowerPillar.width * 0.2, lowerPillar.height * 0.8);
    lowerPillar.body.setOffset(lowerPillar.width * 0.4, lowerPillar.height * 0.15);

    const gapCenterY = (upperY + lowerY) / 2;
    const zoneHeight = Math.max(40, gapHeight * 0.9);
    const zoneWidth = 12;

    const zone = this.add.zone(this.scale.width, gapCenterY, zoneWidth, zoneHeight);
    this.physics.add.existing(zone);
    zone.body.setAllowGravity(false);
    zone.body.setImmovable(true);
    zone.body.setVelocityX(this.speed);
    zone.scored = false;
    this.scoreZones.add(zone);

    this.pillarSpawnTime = this.time.now + this.calcNextSpawnDelayMs();
  }

  updateDifficulty() {
    let newSpeed = this.baseSpeed;
    let newTier = 0;

    if (this.score >= 100) { newSpeed = -400; newTier = 5; }
    else if (this.score >= 70) { newSpeed = -350; newTier = 4; }
    else if (this.score >= 15) { newSpeed = -300; newTier = 3; }
    else if (this.score >= 10) { newSpeed = -250; newTier = 2; }
    else if (this.score >= 5)  { newSpeed = -200; newTier = 1; }

    this.speed = Math.max(newSpeed, this.minSpeed);

    this.upperPillars.children.iterate(p => { if (p && p.body) p.body.velocity.x = this.speed; });
    this.lowerPillars.children.iterate(p => { if (p && p.body) p.body.velocity.x = this.speed; });
    this.scoreZones.getChildren().forEach(z => { if (z.body) z.body.velocity.x = this.speed; });

    if (this.pillarSpawnTime) {
      const target = this.time.now + this.calcNextSpawnDelayMs();
      this.pillarSpawnTime = Math.min(this.pillarSpawnTime, target);
    }

    if (newTier > this.difficultyTier) {
      this.difficultyTier = newTier;
      this.showDifficultyNotice(`탄지로가 위험해! 스피드 UP!`);
    }
  }

  showDifficultyNotice(msg, color = "#ffffff", stroke = "#790707") {
    if (this.banner) { this.banner.destroy(); this.banner = null; }

    const { width, height } = this.scale;
    const anchorX = width / 2;

    const text = this.add.text(anchorX, height * 0.28, msg, {
      fontSize: "28px", fontFamily: "Fantasy", color, stroke, strokeThickness: 4,
    })
      .setOrigin(0.5)
      .setDepth(20)
      .setAlpha(0)
      .setScale(0.95)
      .setScrollFactor(0);

    this.banner = text;
    text.x = anchorX - 40;

    this.tweens.add({ targets: text, alpha: 1, x: anchorX, scale: 1, y: text.y - 8, duration: 260, ease: "Back.Out" });
    this.cameras?.main?.flash(120, 255, 255, 255, false);
    this.tweens.add({ targets: text, alpha: { from: 1, to: 0.35 }, duration: 140, yoyo: true, repeat: 5, delay: 260, ease: "Sine.InOut" });
    this.tweens.add({ targets: text, scale: { from: 1.0, to: 1.06 }, duration: 260, yoyo: true, repeat: 3, delay: 260, ease: "Sine.InOut" });

    this.time.delayedCall(1800, () => {
      this.tweens.add({
        targets: text, alpha: 0, scale: 0.96, y: text.y - 6, duration: 320, ease: "Quad.Out",
        onComplete: () => { text.destroy(); if (this.banner === text) this.banner = null; }
      });
    });
  }

  showPointsNotice(msg) {
    if (this.pointsBanner) { this.pointsBanner.destroy(); this.pointsBanner = null; }

    const base = this.pointsText;
    const marginY = 4;
    const anchorX = base.x;
    const anchorY = base.y + base.displayHeight + marginY;

    const { fontSize, holdMs, blinkRepeat, blinkLowAlpha } = this.pointsBannerOpts ?? {
      fontSize: 26, holdMs: 1800, blinkRepeat: 6, blinkLowAlpha: 0.2
    };

    const t = this.add.text(anchorX, anchorY, msg, {
      fontSize: `${fontSize}px`, fontFamily: "Fantasy", color: "#510499ff",
      stroke: "#ffffffff", strokeThickness: 4,
    })
      .setOrigin(0, 0)
      .setDepth(30)
      .setAlpha(0)
      .setScale(0.95)
      .setScrollFactor(0);

    this.pointsBanner = t;
    t.x = anchorX - 40;

    this.tweens.add({ targets: t, alpha: 1, x: anchorX, scale: 1, duration: 320, ease: "Back.Out" });
    this.tweens.add({ targets: t, alpha: { from: 1, to: blinkLowAlpha }, duration: 120, yoyo: true, repeat: blinkRepeat, delay: 320, ease: "Sine.InOut" });
    this.tweens.add({ targets: t, scale: { from: 1.0, to: 1.08 }, duration: 180, yoyo: true, repeat: Math.max(0, Math.floor(blinkRepeat / 2)), delay: 320, ease: "Sine.InOut" });

    this.time.delayedCall(holdMs, () => {
      this.tweens.add({
        targets: t, alpha: 0, x: anchorX + 8, scale: 0.96, duration: 280, ease: "Quad.Out",
        onComplete: () => { t.destroy(); if (this.pointsBanner === t) this.pointsBanner = null; }
      });
    });
  }

  checkClickMissions() {
    for (const m of this.clickMilestones) {
      if (this.clickCount >= m && !this.reachedMilestones.has(m)) {
        this.reachedMilestones.add(m);
        const reward = this.milestoneRewards[m] ?? 0;

        this.showDifficultyNotice(`미션 달성!   클릭 ${m}회`,"#510499ff","#ffffffff");
        if (reward > 0) {
          this.addPoints(reward);
          this.showPointsNotice(`+${reward} GET!`);
        }
      }
    }
  }

  addPoints(amount) {
    this.totalPoints += amount;
    if (this.pointsText) this.pointsText.setText(`PTS: ${this.totalPoints}`);
  }

  getSpacingPx() {
    const base = this.spacingPx;
    const extra = Math.max(0, (Math.abs(this.speed) - Math.abs(this.baseSpeed)) / 100) * 10;
    return Phaser.Math.Clamp(base + extra, 200, 400);
  }

  calcNextSpawnDelayMs() {
    const pillarW = this.textures.get("pillar").getSourceImage().width;
    const margin = pillarW * 0.2;
    const effectiveSpacing = this.getSpacingPx() + margin;
    return (effectiveSpacing / Math.abs(this.speed)) * 1000;
  }

  onScoreZone(player, zone) {
    if (zone.scored || this.isGameOver) return;
    zone.scored = true;
    this.score += 1;
    this.scoreText.setText(this.score);

    // ★ 추가: 점수 기반 업적 체크
    this.checkScoreAchievements();

    this.updateDifficulty();
  }

  hitPillar() {
    if (this.isGameOver) return;
    this.isGameOver = true;

    this.player.anims.play("fall", true);
    this.player.setVelocity(0, 0);

    [this.upperPillars, this.lowerPillars].forEach(group =>
      group.children.iterate(p => p.body.velocity.x = 0)
    );
    this.scoreZones.getChildren().forEach(zone => { if (zone.body) zone.body.velocity.x = 0; });

    const { width, height } = this.scale;
    this.scene.pause();
    this.scene.launch('GameOver', {
      score: this.score,
      anchorX: width / 2,
      anchorY: height / 2,
      scaleX: 0.5,
      scaleY: 0.5,
    });
  }

  // ★ 추가: 점수 업적 체크 로직
  checkScoreAchievements() {
    for (const a of SCORE_ACHIEVEMENTS) {
      if (this.score >= a.threshold) {
        this.unlockAchievement(a.id); // 내부에서 Set으로 중복 차단
      }
    }
  }

  unlockAchievement(achievementId) {
    console.log("imunlockachievement");
    if (loginId === "") return;

    if (!this.unlockedAchievements) this.unlockedAchievements = new Set();
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
        console.log("🎉 업적 달성: " + resp.title + "업적 설명:" + resp.description);
        showAchievementPopup("🎉 업적 달성: " + resp.title, resp.description);
      }
    }).fail((err) => {
      console.error("업적 서버 오류:", err);
    });
  }
}
window.MainGame = MainGame;
