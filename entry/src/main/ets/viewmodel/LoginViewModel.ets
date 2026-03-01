import { APIConstants } from '../common/APIConstants';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { TokenResponse } from '../model/TokenResponse';
import { AUTH_URL } from '../lib/Constants';
import taskpool from '@ohos.taskpool';
import { processRespTask } from '../common/ProcessRespTask';
import { storage } from '../services/Storage';

export class LoginViewModel {
  accessToken: string = '';
  activationKey: string = '';

  async postOAuthToken(code: string): Promise<string | null> {
    const httpRequest = http.createHttp();
    const body =
      'grant_type=authorization_code' +
        `&code=${encodeURIComponent(code)}` +
        `&client_id=${encodeURIComponent(APIConstants.CLIENT_ID)}` +
        `&client_secret=${encodeURIComponent(APIConstants.CLIENT_SECRET)}` +
        `&redirect_uri=${encodeURIComponent(APIConstants.REDIRECT_URL)}`;
    return new Promise((resolve, reject) => {
      httpRequest.request(
        AUTH_URL,
        {
          method: http.RequestMethod.POST,
          header: {
            'contentType': 'application/x-www-form-urlencoded'
          },
          extraData: body,
          expectDataType: http.HttpDataType.STRING
        },
        async (err: BusinessError, data) => {
          const task = new taskpool.Task(processRespTask, [err, data]);
          await taskpool.execute(task);

          let parsed: TokenResponse | null = null;

          if (typeof data.result === 'string') {
            try {
              parsed = JSON.parse(data.result) as TokenResponse;
            } catch (e) {
              console.error('JSON parse failed:', e);
              resolve(null);
              return;
            }
          } else if (typeof data.result === 'object') {
            parsed = data.result as TokenResponse;
          }
          if (parsed?.accessToken && parsed?.refreshToken) {
            this.saveTokens(parsed.accessToken, parsed.refreshToken);
            resolve(parsed.accessToken);
          } else {
            console.error('Token parse error or missing fields:', parsed);
            resolve(null);
          }
        }
      );
    });
  }

  async saveTokens(accessToken: string, refreshToken: string) {
    await storage.set('accessToken', accessToken);
    await storage.set('refreshToken', refreshToken);
    this.accessToken = accessToken;
  }
}