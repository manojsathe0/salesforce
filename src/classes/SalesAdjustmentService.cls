public with sharing class SalesAdjustmentService 
{
    public SalesAdjustmentService() {
        
    }

    public static void createManualSharing(List<Sales_Adjustment__c> salesAdjustments)
    {

        try
        {
            List<Sales_Adjustment__Share> salesAdjustmentShares = new List<Sales_Adjustment__Share>();
            for(Sales_Adjustment__c theAdjsutment : salesAdjustments)
            {   
                Sales_Adjustment__Share adjustmentShare  = new Sales_Adjustment__Share();
                adjustmentShare.ParentId = theAdjsutment.Id;
                adjustmentShare.UserOrGroupId = theAdjsutment.Agent__c;
                adjustmentShare.AccessLevel = 'Read';
                salesAdjustmentShares.add(adjustmentShare);

            }
            

            Database.SaveResult[] srList;
            if(!salesAdjustmentShares.isEmpty())
                srList = Database.insert(salesAdjustmentShares,false);
            for(Database.SaveResult sr : srList)
            {
                // Process the save results.
                if(sr.isSuccess())
                {
                // Indicates success
                    System.debug('Successfully inserted Sales Adjustment Shared. Sales Adjustment ID: ' + sr.getId());
                }
                else 
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors())
                    {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Sales Adjustment fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug('>>>>> Sales Adjustment Manual Sharing : '+ex.getMessage());
        }
    }
    
    
}