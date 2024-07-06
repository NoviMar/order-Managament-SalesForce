import { LightningElement, wire } from 'lwc';
import getUserInfo from '@salesforce/apex/AccountController.getUserInfo';

export default class AccountController extends LightningElement {
    userDetails;

    // Fetch user info
    @wire(getUserInfo)
    wiredUserInfo({ error, data }) {
        if (data) {
            this.userDetails = data;
        } else if (error) {
            console.error('Error loading user info:', error);
        }
    }

}
