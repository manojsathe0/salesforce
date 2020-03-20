@isTest
public class TaskServiceTest
{
    static List<Task> testLeadTasks;
    static List<Lead> testLeads;
    static final String LAST_NAME = 'Test Last Name';
    static final Integer SIZE = 2;
    static final String EAMIL_USER = 'Email to Case User';
    
    static void setupData()
    {
        setupDataSEAD();
        testLeadTasks = new List<Task>();
        testLeads = TestUtils.createLeads(SIZE , LAST_NAME , true);
        for(Lead theLead : testLeads)
        {
            for(Task theTask : TestUtils.createTasks(SIZE, null , false))
            {
                theTask.WhoId = theLead.Id;
                theTask.Commission_Eligible__c = true;
                testLeadTasks.add(theTask);
            }
        }
    }
    static void setupDataSEAD()
    {
        SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.Lead_New_Stage_Activity_Limit__c = 1;
        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
        config.Lead_Abandoner_Score__c = 1;
        config.Lead_Chat_Score__c = 1;
        config.Lead_Days_from_Ownership__c = 2;
        config.Lead_Email_Score__c = 1;
        config.Lead_Inbound_Score__c = 2;
        config.Lead_Mobile_Score__c = 3;
        config.Lead_Score_Initial__c = 3;
        config.Lead_Social_Media_Score__c = 1;


        insert config;
    }
    static testMethod void testOrderMatchingCreation_OnInsert()
    {
        setupData();
        List<Task> allTasks = new List<Task>();
        alltasks.addAll(testLeadTasks);
        
        Test.startTest();
            insert allTasks;
        Test.stopTest();
        
        List<Order_Matching_Activity__c> orderMatchingActivities = [SELECT Id FROM Order_Matching_Activity__c];
        System.assertEquals(4 , orderMatchingActivities.size() , '4 Order matching activities should have been created');
    }
    
    static testMethod void testOrderMatchingCreation_OnUpdate()
    {
        setupData();
        List<Task> allTasks = new List<Task>();
        alltasks.addAll(testLeadTasks);
        for(Task theTask : allTasks)
        {
            theTask.Commission_Eligible__c = false;
        }
        insert allTasks;
        
        for(Task theTask : allTasks)
        {
            theTask.Commission_Eligible__c = true;
        }
        Test.startTest();
            update allTasks;
        Test.stopTest();
        List<Order_Matching_Activity__c> orderMatchingActivities = [SELECT Id FROM Order_Matching_Activity__c];
        System.assertEquals(4 , orderMatchingActivities.size() , '4 Order matching activities should have been created');
    }
    
    static testMethod void testOrderMatchingCreation_OnInsertWithContact()
    {
        setupData();
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(SIZE , 'Test Contact', testAccount.Id, true);
        List<Task> allTasks = new List<Task>();
        for(Contact theContact : testContacts)
        {
            for(Task theTask : TestUtils.createTasks(SIZE, null , false))
            {
                theTask.WhoId = theContact.Id;
                theTask.Commission_Eligible__c = true;
                allTasks.add(theTask);
            }
        }
        Test.startTest();
            insert allTasks;
        Test.stopTest();
        List<Order_Matching_Activity__c> orderMatchingActivities = [SELECT Id FROM Order_Matching_Activity__c];
        System.assertEquals(4 , orderMatchingActivities.size() , '4 Order matching activities should have been created(2 COntacts * 2 Tasks = 4 OMAs)');
    }
    
    static testMethod void testNoOrderMatchingCreation_OnInsertWithAccount()
    {
        setupData();
        List<Account> testAccounts = TestUtils.createAccounts(SIZE , 'Test Account' , true); 
        List<Task> allTasks = new List<Task>();
        for(Account theAccount : testAccounts)
        {
            for(Task theTask : TestUtils.createTasks(SIZE, null , false))
            {
                theTask.WhatId = theAccount.Id;
                theTask.Commission_Eligible__c = true;
                allTasks.add(theTask);
            }
        }
        Test.startTest();
            insert allTasks;
        Test.stopTest();
        List<Order_Matching_Activity__c> orderMatchingActivities = [SELECT Id FROM Order_Matching_Activity__c];
        System.assertEquals(0 , orderMatchingActivities.size() , 'No Order matching activities should have been created');
    }
    

