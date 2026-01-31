import { HealthDataComponent } from '../components/HealthDataComponent';
import { HealthDataViewModel } from '../viewmodel/HealthDataViewModel';

@Entry
@Component
export struct HealthDataPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  @State currentHeartRate: number = 75;
  @State currentBodyTemperature: number = 34;
  private currentStressLevel: number = 30;
  @State currentStressStatus: string = 'Calm';
  private viewModel = new HealthDataViewModel();

  async aboutToAppear(): Promise<void> {
    this.currentHeartRate = 70;
    this.currentBodyTemperature = 33;
    this.currentStressLevel = await this.viewModel.updateMoodValue();
    this.currentStressStatus = this.viewModel.updateCurrentStressStatus(this.currentStressLevel);
  }

  build() {
    NavDestination() {
      Column({ space: 16 }) {
        Swiper() {
          HealthDataComponent({
            text: `Heart Rate: ${this.currentHeartRate}`,
            image: $r('app.media.heart')
          })
          HealthDataComponent({
            text: `Body Temperature: ${this.currentBodyTemperature}`,
            image: $r('app.media.temperature')
          })
          HealthDataComponent({
            text: this.currentStressStatus,
            image: $r('app.media.stress_level')
          })

        }
        .width('100%')
        .height('100%')
        .vertical(true)
        .indicator(
          new DotIndicator()
            .color(Color.Gray)
            .selectedColor('#E86164'))
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}