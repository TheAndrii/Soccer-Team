public with sharing class DeleteTeamCallouts {

    @AuraEnabled
    public static void makeDeleteCallout(Id currentRecordId){
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setHeader('recordId', currentRecordId);
        request.setEndpoint('https://avenga-school.herokuapp.com/delete-record');
        Http http = new Http();
        HttpResponse response;

        try {
            response = http.send(request);

            System.debug(response.toString());
            System.debug('STATUS: ' + response.getStatus());
            System.debug('STATUS_CODE: ' + response.getStatusCode());
        } catch (System.CalloutException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

        if(response.getStatusCode() == 200) {
            Team__c team = [
                SELECT Id
                FROM Team__c
                WHERE Id =: currentRecordId
            ];

            try {
                delete team;
            } catch (System.DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }
}
