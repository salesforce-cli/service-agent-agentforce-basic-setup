import { LightningElement, wire, track } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';

export default class HelloHome extends LightningElement {
    userId = USER_ID;
    @track firstName;
    get isGuest() {
        return !this.userId; // In Experience Cloud, guest userId is undefined/null
    }
    get greeting() {
        if (this.isGuest) {
            return 'Hello Guest';
        }
        return this.firstName ? `Hello ${this.firstName}` : 'Hello';
    }

    @wire(getRecord, { recordId: '$userId', fields: [FIRST_NAME_FIELD] })
    wiredUser({ data, error }) {
        if (data) {
            this.firstName = data.fields.FirstName && data.fields.FirstName.value;
        } else if (error) {
            // If guest or error, keep default behavior
            this.firstName = undefined;
        }
    }
}
