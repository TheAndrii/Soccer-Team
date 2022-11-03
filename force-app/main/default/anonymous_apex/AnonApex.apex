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

List<Match__c> matchesInPrevMonth = [
            SELECT Id, Name, StartDatetime__c, Visitors__c, HomeTeam__c, Winner__c  
            FROM Match__c 
            WHERE Winner__c != 'Draw' 
        ];
//System.debug(matchesInPrevMonth); //WHERE StartDatetime__c = LAST_N_MONTHS:1

        Set<Id> teamIds = new Set<Id>();

        for(Match__c match : matchesInPrevMonth){
            teamIds.add(match.HomeTeam__c);
            teamIds.add(match.Visitors__c);
        }
//System.debug(teamIds);

List<Player__c> playersList = [
            SELECT Id, Name, isActive__c, Team__c, Bonus__c  
            FROM Player__c
            WHERE isActive__c = true
        ];
//System.debug(playersList);

// for(Player__c player : playersList){
//     player.Bonus__c = 0;
// }

// update playersList;

//System.debug(playersList);

        List<Team__c> teamsList = [
            SELECT Id, Name, TotalWins__c
            FROM Team__c
            WHERE Id IN: teamIds
        ];

        System.debug(teamsList);

        Id winerTeamId;

        for(Player__c player : playersList){
            for(Match__c match : matchesInPrevMonth){
                for(Team__c team : teamsList){
                    if(match.Winner__c == team.Name){
                    	winerTeamId =  team.Id;
                    } 
                }

                if(player.Team__c == winerTeamId){
                    //player.Bonus__c += 50;
                }
            }
        }
//System.debug(playersList);

// String winerTeamId1;
// List<Id> winnerMatchesInPrevMonth = new List<Id>();

// for(Match__c match : matchesInPrevMonth){
//     for(Team__c team : teamsList){
//         if(match.Winner__c == team.Name){
//             winerTeamId1 =  team.Id;
//             winnerMatchesInPrevMonth.add(winerTeamId1);
//         } 
//     }
// }
// System.debug(winnerMatchesInPrevMonth);

// for(Player__c player : playersList){
//     for(Id team : winnerMatchesInPrevMonth){
//         if(player.Team__c == team){
//             player.Bonus__c += 50;
//         }
//     }
// }
// System.debug(playersList);

//Map<Id, List<Match__c>> teamsMemmberToMatches1 = new Map<Id, List<Match__c>>();
Map<Id, Integer> teamsMemmberToMatches1 = new Map<Id, Integer>();
Integer sc = 0;
List<Match__c> matchesList = new List<Match__c>();

for(Match__c match : matchesInPrevMonth){
    for(Team__c team : teamsList){
        if(match.Winner__c == team.Name){
            winerTeamId =  team.Id;
            sc += 1;
            teamsMemmberToMatches1.put(winerTeamId, sc);
            //matchesList.add(match);
        }
        
    }
    
     
}

//System.debug(teamsMemmberToMatches1);

//================================================================
//PlayerBonusBatch playerBonus = new PlayerBonusBatch();
//Id batchId = Database.executeBatch(playerBonus);

// System.debug([
//     SELECT Id, Name  
//     FROM Team__c 
// ]);

Id currentRecordId = 'a017Q00001BiFNCQA3'; //

//DeleteTeamCallouts.makeDeleteCallout(currentRecordId);
System.debug([
    SELECT Id, Name  
    FROM Team__c 
]);

System.debug([
    SELECT Id, Name, Score__c  
    FROM Match__c
    ORDER BY Score__c DESC
    LIMIT 5
]);

String str1 = '5:3'; //8
String str2 = '2:7'; //9
if (str1 > str2) {
	system.debug('Max');
} else {
   system.debug('Min');
}

List<Match__c> allMatchesList = [
    SELECT Id, Name, Score__c  
    FROM Match__c
    WHERE Score__c != ''
];

System.debug(allMatchesList);
Integer scr = 0;
//List<Id> filteredMatchesList = new List<Id>();
Map<String, Integer> matchesMap = new Map<String, Integer>();
Set<Id> setId = new Set<Id>();

for(Match__c match : allMatchesList){
    Integer homeTeamScore = integer.valueof(match.Score__c.substringBefore(':'));
    Integer visitorsTeamScore = integer.valueof(match.Score__c.substringAfter(':'));
    Integer scrSum = homeTeamScore + visitorsTeamScore;
    matchesMap.put(match.Id, scrSum);
    setId.add(match.Id);
}
System.debug(matchesMap);


public class Pair {
        public Integer value { get; set; }
        public String key { get; set; }
        public Pair(Integer value, String key) {
            this.value = value;
            this.key = key;
        }
}

List<Pair> oList = new List<Pair>();
for (String matchId: setId) oList.add(new Pair(matchesMap.get(matchId), matchId));

Integer tmpValue = 0;
String tmpKey = NULL;

// Bubble sort
for (Integer i = 0; i < oList.size()-1; i++) {
    for (Integer j = 1; j < oList.size(); j++) {
        if (oList.get(j-1).value > oList.get(j).value) {
            // permute
            tmpValue = oList.get(j-1).value;
            tmpKey = oList.get(j-1).key;
            oList.get(j-1).value = oList.get(j).value;
            oList.get(j-1).key = oList.get(j).key;
            oList.get(j).value = tmpValue;
            oList.get(j).key = tmpKey;
          }
     }
}

System.debug(oList);

List<Pair> resultMatches = new List<Pair>();
for(Integer i=oList.size()-1; i>=oList.size()-5;i--){
    resultMatches.add(oList[i]);
}
System.debug(resultMatches);

List<Id> result = new List<Id>();

for (Integer i=0; i<5; i++){
    result.add(resultMatches.get(i).key);
}
System.debug(result);

System.debug(MatchRESTHelper.getMatchIds());