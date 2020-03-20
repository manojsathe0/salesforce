public with sharing class ExternalEndpointService 
{
	public ExternalEndpointService() 
	{
		
	}
	
	public static External_Endpoint__c getEndpointCustomSetting()
	{
		String theUserName = UserInfo.getUserName();
		String theEnvironment = theUserName.substring(theUserName.lastIndexOf('.')+1 , theUserName.length());
		return External_Endpoint__c.getInstance(theEnvironment);
	}
}