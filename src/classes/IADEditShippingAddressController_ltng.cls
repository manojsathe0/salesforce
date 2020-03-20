public class IADEditShippingAddressController_ltng {
    @AuraEnabled public static IADContractBeans_ltng.IADShippingAddressBean theContacts{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADShippingContact shippingContact {get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADOrderContact newOrderContact{get;set;}
    @AuraEnabled public static List<String> statePicklist {get;set;}
    @AuraEnabled public static IADEditShippingAddressService_ltng addressService{get;set;}
    @AuraEnabled public static String orderID{get;set;}
    @AuraEnabled public static String orderContactId{get;set;}
    @AuraEnabled public static Boolean isNew{get;set;}
    
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
    @AuraEnabled
    public static IADEditShippingAddressController_ltng init(String orderNumber, String ocId, Boolean isNewOsContact)
    {
        system.debug('ordernumber: '+ orderNumber +'OrderContactId' + ocId +'isNewOsContact' + isNewOsContact);
        IADEditShippingAddressController_ltng ctrlRef = new IADEditShippingAddressController_ltng();
        orderID = orderNumber;
        orderContactId = ocId;
        isNew = isNewOsContact;
        iadServiceMessages = new List<IADMessage_ltng>();
        addressService = new IADEditShippingAddressService_ltng();
        statePicklist = new List<String>();
        statePicklist.add('--None--');
        shippingContact = new IADContractBeans_ltng.IADShippingContact();
        if(isNew)
        {
            for(String state : UtilityLibrary.stateIdsToStateMap.values())
            {
                statePicklist.add(state);
            }
        }
        system.debug('ctrlRef: '+ctrlRef);
        return ctrlRef;
    }
    
    @AuraEnabled 
    public static IADEditShippingAddressController_ltng populateShippingAddress(String orderNumber, String ocId, Boolean isNewOsContact)
    {
        IADEditShippingAddressController_ltng addressCtrlRef = new IADEditShippingAddressController_ltng();
        init(orderNumber, ocId, isNewOsContact);
        try
        {
            IADServiceBase_ltng.initWrapper(IADEditShippingAddressService_ltng.GETCONTACTSBYORDERID);//processShippingContactResponse
            IADEditShippingAddressService_ltng.getShippingContact(orderID);
            processShippingContactResponse();
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('Shipping controller ref: '+addressCtrlRef);
        system.debug('Shipping contact: '+IADEditShippingAddressController_ltng.shippingContact);
        return addressCtrlRef; 
    }

    public static void processShippingContactResponse() 
    {   
        system.debug('Inside Callback');
        try
        {
            APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(IADEditShippingAddressService_ltng.GETCONTACTSBYORDERID);
            system.debug('Response----'+response); 
            if(response.resultObjects != null)
            {
                if(!response.resultObjects.isEmpty())
                {
                    system.debug(response.resultObjects);

                    theContacts = (IADContractBeans_ltng.IADShippingAddressBean)response.resultObjects[0];
                    system.debug('the contacts: '+theContacts);
                    for(IADContractBeans_ltng.IADShippingContact theContact : theContacts.contacts)
                    {
                        system.debug('Order contact id returned from callout: '+theContact.orderContactId);
                        system.debug('order contact passed from js controller: '+orderContactId);
                        if(String.isBlank(orderContactId) && theContact.contactType == 'Shipping'){
                            system.debug('im ready to assign the shipping address');
                            shippingContact = theContact;
                        }
                        else if(orderContactId != null && String.valueOf(theContact.orderContactId) == orderContactId){
                            shippingContact = theContact;
                        }
                    }

                    statePicklist.clear();
                    
                    if(shippingContact.state != null){
                        statePicklist.add(shippingContact.state);
                    }
                    
                    for(String stateMap : UtilityLibrary.stateIdsToStateMap.values())
                    {
                        if(stateMap != shippingContact.state){
                            statePicklist.add(stateMap);
                        }
                    }
                    if(shippingContact.emailAddresses != null && shippingContact.emailAddresses.size() > 0){
                        shippingContact.theEmail = shippingContact.emailAddresses[0].emailAddress;
                    }
                    
                    system.debug('shippingContact ' + shippingContact);
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException); 
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug(IADServiceBase_ltng.iadMessages); 
    }
        
    @AuraEnabled 
    public static IADEditShippingAddressController_ltng updateContact(String orderNumber, String ocId, Boolean isNewOsContact, Map<String, Object> localContact)
    {
        system.debug('localContact: '+localContact);
        system.debug('serialized response: '+JSON.serialize(localContact));
        IADContractBeans_ltng.IADShippingContact localShippingContact = (IADContractBeans_ltng.IADShippingContact) JSON.deserialize(JSON.serialize(localContact), IADContractBeans_ltng.IADShippingContact.class);
        system.debug('localShippingContact: '+localShippingContact);
        IADEditShippingAddressController_ltng addressCtrlRef = new IADEditShippingAddressController_ltng();
        init(orderNumber, ocId, isNewOsContact);
        
        try
        {
            if(localShippingContact.zipCode.length()<5)
            {
                IADServiceBase_ltng.populateErrorMessage('Zipcode must be 5 digits');
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
           
            IADServiceBase_ltng.initWrapper(IADEditShippingAddressService.PUTCONTACTBYORDERID); //, 'processContactUpdateResponse'
            localShippingContact.updatedBy = UserInfo.getName();
            system.debug('state selected ' + localShippingContact.state);
            localShippingContact.state = UtilityLibrary.stateToStateCodeMap.get(localShippingContact.state);
            //system.debug('state changed to ' + selectedState);
            if(UtilityLibrary.isNotNullOrBlank(localShippingContact.theEmail))
            {
                if(!UtilityLibrary.validateEmail(localShippingContact.theEmail))
                {
                    IADServiceBase_ltng.populateErrorMessage('Must provide valid email format.');
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    localShippingContact.emailAddresses = new List<IADContractBeans_ltng.IADShippingContact_Email>();
                    IADContractBeans_ltng.IADShippingContact_Email newEmail = new IADContractBeans_ltng.IADShippingContact_Email();
                    newEmail.emailAddress = localShippingContact.theEmail;
                    localShippingContact.emailAddresses.add(newEmail);
                }
            }
            if(IADServiceBase_ltng.errorCount==0){
                system.debug('serialized local contact: '+JSON.serialize(localShippingContact));
                IADEditShippingAddressService_ltng.putShippingContact(orderID, JSON.serialize(localShippingContact));
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('controller reference: '+addressCtrlRef);
        system.debug('sevice message: '+iadServiceMessages);
        return addressCtrlRef;
    }

    @AuraEnabled 
    public static IADEditShippingAddressController_ltng createContact(String orderNumber, String ocId, Boolean isNewOsContact, Map<String, Object> localContact)
    {
        system.debug('localContact: '+localContact);
        IADContractBeans_ltng.IADShippingContact localShippingContact = (IADContractBeans_ltng.IADShippingContact) JSON.deserialize(JSON.serialize(localContact), IADContractBeans_ltng.IADShippingContact.class);
        system.debug('localShippingContact: '+localShippingContact);
        IADEditShippingAddressController_ltng addressCtrlRef = new IADEditShippingAddressController_ltng();
        init(orderNumber, ocId, isNewOsContact);
        try
        {
            if(localShippingContact.zipCode.length()<5)
            {
                //IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error', 'Zipcode must be 5 digits'));
                //return null;
                IADServiceBase_ltng.populateErrorMessage('Zipcode must be 5 digits');
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
          
            IADServiceBase_ltng.initWrapper(IADEditShippingAddressService_ltng.POSTCONTACTBYORDERID);//, 'processContactCreateResponse'
            newOrderContact = new IADContractBeans_ltng.IADOrderContact();
            newOrderContact.contactType = 'Alternate';
            newOrderContact.createdBy = 'Salesforce';
            newOrderContact.firstName = localShippingContact.firstName;
            newOrderContact.lastName = localShippingContact.lastName;
            newOrderContact.addressLine1 = localShippingContact.addressLine1;
            newOrderContact.addressLine2 = localShippingContact.addressLine2;
            newOrderContact.city = localShippingContact.city;
            newOrderContact.state = localShippingContact.state;
            newOrderContact.zipCode = localShippingContact.zipCode;
            if(UtilityLibrary.isNotNullOrBlank(localShippingContact.theEmail))
            {
                if(!UtilityLibrary.validateEmail(localShippingContact.theEmail))
                {
                    IADServiceBase_ltng.populateErrorMessage('Must provide valid email format.');
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    newOrderContact.emailAddresses = new List<IADContractBeans_ltng.IADShippingContact_Email>();
                    IADContractBeans_ltng.IADShippingContact_Email newEmail = new IADContractBeans_ltng.IADShippingContact_Email();
                    newEmail.emailAddress = localShippingContact.theEmail;
                    newOrderContact.emailAddresses.add(newEmail);
                }
            }
            newOrderContact.homePhone = localShippingContact.homePhone;
            newOrderContact.workPhone = localShippingContact.workPhone;
            newOrderContact.mobilePhone = localShippingContact.mobilePhone;
            newOrderContact.faxPhone = localShippingContact.faxPhone;
            newOrderContact.theEmail = localShippingContact.theEmail;
            if(IADServiceBase_ltng.errorCount==0){
                IADEditShippingAddressService_ltng.createOrderContact(orderID, JSON.serialize(newOrderContact));
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('controller reference: '+addressCtrlRef);
        system.debug('sevice message: '+iadServiceMessages);
        return addressCtrlRef;
    }
    
    @AuraEnabled
    public static IADEditShippingAddressController_ltng deleteContact(String orderNumber, String ocId)
    {
        addressService = new IADEditShippingAddressService_ltng();
        IADEditShippingAddressController_ltng addressCtrlRef = new IADEditShippingAddressController_ltng();
        List<Contact> contact = new List<Contact>();
        system.debug('Order number: '+orderNumber);
        system.debug('Order Contact Id: '+ocId);
        if (String.isNotEmpty(ocId)) 
        {
            try 
            {
                contact = [SELECT Id, LZ_Order_Contact_ID__c, LegalZoom_Contact_ID__c, FkUser__c FROM Contact WHERE LZ_Order_Contact_ID__c = :ocId];
            }
            catch (QueryException theException) 
            {
                IADServiceBase_ltng.populateErrorMessage(theException);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            
            if (contact.size() > 0){
                if(contact[0].FkUser__c != null && orderNumber != null) 
                {
                    System.Debug('ID: ' + contact[0].Id);
                    System.Debug('FkUser__c: ' + contact[0].FkUser__c);
                    System.Debug('orderNumber: ' + orderNumber);
                    System.Debug('LZ_Order_Contact_ID__c: ' + contact[0].LZ_Order_Contact_ID__c);
                    try {
                        IADServiceBase_ltng.initWrapper(IADEditShippingAddressService_ltng.DELETECONTACTBYID);
                        IADEditShippingAddressService_ltng.deleteContact(orderNumber, contact[0].FkUser__c);
                    }
                    catch(Exception theException) {
                        IADServiceBase_ltng.populateErrorMessage(theException);
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    }
                }
                else 
                {
                    IADServiceBase_ltng.populateErrorMessage('Both FkUser and LegalZoom Contact ID fields on Contact need to be populated.');
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }else{
                IADServiceBase_ltng.populateErrorMessage('There is no contact in salesforce that is associated with the Order Contact Id: '+ocId);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        else 
        {
            IADServiceBase_ltng.populateErrorMessage('No Order Contact Id found.');
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return addressCtrlRef;
    }
}