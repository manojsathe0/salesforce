public class IADContactManagerService_ltng extends IADServiceBase_ltng{

    @AuraEnabled  public static Boolean editLoginEmialContext {get;set;}

   @AuraEnabled  public static Boolean resetPasswordSuccess{get;set;}
   @AuraEnabled  public static Boolean contactUpdateSuccess{get;set;}
   public static contact con ;
   public static string custid;
   
   public static boolean lifeplan ;

    public final static String RESETPASSWORD = 'PostResetPassword';
    public final static String CONTACTUPDATE = 'PutContactInfoByCustomerAndContactId';
    public final static String CONTACTINSERT = 'PostContactByCustomerId';
    public final static String UPDATECONTACTINFOITP = 'UpdateContactITP';
   
    public  IADContactManagerService_ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(RESETPASSWORD);
        endpoints.add(CONTACTUPDATE);
        endpoints.add(CONTACTINSERT);
        endpoints.add(UPDATECONTACTINFOITP);
        initEndpoints(endpoints);
        
        resetPasswordSuccess = false;
        contactUpdateSuccess= false;
        editLoginEmialContext = false;
    }
    public static void putContactUpdate(Contact c, string lzcId, string custId) 
    {
        system.debug('padma entered updatecontact');
        system.debug('padma contact c is '+c);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE).endPointConfig.link__c;
       system.debug('calloutURL is '+calloutURL);
       // calloutURL = calloutURL.replace('{CUSTOMERID}', c.FKUser__c);
       // calloutURL = calloutURL.replace('{CONTACTID}', c.LegalZoom_Contact_ID__c);
        
        calloutURL = calloutURL.replace('{CUSTOMERID}', custId);
        calloutURL = calloutURL.replace('{CONTACTID}', lzcId);
