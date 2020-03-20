/*
	OpportunityService class created as Service class for Opportunity Trigger on 10/20/2017
	Author: Artyom M.
	Story: B-22376
*/
public without sharing class OpportunityService {
	public final static String DUP_ERROR_MSG = 'Opportunity with the same product already exists for this contact.';
	private static List<SEAD_Scoring_Time__c> configList = new List<SEAD_Scoring_Time__c>();
	public static final String QUEST_TYPE ='Questionnaire';
    public static final String CUST_TYPE ='Customer';
    public static final String WEB_TYPE ='Website';
	public static void ensureNoDuplicateOppsUnderSameContact(Map<Id, Opportunity> oldOppsMap, List<Opportunity> newOpps, Boolean isInsert) {
		System.debug('OpportunityService service started.');

		Set<Id> contactIdSet = new Set<Id>();
		System.debug('newOpps size ' + newOpps.size());
		for (Opportunity op : newOpps) {
			if (op.Contact__c != null) {
				contactIdSet.add(op.Contact__c);
			}
		}
		
		Map<Id, List<Opportunity>> contactIdtoOppListMap = new Map<Id, List<Opportunity>>();
		
		List<Opportunity> existingOpss = new List<Opportunity>();
		existingOpss = [SELECT Id, Contact__c, Product2__c FROM Opportunity WHERE Contact__c IN :contactIdSet AND (NOT StageName Like 'Closed%') LIMIT 5000];
		System.debug('Exisitng: ' + existingOpss.size()); 
		for (Opportunity op : existingOpss) {
			if (!contactIdtoOppListMap.containsKey(op.Contact__c)) {
				contactIdtoOppListMap.put(op.Contact__c, new List<Opportunity>());
			}
			contactIdtoOppListMap.get(op.Contact__c).add(op);
		}
		
		if (isInsert) {
			for (Opportunity op : newOpps) {
				List<Opportunity> localOppList = new List<Opportunity>(); 
				if (contactIdtoOppListMap.containsKey(op.Contact__c)) {
					localOppList = contactIdtoOppListMap.get(op.Contact__c);
					for (Opportunity o : localOppList) {
						if (op.Product2__c != null && op.Product2__c.Equals(o.Product2__c)) {
							op.addError(DUP_ERROR_MSG);
						}
					}
				}
			}
		}
		else {
			for (Opportunity op : newOpps) {
				if (op.Product2__c != null && op.Product2__c != oldOppsMap.get(op.Id).Product2__c) {
					List<Opportunity> localOppList = new List<Opportunity>();
					if (contactIdtoOppListMap.containsKey(op.Contact__c)) {
						localOppList = contactIdtoOppListMap.get(op.Contact__c);
						for (Opportunity o : localOppList) {
							if (op.Product2__c.Equals(o.Product2__c)) {
								op.addError(DUP_ERROR_MSG);
							}
						}
					}
				}
			}
		}
		
		
	}
	public static Boolean isAdminProfileRunningNow() {
		Boolean isAdminProfileRunning = false;
		List<Profile> adminProfiles = new List<Profile>();
		adminProfiles = [SELECT Id, Name FROM Profile WHERE Name LIKE 'System Admin%'];
		System.debug('adminProfiles size ' + adminProfiles.size());
		for (Profile pr : adminProfiles) {
			System.debug('UserInfo.getProfileId() ' + UserInfo.getProfileId());
			System.debug('pr.Id ' + pr.Id);
			if (UserInfo.getProfileId() == pr.Id) {
				isAdminProfileRunning = true;
			}
		}
		return isAdminProfileRunning;
		
	}
	
	/*
    Populate Opp score functionality based on Custom Settings data
    Created By: Artyom M.
    Per Stories: B-18405, B-18411
    */
        
    public static void populateOppScore(List<Opportunity> opps, Boolean isBatch) {
    	System.debug('populateOppScore started.');
    	SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
    	configList = [SELECT Id, Minimum__c, Maximum__c, Score__c, Related_To__c, Time_type__c, Record_type__c FROM SEAD_Scoring_Time__c WHERE Related_To__c = 'Opp' LIMIT 100];
    	System.Debug('configList size = ' + configList.size());
        List<SEAD_Scoring_Percent__c> scp = [SELECT ID, Name, Maximum__c, Minimum__c, Score__c, Record_Type__c FROM SEAD_Scoring_Percent__c WHERE Related_To__c = 'Opp' LIMIT 100];
        System.Debug('scp size = ' + scp.size());
            
        List<Task> globalTaskCount = new List<Task>(); 
        Set<Id> oppIdsSet = new Set<Id>();
        for (Opportunity opp : opps) {
        	oppIdsSet.add(opp.Id);
        }
        System.debug('Id Set size: ' + oppIdsSet.size());
        Date cutoffDate = System.today().addDays(-180);
        if (oppIdsSet.size() > 0) {
        	//globalTaskCount = [SELECT Id, CreatedDate, WhoId FROM Task WHERE WhoId IN :oppIdsSet AND CreatedDate >= :cutoffDate];
        }
    	
    	
    	List<Opportunity> oppsToUpdate= new List<Opportunity>();
    	
    	if (opps.size() > 0) {
    		for (Opportunity opp : opps) {
    			Integer initialScore = Integer.valueof(config.Opp_Score_Initial__c);
    			Decimal sourceScore = 0;
    			
    			if (UtilityLibrary.isNotNullOrBlank(opp.LeadSource)) {
    				if(opp.LeadSource=='Abandoner')
    					sourceScore =  config.Opp_Abandoner_Score__c;
                    if(opp.LeadSource=='Chat')
                        sourceScore = config.Opp_Chat_Score__c;
                    if(opp.LeadSource=='Email')
                        sourceScore = config.Opp_Email_Score__c;
                    if(opp.LeadSource=='Inbound')
                        sourceScore = config.Opp_Inbound_Score__c;
                    if(opp.LeadSource=='Mobile')
                        sourceScore =config.Opp_Mobile_Score__c;
                    if(opp.LeadSource=='Social Media')
                        sourceScore =  config.Opp_Social_Media_Score__c;
    			}
    			
    			Decimal questionareScore = 0;
    			Decimal custEngScore = 0;
    			Decimal websiteScore = 0;
    			Decimal percentageScore = 0;
    			
    			
    			if (opp.Questionnaire_End_Time__c != null) {
    				questionareScore = searchConfigScore(opp.Questionnaire_End_Time__c, QUEST_TYPE, 'Opp');
    			}
    			
    			if (opp.My_Account_End_Time__c != null) {
    				custEngScore = searchConfigScore(opp.My_Account_End_Time__c, CUST_TYPE, 'Opp');
    			}
    			
    			if (opp.Website_End_Time__c != null) {
    				websiteScore = searchConfigScore(opp.Website_End_Time__c, WEB_TYPE, 'Opp');
    			}
    			

    			if(opp.Questionnaire_Percent_Complete__c != null) {
    				Integer percent = Integer.valueOf(opp.Questionnaire_Percent_Complete__c);

					for (SEAD_Scoring_Percent__c ssp : scp) {
						if (ssp.Maximum__c >= percent && ssp.Minimum__c < percent && ssp.Record_type__c == QUEST_TYPE) {
							percentageScore = ssp.Score__c;
                    		System.debug('percentageScore ' + percentageScore);
						}
					} 				
    				
    			}
    			
    			Integer emailOptScore = 0;
				Integer unopenedEmailCount = 0;
                Integer unansweredOCcount = 0;
                Integer taskCount = 0;
                
				
				if(opp.HasOptedOutOfEmail__c){
                	emailoptscore = -1;
                }
  
				
                unansweredOCcount = opp.Tasks.size()*-1;

                if(opp.Id != null){
                	for (Task tsk : globalTaskCount) {
                    	if (tsk.WhoId == opp.Id) {
                    		taskCount++;
                    	}
                    }
                }
    			
    			opp.Score__c = initialScore + sourceScore +taskCount + questionareScore + custEngScore + websiteScore + percentageScore + emailOptScore + unopenedEmailCount + unansweredOCcount;
				oppsToUpdate.add(opp);

    		}
    	}
    	
    	if(isBatch) {
    		update oppsToUpdate;
    	}
    }
    /*
    A helper method created for Bulkifying purposes to substiute not bulkified getConfigScore method.
    Searches trough list
    Created By: Artyom M.
    Per Stories: B-18405, B-18411
    */
    public static Decimal searchConfigScore(Datetime endTime, String recordType, String relatedTo) {
    	Datetime now = datetime.now();
    	Integer minutesSinceEndTime = (Integer.valueof((now.getTime())/1000/60 - (endtime.getTime())/1000/60));
    	System.Debug('minutesSinceEndTime - ' + minutesSinceEndTime);
    	Decimal score = 0;
    	if (minutesSinceEndTime > 5940) {
    		score = -1;    		
    	}
    	else {
    		for (SEAD_Scoring_Time__c cnfT : configList) {
    			Decimal minimumMinutes, maximumMinutes;
    			if (cnfT.Time_type__c == 'Minutes') {
    				minimumMinutes = cnfT.Minimum__c;
    				maximumMinutes = cnfT.Maximum__c;
    			}
    			else {
    				minimumMinutes = cnfT.Minimum__c * 60;
    				maximumMinutes = cnfT.Maximum__c * 60;
    			}
    			
    			if (minutesSinceEndTime < maximumMinutes && minutesSinceEndTime >= minimumMinutes && cnfT.Record_type__c == recordType && cnfT.Related_To__c == relatedTo) {
    				System.Debug('name ' + cnfT.Score__c);
    				score = cnfT.Score__c;
    				System.debug('Config ID: ' + cnfT.Id);
    			}
    		}
    	}
    	
    	return score;
    	
    }
    
    public static void populateTealiumChanges(Map<Id, Opportunity> oldOpps, Map<Id, Opportunity> newOpps) {
    	System.Debug('populateTealiumChanges STARTS HERE');
    	for(Opportunity opp : newOpps.values()) {
    		Map<String, Map<String, String>> changes = new Map<String, Map<String, String>>();
    		if ((opp.Updated_By_Tealium__c || opp.Reassigned_to_New_Sales_Owner__c) && opp.OptIn_Opportunity__c != true) {
    			Opportunity oldOpp = oldOpps.get(opp.Id);
				for (Schema.FieldSetMember fsm : UtilityLibrary.getOppTealiumUpdateFields()) {
					Object oldVal = oldOpp.get(fsm.fieldPath);
					Object newVal = opp.get(fsm.fieldPath);
					System.Debug('oldVal = ' + oldVal);
					System.Debug('newVal = ' + newVal);
                    if(oldVal != newVal) {
						if (String.valueOf(fsm.getType())  == 'Boolean') {
							if (oldVal == false && newVal == true) {
                            	System.debug('It switched to true: ' + newVal);
                                Map<String, String> fieldMap = new Map<String, String>();
                                fieldMap.put(String.valueOf(oldVal), String.valueOf(newVal));
                                changes.put(fsm.label, fieldMap);
                            }
                         }
                         else {
                         	Map<String, String> fieldMap = new Map<String, String>();
                             String oldValStr;
                             if (oldVal == null) {
                                 oldValStr = 'Blank';
                             }
                             else {
                                 oldValStr = String.valueOf(oldVal);
                             }
                            fieldMap.put(oldValStr, String.valueOf(newVal));
                             System.debug('fieldMap = ' + fieldMap);
                            changes.put(fsm.label, fieldMap);
                         }
                         if (changes != null && !changes.isEmpty()) {
                         	String jsonStr = JSON.serialize(changes);
							 if(jsonStr.length() <= 255) {
							 	opp.Tealium_Updates__c = jsonStr;						 	
						 }
                         }
                           		
					}
				}
             }
		}
	}
	
	public static void stampContactOnNewOppCreation(List<Opportunity> opps) {
		Set<Id> parentContactIdSet = new Set<Id>();
		Map<Id, Id> oppIdToContactIdMap = new Map<Id, Id>();
		Map<Id, Id> contactIdToOppIdMap = new Map<Id, Id>();
		for (Opportunity o : opps) {
			if (o.Updated_By_Tealium__c == true && o.OptIn_Opportunity__c == false) {
				contactIdToOppIdMap.put(o.Contact__c, o.Id);
				//oppIdToContactIdMap.put(, );
				parentContactIdSet.add(o.Contact__c); //only opps created via API
			}
		}
		
		System.Debug('parentContactIdSet = ' + parentContactIdSet.size());
		List<Contact> parentContacts = new List<Contact>();
		parentContacts = [SELECT Id, Last_Opportunity_Created_DateTime__c, Last_Opportunity_Id__c, Updated_By_Tealium__c, Updated_By_Tealium_DateTime__c FROM Contact WHERE Id In :contactIdToOppIdMap.keySet()];
		if (!parentContacts.isEmpty()) {
			for (Contact cnt : parentContacts) {
				cnt.Last_Opportunity_Created_DateTime__c = System.Now();
				cnt.Updated_By_Tealium_DateTime__c = System.Now();
				cnt.Updated_By_Tealium__c = true;
				cnt.Last_Opportunity_Id__c = contactIdToOppIdMap.get(cnt.Id);
			}
			update parentContacts;
		}
		
		
		
	}
	
	public static void markReassignedOpportunities(Map<Id, Opportunity> oldOpps, Map<Id, Opportunity> newOpps) {
        List<Profile> salesProfiles = [SELECT Id, Name FROM Profile WHERE (NOT Name LIKE 'System%')];
        Set<Id> salesProfileIdsSet = new Set<Id>();
        for (Profile pf : salesProfiles) {
            salesProfileIdsSet.add(pf.Id);
        }
        List<User> userList = [SELECT Id FROM User WHERE ProfileId IN :salesProfileIdsSet and isactive=true ];
        Set<Id> userIdSet =  new Set <Id>();
        for (User u : userList) {
            userIdSet.add(u.Id);
        }
        for (Opportunity opp : newOpps.values()) {
            opp.Reassigned_to_New_Sales_Owner__c = false;
            Id newOwnerID = opp.OwnerId;
            Id oldOwnerId = oldOpps.get(opp.Id).OwnerId;
            if (newOwnerID != oldOwnerId) {
                //owner has changed
                if (userIdSet.contains(newOwnerID) && userIdSet.contains(oldOwnerId)) {
                    opp.User_Changed_On__c = System.Now();
                    opp.Reassigned_to_New_Sales_Owner__c = true;
                }
                else {
                    opp.Reassigned_to_New_Sales_Owner__c = false;
                }
            }
        }


    }
    /*
	Added for Story: B-18815
	Created by: Artyom M.
	*/
    public static void checkForOwnershipChange(Map<Id, Opportunity> oldOpps, Map<Id, Opportunity> newOpps) {
        //Id integrationUserId = UtilityLibrary.integrationUser.id; //used the Utility library to retrieve the integration user id: B-38758
        for (Opportunity newOpp : newOpps.values()) {
            Opportunity oldOpp = oldOpps.get(newOpp.Id);
            //if(newOpp.OwnerId != oldOpp.OwnerId && newOpp.OwnerId != integrationUserId) {
            if(newOpp.OwnerId != oldOpp.OwnerId && !UtilityLibrary.allIntegrationUserIds.Contains(newOpp.OwnerId)) {
                newOpp.Ownership_Date__c = Datetime.now();
            }
        }
    }
    /*
	    The following method auto assignes the Opp close date
		Added per Story B-23079
		Created by: Artyom M.
		
		Removed and substituted with worflow.
	*/
	
	/*
	
    public static void populateCloseDate(Map<Id, Opportunity> oldOpps, List<Opportunity> newOppsList) {
    	List<OpportunityStage> opportunityStages = [SELECT MasterLabel, IsActive, IsClosed, IsWon FROM OpportunityStage WHERE isWon = true AND IsClosed = true AND IsActive = true];
    	System.Debug('opportunityStages = ' + opportunityStages);
    	if (oldOpps == null) {
    		System.Debug('New scenario');
    		//insert scenario
    		for (Opportunity opp : newOppsList) {
    			Boolean isClosedWon = false;
    			for (OpportunityStage os : opportunityStages) {
    				if (os.MasterLabel.equals(opp.StageName)) {
    					isClosedWon = true;
    					break;
    				}
    			}
    			if (isClosedWon) {
    				opp.CloseDate = System.Today();
    				System.Debug('opp.CloseDate = ' + opp.CloseDate);
    			}
    			else {
    				opp.CloseDate = System.Today().addDays(7);    				
    			}
    		}
    	}
    	else {
    		//Exisitng scenario
    		System.Debug('Existing scenario');
    		for (Opportunity opp : newOppsList) {
    			Opportunity oldOpp = oldOpps.get(opp.Id);
    			Boolean isClosedWon = false;
    			System.Debug('opp.StageName = ' + opp.StageName);
    			System.Debug('oldOpp.StageName = ' + oldOpp.StageName);
    			if (opp.StageName != oldOpp.StageName) {
    				System.Debug('!=');
    				for (OpportunityStage os : opportunityStages) {
    					if (os.MasterLabel.equals(opp.StageName)) {
    						isClosedWon = true;
    						break;
    					}
    				}
    				if (isClosedWon) {
    					opp.CloseDate = System.Today();
    					System.Debug('opp.CloseDate = ' + opp.CloseDate);
    				}
    			}			
    		}
    		
    	}
    	
    }
    */
    
    /*
	    The following method populates some Opp Source fields
		Added per Story B-18392
		Created by: Artyom M.
	*/
    public static void populateOppSourceFields(Map<Id, Opportunity> oldOpps, List<Opportunity> newOppsList) {
    	for (Opportunity newOpp : newOppsList) {
    		Opportunity oldOpp = oldOpps.get(newOpp.Id);
    		if (newOpp.LeadSource != oldOpp.LeadSource) {
    			if (UtilityLibrary.isNotNullOrBlank(oldOpp.List_Of_Sources__c)) {
    				if (!newOpp.List_Of_Sources__c.contains(newOpp.LeadSource) ) {
    					newOpp.List_Of_Sources__c = newOpp.List_Of_Sources__c + newOpp.LeadSource + ',';
    				}
    				if (newOpp.List_Of_Sources__c.contains(',')) {
    					List<String> parts = newOpp.List_Of_Sources__c.split(',');
						newOpp.Total_Source_Count__c = parts.size();
    				}
    				newOpp.Latest_Source_Activity_Date_Time__c = Datetime.now();
    			}
    		}
    	}
    	
    }
	
}