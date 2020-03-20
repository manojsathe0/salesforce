public with sharing class IADMessageFactory
{
    public static IADMessage createMessage(String messageType , String messageBody)
    {
         return new IADMessage(messageType  , messageBody); 
    }
    
    public static List<IADMessage> clearMessage()
    {
        return new List<IADMessage>();
    }
}