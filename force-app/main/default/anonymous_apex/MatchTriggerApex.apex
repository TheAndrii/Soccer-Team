List<Match__c> newMatchesList = [
    SELECT Winner__c, HomeTeam__c, Visitors__c 
    FROM Match__c 
    ORDER BY Winner__c];
//System.debug(newMatchesList);

Map<Id, List<Id>> teamsMap = new Map<Id, List<Id>>();

    for(Match__c match : newMatchesList){
        List<Id> teamIdsList = new List<Id>();
        teamIdsList.add(match.HomeTeam__c);
        teamIdsList.add(match.Visitors__c);
        teamsMap.put(match.Id, teamIdsList);
    }

//System.debug(teamsMap);

// Set<Id> teamsId = new Set<Id>();

//         for(Match__c match : newMatchesList){
//             teamsId.add(match.HomeTeam__c);
//             teamsId.add(match.Visitors__c);
//         }

// System.debug(teamsId);

// List<Team__c> allTeamsList = [SELECT Id, Name, TotalWins__c FROM Team__c WHERE Id IN: teamsId];
// System.debug(allTeamsList);

// Map<String, Team__c> teamNameIdMap = new Map<String, Team__c>();

// for(Team__c team : allTeamsList){
//     teamNameIdMap.put(team.Name, team);
// }
// System.debug(teamNameIdMap);
//System.debug(newMatchesList);



Set<Id> teamIdsSet = new Set<Id>();
        for(Match__c match : newMatchesList){
            teamIdsSet.add(match.HomeTeam__c);
            teamIdsSet.add(match.Visitors__c);
        }

//System.debug(teamIdsSet);

        List<Match__c> relatedMatchesToUpdate = [
            SELECT Id, Name, StartDatetime__c, Visitors__c, HomeTeam__c  
            FROM Match__c 
            WHERE Visitors__c IN: teamIdsSet OR HomeTeam__c IN:teamIdsSet
        ];

//System.debug(relatedMatchesToUpdate);

        List<Team__c> relatedTeamsList = [
            SELECT Name  
            FROM Team__c 
            WHERE Id IN: teamIdsSet
        ];

        //Map<String, DateTime> matchesStartDateTime = new Map<String, DateTime>();

        String visitorsTeamName;
        String homeTeamName;
        DateTime dt = DateTime.valueOf('2022-10-09 10:00:00');

        //String TeamName1 = relatedMatchesToUpdate[0].HomeTeam__c + ' - ' + relatedMatchesToUpdate[0].Visitors__c;
        String TeamName1;
        String TeamName2;

        //System.debug(TeamName1);
        //System.debug(dt);

        Map<String, List<Match__c>> teamsMemmberToMatches = new Map<String, List<Match__c>>();
        
        for(Match__c match : relatedMatchesToUpdate){
			String key1 = match.Visitors__c+'_'+match.HomeTeam__c;
			String key2 = match.HomeTeam__c+'_'+match.Visitors__c;
        	if (!teamsMemmberToMatches.containsKey(key1)) {
				teamsMemmberToMatches.put(key1, new List<Match__c>()); 
				teamsMemmberToMatches.put(key2, new List<Match__c>()); 
			} else {
				teamsMemmberToMatches.get(key1).add(match);
				teamsMemmberToMatches.get(key2).add(match);
			}  
        }
        

//System.debug(teamsMemmberToMatches); 

Team__c newFirstTeam = new Team__c(Name = 'FirstTeam');
Team__c newSecondTeam = new Team__c(Name = 'SecondTeam');

List<Team__c> testTeamsList = new List<Team__c>{newFirstTeam, newSecondTeam};
//System.debug(testTeamsList[0].Name);
