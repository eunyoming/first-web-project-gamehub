

class MainGame extends Phaser.Scene {


	constructor() {
		super({ key: "MainGame" });

	}

	init() {

		this.startTimeStamp = Date.now();
		this.difficultyLevel = 1; // 기본 난이도
		this.point = 0;
		this.score = 0;
		this.heart = 2;
		this.lazorCount = 2;
		this.bossSpawned = false;
		this.obstacles = null;
		this.items = null;
		this.obstacleTimer = null;
		this.checkTimer = null;
		this.playerHasLaser = false;
		this.attackCount = 0;
		this.speedCount = 0;
		this.unlockedAchievements = new Set();
		this.startTime = null;

	}

	preload() {

		this.load.image('player', IMG_PATH + 'assets/image/spaceship.png');
		this.load.image("stone", IMG_PATH + "assets/image/stone.png")
		this.load.image("stone2", IMG_PATH + "assets/image/stone2.png")
		this.load.image("stone3", IMG_PATH + "assets/image/stone3.png")
		this.load.image("item1", IMG_PATH + "assets/image/item01.png") //레이저 획득 아이템
		this.load.image("item2", IMG_PATH + "assets/image/item02.png") //점수 획득 아이템
		this.load.image("item3", IMG_PATH + "assets/image/item03.png") //체력 회복 아이템
		this.load.image("item4", IMG_PATH + "assets/image/item04.png"); // 속도 증가 아이템
		this.load.image("bossJet", IMG_PATH + "assets/image/boss.png");
		this.load.image("bossBullet", IMG_PATH + "assets/image/boss_bullet.png");

		this.load.image("background", IMG_PATH + "assets/image/background.png");

		this.load.spritesheet("lazor", IMG_PATH + "assets/image/lazor_vertical.png", {
			frameWidth: 60,
			frameHeight: 482

		});

	}


	create() {
		
		this.speed = 350;
		this.cameras.main.setBackgroundColor("#ffffff");
		

		if (this.obstacleTimer) {
			this.obstacleTimer.remove(false); // false: 즉시 제거
		}

		if (this.checkTimer) {
			this.checkTimer.remove(false);
		}


		// 난이도 체크 타이머 (매 5초마다 확인)
		this.checkTimer = this.time.addEvent({
			delay: 5000,
			loop: true,
			callback: () => {
				const elapsed = (this.time.now - this.startTime) / 1000;

				let newLevel = this.difficultyLevel;
	

				if (elapsed > 80 && !this.bossSpawned) {
					newLevel = 5;

					//보스 출현
					this.spawnBoss();

					this.bossSpawned = true;
				}
				else if (elapsed > 60) newLevel = 4;
				else if (elapsed > 40) newLevel = 3;
				else if (elapsed > 20) newLevel = 2;

				if (newLevel !== this.difficultyLevel) {
					this.difficultyLevel = newLevel;
					console.log(`난이도 변경: ${this.difficultyLevel}`);

				}
			}
		});



		this.tileSprite = this.add.tileSprite(0, 0, 900, 900, 'background').setOrigin(0, 0);

		if (!this.anims.exists('attack')) {
			this.anims.create({
				key: 'attack',
				frames: this.anims.generateFrameNumbers('lazor', { start: 0, end: 7 }),
				frameRate: 8,
				repeat: 0
			});
		}

		let cameraWidth = this.cameras.main.width;
		let cameraHeight = this.cameras.main.height;


		this.player = this.physics.add.sprite(cameraWidth / 2, cameraHeight - 100, "player")
			.setScale(0.3, 0.3)
			.setSize(200, 300);

		this.obstacles = this.physics.add.group();
		this.items = this.physics.add.group();

		this.cursor = this.input.keyboard.createCursorKeys();

		this.player.setCollideWorldBounds(true);

		let rectangle = this.add.rectangle(cameraWidth / 2, cameraHeight + 60, cameraWidth, 1, 0x000000);
		this.physics.add.existing(rectangle, true);

		this.physics.add.collider(this.obstacles, rectangle, (box) => {
			box.destroy();


		});

		this.physics.add.collider(this.items, rectangle, (box) => {
			box.destroy();
		});


		this.physics.add.collider(this.obstacles);
		this.physics.add.collider(this.items);

		//아이템 생성
		this.time.addEvent({
			delay: Phaser.Math.Between(1000, 4000),
			callback: () => {
				const weightedItems = ["item1", "item1", "item2", "item2", "item3", "item4", "item4"]; // item4 추가
				const selectedItem = Phaser.Utils.Array.GetRandom(weightedItems);

				this.items.create(
					Phaser.Math.Between(-50, 900),
					-50,
					selectedItem
				)
					.setScale(0.2)
					.setSize(300, 300)
					.setOrigin(0, 0)
					.setGravityY(300)
					.setVelocityY(Phaser.Math.Between(100, 300))
					.setCollideWorldBounds(false);
			},
			loop: true
		});



		this.obstacleTimer = this.time.addEvent({
			delay: this.getObstacleDelay(), // 난이도에 따라 결정
			callback: () => {
				const stoneTypes = ["stone", "stone2", "stone3"];
				const selectedStone = Phaser.Utils.Array.GetRandom(stoneTypes);

				const speed = this.getObstacleSpeed(); // 난이도에 따라 속도 결정

				if (selectedStone == "stone3") {
					this.obstacles.create(
						Phaser.Math.Between(-50, 900),
						-50,
						selectedStone
					)
						.setScale(0.2)
						.setSize(200, 200)
						.setOrigin(0, 0)
						.setGravityY(350)
						.setVelocityY(speed)
						.setCollideWorldBounds(false);
				} else {
					this.obstacles.create(
						Phaser.Math.Between(-50, 900),
						-50,
						selectedStone
					)
						.setScale(0.2)
						.setSize(300, 300)
						.setOrigin(0, 0)
						.setGravityY(350)
						.setVelocityY(speed)
						.setCollideWorldBounds(false);

				}

			},
			loop: true
		});

		// this.physics.add.overlap //뚫고 지나가기 설정
		// this.physics.add.collider 충돌설정
		this.physics.add.overlap([this.player], this.obstacles, (player, obstacle) => {

			if (this.heart > 1) {
				//하트 감소

				this.heart -= 1;
				obstacle.destroy();
			} else {//게임오버
				this.scene.stop("MainGame");
				this.scene.start("Gameover", { point: this.point, score: this.score, ending: "lose", startTime: this.startTimeStamp, endTime: Date.now() });
				this.unlockAchievement("SPACE_BATTLE_FIRST_DEAD");
			}


		});

		this.lazors = this.physics.add.group(); // 레이저 그룹 생성

		this.zKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.Z); // Z 키 등록



