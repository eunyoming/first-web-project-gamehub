class GameOver extends Phaser.Scene {
  constructor() {
    super({ key: 'GameOver' });
  }

  create(data) {
    // MainScene는 그대로 살아있고(paused), GameOverScene이 오버레이로 뜸.
    const main = this.scene.get('MainGame');

    const { width, height } = this.scale;
    const cx = data?.anchorX ?? width / 2;
    const cy = data?.anchorY ?? height / 2;
    const sx = data?.scaleX ?? 0.5;
    const sy = data?.scaleY ?? 0.5;

    // 반투명 배경(클릭 막기)
    const shade = this.add.rectangle(0, 0, width, height, 0x000000, 0.45)
      .setOrigin(0, 0)
      .setInteractive(); // 클릭 이벤트 흡수

    // 게임오버 이미지
    const go = this.add.image(cx, cy, 'gameover')
      .setOrigin(0.5)
      .setScale(sx, sy)
      .setDepth(10)
      .setInteractive();

    // SCORE 보드 & 텍스트 (메인 코드와 동일한 자간/크기)
    const below = go.y + go.displayHeight * 0.1;
    const uiDepth = go.depth + 1;

    const scoreImg = this.add.image(go.x, below + 130, 'score')
      .setOrigin(0.5)
      .setScale(0.8)
      .setDepth(uiDepth);

    const scoreTxt = this.add.text(go.x, below + 127, String(data?.score ?? 0), {
      fontSize: "32px",
      fontFamily: "Fantasy",
      fill: "white",
    }).setOrigin(0.5).setDepth(uiDepth);

    // 재시작 안내
    const hint = this.add.text(go.x, scoreTxt.y + 70, '화면을 터치/클릭하면 재시작', {
      fontSize: '18px',
      fontFamily: 'Fantasy',
      color: '#ffffff',
      stroke: '#000000',
      strokeThickness: 3,
    }).setOrigin(0.5).setDepth(uiDepth);

    // 어느 곳을 클릭해도 재시작
    this.input.once('pointerdown', () => this._restart());
  }

  _restart() {
    // 오버레이 닫고 MainScene 재시작(이전 restartGame과 동일한 효과)
    this.scene.stop();               // GameOverScene 닫기
    const main = this.scene.get('MainGame');
    main.scene.restart();            // MainScene을 생성부터 다시
  }
}
window.GameOver = GameOver;