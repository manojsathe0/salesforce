public class IADEditShippingAddressService extends IADServiceBase
{
	public final static String GETCONTACTSBYORDERID = 'GetContactsByOrderID';
    public final static String PUTCONTACTBYORDERID = 'PutContactByOrderId';
    public final static String POSTCONTACTBYORDERID = 'PostOrderContactByOrderId';
    public final static String DELETECONTACTBYID = 'DeleteContactById';

	
	public IADEditShippingAddressService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETCONTACTSBYORDERID);
        endpoints.add(PUTCONTACTBYORDERID);
        endpoints.add(POSTCONTACTBYORDERID);
        endpoints.add(DELETECONTACTBYID);
        initEndpoints(endpoints);
    }
    public Object getShippingContact(String orderID )
    {
        String calloutURL = (APItoWrapper.get(GETCONTACTSBYORDERID).endPointConfig.link__c).replace('{orderId}',orderID);
        APItoWrapper.get(GETCONTACTSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderID);
        Object continuationObject = makeRequest(calloutURL, GETCONTACTSBYORDERID, '');
        return continuationObject;
    }
    public void readShippingContactResponse()
    {
        try
        {
            APIRequestResponseWrapper shippingContactResponse = APItoWrapper.get(GETCONTACTSBYORDERID);
            system.debug(shippingContactResponse);
            if (shippingContactResponse.responseData != null)
            {
                if (shippingContactResponse.checkIsValidResponse())
                {

                    IADContractBeans.IADShippingAddressBean deSerializedShippingContact = (IADContractBeans.IADShippingAddressBean) JSON.deserialize(shippingContactResponse.responseData, IADContractBeans.IADShippingAddressBean.class);
                    shippingContactResponse.resultObjects = new List<Object>{deSerializedShippingContact};

                }
                else
                {
                    populateErrorMessage(shippingContactResponse);

                }
            }
            else
            {
                populateNullErrorMessage(shippingContactResponse);
            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    
     /*
    Contact deleting functionality added
    By Artyom M.
    Per Story: B-14887, B-22617
    */
    public Object deleteContact(String orderId, String contactId) {
    	String calloutURL = (APItoWrapper.get(DELETECONTACTBYID).endPointConfig.link__c).replace('{orderId}', orderId).replace('{contactId}', contactId);
    	Object continuationObject = makeRequest(calloutURL, DELETECONTACTBYID, '');
        return continuationObject;
     
    }

  public void readDeleteContactResponse() {
  	try {
  		APIRequestResponseWrapper shippingContactResponse = APItoWrapper.get(DELETECONTACTBYID);
  		system.debug('readDeleteContactResponse here: ' + shippingContactResponse);
      	if (shippingContactResponse.responseData != null) {
	        if (shippingContactResponse.checkIsValidResponse()) {
	          	populateSuccessMessage('Contact Successfully Deleted');
	        }
	        else {
	          	populateErrorMessage(shippingContactResponse);
	        }
      }
      else {
      	populateNullErrorMessage(shippingContactResponse);
      }
    }
    catch (Exception theException) {
      	populateErrorMessage(theException);
    }
  }
    
    
    public Object putShippingContact(String orderID, String shippingContact)
    {
        String calloutURL = (APItoWrapper.get(PUTCONTACTBYORDERID).endPointConfig.link__c).replace('{orderId}',orderID);
        APItoWrapper.get(PUTCONTACTBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderID);
        Object continuationObject = makeRequest(calloutURL, PUTCONTACTBYORDERID, shippingContact);
        return continuationObject;
    }

    public void readPutShippingContactResponse()
    {
        try
        {
            APIRequestResponseWrapper shippingContactResponse = APItoWrapper.get(PUTCONTACTBYORDERID);
            system.debug(shippingContactResponse);
            if (shippingContactResponse.responseData != null)
            {
                if (shippingContactResponse.checkIsValidResponse())
                {

                    populateSuccessMessage('Contact Successfully Updated');
                }
                else
                {
                    populateErrorMessage(shippingContactResponse);
                }
            }
            else
            {
                populateNullErrorMessage(shippingContactResponse);
            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public Object createOrderContact(String orderID, String orderContact)
    {
        String calloutURL = (APItoWrapper.get(POSTCONTACTBYORDERID).endPointConfig.link__c).replace('{orderId}',orderID);
        APItoWrapper.get(POSTCONTACTBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderID);
        Object continuationObject = makeRequest(calloutURL, POSTCONTACTBYORDERID, orderContact);
        return continuationObject;
    }

    public void readCreateOrderContactResponse()
    {
        try
        {
            APIRequestResponseWrapper shippingContactResponse = APItoWrapper.get(POSTCONTACTBYORDERID);
            system.debug(shippingContactResponse);
            if (shippingContactResponse.responseData != null)
            {
                if (shippingContactResponse.checkIsValidResponse())
                {

                    populateSuccessMessage('Contact Successfully Created');
                }
                else
                {
                    populateErrorMessage(shippingContactResponse);
                   
                }
            }
            else
            {
                populateNullErrorMessage(shippingContactResponse);
            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }

	
}