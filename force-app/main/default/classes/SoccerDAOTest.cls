@isTest
private class SoccerDAOTest {
    
    @TestSetup
    static void dataSetup(){
        
        Team__c newTeam1 = new Team__c(Name = 'Team1', TotalWins__c = 3, TotalActivePlayers__c = 11);
        Team__c newTeam2 = new Team__c(Name = 'Team2', TotalWins__c = 1, TotalActivePlayers__c = 11);
        Team__c newTeam3 = new Team__c(Name = 'Team3', TotalWins__c = 2, TotalActivePlayers__c = 11);
        insert new List<Team__c>{newTeam1, newTeam2, newTeam3};

        Player__c newPlayer1 = new Player__c(Name = 'Player1', isActive__c = true, Team__c = newTeam1.Id);
        Player__c newPlayer2 = new Player__c(Name = 'Player2', isActive__c = true, Team__c = newTeam1.Id);
        Player__c newPlayer3 = new Player__c(Name = 'Player3', isActive__c = true, Team__c = newTeam2.Id);
        Player__c newPlayer4 = new Player__c(Name = 'Player4', isActive__c = true, Team__c = newTeam2.Id);
        Player__c newPlayer5 = new Player__c(Name = 'Player5', isActive__c = true, Team__c = newTeam3.Id);
        Player__c newPlayer6 = new Player__c(Name = 'Player6', isActive__c = true, Team__c = newTeam3.Id);
        insert new List<Player__c>{newPlayer1, newPlayer2, newPlayer3, newPlayer4, newPlayer5, newPlayer6};

        DateTime dt = DateTime.valueOf('2022-11-30 17:00:00');

        Match__c mewMatch1 = new Match__c(
            Name = 'Team1 - Team2', StartDateTime__c = dt, HomeTeam__c = newTeam1.Id, Visitors__c = newTeam2.Id, Score__c = '1:0'
        );
        Match__c mewMatch2 = new Match__c(
            Name = 'Team2 - Team1', StartDateTime__c = dt, HomeTeam__c = newTeam2.Id, Visitors__c = newTeam1.Id, Score__c = '1:2'
        );
        Match__c mewMatch3 = new Match__c(
            Name = 'Team3 - Team1', StartDateTime__c = dt, HomeTeam__c = newTeam3.Id, Visitors__c = newTeam1.Id, Score__c = '0:0'
        );
        insert new List<Match__c>{mewMatch1, mewMatch2, mewMatch3};
    }

    @isTest
    static void getTeamsByIdsTest(){

        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Id team1Id = teamsList.get(0).Id;
        Id team2Id = teamsList.get(1).Id;

        Test.startTest();
        List<Team__c> resultingList = SoccerDAO.getTeamsByIds(new Set<Id>{team1Id, team2Id});
        Test.stopTest();
        
        System.assertEquals(
            team1Id,
            resultingList.get(0).Id, 
            'SoccerDAO.getTeamsByIds is working incorrectly'
        );
        System.assertEquals(
            team2Id,
            resultingList.get(1).Id, 
            'SoccerDAO.getTeamsByIds is working incorrectly'
        );
    }

    @isTest
    static void getActivePlayersTest(){
        
        Integer limitNumber = 2;
        Integer offsetNumber = 1;

        List<Player__c> playersList = [
            SELECT Id, Name, isActive__c
            FROM Player__c
            WHERE isActive__c = true  
            ORDER BY Name ASC LIMIT :limitNumber OFFSET :offsetNumber
        ];

        Id player1Id = playersList.get(0).Id;
        Id player2Id = playersList.get(1).Id;

        Test.startTest();
        List<Player__c> resultingList = SoccerDAO.getActivePlayers(limitNumber, offsetNumber);
        Test.stopTest();

        System.assertEquals(
            player1Id,
            resultingList.get(0).Id, 
            'SoccerDAO.getActivePlayers is working incorrectly'
        );
        System.assertEquals(
            player2Id,
            resultingList.get(1).Id, 
            'SoccerDAO.getActivePlayers is working incorrectly'
        );
    }

