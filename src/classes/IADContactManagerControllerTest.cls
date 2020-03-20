@isTest
private class IADContactManagerControllerTest {
    public static Customer_Login__c customer = new Customer_Login__c();
    public static Contact theContact;
    public static Account theAccount;
    public static List<StatesMap__c> stateMap= new List<StatesMap__c>();

    
    public static void setupData()
    {
        StatesMap__c state1 = new StatesMap__c(Name = 'Texas', State_Code__c = 'TX', State_Id__c = 34);
        stateMap.add(state1);
        insert stateMap;

        theAccount = TestUtils.createAccounts(1,'TestAccount', True)[0];
        theContact = buildContactData('Primary Contact' , 'Test@test.com','9998887898',  '123 down street' , '#9900' , 'Austin' , 'TX' , '78717' , '7778889999' , '4445556666' , '1114447777');
        theContact .FkUser__c = '9999999';
        theContact.LegalZoom_Contact_ID__c = '99999991';
        insert theContact;

        customer.Name = 'loginEmail@legalzoom.com';
        customer.Customer_ID__c = '9999999';
        customer.Primary_COntact__c = theContact.Id;
        insert customer;
        
        External_Endpoint__c newEndPoint = new External_Endpoint__c();
        newEndPoint.Name = UserInfo.getUserName().substring(UserInfo.getUserName().lastIndexOf('.')+1 , UserInfo.getUserName().length());
        newEndPoint.Access_Key__c = 'test@123';
        newEndPoint.Api_Endpoint_URL__c = 'http://www.legalzoom.com/';
        newEndPoint.Secret_key__c = 'testClass@123';
        newEndPoint.Notepad_URL__c = 'http://www.legalzoom.com/';
        insert newEndpoint;
        
    }

    public static contact buildContactData(String type, String emial, String phone, String street, String address2, String city, String state, String zip, String mobile, String homePhone, String otherPhone )
    {
        Contact buildContact =TestUtils.createContacts(1, 'TestContact', theAccount.Id, false)[0];
        buildContact.Contact_Type__c = type;
        buildContact.Email = emial;
        buildContact.Phone = phone;
        buildContact.MailingStreet = street;
        buildContact.Address_2__c = address2;
        buildContact.MailingCity = city;
        buildContact.MailingState = state; 
        buildContact.MailingPostalCode = zip;
        buildContact.MobilePhone = mobile;
        buildContact.HomePhone = homePhone;
        buildContact.OtherPhone = otherPhone;
        return buildContact;
    }

    public static Id insertAuthorizedContact()
    {
        theAccount = TestUtils.createAccounts(1,'TestAccount2', True)[0];
        Contact newContact = buildContactData('Authorized Contact' , 'Test2ndAuth@test.com','5552228888',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '6665554444' , '9995550000' , '0001110000');
        insert newContact;
        return newContact.Id;
    }

