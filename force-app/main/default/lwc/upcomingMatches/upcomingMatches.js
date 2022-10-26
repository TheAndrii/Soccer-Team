import { LightningElement, api, wire } from 'lwc';
import getMatches from '@salesforce/apex/upcomingMatchesLWC.getMatches';

const columns = [
    { 
        label: 'Match name', 
        fieldName: 'Name' 
    },
    {
        label: 'Start date',
        fieldName: 'StartDateTime__c',
        initialWidth: 180,
        type: 'date',
        typeAttributes:{
            year: 'numeric',
            month: 'long',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }
    },
];

export default class UpcomingMatches extends LightningElement {
    @api recordId;
    columns = columns;
    matches = [];

    @wire(getMatches, {currentRecordId:'$recordId'}) 
    wiredGetMatches({data, error}) {
        if(data) {
            this.matches = data;
        } else if (error) {
            console.log(error);
        }
    }
}