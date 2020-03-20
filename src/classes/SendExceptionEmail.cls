public with sharing class SendExceptionEmail 
{
    final static String SF_ERROR = 'Salesforce System';
    final static String SF_TEAM = 'Salesforce Team';

    public static void sendDMLExceptionEmail(DmlException dmlEx , String subject)
    {
        Messaging.SingleEmailMessage mail= getEmailMessage(subject);       
        String errorMessage = '';
        for(Integer i =0;i<dmlEx.getNumDml();++i)
        {
            errorMessage += dmlEx.getDmlMessage(i)+'---';
            errorMessage += 'Id of the record causing error '+ dmlEx.getDmlId(i)+'----';
            errorMessage += 'Field causing error -> ';
            String fieldNames = '';
            for(String fieldName : dmlEx.getDmlFieldNames(i))
            {
                fieldNames += fieldName+',';
            }
            errorMessage += fieldNames;
        }
        mail.setPlainTextBody(errorMessage);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

    public static void sendExceptionEmail(Exception theException , String subject)
    {
         Messaging.SingleEmailMessage mail= getEmailMessage(subject);
         String errorMessage = '';
         errorMessage += '\nLine Number : '+theException.getLineNumber();
         errorMessage += '\nMessage : '+theException.getMessage();
         errorMessage += '\nStacktrace : '+theException.getStackTraceString();
         errorMessage += '\nUser : '+UserInfo.getName();
         mail.setPlainTextBody(errorMessage);
         if(!Test.isRunningTest())
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

    public static void sendIADExceptionEmail(IADException theException , String subject)
    {
         Messaging.SingleEmailMessage mail= getEmailMessage(subject);
         String errorMessage = '';
         errorMessage += '\nLine Number : '+theException.getLineNumber();
         errorMessage += '\nMessage : '+theException.getMessage();
         errorMessage += '\nStacktrace : '+theException.getStackTraceString();
         errorMessage += '\nUser : '+UserInfo.getName();
         mail.setPlainTextBody(errorMessage);
         if(!Test.isRunningTest())
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

    public static Messaging.SingleEmailMessage  getEmailMessage(String theSubject)
    {
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        SalesforceTeamEmail__c sfTeamEmail = SalesforceTeamEmail__c.getValues(SF_TEAM);
        List<String> toAddresses = new List<String>();
        if(Test.isRunningTest())
        {
            toAddresses.add('salesforceteam@legalzoom.com');
        }
        else
        {
            toAddresses = new String[] {sfTeamEmail.Email__c};
        }
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName(SF_ERROR);
        mail.setSubject(theSubject+' : ' + UserInfo.getOrganizationName());
        return mail;
    }

    public static void sendGenericErrorEmal(String emailMessage , String subject)
    {
         Messaging.SingleEmailMessage mail= getEmailMessage(subject);
         mail.setPlainTextBody(emailMessage+UserInfo.getName());
         if(!Test.isRunningTest())
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

     
    public static void sendIADRequestResponseEmail(APIRequestResponseWrapper theResponse , String theSubject)
    {
        Messaging.SingleEmailMessage mail= getEmailMessage('IAD '+theSubject);
        String errorMessage = '';

        for(String key : theResponse.objectTypeToId.keySet())
        {
            String value = theResponse.objectTypeToId.get(key);
            errorMessage += '\n'+key + ' : ' + value;
        }
        errorMessage += '\nEnd Point : '+theResponse.callURL;
        errorMessage += '\nRequest Type : '+theResponse.requestType;

        //scrub account number
        if(theResponse.endPointConfig.label=='PostNewPaymentProfile')
        {
            IADContractBeans.IADNewPaymentProfileRequestBean deserialzedProfile =  (IADContractBeans.IADNewPaymentProfileRequestBean) JSON.deserialize(theResponse.payload, IADContractBeans.IADNewPaymentProfileRequestBean.class);

            if(deserialzedProfile.paymentProfile.accountType == UtilityLibrary.profileNameToAccountTypeMap.get('American Express'))
                deserialzedProfile.paymentProfile.accountNumber = deserialzedProfile.paymentProfile.firstDigit + 'xxxx-xxxxx-x' + deserialzedProfile.paymentProfile.last4Digits;
            else
                deserialzedProfile.paymentProfile.accountNumber = deserialzedProfile.paymentProfile.firstDigit + 'xxx-xxxx-xxx' + deserialzedProfile.paymentProfile.last4Digits;

            theResponse.payload = JSON.serialize(deserialzedProfile);
        }

        errorMessage += '\nPayload : '+theResponse.payload;
        errorMessage += '\nResponse : '+theResponse.responseData;
        errorMessage += '\nStatus Code : '+theResponse.statusCode;
        errorMessage += '\nError Message : '+theResponse.errorMessage;
        errorMessage += '\nUser : '+UserInfo.getName();



        mail.setPlainTextBody(errorMessage);
        if(!Test.isRunningTest())
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    public static void sendDatabaseBatchExceptionEmail(String errorMessage, String name )
    {
        Messaging.SingleEmailMessage mail= getEmailMessage('Exception: Records in ' + name + ' Batch job failed');

        String errorBody = '\nThe following error(s) have occurred. ' + errorMessage;
        mail.setPlainTextBody(errorBody);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    public static void sendDeleteExceptionEmail(String errorMessage, String name )
    {
        Messaging.SingleEmailMessage mail= getEmailMessage('Exception: Records in ' + name + ' Delete job failed');

        String errorBody = '\nThe following error(s) have occurred. ' + errorMessage;
        mail.setPlainTextBody(errorBody);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    public static void sendBatchExceptionEmail(Exception theException , String name )
    {
        Messaging.SingleEmailMessage mail= getEmailMessage('Exception: ' + name + ' Batch job failed');
        String errorMessage = '';
        errorMessage += '\nLine Number : '+theException.getLineNumber();
        errorMessage += '\nMessage : '+theException.getMessage();
        errorMessage += '\nStacktrace : '+theException.getStackTraceString();
        errorMessage += '\nUser : '+UserInfo.getName();
        mail.setPlainTextBody(errorMessage);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


}