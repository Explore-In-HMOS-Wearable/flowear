import { datas, Model } from '../model/Model';
import { ArcList, ArcListItem, ColorMetrics, ComponentContent, ArcListAttribute } from '@kit.ArkUI';
import { Icon, Icons } from '@iakii/icons';

@Builder
function header() {
  Text('Home Page')
    .fontSize(18)
    .fontWeight(FontWeight.Bold)
    .fontColor($r('app.color.main_color'));
}

@Component
export default struct HomePage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  context: UIContext = this.getUIContext();
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header));
  swiperCont: SwiperController = new SwiperController();

  build() {
    NavDestination() {
      ArcList({ header: this.header, initialIndex: 2 }) {
        ForEach(datas, (menuItem: Model) => {
          ArcListItem() {
            Row() {
              Stack() {
                Icon({ icon: menuItem.icn, iconSize: 20, iconColor: $r('app.color.main_color') });
              }
              .size({ width: 30, height: 30 })
              .alignContent(Alignment.Center)
              .backgroundColor(Color.White)
              .borderRadius('50%');

              Blank(2);
              Text(menuItem.name.toString())
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('60%')
                .textAlign(TextAlign.Start)
                .fontSize(14)
                .fontColor(Color.White);

              Icon({ icon: Icons.caret_right_fill, iconSize: 20, iconColor: Color.White });
            }
            .backgroundColor($r('app.color.main_color'))
            .borderRadius(25)
            .margin(5)
            .width('85%')
            .padding({
              top: 3,
              bottom: 3,
              left: 8,
              right: 3
            })
            .onClick(() => {
              if (menuItem.name !== 'Calendar') {
                this.pageStack.pushPathByName(menuItem.route, null);
              } else {
                this.swiperCont.showPrevious();
              }
            });
          };
        }, (item: string, index: number) => item);
      }
      .scrollBarColor(ColorMetrics.resourceColor($r('app.color.main_color')));
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_color'))
    .hideTitleBar(true)
    .hideBackButton(true);
  }
}