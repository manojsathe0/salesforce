public with sharing class ExternalEndpointService_ltng 
{
	public static External_Endpoint__c getEndpointCustomSetting()
	{
		String theUserName = UserInfo.getUserName();
		String theEnvironment = theUserName.substring(theUserName.lastIndexOf('.')+1 , theUserName.length());
        system.debug('theEnvironment: '+theEnvironment);
		return External_Endpoint__c.getInstance(theEnvironment);
	}
}