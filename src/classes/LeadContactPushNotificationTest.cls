@isTest
public class LeadContactPushNotificationTest 
{
    static List<Contact> testContacts;
    static List<Lead> testLeads;
    static List<Opportunity> testOpps;
    static User testUser; 
    static final Integer RECORD_SIZE = 10;
    static final string LAST_NAME = 'John2';
    static final Integer ACCOUNT_RECORD_SIZE = 10;
    static Object contactValue;
    static Object leadValue;
    static Object oppValue;
    
    static void setupData()
    {
    	System.Debug('SETUPSETUP');
        TestUtils.createSEADConfig();
        testLeads = TestUtils.createLeads(RECORD_SIZE , LAST_NAME , false);
        List<Account> testAccounts = TestUtils.createAccounts(ACCOUNT_RECORD_SIZE, LAST_NAME, true);
        testContacts = TestUtils.createContacts(RECORD_SIZE, LAST_NAME, testAccounts[0].Id, false);
        testUser = TestUtils.createUser(LAST_NAME , TestUtils.STANDARD_PROFILE_ID , true);
        testOpps = TestUtils.createOpportunities(RECORD_SIZE , LAST_NAME , false);
        for (Opportunity opp : testOpps) {
				opp.AccountId = testAccounts[0].Id;
				opp.Contact__c = testContacts[0].Id;
				opp.StageName = 'New';
				opp.Score__c = 300;
				opp.My_Account_End_Time__c = System.Now().addDays(-1);
			}
        System.runAs(testUser) 
        { 
        	insert testOpps;
            insert testContacts;
            insert testLeads;
        }
        String contactField = getContactField();
        String leadField = getLeadField();
        String oppField = getOppField();
        for(Contact theContact : testContacts)
        {
            Object o = theContact.get(contactField);
            theContact.put(contactField, contactValue);
            theContact.Updated_by_Tealium__c = true;
            theContact.ownerId = testUser.Id;
            theContact.Updated_By_Tealium_DateTime__c = System.now();
        }
        for(Lead theLead : testLeads)
        {
            Object o = theLead.get(leadField);
            System.Debug('leadField = ' + leadField + ' and leadValue = ' + leadValue);
            theLead.put(leadField, leadValue);
            theLead.Updated_by_Tealium__c = true;
            theLead.ownerId = testUser.Id;
            theLead.Updated_By_Tealium_DateTime__c = System.now();
        }
        for(Opportunity theOpp : testOpps)
        {
            Object o = theOpp.get(oppField);
            System.Debug('oppField = ' + oppField + ' and oppValue = ' + oppValue);
            theOpp.put(oppField, oppValue);
            theOpp.Updated_by_Tealium__c = true;
            theOpp.ownerId = testUser.Id;
            theOpp.Updated_By_Tealium_DateTime__c = System.now();
        }
        
        System.runAs(testUser) 
        { 
            update testContacts;
            update testLeads;
            update testOpps;
        }
    }
    static String getContactField()
    {
        for(Schema.FieldSetMember fsm : UtilityLibrary.getContactTealiumUpdateFields())
        {
            system.debug('fsm.fieldPath ' + fsm.fieldPath + ' fsm.getType() ' + fsm.getType());
            if(fsm.getType()==Schema.DisplayType.String || fsm.getType()==Schema.DisplayType.TEXTAREA)
            {
                contactValue = 'test';
                return fsm.fieldPath;
            }
            else if(fsm.getType()==Schema.DisplayType.Boolean)
            {
                contactValue = true;
                return fsm.fieldPath;
            }
            else if(fsm.getType()==Schema.DisplayType.Datetime)
            {
                contactValue = System.now(); 
                return fsm.fieldPath;
            }
            else
                contactValue = null;
        }
        return null;
    }
    static String getLeadField()
    {
        for(Schema.FieldSetMember fsm : UtilityLibrary.getLeadTealiumUpdateFields())
        {
            system.debug('fsm.fieldPath ' + fsm.fieldPath + ' fsm.getType() ' + fsm.getType());
            if(fsm.getType()==Schema.DisplayType.String || fsm.getType()==Schema.DisplayType.TEXTAREA)
            {
                leadValue = 'test';
                return fsm.fieldPath;
            }
            else if(fsm.getType()==Schema.DisplayType.Boolean)
            {
                leadValue = true;
                return fsm.fieldPath;
            }
            else if(fsm.getType()==Schema.DisplayType.Datetime)
            {
                leadValue = System.now();
                return fsm.fieldPath;
            }
            else
                leadValue = null;
        }
        return null;
    }
    static String getOppField()
    {
        for(Schema.FieldSetMember fsm : UtilityLibrary.getOppTealiumUpdateFields())
        {
            system.debug('fsm.fieldPath ' + fsm.fieldPath + ' fsm.getType() ' + fsm.getType());
            if(fsm.getType()==Schema.DisplayType.String || fsm.getType()==Schema.DisplayType.TEXTAREA)
            {
                oppValue = 'test';
                return fsm.fieldPath;
            }
            else if(fsm.getType()==Schema.DisplayType.Boolean)
            {
                oppValue = true;
                return fsm.fieldPath;
            }
            else if(fsm.getType()==Schema.DisplayType.Datetime)
            {
                oppValue = System.now();
                return fsm.fieldPath;
            }
            else
                leadValue = null;
        }
        return null;
    }
    static testMethod void testGetAllLeadsAndContactsInfo()
    {
        setupData();
        
        List<LeadContactPushNotificationController.TealiumWrapper> theUpdates;
        System.runAs(testUser)
        {
            Test.startTest();
                LeadContactPushNotificationController controller = new LeadContactPushNotificationController();
                theUpdates = controller.updates;  
                system.debug('theupdates ' + controller.updates);
            Test.stopTest();
        }
        //System.assertEquals(RECORD_SIZE + RECORD_SIZE , theUpdates.size() , RECORD_SIZE + RECORD_SIZE );
        //System.assertEquals(RECORD_SIZE , leadsInfo.size() , RECORD_SIZE);
    }
    static testMethod void testgetContactUpdate()
    {
        setupData();
        
        List<LeadContactPushNotificationController.TealiumWrapper> theUpdates;
        System.runAs(testUser)
        {
            Test.startTest();
                PageReference pageRef = Page.LeadContactPushNotifications;
                Test.setCurrentPage(pageRef);
            
            
                LeadContactPushNotificationController controller = new LeadContactPushNotificationController();
                String contactField = getContactField();
                Contact theContact = testContacts[0];
                theContact.Updated_by_Tealium__c = false;
                update theContact;
                controller = new LeadContactPushNotificationController();
                theUpdates = controller.updates;  
                System.assertEquals(RECORD_SIZE + RECORD_SIZE + RECORD_SIZE-1, theUpdates.size() , RECORD_SIZE + RECORD_SIZE-1);
                theContact.Updated_by_Tealium__c = true;
                Object o = theContact.get(contactField);
                theContact.put(contactField, contactValue);
                update theContact;
                pageRef.getParameters().put('contactId', theContact.id);
                controller.getContactChanges();
                theUpdates = controller.updates;
            Test.stopTest();
        }
        //System.assertEquals(RECORD_SIZE + RECORD_SIZE, theUpdates.size() , RECORD_SIZE + RECORD_SIZE);
    }
    static testMethod void testgetLeadUpdate()
    {
        setupData();
        
        List<LeadContactPushNotificationController.TealiumWrapper> theUpdates;
        System.runAs(testUser)
        {
            Test.startTest();
                PageReference pageRef = Page.LeadContactPushNotifications;
                Test.setCurrentPage(pageRef);
            
            
                LeadContactPushNotificationController controller = new LeadContactPushNotificationController();
                String leadField = getLeadField();
                Lead theLead = testLeads[0];
                theLead.Updated_by_Tealium__c = false;
                update theLead;
                controller = new LeadContactPushNotificationController();
                theUpdates = controller.updates;  
                System.assertEquals(RECORD_SIZE + RECORD_SIZE + RECORD_SIZE-1, theUpdates.size() , RECORD_SIZE + RECORD_SIZE-1);
                theLead.Updated_by_Tealium__c = true;
                Object o = theLead.get(leadField);
                theLead.put(leadField, leadValue);
                update theLead;
                pageRef.getParameters().put('leadId', theLead.id);
                controller.getLeadChanges();
                theUpdates = controller.updates;  
            Test.stopTest();
        }
       // System.assertEquals(RECORD_SIZE + RECORD_SIZE, theUpdates.size() , RECORD_SIZE + RECORD_SIZE);
    }
    
