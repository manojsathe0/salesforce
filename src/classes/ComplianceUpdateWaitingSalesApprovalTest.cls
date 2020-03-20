@isTest
private class ComplianceUpdateWaitingSalesApprovalTest 
{
    
    static User salesRepUser1;
    static User salesRepUser2;
    
    static void setupData()
    {
        // Insert Sales Manager User
        User salesMgrUser1 = TestUtils.SALES_MGR_USER;
        salesMgrUser1.CommunityNickname = 'alkjvxa';
        User salesMgrUser2 = TestUtils.SALES_MGR_USER;
        salesMgrUser2.Username += 'b';
        salesMgrUser2.CommunityNickname = 'alkjvxb';
        System.runAs(TestUtils.ADMIN_USER)
        {
            insert new User[]{salesMgrUser1, salesMgrUser2};
        }
        
        // Insert Sales Rep Users
        salesRepUser1 = TestUtils.SALES_REP_USER;
        salesRepUser1.CommunityNickname = 'alkjvxc';
        salesRepUser1.ManagerId = salesMgrUser1.Id;
        
        salesRepUser2 = TestUtils.SALES_REP_USER;
        salesRepUser2.CommunityNickname = 'alkjvxd';
        salesRepUser2.Username += 'b';
        salesRepUser2.ManagerId = salesMgrUser2.Id;
        System.runAs(TestUtils.ADMIN_USER)
        {
            insert new User[]{salesRepUser1, salesRepUser2};
        }
        
        Compliance_Review_Number_Of_DayMonth__c numberDay1 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay1.Name = 'Had Violation Day';
        numberDay1.Number__c = 3;
        
        Compliance_Review_Number_Of_DayMonth__c numberDay2 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay2.Name = 'Awaiting Approval Day';
        numberDay2.Number__c = 4;
        
        Compliance_Review_Number_Of_DayMonth__c numberDay3 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay3.Name = 'Corrective Plan UPL Coaching';
        numberDay3.Number__c = 6;
        
        Compliance_Review_Number_Of_DayMonth__c numberDay4 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay4.Name = 'Written Warning Period';
        numberDay4.Number__c = 6;
        
        Compliance_Review_Number_Of_DayMonth__c numberDay5 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay5.Name = 'Day Violations';
        numberDay5.Number__c = 90;
         
        insert new Compliance_Review_Number_Of_DayMonth__c[]{numberDay1,numberDay2,numberDay3,numberDay4,numberDay5};
        
        Compliance_Review_Last_Corrective_Plan__c terminationtStatus = new Compliance_Review_Last_Corrective_Plan__c();
        terminationtStatus.Name = 'Termination';
        terminationtStatus.LCP_Status__c = 'Termination';
        
        Compliance_Review_Last_Corrective_Plan__c dayViolationsStatus = new Compliance_Review_Last_Corrective_Plan__c();
        dayViolationsStatus.Name = 'Day Violations';
        dayViolationsStatus.LCP_Status__c = 'Coaching, Verbal, Training';
        
        Compliance_Review_Last_Corrective_Plan__c writtenWarningPeriodStatus = new Compliance_Review_Last_Corrective_Plan__c();
        writtenWarningPeriodStatus.Name = 'Written Warning Period';
        writtenWarningPeriodStatus.LCP_Status__c = '1st Written, 2nd Written';

        insert new Compliance_Review_Last_Corrective_Plan__c[]{dayViolationsStatus,writtenWarningPeriodStatus,terminationtStatus};
        
        Compliance_Review_Status__c statusAwaiting = new Compliance_Review_Status__c();
        statusAwaiting.Name = 'Awaiting Status';
        statusAwaiting.Compliance_Status__c = 'Awaiting Sales Approval, Awaiting Rep Coaching';
        
        Compliance_Review_Status__c repCoachingCompletedStatus = new Compliance_Review_Status__c();
        repCoachingCompletedStatus.Name = 'Rep Coaching Completed';
        repCoachingCompletedStatus.Compliance_Status__c = 'Rep Coaching Completed';
        insert new Compliance_Review_Status__c[]{statusAwaiting,repCoachingCompletedStatus};
    }
    
