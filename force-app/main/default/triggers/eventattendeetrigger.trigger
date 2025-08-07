trigger eventattendeetrigger on Event_Attendee__c (after insert) {
    	AttendeeTriggerHandler.sendalert(Trigger.new);
}