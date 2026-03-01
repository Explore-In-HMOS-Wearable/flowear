import { HealthDataComponent } from '../components/HealthDataComponent';
import { BodyTempViewModel } from '../viewmodel/BodyTempViewModel';
import { HealthDataViewModel } from '../viewmodel/HealthDataViewModel';
import { HeartRateViewModel } from '../viewmodel/HeartRateViewModel';

@Component
export struct HealthDataPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  @State currentHeartRate: number = 75;
  @State currentBodyTemperature: number = 75;
  @State currentStressStatus: string = 'Calm';
  private accessToken: string = '';
  private currentStressLevel: number = 30;
  private viewModel = new HealthDataViewModel();
  private heartViewModel = new HeartRateViewModel();
  private tempViewModel = new BodyTempViewModel();

  async aboutToAppear(): Promise<void> {
    this.accessToken = await this.viewModel.getAccessTokenFromStorage();
    if (this.accessToken) {
      this.currentHeartRate =
        await this.heartViewModel.getLatestHeartRate(this.accessToken, Date.now(), (Date.now() - 3600000));
      this.currentBodyTemperature =
        await this.tempViewModel.getLatestBodyTemp(this.accessToken, Date.now(), (Date.now() - 3600000));
    }
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
          });
          HealthDataComponent({
            text: `Body Temperature: ${this.currentBodyTemperature}`,
            image: $r('app.media.temperature')
          });
          HealthDataComponent({
            text: this.currentStressStatus,
            image: $r('app.media.stress_level')
          });

        }
        .width('100%')
        .height('100%')
        .vertical(true)
        .indicator(
          new DotIndicator()
            .color(Color.Gray)
            .selectedColor('#E86164'));
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center);
    }
    .backgroundColor($r('app.color.background_color'))
    .width('100%')
    .height('100%')
    .hideTitleBar(true);
  }
}