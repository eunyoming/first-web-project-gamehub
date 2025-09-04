class StartScene extends Phaser.Scene {
  constructor() {
    super({ key: "StartScene" });
  }

  preload() {
    this.load.image("player", "assets/player.png");
    this.load.image("arrow", "assets/arrow.png");
    this.load.image("background", "assets/background_body.png");
  }

  create() {
    // 배경 (중앙)
    this.add.image(400, 400, "background").setDisplaySize(800, 800).setDepth(-1);

    // 게임 플레이 영역 (800x800, 중앙)
    this.playArea = new Phaser.Geom.Rectangle(100, 100, 600, 600);

    // 👉 흰색 배경 사각형
    const graphics = this.add.graphics();
    graphics.fillStyle(0xffffff, 1); // 흰색
    graphics.fillRect(this.playArea.x, this.playArea.y, this.playArea.width, this.playArea.height);

    // 게임 제목
    this.add
      .text(400, 370, "화살 피하기", {
        fontSize: "40px",
        fontFamily: "Arial, sans-serif",
        color: "#222",
      })
      .setOrigin(0.5);

    // 시작 텍스트
    const startText = this.add
      .text(400, 450, "클릭 또는 SPACE를 눌러 시작", {
        fontSize: "20px",
        fontFamily: "Arial, sans-serif",
        color: "#969494ff",
      })
      .setOrigin(0.5)
      .setInteractive({ useHandCursor: true });

    this.input.keyboard.once("keydown-SPACE", () => {
      this.scene.start("MainScene");
    });

    startText.on("pointerdown", () => {
      this.scene.start("MainScene");
    });
  }
}
