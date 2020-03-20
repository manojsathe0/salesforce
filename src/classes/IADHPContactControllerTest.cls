@isTest
public class IADHPContactControllerTest
{
    static Order__c testOrder;
    static Contact testContact;
    public static Customer_Login__c customerLogin = new Customer_Login__c();
    static void setupData()
    {
      
       
       Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
       testContact = TestUtils.createContacts(1 , 'LastName' , testAccount.Id , true)[0];
       customerLogin = TestUtils.createCustomerLogins(1 , 'testbb@test.com' ,  false)[0];
       customerLogin.Primary_Contact__c = testContact.Id;
       customerLogin.Customer_ID__c = '11576778';
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
  /*  static testMethod void testLifePlan() {
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
    	
    	
    	IADHighlightsPanelContactController_ltng theController;
       PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testContact.Id));
       Test.setCurrentPage(pageRef);
      
       Test.startTest();
             theController = new IADHighlightsPanelContactController_ltng();//populateContactAndCustomerLogins gets called from constructor
             //Increasing the coverage
             theController.refreshVerifySection();
             theController.refreshPage();
             theController.closeAdvisory();
       Test.stopTest();
    	
    }*/
    static testMethod void testPopulateContactAndCustomerLogins_WithContact()
    {
       
       setupData();
        String contactId = [Select Id from Contact  limit 1][0].Id;
       IADHighlightsPanelContactController_ltng theController;
        
      /* PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testContact.Id));
       Test.setCurrentPage(pageRef); */
        IADHighlightsPanelContactController_ltng.contactId = testContact.Id;
      
       Test.startTest();
      	IADHighlightsPanelContactController_ltng.init(contactId);//populateContactAndCustomerLogins gets called from constructor
       Test.stopTest();
       
      // System.assertEquals(1 , IADHighlightsPanelContactController_ltng.customerLogin.size() , 'Customer Login should have been populated');
       
    }
    
    static testMethod void testPopulateContactAndCustomerLogins_WithOrder()
    {
       
       setupData();
        String orderId = [Select Id from Order__c limit 1][0].Id;
   		
            
       Test.startTest();
            IADHighlightsPanelContactController_ltng.init(orderId); //populateContactAndCustomerLogins gets called from constructor
       Test.stopTest();
       
       System.assertEquals(1 , IADHighlightsPanelContactController_ltng.customerLogin.size() , 'Customer Login should have been populated');
       
    }


    
   /* static testMethod void testGetCurrentAdvisory()
    {
       setupData();
       PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
       pageRef.getParameters().put('id', String.valueOf(testContact.Id));
       testContact.Advisory__c = 'BBB';
       update testContact;
       Test.setCurrentPage(pageRef);
       IADHighlightsPanelContactController_ltng theController =  new  IADHighlightsPanelContactController_ltng();
       Test.startTest();
           String currentAdvisory = IADHighlightsPanelContactController_ltng.currentAdvisory;
           System.assertEquals('BBB', currentAdvisory , 'Current Advisory should have been populated'); 
       Test.stopTest(); 
          
    }*/
    
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
        
        
               /* PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
                pageRef.getParameters().put('id', String.valueOf(testContact.Id));
              
                Test.setCurrentPage(pageRef); */

                IADHighlightsPanelContactController_ltng theController = new IADHighlightsPanelContactController_ltng(); 
                IADHighlightsPanelContactController_ltng.contactId = testContact.Id;
            	IADHighlightsPanelContactController_ltng.verifiedHours=integer.valueOf( UtilityLibrary.getConfig().Contact_Highlights_Panel_Hours_Threshold__c);
           		IADHighlightsPanelContactController_ltng.populateContactAndCustomerLogins(testContact.Id);
                Test.startTest(); 
                    isCustomerVerified = IADHighlightsPanelContactController_ltng.isCustomerVerified;
                Test.stopTest();
              
        
        }
        List<Task> createdTasks = [SELECT Id , Is_Customer_Verified__c , Date_Time_Customer_Verification__c FROM Task WHERE WhoId =:testContact.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
        System.assertEquals(true , isCustomerVerified , 'Customer Verified should be true');

    }
    
   /* static testMethod void testupdateAdv()
    {
        setupData();
        IADHighlightsPanelContactController_ltng theController;
        PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
        pageRef.getParameters().put('id', String.valueOf(testContact.Id));
        Test.setCurrentPage(pageRef);
        theController = new IADHighlightsPanelContactController_ltng();
        IADHighlightsPanelContactController_ltng.contacts[0].Advisory__c = 'VIP';
        Test.startTest();
            theController.updateAdv();
        Test.stopTest();

        Contact queriedContact = [SELECT Id , Advisory__c FROM Contact WHERE Id = :testContact.Id limit 1];
        System.assertEquals('VIP' , queriedContact.Advisory__c , 'Advisory should have been updated');
        
    }*/
    
