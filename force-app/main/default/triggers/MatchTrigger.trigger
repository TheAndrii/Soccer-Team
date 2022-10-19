trigger MatchTrigger on Match__c (after insert, after update, before insert, before update) {

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            MatchTriggerHandler.onAfterUpdate(Trigger.new);
        }     
    }
        else {
          MatchTriggerHandler.onBeforeInsert(Trigger.new);  
        }
}