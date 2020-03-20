public with sharing class IADOrderWithOrderItemsController_ltng
{  
    @AuraEnabled public Boolean termsAccepted{get;set;}
    @AuraEnabled public Boolean isCancelled{get;set;}
    @AuraEnabled public String customerName{get;set;}
    @AuraEnabled public String orderNumber{get;set;}    
    
    @AuraEnabled public Order__c thisOrder {get;set;}
    @AuraEnabled public static IADOrderWithOrderItemsService_ltng orderService{get;set;}
    
    @AuraEnabled public List<Authorized_Contact__c> authorizedContacts{get;set;}
    @AuraEnabled public String customerId{get;set;}     
    
    @AuraEnabled public static List<String> orderTags{get;set;}
    
    @AuraEnabled public static IADOrderWithOrderItemsController_ltng ctrlRef {get; set;}
    @AuraEnabled public  static String customerIdrelated{get;set;}  
    
    @AuraEnabled
    public static IADOrderWithOrderItemsController_ltng init(String orderRecordId, String orderNumber)
    {
        IADOrderWithOrderItemsController_ltng ctrl = new IADOrderWithOrderItemsController_ltng();
        ctrl.authorizedContacts = new List<Authorized_Contact__c>();  
        ctrl.thisOrder = new Order__c();
        ctrl.termsAccepted = false;
        ctrl.isCancelled = false;
        
        if(String.isNotBlank(orderRecordId))
        {
            ctrl.thisOrder = [SELECT Id , Name , OrderID__c , Contact__r.Name, Contact__r.Contact_Type__c, Contact__r.FkUser__c,Language_Preferance__c, Order_Date_Time_Created__c, Date_Time_TOS_Accepted__c, TOS_Accepted__c, OrderTerms__c, CreatedBy.Name, LastModifiedBy.Name FROM Order__c WHERE Id = :orderRecordId limit 1][0];
            ctrl.orderNumber = ctrl.thisOrder.OrderID__c;
            ctrl.customerId = ctrl.thisOrder.Contact__r.FkUser__c;
            ctrl.customerName = ctrl.thisOrder.Contact__r.Name;
            customerIdrelated= ctrl.thisOrder.Contact__r.FkUser__c;
            ctrl.authorizedContacts = [select Id, Contact__r.LZ_Order_Contact_ID__c, Contact__r.Name, Contact__r.Contact_Type__c, Authorized_Order__c, Authorized_Order__r.Name from Authorized_Contact__c where Authorized_Order__r.Id =: orderRecordId and Inactive__c = false];
        }
        else{
            ctrl.orderNumber = orderNumber;
        }
        return ctrl;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng getOrderByOrderId(String orderRecordId, String orderNumber) 
    {   
        system.debug('orderRecordId: '+orderRecordId);
        system.debug('orderNumber: '+orderNumber);
        orderService  = new IADOrderWithOrderItemsService_ltng();
        
        ctrlRef = init(orderRecordId, orderNumber);
        
        try
        {   
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERBYORDERID);
            IADOrderWithOrderItemsService_ltng.getOrderByOrderId(ctrlRef.orderNumber);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in startRequestsInParallel');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
        system.debug('orderWrapper: '+IADOrderWithOrderItemsService_ltng.finalOrderItemWrappers);
        system.debug('the order balance: '+IADOrderWithOrderItemsService_ltng.theOrderBalance);
        return orderService;        
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng getOrderBalanceByOrderId(String orderRecordId, String orderNumber) 
    {   
        orderService  = new IADOrderWithOrderItemsService_ltng();
        ctrlRef = init(orderRecordId, orderNumber);
        try
        {   
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID);
            IADOrderWithOrderItemsService_ltng.getOrderBalanceByOrderId(ctrlRef.orderNumber);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in startRequestsInParallel');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('the order balance: '+IADOrderWithOrderItemsService_ltng.theOrderBalance);
        return orderService;        
    }    
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng getOrderTags(String orderRecordId, String orderNumber) 
    {   
        try
        {   
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERTAGBYORDERID);
            IADOrderWithOrderItemsService_ltng.getOrderTagByOrderId(ctrlRef.orderNumber);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in getOrderTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('IADOrderWithOrderItemsService_ltng.iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        return orderService;        
    }   
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng createOrderTags(String orderRecordId, String tagName, String orderNumber) 
    {   
        try
        {   
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.POSTORDERTAGBYORDERID);
            IADOrderWithOrderItemsService_ltng.createOrderTagByOrderId(ctrlRef.orderNumber, tagName);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in createOrderTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('iadServiceMessages---->'+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng deleteOrderTags(String orderRecordId, String tagName, String orderNumber) 
    {   
        try
        {   
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.DELETEORDERTAGBYORDERID);
            IADOrderWithOrderItemsService_ltng.deleteOrderTagByOrderId(ctrlRef.orderNumber, tagName);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in deleteOrderTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng getShipmentsByOrderId(String orderRecordId, String orderNumber) 
    {   
        try
        {   
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETSHIPMENTSBYORDERID);
            IADOrderWithOrderItemsService_ltng.getShipmentsByOrderId(ctrlRef.orderNumber);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in getShipmentsByOrderId');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
        return orderService;        
    }   
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng populateActionItemsByOrderItemId(String orderItemId, String actionType)
    {
        orderService  = new IADOrderWithOrderItemsService_ltng();
        Set<String> actionTypeIds = new Set<String>();
        system.debug('actionType: '+actionType);
        if(actionType == 'changePackage')
        {
            //actionTypeIds.add('2');//Cancel Uncomment this to display Cancel Package Action Item
            actionTypeIds.add('3');//Change
        }
        else if(actionType == 'addItem')
        {
            actionTypeIds.add('0');//Add
        }
        system.debug('actionTypeIds: '+actionTypeIds);
        try
        {
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETACTIONITEMSBYORDERITEMID);
            IADOrderWithOrderItemsService_ltng.getActionItemsByOrderItemId(orderItemId , actionTypeIds);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng modifyOrderItem(String productConfigurationId, String orderItemId, String orderRecordId, String orderNumber, Map<String, Object> pdtCnfgActionItem, Map<String, Object> orderItemIdToPdtCnfgId)
    {
        System.debug('productConfigurationId: '+productConfigurationId);
        System.debug('orderItemId: '+orderItemId);
        System.debug('orderRecordId: '+orderRecordId);
        System.debug('pdtCnfgActionItem: '+pdtCnfgActionItem);
        System.debug('orderItemIdToPdtCnfgId: '+orderItemIdToPdtCnfgId); 
        
        orderService  = new IADOrderWithOrderItemsService_ltng();
        ctrlRef = init(orderRecordId, orderNumber);
        Map<String, IADContractBeans_ltng.IADActionItem> pdtCnfgActionItemMap = new Map<String, IADContractBeans_ltng.IADActionItem>();
        for(String pdtCnfgId : pdtCnfgActionItem.keySet()){
            String theResponse = JSON.serialize(pdtCnfgActionItem.get(pdtCnfgId));        
            IADContractBeans_ltng.IADActionItem deSerializedResponse  = (IADContractBeans_ltng.IADActionItem) JSON.deserialize(theResponse , IADContractBeans_ltng.IADActionItem.class);
            pdtCnfgActionItemMap.put(pdtCnfgId, deSerializedResponse);
        }
        
        Map<String, String> orderItemIdToPdtCnfgIdMap = new Map<String, String>();
        for(String orderItemPdtCnfg : orderItemIdToPdtCnfgId.keySet()){
            orderItemIdToPdtCnfgIdMap.put(orderItemPdtCnfg, String.valueOf(orderItemIdToPdtCnfgId.get(orderItemPdtCnfg)));
        }
        
        system.debug('pdtCnfgActionItemMap: '+pdtCnfgActionItemMap);
        try
        {            
            if(pdtCnfgActionItemMap.get(productConfigurationId).actionItemsType == '0') //Only Trigger this for Adding Add On, Cross Sell , Shipping and Filing Fees
            {
                system.debug('addOrderItem: ');
                IADOrderWithOrderItemsService_ltng.addOrderItem(productConfigurationId, ctrlRef.orderNumber, orderItemId, pdtCnfgActionItemMap);
            }
            else if(pdtCnfgActionItemMap.get(productConfigurationId).actionItemsType == '2')//Cancel
            {
                system.debug('cancelOrderItem: ');
                IADOrderWithOrderItemsService_ltng.cancelOrderItem(productConfigurationId, ctrlRef.orderNumber, pdtCnfgActionItemMap);
            }
            else if(pdtCnfgActionItemMap.get(productConfigurationId).actionItemsType == '3')//Change
            {
                system.debug('changeOrderItem: ');
                IADOrderWithOrderItemsService_ltng.changeOrderItem(productConfigurationId, ctrlRef.orderNumber, orderItemId, pdtCnfgActionItemMap, orderItemIdToPdtCnfgIdMap); 
            }
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('modifiedOrderItemWrappers: '+IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers);
        system.debug('modifiedOrderItems service: '+orderService);
        system.debug('modifiedOrderItems IADMessage_ltng iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        
        return orderService;
    } 
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng callCancelOrder(String orderRecordId, String orderNumber)
    {
        try
        {
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService.DELETEORDERBYORDERID); //, 'processCancelUncancelOperationResponse'
            IADOrderWithOrderItemsService_ltng.callCancelUnCancelOrder(ctrlRef.orderNumber , 'Cancel');
            system.debug('IAD Order cancellation message: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        catch(Exception theException)
        {
            system.debug('Exception inside cancel');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('cancellation: '+orderService);
        system.debug('cancellation IADMessage_ltng iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        system.debug('cancellation IADMessage_ltng message list: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages[0].message);
        
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng callUncancelOrder(String orderRecordId, String orderNumber)
    {
        try
        {
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService.PUTUNCANCELORDERBYORDERID);
            IADOrderWithOrderItemsService_ltng.callCancelUnCancelOrder(ctrlRef.orderNumber , 'UnCancel');
        }
        catch(Exception theException)
        {
            system.debug('Exception inside Uncancel');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('Uncancellation: '+orderService);
        system.debug('Uncancellation IADMessage_ltng iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        system.debug('Uncancellation IADMessage_ltng message list: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages[0].message);
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng convertOrderToThreePay(String orderRecordId, String orderNumber)
    {
        try
        {
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService.PUTORDERTO3PAYBYORDERID); // , 'processConvert3PayResponse'
            IADOrderWithOrderItemsService_ltng.convertOrderTo3Pay(ctrlRef.orderNumber, ctrlRef.customerId);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('conver to 3pay: log'+orderService);
        return orderService;
    }
    
    @AuraEnabled
    public static List<IADOrderWithOrderItemsService_ltng.OrderItemHistoryWrapper> populateOrderHistory(String orderRecordId, String orderNumber, Map<String, Object> orderItemIdToPdtNameMap)
    {
        try
        {
            Map<String, String> oipnMap = new Map<String, String>();
            for(String odrItem : orderItemIdToPdtNameMap.keySet()){
                oipnMap.put(odrItem, String.valueOf(orderItemIdToPdtNameMap.get(odrItem)));
            }
            system.debug('oipnMap----->'+oipnMap);
            system.debug('orderItemIdToPdtNameMap----->'+orderItemIdToPdtNameMap);
            
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERHISTORYBYORDERID);
            IADOrderWithOrderItemsService_ltng.getOrderHistoryByOrderId(ctrlRef.orderNumber, oipnMap);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return IADOrderWithOrderItemsService_ltng.finalOrderItemHistoryWrapper;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng getEininfo(string processingid)
    {
        orderService  = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETENTITYBYPROCESSINGID);
        IADOrderWithOrderItemsService_ltng.getEntityByProcessingID(processingid);
        return  orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng reAutomateOrder(String processingOrderId) 
    {   
        try
        {   
            orderService  = new IADOrderWithOrderItemsService_ltng();
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.POSTDOCUMENTBYPROCESSINGORDERID);
            IADOrderWithOrderItemsService_ltng.postDocumentByProcessingOrderId(processingOrderId);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in reAutomateOrder');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('IADOrderWithOrderItemsService_ltng.iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        system.debug('orderService');
        system.debug(orderService);
        return orderService;        
    }  
    
    @AuraEnabled
    public static List<IADContractBeans_ltng.DocumentList> getDocumentsByProcessingOrderId(String processingOrderId) 
    {   
        try
        {   
            system.debug('processingOrderId--->'+processingOrderId);
            orderService  = new IADOrderWithOrderItemsService_ltng();
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETDOCUMENTSBYPROCESSINGORDERID);
            IADOrderWithOrderItemsService_ltng.getDocumentsByProcessingOrderId(processingOrderId);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in getDocumentsByProcessingOrderId');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('IADOrderWithOrderItemsService_ltng.iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        system.debug('IADOrderWithOrderItemsService_ltng.docList');
        system.debug(IADOrderWithOrderItemsService_ltng.docList);
        return IADOrderWithOrderItemsService_ltng.docList;        
    } 
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng shareDocumentsByProcessingOrderId(String customerId, String processingOrderId, Integer processId, String processName, String contactType, String documentList, List<Decimal> selectedDocuments) 
    {   
        system.debug('customerId-->' + customerId + 'processingOrderId-->' + processingOrderId + 'processId-->' + processId + 'processName-->' + processName + 'contactType-->' + contactType );
        system.debug('<--documentList-->');
        system.debug(documentList);
        system.debug('<--selectedDocuments-->');
        system.debug(selectedDocuments);
        try
        {   
            String payload = generateDocumentSharePayload(customerId, processingOrderId, processId, processName, contactType, documentList, selectedDocuments) ;
            system.debug('payload');
            system.debug(payload);
            orderService  = new IADOrderWithOrderItemsService_ltng();
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.SHAREDOCUMENTSBYPROCESSINGORDERID);
            IADOrderWithOrderItemsService_ltng.shareDocumentByProcessingOrderId(processingOrderId, payload);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in getDocumentsByProcessingOrderId');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('IADOrderWithOrderItemsService_ltng.iadServiceMessages: '+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        system.debug('orderService');
        system.debug(orderService);
        return orderService;        
    } 
    
    public static String generateDocumentSharePayload(String customerId, String processingOrderId, Integer processId, String processName, String contactType, String documentList, List<Decimal> selectedDocuments) 
    {   
        IADContractBeans_ltng.DocumentShareList sharedDocument = new IADContractBeans_ltng.DocumentShareList();
        List<IADContractBeans_ltng.DocumentShareList> documentsToShare = new List<IADContractBeans_ltng.DocumentShareList>();
        
        List<IADContractBeans_ltng.DocumentList> documents = (List<IADContractBeans_ltng.DocumentList>) JSON.deserialize(documentList , List<IADContractBeans_ltng.DocumentList>.class);
        system.debug('documents');
        system.debug(documents);
        
        for(IADContractBeans_ltng.DocumentList doc : documents){
            sharedDocument = new IADContractBeans_ltng.DocumentShareList();
            if(selectedDocuments.contains(Decimal.valueOf(doc.documentId))){
                sharedDocument.documentName = doc.documentName; 
                sharedDocument.folderName = doc.folderName;
                sharedDocument.isFileNetDocument = doc.isFileNetDocument;
                sharedDocument.createdDate = doc.createdDate;
                documentsToShare.add(sharedDocument);
            }
        }
        
        IADContractBeans_ltng.IADDocumentShareBean docShareBean = new IADContractBeans_ltng.IADDocumentShareBean();
        docShareBean.customerId = Integer.valueOf(customerId);
        docShareBean.processingOrderId = Integer.valueOf(processingOrderId);
        docShareBean.files = documentsToShare;
        docShareBean.processId = processId;//Integer.valueOf(processId);
        docShareBean.processName = processName;//processName;
        docShareBean.contactType = contactType;
        
        return JSON.serialize(docShareBean);  
    }      
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng createMiscItem(String orderRecordId, String itemQuantity, String itemPricePerUnit, String itemDescription, String orderNumber)
    {
        try
        {
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADOrderWithOrderItemsService_ltng.createMiscItemByOrderId(ctrlRef.orderNumber, itemQuantity, itemPricePerUnit, itemDescription);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('mis item wrapper: '+IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers);
        //return IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers;
        return orderService;
    }
    
    @AuraEnabled
    public static List<IADOrderWithOrderItemsService_ltng.OrderItemWrapper> createExpedite(String orderRecordId,String pdfcnfgid, String itemQuantity, String orderNumber ,string price )
    {
        try
        {
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADOrderWithOrderItemsService_ltng.createExpedite(ctrlRef.orderNumber, '1', pdfcnfgid,  price );
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('mis item wrapper: '+IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers);
        return IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers;
    }
    
    @AuraEnabled
    public static List<IADOrderWithOrderItemsService_ltng.OrderItemWrapper> createFiling(String orderRecordId,String pdfcnfgid, Integer itemQuantity, String orderNumber)
    {
        try
        {
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderNumber);
            IADOrderWithOrderItemsService_ltng.createFilingItem(ctrlRef.orderNumber, Integer.valueof(itemQuantity), pdfcnfgid,  '275' );
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('mis item wrapper: '+IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers);
        return IADOrderWithOrderItemsService_ltng.modifiedOrderItemWrappers;
    }    
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng subscriptionChangeOptions(String orderRecordId, String orderId, String productComponentId, String orderItemId){
        try
        {
            system.debug('orderRecordId-->' + orderRecordId +'orderId'+ orderId +'productComponentId'+ productComponentId +'orderItemId'+ orderItemId);
            orderService  = new IADOrderWithOrderItemsService_ltng();
            ctrlRef = init(orderRecordId, orderId);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETSUBSCRIPTIONCHANGEOPTIONS);
            IADOrderWithOrderItemsService_ltng.getSubscriptionChangeOptions(productComponentId, orderItemId, ctrlRef.customerName);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('subscriptionChangeOptions: '+IADOrderWithOrderItemsService_ltng.subChangeOptions);
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng proratedSubscriptionTermInfo(String orderRecordId, String orderId, String orderItemId, String renewalProductConfigurationId){
        try
        {
            system.debug('orderRecordId-->' + orderRecordId +'orderId'+ orderId +'renewalProductConfigurationId'+ renewalProductConfigurationId);
            orderService  = new IADOrderWithOrderItemsService_ltng();
            //ctrlRef = init(orderRecordId, orderId);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.POSTPRORATEDSUBSCRIPTIONTERM);
            IADOrderWithOrderItemsService_ltng.postProratedSubscriptionTermInfo(orderId, orderItemId, renewalProductConfigurationId);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('proratedSubInfo: '+IADOrderWithOrderItemsService_ltng.proratedSubInfo);
        return orderService;
    }
    
    @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng upgradeSubscritionPackage(String orderRecordId, Integer subscriptionId, String orderItemId, String targetPackage, String newProductComponentId, String renewalProductConfigurationId){
        try
        {
            system.debug('orderRecordId-->' + orderRecordId + 'subscriptionId-->' + subscriptionId +'orderItemId-->'+ orderItemId +'newProductComponentId-->'+ newProductComponentId +'renewalProductConfigurationId-->'+ renewalProductConfigurationId);
            orderService  = new IADOrderWithOrderItemsService_ltng();
            //ctrlRef = init(orderRecordId, orderId);
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.PutSubscriptionAdjustment);
            IADOrderWithOrderItemsService_ltng.upgradeSubscriptionPackage(subscriptionId, orderItemId, targetPackage, newProductComponentId, renewalProductConfigurationId);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        System.debug('newOrderInfo: '+IADOrderWithOrderItemsService_ltng.newOrderInfo);
        return orderService;
    }
      @AuraEnabled
    public static IADOrderWithOrderItemsService_ltng updateProcessingStatus(String processingnumber) 
    {   
        try
        {   
            orderService  = new IADOrderWithOrderItemsService_ltng();
           
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.PostProcessingStatus);
            IADOrderWithOrderItemsService_ltng.postProcessingstatus(processingnumber);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in createOrderTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('iadServiceMessages---->'+IADOrderWithOrderItemsService_ltng.iadServiceMessages);
        }
        return orderService;
    }

    /* STORY B-39539 - Changes Starts Here*/
    /* Test Coverage in IADOrderWithOrderItems_LtngTest Apex Class */
    @Testvisible private static IADServiceBase_ltng iAD = new IADServiceBase_ltng();
    @TestVisible private with sharing class customException extends Exception {}
    
    @AuraEnabled
    public static string updateOrderToCancel(cancelRequestWrapper cRWrap, string orderId){
        final string CANCELORDERBYORDERID = 'CancelOrderByOrderId';
        APIRequestResponseWrapper_ltng apiWrap;
        String calloutURL ='';
        try{
            if(cRWrap!=null && string.isNotBlank(orderId)){
                cRWrap.updatedBy = UserInfo.getUserEmail().substring(0, UserInfo.getUserEmail().indexOf('@'));
                IADServiceBase_ltng.initEndpoints(new List<String>{CANCELORDERBYORDERID});
                IADServiceBase_ltng.initWrapper(CANCELORDERBYORDERID);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(CANCELORDERBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}', orderId);
                IADServiceBase_ltng.makeRequestMulti(calloutURL, CANCELORDERBYORDERID, JSON.serialize(cRWrap));            
                apiWrap = IADServiceBase_ltng.APItoWrapper.get(CANCELORDERBYORDERID);
                if(apiWrap.checkIsValidResponse()){
                    return 'SUCCESS';
                } else if (String.isNotBlank(apiWrap.errorMessage)) {
                    return apiWrap.errorMessage;
                }
            } else{
                throw new customException('Input Params are Blank');
            }
            return 'FAILURE';
        } catch (Exception e){
            return e.getMessage();
        }
    }
    public with sharing class cancelRequestWrapper{
        /*
        {
          "approvedBy": "sxreddy",
          "updatedBy": "sxreddy"
        }
        */
        @AuraEnabled public string approvedBy {get;set;}
        @AuraEnabled public string updatedBy {get;set;}
    }
    /* STORY B-39539 - Changes Ends Here*/
}