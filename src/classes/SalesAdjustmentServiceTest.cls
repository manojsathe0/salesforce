@isTest
public with sharing class SalesAdjustmentServiceTest {
    public SalesAdjustmentServiceTest() {
        
    }
  
    static testMethod void testCreateManualSharing()
    {
        User testManager = TestUtils.createUser('TestUser' , TestUtils.salesMgrProfileId  ,true);
        User testSalesUser = TestUtils.createUser('SaleUser' , TestUtils.salesAgentProfileId , true);
        List<Sales_Adjustment__c> salesAdjustmentsToUpdate = new List<Sales_Adjustment__c>();
        System.runAs(testManager)
        {
            Test.startTest();
                for(Integer i = 0 ; i< 50 ; ++i)
                {
                    Sales_Adjustment__c salesAdjustment = new Sales_Adjustment__c();
                    salesAdjustment.Amount_of_Adjustment__c = 100;
                    salesAdjustment.Type_of_Adjustment__c = 'Contests';
                    salesAdjustment.Agent__c = testSalesUser.Id;
                    salesAdjustmentsToUpdate.add(salesAdjustment);
                    
                }

                insert salesAdjustmentsToUpdate;
            Test.stopTest();
        }
        System.assertEquals(50 , [SELECT Id FROM Sales_Adjustment__c].size() , '50 Adjustments');
        List<Sales_Adjustment__Share> adjustmentShares = [SELECT Id , AccessLevel , RowCause , UserOrGroupId  FROM Sales_Adjustment__Share WHERE UserOrGroupId = :testSalesUser.Id];
        System.assertEquals(50 , adjustmentShares.size() , '50 records should have been created');

        for(Sales_Adjustment__Share theShare : adjustmentShares)
        {
            System.assertEquals(theShare.AccessLevel, 'Read');
            System.assertEquals(theShare.RowCause, 'Manual');
            System.assertEquals(theShare.UserOrGroupId, testSalesUser.Id);
              
        }
    }
}