@isTest
public class PhoneFormatterTest 
{
	static testMethod void testFormatPhone_Basic()
	{
		String phoneNumber = '5555555555';
		Test.startTest();
			String formatterNumber = PhoneFormatter.formatPhone(phoneNumber);
		Test.stopTest();
		
		System.assertEquals('(555) 555-5555' , formatterNumber ,'Phone number should have been correctly formatted');
	}
	
	static testMethod void testFormatPhone_Complex()
	{
		String phoneNumber = '5555555555ext 23';
		Test.startTest();
			String formatterNumber = PhoneFormatter.formatPhone(phoneNumber);
		Test.stopTest();
		
		System.assertEquals('(555) 555-5555 ext 23' , formatterNumber ,'Phone number should have been correctly formatted');
	}
	
	static testMethod void testFormatPhone_Complex_Strip1()
	{
		String phoneNumber = '15555555555ext 23';
		Test.startTest();
			String formatterNumber = PhoneFormatter.formatPhone(phoneNumber);
		Test.stopTest();
		
		System.assertEquals('(555) 555-5555 ext 23' , formatterNumber ,'Phone number should have been correctly formatted');
	}
}