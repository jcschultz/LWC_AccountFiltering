import { LightningElement, api, track } from 'lwc';

export default class BusinessDetailsPopup extends LightningElement {
    @track isVisible = false;
    @track business = {};

    @api
    show(business) {
        this.business = business;
        this.isVisible = true;
    }

    @api
    toggle(business) {
        if (this.isVisible === true) {
            this.show(business);
        } else {
            this.closePopup();
        }
    }

    closePopup() {
        this.isVisible = false;
    }
}