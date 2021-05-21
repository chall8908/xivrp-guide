import { Controller } from 'stimulus';
import { DateTime, Interval } from 'luxon';

const OPEN_SOON_DIFF = 90; // minutes

export default class extends Controller {
  static targets = ['flag'];
  static values = { startTime: String, endTime: String };

  connect() {
    this.ensureFlagCorrect();
  }

  ensureFlagCorrect() {
    const startTime = DateTime.fromISO(this.startTimeValue);
    const endTime = DateTime.fromISO(this.endTimeValue);
    const eventInterval = Interval.fromDateTimes(startTime, endTime);
    const now = DateTime.now();
    const eod = now.endOf('day');

    let cssClass;
    let flagText;

    if (eventInterval.contains(now)) {
      // Open now
      cssClass = 'event--open-now';
      flagText = 'Open Now';
    } else if (!now.hasSame(startTime, 'day') || eventInterval.isBefore(now)) {
      // Not open
      cssClass = 'event--closed';
      flagText = 'Closed';
    } else {
      cssClass = 'event--open-soon';
      flagText = 'Open Today';

      if (startTime.diff(now).as('minutes') < OPEN_SOON_DIFF) {
        flagText = 'Open Soon';
      }
    }

    this.element.classList.remove('event--closed',
                                  'event--open-soon',
                                  'event--open-now');

    this.element.classList.add(cssClass);
    this.flagTarget.innerText = flagText;
  }
}
