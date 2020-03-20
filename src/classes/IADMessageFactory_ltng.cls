public with sharing class IADMessageFactory_ltng
{
    public static IADMessage_ltng createMessage(String messageType , String messageBody)
    {
         return new IADMessage_ltng(messageType  , messageBody); 
    }
    
    public static List<IADMessage_ltng> clearMessage()
    {
        return new List<IADMessage_ltng>();
    }
}