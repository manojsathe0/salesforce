@istest
Private class DNCService_test {


    static testmethod void testleaddncnophone() {

        List<Lead> testLeads;
        testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        insert testLeads;
        Test.startTest();


        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(testleads[0].id, null, null);
        Test.stopTest();

    }
    static testmethod void testcontactdnc() {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' , HomePhone = '123456789',  MobilePhone = '123456789', otherphone = '123456789');
        insert con1;

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        //mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.testBody =  '{"status": "Success" }';
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(con1.id, 'test', 'test');
        Test.stopTest();

    }
    static testmethod void testcontactdncnophone() {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer');
        insert con1;

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(con1.id, 'test', 'test');
        Test.stopTest();

    }
    static testmethod void Lead_Succee() {

        List<Lead> testLeads;
        testLeads = TestUtils.createLeads(1 , 'Johnson', false);
        testleads[0].phone = '123456789';
        //Boolean isInternalList = testleads[0].Internal_List__c;
        insert testLeads;

        Test.startTest();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        //mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.testBody =  '{"status": "Success" }';
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(testleads[0].id, null, null);
        system.assertEquals(true, [select Internal_List__c from Lead].Internal_List__c);
        Test.stopTest();

    }


    static testmethod void Lead_Failure() {

        List<Lead> testLeads;
        testLeads = TestUtils.createLeads(1 , 'Johnson', false);
        testleads[0].phone = '123456789';
        //Boolean isInternalList = testleads[0].Internal_List__c;
        insert testLeads;

        Test.startTest();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        //mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.testBody =  '{"status": "Failure" }';
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(testleads[0].id, null, null);
        system.assert(([select Id, Request_Result__c from DNC_request__c][0].Request_Result__c == 'Failure') && [select Internal_List__c from Lead][0].Internal_List__c == false);
        Test.stopTest();

    }

    static testmethod void testleadcheckinternal() {

        List<Lead> testLeads;
        testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        insert testLeads;
        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.checkdncinternal(testleads[0].id);
        Test.stopTest();

    }
    static testmethod void testcontactdncfuture() {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' , HomePhone = '123456789',  MobilePhone = '123456789', otherphone = '123456789');
        insert con1;

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        //mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
        mock.testBody =  '{"status": "Success" }';
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(con1.id, null, null);
        Test.stopTest();

    }
    static testmethod void testcontactdncnotvalidresponse() {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' , HomePhone = '123456789',  MobilePhone = '123456789', otherphone = '123456789');
        insert con1;

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  '';
        mock.statusCode = 500;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(con1.id, 'test', 'test');
        Test.stopTest();

    }
    //static testmethod void testcontactdncfuturenotvalid() {
    //    Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' , HomePhone = '123456789',  MobilePhone = '123456789', otherphone = '123456789');
    //    insert con1;

    //    Test.startTest();

    //    IADTestMockGenerator mock = new IADTestMockGenerator();
    //    mock.testBody = '';
    //    mock.statusCode = 500;

    //    Test.setMock(HttpCalloutMock.class, mock);

    //    DNCController_ltng.PostDncIntetnal(con1.id, null, null);
    //    Test.stopTest();

    //}
    static testmethod void testleadfuturenotvalid() {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' , HomePhone = '123456789',  MobilePhone = '123456789', otherphone = '123456789');
        insert con1;
        List<Lead> testLeads;
        testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        insert testLeads;
        Lead newlead = new lead();
        newlead.FirstName = 'test';
        newlead.LastName = 'dhchjd';
        newlead.Phone = '7047249550';
        newlead.Company = 'test';
        insert newlead;
        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 500;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDncIntetnal(newlead.id, 'test', 'test');
        Test.stopTest();
    }


    //@Sai
    @isTest static void PostDNCNumberBulk_Success_Test() {
        //List<Lead> testLeads;
        //testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        //insert testLeads;
        Lead newlead = new lead();
        newlead.FirstName = 'test';
        newlead.LastName = 'dhchjd';
        newlead.Phone = '7047249550';
        newlead.Company = 'test';
        insert newlead;
        Lead newlead2 = new lead();
        newlead2.FirstName = 'test';
        newlead2.LastName = 'dhchjd';
        newlead2.Phone = '7047249552';
        newlead2.Company = 'test';
        insert newlead2;
        Lead newlead3 = new lead();
        newlead3.FirstName = 'test';
        newlead3.LastName = 'dhchjd';
        newlead3.Phone = '7047249551';
        newlead3.Company = 'test';
        insert newlead3;

        List<Id> leadIdList = new List<Id>();
        for(Lead ld : [SELECT Id from Lead])
        {
            leadIdList.add(ld.Id);
        }

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  '{"status": "Success" }';
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        //passing true as 2nd parameter. It should be true when calling from DuplicateChecker class.
        DNCController_ltng.PostDNCNumberBulk(leadIdList, true);
        Test.stopTest();
    }

    //@Sai
    @isTest static void PostDNCNumberBulk_Failure_Test() {
        //List<Lead> testLeads;
        //testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        //insert testLeads;
        Lead newlead = new lead();
        newlead.FirstName = 'test';
        newlead.LastName = 'dhchjd';
        newlead.Phone = '7047249550';
        newlead.Company = 'test';
        insert newlead;
        Lead newlead2 = new lead();
        newlead2.FirstName = 'test';
        newlead2.LastName = 'dhchjd';
        newlead2.Phone = '7047249552';
        newlead2.Company = 'test';
        insert newlead2;
        Lead newlead3 = new lead();
        newlead3.FirstName = 'test';
        newlead3.LastName = 'dhchjd';
        newlead3.Phone = '7047249551';
        newlead3.Company = 'test';
        insert newlead3;

        List<Id> leadIdList = new List<Id>();
        for(Lead ld : [SELECT Id from Lead])
        {
            leadIdList.add(ld.Id);
        }

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  '{"status": "Failure" }';
        mock.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDNCNumberBulk(leadIdList, false);
        Test.stopTest();
    }

    //@Sai
    @isTest static void PostDNCNumberBulk_Invalid_Test() {
        //List<Lead> testLeads;
        //testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        //insert testLeads;
        Lead newlead = new lead();
        newlead.FirstName = 'test';
        newlead.LastName = 'dhchjd';
        newlead.Phone = '7047249550';
        newlead.Company = 'test';
        insert newlead;
        Lead newlead2 = new lead();
        newlead2.FirstName = 'test';
        newlead2.LastName = 'dhchjd';
        newlead2.Phone = '7047249552';
        newlead2.Company = 'test';
        insert newlead2;
        Lead newlead3 = new lead();
        newlead3.FirstName = 'test';
        newlead3.LastName = 'dhchjd';
        newlead3.Phone = '7047249551';
        newlead3.Company = 'test';
        insert newlead3;

        List<Id> leadIdList = new List<Id>();
        for(Lead ld : [SELECT Id from Lead])
        {
            leadIdList.add(ld.Id);
        }

        Test.startTest();

        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  '';
        mock.statusCode = 500;

        Test.setMock(HttpCalloutMock.class, mock);

        DNCController_ltng.PostDNCNumberBulk(leadIdList, false);
        Test.stopTest();
    }

}