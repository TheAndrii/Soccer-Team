import { LightningElement, api, track, wire } from 'lwc';
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
    error;
    columns = columns;

    @wire(getMatches, {currentRecordId:'$recordId'}) wiredgetMatches;
}