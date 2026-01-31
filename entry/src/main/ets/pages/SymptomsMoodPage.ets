import { MoodQuestionComponent } from '../components/MoodQuestionComponent';
import { SymptomsMoodViewModel } from '../viewmodel/SymptomsMoodViewModel';

@Component
export struct SymptomsMoodPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  private viewModel: SymptomsMoodViewModel = new SymptomsMoodViewModel();
  @State shouldShowQuiz: boolean = false;
  @State moodValue: number = 100;
  @State questionIndex: number = 0;
  private questionList = this.viewModel.getQuestions();

  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
  }

  build() {
    NavDestination() {
      if (this.shouldShowQuiz) {
        MoodQuestionComponent({
          questionItem: this.questionList[this.questionIndex],
          onAction: (optionValue: number) => {
            this.moodValue = this.moodValue - optionValue;
            if (this.questionIndex !== this.questionList.length - 1) {
              this.questionIndex += 1;
            } else {
              this.viewModel.saveMoodValue(this.moodValue);
              this.pageStack.pop();
            }
          }
        })
      } else {
        Column() {
          Text(`Let's Check How You Are`)
            .fontColor(Color.Black)
          Blank().height(15)
          Button('Start')
            .backgroundColor('#E86164')
            .onClick(() => {
            this.shouldShowQuiz = true;
          })
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}