    static testMethod void testUpdateOnOrderMatchingActivityWithLead()
    {
        setupData();
        insert testLeadTasks[0];
        
        testLeadTasks[0].Contacted__c = true;
        
        Test.startTest();
            update testLeadTasks[0];
        Test.stopTest();
        List<Order_Matching_Activity__c> orderMatchingActivities = [SELECT Id , Activity_Contacted__c FROM Order_Matching_Activity__c WHERE Activity_SFDC_Id__c =:testLeadTasks[0].Id];
        
        System.assertEquals(1 , orderMatchingActivities.size() , 'There should be 1 order matching activity');
        System.assertEquals(true , orderMatchingActivities[0].Activity_Contacted__c , 'Activity contacted should be true');
    }
    
    static testMethod void populateTaskFields()
    {
        setupData();
        User testUser = TestUtils.createUser('Buffet', TestUtils.STANDARD_PROFILE_ID);
        testUser.Sales_Team__c = 'Inbound';
        
        System.runAs(TestUtils.ADMIN_USER)
        {
            insert testUser;
        }
        Task theTask;
        Lead testLead;
        System.runAs(testUser)
        {
            testLead = TestUtils.createLeads(1 ,  'Jimmy' , true)[0];
            theTask = TestUtils.createTasks(1 , null , false)[0];
            theTask.WhoId = testLead.Id;
            theTask.Commission_Eligible__c = true;
            Test.startTest();
                insert theTask;
            Test.stopTest();
        }
        
        List<Task> updatedTasks = [SELECT Id , Inbound_Outbound__c FROM Task WHERE Id = :theTask.Id];
        System.assertEquals(1 , updatedTasks.size() , '1 record should have been returned');
    }
    
    static testMethod void testPreventOrderNoteEdit()
    {
        setupData();
        User testUser = TestUtils.createUser('Buffet', TestUtils.STANDARD_PROFILE_ID);     
        System.runAs(testUser)
        {
            Task theTask = new Task();
            theTask.Description = 'Test Edit orderNote';
            theTask.Subject = 'Order Note';
            theTask.Type = 'Note';
            insert theTask;
            theTask.Contacted__c = true;
            try
            {
                database.saveresult sr = database.update(theTask);
                if(!sr.isSuccess()) 
                {
                    Database.Error error = sr.getErrors()[0];
                    system.assertEquals(error.getMessage(),'Tasks with type Note cannot be edited');
                }
            }
            catch(Exception exp)
            {
            }
        }
    }

    static testMethod void testPopulateLeadScoreOnTaskWithLeads()
    {
        setupData();
        for(Lead theLead : testLeads)
        {
            theLead.Lead_Score_Non_Time_Sensitive__c = 20;
        }
        update testLeads;

        List<Task> allTasks = new List<Task>();
        for(Lead theLead : testLeads)
        {
            for(Task theTask : TestUtils.createTasks(SIZE, null , false))
            {
                theTask.WhoId = theLead.Id;
                theTask.Commission_Eligible__c = true;
                allTasks.add(theTask);
            }
        }
        //25 Tasks in total
        Test.startTest();
            insert allTasks;
        Test.stopTest();

        List<Task> updatedTasksWithScore = [SELECT Id, Lead_Score__c FROM Task WHERE Id IN :allTasks];
        System.assertEquals(4 , updatedTasksWithScore.size() , '4 Tasks should have been returned');
        //Lead Score becomes 20+30 = 50.Any leads that are created today gets flat score of 30 on top od existing score
        for(Task theTask : updatedTasksWithScore)
        {
            System.assertEquals(50 , theTask.Lead_Score__c , 'Right lead score should have been populated');
        }
        List<Order_Matching_Activity__c> createdOMAs = [SELECT Id, Lead_Score__c FROM Order_Matching_Activity__c];
        System.assertEquals(4 , createdOMAs.size() , '4 OMAs should have been returned');
        for(Order_Matching_Activity__c theOMA : createdOMAs)
        {
            System.assertEquals(50 , theOMA.Lead_Score__c , 'Right lead score should have been populated');
        }

    }

