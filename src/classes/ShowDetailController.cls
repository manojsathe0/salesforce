global without sharing class ShowDetailController {

    public String contactId {get;set;}
    public String orderId {get;set;}

    public String TSID {get;set;}
    public String hostURL {get;set;}
    public static final String SALESFORCE_BASED_URL = 'Salesforce Based URL'; 
    
    public ShowDetailController()
    {
        getContactRecordID();
        TSID = getTSID();
        hostURL = getHostURL();
    }
    
    public void getContactRecordID()
    {
        String userOrderID = ApexPages.currentPage().getParameters().get('UserOrder');
       
        try
        {
            List<Order_Item__c> orderItemList = [SELECT Order__r.Contact__c , Order__c FROM Order_Item__c WHERE User_Order_ID__c =: userOrderID order by LastModifiedDate desc LIMIT 1];
            if(!orderItemList.isEmpty())
            {
                for(Order_Item__c theItem : orderItemList)
                {
                    contactId = theItem.Order__r.Contact__c;
                    orderId = theItem.Order__c;
                }
            }

        }catch(System.DmlException ex){
            System.debug(ex.getMessage());
        }
        
    }
    
    public String getTSID()
    {
        String userProfile = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        String tsid;
        try
        {           
            Profile_Map_App_ID__c profileMapAppId = Profile_Map_App_ID__c.getInstance(userProfile);
            
            if(profileMapAppId != null)
            {
                tsid = profileMapAppId.TSID__c;
            }
            
        }catch(System.DmlException ex){
            System.debug(ex.getMessage());
        }
        return tsid;
    }
    
    public String getHostURL()
    {
        String hostURL;
        if(URL.getSalesforceBaseUrl().getHost().contains('cs'))
        {
            hostURL = 'https://'+URL.getSalesforceBaseUrl().getHost();
        }
        else
        {
            Salesforce_Host_URL__c host = Salesforce_Host_URL__c.getInstance(SALESFORCE_BASED_URL);
            hostURL = host.Host_URL__c;
        }    
        return hostURL;
    }
}