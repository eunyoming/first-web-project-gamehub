// --- 전역 변수 --- 
let bestScore = 0;

class MainScene extends Phaser.Scene {
	constructor() {
		super("MainScene");

		this.unlockedAchievements = new Set();
		this.deathCount = 0;
		this.restartCount = 0;
		this.afkTime = 0;
		this.movingTime = 0;
		this.patternsSeen = 0;
		this.totalPatterns = 7; // single, circle, spiral, down, up, left, right
	}

	init(data) {
		this.score = 0;                 // 점수 리셋
		this.isGameOver = false;        // 상태 리셋
		this.elapsed = 0;				// 경과시간 리셋
		// 재시작 카운트 가져오기
		this.restartCount = data.restartCount;

		// data가 없으면 전역 loginId 사용
		this.loginId = (data && data.loginId) ? data.loginId : (typeof loginId !== "undefined" ? loginId : "");
	}

	preload() {
		this.load.image("background", IMG_PATH + "assets/background_body.png"); // 첫 번째 이미지
		this.load.image("cat", IMG_PATH + "assets/player.png"); // 두 번째 이미지 (주인공 고양이)
		this.load.image("arrow", IMG_PATH + "assets/arrow.png");
	}

	create() {
		// 시작 타임 설정
		this.startTime = null;

		this.matter.world.resume(); // 다시 시작할 때 월드 재개

		// 기존 이벤트 리스너 제거 후 새로 등록
		this.matter.world.off("collisionstart");
		this.hitDetected = false;
		this.matter.world.on('collisionstart', (event, bodyA, bodyB) => {
		    if (bodyA.gameObject === this.player || bodyB.gameObject === this.player) {
		        this.hitDetected = true;
		    }
		});

		// 배경/텍스트
		// 배경 (800x800 기준으로 중앙 배치)
		this.background = this.add.image(400, 400, "background").setDisplaySize(800, 800).setDepth(-1);

		// 게임 플레이 구역 (600x600, 중앙 400,400 기준)
		this.playArea = new Phaser.Geom.Rectangle(100, 100, 600, 600);

		// 👉 흰색 배경 그리기
		const graphics = this.add.graphics();
		graphics.fillStyle(0xffffff, 1); // 흰색, 불투명
		graphics.fillRectShape(this.playArea);

		// 배경은 항상 뒤로 보내기
		graphics.setDepth(-0.5);

		// 플레이어 생성 (중앙에 위치)
		this.player = this.matter.add.image(400, 400, "cat");

		// 크기 줄이기 (가로세로 48픽셀)
		this.player.setDisplaySize(48, 48);

		// 다시 원형 충돌체 설정 (이미지가 리사이즈 되었으니 hitbox도 갱신)
		this.player.setCircle(16); // 반지름 24px
		this.player.setFrictionAir(0.05);
		this.player.setFixedRotation();

		// 👉 플레이어 움직임이 playArea 밖으로 안 나가게 하기 위해 이벤트 추가
		this.events.on("update", () => {
			if (!Phaser.Geom.Rectangle.Contains(this.playArea, this.player.x, this.player.y)) {
				// 벗어나면 강제로 안쪽으로 되돌리기
				this.player.x = Phaser.Math.Clamp(this.player.x, 100, 700);
				this.player.y = Phaser.Math.Clamp(this.player.y, 100, 700);
			}
		});
		
		// --- 초기 이동 관련 변수 초기화 (중요) ---
		this.player.totalMovedDist = 0;
		this.player.prevX = this.player.x;
		this.player.prevY = this.player.y;

		// 점수 텍스트
		this.scoreText = this.add.text(110, 110, "Score: 0", {
			font: "bold 20px Arial", // 굵게 + 크기 + 폰트
			color: "#000"
		});

		// 경과 시간 텍스트
		this.timeText = this.add.text(110, 140, "Time: 0s", {
			font: "bold 20px Arial", // 굵게
			color: "#000"
		});

		// 게임 시작
		this.score = 0;
		this.elapsed = 0;
		this.isGameOver = false;

		this.arrows = [];
		this.seenPatterns = new Set();

		// 재시작 카운트
		this.restartCount++;

		// 입력
		this.cursors = this.input.keyboard.createCursorKeys();

		// 충돌 이벤트 (플레이어 vs 화살)
		this.matter.world.on("collisionstart", (event, bodyA, bodyB) => {
			if (bodyA.gameObject === this.player || bodyB.gameObject === this.player) {
			}
		});

		// 화살 저장용 배열 (Matter는 group 개념이 달라서 직접 관리)
		this.arrows = [];
		// 난이도 변수
		this.arrowSpeed = 120;
		this.spawnDelay = 1600;
		this.diffTimer = 0;

		// 패턴 생성 타이머
		this.spawnEvent = this.time.addEvent({
			delay: this.spawnDelay,
			loop: true,
			callback: () => this.spawnPattern(),
		});

		// 카테고리 정의
		this.arrowCategory = this.matter.world.nextCategory();
		this.playerCategory = this.matter.world.nextCategory();

		// 플레이어 충돌 설정
		this.player.setCollisionCategory(this.playerCategory);
		this.player.setCollidesWith(this.arrowCategory);

		// 이미 달성한 업적 저장
		this.unlockedAchievements = new Set();

		// 업적 체크용 상태 값들
		this.afkTime = 0;
		this.movingTime = 0;
		this.patternsSeen = 0;
		this.totalPatterns = 7;
		this.deathCount = 0;
		this.hitCount = 0;
	}

