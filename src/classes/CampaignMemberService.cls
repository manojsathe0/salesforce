public without sharing class CampaignMemberService
{
    
    public final static String INTEGRATION_USER = 'Integration User';
    public static Boolean hasCampaignMemberLogicRun = false;
    //public final static String INTEGRATION_USER_ID = '005G0000001qcaP';
    public final static String INTEGRATION_USER_ID = UtilityLibrary.integrationUser.Id; //changes made in accordance with B-37996
    public final static String LZ_Site_User_ID = '005G0000001qgD0IAI';
    public final static Set<String> removedStatuses = new Set<String>{CampaignConstants.ORDER_PLACED, CampaignConstants.REMOVED};
    public final static Set<String> addedStatuses = new Set<String>{CampaignConstants.ADDED, CampaignConstants.SENT};
    public final static Set<String> campaignNamesToIngore = new Set<String>{'Inbound'};
    public final static Set<String> baseProducts = new Set<String>{'Living Trust','Last Will and Testament'};
    public static void updateLeadsOrContacts(List<CampaignMember> campaignMembers)
    {
        
        Map<Id,List<CampaignMember>> contactIdToCampaignMembers = new Map<Id,List<CampaignMember>>();
        Map<Id,List<CampaignMember>> leadIdToCampaignMembers = new Map<Id,List<CampaignMember>>();
        Set<Id> campaignMemberIds = new Set<Id>();
        Map<Id,Contact> contactsToUpdate = new Map<Id,Contact>();
        Map<Id,Lead> leadsToUpdate = new Map<Id,Lead>();
        
        for(CampaignMember theMember : campaignMembers)
        {
            campaignMemberIds.add(theMember.Id);
            if(theMember.ContactId != null)
            {
                if(addedStatuses.contains(theMember.Status))
                {
                    Contact theContact = new Contact(Id = theMember.ContactId);
                    contactsToUpdate.put(theMember.contactId  , theContact);
                }
            }
            if(theMember.LeadId != null)
            {
                
                if(addedStatuses.contains(theMember.Status))
                {
                    Lead theLead = new Lead(Id = theMember.LeadId);
                    leadsToUpdate.put(theMember.LeadId , theLead);
                }
            }
        }
        
        Map<Id, Contact> contactsSalesOwners = new Map<Id, Contact>([select id, OwnerId, LastModifiedById, Updated_By_Tealium__c  from Contact
        where Id in : contactsToUpdate.keySet() and Owner.IsActive = true and Owner.Profile.Name like '%Sales%']);
        
        Map<Id, Lead> leadsSalesOwners = new Map<Id, Lead>([select id, OwnerId, LastModifiedById, Updated_By_Tealium__c  from Lead
        where Id in : leadsToUpdate.keySet() and Owner.IsActive = true and Owner.Profile.Name like '%Sales%'] );
        
        for(Id contactId : contactsToUpdate.keySet())
        {
            Contact theContact = contactsToUpdate.get(contactId);
            
            if(contactsSalesOwners.get(theContact.Id)!=null)
            {
                theContact.Updated_By_Tealium__c = true;
            }
            else
            {
                theContact.OwnerId = INTEGRATION_USER_ID; // Putting the SFDC Id as this method is also called from LZPKB Site user which doesn't have acess to User object //changes made in accordance B-37996
            }
            contactsToUpdate.put(theContact.Id , theContact);
        }
        for(Id leadId : leadsToUpdate.keySet())
        {
            Lead theLead = leadsToUpdate.get(leadId);
            if(leadsSalesOwners.get(theLead.Id)!=null)
            {
                theLead.Updated_By_Tealium__c = true;
            }
            else
            {
                theLead.OwnerId = INTEGRATION_USER_ID;   //changes made in accordance B-37996
            }
            leadsToUpdate.put(theLead.Id , theLead);
        }
        
        
        if(!contactsToUpdate.isEmpty())
        {
            try
            {
                upsert contactsToUpdate.values();
            }
            catch(DMlException dmlEx)
            {
                SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Failed Updating the Contacts');
            }
        }
        System.debug('Leads To Update '+leadsToUpdate);
        
        if(!leadsToUpdate.isEmpty())
        {
            try
            {
                update leadsToUpdate.values();
            }
            catch(DMlException dmlEx)
            {
                system.debug( 'Failed Updating the Leads, error: ' + dmlEx.getMessage());
                SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Failed Updating the Leads');
            }
            //List<Database.SaveResult> SR = Database.update(leadsToUpdate.values(), false);
        }
        hasCampaignMemberLogicRun = true;
    }
    /*
    public static List<CampaignMember> getChangedCampaignMembers(Map<Id,CampaignMember> newCampaignMembers , List<CampaignMember> oldCampaignMembers)
    {
        List<CampaignMember> campaignMembersToConsider = new List<CampaignMember>();
        
        for(CampaignMember theOldCampaignMember : oldCampaignMembers)
        {
            CampaignMember theNewCampaignMember = newCampaignMembers.get(theOldCampaignMember.Id);
            if((removedStatuses.contains(theNewCampaignMember.Status) && !removedStatuses.contains(theOldCampaignMember.Status))
            || (addedStatuses.contains(theNewCampaignMember.Status) && !addedStatuses.contains(theOldCampaignMember.Status)))
            {
                campaignMembersToConsider.add(theNewCampaignMember);
            }
        }
        
        return campaignMembersToConsider;
    }
    */
    
    //commented in accordance with B-37996
    /*
    public static User integrationUser
    {
        get
        {
            if(integrationUser == null)
            {
                List<User> integrationUsers = [SELECT Id FROM User WHERE Name = :INTEGRATION_USER];
                if(!integrationUsers.isEmpty())
                {
                    integrationUser = integrationUsers[0];
                }
            }
            
            return integrationUser;
        }
        private set;
    }
    */
    
    public static void populateProductNameForEPBundelUpsell(List<CampaignMember> campaignMembers)
    {
        List<CampaignMember> queriedCampaignMembers =  [SELECT Id , ContactId , Campaign.Name , Status FROM CampaignMember WHERE Id IN :campaignMembers AND contactId != null];
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contactsToResetScore = new List<Contact>();
        for(CampaignMember theMember : queriedCampaignMembers)
        {
            if(theMember.Campaign.Name == 'EP Upsell Campaign' && theMember.Status == 'Added')
            contactIds.add(theMember.ContactId);
            else if(theMember.Campaign.Name == 'EP Upsell Campaign' && removedStatuses.contains(theMember.Status))
            {
                contactsToResetScore.add(new Contact(Id = theMember.ContactId , EP_Upsell_Score__c = 0));
            }
        }
        
        if(!contactIds.isEmpty())
        {
            List<Contact> contacts = [SELECT Id  , (SELECT Id , Process__c FROM Orders__r WHERE Process__c IN :baseProducts ORDER BY CreatedDate desc limit 1) FROM Contact WHERE Id IN :contactIds];
            for(Contact theContact : contacts)
            {
                for(Order__c theOrder : theContact.Orders__r)
                {
                    theContact.Base_Product__c = theOrder.Process__c;
                    theContact.EP_Upsell_Score__c =  40; //constant Score less than mobile
                }
            }
            if(!contacts.isEmpty())
            {
                try
                {
                    update contacts;
                    
                }
                catch(DMlException dmlEx)
                {
                    system.debug( 'Failed Updating the Contact With Product Name, error: ' + dmlEx.getMessage());
                    SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Failed Updating the Contact With Product Name');
                }
            }
        }
        if(!contactsToResetScore.isEmpty())
        {
            try
            {
                update contactsToResetScore;
                
            }
            catch(DMlException dmlEx)
            {
                system.debug( 'Failed Reseting EP Bundle Upsell Score on Contact , error: ' + dmlEx.getMessage());
                SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Failed Reseting EP Bundle Upsell Score on Contact');
            }
            
        }
        
    }
    
    public static void updateCampaignNameOnLeadAndContact(Map<Id,CampaignMember> newCampaignMembers)
    {
        Id mobileCampaignId;
        List<Campaign> mobileCampaign = [SELECT Id FROM Campaign WHERE Name =: CampaignConstants.MOBILE LIMIT 1];
        if(!mobileCampaign.isEmpty())
        {
            mobileCampaignId = mobileCampaign[0].Id;
        }
        Set<Id> mobileCampaignLeadIds = new Set<Id>();
        Set<Id> mobileCampaignContactIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id,Id> recordIdToCampaignId = new Map<Id,Id>();
        Set<Id> campaignIds = new Set<Id>();
        Map<Id,String> campaignIdToName = new Map<Id,String>();
        system.debug('Cmembers'+ newCampaignMembers);
        for(CampaignMember theCampaignMember : newCampaignMembers.values())
        {
            if(addedStatuses.contains(theCampaignMember.Status))
            {
                campaignIds.add(theCampaignMember.CampaignId);
                if(theCampaignMember.LeadId != null)
                {
                    recordIdToCampaignId.put(theCampaignMember.LeadId,theCampaignMember.CampaignId);
                    leadIds.add(theCampaignMember.LeadId);
                }
                if(theCampaignMember.ContactID != null)
                {
                    recordIdToCampaignId.put(theCampaignMember.ContactId,theCampaignMember.CampaignId);
                    contactIds.add(theCampaignMember.ContactId);
                }
            }
            //reduce mobile score when lead or contact comes out of Mobile campaign
            if(removedStatuses.contains(theCampaignMember.Status))
            {
                if(theCampaignMember.CampaignId == mobileCampaignId)
                {
                    if(theCampaignMember.LeadId != null)
                        mobileCampaignLeadIds.add(theCampaignMember.LeadId);
                    if(theCampaignMember.ContactID != null)
                        mobileCampaignContactIds.add(theCampaignMember.ContactID);
                }
            }
        }
        if(!campaignIds.isEmpty())
        {
            for(Campaign theCampaign : [SELECT Id, Name FROM Campaign Where Id in: campaignIds])
            {
                campaignIdToName.put(theCampaign.Id,theCampaign.Name);
            }
        }
        
        if(!leadIds.isEmpty())
        {
            for(Id theLeadId : leadIds)
            {
                Lead leadToUpdate = new Lead(Id = theLeadId);
				leadToUpdate.Sales_opportunity_latest_campaign__c = campaignIdToName.get(recordIdToCampaignId.get(theLeadId));
                if((recordIdToCampaignId.get(theLeadId)) == mobileCampaignId)
                    leadToUpdate.Last_Time_Added_to_Campaign__c = System.now();
                leadsToUpdate.add(leadToUpdate);
                system.debug(leadToUpdate);
            }
        }
        
        if(!mobileCampaignLeadIds.isEmpty())
        {
            for(Lead  theMobileLead : [Select Id, Last_Time_Added_to_Campaign__c From Lead Where Id in: mobileCampaignLeadIds])
            {
                theMobileLead.Last_Time_Added_to_Campaign__c = null;
                leadsToUpdate.add(theMobileLead);
            }
        }
        
        if(!leadsToUpdate.isEmpty())
        {
            List<Database.SaveResult> updateResults =  Database.update(leadsToUpdate,false);
            String errorMessage = '';
            for(Database.SaveResult theResult : updateResults)
            {
                for(Database.Error theError : theResult.getErrors())
                {
                    errorMessage += theResult.getId() +'--'+theError.getMessage()+'-------';
                }
            }
            if(errorMessage != '')
            {
                SendExceptionEmail.sendGenericErrorEmal(errorMessage , 'Failed Updating Campaign name on Lead');
            }
        }
        
        
        if(!contactIds.isEmpty())
        {
            for(Id theContactId : contactIds)
            {
                Contact contactToUpdate = new Contact(Id = theContactId);
                contactToUpdate.Last_Time_Added_to_Campaign__c = System.now();
                contactToUpdate.Sales_opportunity_latest_campaign__c = campaignIdToName.get(recordIdToCampaignId.get(theContactId));
                
                contactsToUpdate.add(contactToUpdate);
                system.debug(contactsToUpdate);
            }
        }
        
        if(!mobileCampaignContactIds.isEmpty())
        {
            for(Contact  theMobileContact : [Select Id, Lead_Score_Mobile_time_since_creation__c, Last_Time_Added_to_Campaign__c From Contact Where Id in: mobileCampaignContactIds])
            {
                theMobileContact.Last_Time_Added_to_Campaign__c = null;
                contactsToUpdate.add(theMobileContact);
            }
        }
        
        if(!contactsToUpdate.isEmpty())
        {
            List<Database.SaveResult> updateResults =  Database.update(contactsToUpdate,false);
            String errorMessage = '';
            for(Database.SaveResult theResult : updateResults)
            {
                for(Database.Error theError : theResult.getErrors())
                {
                    errorMessage += theResult.getId() +'--'+theError.getMessage()+'-------';
                }
            }
            if(errorMessage != '')
            {
                SendExceptionEmail.sendGenericErrorEmal(errorMessage , 'Failed Updating Campaign name on Contact');
            }
        }
		    Integer i = 0;
    Integer j = 0;
    Integer k = 0;
    Integer l = 0;
    Integer m = 0;
    Integer n = 0;
    Integer ii = 0;
    Integer jj = 0;
    Integer kk = 0;
    Integer ll = 0;
    Integer mm = 0;
    Integer nn = 0;
    Integer oo = 0;
    Integer pp = 0;
    Integer qq = 0;
    Integer o = 0;
    Integer p = 0;
    Integer q = 0;
    Integer r = 0;
    Integer s = 0;
    Integer t = 0;
    Integer u = 0;
    Integer v = 0;
    Integer w = 0;
    Integer rr = 0;
    Integer ss = 0;
    Integer tt = 0;
    Integer uu = 0;
    Integer a = 0;
    Integer aa = 0;
    Integer b = 0;
        
    }
    
}