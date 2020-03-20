trigger UserOrderExtension on User_Order_Extension__c(after insert , after update){
    if(trigger.isAfter){
        if(Trigger.isInsert)
            {
                UserOrderExtension.populateUserorderExtensionLookUpOnOrderItem(Trigger.new);
                UserOrderExtension.closeExceptionsAndCasesOnCleanRevisions(Trigger.new);// padma uncommented
                UserOrderExtension.updateOppStageToClose(Trigger.New, Trigger.oldMap);  //@Sai - B-41703
            }
            else if(Trigger.isUpdate)
            {
               /* List<User_Order_Extension__c> extensionsWithEntityChanged = UserOrderExtension.getUOEWithEntityNameChanged(Trigger.newMap , Trigger.old);
                if(!extensionsWithEntityhttps://legalzoom--qa.cs69.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#Changed.isEmpty())
                {
                    UserOrderExtension.populateUserorderExtensionLookUpOnOrderItem(Trigger.new);
                }*/
                UserOrderExtension.populateUserorderExtensionLookUpOnOrderItem(Trigger.new);
                UserOrderExtension.closeExceptionsAndCasesOnCancellation(Trigger.new, Trigger.oldMap);
                UserOrderExtension.closeExceptionsAndCasesOnCleanRevisionsUpdate(Trigger.new, Trigger.oldMap);
                UserOrderExtension.updateOppStageToClose(Trigger.New, Trigger.oldMap);  //@Sai - B-41703
            }
    }
    
    

   
}