@isTest
public class LogCallCaseControllerTest {
    static final String INBOUND = 'Inbound';
    static final String COMMENT = 'Test Comments';
    static final String NEW_STATUS = 'New';
    static final String NONE = '--None--';
    static final String UNRESOLVED_RESOLUTION = 'Unresolved - Initial Email Sent';
    static final String UNRESOLVED_OTHER_RESOLUTION = 'Unresolved – Other';
    static final String RESOLVED_RESOLUTION = 'Resolved - Not a Problem';
    static final String OTHER_REASON = 'OTHER Reason Test';

    static testMethod void testCreateTask_NoError()
    {
        Case testCase = TestUtils.createCases(1, true)[0];
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        LogCallCaseController theController = new LogCallCaseController(sc);
        PageReference pageRef = Page.LogCallCase;
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        Test.setCurrentPage(pageRef);

        Test.startTest();
            theController.theTask.Inbound_Outbound__c = INBOUND;
            theController.theTask.Description = COMMENT;
            theController.status = NEW_STATUS;
            theController.resolution = '--None--';
            theController.getCaseStatus();
            theController.getCaseProblemResolution();
            system.debug(theController.theTask);
            theController.createTask(); 
            system.debug(theController.theTask);
        Test.stopTest();

        List<Task> createdTasks = [SELECT Id , Subject, Description , Inbound_Outbound__c FROM Task WHERE WhatId =:testCase.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
        System.assertEquals(INBOUND + ' Activity' , createdTasks[0].Subject , 'Right subject should have been populated');
        System.assertEquals(INBOUND , createdTasks[0].Inbound_Outbound__c , 'Right Type should have been populated');
        
        List<Case> cases = [SELECT Id , Status , Problem_Order_Resolution__c , Problem_Order_Other_Reason__c FROM Case Where Id = :testCase.Id];
        System.assertEquals(1 , cases.size() , '1 Case should have been returned');
        System.assertEquals(NEW_STATUS , cases[0].Status , 'Right status should have been populated');
        System.assertEquals(NONE , cases[0].Problem_Order_Resolution__c , 'Right resolution should have been populated');
        System.assertEquals(null , cases[0].Problem_Order_Other_Reason__c , 'Other fields should not have been populated');

        List<CaseComment> insertedCaseComments = [Select Id , commentBody , ParentId From CaseComment Where ParentId =: testCase.Id];
        System.assertEquals(1 , insertedCaseComments.size() , '1 Case Comment should have been returned');
        System.assertEquals(COMMENT , insertedCaseComments[0].commentBody, 'Right Comment Body Should have been populated');
    }

    static testMethod void testCreateTask_UnresolvedErrorTest()
    {
        Case testCase = TestUtils.createCases(1, true)[0];
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        LogCallCaseController theController = new LogCallCaseController(sc);
        PageReference pageRef = Page.LogCallCase;
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        Test.setCurrentPage(pageRef);

        Test.startTest();
            theController.theTask.Inbound_Outbound__c = INBOUND;
            theController.theTask.Description = COMMENT;
            theController.status = NEW_STATUS;
            theController.resolution = RESOLVED_RESOLUTION;
            theController.createTask(); 
        Test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs)
        {
            System.assertEquals(msg.getDetail(),ProblemOrderConstants.RESOLVED_REASON_ERROR,'Right Error Message Should have been Populated');
        }

    }


    static testMethod void testCreateTask_OtherErrorTest()
    {
        Case testCase = TestUtils.createCases(1, true)[0];
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        LogCallCaseController theController = new LogCallCaseController(sc);
        PageReference pageRef = Page.LogCallCase;
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        Test.setCurrentPage(pageRef);

        Test.startTest();
            theController.theTask.Inbound_Outbound__c = INBOUND;
            theController.theTask.Description = COMMENT;
            theController.status = ProblemOrderConstants.CLOSED_STATUS;
            theController.resolution = UNRESOLVED_OTHER_RESOLUTION;
            theController.createTask(); 
        Test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs)
        {
            System.assertEquals(msg.getDetail(),ProblemOrderConstants.RESOLUTION_OTHER_ERROR,'Right Error Message Should have been Populated');
        }

    }
}