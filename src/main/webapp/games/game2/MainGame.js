class MainGame extends Phaser.Scene{
    constructor(){
        super({key:"MainGame"});
        this.obstacles = null;
        this.items = null;
        this.playerHasLaser = false;
        
      
   


    }


      init() {
        this.startTimeStamp = Date.now();
        this.startTime = 0;
        this.difficultyLevel = 1; // 기본 난이도
        this.point = 0;
        this.score = 0;
        this.heart = 2;
        this.lazorCount = 2;
     
        this.bossSpawned = false;


        
    }



    preload(){
    
   this.load.image('player', IMG_PATH+'assets/image/spaceship.png');
   this.load.image("stone", IMG_PATH+"assets/image/stone.png")
    this.load.image("stone2", IMG_PATH+"assets/image/stone2.png")
    this.load.image("stone3", IMG_PATH+"assets/image/stone3.png")
     this.load.image("item1", IMG_PATH+"assets/image/item01.png") //레이저 획득 아이템
    this.load.image("item2",IMG_PATH+"assets/image/item02.png") //점수 획득 아이템
    this.load.image("item3", IMG_PATH+"assets/image/item03.png") //체력 회복 아이템
    this.load.image("item4",IMG_PATH+"assets/image/item04.png"); // 속도 증가 아이템
    this.load.image("bossJet", IMG_PATH+"assets/image/boss.png");
    this.load.image("bossBullet", IMG_PATH+"assets/image/boss_bullet.png");

   this.load.image("background", IMG_PATH+"assets/image/background.png");

    this.load.spritesheet("lazor",IMG_PATH+"assets/image/lazor_vertical.png",{
            frameWidth: 60,
            frameHeight: 482

        } );


    }



    create(){
        this.startTime = this.time.now;
        this.speed = 350;
        this.gameOver = false; 
        this.cameras.main.setBackgroundColor("#ffffff");

        // 난이도 체크 타이머 (매 5초마다 확인)
        this.time.addEvent({
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

                    // 타이머 재설정
                    this.obstacleTimer.remove(false);
                    this.obstacleTimer = this.time.addEvent({
                        delay: this.getObstacleDelay(),
                        callback: () => {
                            const stoneTypes = ["stone", "stone2", "stone3"];
                            const selectedStone = Phaser.Utils.Array.GetRandom(stoneTypes);
                            const speed = this.getObstacleSpeed();

                            this.obstacles.create(
                                Phaser.Math.Between(50, 900),
                                50,
                                selectedStone
                            )
                            .setScale(0.2)
                            .setSize(300, 300)
                            .setOrigin(0, 0)
                            .setGravityY(300)
                            .setVelocityY(speed)
                            .setCollideWorldBounds(false);
                        },
                        loop: true
                    });
                }
            }
        });



        this.tileSprite = this.add.tileSprite(0,0, 900, 900,'background').setOrigin(0,0);

           this.anims.create({
            key: 'attack',
            frames: this.anims.generateFrameNumbers('lazor', { start: 0, end: 7}),
            frameRate:8,
            repeat: 0
            });

          let cameraWidth = this.cameras.main.width;
        let cameraHeight = this.cameras.main.height;


        this.player = this.physics.add.sprite(cameraWidth/2,cameraHeight-100,"player").setScale(0.3 ,0.3);
        
        this.obstacles = this.physics.add.group(); 
         this.items = this.physics.add.group(); 

        this.cursor=  this.input.keyboard.createCursorKeys();
      
        this.player.setCollideWorldBounds(true);

        let rectangle = this.add.rectangle(cameraWidth/2,cameraHeight+60,cameraWidth, 1,0x000000 ); 
        this.physics.add.existing(rectangle,true);

         this.physics.add.collider(this.obstacles, rectangle, (box) =>{
            box.destroy(); 
            
             console.log( this.obstacles.length);
         });

         this.physics.add.collider(this.items, rectangle, (box) =>{
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
                    Phaser.Math.Between(0, 900),
                    0,
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

                if(selectedStone == "stone3"){
                        this.obstacles.create(
                    Phaser.Math.Between(0, 900),
                    0,
                    selectedStone
                )
                .setScale(0.2)
                .setSize(200, 200)
                .setOrigin(0, 0)
                .setGravityY(300)
                .setVelocityY(speed)
                .setCollideWorldBounds(false);
                }else{
                    this.obstacles.create(
                    Phaser.Math.Between(0, 900),
                    0,
                    selectedStone
                )
                .setScale(0.2)
                .setSize(300, 300)
                .setOrigin(0, 0)
                .setGravityY(300)
                .setVelocityY(speed)
                .setCollideWorldBounds(false);

                }

                


            },
            loop: true
        });

        // this.physics.add.overlap //뚫고 지나가기 설정
        // this.physics.add.collider 충돌설정
      this.physics.add.overlap([this.player], this.obstacles, (player, obstacle)=>{
       
            if(this.heart > 1){
                //하트 감소

                this.heart-=1;
                obstacle.destroy();
            }else{//게임오버

            this.scene.start("Gameover",{ point: this.point, score: this.score,ending:"lose", startTime:this.startTimeStamp, endTime:Date.now() });
         
            }
            

        });

          this.lazors = this.physics.add.group(); // 레이저 그룹 생성

           this.zKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.Z); // Z 키 등록



         this.physics.add.overlap([this.player], this.items, (player, item)=>{
           if (item.texture.key === 'item1') {
                this.lazorCount += 1;
                this.score + 100;

                const lazorText = this.add.text(20, 80, '레이저 획득!', { fontSize: '24px', fill: '#00ff00' });

                 this.time.addEvent({
                    delay: 3000, // 3초 후 텍스트 제거
                    callback: () => {
                        lazorText.destroy();
                                        }
                    });
                
            }else if (item.texture.key === 'item2') {

                 this.point += this.getItemPoint();
                  this.score += 300;

            }else if (item.texture.key === 'item3') {

                this.heart += 1;
                this.score + 100;
            } else if (item.texture.key === 'item4') {

                this.score + 100;

                const speedText = this.add.text(20, 120, '속도 증가!', {
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
             this.score += 500; //장애물 제거시 점수 증가 (500점)

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

                this.time.addEvent({
            delay: 3000, // 3초마다
            callback: () => {
                this.point += 1;
             
            },
            loop: true
            });

              this.time.addEvent({
            delay: 100, // 1초마다
            callback: () => {
                 this.score += 10;
            },
            loop: true
            });


    }

    update(time){


        this.tileSprite.tilePositionY -= 4;

           this.player.setVelocity(0);

          if(this.cursor.left.isDown){
         this.player.setVelocityX(-this.speed);


        }
        if(this.cursor.right.isDown){
             this.player.setVelocityX(this.speed);

        }
         if(this.cursor.up.isDown){
            this.player.setVelocityY(-this.speed);

        }
        if(this.cursor.down.isDown){
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

                        if (this.boss.hp <= 0) {
                            this.boss.destroy();
                            this.score += 5000;

                            this.scene.start("Gameover", { point: this.point, score: this.score,ending:"win", startTime:this.startTimeStamp, endTime:Date.now() });
                        }
                    }
                }
            });
}



    }

    getObstacleDelay() {
    switch (this.difficultyLevel) {
        case 1: return Phaser.Math.Between(500,700);
        case 2: return Phaser.Math.Between(300, 700);
        case 3: return Phaser.Math.Between(300, 700);
        case 4: return Phaser.Math.Between(200, 400);
        case 5: return Phaser.Math.Between(200, 400);
        default: return Phaser.Math.Between(500, 1000);
    }
}

