public with sharing class SEAD_EventNotifications
{
    public List<Event__c> eventUpdates{get;set;}
    public List<Event__c> allEvents{get;set;}
    public String eventUpdatesJSON{get;set;}
    public String userId{get;set;}
    public Boolean eventUpdated {get;set;}
    public Datetime now {get;set;}
    
     public Boolean getIsClassic() {
    	return (UserInfo.getUiThemeDisplayed() == 'Theme3');
	}

    public SEAD_EventNotifications()
    {
        userId = UserInfo.getUserId();
        eventUpdated = false;
        eventUpdates = new List<Event__c>();
        allEvents = new List<Event__c>();

        initEvents();
    }
    public void initEvents()
    {
        now = datetime.now();
        eventUpdates = [select id, Name, Lead__c, Contact__c, Related_To__c, Event_Time__c, Reminder_Minutes__c, Snoozed_Time__c from Event__c where Event_Time__c = TODAY and ownerId =:userId and Is_Inactive__c = false];
        allEvents = eventUpdates;

        system.debug('allEvents updates ' + allEvents);

        eventUpdatesJSON = JSON.serialize(allEvents);
        system.debug('eventUpdatesJSON ' + eventUpdatesJSON);
        Integer index = 0;
        while (index < eventUpdates.size())
        {
            Event__c theEvent = eventUpdates.get(index);
            Boolean needsRemoval = needsRemoval(theEvent);
            system.debug('needs removal ' + needsRemoval);
            if(needsRemoval)
                eventUpdates.remove(index);
            else
                index++;
        }
        system.debug('event updates ' + eventUpdates);
        if(eventUpdates.size()>0)
        {
            eventUpdated = true;
        }
    }
    public void getEventChanges()
    {
        eventUpdated = false;
        now = datetime.now();
        String eventId = ApexPages.currentPage().getParameters().get('eventId');
        system.debug('eventid ' + eventId);
        List<Event__c> theEventUpdate = [select id, Name, Event_Time__c, Reminder_Minutes__c, Snoozed_Time__c from Event__c where Event_Time__c = TODAY and ownerId =:userId and Is_Inactive__c = false and Id =: eventId limit 1];
        if(theEventUpdate.size() > 0)
        {
            eventUpdates.clear();
            initEvents();
            if(!needsRemoval(theEventUpdate[0]))
                eventUpdated = true;
            else
                eventUpdated = false;
        }
        else
            eventUpdated = false;

        if(eventUpdated==false && theEventUpdate.size()>0 && eventUpdates.size()>0)
        {
            Integer index = 0;
            while (index < eventUpdates.size())
            {
                Event__c theEvent = eventUpdates.get(index);
                if(theEvent.id == theEventUpdate[0].id)
                    eventUpdates.remove(index);
            }
        }
        eventUpdatesJSON = JSON.serialize(eventUpdates);
        system.debug('eventUpdatesJSON ' + eventUpdates);


    }
    public Boolean needsRemoval(Event__c theEvent)
    {
        Boolean needsRemoval;

        if(theEvent.Snoozed_Time__c != null)
        {
            system.debug('checking Snoozed_Time__c');
            if(now >= theEvent.Snoozed_Time__c)
            {
                needsRemoval = false;
            }
            else if(now < theEvent.Snoozed_Time__c)
            {
                needsRemoval = true;
            }
        }
        else
        {
            system.debug('checking reminder minutes');
            //else if(UtilityLibrary.GetElapsedMinutes(now.addMinutes(Integer.valueOf(theEvent.Reminder_Minutes__c)), theEvent.Event_Time__c) <= Integer.valueOf(theEvent.Reminder_Minutes__c))
            Datetime toBeReminded = now.addMinutes(Integer.valueOf(theEvent.Reminder_Minutes__c));
            system.debug('toBeReminded ' + toBeReminded);
            system.debug('theEvent.Event_Time__c ' + theEvent.Event_Time__c);
//            if(now.addMinutes(Integer.valueOf(theEvent.Reminder_Minutes__c)) >= theEvent.Event_Time__c)
//            {
//                needsRemoval = true;
//            }
            if(now < theEvent.Event_Time__c.addMinutes(-1*Integer.valueOf(theEvent.Reminder_Minutes__c)))
            {
                needsRemoval = true;
            }
            else
            {
                needsRemoval = false;
            }
        }


        return needsRemoval;
    }
    public void dismiss()
    {
        String eventId = ApexPages.currentPage().getParameters().get('eventId');
        system.debug('eventid ' + eventId);
        List<Event__c> theEvent = [select id, Is_Inactive__c from Event__c where Event_Time__c = TODAY and ownerId =:userId and Is_Inactive__c = false and Id =: eventId limit 1];
        if(theEvent.size() > 0)
        {
            theEvent[0].Is_Inactive__c = true;
            update theEvent[0];
            eventUpdates.clear();
            initEvents();
        }
    }
    public void snooze()
    {
        String eventId = ApexPages.currentPage().getParameters().get('eventId');
        system.debug('eventid ' + eventId);
        List<Event__c> theEvent = [select id, Snoozed_Time__c, Event_Time__c from Event__c where Event_Time__c = TODAY and ownerId =:userId and Is_Inactive__c = false and Id =: eventId limit 1];
        if(theEvent.size() > 0)
        {
            theEvent[0].Snoozed_Time__c = theEvent[0].Event_Time__c.addMinutes(-5);
            update theEvent[0];
            eventUpdates.clear();
            initEvents();
        }
    }

}