@isTest
private class ComplianceReviewChangeCallIDTest 
{
    public static Compliance_Review__c complianceReview;
    public static SalesQA__c salesQAObj1;
    public static SalesQARepRoles__c salesQARepRoleObj = new SalesQARepRoles__c();
    public static User userTest;
    
    static void setup()
    {
        salesQARepRoleObj.Name = 'Sales Lead';
        insert salesQARepRoleObj;
        
        Set<String> repRoles = SalesQARepRoles__c.getAll().keySet();
        ID userRoleID = [SELECT ID FROM UserRole WHERE Name = 'Sales Specialist'][0].Id;
        ID salesManager = [SELECT Id FROM User WHERE UserRole.Name = 'Sales Management'][0].Id;

        userTest = new User(FirstName='Testttt', LastName='SalesRep', UserName='test54321@test.test', Email='test91@test.com', Alias='tester91',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test91',
                ProfileId = TestUtils.salesAgentProfileId, UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        
        System.runAs(TestUtils.ADMIN_USER)
        {
            insert userTest;
        }
        
        salesQAObj1 = new SalesQA__c();
        salesQAObj1.SetupOwnerId = userTest.Id;
        salesQAObj1.ExcludeFromCycle__c = false;
        salesQAObj1.Pulled__c = false;
        insert salesQAObj1;
        
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
        
        //create Compliance
        complianceReview = new Compliance_Review__c();
        complianceReview.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        complianceReview.Representative__c = userTest.Id;
        complianceReview.Recorded_Call_ID__c = 'qwer1';
        complianceReview.Status__c = 'Draft';
        complianceReview.Length_of_Call__c = 2.30;
                
        insert complianceReview;
    }   
    
    static testMethod void complianceChangeCallIDTest_Positive() 
    {
        setup();
     
        PageReference pageRef = Page.ComplianceReviewChangeCallID;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('ComplianceID', complianceReview.Id);
        ComplianceReviewChangeCallIDController controller = new ComplianceReviewChangeCallIDController();
        controller.recordCallId = 'qwer2';
        controller.save();
    }
    
    static testMethod void complianceChangeCallIDTest_Duplicated_Negative() 
    {
        setup();
     
        PageReference pageRef = Page.ComplianceReviewChangeCallID;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('ComplianceID', complianceReview.Id);
        ComplianceReviewChangeCallIDController controller = new ComplianceReviewChangeCallIDController();
        controller.recordCallId = 'qwer1';
        controller.save();
    }
    
    static testMethod void complianceChangeCallIDTest_NoCallID_Negative() 
    {
        setup();
     
        PageReference pageRef = Page.ComplianceReviewChangeCallID;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('ComplianceID', complianceReview.Id);
        ComplianceReviewChangeCallIDController controller = new ComplianceReviewChangeCallIDController();
        controller.save();
    }
}