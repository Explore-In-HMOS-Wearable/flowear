import { BaseHealthService } from '../services/BaseHealthService';
import { HealthValue } from '../model/HealthKit/HealthValue';

export class BodyTempViewModel extends BaseHealthService {
  protected dataTypeName = 'com.huawei.continuous.body.temperature.statistics';

  protected extractFieldName(value: HealthValue): string {
    return value.fieldName;
  }

  protected extractValue(value: HealthValue): number {
    return value.floatValue;
  }

  async getLatestBodyTemp(
    accessToken: string,
    startTime: number,
    endTime: number
  ): Promise<number> {

    const result = await this.getData(accessToken, startTime, endTime);

    if (!result.values.length) {
      return 0;
    }
    const latestHeartRate = result.values[result.values.length - 1];

    return latestHeartRate ?? 0;
  }

  async getWeeklyBodyTemp(
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