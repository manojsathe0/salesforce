public class IADOrderSearchController_Ltng extends IADServiceBase_ltng {
    public final static String GETORDERBYORDERID = 'GetOrderByOrderId';
    
    @AuraEnabled public static Order__c order{get;set;}
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static Boolean orderFoundViaApi{get;set;}
    @AuraEnabled public static Boolean orderFoundInSalesforce{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> serviceMessages{get;set;}
    @AuraEnabled public static IADOrderSearchController_Ltng orderSearch{get;set;}
    
    public IADOrderSearchController_Ltng() 
    {
        super();
        
        List<String> endpoints = new List<String>();
        endpoints.add(GETORDERBYORDERID);
        initEndpoints(endpoints); 
        
        order = new Order__c();
        orderFoundViaApi = false;
        orderFoundInSalesforce = false;
        serviceMessages = new List<IADMessage_ltng>();
    }
    
    public static Order__c createNewOrder(String orderNumber, String customerId)
    {
        order = new Order__c();
            
        if(String.isNotBlank(orderNumber))
        {
            order.Name = orderNumber;
            order.OrderID__c = orderNumber;
            if(String.isNotBlank(customerId)){
                List<Contact> contact = [SELECT Id FROM Contact WHERE FkUser__c =: customerId];
                if(contact.size() > 0){
                    order.Contact__c = contact[0].Id;
                }
            }
            insert order;
        }  
        return order;
    }
    
    @AuraEnabled
    public static IADOrderSearchController_Ltng validateOrderByOrderId(String orderNumber) 
    {
        system.debug('orderNumber: '+orderNumber);        
        IADOrderSearchController_Ltng orderSearch  = new IADOrderSearchController_Ltng();
        
        try
        {   
            for(Order__c ordr : [SELECT Id, OrderId__c, Contact__r.FkUser__c FROM Order__c WHERE OrderId__c =: orderNumber LIMIT 1]){
                order = ordr;
                orderFoundInSalesforce = true;                
                orderId = ordr.OrderId__c;
                customerId = ordr.Contact__r.FkUser__c;
            }
            if(!orderFoundInSalesforce){
                IADServiceBase_ltng.initWrapper(GETORDERBYORDERID);
                String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).endPointConfig.link__c + orderNumber;
                IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERBYORDERID, '');
                APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID);
                system.debug('get order by order Id: theResponse: ');
                system.debug(theResponse);
                if(theResponse.checkIsValidResponse())
                {
                    if(theResponse.responseData != null)
                    {
                        IADContractBeans_ltng.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans_ltng.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBeanWrapper.class);
                        system.debug('deSerializedResponse');
                        system.debug(deSerializedResponse);
                        orderId = deserializedResponse.Order.orderId;
                        customerId = deserializedResponse.Order.customerId; 
                        if(String.isNotBlank(orderId)){
                            orderFoundViaApi = true;
                            createNewOrder(orderId, customerId);
                        }
                    }
                    else
                    {
                        IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                        serviceMessages = IADServiceBase_ltng.iadMessages;
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(theResponse);
                    serviceMessages = IADServiceBase_ltng.iadMessages;
                }         
            }   
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in IADOrderSearchController_Ltng-->getOrderByOrderId-->');
            IADServiceBase_ltng.populateErrorMessage(theException);
            serviceMessages = IADServiceBase_ltng.iadMessages;
        }
        return orderSearch;        
    }
}