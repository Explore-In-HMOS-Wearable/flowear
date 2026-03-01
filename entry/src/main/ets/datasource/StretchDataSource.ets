import { StretchModel } from '../model/StretchModel';

export class StretchDataSource {
  static exerciseList: StretchModel[] =
    [{
      imageArray: [{ src: $r('app.media.stretch_1') }, { src: $r('app.media.stretch_1_rev') }],
      exerciseDesc: 'Just start with basic stretch\nfor your arm'
    }];
}
