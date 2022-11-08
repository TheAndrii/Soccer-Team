({
   doInit: function (cmp, event, helper) {
        cmp.set('v.columns', [
            { label: 'Team Name', fieldName: 'Name', type: 'text', initialWidth: 120},
            { label: 'Total Wins', fieldName: 'TotalWins__c', type: 'number', initialWidth: 110},
            { label: 'Total Active Players', fieldName: 'TotalActivePlayers__c', type: 'number'}
        ]);
        helper.getData(cmp);
    }
})