const tetriminos = {
    i: [
        [
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
        ],
        [
            [1, 0, 0, 0],
            [1, 0, 0, 0],
            [1, 0, 0, 0],
            [1, 0, 0, 0],
        ],
    ],
    j: [
        [
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 0],
        ],
        [
            [1, 1, 0],
            [1, 0, 0],
            [1, 0, 0],
        ],
        [
            [1, 1, 1],
            [0, 0, 1],
            [0, 0, 0],
        ],
        [
            [0, 1, 0],
            [0, 1, 0],
            [1, 1, 0],
        ],
    ],
    l: [
        [
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0],
        ],
        [
            [1, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
        ],
        [
            [1, 1, 1],
            [1, 0, 0],
            [0, 0, 0],
        ],
        [
            [1, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
        ],
    ],
    o: [
        [
            [1, 1],
            [1, 1]
        ],
        [
            [1, 1],
            [1, 1]
        ],
    ],
    s: [
        [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0],
        ],
        [
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
        ],
    ],

    t: [
        [
            [0, 1, 0],
            [1, 1, 1],
            [0, 0, 0],
        ],
        [
            [1, 0, 0],
            [1, 1, 0],
            [1, 0, 0],
        ],
        [
            [1, 1, 1],
            [0, 1, 0],
            [0, 0, 0],
        ],
        [
            [0, 1, 0],
            [1, 1, 0],
            [0, 1, 0],
        ],
    ],
    z: [
        [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0],
        ],
        [
            [0, 1, 0],
            [1, 1, 0],
            [1, 0, 0],
        ],
    ]
};
const rotationStates = {
    l: {
        0: [0, 1],
        1: [1, -1],
        2: [-1, 1],
        3: [0, -1],
    },
    j: {
        0: [0, 1],
        1: [1, -1],
        2: [-1, 1],
        3: [0, -1],
    },
    t: {
        0: [0, 0],
        1: [1, -1],
        2: [-1, 1],
        3: [0, 0],
    },
    s: {
        0: [-1, 1],
        1: [1, -1],
    },
    z: {
        0: [-1, 1],
        1: [1, -1],
    },
    i: {
        0: [-1, 1],
        1: [1, -1],
    },
    o: {
        0: [0, 0],
    },
};
let gameOver = false;
let lines = 0;
let score = 0;
let level = 1;
let rotationCount = 0;
let tmpRandomIndex = 0;
let sameBlockCount = 0;
// document.getElementById("startGame").addEventListener("click", function () {
//     window.game.scene.keys["TetrisScene"].resetGame();
// });

class tetris extends Phaser.Scene {
    constructor() {
        super({ key: "tetris" });
        this.gameBoard = [];
        this.currentTetrimino = null;
        this.blockSprites = [];
        for (let i = 0; i < 20; i++) {
            this.blockSprites[i] = new Array(10).fill(null);
        }
    }

    init() {
        this.unlockedAchievements = new Set();
    }


