import { SymptomMoodQuestions } from '../datasource/SymptomsMoodQuestions';
import { SymptomQuestionModel } from '../model/SymptomQuestionModel';
import { storage } from '../services/Storage';

export class SymptomsMoodViewModel {
  private questionDataSource = new SymptomMoodQuestions();
  private questions: SymptomQuestionModel[] = this.questionDataSource.setQuestions();

  getQuestions(): SymptomQuestionModel[] {
    return this.questions;
  }

  async saveMoodValue(newMoodValue: number) {
    await storage.set('moodValue', newMoodValue.toString());
  }
}
