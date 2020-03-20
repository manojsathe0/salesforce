public class IADContactManagerService extends IADServiceBase
{
    public static Boolean editLoginEmialContext;

    public Boolean resetPasswordSuccess{get;set;}
    public Boolean contactUpdateSuccess{get;set;}

    public final static String RESETPASSWORD = 'PostResetPassword';
    public final static String CONTACTUPDATE = 'PutContactInfoByCustomerAndContactId';
    public final static String CONTACTINSERT = 'PostContactByCustomerId';
   
    public IADContactManagerService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(RESETPASSWORD);
        endpoints.add(CONTACTUPDATE);
        endpoints.add(CONTACTINSERT);
        initEndpoints(endpoints);
        
        resetPasswordSuccess = false;
        contactUpdateSuccess= false;
        editLoginEmialContext = false;
    }
    public Object putContactUpdate(Contact c) 
    {
        String calloutURL = APItoWrapper.get(CONTACTUPDATE).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{CUSTOMERID}', c.FKUser__c);
        calloutURL = calloutURL.replace('{CONTACTID}', c.LegalZoom_Contact_ID__c);

        String jsonString = createContactBody(c);

        system.debug('json string ' + jsonString);
        APItoWrapper.get(CONTACTUPDATE).setInfo(APIRequestResponseWrapper.CUSTOMER, c.FKUser__c);
        APItoWrapper.get(CONTACTUPDATE).setInfo(APIRequestResponseWrapper.CONTACT, c.LegalZoom_Contact_ID__c);

        Object continuationObject = makeRequest(calloutURL, CONTACTUPDATE, jsonString);

        APIRequestResponseWrapper response = APItoWrapper.get(CONTACTUPDATE);

        system.debug('response.isAsync ' + response.isAsync);

        if(!response.isAsync)
            readContactUpdateResponse();

        return continuationObject;

       
    }
    public void readContactUpdateResponse()
    {
        try
        {
            APIRequestResponseWrapper response = APItoWrapper.get(CONTACTUPDATE);
            system.debug('in readContactUpdateResponse ' + response.responseData + ' status code ' + response.statusCode);
            if(response.statusCode == '200')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans.IADContactUpdateBean deSerializedResponse = (IADContractBeans.IADContactUpdateBean) JSON.deserialize(response.responseData   ,IADContractBeans.IADContactUpdateBean.class);
                response.resultObjects = new List<IADContractBeans.IADContactUpdateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                populateSuccessMessage('Contact successfully updated. Please wait a few minutes for updates to sync with Salesforce.');
            }
            else if(response.statusCode=='400')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans.IADContactCreateBean deSerializedResponse = (IADContractBeans.IADContactCreateBean) JSON.deserialize(response.responseData   ,IADContractBeans.IADContactCreateBean.class);
                response.resultObjects = new List<IADContractBeans.IADContactCreateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                populateErrorMessage('Contact Update Unsuccessful. ' + deSerializedResponse.status.message);
            }
            else
            {
                populateErrorMessage(response);
            }
         }
        catch(IADException theException)
        {
            populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public Object postContactInsert(Contact c) 
    {
        try
        {
            String calloutURL = APItoWrapper.get(CONTACTINSERT).endPointConfig.link__c;
            calloutURL = calloutURL.replace('{CUSTOMERID}', c.FKUser__c);
            
            String jsonString = createContactBody(c);
            
            system.debug('json string ' + jsonString);

            APItoWrapper.get(CONTACTINSERT).setInfo(APIRequestResponseWrapper.CUSTOMER, c.FKUser__c);
            
            Object continuationObject = makeRequest(calloutURL, CONTACTINSERT, jsonString);
            
            APIRequestResponseWrapper response = APItoWrapper.get(CONTACTINSERT);
            
            if(!response.isAsync)
                readContactInsertResponse();
            
            return continuationObject;
        }
        catch(Exception theException)
        {
            populateErrorMessage(theException);
            return null;
        }
       
    }
    public void readContactInsertResponse()
    {
        try
        {
            APIRequestResponseWrapper response = APItoWrapper.get(CONTACTINSERT);
            system.debug('in readContactInsertResponse ' + response.responseData + ' status code ' + response.statusCode);
            if(response.statusCode == '201')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans.IADContactCreateBean deSerializedResponse = (IADContractBeans.IADContactCreateBean) JSON.deserialize(response.responseData   ,IADContractBeans.IADContactCreateBean.class);
                response.resultObjects = new List<IADContractBeans.IADContactCreateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                populateSuccessMessage(deSerializedResponse.status.message);
            }
            else if(response.statusCode=='400')
            {
                system.debug('@@the response ' + response.responseData);
                IADContractBeans.IADContactCreateBean deSerializedResponse = (IADContractBeans.IADContactCreateBean) JSON.deserialize(response.responseData   ,IADContractBeans.IADContactCreateBean.class);
                response.resultObjects = new List<IADContractBeans.IADContactCreateBean>();
                response.resultObjects.add(deSerializedResponse);
                system.debug(response);
                populateErrorMessage('Contact Create Unsuccessful. ' + deSerializedResponse.status.message);
            }
            else
            {
                populateErrorMessage(response);
            }
            
        }
        catch(Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public String createContactBody(Contact c)
    {
        IADContractBeans.IADContactUpdateBean contactUpdateBean= new IADContractBeans.IADContactUpdateBean();
        IADContractBeans.IADContactUpdate theContactbean = new IADContractBeans.IADContactUpdate();
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
    public Object postResetPassword(String custID) 
    {
        try
        {
            String calloutURL = APItoWrapper.get(RESETPASSWORD).endPointConfig.link__c;
            
            String jsonString = createResetPasswordRequestBody(custID);

            APItoWrapper.get(RESETPASSWORD).setInfo(APIRequestResponseWrapper.CUSTOMER, custID);
            
            Object continuationObject = makeRequest(calloutURL, RESETPASSWORD, jsonString);
            
            APIRequestResponseWrapper response = APItoWrapper.get(RESETPASSWORD);
            if(!response.isAsync)
                readResetPasswordResponse();
            
            return continuationObject;
        }
        catch(Exception theException)
        {
            throw new IADException('Failed resetting password. '+theException.getMessage() , theException);
        }
        
       
    }
    
    public void readResetPasswordResponse()
    {
        System.debug('What abt me?');
        try
        {
            APIRequestResponseWrapper response = APItoWrapper.get(RESETPASSWORD);
            system.debug(response.theResponse);
            if(response.checkIsValidResponse())
            {
                if(response != null && response.statusCode == '200')
                {
                    IADContractBeans.IADRequestPasswordBean deSerializedResponse = (IADContractBeans.IADRequestPasswordBean) JSON.deserialize(response.responseData   ,IADContractBeans.IADRequestPasswordBean.class);
                    response.resultObjects = new List<IADContractBeans.IADRequestPasswordBean>();
                    response.resultObjects.add(deSerializedResponse);
                    system.debug(response);
                    populateSuccessMessage('Password successfully reset.');
                }
                else
                {
                    populateNullErrorMessage(response);
                }
            }
            else
            {
                populateErrorMessage(response);
            }
         }
         catch(Exception theException)
         {
             populateErrorMessage(theException);
         }
    }  
    public String createResetPasswordRequestBody(String theEmail)
    {
        IADContractBeans.IADRequestPasswordRequestBean resetPasswordBean= new IADContractBeans.IADRequestPasswordRequestBean();
        IADContractBeans.requestpassword theEmailbean = new IADContractBeans.requestpassword();
        theEmailbean.email = theEmail;
        resetPasswordBean.requestpassword = theEmailbean;
        return JSON.serialize(resetPasswordBean);
    }
}