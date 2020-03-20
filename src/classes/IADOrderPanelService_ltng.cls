public class IADOrderPanelService_ltng extends IADServiceBase_ltng
{
  @AuraEnabled   public  static Boolean hasIncompleteOrders{get;set;}
    @AuraEnabled  public  static APIRequestResponseWrapper_ltng incompleteOrderResponse{get;set;}
    public final static String GETORDERSBYCUSTOMERID = 'GetOrdersByCustomerId';
   @AuraEnabled  public  static Set<IADContractBeans_ltng.IADOrderBean> theOrders{get;set;}
    //public final static String GETORDERNUMBERFROMORDERID = 'GetOrderNumberFromOrderItemId';
     public final static String GETINCOMPLETEORDERSBYCUSTOMERID = 'GetIncompleteOrdersByCustomerID';
    //public IADContractBeans.IncompleteOrdersBean incompleteOrdersService{get;set;}
  @AuraEnabled   public  static incompletedWrapperList incompleteOrdersService{get;set;}
    public IADOrderPanelService_ltng()
    {
        super();
        hasIncompleteOrders = false;
        incompleteOrdersService = new incompletedWrapperList();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETORDERSBYCUSTOMERID);
        endpoints.add(GETINCOMPLETEORDERSBYCUSTOMERID);
        initEndpoints(endpoints);
    }
    public static void getOrdersByCustomerId(String custId)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERSBYCUSTOMERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{customerId}',custId);
        IADServiceBase_ltng.APItoWrapper.get(GETORDERSBYCUSTOMERID).setInfo(APIRequestResponseWrapper.CUSTOMER, custId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERSBYCUSTOMERID, '');
  
    }
    public static  void populateOrders()
    {
        
        try
        {
            //initHTTPResponse(GETORDERSBYCUSTOMERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETORDERSBYCUSTOMERID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans_ltng.IADOrdersBean deserializedResponse = (IADContractBeans_ltng.IADOrdersBean) JSON.deserialize(response.responseData , IADContractBeans_ltng.IADOrdersBean.class);
                    if(deserializedResponse != null)
                    {
                        
                        system.debug('deserializedResponse ' + deserializedResponse);
                        
                        theOrders = new Set<IADContractBeans_ltng.IADOrderBean>();
                        
                        for(IADContractBeans_ltng.IADOrderGroup theGroup : deserializedResponse.orderGroups)
                        {
                            theOrders.addAll(theGroup.orders);
                            for(IADContractbeans_ltng.IADOrderBean theOrder : theOrders)
                            {
                                for(IADContractbeans_ltng.IADOrderItem theOrderItemWrapper : theOrder.orderItems)
                                {
                                    if((theOrderItemWrapper.productConfiguration.productTypeId == '2' || theOrderItemWrapper.productConfiguration.productTypeId == '12'
                                        || theOrderItemWrapper.productConfiguration.productTypeId == '13' || theOrderItemWrapper.productConfiguration.productTypeId == '10'
                                        || theOrderItemWrapper.productConfiguration.productTypeId == '9'))
                                    {
                                        if(theOrder.productName == null)
                                            theOrder.productName = theOrderItemWrapper.productConfiguration.productComponent.displayNameOnBill;
                                    }
                                }
                                theOrder.dateCreatedDatetime = UtilityLibrary.parseIADDatetime(theOrder.dateCreated);
                                theOrder.paymentStatusName = IADPaymentTransaction.orderStatusMap.get(Integer.valueOf(theOrder.paymentStatus));
                                system.debug('paymentStatusName ' + theOrder.paymentStatusName);
                            }
                        }
                        
                        response.resultObjects = new List<Object>{deserializedResponse};
                            }
                    
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(response);
                }
                
            }
            else
            {
               IADServiceBase_ltng.populateErrorMessage(response);
            }
            
            
        }
        catch(Exception theException)
        {
            throw new IADException('Failed Displaying Orders '+theException.getMessage() , theException);
        }
    }
    
    public  static void  getIncompleteOrders(String theCustId) 
    {
        
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETINCOMPLETEORDERSBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}',theCustId);
        //APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETINCOMPLETEORDERSBYCUSTOMERID , '');
        
        
            populateIncompleteOrders();
        
        
        
    }
    
    public  static void populateIncompleteOrders()
    {
        try
        {    
            //initHTTPResponse(GETINCOMPLETEORDERSBYCUSTOMERID); //sets the responseData and statusCode on the wrapper
            
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETINCOMPLETEORDERSBYCUSTOMERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    system.debug('the response val check '+theResponse.responseData);
                    incompletedWrapperList deSerializedOrders = (incompletedWrapperList) JSON.deserialize(theResponse.responseData , incompletedWrapperList.class);
                    
                     system.debug('the response val de '+deSerializedOrders);
                    theResponse.resultObjects = new List<Object>{deSerializedOrders};
                    system.debug('the response val '+theResponse.resultObjects);
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        hasIncompleteOrders = true;
                        incompleteOrdersService = (incompletedWrapperList)IADServiceBase_ltng.APItoWrapper.get(GETINCOMPLETEORDERSBYCUSTOMERID).resultObjects[0];
                        system.debug('-------->'+incompleteOrdersService);
                    }
                    else
                        hasIncompleteOrders = false;
                }
                else
                {
                    IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , 'Invalid Response. Response Code : '+theResponse.statusCode + ' Message Body :  '+theResponse.errorMessage));             }
            }
            else
            {
                IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , 'Null Response. Response Code : '+theResponse.statusCode));             
            }
        }
        
        catch(Exception theException)
        {
            throw new IADException('Failed Displaying Incomplete Orders '+theException.getMessage() , theException);
        }  
    }
    
    public class incompletedWrapperList{
       @AuraEnabled  public List<incompleteWrapper> processingOrders{get;set;}
        public incompletedWrapperList(){
            processingOrders = new List<incompleteWrapper>();
        }
    }
    
    public class incompleteWrapper{
       @AuraEnabled  public string processingOrderId{get;set;}
      @AuraEnabled  public string customerId{get;set;}
      @AuraEnabled  public string processId{get;set;}
       @AuraEnabled  public string questionnaireId{get;set;}
      @AuraEnabled   public string lastPageVisited{get;set;}
      @AuraEnabled  public string startDate{get;set;}
      @AuraEnabled   public string completedDate{get;set;}
      @AuraEnabled   public string firstCompletedDate{get;set;}
      @AuraEnabled  public string lastCompletedDate{get;set;}
     @AuraEnabled    public string stateId{get;set;}
       @AuraEnabled  public string lastAccessedDate{get;set;}
       @AuraEnabled  public string reOpenedDate{get;set;}
       @AuraEnabled  public boolean isQuestionnaireCompleted{get;set;}
      @AuraEnabled   public boolean isRevision{get;set;}
       @AuraEnabled  public string processingStatusId{get;set;}
       @AuraEnabled  public string productName{get;set;}
    }
    
}