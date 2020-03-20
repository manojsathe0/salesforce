/**
 * Created by jboles on 10/14/2016.
 */
@isTest
public class IADEditShippingAddressTest
{
    final static String PRODUCT_LINE = 'Test ProductLine';
    static Id relationshipTypeId;
    static List<Order__c> orders;

    public static void setupData()
    {
        Product2 testProduct = TestUtils.createProducts( 1 , '', false)[0];
        testProduct.Name = 'Business Advantage Pro Attorney Consultation';
        Product_Line__c testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct;

        orders = TestUtils.createOrders(1, testProduct.id, true);

        StatesMap__c sMap = new StatesMap__c();
        sMap.Name = 'California';
        sMap.State_Code__c = 'CA';
        sMap.Is_State__c = true;
        sMap.State_Id__c = 5;
        insert sMap;

    }
    @isTest static void testGetContactsByOrderIdAsync()
    {
        setupData();

        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.GETCONTACTSBYORDERID, true);

        //Async
        Continuation conti = (continuation)theController.populateShippingAddress();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.addressService.APItoWrapper.get(IADEditShippingAddressService.GETCONTACTSBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


    }
    @isTest static void testGetContactsByOrderIdSync()
    {
        setupData();
        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.GETCONTACTSBYORDERID, false);

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getOrderContactsResponse();
        mock.statusCode=200;

        Test.setMock(HttpCalloutMock.class, mock);

        theController.populateShippingAddress();


