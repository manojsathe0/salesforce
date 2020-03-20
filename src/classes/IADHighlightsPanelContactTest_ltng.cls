@istest
public  class IADHighlightsPanelContactTest_ltng
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
    
    static testMethod void testPopulateContactAndCustomerLogins_WithContact()
    {
       
       setupData();
       IADHighlightsPanelContactController theController;
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  '{"securityQuestion": {"questionId": 20,"question": "What was the first street you lived on?","answer": "78613"},"thirdPartyUserInfo": [{"userId": 11591237,"thirdPartyId": "341338014","thirdPartyTypeId": 8,"createdBy": "CustomerBoxAccountProvision"}]}';
      
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock); 
       
       Test.startTest();
             IADHighlightsPanelContactController_ltng.init(testContact.id);//populateContactAndCustomerLogins gets called from constructor
       Test.stopTest();
       
      
       
    }
    
    static testMethod void testPopulateContactAndCustomerLogins_WithOrder()
    {
       
       setupData();
       IADHighlightsPanelContactController theController;
      
            
       Test.startTest();
       IADHighlightsPanelContactController_ltng.init(testOrder.id);
            //populateContactAndCustomerLogins gets called from constructor
       Test.stopTest();
       
      
       
    }

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
      
      
      
      
       Test.startTest();
             //populateContactAndCustomerLogins gets called from constructor
             IADHighlightsPanelContactController_ltng.init(testContact.id);
             
       Test.stopTest();
      
    }

    
    static testMethod void testGetCurrentAdvisory()
    {
       setupData();
       
       testContact.Advisory__c = 'BBB';
       update testContact;
       
       Test.startTest();
          IADHighlightsPanelContactController_ltng.updateAdv(testcontact.id,'1234');
       Test.stopTest(); 
          
    }
    

 static testMethod void testGetCustomerTagsPositive(){
       
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADHighlightsPanelContactController_ltng.getCustomerTags('12345');
    }
    
    
    
    static testMethod void testDeleteOrderTagsPositive(){
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADHighlightsPanelContactController_ltng.deleteCustomerTags('tag1', '32546240');
    }
    
     static testMethod void testCreateOrderTagsPositive(){
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.createOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADHighlightsPanelContactController_ltng.createCustomerTags( 'tag1', '32546240');
    }
    
     static testMethod void testResetPasswordAsync()
    {
        
          IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);  
          
          Test.startTest();       
              IADHighlightsPanelContactController_ltng.resetPassword('testemail');
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
        
         boolean verify ;
         IADHighlightsPanelContactController_ltng.init(testOrder.id);
                IADHighlightsPanelContactController_ltng contactcontroller = new IADHighlightsPanelContactController_ltng();

                Test.startTest(); 
                   verify= contactcontroller.isCustomerVerified;
                Test.stopTest();
              
        
        }
        }
        
        
        static testMethod void testGetCustomerTagsnegative(){
       
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderTagResponse();
        mock.statusCode=500;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADHighlightsPanelContactController_ltng.getCustomerTags('');
    }
    
    
    
    static testMethod void testDeleteOrderTagsnegative(){
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=500;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADHighlightsPanelContactController_ltng.deleteCustomerTags('', '32546240');
    }
    
     static testMethod void testCreateOrderTagsnegative(){
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.createOrderTagResponse();
        mock.statusCode=500;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADHighlightsPanelContactController_ltng.createCustomerTags( '', '32546240');
    }
    
     static testMethod void testResetPasswordAsyncegative()
    {
        
          IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
        mock.statusCode=500;
        Test.setMock(HttpCalloutMock.class, mock);  
          
          Test.startTest();       
              IADHighlightsPanelContactController_ltng.resetPassword('');
          Test.stopTest();      
          
    }
    
    static testMethod void postLoginTokenTest()
    {
        setupData();
        
          IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);  
          
          Test.startTest();       
              IADHighlightsPanelContactController_ltng.postLoginToken('123456');
          Test.stopTest();      
          
    }
    static testMethod void deleteAuthContactTest()
    {
        setupData();
        
          IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);  
          
          Test.startTest();       
              IADHighlightsPanelContactController_ltng.deleteAuthorizedContact('123456', '2122222', '22212');
          Test.stopTest();      
          
    }
       static testMethod void testPopulateSubscriptionsiconspositive()
    {
        setupData();
        Test.startTest();
         IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();   
        IADHighlightsPanelContactService_ltng service = new IADHighlightsPanelContactService_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADHighlightsPanelContactController_ltng.getCustomerSubIcons ( '1234'); 
        IADHighlightsPanelContactController_ltng.hasboxaccount=false;
        IADHighlightsPanelContactController_ltng.boxid='123';
        IADHighlightsPanelContactController_ltng.userid='123';
        IADHighlightsPanelContactController_ltng.appid='123';
        IADHighlightsPanelContactController_ltng.oauthtoken='123';
        Test.stopTest();
    }  
    
     static testMethod void testPopulateSubscriptionsnegative()
    {
        setupData();
        Test.startTest();
         IADHighlightsPanelContactController_ltng ctrlRef = new IADHighlightsPanelContactController_ltng();   
        IADHighlightsPanelContactService_ltng service = new IADHighlightsPanelContactService_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADHighlightsPanelContactController_ltng.getCustomerSubIcons ( ''); 
        
        
        Test.stopTest();
    }  
    
     static testMethod void deleteAuthContactTestNegative()
    {
        setupData();
        
          IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);  
          
          Test.startTest();       
              IADHighlightsPanelContactController_ltng.deleteAuthorizedContact('123456', '', '22212');
          Test.stopTest();      
          
    }
}