/*@Author: Padma s
  @User Story: 
*/
public class IADContactManagerController_ltng {
    

    @AuraEnabled public static Contact newContact{get;set;}  
    @AuraEnabled public static Boolean showNewContactForm{get;set;}
    @AuraEnabled public static List<string> statePicklist {get;set;}
    public static string PRIMARY_CONTACT = 'Primary Contact';    
    public string AUTHORIZED_CONTACT = 'Authorized Contact';
    //@AuraEnabled public static List<Schema.FieldSetMember> fields{get; set;}
    @AuraEnabled public static string lzContactId {get; set;}
    @AuraEnabled public static string customerId {get; set;}
    @AuraEnabled public static string primaryContactEmail {get;set;}
    @AuraEnabled public static string contactType {get;set;}
    @AuraEnabled public static boolean orderAuthorizedContact{get;set;}
    public static boolean canUpdateContact = false;
    @AuraEnabled public static IADContactManagerService_ltng contactManagerService {get;set;}
    @AuraEnabled public static IADContactManagerController_ltng ctrlRef {get; set;}
     @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    
    @AuraEnabled
    public static IADContactManagerController_ltng init(String recordId)
    {
        IADContactManagerController_ltng ctrlRefs = new IADContactManagerController_ltng();
        exceptions = new List<IADMessage_ltng> ();
        contactManagerService = new IADContactManagerService_ltng();
        statePicklist = new List<string>();
        for(String stateMap : UtilityLibrary.stateToStateIdsMap.keySet())
        {
            statePicklist.add(statemap);
        }
        System.debug('statepicklist is '+statePicklist);

        showNewContactForm = true;
        
        if(recordId != null)
        {
            newContact = [SELECT Id ,Life_Plan_Company_c__c, LastModifiedDate, FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , OtherPhone , 
             MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c, LegalZoom_Contact_ID__c,Life_Plan__c,Customer_Login_Email__c
              FROM Contact  WHERE Id = :recordId];
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
                IADServiceBase_ltng.populateErrorMessage('Order authorized contacts cannot be edited.');
           exceptions = IADServiceBase_ltng.iadMessages;
               
            }
            
         customerId =newContact.FkUser__c;
            system.debug('customerId is '+customerId);
         lzContactId  = newContact.LegalZoom_Contact_ID__c;
        }
        else
        {
            newContact = new Contact();
        }
        
       
         List<Schema.FieldSetMember> fields =  SObjectType.Contact.FieldSets.ContactLzApi.getFields();
   
