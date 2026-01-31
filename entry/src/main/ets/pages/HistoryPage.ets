import { ArcSwiper, ArcSwiperAttribute } from '@kit.ArkUI';
import { HistoryComponent } from '../components/HistoryComponent';

@Entry
@Component
export struct HistoryPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  @State weeklyHeartRate: number [] = [70, 89, 95, 80];
  @State weeklyBodyTemperature: number[] = [33.5, 34, 35, 34];

  build() {
    NavDestination() {
      ArcSwiper() {
        Column({ space: 3 }) {
          Button() {
            Image($r('app.media.back_icon'))
          }
          .backgroundColor('#e86164')
          .size({ width: 30, height: 30 })
          .onClick(() => {
            this.pageStack.pop();
          })

          Text('This section displays your\nhealth data from previous month\nas weekly averages')
            .fontColor(Color.Black)
          Text('\u2193')
            .fontColor(Color.Black)
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)

        HistoryComponent({
          title: 'Your weekly heart rates',
          image: $r('app.media.heart'),
          dataArray: this.weeklyHeartRate
        })
        HistoryComponent({
          title: 'Your weekly temperatures',
          image: $r('app.media.temperature'),
          dataArray: this.weeklyBodyTemperature
        })
      }
      .width('100%')
      .height('100%')
      .vertical(true)
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}

