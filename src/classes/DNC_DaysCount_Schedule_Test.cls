/**
     *  @author         Saikiran Salla - ssalla@legalzoom.com
     *  @description    Test class for DNC_DaysCount_Schedule, DNC_CheckDNCList_Batch, DNC_CheckPhone_Library, DNC_CheckDNCList_Impl, DNC_Utility
     *  @history        2019-March-26   -   Created
*/

@isTest
private class DNC_DaysCount_Schedule_Test {

    @testsetup static void test_data() {
        // Implement test data

        id conPrimaryRedTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();

        Id leadPrimaryRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard Lead').getRecordTypeId();

        Contact con = new Contact();
        con.LastName = 'lastName';
        con.MobilePhone = '9999998889';
        con.AssistantPhone = '9999998880';
        con.HomePhone = '9999998881';
        con.OtherPhone = '9999998882';
        con.Phone = '9999998883';
        con.RecordtypeId = conPrimaryRedTypeID;
        insert con;

        Contact con2 = new Contact();
        con2.LastName = 'lastName';
        con2.MobilePhone = '9999998889';
        con2.AssistantPhone = '9999998880';
        con2.HomePhone = '9999998881';
        con2.OtherPhone = '9999998882';
        con2.Phone = '9999998883';
        con2.RecordtypeId = conPrimaryRedTypeID;
        insert con2;

        Lead ld = new Lead();
        ld.LastName = 'lastName';
        ld.Company = 'company';
        ld.Status = 'Qualified';
        ld.LeadSource = 'Chat';
        ld.Phone = '6677667766';
        ld.Review_Phone__c = '4545454545';
        ld.RecordTypeId = leadPrimaryRT;
        //ld.
        //ld.
        insert ld;

        //Custom Settings
        DNC_DaysCount__c daysCount = new DNC_DaysCount__c();
        daysCount.Name = 'Default Days';
        daysCount.Days_to_Run__c = 23;
        daysCount.Batch_Scope__c = 5;
        Date dd = Date.today();
        daysCount.Last_Ran_Date__c = Date.today().addDays(-40);
        insert daysCount;

    }

    @isTest static void test_Schedule() {
        // Implement test code
        System.schedule('String_jobname', '0 0 0 15 3 ? *', new DNC_checkDNCList_Schedule());


        //Just to cover uncovered part
        DNC_CheckPhone_Library.cls_PhoneNumber phNum =  new DNC_CheckPhone_Library.cls_PhoneNumber();
    }

    @isTest static void test_Contact_Batch() {

        id conPrimaryRedTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();

        Id leadPrimaryRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard Lead').getRecordTypeId();

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(200);
        mock.setStaticResource('DNC_CheckPhoneResponse');
        mock.setHeader('Content-Type', 'application/json');


        //System.schedule('String_jobname', '0 0 0 15 3 ? *', new DNC_DaysCount_Schedule());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        Database.ExecuteBatch(new DNC_CheckDNCList_Batch('Contact', conPrimaryRedTypeID, leadPrimaryRT), 2);
        Test.stopTest();

        system.debug('----Contact from Test' + [select Wireless__c, Known_Litigator__c, Internal_list__c from contact]);
    }

    @isTest static void test_Lead_Batch() {
        id conPrimaryRedTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();

        Id leadPrimaryRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard Lead').getRecordTypeId();

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(200);
        mock.setStaticResource('DNC_CheckPhoneResponse');
        mock.setHeader('Content-Type', 'application/json');


        //System.schedule('String_jobname', '0 0 0 15 3 ? *', new DNC_DaysCount_Schedule());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        Database.ExecuteBatch(new DNC_CheckDNCList_Batch('Lead', conPrimaryRedTypeID, leadPrimaryRT), 1);
        Test.stopTest();

        //Now it enters into if (!aajList.isEmpty())
        System.schedule('String_jobname', '0 0 0 15 3 ? *', new DNC_checkDNCList_Schedule());

        system.debug('----Lead from Test' + [select Wireless__c, Known_Litigator__c from Lead]);
    }

    //it has response P and No reason. So it should call POST DNC Internal List api.
    @isTest static void test_Contact_Batch2() {

        id conPrimaryRedTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();

        Id leadPrimaryRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard Lead').getRecordTypeId();

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(200);
        mock.setStaticResource('DNC_CheckPhoneResponse');
        mock.setHeader('Content-Type', 'application/json');

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        Database.ExecuteBatch(new DNC_CheckDNCList_Batch('Contact', conPrimaryRedTypeID, leadPrimaryRT), 2);
        Test.stopTest();

        system.debug('----Contact from Test' + [select Wireless__c, Known_Litigator__c, Internal_list__c from contact]);
    }

}