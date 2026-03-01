import { ManualLoginViewModel } from '../viewmodel/ManualLoginViewModel';
import { APIConstants } from '../common/APIConstants';
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { Icon, Icons } from '@iakii/icons';

@Entry
@Component
export struct ManualLoginPage {
  @State shouldShowWebView: boolean = true;
  @State accessToken: string = '';
  @State activationKey: string = '';
  controller: webview.WebviewController = new webview.WebviewController();
  private viewModel = new ManualLoginViewModel();
  @Consume('NavPathStack') pageStack: NavPathStack;

  async aboutToAppear(): Promise<void> {
    try {
      console.info('enteredd');
      this.controller.zoomOut();
    } catch (error) {
      // TODO: Implement error handling.
    }
    const storedToken = await this.viewModel.getAccessTokenFromStorage();
    if (storedToken.length > 0) {
      this.accessToken = storedToken;
      this.shouldShowWebView = false;
    }
  }

  handleOAuthCode(code: string) {
    this.activationKey = code;
    this.shouldShowWebView = false;
    this.viewModel.postOAuthToken(code).then((token) => {
      if (token) {
        this.accessToken = token;
      }
    }).catch((e: BusinessError) => {
      console.error('Token exchange failed:', e);
    });
  }

  build() {
    NavDestination() {
      Column() {
        if (this.shouldShowWebView) {
          Web({ src: APIConstants.AUTH_URL, controller: this.controller })
            .width('100%')
            .height('100%')
            .zoomAccess(true)
            .onLoadIntercept((event) => {
              if (event) {
                const url = event.data.getRequestUrl();
                console.info(`URL: ${url}`);
                const code = this.viewModel.getQueryParameter(url, 'code');
                if (code) {
                  console.info(`Code received from redirect: ${code}`);
                  this.handleOAuthCode(code);
                }
              }
              return false;
            });
          Button() {
            Icon({ icon: Icons.arrow_left_short, iconSize: 30, iconColor: Color.White });
          }
          .backgroundColor($r('app.color.main_color'))
          .onClick(() => {
            this.pageStack.pop();
          });
        } else {
          Column() {
            Text('Access Token is:')
              .fontSize(14)
              .height('20%')
              .width('100%')
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center);
            Text(this.accessToken)
              .fontSize(14)
              .height('30%')
              .width('100%')
              .fontColor(Color.Red);
          }
          .height('100%')
          .width('100%');
        }
      }
      .height('90%')
      .width('100%');
    }
    .backgroundColor($r('app.color.background_color'))
    .hideBackButton(true);
  }
}