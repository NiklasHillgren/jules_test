import { LightningElement, api, track } from 'lwc';

export default class AlertList extends LightningElement {
    @track alerts = [];
    alertCounter = 0;

    @api
    show(message, type = 'info', duration = 5000) {
        const id = this.alertCounter++;
        const className = this.computeClassName(type);
        const label = this.computeLabel(type);

        const newAlert = {
            id,
            message,
            type,
            className,
            label
        };

        this.alerts = [...this.alerts, newAlert];

        if (duration > 0) {
            setTimeout(() => {
                this.removeAlert(id);
            }, duration);
        }
    }

    computeClassName(type) {
        let baseClass = 'alert alert-dismissible fade show ';
        switch (type) {
            case 'success':
                return baseClass + 'alert-success';
            case 'info':
                return baseClass + 'alert-info';
            case 'warning':
                return baseClass + 'alert-warning';
            case 'danger':
            case 'error':
                return baseClass + 'alert-danger';
            default:
                return baseClass + 'alert-info';
        }
    }

    computeLabel(type) {
        switch (type) {
            case 'success':
                return 'Success!';
            case 'info':
                return 'Info!';
            case 'warning':
                return 'Warning!';
            case 'danger':
            case 'error':
                return 'Danger!';
            default:
                return '';
        }
    }

    handleClose(event) {
        const alertId = parseInt(event.currentTarget.name, 10);
        this.removeAlert(alertId);
    }

    removeAlert(id) {
        this.alerts = this.alerts.filter(alert => alert.id !== id);
    }
}
