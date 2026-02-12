// 游戏数据模型
export enum Direction {
  UP = 0,
  DOWN = 1,
  LEFT = 2,
  RIGHT = 3
}

export class Tank {
  x: number = 0;
  y: number = 0;
  direction: Direction = Direction.UP;
  speed: number = 5;
  isPlayer: boolean = true;
  isAlive: boolean = true;
  size: number = 40;

  constructor(x: number, y: number, isPlayer: boolean) {
    this.x = x;
    this.y = y;
    this.direction = Direction.UP;
    this.speed = isPlayer ? 5 : 3;
    this.isPlayer = isPlayer;
    this.isAlive = true;
    this.size = 40;
  }

  move(dir: Direction, maxX: number, maxY: number): void {
    this.direction = dir;
    switch (dir) {
      case Direction.UP:
        this.y = Math.max(0, this.y - this.speed);
        break;
      case Direction.DOWN:
        this.y = Math.min(maxY - this.size, this.y + this.speed);
        break;
      case Direction.LEFT:
        this.x = Math.max(0, this.x - this.speed);
        break;
      case Direction.RIGHT:
        this.x = Math.min(maxX - this.size, this.x + this.speed);
        break;
    }
  }
}

export class Bullet {
  x: number = 0;
  y: number = 0;
  direction: Direction = Direction.UP;
  speed: number = 10;
  isPlayerBullet: boolean = true;
  size: number = 8;

  constructor(tank: Tank) {
    this.size = 8;
    this.speed = 10;
    this.direction = tank.direction;
    this.isPlayerBullet = tank.isPlayer;

    const centerX = tank.x + tank.size / 2;
    const centerY = tank.y + tank.size / 2;

    switch (this.direction) {
      case Direction.UP:
        this.x = centerX - this.size / 2;
        this.y = tank.y - this.size;
        break;
      case Direction.DOWN:
        this.x = centerX - this.size / 2;
        this.y = tank.y + tank.size;
        break;
      case Direction.LEFT:
        this.x = tank.x - this.size;
        this.y = centerY - this.size / 2;
        break;
      case Direction.RIGHT:
        this.x = tank.x + tank.size;
        this.y = centerY - this.size / 2;
        break;
    }
  }

  move(): void {
    switch (this.direction) {
      case Direction.UP:
        this.y -= this.speed;
        break;
      case Direction.DOWN:
        this.y += this.speed;
        break;
      case Direction.LEFT:
        this.x -= this.speed;
        break;
      case Direction.RIGHT:
        this.x += this.speed;
        break;
    }
  }
}

export class Wall {
  x: number = 0;
  y: number = 0;
  size: number = 40;
  isDestructible: boolean = true;
  isDestroyed: boolean = false;

  constructor(x: number, y: number, isDestructible: boolean = true) {
    this.x = x;
    this.y = y;
    this.size = 40;
    this.isDestructible = isDestructible;
    this.isDestroyed = false;
  }
}
