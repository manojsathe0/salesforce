public class InBinDateService_ltng extends IADServiceBase_ltng {
    public final static String UPDATEINBINDATE = 'UpdateInBinDateByProcessingNumber';
     public final static String GetInBinDateByProcessingNumber  = 'GetInBinDateByProcessingNumber';
    public final static String  PutProcessingStatus ='PutProcessingStatus';
    // inistantiate the class
    public  InBinDateService_ltng ()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GetInBinDateByProcessingNumber);
        endpoints.add(PutProcessingStatus);
        endpoints.add(UPDATEINBINDATE);
        initEndpoints(endpoints);
    }
    
    
    // method to actually call the apigee webservice and get the result.
    public static void   getInbinDate(String ProcessingNumber,boolean checkrecalculate )
    {    IADServiceBase_ltng.initWrapper(GetInBinDateByProcessingNumber);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GetInBinDateByProcessingNumber).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{processnumber}',ProcessingNumber);
     
    if(checkrecalculate)
    {
    
    calloutURL=calloutURL+'&reCalculate=true';
    }
   
     
      system.debug('the url is '+calloutURL);
      IADServiceBase_ltng.makeRequestMulti(calloutURL, GetInBinDateByProcessingNumber,'');
        
      
    }
    
    /* 
     * The following code added by Artyom M.
     * Per story:  B-25958
     */
    /*
    public static void updateInbinDate(String orderNumber, DateTime newDate, Boolean isExpedite) {
        POR_DDSContractBeans.InBinDateUpdateBean inBinUpdate = new POR_DDSContractBeans.InBinDateUpdateBean();
        inBinUpdate.orderNumber = orderNumber;
        inBinUpdate.inBinDate = String.valueOf(newDate);
        inBinUpdate.expedite = isExpedite;
        
        String inBinUpdateInJSON = JSON.serialize(inBinUpdate);
        System.debug('inBinUpdateInJSON = ' + inBinUpdateInJSON);
        //String test = '{  "orderNumber":"507716113",  "inBinDate":"04-03-28 15:54:51"}';
        APIGeeNonBearerConnector.makeLZKeyPostCall('Update_InBinDate', inBinUpdateInJSON);
        
    }
*/
    @future(callout=true)
    public static void updateInbinDate(String orderNumber, DateTime newDate, Boolean isExpedite) {
        POR_DDSContractBeans.InBinDateUpdateBean inBinUpdate = new POR_DDSContractBeans.InBinDateUpdateBean();
        inBinUpdate.orderNumber = orderNumber;
        inBinUpdate.inBinDate = String.valueOf(newDate);
        inBinUpdate.expedite = isExpedite;
        
        String inBinUpdateInJSON = JSON.serialize(inBinUpdate);
        System.debug('inBinUpdateInJSON = ' + inBinUpdateInJSON);
        InBinDateService_ltng srvc = new InBinDateService_ltng();
        IADServiceBase_ltng.initWrapper(UPDATEINBINDATE);
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(UPDATEINBINDATE).endPointConfig.link__c);
        system.debug('calloutURL ' + calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, UPDATEINBINDATE , inBinUpdateInJSON);
           

        
    }
    @future(callout=true)
      public static void updateProcessingstatus(String orderNumber ,string processingstatus)
   {
   
     POR_DDSContractBeans.UpdateProcessingBean processingUpdate = new  POR_DDSContractBeans.UpdateProcessingBean();
     InBinDateService_ltng inbindateservice = new InBinDateService_ltng();
      processingUpdate.orderNumber=orderNumber;
      processingUpdate.processingStatus=processingstatus;
      String payloadprocessing =JSON.serialize(processingUpdate);
      IADServiceBase_ltng.initWrapper(PutProcessingStatus);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(PutProcessingStatus).endPointConfig.link__c;
         system.debug('calloutURL ' + calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PutProcessingStatus , payloadprocessing);
     //APIGeeNonBearerConnector.makeLZKeyPostCall('Update_Processing',  payloadprocessing);
   
   }

  
}