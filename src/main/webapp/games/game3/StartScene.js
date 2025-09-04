class StartScene extends Phaser.Scene {
  constructor() {
    super({ key: "StartScene" });
  }

  preload() {
    // 배경과 주인공 이미지 로드
    this.load.image("background", IMG_PATH+"assets/background_body.png"); // 첫 번째 이미지
    this.load.image("cat", IMG_PATH+"assets/player.png"); // 두 번째 이미지 (주인공 고양이)
    this.load.image("arrow", IMG_PATH+"assets/arrow.png");
  
	// 👉 게임오버 전용 고양이 이미지 추가
	this.load.image("gameover_cat", IMG_PATH + "assets/gameover_player.png");
	}

  create() {
    // 1. 배경 꽉 채우기
    this.add.image(400, 400, "background")
      .setDisplaySize(800, 800)
      .setDepth(-2);

    // 2. 흰색 박스 (타이틀 영역 강조)
    const graphics = this.add.graphics();
    graphics.fillStyle(0xffffff, 1);
    graphics.fillRoundedRect(97, 100, 606, 600, 20);

    // 3. 주인공 고양이 이미지 (살짝 위아래로 움직이는 애니메이션)
    const cat = this.add.image(400, 280, "cat")
      .setDisplaySize(150, 150)
      .setDepth(1);

    this.tweens.add({
      targets: cat,
      y: 290,
      duration: 800,
      yoyo: true,
      repeat: -1,
      ease: "Sine.easeInOut"
    });

    // 4. 게임 제목 (굵고 귀여운 폰트 스타일 - 썸네일 폰트 스타일에 맞춰 수정)
    this.add.text(400, 380, "화살 피했냥", { // 게임 제목을 "화살 피했냥"으로 수정
      fontSize: "56px", // 썸네일처럼 더 크게
      fontFamily: "Arial Black, sans-serif", // 더 두껍고 귀여운 느낌을 위해
      color: "#ff6699", // 썸네일과 동일한 핑크색
      stroke: "#ffffff",
      strokeThickness: 8, // 테두리 두께 증가
      shadow: { offsetX: 3, offsetY: 3, color: "#000", blur: 5, fill: true } // 그림자 강화
    }).setOrigin(0.5);

    // 5. 시작 안내 텍스트 (깜빡이는 효과)
    const startText = this.add.text(400, 450, "클릭 또는 SPACE를 눌러 시작", {
      fontSize: "22px",
      fontFamily: "Arial, sans-serif",
      color: "#333"
    }).setOrigin(0.5).setInteractive({ useHandCursor: true });

    this.tweens.add({
      targets: startText,
      alpha: 0,
      duration: 700,
      yoyo: true,
      repeat: -1
    });

    // 6. 입력 이벤트
    this.input.keyboard.once("keydown-SPACE", () => {
      this.scene.start("MainScene");
    });

    startText.on("pointerdown", () => {
      this.scene.start("MainScene");
    });
  }
}