		this.physics.add.overlap([this.player], this.items, (player, item) => {
			
			if (item.texture.key === 'item1') {
				this.lazorCount += 1;
				this.score + 500;

				const lazorText = this.add.text(20, 120, '레이저 획득!', { fontSize: '24px', fill: '#00ff00' });

				this.time.addEvent({
					delay: 3000, // 3초 후 텍스트 제거
					callback: () => {
						lazorText.destroy();
					}
				});

			} else if (item.texture.key === 'item2') {
				
				const speedText = this.add.text(20, 150, '포인트 획득!', {
													fontSize: '24px',
													fill: '#B1D8FF'
												});

												this.time.addEvent({
													delay: 3000, // 3초 후 텍스트 제거
													callback: () => {
														speedText.destroy();
													}
												});

				this.point += this.getItemPoint();
				this.score += 500;

			} else if (item.texture.key === 'item3') {
				
				const speedText = this.add.text(20, 180, '체력 증가!', {
									fontSize: '24px',
									fill: '#FFB4B4'
								});

								this.time.addEvent({
									delay: 3000, // 3초 후 텍스트 제거
									callback: () => {
										speedText.destroy();
									}
								});

				this.heart += 1;
				this.score + 500;
				
				
			} else if (item.texture.key === 'item4') {

				this.score + 500;
				
				this.speedCount +=1;
				
				if(this.speedCount === 10 ){
					this.unlockAchievement("SPACE_BATTLE_SPEED_SHOOTER");
				}

				const speedText = this.add.text(20, 220, '속도 증가!', {
					fontSize: '24px',
					fill: '#ff9900'
				});

				this.time.addEvent({
					delay: 3000, // 3초 후 텍스트 제거
					callback: () => {
						speedText.destroy();
					}
				});

				this.speed += 200; // 속도 증가

				this.player.setTint(0xff9900); // 오렌지빛 효과

				this.time.addEvent({
					delay: 3000,
					callback: () => {
						this.speed -= 200;

						this.player.clearTint(); // 원래 색상 복귀
					}
				});

			}



			item.destroy();

		});

		//레이저와 장애물이 부딪히면 장애물 파괴
		this.physics.add.overlap(this.lazors, this.obstacles, (lazor, obstacle) => {

			obstacle.destroy();  // 장애물 제거
			this.score += 1000; //장애물 제거시 점수 증가 (1000점)
			this.attackCount++;

					if (this.attackCount === 1) {
						this.unlockAchievement("SPACE_BATTLE_FIRST_KILL");
					}

					if (this.attackCount === 10) {
						this.unlockAchievement("SPACE_BATTLE_10_ATTACKS");
					}

		});




		this.heartText = this.add.text(this.cameras.main.width - 150, 20, `❤️ x ${this.heart}`, {
			fontSize: '32px',
			fill: '#ff0000',
			fontFamily: 'Arial'
		});

