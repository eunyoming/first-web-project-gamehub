class Gameover extends Phaser.Scene {

    constructor() {
        super({ key: "Gameover" })
    }
    init(data) {
        this.finalScore = data.score || 0; // 이전 씬에서 전달받은 점수
        this.finalPoint = data.points;
		this.startTime = data.startTime;
		this.endTime = data.endTime;
			
		
    }

    //score: this.score, startTime : this.startTimeStamp, endTime : Datenow() ,points : this.points 
    preload() { }

    create() {
		
		const payload = {
			
		userId : loginId,
		game_seq:  parseInt(new URLSearchParams(window.location.search).get("game_seq")),
		gameScore: this.finalScore,
		gameStartTime: Number(this.startTime),
		gameEndTime: Number(this.endTime),
		
		};
		
		
		console.log("전송할 JSON:", JSON.stringify(payload));
		
        this.cameras.main.setBackgroundColor('#000000');
        this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 - 200,
            "G A M E  O V E R",
            {
                fontSize: "80px",
                fontStyle: "bold",
                fill: "#ff0000"
            }
        ).setOrigin(0.5);

        this.add.text(this.cameras.main.width / 2,
            this.cameras.main.height / 2 - 20, 'Total Score: ' + this.finalScore,
            { fontSize: '32px', fill: "#ff0000" }).setOrigin(0.5);

        let restartButton = this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 + 50,
            "Retry?",
            {
                fontSize: '20px',
                padding: 10,
                fill: "#ff0000"
            }
        ).setOrigin(0.5).setInteractive();

        restartButton.on("pointerdown", () => {
            this.scene.start("MainScene"); // 씬 넘어가기
        })
        restartButton.on("pointerover", () => {
            restartButton.setBackgroundColor("#ccc");
            this.game.canvas.style.cursor = "pointer";
        })
        restartButton.on("pointerout", () => {
            restartButton.setBackgroundColor("#000000");
            this.game.canvas.style.cursor = "default";
        })

        let toTitleButton = this.add.text(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2 + 100,
            "To Title",
            {
                fontSize: '20px',
                padding: 10,
                fill: "#ff0000"
            }
        ).setOrigin(0.5).setInteractive();

        toTitleButton.on("pointerdown", () => {
            this.scene.start("GameTitle"); // 씬 넘어가기
        })
        toTitleButton.on("pointerover", () => {
            toTitleButton.setBackgroundColor("#ccc");
            this.game.canvas.style.cursor = "pointer";
        })
        toTitleButton.on("pointerout", () => {
            toTitleButton.setBackgroundColor("#000000");
            this.game.canvas.style.cursor = "default";
        })
		
        // 현재 URL에서 game_seq가져오기
    
        // ✅ Ajax 전송 (게임 기록 저장)
        $.ajax({
            url: "/api/game/recordInsert",
            type: "post",
            contentType: "application/json",
            data: JSON.stringify(payload)
				
            }).done(function(resp){
							
			console.log(resp);
							
			}); 
        $.ajax({
			    url: "/api/point/gameOver",
			    type: "POST",
			    data: {
			        seq: 6,               // POINT 테이블의 SEQ
			        pointValue: this.finalPoint       // 클라이언트에서 계산된 포인트 값
			    },
			    success: function(response) {
			        console.log("포인트 지급 성공:", response);
			    },
			    error: function(xhr) {
			        console.error("에러 발생:", xhr.responseText);
			    }
			});

    }

    update() { }
}