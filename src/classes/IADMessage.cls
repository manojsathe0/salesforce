public with sharing class IADMessage 
{
    
    public String msgType{get;set;}
    public String message{get;set;}
    public Boolean hasMessage{get;set;}
    public IADMessage(){}
    public IADMessage(String theMsgType , String theMessage) 
    {
        system.debug('message :' + theMessage);
        msgType = theMsgType;
        message = theMessage;
        hasMessage = true;
    }
}