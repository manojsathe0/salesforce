public with sharing class IADHelper
{
    public IADHelper()
    {
    }
    
    public static String getAPIBaseURL()
    {
        String theEnvironment = getEnvironmentName();
        String baseURL = '';
        if(theEnvironment != null && theEnvironment != '')
        {
            List<IAD_API_Base_URL__mdt > baseURLs = [SELECT IAD_API_Base_URL__c , DeveloperName FROM IAD_API_Base_URL__mdt WHERE DeveloperName = :theEnvironment];
            if(!baseURLs.isEmpty())
                baseURL = baseURLs[0].IAD_API_Base_URL__c;
        }
        return baseURL;
    }
    
    public static void saveAccessToken(String accessToken)
    {
       String userId = UserInfo.getUserId(); // Current User ID
       if(accessToken != null && accessToken != '')
       {
             List<APIGEE_ACCESS_TOKEN__c> accessTokens = [SELECT Id,Last_Token_Time__c  FROM APIGEE_ACCESS_TOKEN__c WHERE User_Id__c = :userId];
             if(!accessTokens.isEmpty())
             {
                 accessTokens[0].User_Id__c  = userId;
                 accessTokens[0].Access_Token__c  = accessToken;
                 accessTokens[0].Last_Token_Time__c = System.now();
                 update accessTokens[0];
             }
             else
             {
                 APIGEE_ACCESS_TOKEN__c accToken1 = new APIGEE_ACCESS_TOKEN__c();
                 accToken1.User_Id__c = userId;
                 accToken1.Access_Token__c = accessToken;
                 accToken1.Last_Token_Time__c = System.now();
                 insert accToken1;
             
             }
             
       }         
    
    
    }
    
    public static String getEnvironmentName()
    {
        String theUserName = UserInfo.getUserName();
        String theEnvironment = theUserName.substring(theUserName.lastIndexOf('.')+1 , theUserName.length()); 
        return theEnvironment;
    }

    public static Map<String,String> getAppIdToAppURL()
    {
        String theEnvironment = getEnvironmentName();
        String baseURL = '';
        Map<String,String> appIdToAppURL = new Map<String,String>();
        if(theEnvironment != null && theEnvironment != '')
        {
            List<IAD_API_Base_URL__mdt > baseURLs = [SELECT App_Id__c , Box_Base_URL__c FROM IAD_API_Base_URL__mdt WHERE DeveloperName = :theEnvironment];
            if(!baseURLs.isEmpty())
            {
                appIdToAppURL.put(baseURLs[0].App_Id__c , baseURLs[0].Box_Base_URL__c);
            }
        }
        return appIdToAppURL;
    }
}