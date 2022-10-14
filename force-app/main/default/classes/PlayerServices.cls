public class PlayerServices {
    
    public static Map<String, List<Player__c>> groupActiveByStatus (List<Player__c> listOfPlayers){
        
        List<Player__c> activePlayerList = new List<Player__c>();
        List<Player__c> inactivePlayerList = new List<Player__c>();
        Map<String, List<Player__c>> playersStatus = new Map<String, List<Player__c>>();
        
        for (Player__c player : listOfPlayers){
            if (player.IsActive__c == true){
            	activePlayerList.add(player);
            } else {
                inactivePlayerList.add(player);
            }
        }
        playersStatus.put('active', activePlayerList);
        playersStatus.put('inactive', inactivePlayerList);
        
        return playersStatus;
    }

}