    @isTest
    static void getMostWinnerTeamTest(){

        Team__c mostWinnerTeam = [SELECT Id, Name FROM Team__c ORDER BY TotalWins__c DESC LIMIT 1];
        Id mostWinnerTeamId = mostWinnerTeam.Id;

        Test.startTest();
        Team__c result = SoccerDAO.getMostWinnerTeam();
        Test.stopTest();

        System.assertEquals(
            mostWinnerTeamId,
            result.Id, 
            'SoccerDAO.getMostWinnerTeam is working incorrectly'
        );
    }

    @isTest
    static void getWonMatchesCountByTeamIdTest(){

        Team__c team = [
            SELECT Id, TotalWins__c 
            FROM Team__c 
            ORDER BY Name ASC
            LIMIT 1
        ];

        Id teamId = team.Id;

        Test.startTest();
        Integer wonMatchesOfTeam = SoccerDAO.getWonMatchesCountByTeamId(teamId);
        Test.stopTest();

        System.assertEquals(
            team.TotalWins__c.intValue(),
            wonMatchesOfTeam, 
            'SoccerDAO.getWonMatchesCountByTeamId is working incorrectly'
        );
    }

    @isTest
    static void getTeamsWithPlayerNumberTestWithoutNull(){

        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Id team1Id = teamsList.get(0).Id;
        Id team2Id = teamsList.get(1).Id;
        
        Test.startTest();
        Map<Id, Integer> resultingMap = SoccerDAO.getTeamsWithPlayerNumber(new Set<Id>{team1Id, team2Id});
        Test.stopTest();

        System.assertEquals(
            2, 
            resultingMap.get(team1Id), 
            'SoccerDAO.getTeamsWithPlayerNumber is working incorrectly'
        );
        System.assertEquals(
            2, 
            resultingMap.get(team2Id), 
            'SoccerDAO.getTeamsWithPlayerNumber is working incorrectly'
        );
    }

    @isTest
    static void getTeamsWithPlayerNumberTestWithNull(){
        
        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Id team1Id = teamsList.get(0).Id;
        Id team2Id = teamsList.get(1).Id;
        Id team3Id = teamsList.get(2).Id;
        
        Test.startTest();
        Map<Id, Integer> resultingMap = SoccerDAO.getTeamsWithPlayerNumber(new Set<Id>{null});
        Test.stopTest();

        System.assertEquals(
            2, 
            resultingMap.get(team1Id), 
            'SoccerDAO.getTeamsWithPlayerNumber is working incorrectly'
        );
        System.assertEquals(
            2, 
            resultingMap.get(team2Id), 
            'SoccerDAO.getTeamsWithPlayerNumber is working incorrectly'
        );
        System.assertEquals(
            2, 
            resultingMap.get(team3Id), 
            'SoccerDAO.getTeamsWithPlayerNumber is working incorrectly'
        );
    }

    @isTest
    static void getTeamStatisticsTestWithoutNull(){
        
        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Id team1Id = teamsList.get(0).Id;
        Id team2Id = teamsList.get(1).Id;

        Test.startTest();
        Integer result = SoccerDAO.getTeamStatistics(new Set<Id>{team1Id, team2Id});
        Test.stopTest();

        System.assertEquals(
            11, 
            result, 
            'SoccerDAO.getTeamStatistics is working incorrectly'
        );
    }

    @isTest
    static void getTeamStatisticsTestWithNull(){
        
        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Id team1Id = teamsList.get(0).Id;
        Id team2Id = teamsList.get(1).Id;
        Id team3Id = teamsList.get(2).Id;

        Test.startTest();
        Integer result = SoccerDAO.getTeamStatistics(new Set<Id>{null});
        Test.stopTest();

        System.assertEquals(
            11, 
            result, 
            'SoccerDAO.getTeamStatistics is working incorrectly'
        );
    }

    @isTest
    static void getTeamWithMostScoresTest(){

        List<Team__c> teamsList = [
            SELECT Id, Name 
            FROM Team__c 
            ORDER BY Name ASC
        ];

        Team__c team1 = teamsList[0];

        Test.startTest();
        Team__c result = SoccerDAO.getTeamWithMostScores();
        Test.stopTest();

        System.assertEquals(
            team1, 
            result, 
            'SoccerDAO.getTeamWithMostScores is working incorrectly'
        );
    }
}