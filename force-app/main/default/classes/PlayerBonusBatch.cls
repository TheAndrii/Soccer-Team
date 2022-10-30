public class PlayerBonusBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful {
    
    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, StartDatetime__c, Visitors__c, HomeTeam__c, Winner__c ' + 
            'FROM Match__c ' +
            'WHERE Winner__c != \'Draw\''
        ); //WHERE StartDatetime__c = LAST_N_MONTHS:1
    }
    
    public void execute(Database.BatchableContext bc, List<Match__c> scope){

        Set<Id> teamIds = new Set<Id>();

        for(Match__c match : scope){
            teamIds.add(match.HomeTeam__c);
            teamIds.add(match.Visitors__c);
        }

        List<Player__c> playersList = [
            SELECT Id, Name, isActive__c, Team__c, Bonus__c
            FROM Player__c
            WHERE isActive__c = true AND Team__c IN: teamIds
        ];

        List<Team__c> teamsList = [
            SELECT Id, Name
            FROM Team__c
            WHERE Id IN: teamIds
        ];

        String winerTeamId;

        for(Player__c player : playersList){
            for(Match__c match : scope){
                for(Team__c team : teamsList){
                    if(match.Winner__c == team.Name){
                    	winerTeamId =  team.Id;
                    } 
                }

                if(player.Team__c == winerTeamId){
                    player.Bonus__c += 50;
                }
            }
            ++recordsProcessed;
        }

        update playersList;
    }

    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed.');
    }

    public void execute(SchedulableContext context){
        PlayerBonusBatch playerBonus = new PlayerBonusBatch();
        Id batchId = Database.executeBatch(playerBonus);
    }
}