public class IADEditShippingAddressController 
{
	public IADContractBeans.IADShippingAddressBean theContacts{get;set;}
	public IADContractBeans.IADShippingContact shippingContact {get;set;}
    public IADContractBeans.IADOrderContact newOrderContact{get;set;}
	public List<SelectOption> statePicklist {get;set;}
	public IADEditShippingAddressService addressService{get;set;}
	public String orderID{get;set;}
    public String orderContactId{get;set;}
    public Boolean isNew{get;set;}
	
	public IADEditShippingAddressController()
	{
        isNew = ApexPages.currentPage().getParameters().get('isNew')=='true'?true:false;
        orderContactId = ApexPages.currentPage().getParameters().get('orderContactId');
		orderID = ApexPages.currentPage().getParameters().get('id');
        addressService = new IADEditShippingAddressService();
        statePicklist = new List<SelectOption>();
	    statePicklist.add(new SelectOption('--None--','--None--'));
        shippingContact = new IADContractBeans.IADShippingContact();
        if(isNew)
        {
            for(String stateMap : UtilityLibrary.stateIdsToStateMap.values())
            {
                statePicklist.add(new SelectOption(stateMap, stateMap));
            }
        }
    }

	public Object populateShippingAddress()
	{
		Object continuationObject;
        try
        {
            addressService.initWrapper(IADEditShippingAddressService.GETCONTACTSBYORDERID, 'processShippingContactResponse');
            continuationObject = addressService.getShippingContact(orderID);

            APIRequestResponseWrapper response =  addressService.APItoWrapper.get(IADEditShippingAddressService.GETCONTACTSBYORDERID);
            if(!response.isAsync)
                processShippingContactResponse();
        }
        catch(IADException theException)
        {
            addressService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            addressService.populateErrorMessage(theException);
        }
        
        return continuationObject; 
	}

	//Callback method for Asynchronous
    public Object processShippingContactResponse() 
    {   
        system.debug('Inside Callback');
        try
        {
            addressService.initHTTPResponse(IADEditShippingAddressService.GETCONTACTSBYORDERID);
           
            addressService.readShippingContactResponse();
              
            APIRequestResponseWrapper response =  addressService.APItoWrapper.get(IADEditShippingAddressService.GETCONTACTSBYORDERID);
            system.debug('Response----'+response); 
            if(response.resultObjects != null)
            {
                if(!response.resultObjects.isEmpty())
                {
                    system.debug(response.resultObjects);

                    theContacts = (IADContractBeans.IADShippingAddressBean)response.resultObjects[0];
                    for(IADContractBeans.IADShippingContact theContact : theContacts.contacts)
                    {
                        if(orderContactId == null && theContact.contactType == 'Shipping')
                            shippingContact = theContact;
                        else if(orderContactId != null && String.valueOf(theContact.orderContactId) == orderContactId)
                            shippingContact = theContact;
                    }

                    //shippingContact.state = UtilityLibrary.stateIdsToStateMap.get(Decimal.valueOf(shippingContact.state));
                    statePicklist.clear();
                    if(shippingContact.state!= null)
                        statePicklist.add(new SelectOption(shippingContact.state, shippingContact.state));
                    for(String stateMap : UtilityLibrary.stateIdsToStateMap.values())
                    {
                        if(stateMap != shippingContact.state)
                            statePicklist.add(new SelectOption(stateMap, stateMap));
                    }
                    if(shippingContact.emailAddresses != null && shippingContact.emailAddresses.size()>0)
                        shippingContact.theEmail = shippingContact.emailAddresses[0].emailAddress;
                    //statePicklist.sort();

                    system.debug('shippingContact ' + shippingContact);
                }
            }
        }
        catch(IADException theException)
        {
            addressService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            addressService.populateErrorMessage(theException);
        }
        system.debug(addressService.iadMessages); 
        return null;
    }
    
     /*
	    Contact deleting functionality added
	    By Artyom M.
	    Per Story: B-14887, B-22617
    */
    public Object deleteContact() {
    	Object continuationObject;
    	Contact cnt = new Contact();
	    if (orderContactId != null) {
	    	try {
	        	cnt = [SELECT Id, LZ_Order_Contact_ID__c, LegalZoom_Contact_ID__c, FkUser__c FROM Contact WHERE LZ_Order_Contact_ID__c = :orderContactId][0];
	      	}
	      catch (QueryException theException) {
	      	addressService.populateErrorMessage(theException);
	      }
	      if (cnt.LZ_Order_Contact_ID__c != null) {
	
	        System.Debug('ID: ' + cnt.Id);
	        System.Debug('LZ_Order_Contact_ID__c: ' + cnt.LZ_Order_Contact_ID__c);
	       
	        try {
	        	addressService.initWrapper(IADEditShippingAddressService.DELETECONTACTBYID, 'processDeleteContactResponse');
	        	continuationObject = addressService.deleteContact(orderID, cnt.LZ_Order_Contact_ID__c);
	        }
	        catch(IADException theException) {
	        	addressService.populateErrorMessage(theException);
	        }
	        catch(Exception theException) {
	        	addressService.populateErrorMessage(theException);
	        }
	
	      }
	      else {
	        addressService.populateErrorMessage('LZ Order Contact ID field on Contact need to be populated.');
	      }
	    }
	    else {
	    	addressService.populateErrorMessage('No Order Contact Id found.');
	    }
	
	
	    return continuationObject;
    }
    
    
    public Object processDeleteContactResponse() {
    	System.Debug('inside processDeleteContactResponse method');
    	try {
    		addressService.initHTTPResponse(IADEditShippingAddressService.DELETECONTACTBYID);
    		addressService.readDeleteContactResponse();
    	}
    	catch(IADException theException) {
      		addressService.populateErrorMessage(theException);
    	}
	    catch(Exception theException) {
	    	addressService.populateErrorMessage(theException);
	    }
    	return null;
  }
    
