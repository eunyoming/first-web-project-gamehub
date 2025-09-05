
class Intro extends Phaser.Scene {
  constructor() {
    super({ key: "Intro" });
  }

  preload() {
    // MainGame 쓰던 시작 메시지/배경을 그대로 로드해둠 (중복 로드도 안전)
    this.load.image('background', IMG_PATH + 'assets/image/background.png');
    this.load.image('startGame', IMG_PATH + 'assets/image/message.png');
  }

  create() {
    const { width, height } = this.scale;

    // 배경(화면 전체)
    this.add.tileSprite(0, 0, width, height, "background").setOrigin(0, 0);

    // 시작 메시지(기존 MainGame 동일한 위치/스케일)
    this.startGameImage = this.add.image(width / 1.98, height / 1.85, "startGame")
      .setOrigin(0.5)
      .setScale(0.5);

    // 하단 힌트(선택)
    this.add.text(width / 2, height * 0.9, "CLICK / SPACE TO START", {
      fontSize: "18px",
      fontFamily: "Fantasy",
      color: "#ffffff",
      stroke: "#000000",
      strokeThickness: 3,
    }).setOrigin(0.5);

    // 입력
    this.input.once("pointerdown", () => this._go());
    this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
    this.input.keyboard.once("keydown-SPACE", () => this._go());
  }

  _go() {
    // MainGame 전환 (MainGame 바로 플레이 시작하도록 구성)
    this.scene.start("MainGame");
  }
}

window.Intro = Intro;
