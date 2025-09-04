class MainScene extends Phaser.Scene {
    constructor() {
        super({ key: 'MainScene' });
    }

    init(data) {
        this.startTimeStamp = Date.now();
        this.startTime = null;
		this.endTime = null;
		
        // 상태 정보 초기화
        this.score = 0;    // 점수
        this.points = 0;   // 포인트
        this.lives = 3;    // 목숨
        this.invincible = false; // 무적 여부
        this.isDead = false;     // 사망 여부
        this.isHurt = false;     // 데미지 여부
        this.scoreIncrement = 20;  // 초기 점수 증가폭
        this.elapsedTime = 0;       // 경과 시간 (ms)
        
        // 속도 관련 변수
        this.scrollSpeed = 3;
        this.speed = 200;
    }


    preload() {
        
        this.load.image('background', IMG_PATH +'assets/image/unrealbackground.png');
        this.load.image('platform', IMG_PATH +'assets/image/unrealplatform.png');
        this.load.image('platformTrap', IMG_PATH +'assets/image/unrealplatform_trap.png');
        this.load.image('heart', IMG_PATH +'assets/image/heart.png');
        this.load.image('diamond', IMG_PATH +'assets/image/diamond.png');
        this.load.image('emerald', IMG_PATH +'assets/image/emerald.png');
        this.load.image('potion', IMG_PATH +'assets/image/potion.png');
        this.load.spritesheet("runSheet",IMG_PATH +"assets/image/Run.png", { frameWidth: 128, frameHeight: 128 });
        this.load.spritesheet("jumpSheet", IMG_PATH +"assets/image/Jump.png", { frameWidth: 128, frameHeight: 128 });
        this.load.spritesheet("hurtSheet", IMG_PATH +"assets/image/Hurt.png", { frameWidth: 128, frameHeight: 128 });
        this.load.spritesheet("deadSheet", IMG_PATH +"assets/image/Dead.png", { frameWidth: 128, frameHeight: 128 });
    }

    create() {
        //카메라 scene 전환
        this.cameras.main.setBackgroundColor("#ffffff");
        //bound로 필드 삭제하기

        this.boundX = this.add.rectangle(-200, this.cameras.main.height / 2, 100,
            this.cameras.main.height * 2, 0xff0000);
        this.physics.add.existing(this.boundX, true); // 정적 바디로 설정
        this.boundY = this.add.rectangle(this.cameras.main.width / 2, this.cameras.main.height + 300,
            this.cameras.main.width * 2, 100, 0xff0000);
        this.physics.add.existing(this.boundY, true);
        //방향키 구현
        this.cursors = this.input.keyboard.createCursorKeys();

        //애니메이션 run
        if (!this.anims.exists("run")) {
            this.anims.create({
                key: "run",
                frames: this.anims.generateFrameNumbers("runSheet", { start: 0, end: 7 }),
                frameRate: 10,
                repeat: -1
            });
        }
        //애니메이션 jump
        if (!this.anims.exists("jump")) {
            this.anims.create({
                key: "jump",
                frames: this.anims.generateFrameNumbers("jumpSheet", { start: 0, end: 9 }),
                frameRate: 5,
                repeat: -1
            });
        }
        //애니메이션 hurt
        if (!this.anims.exists("hurt")) {
            this.anims.create({
                key: "hurt",
                frames: this.anims.generateFrameNumbers("hurtSheet", { start: 0, end: 2 }),
                frameRate: 5,
                repeat: 0
            });
        }
        //애니메이션 dead
        if (!this.anims.exists("dead")) {
            this.anims.create({
                key: "dead",
                frames: this.anims.generateFrameNumbers("deadSheet", { start: 0, end: 2 }),
                frameRate: 5,
                repeat: 0
            });
        }
       
        // 배경 (tileSprite 활용 → 스크롤 효과)
        this.tileSprite = this.add.tileSprite(0, 0, 1080, 960, 'background');
        this.tileSprite.setOrigin(0, 0);

        // 플레이어 FIXED
        this.me = this.physics.add.sprite(200, 200, 'runSheet');
        this.me.setOrigin(0.5, 0.5);
        this.me.setBounce(0.1);
        this.me.setCollideWorldBounds(false);
        this.me.setScale(2, 2);
        this.me.setSize(60, 80);
        this.me.setOffset(30, 50);
        this.me.setMass(2);
        this.me.setDrag(50);
        this.me.setData("jumpCount", 2);

      


        // 초기 무지 발판 생성 FIXED 
        let platform = this.physics.add.sprite(0, 600, "platform");
        platform.setScale(0.6, 0.3);
        platform.setImmovable(true);
        platform.setOrigin(0.1, 0.5);
        platform.setSize(800, 300);
        platform.body.allowGravity = false;

        //초기발판 삭제하기
        this.time.delayedCall(5000, () => {
            platform.destroy();
        });
        //발판 그룹 만들기
        this.platforms = this.physics.add.group();
        //발판 주기적 생성 타이머
        this.time.addEvent({
            delay: 2000, // 2초마다 생성
            callback: this.createPlatform,
            callbackScope: this,
            loop: true
        });
        // 충돌 처리 무지발판 
        this.physics.add.collider(this.me, platform);
        this.physics.add.collider(this.me, this.platform);
        //충돌처리 카메라 X축 뒤로 Y축밖으로 나가면 Gameover만들어버림
        this.physics.add.collider(this.me, this.platforms, (me, platform) => {
            if (platform.texture.key === "platformTrap") {
                this.hitTrap();
            }
        });
        this.physics.add.collider(this.me, this.boundX, (me, boundX) => {
            this.scene.start("Gameover", { score: this.score, startTime : this.startTimeStamp,endTime :this.endTime = Date.now(),points : this.points });
			
        });
        this.physics.add.collider(this.me, this.boundY, (me, boundY) => {
			
            this.scene.start("Gameover", { score: this.score, startTime : this.startTimeStamp,endTime :this.endTime = Date.now(),points : this.points });
			
        });
        this.me.play("run");
        this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
        //아이템 그룹
        this.items = this.physics.add.group();
        //아이템 충돌처리
        this.physics.add.overlap(this.me, this.items, this.collectItem, null, this);
       

        // 하트 UI 그룹
        this.hearts = this.add.group();
        for (let i = 0; i < this.lives; i++) {
            let heart = this.add.image(50 + i * 50, 50, "heart").setScrollFactor(0);
            heart.setScale(0.1);
            this.hearts.add(heart);
        }
        this.scoreText = this.add.text(50, 100, "점수: 0", { fontSize: "20px", fill: "#fff" }).setScrollFactor(0);
        this.pointsText = this.add.text(50, 130, "포인트: 0", { fontSize: "20px", fill: "#0f0" }).setScrollFactor(0);

        //생존 시간 점수
        this.time.addEvent({
            delay: 100, // 1초마다
            callback: () => {
                if (!this.isDead) {   // 죽으면 점수 증가 중지
                    this.score += this.scoreIncrement;
                    this.scoreText.setText("점수: " + this.score);

                    this.elapsedTime += 100;
                    if (this.elapsedTime % 10000 === 0) { 
                    this.scoreIncrement += 15;
            }

                }

            },
            loop: true
        });
       


        //아이템 먹기 처리
        this.physics.add.overlap(this.me, this.items, (player, item) => {
            if (item.texture.key === "potion") {
                if (this.lives < 3) {
                    this.lives++;
                    this.updateHearts();
                }
            } else if (item.texture.key === "diamond") {
                this.score += 10;
                this.scoreText.setText("점수: " + this.score);
            } else if (item.texture.key === "emerald") {
                this.points += 10;
                this.pointsText.setText("포인트: " + this.points);
            }
            item.destroy();
        });



    }
  

    createPlatform() { // 자동 플랫폼 생성
        let isTrap = Math.random() < 0.3; // 30% 확률

        let key = isTrap ? "platformTrap" : "platform";
        let platform = this.platforms.create(900, Phaser.Math.Between(300, 500), key);
        platform.setVelocityX(-200); // 왼쪽으로 이동
        platform.setImmovable(true);
        platform.body.allowGravity = false;
        let scaleX = Phaser.Math.FloatBetween(0.2, 0.5);
        //랜덤크기
        platform.setScale(scaleX, 0.2);
        platform.setOrigin(0.5, 0.5);
        platform.setSize(800, 300);
        platform.setMass(10);


        //함정 여부 저장
        platform.setData("isTrap", isTrap);

        if (Math.random() < 0.3) {
            this.spawnItem(platform.x, platform.y - 80);
        }

        this.physics.add.collider(this.me, platform, (player, plat) => {
            if (plat.getData("isTrap")) {
                this.hitTrap();
            }
        });

    }
    // 아이템 생성
    spawnItem(x, y) {
        // 아이템 종류 선택
        let itemTypes = ["potion", "diamond", "emerald"];
        let itemType = Phaser.Utils.Array.GetRandom(itemTypes);

        let item = this.items.create(x, y, itemType);
        item.setScale(0.5, 0.5);
        item.setVelocityX(-200);
        item.setImmovable(true);
        item.body.allowGravity = false;

        // 살짝 위아래로 움직이게 하기 (tween)
        this.tweens.add({
            targets: item,
            y: y - 10,
            duration: 800,
            yoyo: true,
            repeat: -1
        });

        item.setData("type", itemType); // 종류 저장
    }

    collectItem(player, item) {
        let type = item.getData("type");

        if (type === "potion") {
            if (this.lives < 3) {
                this.lives++;
                this.updateHearts();
            }
        } else if (type === "diamond") {
            this.score += 10; // 점수 증가
            this.scoreText.setText("점수: " + this.score);
        } else if (type === "emerald") {
            this.points += 5; // 포인트 증가
            this.pointsText.setText("포인트: " + this.points);
        }

        item.destroy(); // 아이템 삭제
    }
    hitTrap() {
        if (this.invincible) return; // 무적이면 무시

        this.lives -= 1;
        this.updateHearts();

        // hurt 모션 (직접 애니메이션 추가해둔 걸 실행하면 됨)

        this.me.play("hurt", true);

        // 무적 시작
        this.isHurt = true;
        this.invincible = true;
        this.me.setTint(0xff0000); // 빨갛게 표시 (옵션)

        this.time.delayedCall(1500, () => { // 1.5초 무적
            this.isHurt = false;
            this.invincible = false;
            this.me.clearTint();

        });
        if (this.lives === 0) {

            this.me.play("dead", true);
            this.isDead = true;
            this.invincible = true;
            this.me.setVelocity(0, 0); // 움직임 멈춤
            this.me.setCollideWorldBounds(false); // 혹시 튕기지 않게

            this.time.delayedCall(1500, () => {
                this.scene.start("Gameover", { score: this.score, startTime : this.startTimeStamp,endTime :this.endTime = Date.now(),points : this.points });
            });
            return;
        }

        // 목숨이 0이면 게임오버

    }
    updateHearts() {
        this.hearts.clear(true, true); // 기존 하트 삭제
        for (let i = 0; i < this.lives; i++) {
            let heart = this.add.image(50 + i * 50, 50, "heart").setScrollFactor(0);
            heart.setScale(0.1);
            this.hearts.add(heart);
        }
    }


    update() {


        // 플레이어 이동
        if (this.cursors.left.isDown) {
            this.me.setVelocityX(-this.speed);
        }
        else if (this.cursors.right.isDown) {
            this.me.setVelocityX(this.speed);
        } else {
            this.me.setVelocityX(0);
        }

        // 배경 왼쪽으로 스크롤
        this.tileSprite.tilePositionX += this.scrollSpeed;
        //점프 구현 + 더블점프
        if (this.me.body.touching.down) {
            this.me.setData("jumpCount", 2);
        }
        if (Phaser.Input.Keyboard.JustDown(this.spaceKey)

            && this.me.getData("jumpCount") > 0) {

            this.me.setVelocityY(-400);
            this.me.setData("jumpCount", this.me.getData("jumpCount") - 1);
        }


        // 모션 변경
        if (!this.isHurt && !this.isDead) { // hurt 또는 dead 중이면 run/jump로 덮어쓰지 않음
            if (!this.me.body.touching.down) {
                this.me.play("jump", true);
            } else {
                this.me.play("run", true);
            }
        }





    }




}