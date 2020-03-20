@isTest
public class USPTOEmailParserTest
{
	public static String USPTOId = 'USPTO/BAS-208.30.2.66-20140721190010314970-New/Application-500fa093d7ce682cebaa3ab5416e032d4561a1934e6f370aab396d24ce84be3b3';
	public static String firstEmailBody;	
	public static String secondEmailBody;	
	public static String thirdEmailBody;	

	public static String firstEmailSubject;
	public static String secondEmailSubject;
	public static String thirdEmailSubject;
	public final static String SERIAL_NUMBER = '86343742';
	public final static String USER_ORDER_ID = '555216956';
	public final static String TRADEMARK_NAME = 'My Awesome Trademark';
	static
	{
		firstEmailBody = 'You have been sent this message by LegalZoom order # 35409192 Electronic Signature Request for e-signature service through '+
						'the Trademark Electronic Application System (TEAS), U.S. Patent and Trademark Office.'+

						'To sign Trademark/Service Mark Application, Principal Register electronically, please CLICK HERE.'+

						'NOTE: If your mail system does not allow such access directly, highlight the characters appearing in the URL address '+
						'below and copy through your Edit function, then paste into your browser and click enter. If the link below appears '+
						'on 2 separate lines, you must ensure that the entire address appears in the URL line of your browser '+
						'(i.e., that both lines are copied and pasted to create one overall URL address) before clicking on enter.'+

						'http://teas.uspto.gov/submit250/sign.service?id=USPTO/BAS-208.30.2.66-20140721190010314970-New/Application-500fa093d7ce682cebaa3ab5416e032d4561a1934e6f370aab396d24ce84be3b3'+

						'TEAS support team'+
						'Mon Jul 21 19:04:57 EDT 2014'+
						'STAMP: '+USPTOId+'\n'+
						

						'________________________________'+
						'[http://teas.uspto.gov/images/teaslogos.gif]Trademark Electronic Application System (TEAS) service'+
						'U.S. Patent and Trademark Office'+
						'teas@uspto.gov';

		secondEmailBody = '*NOTE*: If your mail system does not allow such access directly, highlight'+
							'the characters appearing in the URL address below and copy through your'+
							'Edit function, then paste into your browser and click enter. If the link'+
							'below appears on 2 separate lines, you must ensure that the entire address'+
							'appears in the URL line of your browser (i.e., that both lines are copied'+
							'and pasted to create one overall URL address) before clicking on enter.'+

							'http://teas.uspto.gov/forms/teas.service?form.action=SIGNRES&formId=bas&id=USPTO/BAS-208.30.2.66-20140721190010314970-New/Application-500fa093d7ce682cebaa3ab5416e032d4561a1934e6f370aab396d24ce84be3b3'+

							'TEAS support team'+
							'Mon Jul 21 19:26:40 EDT 2014'+
							'STAMP:\n'+
							USPTOId+'\n'+

							'------------------------------'+
							'*Trademark Electronic Application System (TEAS) service U.S. Patent and'+
							'Trademark Office teas@uspto.gov <teas@uspto.gov>';

		thirdEmailBody = '1. *YOUR MARK:* '+TRADEMARK_NAME+' (Standard Characters, mark.jpg)\n'+
								'The literal element of the mark consists of Trademark.'+
							'TEAS support team'+
							'Mon Jul 21 19:26:40 EDT 2014'+
							'STAMP:\n'+
							USPTOId+'\n'+

							'------------------------------';						

		firstEmailSubject = USER_ORDER_ID+'; '+TRADEMARK_NAME+' requests you to e-sign the Trademark/Service Mark Application, Principal Register';
		secondEmailSubject = 'Submission link for Trademark/Service Mark Application, Principal Register';
		thirdEmailSubject = 'Serial number '+SERIAL_NUMBER+': Received Your Trademark/Service Mark Application, Principal Register';
	}

	static testmethod void test_getUSPTOEmailWrappers()
	{

		Integer SIZE = 10;
		Case testCase = TestUtils.createCases(1 , true)[0];
		List<EmailMessage> testEmailMessages = TestUtils.createEmailMessages(SIZE , testCase.Id , false);
		for(EmailMessage theMessage : testEmailMessages)
		{
			theMessage.textBody = firstEmailBody;
			theMessage.Subject = firstEmailSubject;
		}

		insert testEmailMessages;

		USPTOEmailParser theEmailParser = new USPTOEmailParser();

		Test.startTest();
			List<USPTOEmailWrapper> USPTOEmailWrappers = theEmailParser.getUSPTOEmailWrappers(testEmailMessages);
		Test.stopTest();

		System.assertEquals(SIZE , USPTOEmailWrappers.size() , '10 USPTO Email Wrappers should have been returned');
		for(USPTOEmailWrapper theEmailWrapper : USPTOEmailWrappers)
		{
			System.assertEquals(testCase.Id , theEmailWrapper.caseId , 'Case Id should have been populated');
		}
	}


