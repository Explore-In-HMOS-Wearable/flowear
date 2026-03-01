import { storage } from '../services/Storage';

export class HealthDataViewModel {
  moodValue: number = 0;

  async updateMoodValue(): Promise<number> {
    const v = await storage.get('moodValue');
    const valueToNum: number = Number(v);
    this.moodValue = Number.isNaN(valueToNum) ? 0 : valueToNum;
    console.info(`new current moodValue ${this.moodValue}`);
    return this.moodValue;
  }

  async getAccessTokenFromStorage(): Promise<string> {
    const token = (await storage.get('accessToken')) ?? '';
    return token;
  }

  updateCurrentStressStatus(moodLevel: number): string {
    const status = `Stress level: ${moodLevel >= 90 ? 'Happy' :
      moodLevel >= 60 ? 'Calm' : moodLevel >= 40 ? 'On Edge' : 'Very Stressful'}`;
    return status;
  }
}
