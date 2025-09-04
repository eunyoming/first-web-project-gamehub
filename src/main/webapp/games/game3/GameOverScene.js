class GameOverScene extends Phaser.Scene {
  constructor() {
    super({ key: "GameOverScene" });
  }

  init(data) {
    this.finalScore = data?.score ?? 0;
    this.finalTime = data?.time ?? 0;
  }

  create() {
    // 배경
    this.add.image(400, 400, "background").setDisplaySize(800, 800).setDepth(-1);

    // 게임 플레이 영역 (600x600, 중앙)
    this.playArea = new Phaser.Geom.Rectangle(100, 100, 600, 600);

    // 👉 흰색 배경 사각형
    const graphics = this.add.graphics();
    graphics.fillStyle(0xffffff, 1);
    graphics.fillRect(this.playArea.x, this.playArea.y, this.playArea.width, this.playArea.height);

    // 텍스트 (간격 재정렬)
    this.add.text(400, 260, "GAME OVER", { fontSize: "36px", color: "#000" }).setOrigin(0.5);

    this.add.text(400, 320, `Score : ${this.finalScore}`, { fontSize: "22px", color: "#333" }).setOrigin(0.5);
    this.add.text(400, 360, `Best : ${bestScore}`, { fontSize: "22px", color: "#666" }).setOrigin(0.5);

    // ✅ 최종 생존 시간 표시
    this.add.text(400, 400, `생존 시간 : ${this.formatTime(this.finalTime)} !! `, { fontSize: "22px", color: "#444" }).setOrigin(0.5);

    // 👉 SPACE / CLICK: 다시 시작
    const restartText = this.add
      .text(400, 440, "SPACE / CLICK: 다시 시작", { fontSize: "18px", color: "#555" })
      .setOrigin(0.5)
      .setInteractive({ useHandCursor: true });

    // ✅ 업적 체크 (사망 관련)
    const mainScene = this.scene.get("MainScene");
    mainScene.deathCount++;

    for (const id in achievements) {
      const ach = achievements[id];
      if (!mainScene.unlockedAchievements.has(id) && ach.condition(mainScene)) {
        mainScene.unlockAchievement(id);
      }
    }

    // 스페이스바 입력 → 다시 시작
    this.input.keyboard.once("keydown-SPACE", () => this.handleRestart(mainScene));

    // 마우스 클릭 입력 → 다시 시작
    restartText.on("pointerdown", () => this.handleRestart(mainScene));
  }

  handleRestart(mainScene) {
    // ✅ 연속 재시작 카운트 증가
    mainScene.restartCount++;

    // ✅ 업적 다시 검사 (연속 재시작 등)
    for (const id in achievements) {
      const ach = achievements[id];
      if (!mainScene.unlockedAchievements.has(id) && ach.condition(mainScene)) {
        mainScene.unlockAchievement(id);
      }
    }

    this.scene.stop("GameOverScene");
    this.scene.start("MainScene");
  }

  formatTime(ms) {
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
  }
}
