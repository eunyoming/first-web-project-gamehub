class Gameover extends Phaser.Scene {

    constructor() {
        super({ key: "Gameover" });
    }

    init(data) {
        this.score = data.score;
        this.level = data.level;
        this.lines = data.lines;
        this.startTime = data.startTime;
        this.endTime = data.endTime;
    }

    preload() {

        this.load.image('gameoverBackground', IMG_PATH + 'assets/gameover.png'); // 경로는 프로젝트에 맞게
    }

    create() {

        const payload = {
            userId: loginId,
            game_seq: parseInt(new URLSearchParams(window.location.search).get("game_seq")),
            gameScore: this.score,
            gameStartTime: Number(this.startTime),
            gameEndTime: Number(this.endTime)
        };

        console.log("전송할 JSON:", JSON.stringify(payload)); // 확인용 로그

        $.ajax({
            url: "/api/game/recordInsert",
            contentType: "application/json",
            type: "post",
            data: JSON.stringify(payload)

        }).done(function (resp) {

            console.log(resp);

        });

    

        let bg = this.add.image(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2,
            'gameoverBackground'
        ).setOrigin(0.5, 0.5).setScale(0.7, 0.8);

        const uiX = this.cameras.main.width / 2; // 보드 오른쪽 시작 X
        let yOffset = this.cameras.main.height / 2 + 32;

        // Score 네온 텍스트
        this.scoreText = this.add.text(uiX, yOffset + 30, `Score : ${this.score}`, {
            fontSize: '32px',
            fontFamily: 'Arial Black',
            color: '#fff4e3ff',          // 기본 글자 색
            stroke: '#ffffffff',         // 테두리 색도 동일

        }).setOrigin(0.5, 0.5);
        this.scoreText.setShadow(0, 0, '#ffc547ee', 10, true, true);


        this.linesText = this.add.text(uiX, yOffset + 75, `Lines : ${this.lines}`, {
            fontSize: '32px',
            fontFamily: 'Arial Black',
            color: '#fff4e3ff',          // 기본 글자 색
            stroke: '#ffffffff',         // 테두리 색도 동일

        }).setOrigin(0.5, 0.5);
        this.linesText.setShadow(0, 0, '#ffc547ee', 10, true, true);

        this.levelText = this.add.text(uiX, yOffset + 120, `Level : ${this.level}`, {
            fontSize: '32px',
            fontFamily: 'Arial Black',
            color: '#fff4e3ff',          // 기본 글자 색
            stroke: '#ffffffff',         // 테두리 색도 동일

        }).setOrigin(0.5, 0.5);
        this.levelText.setShadow(0, 0, '#ffc547ee', 10, true, true);

        // 버튼 공통 함수
        const createButton = (x, y, text, callback) => {
            // 버튼 배경 Graphics

            // 버튼 텍스트
            let btnText = this.add.text(x, y, text, {
                fontSize: '30px',
                fontFamily: 'Arial Black',
                color: '#fff4e3ff'
            }).setOrigin(0.5).setInteractive({ useHandCursor: true });
            btnText.setShadow(0, 0, '#ffc547ee', 10, true, true);


            // 클릭 이벤트
            btnText.on('pointerdown', callback);

            // 마우스 오버/아웃 이벤트
            btnText.on('pointerover', () => {
                btnText.setFontSize("35px");
                btnText.setColor('#ffe679f1');  // 글자 색 반전
            });

            btnText.on('pointerout', () => {
                btnText.setFontSize("30px");
                btnText.setColor('#fff4e3ff');
            });

            return { btnText };
        };

        // 사용 예
        this.restartButton = createButton(this.cameras.main.width / 2 - 100, this.cameras.main.height / 2 + 203, "Restart", () => {
            this.scene.start("tetris");

        });
        this.mainMenuButton = createButton(this.cameras.main.width / 2 + 100, this.cameras.main.height / 2 + 203, "Main Menu", () => {
            this.scene.start("GameIntro");
        });

        this.blinkTexts = [this.scoreText, this.linesText, this.levelText];
        this.blinkAlpha = 0.3;
        this.blinkDirection = 1;
    }
    // update()
    update() {

    }
}