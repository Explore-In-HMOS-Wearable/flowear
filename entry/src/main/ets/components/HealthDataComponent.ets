@Component
export struct HealthDataComponent {
  @Prop text: string;
  @Prop image: Resource;

  build() {
    Column() {
      Image(this.image).size({ width: 140, height: 140 });
      Text(this.text).fontColor(Color.Black);
    }
    .justifyContent(FlexAlign.Center);
  }
}