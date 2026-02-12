import { router } from '@kit.ArkUI';
import { Tank, Bullet, Wall, Direction } from '../model/GameModel';

@Entry
@Component
struct GamePage {
  // 游戏区域大小
  @State gameWidth: number = 360;
  @State gameHeight: number = 480;

  // 玩家坦克
  @State playerX: number = 160;
  @State playerY: number = 420;
  @State playerDir: Direction = Direction.UP;
  @State playerAlive: boolean = true;

  // 敌方坦克
  @State enemies: Tank[] = [];

  // 子弹
  @State bullets: Bullet[] = [];

  // 墙壁
  @State walls: Wall[] = [];

  // 游戏状态
  @State score: number = 0;
  @State isGameOver: boolean = false;
  @State isVictory: boolean = false;

  // 定时器ID
  private gameLoopId: number = -1;
  private enemyMoveId: number = -1;

  aboutToAppear(): void {
    this.initGame();
    this.startGameLoop();
  }

  aboutToDisappear(): void {
    this.stopGameLoop();
  }

  initGame(): void {
    this.playerX = 160;
    this.playerY = 420;
    this.playerDir = Direction.UP;
    this.playerAlive = true;

    // 创建敌人
    this.enemies = [];
    const e1 = new Tank(40, 40, false);
    const e2 = new Tank(160, 40, false);
    const e3 = new Tank(280, 40, false);
    this.enemies.push(e1, e2, e3);

    // 创建墙壁
    this.walls = [];
    for (let i = 0; i < 4; i++) {
      this.walls.push(new Wall(80 + i * 60, 200));
    }
    for (let i = 0; i < 3; i++) {
      this.walls.push(new Wall(100 + i * 70, 300));
    }

    this.bullets = [];
    this.score = 0;
    this.isGameOver = false;
    this.isVictory = false;
  }

  startGameLoop(): void {
    this.gameLoopId = setInterval(() => {
      if (!this.isGameOver && !this.isVictory) {
        this.updateGame();
      }
    }, 50);

    this.enemyMoveId = setInterval(() => {
      if (!this.isGameOver && !this.isVictory) {
        this.updateEnemyAI();
      }
    }, 800);
  }

  stopGameLoop(): void {
    if (this.gameLoopId !== -1) {
      clearInterval(this.gameLoopId);
    }
    if (this.enemyMoveId !== -1) {
      clearInterval(this.enemyMoveId);
    }
  }

  updateGame(): void {
    // 更新子弹
    let newBullets: Bullet[] = [];
    for (let bullet of this.bullets) {
      bullet.move();

      // 边界检测
      if (bullet.x < 0 || bullet.x > this.gameWidth ||
        bullet.y < 0 || bullet.y > this.gameHeight) {
        continue;
      }

      // 墙壁碰撞
      let hitWall = false;
      for (let wall of this.walls) {
        if (!wall.isDestroyed && this.checkCollision(
          bullet.x, bullet.y, bullet.size,
          wall.x, wall.y, wall.size)) {
          if (wall.isDestructible) {
            wall.isDestroyed = true;
          }
          hitWall = true;
          break;
        }
      }
      if (hitWall) continue;

      // 坦克碰撞
      if (bullet.isPlayerBullet) {
        for (let enemy of this.enemies) {
          if (enemy.isAlive && this.checkCollision(
            bullet.x, bullet.y, bullet.size,
            enemy.x, enemy.y, enemy.size)) {
            enemy.isAlive = false;
            this.score += 100;
            hitWall = true;
            break;
          }
        }
      } else {
        if (this.playerAlive && this.checkCollision(
          bullet.x, bullet.y, bullet.size,
          this.playerX, this.playerY, 40)) {
          this.playerAlive = false;
          this.isGameOver = true;
          hitWall = true;
        }
      }

      if (!hitWall) {
        newBullets.push(bullet);
      }
    }
    this.bullets = newBullets;

    // 更新墙壁
    this.walls = this.walls.filter(w => !w.isDestroyed);

    // 检查胜利
    if (this.enemies.every(e => !e.isAlive)) {
      this.isVictory = true;
    }
  }

  updateEnemyAI(): void {
    for (let enemy of this.enemies) {
      if (!enemy.isAlive) continue;

      const dirs = [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT];
      const randomDir = dirs[Math.floor(Math.random() * 4)];
      enemy.move(randomDir, this.gameWidth, this.gameHeight);

      if (Math.random() < 0.4) {
        const bullet = new Bullet(enemy);
        this.bullets.push(bullet);
      }
    }
    this.enemies = [...this.enemies];
    this.bullets = [...this.bullets];
  }

  checkCollision(x1: number, y1: number, s1: number,
    x2: number, y2: number, s2: number): boolean {
    return x1 < x2 + s2 && x1 + s1 > x2 &&
      y1 < y2 + s2 && y1 + s1 > y2;
  }

