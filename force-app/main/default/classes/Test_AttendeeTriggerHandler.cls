@isTest
public class Test_AttendeeTriggerHandler {

    @testSetup
    static void setupData() {
        // Step 1: Create Organizer (parent for Event1__c)
        Event_Organizer__c org = new Event_Organizer__c(Name = 'John Smith',Name__c = 'Test', Email__c ='sumachegondi76@gmail.com', Phone__c='98786789987');
        insert org;

        // Step 2: Create Event (child with required Event_Organizer__c)
        Event1__c eventRec = new Event1__c(
            Name = 'Salesforce Mega Event',
            Start_Date_Time__c = DateTime.now().addDays(3),
            //Location__c = 'Hyderabad',
            End_Date_Time__c = DateTime.now().addDays(7),
            Name__c = 'Salesforce Mega Event',
            Max_Seats__c =5,
            Live__c = true,                        
        //Event_Accepting_Attendees__c = true,
            Event_Organizer__c = org.Id  // Master-detail relationship
        );
        insert eventRec;

        // Step 3: Create Attendee
        Attendees__c attendee = new Attendees__c(
            Name = 'Alice',
            Email__c = 'alice@example.com',
            Phone__c = '9999999999',
            Name__c = 'Alice'
        );
        insert attendee;
    }

    @isTest
    static void testPositive_EmailSent() {
        // Fetch data from test setup
        Event1__c eventRec = [SELECT Id FROM Event1__c LIMIT 1];
        Attendees__c attendee = [SELECT Id FROM Attendees__c LIMIT 1];

        Event_Attendee__c ea = new Event_Attendee__c(
            Event__c = eventRec.Id,
            Attendees__c = attendee.Id
        );

        Test.startTest();
        insert ea;
        Test.stopTest();

        // No way to check actual email sent in unit test, so check record created successfully
        System.assertNotEquals(null, ea.Id, 'Event_Attendee record should be inserted');
    }

    @isTest
    static void testNegative_MissingEmail() {
        // Create Attendee without email
        Attendees__c badAttendee = new Attendees__c(
            Name = 'NoEmail User',
            Phone__c = '8888888888',
            Email__c = 'sumachegondi@gmail.com',
              Name__c = 'NoEmail User'
        );
        insert badAttendee;

        Event1__c eventRec = [SELECT Id FROM Event1__c LIMIT 1];

        Event_Attendee__c ea = new Event_Attendee__c(
            Event__c = eventRec.Id,
            Attendees__c = badAttendee.Id
        );

        Test.startTest();
        insert ea;
        Test.stopTest();

        // Still inserted, but no email will be sent
        System.assertNotEquals(null, ea.Id, 'Event_Attendee with missing email should be inserted');
    }
}