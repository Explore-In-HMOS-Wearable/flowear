import { Option, SymptomQuestionModel } from '../model/SymptomQuestionModel';

@Component
export struct MoodQuestionComponent {
  @Prop questionItem: SymptomQuestionModel;
  onAction?: (value: number) => void;
  scroller: Scroller = new Scroller();

  build() {
    Column({ space: 7 }) {
      Text(this.questionItem.question)
        .fontColor(Color.Black)
      if (this.questionItem.options.length > 3) {
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
                })
            }
          }, (item: string, index: number) => item)
        }
      } else {
        ForEach(this.questionItem.options, (option: Option, index) => {
          Button(option.content)
            .backgroundColor('#E86164')
            .scale({ x: 0.9, y: 0.9 })
            .onClick(() => {
              if (this.onAction) {
                this.onAction(option.value);
              }
            })
        }, (item: string, index: number) => item)
      }
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)

  }
}