@isTest
private class MatchTriggerHandlerTest {

    @TestSetup
    static void dataSetup(){

        Player__c newPlayer1 = new Player__c(Name = 'Player1', Email__c = 'player1@email.com', isActive__c = true);
        Player__c newPlayer2 = new Player__c(Name = 'Player2', Email__c = 'player2@email.com', isActive__c = true);
        insert new List<Player__c>{newPlayer1, newPlayer2};

        Team__c newTeam1 = new Team__c(Name = 'Team1', TotalWins__c = 0, TotalActivePlayers__c = 11);
        Team__c newTeam2 = new Team__c(Name = 'Team2', TotalWins__c = 0, TotalActivePlayers__c = 11);
        Team__c newTeam3 = new Team__c(Name = 'Team3', TotalWins__c = 0, TotalActivePlayers__c = 11);
        insert new List<Team__c>{newTeam1, newTeam2, newTeam3};

        DateTime dt1 = DateTime.valueOf('2022-10-27 17:00:00');
        DateTime dt2 = DateTime.valueOf('2022-10-28 17:00:00');
        DateTime dt3 = DateTime.valueOf('2022-10-29 17:00:00');
        DateTime dt4 = DateTime.valueOf('2022-10-30 17:00:00');

        Match__c mewMatch1 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt1, HomeTeam__c = newTeam1.Id, Visitors__c = newTeam2.Id, Score__c = '1:0'
        );
        Match__c mewMatch2 = new Match__c(
            Name = 'Team2 - Team1', StartDateTime__c = dt2, HomeTeam__c = newTeam2.Id, Visitors__c = newTeam1.Id, Score__c = '2:1'
        );
        Match__c mewMatch3 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt3, HomeTeam__c = newTeam1.Id, Visitors__c = newTeam2.Id, Score__c = '0:0'
        );
        Match__c mewMatch4 = new Match__c(
            Name = 'Team3 - Team1', StartDateTime__c = dt4, HomeTeam__c = newTeam3.Id, Visitors__c = newTeam1.Id, Score__c = '1:0'
        );
        insert new List<Match__c>{mewMatch1, mewMatch2, mewMatch3, mewMatch4};
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

        MatchTriggerHandler.onAfterUpdate(relatedMatches);

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
            LIMIT 2
        ];

        Id team1Id = previousMatches.get(0).Visitors__c;
        Id team2Id = previousMatches.get(1).Visitors__c;
        Id team3Id = previousMatches.get(0).HomeTeam__c;

        DateTime prevDT5 = previousMatches[0].StartDateTime__c;
        DateTime prevDT6 = previousMatches[1].StartDateTime__c;

        DateTime dt5 = DateTime.valueOf('2022-11-09 13:00:00');
        DateTime dt6 = DateTime.valueOf('2022-11-11 14:00:00');

        Match__c mewMatch5 = new Match__c(
            Name = 'Team1 - Team3', StartDateTime__c = dt5, HomeTeam__c = team1Id, Visitors__c = team3Id
        );
        Match__c mewMatch6 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt6, HomeTeam__c = team1Id, Visitors__c = team2Id
        );
        insert new List<Match__c>{mewMatch5, mewMatch6};

        MatchTriggerHandler.onBeforeInsert(new List<Match__c>{mewMatch5, mewMatch6});

        List<Match__c> updatedMatches = [
            SELECT Id, Name, PreviousMatchBetweenTeamsDatetime__c
            FROM Match__c
            ORDER BY StartDateTime__c DESC
            LIMIT 2
        ];

        System.assertEquals(
            prevDT6, 
            updatedMatches[0].PreviousMatchBetweenTeamsDatetime__c, 
            'MatchTriggerHandlerTest.onBeforeInsert is working incorrectly'
        );
        System.assertEquals(
            prevDT5, 
            updatedMatches[1].PreviousMatchBetweenTeamsDatetime__c,
            'MatchTriggerHandlerTest.onBeforeInsert is working incorrectly'
        );
    }
}
