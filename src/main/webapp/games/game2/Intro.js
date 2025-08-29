class Intro extends Phaser.Scene{ 
    constructor(){
        super({key: "Intro"})
    }




    preload() {
    this.load.image("startPage", IMG_PATH+"assets/image/startPage.png"); // 경로는 실제 이미지 위치에 맞게 수정
        }


   create() {
    // 📷 배경 이미지 추가 (preload에서 먼저 로드해야 함)
    this.add.image(
        this.cameras.main.width / 2,
        this.cameras.main.height / 2,
        "startPage"
    ).setOrigin(0.5, 0.5)
     .setDisplaySize(this.cameras.main.width, this.cameras.main.height); // 화면 크기에 맞게 조정

    // 👤 접속한 아이디 텍스트 (아래쪽에 작게 표시)
    this.add.text(
        this.cameras.main.width / 2,
        this.cameras.main.height - 30,
        loginId===""? "비회원 접속":"접속한 아이디: "+loginId,
        {
            fontSize: "16px",
            fill: "#ffffff"
        }
    ).setOrigin(0.5);

     // 🔲 버튼 위치에 투명한 클릭 영역 추가
    const buttonZone = this.add.zone(400, 810, 240, 60)
        .setOrigin(0.5)
        .setInteractive({ useHandCursor: true });

    // 클릭 이벤트 처리
    buttonZone.on("pointerdown", () => {
        this.scene.start("MainGame");
    });

}

}