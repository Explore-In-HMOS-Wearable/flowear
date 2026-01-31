import { SymptomQuestionModel } from '../model/SymptomQuestionModel';

export class SymptomMoodQuestions {
  private moodQuestions: SymptomQuestionModel[];

  constructor() {
    this.moodQuestions = this.setQuestions();
  }

  setQuestions(): SymptomQuestionModel[] {
    const questionList: SymptomQuestionModel[] = [
      {
        question: 'How do you feel?',
        options: [
          {
            content: '\u{1F929}',
            value: -10
          },
          {
            content: `\u{1F970}`,
            value: 0
          },
          {
            content: '\u{1F642}',
            value: 10
          },
          {
            content: '\u{1F610}',
            value: 15
          },
          {
            content: '\u{1F614}',
            value: 20
          },
          {
            content: '\u{1F623}',
            value: 25
          }]
      },
      {
        question: 'Do you have stomach ache?',
        options: [
          {
            content: 'Yes',
            value: 20
          },
          {
            content: 'No',
            value: 0
          }]
      },
      {
        question: 'Do you have fever?',
        options: [
          {
            content: 'I\'m burning',
            value: 15
          },
          {
            content: 'Little',
            value: 5
          },
          {
            content: 'Nope',
            value: 0
          }]
      },
      {
        question: 'Any pain on chest?',
        options: [
          {
            content: 'Hurts very much',
            value: 15
          },
          {
            content: 'Little',
            value: 5
          },
          {
            content: 'Nope',
            value: 0
          }
        ]
      }
    ];
    return questionList;
  }

  getQuestions(): SymptomQuestionModel[] {
    return this.moodQuestions;
  }
}