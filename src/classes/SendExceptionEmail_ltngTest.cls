@isTest
private class SendExceptionEmail_ltngTest
{
    final static String THE_SUBJECT = 'Test Subject';   
    static SalesforceTeamEmail__c sfTeamEmail;
    static
    {
         sfTeamEmail = new SalesforceTeamEmail__c();
         sfTeamEmail.Name = 'Salesforce Team';
         sfTeamEmail.Email__c = 'salesforceteam@legalzoom.com';
         insert sfTeamEmail;
    }
    static testMethod void testSendDMLExceptionEmail()
    {
        Account theAccount = new Account();
        Boolean exceptionOccured = false;
        Test.startTest();
        try
        {
            insert theAccount;  
        }
        catch(DMLException dmlEx)
        {
            SendExceptionEmail_ltng.sendDMLExceptionEmail(dmlEx , THE_SUBJECT);
            exceptionOccured = true;
        }
        Test.stopTest();
        System.assertEquals(true , exceptionOccured , 'Exception should have occured');
    }

    static testMethod void testGetEmailMessage()
    {
        Messaging.SingleEmailMessage mail;
        
        Test.startTest();
            mail = SendExceptionEmail_ltng.getEmailMessage(THE_SUBJECT);
        Test.stopTest();

        System.assertNotEquals(null  , mail , 'EmailMessage should have been created');
    }

    static testMethod void testSendGenereicEmail()
    {
        Test.startTest();
            SendExceptionEmail_ltng.sendGenericErrorEmal('Test Message' , THE_SUBJECT);
        Test.stopTest();
    }

    static testMethod void testSendIADRequestResponseEmail()
    {
        Test.startTest();
            SendExceptionEmail_ltng.sendIADRequestResponseEmail(new APIRequestResponseWrapper_ltng(), 'IAD API Response');
        Test.stopTest();
    }

    
    static testMethod void testSendExceptionEmail_ltng()
    {
        String nullString = null;

        Test.startTest();
            try
            {
                nullString.substring(0,1);
                
            }
            catch(Exception theExp)
            {
                SendExceptionEmail_ltng.sendExceptionEmail(theExp , 'Exception');
            }
            
        Test.stopTest();
    }

    static testMethod void testSendIADExceptionEmail()
    {
        try
        {
            String nullString = null;

            Test.startTest();
                try
                {
                    nullString.substring(0,1);
                    
                }
                catch(Exception theExp)
                {
                    throw new IADException('IAD Exception' , theExp);
                    
                }
                
            Test.stopTest();
        }
        catch(IADException theIADException)
        {
            SendExceptionEmail_ltng.sendIADExceptionEmail(theIADException , 'IAD Exception');
        }
    }
    static testMethod void testSendBatchEmailException()
    {
        try
        {
            String nullString = null;
            nullString.substring(0,1);

        }
        catch(Exception theExp)
        {
            SendExceptionEmail_ltng.sendDatabaseBatchExceptionEmail('test name' , 'batch Exception');
            SendExceptionEmail_ltng.sendDeleteExceptionEmail('test name', 'delete exception');
        }

    }
    static testMethod void testSendDeleteExceptionEmail()
    {
        try
        {
            String nullString = null;
            nullString.substring(0,1);

        }
        catch(Exception theExp)
        {
            SendExceptionEmail_ltng.sendBatchExceptionEmail(theExp , 'batch Exception');
        }

    }

}