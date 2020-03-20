public with sharing class LeadContactInfo 
{
    public String objectId{get;set;}
    public String name{get;set;}
    public String escapedName{get;set;}
    public String status{get;set;}
    public String campaignName{get;set;}
    public String phone{get;set;}
    public String state{get;set;}
    public String product{get;set;}
    public String accountLoginId{get;set;}
    public String dateTimeCreated{get;set;} 
    public String dateTimeModified{get;set;} 
    public Decimal totalActivities{get;set;}
    public String temperature{get;set;}
    public String owner{get;set;}
    public String objectType{get;set;} 
    public Boolean isSelected{get;set;}
    public String orderNumber{get;set;}
    public String accountId{get;set;}
    public String lastActivity{get;set;}
    
    public LeadContactInfo(String theId , String theName  , String theStatus , String theStage , String thePhone , String theState , String theAccountLoginId , String theDateTimeCreated , String theDateTimeModified , String theOwner , String theObjectType , String theAccountId, String theCampaignName, String theLastActivity, Decimal theTotalActivities, String theTemperature, String theProduct)
    {
        objectId = theId;
        name = theName;
        escapedName = String.escapeSingleQuotes(theName);
        status = theStatus;
        phone = thePhone;
        state = theState;
        accountLoginId = theAccountLoginId;
        dateTimeCreated = theDateTimeCreated;
        dateTimeModified = theDateTimeModified;
        owner = theOwner;
        objectType = theObjectType;
        isSelected = false;
        accountId = theAccountId;
        campaignName = theCampaignName;
        lastActivity = theLastActivity;
        totalActivities = theTotalActivities;
        temperature = theTemperature;
        product = theProduct;
    } 
}