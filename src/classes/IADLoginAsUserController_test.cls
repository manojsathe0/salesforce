@istest

 public class IADLoginAsUserController_test{
 
 static testmethod void testLoginAsLead()
 {
       Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
       contact testContact = TestUtils.createContacts(1 , 'LastName' , testAccount.Id , true)[0];
       Customer_Login__c customerLogin = TestUtils.createCustomerLogins(1 , 'testbb@test.com' ,  false)[0];
       customerLogin.Primary_Contact__c = testContact.Id;
        
       insert customerLogin;
       
      order__c testOrder = TestUtils.createOrders(1 , null , false)[0];
       testOrder.Contact__c = testContact.Id;
       insert testOrder;
       List<Lead> testLeads = TestUtils.createLeads(1 , 'Johnson', false);
       insert testleads[0];
    IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"requestPasswordMessage": {"status": "20","message": "Request Password Sent"}}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);  
          
          Test.startTest();    
IADLoginAsUserController.LoginUser(testleads[0].id);
 test.stoptest();
 
 }
 
 @isTest static void testresetpassword()
    {
        
        
        
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
       contact testContact = TestUtils.createContacts(1 , 'LastName' , testAccount.Id , true)[0];
       Customer_Login__c customerLogin = TestUtils.createCustomerLogins(1 , 'testbb@test.com' ,  false)[0];
       customerLogin.Primary_Contact__c = testContact.Id;
        
       insert customerLogin;
       
      order__c testOrder = TestUtils.createOrders(1 , null , false)[0];
       testOrder.Contact__c = testContact.Id;
       insert testOrder;
       List<Lead> testLeads = TestUtils.createLeads(1 , 'Johnson', false);
       insert testleads[0];
        String responseBody = IADTestDataUtil.createContactResponse();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postResetPasswordResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
    test.starttest();
        IADLoginAsUserController.ResetPassword(testleads[0].id);
        test.stoptest();
        
       
 
    } 

}