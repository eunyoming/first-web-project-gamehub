class GameOver extends Phaser.Scene {
  constructor() {
    super({ key: "GameOver" });
  }

  init(data) {
    this.finalScore = Number(data?.score || 0);   // 100점 단위
    this.finalPoint = Number(data?.points || 0);  // 이번 판 누적 포인트(미션 등)
    this.startTime  = Number(data?.startTime || Date.now());
    this.endTime    = Number(data?.endTime   || Date.now());
    this.runId      = data?.runId || "";         // 판 식별자

    this.anchorX = data?.anchorX ?? this.scale.width / 2;
    this.anchorY = data?.anchorY ?? this.scale.height / 2;
    this.sx = data?.scaleX ?? 0.5;
    this.sy = data?.scaleY ?? 0.5;
  }

  preload() { /* 리소스는 MainGame에서 로드됨 */ }

  create() {
    const gameSeq = parseInt(new URLSearchParams(window.location.search).get("game_seq")) || null;

    // (1) 게임 기록 저장
    const payloadRecord = {
      userId: loginId,
      game_seq: gameSeq,
      gameScore: this.finalScore,
      gameStartTime: this.startTime,
      gameEndTime: this.endTime,
      runId: this.runId,
    };
    $.ajax({
      url: "/api/game/recordInsert",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify(payloadRecord)
    }).done((resp) => {
      console.log("[recordInsert] OK:", resp);
    }).fail((err) => {
      console.error("[recordInsert] FAIL:", err);
    });

    // (2) 포인트 적립 — 폼 전송
    $.ajax({
      url: "/api/point/gameOver",
      type: "POST",
      data: {
        seq: 6,
        pointValue: this.finalPoint
      }
    }).done((resp) => {
      console.log("[point/gameOver] OK(FORM):", resp);
    }).fail((xhr) => {
      console.error("[point/gameOver] FAIL(FORM):", xhr.status, xhr.responseText);
    });

    // === UI ===
    const { width, height } = this.scale;
    this.add.rectangle(0, 0, width, height, 0x000000, 0.45)
      .setOrigin(0, 0).setInteractive();

    const cx = this.anchorX, cy = this.anchorY;

    // 게임오버 이미지
    const go = this.add.image(cx, cy, 'gameover')
      .setOrigin(0.5)
      .setScale(this.sx, this.sy)
      .setDepth(10)
      .setInteractive();

    const below = go.y + go.displayHeight * 0.1;
    const uiDepth = go.depth + 1;

    const scoreImg = this.add.image(go.x, below + 130, 'score')
      .setOrigin(0.5)
      .setScale(0.8)
      .setDepth(uiDepth);

    this.add.text(go.x, below + 127, String(this.finalScore), {
      fontSize: "32px",
      fontFamily: "Fantasy",
      fill: "white",
      stroke: "#000000",
      strokeThickness: 4
    }).setOrigin(0.5).setDepth(uiDepth);

    this.input.once('pointerdown', () => this._restart());
	
	// ✅ 안전장치: 화면에 이미 만들어진 "획득한 POINT" 텍스트가 있으면 전부 제거
	this.children.getAll().forEach(o => {
	  if (o && o.type === 'Text' && typeof o.text === 'string' && o.text.includes('획득한 POINT')) {
	    o.destroy();
	  }
	});
  }

  _restart() {
    this.scene.stop();                // GameOver 닫기
    const main = this.scene.get('MainGame');
    main.scene.restart();             // MainGame 재시작
  }

  formatTimestamp(ts) {
    const d = new Date(Number(ts));
    const yy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mi = String(d.getMinutes()).padStart(2, "0");
    const ss = String(d.getSeconds()).padStart(2, "0");
    return `${yy}-${mm}-${dd} ${hh}:${mi}:${ss}`;
  }
}
window.GameOver = GameOver;