  movePlayer(dir: Direction): void {
    if (this.isGameOver || this.isVictory || !this.playerAlive) return;

    const speed = 8;
    const size = 40;
    let newX = this.playerX;
    let newY = this.playerY;

    this.playerDir = dir;
    switch (dir) {
      case Direction.UP:
        newY = Math.max(0, this.playerY - speed);
        break;
      case Direction.DOWN:
        newY = Math.min(this.gameHeight - size, this.playerY + speed);
        break;
      case Direction.LEFT:
        newX = Math.max(0, this.playerX - speed);
        break;
      case Direction.RIGHT:
        newX = Math.min(this.gameWidth - size, this.playerX + speed);
        break;
    }

    // 墙壁碰撞检测
    let canMove = true;
    for (let wall of this.walls) {
      if (!wall.isDestroyed && this.checkCollision(newX, newY, size, wall.x, wall.y, wall.size)) {
        canMove = false;
        break;
      }
    }

    if (canMove) {
      this.playerX = newX;
      this.playerY = newY;
    }
  }

  playerShoot(): void {
    if (this.isGameOver || this.isVictory || !this.playerAlive) return;

    const playerTank = new Tank(this.playerX, this.playerY, true);
    playerTank.direction = this.playerDir;
    const bullet = new Bullet(playerTank);
    this.bullets = [...this.bullets, bullet];
  }

  restartGame(): void {
    this.stopGameLoop();
    this.initGame();
    this.startGameLoop();
  }

  build() {
    Column() {
      // 顶部信息
      Row() {
        Text(`分数: ${this.score}`)
          .fontSize(18)
          .fontColor('#ffffff')
        Text(`敌人: ${this.enemies.filter(e => e.isAlive).length}`)
          .fontSize(18)
          .fontColor('#ffffff')
          .margin({ left: 30 })
      }
      .width('100%')
      .height(40)
      .backgroundColor('#333333')
      .justifyContent(FlexAlign.Center)

      // 游戏区域
      Stack() {
        // 背景
        Column()
          .width(this.gameWidth)
          .height(this.gameHeight)
          .backgroundColor('#1a1a1a')

        // 墙壁
        ForEach(this.walls, (wall: Wall, index: number) => {
          if (!wall.isDestroyed) {
            Column()
              .width(wall.size)
              .height(wall.size)
              .backgroundColor('#795548')
              .borderRadius(4)
              .position({ x: wall.x, y: wall.y })
          }
        })

        // 玩家坦克
        if (this.playerAlive) {
          Column()
            .width(40)
            .height(40)
            .backgroundColor('#2E7D32')
            .borderRadius(6)
            .position({ x: this.playerX, y: this.playerY })
        }

        // 敌方坦克
        ForEach(this.enemies, (enemy: Tank, index: number) => {
          if (enemy.isAlive) {
            Column()
              .width(enemy.size)
              .height(enemy.size)
              .backgroundColor('#C62828')
              .borderRadius(6)
              .position({ x: enemy.x, y: enemy.y })
          }
        })

        // 子弹
        ForEach(this.bullets, (bullet: Bullet, index: number) => {
          Column()
            .width(bullet.size)
            .height(bullet.size)
            .backgroundColor('#FFC107')
            .borderRadius(4)
            .position({ x: bullet.x, y: bullet.y })
        })

        // 游戏结束遮罩
        if (this.isGameOver || this.isVictory) {
          Column() {
            Text(this.isVictory ? '🎉 胜利!' : '💥 游戏结束')
              .fontSize(32)
              .fontColor('#ffffff')
              .fontWeight(FontWeight.Bold)

            Text(`得分: ${this.score}`)
              .fontSize(22)
              .fontColor('#ffffff')
              .margin({ top: 15 })

            Button('重新开始')
              .width(140)
              .height(45)
              .fontSize(18)
              .margin({ top: 25 })
              .onClick(() => this.restartGame())
          }
          .width(this.gameWidth)
          .height(this.gameHeight)
          .backgroundColor('#000000')
          .opacity(0.85)
          .justifyContent(FlexAlign.Center)
        }
      }
      .width(this.gameWidth)
      .height(this.gameHeight)
      .margin({ top: 10 })

      // 控制按钮
      Column() {
        Button('↑')
          .width(55)
          .height(55)
          .fontSize(26)
          .backgroundColor('#555555')
          .onClick(() => this.movePlayer(Direction.UP))

        Row() {
          Button('←')
            .width(55)
            .height(55)
            .fontSize(26)
            .backgroundColor('#555555')
            .onClick(() => this.movePlayer(Direction.LEFT))

          Button('🔥')
            .width(65)
            .height(65)
            .fontSize(26)
            .backgroundColor('#C62828')
            .margin({ left: 8, right: 8 })
            .onClick(() => this.playerShoot())

          Button('→')
            .width(55)
            .height(55)
            .fontSize(26)
            .backgroundColor('#555555')
            .onClick(() => this.movePlayer(Direction.RIGHT))
        }
        .margin({ top: 5 })

        Button('↓')
          .width(55)
          .height(55)
          .fontSize(26)
          .backgroundColor('#555555')
          .margin({ top: 5 })
          .onClick(() => this.movePlayer(Direction.DOWN))
      }
      .margin({ top: 15 })

      // 返回按钮
      Button('返回主页')
        .width(110)
        .height(36)
        .fontSize(14)
        .backgroundColor('#666666')
        .margin({ top: 15 })
        .onClick(() => {
          this.stopGameLoop();
          router.back();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#222222')
  }
}
