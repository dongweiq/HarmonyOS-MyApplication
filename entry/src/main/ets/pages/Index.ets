import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State title: string = '坦克大战';
  @State highScore: number = 0;

  build() {
    Column() {
      // 标题
      Text(this.title)
        .fontSize(48)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2E7D32')
        .margin({ top: 100 })

      // 坦克图标
      Text('🎮')
        .fontSize(80)
        .margin({ top: 40 })

      // 最高分
      Text(`最高分: ${this.highScore}`)
        .fontSize(24)
        .fontColor('#666666')
        .margin({ top: 20 })

      // 开始按钮
      Button('开始游戏')
        .width(200)
        .height(60)
        .fontSize(24)
        .backgroundColor('#2E7D32')
        .margin({ top: 60 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/GamePage' });
        })

      // 说明
      Column() {
        Text('操作说明:')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })
        Text('← → ↑ ↓ : 控制坦克移动')
          .fontSize(16)
        Text('🔥 按钮 : 发射子弹')
          .fontSize(16)
        Text('消灭所有敌人获胜!')
          .fontSize(16)
      }
      .margin({ top: 40 })
      .padding(20)
      .backgroundColor('#f5f5f5')
      .borderRadius(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}
