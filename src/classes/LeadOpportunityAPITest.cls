/**
 * Created by jboles on 4/26/2017.
 */
@isTest
public class LeadOpportunityAPITest
{
    @isTest
    static void testPostCallout()
    {
        SEAD_Configuration__c theConfiguration = new SEAD_Configuration__c();
        theConfiguration.Name = 'Default';
        //theConfiguration.
		SEAD_Profiles__c profiles = new SEAD_Profiles__c();
		profiles.Name = 'Default';
		profiles.Allowed_Profile_Names__c = 'Sales Manager (SEAD 2);';
		insert profiles;

        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.SEAD_Configuration__c.fields.getMap();

        for(String fieldName : schemaFieldMap.keySet())
        {
            if(fieldName.contains('__c'))
            {
                theConfiguration.put(fieldName, 1);
            }
        }
        insert theConfiguration;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        String requestBody = '{"firstName":"John","lastName":"Doe","LeadID" : 123456789, "uuid":"123456789","email":"test2231232@jlasdkfasdj.com","customerId":"123987635","phone":"5555555555","device":"Mobile","marketingInfo":{"marketingChannel":"Organic","marketingSource":"Yahoo","marketingCampaign":"LLC Special Offer"},"questionnaireInfo":{"startDateTime":"2017-03-20T17:01:13.743Z","endDateTime":"2017-03-20T17:01:23.743Z","percentageQuestionnaireCompletion":46,"state":"CA", "lastPageOnQuestionnaire":"Page Name","processingNumber":"567901234","processName":"LLC","packageName":"LLC Gold","amount":299,"optIns":[{"option":"RA"},{"option":"BAP"},{"option":"LAP"},{"option":"Compliance"}],"milestone":{"purchaseLockPage":true,"productOverviewPage":true,"checkoutPage":false}},"cartInfo":{"cartItems":[{"productName":"Compliance Package","price":59.99},{"productName":"Registered Agent","price":159.99}]},"myAccount":{"startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z","accountActivities":[{"action":"View Compliance Calendar"},{"action":"View Completed Orders"},{"action":"Print Invoice"},{"action":"Set up Attorney/Tax Consultation"},{"action":"Company Profile"},{"action":"Account Profile"},{"action":"Make a Payment"}]},"page":{"pageName":"My Test Page","startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z"}}';

        req.requestURI = 'https://legalzoom--janesbox2.cs11.my.salesforce.com/services/apexrest/LeadOpportunityAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;

        LeadOpportunityAPI.createOrUpdateLeadOrOpportunity();

        System.debug(req);
        System.debug(res);

        Test.stopTest();
    }
    @isTest
	static void testWithExistingOpportunity()
		{
			SEAD_Configuration__c theConfiguration = new SEAD_Configuration__c();
			theConfiguration.Name = 'Default';
			//theConfiguration.


			Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.SEAD_Configuration__c.fields.getMap();

			for(String fieldName : schemaFieldMap.keySet())
				{
					if(fieldName.contains('__c'))
					{
						theConfiguration.put(fieldName, 1);
					}
				}
			insert theConfiguration;
			
			SEAD_Profiles__c profiles = new SEAD_Profiles__c();
		profiles.Name = 'Default';
		profiles.Allowed_Profile_Names__c = 'Sales Manager (SEAD 2);';
		insert profiles;
			Opportunity cnt = new Opportunity();
			cnt.Name = 'John Doe';
			cnt.Email__c = 'test2231232@jlasdkfasdj.com';
			cnt.StageName = 'New';
			cnt.CloseDate = System.today().addDays(10);
			insert cnt;

			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();

			String requestBody = '{"firstName":"John","lastName":"Doe","uuid":"123456789","email":"test2231232@jlasdkfasdj.com","customerId":"123987635","phone":"5555555555","device":"Mobile","marketingInfo":{"marketingChannel":"Organic","marketingSource":"Yahoo","marketingCampaign":"LLC Special Offer"},"questionnaireInfo":{"startDateTime":"2017-03-20T17:01:13.743Z","endDateTime":"2017-03-20T17:01:23.743Z","percentageQuestionnaireCompletion":46,"state":"CA", "lastPageOnQuestionnaire":"Page Name","processingNumber":"567901234","processName":"LLC","packageName":"LLC Gold","amount":299,"optIns":[{"option":"RA"},{"option":"BAP"},{"option":"LAP"},{"option":"Compliance"}],"milestone":{"purchaseLockPage":true,"productOverviewPage":true,"checkoutPage":false}},"cartInfo":{"cartItems":[{"productName":"Compliance Package","price":59.99},{"productName":"Registered Agent","price":159.99}]},"myAccount":{"startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z","accountActivities":[{"action":"View Compliance Calendar"},{"action":"View Completed Orders"},{"action":"Print Invoice"},{"action":"Set up Attorney/Tax Consultation"},{"action":"Company Profile"},{"action":"Account Profile"},{"action":"Make a Payment"}]},"page":{"pageName":"My Test Page","startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z"}}';

			req.requestURI = 'https://legalzoom--janesbox2.cs11.my.salesforce.com/services/apexrest/LeadOpportunityAPI/';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueOf(requestBody);

			Test.startTest();
			RestContext.request = req;
			RestContext.response = res;

			LeadOpportunityAPI.createOrUpdateLeadOrOpportunity();

			System.debug(req);
			System.debug(res);

			Test.stopTest();
		}
	@isTest
	static void testWithExistingContact()
		{
			SEAD_Configuration__c theConfiguration = new SEAD_Configuration__c();
			theConfiguration.Name = 'Default';
			//theConfiguration.


			Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.SEAD_Configuration__c.fields.getMap();

			for(String fieldName : schemaFieldMap.keySet())
				{
					if(fieldName.contains('__c'))
					{
						theConfiguration.put(fieldName, 1);
					}
				}
			insert theConfiguration;
			
			SEAD_Profiles__c profiles = new SEAD_Profiles__c();
		profiles.Name = 'Default';
		profiles.Allowed_Profile_Names__c = 'Sales Manager (SEAD 2);';
		insert profiles;
			Account acc = new Account();
			acc.Name = 'TestAcc';
			insert acc;
			
			Contact cnt = new Contact();
			cnt.account = acc;
			cnt.FirstName = 'John';
			cnt.lastName = 'Doe';
			cnt.email = 'test2231232@jlasdkfasdj.com';
			insert cnt;
			
			Opportunity opp = new Opportunity();
			opp.Name = 'John Doe';
			opp.Email__c = 'test2231232@jlasdkfasdj.com';
			opp.StageName = 'New';
			opp.Product2__c = 'LLC';
			opp.account = acc;
			opp.Contact__c = cnt.Id;
			opp.CloseDate = System.today().addDays(10);
			opp.My_Account_End_Time__c = System.Now();
			insert opp;
			
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();

			String requestBody = '{"firstName":"John","lastName":"Doe","uuid":"123456789","email":"test2231232@jlasdkfasdj.com","customerId":"123987635","phone":"5555555555","device":"Mobile","marketingInfo":{"marketingChannel":"Organic","marketingSource":"Yahoo","marketingCampaign":"LLC Special Offer"},"questionnaireInfo":{"startDateTime":"2017-03-20T17:01:13.743Z","endDateTime":"2017-03-20T17:01:23.743Z","percentageQuestionnaireCompletion":46,"state":"CA", "lastPageOnQuestionnaire":"Page Name","processingNumber":"567901234","processName":"LLC","packageName":"LLC Gold","amount":299,"optIns":[{"option":"RA"},{"option":"BAP"},{"option":"LAP"},{"option":"Compliance"}],"milestone":{"purchaseLockPage":true,"productOverviewPage":true,"checkoutPage":false}},"cartInfo":{"cartItems":[{"productName":"Compliance Package","price":59.99},{"productName":"Registered Agent","price":159.99}]},"myAccount":{"startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z","accountActivities":[{"action":"View Compliance Calendar"},{"action":"View Completed Orders"},{"action":"Print Invoice"},{"action":"Set up Attorney/Tax Consultation"},{"action":"Company Profile"},{"action":"Account Profile"},{"action":"Make a Payment"}]},"page":{"pageName":"My Test Page","startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z"}}';

			req.requestURI = 'https://legalzoom--janesbox2.cs11.my.salesforce.com/services/apexrest/LeadOpportunityAPI/';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueOf(requestBody);

			Test.startTest();
			RestContext.request = req;
			RestContext.response = res;
 			LeadOpportunityAPI.isOwnedBySEAD2 = false;		
			LeadOpportunityAPI.createOrUpdateLeadOrOpportunity();

			System.debug(req);
			System.debug(res);

			Test.stopTest();
		}
    
