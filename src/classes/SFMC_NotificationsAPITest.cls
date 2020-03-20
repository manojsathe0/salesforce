/*
    MC Phase 2 functionality.
    Delivering an API endpoint to perform a contact Search in Salesforce and pass the contact infromation further to Marketing Cloud
    Stories: B-27980, B-28913
    Developer: Artyom M. 
	3/21/19 - Haritha updating for git to pick up in package
*/

@isTest
public with sharing class SFMC_NotificationsAPITest {
    public static String testJSONstr;
    public static String testJSONstrBroken;
    public static String testJSONstrNoCatName;
    public static String testJSONstrNoNotificationId;
    public static String testJSONstrBadContact;
    public static String testJSONstrNoCustId;
    public static String testJSONstrMissingNodes;
    public static String SFMCTokenResponse;
    public static String contactFromAPIPayloadGeneric;
    public static String contactFromAPIPayload;
    public static String MCTriggerSendRest_Password_Payload_Primary;
    public static String MCTriggerSendRest_Password_Payload_Login;
    public static String MCTriggerSendRest_Password_Payload_Override;
    public static String MCTriggerSendRest_Password_Payload_Override1;
    public static String MCTriggerSendRest_Password_Payload_None;
    public static String MCJourney_Payload_Primary;
    public static String MCJourney_Payload_Primary1;
    public static String MCTriggerSendRest_Password_Payload_Primary1;
    
    public static void dataSetup() {
        Contact theContact = new Contact();
        theContact.lastName = 'Test';
        theContact.FkUser__c = '123443212';
        theContact.Email = 'test@test.com';
        theContact.Contact_Type__c = 'Primary Contact';
        insert theContact;
        Account acc = new Account();
        acc.name='test@legalzoom.com';
        acc.customer_id__c='1789023';
        insert acc;
        
        testJSONstr = '{ \"metaData\":{ \"version\":\"1.0.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Biz_Problem_Name\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        testJSONstrBroken = '{ \"metaData\":{ \"ver16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Biz_Problem_Name\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        testJSONstrNoCatName  = '{ \"metaData\":{ \"version\":\"1.0.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\"}, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        testJSONstrNoNotificationId = '{ \"metaData\":{ \"version\":\"1.0.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"CategoryName\":\"Biz_Problem_Name\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        testJSONstrBadContact = '{ \"metaData\":{ \"version\":\"1.0.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Biz_Problem_Name\" }, \"referenceData\":{ \"customer\":{ \"customerId\":12344, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        testJSONstrNoCustId = '{ \"metaData\":{ \"version\":\"1.0.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Biz_Problem_Name\" }, \"referenceData\":{ \"customer\":{ \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        testJSONstrMissingNodes = '{ \"metaData\":null, \"referenceData\":{ \"customer\":{ \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }, \"order\":{ \"orderId\":112456, \"processingOrderId\":12456, \"processId\":2, \"processingStatusId\":32 }, \"payment\":{ \"profileId\":12345 }, \"externalContent\":[ { \"name\":\"RecieptHtml\", \"uri\":\"http://\", \"contenttype\":\"HTML\" } ] }, \"optionalData\":{ \"entityName\":\"none\", \"productName\":\"LLC\", \"questionnaire\":\"LLC\", \"packageType\":\"Standard\", \"shipMethod\":\"Standard Shipping\", \"fedexNumber\":\"CA\", \"orderType\":\"Legalzoom\", \"userordernumber\":\"1234\", \"FirstName\" : \"Test\" } }';
        SFMCTokenResponse = '{ \"accessToken\": \"ZbFvoq0BFCnzJVpK0Hjb3Aei\", \"expiresIn\": 3479 }';
        contactFromAPIPayloadGeneric = '{ \"customerInfo\": { \"uuid\": \"string\", \"customerId\": 0, \"loginUsername\": \"string\" }, \"contactInfo\": { \"userContactInfoId\": 0, \"customerId\": 0, \"description\": \"string\", \"firstName\": \"string\", \"lastName\": \"string\", \"addressLine1\": \"string\", \"addressLine2\": \"string\", \"city\": \"string\", \"stateId\": 0, \"county\": 0, \"zipcode\": \"string\", \"email1\": \"string\", \"email2\": \"string\", \"email3\": \"string\", \"homePhone\": \"string\", \"workPhone\": \"string\", \"cellPhone\": \"string\", \"fax\": \"string\", \"country\": 0, \"state\": \"string\", \"taxID\": 0, \"active\": \"string\", \"statusChanged\": \"2018-12-06T00:52:02.250Z\", \"statusChangedBy\": \"string\", \"crmContactId\": \"string\", \"contactInfoType\": 0, \"updateSource\": 0, \"stateFullName\": \"string\", \"abbr\": \"string\", \"existingContact\": true, \"contactCreated\": true, \"contactUpdated\": true, \"message\": \"string\" }, \"accountInfo\": { \"customerManager\": { \"employeeAccountManagerId\": 0, \"firstName\": \"string\", \"lastName\": \"string\", \"phone\": \"string\", \"phoneExtension\": \"string\", \"email\": \"string\", \"team\": { \"customerTeamId\": 0, \"salesforceId\": \"string\", \"name\": \"string\", \"phone\": \"string\", \"phoneExtension\": \"string\", \"email\": \"string\" } }, \"status\": { \"accountStatusId\": 0, \"serviceStatus\": \"string\", \"description\": \"string\", \"isActive\": \"string\" }, \"memberSinceDate\": \"2018-12-06T00:52:02.250Z\" }, \"securityQuestion\": { \"questionId\": 0, \"question\": \"string\", \"answer\": \"string\" }, \"thirdPartyUserInfo\": [ { \"userId\": 0, \"thirdPartyId\": \"string\", \"thirdPartyTypeId\": 0, \"createdBy\": \"string\", \"hasLifePlan\": true } ] }';
        contactFromAPIPayload = '{ \"customerInfo\": { \"uuid\": \"2ab8d5c9-285f-4d8c-9d69-4dfb512e6f23\", \"customerId\": 11012938, \"loginUsername\": \"pbryantuat1@legalzoom.com\" }, \"contactInfo\": { \"userContactInfoId\": 13167263, \"customerId\": 11012938, \"description\": null, \"firstName\": \"FN\", \"lastName\": \"Fn\", \"addressLine1\": \"123 maine street\", \"addressLine2\": null, \"city\": \"Austin\", \"stateId\": 21, \"county\": null, \"zipcode\": \"78717\", \"email1\": \"pbryantuat1@legalzoom.com\", \"email2\": null, \"email3\": null, \"homePhone\": \"(512) 212-4444\", \"workPhone\": null, \"cellPhone\": null, \"fax\": null, \"country\": 225, \"state\": \"Texas\", \"taxID\": null, \"active\": 1, \"statusChanged\": \"0001-01-01T00:00:00Z\", \"statusChangedBy\": null, \"crmContactId\": null, \"contactInfoType\": 1, \"updateSource\": null, \"stateFullName\": \"Texas\", \"abbr\": \"TX\", \"existingContact\": false, \"contactCreated\": false, \"contactUpdated\": false, \"message\": \"\" }, \"accountInfo\": { \"customerManager\": null, \"status\": null, \"memberSinceDate\": null }, \"securityQuestion\": { \"questionId\": 0, \"question\": null, \"answer\": null }, \"thirdPartyUserInfo\": [ { \"userId\": 11012938, \"thirdPartyId\": \"3707071215\", \"thirdPartyTypeId\": 8, \"createdBy\": \"CustomerBoxAccountProvision\", \"hasLifePlan\": false } ] }';
        MCTriggerSendRest_Password_Payload_Primary = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Password_Reset_Request\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
        MCTriggerSendRest_Password_Payload_Login = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Password_Reset_Request\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Login\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
        MCTriggerSendRest_Password_Payload_Override = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Password_Reset_Request\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Override\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
        MCTriggerSendRest_Password_Payload_Override1 = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Password_Reset_Request\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443, \"contactType\":\"Override\", \"contactId\":12456473, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
        MCTriggerSendRest_Password_Payload_None = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Password_Reset_Request\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"LogIn\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
         MCJourney_Payload_Primary = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Login_Change_Successful\" }, \"referenceData\":{ \"customer\":{ \"customerId\":123443212, \"contactType\":\"Override\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
         MCJourney_Payload_Primary1 = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Login_Change_Successful\" }, \"referenceData\":{ \"customer\":{ \"customerId\":1789023, \"contactType\":\"Override\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
         MCTriggerSendRest_Password_Payload_Primary1 = '{ \"metaData\":{ \"version\":\"1.0\", \"dateCreated\":\"2018-01-09T15:16:05.0514396-08:00\", \"correlationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac99158a\", \"notificationId\":\"1e7dbf3d-d00d-44c3-ba19-64efac991a0\", \"CategoryName\":\"Customer_Password_Reset_Request\" }, \"referenceData\":{ \"customer\":{ \"customerId\":1789023, \"contactType\":\"Primary\", \"contactId\":12456, \"thirdPartyId\":null }}, \"optionalData\":{\"PasswordLink\":\"https://\", \"OrderType\":\"LegalZoom\" } }';
        //'{\"metadata\":{\"version\":\"1.0\",\"datecreated\":\"2019-03-08T20:37:02.0337623Z\",\"categoryname\":\"Customer_Password_Reset_Request\",\"notificationid\":\"db6592e5-1e01-42c8-afe6-601fa9d8adc3\",\"correlationid\":\"350b2635-794f-4674-826e-709bad4b7a99\"},\"referencedata\":{\"Customer\":{\"CustomerId\":12363928,\"ContactType\":\"Login\"}},\"optionaldata\":{\"PasswordLink\":\"https://www.legalzoom.com/LZWeb/Welcome/PasswordReset.aspx?PwdResetRequest=7tQViH82Q5Hun5JFhCaIjIoRpS8YnRVk0HeLuxoY6CpNuhsJPCWW%2F%2BxEyOjHw%2BZC\",\"OrderType\":\"LegalZoom\"}}';
        
        APIEndpointStatistics__c APIEndpointToInsert = new APIEndpointStatistics__c();
        APIEndpointToInsert.Name = 'notificationAPI';/*
        APIEndpointToInsert.Request_Count__c = 0;
        APIEndpointToInsert.Response_Count_for_200__c = 0;
        APIEndpointToInsert.Response_Count_for_400__c = 0;
        APIEndpointToInsert.Response_Count_for_404__c = 0;
        APIEndpointToInsert.Response_Count_for_500__c = 0;
        APIEndpointToInsert.Runtime_Version__c = '1.0.0';*/
        APIEndpointToInsert.Machine_Name__c = 'Salesforce';
        insert APIEndpointToInsert;
        
    }
    
    @isTest
    static void testHhandleHTTPRequestTriggerSendRestPwd() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_Primary);

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=202;
        mock.testBody = SFMCTokenResponse;
        Test.setMock(HttpCalloutMock.class, mock);

        SFMC_NotificationsAPI.handleHTTPRequest();

        System.debug(req);
        System.debug(res);

        Test.stopTest();
    }
    
     @isTest
    static void testHhandleHTTPRequestTriggerSendRestPwdacc() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_Primary1);

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=202;
        mock.testBody = SFMCTokenResponse;
        Test.setMock(HttpCalloutMock.class, mock);

        SFMC_NotificationsAPI.handleHTTPRequest();

        System.debug(req);
        System.debug(res);

        Test.stopTest();
    }

    @isTest
    static void testHhandleHTTPRequestJourneyContactOther() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(MCJourney_Payload_Primary);

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=202;
        mock.testBody = SFMCTokenResponse;
        Test.setMock(HttpCalloutMock.class, mock);

        SFMC_NotificationsAPI.handleHTTPRequest();

        System.debug(req);
        System.debug(res);

        Test.stopTest();
    }
    
    @isTest
    static void testHhandleHTTPRequestJourneyContactOther1() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(MCJourney_Payload_Primary1);

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=202;
        mock.testBody = SFMCTokenResponse;
        Test.setMock(HttpCalloutMock.class, mock);

        SFMC_NotificationsAPI.handleHTTPRequest();

        System.debug(req);
        System.debug(res);

        Test.stopTest();
    }
    
    @isTest
    static void testHhandleHTTPRequestTriggerSendRestPwdNone() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

		req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_None);

		Test.startTest();
		RestContext.request = req;
		RestContext.response = res;

		IADTestMockGenerator mock = new IADTestMockGenerator();
		mock.statusCode=202;
		mock.testBody = SFMCTokenResponse;
		Test.setMock(HttpCalloutMock.class, mock);

		SFMC_NotificationsAPI.handleHTTPRequest();

		System.debug(req);
		System.debug(res);

		Test.stopTest();
	}


	@isTest
	static void testHhandleHTTPRequestTriggerSendRestPwdLogin() {
		dataSetup();
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_Login);

		Test.startTest();
		RestContext.request = req;
		RestContext.response = res;

		IADTestMockGenerator mock = new IADTestMockGenerator();
		mock.statusCode=202;
		mock.testBody = SFMCTokenResponse;
		Test.setMock(HttpCalloutMock.class, mock);

		SFMC_NotificationsAPI.handleHTTPRequest();

		System.debug(req);
		System.debug(res);

		Test.stopTest();
	}

	@isTest
	static void testHhandleHTTPRequestTriggerSendRestPwdOverride() {
		dataSetup();
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_Override);

		Test.startTest();
		RestContext.request = req;
		RestContext.response = res;

		IADTestMockGenerator mock = new IADTestMockGenerator();
		mock.statusCode=202;
		mock.testBody = SFMCTokenResponse;
		Test.setMock(HttpCalloutMock.class, mock);

		SFMC_NotificationsAPI.handleHTTPRequest();
		APIEndpointStatisticsService.incrementResponseCodeValueAndLog('NotificationAPI',202,null, null,null,null,userInfo.getUserId());
		APIEndpointStatistics__c astat = new APIEndpointStatistics__c(name='/services/apexrest/SFMCNotificationsAPI/',Response_Count_for_200__c=10,Response_Count_for_400__c = 5,Response_Count_for_404__c = 1,Response_Count_for_500__c = 0);
		insert astat;
		APIEndpointStatisticsService.getAPIStatisticsAsJSONByEndpointName('/services/apexrest/SFMCNotificationsAPI/');
		System.debug(req);
		System.debug(res);

        Test.stopTest();
    }
    
     @isTest
    static void testHhandleHTTPRequestTriggerSendRestPwdOverride1() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_Override1);

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=202;
        mock.testBody = SFMCTokenResponse;
        Test.setMock(HttpCalloutMock.class, mock);

        SFMC_NotificationsAPI.handleHTTPRequest();
        APIEndpointStatisticsService.incrementResponseCodeValueAndLog('NotificationAPI',202,null, null,null,null,userInfo.getUserId());
        APIEndpointStatistics__c astat = new APIEndpointStatistics__c(name='/services/apexrest/SFMCNotificationsAPI/',Response_Count_for_200__c=10,Response_Count_for_400__c = 5,Response_Count_for_404__c = 1,Response_Count_for_500__c = 0);
        insert astat;
        APIEndpointStatisticsService.getAPIStatisticsAsJSONByEndpointName('/services/apexrest/SFMCNotificationsAPI/');
        System.debug(req);
        System.debug(res);

        Test.stopTest();
    }
    
    @isTest
    static void testHhandleHTTPRequestTriggerSendRestPwdFail() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

		req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(MCTriggerSendRest_Password_Payload_Primary);

		Test.startTest();
		RestContext.request = req;
		RestContext.response = res;

		IADTestMockGenerator mock = new IADTestMockGenerator();
		mock.statusCode=400;
		mock.testBody = SFMCTokenResponse;
		Test.setMock(HttpCalloutMock.class, mock);

		SFMC_NotificationsAPI.handleHTTPRequest();

		System.debug(req);
		System.debug(res);

		Test.stopTest();
	}


	@isTest
    static void testHhandleHTTPRequestSuccess() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    
    @isTest
    static void testHhandleHTTPRequestSuccessNoContactInSFDC() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrBadContact);