   /* static testMethod void testPopulateCustomerAsync()
    {
        IADHighlightsPanelContactController_ltng theController = new IADHighlightsPanelContactController_ltng();
        IADHighlightsPanelContactController_ltng.customerId = '11576778';
        //Continuation conti = (continuation)theController.populateCustomer();
       
        Map<String, HttpRequest> requests = IADHighlightsPanelContactController_ltng.populateCustomer().getRequests();
       //System.assert(requests.size() == 1);
        //System.assert(requests.get(theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService.GETCUSTOMERBYCUSTOMERID).requestLabelContinuation) != null);
        
        HttpResponse response = new HttpResponse();
        String responseBody = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        response.setBody(responseBody); 
        response.setStatusCode(200);
             
        Test.setContinuationResponse(theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID).requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(responseBody, theController.contactService.APIToWrapper.get(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID).responseData);
              
        
    }*/
    static testMethod void testPopulateCustomerSync()
    {
        IADHighlightsPanelContactController_ltng  theController = new IADHighlightsPanelContactController_ltng();
        IADHighlightsPanelContactController_ltng.customerId = '11576778';
        IADHighlightsPanelContactService_ltng service = new IADHighlightsPanelContactService_ltng();
        //IADServiceBase_ltng.APItoAsync.put(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        mock.statusCode=200;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
        	IADServiceBase_ltng.initWrapper('GetCustomerByCustomerId');
        	APIRequestResponseWrapper_ltng apiResponse = new APIRequestResponseWrapper_ltng();
        	apiResponse.responseData = '{"customerInfo":{"uuid":"68124eeb-48bc-488f-8cbe-937a695410ca","customerId":10970999,"loginUsername":"ymasu@legalzoom.com"},"contactInfo":{"userContactInfoId":13117879,"customerId":10970999,"description":"Created from Salesforce","firstName":"llc","lastName":"contact","addressLine1":"fdgsg","addressLine2":"","city":"sdfsf","stateId":19,"county":null,"zipcode":"78613","email1":"ymasu@legalzoom.com","email2":null,"email3":null,"homePhone":"(512) 118-8110","workPhone":"","cellPhone":null,"fax":null,"country":0,"state":null,"taxID":null,"active":1,"statusChanged":"2018-01-11T10:46:26Z","statusChangedBy":null,"crmContactId":null,"contactInfoType":1,"updateSource":null,"stateFullName":null,"abbr":null,"existingContact":false,"contactCreated":false,"contactUpdated":false,"message":""},"accountInfo":{"customerManager":null,"status":null,"memberSinceDate":null},"securityQuestion":{"questionId":0,"question":null,"answer":null},"thirdPartyUserInfo":[{"userId":10970999,"thirdPartyId":"3029397","thirdPartyTypeId":1,"createdBy":"10970999","hasLifePlan":false}],"groupPlanClientConfig":null}';
        	apiResponse.statusCode = '200';
        	IADServiceBase_ltng.APItoWrapper.put('GetCustomerByCustomerId', apiResponse);
        	IADHighlightsPanelContactService_ltng.populateCustomer();
        Test.stopTest();    
        //IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID);
        //HttpResponse res = IADServiceBase_ltng.APIToWrapper.get(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID).theResponse;
       //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json' , 'Right Content Type Should be populated');
        //String actualValue = res.getBody();
        //String expectedValue = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        //System.assertEquals(actualValue, expectedValue , 'Right response should have been populated');
       // System.assertEquals(200, res.getStatusCode() , 'Right status code should have been populated');
        
    }
    static testMethod void testPopulateCustomerSyncFail()
    {
        IADHighlightsPanelContactController_ltng  theController = new IADHighlightsPanelContactController_ltng();
        IADHighlightsPanelContactController_ltng.customerId = '11576778';
        IADHighlightsPanelContactService_ltng service = new IADHighlightsPanelContactService_ltng();
        //IADServiceBase_ltng.APItoAsync.put(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        mock.statusCode=200;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
        	IADServiceBase_ltng.initWrapper('GetCustomerByCustomerId');
        	APIRequestResponseWrapper_ltng apiResponse = new APIRequestResponseWrapper_ltng();
        	apiResponse.responseData = null;
        	apiResponse.statusCode = '401';
        	IADServiceBase_ltng.APItoWrapper.put('GetCustomerByCustomerId', apiResponse);
        	IADHighlightsPanelContactService_ltng.populateCustomer(); 
            IADServiceBase_ltng.populateSuccessMessage('Success');
            IADServiceBase_ltng.populateErrorMessage('Error');
            IADServiceBase_ltng.populateErrorMessage(new IADException());
        	try
            {
                Integer i = 1/0;
            }
            catch(Exception e)
            {
                IADServiceBase_ltng.populateErrorMessage(e);
        	}
            IADServiceBase_ltng.populateNullErrorMessage(new APIRequestResponseWrapper_ltng());
        	service.addMessages(new List<IADMessage_ltng>(), 1);
        	IADMessageFactory_ltng.clearMessage();
        	//IADServiceBase_ltng.clearMessages();
        	//service.getErrorCount();
        Test.stopTest();    
        //IADServiceBase_ltng.initWrapper(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID);
        //HttpResponse res = IADServiceBase_ltng.APIToWrapper.get(IADHighlightsPanelContactService_ltng.GETCUSTOMERBYCUSTOMERID).theResponse;
       //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json' , 'Right Content Type Should be populated');
        //String actualValue = res.getBody();
        //String expectedValue = '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
        //System.assertEquals(actualValue, expectedValue , 'Right response should have been populated');
       // System.assertEquals(200, res.getStatusCode() , 'Right status code should have been populated');
        
    }
    
    
   /* static testMethod void testResetPasswordAsync()
    {
        
          setupData();
          PageReference pageRef = Page.IADHighlightsPanelPrimaryContactPage;
          pageRef.getParameters().put('id', String.valueOf(testOrder.Id));
          Test.setCurrentPage(pageRef);

          IADHighlightsPanelContactController_ltng theController = new IADHighlightsPanelContactController_ltng();
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
          
    }*/

    /*static testMethod void testResetPasswordFlag()
    {
       IADHighlightsPanelContactController_ltng theController = new IADHighlightsPanelContactController_ltng();
       Test.startTest();
          theController.resetPasswordFlag();
       Test.stopTest();
       System.assert(!theController.passwordReset , 'Flag set be set to false');
    }*/



}