// =============================================
// MainGame — 업적(1회만) + 동일 조건 미션(매 판 포인트 지급)
// 내부 score는 +1씩, 표시는 ×100, 포인트 적립은 GameOver에서 처리
// =============================================

/** 업적 조건(1회만) */
const SCORE_ACHIEVEMENTS = [
  { threshold: 5,   id: "NEZUCO_SCORE_10"   },
  { threshold: 10,  id: "NEZUCO_SCORE_50"  },
  { threshold: 15,  id: "NEZUCO_SCORE_80"  },
  { threshold: 100, id: "NEZUCO_SCORE_100" },
  { threshold: 200, id: "NEZUCO_SCORE_200" },
];
const CLICK_ACHIEVEMENTS = [
  { threshold: 50,   id: "NEZUCO_CLICK_50"   },
  { threshold: 100,  id: "NEZUCO_CLICK_100"  },
  { threshold: 200,  id: "NEZUCO_CLICK_200"  },
  { threshold: 500,  id: "NEZUCO_CLICK_500"  },
  { threshold: 1000, id: "NEZUCO_CLICK_1000" },
];

/** 미션(매 판 포인트 지급) — 업적과 동일 조건 */
const MISSION_SCORE_RULES = [
  { threshold: 5,   id: "MISSION_SCORE_10"   },
  { threshold: 10,  id: "MISSION_SCORE_50"  },
  { threshold: 15,  id: "MISSION_SCORE_80"  },
  { threshold: 100, id: "MISSION_SCORE_100" },
  { threshold: 200, id: "MISSION_SCORE_200" },
];
const MISSION_CLICK_RULES = [
  { threshold: 50,   id: "MISSION_CLICK_50"   },
  { threshold: 100,  id: "MISSION_CLICK_100"  },
  { threshold: 200,  id: "MISSION_CLICK_200"  },
  { threshold: 500,  id: "MISSION_CLICK_500"  },
  { threshold: 1000, id: "MISSION_CLICK_1000" },
];
const MISSION_REWARDS = {
  MISSION_SCORE_10:   100,
  MISSION_SCORE_50:   100,
  MISSION_SCORE_80:   300,
  MISSION_SCORE_100:  500,
  MISSION_SCORE_200:  1000,
  MISSION_CLICK_50:   100,
  MISSION_CLICK_100:  100,
  MISSION_CLICK_200:  300,
  MISSION_CLICK_500:  500,
  MISSION_CLICK_1000: 1000,
};

/** 업적 텍스트/파티클(아이콘 사용 안 함) */
const ACHIEVEMENT_META = {
	NEZUCO_SCORE_10:   { title: "SCORE 10 돌파 ! 벽력일섬",    spark: "starburst", colors: [0xfef08a, 0xfde047] },
	  NEZUCO_SCORE_50:   { title: "SCORE 50 돌파 ! 천풍의 포효",      spark: "wind",      colors: [0xc7d2fe, 0x93c5fd] },
	  NEZUCO_SCORE_80:   { title: "SCORE 80 돌파 ! 유류무빙",        spark: "ring",      colors: [0xd1d5db, 0xe5e7eb] },
	  NEZUCO_SCORE_100:  { title: "SCORE 100 돌파 ! 연염양화",        spark: "flame",     colors: [0xfda4af, 0xf97316] },
	  NEZUCO_SCORE_200:  { title: "SCORE 200 CLEAR !!! 히노카미 카구라", spark: "flame",     colors: [0xfca5a5, 0xf59e0b] },
	  NEZUCO_CLICK_50:   { title: "CLICK 50 돌파 ! 화무참",          spark: "starburst", colors: [0xa78bfa, 0xf5d0fe] },
	  NEZUCO_CLICK_100:  { title: "CLICK 100 돌파 ! 난무",            spark: "starburst", colors: [0xc4b5fd, 0xf0abfc] },
	  NEZUCO_CLICK_200:  { title: "CLICK 200 돌파 ! 월영참",      spark: "flame",     colors: [0xfda4af, 0xfb7185] },
	  NEZUCO_CLICK_500:  { title: "CLICK 500 돌파 ! 혈염의 군주",      spark: "ring",      colors: [0xfcd34d, 0xf59e0b] },
	  NEZUCO_CLICK_1000: { title: "CLICK 1000 돌파 !!! 일륜의 주인",          spark: "moon",      colors: [0x93c5fd, 0xbfdbfe] },
};
/** 미션 → 업적 매핑(표시/파티클 재사용) */
const MISSION_TO_ACH = {
  MISSION_SCORE_10:   "NEZUCO_SCORE_10",
  MISSION_SCORE_50:   "NEZUCO_SCORE_50",
  MISSION_SCORE_80:   "NEZUCO_SCORE_80",
  MISSION_SCORE_100:  "NEZUCO_SCORE_100",
  MISSION_SCORE_200:  "NEZUCO_SCORE_200",
  MISSION_CLICK_50:   "NEZUCO_CLICK_50",
  MISSION_CLICK_100:  "NEZUCO_CLICK_100",
  MISSION_CLICK_200:  "NEZUCO_CLICK_200",
  MISSION_CLICK_500:  "NEZUCO_CLICK_500",
  MISSION_CLICK_1000: "NEZUCO_CLICK_1000",
};

