@isTest
public with sharing class ComplianceReviewRepCountControllerTest 
{
    static testMethod void testsaveCounts()
    {    
        Compliance_Review_Limit_Chosen_Rep__c salesLimit = new Compliance_Review_Limit_Chosen_Rep__c(Name = 'Limit Chosen Rep',Limit_Chosen_Rep__c = 25);
        insert salesLimit;
        
        Compliance_Review_Limit_Chosen_Rep__c ccsLimit = new Compliance_Review_Limit_Chosen_Rep__c(Name = 'CCS Limit Chosen Rep',Limit_Chosen_Rep__c = 25);
        insert ccsLimit ;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(salesLimit);
        ComplianceReviewRepCountController theController = new ComplianceReviewRepCountController(sc);
        PageReference pageRef = Page.ComplianceReviewRepCount;
        
        Test.setCurrentPage(pageRef);
        
        Test.startTest(); 
            theController.ccsCount = 21;
            theController.salesCount = 20;
            theController.saveRecords();
        Test.stopTest();
        
        List<Compliance_Review_Limit_Chosen_Rep__c> updatedCounts = [SELECT ID, Name, Limit_Chosen_Rep__c FROM Compliance_Review_Limit_Chosen_Rep__c ORDER BY Name ASC];
         for(Compliance_Review_Limit_Chosen_Rep__c theCount : updatedCounts )
            {
                if(theCount.Name.Contains('CCS'))
                    system.assertEquals(21,theCount.Limit_Chosen_Rep__c);
                else
                    system.assertEquals(20,theCount.Limit_Chosen_Rep__c);
            }
    }
}