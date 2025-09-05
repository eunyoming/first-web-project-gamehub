class Gameover extends Phaser.Scene {

    constructor() {
        super({ key: "Gameover" })
    }

    init(data) {
        this.finalScore = data.score || 0; // 이전 씬에서 전달받은 점수
        this.finalPoint = data.points || 0;
        this.startTime = data.startTime;
        this.endTime = data.endTime;
    }

    preload() { }

    create() {
        this.cameras.main.setBackgroundColor('#000000');
        this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 - 200,
            "G A M E  O V E R",
            { fontSize: "80px", fontStyle: "bold", fill: "#ff0000" }
        ).setOrigin(0.5);

        this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 - 20,
            'Total Score: ' + this.finalScore,
            { fontSize: '32px', fill: "#ff0000" }
        ).setOrigin(0.5);

        let restartButton = this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 + 50,
            "Retry?",
            { fontSize: '20px', padding: 10, fill: "#ff0000" }
        ).setOrigin(0.5).setInteractive();

        restartButton.on("pointerdown", () => {
            this.scene.start("MainScene");
        });
        restartButton.on("pointerover", () => {
            restartButton.setBackgroundColor("#ccc");
            this.game.canvas.style.cursor = "pointer";
        });
        restartButton.on("pointerout", () => {
            restartButton.setBackgroundColor("#000000");
            this.game.canvas.style.cursor = "default";
        });

        let toTitleButton = this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 + 100,
            "To Title",
            { fontSize: '20px', padding: 10, fill: "#ff0000" }
        ).setOrigin(0.5).setInteractive();

        toTitleButton.on("pointerdown", () => {
            this.scene.start("GameTitle");
        });
        toTitleButton.on("pointerover", () => {
            toTitleButton.setBackgroundColor("#ccc");
            this.game.canvas.style.cursor = "pointer";
        });
        toTitleButton.on("pointerout", () => {
            toTitleButton.setBackgroundColor("#000000");
            this.game.canvas.style.cursor = "default";
        });

        // ✅ 회원 여부 체크
        if (loginId && loginId !== "") {
            const payload = {
                userId: loginId,
                game_seq: parseInt(new URLSearchParams(window.location.search).get("game_seq")),
                gameScore: this.finalScore,
                gameStartTime: Number(this.startTime),
                gameEndTime: Number(this.endTime),
            };

            console.log("전송할 JSON:", JSON.stringify(payload));

            // 게임 기록 서버 전송
            $.ajax({
                url: "/api/game/recordInsert",
                type: "post",
                contentType: "application/json",
                data: JSON.stringify(payload)
            }).done(function(resp){
                console.log(resp);
            });

            // 포인트 서버 전송
            $.ajax({
                url: "/api/point/gameOver",
                type: "POST",
                data: {
                    seq: 6,               // POINT 테이블의 SEQ
                    pointValue: this.finalPoint
                },
                success: function(response) {
                    console.log("포인트 지급 성공:", response);
                },
                error: function(xhr) {
                    console.error("에러 발생:", xhr.responseText);
                }
            });
        } else {
            console.log("비회원은 서버 전송 생략");
        }
    }

    update() { }
}
