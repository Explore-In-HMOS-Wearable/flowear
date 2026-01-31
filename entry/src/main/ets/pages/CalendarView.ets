import { CustomContentDialog } from '@kit.ArkUI';
import { getMonth, getNextDate, getPreviousDate, getYear } from '../lib/Utils';
import { YearMonthSelector } from './YearMonthSelector';
import { WEEK_DAYS } from '../lib/Constants';
import { ListDataSource } from '../services/ListDataSource';
import dayjs from 'dayjs';
import { CycleManager } from '../services/CycleManager';

@Component
export struct CalendarView {
  private selectedStartDay: number | null = null;
  @State selectionBaseDate: Date | null = null;
  private showConfirm: boolean = false;
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State loading: boolean = true;
  @State currentDate: Date = new Date();
  @State month: string = getMonth(this.currentDate.getTime());
  @State year: string = getYear(this.currentDate.getTime());
  private days: ListDataSource<MonthDay> = new ListDataSource<MonthDay>();
  private context: UIContext = this.getUIContext();
  private dialogController: CustomDialogController = new CustomDialogController({
    cornerRadius: '50%',
    width: '100%',
    height: '100%',
    builder: CustomContentDialog({
      primaryTitle: 'Select Year',
      contentBuilder: () => {
        this.buildContent();
      }
    })
  });

