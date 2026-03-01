import { ArcSwiper } from '@kit.ArkUI';
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts';
import { Icon, Icons } from '@iakii/icons';

@Component
export struct HistoryComponent {
  @Prop title: string;
  @Prop presentMonthData: number[];
  @Prop lastMonthData: number[];
  @State weeklyChart: UChartsController = new UChartsController();
  onAction?: () => void;
  private dataMin = Math.min(...this.presentMonthData, ...this.lastMonthData);
  private dataMax = Math.max(...this.presentMonthData, ...this.lastMonthData);
  private weeklyOpts: Partial<ChartOptions> = {
    type: 'column',
    categories: ['1-7', '8-14', '15-21', '22-30'],
    series: [
      {
        name: 'Last month',
        data: this.lastMonthData,
        color: '#b8daf7'
      },
      {
        name: 'This month',
        data: this.presentMonthData,
        color: '#ff9292'
      }
    ],
    xAxis: { disableGrid: true },
    yAxis: {
      data: [{ min: this.dataMin - 5, max: this.dataMax + 5 }],
      disableGrid: true,
      splitNumber: 5
    },
    background: '#ffffff',
    extra: {
      line: {
        type: 'curve',
        activeType: 'hollow'
      }
    },
    legend: { show: false },
    fontSize: 12
  };

  aboutToAppear(): void {
    console.info(`array is ${this.presentMonthData}`);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text(this.title)
          .fontColor(Color.Black)
          .fontSize(14)
          .fontWeight(FontWeight.Bold);
        UCharts({
          controller: this.weeklyChart,
          onReady: () => {
            this.weeklyChart.updateData(this.weeklyOpts);
          },
          contentWidth: 200,
          contentHeight: 130
        });
        Icon({ icon: Icons.caret_down_fill, iconSize: 30, iconColor: $r('app.color.main_color') })
          .scale({ x: 1, y: 1 })
          .onClick(() => {
            if (this.onAction) {
              this.onAction();
            }
          });
      };
    }
    .alignContent(Alignment.Center);

  }
}