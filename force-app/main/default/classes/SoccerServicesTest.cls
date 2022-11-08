@isTest
private class SoccerServicesTest {

    @TestSetup
    static void dataSetup(){

        Player__c newPlayer1 = new Player__c(Name = 'Player1', Email__c = 'player1@email.com', isActive__c = true);
        Player__c newPlayer2 = new Player__c(Name = 'Player2', Email__c = 'player2@email.com', isActive__c = true);
        insert new List<Player__c>{newPlayer1, newPlayer2};

        Team__c newTeam1 = new Team__c(Name = 'Team1', TotalWins__c = 3, TotalActivePlayers__c = 11);
        Team__c newTeam2 = new Team__c(Name = 'Team2', TotalWins__c = 1, TotalActivePlayers__c = 11);
        insert new List<Team__c>{newTeam1, newTeam2};

        DateTime dt = DateTime.valueOf('2022-11-30 17:00:00');

        Match__c mewMatch1 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt, HomeTeam__c = newTeam1.Id, Visitors__c = newTeam2.Id
        );
        insert new List<Match__c>{mewMatch1};
    }

    @isTest
    static void createPlayerTest(){

        String name = 'Player3';
        String email = 'player3@email.com';
        Map<SObjectField, Object> extraValues = new Map<SObjectField, Object>();
        Schema.SObjectField statusField = Player__c.isActive__c;
        Object isActiveStatus = true;
        extraValues.put(statusField, isActiveStatus);

        Test.startTest();
        SoccerService.createPlayer(name, email, extraValues);
        Test.stopTest();

        Player__c createdPlayer = [
            SELECT Name, Email__c
            FROM Player__c
            WHERE Name = 'Player3' AND Email__c = 'player3@email.com'
        ];

        System.assertEquals(
            'player3@email.com',
            createdPlayer.Email__c, 
            'SoccerServices.createPlayer is working incorrectly'
        );
    }

    @isTest
    static void arangeMatchTest(){

        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Id homeTeamId = teamsList.get(0).Id;
        Id visitorsTeamId = teamsList.get(1).Id;
        DateTime mathcDT = DateTime.valueOf('2022-12-30 17:00:00');

        Test.startTest();
        SoccerService.arangeMatch(mathcDT, homeTeamId, visitorsTeamId);
        Test.stopTest();

        Match__c createdMatch = [
            SELECT Name, StartDateTime__c, HomeTeam__c, Visitors__c 
            FROM Match__c 
            WHERE StartDateTime__c =: mathcDT
              
        ];

        System.assert(
            createdMatch.StartDateTime__c == mathcDT && createdMatch.HomeTeam__c == homeTeamId && createdMatch.Visitors__c == visitorsTeamId, 
            'SoccerServices.arangeMatch is working incorrectly'
        );
    }

    @isTest
    static void setScoreToMatchesTest(){

        Match__c matchToUpdate = [
            SELECT Id, Name, StartDateTime__c, HomeTeam__c, Visitors__c 
            FROM Match__c 
            WHERE Name =: 'Team1 - Team2'  
        ];

        Id matchId = matchToUpdate.Id;
        Integer homeTeamScore = 2;
        Integer visitorsTeamScore = 1;

        List<SoccerService.ScoreHelper> scoresList = SoccerService.getList(matchId, homeTeamScore, visitorsTeamScore);

        Test.startTest();
        SoccerService.setScoreToMatches(scoresList);
        Test.stopTest();

        Match__c updatedMatch = [
            SELECT Id, Name, StartDateTime__c, HomeTeam__c, Visitors__c, Score__c 
            FROM Match__c 
            WHERE Id =: matchId  
        ];

        System.assertEquals(
            '2:1',
            updatedMatch.Score__c, 
            'SoccerServices.setScoreToMatches is working incorrectly'
        );
    }

    @isTest
    static void deactivatePlayersTest(){

        List<Player__c> playersToDeactivate = [
            SELECT Id, isActive__c
            FROM Player__c
            WHERE isActive__c = true
            LIMIT 2
        ];
        
        Id player1Id = playersToDeactivate.get(0).Id;
        Id player2Id = playersToDeactivate.get(1).Id;

        Test.startTest();
        SoccerService.deactivatePlayers(new List<Id>{player1Id, player2Id});
        Test.stopTest();

        List<Player__c> deactivatedPlayers = [
            SELECT Id, isActive__c
            FROM Player__c
            WHERE isActive__c = false
        ];

        System.assert(
            deactivatedPlayers[0].isActive__c == false && deactivatedPlayers[1].isActive__c == false, 
            'SoccerServices.deactivatePlayers is working incorrectly'
        );
    }
}