    static testMethod void testPopulateLeadScoreOnTaskWithContacts_Insert()
    {
        setupData();
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(SIZE , 'Test Contact', testAccount.Id, false);
        for(Contact theContact : testContacts)
        {
            theContact.Lead_Score_Non_Time_Sensitive__c = 20;
        }
        insert testContacts;

        List<Task> allTasks = new List<Task>();
        for(Contact theContact : testContacts)
        {
            for(Task theTask : TestUtils.createTasks(SIZE, null , false))
            {
                theTask.WhoId = theContact.Id;
                theTask.Commission_Eligible__c = true;
                allTasks.add(theTask);
            }
        }
        //25 Tasks in total
        Test.startTest();
            insert allTasks;
        Test.stopTest();

        List<Task> updatedTasksWithScore = [SELECT Id, Lead_Score__c FROM Task WHERE Id IN :allTasks];
        System.assertEquals(4 , updatedTasksWithScore.size() , '4 Tasks should have been returned');
        for(Task theTask : updatedTasksWithScore)
        {
            System.assertEquals(20 , theTask.Lead_Score__c , 'Right lead score should have been populated');
        }
        List<Order_Matching_Activity__c> createdOMAs = [SELECT Id, Lead_Score__c FROM Order_Matching_Activity__c];
        System.assertEquals(4 , createdOMAs.size() , '4 OMAs should have been returned');
        for(Order_Matching_Activity__c theOMA : createdOMAs)
        {
            System.assertEquals(20 , theOMA.Lead_Score__c , 'Right lead score should have been populated');
        }

    }
    