  private confirmDialog: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.confirmDialogBuilder();
      }
    })
  });

  aboutToAppear(): void {
    CycleManager.getBaseDate().then((date) => {
      if (date) {
        this.selectionBaseDate = date;
      }

      this._computedCurrentMonthDays(this.currentDate).then((days) => {
        this.loading = false;
        this.days.resetData();
        days.forEach(d => this.days.pushData(d));
        this._applySelection();
      });
    });
  }

  private async _computedCurrentMonthDays(date: Date): Promise<MonthDay[]> {
    const days: MonthDay[] = [];
    const today = new Date();

    const baseDate = new Date(date.getTime());
    const dayjsDate = dayjs(baseDate);

    const daysInMonth = dayjsDate.daysInMonth();
    const firstDayIndex = dayjsDate.startOf('month').day();

    for (let i = 0; i < firstDayIndex; i++) {
      days.push({
        index: 0,
        dayIndex: i as 0 | 1 | 2 | 3 | 4 | 5 | 6,
        isNotCurrent: true,
        hasEvents: false,
        isToday: false
      });
    }

    const currentDate = new Date(baseDate.getFullYear(), baseDate.getMonth(), 1);

    for (let index = 1; index <= daysInMonth; index++) {
      currentDate.setDate(index);

      const isToday =
        currentDate.getDate() === today.getDate() &&
          currentDate.getMonth() === today.getMonth() &&
          currentDate.getFullYear() === today.getFullYear();

      days.push({
        index,
        dayIndex: dayjs(currentDate).day() as 0 | 1 | 2 | 3 | 4 | 5 | 6,
        isNotCurrent: false,
        hasEvents: false,
        isToday
      });
    }

    return days;
  }

  @Builder
  buildContent(): void {
    Column() {
      YearMonthSelector({
        year: this.currentDate.getFullYear(),
        month: this.currentDate.getMonth(),
        onYearMonthSelected: (year: number, month: number) => {
          const currentDate = new Date();
          currentDate.setTime(this.currentDate.getTime());
          currentDate.setFullYear(year, month);
          this.currentDate = currentDate;
          this.month = getMonth(currentDate.getTime());
          this.year = getYear(currentDate.getTime());
          this.loading = true;

          this._computedCurrentMonthDays(currentDate).then((days) => {
            this.loading = false;
            this.days.resetData();
            days.forEach((day) => {
              this.days.pushData(day);
            });
            this._applySelection();
          });
        },
        onClose: () => {
          this.dialogController.close();
        }
      })
    }
  }

  @Builder
  monthDayBuilder(monthDay: MonthDay) {
    if (monthDay.isNotCurrent || monthDay.index === 0) {
      GridItem() {
      }
    } else {
      GridItem() {
        Text(`${monthDay.index}`)
          .fontSize(14)
          .fontWeight(monthDay.isToday ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(
            (monthDay.isToday ?? monthDay.isSelected) ?
              Color.White :
              (monthDay.dayIndex === 0 || monthDay.dayIndex === 6 ?
                '#e64547' :
                Color.Black)
          )
          .backgroundColor(
            monthDay.isToday ?
              '#3b82f6' :
              monthDay.isSelected ?
                '#e86164' :
                Color.Transparent
          )
          .borderRadius(18)
          .width('25vp')
          .height('25vp')
          .textAlign(TextAlign.Center)
          .onClick(() => {
            const base = new Date(this.currentDate);
            base.setDate(monthDay.index);
            this.selectionBaseDate = base;
            CycleManager.setBaseDate(base);
            this.confirmDialog.open();
          })
      }
    }
  }

  @Builder
  confirmDialogBuilder() {
    Column() {
      Text('Are you sure?')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })
      Text('This will select repeating 7-day periods.')
        .margin({ bottom: 10 })
      Row({ space: 5 }) {
        Button('Cancel')
          .fontSize(14)
          .onClick(() => {
            this.confirmDialog.close();
          })
          .height('30%')
        Button('OK')
          .fontSize(14)
          .onClick(() => {
            this._applySelection();
            this.confirmDialog.close();
          })
          .height('30%')
      }
    }
    .margin({ left: 15, bottom: 15 })
    .height('50%')
  }

  private _applySelection() {
    if (!this.selectionBaseDate) {
      return;
    }
    const baseTime = new Date(
      this.selectionBaseDate.getFullYear(),
      this.selectionBaseDate.getMonth(),
      this.selectionBaseDate.getDate()
    ).getTime();
    const newDays: MonthDay[] = [];
    const currentDayDate = new Date(
      this.currentDate.getFullYear(),
      this.currentDate.getMonth(),
      1
    );
    for (let i = 0; i < this.days.totalCount(); i++) {
      const day = this.days.getData(i);
      let isSelected = false;
      if (!day.isNotCurrent && day.index > 0) {
        currentDayDate.setDate(day.index);
        const diffDays = Math.floor(
          (currentDayDate.getTime() - baseTime) / (24 * 60 * 60 * 1000)
        );
        if (diffDays >= 0) {
          const cycleDay = diffDays % 28;
          isSelected = cycleDay >= 0 && cycleDay <= 6;
        }
      }
      newDays.push({
        index: day.index,
        dayIndex: day.dayIndex,
        isNotCurrent: day.isNotCurrent,
        hasEvents: day.hasEvents,
        isToday: day.isToday,
        isSelected: isSelected
      });
    }
    this.days.resetData();
    newDays.forEach(d => this.days.pushData(d));
  }

  build() {
    NavDestination() {
      Column() {
        Text(`${this.month}, ${this.year}`)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
          .padding({ bottom: '5vp' })
          .onClick(() => {
            this.dialogController.open();
          })
        if (this.loading) {
          LoadingProgress()
            .width('50vp')
            .height('50vp')
        } else {
          Grid() {
            ForEach(WEEK_DAYS, (day: string, index: number) => {
              GridItem() {
                Text(day)
                  .fontColor(index === 0 || index === 6 ? '#e64547' : Color.Black)
                  .textAlign(TextAlign.Center)
              }
            }, (day: string, index: number) => day
            )
            LazyForEach(
              this.days,
              (monthDay: MonthDay) => this.monthDayBuilder(monthDay),
              (monthDay: MonthDay) => `${monthDay.index}`
            )
          }
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .columnsGap(1)
          .rowsGap(1)
          .width('80%')
          .height('65%')
        }
      }
      .padding({
        left: this.context.getWindowWidthBreakpoint() / 4.5,
        top: 0
      })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
      .gesture(
        SwipeGesture({ direction: SwipeDirection.Vertical })
          .onAction((event: GestureEvent) => {
            const currentDateTimestamp = this.currentDate.getTime();
            let newDate = new Date();
            if (event.angle > 0) {
              newDate = getPreviousDate(currentDateTimestamp);
            } else {
              newDate = getNextDate(currentDateTimestamp);
            }
            this.currentDate = newDate;
            this.loading = true;
            this._computedCurrentMonthDays(newDate).then((days) => {
              this.loading = false;
              this.days.resetData();
              days.forEach((day) => {
                this.days.pushData(day);
              });
              this._applySelection();
            });
            this.month = getMonth(newDate.getTime());
            this.year = getYear(newDate.getTime());
          })
      )
    }
    .backgroundColor(Color.White)
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}

export interface MonthDay {
  index: number;
  dayIndex: number;
  isNotCurrent: boolean;
  hasEvents: boolean;
  isToday?: boolean;
  isSelected?: boolean;
}