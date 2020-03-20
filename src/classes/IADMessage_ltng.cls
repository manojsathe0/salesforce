public with sharing class IADMessage_ltng
{
    @AuraEnabled public String msgType{get;set;}
    @AuraEnabled public String message{get;set;}
    @AuraEnabled public Boolean hasMessage{get;set;}
    
    public IADMessage_ltng(String theMsgType , String theMessage) 
    {
        system.debug('message :' + theMessage);
        msgType = theMsgType;
        message = theMessage;
        hasMessage = true;
    }
}