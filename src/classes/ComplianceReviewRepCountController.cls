public without sharing class ComplianceReviewRepCountController
{
    public List<Compliance_Review_Limit_Chosen_Rep__c> counts{get;set;}
    public Decimal ccsCount{get;set;}
    public Decimal salesCount{get;set;}
    
    public ComplianceReviewRepCountController(ApexPages.StandardController stdController)
    {
        counts = new List<Compliance_Review_Limit_Chosen_Rep__c>();
        counts = [SELECT ID, Name, Limit_Chosen_Rep__c FROM Compliance_Review_Limit_Chosen_Rep__c ORDER BY Name ASC];
    }
    
    public PageReference saveRecords()
    {
        for(Compliance_Review_Limit_Chosen_Rep__c theCount : counts)
        {
            if(theCount.Name == 'CCS Limit Chosen Rep')
                theCount.Limit_Chosen_Rep__c = ccsCount;
            else
                theCount.Limit_Chosen_Rep__c  = salesCount;
        }
        update counts;
        return null;
    }
}