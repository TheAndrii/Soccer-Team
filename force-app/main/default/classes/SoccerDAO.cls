public class SoccerDAO {

    public static List<Team__c> getTeamsByIds(Set<Id> teamIds){
        List<Team__c> teamsList = [SELECT Name FROM Team__c WHERE Id in:teamIds];
        return teamsList;
    }

    public static List<Player__c> getActivePlayers(Integer limitNumber, Integer offsetNumber){
        List<Player__c> activePlayersList = [
            SELECT Name, IsActive__c 
            FROM Player__c 
            WHERE IsActive__c = true 
            ORDER BY Name ASC LIMIT :limitNumber OFFSET :offsetNumber];
        return activePlayersList;
    }

    public static Team__c getMostWinnerTeam(){
        return [SELECT Name FROM Team__c ORDER BY TotalWins__c DESC LIMIT 1];
    }

    public static Integer getWonMatchesCountByTeamId(Id teamId){
        List<Team__c> WonMatchesList = [SELECT TotalWins__c FROM Team__c WHERE Id =: teamId];
        return WonMatchesList[0].TotalWins__c.intValue();    
    }

    public static Map<Id, Integer> getTeamsWithPlayerNumber (Set<Id> teamIds){
        Map<Id, Integer> numberOfPlayers = new Map<Id, Integer>();
        Set<Id> nullTeamIds = new Set<Id>{null};
        if (teamIds == nullTeamIds){
            List<AggregateResult> numberOfPlayersList = Database.query('SELECT COUNT(Id) numberOfPlayers, Team__c '
                + 'FROM Player__c ' + 'WHERE Team__c != null ' + 'GROUP By Team__c');
          	for (AggregateResult a : numberOfPlayersList){
            	String teamId =(String)a.get('Team__c');
            	Integer intdata =(Integer)a.get('numberOfPlayers');
            	numberOfPlayers.put(teamId, intdata);
        	}
        } else {
            List<AggregateResult> numberOfPlayersList = [
                SELECT COUNT(Id) numberOfPlayers, Team__c 
                FROM Player__c 
                WHERE Team__c IN : teamIds GROUP By Team__c
            ];
            for (AggregateResult a : numberOfPlayersList){
            	String teamId =(String)a.get('Team__c');
            	Integer intdata =(Integer)a.get('numberOfPlayers');
            	numberOfPlayers.put(teamId, intdata);
        	}
        }
        
        return numberOfPlayers;
    }

    public static Integer getTeamStatistics(Set<Id> teamIds){
        Set<Id> nullTeamIds = new Set<Id>{null};
        Integer intVersion;
        if (teamIds == nullTeamIds){
            AggregateResult[] avgNumberOfPlayersList = [
                SELECT AVG(TotalActivePlayers__c) avgNumberOfPlayers 
                FROM Team__c 
            ];
            for (AggregateResult a : avgNumberOfPlayersList){
            	Decimal avgdata =(Decimal) a.get('avgNumberOfPlayers');
            	intVersion = Integer.valueOf(avgdata);
        	}
        } else {
            AggregateResult[] avgNumberOfPlayersList = [
                SELECT AVG(TotalActivePlayers__c) avgNumberOfPlayers 
                FROM Team__c 
                WHERE Id IN : teamIds
            ];
            for (AggregateResult a : avgNumberOfPlayersList){
            	Decimal avgdata =(Decimal) a.get('avgNumberOfPlayers');
            	intVersion = Integer.valueOf(avgdata);
        	}
        }
        return intVersion;
    }

    public static Team__c getTeamWithMostScores(){
        List<Match__c> matchesList = [SELECT Winner__c, HomeTeam__c, Visitors__c FROM Match__c ORDER BY Winner__c];
        Map<Id, Integer> teamsScore = new Map<Id, Integer>();
    	
        String homeTeam;
        String visitorTeam;
        String winerTeam;
        Integer homeTeamScore = 0;
        Integer visitorTeamScore = 0;
    	Integer initialScore = 0;
    
    	List<Team__c> allTeamsList = [SELECT Id, Name FROM Team__c];
    	for(Team__c a : allTeamsList){
        	teamsScore.put(a.Id, initialScore);
    	}

		String winerTeamId;
    	
        for(Match__c a : matchesList){
            homeTeam = a.HomeTeam__c;
            visitorTeam = a.Visitors__c;

            if(a.Winner__c != 'Draw'){
                for(Team__c b : allTeamsList){
                    if(a.Winner__c == b.Name){
                    	winerTeamId =  b.Id;
                    } 
                }
               winerTeam = winerTeamId;
            }
            
            if (winerTeam == homeTeam){
                Integer value = teamsScore.get(winerTeam);
                homeTeamScore = value + 2;
                teamsScore.remove(winerTeam);
                teamsScore.put(winerTeam, homeTeamScore);
            } else if (winerTeam == visitorTeam){
                Integer value = teamsScore.get(winerTeam);
                visitorTeamScore = value + 2;
                teamsScore.remove(winerTeam);
                teamsScore.put(winerTeam, visitorTeamScore);
            } else {
                Integer valueHome = teamsScore.get(homeTeam);
                Integer valueVisitors = teamsScore.get(visitorTeam);
                homeTeamScore = valueHome + 1;
                visitorTeamScore = valueVisitors + 1;
                teamsScore.remove(homeTeam);
                teamsScore.remove(visitorTeam);
                teamsScore.put(homeTeam, homeTeamScore);
                teamsScore.put(visitorTeam, visitorTeamScore);
            } 
        }
		System.debug(teamsScore);
        return [SELECT Name FROM Team__c WHERE Id =: winerTeam];
    }
}