	//555216956; Trademark Name requests you to e-sign the Trademark/Service Mark Application, Principal Register
	//Submission link for Trademark/Service Mark Application, Principal Register
	//Serial number 86343742: Received Your Trademark/Service Mark Application, Principal Register
	static testMethod void test_getEmailType()
	{
		

		USPTOEmailParser theEmailParser = new USPTOEmailParser();

		Test.startTest();
			System.assertEquals(USPTOEmailParser.FIRST , theEmailParser.getEmailType(firstEmailSubject));
			System.assertEquals(USPTOEmailParser.SECOND , theEmailParser.getEmailType(secondEmailSubject));
			System.assertEquals(USPTOEmailParser.THIRD , theEmailParser.getEmailType(thirdEmailSubject));
		Test.stopTest();
	}

	//Extracts the Order number and trademark name from the email subject
	//Subject Format : 555216956; Trademark Name requests you to e-sign the Trademark/Service Mark Application, Principal Register
	static testmethod void test_processFirstEmail()
	{
		
		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		USPTOEmailWrapper theEmailWrapper = new USPTOEmailWrapper();
		Test.startTest();
			 theEmailParser.processFirstEmail(firstEmailSubject , theEmailWrapper);
		Test.stopTest();
		
		System.assertEquals(USER_ORDER_ID , theEmailWrapper.userOrderNumber ,'UserOrdernumber value should have been populated');
		System.assertEquals(TRADEMARK_NAME , theEmailWrapper.trademarkName ,'Right trademark name value should have been populated'); 		
	}

	static testmethod void test_processFirstEmailWithNoTrademarkValue()
	{
		
		firstEmailSubject = USER_ORDER_ID+';'+' requests you to e-sign the Trademark/Service Mark Application, Principal Register';
		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		USPTOEmailWrapper theEmailWrapper = new USPTOEmailWrapper();
		Test.startTest();
			 theEmailParser.processFirstEmail(firstEmailSubject , theEmailWrapper);
		Test.stopTest();
		
		System.assertEquals(USER_ORDER_ID , theEmailWrapper.userOrderNumber ,'UserOrdernumber value should have been populated');
		System.assertEquals(null , theEmailWrapper.trademarkName ,'Right trademark name value should have been populated'); 		
	}


	//Extracts the serial number from the Email subject
	//Subject format: Serial number 86343742: Received Your Trademark/Service Mark Application, Principal Register
		
	static testmethod void test_processThirdEmail()
	{
		

		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		USPTOEmailWrapper theEmailWrapper = new USPTOEmailWrapper();
		Test.startTest();
			theEmailParser.processThirdEmail(thirdEmailSubject , theEmailWrapper);
		Test.stopTest();
		
		System.assertEquals(SERIAL_NUMBER , theEmailWrapper.serialNumber ,'Right serial number value should have been populated');
	}

	static testmethod void test_getUSPTOUniqueId()
	{
		
		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		Test.startTest();
			String returnedId = theEmailParser.getUSPTOUniqueId(firstEmailBody);
		Test.stopTest();
				
		System.assertEquals(USPTOId,returnedId,'USPTO Id should have been returned');

	}
	
	static testMethod void test_getTrademarkName()
	{
		String trademarkName = 'TWSS Gear';
		String thirdEmailBody1 = '1. *YOUR MARK:*  '+trademarkName+' (Standard Characters, mark.jpg)\n'+
								'The literal element of the mark consists of TWSS Gear.';

		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		Test.startTest();
			String returnedTrademarkName = theEmailParser.getTrademarkName(thirdEmailBody1);
		Test.stopTest();
				
		System.assertEquals(trademarkName , returnedTrademarkName,'Trademark name should have been returned');
	}
	
	static testMethod void test_getTrademarkNameWithBraces()
	{
		String trademarkName = 'TWSS Gear(My Own)';
		String thirdEmailBody1 = '1. *YOUR MARK:* '+trademarkName+' (Standard Characters, mark.jpg)\n'+
								'The literal element of the mark consists of TWSS Gear.';

		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		Test.startTest();
			String returnedTrademarkName = theEmailParser.getTrademarkName(thirdEmailBody1);
		Test.stopTest();
				
		System.assertEquals(trademarkName , returnedTrademarkName,'Trademark name should have been returned');
	}

	static testMethod void test_getTrademarkNameWith_NoValue()
	{
		
		String thirdEmailBody1 = '1. *YOUR MARK:* (Standard Characters, mark.jpg)\n'+
								'The literal element of the mark consists of TWSS Gear.';

		USPTOEmailParser theEmailParser = new USPTOEmailParser();
		Test.startTest();
			String returnedTrademarkName = theEmailParser.getTrademarkName(thirdEmailBody1);
		Test.stopTest();
				
		System.assertEquals(null , returnedTrademarkName,'Trademark name should have been returned');
	}
	

}