//
        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode = 200;
            mock.testBody = contactFromAPIPayload;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    
    
    @isTest
    static void testHhandleHTTPRequestFailNullFromSFMC() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode = 400;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHhandleHTTPRequestFailBrokenJSON() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrBroken);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    
    @isTest
    static void testHhandleHTTPRequestFailMissingNodes() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrMissingNodes);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHhandleHTTPRequestFailEmptyBody() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHhandleHTTPRequestFailNoCatName() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrNoCatName);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHhandleHTTPRequestFailNoNotificationId() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrNoNotificationId);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    
    @isTest
    static void testHhandleHTTPRequestFailBadContact() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/notificationAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrBadContact);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHhandleHTTPRequestFailNoCustId() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/SFMCNotificationsAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrNoCustId);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            
            IADTestMockGenerator mock = new IADTestMockGenerator();
            mock.statusCode=201;
            mock.testBody = SFMCTokenResponse;
            Test.setMock(HttpCalloutMock.class, mock);
            
            SFMC_NotificationsAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHhandleHTTPRequestExtra() {
        dataSetup();
        SFMC_ContractBeans.InboundRequest inboundRequest;
        SFMC_ContractBeans.GetContactResponse contactDesccription;
        try {
            
            inboundRequest = (SFMC_ContractBeans.InboundRequest) JSON.deserialize(testJSONstr, SFMC_ContractBeans.InboundRequest.class);
            
            
            contactDesccription = (SFMC_ContractBeans.GetContactResponse) JSON.deserialize(contactFromAPIPayloadGeneric, SFMC_ContractBeans.GetContactResponse.class);
            System.debug(contactDesccription.contactInfo.userContactInfoId);
            System.debug(contactDesccription.contactInfo.customerId);
            System.debug(contactDesccription.contactInfo.description);
            System.debug(contactDesccription.contactInfo.firstName);
            System.debug(contactDesccription.contactInfo.lastName);
            System.debug(contactDesccription.contactInfo.addressLine1);
            System.debug(contactDesccription.contactInfo.addressLine2);
            System.debug(contactDesccription.contactInfo.city);
            System.debug(contactDesccription.contactInfo.stateId);
            System.debug(contactDesccription.contactInfo.county);
            System.debug(contactDesccription.contactInfo.zipcode);
            System.debug(contactDesccription.contactInfo.email1);
            System.debug(contactDesccription.contactInfo.email2);
            System.debug(contactDesccription.contactInfo.email3);
            System.debug(contactDesccription.contactInfo.homePhone);
            System.debug(contactDesccription.contactInfo.workPhone);
            System.debug(contactDesccription.contactInfo.cellPhone);
            System.debug(contactDesccription.contactInfo.fax);
            System.debug(contactDesccription.contactInfo.country);
            System.debug(contactDesccription.contactInfo.state);
            System.debug(contactDesccription.contactInfo.taxID);
            System.debug(contactDesccription.contactInfo.active);
            System.debug(contactDesccription.contactInfo.statusChanged);
            System.debug(contactDesccription.contactInfo.crmContactId);
            System.debug(contactDesccription.contactInfo.contactInfoType);
            System.debug(contactDesccription.contactInfo.updateSource);
            System.debug(contactDesccription.contactInfo.stateFullName);
            System.debug(contactDesccription.contactInfo.abbr);
            System.debug(contactDesccription.contactInfo.existingContact);
            System.debug(contactDesccription.contactInfo.contactCreated);
            System.debug(contactDesccription.contactInfo.contactUpdated);
            System.debug(contactDesccription.contactInfo.message);
            
        }
        catch (Exception e) {
            System.Debug(e);
        }
        
        
        System.debug(inboundRequest.metaData.version);
        System.debug(inboundRequest.metaData.dateCreated);
        System.debug(inboundRequest.metaData.correlationId);
        
        System.debug(inboundRequest.referenceData.customer.contactType);
        System.debug(inboundRequest.referenceData.customer.contactId);
        System.debug(inboundRequest.referenceData.customer.thirdPartyId);
        System.debug(inboundRequest.referenceData.customer);
        
        System.debug(inboundRequest.referenceData.order.orderId);
        System.debug(inboundRequest.referenceData.order.processingOrderId);
        System.debug(inboundRequest.referenceData.order.processId);
        System.debug(inboundRequest.referenceData.order.processingStatusId);
        
        System.debug(inboundRequest.referenceData.order);
        System.debug(inboundRequest.referenceData.payment);
        System.debug(inboundRequest.referenceData.externalContent);
        
    }
}