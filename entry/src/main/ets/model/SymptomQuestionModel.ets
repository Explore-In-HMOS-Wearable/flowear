export interface SymptomQuestionModel {
  question: string,
  options: Option[]
}

export interface Option {
  content: string,
  value: number
}

export const defaultSymptomQuestion: SymptomQuestionModel = {
  question: '',
  options: []
};