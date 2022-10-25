public with sharing class TeamsRatingController {
    @AuraEnabled
    public static List<Team__c> getTeamsRating() {
        return [SELECT Id, Name, TotalWins__c, TotalActivePlayers__c FROM Team__c ORDER BY TotalWins__c DESC LIMIT 3];
    }
}