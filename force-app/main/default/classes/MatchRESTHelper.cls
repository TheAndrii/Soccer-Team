public with sharing class MatchRESTHelper {
    public static List<Id> getMatchIds() {
        List<Match__c> allMatchesList = [
            SELECT Id, Name, Score__c  
            FROM Match__c
            WHERE Score__c != ''
        ];

        Map<String, Integer> matchesMap = new Map<String, Integer>();
        Set<Id> setId = new Set<Id>();

        for(Match__c match : allMatchesList){
            Integer homeTeamScore = integer.valueof(match.Score__c.substringBefore(':'));
            Integer visitorsTeamScore = integer.valueof(match.Score__c.substringAfter(':'));
            Integer scrSum = homeTeamScore + visitorsTeamScore;
            matchesMap.put(match.Id, scrSum);
            setId.add(match.Id);
        }

        List<Pair> oList = new List<Pair>();
        for (String matchId: setId) oList.add(new Pair(matchesMap.get(matchId), matchId));

        Integer tmpValue = 0;
        String tmpKey = NULL;

        // Bubble sort
        for (Integer i = 0; i < oList.size()-1; i++) {
            for (Integer j = 1; j < oList.size(); j++) {
                if (oList.get(j-1).value > oList.get(j).value) {
                    tmpValue = oList.get(j-1).value;
                    tmpKey = oList.get(j-1).key;
                    oList.get(j-1).value = oList.get(j).value;
                    oList.get(j-1).key = oList.get(j).key;
                    oList.get(j).value = tmpValue;
                    oList.get(j).key = tmpKey;
                }
            }
        }

        List<Pair> resultMatches = new List<Pair>();
        for(Integer i=oList.size()-1; i>=oList.size()-5;i--){
            resultMatches.add(oList[i]);
        }

        List<Id> result = new List<Id>();

        for (Integer i=0; i<5; i++){
            result.add(resultMatches.get(i).key);
        }

        return result;
    }
}