    @isTest
	static void testWithExistingContactSEAD()
		{
			SEAD_Configuration__c theConfiguration = new SEAD_Configuration__c();
			theConfiguration.Name = 'Default';
			//theConfiguration.


			Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.SEAD_Configuration__c.fields.getMap();

			for(String fieldName : schemaFieldMap.keySet())
				{
					if(fieldName.contains('__c'))
					{
						theConfiguration.put(fieldName, 1);
					}
				}
			insert theConfiguration;
			
			SEAD_Profiles__c profiles = new SEAD_Profiles__c();
		profiles.Name = 'Default';
		profiles.Allowed_Profile_Names__c = 'Sales Manager (SEAD 2);';
		insert profiles;
			Account acc = new Account();
			acc.Name = 'TestAcc';
			insert acc;
			
			Contact cnt = new Contact();
			cnt.account = acc;
			cnt.FirstName = 'John';
			cnt.lastName = 'Doe';
			cnt.email = 'test2231232@jlasdkfasdj.com';
			insert cnt;
			
			Opportunity opp = new Opportunity();
			opp.Name = 'John Doe';
			opp.Email__c = 'test2231232@jlasdkfasdj.com';
			opp.StageName = 'New';
			opp.Product2__c = 'LLC';
			opp.account = acc;
			opp.Contact__c = cnt.Id;
			opp.CloseDate = System.today().addDays(10);
			opp.My_Account_End_Time__c = System.Now();
			insert opp;
			
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();

			String requestBody = '{"firstName":"John","lastName":"Doe","uuid":"123456789","email":"test2231232@jlasdkfasdj.com","customerId":"123987635","phone":"5555555555","device":"Mobile","marketingInfo":{"marketingChannel":"Organic","marketingSource":"Yahoo","marketingCampaign":"LLC Special Offer"},"questionnaireInfo":{"startDateTime":"2017-03-20T17:01:13.743Z","endDateTime":"2017-03-20T17:01:23.743Z","percentageQuestionnaireCompletion":46,"state":"CA", "lastPageOnQuestionnaire":"Page Name","processingNumber":"567901234","processName":"LLC","packageName":"LLC Gold","amount":299,"optIns":[{"option":"RA"},{"option":"BAP"},{"option":"LAP"},{"option":"Compliance"}],"milestone":{"purchaseLockPage":true,"productOverviewPage":true,"checkoutPage":false}},"cartInfo":{"cartItems":[{"productName":"Compliance Package","price":59.99},{"productName":"Registered Agent","price":159.99}]},"myAccount":{"startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z","accountActivities":[{"action":"View Compliance Calendar"},{"action":"View Completed Orders"},{"action":"Print Invoice"},{"action":"Set up Attorney/Tax Consultation"},{"action":"Company Profile"},{"action":"Account Profile"},{"action":"Make a Payment"}]},"page":{"pageName":"My Test Page","startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z"}}';

			req.requestURI = 'https://legalzoom--janesbox2.cs11.my.salesforce.com/services/apexrest/LeadOpportunityAPI/';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueOf(requestBody);

			Test.startTest();
			RestContext.request = req;
			RestContext.response = res;
            LeadOpportunityAPI.isOwnedBySEAD2 = true;
			
			LeadOpportunityAPI.createOrUpdateLeadOrOpportunity();

			System.debug(req);
			System.debug(res);

			Test.stopTest();
		}
	@isTest
	static void testWithExistingLead()
		{
			SEAD_Configuration__c theConfiguration = new SEAD_Configuration__c();
			theConfiguration.Name = 'Default';
			//theConfiguration.


			Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.SEAD_Configuration__c.fields.getMap();

			for(String fieldName : schemaFieldMap.keySet())
				{
					if(fieldName.contains('__c'))
					{
						theConfiguration.put(fieldName, 1);
					}
				}
			insert theConfiguration;
			
			SEAD_Profiles__c profiles = new SEAD_Profiles__c();
		profiles.Name = 'Default';
		profiles.Allowed_Profile_Names__c = 'Sales Manager (SEAD 2);';
		insert profiles;
			Lead ld = new Lead();
			ld.FirstName = 'John';
			ld.lastName = 'Doe';
			ld.Company = 'TestCompany';
			ld.email = 'test2231232@jlasdkfasdj.com';
			insert ld;


			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();

			String requestBody = '{"firstName":"John","lastName":"Doe","uuid":"123456789","email":"test2231232@jlasdkfasdj.com","customerId":"123987635","phone":"5555555555","device":"Mobile","marketingInfo":{"marketingChannel":"Organic","marketingSource":"Yahoo","marketingCampaign":"LLC Special Offer"},"questionnaireInfo":{"startDateTime":"2017-03-20T17:01:13.743Z","endDateTime":"2017-03-20T17:01:23.743Z","percentageQuestionnaireCompletion":46,"state":"CA", "lastPageOnQuestionnaire":"Page Name","processingNumber":"567901234","processName":"LLC","packageName":"LLC Gold","amount":299,"optIns":[{"option":"RA"},{"option":"BAP"},{"option":"LAP"},{"option":"Compliance"}],"milestone":{"purchaseLockPage":true,"productOverviewPage":true,"checkoutPage":false}},"cartInfo":{"cartItems":[{"productName":"Compliance Package","price":59.99},{"productName":"Registered Agent","price":159.99}]},"myAccount":{"startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z","accountActivities":[{"action":"View Compliance Calendar"},{"action":"View Completed Orders"},{"action":"Print Invoice"},{"action":"Set up Attorney/Tax Consultation"},{"action":"Company Profile"},{"action":"Account Profile"},{"action":"Make a Payment"}]},"page":{"pageName":"My Test Page","startDateTime":"2017-03-20T17:01:13.744Z","endDateTime":"2017-03-20T17:01:23.743Z"}}';

			req.requestURI = 'https://legalzoom--janesbox2.cs11.my.salesforce.com/services/apexrest/LeadOpportunityAPI/';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueOf(requestBody);

			Test.startTest();
			RestContext.request = req;
			RestContext.response = res;

			LeadOpportunityAPI.createOrUpdateLeadOrOpportunity();

			System.debug(req);
			System.debug(res);

			Test.stopTest();
		}

}