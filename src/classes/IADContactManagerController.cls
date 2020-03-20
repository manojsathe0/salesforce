public without sharing class IADContactManagerController
{
    public Contact newContact{get;set;}
    public Boolean showNewContactForm{get;set;}
    public List<SelectOption> statePicklist {get;set;}
    public static string PRIMARY_CONTACT = 'Primary Contact';
    public static string AUTHORIZED_CONTACT = 'Authorized Contact';
    public string primaryContactEmail;
    public string contactType;
    public boolean orderAuthorizedContact{get;set;}
    public static boolean canUpdateContact = false;
    public IADContactManagerService contactManagerService{get;set;}
    
    public IADContactManagerController()
    {
        contactManagerService = new IADContactManagerService();
        statePicklist = new List<SelectOption>();
        for(String stateMap : UtilityLibrary.stateToStateIdsMap.keySet())
        {
            statePicklist.add(new SelectOption(stateMap, stateMap));
        }

        showNewContactForm = true;
        Id contactId =  ApexPages.currentPage().getParameters().get('id');
        if(contactId != null)
        {
            newContact = [SELECT Id , LastModifiedDate, FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , OtherPhone , 
             MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c, LegalZoom_Contact_ID__c
              FROM Contact WHERE Id = :contactId];
            if(newContact.LZ_Order_Contact_ID__c == null) 
            {
                if(newContact.MailingState != null && newContact.MailingState != '')
                {
                    If(newContact.MailingState.isNumeric() && UtilityLibrary.stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState))) 
                        newContact.MailingState = UtilityLibrary.stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState));
                    else
                        if(UtilityLibrary.stateCodeToStateMap.containsKey(newContact.MailingState))
                            newContact.MailingState = UtilityLibrary.stateCodeToStateMap.get(newContact.MailingState);
                }
                if(newContact.Contact_type__c == PRIMARY_CONTACT)
                        primaryContactEmail = newContact.Email;
                else
                    contactType = newContact.Contact_type__c;
            }
            else
            {
                orderAuthorizedContact = true;
                contactManagerService.populateErrorMessage('Order authorized contacts cannot be edited.');    
            }
        }
        else
        {
            newContact = new Contact();
        }

    }

    public Object updateContact()
    {
        Object continuationObject;
        try
        {
            contactManagerService.clearMessages();
            newContact.MailingState = String.valueOf(UtilityLibrary.stateToStateIdsMap.get(newContact.MailingState));
            contactManagerService.initWrapper(IADContactManagerService.CONTACTUPDATE,'processContactUpdateResponse');
            continuationObject = contactManagerService.putContactUpdate(newContact);
            APIRequestResponseWrapper response =  contactManagerService.APItoWrapper.get(IADContactManagerService.CONTACTUPDATE);
            
            if(!response.isAsync)
                processContactUpdateResponse();
        }
        catch(IADException theException)
        {
            contactManagerService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        
        return continuationObject; 
    }

   
    
    //Callback method for Asynchronous
    public Object processContactUpdateResponse() 
    {    
        system.debug('inside callback method');

        try
          {
            contactManagerService.initHTTPResponse(IADContactManagerService.CONTACTUPDATE);
            contactManagerService.readContactUpdateResponse();
            
        
        }
        catch(IADException theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        return null;
    }
    
    
    public Object createNewContact()
    {
        
        Object continuationObject;
        try
        {
            string fkuser = ApexPages.currentPage().getParameters().get('fkUser');

            contactManagerService.clearMessages();
            newContact.fkUser__c = fkuser;
            newContact.MailingState = String.valueOf(UtilityLibrary.stateToStateIdsMap.get(newContact.MailingState));
            contactManagerService.initWrapper(IADContactManagerService.CONTACTINSERT,'processContactInsertResponse');
            continuationObject = contactManagerService.postContactInsert(newContact);
            APIRequestResponseWrapper response =  contactManagerService.APItoWrapper.get(IADContactManagerService.CONTACTINSERT);
            
            if(!response.isAsync)
                processContactInsertResponse();
        }
        catch(IADException theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        
        return continuationObject; 

    }
    
    public Object processContactInsertResponse() 
    {    
        system.debug('inside callback method');

        try
          {
            contactManagerService.initHTTPResponse(IADContactManagerService.CONTACTINSERT);
            contactManagerService.readContactInsertResponse();
            
            
        }
        catch(IADException theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        return null;
    }

    
    public Object resetPassword()
    {
        Object continuationObject;
        try
        {
            contactManagerService.clearMessages();
            contactManagerService.initWrapper(IADContactManagerService.RESETPASSWORD, 'processResetPasswordResponse');
            continuationObject = contactManagerService.postResetPassword(newContact.Email);
            APIRequestResponseWrapper response =  contactManagerService.APItoWrapper.get(IADContactManagerService.RESETPASSWORD);
            
        }
        catch(IADException theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }

        system.debug('end of API call' + continuationObject);
        return continuationObject; 
    }
    public List<Schema.FieldSetMember> getFields()
    {
        return SObjectType.Contact.FieldSets.ContactLzApi.getFields();
    }
     //Callback method for Asynchronous
    public Object processResetPasswordResponse() 
    {    
        system.debug('inside callback method');

        try
        {
            
            contactManagerService.initHTTPResponse(IADContactManagerService.RESETPASSWORD);
            contactManagerService.readResetPasswordResponse();
            
            APIRequestResponseWrapper response =  contactManagerService.APItoWrapper.get(IADContactManagerService.RESETPASSWORD);
        }
        catch(IADException theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactManagerService.populateErrorMessage(theException);
        }
        return null;
    }

}