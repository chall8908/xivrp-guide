import { Controller } from 'stimulus';
import jQuery from 'jquery';

export default class extends Controller {
  toggleContent = (e) => {
    jQuery(e.target.nextElementSibling).slideToggle({
      duration: 'fast',
      start: function() {
        // Fix display attribute
        this.style.display = 'flex';
      }
    });
  }
}
