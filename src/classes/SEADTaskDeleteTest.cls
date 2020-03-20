/**
 * Created by jboles on 5/16/2017.
 */
@isTest
public class SEADTaskDeleteTest
{
    static testMethod void testTaskDelete()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.Lead_New_Stage_Activity_Limit__c = 1;
        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
        config.Lead_Abandoner_Score__c = 1;
        config.Lead_Chat_Score__c = 1;
        config.Lead_Days_from_Ownership__c = 2;
        config.Lead_Email_Score__c = 1;
        config.Lead_Inbound_Score__c = 2;
        config.Lead_Mobile_Score__c = 3;
        config.Lead_Score_Initial__c = 3;
        config.Lead_Social_Media_Score__c = 1;


        insert config;


        system.runAs(u)
        {
            Lead testLead = TestUtils.createLeads(1 , 'Test LastName' , false)[0];

            Task theTask = new Task();
            theTask.WhoId = testLead.Id;
            theTask.Description = 'Test Description';
            theTask.CallObject = '998899';
            theTask.Marked_for_Delete__c = true;
            insert theTask;

            Test.startTest();
            SEAD_TaskDeletionSchedule myClass = new SEAD_TaskDeletionSchedule ();
            String chron = '0 0 23 * * ?';
            system.schedule('SEAD_TaskDeletion Sched', chron, myClass);
            Test.stopTest();
        }

    }
    static testMethod void testTaskDeleteFailure()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.Lead_New_Stage_Activity_Limit__c = 1;
        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
        config.Lead_Abandoner_Score__c = 1;
        config.Lead_Chat_Score__c = 1;
        config.Lead_Days_from_Ownership__c = 2;
        config.Lead_Email_Score__c = 1;
        config.Lead_Inbound_Score__c = 2;
        config.Lead_Mobile_Score__c = 3;
        config.Lead_Score_Initial__c = 3;
        config.Lead_Social_Media_Score__c = 1;


        insert config;


        system.runAs(u)
        {
            Lead testLead = TestUtils.createLeads(1 , 'Test LastName' , false)[0];

            Task theTask = new Task();
            theTask.WhoId = testLead.Id;
            theTask.Description = 'Test Description';
            theTask.CallObject = '998899';
            theTask.Marked_for_Delete__c = true;
            insert theTask;

            Test.startTest();
            SEAD_TaskDeletionSchedule myClass = new SEAD_TaskDeletionSchedule ();
            String chron = '0 0 23 * * ?';
            system.schedule('SEAD_TaskDeletion Sched', chron, myClass);


            List<Task> deleteTasks = new List<Task>();
            theTask.whoId = null;
            theTask.id = null;
            deleteTasks.add(theTask);
            SEAD_TaskDeletion taskDeleteClass = new SEAD_TaskDeletion();
            taskDeleteClass.handleErrors(deleteTasks);
            taskDeleteClass.handleErrors(null);

            Test.stopTest();
        }

    }
}