    public Object updateContact()
    {
        Object continuationObject;
        try
        {
            addressService.clearMessages();
            if(shippingContact.zipCode.length()<5)
            {
                addressService.populateErrorMessage('Zipcode must be 5 digits');
            }
           
            addressService.initWrapper(IADEditShippingAddressService.PUTCONTACTBYORDERID, 'processContactUpdateResponse');
            shippingContact.updatedBy = UserInfo.getName();
            system.debug('state selected ' + shippingContact.state);
            shippingContact.state = UtilityLibrary.stateToStateCodeMap.get(shippingContact.state);
            system.debug('state changed to ' + shippingContact.state);
            if(UtilityLibrary.isNotNullOrBlank(shippingContact.theEmail))
            {
                if(!UtilityLibrary.validateEmail(shippingContact.theEmail))
                {
                    addressService.populateErrorMessage('Must provide valid email format.');
                }
                else
                {
                    shippingContact.emailAddresses = new List<IADContractBeans.IADShippingContact_Email>();
                    IADContractBeans.IADShippingContact_Email newEmail = new IADContractBeans.IADShippingContact_Email();
                    newEmail.emailAddress = shippingContact.theEmail;
                    shippingContact.emailAddresses.add(newEmail);
                }
            }
            if(addressService.errorCount==0)
                continuationObject = addressService.putShippingContact(orderID, JSON.serialize(shippingContact));
        }
        catch(IADException theException)
        {
            addressService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            addressService.populateErrorMessage(theException);
        }

        return continuationObject; 
    }
    public Object processContactUpdateResponse() 
    {    
        system.debug('inside callback method');

        try
        {
            addressService.initHTTPResponse(IADEditShippingAddressService.PUTCONTACTBYORDERID);
            addressService.readPutShippingContactResponse();
        }
        catch(IADException theException)
        {
            addressService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            addressService.populateErrorMessage(theException);
        }
        //addressService.iadMessages = contactService.iadMessages;
        return null;
    }
    public Object createContact()
    {
        Object continuationObject;
        try
        {
            addressService.clearMessages();
            if(shippingContact.zipCode.length()<5)
            {
                addressService.iadMessages.add(IADMessageFactory.createMessage('error', 'Zipcode must be 5 digits'));
                return null;
            }
          
            addressService.initWrapper(IADEditShippingAddressService.POSTCONTACTBYORDERID, 'processContactCreateResponse');
            newOrderContact = new IADContractBeans.IADOrderContact();
            newOrderContact.contactType = 'Alternate';
            newOrderContact.createdBy = 'Salesforce';
            newOrderContact.firstName = shippingContact.firstName;
            newOrderContact.lastName = shippingContact.lastName;
            newOrderContact.addressLine1 = shippingContact.addressLine1;
            newOrderContact.addressLine2 = shippingContact.addressLine2;
            newOrderContact.city = shippingContact.city;
            newOrderContact.state = shippingContact.state;
            newOrderContact.zipCode = shippingContact.zipCode;
            if(UtilityLibrary.isNotNullOrBlank(shippingContact.theEmail))
            {
                if(!UtilityLibrary.validateEmail(shippingContact.theEmail))
                {
                    addressService.populateErrorMessage('Must provide valid email format.');
                }
                else
                {
                    newOrderContact.emailAddresses = new List<IADContractBeans.IADShippingContact_Email>();
                    IADContractBeans.IADShippingContact_Email newEmail = new IADContractBeans.IADShippingContact_Email();
                    newEmail.emailAddress = shippingContact.theEmail;
                    newOrderContact.emailAddresses.add(newEmail);
                }
            }
            newOrderContact.homePhone = shippingContact.homePhone;
            newOrderContact.workPhone = shippingContact.workPhone;
            newOrderContact.mobilePhone = shippingContact.mobilePhone;
            newOrderContact.faxPhone = shippingContact.faxPhone;
            newOrderContact.theEmail = shippingContact.theEmail;
            if(addressService.errorCount==0)
                continuationObject = addressService.createOrderContact(orderID, JSON.serialize(newOrderContact));
        }
        catch(IADException theException)
        {
            addressService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            addressService.populateErrorMessage(theException);
        }

        return continuationObject;
    }
    public Object processContactCreateResponse()
    {
        system.debug('inside callback method');

        try
        {
            addressService.initHTTPResponse(IADEditShippingAddressService.POSTCONTACTBYORDERID);
            addressService.readCreateOrderContactResponse();
        }
        catch(IADException theException)
        {
            addressService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            addressService.populateErrorMessage(theException);
        }
        //addressService.iadMessages = contactService.iadMessages;
        return null;
    }

}