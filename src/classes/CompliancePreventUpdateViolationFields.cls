public with sharing class CompliancePreventUpdateViolationFields 
{
    public static final String COMPLIANCE_STATUS = 'Compliant';
    public static final String COMPLIANCE_ERROR_MESSAGE = 'Violation-related fields cannot be modified if it is not the latest record.';
    
    public static void PreventUpdateViolationFields_CompliantStatus(List<Compliance_Review__c> newComp)
    {
        Set<Id> compRepID = new Set<Id>();
        if(Userinfo.getProfileId() != ADMIN_PROFILE_ID)
        {
            for(Compliance_Review__c comp : newComp)
            {
                compRepID.add(comp.Representative__c);
            }
            List<Compliance_Review__c> compOldList = [  SELECT Id, Status__c, CreatedDate, Violation_A1__c, Violation_A2__c, Violation_A3__c, Violation_A4__c, Violation_A5__c, Violation_A6__c, Violation_A7__c, Violation_A8__c
                                                        FROM Compliance_Review__c 
                                                        WHERE Compliance_Review__c.Representative__c IN: compRepID 
                                                        AND Compliance_Review__c.RecordTypeId =: NewComplianceReviewController.SCOREDBASED_RECORDTYPE
                                                        ORDER BY CreatedDate DESC
                                                     ];

            for(Compliance_Review__c compNew : newComp)
            {
                if(compNew.Status__c == COMPLIANCE_STATUS)
                {
                    if(compOldList.size() > 1)
                    {
                        if(compNew.CreatedDate != compOldList[0].CreatedDate)
                        {
                            for(Compliance_Review__c compOld : compOldList)
                            {
                                if(compNew.Id == compOld.Id)
                                {
                                    if(
                                        compNew.Violation_A1__c != compOld.Violation_A1__c ||
                                        compNew.Violation_A2__c != compOld.Violation_A2__c ||
                                        compNew.Violation_A3__c != compOld.Violation_A3__c ||
                                        compNew.Violation_A4__c != compOld.Violation_A4__c ||
                                        compNew.Violation_A5__c != compOld.Violation_A5__c ||
                                        compNew.Violation_A6__c != compOld.Violation_A6__c ||
                                        compNew.Violation_A7__c != compOld.Violation_A7__c ||
                                        compNew.Violation_A8__c != compOld.Violation_A8__c
                                      )
                                    {
                                        compNew.addError(COMPLIANCE_ERROR_MESSAGE);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static Id ADMIN_PROFILE_ID 
    {
        get
        {
            if(ADMIN_PROFILE_ID == null)
            {
                List<Profile> adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
                if(!adminProfile.isEmpty())
                {
                    ADMIN_PROFILE_ID = adminProfile[0].Id;
                }
            }
            
            return ADMIN_PROFILE_ID ;
        }
    }
}