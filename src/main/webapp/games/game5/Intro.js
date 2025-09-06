
class Intro extends Phaser.Scene {
  constructor() {
    super({ key: "Intro" });
  }

  preload() {
    // MainGame 쓰던 시작 메시지/배경을 그대로 로드해둠)
    this.load.image('background', IMG_PATH + 'assets/image/background.png');
    this.load.image('startGame', IMG_PATH + 'assets/image/message.png');
  }

  create() {
    const { width, height } = this.scale;

    // 배경(화면 전체)
    this.add.tileSprite(0, 0, width, height, "background").setOrigin(0, 0);

    // 시작 이미지
    this.startGameImage = this.add.image(width / 1.98, height / 1.85, "startGame")
      .setOrigin(0.5)
      .setScale(0.5);

    // 클릭 스페이스 누르면 시작
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
