@Component
export struct ButtonComponent {
  @Prop text: string;

  build() {
    Button(this.text)
      .width('70%')
      .height(40)
      .fontSize(14)
      .fontWeight(FontWeight.Medium)
      .backgroundColor('#243A6A')
      .borderRadius(22)
  }
}