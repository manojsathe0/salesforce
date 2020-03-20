@isTest
public class ComplianceReviewServiceTest
{

  static User salesRepUser1;
  static User salesRepUser2;
  static Set<String> STATUS_EXCLUDE_VIOLATION_LIST = new Set<String>{'Draft','Compliant','QA Mgr Disputed','Rep Coaching Completed','Skipped'};
  
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
    /*
    public static testmethod void testLastCorrectivePlan_WrittenWarning_Bulk()
    {
      setupData();
      List<Compliance_Review__c> compList1 = new List<Compliance_Review__c>();
      List<Compliance_Review__c> compList2 = new List<Compliance_Review__c>();
      Map<Id, Compliance_Review__c> comp1Map = new Map<Id, Compliance_Review__c>();
      Set<Id> compIDSet = new Set<Id>();
      DateTime mockUpDateTime = DateTime.now().addMonths(-6);
       // Create Compliance Reviews
      for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3002'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
      cr1.UPL_Coaching__c = true;
            
            cr1.CCS_UPL_Violation__c = 'Disqualified'; 
            cr1.CCS_Disclaimer_Violation__c = 'No';
            cr1.CCS_Security_Violation__c = 'No';
            cr1.CCS_Tax_Violation__c = 'Yes';
            cr1.UPL_Coaching__c = True;  
            
          cr1.CreatedDate = mockUpDateTime;
          cr1.LastModifiedDate = mockUpDateTime;
          compList1.add(cr1);
      }
        insert compList1;
        
        for(Compliance_Review__c com:compList1)
        {
          compIDSet.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: compIDSet
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList = new List<Compliance_Review__c>();                                    
         
         for(Compliance_Review__c comListUpdate : comList)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '1st Written';
           comListUpdate.Corrective_Plan_UPL_Coaching__c = 'Coaching';
            comListUpdate.CP_Unethical_Business_Practice__c = '1st Written';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = '1st Written';
            comListUpdate.Corrective_Plan_Discounts__c = 'Coaching';
            comListUpdate.Corrective_Plan_Security__c = 'Coaching';
            comListUpdate.Corrective_Plan_Taxation__c = 'Coaching';
            comListUpdate.Corrective_Plan_Service__c = 'Coaching';
            
            comListUpdate.CCS_Corrective_Plan_UPL__c = '1st Written'; 
            comListUpdate.CCS_Corrective_Plan_Disclaimer__c = '1st Written';
            comListUpdate.CCS_Corrective_Plan_Security__c = 'Coaching';
            comListUpdate.CCS_Corrective_Plan_Taxation__c = 'Coaching';
            comListUpdate.CCS_Corrective_Plan_UPL_Coaching__c = 'Coaching'; 
             
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime;
           updateCompReviewList.add(comListUpdate);
         }
         update updateCompReviewList;
         
         for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3003'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
      cr1.UPL_Coaching__c = true;
            
            cr1.CCS_UPL_Violation__c = 'Disqualified'; 
            cr1.CCS_Disclaimer_Violation__c = 'No';
            cr1.CCS_Security_Violation__c = 'No';
            cr1.CCS_Tax_Violation__c = 'Yes';
            cr1.UPL_Coaching__c = True;
            
          cr1.CreatedDate = mockUpDateTime.addDays(1);
          cr1.LastModifiedDate = mockUpDateTime.addDays(1);
          compList2.add(cr1);
      }
        insert compList2;
        
        Set<ID> repID2 = new Set<ID>();
        for(Compliance_Review__c com:compList2)
        {
          repID2.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: repID2
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList2 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList2)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '2nd Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '2nd Written';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = '2nd Written';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c= '2nd Written';
            comListUpdate.Corrective_Plan_Service__c= '2nd Written';
            comListUpdate.Corrective_Plan_UPL_Coaching__c = '2nd Written';
            
            comListUpdate.CCS_Corrective_Plan_UPL__c = '2nd Written'; 
            comListUpdate.CCS_Corrective_Plan_Disclaimer__c = '2nd Written';
            comListUpdate.CCS_Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.CCS_Corrective_Plan_Taxation__c = '2nd Written';
            comListUpdate.CCS_Corrective_Plan_UPL_Coaching__c = '2nd Written';
             
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(2);
           updateCompReviewList2.add(comListUpdate);
         }
         update updateCompReviewList2;
        
        Compliance_Review__c cr3 = new Compliance_Review__c();
        cr3.Representative__c = salesRepUser2.Id;
        cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr3.Recorded_Call_ID__c = '300401';
        cr3.Length_of_Call__c = 4.50;
        cr3.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
    cr3.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
    cr3.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
    cr3.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
    cr3.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
    cr3.Violation_A6__c = 'Yes'; //Service_Violation__c
    cr3.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
    cr3.UPL_Coaching__c = true;
        
        cr3.CCS_UPL_Violation__c = 'Disqualified'; 
        cr3.CCS_Disclaimer_Violation__c = 'No';
        cr3.CCS_Security_Violation__c = 'No';
        cr3.CCS_Tax_Violation__c = 'Yes';
        cr3.UPL_Coaching__c = True;
        
        cr3.CreatedDate = mockUpDateTime.addDays(2);
        cr3.LastModifiedDate = mockUpDateTime.addDays(2);
        insert cr3;
        
        List<Compliance_Review__c> comList3 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList3 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList3)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = 'Termination';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = 'Termination';
            comListUpdate.Corrective_Plan_Discounts__c = 'Termination';
            comListUpdate.Corrective_Plan_Security__c = 'Termination';
            comListUpdate.Corrective_Plan_Taxation__c = 'Termination';
            comListUpdate.Corrective_Plan_Service__c = 'Termination';
            comListUpdate.Corrective_Plan_UPL_Coaching__c = 'Termination';
             
            comListUpdate.CCS_Corrective_Plan_UPL__c = 'Termination'; 
            comListUpdate.CCS_Corrective_Plan_Disclaimer__c = 'Termination';
            comListUpdate.CCS_Corrective_Plan_Security__c = 'Termination';
            comListUpdate.CCS_Corrective_Plan_Taxation__c = 'Termination';
            comListUpdate.CCS_Corrective_Plan_UPL_Coaching__c = 'Termination'; 
             
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(2);
           updateCompReviewList3.add(comListUpdate);
         }
         update updateCompReviewList3;
         
        Compliance_Review__c cr4 = new Compliance_Review__c();
        cr4.Representative__c = salesRepUser2.Id;
        cr4.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr4.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr4.Recorded_Call_ID__c = '300402';
        cr4.Length_of_Call__c = 15.50;
        cr4.CreatedDate = mockUpDateTime.addDays(2);
        cr4.LastModifiedDate = mockUpDateTime.addDays(2);
        insert cr4;
        
        List<Compliance_Review__c> comList4 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList4 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList4)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
            comListUpdate.CP_Unethical_Business_Practice__c = 'Termination';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(2);
           updateCompReviewList4.add(comListUpdate);
         }
         update updateCompReviewList4;
        
         Compliance_Review__c cr5 = new Compliance_Review__c();
        cr5.Representative__c = salesRepUser2.Id;
        cr5.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr5.Recorded_Call_ID__c = '300403';
        cr5.Length_of_Call__c = 15.50;
        cr5.CreatedDate = mockUpDateTime.addDays(2);
        cr5.LastModifiedDate = mockUpDateTime.addDays(2);
        insert cr5;
    }
    
    public static testmethod void testLastCorrectivePlan_Bulk()
    {
      setupData();
      List<Compliance_Review__c> compList1 = new List<Compliance_Review__c>();
      List<Compliance_Review__c> compList2 = new List<Compliance_Review__c>();
      Map<Id, Compliance_Review__c> comp1Map = new Map<Id, Compliance_Review__c>();
      Set<Id> compIDSet = new Set<Id>();
      DateTime mockUpDateTime = DateTime.now().addMonths(-2);
       // Create Compliance Reviews
      for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3002'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
          cr1.CreatedDate = mockUpDateTime;
          cr1.LastModifiedDate = mockUpDateTime;
          compList1.add(cr1);
      }
        insert compList1;
        
        for(Compliance_Review__c com:compList1)
        {
          compIDSet.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: compIDSet
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '1st Written';
           comListUpdate.Corrective_Plan_UPL_Coaching__c = 'Coaching';
            comListUpdate.CP_Unethical_Business_Practice__c = '1st Written';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = '1st Written';
            comListUpdate.Corrective_Plan_Discounts__c = 'Coaching';
            comListUpdate.Corrective_Plan_Security__c = 'Coaching';
            comListUpdate.Corrective_Plan_Taxation__c = 'Coaching';
            comListUpdate.Corrective_Plan_Service__c = 'Coaching';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime;
           updateCompReviewList.add(comListUpdate);
         }
         update updateCompReviewList;
         
         for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3003'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
          cr1.CreatedDate = mockUpDateTime.addDays(1);
          cr1.LastModifiedDate = mockUpDateTime.addDays(1);
          compList2.add(cr1);
      }
        insert compList2;
        
        Set<ID> repID2 = new Set<ID>();
        for(Compliance_Review__c com:compList2)
        {
          repID2.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: repID2
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList2 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList2)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '2nd Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '2nd Written';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c= '2nd Written';
            comListUpdate.Corrective_Plan_Service__c= '2nd Written';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList2.add(comListUpdate);
         }
         update updateCompReviewList2;
        
        Compliance_Review__c cr3 = new Compliance_Review__c();
        cr3.Representative__c = salesRepUser2.Id;
        cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr3.Recorded_Call_ID__c = '300401';
        cr3.Length_of_Call__c = 4.50;
        cr3.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
    cr3.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
    cr3.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
    cr3.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
    cr3.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
    cr3.Violation_A6__c = 'Yes'; //Service_Violation__c
    cr3.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
        cr3.CreatedDate = mockUpDateTime.addDays(1);
        cr3.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr3;
        
        List<Compliance_Review__c> comList3 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList3 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList3)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = 'Termination';
            comListUpdate.Corrective_Plan_Discounts__c = 'Termination';
            comListUpdate.Corrective_Plan_Security__c = 'Termination';
            comListUpdate.Corrective_Plan_Taxation__c = 'Termination';
            comListUpdate.Corrective_Plan_Service__c = 'Termination';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList3.add(comListUpdate);
         }
         update updateCompReviewList3;
         
        Compliance_Review__c cr4 = new Compliance_Review__c();
        cr4.Representative__c = salesRepUser2.Id;
        cr4.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr4.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr4.Recorded_Call_ID__c = '300402';
        cr4.Length_of_Call__c = 15.50;
        cr4.CreatedDate = mockUpDateTime.addDays(1);
        cr4.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr4;
        
        List<Compliance_Review__c> comList4 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList4 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList4)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
            comListUpdate.CP_Unethical_Business_Practice__c = 'Termination';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList4.add(comListUpdate);
         }
         update updateCompReviewList4;
        
         Compliance_Review__c cr5 = new Compliance_Review__c();
        cr5.Representative__c = salesRepUser2.Id;
        cr5.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr5.Recorded_Call_ID__c = '300403';
        cr5.Length_of_Call__c = 15.50;
        cr5.CreatedDate = mockUpDateTime.addDays(1);
        cr5.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr5;
    }
    
    public static testmethod void testLastCorrectivePlan_Bulk_Negative_DaysViolation()
    {
      setupData();
      List<Compliance_Review__c> compList1 = new List<Compliance_Review__c>();
      List<Compliance_Review__c> compList2 = new List<Compliance_Review__c>();
      Map<Id, Compliance_Review__c> comp1Map = new Map<Id, Compliance_Review__c>();
      Set<Id> compIDSet = new Set<Id>();
      DateTime mockUpDateTime = DateTime.now().addMonths(-2);
       // Create Compliance Reviews
      for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3002'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
          cr1.CreatedDate = mockUpDateTime;
          cr1.LastModifiedDate = mockUpDateTime;
          compList1.add(cr1);
      }
        insert compList1;
        
        for(Compliance_Review__c com:compList1)
        {
          compIDSet.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: compIDSet
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '1st Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '1st Written';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = '1st Written';
            comListUpdate.Corrective_Plan_Discounts__c = 'Coaching';
            comListUpdate.Corrective_Plan_Security__c = 'Coaching';
            comListUpdate.Corrective_Plan_Taxation__c = 'Coaching';
            comListUpdate.Corrective_Plan_Service__c = 'Coaching';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime;
           updateCompReviewList.add(comListUpdate);
         }
         update updateCompReviewList;
         
         for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3003'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
          cr1.CreatedDate = mockUpDateTime.addDays(1);
          cr1.LastModifiedDate = mockUpDateTime.addDays(1);
          compList2.add(cr1);
      }
        insert compList2;
        
        Set<ID> repID2 = new Set<ID>();
        for(Compliance_Review__c com:compList2)
        {
          repID2.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: repID2
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList2 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList2)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '2nd Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '2nd Written';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c= '2nd Written';
            comListUpdate.Corrective_Plan_Service__c= '2nd Written';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList2.add(comListUpdate);
         }
         update updateCompReviewList2;
        
        Compliance_Review__c cr3 = new Compliance_Review__c();
        cr3.Representative__c = salesRepUser2.Id;
        cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr3.Recorded_Call_ID__c = '300401';
        cr3.Length_of_Call__c = 4.50;
        cr3.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
    cr3.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
    cr3.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
    cr3.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
    cr3.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
    cr3.Violation_A6__c = 'Yes'; //Service_Violation__c
    cr3.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
        cr3.CreatedDate = mockUpDateTime.addDays(1);
        cr3.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr3;
        
        List<Compliance_Review__c> comList3 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList3 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList3)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = 'Termination';
            comListUpdate.Corrective_Plan_Discounts__c = 'Training';
            comListUpdate.Corrective_Plan_Security__c = 'Training';
            comListUpdate.Corrective_Plan_Taxation__c = 'Training';
            comListUpdate.Corrective_Plan_Service__c = 'Training';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList3.add(comListUpdate);
         }
         update updateCompReviewList3;
         
        Compliance_Review__c cr4 = new Compliance_Review__c();
        cr4.Representative__c = salesRepUser2.Id;
        cr4.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr4.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr4.Recorded_Call_ID__c = '300402';
        cr4.Length_of_Call__c = 15.50;
        cr4.CreatedDate = mockUpDateTime.addDays(1);
        cr4.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr4;
        
        List<Compliance_Review__c> comList4 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList4 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList4)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
            comListUpdate.CP_Unethical_Business_Practice__c = 'Termination';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList4.add(comListUpdate);
         }
         update updateCompReviewList4;
        
         Compliance_Review__c cr5 = new Compliance_Review__c();
        cr5.Representative__c = salesRepUser2.Id;
        cr5.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr5.Recorded_Call_ID__c = '300403';
        cr5.Length_of_Call__c = 15.50;
        cr5.CreatedDate = mockUpDateTime.addDays(1);
        cr5.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr5;
    }
    
    public static testmethod void testLastCorrectivePlan_Bulk_Negative_SixMonthsViolation()
    {
      setupData();
      List<Compliance_Review__c> compList1 = new List<Compliance_Review__c>();
      List<Compliance_Review__c> compList2 = new List<Compliance_Review__c>();
      Map<Id, Compliance_Review__c> comp1Map = new Map<Id, Compliance_Review__c>();
      Set<Id> compIDSet = new Set<Id>();
      DateTime mockUpDateTime = DateTime.now().addMonths(-2);
       // Create Compliance Reviews
      for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3002'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
            
            cr1.CCS_UPL_Violation__c = 'Disqualified'; 
      cr1.CCS_Disclaimer_Violation__c = 'No';
      cr1.CCS_Security_Violation__c = 'No';
      cr1.CCS_Tax_Violation__c = 'Yes';
      cr1.UPL_Coaching__c = True; 
            
          cr1.CreatedDate = mockUpDateTime;
          cr1.LastModifiedDate = mockUpDateTime;
          compList1.add(cr1);
      }
        insert compList1;
        
        for(Compliance_Review__c com:compList1)
        {
          compIDSet.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: compIDSet
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '1st Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '1st Written';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = '1st Written';
            comListUpdate.Corrective_Plan_Discounts__c = '1st Written';
            comListUpdate.Corrective_Plan_Security__c = '1st Written';
            comListUpdate.Corrective_Plan_Taxation__c = '1st Written';
            comListUpdate.Corrective_Plan_Service__c = '1st Written';
            
            comListUpdate.CCS_Corrective_Plan_UPL__c = '1st Written'; 
            comListUpdate.CCS_Corrective_Plan_Disclaimer__c = '1st Written';
            comListUpdate.CCS_Corrective_Plan_Security__c = 'Coaching';
            comListUpdate.CCS_Corrective_Plan_Taxation__c = 'Coaching';
            comListUpdate.CCS_Corrective_Plan_UPL_Coaching__c = 'Coaching';  
             
             
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime;
           updateCompReviewList.add(comListUpdate);
         }
         update updateCompReviewList;
         
         for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3003'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
            
            cr1.CCS_UPL_Violation__c = 'Disqualified'; 
      cr1.CCS_Disclaimer_Violation__c = 'No';
      cr1.CCS_Security_Violation__c = 'No';
      cr1.CCS_Tax_Violation__c = 'Yes';
      cr1.UPL_Coaching__c = True;
            
            
          cr1.CreatedDate = mockUpDateTime.addDays(1);
          cr1.LastModifiedDate = mockUpDateTime.addDays(1);
          compList2.add(cr1);
      }
        insert compList2;
        
        Set<ID> repID2 = new Set<ID>();
        for(Compliance_Review__c com:compList2)
        {
          repID2.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: repID2
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList2 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList2)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '2nd Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '2nd Written';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c= '2nd Written';
            comListUpdate.Corrective_Plan_Service__c= '2nd Written';
            
            comListUpdate.CCS_Corrective_Plan_UPL__c = '2nd Written'; 
            comListUpdate.CCS_Corrective_Plan_Disclaimer__c = '2nd Written';
            comListUpdate.CCS_Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.CCS_Corrective_Plan_Taxation__c = '2nd Written';
            comListUpdate.CCS_Corrective_Plan_UPL_Coaching__c = '2nd Written'; 
             
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList2.add(comListUpdate);
         }
         update updateCompReviewList2;
        
        Compliance_Review__c cr3 = new Compliance_Review__c();
        cr3.Representative__c = salesRepUser2.Id;
        cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr3.Recorded_Call_ID__c = '300401';
        cr3.Length_of_Call__c = 4.50;
        cr3.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
    cr3.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
    cr3.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
    cr3.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
    cr3.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
    cr3.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
        
        cr3.CCS_UPL_Violation__c = 'Disqualified'; 
    cr3.CCS_Disclaimer_Violation__c = 'No';
    cr3.CCS_Security_Violation__c = 'No';
    cr3.CCS_Tax_Violation__c = 'Yes';
    cr3.UPL_Coaching__c = True;
        
        cr3.CreatedDate = mockUpDateTime.addDays(1);
        cr3.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr3;
        
        List<Compliance_Review__c> comList3 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList3 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList3)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = 'Termination';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c = '2nd Written';
            comListUpdate.Corrective_Plan_Service__c = '2nd Written';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList3.add(comListUpdate);
         }
         update updateCompReviewList3;
         
        Compliance_Review__c cr4 = new Compliance_Review__c();
        cr4.Representative__c = salesRepUser2.Id;
        cr4.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr4.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr4.Recorded_Call_ID__c = '300402';
        cr4.Length_of_Call__c = 15.50;
        cr4.CreatedDate = mockUpDateTime.addDays(1);
        cr4.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr4;
        
        List<Compliance_Review__c> comList4 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList4 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList4)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
            comListUpdate.CP_Unethical_Business_Practice__c = 'Termination';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList4.add(comListUpdate);
         }
         update updateCompReviewList4;
        
        Compliance_Review__c cr5 = new Compliance_Review__c();
        cr5.Representative__c = salesRepUser2.Id;
        cr5.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr5.Recorded_Call_ID__c = '300403';
        cr5.Length_of_Call__c = 15.50;
        cr5.CreatedDate = mockUpDateTime.addDays(1);
        cr5.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr5;
    }
    
    public static testmethod void testLastCorrectivePlan_WrittenWarning_Date_Bulk_Negative()
    {
      setupData();
      List<Compliance_Review__c> compList1 = new List<Compliance_Review__c>();
      List<Compliance_Review__c> compList2 = new List<Compliance_Review__c>();
      Map<Id, Compliance_Review__c> comp1Map = new Map<Id, Compliance_Review__c>();
      Set<Id> compIDSet = new Set<Id>();
      DateTime mockUpDateTime = DateTime.now().addMonths(-6);
       // Create Compliance Reviews
      for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3002'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
          cr1.CreatedDate = mockUpDateTime;
          cr1.LastModifiedDate = mockUpDateTime;
          compList1.add(cr1);
      }
        insert compList1;
        
        for(Compliance_Review__c com:compList1)
        {
          compIDSet.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: compIDSet
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '1st Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '1st Written';
            comListUpdate.Corrective_Plan_Outbound_Disclaimer__c = '1st Written';
            comListUpdate.Corrective_Plan_Discounts__c = '1st Written';
            comListUpdate.Corrective_Plan_Security__c = '1st Written';
            comListUpdate.Corrective_Plan_Taxation__c = '1st Written';
            comListUpdate.Corrective_Plan_Service__c = '1st Written';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime;
           updateCompReviewList.add(comListUpdate);
         }
         update updateCompReviewList;
         
         for(Integer i = 0; i < 1; i++)
      {
          Compliance_Review__c cr1 = new Compliance_Review__c();
          cr1.Representative__c = salesRepUser2.Id;
          cr1.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
          cr1.Recorded_Call_ID__c = '3003'+i;
          cr1.Length_of_Call__c = 4.50;
          cr1.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
      cr1.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
      cr1.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
      cr1.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
      cr1.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
      cr1.Violation_A6__c = 'Yes'; //Service_Violation__c
      cr1.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
          cr1.CreatedDate = mockUpDateTime.addDays(1);
          cr1.LastModifiedDate = mockUpDateTime.addDays(1);
          compList2.add(cr1);
      }
        insert compList2;
        
        Set<ID> repID2 = new Set<ID>();
        for(Compliance_Review__c com:compList2)
        {
          repID2.add(com.Representative__c);
        }
        
        List<Compliance_Review__c> comList2 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: repID2
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList2 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList2)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = '2nd Written';
            comListUpdate.CP_Unethical_Business_Practice__c = '2nd Written';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c= '2nd Written';
            comListUpdate.Corrective_Plan_Service__c= '2nd Written';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList2.add(comListUpdate);
         }
         update updateCompReviewList2;
        
        Compliance_Review__c cr3 = new Compliance_Review__c();
        cr3.Representative__c = salesRepUser2.Id;
        cr3.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr3.Recorded_Call_ID__c = '300401';
        cr3.Length_of_Call__c = 4.50;
        cr3.Violation_A1__c = 'Disqualified'; //UPL_Violation__c
    cr3.Violation_A2__c = 'Disqualified'; //Unethical_Business_Practice_Violation__c
    cr3.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
    cr3.Violation_A4__c = 'Yes'; //Unauthorized_Discount_Violation__c
    cr3.Violation_A5__c = 'Poor'; //Customer_Verification_Violation__c
    cr3.Violation_A7__c = 'Yes'; //Tax_Advice_Violation__c
        cr3.CreatedDate = mockUpDateTime.addDays(1);
        cr3.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr3;
        
        List<Compliance_Review__c> comList3 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList3 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList3)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
           comListUpdate.Corrective_Plan_UPL__c = 'Termination';
            comListUpdate.Corrective_Plan_Discounts__c = '2nd Written';
            comListUpdate.Corrective_Plan_Security__c = '2nd Written';
            comListUpdate.Corrective_Plan_Taxation__c = '2nd Written';
            comListUpdate.Corrective_Plan_Service__c = '2nd Written';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList3.add(comListUpdate);
         }
         update updateCompReviewList3;
         
        Compliance_Review__c cr4 = new Compliance_Review__c();
        cr4.Representative__c = salesRepUser2.Id;
        cr4.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr4.Violation_A3__c = 'No (1st Contact)'; //Disclaimer_Violation__c
        cr4.Recorded_Call_ID__c = '300402';
        cr4.Length_of_Call__c = 15.50;
        cr4.CreatedDate = mockUpDateTime.addDays(1);
        cr4.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr4;
        
        List<Compliance_Review__c> comList4 = [SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,                                                    
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c =: cr3.Representative__c
                                               AND ((Compliance_Review__c.Total_Violation_Number__c > 0 AND Compliance_Review__c.Status__c NOT IN: STATUS_EXCLUDE_VIOLATION_LIST))
                                               order by Compliance_Review__c.CreatedDate ASC];
         
         List<Compliance_Review__c>  updateCompReviewList4 = new List<Compliance_Review__c>();                                    
         for(Compliance_Review__c comListUpdate : comList4)
         {
           comListUpdate.Status__c = 'Rep Coaching Completed';
            comListUpdate.CP_Unethical_Business_Practice__c = 'Termination';
           comListUpdate.Corrective_Plan_Start_Date__c = mockUpDateTime.addDays(1);
           updateCompReviewList4.add(comListUpdate);
         }
         update updateCompReviewList4;
        
         Compliance_Review__c cr5 = new Compliance_Review__c();
        cr5.Representative__c = salesRepUser2.Id;
        cr5.RecordTypeId = NewComplianceReviewController.SCOREDBASED_RECORDTYPE;
        cr5.Recorded_Call_ID__c = '300403';
        cr5.Length_of_Call__c = 15.50;
        cr5.CreatedDate = mockUpDateTime.addDays(1);
        cr5.LastModifiedDate = mockUpDateTime.addDays(1);
        insert cr5;
    } 
    
    */
}