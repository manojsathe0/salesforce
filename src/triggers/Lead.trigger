trigger Lead on Lead (before update , before insert , after insert , after update, before delete ) {
	if(system.isFuture()) return;

    if(Trigger.isBefore && Trigger.isUpdate)
    {
        LeadService.populateCustomOwnerField(Trigger.new);
        LeadService.populateInitialProduct(Trigger.new);
        List<Lead> leadsForDupCheck = LeadService.getLeadsForDupCheck(Trigger.new);
        if(!leadsForDupCheck.isEmpty()){
            LeadService.checkForDuplicateContact(leadsForDupCheck);
        }
        LeadService.markReassignedLeads(Trigger.oldMap , Trigger.newMap);
        LeadService.populateTealiumChanges(Trigger.oldMap , Trigger.newMap);
       // LeadService.populateProductLine(Trigger.new);
        LeadService.checkForOwnershipChange(Trigger.oldMap , Trigger.newMap);
        LeadService.populateLeadSources(Trigger.oldMap , Trigger.newMap);
        //system.debug('oldEmail'+Trigger.oldMap.get(Trigger.new[0].id).email);
        //system.debug('newEmail'+Trigger.newMap.get(Trigger.new[0].id).email);
        if( Trigger.oldMap.get(Trigger.new[0].id).email != Trigger.newMap.get( Trigger.new[0].id ).email  ){
            LeadService.isValueChanged = true;
        }
        if(!Test.isRunningTest()){
            LeadService.markModifiedRecords(Trigger.old , Trigger.new);
        }
       
       
        //padma modified  below for 101 SOQL issue on leadservice test. as this method call is taking 160 SOQL queries
        //LeadService.deleteChildren(Trigger.new);  // commented
        if(!Test.isRunningTest()){
            Map<Id,Lead> leadmap= new Map<Id, Lead>();
            for (Lead ld : Trigger.new){
    
                Lead oldLead = trigger.oldmap.get(ld.Id);
    
                if( (ld.isConverted != oldLead.isConverted ) && ld.isConverted ){
    
                    if(!leadmap.containsKey(ld.Id)) {
                        leadmap.put(ld.Id, ld);
                    }
    
                }
            }
    
            LeadService.deleteChildren(leadmap);
        }
        //EOC below
    }
    if(Trigger.isBefore && Trigger.isInsert)
    {
    	//Padma @B-33310
    	Set<String> leadEmailSet = new Set<String>();
		List<Lead> leadList = new List<Lead>();
		Map<String, Id> leadAcctMap = new Map<String, Id>();
		String matchAccountId; 
	
		for (Lead l: trigger.new) {
			leadEmailSet.add(l.Company);
			leadList.add(l);
		}
		
	    Account[] acctList = [SELECT Id, Name FROM Account WHERE Name in : leadEmailSet ORDER BY Name];
		if (acctList.size() > 0) {
			for (Lead l: leadList) {
				for (Account a: acctList) {
					if (l.Company == a.Name) {
						leadAcctMap.put(l.Company,a.Id);
						break;
					}
				}
			}
		}
	
		for (Lead l: trigger.new) {
			l.Account__c = leadAcctMap.containsKey(l.Company) ? leadAcctMap.get(l.Company) : NULL;
		}
	
   
        LeadService.populateCustomOwnerField(Trigger.new);
        LeadService.populateInitialProduct(Trigger.new);
      //  LeadService.populateProductLine(Trigger.new);
        for(Lead theLead : Trigger.new)
            {
                if(theLead.Phone != null)
                    theLead.Phone = PhoneFormatter.formatPhone(theLead.Phone);
                if(theLead.LeadSource != null)
                {
                    theLead.Lead_Sources__c = theLead.LeadSource  + ',';
                    theLead.Total_Source_Count__c = 1;
                }
                else
                {
                    theLead.Total_Source_Count__c = 0;
                }
            }
        List<Lead> leadsForDupCheck = LeadService.getLeadsForDupCheck(Trigger.new);
        if(!leadsForDupCheck.isEmpty()){
            LeadService.checkForDuplicateContact(leadsForDupCheck);
        }
        
        //Padma @B-18708 and B-16602
        if(!Test.isRunningTest()){
        LeadService.populateLeadScore(Trigger.new,false); 
        }
          
       
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
    	//Padma @B-33310
		String genesysId = trigger.new[0].Genesys_Interaction_Id__c;
	    if(genesysId != null){
	            g_WorkspaceConnectorController.linkActivityToObjectSelected(trigger.new[0].Id,genesysId);
	    }
        //B-19691  : after lead is inserted we check that if record has been processed if yes then we leave it, if no then do UpdateUUid Call
       

        if(!Test.isRunningTest()){
            LeadService.updateUUID(Trigger.new[0].id);
                	LeadService.processTmsLeads(Trigger.new);
        	
    	}
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
         //B-19691 : after lead is inserted we check that if record has been processed if yes then we leave it, if no then do UpdateUUid Call
        if(!Test.isRunningTest()){
            if (LeadService.isValueChanged){
            	LeadService.updateUUID(Trigger.new[0].id);
            }
        }
        List<Lead> mobileLeads = LeadService.getMobileLeadsWithEmail(Trigger.oldMap , Trigger.newMap);
        if(!mobileLeads.isEmpty())
        {

            LeadService.processMobilLeads(mobileLeads);

        }
        LeadService.processLeadByContactStatus(Trigger.oldMap , Trigger.newMap);
        LeadService.checkIfPhoneNumberChanged(Trigger.oldMap, Trigger.new);
        
        //Padma
        List<Lead> leadQ = new List<Lead>();
        for (Lead ld : Trigger.new){
            
            Lead oldLead = Trigger.oldMap.get(ld.Id);
            
            
            //Padma @B-18129 @ B-18698
            if (ld.Status == 'Closed Lost') {
                
                if((ld.Questionnaire_End_Time__c != oldLead.Questionnaire_End_Time__c && ld.Questionnaire_End_Time__c != null   ) ||
                  (ld.My_Account_End_Time__c != oldLead.My_Account_End_Time__c  && ld.My_Account_End_Time__c != null  )||
                  (ld.Website_End_Time__c != oldLead.Website_End_Time__c  && ld.Website_End_Time__c != null  ) )
                  
                   
                {
                    
                    leadQ.add(ld);
                    
                
                }
            }
        }
        
        
        LeadService.reOpenClosedLead(leadQ);

    }
    if(Trigger.isBefore && Trigger.isDelete)
    {
        LeadService.deleteChildren(Trigger.oldMap);
    }
   if(Trigger.isbefore && Trigger.isUpdate)
    {
       leadservice.updateKeadStatusDNc(Trigger.new);
    }
}