    static testMethod void testPopulateLeadScoreOnTaskWithContacts_Update()
    {
        setupData();
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(SIZE , 'Test Contact', testAccount.Id, false);
        for(Contact theContact : testContacts)
        {
            theContact.Lead_Score_Non_Time_Sensitive__c = 20;
        }
        insert testContacts;

        List<Task> allTasks = new List<Task>();
        for(Task theTask : TestUtils.createTasks(SIZE, null , false))
        {
            allTasks.add(theTask);
        }
        insert allTasks;
        Integer i = 0;
        for(Contact theContact : testContacts)
        {
            allTasks[i].WhoId = theContact.Id;  
            allTasks[i].Commission_Eligible__c = true;
            ++i;
        }
        
        Test.startTest();
            update allTasks;
        Test.stopTest();

        List<Task> updatedTasksWithScore = [SELECT Id, Lead_Score__c FROM Task WHERE Id IN :allTasks];
        System.assertEquals(SIZE , updatedTasksWithScore.size() , SIZE +' Tasks should have been returned');
        for(Task theTask : updatedTasksWithScore)
        {
            System.assertEquals(20 , theTask.Lead_Score__c , 'Right lead score should have been populated');
        }
        List<Order_Matching_Activity__c> createdOMAs = [SELECT Id, Lead_Score__c FROM Order_Matching_Activity__c];
        System.assertEquals(SIZE , createdOMAs.size() , SIZE +' OMAs should have been returned');
        for(Order_Matching_Activity__c theOMA : createdOMAs)
        {
            System.assertEquals(20 , theOMA.Lead_Score__c , 'Right lead score should have been populated');
        }

    }

    
    static testMethod void testUpdateCampaignMemberStatusWithContacts_SalesProfile()
    {
        setupData();
        List<Account> testAccounts = TestUtils.createAccounts(50 , 'Test Account', true);
        List<Contact> testContacts = new List<Contact>();
        for(Account theAccount : testAccounts)
        {
            testContacts.add(TestUtils.createContacts(1 , 'Test Contact', theAccount.Id, false)[0]);
        }
        insert testContacts;
        Campaign testCampaign = TestUtils.createCampaigns(1, 'My Campaign', null , null ,  true)[0];
        List<CampaignMember> campaignMembersToCreate = new List<CampaignMember>();
        for(Contact theContact : testContacts)
        {
            campaignMembersToCreate.add(TestUtils.createCampaignMembers(1 , testCampaign.Id , theContact.Id, null , false)[0]);
        }
        insert campaignMembersToCreate;
        Test.startTest();
            System.runAs(new User(Id = UserInfo.getUserId()))
            { 
                System.runAs(TestUtils.SALES_REP_USER)
                {
                    List<Task> tasksToCreate = new List<Task>();
                    for(Contact theContact : testContacts)
                    {
                        Task theTask = TestUtils.createTasks(1, null , false)[0];
                        theTask.WhoId = theContact.Id;
                        tasksToCreate.add(theTask);
                    }
                    insert tasksToCreate;
                }
            }
        Test.stopTest();
        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember WHERE contactId IN :testContacts];
        System.assertEquals(50 , updatedCampaignMembers.size() , '50 Campaign Members should have been created');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            //System.assertEquals(CampaignConstants.SALES_ACTIVITY , theMember.Status , 'Right Ststaus should have been populated');
        }
    }

    
    static testMethod void testUpdateCampaignMemberStatusWithContacts_SalesProfile_OnUpdate()
    {
        setupData();
        List<Account> testAccounts = TestUtils.createAccounts(50 , 'Test Account', true);
        List<Contact> testContacts = new List<Contact>();
        for(Account theAccount : testAccounts)
        {
            testContacts.add(TestUtils.createContacts(1 , 'Test Contact', theAccount.Id, false)[0]);
        }
        insert testContacts;
        Campaign testCampaign = TestUtils.createCampaigns(1, 'My Campaign', null , null ,  true)[0];
        List<CampaignMember> campaignMembersToCreate = new List<CampaignMember>();
        for(Contact theContact : testContacts)
        {
            campaignMembersToCreate.add(TestUtils.createCampaignMembers(1 , testCampaign.Id , theContact.Id, null , false)[0]);
        }
        insert campaignMembersToCreate;
        Test.startTest();
            System.runAs(new User(Id = UserInfo.getUserId()))
            { 
                System.runAs(TestUtils.SALES_REP_USER)
                {
                    List<Task> tasksToCreate = new List<Task>();
                    for(Integer i = 0 ; i <50 ; ++i)
                    {
                        Task theTask = TestUtils.createTasks(1, null , false)[0];
                        tasksToCreate.add(theTask);
                    }
                   
                    insert tasksToCreate;    
                    
                    Integer i = 0;
                    for(Contact theContact : testContacts)
                    {
                        tasksToCreate[i].WhoId = theContact.Id;  
                        ++i; 
                    }
                    
                    update tasksToCreate;
                }
            }
        Test.stopTest();
        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember WHERE contactId IN :testContacts];
        System.assertEquals(50 , updatedCampaignMembers.size() , '50 Campaign Members should have been created');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            //System.assertEquals(CampaignConstants.SALES_ACTIVITY , theMember.Status , 'Right Ststaus should have been populated');
        }
    }


    static testMethod void testUpdateCampaignMemberStatusWithLeads_SalesProfile_OnInsert()
    {
        setupData();
        List<Lead> testLeads1 = TestUtils.createLeads(50 , 'Test LastName', true);
        Campaign testCampaign = TestUtils.createCampaigns(1, 'My Campaign', null , null ,  true)[0];
        List<CampaignMember> campaignMembersToCreate = new List<CampaignMember>();
        for(Lead theLead : testLeads1)
        {
            campaignMembersToCreate.add(TestUtils.createCampaignMembers(1 , testCampaign.Id , null , theLead.Id , false)[0]);
        }
        insert campaignMembersToCreate;
        Test.startTest();
            System.runAs(new User(Id = UserInfo.getUserId()))
            { 
                User salesUser = TestUtils.SALES_REP_USER;
                insert salesUser;

                for(Lead theLead : testLeads1)
                {
                    theLead.ownerId = salesUser.Id;
                }
                update testLeads1;
                
                System.runAs(salesUser)
                {
                   

                    List<Task> tasksToCreate = new List<Task>();
                    for(Lead theLead : testLeads1)
                    {
                        Task theTask = TestUtils.createTasks(1, null , false)[0];
                        theTask.WhoId = theLead.Id;
                        tasksToCreate.add(theTask);
                    }
                    insert tasksToCreate;
                }
            }
        Test.stopTest();
        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember WHERE leadId IN :testLeads1];
        System.assertEquals(50 , updatedCampaignMembers.size() , '50 Campaign Members should have been created');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            //System.assertEquals(CampaignConstants.SALES_ACTIVITY , theMember.Status , 'Right Ststaus should have been populated');
        }
    }
    
    static testMethod void testUpdateCampaignMemberStatusWithLeads_SalesProfile_OnUpdate()
    {
        setupData();
        List<Lead> testLeads1 = TestUtils.createLeads(50 , 'Test LastName', true);
        Campaign testCampaign = TestUtils.createCampaigns(1, 'My Campaign', null , null ,  true)[0];
        List<CampaignMember> campaignMembersToCreate = new List<CampaignMember>();
        for(Lead theLead : testLeads1)
        {
            campaignMembersToCreate.add(TestUtils.createCampaignMembers(1 , testCampaign.Id , null , theLead.Id , false)[0]);
        }
        insert campaignMembersToCreate;
        Test.startTest();
            System.runAs(new User(Id = UserInfo.getUserId()))
            { 
                User salesUser = TestUtils.SALES_REP_USER;
                insert salesUser;

                for(Lead theLead : testLeads1)
                {
                    theLead.ownerId = salesUser.Id;
                }
                update testLeads1;
                
                System.runAs(salesUser)
                {
                   
                     //First create the task not associated to Lead
                    List<Task> tasksToCreate = TestUtils.createTasks(50, null , true);
                    //update the task.With geneysys Task gets created first and then is updated with lead/contact    
                    //Now associate it to leads
                    Integer i = 0 ; 
                    for(Lead testLead : testLeads1)
                    {

                        tasksToCreate[i].WhoId = testLead.Id;
                        ++i;                           
                    }
                    update tasksToCreate;

                }



            }
        Test.stopTest();
        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember WHERE leadId IN :testLeads1];
        System.assertEquals(50 , updatedCampaignMembers.size() , '50 Campaign Members should have been created');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            //System.assertEquals(CampaignConstants.SALES_ACTIVITY , theMember.Status , 'Right Ststaus should have been populated');
        }
    }

    
    static testMethod void testUpdateCampaignMemberStatusWithLeads_NonSalesProfile()
    {
        setupData();
        List<Lead> testLeads1 = TestUtils.createLeads(50 , 'Test LastName', true);
        Campaign testCampaign = TestUtils.createCampaigns(1, 'My Campaign', null , null ,  true)[0];
        List<CampaignMember> campaignMembersToCreate = new List<CampaignMember>();
        for(Lead theLead : testLeads1)
        {
            campaignMembersToCreate.add(TestUtils.createCampaignMembers(1 , testCampaign.Id , null , theLead.Id , false)[0]);
        }
        insert campaignMembersToCreate;
        Test.startTest();
           
            List<Task> tasksToCreate = new List<Task>();
            for(Lead theLead : testLeads1)
            {
                Task theTask = TestUtils.createTasks(1, null , false)[0];
                theTask.WhoId = theLead.Id;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
               
            
        Test.stopTest();
        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember WHERE leadId IN :testLeads1];
        System.assertEquals(50 , updatedCampaignMembers.size() , '50 Campaign Members should have been created');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            System.assertEquals(CampaignConstants.ADDED , theMember.Status , 'Status should have remained as Added');
        }
    }
    
    static testMethod void testNoOfCallsOn_Case()
    {
        setupData();
        List<Case> newCases =   TestUtils.createCases(SIZE, true);
        List<Task> tasksToInsert = new List<Task>();
        for(Case theCase : newCases)
        {
            for(Integer i = 1; i <= SIZE; i++)
            {
                Task newTask = new task();
                newTask.WhatId = theCase.Id;
                newTask.Type = 'Call';
                newTask.Subject = 'Test Calls on case';
                tasksToInsert.add(newTask);
            }
        }

        Test.startTest();
            insert tasksToInsert;
        Test.stopTest();

        List<Case> updatedCases = [SELECT Total_Phone_Contacts__c FROM Case WHERE Id IN: newCases];

        for(Case theCase : updatedCases)
        {
            system.assertEquals(SIZE , theCase.Total_Phone_Contacts__c, 'Right number of calls should have been populated');
        }
    }

    static testMethod void testNoOfCallsOn_Lead_OnInsert()
    {
        setupData();
        List<Lead> testLead = TestUtils.createLeads(SIZE , LAST_NAME , true);
        List<Task> tasksToInsert = new List<Task>();
        for(Lead theLead : testLead)
        {
            for(Integer i = 1; i <= SIZE; i++)
            {
                Task newTask = new task();
                newTask.WhoId = theLead.Id;
                newTask.Type = 'Call';
                newTask.Subject = 'Test Calls on case';
                tasksToInsert.add(newTask);
            }
        }

        Test.startTest();
            insert tasksToInsert;
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Total_Phone_Contacts__c FROM Lead WHERE Id IN: testLead];

        for(Lead theLead : updatedLeads)
        {
            system.assertEquals(SIZE , theLead.Total_Phone_Contacts__c, 'Right number of calls should have been populated');
        }
    }

    static testMethod void testNoOfCallsOn_Lead_OnUpdate()
    {
        setupData();
        Integer NumberToCreate = 5;
        List<Lead> testLeads1 = TestUtils.createLeads(NumberToCreate , LAST_NAME , true);
        List<Task> tasksToInsert = new List<Task>();
        for(Lead theLead : testLeads1)
        {
            for(Integer i = 1; i <= NumberToCreate; i++)
            {
                Task newTask = new task();
                newTask.Type = 'Call';
                newTask.Subject = 'Test Calls on Lead';
                tasksToInsert.add(newTask);
            }
        }
        insert tasksToInsert;

        Integer j = NumberToCreate;
        for(Lead testLead : testLeads1)
        {
                      
            for(Integer i = j-NumberToCreate ; i<j ; ++i)
            {
                tasksToInsert[i].WhoId = testLead.Id;
            }
            
            j += NumberToCreate;        
        }



        Test.startTest();
            update tasksToInsert;
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Total_Phone_Contacts__c FROM Lead WHERE Id IN: testLeads1];

        for(Lead theLead : updatedLeads)
        {
            system.assertEquals(NumberToCreate , theLead.Total_Phone_Contacts__c, 'Right number of calls should have been populated');
        }
    }


    static testMethod void testNoOfCallsOn_Contact_On_Insert()
    {
        setupData();
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(SIZE , 'Test Contact', testAccount.Id, true);
        List<Task> tasksToInsert = new List<Task>();
        for(Contact testContact : testContacts)
        {
            for(Integer i = 1; i <= SIZE; i++)
            {
                Task newTask = new task();
                newTask.WhoId = testContact.Id;
                newTask.Type = 'Call';
                newTask.Subject = 'Test Calls on case';
                tasksToInsert.add(newTask);
            }
        }

        Test.startTest();
            insert tasksToInsert;
        Test.stopTest();

        List<Contact> updatedContacts = [SELECT Total_Phone_Contacts__c FROM Contact WHERE Id IN: testContacts];

        for(Contact theContact : updatedContacts)
        {
            system.assertEquals(SIZE , theContact.Total_Phone_Contacts__c, 'Right number of calls should have been populated');
        }
    }

    static testMethod void testNoOfCallsOn_Contact_On_Update()
    {
        setupData();
        Integer NumberToCreate = 5;
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(NumberToCreate , 'Test Contact', testAccount.Id, true);
        //First create Call task not associated with any contact for Sales(Record Type Sales Task)
        List<Task> tasksToInsert = new List<Task>();
        for(Integer i = 1; i <= NumberToCreate*NumberToCreate; i++)
        {
            Task newTask = new task();
            newTask.Type = 'Call';
            newTask.Subject = 'Test Calls on case';
            tasksToInsert.add(newTask);
        }
        insert tasksToInsert;

        Integer j = NumberToCreate;
        for(Contact testContact : testContacts)
        {
                      
            for(Integer i = j-NumberToCreate ; i<j ; ++i)
            {
                tasksToInsert[i].WhoId = testContact.Id;
            }
            
            j += NumberToCreate;        
        }



        Test.startTest();
            update tasksToInsert;
        Test.stopTest();

        List<Contact> updatedContacts = [SELECT Total_Phone_Contacts__c FROM Contact WHERE Id IN: testContacts];

        for(Contact theContact : updatedContacts)
        {
            system.assertEquals(NumberToCreate , theContact.Total_Phone_Contacts__c, 'Right number of calls should have been populated');
        }
    }
    
    static testMethod void testPopulateDateTimeFieldsOnActivity()
    {
        setupData();
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(1 , 'Test Contact', testAccount.Id, true);
        Case testCase = TestUtils.createCases(1 , true)[0]; //Workflow rules updates Date_Time_Last_Queue_Assigned__c on Case
     
           
        List<Task> tasksToInsert = new List<Task>();
        User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , true);
        Test.startTest();
            System.runAs(theUser)
            {
                for(Integer i = 0; i < 10; i++)
                {
                    Task newTask = new task();
                    newTask.Type = 'Email';
                    newTask.WhatId = testCase.Id;
                    newTask.Subject = 'Test Email on case';
                    tasksToInsert.add(newTask);
                }
                insert tasksToInsert;
                
            }
        Test.stopTest();

        List<Task> updatedTasks = [SELECT Id , Date_Time_Last_Queue_Assigned__c  FROM Task WHERE Id IN :tasksToInsert];
        System.assertEquals(10 , updatedTasks.size() , '10 tasks should have been created');
        for(Task theTask : updatedTasks)
        {
            System.assertNotEquals( null , theTask.Date_Time_Last_Queue_Assigned__c , 'Date Time Last Queue Signed should have been populated');
        }
    }
    
    static testMethod void testPopulateLastCampaignOnActivity_Contact()
    {
        setupData();
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0]; 
        List<Contact> testContacts = TestUtils.createContacts(1 , 'Test Contact', testAccount.Id, false);
        testContacts[0].Sales_opportunity_latest_campaign__c = 'Inbound';
        insert testContacts;
                   
        List<Task> tasksToInsert = new List<Task>();
        User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , true);
        Test.startTest();
            System.runAs(theUser)
            {
                for(Integer i = 0; i < 10; i++)
                {
                    Task newTask = new task();
                    newTask.Type = 'Call';
                    newTask.Subject = 'Test Task';
                    tasksToInsert.add(newTask);
                }
                insert tasksToInsert;
                
                for(Task theTask : tasksToInsert)
                {
                    theTask.WhoId = testContacts[0].Id;
                }

                update tasksToInsert;
            }

        Test.stopTest();

        List<Task> updatedTasks = [SELECT Id , Last_Campaign__c FROM Task WHERE Id IN :tasksToInsert];
        System.assertEquals(10 , updatedTasks.size() , '10 tasks should have been created');
        for(Task theTask : updatedTasks)
        {
            System.assertEquals( 'Inbound' , theTask.Last_Campaign__c , 'Last Campaign Should have been populated on the Activity');
        }
    }

    static testMethod void testPopulateLastCampaignOnActivity_Lead()
    {
        setupData();
                   
        List<Task> tasksToInsert = new List<Task>();
        User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , true);
        Test.startTest();
            System.runAs(theUser)
            {
                Lead testLead = TestUtils.createLeads(1 , 'TestLead' , false)[0];
                insert testLead;
                for(Integer i = 0; i < 10; i++)
                {
                    Task newTask = new task();
                    newTask.Type = 'Call';
                    newTask.Subject = 'Test Task';
                    tasksToInsert.add(newTask);
                }
                insert tasksToInsert;
                
                for(Task theTask : tasksToInsert)
                {
                    theTask.WhoId = testLead.Id;
                }

                update tasksToInsert;
            }

        Test.stopTest();

        List<Task> updatedTasks = [SELECT Id , Last_Campaign__c FROM Task WHERE Id IN :tasksToInsert];
//        System.assertEquals(10 , updatedTasks.size() , '10 tasks should have been created');
//        for(Task theTask : updatedTasks)
//        {
//            System.assertEquals( 'Inbound' , theTask.Last_Campaign__c , 'Last Campaign Should have been populated on the Activity');
//        }
    }

    static testMethod void testMergeGenesysTaskToSalesInteraction()
    {
        setupData();

        List<Task> tasksToInsert = new List<Task>();
        User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , true);
       
        Test.startTest();
        System.runAs(theUser)
        {
            Task newTask = new task();
            for(Integer i = 0; i < 2; i++)
            {
                newTask = new task();
                newTask.Type = 'Call';
                newTask.Subject = 'Test Task';
                newTask.Start_Order_Decline_Flow__c = true;
                newTask.RecordTypeId = TaskService.salesTaskRecordTypeId;
                insert newTask;
                tasksToInsert.add(newTask);
            }
            system.debug('tasksToInsert size '+ tasksToInsert.size());

        }
        List<Task> queriedTasks = [select id, Marked_for_Delete__c from Task where Marked_for_Delete__c = true];
        Test.stopTest();

    }
    

}