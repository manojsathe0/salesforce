public class IADHighlightsPanelContactController_ltng {
    
    @AuraEnabled public static List<Contact> contacts{get;set;}
    @AuraEnabled public static List<Customer_Login__c> customerLogin{get;set;}
    @AuraEnabled public static List<Authorized_Contact__c> authorizedContacts{get;set;}
    @AuraEnabled public static List<Id> authorizedContactIds{get;set;}
    @AuraEnabled public static List<Order__c> orders{get;set;}
    @AuraEnabled public static String contactId{get;set;}
    @AuraEnabled public static String contactidtosend{get;set;}
    @AuraEnabled public static  Boolean thereIsCompanyAlert{get;set;}   
    @AuraEnabled public  static String companyAlert{get;set;}
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static Integer netPromoter {get;set;}
    @AuraEnabled public static String color{get;set;}
    @AuraEnabled public static String emailIcon{get;set;}
    @AuraEnabled public static String callIcon{get;set;}
    @AuraEnabled public static String mapIcon{get;set;}
    @AuraEnabled public static String boxIcon{get;set;}
    @AuraEnabled public static Boolean hasBoxAccount{get;set;}
    @AuraEnabled public static IADHighlightsPanelContactService_ltng contactService{get;set;}
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static IADContactManagerService_ltng contactManagerService{get;set;}
    @AuraEnabled public static Boolean passwordReset{get;set;}
    @AuraEnabled public static Integer verifiedHours{get;set;}
    @AuraEnabled public static String contactName{get;set;}
    @AuraEnabled public static String currentAdvisory{get;set;}
    @AuraEnabled public static List<String> customerTags{get;set;}
    @AuraEnabled public static String boxId{get;set;} 
    @AuraEnabled public static String oauthToken{get;set;}
    @AuraEnabled public static String userId{get;set;}
    @AuraEnabled public static String appURL{get;set;}
    @AuraEnabled public static String appId{get;set;}
    @AuraEnabled public static Boolean hasSecurityQuestion{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    @AuraEnabled public static List<String>  advisoryoptions{get;set;} 
    @AuraEnabled public static String loginURL {get;set;} 
    //@AuraEnabled public static Map<String, String> customerSubIcons {get; set;}  //padma @B-29724
    //@AuraEnabled public static IADHighlightsPanelContactController_ltng ctrlRef {get; set;}
    
    @AuraEnabled
    public static IADHighlightsPanelContactController_ltng init(String recordId)
    {
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        advisoryoptions = PicklistDescriber.describe('contact', 'Standard_Contact', 'Advisory__c');
        // List<string > options =PicklistDescriber.describe('contact', 'Standard_Contact', 'Advisory__c');
        exceptions= new List<IADMessage_ltng>();
        
        passwordReset = false;
        emailIcon = IADSGVIconStrings.email;
        callIcon = IADSGVIconStrings.call;
        mapIcon = IADSGVIconStrings.mapIcon;
        boxIcon = IADSGVIconStrings.boxIcon;
        
        contactManagerService = new IADContactManagerService_ltng();
        contactService = new IADHighlightsPanelContactService_ltng();
        system.debug('Im inside the init method');
        system.debug('Record id: '+recordId);
        if(recordId != null && recordId != '')
        {
            
            if(recordId.startsWith('003'))
            {
                system.debug('getting inside contact: populateContactAndCustomerLogins()');
                populateContactAndCustomerLogins(recordId);
            }
            else
            {
                orderId = recordId;
                orders = [SELECT id , Contact__c , Contact__r.Name, Contact__r.Advisory__c FROM Order__c WHERE Id = :orderId];
                if(!orders.isEmpty() && orders[0].Contact__c != null)
                {
                    contactName = orders[0].Contact__r.Name;
                    contactId = orders[0].Contact__c;
                    currentAdvisory = orders[0].Contact__r.Advisory__c;
                    system.debug('getting inside: populateContactAndCustomerLogins()');
                    populateContactAndCustomerLogins(contactId);
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage('Contact not synced with Salesforce, please review this with a member of your management team.');
                    exceptions = IADServiceBase_ltng.iadMessages;
                    
                }
            }
            
        }
        verifiedHours = integer.valueOf( UtilityLibrary.getConfig().Contact_Highlights_Panel_Hours_Threshold__c);
        netPromoter = integer.ValueOf(Math.rint(Math.random() * 3));
        
        if(netPromoter == 1)
        {
            color = 'slds-icon-action-close';
        }
        else if(netPromoter ==2)
        {
            color = 'slds-icon-standard-email-chatter';
        }
        else
        {
            color = 'slds-icon-standard-contract';
        }
        
        /* replace above logic with this after we have the netpromoter API
if(netPromoter <= 6)
{
color = 'slds-icon-action-close';
}
else if(netPromoter >=7 || netPromoter <= 8)
{
color = 'slds-icon-standard-email-chatter';
}
else
{
color = 'slds-icon-standard-contract';
}
*/
        populateCustomer();
        system.debug('Contact information: '+contacts[0]);
        system.debug('class reference: '+ctrlRef);
        return ctrlRef;
    }
    
    public static void populateContactAndCustomerLogins(String contactId)
    {
        
        system.debug('inside: populateContactAndCustomerLogins()');
         // Added two fields - Mailing Country and Address_2__c in below query - STORY B-38865
        contacts = [SELECT Id,Name,Email,Homephone,MailingStreet, MailingCity,FkUser__c, MailingPostalCode,MailingCountry, Address_2__c, MailingState,Genesys_Interaction_Id__c, Advisory__c,Account.Life_Plan__c,Account.Life_Plan_Company__c, Account.Lifeplan_Plus__c ,Account.Lp_free_ITP__c ,Account.Employee_Id__c,Sum_of_Total_Deals__c , LegalZoom_Contact_ID__c, RecordType.Name, Inactive__c, Contact_Type__c ,No_Telemarketing_Allowed__c,Customer_Login_Email__c FROM Contact where id=:contactId];
        
        if(!contacts.isEmpty())
        { 
            system.debug('the comtact id is '+ contactId);
            contactidtosend = contacts[0].Id;
            currentAdvisory = contacts[0].Advisory__c;
            if (contacts[0].Account.Life_Plan__c && UtilityLibrary.isNotNullOrBlank(contacts[0].Account.Life_Plan_Company__c)) {
                String compnayName = contacts[0].Account.Life_Plan_Company__c;
                LifePlanClientSettings__c companyCS = LifePlanClientSettings__c.getValues(compnayName);
                if (companyCS != null) {
                    if (UtilityLibrary.isNotNullOrBlank(companyCS.Alert_Message__c)) {
                        thereIsCompanyAlert = true;
                        companyAlert = companyCS.Alert_Message__c;
                    }
                }            
            }
            customerLogin = [SELECT Name, Customer_ID__c, ID FROM Customer_Login__c WHERE Primary_Contact__r.ID =: contacts[0].Id LIMIT 1];
            if(!customerLogin.isEmpty()){
                customerId = customerLogin [0].Customer_ID__c;
            }
        }
        if(!customerLogin.isEmpty())
        {
            authorizedContacts = [SELECT Contact__r.ID, Contact__r.LastName, Contact__r.FirstName, Contact__r.Name from Authorized_Contact__c WHERE Authorized_Customer_Login__r.name =: customerLogin[0].Name and Inactive__c = false];
        }
    }
    
    @AuraEnabled
    public static IADHighlightsPanelContactService_ltng getCustomerTags(String customerId) 
    {   
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();            
        try
        {   
            //init(recordId);
            contactService = new IADHighlightsPanelContactService_ltng();
            customerTags = new List<String>();
            system.debug('im inside CustomerTags: first');
            system.debug('endpoint label: '+IADHighlightsPanelContactService_ltng.GETCUSTOMERTAGBYCUSTOMERID);
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.GETCUSTOMERTAGBYCUSTOMERID);
            customerTags = IADHighlightsPanelContactService_ltng.getCustomerTagByCustomerId(customerId);            
        }
        catch(IADException theException)
        {
            system.debug('exception thrown in getCustomerTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
            //orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in getCustomerTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
            //orderService.populateErrorMessage(theException);
        }
        //system.debug('order tags: '+orderTags);
        
        return contactService;        
    }   
    
    @AuraEnabled
    public static IADHighlightsPanelContactController_ltng createCustomerTags(String customerId, String tagName ,string vip) 
    {   
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        try
        {   
            contactService = new IADHighlightsPanelContactService_ltng();
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.POSTCUSTOMERTAGBYCUSTOMERID);
            IADHighlightsPanelContactService_ltng.createCustomerTagByCustomerId(customerId, tagName ,vip);
            
        }
        catch(IADException theException)
        {
            system.debug('exception thrown in createCustomerTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in createCustomerTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        //system.debug('order tags: '+orderTags);
        //exceptions = IADServiceBase_ltng.iadMessages;
        return ctrlRef;
    }
    
    @AuraEnabled
    public static IADHighlightsPanelContactController_ltng deleteCustomerTags(String customerId, String tagName) 
    {   
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        try
        {   
            contactService = new IADHighlightsPanelContactService_ltng();
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.DELETECUSTOMERTAGBYCUSTOMERID);
            IADHighlightsPanelContactService_ltng.deleteCustomerTagByCustomerId(customerId, tagName);
            
        }
        catch(IADException theException)
        {
            system.debug('exception thrown in deleteCustomerTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in deleteCustomerTags');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        //system.debug('deleteCustomerTags: '+deleteCustomerTags);
        return ctrlRef;
    }
    
    
    @AuraEnabled
    public Boolean isCustomerVerified
    {
        get
        {
            isCustomerVerified = false;
            if(contacts!=null){
            List<Contact> updatedConatcts = [SELECT Id, Genesys_Interaction_Id__c FROM Contact WHERE Id =:contacts[0].Id];
            Datetime startTime = system.now().addHours(verifiedHours);
            Datetime endTime = system.now();
            if(updatedConatcts[0].Genesys_Interaction_Id__c != null && updatedConatcts[0].Genesys_Interaction_Id__c != '')
            {
                List<Task> theTasks = [SELECT Id ,Is_Customer_Verified__c , CallObject   FROM Task WHERE CallObject = :updatedConatcts[0].Genesys_Interaction_Id__c
                                       AND CreatedDate >=: startTime and CreatedDate <=: endTime AND Subject != 'Case Activity' order by createddate desc];
                if(!theTasks.isEmpty())
                {
                    for(Task theTask : theTasks)
                    {
                        if(theTask.Is_Customer_Verified__c){
                            isCustomerVerified = true;
                        }
                    }
                }
            }
            }
            return isCustomerVerified;
        }
        set;
    }
    @auraenabled
    public static  IADHighlightsPanelContactController_ltng  updateAdv(string contactId, string selectedadvisor)
    {
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        exceptions= new List<IADMessage_ltng>();
        contacts = [SELECT Id,Name,Email,Homephone,MailingStreet, MailingCity, MailingPostalCode , MailingState,Genesys_Interaction_Id__c, Advisory__c,Account.Life_Plan__c,Account.Life_Plan_Company__c  FROM Contact where id=:contactId];
        
        try
        {
            currentAdvisory=contacts[0].Advisory__c;
            if(contacts[0].Advisory__c != null ||  String.isBlank(currentAdvisory) )
            {
                contacts[0].Advisory__c =selectedadvisor;
                update contacts;
            }
            else{
                contacts[0].Advisory__c = currentAdvisory;
            }
        }
        catch(DMLEXception dmlEx)
        {
            if(dmlEx.getMessage().contains('UNABLE_TO_LOCK_ROW')){
                IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
                exceptions = IADServiceBase_ltng.iadMessages;
            }
            
            
            else if(UtilityLibrary.sendEmail)
                SendExceptionEmail.sendExceptionEmail(dmlEx, 'IAD Exception');
        }
        return ctrlRef;
    }
    
    
    public static void populateCustomer()
    {
        
        //Object continuationObject;
        try
        {
            
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID);
            if(customerId != null){
                IADHighlightsPanelContactService_ltng.getCustomerByCustomerId(customerId);
            }
            
            //processResponse();
            
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        //return continuationObject;
        
    }
    
    @Auraenabled
    public  static IADHighlightsPanelContactController_ltng resetPassword(String custEmail,String orderType)
    {
        
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        exceptions= new List<IADMessage_ltng>();
        
        try
        {
            
            //contactManagerService.initWrapper(IADContactManagerService.RESETPASSWORD, 'processResetPasswordResponse');
            //continuationObject = contactManagerService.postResetPassword(contacts[0].Email);
            IADContactManagerService_ltng contactmanager =  new  IADContactManagerService_ltng(); 
            IADServiceBase_ltng.initWrapper(IADContactManagerService_ltng.RESETPASSWORD);
            IADContactManagerService_ltng.postResetPassword(custEmail,orderType);
            processResetPasswordResponse();
            
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        return ctrlRef;
        
    }
    
    public static  void processResetPasswordResponse()
    {
        
        try
        {
            //contactManagerService.iadMessages.clear();
            //contactManagerService.initHTTPResponse(IADContactManagerService.RESETPASSWORD);
            IADContactManagerService_ltng.readResetPasswordResponse();
            
            if(!IADServiceBase_ltng.iadMessages.isEmpty())
            {
                
                if(IADServiceBase_ltng.iadMessages[0].message == 'Password successfully reset.')
                {
                   // IADServiceBase_ltng.iadMessages[0].message = 'Message has been sent for Password  reset';
                    
                    exceptions = IADServiceBase_ltng.iadMessages;
                    
                    
                }
                else
                
                {
                
                    exceptions = IADServiceBase_ltng.iadMessages;
                
                }
            }
            
            
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        //return null;
    }
    
      
    //Padma added for LAU B-26903
    @AuraEnabled
    public static String postLoginToken(String customerId)
    {
        system.debug('inside postlogintoken ' +customerId);
         String loginURL;   
        
        try
        {
            IADHighlightsPanelContactService_ltng contactService=new IADHighlightsPanelContactService_ltng();
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.POSTLOGINTOKENBYCUSTOMERID);
           loginURL = IADHighlightsPanelContactService_ltng.postLoginTokenByCustomerId(customerId);
            
           
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions=IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions=IADServiceBase_ltng.iadMessages;
        }
         //IADHighlightsPanelContactController_ltng crt = new IADHighlightsPanelContactController_ltng();
         return loginURL;
        
    }
    //EOC Padma LAU
    
    @AuraEnabled
    public static IADHighlightsPanelContactController_ltng deleteAuthorizedContact(String recordId, String customerId, String contactId) {
        System.debug('Inside deleteAuthorizedContact');
    

        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        try
        {   
            contactService = new IADHighlightsPanelContactService_ltng();
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.DELETEAUTHCONTACTBYID);
            IADHighlightsPanelContactService_ltng.deleteAuthContactById(customerId, contactId);
            /*
            List<Contact> contactsToDelete = new List<Contact>();//LegalZoom_Contact_ID__c, FkUser__c
            contactsToDelete = [SELECT Id FROM Contact WHERE Id =:recordId];
            if(!contactsToDelete.isEmpty()) {
                System.debug('Deleting Contact from Salesforce: ' + contactsToDelete.size());
                delete contactsToDelete;
            }
            */
            
        }
        catch(IADException theException)
        {
            system.debug('exception thrown in deleteAuthorizedContact');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in deleteAuthorizedContact');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        //system.debug('deleteCustomerTags: '+deleteCustomerTags);
        return ctrlRef;
    }
    
    //Padma @B-29724
    
   /* @AuraEnabled
    public static IADHighlightsPanelContactService_ltng getCustomerSubIcons ( String customerId) 
    {   
        IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();            
        try
        {   
           
            contactService = new IADHighlightsPanelContactService_ltng();            
            customerSubIcons= new Map<String, String>();            
            
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.GETSUBSCRITPIONSERVICESBYCUSTOMERID);
            customerSubIcons = IADHighlightsPanelContactService_ltng.getSubscriptionservicesyByCustomerId(customerId);            
        }
        catch(IADException theException)
        {
            
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
            
        }
        catch(Exception theException)
        {
         
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        
        }
     
        
        return contactService;        
    }  
    */ 
     @AuraEnabled
    public static  IADHighlightsPanelContactController_ltng createProvisionAccount(String payload){
            IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();
        try
        {   
        
             contactService = new IADHighlightsPanelContactService_ltng(); 
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.CREATETHIRDPARTYUSER);
            IADHighlightsPanelContactService_ltng.createProvisionAccount(payload);            
        }
        
        catch(Exception theException)
        {
            
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
            
        }
        return ctrlRef;
        
    }
    @AuraEnabled
    public static IADHighlightsPanelContactService_ltng getThirdPartyTypeId(String recId){
        try
        {   
            String payload;
            if(recId.startsWith('003'))
            {
            Contact conObj=[SELECT Id,Name,LastName FROM Contact where id=:recId];
             contactService = new IADHighlightsPanelContactService_ltng();         
                payload='{"name":"'+conObj.name+' '+conObj.Lastname+'","provisionFolderStructure":"true"}'; 
                
            }
            
            else
            {
                
             order__c conObj =[select contact__r.Name ,Contact__r.LastName from order__c where id=:recId] ;   
                contactService = new IADHighlightsPanelContactService_ltng();         
                payload='{"name":"'+conObj.contact__r.name+' '+conObj.contact__r.Lastname+'","provisionFolderStructure":"true"}'; 
            }
             
            IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.GETTHIRDPARTYTYPEID);
            IADHighlightsPanelContactService_ltng.getThirdPartyTypeId(payload);            
        }
        
        catch(Exception theException)
        {
            
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
            
        }
        return contactService;
        
    }
    
    
}