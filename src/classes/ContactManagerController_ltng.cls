public class ContactManagerController_ltng 
{
    public static string primaryContactEmail;
    public static boolean canUpdateContact = false;
    public static string PRIMARY_CONTACT = 'Primary Contact';
    public static string AUTHORIZED_CONTACT = 'Authorized Contact';
    //public final static String INTEGRATION_USER = 'Integration User';  //integration user reference not used anywhere.
    
    @AuraEnabled public static string contactType {get;set;}
    @AuraEnabled public static Contact newContact {get;set;}
    @AuraEnabled public static List<String> statePicklist {get;set;}
    @AuraEnabled public static boolean orderAuthorizedContact {get;set;}
    @AuraEnabled public static List<IADMessage_ltng> messages {get;set;}
    @AuraEnabled public static Id returnId {get;set;}
      
    public static Map<String, Decimal> stateToStateIdsMap
    {
        get
        {
            if(stateToStateIdsMap == null)
            {
                stateToStateIdsMap = new Map<String,Decimal>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c, State_Id__c FROM StatesMap__c])
                {
                    stateToStateIdsMap.put(stateMap.Name,stateMap.State_Id__c);
                }
            }
            return stateToStateIdsMap;
        } 
        set; 
    }
    
    public static Map<Decimal, String> stateIdsToStateMap
    {
        get
        {
            if(stateIdsToStateMap == null)
            {
                stateIdsToStateMap = new Map<Decimal,String>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c, State_Id__c FROM StatesMap__c])
                {
                    stateIdsToStateMap.put(stateMap.State_Id__c,stateMap.Name);
                }
            }
            return stateIdsToStateMap;
        }
        set;
    }
    
    public static Map<String, String> stateCodeToStateMap
    {
        get
        {
            if(stateCodeToStateMap == null)
            {
                stateCodeToStateMap = new Map<String,String>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c, State_Id__c FROM StatesMap__c])
                {
                    stateCodeToStateMap.put(stateMap.State_code__c,stateMap.Name);
                }
            }
            return stateCodeToStateMap;
        }
        set;
    }
    
    @AuraEnabled
    public static ContactManagerController_ltng onload(Id contactId)
    {
        system.debug('contactId: '+contactId);
        contactType = '';
        orderAuthorizedContact = false;
        statePicklist = new List<String>();
        messages = new List<IADMessage_ltng>();
        ContactManagerController_ltng ctrlRef = new ContactManagerController_ltng();
        for(String state : stateToStateIdsMap.keySet())
        {
            statePicklist.add(state);
        }
        
        newContact = [SELECT Id , FirstName , LastName , Inactive__c , Contact_type__c , Email , FkUser__c , DoNotCall, HasOptedOutOfEmail, HomePhone , MobilePhone , OtherPhone , 
                      MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c, LegalZoom_Contact_ID__c,
                      Duplicate__c FROM Contact WHERE Id = :contactId];
        system.debug(newContact.MailingState); 
        system.debug(stateIdsToStateMap); 
        system.debug('newContact.LZ_Order_Contact_ID__c: '+newContact.LZ_Order_Contact_ID__c);
        if(newContact.LZ_Order_Contact_ID__c == null) 
        {
            if(newContact.MailingState != null && newContact.MailingState != '')
            {
                If(newContact.MailingState.isNumeric() && stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState))){ 
                    newContact.MailingState = stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState));
                }
                else{
                    if(stateCodeToStateMap.containsKey(newContact.MailingState))
                        newContact.MailingState = stateCodeToStateMap.get(newContact.MailingState);
                }
            }
            if(newContact.Contact_type__c == PRIMARY_CONTACT){
                primaryContactEmail = newContact.Email;
            }
            else{
                contactType = newContact.Contact_type__c;
            }
        }
        else
        {
            orderAuthorizedContact = true;
        }
        return ctrlRef;
    }
        
    @AuraEnabled
    public static ContactManagerController_ltng updateContact(Id contactId, contact newContact, String contactType)
    {
        ContactManagerController_ltng ctrlRef = new ContactManagerController_ltng();
        messages = new List<IADMessage_ltng>();
        //onload(contactId);
        system.debug('newContact: '+newContact);
        
        newContact.MailingState = String.valueOf(stateToStateIdsMap.get(newContact.MailingState));
        ContactApiResponse_ltng response = new ContactApiResponse_ltng();
        response =  LZApiService_ltng.callLzAPIContactService(newContact,'Update', ''); 
        system.debug('response from callout: '+response);
        if(response.accountUpdated == 1 )
        {
            system.debug(newContact.Contact_type__c + ' contact type '+ contactType);
            List<Contact> primaryContact;
            if(newContact.Contact_type__c == PRIMARY_CONTACT && contactType == AUTHORIZED_CONTACT)
            {
                primaryContact =  [Select Id , FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , 
                                   OtherPhone , MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c ,
                                   LegalZoom_Contact_ID__c, Duplicate__c From Contact Where Contact_type__c =: PRIMARY_CONTACT AND FkUser__c = : newContact.FkUser__c Limit 1];
                if(!primaryContact.isEmpty()){
                    updateAuthToPrimaryContact(newContact,primaryContact);
                }
            }
            system.debug('primaryContact: '+primaryContact);
            try
            {
                if(newContact.MailingState != null){
                    if(stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState))){
                        newContact.MailingState = stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState));
                    }
                }
                if(newContact.Contact_type__c == PRIMARY_CONTACT && contactType == AUTHORIZED_CONTACT && !primaryContact.isEmpty())
                {
                    Contact authContactToUpdate = new Contact(Id = newContact.Id); 
                    authContactToUpdate.Inactive__c = true;
                    authContactToUpdate.Contact_type__c = AUTHORIZED_CONTACT;
                    update authContactToUpdate;
                    
                    if(!primaryContact.isEmpty()){
                        returnId = primaryContact[0].Id;
                    }
                    else{
                        returnId = contactId;
                    }
                    messages.add(new IADMessage_ltng('success', 'Contact Successfully Updated.'));
                }
                else
                {
                    update newContact;
                    returnId = contactId;
                    messages.add(new IADMessage_ltng('success', 'Contact Successfully Update.'));
                }
                
            }
            catch(DmlException exp)
            {
                messages.add(new IADMessage_ltng('error', 'Unable To Update Contact. Reason: '+exp.getMessage()));
                SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to update contact');
                return null;
            }            
        }
        else
        {
            messages.add(new IADMessage_ltng('error', 'Unable To Update Contact. Reason: '+response.message));
            return null;
        }
        
        system.debug('ctrlRef: '+ctrlRef);
        return ctrlRef;
    }   
    
    public static void updateAuthToPrimaryContact(Contact theContact, List<Contact> primaryContact)
    {
        Contact contactToUpdate = new Contact();
        if(!primaryContact.isEmpty())
        {
            contactToUpdate.put('ID', primaryContact[0].Id);
            for(Schema.FieldSetMember fieldToUpdate : SObjectType.Contact.FieldSets.ContactLzApi.getFields())
            {
                contactToUpdate.put(fieldToUpdate.getFieldPath(), theContact.get(fieldToUpdate.getFieldPath()));
            }
            if(theContact.MailingState != null){
                if(stateIdsToStateMap.containsKey(Decimal.valueOf(theContact.MailingState))){
                	contactToUpdate.put('MailingState',stateIdsToStateMap.get(Decimal.valueOf(theContact.MailingState)));
                }
            }
        }
        Customer_Login__c customer = [Select Id, Name, Customer_ID__c From Customer_Login__c Where Customer_ID__c =: theContact.FkUser__c];
        customer.Name = theContact.Email;
        
        try
        {
            update customer;
            if(!primaryContact.isEmpty()){
                update contactToUpdate;
            }
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to update authorized to primary contact');
            messages.add(new IADMessage_ltng('error', 'Unable to update contact.'));
        }
        
    }
    
}