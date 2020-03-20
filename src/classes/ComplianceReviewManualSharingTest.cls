@isTest
private class ComplianceReviewManualSharingTest 
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
        
        Compliance_Review_Status__c excludeCompletedStatus = new Compliance_Review_Status__c();
        excludeCompletedStatus.Name = 'Exclude Complete Status';
        excludeCompletedStatus.Compliance_Status__c = 'Accept Coaching Rejection, Compliant, Rep Coaching Completed, QA Mgr Disputed';
        
        Compliance_Review_Status__c statusAwaiting = new Compliance_Review_Status__c();
        statusAwaiting.Name = 'Awaiting Status';
        statusAwaiting.Compliance_Status__c = 'Awaiting Sales Approval, Awaiting Rep Coaching';
        
        Compliance_Review_Status__c repCoachingCompletedStatus = new Compliance_Review_Status__c();
        repCoachingCompletedStatus.Name = 'Rep Coaching Completed';
        repCoachingCompletedStatus.Compliance_Status__c = 'Rep Coaching Completed';
    insert new Compliance_Review_Status__c[]{excludeCompletedStatus,statusAwaiting,repCoachingCompletedStatus};
  }
  
    public static testmethod void testSalesRepManualSharing_Positive()
    {
      setupData();
      List<Compliance_Review__c> compInsertList = new List<Compliance_Review__c>();
        // Create Compliance Reviews
    Compliance_Review__c cr1 = new Compliance_Review__c();
      cr1.Representative__c = salesRepUser1.Id;
      compInsertList.add(cr1);
        insert cr1;
        
        List<Compliance_Review__c> compQuery = [SELECT Id, Status__c, Representative__c FROM Compliance_Review__c WHERE Id =: cr1.ID];
        List<Compliance_Review__c> compUpdateList = new List<Compliance_Review__c>(); 
        for(Compliance_Review__c comp : compQuery)
        {
          comp.Status__c = 'Compliant';
          compUpdateList.add(comp);
        }
        Test.startTest();
          update compUpdateList;
        Test.stopTest();
        
        // Query job sharing records.
        List<Compliance_Review__Share> compShrs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause 
                     FROM Compliance_Review__Share 
                     WHERE ParentId = :compUpdateList[0].Id 
                     AND UserOrGroupId = :compUpdateList[0].Representative__c];
        // Insert manual share for user who is not record owner.
        System.assertEquals(1, compShrs.size());
    }
    
    public static testmethod void testSalesRepManualSharing_Batch_Positive()
    {
      setupData();
      List<Compliance_Review__c> compInsertList = new List<Compliance_Review__c>();
      List<User> userList = [ SELECT Id, ManagerID, ProfileID 
                  FROM User 
                  WHERE User.ProfileId =: TestUtils.salesAgentProfileId 
                  AND User.Division = 'Sales'
                  AND IsActive = true 
                    AND ManagerId != null 
                                ORDER BY CreatedDate ASC LIMIT 5];
      for(User u : userList)
      {
        // Create Compliance Reviews
      Compliance_Review__c cr1 = new Compliance_Review__c();
      cr1.Status__c = 'Compliant';
        cr1.Representative__c = u.Id;
        compInsertList.add(cr1);
      }

        Test.startTest();
          insert compInsertList;
        Test.stopTest();
        
        Set<Id> recordId = new Set<Id>();
        Set<Id> RepresentativeId = new Set<Id>();
        for(Compliance_Review__c comp : compInsertList)
        {
          recordId.add(comp.Id);
          RepresentativeId.add(comp.Representative__c);
        }
        
        ComplianceReviewManualSharing compShare = new ComplianceReviewManualSharing();
        compShare.complianceReviewManualSharingBatch();
        
        // Query job sharing records.
        List<Compliance_Review__Share> compShrs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause 
                     FROM Compliance_Review__Share 
                     WHERE ParentId IN: recordId 
                     AND UserOrGroupId IN: RepresentativeId];
        // Insert manual share for user who is not record owner.
        System.assertEquals(compShrs.size(), compInsertList.size());
    }
    
    public static testmethod void testSalesRepManualSharing_Batch_Negative()
    {
      setupData();
      List<Compliance_Review__c> compInsertList = new List<Compliance_Review__c>();
      List<User> userList = [ SELECT Id, ManagerID, ProfileID 
                  FROM User 
                  WHERE User.ProfileId =: TestUtils.salesAgentProfileId 
                  AND User.Division = 'Sales'
                  AND IsActive = true 
                    AND ManagerId != null 
                                ORDER BY CreatedDate ASC LIMIT 5];
      for(User u : userList)
      {
        // Create Compliance Reviews
      Compliance_Review__c cr1 = new Compliance_Review__c();
      cr1.Status__c = 'Draft';
        cr1.Representative__c = u.Id;
        compInsertList.add(cr1);
      }
      Test.startTest();
          insert compInsertList;
        Test.stopTest();
        
        Set<Id> recordId = new Set<Id>();
        Set<Id> RepresentativeId = new Set<Id>();
        for(Compliance_Review__c comp : compInsertList)
        {
          recordId.add(comp.Id);
          RepresentativeId.add(comp.Representative__c);
        }
        
        ComplianceReviewManualSharing compShare = new ComplianceReviewManualSharing();
        compShare.complianceReviewManualSharingBatch();

        // Query job sharing records.
        List<Compliance_Review__Share> compShrs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause 
                     FROM Compliance_Review__Share 
                     WHERE ParentId IN: recordId 
                     AND UserOrGroupId IN: RepresentativeId];
        // Insert manual share for user who is not record owner.
        System.assertEquals(0, compShrs.size());
    }
    
    public static testmethod void testSalesRepManualSharing_Negative()
    {
      setupData();
      List<Compliance_Review__c> compInsertList = new List<Compliance_Review__c>();
        // Create Compliance Reviews
    Compliance_Review__c cr2 = new Compliance_Review__c();
      cr2.Representative__c = salesRepUser2.Id;
      compInsertList.add(cr2);
        insert cr2;
        
        List<Compliance_Review__c> compQuery = [SELECT Id, Status__c, Representative__c FROM Compliance_Review__c WHERE Id =: cr2.ID];
        List<Compliance_Review__c> compUpdateList = new List<Compliance_Review__c>(); 
        for(Compliance_Review__c comp : compQuery)
        {
          comp.Status__c = 'Awaiting Sales Approval';
          compUpdateList.add(comp);
        }
        
        Test.startTest();
          update compUpdateList;
        Test.stopTest();
        
        // Query job sharing records.
        List<Compliance_Review__Share> compShrs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause 
                     FROM Compliance_Review__Share 
                     WHERE ParentId = :compUpdateList[0].Id 
                     AND UserOrGroupId = :compUpdateList[0].Representative__c];
        // Insert manual share for user who is not record owner.
        System.assertEquals(compShrs.size(), 0);
    }
    
    public static testmethod void testSalesRepManualSharing_InvalidComplianceID_Negative()
    {
      setupData();
      List<Compliance_Review__c> compInsertList = new List<Compliance_Review__c>();
        // Create Compliance Reviews
    Compliance_Review__c cr2 = new Compliance_Review__c();
      cr2.Representative__c = salesRepUser2.Id;
      compInsertList.add(cr2);
        insert cr2;
        
        List<Compliance_Review__c> compQuery = [SELECT Id, Status__c, Representative__c FROM Compliance_Review__c WHERE Id =: cr2.ID];
        List<Compliance_Review__c> compUpdateList = new List<Compliance_Review__c>(); 
        for(Compliance_Review__c comp : compQuery)
        {
          comp.Status__c = 'Compliant';
          compUpdateList.add(comp);
        }
        
        Test.startTest();
          update compUpdateList;
        Test.stopTest();
        
        // Query job sharing records.
        List<Compliance_Review__Share> compShrs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause 
                     FROM Compliance_Review__Share 
                     WHERE ParentId = :compUpdateList[0].Id 
                     AND UserOrGroupId = :compUpdateList[0].Representative__c];
        // Insert manual share for user who is not record owner.
        System.assertEquals(compShrs.size(), 1);
        
        delete compUpdateList;
    }
}