public class AttendeeTriggerHandler{
    public static void sendalert(list<Event_Attendee__c> newAttendees){
            Set<Id> attendeeIds = new Set<Id>();
            Set<Id> eventIds = new Set<Id>();
        
            for (Event_Attendee__c ea : newAttendees) {
                if (ea.Attendees__c != null) attendeeIds.add(ea.Attendees__c);
                if (ea.Event__c != null) eventIds.add(ea.Event__c);
            }

            Map<Id, Attendees__c> attendeeMap = new Map<Id, Attendees__c>(
                [SELECT Id, Name, Email__c, Phone__c FROM Attendees__c WHERE Id IN :attendeeIds]
            );

            Map<Id, Event1__c> eventMap = new Map<Id, Event1__c>(
                [SELECT Id, Name, Start_Date_Time__c, Location__c, Organizer__c FROM Event1__c WHERE Id IN :eventIds]
            );

        list<Messaging.SingleEmailMessage> lstemail= new List<Messaging.SingleEmailMessage>();
         for (Event_Attendee__c ea : newAttendees) {
                Attendees__c attendee = attendeeMap.get(ea.Attendees__c);
                Event1__c eventRec = eventMap.get(ea.Event__c);

                if (attendee != null && String.isNotBlank(attendee.Email__c)) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setsubject('Pass for the'+ eventRec.Name + '"');
            email.setplainTextBody('This is a notification by Salesforce Dear'+ attendee +' , Thank you for registering for'+eventRec.Name+'which will be Organized on'
                                   +String.valueOf(eventRec.Start_Date_Time__c) +
                                   ' & will be held in'+eventRec.Location__c+
                                   'We are excited to have you, see you at the event.Find the Google Map Location for the Event Here' 
                                   + '(https://www.google.com/maps/place/)' + 'Add your Location HereThanks,' + eventRec.Organizer__c);
            email.setToAddresses(new String[] {attendee.Email__c});
            lstemail.add(email);
           
        }
        }
        if(!lstemail.isempty()){
         Messaging.sendEmail(lstemail);
            
     	}
   
    }
}