class MainGame extends Phaser.Scene {
  constructor() {
    super({ key: "MainGame" });

    this.isGameOver = false;
    this.score = 0;
    this.speed = -150;

    this.gapRatio = 0.36;
    this.baseSpeed = -150;
    this.minSpeed = -500;
    this.spacingPx = 240;

    this.difficultyTier = 0;
    this.banner = null;            // 난이도 배너(Text)

    this.clickCount = 0;
    this.totalPoints = 0;
    this.pointsBanner = null;
    this.pointsBannerOpts = { fontSize: 26, holdMs: 1800, blinkRepeat: 6, blinkLowAlpha: 0.2 };

    this.unlockedAchievements = new Set(); // 세션 멱등
    this.runAchievementsAwarded = new Set();
    this.runMissionsAwarded = new Set();

    this.sessionStartMs = 0;
    this.sessionEndMs = 0;
    this.runId = "";

    this.missionBanner = null;     // 동시 배너 회피용
  }
  init() {
    this.isGameOver = false;
    this.score = 0;
    this.clickCount = 0;
    this.totalPoints = 0;

    this.baseSpeed = -150;
    this.minSpeed  = -500;
    this.speed     = this.baseSpeed;  // ★ 여기서 초기화
    this.difficultyTier = 0;

    this.runAchievementsAwarded = new Set();
    this.runMissionsAwarded     = new Set();
  }

  preload() {
    this.load.image('background', IMG_PATH + 'assets/image/background.png');
    this.load.image('pillar',     IMG_PATH + 'assets/image/pillar.png');
    this.load.image('gameover',   IMG_PATH + 'assets/image/gameover.png');
	this.load.image('gameclear',   IMG_PATH + 'assets/image/gameclear.png');
    this.load.image('score',      IMG_PATH + 'assets/image/score.png');
    this.load.spritesheet('me',   IMG_PATH + 'assets/image/nezuco.png', { frameWidth: 512, frameHeight: 1024 });
  }

