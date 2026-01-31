import { Icons } from '@iakii/icons';

export class SuggestionBodyModel {
  index: number;
  icon: string;
  text: string;

  constructor(index: number, icon: string, text: string) {
    this.index = index;
    this.icon = icon;
    this.text = text;
  }
}

const suggestionBodyDatas: SuggestionBodyModel[] = [
  new SuggestionBodyModel(
    0,
    Icons.heart_pulse,
    `Listen to your body when it asks for rest, because slowing down is not a failure but a necessary part of healing.`
  ),
  new SuggestionBodyModel(
    1,
    Icons.activity,
    `Move your body gently and with intention, choosing care over pressure and patience over force.`
  ),
  new SuggestionBodyModel(
    2,
    Icons.heart,
    `Respect the signals your body sends you, even when they ask you to pause or slow down.`
  ),
  new SuggestionBodyModel(
    3,
    Icons.apple,
    `Nourish your body consistently, knowing that small daily choices build long-term balance.`
  ),
  new SuggestionBodyModel(
    4,
    Icons.leaf,
    `Allow your body to change naturally, without judgment or unrealistic expectations.`
  ),
  new SuggestionBodyModel(
    5,
    Icons.wind,
    `Breathe deeply and give your body moments of stillness throughout the day.`
  ),
  new SuggestionBodyModel(
    6,
    Icons.arrow_bar_down,
    `Treat your body as a partner, not a problem that needs to be fixed.`
  ),
  new SuggestionBodyModel(
    7,
    Icons.cloud_arrow_down_fill,
    `Trust that rest, movement, and nourishment work together to support your wellbeing.`
  )
];

export { suggestionBodyDatas };