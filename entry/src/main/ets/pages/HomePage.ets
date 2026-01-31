import { datas, Model } from '../model/Model';
import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { Icon } from '@iakii/icons';

@Builder
function header() {
  Text('Home Page')
    .fontSize(14)
    .fontWeight(FontWeight.Bold)
}

@Component
export struct HomePage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  context: UIContext = this.getUIContext();
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header));

  build() {
    NavDestination() {
      ArcList({ header: this.header }) {
        ForEach(datas, (menuItem: Model) => {
          ArcListItem() {
            Row() {
              Icon({ icon: menuItem.icn, iconSize: 30, iconColor: Color.White })
                .margin({ left: 8 });
              Blank(2)
              Text(menuItem.name.toString())
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('60%')
                .textAlign(TextAlign.Start)
                .fontSize(14)
                .fontColor(Color.White)
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
              this.pageStack.pushPathByName(menuItem.route, null);
            })
          }
        }, (item: string, index: number) => item)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}