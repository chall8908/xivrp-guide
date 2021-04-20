import { Controller } from 'stimulus';
import jQuery from 'jquery'

export default class extends Controller {
  static targets = [ 'close' ];
  static values = { autodismiss: Number };

  connect() {
    this.timeout = setTimeout(this.closeMessage, this.autodismissValue);
  }

  closeMessage = () => {
    clearTimeout(this.timeout);

    jQuery(this.element).fadeOut('fast', () => this.element.remove());
  }
}
