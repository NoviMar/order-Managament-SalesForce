import { LightningElement, wire, api } from 'lwc';
import getAccount from '@salesforce/apex/AccountController.getAccount';

export default class AccountController extends LightningElement {
    @api recordId; // Automatically populated with the current record's Id

    account;

    @wire(getAccount, { accountId: '$recordId' })
    wiredAccount({ error, data }) {
        if (data) {
            this.account = data;
        } else if (error) {
            console.error('Error loading account details:', error);
        }
    }
}
