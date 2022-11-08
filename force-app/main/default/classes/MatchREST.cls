@RestResource(urlMapping='/Match__c/*')
global with sharing class MatchREST {
    
    @HttpGet
    global static List<Match__c> getMatchesWithHighestScore(){
        List<Id> matchIds = MatchRESTHelper.getMatchIds();
        return [SELECT Id, Name, Score__c FROM Match__c WHERE Id IN:matchIds];
    }
}