	update(time, delta) {
		this.debugTimer = (this.debugTimer || 0) + delta;
		if (this.debugTimer >= 1000) {
			this.debugTimer = 0;
		}
		if (this.isGameOver) return;

		// 최초 시작 시간 기록
		if (this.startTime === null) {
		    this.startTime = time;
		}

		// 이동
		const speed = 3;
		this.player.setVelocity(0, 0);
		if (this.cursors.left.isDown) this.player.setVelocityX(-speed);
		if (this.cursors.right.isDown) this.player.setVelocityX(speed);
		if (this.cursors.up.isDown) this.player.setVelocityY(-speed);
		if (this.cursors.down.isDown) this.player.setVelocityY(speed);

		// --- 경과 시간 ---
		const elapsed = time - this.startTime;
		const minutes = Math.floor(elapsed / 60000);
		const seconds = Math.floor((elapsed % 60000) / 1000);
		const formatted = minutes + ':' + seconds.toString().padStart(2, '0');
		this.timeText.setText('Time: ' + formatted);

		// --- 점수 ---
		this.score += minutes + 1;
		this.scoreText.setText('Score: ' + this.score);

		// 난이도 점진 상승 (10초마다)
		this.diffTimer += delta;
		if (this.diffTimer >= 10000) {
			this.diffTimer = 0;

			if (Phaser.Math.Between(0, 1) === 0) {
				if (this.arrowSpeed < 300) {
					this.arrowSpeed += 20;
					if (this.arrowSpeed > 300) this.arrowSpeed = 300;
				}
			} else {
				if (this.spawnDelay > 500) {
					this.spawnDelay -= 150;
					if (this.spawnDelay < 500) this.spawnDelay = 500;

					this.spawnEvent.remove(false);
					this.spawnEvent = this.time.addEvent({
						delay: this.spawnDelay,
						loop: true,
						callback: () => this.spawnPattern(),
					});
				}
			}

			// AFK 체크
			if (!this.cursors.left.isDown && !this.cursors.right.isDown &&
				!this.cursors.up.isDown && !this.cursors.down.isDown) {
				this.afkTime += delta;
				if (this.afkTime >= 15000) {
					this.unlockAchievement('MEOW_AFK_15S');
					this.afkTime = 0;
				}
			} else {
				this.afkTime = 0;
			}

			// 계속 움직이기 체크
			if (this.cursors.left.isDown || this.cursors.right.isDown ||
				this.cursors.up.isDown || this.cursors.down.isDown) {
				this.movingTime += delta;
				if (this.movingTime >= 15000) {
					this.unlockAchievement('MEOW_KEEP_MOVING_15S');
					this.movingTime = 0;
				}
			} else {
				this.movingTime = 0;
			}
		}
		
		// 충돌시 게임오버
		if (this.hitDetected) {
		    this.gameOver(elapsed); // ✅ time 넘기기
		    this.hitDetected = false;
		}
	}

