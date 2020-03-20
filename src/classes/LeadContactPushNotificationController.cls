public with sharing class LeadContactPushNotificationController
{
    public List<Contact> tealiumContactUpdates{get;set;}
    public List<Lead> tealiumLeadUpdates{get;set;}
    public List<Opportunity> tealiumOppUpdates{get;set;}
    public List<TealiumWrapper> updates{get;set;}
    public String userId{get;set;}
    public Boolean tealiumUpdated {get;set;}
    public Integer days{get;set;}
    public Datetime interval{get;set;}
    public Boolean getIsClassic() {
    	return (UserInfo.getUiThemeDisplayed() == 'Theme3');
	}
    public LeadContactPushNotificationController()
    {
        userId = UserInfo.getUserId();
        updates= new List<TealiumWrapper>();

        
        tealiumUpdated = false;
        try {
            days = Integer.valueOf([select Lead_Contact_Push_Notification_Days__c from LZ_Config__mdt where label = 'Default' limit 1].Lead_Contact_Push_Notification_Days__c);
        }
        catch(Exception e) {
            System.debug('Exc: ' + e.getMessage());
        }
        //This code is in case for some reason the LZ_Config__mdt did not get pulled
        if (days == null) {
            days = 10;
        }
        System.Debug('Days: ' + days);
        interval  = System.today() - days;
        initLeads();
        initContacts();
        initOpps();
        updates.sort();
    }
    public void initContacts()
    {
        tealiumContactUpdates = [select id, Tealium_Updates__c, name, Last_Opportunity_Id__c, Updated_By_Tealium_DateTime__c from Contact where Updated_By_Tealium_DateTime__c > :interval and Updated_By_Tealium__c = true and OwnerId =: userId order by Updated_By_Tealium_DateTime__c desc LIMIT 100];
        system.debug('contact updates ' + tealiumContactUpdates);

        for(Contact thisContact : tealiumContactUpdates)
        {
            Map<String, Map<String, String>> jsonMap = getJSONUpdates(thisContact.Tealium_Updates__c);
            system.debug('jsonMap ' + jsonMap);
            if(jsonMap != null && jsonMap.size() > 0)
            {
                TealiumWrapper wrap = new TealiumWrapper();
                

                wrap.name = thisContact.name;
                wrap.objType = 'Contact';
                wrap.modified = thisContact.Updated_By_Tealium_DateTime__c;
                List<String> strChanges = new List<String>();
                String activity = '';
                for(String key : jsonMap.keySet())
                {
                    Map<String, String> changes = jsonMap.get(key);
                    Set <String> keySet = new Set<String>();
                    String theKey = '';
                    keySet = changes.keySet();
                    for (String keyStr : keySet) {
                        theKey = keyStr;
                        if (key.contains('Product')) {
                            activity += 'Change of Product; ';
                        }
                        if (key.contains('Opportunity')) {
                            activity += 'New Opportunity; ';
                        }
                    }

                    strChanges.add( key + ' : ' + changes.get(theKey));
                }
                wrap.Activity =  activity;
                if (Activity.contains('New Opportunity;')) {
                	wrap.id = thisContact.Last_Opportunity_Id__c;
                }
                else {
                	wrap.id = thisContact.id;
                }
                wrap.changes = strChanges;
                updates.add(wrap);
            }
        }
    }
    public void initLeads()
    {
        System.Debug('Date: ' + interval);
        tealiumLeadUpdates = [select id, Tealium_Updates__c, Updated_By_Tealium_DateTime__c, Sales_User_Changed_Time__c, name from Lead WHERE OwnerId =: userId AND ((Updated_By_Tealium_DateTime__c > :interval AND Updated_By_Tealium__c = true) OR (Sales_User_Changed_Time__c > :interval AND Reassigned_to_New_Sales_Owner__c = true)) order by Updated_By_Tealium_DateTime__c desc LIMIT 100];
        system.debug('lead updates ' + tealiumLeadUpdates);
        
        for(Lead thisLead : tealiumLeadUpdates)
        {
            Map<String, Map<String, String>> jsonMap = getJSONUpdates(thisLead.Tealium_Updates__c);
            system.debug('jsonMap ' + jsonMap);
            if(jsonMap != null && jsonMap.size() > 0)
            {
                TealiumWrapper wrap = new TealiumWrapper();
                wrap.id = thisLead.id;
                wrap.name = thisLead.name;
                wrap.objType = 'Lead';

                if (thisLead.Updated_By_Tealium_DateTime__c != null && thisLead.Sales_User_Changed_Time__c != null) {
                	if (thisLead.Updated_By_Tealium_DateTime__c > thisLead.Sales_User_Changed_Time__c) {
	                    wrap.modified = thisLead.Updated_By_Tealium_DateTime__c;
	                }
	                else {
	                    wrap.modified = thisLead.Sales_User_Changed_Time__c;
	                }
                }
                else
                if (thisLead.Updated_By_Tealium_DateTime__c == null ) {
                	wrap.modified = thisLead.Sales_User_Changed_Time__c;
                }
                else
                if (thisLead.Sales_User_Changed_Time__c == null) {
                	wrap.modified = thisLead.Updated_By_Tealium_DateTime__c;
                }
                else {
                	wrap.modified = thisLead.Updated_By_Tealium_DateTime__c;
                }
 

                List<String> strChanges = new List<String>();
                String activity = '';
                for(String key : jsonMap.keySet())
                {
                    Map<String, String> changes = jsonMap.get(key);
                    Set <String> keySet = new Set<String>();
                    String theKey = '';
                    keySet = changes.keySet();
                    for (String keyStr : keySet) {
                        theKey = keyStr;
                        /*  */
                        if (key.contains('Product')) {
                            activity += 'Change of Product; ';
                        }
                        if (key.contains('My Account')) {
                            activity += 'Online on My Account; ';
                        }
                        if (key.contains('Website')) {
                            activity += 'Online on Website; ';
                        }
                        if (key.contains('User Changed')) {
                            activity += 'Reassigned to you; ';
                        }

                    }

                    strChanges.add( key + ' : ' + changes.get(theKey));
                }
                wrap.Activity =  activity;
                wrap.changes = strChanges;
                updates.add(wrap);
            }
        }
    }
    public void initOpps() {
    	tealiumOppUpdates = [SELECT Id, Contact__r.Name, User_Changed_On__c, Tealium_Updates__c, Updated_By_Tealium_DateTime__c, Name from Opportunity WHERE OwnerId =: userId AND ((Updated_By_Tealium_DateTime__c > :interval AND Updated_By_Tealium__c = true) OR (User_Changed_On__c > :interval AND Reassigned_to_New_Sales_Owner__c = true))];
    	for (Opportunity opp : tealiumOppUpdates) {
    		Map<String, Map<String, String>> jsonMap = getJSONUpdates(opp.Tealium_Updates__c);
    		if(jsonMap != null && jsonMap.size() > 0) {
    			TealiumWrapper wrap = new TealiumWrapper();
    			wrap.id = opp.id;
    			wrap.name = opp.name + ' (' + opp.Contact__r.Name + ')';
    			wrap.objType = 'Opportunity';
    			wrap.modified = opp.Updated_By_Tealium_DateTime__c;
    			if (opp.User_Changed_On__c != null && opp.User_Changed_On__c > opp.Updated_By_Tealium_DateTime__c) {
    				wrap.modified = opp.User_Changed_On__c;
    			}
    			List<String> strChanges = new List<String>();
    			String activity = '';
    			for(String key : jsonMap.keySet()) {
                    Map<String, String> changes = jsonMap.get(key);
                    Set <String> keySet = new Set<String>();
                    String theKey = '';
                    keySet = changes.keySet();
                    for (String keyStr : keySet) {
                        theKey = keyStr;
                        if (key.contains('Questionnaire')) {
                            activity += 'Active in Questionnaire; ';
                        }
                        if (key.contains('My Account')) {
                            activity += 'Active on My Account; ';
                        }
                        if (key.contains('Website')) {
                            activity += 'Active on Website; ';
                        }
                        if (key.contains('User Changed')) {
                            activity += 'Reassigned to you; ';
                        }
                    }

                    strChanges.add( key + ' : ' + changes.get(theKey));
                }
                wrap.Activity = activity;
                wrap.changes = strChanges;
                updates.add(wrap);
    		}
    	}
    }
    public void getContactChanges()
    {
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        List<Contact> theContact = [select id, Tealium_Updates__c, Updated_By_Tealium__c, Updated_By_Tealium_DateTime__c from Contact where Updated_By_Tealium__c = true and Id =: contactId limit 1];
        if(theContact.size() > 0)
            tealiumUpdated = true;
        else
            tealiumUpdated = false;
        updates.clear();
        initContacts();
        initLeads();
        initOpps();
        updates.sort();
    }
    public void getLeadChanges()
    {
        String leadId = ApexPages.currentPage().getParameters().get('leadId');
        List<Lead> theLead = [select id, Tealium_Updates__c, Updated_By_Tealium__c, Updated_By_Tealium_DateTime__c from Lead where (Updated_By_Tealium__c = true OR Reassigned_to_New_Sales_Owner__c = true) and Id =: leadId LIMIT 1];
        if(theLead.size() > 0)
            tealiumUpdated = true;
        else
            tealiumUpdated = false;
        updates.clear();
        initContacts();
        initLeads();
        initOpps();
        updates.sort();
    }
    public void getOppChanges()
    {
        String oppId = ApexPages.currentPage().getParameters().get('oppId');
        List<Opportunity> theOpp = [SELECT Id, Tealium_Updates__c, Updated_By_Tealium__c, Updated_By_Tealium_DateTime__c FROM Opportunity WHERE (Updated_By_Tealium__c = true OR Reassigned_to_New_Sales_Owner__c = true) AND Id =:oppId LIMIT 1];
        if(theOpp.size() > 0)
            tealiumUpdated = true;
        else
            tealiumUpdated = false;
        updates.clear();
        initContacts();
        initLeads();
        initOpps();
        updates.sort();
    }
    public class TealiumWrapper implements Comparable
    {
        public String id {get;set;}
        public String name {get;set;}
        public String objType {get;set;}
        public List<String> changes{get;set;}
        public Datetime modified{get;set;}
        public Boolean ActiveOnWebsite{get;set;}
        public String Activity{get;set;}
        public Integer compareTo(Object compareTo) 
        {
            TealiumWrapper compareToWrap = (TealiumWrapper)compareTo;
            
            Integer returnValue = 0;
            if (modified < compareToWrap.modified) 
            {
                returnValue = 1;
            } 
            else if (modified > compareToWrap.modified) 
            {
                returnValue = -1;
            }
            
            return returnValue;       
        }
    }
    
    public Map<String, Map<String, String>> getJSONUpdates(String jsonStr)
    {
        if(jsonStr != null && jsonStr != '')
            return (Map<String, Map<String, String>>)JSON.deserialize(jsonStr, Map<String, Map<String, String>>.class);
        return null;
    }

}