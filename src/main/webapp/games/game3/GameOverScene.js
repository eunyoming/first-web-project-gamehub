class GameOverScene extends Phaser.Scene {
  constructor() {
    super({ key: "GameOverScene" });
  }

  init(data) {
    this.finalScore = data?.score ?? 0;
  }

  create() {
    this.add.image(400, 400, "background").setDisplaySize(800, 800).setDepth(-1);

    // 게임 플레이 영역 (600x600, 중앙)
    this.playArea = new Phaser.Geom.Rectangle(100, 100, 600, 600);

    // 👉 흰색 배경 사각형
    const graphics = this.add.graphics();
    graphics.fillStyle(0xffffff, 1);
    graphics.fillRect(this.playArea.x, this.playArea.y, this.playArea.width, this.playArea.height);

    this.add.text(400, 300, "GAME OVER", { fontSize: "36px", color: "#000" }).setOrigin(0.5);
    this.add.text(400, 370, `Score: ${this.finalScore}`, { fontSize: "22px", color: "#333" }).setOrigin(0.5);

    // 👉 SPACE: 다시 시작 (클릭 가능 + 커서 바뀜)
    const restartText = this.add
      .text(400, 430, "SPACE / CLICK: 다시 시작", { fontSize: "18px", color: "#555" })
      .setOrigin(0.5)
      .setInteractive({ useHandCursor: true });

    // 스페이스바 입력
    this.input.keyboard.once("keydown-SPACE", () => this.scene.start("MainScene"));

    // 마우스 클릭 입력
    restartText.on("pointerdown", () => this.scene.start("MainScene"));
  }
}