	// 랜덤 패턴
	spawnPattern() {
		const patterns = ["single", "circle", "spiral", "down", "up", "left", "right"];
		const pick = Phaser.Utils.Array.GetRandom(patterns);

		this.seenPatterns.add(pick);
		this.patternsSeen = this.seenPatterns.size;

		switch (pick) {
			case "single": this.spawnSingle(); break;
			case "circle": this.spawnCircle(); break;
			case "spiral": this.spawnSpiral(); break;
			case "down": this.spawnDown(); break;
			case "up": this.spawnUp(); break;
			case "left": this.spawnLeft(); break;
			case "right": this.spawnRight(); break;
		}
	}

	// 공통: 화살 생성 (Matter.js)
	createArrow(x, y, vx, vy) {
		const arrow = this.matter.add.image(x, y, "arrow");
		arrow.setDisplaySize(48, 48);
		arrow.setFrictionAir(0);
		arrow.setVelocity(vx / 60, vy / 60);

		// 회전 각도 계산
		const angleRad = Math.atan2(vy, vx);

		// 👉 히트박스 모양 정의
		// 히트박스 (항상 같은 모양, 예: 가로 방향)
		const verts = Phaser.Physics.Matter.Matter.Vertices.fromPath(
			"0 0  32 4  48 6  32 8  0 12"
		);

		// 👉 바디 설정
		arrow.setBody({
			type: "fromVertices",
			verts: verts,
			flagInternal: true,
		});

		// 바디에도 회전 적용
		this.matter.body.setAngle(arrow.body, angleRad);

		// 👉 이미지 회전도 적용 (동기화)
		arrow.setRotation(angleRad);

		// 👉 충돌 설정 (화살 ↔ 플레이어만 충돌)
		arrow.setCollisionCategory(this.arrowCategory);
		arrow.setCollidesWith(this.playerCategory);

		this.arrows.push(arrow);
		return arrow;
	}


	// 1) 랜덤 싱글
	spawnSingle() {
		const x = Phaser.Math.Between(this.playArea.x, this.playArea.x + this.playArea.width);
		const y = Phaser.Math.Between(this.playArea.y, this.playArea.y + this.playArea.height);
		const vx = Phaser.Math.Between(-this.arrowSpeed, this.arrowSpeed);
		const vy = Phaser.Math.Between(-this.arrowSpeed, this.arrowSpeed);

		if (vx === 0 && vy === 0) vy = this.arrowSpeed;
		this.createArrow(x, y, vx, vy);
	}

	// 2) 원형 (가장자리 → 중앙)
	spawnCircle() {
		const cx = this.playArea.centerX;
		const cy = this.playArea.centerY;
		const n = 14;

		for (let i = 0; i < n; i++) {
			let x, y;
			const side = Phaser.Math.Between(0, 3);

			if (side === 0) {
				// 위쪽
				x = Phaser.Math.Between(this.playArea.x, this.playArea.right);
				y = this.playArea.y - 20;
			} else if (side === 1) {
				// 오른쪽
				x = this.playArea.right + 20;
				y = Phaser.Math.Between(this.playArea.y, this.playArea.bottom);
			} else if (side === 2) {
				// 아래쪽
				x = Phaser.Math.Between(this.playArea.x, this.playArea.right);
				y = this.playArea.bottom + 20;
			} else {
				// 왼쪽
				x = this.playArea.x - 20;
				y = Phaser.Math.Between(this.playArea.y, this.playArea.bottom);
			}

			const dx = cx - x;
			const dy = cy - y;
			const len = Math.sqrt(dx * dx + dy * dy);

			const speedFactor = Phaser.Math.FloatBetween(0.7, 1.3);
			const vx = (dx / len) * this.arrowSpeed * speedFactor;
			const vy = (dy / len) * this.arrowSpeed * speedFactor;

			this.createArrow(x, y, vx, vy);
		}
	}

	// 3) 나선형 (가장자리 → 중앙)
	spawnSpiral() {
		const cx = this.playArea.centerX;
		const cy = this.playArea.centerY;
		const n = 20;

		let angle = Math.random() * Phaser.Math.PI2;
		for (let i = 0; i < n; i++) {
			angle += 0.3;

			const radius = Math.max(this.playArea.width, this.playArea.height) / 2 + 50;
			const x = cx + Math.cos(angle) * radius;
			const y = cy + Math.sin(angle) * radius;

			const dx = cx - x;
			const dy = cy - y;
			const len = Math.sqrt(dx * dx + dy * dy);

			// 속도 랜덤 보정
			const speedFactor = Phaser.Math.FloatBetween(0.6, 1.4);
			const vx = (dx / len) * this.arrowSpeed * speedFactor;
			const vy = (dy / len) * this.arrowSpeed * speedFactor;

			this.createArrow(x, y, vx, vy);
		}
	}