    preload() {
        this.load.image("j", IMG_PATH + "assets/Shape Blocks/J.png");
        this.load.image("i", IMG_PATH + "assets/Shape Blocks/I.png");
        this.load.image("l", IMG_PATH + "assets/Shape Blocks/L.png");
        this.load.image("z", IMG_PATH + "assets/Shape Blocks/Z.png");
        this.load.image("s", IMG_PATH + "assets/Shape Blocks/S.png");
        this.load.image("t", IMG_PATH + "assets/Shape Blocks/T.png");
        this.load.image("o", IMG_PATH + "assets/Shape Blocks/O.png");
        this.load.image("j1", IMG_PATH + "assets/Shape Blocks/J1.png");
        this.load.image("i1", IMG_PATH + "assets/Shape Blocks/I1.png");
        this.load.image("l1", IMG_PATH + "assets/Shape Blocks/L1.png");
        this.load.image("z1", IMG_PATH + "assets/Shape Blocks/Z1.png");
        this.load.image("s1", IMG_PATH + "assets/Shape Blocks/S1.png");
        this.load.image("t1", IMG_PATH + "assets/Shape Blocks/T1.png");
        this.load.image("j2", IMG_PATH + "assets/Shape Blocks/J2.png");
        this.load.image("l2", IMG_PATH + "assets/Shape Blocks/L2.png");
        this.load.image("t2", IMG_PATH + "assets/Shape Blocks/T2.png");
        this.load.image("j3", IMG_PATH + "assets/Shape Blocks/J3.png");
        this.load.image("l3", IMG_PATH + "assets/Shape Blocks/L3.png");
        this.load.image("t3", IMG_PATH + "assets/Shape Blocks/T3.png");
        this.load.image("block-j", IMG_PATH + "assets/Single Blocks/Blue.png");
        this.load.image("block-i", IMG_PATH + "assets/Single Blocks/LightBlue.png");
        this.load.image("block-l", IMG_PATH + "assets/Single Blocks/Orange.png");
        this.load.image("block-s", IMG_PATH + "assets/Single Blocks/Green.png");
        this.load.image("block-t", IMG_PATH + "assets/Single Blocks/Purple.png");
        this.load.image("block-z", IMG_PATH + "assets/Single Blocks/Red.png");
        this.load.image("block-o", IMG_PATH + "assets/Single Blocks/Yellow.png");
        this.load.image("board", IMG_PATH + "assets/Board/Board1.png");
        this.load.audio("lineClear", IMG_PATH + "assets/Sound Effects/clear-lines.mp3");
        this.load.on("complete", () => {
            const oTetrimino = this.textures.get("o").getSourceImage();
            this.blockSize = oTetrimino.width / 4;
        });

        this.load.image('Background', IMG_PATH + 'assets/tetrisSceneBackground1.png'); // 경로는 프로젝트에 맞게
    }
    create() {

        //전역 변수 초기화
        score = 0;
        level = 1;
        lines = 0;
        rotationCount = 0;
        tmpRandomIndex = 0;
        sameBlockCount = 0;

        let backGround = this.add.image(
            this.cameras.main.width / 2,
            this.cameras.main.height / 2,
            'Background'
        ).setOrigin(0.5).setScale(0.7, 0.8);

        // 배경 보드
        this.boardOffsetX = 50;
        this.boardOffsetY = 50;


        let bg = this.add.image(this.boardOffsetX, this.boardOffsetY, "board").setOrigin(0, 0);
        bg.displayWidth = this.sys.game.config.width - 330;
        bg.displayHeight = this.sys.game.config.height - 100;

        this.lineClear = this.sound.add("lineClear");

        // 게임보드 초기화
        for (let i = 0; i < 20; i++) {
            this.gameBoard[i] = [];
            for (let j = 0; j < 10; j++) {
                this.gameBoard[i][j] = 0;
            }
        }

        // UI 영역 설정 (오른쪽)
        const uiX = 420; // 보드 오른쪽 시작 X
        let yOffset = 80;

        // TETRIS 로고
        this.add.text(uiX + 90, yOffset, "TETRIS", {
            fontSize: '52px',
            fontFamily: 'Arial Black',
            color: '#ff4444',
            stroke: '#ffffff',
            strokeThickness: 6,
        }).setOrigin(0.5, 0.5);

        yOffset += 70;
        // Next Block Title
        this.nextblock = this.add.text(uiX, yOffset, "Next Block", {
            fontSize: '28px',
            fontFamily: 'Arial Black',
            color: '#ffffffff',          // 기본 글자 색
            stroke: '#00ffff',         // 테두리 색도 동일
            strokeThickness: 1
        }).setOrigin(0, 0.5);
        this.nextblock.setShadow(0, 0, '#000000ff', 3, true, true);

        yOffset += 50;
        // 다음 블록 미리보기
        const previewBox = this.add.rectangle(uiX + 80, yOffset + 60, 180, 150, 0x111111, 0.8)
            .setStrokeStyle(2, 0x00ffcc);
        this.nextTetriminoImage = this.add.image(uiX + 80, yOffset + 60, this.nextTetriminoType)
            .setOrigin(0.5)
            .setScale(0.6);


        yOffset += 130;
        // Divider line
        this.add.line(0, 0, uiX + 80, yOffset + 50, uiX + 280, yOffset + 50, 0xffffff, 0.8)
            .setLineWidth(3);

        yOffset += 74;

        // Score
        let graphics = this.add.graphics();
        graphics.fillStyle(0x000000, 0.8); // 색상 + alpha
        graphics.fillRoundedRect(uiX - 10, yOffset + 15, 180, 140, 1); // 마지막 10 = 모서리 반경
        graphics.lineStyle(2, 0x00ffcc); // 두께, 색상
        graphics.strokeRoundedRect(uiX - 10, yOffset + 15, 180, 140, 1);

        // Score 네온 텍스트
        this.scoreText = this.add.text(uiX + 5, yOffset + 45, `Score : 0`, {
            fontSize: '20px',
            fontFamily: 'Arial Black',
            color: '#ffffffff',          // 기본 글자 색
            stroke: '#00ffff',         // 테두리 색도 동일
            strokeThickness: 1
        }).setOrigin(0, 0.5);

        // 네온 글로우 느낌 그림자
        this.scoreText.setShadow(0, 0, '#000000ff', 3, true, true);
        this.linesText = this.add.text(uiX + 5, yOffset + 83, `Lines : 0`, {
            fontSize: '20px',
            fontFamily: 'Arial Black',
            color: '#ffffffff',          // 기본 글자 색
            stroke: '#00ffff',         // 테두리 색도 동일
            strokeThickness: 1
        }).setOrigin(0, 0.5);
        this.linesText.setShadow(0, 0, '#000000ff', 3, true, true);

        this.levelText = this.add.text(uiX + 5, yOffset + 120, `Level : 1`, {
            fontSize: '20px',
            fontFamily: 'Arial Black',
            color: '#ffffffff',          // 기본 글자 색
            stroke: '#00ffff',         // 테두리 색도 동일
            strokeThickness: 1
        }).setOrigin(0, 0.5);
        this.levelText.setShadow(0, 0, '#000000ff', 3, true, true);
        // 컨트롤 및 초기화
        this.moveCounter = 0;
        this.moveInterval = 60;
        this.spawnTetrimino();
        this.cursors = this.input.keyboard.createCursorKeys();
    }
    spawnTetrimino() {
        rotationCount = 0;
        tmpRandomIndex = 0;
        sameBlockCount = 0;


        const tetriminos = ["j", "i", "l", "z", "s", "t", "o"];

        if (!this.nextTetriminoType) {
            const randomIndex = Math.floor(Math.random() * tetriminos.length);

            if (tmpRandomIndex != randomIndex) {
                tmpRandomIndex = randomIndex;
                sameBlockCount = 0;
            }
            else {
                sameBlockCount++;
            }

            if (sameBlockCount == 3) {
                this.unlockAchievement("TETRIS_LUCKY_BLOCK");
            }
            else if (sameBlockCount == 5) {
                this.unlockAchievement("TETRIS_LUCKY_BLOCK_2");
            }

            this.nextTetriminoType = tetriminos[randomIndex];
        }
        this.currentTetriminoType = this.nextTetriminoType;
        const randomIndex = Math.floor(Math.random() * tetriminos.length);
        this.nextTetriminoType = tetriminos[randomIndex];

        const uiX = 350; // 보드 오른쪽 시작 X
        let yOffset = 10;
        this.nextTetriminoImage.setTexture(this.nextTetriminoType);



        this.currentTetrimino = this.physics.add.image(0, this.blockSize, this.currentTetriminoType);
        const tetriminoWidth = 0.5 * this.currentTetrimino.displayWidth / this.blockSize;
        const xOffset = tetriminoWidth % 2 === 0 ? (this.blockSize * (10 - tetriminoWidth)) / 2 : 3 * this.blockSize;
        this.currentTetrimino.x = xOffset + this.boardOffsetX;
        this.currentTetrimino.y = this.boardOffsetY;
        this.currentTetrimino.rotationState = 0;
        this.currentTetrimino.setOrigin(0, 0);
        this.currentTetrimino.setScale(0.5);
        this.physics.world.enable(this.currentTetrimino);
        this.currentTetrimino.body.collideWorldBounds = true;
        this.currentTetrimino.blocks = this.calculateBlockPositions(this.currentTetriminoType, 0);

        gameOver = this.isGameOver();
        if (gameOver) {
            this.displayEndGameMessage();
        }

    }
    spawnTetriminoAt(type, x, y, rotationState) {
        this.currentTetrimino = this.physics.add.image(0, this.blockSize, type);
        this.currentTetrimino.setOrigin(0, 0);
        this.currentTetrimino.setScale(0.5);
        this.physics.world.enable(this.currentTetrimino);
        this.currentTetrimino.body.collideWorldBounds = true;
        this.currentTetrimino.x = x + rotationStates[this.currentTetriminoType][rotationState][0] * this.blockSize;
        this.currentTetrimino.y = y + rotationStates[this.currentTetriminoType][rotationState][1] * this.blockSize;
        this.currentTetrimino.rotationState = rotationState;
        this.currentTetrimino.blocks = this.calculateBlockPositions(this.currentTetriminoType, rotationState);
    }
    isGameOver() {
        let spawnLocations = {
            i: [0, 3],
            o: [0, 4],
            default: [0, 3]
        };
        let spawnLocation = spawnLocations[this.currentTetriminoType] || spawnLocations["default"];
        let blockPositions = this.calculateBlockPositions(this.currentTetriminoType, this.currentTetrimino.rotationState);
        for (let block of blockPositions) {
            let x = spawnLocation[1] + block.x;
            let y = spawnLocation[0] + block.y;
            if (this.gameBoard[y] && this.gameBoard[y][x] === 1) {
                return true;
            }
        }
        return false;
    }
    displayEndGameMessage() {

        this.scene.start("Gameover", { score: score, level: level, lines: lines });

        // finalScore.innerText = score;

    }

