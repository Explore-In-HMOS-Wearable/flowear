import { Icon, Icons } from '@iakii/icons';
import { MeditationModel } from '../model/MeditationModel';
import { MeditationViewModel } from '../viewmodel/MeditationViewModel';

@Entry
@Component
export struct MeditationPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  @State scaleV: number = 1;
  private timer: number = -1;
  currentStressLevel: number = 100;
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
        this.scaleV = this.scaleV === 1 ? 1.4 : 1;
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
                  .fontColor(Color.Black);
                Blank().height(15);
                Icon({ icon: Icons.caret_down_fill, iconSize: 30, iconColor: $r('app.color.main_color') })
                  .scale({ x: this.scaleV, y: this.scaleV })
                  .animation({
                    duration: 800,
                    curve: Curve.EaseInOut
                  })
                  .onClick(() => {
                    this.swiperController.showNext();
                  });
              }
              .justifyContent(FlexAlign.Center)
              .height('100%');

              ForEach(this.exercises, (exerciseItem: MeditationModel, index: number) => {
                Column() {
                  Stack() {
                    Column() {

                      Text(exerciseItem.name)
                        .fontColor(Color.Black);
                      Image(exerciseItem.icon).size({ width: 80, height: 80 });
                      Text(exerciseItem.desc)
                        .fontColor(Color.Black);
                    };
                  }.layoutWeight(1);

                  if (index !== this.exercises.length - 1) {
                    Icon({ icon: Icons.caret_down_fill, iconSize: 30, iconColor: $r('app.color.main_color') })
                      .scale({ x: this.scaleV, y: this.scaleV })
                      .animation({
                        duration: 800,
                        curve: Curve.EaseInOut
                      })
                      .onClick(() => {
                        this.swiperController.showNext();
                      });
                  }
                }
                .height('100%')
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  this.pageStack.pushPathByName(exerciseItem.route, null);
                });
              }, (item: string, index: number) => item);
            }
            .indicator(
              new DotIndicator()
                .color(Color.Gray)
                .selectedColor('#E86164'))
            .vertical(true)
            .width('100%')
            .height('100%');
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center);
        } else {
          Column() {
            Text('Please complete Mood Test first on the Symptoms and Mood page')
              .fontColor(Color.Black);
            Image($r('app.media.heart')).size({ width: 60, height: 60 });
          }
          .justifyContent(FlexAlign.Center)
          .height('100%')
          .padding(10);
        }
      }
      .width('100%')
      .height('100%');
    }
    .backgroundColor($r('app.color.background_color'))
    .width('100%')
    .height('100%')
    .hideTitleBar(true);
  }
}