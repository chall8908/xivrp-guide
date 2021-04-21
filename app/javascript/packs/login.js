import zxcvbn from 'zxcvbn';
import { application } from 'controllers/application';
import { Controller } from 'stimulus';

class PasswordController extends Controller {
  static targets = [ 'progress', 'bar', 'label' ]

  calculateStrength(e) {
    let password = e.target.value;
    let result = zxcvbn(password);

    if (password.length < 6) {
      result.score = 0;
      result.feedback.warning = '';
    }

    let progress = Math.round((result.score / 4) * 100);
    let barClass = 'error';

    switch(result.score) {
      case 2:
        barClass = 'warning';
        break;

      case 3:
      case 4:
        barClass = 'success';
        break;

      case 0:
      case 1:
      default:
        barClass = 'error';
        break;
    }

    this.progressTarget.classList.remove('error', 'warning', 'success');
    this.progressTarget.classList.add(barClass);

    this.progressTarget.dataset.percent = progress;
    this.barTarget.style.width = progress + '%';

    this.labelTarget.innerText = result.feedback.warning;
  }
}

class RegistrationController extends Controller {
  static targets = ['password', 'passwordConfirmation' ];

  ensureValidity(e) {
    if (this.passwordTarget.value !== this.passwordConfirmationTarget.value) {
      this.passwordConfirmationTarget.setCustomValidity('Does not match password field');
      this.passwordConfirmationTarget.reportValidity();
      e.preventDefault();
    }
  }
}

application.register('password', PasswordController);
application.register('registration', RegistrationController);
