//updated B-38758
@isTest
public with sharing class UtilityLibraryTest {

	final static String testDateTime = '2016-11-02T15:18:45.85Z';

	static testMethod void testparseIADDatetime()
	{
		Test.startTest();
		DateTime theDateTime = UtilityLibrary.parseIADDatetime(testDateTime);
		Test.stopTest();
	}

	static testMethod void testParseIADDate()
	{
		Test.startTest();
		Date theDate = UtilityLibrary.parseIADDate(testDateTime);
		Test.stopTest();
	}

	static testMethod void testConvertJSDateToIADDate()
	{
		Test.startTest();
		String theDate = UtilityLibrary.convertJSDateToIADDate('11/18/2016' , '');
		Test.stopTest();
	}


	static testMethod void testConvertJSDateToIADDateDT()
	{
		Test.startTest();
		DateTime theDateTime = UtilityLibrary.convertJSDateToIADDateDT('11/18/2016');
		Test.stopTest();
	}

	static testMethod void testConvertToIADDateNonGMT()
	{
		Test.startTest();
		UtilityLibrary.convertToIADDateNonGMT(DateTime.now() , '');
		Test.stopTest();
	}

	static testMethod void tesConvertToIADDate()
	{
		Test.startTest();
		String theDateTime = UtilityLibrary.convertToIADDate(Datetime.now());
		Test.stopTest();
	}

	static testMethod void testConvertToIADContactActive()
	{
		Test.startTest();
		String theFlag = UtilityLibrary.convertToIADContactActive(false);
		Test.stopTest();
	}

	static testMethod void testConvertToIADContactType()
	{
		Test.startTest();
		String theTypeId = UtilityLibrary.convertToIADContactType('Primary Contact');
		Test.stopTest();
	}

	static testMethod void testGetCaseTasksMap()
	{
		List<Case> testCases = TestUtils.createCases(5, true);
		Set<Id> caseIds = new Set<Id>();
		for(Case theCase : testCases)
		{
			caseIds.add(theCase.Id);
		}
		Test.startTest();
		Map<Id,Map<Id,Task>> theMap = UtilityLibrary.GetCaseTasksMap(caseIds);
		Test.stopTest();
	}

	static testMethod void testGetLocalTime()
	{
		Test.startTest();
		UtilityLibrary.getLocalTime(testDateTime);
		Test.stopTest();
	}

	static testMethod void testGetIADDateTime()
	{
		Test.startTest();
		UtilityLibrary.getIADDateTime(testDateTime);
		Test.stopTest();
	}

	static testMethod void testGetIADDateTimeDT()
	{
		Test.startTest();
		UtilityLibrary.getIADDateTimeDT(testDateTime);
		Test.stopTest();
	}

	static testMethod void testGetLeadTealiumUpdateFields()
	{
		Test.startTest();
		UtilityLibrary.getLeadTealiumUpdateFields();
		Test.stopTest();
	}

	static testMethod void testGetContactTealiumUpdateFields()
	{
		Test.startTest();
		UtilityLibrary.getContactTealiumUpdateFields();
		Test.stopTest();
	}

	static testMethod void testStateToStateIdsMap()
	{
		Test.startTest();
		Map<String,Decimal> theMap = UtilityLibrary.stateToStateIdsMap;
		Test.stopTest();
	}

	static testMethod void testStateIdsToStateMap()
	{
		Test.startTest();
		Map<Decimal,String> theMap = UtilityLibrary.stateIdsToStateMap;
		Test.stopTest();
	}

	static testMethod void stateToStateCodeMap()
	{
		Test.startTest();
		Map<String,String> theMap = UtilityLibrary.stateToStateCodeMap;
		Test.stopTest();
	}

	static testMethod void stateCodeToStateMap()
	{
		Test.startTest();
		Map<String,String> theMap = UtilityLibrary.stateCodeToStateMap;
		Test.stopTest();
	}

	static testMethod void testPaymentReasons()
	{
		Test.startTest();
		List<SelectOption> theOptions = UtilityLibrary.paymentReasons;
		Test.stopTest();
	}

	static testMethod void testRefundReasons()
	{
		Test.startTest();
		List<SelectOption> theOptions = UtilityLibrary.refundReasons;
		Test.stopTest();
	}

	static testMethod void testExpMonths()
	{
		Test.startTest();
		List<SelectOption> theOptions = UtilityLibrary.expMonths;
		Test.stopTest();
	}

	static testMethod void testExpYears()
	{
		Test.startTest();
		List<SelectOption> theOptions = UtilityLibrary.expYears;
		Test.stopTest();
	}

	static testMethod void testStatePicklist()
	{
		Test.startTest();
		List<SelectOption> theOptions = UtilityLibrary.statePicklist;
		Test.stopTest();
	}

	static testmethod void testProfileAccountTypeToNameMap()
	{
		Test.startTest();
		Map<String,String>  theMap = UtilityLibrary.profileAccountTypeToNameMap;
		Test.stopTest();
	}

	static testMethod void testProfileNameToAccountTypeMap()
	{
		Test.startTest();
		Map<String,String> theMap = UtilityLibrary.profileNameToAccountTypeMap;
		Test.stopTest();
	}

	static testMethod void testProfileAccountTypetoNameMapCC()
	{
		Test.startTest();
		Map<String,String> theMap = UtilityLibrary.profileAccountTypeToNameMapCC;
		Test.stopTest();
	}

	static testMethod void testProfilePaymentNameToTypeMap()
	{
		Test.startTest();
		Map<String,String> theMap = UtilityLibrary.profilePaymentNameToTypeMap;
		Test.stopTest();
	}

	static testMethod void testPaymentTypes()
	{
		Test.startTest();
		List<SelectOption> theOptions = UtilityLibrary.paymentTypes;
		Test.stopTest();
	}

	static testMethod void testValidateEmail()
	{
		Test.startTest();
		Boolean isValid = UtilityLibrary.validateEmail('hello@yahoo.com');
		System.assert(isValid , 'Email should be valid');
		Test.stopTest();
	}
	static testmethod void stripStoreCreditOrProfileId()
	{
		Test.startTest();
		String str = UtilityLibrary.stripStoreCreditOrProfileId('sc1234');
		System.assert(!(str.contains('sc')), 'String should not contain sc.');
		Test.stopTest();
	}
	static testmethod void generateUpdatedBy()
	{
		Test.startTest();
		String str = UtilityLibrary.generateUpdatedBy();
		System.assert(UtilityLibrary.isNotNullOrBlank(str), 'String should contain username.');
		Test.stopTest();
	}
	static testMethod void getConfig()
	{
		Test.startTest();
		IAD_Config__mdt metaData = UtilityLibrary.getConfig();
		System.assert(metaData!= null, 'Should have metadata');
		Test.stopTest();
	}
	static testMethod void getIntegrationUser()
	{
		Test.startTest();
		User u = UtilityLibrary.integrationUser;
		System.assert(u!= null, 'Integration user should exist');
		Test.stopTest();
	}
	static testMethod void sendEmail()
	{
		Test.startTest();
		Boolean sendEmail = UtilityLibrary.sendEmail;
		System.assert(sendEmail == null, 'Should not send emails during tests');
		Test.stopTest();
	}
	static testMethod void getElapsedMinutes()
	{
		Test.startTest();
		Integer num = UtilityLibrary.GetElapsedMinutes(Datetime.now(), Datetime.now().addDays(1));
		System.assert(num != null, 'Should calculate the time');
		Test.stopTest();
	}
	static testMethod void testIfNotBlankThenCopy()
	{
		Test.startTest();
			String str;
			String strToCheck = 'test';
			strToCheck = UtilityLibrary.ifNotBlankThenCopy(strToCheck);
			str = UtilityLibrary.ifNotBlankThenCopy(str);
		Test.stopTest();
	}
	static testMethod void getAllIntegrationUsers()
	{
		Test.startTest();
		List<Integration_User_Config__mdt> intUsrs = UtilityLibrary.allIntegrationUsers;
		Test.stopTest();
	}
	static testMethod void getAllIntegrationUserIds()
	{
		Test.startTest();
		Set<Id> intUsrsIds = UtilityLibrary.allIntegrationUserIds;
		Test.stopTest();
	}
    static testMethod void getPermissionAssignedOrNotStatus()
	{
		Test.startTest();
		Boolean isPermissionSetAssigned = UtilityLibrary.isPermissionSetAssigned(UserInfo.getUserId(), UtilityLibrary.PERMISSION_SET1);
		Test.stopTest();
	}
}