import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { LoginViewModel } from '../viewmodel/LoginViewModel';
import { healthStore } from '@kit.HealthServiceKit';
import { common } from '@kit.AbilityKit';
import { PromptAction } from '@kit.ArkUI';

@Component
export struct LoginPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();
  promptAction: PromptAction = this.uiContext.getPromptAction();
  private viewModel = new LoginViewModel();
  @State isLoading: boolean = false;

  async healthInit() {
    try {
      await healthStore.init(this.getUIContext().getHostContext());
      console.info('testTag', 'Succeeded in initializing.');
    } catch (err) {
      console.error('testTag', `Failed to init. Code: ${err.code}, message: ${err.message}`);
    }
  }

  async initializeHealthAccess() {
    const authorizationParameter: healthStore.AuthorizationRequest = {
      readDataTypes: [healthStore.healthDataTypes.HEART_RATE, healthStore.samplePointHelper.heartRate.DATA_TYPE],
      writeDataTypes: [healthStore.exerciseSequenceHelper.DATA_TYPE, healthStore.samplePointHelper.heartRate.DATA_TYPE]
    };

    try {
      const authorizationResponse =
        await healthStore.requestAuthorizations(this.getUIContext().getHostContext() as common.UIAbilityContext,
          authorizationParameter);

      console.info('testTag', '2Succeeded in requesting authorization.');
      authorizationResponse.writeDataTypes.forEach(dataType => {
        console.info('testTag', `2grantedWriteDataType is : ${dataType.name}`);
      });
      authorizationResponse.readDataTypes.forEach(dataType => {
        console.info('testTag', `2grantedReadDataTypes is : ${dataType.name}`);
      });
      this.isLoading = false;
      this.showToast('health successful');
    } catch (err) {
      this.isLoading = false;
      this.showToast('health error');
      console.error('testTag', `2Failed to request authorization. Code: ${err.code}, message: ${err.message}`);
    }
  }

  dealAllError(error: BusinessError): void {
    console.error('testTag', `Failed to login. Code: ${error.code}, message: ${error.message}`);
    this.isLoading = false;
    this.showToast(error.message);
  }

  showToast(text: string) {
    this.promptAction.openToast({
      message: text,
      duration: 3000
    })
      .catch((error: BusinessError) => {
        console.error(`openToast error code is ${error.code}, message is ${error.message}`);
      })
      .finally(() => {
        console.error(`openToast finished`);
      });
  }

  @Builder
  showLoginStatus() {
    LoadingProgress()
      .color($r('app.color.main_color'))
      .size({ width: 25, height: 25 })
      .visibility(this.isLoading ? Visibility.Visible : Visibility.None);
  }

  async doHuaweiLogin() {
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    loginRequest.forceLogin = true;
    loginRequest.state = util.generateRandomUUID();
    try {
      const controller = new authentication.AuthenticationController(this.getUIContext().getHostContext());
      controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
        const loginWithHuaweiIDResponse = response as authentication.LoginWithHuaweiIDResponse;
        const state = loginWithHuaweiIDResponse.state;
        if (state && loginRequest.state !== state) {
          console.error('testTag', `Failed to login. The state is different, response state: ${state}`);
          return;
        }
        console.info('testTag', 'Succeeded in logging in.');
        const loginWithHuaweiIDCredential = loginWithHuaweiIDResponse?.data;
        const code = loginWithHuaweiIDCredential?.authorizationCode;
        console.info('testTag', `authCode is: ${code}`);
        if (code !== undefined) {
          this.showToast('Login successful');
          this.healthInit();
          this.initializeHealthAccess();
          this.viewModel.postOAuthToken(code).then((token) => {
            console.info('testTag', `postAuth: ${token}`);
          }).catch((e: BusinessError) => {
            console.error('Token exchange failed:', e);
          });
        }
      }).catch((error: BusinessError) => {
        this.dealAllError(error);
      });
    } catch (error) {
      this.dealAllError(error);
    }
  }

  build() {
    NavDestination() {
      Stack() {
        Stack() {
          this.showLoginStatus();
        }
        .width('100%')
        .height('20%')
        .align(Alignment.Bottom);

        Column({ space: 16 }) {
          Text('Welcome to Flowear')
            .fontColor($r('app.color.main_color'));
          Button('Log in with HUAWEI ID')
            .backgroundColor('#CE0E2D')
            .fontSize(14)
            .onClick(() => {
              this.isLoading = true;
              this.doHuaweiLogin();
            });
          Button('Login Manually')
            .backgroundColor($r('app.color.main_color'))
            .fontSize(14)
            .onClick(() => {
              this.pageStack.pushPathByName('ManualLoginPage', null);
            });
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .padding(20);
      }
      .align(Alignment.Top);

    }
    .backgroundColor($r('app.color.background_color'))
    .hideTitleBar(true);
  }
}