class GameIntro extends Phaser.Scene {

    constructor() {
        super({ key: "GameIntro" });
    }

    preload() {
        this.load.image('introBg', IMG_PATH + 'assets/introBackground.png'); // 경로는 프로젝트에 맞게
        //this.load.image('startBtn', 'assets/start-button.png');    // 시작 버튼 이미지
    }

    create() {
        const { width, height } = this.cameras.main;
        // 배경 이미지
        let bg = this.add.image(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2,
            'introBg'
        ).setOrigin(0.5, 0.55);


        bg.setScale(0.7, 0.8);
        // "시작하기" 버튼


        // 버튼 텍스트

        this.buttonText = this.add.text(width / 2, height / 2 + 110, "START GAME", {
            fontSize: "48px",
            fontStyle: "bold",
            fontFamily: 'Arial Black',
            color: "#fffffffd"
        }).setOrigin(0.51).setInteractive({ useHandCursor: true }); // 반드시!
        this.buttonText.setShadow(2, 2, "#ffc547ee", 2, false, true);


        this.buttonText.on("pointerdown", () => {
            this.scene.start("tetris");
        })

        this.buttonText.on("pointerover", () => {
            this.buttonText.setFontSize("51px");
            this.buttonText.setColor("#ffe2a4ff");
            this.buttonText.setShadow(2, 2, "#ffc547ee", 2, false, true);
            this.game.canvas.style.cursor = "pointer";
        })

        this.buttonText.on("pointerout", () => {
            this.buttonText.setFontSize("48px");
            this.buttonText.setColor("#ffffff");  // 원래 흰색
            this.buttonText.setShadow(2, 2, "#000000ff", 2, false, true);
            this.game.canvas.style.cursor = "default";
        })

        this.blinkAlpha = 0.3;
        this.blinkDirection = 1;

        // 👤 접속한 아이디 텍스트 (아래쪽에 작게 표시)
        this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 + 180,
            loginId === "" ? "비회원 접속" : "접속한 아이디: " + loginId,
            {
                fontSize: "20px",
                fill: "#ffffff"
            }
        ).setOrigin(0.5);
    }
    update() {
        this.blinkAlpha += 0.005 * this.blinkDirection;
        if (this.blinkAlpha >= 1) this.blinkDirection = -1;
        if (this.blinkAlpha <= 0.3) this.blinkDirection = 1;

        this.buttonText.setAlpha(this.blinkAlpha);
    }
}