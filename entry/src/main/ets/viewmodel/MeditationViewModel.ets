import { MeditationModel } from '../model/MeditationModel';
import { setExercises } from '../datasource/MeditationDataSource';
import { storage } from '../services/Storage';

export class MeditationViewModel {
  accessToken: string = '';
  activationKey: string = '';
  exercises: MeditationModel[] = [{
    name: '',
    desc: '',
    icon: '',
    route: ''
  }];

  moodStage: number = 0;
  moodValue: number = 0;

  async updateMoodValue(): Promise<number> {
    const v = await storage.get('moodValue');
    const valueToNum: number = Number(v);
    this.moodValue = Number.isNaN(valueToNum) ? 0 : valueToNum;
    console.info(`new current moodValue ${this.moodValue}`);
    return this.moodValue;
  }

  checkMoodValue(): boolean {
    const v = storage.has('moodValue');
    return v ? v : false;
  }

  updateSuggestionText(moodLevel: number): string {
    const suggestion = moodLevel >= 90 ? 'You look fabulous\nGet even better' :
      moodLevel >= 60 ? 'You need recharge\n Be ready for day' :
        moodLevel >= 40 ? 'Not looking good\n Recover very fast' :
          'You look awful\nRest or go hospital';
    return suggestion;
  }

  getExercises(moodLevel: number): MeditationModel[] {
    this.moodStage = moodLevel >= 90 ? 0 : moodLevel >= 60 ? 1 : moodLevel >= 40 ? 2 : 3;
    this.exercises = setExercises(this.moodStage);
    return this.exercises;
  }
}
