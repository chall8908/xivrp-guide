import { Controller } from 'stimulus';
import { DateTime } from 'luxon';
import TomSelect from 'tom-select';
import toUri from 'to_uri';

export default class extends Controller {
  static targets = [ 'cards', 'file', 'days', 'timezone', 'server', 'name', 'slug' ];

  connect() {
    this.updateSlug();

    this.daysTarget.querySelectorAll('input').forEach(
      (i) => i.dispatchEvent(new InputEvent('change'))
    );

    if (this.timezoneTarget.value === '') {
      this.timezoneTarget.value = DateTime.local().zoneName;
    }

    new TomSelect(this.timezoneTarget);
    new TomSelect(this.serverTarget);

    this.previewCard = this.cardsTarget.querySelector('.event.card');

    this.previewCard.addEventListener('click', function(e) { e.preventDefault(); });
  }

  updateSlug = () => {
    this.slugTarget.innerText = toUri(this.nameTarget.value)
  }

  updateCardBackground = () => {
    let file = this.fileTarget.files[0];
    let reader = new FileReader();

    reader.onload = (e) => {
      this.previewCard.style.cssText = `--bg-image: url(${e.target.result})`
    }

    reader.readAsDataURL(file);
  }

  updateDayButton(e) {
    let box = e.target;
    let cl = box.parentElement.classList;

    cl.toggle('active', box.checked);
    cl.toggle('primary', box.checked);

    this.checkDayValidity();
  }

  checkDayValidity() {
    const dayButtons = this.element.querySelectorAll('.event--days input[type="checkbox"]');

    // If any day buttons are checked, we're good
    if ([...dayButtons].some(e => e.checked)) {
      return true;
    }

    dayButtons[0].setCustomValidity('Must select at least one day');
    dayButtons[0].reportValidity();

    return false;
  }

  validate(e) {
    this.checkDayValidity()

    if (! this.element.checkDayValidity()) {
      this.element.reportValidity();
      e.preventDefault();
      return false;
    }
  }
}