  create() {

    this.sessionStartMs = Date.now();
    this.runId = `${this.sessionStartMs}-${Math.random().toString(36).slice(2,8)}`;

    const { width, height } = this.scale;

    // 배경
    this.bg = this.add.tileSprite(0, 0, width, height, "background").setOrigin(0, 0);

    // 플레이어
    this.player = this.physics.add.sprite(width / 4, height / 2, "me");
    this.player.setScale(0.15).setVisible(true);
    this.player.setSize(400, 550).setOffset(50, 200);
    this.player.setCollideWorldBounds(true);
    this.player.body.allowGravity = true;

    // 애니(중복 생성 방지)
    if (!this.anims.exists("fly"))  this.anims.create({ key: "fly",  frames: this.anims.generateFrameNumbers("me", { start: 0, end: 2 }), frameRate: 9, repeat: -1 });
    if (!this.anims.exists("fall")) this.anims.create({ key: "fall", frames: [{ key: "me", frame: 0 }], frameRate: 9, repeat: -1 });
    this.player.anims.play("fly", true);

    // 기둥 & 충돌
    this.upperPillars = this.physics.add.group();
    this.lowerPillars = this.physics.add.group();
    this.physics.add.collider(this.player, this.upperPillars, this.hitPillar, null, this);
    this.physics.add.collider(this.player, this.lowerPillars, this.hitPillar, null, this);

    // 바닥
    this.ground = this.add.rectangle(width / 2, height, width, 15, 0x000000, 0);
    this.physics.add.existing(this.ground, true);
    this.physics.add.collider(this.player, this.ground, this.hitPillar, null, this);

    // 점수(표시는 ×100)
    this.scoreText = this.add.text(width / 2, 30, "0", { fontSize: "32px", fontFamily: "Fantasy", fill: "white" })
      .setOrigin(0.5).setDepth(1).setVisible(true);

    // 좌상단 포인트
    this.pointsText = this.add.text(16, 16, "PTS: 0", {
      fontSize: "26px", fontFamily: "Fantasy", fill: "#510499ff",
      stroke: "#ffffffff", strokeThickness: 3,
    }).setDepth(2).setScrollFactor(0);

    // 입력
    this.input.on("pointerdown", () => this.handleInput());
    this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
    this.input.keyboard.on("keydown-SPACE", () => this.handleInput());

    // 점수 Zone
    this.scoreZones = this.add.group();
    this.physics.add.overlap(this.player, this.scoreZones, this.onScoreZone, null, this);

    // 파티클 텍스처 준비(아이콘 없이)
    this.ensureSparkTextures();

    // 첫 스폰
    this.spawnPillarPair();
    this.pillarSpawnTime = this.time.now + this.calcNextSpawnDelayMs();
  }

  // 입력/업데이트
  handleInput() {
    this.clickCount += 1;
    this.checkClickAchievements();
    this.checkClickMissions();
    if (!this.isGameOver) this.player.setVelocityY(-230);
  }

  update() {
    if (this.isGameOver) return;

    if (Phaser.Input.Keyboard.JustDown(this.spaceKey)) this.player.setVelocityY(-230);

    this.upperPillars.children.iterate(p => { if (p && p.x + p.displayWidth / 2 < 0) p.destroy(); });
    this.lowerPillars.children.iterate(p => { if (p && p.x + p.displayWidth / 2 < 0) p.destroy(); });
    this.scoreZones.getChildren().forEach(z => { if (z.x + z.width / 2 < 0) z.destroy(); });

    if (this.pillarSpawnTime < this.time.now) this.spawnPillarPair();
  }

