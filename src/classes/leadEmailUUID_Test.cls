@isTest

private  class leadEmailUUID_Test {
    static void setup()
    {
        SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.Lead_New_Stage_Activity_Limit__c = 1;
        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
        config.Lead_Abandoner_Score__c = 1;
        config.Lead_Chat_Score__c = 1;
        config.Lead_Days_from_Ownership__c = 2;
        config.Lead_Email_Score__c = 1;
        config.Lead_Inbound_Score__c = 2;
        config.Lead_Mobile_Score__c = 3;
        config.Lead_Score_Initial__c = 3;
        config.Lead_Social_Media_Score__c = 1;


        insert config;
    }
    static testMethod void testLeadEmailUUIDService1(){
        setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"email" : "bxliu@lz.com","uuid" : "wdowkdmadca"}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        List<lead> lst = TestUtils.createLeads(1,'testMuthu',false);
        lst[0].email = 'bxliu@lz.com';
        insert lst;
        LeadService.updateUUID(lst[0].id,true);
        //lst[0].email = 'bxliu0706-0223@lz.com';
        //lst[0].record_processed_Once__c = false;
        //update lst;
    }
    static testMethod void testLeadEmailUUIDService2(){
        setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        List<lead> lst = TestUtils.createLeads(1,'testMuthu',false);
        lst[0].email = 'bxliu@lz.com';
        insert lst;
        lst[0].email = 'bxliu0706-0223@lz.com';
        lst[0].record_processed_Once__c = false;
        update lst;
        LeadService.updateUUID(lst[0].id,true);
    }
}