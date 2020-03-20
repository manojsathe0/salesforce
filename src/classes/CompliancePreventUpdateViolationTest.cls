@isTest
private class CompliancePreventUpdateViolationTest 
{
    static User salesRepUser1;
    static User salesRepUser2;
    static Id SCORECARD_RECORDTYPE;
    static Compliance_Review__c comp;
    
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
        salesRepUser1.CommunityNickname = 'alkjvxd';
        salesRepUser2.Username += 'b';
        salesRepUser2.ManagerId = salesMgrUser2.Id;
        System.runAs(TestUtils.ADMIN_USER)
        {
            insert new User[]{salesRepUser1, salesRepUser2};
        }
        
        Compliance_Review_Number_Of_DayMonth__c numberDay1 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay1.Name = 'Corrective Plan UPL Coaching';
        numberDay1.Number__c = 6;
        
        Compliance_Review_Number_Of_DayMonth__c numberDay2 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay2.Name = 'Written Warning Period';
        numberDay2.Number__c = 6;
        
        Compliance_Review_Number_Of_DayMonth__c numberDay3 = new Compliance_Review_Number_Of_DayMonth__c();
        numberDay3.Name = 'Day Violations';
        numberDay3.Number__c = 90;
        
        insert new Compliance_Review_Number_Of_DayMonth__c[]{numberDay1,numberDay2,numberDay3};
        
        Compliance_Review_Last_Corrective_Plan__c dayViolationsStatus = new Compliance_Review_Last_Corrective_Plan__c();
        dayViolationsStatus.Name = 'Day Violations';
        dayViolationsStatus.LCP_Status__c = 'Coaching, Verbal, Training';
        
        Compliance_Review_Last_Corrective_Plan__c writtenWarningPeriodStatus = new Compliance_Review_Last_Corrective_Plan__c();
        writtenWarningPeriodStatus.Name = 'Written Warning Period';
        writtenWarningPeriodStatus.LCP_Status__c = '1st Written, 2nd Written';
        
        Compliance_Review_Last_Corrective_Plan__c terminationtStatus = new Compliance_Review_Last_Corrective_Plan__c();
        terminationtStatus.Name = 'Termination';
        terminationtStatus.LCP_Status__c = 'Termination';
        
        insert new Compliance_Review_Last_Corrective_Plan__c[]{dayViolationsStatus,writtenWarningPeriodStatus,terminationtStatus};
        
        Compliance_Review_Status__c repCoachingCompletedStatus = new Compliance_Review_Status__c();
        repCoachingCompletedStatus.Name = 'Rep Coaching Completed';
        repCoachingCompletedStatus.Compliance_Status__c = 'Rep Coaching Completed';
        insert repCoachingCompletedStatus;
        
