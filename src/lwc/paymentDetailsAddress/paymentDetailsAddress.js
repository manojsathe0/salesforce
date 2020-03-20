import { LightningElement, api, wire, track } from 'lwc';
import getStateNames from '@salesforce/apex/StatePicklistValues.getStateNames';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PaymentDetailsAddress extends LightningElement {
    @api mailingAddress;
    @api isFinanceUser = false;
    @track apexResponse;
    @track mAddress;

    @wire(getStateNames)
    wiredStates({ error, data }) {
        if (data) {
            this.apexResponse = data;
        } else if (error) {
            const showError = new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error',
            });
            this.dispatchEvent(showError);
        }
    }

    connectedCallback() {
        // initialize component
        this.mAddress = { ...this.mailingAddress };
    }

    handleAddressLineOne(event) {
        this.mAddress.addressLine1 = event.target.value;
        this.changeEvent();
    }

    handleAddressLineTwo(event) {
        this.mAddress.addressLine2 = event.target.value;
        this.changeEvent();
    }

    handleCity(event) {
        this.mAddress.city = event.target.value;
        this.changeEvent();
    }

    handleCountry(event) {
        this.mAddress.country = event.target.value;
        this.changeEvent();
    }

    handleState(event) {
        var val = parseInt(event.target.value, 10);
        this.mAddress.stateId = val;
        this.mAddress.state = this.getStateNameWithValue(val);
        this.changeEvent();
    }

    hanldeZipCode(event) {
        this.mAddress.zipCode = event.target.value;
        this.changeEvent();
    }

    changeEvent() {
        var mAddress = this.mAddress;
        this.dispatchEvent(new CustomEvent('addresschange', {
            detail: {
                mAddress
            },
        }));
    }

    get options() {
        var options = [];
        var apexR = this.apexResponse;
        if (apexR) {
            apexR.forEach(element => {
                if (element) {
                    options.push({
                        label: element.Name,
                        value: (element.State_Id__c) ? (element.State_Id__c.toString()) : null
                    });
                }
            });
        } else {
            options.push({ label: null, value: '' });
        }
        return options;
    }

    get picValue() {
        var stateValue = this.mAddress.stateId;
        return (stateValue) ? (stateValue.toString()) : '';
    }

    getStateNameWithValue(num) {
        var apexR = this.apexResponse;
        var stateName = '';
        var i = 0;
        if (apexR) {
            for (; i < apexR.length; i++) {
                if (apexR[i]) {
                    if (apexR[i].State_Id__c === num) {
                        stateName = apexR[i].Name;
                        break;
                    }
                }
            }
        }
        return stateName;
    }
}