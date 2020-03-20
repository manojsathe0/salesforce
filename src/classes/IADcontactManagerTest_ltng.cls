@istest
public class IADcontactManagerTest_ltng
{

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
    
    @isTest static void testInsertNewContactAsync()
    {
        setupData();
        
        
        
        String responseBody = IADTestDataUtil.createContactResponse();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.createContactResponse();
        mock.statusCode=201;
        Test.setMock(HttpCalloutMock.class, mock);
        
        
          test.starttest();
        IADContactManagerController_ltng.createNewcontact('123',theContact);
        test.stoptest();

    } 
    
   
@isTest static void testupdateNewContactAsync()
    {
        setupData();
        
        
        
        String responseBody = IADTestDataUtil.createContactResponse();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.putContactUpdateResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        test.starttest();

        IADContactManagerController_ltng.updateContact(theContact,'123','123' ,false);
        test.stoptest();
 
    } 
    
     @isTest static void testresetpassword()
    {
        setupData();
        
        
        
        String responseBody = IADTestDataUtil.createContactResponse();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postResetPasswordResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADContactManagerController_ltng.init(theContact.id);
        test.starttest();
        IADContactManagerController_ltng.resetPassword('123');
        test.stoptest();
        
       
 
    } 
    static testMethod void testresetpasswordwithError(){
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postResetPasswordResponse();
        mock.statusCode=500;
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        
        
        try
            {
                 IADContactManagerController_ltng.resetPassword('32546240');
                
                Integer i = 1/0;
            }
            catch(Exception e)
            {
                IADServiceBase_ltng.populateErrorMessage(e);
            }
        Test.stopTest();
    }
    @isTest static void testupdateNewContactAsyncITP()
    {
        setupData();
        
        
        
        String responseBody = IADTestDataUtil.createContactResponse();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.putContactUpdateResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        test.starttest();

        IADContactManagerController_ltng.updateContact(theContact,'123','123' ,true);
        test.stoptest();
 
    } 
    @isTest static void testupdateNewContactAsyncnegative()
    {
        setupData();
        
        
        
        String responseBody = IADTestDataUtil.createContactResponse();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.putContactUpdateResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        test.starttest();

        IADContactManagerController_ltng.updateContact(null,'123','123' ,true);
        test.stoptest();
 
    } 


}