public with sharing class MatchTriggerHandler {

    public static void onBeforeInsert(List<Match__c> newMatchesList){
		List<Match__c> listForUpdate = new List<Match__c>();

        Set<Id> teamIdsSet = new Set<Id>();
        for(Match__c match : newMatchesList){
            teamIdsSet.add(match.HomeTeam__c);
            teamIdsSet.add(match.Visitors__c);
        }

        List<Match__c> relatedMatchesToUpdate = [
            SELECT Id, Name, StartDatetime__c, Visitors__c, HomeTeam__c  
            FROM Match__c 
            WHERE Visitors__c IN: teamIdsSet OR HomeTeam__c IN:teamIdsSet
            ORDER BY StartDatetime__c ASC
        ];

        Map<String, List<Match__c>> teamsMemmberToMatches = new Map<String, List<Match__c>>();
        
        for(Match__c match : relatedMatchesToUpdate){
			String key1 = match.Visitors__c + ' - ' + match.HomeTeam__c;
			String key2 = match.HomeTeam__c + ' - ' + match.Visitors__c;
        	if (!teamsMemmberToMatches.containsKey(key1)) {
				teamsMemmberToMatches.put(key1, new List<Match__c>()); 
				teamsMemmberToMatches.put(key2, new List<Match__c>()); 
			} else {
				teamsMemmberToMatches.get(key1).add(match);
				teamsMemmberToMatches.get(key2).add(match);
			}  
        }

		for(Match__c newMatch : newMatchesList){
			String key = newMatch.Visitors__c + ' - ' + newMatch.HomeTeam__c;
			
			if (teamsMemmberToMatches.containsKey(key)) {
				
				List<Match__c> listRealedToThis = teamsMemmberToMatches.get(key);
                Id previousMatch = null;
                DateTime previuosDateTime;
                if (listRealedToThis.size() > 1) { 
                    previuosDateTime = listRealedToThis.get(0).StartDatetime__c;
                    previousMatch = listRealedToThis.get(0).Id;
                }
                system.debug('Test : ' + listRealedToThis);
				for (Match__c matchItem: listRealedToThis) {
                    system.debug('Test : ' + previuosDateTime + ' < ' + matchItem.StartDatetime__c + '  < ' + newMatch.StartDatetime__c);
					if ((previuosDateTime < matchItem.StartDatetime__c) && (matchItem.StartDatetime__c < newMatch.StartDatetime__c)) {
						previuosDateTime = matchItem.StartDatetime__c;
						previousMatch = matchItem.Id;
					}
				}
				if (previousMatch != null) {
                    system.debug('Test : ' + previuosDateTime);
					newMatch.PreviousMatchBetweenTeamsDatetime__c = previuosDateTime;
				}
			}
		}
    }
    
    public static void onAfterUpdate(List<Match__c> newMatches) {
        Set<Id> teamsId = new Set<Id>();

        for(Match__c match : newMatches){
            teamsId.add(match.HomeTeam__c);
            teamsId.add(match.Visitors__c);
        }

        List<Team__c> teamsList = [SELECT Id, Name, TotalWins__c FROM Team__c WHERE Id IN: teamsId];
        Map<String, Team__c> teamNameIdMap = new Map<String, Team__c>();

        for(Team__c team : teamsList){
            teamNameIdMap.put(team.Name, team);
        }

        List<Team__c> updatedTeamsList = new List<Team__c>();

        for(Match__c match : newMatches){
            if(match.Winner__c != 'Draw'){
                updatedTeamsList.add(new Team__c(Id = teamNameIdMap.get(match.Winner__c).Id, TotalWins__c = teamNameIdMap.get(match.Winner__c).TotalWins__c + 1));
            }
        }

        update updatedTeamsList;
    }
}