import { authentication } from '@kit.AccountKit';
import { promptAction, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
export struct LoginPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  uiContext = this.getUIContext();

  async doHuaweiLogin() {
    try {
      const huaweiIdProvider = new authentication.HuaweiIDProvider();
      const authRequest = huaweiIdProvider.createAuthorizationWithHuaweiIDRequest();
      authRequest.scopes = ['openid'];
      const authController = new authentication.AuthenticationController(this.uiContext?.getHostContext());
      const response: authentication.AuthorizationWithHuaweiIDResponse =
        await authController.executeRequest(authRequest);
      const authCode: string | undefined = response.data?.authorizationCode;
      const openId: string | undefined = response.data?.openID;
      const idToken: string | undefined = response.data?.idToken;
      const unionId: string | undefined = response.data?.unionID;
      console.info('login', 'Login successful!');
      console.info('login_page', `Authorization Code: ${authCode}`);
      console.info('login_page', `OpenID: ${openId}`);
      console.info('login_page', `ID Token: ${idToken}`);
      console.info('login_page', `UnionID: ${unionId}`);
      this.onLoginSuccess(authCode, openId, idToken, unionId);

    } catch (err) {
      const e = err as BusinessError;
      console.error('login_page', `error code is: ${e.code}`);
      console.error('login_page', `error message is: ${e.message}`);
    }
  }

  onLoginSuccess(authCode: string | undefined, openId: string | undefined, idToken: string | undefined,
    unionId: string | undefined) {
  }

  build() {
    NavDestination() {
      Column({ space: 16 }) {
        Text('Welcome to Flowra')
          .fontColor($r('app.color.main_color'))
        Button('HUAWEI ID Instant Login')
          .backgroundColor($r('app.color.main_color'))
          .fontSize(14)
          .onClick(() => this.doHuaweiLogin());
        Button('Login Manually')
          .backgroundColor($r('app.color.main_color'))
          .fontSize(14)
          .onClick(() => {
            this.pageStack.pushPathByName('ManualLoginPage', null);
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .padding(20);
    }
    .backgroundColor(Color.White)
    .hideTitleBar(true)
  }
}