	// 4) 위 → 아래
	spawnDown() {
		const step = this.playArea.width / 7; // 균등 간격
		for (let i = 1; i <= 6; i++) {
			const x = this.playArea.x + step * i;
			this.createArrow(x, this.playArea.y - 20, 0, this.arrowSpeed);
		}
	}

	// 5) 아래 → 위
	spawnUp() {
		const step = this.playArea.width / 7;
		for (let i = 1; i <= 6; i++) {
			const x = this.playArea.x + step * i;
			this.createArrow(x, this.playArea.bottom + 20, 0, -this.arrowSpeed);
		}
	}

	// 6) 왼 → 오
	spawnRight() {
		const step = this.playArea.height / 7;
		for (let i = 1; i <= 6; i++) {
			const y = this.playArea.y + step * i;
			this.createArrow(this.playArea.x - 20, y, this.arrowSpeed, 0);
		}
	}

	// 7) 오 → 왼
	spawnLeft() {
		const step = this.playArea.height / 7;
		for (let i = 1; i <= 6; i++) {
			const y = this.playArea.y + step * i;
			this.createArrow(this.playArea.right + 20, y, -this.arrowSpeed, 0);
		}
	}

	gameOver(elapsed) {
		if (this.isGameOver) return;
		this.isGameOver = true;
		
		// 최고 점수 갱신
		if (this.score > bestScore) {
			bestScore = this.score;
		}

		// GameOverScene 으로 점수 + 시간 넘기기
		this.scene.start('GameOverScene', {
		        score: this.score,
		        elapsed: elapsed,   // 그대로 전달
		        startTime: this.startTime,
		        endTime: this.time.now, // 원한다면 종료 시각도 넘길 수 있음
		    });
	}


	// --- 업적 달성 ---
	unlockAchievement(achievementId) {
		if (loginId === "") return;

		if (this.unlockedAchievements.has(achievementId)) return;

		this.unlockedAchievements.add(achievementId);

		// 👉 업적 정보 가져오기
		const ach = achievements[achievementId];
		const title = ach ? ach.title : achievementId;
		const description = ach ? ach.description : "";

		$.ajax({
			url: "/api/achievement/unlock",
			type: "POST",
			contentType: "application/json",
			data: JSON.stringify({
				userId: loginId,
				achievementId: achievementId,
				unlocked_at: Date.now()
			})
		}).done((resp) => {
			if (resp.status === "success") {
				const popupTitle = resp.title || title;
				const popupDesc = resp.description || description;

				console.log("🎉 업적 달성:", popupTitle, "| 설명:", popupDesc);
				showAchievementPopup("🎉 업적 달성: " + popupTitle, popupDesc);
			}
		}).fail((err) => {
			console.error("업적 서버 오류:", err);
		});
	}


	formatTime(ms) {
		const totalSeconds = Math.floor(ms / 1000);
		const minutes = Math.floor(totalSeconds / 60);
		const seconds = totalSeconds % 60;

		return String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
	}

	spawnPattern() {
		const patterns = ["single", "circle", "spiral", "down", "up", "left", "right"];
		const pick = Phaser.Utils.Array.GetRandom(patterns);

		// 패턴 경험 카운트
		if (!this.seenPatterns) this.seenPatterns = new Set();
		this.seenPatterns.add(pick);
		this.patternsSeen = this.seenPatterns.size;

		// 👉 모든 패턴 경험 업적 체크
		if (this.patternsSeen === this.totalPatterns) {
			this.unlockAchievement("MEOW_SEE_ALL_PATTERNS");
		}

		// 기존 패턴 실행
		switch (pick) {
			case "single": this.spawnSingle(); break;
			case "circle": this.spawnCircle(); break;
			case "spiral": this.spawnSpiral(); break;
			case "down": this.spawnDown(); break;
			case "up": this.spawnUp(); break;
			case "left": this.spawnLeft(); break;
			case "right": this.spawnRight(); break;
		}
	}
}