    resetGame() {
        gameOver = false;
        score = 0;
        lines = 0;
        level = 1;
    }
    calculateBlockPositions(type, rotationState) {
        const positions = [];
        const matrix = tetriminos[type][rotationState];
        for (let i = 0; i < matrix.length; i++) {
            for (let j = 0; j < matrix[i].length; j++) {
                if (matrix[i][j] === 1) {
                    positions.push({ x: j, y: i });
                }
            }
        }
        return positions;
    }

    rotate() {
        const numberOfstates = {
            i: 2,
            j: 4,
            l: 4,
            t: 4,
            s: 2,
            z: 2,
            o: 1
        }
        let rotationState = (this.currentTetrimino.rotationState + 1) % numberOfstates[this.currentTetriminoType];
        let allowRotation = this.isRotationValid(this.currentTetriminoType, rotationState);
        if (!allowRotation) return;
        const x = this.currentTetrimino.x;
        const y = this.currentTetrimino.y;
        this.currentTetrimino.rotationState = rotationState;
        let rotatedType = rotationState == 0 ? this.currentTetriminoType : this.currentTetriminoType + rotationState;
        this.currentTetrimino.destroy();
        this.spawnTetriminoAt(rotatedType, x, y, rotationState);
        this.checkAndHandleLandedTetrimino();
        rotationCount++;

        if (rotationCount == 10) {
            this.unlockAchievement("TETRIS_ROTATION_MASTER");
        }
        else if (rotationCount == 50) {
            this.unlockAchievement("TETRIS_ROTATION_MASTER2");
        }
    }
    isRotationValid(type, rotationState) {
        let rotationValid = true;
        const positions = [];
        const matrix = tetriminos[type][rotationState];
        for (let i = 0; i < matrix.length; i++) {
            for (let j = 0; j < matrix.length; j++) {
                if (matrix[i][j] === 1) {
                    positions.push({ x: j, y: i });
                }
            }
        }
        positions.forEach((block) => {
            let currentTetriminox = this.currentTetrimino.x + rotationStates[this.currentTetriminoType][rotationState][0] * this.blockSize;
            let currentTetriminoy = this.currentTetrimino.y + rotationStates[this.currentTetriminoType][rotationState][1] * this.blockSize;
            const x = Math.floor(((currentTetriminox + block.x * this.blockSize) - this.boardOffsetX) / this.blockSize);
            const y = Math.floor(((currentTetriminoy + block.y * this.blockSize) - this.boardOffsetY) / this.blockSize);
            if (x > 9 || x < 0 || y < 0 || y > 19) {
                rotationValid = false;
            } else if (this.gameBoard[y][x] == 1)
                rotationValid = false;
        });
        return rotationValid;
    }
    update() {
        if (gameOver) return;
        this.moveCounter++;
        if (this.currentTetrimino && this.moveCounter >= this.moveInterval) {
            this.setTetriminoOnBoard(0);
            this.currentTetrimino.y += this.blockSize;
            this.moveCounter = 0;
            this.setTetriminoOnBoard(2);
            this.time.delayedCall(500, () => {
                this.checkAndHandleLandedTetrimino();
            });
        }
        if (!this.currentTetrimino) return;
        if (Phaser.Input.Keyboard.JustDown(this.cursors.left)) {
            if (!this.isMoveValid(-1)) return;
            this.setTetriminoOnBoard(0);
            this.currentTetrimino.x -= this.blockSize;
            this.setTetriminoOnBoard(2);
            this.checkAndHandleLandedTetrimino();
        }
        if (Phaser.Input.Keyboard.JustDown(this.cursors.right)) {
            if (!this.isMoveValid(1)) return;
            this.setTetriminoOnBoard(0);
            this.currentTetrimino.x += this.blockSize;
            this.setTetriminoOnBoard(2);
            this.checkAndHandleLandedTetrimino();
        }
        if (this.cursors.down.isDown && this.moveCounter % 5 == 0) {
            this.setTetriminoOnBoard(0);
            if (!this.hasLanded())
                this.currentTetrimino.y += this.blockSize;
            this.setTetriminoOnBoard(2);
            if (this.hasLanded()) {
                this.landTetrimino();
            }
        }
        if (Phaser.Input.Keyboard.JustDown(this.cursors.up) && !this.hasLanded()) {
            this.setTetriminoOnBoard(0);
            this.rotate();
            this.setTetriminoOnBoard(2);
        }
        if (Phaser.Input.Keyboard.JustDown(this.cursors.space)) {
            while (!this.hasLanded()) {
                this.currentTetrimino.y += this.blockSize;
            }
            this.landTetrimino();
        }
    }

