public class IADEditShippingAddressService_ltng extends IADServiceBase_ltng
{
    public final static String GETCONTACTSBYORDERID = 'GetContactsByOrderID';
    public final static String PUTCONTACTBYORDERID = 'PutContactByOrderId';
    public final static String POSTCONTACTBYORDERID = 'PostOrderContactByOrderId';
    public final static String DELETECONTACTBYID = 'DeleteContactById';
    public  static Id contactrecord ;
    
    public IADEditShippingAddressService_ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETCONTACTSBYORDERID);
        endpoints.add(PUTCONTACTBYORDERID);
        endpoints.add(POSTCONTACTBYORDERID);
        endpoints.add(DELETECONTACTBYID);
        initEndpoints(endpoints);
    }
    
    public static void getShippingContact(String orderID )
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETCONTACTSBYORDERID).endPointConfig.link__c).replace('{orderId}',orderID);
        IADServiceBase_ltng.APItoWrapper.get(GETCONTACTSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderID);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETCONTACTSBYORDERID, '');
        readShippingContactResponse();
    }
    
    public static void readShippingContactResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng shippingContactResponse = IADServiceBase_ltng.APItoWrapper.get(GETCONTACTSBYORDERID);
            system.debug(shippingContactResponse);
            if (shippingContactResponse.responseData != null)
            {
                if (shippingContactResponse.checkIsValidResponse())
                {
                    IADContractBeans_ltng.IADShippingAddressBean deSerializedShippingContact = (IADContractBeans_ltng.IADShippingAddressBean) JSON.deserialize(shippingContactResponse.responseData, IADContractBeans_ltng.IADShippingAddressBean.class);
                    shippingContactResponse.resultObjects = new List<Object>{deSerializedShippingContact};
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(shippingContactResponse);
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(shippingContactResponse);
                IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void putShippingContact(String orderID, String shippingContact)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(PUTCONTACTBYORDERID).endPointConfig.link__c).replace('{orderId}',orderID);
        IADServiceBase_ltng.APItoWrapper.get(PUTCONTACTBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderID);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTCONTACTBYORDERID, shippingContact);
        readPutShippingContactResponse();
    }
    
    public static void readPutShippingContactResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng shippingContactResponse = IADServiceBase_ltng.APItoWrapper.get(PUTCONTACTBYORDERID);
            system.debug(shippingContactResponse);
            if (shippingContactResponse.responseData != null)
            {
                if (shippingContactResponse.checkIsValidResponse())
                {
                    IADServiceBase_ltng.populateSuccessMessage('Contact Successfully Updated');
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(shippingContactResponse);
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(shippingContactResponse);
                IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void createOrderContact(String orderID, String orderContact)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(POSTCONTACTBYORDERID).endPointConfig.link__c).replace('{orderId}',orderID);
        IADServiceBase_ltng.APItoWrapper.get(POSTCONTACTBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderID);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTCONTACTBYORDERID, orderContact);
        readCreateOrderContactResponse();
    }

    public static void readCreateOrderContactResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng shippingContactResponse = IADServiceBase_ltng.APItoWrapper.get(POSTCONTACTBYORDERID);
            system.debug(shippingContactResponse);
            system.debug(shippingContactResponse.responseData);
            if (shippingContactResponse.responseData != null)
            {
                if (shippingContactResponse.checkIsValidResponse())
                {
                    IADServiceBase_ltng.populateSuccessMessage('Contact Successfully Created');
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(shippingContactResponse);
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(shippingContactResponse);
                IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void deleteContact(String customerId, String contactId,String contactrecordid) {
        contactrecord=contactrecordid;
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(DELETECONTACTBYID).endPointConfig.link__c).replace('{orderId}', customerId).replace('{contactId}', contactId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DELETECONTACTBYID, '');
        readDeleteContactResponse();
    }

    public static void readDeleteContactResponse() {
        try {
            APIRequestResponseWrapper_ltng shippingContactResponse = IADServiceBase_ltng.APItoWrapper.get(DELETECONTACTBYID);
            system.debug('readDeleteContactResponse here: ' + shippingContactResponse);
            if (shippingContactResponse.responseData != null) {
                if (shippingContactResponse.checkIsValidResponse()) {
                    IADServiceBase_ltng.populateSuccessMessage('Contact Successfully Deleted');
                    Authorized_Contact__c authorized =[select id from Authorized_Contact__c where id=:contactrecord];
                   
                    delete authorized;
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else {
                    IADServiceBase_ltng.populateErrorMessage(shippingContactResponse);
                    IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else {
                IADServiceBase_ltng.populateNullErrorMessage(shippingContactResponse);
                IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException) {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADEditShippingAddressController_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
}