    @isTest static void testInsertNewContactAsync()
    {
        setupData();
        PageReference pageRef = Page.IADContactManager;
        Contact newContact = buildContactData('Authorized Contact' , 'Test2ndAuth@test.com','5552228888',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '6665554444' , '9995550000' , '0001110000');
        newContact.MailingState = 'Texas'; 
        insert newContact;
        pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        
        IADContactManagerController theController = new IADContactManagerController();
        theController.contactManagerService.APItoAsync.put(IADContactManagerService.CONTACTINSERT, true);
        theController.newContact =  newContact;
        
        
        //Async
        Continuation conti = (continuation)theController.createNewContact();
        
        Map<String, HttpRequest> requests = conti.getRequests();
        //Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.contactManagerService.APItoWrapper.get(IADContactManagerService.CONTACTINSERT);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);
        
        // Perform mock callout 
        // (i.e. skip the callout and call the callback method)
        
        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.createContactResponse();
        response.setBody(responseBody); 
        response.setStatusCode(201);
        system.debug('responseBody-----'+responseBody);  
        // Set the fake response for the continuation     
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        

    } 
    @isTest static void testInsertNewContactSync()
    {
        setupData();
        PageReference pageRef = Page.IADContactManager;
        Contact newContact = buildContactData('Authorized Contact' , 'Test2ndAuth@test.com','5552228888',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '6665554444' , '9995550000' , '0001110000');
        newContact.MailingState = 'Texas'; 
        insert newContact;
        pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        
        IADContactManagerController theController = new IADContactManagerController();
        theController.newContact =  newContact;
        
        
        //Async
       
        theController.contactManagerService.APItoAsync.put(IADContactManagerService.CONTACTINSERT, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.createContactResponse();
        mock.statusCode=201;
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        theController.createNewContact();
    
        
        HttpResponse res = theController.contactManagerService.APIToWrapper.get(IADContactManagerService.CONTACTINSERT).theResponse;
    }
     @isTest static void testUpdateExistingContactAsync()
    {
        setupData();
        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',theContact.Id);
        pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        
        IADContactManagerController theController = new IADContactManagerController();
        theController.contactManagerService.APItoAsync.put(IADContactManagerService.CONTACTUPDATE, true);
        theController.newContact.MailingStreet = '1234 main street';
        
        //Async
        Continuation conti = (continuation)theController.updateContact();
        
        Map<String, HttpRequest> requests = conti.getRequests();
        //Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.contactManagerService.APItoWrapper.get(IADContactManagerService.CONTACTUPDATE);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);
        
        // Perform mock callout 
        // (i.e. skip the callout and call the callback method)
        
        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.putContactUpdateResponse();
        response.setBody(responseBody); 
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);  
        // Set the fake response for the continuation     
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        // Verify that the controller's result variable
        //   is set to the mock response.
        //apiresponse = theController.contactManagerService.APItoWrapper.get(IADContactManagerService.CONTACTUPDATE);
        //System.assertEquals(responseBody , apiresponse.responseData, 'Right response should have been returned');
        
        
        theController.contactManagerService.APItoAsync.put(IADContactManagerService.CONTACTUPDATE, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.putContactUpdateResponse();
        mock.statusCode=200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        theController.updateContact();
    
        
        HttpResponse res = theController.contactManagerService.APIToWrapper.get(IADContactManagerService.CONTACTUPDATE).theResponse;

    }
    @isTest static void testUpdateExistingContactSync()
    {
        setupData();
        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',theContact.Id);
         pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        
        IADContactManagerController theController = new IADContactManagerController();
        theController.newContact.MailingStreet = '1234 main street';
        theController.contactManagerService.APItoAsync.put(IADContactManagerService.CONTACTUPDATE, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.putContactUpdateResponse();
        mock.statusCode=200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        theController.updateContact();
    
        
        HttpResponse res = theController.contactManagerService.APIToWrapper.get(IADContactManagerService.CONTACTUPDATE).theResponse;
        
        
    }

     @isTest static void testPasswordReset()
    {
        setupData();
        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',theContact.Id);
         pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        
        IADContactManagerController theController = new IADContactManagerController();
        theController.contactManagerService.APItoAsync.put(IADContactManagerService.RESETPASSWORD, true);
        
        //Async
        Continuation conti = (continuation)theController.resetPassword();
        
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.contactManagerService.APItoWrapper.get(IADContactManagerService.RESETPASSWORD);
        System.assert(requests.get(apiresponse.requestLabelContinuation) != null);
        
        
        // Perform mock callout 
        // (i.e. skip the callout and call the callback method)
        
        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.postResetPasswordResponse();
        response.setBody(responseBody); 
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);  
        // Set the fake response for the continuation     
        apiresponse = theController.contactManagerService.APItoWrapper.get(IADContactManagerService.RESETPASSWORD);
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        // Verify that the controller's result variable
        //   is set to the mock response.
        
        System.assertEquals(responseBody , apiresponse.responseData, 'Right response should have been returned');
        
        
        theController.contactManagerService.apiToAsync.put(IADContactManagerService.RESETPASSWORD, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.postResetPasswordResponse();
        mock.statusCode=200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        theController.resetPassword();
    
        
        HttpResponse res = theController.contactManagerService.APIToWrapper.get(IADContactManagerService.RESETPASSWORD).theResponse;

    }


    @isTest static void testupdateAuthToPrimaryContact()
    {
        setupData();
        string contactId = insertAuthorizedContact();

        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',contactId);
         pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
            IADContactManagerController theController = new IADContactManagerController();
            theController.contactManagerService.apiToAsync.put(IADContactManagerService.CONTACTUPDATE, true);
            theController.newContact.Contact_Type__c = 'Primary Contact';
            theController.newContact.LastName = 'Changed LastName';
            theController.newContact.FkUser__c = '9999999';
            theController.contactType = IADContactManagerController.AUTHORIZED_CONTACT;
        Continuation conti = (continuation)theController.updateContact();
        
    }

    @isTest static void testupdateOrderAuthorizedContact()
    {
        setupData();
        string contactId = insertAuthorizedContact();
        Contact orderContact = new Contact(Id = contactId);
        orderContact.Lz_Order_Contact_Id__c = '99889988';
        update orderContact;

        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',contactId);
        pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        Test.startTest();
            IADContactManagerController contactManager = new IADContactManagerController();
            contactManager.newContact.Contact_Type__c = 'Primary Contact';
            contactManager.newContact.LastName = 'Changed LastName';
            contactManager.updateContact();
        Test.stopTest();

        for(ApexPages.Message msg :  ApexPages.getMessages()) 
        {
            System.assertEquals('Order authorized contacts cannot be edited.', msg.getSummary());
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        }

    }

    @isTest static void testFiedSet()
    {
        setupData();
        string contactId = insertAuthorizedContact();

        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',contactId);
         pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);
        Test.setCurrentPage(pageRef);
        IADContactManagerController contactManager = new IADContactManagerController();
        List<Schema.FieldSetMember> fields = contactManager.getFields();

        system.assertNotEquals(fields.size(), 0);
    }

    //testing the individial method
    @isTest static void testErrors()
    {
        setupData();
        string contactId = insertAuthorizedContact();
        Contact orderContact = new Contact(Id = contactId);
        orderContact.Lz_Order_Contact_Id__c = '99889988';
        update orderContact;

        PageReference pageRef = Page.IADContactManager;
        pageRef.getParameters().put('Id',contactId);

        Test.setCurrentPage(pageRef);
        Test.startTest();
            IADContactManagerController contactManager = new IADContactManagerController();
            contactManager.newContact = null;
            contactManager.processContactInsertResponse();
            contactManager.processResetPasswordResponse();
            contactManager.updateContact();
            contactManager.createNewContact();
            contactManager.resetPassword();
        Test.stopTest();

    }

}