        SCORECARD_RECORDTYPE = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        comp = new Compliance_Review__c();
        comp.RecordTypeId = SCORECARD_RECORDTYPE;
        comp.Representative__c = salesRepUser1.Id;
        comp.Recorded_Call_ID__c = 'AB0001';
        insert comp;
    }
    
    static testMethod void testPreventUpdateViolationFields_Positive() 
    {
        setupData();
        
        List<Compliance_Review__c> compOldList = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.ID =: comp.Id
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                 ];
        
        List<Compliance_Review__c> updateCompList1 = new List<Compliance_Review__c>();
        for(Compliance_Review__c comp2 : compOldList)
        {
            comp.Status__c = 'Compliant';
            updateCompList1.add(comp);
        }
        update updateCompList1;
        
        Compliance_Review__c comp2 = new Compliance_Review__c();
        comp2.RecordTypeId = SCORECARD_RECORDTYPE;
        comp2.Representative__c = salesRepUser1.Id;
        comp2.Recorded_Call_ID__c = 'AB0002';
        comp2.Status__c = 'Compliant';
        insert comp2;
        
        List<Compliance_Review__c> updateCompList2 = new List<Compliance_Review__c>();
        User qaCompUser = [SELECT  Id FROM User WHERE  Profile.Name = 'Compliance Manager' and IsActive = true LIMIT 1];
        
        List<Compliance_Review__c> compOldList2 = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                     FROM Compliance_Review__c 
                                                     WHERE Compliance_Review__c.ID =: updateCompList1[0].Id
                                                  ];
        
        for(Compliance_Review__c comp3 : compOldList2)
        {
            comp3.Violation_A1__c = 'Disqualified';
            updateCompList2.add(comp3);
        }

        try
        {
            System.runAs(qaCompUser)
            {
                Test.startTest();
                    update updateCompList2;
                Test.stopTest();
            }
        }
        catch(Exception ex)
        {
            System.assert(ex.getMessage().contains(CompliancePreventUpdateViolationFields.COMPLIANCE_ERROR_MESSAGE));
        }
    }
    
    static testMethod void testPreventUpdateViolationFields_Negative() 
    {
        setupData();
        
        List<Compliance_Review__c> compOldList = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.ID =: comp.Id
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                 ];
        
        List<Compliance_Review__c> updateCompList1 = new List<Compliance_Review__c>();
        for(Compliance_Review__c comp2 : compOldList)
        {
            comp.Status__c = 'Compliant';
            updateCompList1.add(comp);
        }
        update updateCompList1;
        
        Compliance_Review__c comp2 = new Compliance_Review__c();
        comp2.RecordTypeId = SCORECARD_RECORDTYPE;
        comp2.Representative__c = salesRepUser1.Id;
        comp2.Recorded_Call_ID__c = 'AB0002';
        comp2.Status__c = 'Compliant';
        insert comp2;
        
        List<Compliance_Review__c> updateCompList2 = new List<Compliance_Review__c>();
        User qaCompUser = [SELECT  Id FROM User WHERE  Profile.Name = 'Compliance Manager' and IsActive = true LIMIT 1];
        
        List<Compliance_Review__c> compOldList2 = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.Representative__c =: salesRepUser1.Id
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                 ];
        
        compOldList2[0].Violation_A1__c = 'Disqualified';
        updateCompList2.add(compOldList2[0]);
        
        System.runAs(qaCompUser)
        {
            Test.startTest();
                update updateCompList2;
            Test.stopTest();
        }
    }
    
    static testMethod void testPreventUpdateViolationFields_AdminUpdate_Negative() 
    {
        setupData();
        
        List<Compliance_Review__c> compOldList = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.ID =: comp.Id
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                 ];
        
        List<Compliance_Review__c> updateCompList1 = new List<Compliance_Review__c>();
        for(Compliance_Review__c comp2 : compOldList)
        {
            comp.Status__c = 'Compliant';
            updateCompList1.add(comp);
        }
        update updateCompList1;
        
        Compliance_Review__c comp2 = new Compliance_Review__c();
        comp2.RecordTypeId = SCORECARD_RECORDTYPE;
        comp2.Representative__c = salesRepUser1.Id;
        comp2.Recorded_Call_ID__c = 'AB0002';
        comp2.Status__c = 'Compliant';
        insert comp2;
        
        List<Compliance_Review__c> updateCompList2 = new List<Compliance_Review__c>();
        User adminCompUser = TestUtils.ADMIN_USER;
        
        List<Compliance_Review__c> compOldList2 = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.Id =: updateCompList1[0].Id
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                 ];
        
        compOldList2[0].Violation_A1__c = 'Disqualified';
        updateCompList2.add(compOldList2[0]);
        
        System.runAs(adminCompUser)
        {
            Test.startTest();
                update updateCompList2;
            Test.stopTest();
        }
        
        List<Compliance_Review__c> compOldList3 = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.Id =: updateCompList2[0].Id
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                 ];
        System.assertEquals('Disqualified', compOldList2[0].Violation_A1__c);
    }
}