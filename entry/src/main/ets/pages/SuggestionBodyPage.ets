import { Icon } from '@iakii/icons';
import { suggestionBodyDatas, SuggestionBodyModel } from '../model/SuggestionBodyModel';

@Component
export struct SuggestionBodyPage {
  build() {
    NavDestination() {
      Swiper() {
        ForEach(suggestionBodyDatas, (item: SuggestionBodyModel, index: number) => {
          Column({ space: 24 }) {
            Icon({ icon: item.icon, iconSize: 40, iconColor: '#e86164' })
              .margin({ left: 8 });
            Text(`“${item.text}”`)
              .fontSize(14)
              .fontColor('#e86164')
              .textAlign(TextAlign.Center)
              .padding({ left: 24, right: 24 });
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center);
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
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background_color'));
  }
}