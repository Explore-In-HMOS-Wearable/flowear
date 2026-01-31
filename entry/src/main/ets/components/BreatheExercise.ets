const TEXT_TITLE = 'Breathing Exercise';
const TEXT_START_BUTTON = 'Start';
const TEXT_PREPARE = 'Ready';
const TEXT_BREATH_IN = 'Breathe';
const TEXT_HOLD = 'Hold';
const TEXT_BREATH_OUT = 'Release';
const TEXT_STOP_BUTTON = 'Stop';
const TEXT_COMPLETED = 'Completed!';
const TEXT_RESTART_BUTTON = 'Again';
const TEXT_SECONDS = 'seconds';
const TEXT_CHECKMARK = '✓';

@Component
export struct BreatheExercise {
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State isStarted: boolean = false;
  @State countdown: number = 3;
  @State isExercising: boolean = false;
  @State isExerciseCompleted: boolean = false;
  @State breathPhase: string = TEXT_BREATH_IN;
  @State isExpanding: boolean = false;
  @State exerciseCount: number = 0;
  private totalCycles: number = 5;
  @State phaseTimer: number = 0;
  private countdownTimer: number = -1;
  private breathTimer: number = -1;
  private phaseInterval: number = -1;

  startCountdown() {
    this.isStarted = true;
    this.countdown = 3;

    this.countdownTimer = setInterval(() => {
      this.countdown--;
      if (this.countdown === 0) {
        clearInterval(this.countdownTimer);
          this.startExercise();
      }
    }, 1000);
  }

  startExercise() {
    this.isExercising = true;
    this.exerciseCount = 0;
    this.breathCycle();
  }

  breathCycle() {
    if (this.exerciseCount >= this.totalCycles) {
      this.finishExercise();
      return;
    }

    this.breathPhase = TEXT_BREATH_IN;
    this.isExpanding = true;
    this.phaseTimer = 4;
    this.startPhaseTimer();

    setTimeout(() => {
      this.breathPhase = TEXT_HOLD;
      this.phaseTimer = 4;
      this.startPhaseTimer();

      setTimeout(() => {
        this.breathPhase = TEXT_BREATH_OUT;
        this.isExpanding = false;
        this.phaseTimer = 4;
        this.startPhaseTimer();

        setTimeout(() => {
          this.exerciseCount++;
          this.breathCycle();
        }, 4000);
      }, 4000);
    }, 4000);
  }

  startPhaseTimer() {
    if (this.phaseInterval !== -1) {
      clearInterval(this.phaseInterval);
      this.phaseInterval = -1;
    }

    this.phaseInterval = setInterval(() => {
      this.phaseTimer--;
      if (this.phaseTimer <= 0) {
        clearInterval(this.phaseInterval);
        this.phaseInterval = -1;
      }
    }, 1000);
  }

  finishExercise() {
    this.isExercising = false;
    this.isExerciseCompleted = true;
    this.breathPhase = TEXT_COMPLETED;
    clearInterval(this.phaseInterval);
  }

  resetExercise() {
    clearInterval(this.countdownTimer);
    clearInterval(this.breathTimer);
    clearInterval(this.phaseInterval);
    this.isStarted = false;
    this.isExercising = false;
    this.isExerciseCompleted = false;
    this.countdown = 3;
    this.exerciseCount = 0;
    this.breathPhase = TEXT_BREATH_IN;
    this.isExpanding = false;
    this.phaseTimer = 0;
  }

