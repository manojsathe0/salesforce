@isTest
private class NewComplianceReviewControllerTest
{
     static SalesQA__c salesQAObj1, salesQAObj2, salesQAObj3, salesQAObj4;
     static Team_Management__c teamManage1, teamManage2, teamManage3, teamManage4, teamManage5, teamManage7, teamManage8, teamManage9;
     static SalesQARepRoles__c salesQARepRoleObj = new SalesQARepRoles__c();
     static Compliance_Review_Status__c compStatus = new Compliance_Review_Status__c();
     static User userTest, userTest2, userTest3, userTest4, userTest5, userTest6, userTest7;
     static Compliance_Review__c complianceReview = new Compliance_Review__c();
     static ID AdminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1][0].id;
     static ID managerProfileID = [SELECT Id FROM Profile WHERE Name = 'Sales Manager' LIMIT 1][0].id;
     static ID userRoleID = [SELECT ID FROM UserRole WHERE Name = 'Sales Specialist'][0].Id;
     static ID userRoleIDLead = [SELECT ID FROM UserRole WHERE Name = 'Sales Lead'][0].Id;
     static ID salesManager;// = [SELECT Id FROM User WHERE UserRole.Name = 'Sales Management'][0].Id;
     static User rep4;// = [SELECT ID, Name FROM User WHERE UserRole.Name = 'Sales Lead'][0];
     
     static
     {
        salesQARepRoleObj.Name = 'Sales Lead';
        insert salesQARepRoleObj;
        
        Set<String> repRoles = SalesQARepRoles__c.getAll().keySet();
        
        List<User> addUser = new List<User>();
        userTest = new User(FirstName='Testttt', LastName='SalesRep', UserName='arm54321@legalzoom.test', Email='test91@test.com', Alias='tester91',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='Arm54321@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest);       
        userTest2 = new User(FirstName='TestSalesRep', LastName='SalesRep2', UserName='arm54@legalzoom.test', Email='test911@test.com', Alias='tester1',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm54@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest2);
        userTest3 = new User(FirstName='TestSalesRep3', LastName='SalesRep3', UserName='arm13@legalzoom.test', Email='test913@test.com', Alias='tester13',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm13@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest3);
        userTest4 = new User(FirstName='TestSalesRep4', LastName='SalesRep4', UserName='arm12@legalzoom.test', Email='test91@test.com', Alias='tester12',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm12@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest4);
         
        userTest5 = new User(FirstName='TestSalesRep5', LastName='SalesRep5', UserName='arm1255@legalzoom.test', Email='test9155@test.com', Alias='tester12',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1255@legalzoom',
                ProfileId = AdminProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest5); 
         
        userTest6 = new User(FirstName='TestSalesRep6', LastName='SalesRep6', UserName='arm1266@legalzoom.test', Email='test9166@test.com', Alias='tester66',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1266@legalzoom',
                ProfileId = AdminProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest6); 
         
        userTest7 = new User(FirstName='TestSalesRep7', LastName='SalesRep7', UserName='arm1277@legalzoom.test', Email='test9177@test.com', Alias='tester77',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1277@legalzoom',
                ProfileId = AdminProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest7);  
        
        User salesMan= new User(FirstName='TestSalesMang', LastName='TestSalesMang', UserName='TestSalesMang@legalzoom.test', Email='TestSalesMang@test.com', Alias='sales77',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='TestSalesMang@legalzoom',
                ProfileId = managerProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true);
                
         
        rep4 = new User(FirstName='TestSalesRep8', LastName='SalesRep8', UserName='arm1233377@legalzoom.test', Email='test9177@test.com', Alias='tester78',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1288@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleIDLead, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        
        System.runAs(TestUtils.ADMIN_USER)
        {
            insert addUser;
            insert salesMan;
            salesManager = salesMan.Id;
        
        List<Team_Management__c> addSaleRep = new List<Team_Management__c>();
        teamManage1 = new Team_Management__c();
        teamManage1.User__c = userTest.Id;
        teamManage1.Approval_Manager__c = '005G0000001qcze';
        teamManage1.Manager__c = '005G0000001qcze';
        teamManage1.Compliance_Status__c = 'Live';
        teamManage1.Compliance_RR__c = true;
        teamManage1.Pulled__c = false;
        addSaleRep.add(teamManage1);
        
        teamManage2 = new Team_Management__c();
        teamManage2.User__c = userTest2.Id;
        teamManage2.Approval_Manager__c = '005G0000001qcze';
        teamManage2.Manager__c = '005G0000001qcze';
        teamManage2.Compliance_Status__c = 'Live';
        teamManage2.Compliance_RR__c = true;
        teamManage2.Pulled__c = false;
        addSaleRep.add(teamManage2);
        
        teamManage3 = new Team_Management__c();
        teamManage3.User__c = userTest3.Id;
        teamManage3.Approval_Manager__c = '005G0000001qcze';
        teamManage3.Manager__c = '005G0000001qcze';
        teamManage3.Compliance_Status__c = 'Training';
        teamManage3.Compliance_RR__c = true;
        teamManage3.Pulled__c = false;
        teamManage3.RecordTypeId = [SELECT Id FROM RecordType WHERE developername = 'Sales_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        
        addSaleRep.add(teamManage3);
        
       
        teamManage4 = new Team_Management__c();
        teamManage4.User__c = rep4.Id;
        teamManage4.Approval_Manager__c = '005G0000001qcze';
        teamManage4.Manager__c = '005G0000001qcze';
        teamManage4.Compliance_Status__c = 'Live';
        teamManage4.Compliance_Round_Robin__c = true; 
        teamManage4.Compliance_RR__c = true;
        teamManage4.Pulled__c = false;
        teamManage4.RecordTypeId =[SELECT Id FROM RecordType WHERE developername = 'Service_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
       
        addSaleRep.add(teamManage4);
        
        teamManage5 = new Team_Management__c();
        teamManage5.User__c = userTest4.Id;
        teamManage5.Approval_Manager__c = '005G0000001qcze';
        teamManage5.Manager__c = '005G0000001qcze';
        teamManage5.Compliance_Status__c = 'Training';
        teamManage5.Compliance_RR__c = true;
        teamManage5.Pulled__c = false;
        teamManage5.RecordTypeId  = [SELECT Id FROM RecordType WHERE developername = 'Service_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        addSaleRep.add(teamManage5);
         
        teamManage7 = new Team_Management__c();
        teamManage7.User__c = userTest5.Id;     
        teamManage7.Compliance_Status__c = 'Live';
        teamManage7.Monitored_Department__c = 'CCS';
        teamManage7.RecordTypeId  = [SELECT Id FROM RecordType WHERE developername = 'Compliance_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        addSaleRep.add(teamManage7); 
        
        teamManage8 = new Team_Management__c();
        teamManage8.User__c = userTest6.Id;     
        teamManage8.Compliance_Status__c = 'Training';
        teamManage8.Monitored_Department__c = 'CCS';
        teamManage8.RecordTypeId  = [SELECT Id FROM RecordType WHERE developername = 'Compliance_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        addSaleRep.add(teamManage8); 
        
        teamManage9 = new Team_Management__c();
        teamManage9.User__c = userTest7.Id;     
        teamManage9.Compliance_Status__c = 'Training';
        teamManage9.Monitored_Department__c = 'Sales';
        teamManage9.RecordTypeId  = [SELECT Id FROM RecordType WHERE developername = 'Compliance_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        addSaleRep.add(teamManage9); 
         
        
        insert addSaleRep;
        
        //Create Custom Setting Compilance Review Status
        compStatus.Name = 'Exclude Complete Status';
        compStatus.Compliance_Status__c = 'Accept Coaching Rejection, Compliant, Rep Coaching Completed, QA Mgr Disputed';
        insert compStatus;
        
        Compliance_Review_Day_Delay__c compDayDelay = new Compliance_Review_Day_Delay__c();
        compDayDelay.Name = '24Hours';
        compDayDelay.Hours_Delay__c = 24;
        
        insert compDayDelay;
        
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
        
        Compliance_Review_Limit_Chosen_Rep__c limitChosenRep = new Compliance_Review_Limit_Chosen_Rep__c();
        limitChosenRep.Name = 'Limit Chosen Rep';
        limitChosenRep.Limit_Chosen_Rep__c = 5;
        insert limitChosenRep;
        Compliance_Review_Limit_Chosen_Rep__c cclimitChosenRep = new Compliance_Review_Limit_Chosen_Rep__c();
        cclimitChosenRep.Name = 'CCS Limit Chosen Rep';
        cclimitChosenRep.Limit_Chosen_Rep__c = 4;
        insert cclimitChosenRep;
        
        //create Compliance
        complianceReview.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview.Representative__c = userTest.Id;
        complianceReview.Recorded_Call_ID__c = '211000';
        complianceReview.Status__c = 'Compliant';
        complianceReview.Length_of_Call__c = 2.30;
                
        complianceReview.RecordTypeId = NewComplianceReviewController.SKIP_RECORDTYPE;
        complianceReview.RecordTypeId = NewComplianceReviewController.TRAINING_RECORDTYPE;
        complianceReview.RecordTypeId = NewComplianceReviewController.CCS_TRAINING_RECORDTYPE;
         
         }
     }
 
    private static testMethod void testRandomRep_Limit_Chosen_Rep() 
     {
         Test.startTest();
     //   setup();
        complianceReview.Status__c = 'Rep Coaching Completed';
        complianceReview.Corrective_Plan_Start_Date__c = System.now();
        insert complianceReview;
        
        //2nd
        Compliance_Review__c complianceReview2 = new Compliance_Review__c();
        complianceReview2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview2.Representative__c = userTest.Id;
        complianceReview2.Recorded_Call_ID__c = '211001';
        complianceReview2.Corrective_Plan_Start_Date__c = System.now();
        complianceReview2.Status__c = 'Rep Coaching Completed';
        complianceReview2.Length_of_Call__c = 2.30;
        insert complianceReview2;
        
        //3rd
        Compliance_Review__c complianceReview3 = new Compliance_Review__c();
        complianceReview3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview3.Representative__c = userTest.Id;
        complianceReview3.Recorded_Call_ID__c = '211002';
        complianceReview3.Corrective_Plan_Start_Date__c = System.now();
        complianceReview3.Status__c = 'Rep Coaching Completed';
        complianceReview3.Length_of_Call__c = 2.30;
        insert complianceReview3;
        
        //4th
        Compliance_Review__c complianceReview4 = new Compliance_Review__c();
        complianceReview4.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview4.Representative__c = userTest.Id;
        complianceReview4.Recorded_Call_ID__c = '211003';
        complianceReview4.Corrective_Plan_Start_Date__c = System.now();
        complianceReview4.Status__c = 'Rep Coaching Completed';
        complianceReview4.Length_of_Call__c = 2.30;
        insert complianceReview4;
        
        //5th
        Compliance_Review__c complianceReview5 = new Compliance_Review__c();
        complianceReview5.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview5.Representative__c = userTest.Id;
        complianceReview5.Recorded_Call_ID__c = '211004';
        complianceReview5.Corrective_Plan_Start_Date__c = System.now();
        complianceReview5.Status__c = 'Rep Coaching Completed';
        complianceReview5.Length_of_Call__c = 2.30;
        insert complianceReview5;
        
        //6th
        Compliance_Review__c complianceReview6 = new Compliance_Review__c();
        complianceReview6.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview6.Representative__c = userTest.Id;
        complianceReview6.Recorded_Call_ID__c = '211005';
        complianceReview6.Corrective_Plan_Start_Date__c = System.now();
        complianceReview6.Status__c = 'Rep Coaching Completed';
        complianceReview6.Length_of_Call__c = 2.30;
        insert complianceReview6;
        
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
        controller.chooseRandomRep();
        TEst.stopTest();
     }
     
    private static testMethod void testSkipNextRep() 
     {
        //setup();
        Test.startTest();
        insert complianceReview;
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
        //User rep5 = [SELECT ID, Name FROM User WHERE Name = 'Jenny Boyd'][0];
        controller.chosenRep = userTest;
        controller.repName = rep4.Name;
        controller.recordedCallId = '0007';
        controller.skipAndNext();
        Test.stopTest();
     }
     
    private static testMethod void testSkipNextRep_Negative() 
     {
        
        Test.startTest();
        insert complianceReview;
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
        Team_Management__c teamManage6 = new Team_Management__c();
        teamManage6.User__c = rep4.Id;
        teamManage6.Compliance_Round_Robin__c = false;
        teamManage6.Pulled__c = false;
        insert teamManage6;
        controller.repName = rep4.Name;
        controller.skipAndNext();
        TEst.stopTest();
     }
  
    private static testMethod void testDuplicateCallID()
     {
        //setup();
        Test.startTest();
        complianceReview.Status__c = 'Draft';
        insert complianceReview;
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
       
        controller.chosenRep = userTest;
        controller.repName = userTest.Name;
        controller.recordedCallId = '211000';
        controller.newReview();
         TEst.stopTest();
     }  
     
     
    private static testMethod void testNewComplianceReview()
     {
    
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
        Test.startTest();
            controller.chosenRep = userTest4;
            controller.repName = userTest4.Name;
            controller.repID = userTest4.Id;
            controller.recordedCallId = '211006';
            controller.newReview();
        Test.stopTest();
        
     }
    
    
    private static testMethod void testCCSScoredBased() 
     {
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
        Test.startTest();
            controller.chosenRep = rep4;
            controller.repName = rep4.Name;
            controller.repID = rep4.Id;
            controller.recordedCallId = '211006';
            controller.newReview();
        Test.stopTest();
         
     }
    
    private static testMethod void testSaleLiveRandomRep() 
     {
       
        Test.startTest();
       
        PageReference pageRef = Page.NewComplianceReview;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
        
        NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
        controller.chooseRandomRep();   
        controller.newReview();
        Test.stopTest();
     }
    
    private static testMethod void testCCSLiveRandomRep() 
     {
       
        Test.startTest();
        System.runAs(userTest5)
        {
            PageReference pageRef = Page.NewComplianceReview;
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
            
            NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
            controller.chooseRandomRep();   
           // controller.newReview();
        }     
        Test.stopTest();
     }
    
    private static testMethod void testCCSTrainingRandomRep() 
     {
       
        Test.startTest();
        System.runAs(userTest6)
        {
            PageReference pageRef = Page.NewComplianceReview;
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
            
            NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
            controller.chooseRandomRep();   
          //  controller.newReview();
        }     
        Test.stopTest();
     }
    
    private static testMethod void testSalesTrainingRandomRep() 
     {
       
        Test.startTest();
        System.runAs(userTest7)
        {
            PageReference pageRef = Page.NewComplianceReview;
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController stdLead = new ApexPages.StandardController(complianceReview);
            
            NewComplianceReviewController controller = new NewComplianceReviewController(stdLead);
            controller.chooseRandomRep();   
          //  controller.newReview();
        }     
        Test.stopTest();
     }
}