getObstacleSpeed() {
    switch (this.difficultyLevel) {
        case 1: return Phaser.Math.Between(200, 300);
        case 2: return Phaser.Math.Between(400, 500);
        case 3: return Phaser.Math.Between(500, 700);
        case 4: return Phaser.Math.Between(600,800);
        case 5: return Phaser.Math.Between(500, 900);
        default: return Phaser.Math.Between(200, 300);
    }
}



getItemPoint() {
    switch (this.difficultyLevel) {
        case 1: return Phaser.Math.Between(5, 15);
        case 2: return Phaser.Math.Between(10, 20);
        case 3: return Phaser.Math.Between(15, 25);
        case 4: return Phaser.Math.Between(20,30);
        default: return Phaser.Math.Between(5, 10);
    }
}

spawnBoss(){
      //보스 등장
            this.boss = this.physics.add.sprite(this.cameras.main.width / 2, -150, "bossJet")
                        .setScale(1).setVelocityY(50);
                        

                    this.bossBullets = this.physics.add.group();

                    this.time.addEvent({
                        delay: 1500,
                        loop: true,
                        callback: () => {
                            if (!this.boss.active) return;

                            const directions = [
                                { x: 0, y: 300 },     // 아래로
                                { x: -150, y: 300 },  // 왼쪽 아래 대각선
                                { x: 150, y: 300 }    // 오른쪽 아래 대각선
                            ];

                            directions.forEach(dir => {
                                const bullet = this.bossBullets.create(this.boss.x, this.boss.y + 50, "bossBullet");
                                bullet.setScale(0.2)
                                    .setSize(300, 300)
                                    .setOrigin(0.5, 0.5)
                                    .setGravityY(0)
                                    .setVelocity(dir.x, dir.y)
                                    .setCollideWorldBounds(false);
                            });
                        }
                    });


                    // 보스와 플레이어 충돌
                    this.physics.add.overlap(this.player, this.bossBullets, (player, bullet) => {
                        bullet.destroy();
                        this.heart -= 1;
                        if (this.heart <= 0) {
                            this.scene.start("Gameover", { point: this.point, score: this.score,ending:"lose", startTime:this.startTimeStamp, endTime:Date.now() });
                        }
                    });

                    this.boss.hp = 7;
                    this.boss.lastHitTime = 0;

                   this.bossHpText= this.add.text(this.boss.x , 50, `보스 체력: ${this.boss.hp}`, {
                    fontSize: '32px',
                    fill: '#b15151ff'
            }).setOrigin(0.5, 0.5);

}




}