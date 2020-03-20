@isTest
public class IADHighlightsPanelContactControllerTest
{
    static Order__c testOrder;
    static Contact testContact;
    static void setupData()
    {
       
       Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
       testContact = TestUtils.createContacts(1 , 'LastName' , testAccount.Id , true)[0];
       Customer_Login__c customerLogin = TestUtils.createCustomerLogins(1 , 'testbb@test.com' ,  false)[0];
       customerLogin.Primary_Contact__c = testContact.Id;
       insert customerLogin;
       
       testOrder = TestUtils.createOrders(1 , null , false)[0];
       testOrder.Contact__c = testContact.Id;
       insert testOrder;
       
        
    }
    
    /*
        	Story: B-24345
        	By Artyom M.
        	Displaying Comnpany specific messages of lifeplan csutumers.
      */
    static testMethod void testLifePlan() {
    	setupData();
    	Account testAccount = TestUtils.createAccounts(1 , 'Test Account 2' , false)[0];
    	testAccount.Life_Plan__c = true;
    	testAccount.Life_Plan_Company__c = 'Test Company';
    	LifePlanClientSettings__c companyCS = new LifePlanClientSettings__c();
    	companyCS.Name = 'Test Company';
    	companyCS.Alert_Message__c = 'Test Message';
    	insert companyCS;
    	insert testAccount;
    	testContact.AccountID = testAccount.Id;
    	update testContact;
    	
    	
    	IADHighlightsPanelContactController theController;
       PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testContact.Id));
       Test.setCurrentPage(pageRef);
      
       Test.startTest();
             theController = new IADHighlightsPanelContactController();//populateContactAndCustomerLogins gets called from constructor
             //Increasing the coverage
             theController.refreshVerifySection();
             theController.refreshPage();
             theController.closeAdvisory();
       Test.stopTest();
    	
    }
    static testMethod void testPopulateContactAndCustomerLogins_WithContact()
    {
       
       setupData();
       IADHighlightsPanelContactController theController;
       PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testContact.Id));
       Test.setCurrentPage(pageRef);
      
       Test.startTest();
             theController = new IADHighlightsPanelContactController();//populateContactAndCustomerLogins gets called from constructor
       Test.stopTest();
       
       System.assertEquals(1 , theController.customerLogin.size() , 'Customer Login should have been populated');
       
    }
    
    static testMethod void testPopulateContactAndCustomerLogins_WithOrder()
    {
       
       setupData();
       IADHighlightsPanelContactController theController;
       PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testOrder.Id));
       Test.setCurrentPage(pageRef);
            
       Test.startTest();
             theController = new IADHighlightsPanelContactController(); //populateContactAndCustomerLogins gets called from constructor
       Test.stopTest();
       
       System.assertEquals(1 , theController.customerLogin.size() , 'Customer Login should have been populated');
       
    }


    
    static testMethod void testGetCurrentAdvisory()
    {
       setupData();
       PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testContact.Id));
       testContact.Advisory__c = 'BBB';
       update testContact;
       Test.setCurrentPage(pageRef);
       IADHighlightsPanelContactController theController =  new  IADHighlightsPanelContactController();
       Test.startTest();
           String currentAdvisory = theController.currentAdvisory;
           System.assertEquals('BBB', currentAdvisory , 'Current Advisory should have been populated'); 
       Test.stopTest(); 
          
    }
    
    static testMethod void testIsCustomerVerified()
    {
        setupData();
        testContact.Genesys_Interaction_Id__c = '998899';
        update testContact;
        
        Task theTask = new Task();
        theTask.WhoId = testContact.Id;
        theTask.Description = 'Test Description';
        theTask.CallObject = '998899';
        insert theTask;
                
                               
        User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , true);
        
        Boolean isCustomerVerified;
        System.runAs(theUser)
        {
                theTask.Is_Customer_Verified__c = true;
                update theTask;
        
        
                PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
                pageRef.getParameters().put('id', String.valueOf(testContact.Id));
              
                Test.setCurrentPage(pageRef);

                IADHighlightsPanelContactController theController = new IADHighlightsPanelContactController(); 
                
                Test.startTest(); 
                    isCustomerVerified = theController.isCustomerVerified;
                Test.stopTest();
              
        
        }
        List<Task> createdTasks = [SELECT Id , Is_Customer_Verified__c , Date_Time_Customer_Verification__c FROM Task WHERE WhoId =:testContact.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
        System.assertEquals(true , isCustomerVerified , 'Customer Verified should be true');

    }
    
    static testMethod void testupdateAdv()
    {
        setupData();
        IADHighlightsPanelContactController theController;
        PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
        pageRef.getParameters().put('id', String.valueOf(testContact.Id));
        Test.setCurrentPage(pageRef);
        theController = new IADHighlightsPanelContactController();
        theController.contacts[0].Advisory__c = 'VIP';
        Test.startTest();
            theController.updateAdv();
        Test.stopTest();

        Contact queriedContact = [SELECT Id , Advisory__c FROM Contact WHERE Id = :testContact.Id limit 1];
        System.assertEquals('VIP' , queriedContact.Advisory__c , 'Advisory should have been updated');
        
    }
    
    static testMethod void testPopulateCustomerAsync()
    {
        IADHighlightsPanelContactController theController = new IADHighlightsPanelContactController();
        theController.customerId = '11576778';
        Continuation conti = (continuation)theController.populateCustomer();
       
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        System.assert(requests.get(theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID).requestLabelContinuation) != null);
        
        HttpResponse response = new HttpResponse();
        String responseBody = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        response.setBody(responseBody); 
        response.setStatusCode(200);
             
        Test.setContinuationResponse(theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID).requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(responseBody, theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID).responseData);
              
        
    }
    static testMethod void testPopulateCustomerSync()
    {
        IADHighlightsPanelContactController  theController = new IADHighlightsPanelContactController();
        theController.customerId = '11576778';
        theController.contactService.APItoAsync.put(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        mock.statusCode=200;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
            theController.populateCustomer();
        Test.stopTest();    
        
        HttpResponse res = theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID).theResponse;
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json' , 'Right Content Type Should be populated');
        String actualValue = res.getBody();
        String expectedValue = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        System.assertEquals(actualValue, expectedValue , 'Right response should have been populated');
        System.assertEquals(200, res.getStatusCode() , 'Right status code should have been populated');
        
    }
    
    static testMethod void testResetPasswordAsync()
    {
        
          setupData();
          PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
          pageRef.getParameters().put('id', String.valueOf(testOrder.Id));
          Test.setCurrentPage(pageRef);

          IADHighlightsPanelContactController theController = new IADHighlightsPanelContactController();
          Continuation conti = (continuation)theController.resetPassword();
         
          Map<String, HttpRequest> requests = conti.getRequests();
          System.assert(requests.size() == 1);
          System.assert(requests.get(theController.contactManagerService.APIToWrapper.get(IADContactManagerService.RESETPASSWORD).requestLabelContinuation) != null);
          
          HttpResponse response = new HttpResponse();
          String responseBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
          response.setBody(responseBody); 
          response.setStatusCode(200);
          Test.startTest();       
              Test.setContinuationResponse(theController.contactManagerService.APIToWrapper.get(IADContactManagerService.RESETPASSWORD).requestLabelContinuation, response);
              Object result = Test.invokeContinuationMethod(theController, conti);
              System.assertEquals(null, result);
              System.assertEquals(responseBody, theController.contactManagerService.APIToWrapper.get(IADContactManagerService.RESETPASSWORD).responseData);
          Test.stopTest();      
          
    }

    static testMethod void testResetPasswordFlag()
    {
       IADHighlightsPanelContactController theController = new IADHighlightsPanelContactController();
       Test.startTest();
          theController.resetPasswordFlag();
       Test.stopTest();
       System.assert(!theController.passwordReset , 'Flag set be set to false');
    }



}