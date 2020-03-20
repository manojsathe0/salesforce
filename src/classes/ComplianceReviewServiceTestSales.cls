@isTest
public class ComplianceReviewServiceTestSales
{
  public static User salesRepUser1;
  static User salesRepUser2;
  static Set<String> STATUS_EXCLUDE_VIOLATION_LIST = new Set<String>{'Draft','Compliant','QA Mgr Disputed','Rep Coaching Completed','Skipped'};
  
  public static void setupData()
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
  }
  
    public static testmethod void testSalesRepManager()
    {
      setupData();
        // Create Compliance Reviews
        Compliance_Review__c cr1 = new Compliance_Review__c();
        cr1.Representative__c = salesRepUser1.Id;
        Compliance_Review__c cr2 = new Compliance_Review__c();
        cr2.Representative__c = salesRepUser2.Id;
        
        Test.startTest();
        
        insert new Compliance_Review__c[]{cr1, cr2};
    }
    
    public static testmethod void testInitialDisclaimer()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A3__c = 'No (1st Contact)';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_Outbound_Disclaimer__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].Corrective_Plan_Outbound_Disclaimer__c , '1st Written');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A3__c = 'No (1st Contact)';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Outbound_Disclaimer__c, Corrective_Plan_Outbound_Disclaimer__c From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_Outbound_Disclaimer__c , '1st Written');  

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
        cr2.status__c = 'Rep Coaching Completed';
        

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          update cr2;
          insert cr3;
          Test.stopTest();

        List<Compliance_Review__c> insertedComReview3 = [Select Id , LCP_Outbound_Disclaimer__c, Corrective_Plan_Outbound_Disclaimer__c From Compliance_Review__c Where Id =: cr3.Id];
        System.assertEquals('2nd Written' , insertedComReview3[0].LCP_Outbound_Disclaimer__c , '2nd Written'); 
    }

    public static testmethod void testInitialDisclaimer_Under6Month()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A3__c = 'No (1st Contact)';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_Outbound_Disclaimer__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].Corrective_Plan_Outbound_Disclaimer__c , '1st Written');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A3__c = 'No (1st Contact)';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Outbound_Disclaimer__c, Corrective_Plan_Outbound_Disclaimer__c From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_Outbound_Disclaimer__c , '1st Written');  
      }

    public static testmethod void test2ndDisclaimer()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A3__c = 'No (2nd Contact)';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-2);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Cp_2nd_Contact_Disclaimer__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Cp_2nd_Contact_Disclaimer__c , 'Coaching');
        system.debug(cr1);
        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A3__c = 'No (2nd Contact)';
        insert cr2;
        system.debug(cr2);
        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_2nd_Contact_Disclaime__c , Cp_2nd_Contact_Disclaimer__c From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_2nd_Contact_Disclaime__c , 'Coaching');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-2);
        cr2.status__c = 'Rep Coaching Completed';
        

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          update cr2;
          insert cr3;
          Test.stopTest();

        List<Compliance_Review__c> insertedComReview3 = [Select Id , LCP_2nd_Contact_Disclaime__c , Cp_2nd_Contact_Disclaimer__c From Compliance_Review__c Where Id =: cr3.Id];
        System.assertEquals('Verbal' , insertedComReview3[0].LCP_2nd_Contact_Disclaime__c , 'Verbal');
      }

    public static testmethod void test2ndDisclaimer_Under6Month()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A3__c = 'No (2nd Contact)';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Cp_2nd_Contact_Disclaimer__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Cp_2nd_Contact_Disclaimer__c , 'Coaching');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A3__c = 'No (2nd Contact)';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_2nd_Contact_Disclaime__c , Cp_2nd_Contact_Disclaimer__c From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_2nd_Contact_Disclaime__c , 'Coaching');
      }

    public static testmethod void testUPL()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A1__c = 'Disqualified';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_UPL__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].Corrective_Plan_UPL__c , '1st Written');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A1__c = 'Disqualified';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_UPL__c  From Compliance_Review__c Where Id =: cr2.Id]; 
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_UPL__c , '1st Written');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
        cr2.status__c = 'Rep Coaching Completed';

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          update cr2;
          insert cr3;
          Test.stopTest();

        List<Compliance_Review__c> insertedComReview3 = [Select Id , LCP_UPL__c  From Compliance_Review__c Where Id =: cr3.Id]; 
        System.assertEquals('2nd Written' , insertedComReview3[0].LCP_UPL__c , '2nd Written');
      }

      public static testmethod void testUPL_under6month()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A1__c = 'Disqualified';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_UPL__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].Corrective_Plan_UPL__c , '1st Written');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A1__c = 'Disqualified';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_UPL__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_UPL__c , '1st Written');
      }

    public static testmethod void testUPL_No2ndViolation()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A1__c = 'Disqualified';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_UPL__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].Corrective_Plan_UPL__c , '1st Written');

        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_UPL__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_UPL__c , '1st Written');

        Compliance_Review__c cr3 = new Compliance_Review__c();
                  cr3.Representative__c = salesRepUser1.Id;
                  cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr3.Recorded_Call_ID__c = '30003';
                  cr3.Violation_A1__c = 'Disqualified';
        insert cr3;

        List<Compliance_Review__c> insertedComReview3 = [Select Id ,Corrective_Plan_UPL__c, LCP_UPL__c  From Compliance_Review__c Where Id =: cr3.Id];
        System.assertEquals('2nd Written' , insertedComReview3[0].Corrective_Plan_UPL__c , '2nd Written');

      }

    public static testmethod void testUPLCoaching()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.UPL_Coaching__c = True;
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_UPL_Coaching__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Corrective_Plan_UPL_Coaching__c , 'Coaching');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.UPL_Coaching__c = True;
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_UPL_Coaching__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_UPL_Coaching__c , 'Coaching');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
        cr2.status__c = 'Rep Coaching Completed';
        update cr2;

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          insert cr3;
          Test.stopTest();

        List<Compliance_Review__c> insertedComReview3 = [Select Id , LCP_UPL_Coaching__c  From Compliance_Review__c Where Id =: cr3.Id];
        System.assertEquals('Verbal' , insertedComReview3[0].LCP_UPL_Coaching__c , 'Verbal');
      }

    public static testmethod void testUPLCoaching_under6month()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.UPL_Coaching__c = True;
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_UPL_Coaching__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Corrective_Plan_UPL_Coaching__c , 'Coaching');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.UPL_Coaching__c = True;
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_UPL_Coaching__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_UPL_Coaching__c , 'Coaching');
      }

    public static testmethod void testTaxViolation_90Day()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A7__c = 'Yes';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_Taxation__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Corrective_Plan_Taxation__c , 'Coaching');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A7__c = 'Yes';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Taxation__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_Taxation__c , 'Coaching');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
        cr2.status__c = 'Rep Coaching Completed';
        update cr2;

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          insert cr3;
          Test.stopTest();
      }
     
    public static testmethod void testImproperSales()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A2__c = 'Disqualified';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , CP_Unethical_Business_Practice__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].CP_Unethical_Business_Practice__c , '1st Written');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A2__c = 'Disqualified';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Unethical_Business_Practice__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_Unethical_Business_Practice__c , '1st Written');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-5);
        cr2.status__c = 'Rep Coaching Completed';

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          update cr2;
          insert cr3;
          Test.stopTest();
      }  

      public static testmethod void testImproperSales_under6month()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A2__c = 'Disqualified';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , CP_Unethical_Business_Practice__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('1st Written' , insertedComReview[0].CP_Unethical_Business_Practice__c , '1st Written');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A2__c = 'Disqualified';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Unethical_Business_Practice__c  From Compliance_Review__c Where Id =: cr2.Id]; 
        System.assertEquals('1st Written' , insertedComReview2[0].LCP_Unethical_Business_Practice__c , '1st Written');
      }

      public static testmethod void testSecurity()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A5__c = 'No';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_Security__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Corrective_Plan_Security__c , 'Coaching');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A5__c = 'No';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Security__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_Security__c , 'Coaching');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
        cr2.status__c = 'Rep Coaching Completed';

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          update cr2;
          insert cr3;
          Test.stopTest();
      }  

      public static testmethod void testFeeViolation()
    {
       setupData();
       Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser1.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '30001';
          cr1.Violation_A8__c = 'No';
          cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-2);
          insert cr1;
          
          cr1.status__c = 'Rep Coaching Completed';
          update cr1;

        List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_Fee__c From Compliance_Review__c Where Id =: cr1.Id];
        System.assertEquals('Coaching' , insertedComReview[0].Corrective_Plan_Fee__c , 'Coaching');

        //LCP 1st Written
        Compliance_Review__c cr2 = new Compliance_Review__c();
                  cr2.Representative__c = salesRepUser1.Id;
                  cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                  cr2.Recorded_Call_ID__c = '30002';
                  cr2.Violation_A8__c = 'No';
        insert cr2;

        List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Fee__c  From Compliance_Review__c Where Id =: cr2.Id];
        System.assertEquals('Coaching' , insertedComReview2[0].LCP_Fee__c , 'Coaching');

        cr2.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-2);
        cr2.status__c = 'Rep Coaching Completed';
        update cr2;

        Compliance_Review__c cr3 = new Compliance_Review__c();
          cr3.Representative__c = salesRepUser1.Id;
          cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr3.Recorded_Call_ID__c = '30003';
          Test.startTest();
          insert cr3;
          Test.stopTest();

        List<Compliance_Review__c> insertedComReview3 = [Select Id , LCP_Fee__c  From Compliance_Review__c Where Id =: cr3.Id]; 
        System.assertEquals('Verbal' ,insertedComReview3[0].LCP_Fee__c , 'Verbal');
      } 

       public static testmethod void testFeeViolation_under6Month()
      {
         setupData();
         Compliance_Review__c cr1 = new Compliance_Review__c();
            cr1.Representative__c = salesRepUser1.Id;
            cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
            cr1.Recorded_Call_ID__c = '30001';
            cr1.Violation_A8__c = 'No';
            cr1.Corrective_Plan_Start_Date__c = DateTime.now().addMonths(-1);
            insert cr1;
            
            cr1.status__c = 'Rep Coaching Completed';
            update cr1;

          List<Compliance_Review__c> insertedComReview = [Select Id , Corrective_Plan_Fee__c From Compliance_Review__c Where Id =: cr1.Id];
          System.assertEquals('Coaching' , insertedComReview[0].Corrective_Plan_Fee__c , 'Coaching');

          //LCP 1st Written
          Compliance_Review__c cr2 = new Compliance_Review__c();
                    cr2.Representative__c = salesRepUser1.Id;
                    cr2.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
                    cr2.Recorded_Call_ID__c = '30002';
                    cr2.Violation_A8__c = 'No';
          insert cr2;

          List<Compliance_Review__c> insertedComReview2 = [Select Id , LCP_Fee__c  From Compliance_Review__c Where Id =: cr2.Id];
          System.assertEquals('Coaching' , insertedComReview2[0].LCP_Fee__c );
        }
}