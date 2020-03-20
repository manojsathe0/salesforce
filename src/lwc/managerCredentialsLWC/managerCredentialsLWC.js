import { LightningElement, track } from 'lwc';
import isValidateManagerCredential from '@salesforce/apex/IADDiscountController_Ltng.isValidateManagerCredential';

export default class ManagerCredentialsLWC extends LightningElement {
    usrNValue = '';
    passValue = '';
    isSuccess = false;
    @track error = '';
    @track spinner = false;

    handleUserName(event) {
        this.usrNValue = event.target.value;
    }

    handlePassword(event) {
        this.passValue = event.target.value;
    }

    closeModal() {
        this.closeEvent();
    }

    saveMethod() {
        if (this.validateInputField()) {
            this.callApexToValidate();
        }
    }

    closeEvent() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    callApexToValidate() {
        this.error = '';
        this.spinner = true;
        isValidateManagerCredential({ usrn: this.usrNValue, pwd: this.passValue })
            .then(result => {
                this.isSuccess = result;
                this.error = undefined;
                if (this.isSuccess === true) {
                    this.successEvent();
                } else {
                    this.error = 'Invalid username or password. Please try again!';
                }
                this.spinner = false;
            })
            .catch(error => {
                this.error = error;
                this.spinner = false;
            });
    }

    successEvent() {
        var userName;
        var usrN = this.usrNValue; // STORY B-41395 - Added
        //userName = this.usrNValue.substring(0, this.usrNValue.indexOf('@')); // STORY B-41395 - Commented
        userName = usrN.includes('@') ? usrN.substring(0, usrN.indexOf('@')) : usrN; // STORY B-41395 - Added
        this.dispatchEvent(new CustomEvent('success', {
            detail: {
                userName
            },
        }));
    }

    validateInputField() {
        this.error = '';
        if ((!this.usrNValue) || (!this.passValue)) {
            this.error = 'Please fill all fields';
            return false;
        }
        return true;
    }
}