import { LightningElement, track, api } from 'lwc';
import sendCustomerLoginEmail from '@salesforce/apex/UpdateCustomerLogin.sendCustomerLoginEmail';

export default class UpdateCustomerLoginEmail extends LightningElement {
    @api emailAddress;
    @track newEmailAddress;
    @track openEditScreen = false;
    @track error = '';
    @track spinner = false;
    @api customerId;

    handleClick(event) {
        var clickedButtonLabel = event.target.label;

        if (clickedButtonLabel === 'edit') {
            this.openEditScreen = true;
            this.newEmailAddress = this.emailAddress;
        }
    }

    handleEmailChange(event) {
        this.newEmailAddress = event.target.value;
    }

    closeModal() {
        this.openEditScreen = false;
    }

    saveMethod() {
        if (this.newEmailAddress) {
            if (this.newEmailAddress === this.emailAddress) {
                this.error = 'please update the email address before saving';
            } else {
                // Call Apex to make API Callout
                this.callApexToUpdate();
            }
        } else {
            this.error = 'please provide valid email address before saving';
        }
    }

    successEvent() {
        var updatedValue = this.newEmailAddress;
        this.dispatchEvent(new CustomEvent('success', {
            detail: {
                updatedValue
            },
        }));
    }

    callApexToUpdate() {
        // Call Apex to make API Callout
        this.error = '';
        this.spinner = true;

        let parameterObject = {
            currentLoginEmail: this.emailAddress,
            newLoginEmail: this.newEmailAddress,
            orderType: null
        };

        sendCustomerLoginEmail({ rWrap: parameterObject, customerid: this.customerId })
            .then(result => {
                this.error = '';
                if (result) {
                    if (result === 'SUCCESS') {
                        // Dispatch Success Event
                        this.successEvent();
                        // Close Modal
                        this.closeModal();
                    } else if (result === 'FAILURE') {
                        this.error = 'Failed! Unable to update Customer Login Email.';
                    } else {
                        this.error = 'Failed! Unable to update Customer Login Email : ' + result;
                    }
                } else {
                    this.error = 'Failed! Unable to update Customer Login Email.';
                }
                this.spinner = false;
            })
            .catch(error => {
                this.error = error;
                this.spinner = false;
            });
    }
}