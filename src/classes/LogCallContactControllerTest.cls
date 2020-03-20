@isTest
public class LogCallContactControllerTest 
{
        static final String CONTACT_STATUS = 'Contacted/Spoke';
        static final String LEAD_STATUS = 'Order Placed';
        static final String COMMISSION_CONTACT_STATUS = 'Contacted/Spoke - Commission Eligible';
        static final String QUALIFIED_INTERESTED = 'Qualified (Interested)';
    
    static testMethod void testCreateTask_ContactStatus()
    {
            Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
            Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
            testContact.Genesys_Interaction_Id__c = '998899';
            insert testContact;


            ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
                LogCallContactController theController = new LogCallContactController(sc);
                PageReference pageRef = Page.LogCallContact;
                pageRef.getParameters().put('id', String.valueOf(testContact.Id));
                Test.setCurrentPage(pageRef);

                Test.startTest(); 
                    theController.theTask.Contact_Status__c = CONTACT_STATUS;
                    theController.theTask.Lead_Status__c = LEAD_STATUS;
                    theController.createEmailTask();
                Test.stopTest();

                List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testContact.Id];
                System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
                List<Contact> contacts = [SELECT Id , Contact_Status__c FROM Contact Where Id = :testContact.Id];
            System.assertEquals(1 , contacts.size() , '1 Contact should have been returned');
            System.assertEquals(CONTACT_STATUS , contacts[0].Contact_Status__c , 'Right Call status should have been populated');
    }

        static testMethod void testCreateTask_LeadStatus()
        {

                Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
                Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
                User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
                System.runAs(theUser)
                {
                    testContact.Genesys_Interaction_Id__c = '998899';
                    insert testContact;

                    Task theTask = new Task();
                    theTask.WhoId = testContact.Id;
                    theTask.Description = 'Test Description';
                    theTask.CallObject = '998899';
                    insert theTask;

                    ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
                    LogCallContactController theController = new LogCallContactController(sc);
                    PageReference pageRef = Page.LogCallContact;
                    pageRef.getParameters().put('id', String.valueOf(testContact.Id));
                    Test.setCurrentPage(pageRef);
                
                    Test.startTest(); 
                         theController.theTask.Contact_Status__c = CONTACT_STATUS;
                         theController.theTask.Lead_Status__c = LEAD_STATUS;
                         theController.createTask();
                    Test.stopTest();
                }        
                List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testContact.Id];
                System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
                List<Contact> contacts = [SELECT Id , Lead_Status__c , ownerId FROM Contact Where Id = :testContact.Id];
                System.assertEquals(1 , contacts.size() , '1 Contact should have been returned');
                System.assertEquals(LEAD_STATUS , contacts[0].Lead_Status__c , 'Right Call status should have been populated');
                System.assertEquals(theUser.Id , contacts[0].ownerId , 'Right owner Id should have been populated');
        
        }

        static testMethod void testCreateCommissionTask()
        {
                
                Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
                Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
                User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
                System.runAs(theUser)
                {
                    testContact.Genesys_Interaction_Id__c = '998899';
                    insert testContact;

                    Task theTask = new Task();
                    theTask.WhoId = testContact.Id;
                    theTask.Description = 'Test Description';
                    theTask.CallObject = '998899';
                    insert theTask;
                    
                    ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
                    LogCallContactController theController = new LogCallContactController(sc);
                    PageReference pageRef = Page.LogCallContact;
                    pageRef.getParameters().put('id', String.valueOf(testContact.Id));
                    Test.setCurrentPage(pageRef);
                
                    Test.startTest(); 
                            theController.theTask.Lead_Status__c = LEAD_STATUS;
                            theController.theTask.Contact_Status__c = COMMISSION_CONTACT_STATUS;
                            theController.createTask();
                    Test.stopTest();
                }
                List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testContact.Id];
                System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
                List<Contact> contacts = [SELECT Id , Lead_Status__c , ownerId ,Contact_Status__c  FROM Contact Where Id = :testContact.Id];
                System.assertEquals(1 , contacts.size() , '1 Contact should have been returned');
                System.assertEquals(QUALIFIED_INTERESTED , contacts[0].Lead_Status__c , 'Right Lead status should have been populated');
                System.assertEquals( COMMISSION_CONTACT_STATUS , contacts[0].Contact_Status__c , 'Right Lead status should have been populated');
                System.assertEquals(theUser.Id , contacts[0].ownerId , 'Right owner Id should have been populated.Lead should have been assigned to User');
        }
        
        static testMethod void testCreateSubscriptionSaveTask()
        {
            Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
            Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , true)[0];
          
            
            Order__c testOrder = TestUtils.createOrders(1, null , false)[0];
            testOrder.Contact__c = testContact.Id;
            insert testOrder;
            
            Order_Item__c testOrderItem = TestUtils.createOrderItems(1, testOrder.Id ,  false)[0];
            testOrderItem.Subscription_Status__c = 'Active';
            insert testOrderItem;


            User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
            
            System.runAs(theUser)
            {
                testContact.Genesys_Interaction_Id__c = '998899';
                testContact.ownerId = theUser.Id;
                update testContact;

                Task theTask = new Task();
                theTask.WhoId = testContact.Id;
                theTask.Description = 'Test Description';
                theTask.CallObject = '998899';
                insert theTask;
                
                ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
                LogCallContactController theController = new LogCallContactController(sc);
                PageReference pageRef = Page.LogCallContact;
                pageRef.getParameters().put('id', String.valueOf(testContact.Id));
                Test.setCurrentPage(pageRef);
                
                Test.startTest();
                        
                        List<SelectOption> selectOptions = theController.getCancellationReasons();
                        System.assert(!selectOptions.isEmpty() , 'Cancellation Reason should not be empty');
                        theController.SubscriptionItems = theController.SubscriptionItems; 
                        
                        theController.theTask.Lead_Status__c = LEAD_STATUS;
                        theController.theTask.Contact_Status__c = COMMISSION_CONTACT_STATUS;
                        theController.theTask.Is_Subscription_Activity__c  = true;
                        theController.subscriptionItems[0].isSelected = true;
                        theController.subsCriptionItems[0].cancellationReason = 'Didn\'t like';
                       
                        theController.createTask();
                Test.stopTest();
            }
            List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testContact.Id];
            System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
            List<Contact> contacts = [SELECT Id , Lead_Status__c , ownerId ,Contact_Status__c  FROM Contact Where Id = :testContact.Id];
            System.assertEquals(1 , contacts.size() , '1 Contact should have been returned');
            System.assertEquals(QUALIFIED_INTERESTED , contacts[0].Lead_Status__c , 'Right Lead status should have been populated');
            System.assertEquals( COMMISSION_CONTACT_STATUS , contacts[0].Contact_Status__c , 'Right Lead status should have been populated');
            System.assertEquals(theUser.Id , contacts[0].ownerId , 'Right owner Id should have been populated.Lead should have been assigned to User');

            List<Order360__c> order360sCreated = [SELECT Id , Reason_for_cancellation__c  FROM Order360__c WHERE Parent_Order_Item__c = :testOrderItem.Id];

            System.assertEquals(1 , order360sCreated.size() , '1 Order 360 record should have been created');
            System.assertEquals('Didn\'t like' , order360sCreated[0].Reason_for_cancellation__c , 'Right reason for cancellation should have been populated');
        }
        
        static testMethod void testCreateSubscriptionSaveTask_WithEmail()
        {
            Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
            Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , true)[0];
          
            
            Order__c testOrder = TestUtils.createOrders(1, null , false)[0];
            testOrder.Contact__c = testContact.Id;
            insert testOrder;
            
            Order_Item__c testOrderItem = TestUtils.createOrderItems(1, testOrder.Id ,  false)[0];
            testOrderItem.Subscription_Status__c = 'Active';
            insert testOrderItem;


            User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
            
            System.runAs(theUser)
            {
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
                LogCallContactController theController = new LogCallContactController(sc);
                PageReference pageRef = Page.LogCallContact;
                pageRef.getParameters().put('id', String.valueOf(testContact.Id));
                Test.setCurrentPage(pageRef);
                
                Test.startTest();
                        
                        
                        theController.SubscriptionItems = theController.SubscriptionItems; 
                        theController.theTask.Lead_Status__c = LEAD_STATUS;
                        theController.theTask.Contact_Status__c = COMMISSION_CONTACT_STATUS;
                        theController.theTask.Is_Subscription_Activity__c  = true;
                        theController.subscriptionItems[0].isSelected = true;
                        theController.createEmailTask();
                Test.stopTest();
            }
            List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testContact.Id];
            System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
            List<Contact> contacts = [SELECT Id , Lead_Status__c , ownerId ,Contact_Status__c  FROM Contact Where Id = :testContact.Id];
            System.assertEquals(1 , contacts.size() , '1 Contact should have been returned');
            System.assertEquals(QUALIFIED_INTERESTED , contacts[0].Lead_Status__c , 'Right Lead status should have been populated');
            System.assertEquals( COMMISSION_CONTACT_STATUS , contacts[0].Contact_Status__c , 'Right Lead status should have been populated');
            System.assertEquals(theUser.Id , contacts[0].ownerId , 'Right owner Id should have been populated.Lead should have been assigned to User');

            List<Order360__c> order360sCreated = [SELECT Id FROM Order360__c WHERE Parent_Order_Item__c = :testOrderItem.Id];

            System.assertEquals(1 , order360sCreated.size() , '1 Order 360 record should have been created');
        }
}