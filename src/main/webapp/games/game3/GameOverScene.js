class GameOverScene extends Phaser.Scene {
	constructor() {
		super({ key: "GameOverScene" });
	}

	init(data) {
		this.finalScore = data?.score ?? 0;
		this.finalTime = data?.time ?? 0;
	}

	create() {
		// 1. 배경 꽉 채우기
		this.add.image(400, 400, "background")
			.setDisplaySize(800, 800)
			.setDepth(-2);

		// 2. 흰색 박스 (결과 표시 영역 강조)
		const graphics = this.add.graphics();
		graphics.fillStyle(0xffffff, 1);
		graphics.fillRoundedRect(97, 100, 606, 600, 20);

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
		this.add.text(400, 420, `점수 : ${this.finalScore}`, {
			fontSize: "26px",
			fontFamily: "Arial, sans-serif",
			color: "#333"
		}).setOrigin(0.5);

		this.add.text(400, 460, `최고 점수 : ${bestScore}`, {
			fontSize: "26px",
			fontFamily: "Arial, sans-serif",
			color: "#666"
		}).setOrigin(0.5);

		// 6. 생존 시간 표시
		this.add.text(400, 500, `생존 시간 : ${this.formatTime(this.finalTime)}`, {
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
		if (mainScene.score >= 5000) mainScene.unlockAchievement("MEOW_SCORE_5000");
		if (mainScene.score >= 10000) mainScene.unlockAchievement("MEOW_SCORE_10000");

		// 사망 관련 업적
		if (mainScene.deathCount === 1) mainScene.unlockAchievement("MEOW_FIRST_DEATH");
		if (mainScene.restartCount >= 3) mainScene.unlockAchievement("MEOW_RESTART_3X");
		if (mainScene.isGameOver && mainScene.score === 0) mainScene.unlockAchievement("MEOW_DIE_AT_0");
		for (const id in achievements) {
			const ach = achievements[id];
			if (!mainScene.unlockedAchievements.has(id) && ach.condition(mainScene)) {
				mainScene.unlockAchievement(id);
			}
		}

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
		}

		this.scene.stop("GameOverScene");
		this.scene.start("MainScene");
	}

	formatTime(ms) {
		const totalSeconds = Math.floor(ms / 1000);
		const minutes = Math.floor(totalSeconds / 60);
		const seconds = totalSeconds % 60;
		return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
	}
}
