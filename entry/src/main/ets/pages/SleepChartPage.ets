import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts';

@Component
export struct SleepChartPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State weeklyChart: UChartsController = new UChartsController();
  private weeklyOpts: Partial<ChartOptions> = {
    type: 'line',
    categories: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    series: [
      {
        name: 'Deep Sleep (hour)',
        data: [2.1, 2.3, 1.8, 2.6, 2.2, 2.5, 2.4],
        color: '#ff9292'
      },
      {
        name: 'Light Sleep (hour)',
        data: [4.5, 4.2, 4.8, 4.1, 4.6, 4.3, 4.4],
        color: '#b8daf7'
      },
      {
        name: 'Awake (hour)',
        data: [0.4, 0.3, 0.5, 0.2, 0.3, 0.4, 0.3],
        color: '#c7dab6'
      }
    ],
    xAxis: { disableGrid: true },
    yAxis: {
      data: [{ min: 0, max: 10 }],
      disableGrid: true
    },
    background: '#ffffff',
    extra: {
      line: {
        type: 'curve',
        activeType: 'hollow'
      }
    },
    legend: { show: false }
  };

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        UCharts({
          controller: this.weeklyChart, onReady: () => {
            this.weeklyChart.updateData(this.weeklyOpts);
          }
        });
      }
      .width(210)
      .height(100);
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background_color'));
  }
}