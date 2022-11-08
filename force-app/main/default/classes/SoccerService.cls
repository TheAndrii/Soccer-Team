public with sharing class SoccerService {
	
	public class ScoreHelper{
        Id matchId;
        Integer homeTeamScore;
        Integer visitorsTeamScore;

        public ScoreHelper(String mId, Integer hTeamScore, Integer vTeamScore){
      		this.matchId = mId;
            this.homeTeamScore = hTeamScore;
            this.visitorsTeamScore = vTeamScore;
        }
    }
    
    public static List<ScoreHelper> getList(Id mId, Integer hTeamScore, Integer vTeamScore){
        ScoreHelper newObj = new ScoreHelper(mId, hTeamScore, vTeamScore);
		List<ScoreHelper> scores = new List<ScoreHelper>();
        scores.add(newObj);
        return scores;
    }
    
    public static void createPlayer(String name, String email, Map<SObjectField, Object> extraValues){
        Player__c newPlayer = new Player__c(Name = name, Email__c = email);
        Set<SObjectField> mapKeys = extraValues.keySet();
        List<Object> mapValues = extraValues.values();
        Schema.SObjectField newKey;
        Object newKeyStatus = mapValues[0];

        for (SObjectField key : mapKeys){
            newKey = key;
        }

        newPlayer.put(newKey, newKeyStatus);
        
        try {
            insert newPlayer;
        } catch (System.DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    public static void arangeMatch(DateTime dt, Id homeTeamId, Id visitorsTeamId){
        Team__c homeTeam = [
            SELECT Name 
            FROM Team__c
            WHERE Id =: homeTeamId  
        ];
        Team__c visitorsTeam = [
            SELECT Name 
            FROM Team__c
            WHERE Id =: visitorsTeamId  
        ];

        Match__c newMatch = new Match__c(
            Name = homeTeam.Name + ' - ' + visitorsTeam.Name,
            StartDateTime__c = dt,
            HomeTeam__c = homeTeamId,
            Visitors__c = visitorsTeamId
        );

        try {
            insert newMatch;
        } catch (System.DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    public static void setScoreToMatches(List<ScoreHelper> scores){
        String matchId;
        String homeTeamScore;
        String visitorsTeamScore;
        
        for(ScoreHelper a : scores) {
            matchId = String.valueOf(a.matchId);
            homeTeamScore = String.valueOf(a.homeTeamScore);
            visitorsTeamScore = String.valueOf(a.visitorsTeamScore);
    	}
        
        String matchScore = homeTeamScore + ':' + visitorsTeamScore;

        Match__c match = [
            SELECT Name, StartDateTime__c, HomeTeam__c, Visitors__c, Score__c 
            FROM Match__c 
            WHERE Id =: matchId
        ];

        match.Score__c = matchScore;

        try {
            update match;
        } catch (System.DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    public static void deactivatePlayers(List<Id> playersIds){
        List<Player__c> deactivatedPlayersList = [
            SELECT Name, isActive__c 
            FROM Player__c 
            WHERE Id IN: playersIds
        ];

        for(Player__c player : deactivatedPlayersList){
            player.isActive__c = false;
        }

        try {
            update deactivatedPlayersList;
        } catch (System.DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}