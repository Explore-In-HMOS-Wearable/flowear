import { Icon, Icons } from '@iakii/icons';
import { HistoryComponent } from '../components/HistoryComponent';
import { BodyTempViewModel } from '../viewmodel/BodyTempViewModel';
import { HeartRateViewModel } from '../viewmodel/HeartRateViewModel';
import { ManualLoginViewModel } from '../viewmodel/ManualLoginViewModel';

@Entry
@Component
export struct HistoryPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  private swiperController: SwiperController = new SwiperController();
  @State presentMonthHeartRate: number[] = [];
  @State lastMonthHeartRate: number[] = [];
  @State presentMonthBodyTemperature: number[] = [33.5, 34, 35, 34];
  @State lastMonthBodyTemperature: number[] = [34, 33, 36, 35];
  private totalHeartRates: number[] = [75, 88, 94, 81, 70, 89, 95, 80];
  private totalBodyTemp: number[] = [34, 33, 36, 35, 33.5, 34, 35, 34];
  private viewModel = new ManualLoginViewModel();
  private accessToken: string = '';
  private heartViewModel = new HeartRateViewModel();
  private tempViewModel = new BodyTempViewModel();

  async aboutToAppear(): Promise<void> {
    const storedToken = await this.viewModel.getAccessTokenFromStorage();
    if (storedToken.length > 0) {
      this.accessToken = storedToken;
      this.totalHeartRates =
        await this.heartViewModel.getWeeklyHeartRate(this.accessToken, (Date.now() - 4838400000), Date.now());
      this.totalBodyTemp =
        await this.tempViewModel.getWeeklyBodyTemp(this.accessToken, (Date.now() - 4838400000), Date.now());
      this.lastMonthHeartRate = this.totalHeartRates.slice(0, 4);
      this.lastMonthBodyTemperature = this.totalBodyTemp.slice(0, 4);
      this.presentMonthHeartRate = this.totalHeartRates.slice(-4);
      this.presentMonthBodyTemperature = this.totalBodyTemp.slice(-4);
    }
  }

  build() {
    NavDestination() {
      Swiper(this.swiperController) {
        Column({ space: 3 }) {
          Button() {
            Image($r('app.media.back_icon'))
              .fillColor(Color.White);
          }
          .backgroundColor($r('app.color.main_color'))
          .size({ width: 30, height: 30 })
          .onClick(() => {
            this.pageStack.pop();
          });

          Text('This section displays your\nhealth data from previous month as weekly averages')
            .fontColor(Color.Black);
          Icon({ icon: Icons.caret_down_fill, iconSize: 30, iconColor: $r('app.color.main_color') })
            .scale({ x: 1, y: 1 })
            .onClick(() => {
              this.swiperController.showNext();
            });
        }
        .margin({ left: 15 })
        .height('100%')
        .justifyContent(FlexAlign.Center);

        HistoryComponent({
          title: 'Weekly Heart Rate\nAverages',
          presentMonthData: this.presentMonthHeartRate,
          lastMonthData: this.lastMonthHeartRate,
          onAction: () => {
            this.swiperController.showNext();
          }
        });
        HistoryComponent({
          title: 'Weekly Body\nTemperature Averages',
          presentMonthData: this.presentMonthBodyTemperature,
          lastMonthData: this.lastMonthBodyTemperature,
          onAction: () => {
            this.swiperController.showNext();
          }
        });
      }
      .width('100%')
      .height('100%')
      .vertical(true)
      .indicator(
        new DotIndicator()
          .color($r('app.color.light_main_color'))
          .selectedColor($r('app.color.main_color'))
          .left(1)
      );
    }
    .backgroundColor($r('app.color.background_color'))
    .width('100%')
    .height('100%')
    .hideTitleBar(true);
  }
}

