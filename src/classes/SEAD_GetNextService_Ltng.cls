/*
Created per story: B-25556  
By: Artyom M.
Migration of GetNext functionality to Lightning.  
*/

public without sharing  class SEAD_GetNextService_Ltng {    
    public final static String ABANDONERS = 'Abandoners';
    //public final static String INTEGRATION_USER = 'Integration User';
    public final static String SALESLIST_USER = 'SalesListOwner';
    public static final Integer CONTACTS_TO_ASSIGN = 1;
    public static final Integer LEADS_TO_ASSIGN = 1;
    public static final Integer MAX_OPPS_TO_ASSIGN_PER_DAY = 40;
    public static Set<Id> allCampaignIds = new Set<Id>();
    public SEAD_LeadContactInfo openAbandoner{get;set;}
    public static final List<String> EXCLUDE_ABANDONERS = new List<String>{'Closed Lost','Closed Lost Refund'};
    public static List<Contact> contactsToAssignList = new List<Contact>();
    public static List<Lead> leadsToAssignList = new List<Lead>();
    public static List<Opportunity> childOpps = new List<Opportunity>();
    public static List<Account> accList = new List<Account>();
    public static List<String> skills = new List<String>();
    public static Set<String> currentUserSkillSet = new Set<String>();
    public static Set<String> currentUserFieldsOfExpertiseSet = new Set<String>();
    public static Set<String> productsToExcludeSet = new Set<String>();
    public static String currentUserFieldsOfExpertiseStr;
    public static String productsToExclude;
    public static Map<Id,String> recordIdtoCampaignName = new Map<Id,String>();
    public static  List<Team_Management__c> currentUserInfo = new List<Team_Management__c>();
    public static Set<Id> ownerIds;
    public static Boolean oppScenario;
    public Set<String> removedStatuses = new Set<String>{'Order Placed','Removed'};
    public Set<String> addedStatuses = new Set<String>{'Sent','Added'};

    public final static String NO_ABANDONER_MESSAGE = 'There are no new leads or opportunities available for your skill set at this time.';
    public final static String NOT_ALLOWED_MESSAGE = 'You are not allowed to receive any leads.';
    @AuraEnabled public static GetNextResponseStatus responseStatus {get;set;}
    
    //moved the functionality to Utility library : B-38758
	/*
    @AuraEnabled
    public static User integrationUser {
        get {
            if (integrationUser == null) {
                integrationUser = UtilityLibrary.integrationUser;
            }
            return integrationUser;
        }
        private set;
    }
    */
    @AuraEnabled
    public static User salesListOwner
    {
        get
            {
                if(salesListOwner == null)
                {
                    List<User> salesListOwners = [SELECT Id FROM User WHERE Name = :SALESLIST_USER];
                    if(!salesListOwners.isEmpty())
                    {
                        salesListOwner =salesListOwners[0];
                    }
                }

                return salesListOwner;
            }
        private set;
    }
    

    @AuraEnabled
    public static void setCurrentUserFieldsOfExpertise() {
    	List<Skill_Set_To_Field_Of_Expertise_Mapping__mdt> skillSetToFieldOfExpertiseList = new List<Skill_Set_To_Field_Of_Expertise_Mapping__mdt>();
    	skillSetToFieldOfExpertiseList = [SELECT DeveloperName, Agent_Skill__c, Agent_Field_Of_Expertise__c FROM Skill_Set_To_Field_Of_Expertise_Mapping__mdt LIMIT 100];
    	
    	Map<String, String> skillSetToFieldOfExpertiseMap = new Map<String, String>();
    	for (Skill_Set_To_Field_Of_Expertise_Mapping__mdt skillMap : skillSetToFieldOfExpertiseList) {
    		skillSetToFieldOfExpertiseMap.put(skillMap.Agent_Skill__c, skillMap.Agent_Field_Of_Expertise__c);
    	} 
    	
        currentUserInfo = [SELECT Id, User__c, Skill_Set__c FROM Team_Management__c WHERE User__c =: UserInfo.getUserId() Limit 1];

		
		Set<String> currentUserFieldsOfExpertiseSet = new Set<String>(); 
        if (!currentUserInfo.isEmpty() && currentUserInfo[0].Skill_Set__c != null) {
            currentUserSkillSet.addAll(currentUserInfo[0].Skill_Set__c.split(';'));
            
            for (String skill : currentUserSkillSet) {
            	if (skillSetToFieldOfExpertiseMap.get(skill) != null) {
            		currentUserFieldsOfExpertiseSet.add(skillSetToFieldOfExpertiseMap.get(skill));
            		
            	}
        	
        	}
        	currentUserFieldsOfExpertiseStr = '';
        	for (String fieldOfExpertise : currentUserFieldsOfExpertiseSet) {
        		currentUserFieldsOfExpertiseStr += '\'' + fieldOfExpertise + '\',';
        	}
            currentUserFieldsOfExpertiseStr = currentUserFieldsOfExpertiseStr.removeEnd(',');
        }
        
        
        
		/*
        if (!currentUserSkillSet.isEmpty()) {
            if (currentUserSkillSet.contains('Abandoner-Biz') || currentUserSkillSet.contains('Mobile-Biz') || currentUserSkillSet.contains('Social-Biz')) {
                currentUserFieldsOfExpertiseSet.add('Business Services');
            }
            if (currentUserSkillSet.contains('Abandoner-IP') || currentUserSkillSet.contains('Mobile-IP') || currentUserSkillSet.contains('Social-IP')) {
                currentUserFieldsOfExpertiseSet.add('Intellectual Property');
            }
            if (currentUserSkillSet.contains('Abandoner-PS') || currentUserSkillSet.contains('Mobile-PS') || currentUserSkillSet.contains('Social-PS')) {
                currentUserFieldsOfExpertiseSet.add('Personal Services');
            }
            if (currentUserSkillSet.contains('LLC On-Boarding') ) {
                currentUserFieldsOfExpertiseSet.add('LLC On-Boarding');
            }
            

            currentUserFieldsOfExpertiseStr = '';
            for (String s : currentUserFieldsOfExpertiseSet) {
                currentUserFieldsOfExpertiseStr += '\'' + s + '\',';
            }
            currentUserFieldsOfExpertiseStr = currentUserFieldsOfExpertiseStr.removeEnd(',');
        }

        productsToExcludeSet.add('Business Formations');
        productsToExcludeSet.add('Attorney Services');
        productsToExcludeSet.add('Legal Forms');
        productsToExcludeSet.add('Intellectual Property');
        productsToExcludeSet.add('Personal Services');
        productsToExcludeSet.add('LLC On-Boarding');
        productsToExcludeSet.removeAll(currentUserFieldsOfExpertiseSet);

        productsToExclude = '';
        for (String s : productsToExcludeSet) {
            productsToExclude += '\'' + s + '\',';
            // productsToExclude += s +  '; ' ;
        }
        productsToExclude = productsToExclude.removeEnd(',');
		*/
        System.debug('currentUserFieldsOfExpertiseSet: ' + currentUserFieldsOfExpertiseStr);
        //System.debug('productsToExcludeSet: ' + productsToExclude);
    }
    
    @AuraEnabled
    public static GetNextResponseStatus checkIfAllowedNewAbandoner() {
        setCurrentUserFieldsOfExpertise();
        responseStatus = new GetNextResponseStatus ();
        
        System.debug('iside : checkIfAllowedNewAbandoner' + productsToExclude);
        
        responseStatus.thereAreErrors = false;
        responseStatus.errorMessage = '';
        responseStatus.recordId = null;
        
        if(currentUserInfo.isEmpty()) {
            responseStatus.thereAreErrors = true;
            responseStatus.errorMessage = NOT_ALLOWED_MESSAGE;
        }
        else {
            responseStatus.thereAreErrors = false;
            responseStatus.errorMessage = '';
        }
            
        //if(availableAbandoners<1)
            //return 2;
        System.debug('responseStatus.thereAreErrors' + responseStatus.thereAreErrors);
        System.debug('responseStatus.errorMessage' + responseStatus.errorMessage);
        return responseStatus;
    }
    
    @AuraEnabled
    public static GetNextResponseStatus getNextAbandoner() {
        GetNextResponseStatus responseStatus = new GetNextResponseStatus();
        responseStatus = checkIfAllowedNewAbandoner();
        if (responseStatus.thereAreErrors) {
            return responseStatus;
        }
        //ownerIds = new Set<Id> {salesListOwner.Id, integrationUser.Id};
        ownerIds = new Set<Id> {salesListOwner.Id}; //removed the addition of single integration user id as we would be using multiple integration users for data loads : B-38758
		ownerIds.addAll(UtilityLibrary.allIntegrationUserIds); // added all the integration user ids instead : B-38758
        
        List<Lead> leads = new List<Lead>();
        List<Opportunity> opps = new List<Opportunity>();
        try {
            if (String.isNotBlank(currentUserFieldsOfExpertiseStr)) {
                String queryStr = 'SELECT Id, CreatedDate, Lead_Score__c, Product_Line2__c FROM Lead WHERE (OwnerId =: ownerIds AND Isconverted = false AND Phone != null) ';

                queryStr += 'AND Product_Line2__c IN (';
                queryStr += currentUserFieldsOfExpertiseStr;
                queryStr += ') ';
                queryStr += 'AND (Status != \'Closed Won\' AND Status != \'Closed Lost\') ';

                    /*
                    EXCLUDES part
                    if (String.isNotBlank(productsToExclude) ) {
                        queryStr += 'AND Product_Line_2__c EXCLUDES (';//\'
                        queryStr += productsToExclude;
                        queryStr += ') ';//'\
                    }
                    */
                queryStr += 'ORDER BY CreatedDate DESC, Lead_Score__c DESC NULLS LAST limit :LEADS_TO_ASSIGN';
                System.debug('Query: ' + queryStr);
                leads = Database.query(queryStr);
                    
                    /*
                    Creating querying functionality for Opportunities.
                    Author: Artyom M.
                    Story: B-21962  
                    
                    
                    */
                    
                String oppQuery = 'SELECT Id, CreatedDate, Score__c, Contact__c,OnBoarding__c, Product_Line2__c FROM Opportunity WHERE (OwnerId =: ownerIds AND Score__c != null AND Contact__c != null) ';
                oppQuery += 'AND (StageName != \'Closed Won\' AND StageName != \'Closed Lost\') ';
                oppQuery += 'AND Product_Line2__c IN (';
                oppQuery += currentUserFieldsOfExpertiseStr;
                oppQuery += ') ';
                    
                oppQuery += 'ORDER BY CreatedDate DESC, Score__c DESC NULLS LAST limit :LEADS_TO_ASSIGN';
                System.debug('oppQuery: ' + oppQuery);
                opps = Database.query(oppQuery);
                    
                    
            }
           

            System.Debug('Lead size ' + leads.size());
            System.Debug('Opps size ' + opps.size());

            if (!leads.isEmpty()) {
                System.Debug('Lead score: ' + leads[0].CreatedDate);
                System.Debug('Lead Name: ' + leads[0].Id);
            }
                
                
            if (!opps.isEmpty()) {
                System.Debug('Opp Score: ' + opps[0].CreatedDate);
                System.Debug('Opp Name: ' + opps[0].Id);
            }
                    
            Boolean leadScenario = false;
            oppScenario = false;
                
            if (!leads.isEmpty() && !opps.isEmpty()) {
                if (opps[0].CreatedDate >= leads[0].CreatedDate) {
                    oppScenario = true;
                }
                else {
                    leadScenario = true;
                }
            }
            else
            if (!leads.isEmpty() && opps.isEmpty()) {
                    leadScenario = true;
            }
            else
            if (leads.isEmpty() && !opps.isEmpty()) {
                oppScenario = true;
            }
            else {
                
            }
                
            System.Debug('oppScenario: ' + oppScenario);
            System.Debug('leadScenario: ' + leadScenario);
                
            if (oppScenario&& !opps[0].OnBoarding__c) {
                Id contactId = opps[0].Contact__c;
                System.debug('contactId ' + contactId);
                contactsToAssignList = [SELECT Id, OwnerId, Name, Total_Activities__c, Product2__c, AccountId FROM Contact WHERE ID = :contactId LIMIT :CONTACTS_TO_ASSIGN];
                System.debug('contactsToAssignList ' + contactsToAssignList.size());
                childOpps = [SELECT Id, OwnerId,OnBoarding__c FROM Opportunity WHERE Contact__c = :contactId];
                if (!contactsToAssignList.isEmpty()) {
                    accList = [SELECT Id, OwnerId FROM Account WHERE Id = :contactsToAssignList[0].AccountId LIMIT 1];  
                }
                System.debug('accList ' + accList.size());
            }
            else
            if (leadScenario) {
                leadsToAssignList = [SELECT Id, OwnerId, Name, Lead_Score__c, Total_Activities__c, Product__c
                            FROM Lead
                            WHERE Id =: leads[0].Id AND OwnerId =: ownerIds
                LIMIT : LEADS_TO_ASSIGN FOR UPDATE];
            }


            } catch(QueryException queryEx){
                System.debug('This is Query Exception from Abandoner.: >>>'+queryEx);
            }

        List<SEAD_LeadContactInfo> abandonersToReturn = new List<SEAD_LeadContactInfo>();  
        
        if(oppScenario && opps[0].OnBoarding__c)
        {
         opps[0].OwnerId =  UserInfo.getUserId();  
         update opps[0];
        responseStatus.thereAreErrors = false;
    responseStatus.errorMessage = '';
      responseStatus.recordId = opps[0].id;
      return responseStatus;
        }
        else
        {
        abandonersToReturn = updateLeadContact();
        }
        
        if (!abandonersToReturn.isEmpty()) {
            responseStatus.thereAreErrors = false;
            responseStatus.errorMessage = '';
            System.debug('ID abandonersToReturn[0].objectId' + abandonersToReturn[0].objectId);
            responseStatus.recordId = abandonersToReturn[0].objectId;
        }
        else {
            responseStatus.thereAreErrors = true;
            responseStatus.errorMessage = NO_ABANDONER_MESSAGE;
            responseStatus.recordId = null;
        }
        return responseStatus;
    }

    public static List<SEAD_LeadContactInfo> updateLeadContact() {
            System.debug('Updating method;');
            /*
                    Creating querying functionality for Opportunities.
                    Author: Artyom M.
                    Story: B-21962  

            */
            List<SEAD_LeadContactInfo> abandonersToReturn = new List<SEAD_LeadContactInfo>();
                if(contactsToAssignList.size() > 0)
                {
                    try
                    {
                        for(Contact theContact : contactsToAssignList)
                        {
                            System.debug('Username ' + UserInfo.getUserId());
                            theContact.OwnerId = UserInfo.getUserId();
                            abandonersToReturn.add(new SEAD_LeadContactInfo(String.valueOf(theContact.Id), theContact.Name, null, null, null, null, null, null, null,
                                                                        String.valueOf(theContact.OwnerId), null, null, recordIdtoCampaignName.get(theContact.Id),null, theContact.Total_Activities__c, null,
                                                                        theContact.Product2__c));
                        }
                        for (Opportunity opp : childOpps) {
                        if(!opp.OnBoarding__c)
                        {
                            opp.OwnerId =  UserInfo.getUserId();
                        }
                        }
                        if (!accList.isEmpty()) {
                            Account parentAcc = accList[0];
                            parentAcc.OwnerId = UserInfo.getUserId();
                            update parentAcc;
                        }
                        if (!childOpps.isEmpty()) {
                            update childOpps;
                        } 
                        
                        //System.Debug('Before Updating');
                        update contactsToAssignList;    //get rid of order number
                    } catch(DMLException dmlEx){
                        System.debug('This is DML Exception from Abandoner contact.: >>>'+dmlEx);
                    }
                }
        
            if(leadsToAssignList.size() > 0)
            {
                try
                {
                    for(Lead theLead : leadsToAssignList)
                        {
                            theLead.OwnerId = UserInfo.getUserId();
                            abandonersToReturn.add(new SEAD_LeadContactInfo(String.valueOf(theLead.Id), theLead.Name, null, null, null, null, null, null, null,
                                    String.valueOf(theLead.OwnerId), null, null,recordIdtoCampaignName.get(theLead.Id),null, theLead.Total_Activities__c, null,
                                    theLead.Product2__c));
                        }
                    update leadsToAssignList;
                }catch(DMLException dmlEx){
                    System.debug('This is DML Exception from Abandoner lead.: >>>'+dmlEx);
                }
            }
            return abandonersToReturn;
        }
    
    public class GetNextResponseStatus {
        @AuraEnabled public Boolean thereAreErrors{get;set;}
        @AuraEnabled public String errorMessage{get;set;}
        @AuraEnabled public Id recordId{get;set;}
        
    
    }
    
    
}