		this.lazorText = this.add.text(this.cameras.main.width - 150, 60, `🔫 x ${this.lazorCount}`, {
			fontSize: '28px',
			fill: '#0000ff',
			fontFamily: 'Arial'
		});

		this.pointText = this.add.text(this.cameras.main.width - 150, 100, `💎 ${this.point}`, {
			fontSize: '28px',
			fill: '#008800',
			fontFamily: 'Arial'
		});

		this.levelText = this.add.text(20, 20, `Level: ${this.difficultyLevel}`, {
			fontSize: '32px',
			fill: '#ffffff'
		});

		this.scoreText = this.add.text(20, 50, `Score: ${this.score}`, {
			fontSize: '32px',
			fill: '#ffffff'
		});
		
		this.currentTimeText = this.add.text(20, 80, `현재시간: `, {
					fontSize: '32px',
					fill: '#ffffff'
				});

		this.time.addEvent({
			delay: 3000, // 3초마다
			callback: () => {
				this.point += 1;

			},
			loop: true
		});

		this.time.addEvent({
			delay: 100,
			callback: () => {
				this.score += 100;
			},
			loop: true
		});


	}

	update(time) {
		if (this.startTime === null) {
		        this.startTime = time; // 최초 프레임에서 저장
		    }

		    const elapsed = time - this.startTime;
		    const formatted = this.formatTime(elapsed);
		    this.currentTimeText.setText(`현재시간 ${formatted}`);
	

		this.tileSprite.tilePositionY -= 4;

		this.player.setVelocity(0);

		if (this.cursor.left.isDown) {
			this.player.setVelocityX(-this.speed);


		}
		if (this.cursor.right.isDown) {
			this.player.setVelocityX(this.speed);

		}
		if (this.cursor.up.isDown) {
			this.player.setVelocityY(-this.speed);

		}
		if (this.cursor.down.isDown) {
			this.player.setVelocityY(this.speed);

		}

		this.lazors.children.iterate((lazor) => {
			lazor.x = this.player.x;
			lazor.y = this.player.y - 300;
			lazor.flipX = this.player.flipX;
		});


		if (Phaser.Input.Keyboard.JustDown(this.zKey) && this.lazorCount > 0) {
			const lazor = this.lazors.create(this.player.x, this.player.y - 300, 'lazor').setSize(100);
			lazor.play('attack');

			lazor.on('animationcomplete', () => {
				lazor.destroy(); // 개별 lazor 제거
			});

			this.lazorCount -= 1;
		}



		this.heartText.setText(`❤️ x ${this.heart}`);
		this.lazorText.setText(`🔫 x ${this.lazorCount}`);
		this.pointText.setText(`💎   ${this.point}`);
		this.scoreText.setText(`Score: ${this.score}`);
		this.levelText.setText(`Level: ${this.difficultyLevel}`);
		
		
		if(this.lazorCount ===10){
			this.unlockAchievement("SPCAE_BATTLE_MANY_RAZOR");
		}
		
		if(this.heart === 10 ){
			this.unlockAchievement("SPACE_BATTLE_EMERGENCY_KIT");
		}
		

		if (this.boss && this.boss.active) {

			this.bossHpText.setText(`보스 체력: ${this.boss.hp}`);

			this.lazors.children.iterate((lazor) => {

				if (Phaser.Geom.Intersects.RectangleToRectangle(lazor.getBounds(), this.boss.getBounds())) {
					if (this.time.now - this.boss.lastHitTime > 2000) {
						this.boss.lastHitTime = this.time.now;
						this.boss.hp -= 1;

						// 시각적 피드백
						this.boss.setTint(0xff0000);
						this.time.addEvent({
							delay: 200,
							callback: () => this.boss.clearTint()
						});
						
						//보스의 체력이 0이 되었을 경우
						if (this.boss.hp <= 0) {
							this.boss.destroy();
							this.score += 5000;
							
							this.unlockAchievement("SPACE_BATTLE_WIN");
							this.scene.stop("MainGame");
							this.scene.start("Gameover", { point: this.point, score: this.score, ending: "win", startTime: this.startTimeStamp, endTime: Date.now() });

						
						}
					}
				}
			});


		}
		

	}

	getObstacleDelay() {
		switch (this.difficultyLevel) {
			case 1: return Phaser.Math.Between(500, 700);
			case 2: return Phaser.Math.Between(300, 700);
			case 3: return Phaser.Math.Between(300, 700);
			case 4: return Phaser.Math.Between(200, 400);
			case 5: return Phaser.Math.Between(200, 400);
			default: return Phaser.Math.Between(500, 1000);
		}
	}

	getObstacleSpeed() {
		switch (this.difficultyLevel) {
			case 1: return 250;
			case 2: return 350;
			case 3: return 550;
			case 4: return 600;
			case 5: return 700;
			default: return 200;
		}
	}



	getItemPoint() {
		switch (this.difficultyLevel) {
			case 1: return Phaser.Math.Between(5, 15);
			case 2: return Phaser.Math.Between(10, 20);
			case 3: return Phaser.Math.Between(15, 25);
			case 4: return Phaser.Math.Between(20, 30);
			default: return Phaser.Math.Between(5, 10);
		}
	}

	spawnBoss() {
		//보스 등장
		this.boss = this.physics.add.sprite(this.cameras.main.width / 2, -150, "bossJet")
			.setScale(1).setVelocityY(50);
			
			this.time.delayedCall(5000, () => {
			    if (this.boss.active) {
			        this.boss.setVelocityY(0); // 속도 0으로 설정해서 멈춤
			    }
			});



		this.unlockAchievement("SPACE_BATTLE_BOSS_SPAWN");


		this.bossBullets = this.physics.add.group();

		this.time.addEvent({
		    delay: 1500,
		    loop: true,
		    callback: () => {
		        if (!this.boss.active) return;

		        const pattern = Phaser.Math.Between(1, 3); // 1~3 중 랜덤 선택

		        switch (pattern) {
		            case 1:
		                // 패턴 1: 직선 3방향
		                const directions1 = [
		                    { x: 0, y: 300 },
		                    { x: -150, y: 300 },
		                    { x: 150, y: 300 }
		                ];
		                directions1.forEach(dir => {
		                    const bullet = this.bossBullets.create(this.boss.x, this.boss.y + 50, "bossBullet");
		                    bullet.setScale(0.2)
		                        .setSize(300, 300)
		                        .setOrigin(0.5, 0.5)
		                        .setGravityY(0)
		                        .setVelocity(dir.x, dir.y)
		                        .setCollideWorldBounds(false);
		                });
		                break;

						case 2:
						    for (let i = 0; i < 3; i++) {
						        this.time.delayedCall(i * 200, () => { // 200ms 간격으로 3번 발사
						            const angleToPlayer = Phaser.Math.Angle.Between(this.boss.x, this.boss.y, this.player.x, this.player.y);
						            const speed = 500;
						            const vx = Math.cos(angleToPlayer) * speed;
						            const vy = Math.sin(angleToPlayer) * speed;

						            const bullet2 = this.bossBullets.create(this.boss.x, this.boss.y + 50, "bossBullet");
						            bullet2.setScale(0.2)
						                .setSize(300, 300)
						                .setOrigin(0.5, 0.5)
						                .setGravityY(0)
						                .setVelocity(vx, vy)
						                .setCollideWorldBounds(false);
						        });
						    }
						    break;

		            case 3:
		                // 패턴 3: 원형 회전 탄막
		                const bulletCount = 8;
		                for (let i = 0; i < bulletCount; i++) {
		                    const angle = Phaser.Math.DegToRad((360 / bulletCount) * i);
		                    const vx = Math.cos(angle) * 200;
		                    const vy = Math.sin(angle) * 200;

		                    const bullet3 = this.bossBullets.create(this.boss.x, this.boss.y + 50, "bossBullet");
		                    bullet3.setScale(0.2)
		                        .setSize(300, 300)
		                        .setOrigin(0.5, 0.5)
		                        .setGravityY(0)
		                        .setVelocity(vx, vy)
		                        .setCollideWorldBounds(false);
		                }
		                break;
		        }
		    }
		});


		// 보스와 플레이어 충돌
		this.physics.add.overlap(this.player, this.bossBullets, (player, bullet) => {
			bullet.destroy();
			this.heart -= 1;
			if (this.heart <= 0) {

				this.scene.stop("MainGame");
				this.scene.start("Gameover", { point: this.point, score: this.score, ending: "lose", startTime: this.startTimeStamp, endTime: Date.now() });
			}
		});

		this.boss.hp = 10;
		this.boss.lastHitTime = 0;

		this.bossHpText = this.add.text(this.boss.x, 50, `보스 체력: ${this.boss.hp}`, {
			fontSize: '32px',
			fill: '#b15151ff'
		}).setOrigin(0.5, 0.5);

	}

	unlockAchievement(achievementId) {
		
		if(loginId==="") return;

		console.log(this.unlockedAchievements);

		if (this.unlockedAchievements.has(achievementId)) return;

		this.unlockedAchievements.add(achievementId);

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

				console.log("🎉 업적 달성: " + resp.title + "업적 설명:" + resp.description)
				showAchievementPopup("🎉 업적 달성: " + resp.title, resp.description);
			}
		}).fail((err) => {
		    console.error("업적 서버 오류:", err);
		});

	}
	
	formatTime(ms) {
	    const totalSeconds = Math.floor(ms / 1000);
	    const minutes = Math.floor(totalSeconds / 60);
	    const seconds = totalSeconds % 60;

	    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
	}




}