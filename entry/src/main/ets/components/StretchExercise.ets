import { StretchDataSource } from '../datasource/StretchDataSource';

@Component
export struct StretchExercise {
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State isStarted: boolean = false;
  @State exerciseIndex: number = 0;
  private exerciseList = StretchDataSource.exerciseList;
  private images: ImageFrameInfo[] = [{ src: $r('app.media.stretch_1') }, { src: $r('app.media.stretch_1_rev') }];
  @State timeSpent: number = 0;
  @State timerId: number = -1;
  @State isFinished: boolean = false;

  startTimer(): void {
    this.clearTimer();
    this.timeSpent = 0;
    this.timerId = setInterval(() => {
      this.timeSpent++;
      console.info('check', `value ${this.timeSpent}`);
      if (this.timeSpent > 10) {
        this.timeUp();
      }
    }, 1000);
  }

  clearTimer() {
    clearInterval(this.timeSpent);
  }

  timeUp(): void {
    if (this.exerciseIndex !== this.exerciseList.length - 1) {
      this.exerciseIndex += 1;
    } else {
      this.isFinished = true;
    }

  }

  build() {
    NavDestination() {
      Stack() {
        if (this.isFinished === true) {
          Column() {
            Text('You completed exercises\nHope you get better')
              .fontColor(Color.Black);
            Blank().width(1);
            Button('Menu')
              .backgroundColor($r('app.color.main_color'))
              .onClick(() => {
                this.pageStack.pop();
              });
          };
        } else if (this.isStarted) {
          Column() {
            ImageAnimator()
              .images(this.exerciseList[this.exerciseIndex].imageArray)
              .state(AnimationStatus.Running)
              .iterations(-1)
              .monitorInvisibleArea(true)
              .onClick(() => {
                this.clearTimer();
                this.pageStack.pop();
              })
              .border({ width: 1, color: $r('app.color.main_color') })
              .borderRadius(16)
              .shadow({
                radius: 8,
                color: '#999999',
                offsetX: 0,
                offsetY: 4
              })
              .size({ width: 100, height: 100 });
            Text(this.exerciseList[this.exerciseIndex].exerciseDesc)
              .fontColor(Color.Black);
          }
          .justifyContent(FlexAlign.Center)
          .height('95%');
        } else {
          Column({ space: 6 }) {
            Text('Let\'s Do Some Exercise')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Black);
            Text('(You can finish everytime\nby clicking image)')
              .fontSize(14)
              .fontWeight(FontWeight.Lighter)
              .fontColor(Color.Black);
            Button('Start')
              .backgroundColor($r('app.color.main_color'))
              .onClick(() => {
                this.isStarted = true;
                this.startTimer();
              });
          }
          .justifyContent(FlexAlign.Center)
          .height('100%');

        }

        Progress({
          value: this.timeSpent,
          total: 11,
          type: ProgressType.Ring
        })
          .width('100%')
          .aspectRatio(1)
          .style({
            strokeWidth: '16px',
            enableSmoothEffect: true
          })
          .color('#E86164')
          .backgroundColor('#ff323232')
          .hitTestBehavior(HitTestMode.None);
      };
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White);
  }
}