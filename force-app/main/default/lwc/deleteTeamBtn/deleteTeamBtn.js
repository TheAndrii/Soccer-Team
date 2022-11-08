import { LightningElement, api, track } from 'lwc';
import makeDeleteCallout from '@salesforce/apex/DeleteTeamCallouts.makeDeleteCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class DeleteExample extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    
    @track error;
    handleClick(event) {
        makeDeleteCallout({currentRecordId: this.recordId})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );

                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Team__c',
                        actionName: 'home',
                    },
                });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}