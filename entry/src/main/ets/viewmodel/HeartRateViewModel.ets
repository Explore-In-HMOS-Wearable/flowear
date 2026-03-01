import { BaseHealthService } from '../services/BaseHealthService';
import { HealthValue } from '../model/HealthKit/HealthValue';

export class HeartRateViewModel extends BaseHealthService {
  protected dataTypeName = 'com.huawei.continuous.heart_rate.statistics';

  protected extractFieldName(value: HealthValue): string {
    return value.fieldName;
  }

  protected extractValue(value: HealthValue): number {
    return value.floatValue;
  }

  async getLatestHeartRate(
    accessToken: string,
    startTime: number,
    endTime: number
  ): Promise<number> {

    const result = await this.getData(accessToken, startTime, endTime);

    if (!result.values.length) {
      return 0;
    }
    const latestHeartRate = result.values[result.values.length - 1]; // latest hr

    return latestHeartRate ?? 0;
  }

  async getWeeklyHeartRate(
    accessToken: string,
    startTime: number,
    endTime: number
  ): Promise<number[]> {
    const result = await this.getWeeklyData(accessToken, startTime, endTime);

    if (!result.values.length) {
      return [];
    }

    return result.values;
  }
}