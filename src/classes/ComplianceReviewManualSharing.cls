public with sharing class ComplianceReviewManualSharing 
{
    static final String COMPLIANCE_STATUS = 'Compliant';
    static final String REP_COACHING_COMPLETED_STATUS = 'Rep Coaching Completed';
    static final String EXCLUDE_COMPLETE_STATUS = 'Exclude Complete Status';
    
    public static void complianceReviewManualSharingSalesRep(List<Compliance_Review__c> newComp)
    {
        try
        { 
            List<Compliance_Review__Share> compShare = new List<Compliance_Review__Share>();
            Compliance_Review_Status__c compStatus = Compliance_Review_Status__c.getInstance(EXCLUDE_COMPLETE_STATUS);
            for(Compliance_Review__c comp : newComp)
            {
                if(compStatus.Compliance_Status__c.contains(comp.Status__c))
                {
                    // Create new sharing object for the custom object Job.
                    Compliance_Review__Share complianceShare  = new Compliance_Review__Share();
                    
                    // Set the ID of record being shared.
                    complianceShare.ParentId = comp.Id;
                
                    // Set the ID of user or group being granted access.
                    complianceShare.UserOrGroupId = comp.Representative__c;
                    
                    // Set the access level.
                    complianceShare.AccessLevel = 'Read';
                    
                    // Set rowCause to 'manual' for manual sharing.
                    // This line can be omitted as 'manual' is the default value for sharing objects.
                    complianceShare.RowCause = Schema.Compliance_Review__Share.RowCause.Manual;
                    compShare.add(complianceShare);
                    system.debug(complianceShare);
                }
            }
            // Insert the sharing record and capture the save result. 
            // The false parameter allows for partial processing if multiple records passed 
            // into the operation.
            Database.SaveResult[] srList;
            if(!compShare.isEmpty())
                 srList = Database.insert(compShare,false);
            for(Database.SaveResult sr : srList)
            {
                // Process the save results.
                if(sr.isSuccess())
                {
                    // Indicates success
                    System.debug('Successfully inserted Compliance Review Shared. Compliance Review ID: ' + sr.getId());
                }
                else 
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors())
                    {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Compliance Review fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug('>>>>> Compliance Review Manual Sharing : '+ex.getMessage());
        }
    }
    
    public void complianceReviewManualSharingBatch()
    {
        Compliance_Review_Status__c compStatus = Compliance_Review_Status__c.getInstance(EXCLUDE_COMPLETE_STATUS);
        List<String> excludeCompleteStatusList = compStatus.Compliance_Status__c.split(', ');
        List<Compliance_Review__c> compListBatch = [SELECT Id,Status__c, Representative__c 
                                                    FROM Compliance_Review__c 
                                                    WHERE Status__c IN: excludeCompleteStatusList];
        complianceReviewManualSharingSalesRep(compListBatch);
    }
}