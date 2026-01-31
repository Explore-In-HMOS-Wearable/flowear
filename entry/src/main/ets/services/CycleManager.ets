import { storage } from './Storage';

export class CycleManager {
  private static readonly KEY: string = 'cycle_base_date';

  static async getBaseDate(): Promise<Date | null> {
    const value = await storage.get(CycleManager.KEY);
    if (!value) {
      return null;
    }
    return new Date(Number(value));
  }

  static async setBaseDate(date: Date): Promise<void> {
    await storage.set(CycleManager.KEY, date.getTime().toString());
  }

  static async clear(): Promise<void> {
    await storage.set(CycleManager.KEY, '');
  }
}