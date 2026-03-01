import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PolymerizeWithItemModel } from '../model/HealthKit/PolymerizeWithItemModel';
import { SampleSet } from '../model/HealthKit/SampleSet';
import { SamplePoint } from '../model/HealthKit/SamplePoint';
import { HealthValue } from '../model/HealthKit/HealthValue';
import { sampleSet } from '../common/RCPConstants';
import { HealthDataResult } from '../model/HealthKit/HealthDataResult';
import { HealthResponse } from '../model/HealthKit/HeartResponse';
import { HealthGroup } from '../model/HealthKit/HealthGroup';
import taskpool from '@ohos.taskpool';

@Concurrent
function processRespTask(err: BusinessError, data: http.HttpResponse) {
  if (!err) {
    console.info(`Result: ${data.result}`);
    console.info(`code: ${data.responseCode}`);
    console.info(`type: ${JSON.stringify(data.resultType)}`);
    console.info(`header: ${JSON.stringify(data.header)}`);
    console.info(`cookies: ${data.cookies}`);
  } else {
    console.info(`error: ${JSON.stringify(err)}`);
  }
}

export abstract class BaseHealthService {
  protected abstract dataTypeName: string;

  protected abstract extractValue(value: HealthValue): number;

  protected abstract extractFieldName(value: HealthValue): string;

  async getData(
    accessToken: string,
    startTime: number,
    endTime: number
  ): Promise<HealthDataResult> {

    const response = await this.fetchResponse(accessToken, startTime, endTime);
    return this.mapResponse(response);
  }

  async getWeeklyData(
    accessToken: string,
    startDay: number,
    endDay: number
  ) {
    const response = await this.fetchWeeklyRespone(accessToken, startDay, endDay);
    const allData = this.mapWeeklyResponse(response);
    const result: HealthDataResult = {
      fields: [],
      values: [],
      times: [],
      total: 0
    };

    for (let i = 0; i < allData.fields.length; i++) {
      if (allData.fields[i] === 'avg') {
        result.fields.push(allData.fields[i]);
        result.values.push(allData.values[i]);
        result.times.push(allData.times[i]);
        result.total++;
      }
    }

    return result;
  }

  private async fetchWeeklyRespone(
    accessToken: string,
    startDay: number,
    endDay: number
  ): Promise<HealthResponse> {

    const httpRequest = http.createHttp();

    const body = JSON.stringify({
      polymerizeWith: [{ dataTypeName: this.dataTypeName }] as PolymerizeWithItemModel[],
      startDay,
      endDay
    });

    const headers: Record<string, string> = {
      'authorization': `Bearer ${accessToken}`,
      'contentType': 'application/json'
    };

    return new Promise((resolve, reject) => {
      httpRequest.request(
        sampleSet,
        {
          method: http.RequestMethod.POST,
          header: headers,
          extraData: body,
          expectDataType: http.HttpDataType.STRING
        },
        async (err: BusinessError, data: http.HttpResponse) => {
          const task = new taskpool.Task(processRespTask, data);
          await taskpool.execute(task);

          resolve(JSON.parse(data.result.toString()));
        }
      );
    });
  }

  private mapWeeklyResponse(response: HealthResponse): HealthDataResult {

    const values: number[] = [];
    const fields: string[] = [];
    const times: string[] = [];

    response.group.forEach((group: HealthGroup) => {
      group.sampleSet.forEach((set: SampleSet) => {
        set.samplePoints.forEach((point: SamplePoint) => {
          this.extractFromWeeklyPoint(point, fields, values, times);
        });
      });
    });

    const total = values.reduce((s, v) => s + v, 0);

    return {
      values,
      fields,
      times,
      total
    };
  }

  private async fetchResponse(
    accessToken: string,
    startTime: number,
    endTime: number
  ): Promise<HealthResponse> {

    const httpRequest = http.createHttp();

    const body = JSON.stringify({
      polymerizeWith: [{ dataTypeName: this.dataTypeName }] as PolymerizeWithItemModel[],
      startTime,
      endTime
    });

    const headers: Record<string, string> = {
      'authorization': `Bearer ${accessToken}`,
      'contentType': 'application/json'
    };

    return new Promise((resolve, reject) => {
      httpRequest.request(
        sampleSet,
        {
          method: http.RequestMethod.POST,
          header: headers,
          extraData: body,
          expectDataType: http.HttpDataType.STRING
        },
        async (err: BusinessError, data: http.HttpResponse) => {
          const task = new taskpool.Task(processRespTask, data);
          await taskpool.execute(task);

          resolve(JSON.parse(data.result.toString()));

        }
      );
    });
  }

  private mapResponse(response: HealthResponse): HealthDataResult {

    const values: number[] = [];
    const times: string[] = [];
    const fields: string[] = [];

    response.group.forEach((group: HealthGroup) => {
      group.sampleSet.forEach((set: SampleSet) => {
        set.samplePoints.forEach((point: SamplePoint) => {
          this.extractFromPoint(point, values, times);
        });
      });
    });

    const total = values.reduce((s, v) => s + v, 0);

    return {
      values,
      fields,
      times,
      total
    };
  }

  private extractFromWeeklyPoint(
    point: SamplePoint,
    fields: string[],
    values: number[],
    times: string[]
  ) {

    point.value.forEach((v: HealthValue) => {

      const start = new Date(this.nanoToMillis(point.startTime));
      const end = new Date(this.nanoToMillis(point.endTime));

      fields.push(this.extractFieldName(v));
      values.push(this.extractValue(v));

      times.push(start.toLocaleString());
      times.push(end.toLocaleString());
    });
  }

  private extractFromPoint(
    point: SamplePoint,
    values: number[],
    times: string[]
  ) {

    point.value.forEach((v: HealthValue) => {

      const start = new Date(this.nanoToMillis(point.startTime));
      const end = new Date(this.nanoToMillis(point.endTime));

      values.push(this.extractValue(v));

      times.push(start.toLocaleString());
      times.push(end.toLocaleString());
    });
  }

  private nanoToMillis(nano: number): number {
    return Math.floor(nano / 1_000_000);
  }
}