    checkAndHandleLandedTetrimino() {
        if (this.hasLanded()) {
            this.setTetriminoOnBoard(0);
            this.landTetrimino();
        }
    }

    isMoveValid(direction) {
        let moveValid = true;
        this.currentTetrimino.blocks.forEach((block) => {
            const x = Math.floor(((this.currentTetrimino.x + block.x * this.blockSize) - this.boardOffsetX) / this.blockSize);
            const y = Math.floor(((this.currentTetrimino.y + block.y * this.blockSize) - this.boardOffsetX) / this.blockSize);
            if (this.gameBoard[y][x + direction] === 1 || (x + direction) < 0 || (x + direction) > 9) moveValid = false;
        });
        return moveValid;
    }
    setTetriminoOnBoard(value) {
        this.currentTetrimino.blocks.forEach((block) => {
            const x = Math.floor(((this.currentTetrimino.x + block.x * this.blockSize) - this.boardOffsetX) / this.blockSize);
            const y = Math.floor(((this.currentTetrimino.y + block.y * this.blockSize) - this.boardOffsetY) / this.blockSize);
            if (x >= 0 && x < 10 && y >= 0 && y < 20) {
                this.gameBoard[y][x] = value;
            }
        });
    }

    hasLanded() {
        for (let block of this.currentTetrimino.blocks) {
            const x = Math.floor(((this.currentTetrimino.x + block.x * this.blockSize) - this.boardOffsetX) / this.blockSize);
            const y = Math.floor(((this.currentTetrimino.y + block.y * this.blockSize) - this.boardOffsetY) / this.blockSize);
            if (y >= 19) {
                return true;
            }
            if (y < 20 && x < 10 && this.gameBoard[y + 1][x] === 1) {
                return true;
            }
        }
        return false;
    }
    landTetrimino() {
        this.setTetriminoOnBoard(1);
        this.replaceTetriminoWithBlocks();
        this.checkLines();
        this.spawnTetrimino();
    }
    replaceTetriminoWithBlocks() {
        for (let block of this.currentTetrimino.blocks) {
            let x = this.currentTetrimino.x + block.x * this.blockSize;
            let y = this.currentTetrimino.y + block.y * this.blockSize;
            let blockSprite = this.physics.add.image(x, y, "block-" + this.currentTetriminoType);
            blockSprite.setOrigin(0, 0);
            blockSprite.setScale(0.5);
            this.physics.world.enable(blockSprite);
            let i = Math.floor((y - this.boardOffsetY) / this.blockSize);
            let j = Math.floor((x - this.boardOffsetX) / this.blockSize);
            this.blockSprites[i][j] = blockSprite;
        }
        this.currentTetrimino.destroy();
        this.currentTetrimino = null
    }
    checkLines() {
        let linesToRemove = [];
        let completedTweenCount = 0;
        for (let i = 19; i >= 0; i--) {
            if (this.gameBoard[i].every((cell) => cell === 1)) {
                for (let j = 0; j < 10; j++) {
                    let blockSprite = this.blockSprites[i][j];
                    if (blockSprite !== null) {
                        this.lineClear.play();
                        this.tweens.add({
                            targets: blockSprite,
                            alpha: 0,
                            ease: "Power1",
                            duration: 50,
                            yoyo: true,
                            repeat: 3,
                            onComplete: () => {
                                blockSprite.destroy();
                                completedTweenCount++;
                                if (completedTweenCount === linesToRemove.length * 10) {
                                    this.updateScoreAndLevel(linesToRemove);
                                    this.shiftBlocks(linesToRemove);
                                }
                            },
                        });
                        this.blockSprites[i][j] = null;
                    }
                }
                this.gameBoard[i] = new Array(10).fill(0);
                linesToRemove.push(i);
            }
        }
    }
    shiftBlocks(linesToRemove) {
        for (let line of linesToRemove.reverse()) {
            for (let k = line; k >= 1; k--) {
                for (let j = 0; j < 10; j++) {
                    this.blockSprites[k][j] = this.blockSprites[k - 1][j];
                    if (this.blockSprites[k][j] !== null) {
                        this.blockSprites[k][j].y += this.blockSize;
                    }
                }
                this.gameBoard[k] = [...this.gameBoard[k - 1]];
            }
            this.gameBoard[0] = new Array(10).fill(0);
            this.blockSprites[0] = new Array(10).fill(null);
        }
    }

