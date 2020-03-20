/**
     *  @author         Saikiran Salla - ssalla@legalzoom.com
     *  @description    Batch Class for processing DNC phone number checking in LZ InternalList
     *  @history        2019-March-22   -   Created
*/

public class DNC_checkDNCList_Schedule implements Schedulable {
    Private final String DEFAULT_DAYS = 'Default Days';
    Private final String APEX_CLASS = 'DNC_CheckDNCList_Batch';
    Private final String BATCH_STATUS = 'In Progress';

    public void execute(SchedulableContext sc) {
        //Get RecordTypeID
        Id conPrimaryRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Id leadPrimaryRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard Lead').getRecordTypeId();

        //Get days from custom Metadata
        DNC_DaysCount__c daysCount = DNC_DaysCount__c.getInstance(DEFAULT_DAYS);
        Integer daysToRun = Integer.valueOf(daysCount.Days_to_Run__C);
        Date lastRanDate = daysCount.Last_Ran_Date__c;
        Integer batchScope = Integer.valueOf(daysCount.Batch_Scope__c);

        Date today = Date.today();

        List<AsyncApexJob> aajList = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = : APEX_CLASS AND Status = : BATCH_STATUS];

        if (!aajList.isEmpty()) {
            //Maximum Length is 70 characters.
            daysCount.Exception__c = 'Batch is already in-Progress, Failed to run on ' + today;
            //DNC_Utility.dmlSobject(DNC_Utility.DML_UPDATE, daysCount);
        } else if (lastRanDate.daysBetween(today) >= daysToRun) {
            Database.executebatch(new DNC_CheckDNCList_Batch(DNC_Utility.CONTACT, conPrimaryRT, leadPrimaryRT), batchScope);
            Database.executebatch(new DNC_CheckDNCList_Batch(DNC_Utility.LEAD, conPrimaryRT, leadPrimaryRT), batchScope);

              //Update Custom Settings
            daysCount.Last_Ran_Date__c = today;
            daysCount.Exception__c = '';
        }
        DNC_Utility.dmlSobject(DNC_Utility.DML_UPDATE, daysCount);
    }
}