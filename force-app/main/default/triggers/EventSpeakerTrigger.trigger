trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    EventSpeakerHandler.preventDuplicateBookings(Trigger.new);
}