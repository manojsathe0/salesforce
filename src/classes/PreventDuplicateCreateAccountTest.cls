@isTest
private class PreventDuplicateCreateAccountTest {

    final static String TEST_DUPLICATE_ACCOUNT_NAME = 'FISH';
    final static String TEST_NEW_ACCOUNT_NAME = 'NDK';
    final static String SYS_ADMIN_PROFILE_NAME = 'System Admin- Password Does Not Expire';
    final static String LAST_NAME = 'Echosound';
    final static String LAST_NAME_NEW = 'Echo';
    final static String LAST_NAME_NEW_CUSID = 'Entitile';
    final static String CUSTOMER_ID = 'TestID1234';
    static String testProfile;
    static String URL_SF;
    static User testUser;
    static User testUserNewAccount;
    static User testSystemPassDoNotExpireUser;
    static User testUser_CustomerID;
    static Account testAccount;
    static List<Account> testAcc;
    static List<Account> testAccNewInsert;
    
    static void setUpData(){
        
        Account_Permission_Duplicate__c duplicateALlowedProfileName = new Account_Permission_Duplicate__c();
        duplicateALlowedProfileName.Name = SYS_ADMIN_PROFILE_NAME;
        
        testProfile = [SELECT Id FROM Profile WHERE Profile.Name = 'System Admin- Password Does Not Expire'].Id;
        testSystemPassDoNotExpireUser = [SELECT  Id FROM User WHERE  User.ProfileId =: testProfile and IsActive = true LIMIT 1];
        
        System.runAs(testSystemPassDoNotExpireUser)
        {
            insert duplicateALlowedProfileName;
        }
        
        testUser = TestUtils.createUser(LAST_NAME, TestUtils.STANDARD_PROFILE_ID , false);
        testAccount = TestUtils.createAccounts(1 , TEST_DUPLICATE_ACCOUNT_NAME , false)[0];
        testAccount.Name = TEST_DUPLICATE_ACCOUNT_NAME;     
        insert testAccount;
    
        System.runAs(testUser)
        {
            testAcc = TestUtils.createAccounts(1 , TEST_DUPLICATE_ACCOUNT_NAME, false);
            //testAccount.Name = TEST_DUPLICATE_ACCOUNT_NAME;       
            //insert testAccount;
        }
    }
    
    static void setUpNewAccount(){
        testUserNewAccount = TestUtils.createUser(LAST_NAME_NEW, TestUtils.STANDARD_PROFILE_ID , false);
        System.runAs(testUserNewAccount)
        {
            testAccNewInsert = TestUtils.createAccounts(1 , TEST_NEW_ACCOUNT_NAME, false);
        }
    }
    
    static void setUpDataCustomerID(){
        testUser_CustomerID = TestUtils.createUser(LAST_NAME_NEW_CUSID, TestUtils.STANDARD_PROFILE_ID , false);
        testAccount = TestUtils.createAccounts(1 , TEST_NEW_ACCOUNT_NAME , false)[0];
        testAccount.Name = TEST_NEW_ACCOUNT_NAME;   
        testAccount.Customer_ID__c = CUSTOMER_ID;   
        insert testAccount;
        System.runAs(testUser_CustomerID)
        {
            testAccNewInsert = TestUtils.createAccounts(1 , TEST_NEW_ACCOUNT_NAME, false);
        }
    }

    static testMethod void testDuplicateAccount() {
        setUpData();
       
           System.runAs(testUser)
            {
                Test.startTest();
                    try
                    {
                        insert testAcc;
                    }
                    catch(DMLException dmlEX)
                    {
                    }
                Test.stopTest();
            }
            
            List<Account> accounts = [SELECT Id , Name FROM Account WHERE Id IN :testAcc AND Customer_ID__c != NULL];
            System.assertEquals( 0 , accounts.size() , 'The Account shouldn\'t have been inserted');
    }
    
    static testMethod void testDuplicateAccountInsert_Allow()
    {
        setupData();
        System.runAs(testSystemPassDoNotExpireUser)
        {
            Test.startTest();
                insert testAcc;
            Test.stopTest();
        }
        List<Account> accounts = [SELECT Id , Name FROM Account WHERE Id IN :testAcc];
        System.assertEquals( 1 , accounts.size() , 'The Account should have been insert');
    }
    
    static testMethod void testNewAccount_Insert(){
        setUpNewAccount();
        System.runAs(testUserNewAccount)
        {
            Test.startTest();
                insert testAccNewInsert;
            Test.stopTest();
        }
        List<Account> accounts = [SELECT Id , Name FROM Account WHERE Id IN :testAccNewInsert];
        System.assertEquals( 1 , accounts.size() , 'The Account should have been insert new account.');
    }
    
    static testMethod void testDuplicateAccountInsertAllow_HasCustomerID()
    {
        setUpDataCustomerID();
        System.runAs(testUser_CustomerID)
        {
            Test.startTest();
                    try
                    {
                        insert testAccNewInsert;
                    }
                    catch(DMLException dmlEX)
                    {
                    }
            Test.stopTest();
        }
        List<Account> accounts = [SELECT Id , Name FROM Account WHERE Name = :TEST_NEW_ACCOUNT_NAME AND Customer_ID__c != NULL ORDER BY CreatedDate DESC];
        System.assertEquals( 1 , accounts.size() , 'The Account should have customer ID in account.');
    }

}