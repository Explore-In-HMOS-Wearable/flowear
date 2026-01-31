import { MeditationModel } from '../model/MeditationModel';
import { MeditationViewModel } from '../viewmodel/MeditationViewModel';

@Entry
@Component
export struct MeditationPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  @State scaleV: number = 1;
  private timer: number = -1;
  private currentStressLevel: number = 100;
  @State suggestionText: string = 'You look normal\nMaybe try these';
  @State exercises: MeditationModel[] = [{
    name: '',
    desc: '',
    icon: '',
    route: ''
  }];

  private viewModel = new MeditationViewModel();
  private swiperController: SwiperController = new SwiperController();
  private isMoodSet = false;

  async aboutToAppear(): Promise<void> {
    this.isMoodSet = this.viewModel.checkMoodValue();
    if (this.isMoodSet) {
      this.currentStressLevel = await this.viewModel.updateMoodValue();
      this.suggestionText = this.viewModel.updateSuggestionText(this.currentStressLevel);
      console.info(`new current ${this.currentStressLevel}`);
      this.exercises = this.viewModel.getExercises(this.currentStressLevel);
      this.timer = setInterval(() => {
        this.scaleV = this.scaleV === 1 ? 1.3 : 1;
      }, 1000);
    }
  }

  aboutToDisappear(): void {
    clearInterval(this.timer);
  }

  build() {
    NavDestination() {
      Stack() {
        if (this.isMoodSet) {
          Column({ space: 16 }) {
            Swiper(this.swiperController) {
              Column() {
                Text(this.suggestionText)
                  .fontColor(Color.Black)
                Blank().height(15)
                Text(`\u2193`)
                  .fontColor(Color.Black)
                  .scale({ x: this.scaleV, y: this.scaleV })
                  .onClick(() => {
                    this.swiperController.showNext();
                  })
                  .animation({
                    duration: 1000,
                    curve: Curve.EaseInOut
                  })
              }
              .justifyContent(FlexAlign.Center)
              .height('100%')

              ForEach(this.exercises, (exerciseItem: MeditationModel, index: number) => {
                Column() {
                  Text(exerciseItem.name)
                    .fontColor(Color.Black)
                  Image(exerciseItem.icon).size({ width: 80, height: 80 })
                  Text(exerciseItem.desc)
                    .fontColor(Color.Black)
                  Blank().height(15)
                  if (index !== this.exercises.length - 1) {
                    Text(`\u2193`)
                      .fontColor(Color.Black)
                      .scale({ x: this.scaleV, y: this.scaleV })
                      .animation({
                        duration: 1000,
                        curve: Curve.EaseInOut
                      })
                      .onClick(() => {
                        this.swiperController.showNext();
                      })
                  }
                }
                .height('100%')
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  this.pageStack.pushPathByName('BreatheExercise', null);
                })
              }, (item: string, index: number) => item)
            }
            .vertical(true)
            .width('100%')
            .height('100%')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
        } else {
          Column() {
            Text('Please complete Mood Test first on the Symptoms and Mood page')
              .fontColor(Color.Black)
            Image($r('app.media.heart')).size({ width: 60, height: 60 })
          }
          .justifyContent(FlexAlign.Center)
          .height('100%')
          .padding(10)
        }
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}