    updateScoreAndLevel(linesToRemove) {
        let linesCleared = linesToRemove.length;
        console.log(linesCleared)

        if (linesCleared == 4) {
            this.unlockAchievement("TETRIS_FIRST_TETRIS");
        }

        if (linesCleared > 0) {
            let scores = [0, 40, 100, 300, 1200];
            score += scores[linesCleared] * level;
            this.scoreText.setText("Score : " + score);
            lines += linesCleared;
            this.linesText.setText("Lines : " + lines);
            level = Math.floor(lines / 10 + 1);
            this.levelText.setText("Level : " + level);
            this.moveInterval = Math.max(3, 60 / Math.pow(2, Math.floor((level - 1) / 3)));

            if (level == 5) {
                this.unlockAchievement("TETRIS_LEVEL_5");
            }
            else if (level == 10) {
                this.unlockAchievement("TETRIS_LEVEL_10");
            }
            else if (level == 15) {
                this.unlockAchievement("TETRIS_LEVEL_15");
            }

            if (lines > 49 && lines < 54) {
                this.unlockAchievement("TETRIS_50_LINES");
            }
            else if (lines > 99 && lines < 104) {
                this.unlockAchievement("TETRIS_100_LINES");
            }

        }
    }

    unlockAchievement(achievementId) {
        console.log("imunlockachievement");
        if (loginId === "") return;

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
}