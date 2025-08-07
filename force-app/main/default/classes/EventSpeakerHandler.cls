public class EventSpeakerHandler {
    public static void preventDuplicateBookings(List<Event_Speaker__c> records) {
        Set<Id> speakerIds = new Set<Id>();
        for (Event_Speaker__c rec : records) {
            if (rec.Speaker__c != null) {
                speakerIds.add(rec.Speaker__c);
            }
        }
        if (speakerIds.isEmpty()) return;
        Map<Id, Id> existingBookings = new Map<Id, Id>();
        for (Event_Speaker__c es : [
            SELECT Id, Speaker__c FROM Event_Speaker__c
            WHERE Speaker__c IN :speakerIds
        ]) {
            existingBookings.put(es.Speaker__c, es.Id);
        }
        for (Event_Speaker__c rec : records) {
            if (rec.Speaker__c != null &&
                existingBookings.containsKey(rec.Speaker__c) &&
                rec.Id != existingBookings.get(rec.Speaker__c)) {
                rec.addError('This Speaker is already booked for an Event. Duplicate bookings are not allowed.');
            }
        }
    }
}