  // 스폰/난이도
  spawnPillarPair() {
    const pillarImage = this.textures.get("pillar");
    const pillarHeight = pillarImage.getSourceImage().height;

    let Offset = (Math.random() * pillarHeight) / 2;
    let k = Math.floor(Math.random() * 3) - 1;
    Offset *= k;

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

  // ===== 배너들 =====
  // 난이도 배너(기본 스타일 유지, 미션 배너 떠 있으면 살짝 아래로)
  showDifficultyNotice(msg, color = "#ffffff", stroke = "#790707") {
    if (this.banner) { this.banner.destroy(); this.banner = null; }

    const { width, height } = this.scale;
    let anchorY = height * 0.36;                // 기존 느낌 유지
    if (this.missionBanner && this.missionBanner.active) anchorY += 18; // 겹침 회피

    const text = this.add.text(width / 2, anchorY, msg, {
      fontSize: "32px", fontFamily: "Fantasy", color, stroke, strokeThickness: 4
    }).setOrigin(0.5).setDepth(20).setAlpha(0).setScale(0.98).setScrollFactor(0);

    this.banner = text;
    text.x -= 40;

    this.tweens.add({ targets: text, alpha: 1, x: width / 2, scale: 1, y: text.y - 6, duration: 260, ease: "Back.Out" });
    this.cameras?.main?.flash(100, 255, 255, 255, false);
    this.tweens.add({ targets: text, alpha: { from: 1, to: 0.35 }, duration: 140, yoyo: true, repeat: 4, delay: 240, ease: "Sine.InOut" });

    this.time.delayedCall(1600, () => {
      this.tweens.add({
        targets: text, alpha: 0, scale: 0.97, y: text.y - 6, duration: 300, ease: "Quad.Out",
        onComplete: () => { text.destroy(); if (this.banner === text) this.banner = null; }
      });
    });
  }

  // 좌상단 포인트 메시지(그대로)
  showPointsNotice(msg) {
    if (this.pointsBanner) { this.pointsBanner.destroy(); this.pointsBanner = null; }

    const base = this.pointsText;
    const anchorX = base.x;
    const anchorY = base.y + base.displayHeight + 4;
    const { fontSize, holdMs, blinkRepeat, blinkLowAlpha } = this.pointsBannerOpts;

    const t = this.add.text(anchorX, anchorY, msg, {
      fontSize: `${fontSize}px`, fontFamily: "Fantasy", color: "#510499ff",
      stroke: "#ffffffff", strokeThickness: 4,
    }).setOrigin(0, 0).setDepth(30).setAlpha(0).setScale(0.95).setScrollFactor(0);

    this.pointsBanner = t;
    t.x = anchorX - 40;

    this.tweens.add({ targets: t, alpha: 1, x: anchorX, scale: 1, duration: 300, ease: "Back.Out" });
    this.tweens.add({ targets: t, alpha: { from: 1, to: blinkLowAlpha }, duration: 120, yoyo: true, repeat: blinkRepeat, delay: 300, ease: "Sine.InOut" });
    this.time.delayedCall(holdMs, () => {
      this.tweens.add({
        targets: t, alpha: 0, x: anchorX + 8, scale: 0.96, duration: 260, ease: "Quad.Out",
        onComplete: () => { t.destroy(); if (this.pointsBanner === t) this.pointsBanner = null; }
      });
    });
  }

  // 미션 클리어(위쪽으로, 파티클은 텍스트 뒤 / Phaser 3.60+ API)
  showMissionClearNotice(achievementIdForMeta, label = "") {
    const meta = ACHIEVEMENT_META[achievementIdForMeta] || { title: achievementIdForMeta, spark: "starburst", colors: [0xffd700] };
    const { width, height } = this.scale;
    const anchorX = width / 2;
    const anchorY = Math.max(60, height * 0.22);   // 조금 더 위쪽
    const depth = 30;

    if (this.missionBanner && this.missionBanner.destroy) { this.missionBanner.destroy(); this.missionBanner = null; }

    // 얇은 패널(기존 느낌 유지)
    const g = this.add.graphics().setDepth(depth - 1);
    const panelW = 480, panelH = 92;
    g.fillStyle(0x000000, 0.35).fillRoundedRect(anchorX - panelW/2, anchorY - panelH/2, panelW, panelH, 16);
    g.lineStyle(3, 0xffd700, 0.9).strokeRoundedRect(anchorX - panelW/2, anchorY - panelH/2, panelW, panelH, 16);

    // 텍스트(기존 스타일 유지)
    const titleText = this.add.text(anchorX, anchorY - 18, "미션 클리어!", {
      fontSize: "30px", fontFamily: "Fantasy", color: "#ffd700", stroke: "#000", strokeThickness: 6
    }).setOrigin(0.5).setDepth(depth).setAlpha(0).setScale(0.96);

    const sub = `${meta.title}${label ? ` — ${label}` : ""}`;
    const subText = this.add.text(anchorX, anchorY + 14, sub, {
      fontSize: "18px", fontFamily: "Fantasy", color: "#ffffff", stroke: "#000", strokeThickness: 4
    }).setOrigin(0.5).setDepth(depth).setAlpha(0).setScale(0.96);

    // 파티클(Phaser 3.60+ : add.particles(x,y, texture, config))
    const [c1, c2] = meta.colors || [0xffd700, 0xffffff];
    const { textureKey, emitterConfig } = this.getSparkConfig(meta.spark, anchorX, anchorY - 6, [c1, c2]);
    const emitter = this.add.particles(anchorX, anchorY - 6, textureKey, emitterConfig).setDepth(depth - 2);

    // 정리 핸들러
    const destroyAll = () => { emitter.stop(); emitter.destroy(); g.destroy(); titleText.destroy(); subText.destroy(); this.missionBanner = null; };
    this.missionBanner = { active: true, destroy: destroyAll };

    // 등장/퇴장
    this.tweens.add({ targets: [titleText, subText], alpha: 1, scale: 1, duration: 260, ease: "Back.Out" });
    this.cameras?.main?.shake(100, 0.002);
    this.time.delayedCall(1800, () => {
      this.tweens.add({ targets: [titleText, subText], alpha: 0, duration: 280, ease: "Quad.Out", onComplete: destroyAll });
    });
  }

  // 점수/미션/업적
  addPoints(amount) {
    this.totalPoints += amount;
    if (this.pointsText) this.pointsText.setText(`PTS: ${this.totalPoints}`);
  }

  onScoreZone(player, zone) {
    if (zone.scored || this.isGameOver) return;
    zone.scored = true;

    this.score += 1;
    this.scoreText.setText(this.score * 100);

    this.checkScoreAchievements();
    this.checkScoreMissions();

    this.updateDifficulty();
  }

  checkScoreAchievements() {
    for (const a of SCORE_ACHIEVEMENTS) {
      if (this.score >= a.threshold) this.grantAchievementOnce(a.id);
    }
  }
  checkClickAchievements() {
    for (const a of CLICK_ACHIEVEMENTS) {
      if (this.clickCount >= a.threshold) this.grantAchievementOnce(a.id);
    }
  }
  grantAchievementOnce(achievementId) {
    if (this.runAchievementsAwarded.has(achievementId)) return;
    this.runAchievementsAwarded.add(achievementId);
    this.sendAchievementUnlock(achievementId);
  }

  checkScoreMissions() {
    for (const m of MISSION_SCORE_RULES) {
      if (this.score >= m.threshold) this.grantMission(m.id, `SCORE ${m.threshold}`);
    }
  }
  checkClickMissions() {
    for (const m of MISSION_CLICK_RULES) {
      if (this.clickCount >= m.threshold) this.grantMission(m.id, `CLICK ${m.threshold}`);
    }
  }
  grantMission(missionId, label = "") {
    if (this.runMissionsAwarded.has(missionId)) return;
    this.runMissionsAwarded.add(missionId);

    const pts = MISSION_REWARDS[missionId] ?? 0;
    if (pts > 0) {
      this.addPoints(pts);
      this.showPointsNotice(`+${pts} POINTS${label ? ` (${label})` : ""}`);
    }

    const achIdForMeta = MISSION_TO_ACH[missionId] || missionId;
    this.showMissionClearNotice(achIdForMeta, label);
  }

  // 서버 업적 해금(세션 멱등)
  sendAchievementUnlock(achievementId) {
    try {
      if (typeof loginId === "undefined" || loginId === "") return;
      if (!this.unlockedAchievements) this.unlockedAchievements = new Set();
      if (this.unlockedAchievements.has(achievementId)) return;
      this.unlockedAchievements.add(achievementId);

      $.ajax({
        url: "/api/achievement/unlock",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({ userId: loginId, achievementId, unlocked_at: Date.now() }),
      }).done((resp) => {
        if (resp && resp.status === "success" && typeof showAchievementPopup === 'function') {
          showAchievementPopup("🎉 업적 달성: " + resp.title, resp.description);
        }
      }).fail((err) => console.error("업적 서버 오류:", err));
    } catch (e) {
      console.error("업적 전송 예외:", e);
    }
  }

  // 간격/스폰 계산
  getSpacingPx() {
    const extra = Math.max(0, (Math.abs(this.speed) - Math.abs(this.baseSpeed)) / 100) * 10;
    return Phaser.Math.Clamp(this.spacingPx + extra, 200, 400);
  }
  calcNextSpawnDelayMs() {
    const pillarW = this.textures.get("pillar").getSourceImage().width;
    const margin = pillarW * 0.2;
    const effectiveSpacing = this.getSpacingPx() + margin;
    return (effectiveSpacing / Math.abs(this.speed)) * 1000;
  }

  // ==== 파티클 텍스처 생성(고정 크기, getBounds 사용 안 함) ====
  ensureSparkTextures() {
    const makeTex = (key, draw, w = 32, h = 32) => {
      if (this.textures.exists(key)) return;
      const g = this.make.graphics({ x: 0, y: 0, add: false });
      g.clear();
      draw(g, w, h);
      g.generateTexture(key, w, h);
      g.destroy();
    };
    makeTex("spark_circle", (g, w, h) => { g.fillStyle(0xffffff, 1).fillCircle(w/2, h/2, 8); });
    makeTex("spark_ring",   (g, w, h) => { g.lineStyle(3, 0xffffff, 1).strokeCircle(w/2, h/2, 9); });
    makeTex("spark_ray",    (g, w, h) => { g.fillStyle(0xffffff, 1).fillRect((w-24)/2, (h-4)/2, 24, 4); });
    makeTex("spark_dot",    (g, w, h) => { g.fillStyle(0xffffff, 1).fillCircle(w/2, h/2, 3); });
    makeTex("spark_wisp",   (g, w, h) => { g.fillStyle(0xffffff, 1).fillEllipse(w/2, h/2, 20, 12); });
  }

  // 파티클 스타일별 설정
  getSparkConfig(kind, x, y, colors=[0xffd700]) {
    const base = {
      lifespan: { min: 500, max: 1000 },
      quantity: 12,
      speed: { min: 60, max: 180 },
      scale: { start: 0.35, end: 0 },
      alpha: { start: 0.9, end: 0 },
      tint: colors,
      blendMode: "ADD",
      gravityY: 0
    };
    switch (kind) {
      case "flame":
        return { textureKey: "spark_circle", emitterConfig: { ...base, angle: { min: 220, max: 320 }, speed: { min: 40, max: 120 }, quantity: 16 } };
      case "ring":
        return { textureKey: "spark_ring",   emitterConfig: { ...base, radial: true, speed: { min: 100, max: 200 }, quantity: 10 } };
      case "wind":
        return { textureKey: "spark_wisp",   emitterConfig: { ...base, angle: { min: -20, max: 20 }, speed: { min: 120, max: 220 }, quantity: 14 } };
      case "moon":
        return { textureKey: "spark_dot",    emitterConfig: { ...base, angle: { min: 250, max: 290 }, speed: { min: 40, max: 80 }, quantity: 18, lifespan: { min: 800, max: 1400 } } };
      case "starburst":
      default:
        return { textureKey: "spark_ray",    emitterConfig: { ...base, radial: true, speed: { min: 140, max: 260 }, quantity: 14 } };
    }
  }

  // 게임오버
  hitPillar() {
    if (this.isGameOver) return;
    this.isGameOver = true;

    this.player.anims.play("fall", true);
    this.player.setVelocity(0, 0);

    [this.upperPillars, this.lowerPillars].forEach(g => g.children.iterate(p => p.body.velocity.x = 0));
    this.scoreZones.getChildren().forEach(z => { if (z.body) z.body.velocity.x = 0; });

    this.sessionEndMs = Date.now();

    const { width, height } = this.scale;
    this.scene.pause();
    this.scene.launch('GameOver', {
      score: this.score * 100,
      points: this.totalPoints,
      startTime: this.sessionStartMs,
      endTime: this.sessionEndMs,
      runId: this.runId,
      anchorX: width / 2,
      anchorY: height / 2,
      scaleX: 0.5,
      scaleY: 0.5,
    });
  }
}

window.MainGame = MainGame;
