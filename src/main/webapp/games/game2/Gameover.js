class Gameover extends Phaser.Scene{ 
    constructor(){
        super({key: "Gameover"})
    }

     init(data) {
    this.finalPoint = data.point; // 전달받은 점수 저장
    this.finalScore =data.score;
    this.ending = data.ending;
    this.startTime = data.startTime;
    this.endTime = data.endTime;
    }


    preload(){

    }

    create(){

         this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2-70,
                `게임 시작: ${this.formatTimestamp(this.startTime)}  게임 종료: ${this.formatTimestamp(this.endTime)}`,{
                fontSize:"15px",
                fill:"#ffffffff"
            }
        ).setOrigin(0.5,0.5);


        if(this.ending == "lose"){
            this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2-40,
                'You Lose...',{
                fontSize:"30px",
                fill:"#ff0000"
            }
        ).setOrigin(0.5, 0.5);

        }else if(this.ending =="win"){

 this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2-40,
                'You WIN!!',{
                fontSize:"30px",
                fill:"#2151fcff"
            }
        ).setOrigin(0.5, 0.5);

        }

        // 정 중앙에 텍스트 추가
        this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2-10,
            `Your Score: ${this.finalScore}`,{
                fontSize:"30px",
                fill:"#ff0000"
            }
        ).setOrigin(0.5, 0.5);

        this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2+40,
            `Your Point: ${this.finalPoint}\n`,{
                fontSize:"30px",
                fill:"#ff0000"
            }
        ).setOrigin(0.5, 0.5);

         let restartButton = this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2 + 80 ,
            "Retry?",{
                padding:{
                    left:30, right:30, top:15,bottom:15
                },
                fontSize:"20px",
             
            }
        ).setOrigin(0.5)
        .setInteractive();

         let titleButton = this.add.text(
            this.cameras.main.width/2, 
            this.cameras.main.height/2 + 120 ,
            "Go to title",{
                padding:{
                    left:30, right:30, top:15,bottom:15
                },
                fontSize:"20px",
             
            }
        ).setOrigin(0.5)
        .setInteractive();

        //마우스 올렸을 때
        restartButton.on("pointerover",()=>{
            restartButton.setBackgroundColor("#835555ff");
            this.game.canvas.style.cursor = 'pointer';
        })

        //마우스 나왔을 때
        restartButton.on("pointerout",()=>{
            restartButton.setBackgroundColor("#0000000");
            this.game.canvas.style.cursor = 'default';
        })

        //
         restartButton.on("pointerdown",()=>{
           
           this.scene.start("MainGame");
        })


        //마우스 올렸을 때
        titleButton.on("pointerover",()=>{
            titleButton.setBackgroundColor("#835555ff");
            this.game.canvas.style.cursor = 'pointer';
        })

        //마우스 나왔을 때
        titleButton.on("pointerout",()=>{
            titleButton.setBackgroundColor("#0000000");
            this.game.canvas.style.cursor = 'default';
        })

        //마우스 클릭했을 때

        titleButton.on("pointerdown",()=>{
           
           this.scene.start("Intro");
        })
    }

    update(){

    }

    formatKoreanDate(timestamp) {
        const date = new Date(timestamp);
        return `${date.getFullYear()}년 ${date.getMonth() + 1}월 ${date.getDate()}일 ${date.getHours()}시 ${date.getMinutes()}분 `;
    }

    formatTimestamp(timestamp) {
    const date = new Date(timestamp);

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");

    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");
    const seconds = String(date.getSeconds()).padStart(2, "0");

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}





}