    static testMethod void testDoScheduling_Holiday_Positive() 
    {
        setupData();
        // Create Compliance Reviews
        Compliance_Review__c cr1 = new Compliance_Review__c();
        cr1.Representative__c = salesRepUser2.Id;
        cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr1.Awaiting_Sales_Approval_Date_Time__c = DateTime.valueOf('2014-07-25 16:03:23');
        cr1.Recorded_Call_ID__c = '161121';
        cr1.Length_of_Call__c = 4.50;
        cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
        cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
        cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr1.Violation_A5__c = 'No'; //Customer_Verification_Violation__c
        cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
        cr1.Violation_A8__c = 'No'; //Tax_Advice_Violation__c
        cr1.CreatedDate = DateTime.valueOf('2014-07-25 16:03:23');
        cr1.LastModifiedDate = DateTime.valueOf('2014-07-25 16:03:23');
        insert cr1;
        
        Compliance_Review__c compQueryTest1 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Sales_Rep_Manager__c, 
                                                      Compliance_Review__c.UPL_Violation__c,
                                                      Compliance_Review__c.Unethical_Business_Practice_Violation__c,
                                                      Compliance_Review__c.Disclaimer_Violation__c,
                                                      Compliance_Review__c.Unauthorized_Discount_Violation__c,
                                                      Compliance_Review__c.Customer_Verification_Violation__c,
                                                      Compliance_Review__c.Tax_Advice_Violation__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Awaiting_Sales_Approval_Date_Time__c,
                                                      Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c
                                              FROM Compliance_Review__c WHERE Id =: cr1.Id][0];
        System.assertEquals('Need to Submit for Approval', compQueryTest1.Status__c);
        System.assertEquals(DateTime.valueOf('2014-07-25 16:03:23'), compQueryTest1.Awaiting_Sales_Approval_Date_Time__c);
        System.assertEquals(false, compQueryTest1.Sent_Email_Waiting_Sales_Approval_3_Days__c);
        
        compQueryTest1.Status__c = 'Awaiting Sales Approval';
        update compQueryTest1;
        
        Compliance_Review__c compQueryTest2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Awaiting_Sales_Approval_Date_Time__c,
                                                      Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c
                                              FROM Compliance_Review__c WHERE Id =: compQueryTest1.Id][0];
        System.assertEquals('Awaiting Sales Approval', compQueryTest2.Status__c);
        Test.startTest();
            ComplianceUpdateWaitingSalesApproval.doScheduling();
        Test.stopTest();
    }
    
    static testMethod void testDoScheduling_WithoutHolidayPeriod() 
    {
        setupData();
        // Create Compliance Reviews
        Compliance_Review__c cr1 = new Compliance_Review__c();
        cr1.Representative__c = salesRepUser2.Id;
        cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr1.Awaiting_Sales_Approval_Date_Time__c = DateTime.valueOf('2014-07-30 16:03:23');
        cr1.Recorded_Call_ID__c = '161121';
        cr1.Length_of_Call__c = 4.50;
        cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
        cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
        cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr1.Violation_A5__c = 'No'; //Customer_Verification_Violation__c
        cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
        cr1.CreatedDate = DateTime.valueOf('2014-07-30 16:03:23');
        cr1.LastModifiedDate = DateTime.valueOf('2014-07-30 16:03:23');
        insert cr1;
        
        Compliance_Review__c compQueryTest1 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Sales_Rep_Manager__c, 
                                                      Compliance_Review__c.UPL_Violation__c,
                                                      Compliance_Review__c.Unethical_Business_Practice_Violation__c,
                                                      Compliance_Review__c.Disclaimer_Violation__c,
                                                      Compliance_Review__c.Unauthorized_Discount_Violation__c,
                                                      Compliance_Review__c.Customer_Verification_Violation__c,
                                                      Compliance_Review__c.Tax_Advice_Violation__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Awaiting_Sales_Approval_Date_Time__c,
                                                      Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c
                                              FROM Compliance_Review__c WHERE Id =: cr1.Id][0];
        System.assertEquals('Need to Submit for Approval', compQueryTest1.Status__c);
        System.assertEquals(DateTime.valueOf('2014-07-30 16:03:23'), compQueryTest1.Awaiting_Sales_Approval_Date_Time__c);
        System.assertEquals(false, compQueryTest1.Sent_Email_Waiting_Sales_Approval_3_Days__c);
        
        compQueryTest1.Status__c = 'Awaiting Sales Approval';
        update compQueryTest1;
        
        Compliance_Review__c compQueryTest2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Awaiting_Sales_Approval_Date_Time__c,
                                                      Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c
                                              FROM Compliance_Review__c WHERE Id =: compQueryTest1.Id][0];
        System.assertEquals('Awaiting Sales Approval', compQueryTest2.Status__c);
        Test.startTest();
            ComplianceUpdateWaitingSalesApproval.doScheduling();
        Test.stopTest();
    }
}