import { RouteConstants } from '../common/RouteConstants';
import { CalendarView } from './CalendarView';
import { HealthDataPage } from './HealthDataPage';
import { HistoryPage } from './HistoryPage';
import { HomePage } from './HomePage';
import { LoginPage } from './LoginPage';
import { ManualLoginPage } from './ManualLoginPage';
import { MeditationPage } from './MeditationPage';
import { SleepChartPage } from './SleepChartPage';
import { SuggestionBodyPage } from './SuggestionBodyPage';
import { SymptomsMoodPage } from './SymptomsMoodPage';
import { BreatheExercise } from '../components/BreatheExercise';

@Entry
@Component
struct Index {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  @Builder
  _pagesMap(name: string) {
    if (name === RouteConstants.CALENDAR_VIEW) {
      CalendarView()
    } else if (name === RouteConstants.LOGIN_PAGE) {
      LoginPage()
    } else if (name === RouteConstants.MANUAL_LOGIN_PAGE) {
      ManualLoginPage()
    } else if (name === RouteConstants.HEALTH_DATA_PAGE) {
      HealthDataPage()
    } else if (name === RouteConstants.MEDITATIONS_PAGE) {
      MeditationPage()
    } else if (name === RouteConstants.SUGGESTION_PAGE) {
      SuggestionBodyPage()
    } else if (name === RouteConstants.SYMPTOMS_MOOD_PAGE) {
      SymptomsMoodPage()
    } else if (name === RouteConstants.SLEEP_CHART_PAGE) {
      SleepChartPage()
    } else if (name === RouteConstants.HISTORY_PAGE) {
      HistoryPage()
    } else if (name === RouteConstants.BREATHE_PAGE) {
      BreatheExercise()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Swiper() {
        LoginPage()
        CalendarView()
        HomePage()
      }
      .backgroundColor(Color.White)
    }
    .height('100%')
    .width('100%')
    .hideTitleBar(true)
    .navDestination(this._pagesMap)
    .hideBackButton(true)
    .ignoreLayoutSafeArea()
  }
}