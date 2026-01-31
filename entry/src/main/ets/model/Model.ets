import { RouteConstants } from '../common/RouteConstants';
import { Icons } from '@iakii/icons';

export class Model {
  index: number;
  icn: string;
  name: String;
  route: string;

  constructor(index: number, icn: string, name: string, route: string) {
    this.index = index;
    this.icn = icn;
    this.name = name;
    this.route = route;
  }
}

const datas: Model[] = [
  new Model(0, Icons.calendar_date, 'Calendar', RouteConstants.CALENDAR_VIEW),
  new Model(1, Icons.heart_pulse, 'Meditations', RouteConstants.MEDITATIONS_PAGE),
  new Model(3, Icons.hearts, 'Health Data', RouteConstants.HEALTH_DATA_PAGE),
  new Model(4, Icons.h_square, 'Symptoms & Mood', RouteConstants.SYMPTOMS_MOOD_PAGE),
  new Model(5, Icons.graph_up, 'Sleep Chart', RouteConstants.SLEEP_CHART_PAGE),
  new Model(6, Icons.chat_heart, 'Suggestion for Your Body', RouteConstants.SUGGESTION_PAGE),
  new Model(7, Icons.clock_history, 'Historical Data', RouteConstants.HISTORY_PAGE)
];

export { datas };