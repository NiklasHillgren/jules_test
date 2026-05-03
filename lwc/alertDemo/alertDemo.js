import { LightningElement } from 'lwc';

export default class AlertDemo extends LightningElement {
    handleSuccess() {
        this.template.querySelector('c-alert-list').show('This alert box indicates a successful or positive action.', 'success');
    }

    handleInfo() {
        this.template.querySelector('c-alert-list').show('This alert box indicates a neutral informative change or action.', 'info');
    }

    handleWarning() {
        this.template.querySelector('c-alert-list').show('This alert box indicates a warning that might need attention.', 'warning');
    }

    handleDanger() {
        this.template.querySelector('c-alert-list').show('This alert box indicates a dangerous or potentially negative action.', 'danger');
    }
}
