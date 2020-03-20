public with sharing class Lgt_HighlightsPanelContactController
{

    public List<Contact> contacts{get;set;}
    public List<Customer_Login__c> customerLogin{get;set;}
    public List<Authorized_Contact__c> authorizedContacts{get;set;}
    public List<Id> authorizedContactIds{get;set;}
    public List<Order__c> orders{get;set;}
    public String contactId{Get;set;}
    public String orderId{get;set;}
    public Integer netPromoter {get;set;}
    public String color{get;set;}
    public String emailIcon{get;set;}
    public String callIcon{get;set;}
    public String mapIcon{get;set;}
    public String boxIcon{get;set;}
    public Boolean hasBoxAccount{get;set;}
    public IADHighlightsPanelContactService contactService{get;set;}
    public String customerId{get;set;}
    public IADContactManagerService contactManagerService{get;set;}
    public Boolean passwordReset{get;set;}
    public Integer verifiedHours{get;set;}
    public String contactName{get;set;}

    public Lgt_HighlightsPanelContactController (ApexPages.StandardController controller)
    {
        passwordReset = false;
        emailIcon = IADSGVIconStrings.email;
        callIcon = IADSGVIconStrings.call;
        mapIcon = IADSGVIconStrings.mapIcon;
        boxIcon = IADSGVIconStrings.boxIcon;
        String objId = controller.getRecord().Id;

        contactManagerService = new IADContactManagerService();
        contactService = new IADHighlightsPanelContactService();
        if(objId != null && objId != '')
        {

            if(objId.startsWith('003'))
            {
                List<Contact> contacts = [SELECT Id FROM Contact WHERE Id = :objId];
                if(!contacts.isEmpty())
                    contactId = contacts[0].Id; //Get 18 digit Ids for consistent matching on VF page

                populateContactAndCustomerLogins();
            }
            else
            {
                orderId = objId;
                orders = [SELECT id , Contact__c , Contact__r.Name FROM Order__c WHERE Id = :orderId];
                if(!orders.isEmpty() && orders[0].Contact__c != null)
                {
                    contactName = orders[0].Contact__r.Name;
                    contactId = orders[0].Contact__c;
                    populateContactAndCustomerLogins();
                }
                else
                {
                    contactService.populateErrorMessage('Contact not synced with Salesforce, please review this with a member of your management team.');
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
    }
    public void populateContactAndCustomerLogins()
    {
        contacts = [SELECT Id,Name,Email,Homephone,MailingStreet, MailingCity, MailingPostalCode , MailingState,Genesys_Interaction_Id__c, Advisory__c  FROM Contact where id=:contactId];

        if(!contacts.isEmpty())
        {
            customerLogin = [SELECT Name, Customer_ID__c, ID FROM Customer_Login__c WHERE Primary_Contact__r.ID =: contacts[0].Id LIMIT 1];
            if(!customerLogin.isEmpty())
                customerId = customerLogin [0].Customer_ID__c;
        }
        if(!customerLogin.isEmpty())
        {
            authorizedContacts = [SELECT Contact__r.ID, Contact__r.LastName, Contact__r.FirstName, Contact__r.Name from Authorized_Contact__c WHERE Authorized_Customer_Login__r.name =: customerLogin[0].Name and Inactive__c = false];
        }
    }
    public PageReference refreshVerifySection()
    {
        return null;
    }

    public PageReference refreshPage()
    {
        return null;
    }
    public PageReference closeAdvisory()
    {
        contacts[0].Advisory__c = currentAdvisory;
        return null;
    }
    public Boolean isCustomerVerified
    {
        get
        {
            isCustomerVerified = false;
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
                        if(theTask.Is_Customer_Verified__c)
                            isCustomerVerified = true;
                    }
                }
            }
            return isCustomerVerified;
        }
        set;
    }

    public String currentAdvisory
    {
        get
        {
            Contact c = [select id, Advisory__c from Contact where id =:contactId limit 1];
            return c.Advisory__c;
        }
        set;
    }

    public void  updateAdv()
    {
        try
        {
            if(contacts[0].Advisory__c != null)
            {
                update contacts;
            }
            else{
                contacts[0].Advisory__c = currentAdvisory;
            }
        }
        catch(DMLEXception dmlEx)
        {
            if(dmlEx.getMessage().contains('UNABLE_TO_LOCK_ROW'))
                contactService.populateErrorMessage('A record related to this is currently being updated, please wait and try again.');
            else if(UtilityLibrary.sendEmail)
                SendExceptionEmail.sendExceptionEmail(dmlEx, 'IAD Exception');
        }
    }


    public Object populateCustomer()
    {

        Object continuationObject;
        try
        {

            contactService.initWrapper(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID, 'processResponse');
            if(customerId != null)
                continuationObject = contactService.getCustomerByCustomerId(customerId);

        }
        catch(IADException theException)
        {
            contactService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactService.populateErrorMessage(theException);
        }
        return continuationObject;

    }
    // Callback method for Asynchronous
    public Object processResponse()
    {
        try
        {
            contactService.populateCustomer();

        }
        catch(IADException theException)
        {
            contactService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactService.populateErrorMessage(theException);
        }
        return null;

    }

    public Object resetPassword()
    {


        Object continuationObject;
        contactService.clearMessages();
        try
        {

            contactManagerService.initWrapper(IADContactManagerService.RESETPASSWORD, 'processResetPasswordResponse');
            continuationObject = contactManagerService.postResetPassword(contacts[0].Email);

        }
        catch(IADException theException)
        {
            contactService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactService.populateErrorMessage(theException);
        }
        return continuationObject;

    }

    public Object processResetPasswordResponse()
    {

        try
        {
            contactManagerService.iadMessages.clear();
            contactManagerService.initHTTPResponse(IADContactManagerService.RESETPASSWORD);
            contactManagerService.readResetPasswordResponse();

            if(!contactManagerService.iadMessages.isEmpty())
            {

                if(contactManagerService.iadMessages[0].message == 'Password successfully reset.')
                {
                    contactManagerService.iadMessages[0].message = 'Message has been sent to '+contacts[0].Name+' at '+contacts[0].Email+'.';
                    contactService.clearMessages();
                    contactService.iadMessages.addAll(contactManagerService.iadMessages);
                    passwordReset  = true;

                }
            }

        }
        catch(IADException theException)
        {
            contactService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            contactService.populateErrorMessage(theException);
        }
        return null;
    }

    public void resetPasswordFlag()
    {

        passwordReset = false;
        contactService.iadMessages.clear();
        contactManagerService.iadMessages.clear();
    }
}