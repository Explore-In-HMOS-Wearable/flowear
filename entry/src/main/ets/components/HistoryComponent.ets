import { ArcSwiper } from '@kit.ArkUI';

@Component
export struct HistoryComponent {
  @Prop title: string;
  @Prop image: Resource;
  @Prop dataArray: number[];

  aboutToAppear(): void {
    console.info(`array is ${this.dataArray}`);
  }

  build() {
    Column() {
      Image(this.image).size({ width: 40, height: 40 })
      Text(this.title)
        .fontColor(Color.Black)

      Row() {
        ForEach(this.dataArray, (avg: number, index: number) => {
          Text(index === this.dataArray.length - 1 ?
            `${avg.toString()} ` :
            `${avg.toString()} - `)
            .fontColor(Color.Black)
        }, (item: string, index: number) => item)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}