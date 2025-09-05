class GameOverScene extends Phaser.Scene {
	constructor() {
		super({ key: "GameOverScene" });
	}

	init(data) {
		this.finalScore = data?.score ?? 0;
		this.finalTime = data?.elapsed || 0;
		this.ending = data.ending;
		this.startTime = data.startTime;
		this.endTime = data.endTime;
		console.log('GameOverScene init:', data);
		// ✅ 점수 기반 포인트 계산 (100분의 1, 최대 300포인트)
		this.finalPoint = Math.min(300, Math.floor(this.finalScore / 100));
	}

	create(data) {
		// 점수 비례 얻은 포인트
		const pointValue = this.finalPoint;
		// 플레이 기록 저장 준비
		const payload = {
			userId: loginId,
			game_seq: parseInt(new URLSearchParams(window.location.search).get("game_seq")),
			gameScore: this.finalScore,
			gameStartTime: Number(this.startTime),
			gameEndTime: Number(this.endTime)

		};

		console.log("전송할 JSON:", JSON.stringify(payload)); // 확인용 로그

		$.ajax({
			url: "/api/game/recordInsert",
			contentType: "application/json",
			type: "post",
			data: JSON.stringify(payload)

		}).done(function(resp) {

			console.log(resp);

		});

		$.ajax({
			url: "/api/point/gameOver",
			type: "POST",
			data: {
				seq: 6,               // POINT 테이블의 SEQ
				pointValue: pointValue       // 클라이언트에서 계산된 포인트 값
			},
			success: function(response) {
				console.log("포인트 지급 성공:", response);
			},
			error: function(xhr) {
				console.error("에러 발생:", xhr.responseText);
			}
		});

		// 움직인 px 가져오기
		const movedDist = data.totalMovedDist || 0;
		// 업적 체크 300px 움직이면
		if (movedDist >= 300) this.unlockAchievement("MEOW_WALKER");
		console.log('생존 시간 확인:', this.finalTime);

		// 1. 배경 꽉 채우기
		this.add.image(400, 400, "background")
			.setDisplaySize(800, 800)
			.setDepth(-2);

		// 2. 흰색 박스 (결과 표시 영역 강조)
		const graphics = this.add.graphics();
		graphics.fillStyle(0xffffff, 1);
		graphics.fillRoundedRect(97, 100, 606, 600, 20);

		// 💎 획득 포인트 표시
		this.add.text(400, 150, '획득 포인트 : ' + this.finalPoint, {
			fontSize: "24px",
			fontFamily: "Arial, sans-serif",
			color: "#ff9900", // 눈에 띄는 오렌지색
			fontStyle: "bold"
		}).setOrigin(0.5);

		// 3. 주인공 고양이 (죽어서 시무룩한 버전이 있으면 교체 가능)
		const cat = this.add.image(400, 250, "gameover_cat")
			.setDisplaySize(120, 120)
			.setDepth(1);

		// 살짝 위아래 애니메이션 (울먹이는 느낌)
		this.tweens.add({
			targets: cat,
			y: 260,
			duration: 600,
			yoyo: true,
			repeat: -1,
			ease: "Sine.easeInOut"
		});

		// 4. "GAME OVER" 텍스트 (핑크+테두리로 귀엽게)
		this.add.text(400, 360, "화살 못피했냥..", {
			fontSize: "50px",
			fontFamily: "Arial Black, sans-serif",
			color: "#ff6699",
			stroke: "#ffffff",
			strokeThickness: 8,
			shadow: { offsetX: 3, offsetY: 3, color: "#000", blur: 5, fill: true }
		}).setOrigin(0.5);

		// 5. 점수 표시
		this.add.text(400, 420, '점수 : ' + this.finalScore, {
			fontSize: "26px",
			fontFamily: "Arial, sans-serif",
			color: "#333"
		}).setOrigin(0.5);

		this.add.text(400, 460, '최고 점수 : ' + bestScore, {
			fontSize: "26px",
			fontFamily: "Arial, sans-serif",
			color: "#666"
		}).setOrigin(0.5);

		// 6. 생존 시간 표시
		this.add.text(400, 500, '생존 시간 : ' + this.formatTime(this.finalTime), {
			fontSize: "26px",
			fontFamily: "Arial, sans-serif",
			color: "#444"
		}).setOrigin(0.5);

		// 7. 재시작 텍스트 (깜빡이는 효과)
		const restartText = this.add.text(400, 560, "SPACE / CLICK: 다시 시작", {
			fontSize: "22px",
			fontFamily: "Arial, sans-serif",
			color: "#555"
		}).setOrigin(0.5).setInteractive({ useHandCursor: true });

		this.tweens.add({
			targets: restartText,
			alpha: 0,
			duration: 700,
			yoyo: true,
			repeat: -1
		});

		// 👉 업적 체크 (사망 관련)
		const mainScene = this.scene.get("MainScene");
		mainScene.deathCount++;
		mainScene.isGameOver = true;

		// 점수 업적
		if (mainScene.score >= 1000) mainScene.unlockAchievement("MEOW_SCORE_1000");
		if (mainScene.score >= 3000) mainScene.unlockAchievement("MEOW_SCORE_3000");
		if (mainScene.score >= 7000) mainScene.unlockAchievement("MEOW_SCORE_7000");

		// 사망 관련 업적
		if (mainScene.deathCount === 1) mainScene.unlockAchievement("MEOW_FIRST_DEATH");

		// ⏱ 생존 시간 업적 체크
		const survivedSeconds = Math.floor(this.finalTime / 1000);

		if (survivedSeconds >= 30) mainScene.unlockAchievement("MEOW_SURVIVE_30S");
		if (survivedSeconds >= 60) mainScene.unlockAchievement("MEOW_SURVIVE_1M");
		if (survivedSeconds >= 120) mainScene.unlockAchievement("MEOW_SURVIVE_2M");
		if (survivedSeconds >= 180) mainScene.unlockAchievement("MEOW_SURVIVE_3M");

		for (const id in achievements) {
			const ach = achievements[id];
			if (!mainScene.unlockedAchievements.has(id) && ach.condition(mainScene)) {
				mainScene.unlockAchievement(id);
			};
		};

		// 스페이스바 입력 → 다시 시작
		this.input.keyboard.once("keydown-SPACE", () => this.handleRestart(mainScene));

		// 마우스 클릭 입력 → 다시 시작
		restartText.on("pointerdown", () => this.handleRestart(mainScene));
	}

	handleRestart(mainScene) {
		mainScene.restartCount++;

		// 재시작 관련 업적 즉시 체크
		if (mainScene.restartCount >= 3) {
			mainScene.unlockAchievement("MEOW_RESTART_3X");
		} else if (mainScene.restartCount >= 10) {
			mainScene.unlockAchievement("MEOW_RESTART_10X");
		};

		this.scene.stop("GameOverScene");
		this.scene.start("MainScene", {
			loginId: loginId,
			restartCount: mainScene.restartCount // ✅ 같이 넘겨줌
		})
	}

	formatTime(ms) {
		const totalSeconds = Math.floor(ms / 1000);
		const minutes = Math.floor(totalSeconds / 60);
		const seconds = totalSeconds % 60;
		return String(minutes).padStart(2, "0") + ':' + String(seconds).padStart(2, "0");
	}
}
