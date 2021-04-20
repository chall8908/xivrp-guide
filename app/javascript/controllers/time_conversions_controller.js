import { Controller } from 'stimulus';
import { DateTime, Interval } from 'luxon';

export default class extends Controller {
  static targets = [ 'time' ];
  static values = { startTime: String, endTime: String, time: String, timeFormat: String };

  connect() {
    this.convertTime();
  }

  convertTime() {
    if(this.hasStartTimeValue && this.hasEndTimeValue) {
      return this.convertTimeRange();
    }

    let date = DateTime.fromISO(this.timeValue).toLocal();

    this.timeTarget.textContent = date.toLocaleString(DateTime[this.timeFormatValue]);
  }

  convertTimeRange() {
    let startTime = DateTime.fromISO(this.startTimeValue).toLocal();
    let endTime = DateTime.fromISO(this.endTimeValue).toLocal();
    let interval = Interval.fromDateTimes(startTime, endTime);

    this.timeTarget.textContent = interval.toFormat(this.timeFormatValue);
  }
}
