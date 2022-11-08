@isTest
private class MatchTriggerHandlerTest {

    @TestSetup
    static void dataSetup(){

        Player__c newPlayer1 = new Player__c(Name = 'Player1', Email__c = 'player1@email.com', isActive__c = true);
        Player__c newPlayer2 = new Player__c(Name = 'Player2', Email__c = 'player2@email.com', isActive__c = true);
        insert new List<Player__c>{newPlayer1, newPlayer2};

        Team__c newTeam1 = new Team__c(Name = 'Team1', TotalWins__c = 0, TotalActivePlayers__c = 11);
        Team__c newTeam2 = new Team__c(Name = 'Team2', TotalWins__c = 0, TotalActivePlayers__c = 11);
        insert new List<Team__c>{newTeam1, newTeam2};

        DateTime dt1 = DateTime.valueOf('2022-11-17 17:00:00');
        DateTime dt2 = DateTime.valueOf('2022-11-18 17:00:00');
        DateTime dt3 = DateTime.valueOf('2022-11-19 17:00:00');

        Match__c mewMatch1 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt1, HomeTeam__c = newTeam1.Id, Visitors__c = newTeam2.Id, Score__c = '1:0'
        );
        Match__c mewMatch2 = new Match__c(
            Name = 'Team2 - Team1', StartDateTime__c = dt2, HomeTeam__c = newTeam2.Id, Visitors__c = newTeam1.Id, Score__c = '2:1'
        );
        Match__c mewMatch3 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt3, HomeTeam__c = newTeam1.Id, Visitors__c = newTeam2.Id, Score__c = '0:0'
        );
        insert new List<Match__c>{mewMatch1, mewMatch2, mewMatch3};
    }

    @isTest
    static void onAfterUpdateTest(){

        List<Match__c> relatedMatches = [
            SELECT Id, Name, Winner__c, HomeTeam__c, Visitors__c
            FROM Match__c
        ];

        Id homeTeamId = relatedMatches.get(0).HomeTeam__c;
        Id visitorsTeamId = relatedMatches.get(0).Visitors__c;

        Set<Id> teamsId = new Set<Id>{homeTeamId, visitorsTeamId};

        Test.startTest();
        MatchTriggerHandler.onAfterUpdate(relatedMatches);
        Test.stopTest();

        List<Team__c> relatedTeams = [
            SELECT Id, Name, TotalWins__c
            FROM Team__c
            WHERE Id IN: teamsId
        ];

        System.assertEquals(
            1, 
            relatedTeams[0].TotalWins__c, 
            'MatchTriggerHandlerTest.onAfterUpdate is working incorrectly'
        );
        System.assertEquals(
            1, 
            relatedTeams[1].TotalWins__c, 
            'MatchTriggerHandlerTest.onAfterUpdate is working incorrectly'
        );
    }
    
    @isTest
    static void onBeforeInsertTest(){

        List<Match__c> previousMatches = [
            SELECT Id, Name, StartDateTime__c, Winner__c, HomeTeam__c, Visitors__c
            FROM Match__c
            ORDER BY StartDateTime__c DESC
            LIMIT 1
        ];

        Id team1Id = previousMatches.get(0).HomeTeam__c;
        Id team2Id = previousMatches.get(0).Visitors__c;

        DateTime prevDT5 = previousMatches[0].StartDateTime__c;

        DateTime dt5 = DateTime.valueOf('2022-11-22 13:00:00');

        Match__c mewMatch5 = new Match__c(
            Name = 'Team2 - Team1', StartDateTime__c = dt5, HomeTeam__c = team2Id, Visitors__c = team1Id
        );
        insert new List<Match__c>{mewMatch5};

        Test.startTest();
        MatchTriggerHandler.onBeforeInsert(new List<Match__c>{mewMatch5});
        Test.stopTest();

        List<Match__c> updatedMatches = [
            SELECT Id, Name, PreviousMatchBetweenTeamsDatetime__c
            FROM Match__c
            ORDER BY StartDateTime__c DESC
            LIMIT 1
        ];

        System.assertEquals(
            prevDT5, 
            updatedMatches[0].PreviousMatchBetweenTeamsDatetime__c,
            'MatchTriggerHandlerTest.onBeforeInsert is working incorrectly'
        );
    }
}