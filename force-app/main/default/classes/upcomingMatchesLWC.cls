public with sharing class upcomingMatchesLWC {

    @AuraEnabled(cacheable=true)
    public static List<Match__c> getMatches(Id currentRecordId){
        return [SELECT Name, StartDateTime__c 
                FROM Match__c 
                WHERE StartDateTime__c >: Datetime.now() AND (HomeTeam__c =: currentRecordId OR Visitors__c =: currentRecordId)
                ORDER BY StartDateTime__c
        ];
    }
}