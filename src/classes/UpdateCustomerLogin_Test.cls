/*
 @author :  Harsha Reddy <sxreddy@legalzoom.com>
 @file Description : STORY B-38226
 @desc Created on 2019-04-09 8:33:06 pm
*/
@isTest
private class UpdateCustomerLogin_Test {
    @testSetup
    private static void setupTestData() {
        // Create Admin User
        TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
    }
    
    @isTest private static void sendCustomerLoginEmailTest1() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '{"isUpdated": true,"customerId": 0,"loginEmail": "string","message": "string"}';
                mock.statusCode = 200;
                Test.setMock(HttpCalloutMock.class, mock);
            	UpdateCustomerLogin.requestWrapper rWrap = new UpdateCustomerLogin.requestWrapper();
            	rWrap.newLoginEmail ='test1@gmail.com';
            	rWrap.currentLoginEmail = 'test@gmail.com';
				resp = UpdateCustomerLogin.sendCustomerLoginEmail(rWrap, '0');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendCustomerLoginEmailTest2() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '{"isUpdated": false,"customerId": 0,"loginEmail": "string","message": "string"}';
                mock.statusCode = 200;
                Test.setMock(HttpCalloutMock.class, mock);
            	UpdateCustomerLogin.requestWrapper rWrap = new UpdateCustomerLogin.requestWrapper();
            	rWrap.newLoginEmail ='test1@gmail.com';
            	rWrap.currentLoginEmail = 'test@gmail.com';
				resp = UpdateCustomerLogin.sendCustomerLoginEmail(rWrap, '0');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendCustomerLoginEmailTest3() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.statusCode = 200;
                Test.setMock(HttpCalloutMock.class, mock);
            	UpdateCustomerLogin.requestWrapper rWrap = new UpdateCustomerLogin.requestWrapper();
            	rWrap.newLoginEmail ='test1@gmail.com';
            	rWrap.currentLoginEmail = 'test@gmail.com';
				resp = UpdateCustomerLogin.sendCustomerLoginEmail(rWrap, '0');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    @isTest private static void sendCustomerLoginEmailTest4() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '{"errors":[{"code":"Could not Update ","message":null}]}';
                mock.statusCode = 400;
                Test.setMock(HttpCalloutMock.class, mock);
            	UpdateCustomerLogin.requestWrapper rWrap = new UpdateCustomerLogin.requestWrapper();
            	rWrap.newLoginEmail ='test1@gmail.com';
            	rWrap.currentLoginEmail = 'test@gmail.com';
				resp = UpdateCustomerLogin.sendCustomerLoginEmail(rWrap, '0');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    @isTest private static void sendCustomerLoginEmailTest5() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
				resp = UpdateCustomerLogin.sendCustomerLoginEmail(null, '0');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void responseWrapperTest1() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        UpdateCustomerLogin.responseWrapper resp;
        system.runAs(u){
            Test.startTest();
				resp = new UpdateCustomerLogin.responseWrapper();  
                resp.isUpdated = false;
                resp.customerId = 0;
                resp.loginEmail='string';
                resp.message = 'string';
            Test.stopTest();
            system.assert(resp!=null);
        }
    }
}