import { Icon, Icons } from '@iakii/icons';
import { Option, SymptomQuestionModel } from '../model/SymptomQuestionModel';

@Component
export struct MoodQuestionComponent {
  @Prop questionItem: SymptomQuestionModel;
  onAction?: (value: number) => void;
  scroller: Scroller = new Scroller();
  @State centerIndex: number = -1;
  @State displayType: boolean = false;

  build() {
    Column({ space: 7 }) {
      Text(this.questionItem.question)
        .fontColor(Color.Black);
      if (this.questionItem.options.length > 3) {
        if (!this.displayType) {
          List({ space: 65 }) {
            ForEach(this.questionItem.options, (option: Option, index: number) => {
              ListItem() {
                Button(option.content, { type: ButtonType.Circle })
                  .scale({ x: index === this.centerIndex ? 2.5 : 1.8, y: index === this.centerIndex ? 2.5 : 1.8 })
                  .backgroundColor(index === this.centerIndex ? $r('app.color.main_color') :
                    $r('app.color.light_main_color'))

                  .onClick(() => {
                    if (this.onAction) {
                      this.onAction(option.value);
                    }
                  });
              };
            }, (item: string, index: number) => item);
          }
          .scrollBar(BarState.Off)
          .onScrollIndex((start, end, center) => {
            this.centerIndex = center;
          })
          .alignListItem(ListItemAlign.Center)
          .width('100%')
          .height('50%')
          .listDirection(Axis.Horizontal);
        } else {
          GridRow({
            columns: (this.questionItem.options.length / 2),
            gutter: { x: 5, y: 10 },
            breakpoints: {
              value: ['400vp', '600vp', '800vp'],
              reference: BreakpointsReference.WindowSize
            },
            direction: GridRowDirection.Row
          }) {
            ForEach(this.questionItem.options, (option: Option, index) => {
              GridCol() {
                Button(option.content)
                  .backgroundColor('#E86164')
                  .onClick(() => {
                    if (this.onAction) {
                      this.onAction(option.value);
                    }
                  });
              };
            }, (item: string, index: number) => item);
          };
        }
        Button() {
          Icon({
            icon: this.displayType ? Icons.three_dots : Icons.grid_3x2_gap_fill,
            iconSize: 30,
            iconColor: Color.White
          });
        }
        .backgroundColor($r('app.color.main_color'))
        .onClick(() => {
          this.displayType = !this.displayType;
        });
      } else if (this.questionItem.options.length === 3) {
        ForEach(this.questionItem.options, (option: Option, index: number) => {
          Button(option.content)
            .backgroundColor(index === 0 ? $r('app.color.main_color') :
              index === 1 ? $r('app.color.middle_choice') : $r('app.color.bottom_choice'))
            .scale({ x: 0.9, y: 0.9 })
            .width('85%')
            .onClick(() => {
              if (this.onAction) {
                this.onAction(option.value);
              }
            });
        }, (item: string, index: number) => item);
      } else {
        ForEach(this.questionItem.options, (option: Option, index) => {
          Button(option.content)
            .backgroundColor(index === 0 ? $r('app.color.main_color') : $r('app.color.light_main_color'))
            .scale({ x: 0.9, y: 0.9 })
            .width('100%')
            .border({ width: 0.1, color: $r('app.color.main_color') })
            .onClick(() => {
              if (this.onAction) {
                this.onAction(option.value);
              }
            });
        }, (item: string, index: number) => item);
      }
    }
    .height('100%')
    .justifyContent(FlexAlign.Center);

  }
}