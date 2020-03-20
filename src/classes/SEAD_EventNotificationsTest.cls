/*
 Author : Padma S
 Date   : 08/08/2017
 Description: this a test class for SEAD_EventNotifications controller class
*/

@isTest
public class SEAD_EventNotificationsTest {
    
    static List<Event__c> eventUpdates;
    static List<Event__c> allEvents;  
    static List<Lead> testLeads;
    static User testUser; 
    static final Integer RECORD_SIZE = 10;
    static final string LAST_NAME = 'John2';
    static Boolean eventUpdated ;    
	static dateTime dt=System.now();
    
	/*static void setupData()
    {
        TestUtils.createSEADConfig();
        testLeads = TestUtils.createLeads(RECORD_SIZE , LAST_NAME , false);        
        testUser = TestUtils.createUser(LAST_NAME , TestUtils.STANDARD_PROFILE_ID , true);
        
        System.runAs(testUser) 
        {  
            insert testLeads;
        }
        List<Lead> leadlst= [Select Id from Lead where Id IN :testLeads];
        
        for (Integer i=0; i<10; i++ ){
            Event__c event = new Event__c(Name='Event '+i, Event_Time__c =dt, Lead__c=leadlst[0].Id, ownerId=testUser.Id, Is_Inactive__c=false);
            allEvents.add(event);
        }
        System.runAs(testUser) 
        { 
            insert allEvents;
        }
    }*/

    static testMethod void getEventChangesTest(){
        
       
      		TestUtils.createSEADConfig();
        testLeads = TestUtils.createLeads(RECORD_SIZE , LAST_NAME , false);        
        testUser = TestUtils.createUser(LAST_NAME , TestUtils.STANDARD_PROFILE_ID , true);
        
        System.runAs(testUser) 
        {  
            insert testLeads;
        }
        List<Lead> leadlst= [Select Id from Lead where Id IN :testLeads];
        /*for (Integer i=0; i<10; i++ ){
            Event__c event = new Event__c(Name='Event Test ', Event_Time__c =dt, Lead__c=leadlst[0].Id, ownerId=testUser.Id, Is_Inactive__c=false);
            allEvents.add(event);
        }
        System.runAs(testUser) 
        { 
            insert allEvents;
        }*/
        
        	System.runAs(testUser)
            {
                Test.startTest();
            	PageReference pageRef = Page.SEAD_EventNotificationsPage;
                Test.setCurrentPage(pageRef);
            	SEAD_EventNotifications encontroller = new SEAD_EventNotifications();           	
				encontroller.getEventChanges();  
            	Event__c event = new Event__c(Name='Event test', Reminder_Minutes__c='15',  Event_Time__c =dt, Lead__c=leadlst[0].Id, ownerId=testUser.Id, Is_Inactive__c=false);
                
                Insert event;
                event.Event_Time__c=System.now();
                update event;
            	 pageRef.getParameters().put('eventId', event.id);
                encontroller.getEventChanges();
                encontroller.snooze();
                encontroller.dismiss();
            Test.stopTest();

                
            }
    }
        
    }