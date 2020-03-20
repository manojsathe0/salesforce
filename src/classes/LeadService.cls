public without sharing class LeadService
{
    public static Boolean hasLeadTriggerRun =false;
    public static Boolean isValueChanged =false;
    public static final String PRIMARY_CONTACT = 'Primary Contact';
    public static final String QUEST_TYPE ='Questionnaire';
    public static final String CUST_TYPE ='Customer';
    public static final String WEB_TYPE ='Website';
    private static List<SEAD_Scoring_Time__c> configList = new List<SEAD_Scoring_Time__c>();

    public static void populateCustomOwnerField(List<Lead> newLeads)
        {
            for(Lead theLead : newLeads)
                {
                    theLead.Custom_Owner__c = theLead.ownerId;
                }
        }

    //Real time Call
    public static void processForCampaigns(List<Lead> newLeads)
        {
            Set<String> campaignNames = new Set<String>();

            for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c = :CampaignConstants.PRE_PURCHASE])
                {
                    campaignNames.add(theCampaign.Name);
                }

            if(!campaignNames.isEmpty() && !newLeads.isEmpty())
            {
                CampaignEngine theEngine = new CampaignEngine();
                List<CampaignMember> campaignMembers = theEngine.assignCampaignsForLead(newLeads, campaignNames);

                if(!campaignMembers.isEmpty())
                {
                    try
                    {
                        upsert campaignMembers;
                    }
                    catch(DMLException dmlEx)
                    {

                    }
                }
            }
        }

    public static void checkForDuplicateContact(List<Lead> newLeads)
        {
            Map<String,Lead> emailToLead = new Map<String,Lead>();

            for(Lead theLead : newLeads)
                {
                    if((theLead.Email != null && theLead.Email != '') && theLead.IsConverted == false)
                        emailToLead.put(theLead.Email,theLead);
                }
            List<Contact> matchingPrimaryContacts = new List<Contact>();
            if(!emailToLead.keySet().isEmpty())
                matchingPrimaryContacts = [SELECT Id, Email, Name, Contact_Type__c , Customer_Login_Email__c FROM Contact
                        WHERE Contact_Type__c =: PRIMARY_CONTACT AND Email In: emailToLead.keySet()];
            Map<String,List<Contact>> emailToContactMap = new Map<String,List<Contact>>();
            for(Contact theContact : matchingPrimaryContacts)
                {
                    if(emailToContactMap.containsKey(theContact.email))
                        emailToContactMap.get(theContact.email).add(theContact);
                    else
                        emailToContactMap.put(theContact.email,new List<Contact>{theContact});
                }

            for(Lead theLead : emailToLead.values())
                {
                    if(emailToContactMap.containsKey(theLead.Email))
                    {
                        String link = '';
                        for(Contact theContact : emailToContactMap.get(theLead.Email))
                            link = link + ' <a href="/'+theContact.Id+'" target="_blank"><h4>'+theContact.Name+' - '+theContact.Customer_Login_Email__c+'</h4></a>' + ', ';
                        theLead.addError('You are creating a duplicate record. We recommend you use an existing record instead.'+link, false);
                    }
                }
        }

    public static void processTMSLeads(List<Lead> incomingLeads)
        {
            List<Lead> tmsLeads = new List<Lead>();
            for(Lead theLead : incomingLeads)
                {
                    if(theLead.Campaign__c == 'TMS')
                    {
                        tmsLeads.add(theLead);
                    }
                }
            if(!tmsLeads.isEmpty())
            {

                List<Lead> unConvertedLeads = new List<Lead>();
                Map<Id,Contact> convertedContacts = new Map<Id,Contact>();
                processLeadsForConversion(tmsLeads , unConvertedLeads , convertedContacts);

                if(!unConvertedLeads.isEmpty())
                    LeadService.processForCampaigns(unConvertedLeads);
                if(!convertedContacts.isEmpty())
                    ContactService.processForCampaignsEntry(convertedContacts.values());
            }

        }
    public static void processMobilLeads(List<Lead> incomingLeads)
        {
            List<Lead> mobileLeads = new List<Lead>();
            for(Lead theLead : incomingLeads)
                {
                    if(theLead.LeadSource == CampaignConstants.MOBILE)
                    {
                        mobileLeads.add(theLead);
                    }
                }
            if(!mobileLeads.isEmpty())
            {

                List<Lead> unConvertedLeads = new List<Lead>();
                Map<Id,Contact> convertedContacts = new Map<Id,Contact>();

                processLeadsForConversion(mobileLeads , unConvertedLeads , convertedContacts);

                if(!unConvertedLeads.isEmpty())
                    LeadService.processForCampaigns(unConvertedLeads);
                if(!convertedContacts.isEmpty())
                    ContactService.processForCampaignsEntry(convertedContacts.values());
            }

        }


    public static void processLeadsForConversion(List<Lead> incomingLeads , List<Lead> unConvertedLeads , Map<Id,Contact> convertedContacts)
        {
            Map<String,Lead> emailToLead = new Map<String,Lead>();
            List<Lead> leadsToDelete = new List<Lead>();
            Set<Id> leads = new Set<Id>();
            List<Lead> leadsWithNoEmails = new List<Lead>();

            for(Lead theLead : incomingLeads)
                {
                    if(theLead.Email != null)
                    {
                        if(!emailToLead.containsKey(theLead.Email.toLowerCase()))
                        {
                            emailToLead.put(theLead.Email.toLowerCase()  , theLead);

                        }
                        else
                        {
                            leadsToDelete.add(new Lead(Id = theLead.Id));
                            leads.add(theLead.Id);
                        }

                    }
                    else
                    {
                        leadsWithNoEmails.add(theLead);
                    }
                }
            Map<String,Contact> emailToContact = new Map<String,Contact>();
            Map<Id,Contact> queriedContacts = new Map<Id,Contact>();

            if(!emailToLead.isEmpty())
            {
                for(Contact theContact : [SELECT Id , Email , AccountId FROM Contact WHERE Email IN :emailToLead.keySet() AND Contact_Type__c = :PRIMARY_CONTACT])
                    {
                        emailToContact.put(theContact.Email.toLowerCase() , theContact);
                        queriedContacts.put(theContact.Id , theContact);
                    }
            }

            Map<Id,List<Id>> contactIdToMatchingLeads = new Map<Id,List<Id>>();
            for(String theEmail : emailToLead.keySet())
                {
                    if(emailToContact.containsKey(theEmail.toLowerCase()))
                    {
                        Id contactId = emailToContact.get(theEmail.toLowerCase()).Id;
                        Lead theLead = emailToLead.get(theEmail.toLowerCase());
                        if(!contactIdToMatchingLeads.containsKey(contactId))
                            contactIdToMatchingLeads.put(contactId , new List<Id>());
                        contactIdToMatchingLeads.get(contactId).add(theLead.Id);

                        convertedContacts.put(contactId , queriedContacts.get(contactId));
                    }
                    else
                    {
                        unConvertedLeads.add(emailToLead.get(theEmail.toLowerCase()));
                    }
                }

            unConvertedLeads.addAll(leadsWithNoEmails);

            if(!contactIdToMatchingLeads.isEmpty())
            {
                DuplicateChecker.convertLeads(contactIdToMatchingLeads , queriedContacts);
            }
            if(!leadsToDelete.isEmpty())
            {
                delete leadsToDelete;

            }
        }

    public static void processLeadByContactStatus(Map<Id,Lead> oldLeads , Map<Id,Lead> newLeads)
        {
            List<Lead> leadStatusChanged = new List<Lead>();
            for(Lead newLead : newLeads.values())
                {
                    if(!newLead.IsConverted)
                    {
                        Lead oldLead = oldLeads.get(newLead.Id);
                        if(oldLead.Lead_Call_Status__c != newLead.Lead_Call_Status__c)
                        {
                            leadStatusChanged.add(newLead);
                        }
                    }
                }
            if(!leadStatusChanged.isEmpty())
            {
                LeadService.processForCampaignsExit(leadStatusChanged);
            }
        }

    public static List<Lead> getLeadsForDupCheck(List<Lead> incomingLeads)
        {
            List<Lead> leadsForDupCheck = new List<Lead>();
            for(Lead theLead : incomingLeads)
                {
                    if(theLead.LeadSource != CampaignConstants.MOBILE && theLead.Campaign__c != 'TMS' && theLead.LeadSource != 'Abandoner')
                        leadsForDupCheck.add(theLead);
                }
            return leadsForDupCheck;
        }

    public static void processForCampaignsExit(List<Lead> newLeads)
        {
            Set<String> campaignNames = new Set<String>();
            for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c = :CampaignConstants.PRE_PURCHASE])
                {
                    campaignNames.add(theCampaign.Name);
                }
            if(!campaignNames.isEmpty() && !newLeads.isEmpty())
            {
                CampaignEngine theEngine = new CampaignEngine();
                List<CampaignMember> campaignMembers = theEngine.exitCampaignsForLead(newLeads, campaignNames);

                if(!campaignMembers.isEmpty())
                {
                    try
                    {
                        upsert campaignMembers;
                    }
                    catch(DMLException dmlEx)
                    {

                    }
                }
            }
        }

    public static List<Lead> getMobileLeadsWithEmail(Map<Id,Lead> oldLeads , Map<Id,Lead> newLeads)
        {
            List<Lead> mobileLeadsWithEmail = new List<Lead>();
            for(Lead newLead : newLeads.values())
                {
                    if(!newLead.IsConverted)
                    {
                        Lead oldLead = oldLeads.get(newLead.Id);
                        if(oldLead.Email == null && newLead.Email != null)
                        {
                            mobileLeadsWithEmail.add(newLead);
                        }
                    }
                }
            return mobileLeadsWithEmail;
        }

    public static void populateInitialProduct(List<Lead> leads)
        {
            for(Lead theLead : leads)
                {
                    if(theLead.Initial_Product__c == null)
                        theLead.Initial_Product__c = theLead.Product2__c;

                }
        }
        
    /*public static void populateTealiumChanges(Map<Id,Lead> oldLeads , Map<Id,Lead> newLeads)
    {
        for(Lead newLead : newLeads.values())
        {
            Map<String, Map<String, String>> changes = new Map<String, Map<String, String>>();
            if(newLead.Updated_By_Tealium__c)
            {
                Lead oldLead = oldLeads.get(newLead.Id);
                
                for(Schema.FieldSetMember fsm : UtilityLibrary.getLeadTealiumUpdateFields())
                {
                    Object oldVal = oldLead.get(fsm.fieldPath);
                    Object newVal = newLead.get(fsm.fieldPath);
                    
                    if(oldVal != newVal)
                    {
                        Map<String, String> fieldMap = new Map<String, String>();
                        fieldMap.put(String.valueOf(oldVal), String.valueOf(newVal));
                        changes.put(fsm.label, fieldMap);
                    }
                }
                String jsonStr = JSON.serialize(changes);
                if(jsonStr.length()<=255)
                    newLead.Tealium_Updates__c = jsonStr;
            } 
        }
    }*/
  public static void populateTealiumChanges(Map<Id,Lead> oldLeads , Map<Id,Lead> newLeads)
        {
            for(Lead newLead : newLeads.values())
                {
                    Map<String, Map<String, String>> changes = new Map<String, Map<String, String>>();
                    if(newLead.Updated_By_Tealium__c || newLead.Reassigned_to_New_Sales_Owner__c)
                    {
                        Lead oldLead = oldLeads.get(newLead.Id);

                        for(Schema.FieldSetMember fsm : UtilityLibrary.getLeadTealiumUpdateFields())
                            {


                                Object oldVal = oldLead.get(fsm.fieldPath);
                                Object newVal = newLead.get(fsm.fieldPath);
                                if(oldVal != newVal)
                                {
                                    /*
                                    Code was modified by Artyom M. to work differently with Boolean fields.
                                    With Boolean fields the JSON containing field is being populated on if value is
                                    changed from FALSE to TRUE
                                    Story: B-19331;*/
                                    
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
                                        
                                        fieldMap.put(String.valueOf(oldVal), String.valueOf(newVal));
                                        System.debug('fsm.label ' + fsm.label + ': ' + fieldMap);
                                        changes.put(fsm.label, fieldMap);
                                    }
									String jsonStr = JSON.serialize(changes); // Padma added
									 if(jsonStr.length()<=255)
                            		newLead.Tealium_Updates__c = jsonStr;
                                }
                            }
                        /*String jsonStr = JSON.serialize(changes); // Padma commented
                        if(jsonStr.length()<=255)
                            newLead.Tealium_Updates__c = jsonStr; */
                    }
                }
        }
    public static void checkForOwnershipChange(Map<Id,Lead> oldLeads , Map<Id,Lead> newLeads)
        {
            //Id integrationUserId = UtilityLibrary.integrationUser.id; //used the Utility library to retrieve the integration user id: B-38758
            for(Lead newLead : newLeads.values())
                {
                    Lead oldLead = oldLeads.get(newLead.Id);
                    //if(newLead.OwnerId != oldLead.ownerId && newLead.OwnerId!=integrationUserId)
                    if(newLead.OwnerId != oldLead.ownerId && !UtilityLibrary.allIntegrationUserIds.Contains(newLead.OwnerId))
                        newLead.Ownership_Date__c = Datetime.now();
                }
        }
    public static void populateLeadSources(Map<Id,Lead> oldLeads , Map<Id,Lead> newLeads)
        {
            for(Lead newLead : newLeads.values())
                {
                    Lead oldLead = oldLeads.get(newLead.Id);
                    if(newLead.LeadSource != oldLead.LeadSource)
                    {
                        if(UtilityLibrary.isNotNullOrBlank(oldLead.Lead_Sources__c))
                        {
                            if(!newLead.Lead_Sources__c.contains(newLead.LeadSource))
                            {


                                newLead.Lead_Sources__c = newLead.Lead_Sources__c + newLead.LeadSource + ',';

                            }
                            if(newLead.Lead_Sources__c.contains(','))
                            {
                                List<String> parts = newLead.Lead_Sources__c.split(',');
                                newLead.Total_Source_Count__c = parts.size();
                            }
                            newLead.Latest_Source_Activity__c = Datetime.now();
                        }
                    }
                }
        }
    /*
    Populate Opp score functionality based on Custom Settings data
    Created By: Artyom M.
    Per Stories: B-18405, B-18411
    
    Moved to Opp Service-->
    */
    
    public static void populateLeadScore(List<Lead> leadlist, Boolean isBatch)
        //public static void populateLeadScore(Lead lead)
        {
            SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
            
            /*
                        Bulkified query.
                        By Artyom M.
			*/
            configList = [SELECT Id, Minimum__c, Maximum__c, Score__c, Related_To__c, Time_type__c, Record_type__c FROM SEAD_Scoring_Time__c WHERE Related_To__c = 'Lead' LIMIT 100];
            System.Debug('configList size = ' + configList.size());
            List<SEAD_Scoring_Percent__c> scp = [SELECT ID, Name, Maximum__c, Minimum__c, Score__c, Record_Type__c FROM SEAD_Scoring_Percent__c WHERE Related_To__c = 'Lead' LIMIT 100];
            System.Debug('scp size = ' + scp.size());
            
            List<Task> globalTaskCount = new List<Task>(); 
            Set<Id> leadIdsSet = new Set<Id>();
            for (Lead ld : leadlist) {
            	leadIdsSet.add(ld.Id);
            }
            System.debug('Id Set size: ' + leadIdsSet.size());
            Date cutoffDate = System.today().addDays(-180);

            if (leadIdsSet.size() > 0) {
            	//globalTaskCount = [SELECT Id, WhoId FROM Task WHERE WhoId IN :leadIdsSet];// AND CreatedDate >= :cutoffDate
            }
            
             /*
                        
				END
	            Bulkified query.
	            By Artyom M.
            */
            
            
            List<Lead> updatelist = new List<Lead>();
            if(leadlist.size()>0) {
                for( Lead lead:Leadlist){
                
                /*for( Lead lead: [SELECT Id,LeadSource,Questionnaire_End_Time__c,My_Account_End_Time__c,Website_End_Time__c, Questionnaire_Percent_Complete__c,HasOptedOutOfEmail,Lead_Score2__c,    
                                    (SELECT Id,Createddate,TimesOpened FROM EmailStatuses WHERE createddate <:datetime.now().addHours(-48) AND TimesOpened =0 ) 
                                FROM Lead WHERE Id IN:Leadlist]){*/
                    //lead.Lead_Score2__c = config.Lead_Score_Initial__c;
                    Integer initialScore = Integer.valueof(config.Lead_Score_Initial__c);
                    decimal sourceScore=0;


                    if(UtilityLibrary.isNotNullOrBlank(lead.LeadSource))
                    {

                        if(lead.LeadSource=='Abandoner')
                            sourceScore =  config.Lead_Abandoner_Score__c;
                        if(lead.LeadSource=='Chat')
                            sourceScore = config.Lead_Chat_Score__c;
                        if(lead.LeadSource=='Email')
                            sourceScore = config.Lead_Email_Score__c;
                        if(lead.LeadSource=='Inbound')
                            sourceScore = config.Lead_Inbound_Score__c;
                        if(lead.LeadSource=='Mobile')
                            sourceScore =config.Lead_Mobile_Score__c;
                        if(lead.LeadSource=='Social Media')
                            sourceScore =  config.Lead_Social_Media_Score__c;
                    }



                    decimal Q_Score =0;
                    decimal C_Score=0;
                    decimal W_Score=0;
                    decimal P_Score=0;
                    //Padma S @ B-18708 and B-16602
                    System.debug('lead.Questionnaire_End_Time__c  '+lead.Questionnaire_End_Time__c);
                    if(lead.Questionnaire_End_Time__c !=null){
                        Q_Score = searchConfigScore (lead.Questionnaire_End_Time__c, QUEST_TYPE, 'Lead'); // Questionnaire Score
                        System.Debug('Q_Score' + Q_Score);
                    }

                     System.debug('lead.My_Account_End_Time__c  '+lead.My_Account_End_Time__c);
                    if(lead.My_Account_End_Time__c !=null){
                        C_Score = searchConfigScore (lead.My_Account_End_Time__c, CUST_TYPE, 'Lead'); // Customer engagement Score
                        System.Debug('C_Score' + C_Score);
                    }

                    System.debug('lead.Website_End_Time__c  '+lead.Website_End_Time__c);
                    if(lead.Website_End_Time__c !=null){
                        W_Score = searchConfigScore (lead.Website_End_Time__c, WEB_TYPE, 'Lead');  // Website Score
                        System.Debug('W_Score' + W_Score);
                    }


                    //update the score based on the percentage
                    if(lead.Questionnaire_Percent_Complete__c !=null){



                        Integer percent = Integer.valueOf(lead.Questionnaire_Percent_Complete__c);
                        
                        /*
                        Bulkified query.
                        By Artyom M.
                         */

						for (SEAD_Scoring_Percent__c ssp : scp) {
							if (ssp.Maximum__c >= percent && ssp.Minimum__c < percent && ssp.Record_type__c == QUEST_TYPE) {
								P_Score = ssp.Score__c;
                            	System.debug('P_Score ' + P_Score);
							}
						}
  

                    }

                    Integer emailoptscore =0;
                    Integer Unopenedemailcount=0;
                    Integer UnansweredOCcount=0;
                    Integer taskCount = 0;

                    //add -1 if the lead.Email Opt-Out
                    if(lead.HasOptedOutOfEmail){
                        emailoptscore = -1;
                    }

                    //adding -1 for each of the unopened emails  or unopened emails for 48 hours
                    Unopenedemailcount = lead.emailstatuses.size()*-1;

                    //adding -1 for each of the outbound calls with No Answer.
                    UnansweredOCcount=lead.Tasks.size()*-1;

                    // update the score based on the number of activities on the lead
                    if(lead.Id != null){
                    	
                    	 /*
                        Bulkified query.
                        By Artyom M.
                         */
                    	for (Task tsk : globalTaskCount) {
                    		if (tsk.WhoId == lead.Id) {
                    			taskCount++;
                    		}
                    	}
                        //taskCount = [Select Count() from Task where WhoId =:lead.Id];
                    }


                    /*if(taskCount >0 ){
                       lead.Lead_Score2__c=lead.Lead_Score2__c+taskCount+Q_Score+C_Score+W_Score + P_Score;
                    }
                    else {
                        lead.Lead_Score2__c=lead.Lead_Score2__c + Q_Score + C_Score + W_Score+P_Score;
                    }*/
                    
                    System.Debug('initialScore -' + initialScore);
					System.Debug('sourceScore -' + sourceScore);
                    System.Debug('taskCount -' + taskCount);
                    System.Debug('Q_Score -' + Q_Score);
                    System.Debug('C_Score -' + C_Score);
                    System.Debug('W_Score -' + W_Score);
                    System.Debug('P_Score -' + P_Score);
                    System.Debug('emailoptscore -' + emailoptscore);
                    System.Debug('Unopenedemailcount -' + Unopenedemailcount);
                    System.Debug('UnansweredOCcount -' + UnansweredOCcount);
                    
                    lead.Lead_Score2__c=initialScore+sourceScore+taskCount+Q_Score+C_Score+W_Score + P_Score+emailoptscore+Unopenedemailcount+UnansweredOCcount;
                    updatelist.add(lead);
                }
            }
            //update lead;
            if( isBatch){
                update updatelist;

            }
            //EOC Padma S

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
    
    /*
    Author      : Padma S
    Story       : B-18708 and B-16602
    Description : This method takes the source endtime in datetime fomat and the record type(Questionnaire, customer, website) to get the score from the SEAD_Scoring_Time__c confifuration custom settings.
     */
     
     /*
     
     No longer used. See searchConfigScore instead.
    public static decimal getConfigScore (datetime endtime, string recordType, String relatedTo)
        {

            datetime now =datetime.now();
            //integer minutes = (integer.valueof(now.getTime() - endtime.getTime()))/1000/60;
            //integer Hours = (integer.valueof(now.getTime() - endtime.getTime()))/1000/60/60; 

            integer minutes = (integer.valueof((now.getTime())/1000/60 - (endtime.getTime())/1000/60));
            integer Hours = (integer.valueof((now.getTime())/1000/60/60 - (endtime.getTime())/1000/60/60));


            decimal score;
            string timetype;
            integer timeperiod=0;

            System.debug('time period is '+timeperiod);
            if (minutes <= 60){

                timetype = 'Minutes';
                timeperiod = minutes;
            }
            else {

                timetype = 'Hours';
                timeperiod=Hours;
            }


            if(timeperiod <= 99){
                list<SEAD_Scoring_Time__c>configlist =[Select Id, Minimum__c,Maximum__c,Score__c
                        from SEAD_Scoring_Time__c
                        where Time_type__c=:timetype and Maximum__c >:timeperiod and Minimum__c<=:timeperiod and Record_type__c=:recordType 
                        AND Related_To__c = :relatedTo LIMIT 1];
                if(configlist.size()>0){
                	System.debug('Config ID: ' + configlist[0].Id);
                    SEAD_Scoring_Time__c  configmin = configlist[0];

                    score = configmin.Score__c;
                }
                if(score == null){
                    score=0;
                }

            }
            else {
                score=-1;
            }



            return score;

        }

*/
    /*Author    : Padma S
    Story       : B-18129 @ B-18698 B-19353
    Description : This mehod is reopens the lead and changes the status based on the number of activities on the lead.
                  it is fired from the lead trigger when the there is change in latest Questionnaire, My Account and Website end time changes on the lead 
                  or whhen there is new activity on the lead if the lead is in closed lost. We are also setting the Closed Lost Reason to a blank value. 
    */
    
    public static void reOpenClosedLead(List<Lead> LeadQ ){
        
        SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
        List<Lead> updateleadlist = new List<Lead>();       
        
        List<Lead>leadlist = [SELECT Id, Status, Closed_Lost_Reason__c, (SELECT Id FROM Tasks) FROM Lead WHERE Id IN:leadQ];
        
        for (Lead l: leadlist){
        
                if(l.tasks.size() <= config.Lead_New_Stage_Activity_Limit__c)
                {
                    l.Status ='New';
                    l.Closed_Lost_Reason__c ='';
                    updateleadlist.add(l);
                }
                else if(l.tasks.size() == config.Lead_Qualified_Stage_Activity_Limit__c)
                {
                    l.Status ='Qualified';
                    l.Closed_Lost_Reason__c ='';
                    updateleadlist.add(l);
                    
                }
                else if(l.tasks.size() >= config.Lead_Validated_Stage_Activity_Minimum__c)
                {
                    l.Status ='Validated';
                    l.Closed_Lost_Reason__c ='';
                    updateleadlist.add(l);
                    
                }
        }
        update updateleadlist;    
        
        
    }
    //EOC Padma S

    /*
    Author: Artyom M.
    Story: B-18814

    The following method checks what product is on a Lead record, searches for that product in the Product2 table
    and copies the corresponding Product Line from that Product2 record into the Lead record.
    */

    /*public static void populateProductLine(List<Lead> leads) {
        Set<String> productNamesSet = new Set<String>();
        for(Lead theLead : leads) {
            if (theLead.Product__c != null) {
                productNamesSet.add(theLead.Product__c);
            }
            else {
                theLead.Product_Line_2__c = null;
            }
        }

        List<Product2> relevantProducts;
        relevantProducts = [SELECT Name, Product_Line__r.Name FROM Product2 WHERE Name IN :productNamesSet];
        if (!relevantProducts.isEmpty()) {
            Map<String, String> productNameLineMap = new Map<String, String>();
            for (Product2 pr : relevantProducts) {
                productNameLineMap.put(pr.name, pr.Product_Line__r.Name);
            }

            for (Lead theLead : leads) {
                theLead.Product_Line_2__c = productNameLineMap.get(theLead.Product__c);
            }
        }
    } */

    /*
    Author: Artyom M.
    Story:  B-19331

    The following method checks if a Lead was reassigned from one Sales user to another and
    checks the Reassigned_to_New_Sales_Owner__c checkbox.
    */


    public static void markReassignedLeads(Map<Id,Lead> oldLeads, Map<Id,Lead> newLeads) {
        List<Profile> salesProfiles = [SELECT Id, Name FROM Profile WHERE Name LIKE 'Sales%'];
        Set<Id> salesProfileIdsSet = new Set <Id>();
        for (Profile pf : salesProfiles) {
            salesProfileIdsSet.add(pf.Id);
        }
        List<User> userList = [SELECT Id FROM User WHERE ProfileId IN :salesProfileIdsSet];
        Set<Id> userIdSet =  new Set <Id>();
        for (User u : userList) {
            userIdSet.add(u.Id);
        }
        for (Lead ld : newLeads.values()) {
            ld.Reassigned_to_New_Sales_Owner__c = false;
            Id newOwnerID = ld.OwnerId;
            Id oldOwnerId = oldLeads.get(ld.Id).OwnerId;
            if (newOwnerID != oldOwnerId) {
                //owner has changed
                if (userIdSet.contains(newOwnerID) && userIdSet.contains(oldOwnerId)) {
                    ld.Sales_User_Changed_Time__c = System.Now();
                    ld.Reassigned_to_New_Sales_Owner__c = true;
                }
                else {
                    ld.Reassigned_to_New_Sales_Owner__c = false;
                }
            }
        }


    } 



    public static void deleteChildren(Map<Id,Lead> leads)
        {
            //Padma Moving SOQL outof for loop to avoid too many SOQL issue
            /*for(Lead lead : leads.values())
            {
               if(lead.isConverted || Trigger.isDelete)
                    {

                    List<My_Account_Activity__c> myAccountActivities = [select id from My_Account_Activity__c where Lead__c=:lead.id];
                    MyAccountActivityService.deleteMyAccountActivities(myAccountActivities);
                    List<Opt_In_Cart_Item__c> jsonOptins = [select id from Opt_In_Cart_Item__c where Lead__c=:lead.id];
                    OptInService.deleteOptIns(jsonOptins);
                }


            } */
            List<My_Account_Activity__c> myAccountActivities = [select id from My_Account_Activity__c where Lead__c=:leads.keyset()];
            if(myAccountActivities.size() >0)
            MyAccountActivityService.deleteMyAccountActivities(myAccountActivities);
            List<Opt_In_Cart_Item__c> jsonOptins = [select id from Opt_In_Cart_Item__c where Lead__c=:leads.keyset()];
            if(jsonOptins.size() >0)
            OptInService.deleteOptIns(jsonOptins);
        }
    
    //B-20429 Set the flag Record_Modified__c when Lead records were modified
    public static void markModifiedRecords(List<Lead> oldLead,List<lead> newLead){
        for(integer i=0;i<newLead.size();i++){
            if(oldLead[i].UUID__c != newLead[i].UUID__c ||oldLead[i].FirstName != newLead[i].FirstName ||oldLead[i].LastName != newLead[i].LastName ||oldLead[i].Email != newLead[i].Email ||oldLead[i].Phone != newLead[i].Phone ||oldLead[i].Status != newLead[i].Status ||oldLead[i].Product__c != newLead[i].Product__c ||oldLead[i].Industry != newLead[i].Industry ||oldLead[i].Lead_Score__c != newLead[i].Lead_Score__c ||oldLead[i].Closed_Lost_Reason__c != newLead[i].Closed_Lost_Reason__c){
                newLead[i].Record_Modified__c = true;
            }
        }
    }
    //B-19691 This UpdateUUID method is a future method as we want to get UUID asyncronosly and update it to lead.
    @future(callout=true)
   /* public static void updateUUID(id llist,boolean isEmailChanged){
        //takes lead id  and query the record
        lead l= [select id,UUID__c,Email from lead where id = :llist and (Email != null or Email != '')];
        //check if email is not null and uuid is blank i.e if uuid is already present it will not process further
        if(string.isEmpty(l.UUID__c) || isEmailChanged){
            //instantiate leadEmailUUIDController class
            leadEmailUUIDController a = new leadEmailUUIDController();
            string uuid = a.queryEmailUUID(l.Email);
            // call method queryEmailUUID from leadEmailUUIDController
            if(uuid != ''){
                l.UUID__c = a.queryEmailUUID(l.Email);
                //set record_processed_Once__c true
                l.record_processed_Once__c = true;
                //Update the lead
                update l;
            }
        }
    }*/
    public static void updateUUID(id llist){
        //takes lead id  and query the record
        List<lead> ld= [select id,UUID__c,Email from lead where id = :llist and (Email != null or Email != '')];
         //check if email is not null and uuid is blank i.e if uuid is already present it will not process further
         Lead l;
        if(ld.size()>0){
        	l =ld[0];
        }
       
        if(l != null){
            //instantiate leadEmailUUIDController class
            leadEmailUUIDController a = new leadEmailUUIDController();
            string uuid = a.queryEmailUUID(l.Email);
            system.debug('ResponseUUID'+uuid);
            // call method queryEmailUUID from leadEmailUUIDController
            if(uuid != ''){
                l.UUID__c = uuid;
                //set record_processed_Once__c true
                l.record_processed_Once__c = true;
                //Update the lead
                update l;
            }
        }
    } 
    
    //@B-35598 Artyom  
    public static void checkIfPhoneNumberChanged(Map<Id,Lead> oldLeadsMap, List<Lead> newLeads) {
        System.Debug('Inside checkIfPhoneNumberChanged');
        for (Lead ld : newLeads) {
            if (ld.Internal_List__c == true) {
                if (ld.Phone != null && ld.Phone != oldLeadsMap.get(ld.Id).Phone) {
                    System.Debug('Phone Changed');
                    String formattedPhoneNumber = PhoneFormatter.formatPhone(ld.Phone);
                    DNCService_ltng.numberToInternalList(formattedPhoneNumber);
                }
                if (ld.MobilePhone != null && ld.MobilePhone != oldLeadsMap.get(ld.Id).MobilePhone) {
                    System.Debug('MobilePhone Changed');
                    String formattedPhoneNumber = PhoneFormatter.formatPhone(ld.Phone);
                    DNCService_ltng.numberToInternalList(formattedPhoneNumber);
                }

            }
            
        }
    }
        
     public static void updateKeadStatusDNc(List<lead> leadsnew){
        //Id data = [select id from user where name='Integration User'].id;
       //Id data = UtilityLibrary.integrationUser.id; //used the Utility library to retrieve the integration user id: B-38758
       for(Lead leaddnc :leadsnew )
       {
         //if(leaddnc.Internal_List__c && leaddnc.ownerid==data ) 
         if(leaddnc.Internal_List__c && UtilityLibrary.allIntegrationUserIds.Contains(leaddnc.ownerid))
         {
             leaddnc.Status='Closed Lost';
               leaddnc.Closed_Lost_Reason__c='Do Not Call';
         }
       }
    } 
}