    static testMethod void testgetOppUpdate()
    {
        setupData();
        
        List<LeadContactPushNotificationController.TealiumWrapper> theUpdates;
        System.runAs(testUser)
        {
            Test.startTest();
                PageReference pageRef = Page.LeadContactPushNotifications;
                Test.setCurrentPage(pageRef);
            
            
                LeadContactPushNotificationController controller = new LeadContactPushNotificationController();
                String oppField = getOppField();
                Opportunity theOpp = testOpps[0];
                theOpp.Updated_by_Tealium__c = false;
                update theOpp;
                controller = new LeadContactPushNotificationController();
                theUpdates = controller.updates;  
                System.assertEquals(RECORD_SIZE + RECORD_SIZE + RECORD_SIZE-1, theUpdates.size() , RECORD_SIZE + RECORD_SIZE-1);
                theOpp.Updated_by_Tealium__c = true;
                Object o = theOpp.get(oppField);
                theOpp.put(oppField, oppValue);
                update theOpp;
                pageRef.getParameters().put('oppId', theOpp.id);
                controller.getOppChanges();
                theUpdates = controller.updates;  
            Test.stopTest();
        }
       // System.assertEquals(RECORD_SIZE + RECORD_SIZE, theUpdates.size() , RECORD_SIZE + RECORD_SIZE);
    }

}