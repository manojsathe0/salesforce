public with sharing class IADHighlightsPanelContactService_ltng extends IADServiceBase_ltng{
        
    public final static String GETCUSTOMERBYCUSTOMERID = 'GetCustomerByCustomerId';
    public final static String GETCUSTOMERTAGBYCUSTOMERID = 'GetCustomerTagByCustomerId';
    public final static String POSTCUSTOMERTAGBYCUSTOMERID = 'PostCustomerTagByCustomerId';
    public final static String DELETECUSTOMERTAGBYCUSTOMERID = 'DeleteCustomerTagByCustomerId';
    public final static String POSTLOGINTOKENBYCUSTOMERID = 'PostloginTokenByCustomerId'; // Padma LAU B-26903
    public final static String CREATETHIRDPARTYUSER =   'CreateThirdPartyUser';//@Anvesh B-33354
    public final static String GETTHIRDPARTYTYPEID =    'GetThirdPartyTypeId';
    public final static String DELETEAUTHCONTACTBYID = 'DeleteAuthContactById';
    //public final static String GETSUBSCRITPIONSERVICESBYCUSTOMERID =  'GetSubscriptionServicesByCustomerid';//padma @B-29724
    
    
    @AuraEnabled public static IADContractBeans_ltng.IADCustomerBean customer{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADCustomerTagBean theCustomerTag{get;set;}
    @AuraEnabled public static Boolean hasBoxAccount{get;set;}
    @AuraEnabled public static String boxId{get;set;} 
    @AuraEnabled public static String oauthToken{get;set;}
    @AuraEnabled public static String userId{get;set;}
    @AuraEnabled public static String appURL{get;set;}
    @AuraEnabled public static String appId{get;set;}
    @AuraEnabled public static String createdUser{get;set;}
    @AuraEnabled public static Boolean hasSecurityQuestion{get;set;}
    @AuraEnabled public static List<String> customerTagList{get;set;}
    @AuraEnabled public static Map<String, String> customerTagMap{get;set;}
    
    @auraEnabled public static string webbaseURL{get; set;} //Padma LAU B-26903
    @AuraEnabled public static string loginURL{get;set;} //Padma LAU B-26903
    @AuraEnabled public static Map<String, String>finalIcontoStatus {get; set;}  //padma @B-29724 
   // @AuraEnabled Public static IADContractBeans_ltng.IADsubscriptionServiceBean thesubscriptionService{get;set;}  //padma @B-29724
   @AuraEnabled Public static IADContractBeans_ltng.lifeplanprovision lifeplanuserid{get;set;}
    
    public IADHighlightsPanelContactService_ltng() {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETCUSTOMERBYCUSTOMERID);
        endpoints.add(GETCUSTOMERTAGBYCUSTOMERID);
        endpoints.add(POSTCUSTOMERTAGBYCUSTOMERID);
        endpoints.add(DELETECUSTOMERTAGBYCUSTOMERID);
        endpoints.add(POSTLOGINTOKENBYCUSTOMERID); // Padma LAU B-26903
        endpoints.add(DELETEAUTHCONTACTBYID);
         endpoints.add(CREATETHIRDPARTYUSER);//Anvesh
        endpoints.add(GETTHIRDPARTYTYPEID);//Anvesh
       // endpoints.add(GETSUBSCRITPIONSERVICESBYCUSTOMERID);//padma @B-29724
        initEndpoints(endpoints);
        hasBoxAccount = false;
        hasSecurityQuestion = false;
        createdUser =UtilityLibrary.generateUpdatedBy_withPrefixlogin();
        populateAppUrlAndAppId();

    }

    public static void populateAppUrlAndAppId()
    {
        Map<String,String> appIdToAppURL = IADHelper.getAppIdToAppURL();
        for(String theKey : appIdToAppURL.keySet())
        {
            appId = theKey;
            appURL = appIdToAppURL.get(theKey);
             Integer index = appURL.indexOf('collaborationcenter');
             webbaseURL =appURL.substring(0, index);
            system.debug('Padma webbaseURL is'+webbaseURL);
        }
    } 
    

    
    public static void getCustomerByCustomerId(String customerId)
    {
        
        System.debug('APItoWrapper is '+IADServiceBase_ltng.APItoWrapper);
        
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETCUSTOMERBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}',customerId);
        
        IADServiceBase_ltng.APItoWrapper.get(GETCUSTOMERBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETCUSTOMERBYCUSTOMERID, '');
        populateCustomer();
    }
   
    public static void populateCustomer()
    {
        try
        {  
            //initHTTPResponse(GETCUSTOMERBYCUSTOMERID);
            
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETCUSTOMERBYCUSTOMERID);
            system.debug('customer response from api: '+response);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans_ltng.IADCustomerBean deSerializedInfo = (IADContractBeans_ltng.IADCustomerBean)JSON.deserialize(response.responseData ,IADContractBeans_ltng.IADCustomerBean.class);
                    response.resultObjects = new List<IADContractBeans_ltng.IADCustomerBean>();
                    response.resultObjects.add(deSerializedInfo);
                    system.debug(' populate customer: obj: ' + deSerializedInfo);
                    if(deSerializedInfo != null && !response.resultObjects.isEmpty())
                    {
                        
                        customer = (IADContractBeans_ltng.IADCustomerBean)response.resultObjects[0];
                        for(IADContractBeans_ltng.IADthirdPartyUserInfoBean theThirdParty : customer.thirdPartyUserInfo)
                        {
                            if(theThirdParty.thirdPartyTypeId == '8')
                            {
                               boxId = theThirdParty.thirdPartyId;
                               userId = theThirdParty.userId;
                               hasBoxAccount = true;
                               oauthToken = response.theToken;  
                            }
                            
                             else
                            {
                            
                            System.debug('theThirdParty.thirdPartyId;'+theThirdParty.thirdPartyId);
                                System.debug('theThirdParty.thirduserIdPartyId;'+theThirdParty.userId);
                               boxId = theThirdParty.thirdPartyId;
                               userId = theThirdParty.userId;
                            
                            }

                        }
                        if(customer.securityQuestion.question != null)
                        {
                            hasSecurityQuestion = true; 
                        }        
           
                        
                    }
                }
                else
                {
                    //iadMessages.add(IADMessageFactory.createMessage('error' , 'Null Response. Response Code : '+response.statusCode)); 
                }
            }
            else
            {
            
               //iadMessages.add(IADMessageFactory.createMessage('error' , 'Invalid Response. Response Code : '+response.statusCode + ' Message Body :  '+response.errorMessage)); 
            }
                    
        }
        catch(Exception theException)
        {
            throw new IADException('Failed displaying  Box Account Info.'+theException.getMessage() , theException);
        } 
    }
    
    public static List<String> getCustomerTagByCustomerId(String customerId)
    {
        customerTagList = new List<String>();
        System.debug('Inside customer tag method: APItoWrapper is '+IADServiceBase_ltng.APItoWrapper);
        
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETCUSTOMERTAGBYCUSTOMERID).endPointConfig.link__c + customerId;   
                
        IADServiceBase_ltng.APItoWrapper.get(GETCUSTOMERTAGBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETCUSTOMERTAGBYCUSTOMERID, '');
        customerTagList = populateCustomerTagList();
        return customerTagList;
    }
    
    public static List<String> populateCustomerTagList()
    {
        try
        {  
            List<String> customerTagList = new List<String>();
            customerTagMap = new Map<String, String>();        
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETCUSTOMERTAGBYCUSTOMERID);
            system.debug('customer response from api: '+response);
            if(response.checkIsValidResponse())
            {
                system.debug('------> response.responseData');
                if(response.responseData != null && response.responseData != '')
                {
                    system.debug('Response data inside get customer tag is not null');
                    IADContractBeans_ltng.IADCustomerTagBean deSerializedInfo = (IADContractBeans_ltng.IADCustomerTagBean)JSON.deserialize(response.responseData ,IADContractBeans_ltng.IADCustomerTagBean.class);
                    response.resultObjects = new List<IADContractBeans_ltng.IADCustomerTagBean>();
                    response.resultObjects.add(deSerializedInfo);
                    system.debug(' populate GETCUSTOMERTAGBYCUSTOMERID: ' + deSerializedInfo);
                    if(deSerializedInfo != null && !response.resultObjects.isEmpty())
                    {
                        theCustomerTag = ( IADContractBeans_ltng.IADCustomerTagBean)response.resultObjects[0];
                        for(IADContractbeans_ltng.IADCustomerTags customerTags : theCustomerTag.customerTags){
                            customerTagList.add(customerTags.tag);
                            customerTagMap.put(customerTags.tag, customerTags.tagType);
                        }          
                        
                    }
                }
                else
                {
                    //iadMessages.add(IADMessageFactory.createMessage('error' , 'Null Response. Response Code : '+response.statusCode)); 
                }
            }
            else
            {
            
               //iadMessages.add(IADMessageFactory.createMessage('error' , 'Invalid Response. Response Code : '+response.statusCode + ' Message Body :  '+response.errorMessage)); 
            }
            return customerTagList;                    
        }
        catch(Exception theException)
        {
            throw new IADException('Failed displaying  Box Account Info.'+theException.getMessage() , theException);
        } 
    }
    
  public static void createCustomerTagByCustomerId(String customerId, String tagName ,string vip)
    {   
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTCUSTOMERTAGBYCUSTOMERID).endPointConfig.link__c + customerId;
        system.debug('inside customre tag : '+calloutURL);
        String jsonString ;
        if(vip=='vip')
        {
            jsonString = '{"tagType":"System","tag":"'+tagName+'"}'; 
        }
        else
        {
            jsonString = '{"tagType":"unset","tag":"'+tagName+'"}';
        }
        
        IADServiceBase_ltng.APItoWrapper.get(POSTCUSTOMERTAGBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTCUSTOMERTAGBYCUSTOMERID, jsonString);
        system.debug('after callout customre tag : ');
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTCUSTOMERTAGBYCUSTOMERID);
        system.debug('create customre tag response from api: '+response);
        
        if(!response.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateErrorMessage(response);
            IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void deleteCustomerTagByCustomerId(String customerId, String tagName)
    {   
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(DELETECUSTOMERTAGBYCUSTOMERID).endPointConfig.link__c + customerId;
        String jsonString = '{"tagType":"unset","tag":"'+tagName+'"}';
        IADServiceBase_ltng.APItoWrapper.get(DELETECUSTOMERTAGBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DELETECUSTOMERTAGBYCUSTOMERID, jsonString);
        
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(DELETECUSTOMERTAGBYCUSTOMERID);
        if(!response.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateErrorMessage(response);
            IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        }
    }
    
    //Padma LAU B-26903
  /* @AuraEnabled
    public static String postLoginTokenByCustomerId(String customerId){
        String loginToken;
        
        System.debug('Padma APItoWrapper is '+IADServiceBase_ltng.APItoWrapper);
       // String createdbyuser = UtilityLibrary.generateUpdatedBy_withPrefix();
       String createdbyuser = UtilityLibrary.generateUpdatedBy();
        //system.debug('Padma base url '+IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID).endPointConfig.link__c);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID).endPointConfig.link__c + customerId;
        
         System.debug(' calloutURL is '+calloutURL);
        String jsonString = '{"createdBy": "'+createdbyuser+'"}';
        System.debug('padma jsonString '+ jsonString);
        IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTLOGINTOKENBYCUSTOMERID, jsonString);
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID);
        system.debug('postlogin  response from api: '+response); 
        system.debug('postlogin  response from api: '+response.responseData);
               if(response.responseData != null)
               {
                    map< string, string > values = (map< string, string >)json.deserialize(response.responseData,map< string, string >.class);
                    loginToken= values.get('loginToken');
                   system.debug('values----->'+values);
                   system.debug('loginToken----->'+loginToken);
                    //loginToken=response.responseData;
                    //Map<String, Object> loginTokenMap = JSON.deserializeUntyped(response.responseData);
                    //system.debug('map------>'+loginTokenMap);
                    //loginToken = String.valueOf(loginTokenMap.get('loginToken'));
                }
           
        SYSTEM.DEBUG('PADMA loginToken is '+loginToken);
        if(loginToken != null ){
            loginURL=webbaseURL+'LZWeb/Welcome/SignInProxy.aspx?isLogOut=1&utProxyRequest='+loginToken+'&fkUser='+customerId+'&ccrName=Legalzoom\\'+createdbyuser;
        }
        SYSTEM.DEBUG('PADMA loginURL is '+loginURL);  
        
        return loginURL;
    } */
    @AuraEnabled
    public static String postLoginTokenByCustomerId(String customerId){
        String loginToken;
        
        System.debug('Padma APItoWrapper is '+IADServiceBase_ltng.APItoWrapper);
       // String createdbyuser = UtilityLibrary.generateUpdatedBy_withPrefix();
       String createdbyuser = UtilityLibrary.generateUpdatedBy_withPrefixlogin();
        //system.debug('Padma base url '+IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID).endPointConfig.link__c);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID).endPointConfig.link__c + customerId;
        
         System.debug(' calloutURL is '+calloutURL);
        String jsonString = '{"createdBy": "'+createdbyuser+'"}';
        System.debug('padma jsonString '+ jsonString);
        IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTLOGINTOKENBYCUSTOMERID, jsonString);
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTLOGINTOKENBYCUSTOMERID);
        
        if(!response.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateErrorMessage(response);
            IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        }
        else{
            system.debug('postlogin  response from api: '+response); 
            system.debug('postlogin  response from api: '+response.responseData);
                   if(response.responseData != null)
                   {
                        map< string, string > values = (map< string, string >)json.deserialize(response.responseData,map< string, string >.class);
                        loginToken= values.get('loginToken');
                       system.debug('values----->'+values);
                       system.debug('loginToken----->'+loginToken);
                        //loginToken=response.responseData;
                        //Map<String, Object> loginTokenMap = JSON.deserializeUntyped(response.responseData);
                        //system.debug('map------>'+loginTokenMap);
                        //loginToken = String.valueOf(loginTokenMap.get('loginToken'));
                    }
               
            SYSTEM.DEBUG('PADMA loginToken is '+loginToken);
            if(loginToken != null ){
                loginURL=webbaseURL+'LZWeb/Welcome/SignInProxy.aspx?isLogOut=1&utProxyRequest='+loginToken+'&fkUser='+customerId+'&ccrName='+createdbyuser;
            }
            SYSTEM.DEBUG('PADMA loginURL is '+loginURL);  
        }
        return loginURL;
    } 
    @AuraEnabled
    public static void deleteAuthContactById(String customerId, String contactId) {
        System.debug('Inside deleteAuthContactById.');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(DELETEAUTHCONTACTBYID).endPointConfig.link__c; 
        calloutURL = calloutURL.replace('{customerId}', customerId);
        calloutURL = calloutURL.replace('{contactId}', contactId);
        IADServiceBase_ltng.APItoWrapper.get(DELETEAUTHCONTACTBYID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DELETEAUTHCONTACTBYID, '');
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(DELETEAUTHCONTACTBYID);
        System.debug('response Inside deleteAuthContactById: ' + response);
        if(!response.checkIsValidResponse()) {
            IADServiceBase_ltng.populateErrorMessage(response);
            IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        }
        //customerTagList = populateCustomerTagList();
    }
    
    //Padma @B-29724
   /* public static Map<String,String>  getSubscriptionservicesyByCustomerId(String custId)         
        
    {
      finalIcontoStatus = new Map<String, String>();
      List<IAD_Subscription_Service_type__mdt>IADSubSeriveTypes = [Select  Label,Service_Type__c from IAD_Subscription_Service_type__mdt];         
      List<Subscription_Status__mdt>IADSubStatus = [Select Label, Status__c from    Subscription_Status__mdt];
      Map<String,  List<String>> mapodicontoservicetype = new Map<String,  List<String>>();
      Map<String, String>serviceTypetoiconName = new Map<String, String>();
      Map<String, String>mapofStatustoString = new  Map<String, String>();
      //populating the icon to servicetype map
      //
      for ( IAD_Subscription_Service_type__mdt st: IADSubSeriveTypes)
      {
          serviceTypetoiconName.put(st.Label, st.Service_Type__c);
          if(mapodicontoservicetype.containsKey(st.Service_Type__c))
          {
              mapodicontoservicetype.get(st.Service_Type__c).add(st.Label);
          }
          else
          {
              mapodicontoservicetype.put(st.Service_Type__c, new List<String>{st.Label});
          }
         
      }
      //creating map of status code to string
      for (Subscription_Status__mdt ss:IADSubStatus )
      {
          mapofStatustoString.put(ss.Label, ss.Status__c);
      }
        system.debug('Mapofstatus'+mapofStatustoString);
      Map<String, String> mapoftypetostatusfromresponse = new Map<String, String>();
      Set<String>activeicons = new set<String>();
      Set<String>paymentdueIcons = new set<String>();
      
        String customerId = custId;
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRITPIONSERVICESBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}', custId );
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSUBSCRITPIONSERVICESBYCUSTOMERID , '');
        try{
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRITPIONSERVICESBYCUSTOMERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADContractBeans_ltng.IADsubscriptionServiceBean deSerializedResponse  =(IADContractBeans_ltng.IADsubscriptionServiceBean) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADsubscriptionServiceBean.class);
                    theResponse.resultObjects=new List<IADContractBeans_ltng.IADsubscriptionServiceBean>();
                    theResponse.resultObjects.add(deSerializedResponse);
                    system.debug('deSerializedResponse: '+deSerializedResponse);
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        thesubscriptionService= (IADContractBeans_ltng.IADsubscriptionServiceBean) IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRITPIONSERVICESBYCUSTOMERID).resultObjects[0];
                        for(IADContractBeans_ltng.IADSubscriptionServices subservices :thesubscriptionService.subscriptionServices )
                        {
                            system.debug('loop1');
                            if(serviceTypetoiconName.containsKey(String.valueof(subservices.serviceType)))
                            {
                                System.debug('loop2');
                                if(mapofStatustoString.containsKey(String.valueof(subservices.subscriptionStatus)))
                                {
                                    System.debug('loop3');
                                    System.debug('Substatus ' +mapofStatustoString.get(String.valueof(subservices.subscriptionStatus)));
                                    if(mapofStatustoString.get(String.valueof(subservices.subscriptionStatus)) =='Active')
                                    {
                                        System.debug('loop4');
                                        activeicons.add(serviceTypetoiconName.get(String.valueof(subservices.serviceType)));
                                        finalIcontoStatus.put(serviceTypetoiconName.get(String.valueof(subservices.serviceType)),'Active');
                                    }
                                    else if(mapofStatustoString.get(String.valueof(subservices.subscriptionStatus)) =='Paymment Due' || mapofStatustoString.get(String.valueof(subservices.subscriptionStatus)) =='Expired')
                                    {
                                        System.debug('loop5');
                                        paymentdueIcons.add(serviceTypetoiconName.get(String.valueof(subservices.serviceType)));
                                        finalIcontoStatus.put(serviceTypetoiconName.get(String.valueof(subservices.serviceType)),'Payment Due');
                                    }
                                    
                                }
                                
                            }
                        }
                        
                        System.debug('activeicons' +activeicons );
                        System.debug('paymentdueIcons'+paymentdueIcons);
                    }
                    
                }
            }
            for(string str:paymentdueIcons)
            {
                if(activeicons.contains(str))
                {
                    paymentdueIcons.remove(str);
                }
            }
            
        }
        catch(Exception theException)
        {
            throw new IADException('Failed displaying Subscriptions.'+theException.getMessage() , theException);
        }
        System.debug('finalIcontoStatus' +finalIcontoStatus);
       return finalIcontoStatus; 
    }
    */
     public static void createProvisionAccount(String payload){//@anvesh B-33354
       String createdbyuser = UtilityLibrary.generateUpdatedBy_withPrefixlogin();
        system.debug('payload'+payload);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(CREATETHIRDPARTYUSER).endPointConfig.link__c;        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, CREATETHIRDPARTYUSER, payload);
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(CREATETHIRDPARTYUSER);
        
        if(!response.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateErrorMessage(response);
            IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        } else
        {
           IADServiceBase_ltng.populateSuccessMessage(' Provision Account Created Successfully '); 
             IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        }
         //return null;
     }
      public static void getThirdPartyTypeId(String payload){
       String createdbyuser = UtilityLibrary.generateUpdatedBy_withPrefixlogin();
        
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETTHIRDPARTYTYPEID).endPointConfig.link__c;        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETTHIRDPARTYTYPEID, payload);
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETTHIRDPARTYTYPEID);
          lifeplanuserid = (IADContractBeans_ltng.lifeplanprovision) JSON.deserialize(response.responseData, IADContractBeans_ltng.lifeplanprovision.class);
        System.debug('12345'+response);
        if(!response.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateErrorMessage(response);
            IADHighlightsPanelContactController_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        }
         //return null;
     }

     
}