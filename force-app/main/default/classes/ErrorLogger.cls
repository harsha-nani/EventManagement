public class ErrorLogger {
    public static void log(DateTime logDateTime, String logDetails, String processName) {
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Log_Date_Time__c = logDateTime;
        errorLog.Log_Details__c = logDetails;
        errorLog.Process_Name__c = processName;

        try {
            insert errorLog;
        } catch (Exception e) {
            System.debug('Error while logging: ' + e.getMessage());
        }
    }
}