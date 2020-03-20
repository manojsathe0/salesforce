/**
 * Created by ameliksetyan on 6/28/2017.
 This Class is a modification of GetNextAbandonerLeadContact that works with Skill Set field of the Team Managment object
 and no longer relies on Campaign object when pulling the leads.
 */
public without sharing class SEAD_GetNextAbandonerLeadContact {
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
	public static List<String> skills = new List<String>();
	public static Set<String> currentUserSkillSet = new Set<String>();
	public static Set<String> currentUserFieldsOfExpertiseSet = new Set<String>();
	public static Set<String> productsToExcludeSet = new Set<String>();
	public static String currentUserFieldsOfExpertiseStr;
	public static String productsToExclude;
	public static Map<Id,String> recordIdtoCampaignName = new Map<Id,String>();
	public static  List<Team_Management__c> currentUserInfo = new List<Team_Management__c>();
	public static Set<Id> ownerIds;
	public Set<String> removedStatuses = new Set<String>{'Order Placed','Removed'};
	public Set<String> addedStatuses = new Set<String>{'Sent','Added'};

	//moved the functionality to Utility library : B-38758
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

	public Integer maxAllowedAbandonersPerDay
	{
		get
			{

				if(maxAllowedAbandonersPerDay == null)
				{
					List<Max_Abandoner_Per_Day__c> maxAbandoners = Max_Abandoner_Per_Day__c.getall().values();
					if(maxAbandoners.size() == 1)
						maxAllowedAbandonersPerDay = Integer.valueOf(maxAbandoners[0].Name);
				}

				return maxAllowedAbandonersPerDay;
			}
		set;
	}
	public void setCurrentUserFieldsOfExpertise() {
		currentUserInfo = [SELECT Id, User__c, Skill_Set__c FROM Team_Management__c WHERE User__c =: UserInfo.getUserId() Limit 1];


		if (!currentUserInfo.isEmpty() && currentUserInfo[0].Skill_Set__c != null) {
			currentUserSkillSet.addAll(currentUserInfo[0].Skill_Set__c.split(';'));
		}

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
		productsToExcludeSet.removeAll(currentUserFieldsOfExpertiseSet);

		productsToExclude = '';
		for (String s : productsToExcludeSet) {
			productsToExclude += '\'' + s + '\',';
			// productsToExclude += s +  '; ' ;
		}
		productsToExclude = productsToExclude.removeEnd(',');

		System.debug('currentUserFieldsOfExpertiseSet: ' + currentUserFieldsOfExpertiseStr);
		System.debug('productsToExcludeSet: ' + productsToExclude);
	}
	public Integer checkIfAllowedNewAbandoner()
		{
			setCurrentUserFieldsOfExpertise();
			if(currentUserInfo.isEmpty())
				return 1;
			if(availableAbandoners<1)
				return 2;

			return 0;
		}
	/*
	The following method is using Dynamic SOQL request to query leads that are available for assignment.
	These leads must belong to certain Users and have products matching to the requesting Agent's skills.
	The old version of this  App relied on CampaignMember and Campaign objects to match skills and products,
	while the new version uses Product_Line2__c and Skill_Set__c to achieve these goals.
	The commented out code in this method represents the Contact querying functionality that duplicates Lead querying functionality.
	*/
	public List<SEAD_LeadContactInfo> getNextAbandoner()
		{
			//ownerIds = new Set<Id> {salesListOwner.Id, integrationUser.Id};
			ownerIds = new Set<Id> {salesListOwner.Id}; //removed the addition of single integration user id as we would be using multiple integration users for data loads : B-38758
			ownerIds.addAll(UtilityLibrary.allIntegrationUserIds); // added all the integration user ids instead : B-38758
			List<Lead> leads = new List<Lead>();
			try{

				//List<Contact> contacts = new List<Contact>();
				if (String.isNotBlank(currentUserFieldsOfExpertiseStr)) {
					String queryStr = 'SELECT Id, Lead_Score__c, Product_Line2__c FROM Lead WHERE (OwnerId =: ownerIds AND Isconverted = false AND Phone != null) ';

					if (String.isNotBlank(currentUserFieldsOfExpertiseStr) ) {
						queryStr += 'AND Product_Line2__c IN (';
						queryStr += currentUserFieldsOfExpertiseStr;
						queryStr += ') ';
					}
					/*
					EXCLUDES part
					if (String.isNotBlank(productsToExclude) ) {
						queryStr += 'AND Product_Line_2__c EXCLUDES (';//\'
						queryStr += productsToExclude;
						queryStr += ') ';//'\
					}
					*/
					queryStr += 'ORDER BY Lead_Score__c DESC, CreatedDate DESC NULLS LAST limit :LEADS_TO_ASSIGN';
					System.debug('Query: ' + queryStr);
					leads = Database.query(queryStr);
				}


				/*
				contacts  = [SELECT Id, Contact_Score2__c, Product_Line_2__c FROM Contact WHERE (OwnerId =: ownerIds) AND
				Product_Line_2__c INCLUDES (:currentUserFieldsOfExpertiseStr)
				ORDER BY Contact_Score2__c DESC, CreatedDate DESC NULLS LAST limit : CONTACTS_TO_ASSIGN];
				if (contacts.isEmpty()) {
				  contacts  = [SELECT Id, Contact_Score2__c FROM Contact WHERE (OwnerId =: ownerIds)
				  ORDER BY Contact_Score2__c DESC, CreatedDate DESC NULLS LAST limit : CONTACTS_TO_ASSIGN];
				}
				*/
				/*
						  if(!contacts.isEmpty())
						  contactsToAssignList = [SELECT Id, OwnerId, Name, Contact_Score2__c, Sales_opportunity_latest_campaign__c, Total_Activities__c, Product2__c
									   FROM Contact
									   WHERE Id =: contacts[0].Id AND OwnerId =: ownerIds
									   LIMIT : CONTACTS_TO_ASSIGN FOR UPDATE];
					*/
				if(!leads.isEmpty()) {
					leadsToAssignList = [SELECT Id, OwnerId, Name, Lead_Score__c, Total_Activities__c, Product__c
							FROM Lead
							WHERE Id =: leads[0].Id AND OwnerId =: ownerIds
					LIMIT : LEADS_TO_ASSIGN FOR UPDATE];
				}


			}catch(QueryException queryEx){
				System.debug('This is Query Exception from Abandoner.: >>>'+queryEx);
			}

			return updateLeadContact();
		}

	public static List<SEAD_LeadContactInfo> updateLeadContact()
		{
			List<SEAD_LeadContactInfo> abandonersToReturn = new List<SEAD_LeadContactInfo>();
			/*
				if(contactsToAssignList.size() > 0)
				{
					try
					{
						for(Contact theContact : contactsToAssignList)
						{
							theContact.OwnerId = UserInfo.getUserId();
							abandonersToReturn.add(new SEAD_LeadContactInfo(String.valueOf(theContact.Id), theContact.Name, null, null, null, null, null, null, null,
																		String.valueOf(theContact.OwnerId), null, null, recordIdtoCampaignName.get(theContact.Id),null, theContact.Total_Activities__c,
																		theContact.Product2__c));
						}
						update contactsToAssignList;    //get rid of order number
					}catch(DMLException dmlEx){
						System.debug('This is DML Exception from Abandoner contact.: >>>'+dmlEx);
					}
				}
		*/
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

	public Integer availableAbandoners
	{
		get
			{
				//ownerIds = new Set<Id> {salesListOwner.Id, integrationUser.Id};
				ownerIds = new Set<Id> {salesListOwner.Id}; //removed the addition of single integration user id as we would be using multiple integration users for data loads : B-38758
				ownerIds.addAll(UtilityLibrary.allIntegrationUserIds); // added all the integration user ids instead : B-38758
				
				Integer records = 0;
				if (String.isNotBlank(currentUserFieldsOfExpertiseStr)) {
					String queryStr = 'SELECT count() FROM Lead WHERE (OwnerId =: ownerIds AND Isconverted = false) ';
					queryStr += 'AND Product_Line2__c IN (';
					queryStr += currentUserFieldsOfExpertiseStr;
					queryStr += ') LIMIT 1';
					records = Database.countQuery(queryStr);
				}
				//records = [SELECT COUNT() FROM Lead WHERE (Lead.OwnerId =: ownerIds AND Lead.Isconverted = false) LIMIT 1];
				/*
				if (records < 1) {
				  records = [SELECT COUNT() FROM Contact WHERE (Contact.OwnerId =: ownerIds) LIMIT 1];
				}
		  */
				return records;
			}
	}

}