import { YearItem } from './YearItem';

export class YearDataSource implements IDataSource {
  private years: number[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(minYear: number, maxYear: number) {
    this._generateYears(minYear, maxYear);
  }

  totalCount(): number {
    return this.years.length;
  }

  getData(index: number): YearItem {
    return new YearItem(this.years[index]);
  }

  getIndexByYear(year: number): number {
    return this.years.indexOf(year);
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listeners.push(listener);
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const index = this.listeners.indexOf(listener);
    if (index !== -1) {
      this.listeners.slice(index, 1);
    }
  }

  updateYearRange(minYear: number, maxYear: number) {
    this._generateYears(minYear, maxYear);
    this._notifyDataReload();
  }

  private _generateYears(minYear: number, maxYear: number) {
    this.years = [];
    for (let year = minYear; year < maxYear; year++) {
      this.years.push(year);
    }
  }

  private _notifyDataReload() {
    this.listeners.forEach((listener) => {
      listener.onDataReloaded();
    });
  }
}