IADContactManagerService_ltng.con=c;
IADContactManagerService_ltng.custid=custid;
       String jsonString = createContactBody(c);
       String jsonString1= JSON.serialize(c);

        system.debug('json string ' + jsonString);
        system.debug('json string1 ' + jsonString1  );
        IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE).setInfo(APIRequestResponseWrapper.CUSTOMER, custId);
        IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE).setInfo(APIRequestResponseWrapper.CONTACT, lzcId);
       //IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE).setInfo(APIRequestResponseWrapper.CUSTOMER, c.FKUser__c);
       //IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE).setInfo(APIRequestResponseWrapper.CONTACT, c.LegalZoom_Contact_ID__c);
    
        //Object continuationObject = makeRequest(calloutURL, CONTACTUPDATE, jsonString);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, CONTACTUPDATE, jsonString);
        
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE);

        system.debug('response.isAsync ' + response);

        //if(!response.isAsync)
            readContactUpdateResponse();

        //return continuationObject;

       
    }
    
       
    public static void readContactUpdateResponse()
    {
        
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(CONTACTUPDATE);
            system.debug('in readContactUpdateResponse ' + response.responseData + ' status code ' + response.statusCode);
            if(response.statusCode == '200')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans_ltng.IADContactUpdateBean deSerializedResponse = (IADContractBeans_ltng.IADContactUpdateBean) JSON.deserialize(response.responseData   ,IADContractBeans_ltng.IADContactUpdateBean.class);
                response.resultObjects = new List<IADContractBeans_ltng.IADContactUpdateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                IADContactManagerController_ltng.updateItp(IADContactManagerService_ltng.custid,IADContactManagerService_ltng.con.HomePhone);
                IADServiceBase_ltng.populateSuccessMessage('Contact successfully updated. Please wait a few minutes for updates to sync with Salesforce.');
               // IADContactManagerController_ltng.updateItp(IADContactManagerService_ltng.custid,IADContactManagerService_ltng.con.HomePhone);
                
            }
            else if(response.statusCode=='400')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans_ltng.IADContactCreateBean deSerializedResponse = (IADContractBeans_ltng.IADContactCreateBean) JSON.deserialize(response.responseData   ,IADContractBeans_ltng.IADContactCreateBean.class);
                response.resultObjects = new List<IADContractBeans_ltng.IADContactCreateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                if(deSerializedResponse.status!=null)
                {
                IADServiceBase_ltng.populateErrorMessage('Contact Create Unsuccessful. ' + deSerializedResponse.status.message);
                }
                else
                {
                IADServiceBase_ltng.populateErrorMessage('Contact Create Unsuccessful. ' );    
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(response);
            }
         }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
    }
    
    @AuraEnabled
    public static void postContactInsert(Contact c) 
    {
        system.debug('inside postContactInsert');  
        try
        {
            String calloutURL =IADServiceBase_ltng.APItoWrapper.get(CONTACTINSERT).endPointConfig.link__c;
            calloutURL = calloutURL.replace('{CUSTOMERID}', c.FKUser__c);
            system.debug('calloutURL is'+calloutURL);
            String jsonString = createContactBody(c);
            
            system.debug('json string ' + jsonString);
            
             IADServiceBase_ltng.APItoWrapper.get(CONTACTINSERT).setInfo(APIRequestResponseWrapper.CUSTOMER, c.FKUser__c);

            //IADServiceBase_ltng.APItoWrapper.get(CONTACTINSERT).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, c.FKUser__c);
            
            //Object continuationObject = makeRequest(calloutURL, CONTACTINSERT, jsonString);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, CONTACTINSERT, jsonString);
                
            APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(CONTACTINSERT);
            
            //if(!response.isAsync)
                readContactInsertResponse();
            
            //return continuationObject;
        }
        catch(Exception theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException);
            //return null;
        }
       
    }
    @AuraEnabled
    public static void readContactInsertResponse()
    {
       
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(CONTACTINSERT);
            system.debug('in readContactInsertResponse ' + response.responseData + ' status code ' + response.statusCode);
            if(response.statusCode == '201')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans_ltng.IADContactCreateBean deSerializedResponse = (IADContractBeans_ltng.IADContactCreateBean) JSON.deserialize(response.responseData   ,IADContractBeans_ltng.IADContactCreateBean.class);
                response.resultObjects = new List<IADContractBeans_ltng.IADContactCreateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                
               IADServiceBase_ltng.populateSuccessMessage(deSerializedResponse.status.message);
            }
            else if(response.statusCode=='400')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans_ltng.IADContactCreateBean deSerializedResponse = (IADContractBeans_ltng.IADContactCreateBean) JSON.deserialize(response.responseData   ,IADContractBeans_ltng.IADContactCreateBean.class);
                response.resultObjects = new List<IADContractBeans_ltng.IADContactCreateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                if(deSerializedResponse.status!=null)
                {
                IADServiceBase_ltng.populateErrorMessage('Contact Create Unsuccessful. ' + deSerializedResponse.status.message);
                }
                else
                {
                IADServiceBase_ltng.populateErrorMessage('Contact Create Unsuccessful. ' );    
                }
               // populateErrorMessage('Contact Create Unsuccessful. ' + deSerializedResponse.status.message);
            }
            else
            {
                 IADServiceBase_ltng.populateErrorMessage(response);
                //populateErrorMessage(response);
            }
            
        }
        catch(Exception theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException);
        }
    }
    public static String createContactBody(Contact c)
    {
        IADContractBeans_ltng.IADContactUpdateBean contactUpdateBean= new IADContractBeans_ltng.IADContactUpdateBean();
        IADContractBeans_ltng.IADContactUpdate theContactbean = new IADContractBeans_ltng.IADContactUpdate();
        theContactbean.description = 'Created from Salesforce';
        theContactbean.firstName = c.firstName;
        theContactbean.lastName = c.lastName;
        theContactbean.addressLine1 = c.MailingStreet;
        if(c.Address_2__c != null)
            theContactbean.addressLine2 = c.Address_2__c;
        else
            theContactbean.addressLine2 = '';
        theContactbean.city = c.MailingCity;
        theContactbean.stateId = c.MailingState;
        theContactbean.zipcode = c.MailingPostalCode;
        theContactbean.email1 = c.Email;
        theContactbean.homePhone = c.HomePhone;
        if(c.OtherPhone != null)
            theContactbean.workPhone = c.OtherPhone;
        else
            theContactbean.workPhone = '';
        theContactbean.cellPhone = c.MobilePhone;
        theContactbean.active = UtilityLibrary.convertToIADContactActive(c.Inactive__c);
        theContactbean.statusChanged = UtilityLibrary.convertToIADDate(Datetime.now());
        //theContactbean.statusChanged = UtilityLibrary.convertToIADDate(c.LastModifiedDate);
        theContactbean.contactInfoType = UtilityLibrary.convertToIADContactType(c.Contact_Type__c);
        theContactbean.country = '0';
        

        system.debug('MailingState ' + c.MailingState);
        
        contactUpdateBean.contact = theContactbean;
        
        system.debug('contactUpdateBean ' + contactUpdateBean);
        
        return JSON.serialize(contactUpdateBean);
    }
     @AuraEnabled
    public static void postResetPassword(String custID) 
    {
        system.debug('ented postreset');
        system.debug('padma custId is'+custID);
        try
        {
            String calloutURL =IADServiceBase_ltng.APItoWrapper.get(RESETPASSWORD).endPointConfig.link__c;
                
            String jsonString = createResetPasswordRequestBody(custID);
            system.debug('Padma jsonString is '+jsonString);

            IADServiceBase_ltng.APItoWrapper.get(RESETPASSWORD).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, custID);
            
            //Object continuationObject = makeRequest(calloutURL, RESETPASSWORD, jsonString);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, RESETPASSWORD, jsonString);
            
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(RESETPASSWORD);
           // if(!response.isAsync)
                readResetPasswordResponse();
            
            //return continuationObject;
        }
        catch(Exception theException)
        {
             IADServiceBase_ltng.populateErrorMessage(theException);
            
        }
        
       
    }
     @AuraEnabled
    public static void readResetPasswordResponse()
    {
        System.debug('What abt me?');
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(RESETPASSWORD);
            system.debug(response.theResponse);
            if(response.statusCode == '400')
            {
            IADServiceBase_ltng.populateErrorMessage('The Email Does not Exist '); 
            }
            
          else if(response.checkIsValidResponse())
            {
                if(response != null && response.statusCode == '200')
                {
                    IADContractBeans_ltng.IADRequestPasswordBean deSerializedResponse = (IADContractBeans_ltng.IADRequestPasswordBean) JSON.deserialize(response.responseData   ,IADContractBeans_ltng.IADRequestPasswordBean.class);
                    response.resultObjects = new List<IADContractBeans_ltng.IADRequestPasswordBean>();
                    response.resultObjects.add(deSerializedResponse);
                    system.debug(response);
                    IADServiceBase_ltng.populateSuccessMessage('Password successfully reset.');
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
            IADServiceBase_ltng.populateErrorMessage(theException);
         }
    }  
    public static String createResetPasswordRequestBody(String theEmail)
    {
        IADContractBeans_ltng.IADRequestPasswordRequestBean resetPasswordBean= new IADContractBeans_ltng.IADRequestPasswordRequestBean();
        IADContractBeans_ltng.requestpassword theEmailbean = new IADContractBeans_ltng.requestpassword();
        theEmailbean.email = theEmail;
        resetPasswordBean.requestpassword = theEmailbean;
        return JSON.serialize(resetPasswordBean);
    }
    
     @AuraEnabled
    public static void updateITPcontact(String custID ,string originalnumber) 
    {
       
        try
        {
            String calloutURL =IADServiceBase_ltng.APItoWrapper.get(UPDATECONTACTINFOITP).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{customerId}', custID);
           IADContractBeans_ltng.updateItpcontact updatecontact = new IADContractBeans_ltng.updateItpcontact();
           updatecontact.originalType='Home';
           updatecontact.originalNumber=originalnumber;

          
            IADServiceBase_ltng.makeRequestMulti(calloutURL, UPDATECONTACTINFOITP, JSON.serialize(updatecontact));
            
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(UPDATECONTACTINFOITP);
           // if(!response.isAsync)
                readUpdateITPResponse();
            
            //return continuationObject;
        }
        catch(Exception theException)
        {
             IADServiceBase_ltng.populateErrorMessage(theException);
            
        }
        
       
    }
     @AuraEnabled
    public static void  readUpdateITPResponse()
    {
      
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(UPDATECONTACTINFOITP);
            system.debug(response.theResponse);
            if(response.checkIsValidResponse())
            {
                if(response != null && response.statusCode == '200')
                {
                    IADContractBeans_ltng.UpdateEnrollmentResponse deSerializedResponse = (IADContractBeans_ltng.UpdateEnrollmentResponse) JSON.deserialize(response.responseData   ,IADContractBeans_ltng.UpdateEnrollmentResponse.class);
                    response.resultObjects = new List<IADContractBeans_ltng.UpdateEnrollmentResponse>();
                    response.resultObjects.add(deSerializedResponse);
                    system.debug(response);
                    IADServiceBase_ltng.populateSuccessMessage('Contact update in ITP');
                }
                else
                {
                    //IADServiceBase_ltng.populateNullErrorMessage(response);
                }
            }
            else
            {
               // IADServiceBase_ltng.populateErrorMessage(response);
            }
         }
         catch(Exception theException)
         {
            //IADServiceBase_ltng.populateErrorMessage(theException);
         }
    }  
    
}