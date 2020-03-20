public class OrderExceptionService {
    
    public static  boolean inbinrquested = false;
    @future (callout=true)
    public static  void inbindate(Set<id> orderexceptionids ,boolean calculate)
    {   
       try{
        List<Order_Exception__c> orderexceptionrecord = [select id ,Processing_Number__c from  Order_Exception__c where id IN:orderexceptionids]  ;
        InBinDateService_ltng inbindateservice = new InBinDateService_ltng();
        InBinDateService_ltng.getInbinDate(orderexceptionrecord[0].Processing_Number__c,calculate);
         APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(InBinDateService_ltng.GetInBinDateByProcessingNumber);
         InbinDatewrapper deserializeddata = (InbinDatewrapper)JSON.deserialize(response.responseData, InbinDatewrapper.class);
         orderexceptionrecord[0].Expedite__c=Boolean.valueof( deserializeddata.expedite);
        string strTest=deserializeddata.inbindate;

         String[] arrTest = strTest.split(':');
         string[] s=arrtest[2].split('\\s+');
         string newdate = arrTest[0]+':'+arrtest[1]+' '+s[1];
         orderexceptionrecord[0].Due_Date__c=DateTime.parse(newdate);
           orderexceptionrecord[0].Trigger_Order_due_date__c =false;//Padma B-28019       
         update orderexceptionrecord[0];
        inbinrquested=true;
         }	
         
         catch (Exception e)
         {
         
         
         }
         
       
    }
     public static  void inbindatenonfuture(Set<id> orderexceptionids ,boolean calculate)
    {   
       
       try{
        List<Order_Exception__c> orderexceptionrecord = [select id ,Processing_Number__c from  Order_Exception__c where id IN:orderexceptionids]  ;
        InBinDateService_ltng inbindateservice = new InBinDateService_ltng();
        InBinDateService_ltng.getInbinDate(orderexceptionrecord[0].Processing_Number__c,calculate);
         APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(InBinDateService_ltng.GetInBinDateByProcessingNumber);
         InbinDatewrapper deserializeddata = (InbinDatewrapper)JSON.deserialize(response.responseData, InbinDatewrapper.class);
         orderexceptionrecord[0].Expedite__c=Boolean.valueof( deserializeddata.expedite);
        string strTest=deserializeddata.inbindate;

         String[] arrTest = strTest.split(':');
         string[] s=arrtest[2].split('\\s+');
         string newdate = arrTest[0]+':'+arrtest[1]+' '+s[1];
         orderexceptionrecord[0].Due_Date__c=DateTime.parse(newdate);
           orderexceptionrecord[0].Trigger_Order_due_date__c =false;//Padma B-28019       
         update orderexceptionrecord[0];
         inbinrquested = true;
         }	
         
         catch (Exception e)
         {
         
         
         }
         
       
    }
    /* 
     * The following code added by Artyom M.
     * Per story:  B-25958
     */
    public static void checkIfInbinDateModified(Map<Id, Order_Exception__c> oldExceptions, Map<Id, Order_Exception__c> newExceptions) {
        Set<Id> orderIds = new Set<Id>();
        for (Order_Exception__c newExc : newExceptions.values()) {
            orderIds.add(newExc.Order_Number__c);
        }
        Map<ID, Order__c> orderIdToOrderMap = new Map<ID, Order__c>([SELECT Id, User_Order_ID__c, Name FROM Order__c WHERE Id In: orderIds LIMIT 1000]);
        
        if (orderIdToOrderMap != null && !orderIdToOrderMap.isEmpty()) {
            for (Order_Exception__c newExc : newExceptions.values()) {
                Order_Exception__c oldExc = oldExceptions.get(newExc.Id);
                
                if (newExc.Due_Date__c != oldExc.Due_Date__c || newExc.Expedite__c != oldExc.Expedite__c) {
                    InBinDateService_ltng.updateInbinDate(orderIdToOrderMap.get(newExc.Order_Number__c).User_Order_ID__c, newExc.Due_Date__c, newExc.Expedite__c);
                    System.debug('Date changed on : ' + orderIdToOrderMap.get(newExc.Order_Number__c).User_Order_ID__c + ': ' + newExc.Due_Date__c);
                }
                else {
                    System.debug('Date did not change');
                } 
                
            }
        }
        
    }
    
    public static void checkIfProcessingStatusChanged(List<Order_Exception__c> newOrderExceptions, Map<Id, Order_Exception__c> oldOrderExceptionsMap) {
        System.debug('Inside checkIfProcessingStatusChanged');
        for (Order_Exception__c newOrderException : newOrderExceptions) {
            if (newOrderException.Status__c != oldOrderExceptionsMap.get(newOrderException.Id).Status__c) {
                System.debug('Processing status changed from ' + oldOrderExceptionsMap.get(newOrderException.Id).Status__c + ' to ' + newOrderException.Status__c);
                if (newOrderException.Status__c != null && newOrderException.Status__c.equals('Started')) {
                    System.debug('Calling updateProcessingstatus with: ' + newOrderException.Processing_Number__c + ' and ' + newOrderException.Status__c);
            		InBinDateService_ltng.updateProcessingstatus(newOrderException.Processing_Number__c, newOrderException.Status__c);
                }
            }
            
        }
    }
    public static void updateProcessingStatus(List<Order_Exception__c> newOrderExceptions) {
        InBinDateService_ltng inbindateservice = new InBinDateService_ltng();
        for (Order_Exception__c orderException : newOrderExceptions) {
            System.debug('Calling updateProcessingstatus with: ' + orderException.Processing_Number__c + ' and ' + orderException.Status__c);
            InBinDateService_ltng.updateProcessingstatus(orderException.Processing_Number__c, orderException.Status__c);
        }
    }

   public static  void UpdateProcessingStatus(Set<id> orderexceptionids)
    
    {
    
     List<Order_Exception__c> orderexceptionrecord = [select id ,Processing_Number__c,Status__c from  Order_Exception__c where id IN:orderexceptionids]  ;
        InBinDateService_ltng inbindateservice = new InBinDateService_ltng();
        for(Order_Exception__c orderexception :orderexceptionrecord)
        {
            if(orderexception.Status__c == 'Production Review'){
                InBinDateService_ltng.updateProcessingstatus(orderexception.Processing_Number__c,'Started');
            }
            else{
                InBinDateService_ltng.updateProcessingstatus(orderexception.Processing_Number__c,orderexception.Status__c);
            }
          //InBinDateService_ltng.updateProcessingstatus(orderexception.Processing_Number__c,orderexception.Status__c);
        }
    
    
    }

public class InbinDatewrapper {

    public String expedite;
    public String orderNumber;
    public String refresh;
    public String message;
    public String timestamp;
    public String inbindate;
    public String status;

    
   
}

}