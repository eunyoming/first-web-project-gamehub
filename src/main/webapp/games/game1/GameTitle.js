class GameTitle extends Phaser.Scene {

    constructor() {
        super({ key: "GameTitle" })
    }

    preload() {
        this.load.image('gameTitle', IMG_PATH+'assets/image/gameTitle.png'); // 배경 이미지
    }

    create() {
        // 화면 전체 크기
        let screenWidth = this.cameras.main.width;
        let screenHeight = this.cameras.main.height;

        // 배경 중앙 기준 배치
        let bg = this.add.tileSprite(
            screenWidth / 2,   // 중앙 X
            screenHeight / 2,  // 중앙 Y
            screenWidth,       // 화면 폭에 맞춤
            screenHeight,      // 화면 높이에 맞춤
            'gameTitle'
        );

		this.add.text(
		        this.cameras.main.width / 2,
		        30,
		        loginId===""? "비회원 접속":"접속한 아이디: "+loginId,
		        {
		            fontSize: "16px",
		            fill: "#ffffff"
		        }
		    ).setOrigin(0.5);
		
        // 중앙 기준 정렬
        bg.setOrigin(0.5, 0.5);

        // 시작 버튼
        let startButton = this.add.text(this.cameras.main.centerX, 500, "Start Game", {
            fontSize: "36px",
            fill: "#0f0",
            backgroundColor: "#00000000",
            padding: { x: 20, y: 10 }
        }).setOrigin(0.5).setInteractive();

        // 버튼 클릭 이벤트
        startButton.on('pointerdown', () => {
            this.scene.start("MainScene");
        });

        startButton.on("pointerover", () => {
            startButton.setBackgroundColor("#77777777");
            this.game.canvas.style.cursor = "pointer";
        })
        startButton.on("pointerout", () => {
            startButton.setBackgroundColor("#00000000");
            this.game.canvas.style.cursor = "default";
        })
    }
}