@istest
public class IADStoreCreditTest_ltng {
    @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];
        
        system.runAs(u)
        {
            
            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;
            
            Order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
        
    }
    
    @isTest static void testGetStoreCredit()
    {
        setupData();
        Order__c order1 = [select id from Order__c where name = '1234' limit 1];
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  IADTestDataUtil_ltng.getInstallmentResponse();
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADStoreCreditController_ltng.populateStoreCredit('1234');
        Test.stopTest();
        
    }
    
    @isTest static void testGetStoreCrediterror()
    {
        setupData();
        
        Order__c order1 = [select id from Order__c where name = '1234' limit 1];
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getStoreCreditDetail();
        mock.statusCode = 500;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADStoreCreditController_ltng.customerId='123';
        IADStoreCreditController_ltng.populateStoreCredit('');
        Test.stopTest();
    }
    
    @isTest static void testGetStoreCreditPositiveCase()
    {
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getStoreCreditDetail();
        mock.statusCode = 200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADStoreCreditController_ltng.customerId='123';
        IADStoreCreditController_ltng.populateStoreCredit('39943');
        Test.stopTest();
    }

    /* STORY B-39093 - Changes Starts Here */
    
    @testSetup private static void setupTestData() {
        // Create Admin User
        TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
    }
    
	@isTest private static void sendRefundStoreCreditUpdateTest1(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                //mock.testBody = '{"transactionId":123455,"isStoreCreditRefund": true,"updatedBy": "string","transactionStatus": "pending","reasonCode": "string","reasonText": "string"}';
                mock.testBody =  '{"isSuccess": true}';
            	mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADStoreCreditController_ltng.sendRefundStoreCreditUpdate('123455','pending','1','test1');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundStoreCreditUpdateTest2(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                //mock.testBody = '{"transactionId":123455,"isStoreCreditRefund": true,"updatedBy": "string","transactionStatus": "approved","reasonCode": "string","reasonText": "string"}';
                mock.testBody =  '{"isSuccess": false}';
            	mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADStoreCreditController_ltng.sendRefundStoreCreditUpdate('123455','pending','1','test1');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundStoreCreditUpdateTest3(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody = '';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADStoreCreditController_ltng.sendRefundStoreCreditUpdate('123455','pending','1','test1');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    } 
    
    @isTest private static void sendRefundStoreCreditUpdateTest4(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody ='{"errors":[{"code":"Could not Update Payment status of already Approved/Declined transaction","message":null}]}';
                mock.statusCode=400;
                Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADStoreCreditController_ltng.sendRefundStoreCreditUpdate('123455','pending','1','test1');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundStoreCreditUpdateTest5(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
        		resp = IADStoreCreditController_ltng.sendRefundStoreCreditUpdate('123455','','1','test1');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void  isFinanceUserTest(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'System Administrator' And IsActive=true LIMIT 1];
        boolean resp;
        system.runAs(u){
            Test.startTest();
        		resp = IADStoreCreditController_ltng.isFinanceUser();   
            Test.stopTest();
            system.assert(resp!=null);
        }
    }
    /* STORY B-39093 - Changes Ends Here */
}