  build() {
    NavDestination() {
      Stack() {
        if (!this.isStarted) {
          Column() {
            Text(TEXT_TITLE)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 30 })
              .fontColor('#ffae1c1c')

            Button(TEXT_START_BUTTON)
              .fontSize(20)
              .width(100)
              .height(35)
              .onClick(() => {
                this.startCountdown();
              })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F5F5F5')

        } else if (this.countdown > 0) {
          Column() {
            Text(TEXT_PREPARE)
              .fontSize(20)
              .opacity(0.7)
              .margin({ bottom: 30 })
              .fontColor('#000')

            Text(this.countdown.toString())
              .fontSize(100)
              .fontWeight(FontWeight.Bold)
              .fontColor('#007DFF')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F5F5F5')

        } else if (this.isExercising) {
          Stack() {
            Particle({
              particles: [
                {
                  emitter: {
                    particle: {
                      type: ParticleType.POINT,
                      config: {
                        radius: 1
                      },
                      count: 1000,
                      lifetime: -1,
                      lifetimeRange: 0
                    },
                    emitRate: 1000,
                    shape: ParticleEmitterShape.CIRCLE,
                    position: [0, 0]
                  },
                  color: {
                    range: [
                      this.breathPhase === TEXT_BREATH_IN ? Color.Green :
                        this.breathPhase === TEXT_HOLD ? Color.Orange : Color.Blue,
                      this.breathPhase === TEXT_BREATH_IN ? Color.Green :
                        this.breathPhase === TEXT_HOLD ? Color.Orange : Color.Blue
                    ],
                    updater: {
                      type: ParticleUpdater.CURVE,
                      config: [
                        {
                          from: this.breathPhase === TEXT_BREATH_IN ? Color.Green :
                            this.breathPhase === TEXT_HOLD ? Color.Orange : Color.Blue,
                          to: this.breathPhase === TEXT_BREATH_IN ? Color.Green :
                            this.breathPhase === TEXT_HOLD ? Color.Orange : Color.Blue,
                          startMillis: 0,
                          endMillis: 4000,
                          curve: this.isExpanding ? Curve.EaseOut : Curve.EaseIn
                        }
                      ]
                    }
                  },
                  acceleration: {
                    speed: {
                      range: [0, 0],
                      updater: {
                        type: ParticleUpdater.RANDOM,
                        config: [1, 1]
                      }
                    },
                    angle: {
                      range: [0, 360]
                    }
                  }
                }
              ]
            })
              .width(300)
              .height(300)
              .disturbanceFields([{
                strength: this.isExpanding ? 100 : -100,
                shape: DisturbanceFieldShape.CIRCLE,
                size: { width: 200, height: 200 },
                position: { x: 150, y: 150 },
                feather: 0,
                noiseScale: 1,
                noiseFrequency: 1,
                noiseAmplitude: 1
              }])

            Column() {
              Text(`${this.exerciseCount + 1} / ${this.totalCycles}`)
                .fontSize(16)
                .opacity(0.5)
                .margin({ top: 30, bottom: 10 })
                .fontColor('#000')

              Text(this.breathPhase)
                .fontSize(32)
                .fontWeight(FontWeight.Bold)
                .fontColor(
                  this.breathPhase === TEXT_BREATH_IN ? '#4CAF50' :
                    this.breathPhase === TEXT_HOLD ? '#FF9800' : '#2196F3'
                )
                .margin({ bottom: 5 })

              Text(`${this.phaseTimer} ${TEXT_SECONDS}`)
                .fontSize(18)
                .opacity(0.6)
                .fontColor('#000')
            }
            .width('100%')
            .position({ x: 0, y: 0 })

            Button(TEXT_STOP_BUTTON)
              .fontSize(16)
              .width(100)
              .height(35)
              .backgroundColor('#F44336')
              .position({ x: '50%', y: '80%' })
              .translate({ x: '-50%', y: '-50%' })
              .onClick(() => {
                this.resetExercise();
              })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#FFFFFF')

        } else if (this.isExerciseCompleted && this.isStarted ) {
          Column() {
            Text(TEXT_CHECKMARK)
              .fontSize(50)
              .fontColor('#4CAF50')
              .margin({ bottom: 20 })

            Text(TEXT_COMPLETED)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 30 })
              .fontColor('#000')

            Button(TEXT_RESTART_BUTTON)
              .fontSize(18)
              .width(100)
              .height(40)
              .onClick(() => {
                this.resetExercise();
              })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F5F5F5')
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}