        return ctrlRefs;
    }
    
    @AuraEnabled
   // public static IADContactManagerController_ltng updateContact(Map<String, Object> nContact, string lzcId, String custId)
   public static IADContactManagerController_ltng updateContact(Contact con1, string lzcId, String custId ,boolean lifeplan)
    {
        
        IADContactManagerController_ltng mctrl = new IADContactManagerController_ltng();
        IADContactManagerService_ltng.lifeplan=lifeplan;
        exceptions = new List<IADMessage_ltng> ();
       /* system.debug('padma entered updatecontact');
        System.debug('Pamda newcontact is '+nContact);
        String strJSON = JSON.serialize(nContact);
        system.debug('JSON String is ' + strJSON);
        Contact con1 = (Contact)JSON.deserialize(strJSON, Contact.Class);
        system.debug('Contact is ' + con1);*/
        //Object continuationObject;
      try
        {
           // contactManagerService.clearMessages();
            contactManagerService = new IADContactManagerService_ltng();
           con1.MailingState = String.valueOf(UtilityLibrary.stateToStateIdsMap.get(con1.MailingState));
            //  contactManagerService.initWrapper(IADContactManagerService.CONTACTUPDATE,'processContactUpdateResponse');
            IADServiceBase_ltng.initWrapper(IADContactManagerService_ltng.CONTACTUPDATE);
           // continuationObject = contactManagerService.putContactUpdate(newContact);
           IADContactManagerService_ltng.putContactUpdate(con1, lzcId,custId);  
            APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(IADContactManagerService_ltng.CONTACTUPDATE);
            
            
               // processContactUpdateResponse();
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
           // contactManagerService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        
        //return continuationObject; 
        exceptions = IADServiceBase_ltng.iadMessages;
        return mctrl;
        
    }

   
    @AuraEnabled
    //Callback method for Asynchronous
    public Static Object processContactUpdateResponse() 
    {    
        system.debug('inside callback method');

        //try
          //{
            //contactManagerService.initHTTPResponse(IADContactManagerService.CONTACTUPDATE);
            IADContactManagerService_ltng.readContactUpdateResponse();
            
        
        //}
      /*  catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }*/
        return null;
    }
    
   @AuraEnabled  
   public static IADContactManagerController_ltng createNewcontact(String fkUserId, Contact nc)
    {
      IADContactManagerController_ltng upcon = new IADContactManagerController_ltng();
        exceptions = new List<IADMessage_ltng> ();
       // Object continuationObject;
       system.debug('inside createcontact');
        system.debug('contact nc is '+nc);
        system.debug('fkUserIdc is '+fkUserId);
        try
        {
             contactManagerService = new IADContactManagerService_ltng();
            //string fkuser = ApexPages.currentPage().getParameters().get('fkUser');
            string fkuser = fkUserId;
            //IADServiceBase_ltng.clearMessages();
            nc.fkUser__c = fkuser;
            nc.MailingState = String.valueOf(UtilityLibrary.stateToStateIdsMap.get(nc.MailingState));
            //contactManagerService.initWrapper(IADContactManagerService.CONTACTINSERT,'processContactInsertResponse');
            //IADServiceBase_ltng.initWrapper(IADContactManagerService_ltng.CONTACTINSERT);
            IADServiceBase_ltng.initWrapper(IADContactManagerService_ltng.CONTACTINSERT);
            //continuationObject = contactManagerService.postContactInsert(newContact);
            IADContactManagerService_ltng.postContactInsert(nc);
            APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(IADContactManagerService_ltng.CONTACTINSERT);
            
            //if(!response.isAsync)
                processContactInsertResponse();
        }
       
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        exceptions = IADServiceBase_ltng.iadMessages;
        return upcon;
       // return continuationObject; 

    }
    @AuraEnabled
    public static void processContactInsertResponse() 
    {    
        system.debug('inside processContactInsertResponse');

       /*try
          {*/
            //contactManagerService.initHTTPResponse(IADContactManagerService.CONTACTINSERT);
            IADContactManagerService_ltng.readContactInsertResponse();
            
            
       // }
       /* catch(IADException theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
          IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }*/
       //return null;
    }

    @AuraEnabled
    public static  IADContactManagerController_ltng resetPassword(String custEmail,String orderType )
        
    {
        exceptions = new List<IADMessage_ltng> ();
        system.debug( 'padma inside the resetPassword' );
        System.debug('pcontact is '+custEmail);
        
        
        //Object continuationObject;
        IADContactManagerController_ltng cmct = new IADContactManagerController_ltng();
        try
        {
             contactManagerService = new IADContactManagerService_ltng();
           // IADServiceBase_ltng.clearMessages();
            //contactManagerService.initWrapper(IADContactManagerService.RESETPASSWORD, 'processResetPasswordResponse');
            IADServiceBase_ltng.initWrapper(IADContactManagerService_ltng.RESETPASSWORD);
            //continuationObject = contactManagerService.postResetPassword(newContact.Email);
             IADContactManagerService_ltng.postResetPassword(custEmail,orderType);
            APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(IADContactManagerService_ltng.RESETPASSWORD);
            
        }
        catch(IADException theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }

        //system.debug('end of API call' + continuationObject);
        //return continuationObject; 
        exceptions = IADServiceBase_ltng.iadMessages;
        return cmct;
    } 
    /*public List<Schema.FieldSetMember> getFields()
    {
        return SObjectType.Contact.FieldSets.ContactLzApi.getFields();
    }*/
    
     
    public static void updateItp(string custid ,string originalnumber)
    {
    
    IADContactManagerController_ltng cmct = new IADContactManagerController_ltng();
    IADServiceBase_ltng.initWrapper(IADContactManagerService_ltng.UPDATECONTACTINFOITP);
            //continuationObject = contactManagerService.postResetPassword(newContact.Email);
            IADContactManagerService_ltng.updateITPcontact(custid ,originalnumber);
    
    }
    
}