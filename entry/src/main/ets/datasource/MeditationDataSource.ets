import { MeditationModel } from '../model/MeditationModel';

const filteredExercises: Record<string, MeditationModel[]> = {
  'zero': [
    {
      name: 'Breath',
      desc: 'Make your good day better',
      icon: $r('app.media.heart'),
      route: ''
    },
    {
      name: 'Stretch',
      desc: 'Stay flexible and strong',
      icon: $r('app.media.heart'),
      route: ''
    }
  ],
  'one': [
    {
      name: 'Breath',
      desc: 'Catch your breath before start your day',
      icon: $r('app.media.heart'),
      route: 'BreatheExercise'
    }
  ],
  'two': [
    {
      name: 'Meditation',
      desc: 'Get Ready for the day',
      icon: $r('app.media.heart'),
      route: ''
    },
    {
      name: 'Stretch',
      desc: 'More exercise less ache',
      icon: $r('app.media.heart'),
      route: ''
    }
  ],
  'three': [
    {
      name: 'Meditation',
      desc: 'You are not good, please rest',
      icon: $r('app.media.heart'),
      route: ''
    }
  ]
};

export function setExercises(moodStage: number): MeditationModel[] {
  const textStage = moodStage === 0 ? 'zero' : moodStage === 1 ? 'one' : moodStage === 2 ? 'two' : 'three';
  return filteredExercises[textStage] ?? [];
}