        HttpResponse res = theController.addressService.APIToWrapper.get(IADEditShippingAddressService.GETCONTACTSBYORDERID).theResponse;
    }
    @isTest static void testPutShippingContactAsync()
    {
        setupData();

        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.PUTCONTACTBYORDERID, true);
        theController.shippingContact.state = 'CA';
        theController.shippingContact.zipCode = '43430';

        //Async
        Continuation conti = (continuation)theController.updateContact();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.addressService.APItoWrapper.get(IADEditShippingAddressService.PUTCONTACTBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


    }
    @isTest static void testPutShippingContactSync()
    {
        setupData();
        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.PUTCONTACTBYORDERID, false);
        theController.shippingContact.state = 'CA';
        theController.shippingContact.zipCode = '43430';

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getOrderContactsResponse();
        mock.statusCode=200;

        Test.setMock(HttpCalloutMock.class, mock);

        theController.updateContact();


        HttpResponse res = theController.addressService.APIToWrapper.get(IADEditShippingAddressService.PUTCONTACTBYORDERID).theResponse;

        theController.shippingContact.zipCode = '4304';
        theController.updateContact();
    }

    @isTest static void testPostOrderContactAsync()
    {
        setupData();

        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);
        pageRef.getParameters().put('isNew','true');

        Test.setCurrentPage(pageRef);

        List<IADContractBeans.IADShippingContact_Email> emailAddresses = new  List<IADContractBeans.IADShippingContact_Email>();
        IADContractBeans.IADShippingContact_Email theEmail = new IADContractBeans.IADShippingContact_Email();
        theEmail.emailAddress = 'test@something.com';
        emailAddresses.add(theEmail);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.POSTCONTACTBYORDERID, true);
        theController.shippingContact.firstName='test';
        theController.shippingContact.lastName='test';
        theController.shippingContact.addressLine1='test';
        theController.shippingContact.addressLine2='test';
        theController.shippingContact.city='test';
        theController.shippingContact.state = 'CA';
        theController.shippingContact.zipCode = '43430';
        theController.shippingContact.homePhone = 'test';
        theController.shippingContact.workPhone = 'test';
        theController.shippingContact.mobilePhone = 'test';
        theController.shippingContact.faxPhone = 'test';
        theController.shippingContact.theEmail = 'test@something.com';


        theController.shippingContact.emailAddresses = emailAddresses;

        //Async
        Continuation conti = (continuation)theController.createContact();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.addressService.APItoWrapper.get(IADEditShippingAddressService.POSTCONTACTBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


    }
    @isTest static void testPostOrderContactSync()
    {
        setupData();
        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);
        pageRef.getParameters().put('isNew','true');

        Test.setCurrentPage(pageRef);

        List<IADContractBeans.IADShippingContact_Email> emailAddresses = new  List<IADContractBeans.IADShippingContact_Email>();
        IADContractBeans.IADShippingContact_Email theEmail = new IADContractBeans.IADShippingContact_Email();
        theEmail.emailAddress = 'test@something.com';
        emailAddresses.add(theEmail);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.POSTCONTACTBYORDERID, false);
        theController.shippingContact.firstName='test';
        theController.shippingContact.lastName='test';
        theController.shippingContact.addressLine1='test';
        theController.shippingContact.addressLine2='test';
        theController.shippingContact.city='test';
        theController.shippingContact.state = 'CA';
        theController.shippingContact.zipCode = '43430';
        theController.shippingContact.homePhone = 'test';
        theController.shippingContact.workPhone = 'test';
        theController.shippingContact.mobilePhone = 'test';
        theController.shippingContact.faxPhone = 'test';
        theController.shippingContact.theEmail = 'test@something.com';
        theController.shippingContact.emailAddresses = emailAddresses;

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getOrderContactsResponse();
        mock.statusCode=200;

        Test.setMock(HttpCalloutMock.class, mock);

        theController.createContact();


        HttpResponse res = theController.addressService.APIToWrapper.get(IADEditShippingAddressService.POSTCONTACTBYORDERID).theResponse;

        theController.shippingContact.zipCode = '4304';
        theController.createContact();

    }
    @isTest static void testErrorGetShippingContact()
    {
        setupData();

        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.populateShippingAddress();
        theController.processShippingContactResponse();

        theController.addressService.APItoAsync.put(IADEditShippingAddressService.GETCONTACTSBYORDERID, true);

        //Async
        Continuation conti = (continuation)theController.populateShippingAddress();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.addressService.APItoWrapper.get(IADEditShippingAddressService.GETCONTACTSBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(400);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(206);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        theController.addressService.readShippingContactResponse();

        theController.addressService.APItoWrapper.get(IADEditShippingAddressService.GETCONTACTSBYORDERID).responseData = null;
        theController.addressService.readShippingContactResponse();

        try{

            theController.addressService = null;
            theController.populateShippingAddress();

            theController.processShippingContactResponse();
        }
        catch(exception e)
        {

        }
    }


    @isTest static void testErrorPutShippingContact()
    {
        setupData();

        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.updateContact();
        theController.processContactUpdateResponse();

        theController.shippingContact.state = 'CA';
        theController.shippingContact.zipCode = '43430';
        theController.addressService.APItoAsync.put(IADEditShippingAddressService.PUTCONTACTBYORDERID, true);

        //Async
        Continuation conti = (continuation)theController.updateContact();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.addressService.APItoWrapper.get(IADEditShippingAddressService.PUTCONTACTBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(400);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(206);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        theController.addressService.readPutShippingContactResponse();

        theController.addressService.APItoWrapper.get(IADEditShippingAddressService.PUTCONTACTBYORDERID).responseData = null;
        theController.addressService.readPutShippingContactResponse();

        try{

            theController.addressService = null;
            theController.updateContact();

            theController.processContactUpdateResponse();
        }
        catch(exception e)
        {

        }
    }
    @isTest static void testErrorCreateOrderContact()
    {
        setupData();

        PageReference pageRef = Page.IADEditShippingAddressPage;

        pageRef.getParameters().put('id',orders[0].id);

        Test.setCurrentPage(pageRef);

        IADEditShippingAddressController theController = new IADEditShippingAddressController();
        theController.createContact();
        theController.processContactCreateResponse();

        theController.shippingContact.firstName='test';
        theController.shippingContact.lastName='test';
        theController.shippingContact.addressLine1='test';
        theController.shippingContact.addressLine2='test';
        theController.shippingContact.city='test';
        theController.shippingContact.state = 'CA';
        theController.shippingContact.zipCode = '43430';

        List<IADContractBeans.IADShippingContact_Email> emailAddresses = new  List<IADContractBeans.IADShippingContact_Email>();
        IADContractBeans.IADShippingContact_Email theEmail = new IADContractBeans.IADShippingContact_Email();
        theEmail.emailAddress = 'test@something.com';
        emailAddresses.add(theEmail);
        theController.shippingContact.theEmail = 'test@something.com';
        theController.shippingContact.zipCode = '43430';
        theController.shippingContact.homePhone = 'test';
        theController.shippingContact.workPhone = 'test';
        theController.shippingContact.mobilePhone = 'test';
        theController.shippingContact.faxPhone = 'test';
        theController.shippingContact.emailAddresses = emailAddresses;

        theController.addressService.APItoAsync.put(IADEditShippingAddressService.POSTCONTACTBYORDERID, true);

        //Async
        Continuation conti = (continuation)theController.createContact();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.addressService.APItoWrapper.get(IADEditShippingAddressService.POSTCONTACTBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(400);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = IADTestDataUtil.getOrderContactsResponse();
        response.setBody(responseBody);
        response.setStatusCode(206);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        theController.addressService.readCreateOrderContactResponse();

        theController.addressService.APItoWrapper.get(IADEditShippingAddressService.POSTCONTACTBYORDERID).responseData = null;
        theController.addressService.readCreateOrderContactResponse();

        try{

            theController.addressService = null;
            theController.createContact();

            theController.processContactCreateResponse();
        }
        catch(exception e)
        {

        }
    }
}