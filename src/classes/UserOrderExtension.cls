public class UserOrderExtension {
    
    static Set<String> relationshipTypesToConsider = new Set<String>{'Package','SubscriptionUsage', 'Revision'};
    
    public static void populateUserorderExtensionLookUpOnOrderItem(List<User_Order_Extension__c> newUserOrderExtensions)
    {
        
        Map<String, ID> mapOrderItemIdToUoeId = getMapOrderItemIdToUoeId(newUserOrderExtensions);
        List<Order_Item__c> lstOrderItems2Update = new List<Order_Item__c>();
        for(Order_Item__c oi : [SELECT Id, LZ_Order_Item_ID__c 
                                FROM Order_Item__c 
                                WHERE LZ_Order_Item_ID__c 
                                      IN 
                                      :mapOrderItemIdToUoeId.keySet() 
                                  AND Relationship_Type_Text__c IN :relationshipTypesToConsider]){
            if(mapOrderItemIdToUoeId.get(oi.LZ_Order_Item_ID__c) != null){
                oi.User_Order_Extension__c = mapOrderItemIdToUoeId.get(oi.LZ_Order_Item_ID__c);
                lstOrderItems2Update.add(oi);
            }
        }
        update lstOrderItems2Update;
        
    }
    
    
    public static Map<String, ID> getMapOrderItemIdToUoeId(User_Order_Extension__c[] lstUOEs){
        Map<String, ID> mapOrderItemIdToUoeId = new Map<String, ID>();
        for(User_Order_Extension__c uoe : lstUOEs){
            if(uoe.LZ_Order_Item_ID__c != null && uoe.Id != null){
                mapOrderItemIdToUoeId.put(uoe.LZ_Order_Item_ID__c, uoe.Id);
            }
        }
        return mapOrderItemIdToUoeId;
    }

   /* public static List<User_Order_Extension__c> getUOEWithEntityNameChanged(Map<Id,User_Order_Extension__c> newUOEs , List<User_Order_Extension__c> oldUOEs)
    {
        List<User_Order_Extension__c> entityChangedUOEs = new List<User_Order_Extension__c>();
        for(User_Order_Extension__c oldUOE : oldUOEs)
        {
            User_Order_Extension__c newUOE = newUOEs.get(oldUOE.Id);
            if(newUOE.Entity_Name__c != oldUOE.Entity_Name__c)
            {
                entityChangedUOEs.add(newUOE);
            }
        }
        return entityChangedUOEs;
    } */
    public static void closeExceptionsAndCasesOnCancellation(List<User_Order_Extension__c> newUserOrderExtensions, Map<Id,User_Order_Extension__c> oldUOEs) {
        System.debug('inside CloseExceptionsAndCasesOnCancellation.');
        System.debug('newOrders size: ' + newUserOrderExtensions.size());
        Map<Id,Processing_Status__c> cancelledStatuses = new Map<Id,Processing_Status__c>([SELECT Id, Name FROM Processing_Status__c WHERE Name = 'Cancelled' LIMIT 1000]);
   
        
        System.debug('cancelledStatuses size: ' + cancelledStatuses.size());
        if (!cancelledStatuses.isEmpty()) {
            Set<Id> idsOfCancelledExtensions = new Set<Id>();
            for (User_Order_Extension__c ext : newUserOrderExtensions) {
                User_Order_Extension__c oldUOE = oldUOEs.get(ext.Id);
                if (cancelledStatuses.containsKey(ext.Processing_Status__c) && !cancelledStatuses.containsKey(oldUOE.Processing_Status__c)) {
                    idsOfCancelledExtensions.add(ext.Id);
                    System.debug(ext.Id + ' is cancelled');
                }
            }
            List<Order__c> ordersToQuery = new List<Order__c>();
            ordersToQuery = [SELECT Id, User_Order_ID__c FROM Order__c WHERE User_Order_Extension__c IN :idsOfCancelledExtensions];
            System.debug('ordersToQuery size: ' + ordersToQuery.size());
            if (!ordersToQuery.isEmpty()) {
                Set<Id> idsOfOrders = new Set<Id>(); 
                for (Order__c ord : ordersToQuery) {
                    idsOfOrders.add(ord.Id);
                }
                if (!idsOfOrders.isEmpty()) {
                    System.debug('Calling closeExceptionsAndCases method with ' + idsOfOrders.size() + ' Ids');
                    POR_ExceptionAPIService.closeExceptionsAndCases(idsOfOrders, 'Closed', 'Order Cancelled', 'Order Cancelled');
                  //POR_ExceptionAPIService.closeExceptionsAndCases(idsOfOrders,  'Order Cancelled', 'Order Cancelled');
                }
            }
        }
        
   
    }
    public static void closeExceptionsAndCasesOnCleanRevisions(List<User_Order_Extension__c> newUserOrderExtensions) {
        System.debug('inside closeExceptionsAndCasesOnCleanRevisions.');
        
        Map<Id,Processing_Status__c> readyForDownloadStatuses = new Map<Id,Processing_Status__c>([SELECT Id, Name FROM Processing_Status__c WHERE Name IN ('Ready for Download','Ready to Print') LIMIT 1000]);
        System.debug('readyForDownloadStatuses size: ' + readyForDownloadStatuses.size());
        
    
        
        if (!readyForDownloadStatuses.isEmpty()) {
            Set<Id> idsOfReadyForDownloadExtensions = new Set<Id>();
            Set<String> currentProcessingNumbers = new Set<String>();
            for (User_Order_Extension__c ext : newUserOrderExtensions) {
                if (readyForDownloadStatuses.containsKey(ext.Processing_Status__c)) {
                    idsOfReadyForDownloadExtensions.add(ext.Id);
                    currentProcessingNumbers.add(ext.LZ_User_Order_ID__c);
                }
            }
            System.debug('currentProcessingNumbers size: ' + currentProcessingNumbers.size());
            
            List<Order__c> ordersToQuery = new List<Order__c>();
            ordersToQuery = [SELECT Id, User_Order_ID__c FROM Order__c WHERE User_Order_ID__c IN :currentProcessingNumbers];
            System.debug('ordersToQuery size: ' + ordersToQuery.size());
            if (!ordersToQuery.isEmpty()) {             
                Set<Id> idsOfOrders = new Set<Id>(); 
                for (Order__c ord : ordersToQuery) {
                    idsOfOrders.add(ord.Id);
                }
                if (!idsOfOrders.isEmpty()) {
                    System.debug('Calling closeExceptionsAndCases method with ' + idsOfOrders.size() + ' Ids');
                    POR_ExceptionAPIService.closeExceptionsAndCases(idsOfOrders, 'Resolved', 'Clean Revision Placed', 'Revision placed on LZ.com');
                    // POR_ExceptionAPIService.closeExceptionsAndCases(idsOfOrders, 'Clean Revision Placed', 'Revision placed on LZ.com');
                }
            }
        }
        
   
      
    }
    
    public static void closeExceptionsAndCasesOnCleanRevisionsUpdate(List<User_Order_Extension__c> newUserOrderExtensions, Map<Id,User_Order_Extension__c> oldUOEs) {
        System.debug('inside closeExceptionsAndCasesOnCleanRevisionsUpdate.');
        
       // Map<Id,Processing_Status__c> readyForDownloadStatuses = new Map<Id,Processing_Status__c>([SELECT Id, Name FROM Processing_Status__c WHERE Name = 'Ready for Download' LIMIT 1000]);
        Map<Id,Processing_Status__c> readyForDownloadStatuses = new Map<Id,Processing_Status__c>([SELECT Id, Name FROM Processing_Status__c WHERE Name IN ('Ready for Download','Ready to Print')  LIMIT 1000]);
        System.debug('readyForDownloadStatuses size: ' + readyForDownloadStatuses.size());
        
    
        
        if (!readyForDownloadStatuses.isEmpty()) {
            
            
            
            Set<Id> idsOfReadyForDownloadExtensions = new Set<Id>();
            Set<String> currentProcessingNumbers = new Set<String>();
            for (User_Order_Extension__c ext : newUserOrderExtensions) {
                if (ext.Processing_Status__c != oldUOEs.get(ext.Id).Processing_Status__c) {
                    System.debug('Processing_Status__c chaged from ' + ext.Processing_Status__c + ' to ' + oldUOEs.get(ext.Id).Processing_Status__c);
                    if (readyForDownloadStatuses.containsKey(ext.Processing_Status__c)) {
                        idsOfReadyForDownloadExtensions.add(ext.Id);
                        currentProcessingNumbers.add(ext.LZ_User_Order_ID__c);
                    }
                }
                
            }
            System.debug('currentProcessingNumbers size: ' + currentProcessingNumbers.size());
            
            List<Order__c> ordersToQuery = new List<Order__c>();
            ordersToQuery = [SELECT Id, User_Order_ID__c FROM Order__c WHERE User_Order_ID__c IN :currentProcessingNumbers];
            System.debug('ordersToQuery size: ' + ordersToQuery.size());
            if (!ordersToQuery.isEmpty()) {             
                Set<Id> idsOfOrders = new Set<Id>(); 
                for (Order__c ord : ordersToQuery) {
                    idsOfOrders.add(ord.Id);
                }
                if (!idsOfOrders.isEmpty()) {
                    System.debug('Calling closeExceptionsAndCases method with ' + idsOfOrders.size() + ' Ids');
                    POR_ExceptionAPIService.closeExceptionsAndCases(idsOfOrders, 'Resolved', 'Clean Revision Placed', 'Revision placed on LZ.com');
                    // POR_ExceptionAPIService.closeExceptionsAndCases(idsOfOrders, 'Clean Revision Placed', 'Revision placed on LZ.com');
                }
            }
        } 
    }
    

    //@Sai - B-41703
    //Close OPP when Status is Sent to SOS and Documents Received from SOS.
    public static void updateOppStageToClose(List<User_Order_Extension__c> newUOE, Map<Id, User_Order_Extension__c> oldUOEMap) {
        Set<ID> UOEIds = new Set<ID>();
        Map<ID, ID> procStatusMap = new Map<ID, ID>();
        List<Opportunity> oppListUpdate = new List<Opportunity>();

        for (User_Order_Extension__c uoe : newUOE) {
            if (Trigger.isUpdate){
                if (oldUOEMap.get(uoe.Id).Processing_Status__c != uoe.Processing_Status__c)
                    procStatusMap.put(uoe.Processing_Status__c, uoe.Id);
            }
            if(Trigger.isInsert)
            {
                procStatusMap.put(uoe.Processing_Status__c, uoe.Id);
            }
        }

        for (Processing_Status__c processingStatus : [SELECT Id, Name FROM Processing_Status__c
                WHERE Name IN ('Sent to SOS', 'Documents Received from SOS') and Id IN: procStatusMap.keySet()]) {
            UOEIds.add(procStatusMap.get(processingStatus.id));
        }

        List<Order__c> orderList = [SELECT Id, (SELECT Id, StageName, CloseDate, Closed_Lost_Reason_LTN__c FROM Opportunities__r
                                                WHERE Product2__c IN ('LLC', 'INC')
                                                AND OnBoarding__c = true AND Owner.Name LIKE '%Integration User%')
                                    FROM Order__c WHERE User_Order_Extension__c IN: UOEIds];

        for (Order__c ord : orderList) {
            for (Opportunity opp : ord.Opportunities__r) {
                opp.StageName = 'Closed Lost';
                opp.Closed_Lost_Reason_LTN__c = 'No Longer Interested in LZ Product/Service';
                opp.StageName = 'Closed Lost';
                oppListUpdate.add(opp);
            }
        }

        if (!oppListUpdate.isEmpty()) {
            try {
                update oppListUpdate;
            } catch (Exception e) {
                system.debug('---Failed updating opp ' + e.getMessage() + ' Mtd: UserOrderExtention.updateOppStageToClose()');
            }
        }
}