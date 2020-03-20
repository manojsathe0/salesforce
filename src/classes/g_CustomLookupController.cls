global class g_CustomLookupController {
    public List<Contact> contact_results {get;set;} // search results
    public List<Lead> lead_results {get;set;} // search results
    
    //PJB: Additional results for custom search page
    public List<Order__c> order_results {get;set;} // search results
    public List<Order_Item__c> order_item_results {get;set;} // search results
    public List<Case> case_results {get;set;} //search results

    public string searchString {get;set;} // search keyword, set either by invoking page or via URI
    public string firstName {get;set;} // set by invoking page
    public string lastName {get;set;} // set by invoking page
    public string email {get;set;} // set by invoking page
    
    //PJB: Trying to add some custom fields for search page
    public string stateOfFormation{get;set;} // set by invoking page
    public string caseNumber{get;set;} // set by invoking page
    public string orderNumber{get;set;} // set by invoking page
    public string processingNumber{get;set;} // set by invoking page
    public string entityName{get;set;} // set by invoking page
    public string profile_override{get;set;} // if we want to override the user profile
    //PJB: For animated search icon
    public Boolean searchIsActive{get;set;} // are we searching right now
    //PJB: To display error message
    public string searchMessage{get;set;} // message to show user
    
    public string saveURL {get;set;}
    public string openCustomSearch {get;set;}
    
    //PJB: To contain the grouping of results for each
    public List<g_ContactContainer> contactGroupings{get;set;} 
    public Integer contact_count{get;set;}
    public Integer lead_count{get;set;} 
    public Integer initialLimit{get;set;}
	public Boolean exceededInitialMaxResults{get;set;}
	public Integer finalLimit{get;set;}
	public Boolean exceededFinalMaxResults{get;set;}
	public Boolean expandedSearch{get;set;}		

    public static string selectedObjId {get;set;} // obj id, set via refreshpage
    public static string ixnId {get;set;} // interaction id, set via URI
    public string inServiceCloudConsole {get;set;} // set in constructor
    
    public g_CustomLookupController() {
    	initialLimit=20;
    	finalLimit=200;
    	exceededInitialMaxResults = false;
    	exceededFinalMaxResults = false;
        searchIsActive = false;
        expandedSearch = false;
        searchMessage= '';
        saveURL = System.currentPageReference().getUrl();
        system.debug('*** CustomLookupController saveURL ' + saveURL);
        openCustomSearch = System.currentPageReference().getParameters().get('openCustomSearch');
        system.debug('*** CustomLookupController openCustomSearch ' + openCustomSearch);
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        firstName = System.currentPageReference().getParameters().get('lkfirst');
        lastName = System.currentPageReference().getParameters().get('lklast');
        email = System.currentPageReference().getParameters().get('lkemail');
        stateOfFormation = System.currentPageReference().getParameters().get('lkformation');
        caseNumber = System.currentPageReference().getParameters().get('lkcase');
        orderNumber = System.currentPageReference().getParameters().get('lkorder');
        processingNumber = System.currentPageReference().getParameters().get('lkprocessing');
        entityName = System.currentPageReference().getParameters().get('lkentity');
        profile_override = System.currentPageReference().getParameters().get('lkprofile');      
        
        ixnId = System.currentPageReference().getParameters().get('ixnId');
        inServiceCloudConsole = System.currentPageReference().getParameters().get('inServiceCloudConsole');
        system.debug('*** CustomLookupController ixnId ' + ixnId);
        system.debug('*** CustomLookupController inServiceCloudConsole '+inServiceCloudConsole);
        system.debug('*** CustomLookupController search for '+searchString);      
        
        contactGroupings = new List<g_ContactContainer>();
        contact_count=0;
        lead_results = new List<Lead>();        
        lead_count=0;   
        
        if ((searchString != '' && searchString != null) ||
            (firstName != '' && firstName != null) ||
            (lastName != '' && lastName != null) ||
            (email != '' && email != null) ||
            (stateOfFormation != '' && stateOfFormation != null) ||
            (caseNumber != '' && caseNumber != null) ||
            (orderNumber != '' && orderNumber != null) ||
            (processingNumber != '' && processingNumber != null) ||
            (entityName != '' && entityName != null)
            ) {
            runSearch();  
        }
    }

	//to force a rerender
	global PageReference resultDraw()
	{
		system.debug('*** Result Draw');

		return null;
	}

	//to force a rerender
	global PageReference finalRefresh()
	{
		system.debug('*** Final Refresh');
        searchIsActive = false;        
		
		return null;
	}
	
	//to start the icon drawing
	global PageReference startSearching()
	{
		system.debug('*** Start Searching');
        contact_count=0;
        lead_count=0;   

		contactGroupings.clear();
		lead_results.clear();
		
		searchIsActive = true;		
		return null;
	}
	
    // performs the expanded keyword search
    global PageReference searchMore() {
    	expandedSearch=true;

        system.debug('*** Search More');
        runSearch();
        
        return null;
    }

    // performs the keyword search
    global PageReference search() {
    	expandedSearch=false;

        system.debug('*** Search');
        runSearch();
        
        return null;
    }
  
    // prepare the query and issue the search command
    private void runSearch() {
        system.debug('*** runSearch');
        performSearch(searchString);
    } 
  
  	// update the id from the search page
  	@RemoteAction  	
    global static void updateObjectById()
    {
/*        
		system.debug('[WSC] updateObjectById using  ' + selectedObjId + ' ixnId ' + ixnId);     	
    	g_WorkspaceConnectorController.updateObjectById(selectedObjId, ixnId);
*/    	
        system.debug('*** updateObjectById using  ' + selectedObjId + ' ixnId ' + ixnId); 
        
        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix(); 
		if(selectedObjId!=null && selectedObjId.indexOf(contactPrefix)==0){
            List<Contact> cobjects = [select name, Genesys_Interaction_Id__c from contact where Id = :selectedObjId];
            if(cobjects.size()==1)
            {
	            //update Contact with genesysID
	            Contact myContact = cobjects[0];
	            myContact.Genesys_Interaction_Id__c = ixnId;
	            try{
	            	update myContact;
	            } catch(DmlException e) {
	    			System.debug('updateObjectById - update Contact' + e.getMessage());
				}                
            }else{System.debug('updateObjectById - Contact not found!');}			
		}else if(selectedObjId!=null && selectedObjId.indexOf(leadPrefix)==0){
            List<Lead> lobjects = [select name, Genesys_Interaction_Id__c from lead where Id = :selectedObjId];
            if(lobjects.size()==1)
            {
	            //update Contact with genesysID
	            Lead myLead = lobjects[0];
	            myLead.Genesys_Interaction_Id__c = ixnId;
	            try{
	            	update myLead;
	            } catch(DmlException e) {
	    			System.debug('updateObjectById - update Lead' + e.getMessage());
				}                
            }else{System.debug('updateObjectById - Lead not found!');}					
		}
              
    	return;    	
    }
  
    // run the search and save the records found. 
    private void performSearch(string searchString) {
        system.debug('*** searchString = ' + searchString);
        system.debug('*** firstName = ' + firstName);
        system.debug('*** lastName = ' + lastName);
        system.debug('*** email = ' + email);
        system.debug('*** stateOfFormation = ' + stateOfFormation);
        system.debug('*** caseNumber = ' + caseNumber);
        system.debug('*** orderNumber = ' + orderNumber);
        system.debug('*** processingNumber = ' + processingNumber);
        system.debug('*** entityName = ' + entityName);
        system.debug('*** profile_override = ' + profile_override);

		searchString = searchString.trim();
		if(firstName!= null)
			firstName = firstName.trim();
		if(lastName!= null)
			lastName = lastName.trim();
		if(email!= null)
			email = email.trim();
		if(stateOfFormation!= null)
			stateOfFormation = stateOfFormation.trim();
		if(caseNumber!= null)
			caseNumber = caseNumber.trim();
		if(orderNumber!= null)
			orderNumber = orderNumber.trim();
		if(processingNumber!= null)
			processingNumber = processingNumber.trim();
		if(entityName!= null)
			entityName = entityName.trim();

		Integer listLimit = (expandedSearch==true)? finalLimit+1 : initialLimit+1; //we add one so that we can tell if it goes over the limit
		
		
		order_item_results= new List<Order_Item__c>();
		order_results= new List<Order__c>();
		case_results= new List<Case>();
	    contact_results = new List<Contact>();
		contactGroupings.clear();
		lead_results.clear();
        contact_count=0;
        lead_count=0;   
        searchMessage = '';
        
        

		Boolean caseSearch = false;
		Boolean itemSearch = false;
		Boolean orderSearch = false;
		Boolean contactSearch = false;
		Boolean leadSearch = false;
		
        List<List<SObject>> objs = null;
        Integer listSize = 0;
        
        String user_profile_name='';
        
        if(profile_override!=null && profile_override!=''){
            user_profile_name=profile_override;
        }
        else{
            try{
                List<Profile> active_profile_list = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                user_profile_name = active_profile_list[0].Name;
                system.debug('*** profile name = ' + user_profile_name);
            }catch(QueryException e){
                system.debug('*** ERROR = ' + e); 
            }
        }
                
		String findString = '';
		String orderWhereItemString = '';
		String orderWhereString = '';
		String caseWhereString = '';
		String leadWhereString = '';
		String contactWhereString = '';
		
		String searchTermTooShort = 'Your search term must have 2 or more characters to be included.  ';
		String tooManyResults = 'Exceeded result limit, please refine your search.  ';
		
		if((searchString != null && searchString != ''))
		{
			if(searchString.length()>1)
			{
				String regExp = '[() -]';
				String formattingRemoved = searchString.replaceAll(regExp,'');
				findString += ((findString.length()>0) ? ' OR ' : '') + formattingRemoved;			
				String formattedPhone = searchString;
				if(searchString.length()==9)
					formattedPhone = searchString;
				else if(searchString.length()==10)
					formattedPhone = '(' + searchString.substring(0,3) + ') ' + searchString.substring(3,6) + '-' + searchString.substring(6,10);
				else if(searchString.length()==11)
				{
					if(searchString.substring(0,1)=='1')
						formattedPhone = '(' + searchString.substring(1,4) + ') ' + searchString.substring(4,7) + '-' + searchString.substring(7,11);
					else
						formattedPhone = searchString;
				}
				leadWhereString +=  ((leadWhereString.length()>0) ? ' AND ' : '') + ' Phone=\'' +formattedPhone + '\'';
				contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' (Phone=\'' + formattedPhone + '\' OR HomePhone=\'' + formattedPhone + '\' OR MobilePhone=\'' + formattedPhone + '\' OR OtherPhone=\'' + formattedPhone + '\' OR Fax=\'' + formattedPhone + '\')';
				
				contactSearch=true;
				leadSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}
		}
		if(firstName!=null && firstName!='')
		{
			if(firstName.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + firstName;
				orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Contact__r.FirstName=\'' + firstName + '\'';
				orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Contact__r.FirstName=\'' + firstName + '\'';
				caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' Contact.FirstName=\'' + firstName + '\'';
				leadWhereString += ((leadWhereString.length()>0) ? ' AND ' : '') + ' FirstName=\'' + firstName + '\'';
				contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' FirstName=\'' + firstName + '\'';			
				
				contactSearch=true;
				leadSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}
		}
		if(lastName!=null && lastName!='')
		{
			if(lastName.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + lastName;
				orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Contact__r.LastName=\'' + lastName + '\'';
				orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Contact__r.LastName=\'' + lastName + '\'';
				caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' Contact.LastName=\'' + lastName + '\'';
				leadWhereString += ((leadWhereString.length()>0) ? ' AND ' : '') + ' LastName=\'' + lastName + '\'';
				contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' LastName=\'' + lastName + '\'';			
				
				contactSearch=true;
				leadSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}
		}
		if(email!=null && email!='')
		{
			if(email.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + email;
				orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Contact__r.Email=\'' + email + '\'';
				orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Contact__r.Email=\'' + email + '\'';
				caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' Contact.Email=\'' + email + '\'';
				leadWhereString += ((leadWhereString.length()>0) ? ' AND ' : '') + ' Email=\'' + email + '\'';
				contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' Email=\'' + email + '\'';			
						
				contactSearch=true;
				leadSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}
		}
		if (stateOfFormation != null && stateOfFormation != '' && entityName != null && entityName != '')
		{
			if(stateOfFormation.length()>1 && entityName.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + stateOfFormation;
				orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' State_of_Formation__c=\'' + stateOfFormation + '\'';			
	
				findString += ((findString.length()>0) ? ' OR ' : '') + entityName;
				orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Entity_Name__c=\'' + entityName + '\'';
				
				orderSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}
		}
		if (caseNumber != null && caseNumber != '')
		{
			if(caseNumber.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + caseNumber;
				//caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' CaseNumber like \'%' + caseNumber + '\'';
				caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' CaseNumber=\'' + caseNumber + '\'';
				
				caseSearch=true;
			}	
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}					
		}
		if (orderNumber != null && orderNumber != '')
		{
			if(orderNumber.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + orderNumber;
				orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Name=\'' + orderNumber + '\'';
				orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Name=\'' + orderNumber + '\'';
				
				orderSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}			
		}      
		if (processingNumber != null && processingNumber != '')
		{
			if(processingNumber.length()>1)
			{
				findString += ((findString.length()>0) ? ' OR ' : '') + processingNumber;
				orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' User_Order_ID__c=\'' + processingNumber + '\'';
				
				itemSearch=true;
			}
			else
			{
		        searchMessage += searchMessage.indexOf(searchTermTooShort)<0 ? searchTermTooShort : '';				
			}			
		}
		if(findString.length()>0)
		{
	        try{	
	        	Integer itemIndex=-1;
	        	Integer orderIndex=-1;
	        	Integer caseIndex=-1;
	        	Integer contactIndex=-1;
	        	Integer leadIndex=-1;
	        	Integer currentIndex=0;
				String soslString = 'FIND { ' + findString + '} in ALL FIELDS returning ';
				
				if(itemSearch)
				{
					itemIndex=currentIndex;					
					soslString += (currentIndex>0 ? ', ' : '') +' Order_Item__c(Id, Name,  Order__c, User_Order_ID__c, Product_Name__c, Relationship_Type__c, Order_Item_Date_Time_Created__c where ' + orderWhereItemString + ' LIMIT ' + listLimit + ')';
					currentIndex++;					
				}
				if(orderSearch)
				{
					orderIndex=currentIndex;					
					soslString += (currentIndex>0 ? ', ' : '') +' Order__c(Id, Name, Base_Product_Name__c, Order_Payment_Status__c, Customer_Login__c, Contact__c, User_Order_ID__c, Processing_Status__c, Order_Date_Time_Created__c  where ' + orderWhereString + ' LIMIT ' + listLimit + ')';
					currentIndex++;					
				}
				if(caseSearch)
				{
					caseIndex=currentIndex;					
					soslString += (currentIndex>0 ? ', ' : '') +' Case(Id, CaseNumber, Subject, Status, CreatedDate, Owner.Alias, Queue__c, Assigned_User__c, Contact.Id  where ' + caseWhereString + ' LIMIT ' + listLimit + ')';
					currentIndex++;					
				}
				if(contactSearch)
				{
					contactIndex=currentIndex;					
					soslString += (currentIndex>0 ? ', ' : '') +' Contact(Account.Name, Id, Name, FirstName, LastName, MailingStreet, EMail, Contact_Type__c, Customer_Login_Email__c, LastActivityDate, Owner.Alias, Phone, MobilePhone, HomePhone, AssistantPhone, OtherPhone where ' + contactWhereString + ' LIMIT ' + listLimit + ')';
					currentIndex++;					
				}
				if(leadSearch && user_profile_name.indexOf('Sales')==0)
				{
					leadIndex=currentIndex;					
					soslString += (currentIndex>0 ? ', ' : '') +' Lead(Id, ConvertedAccountId, LastActivityDate, Status, Contact_Status_TEXT__c, Owner.Alias, Name, Street, FirstName, LastName, Email, Phone where ' + leadWhereString + ' LIMIT ' + listLimit + ')';
					currentIndex++;					
				}
				system.debug('*** SOSL String = ' + soslString);
			
				objs = search.query(soslString);
	            listSize = objs.size();		            
	            system.debug('*** SOSL listSize = ' + listSize);
	            if (!objs.isEmpty()) {
	            	if(itemIndex>-1 && objs[itemIndex]!=null)
	            	{
	            		order_item_results.addAll((List<Order_Item__c>) objs[itemIndex]);
	            		system.debug('*** Order Item listSize = ' + order_item_results.size());
	            	}
	        		if(orderIndex>-1 && objs[orderIndex]!=null)
	        		{
	            		order_results.addAll((List<Order__c>) objs[orderIndex]);
	            		system.debug('*** Order listSize = ' + order_results.size());
	        		}
	        		if(caseIndex>-1 && objs[caseIndex]!=null)
	        		{            		
	            		case_results.addAll((List<Case>) objs[caseIndex]);
	            		system.debug('*** Case listSize = ' + case_results.size());
	        		}
	        		if(contactIndex>-1 && objs[contactIndex]!=null)
	        		{
			            contact_results.addAll((List<Contact>) objs[contactIndex]);
			            system.debug('*** Contact listSize = ' + contact_results.size());
	        		}
		            if(leadIndex>-1 && objs[leadIndex]!=null)
		            {
		            	lead_results.addAll((List<Lead>) objs[leadIndex]);
		            	lead_count=lead_results.size();
		            	system.debug('*** Lead listSize = ' + lead_count);
		            }
		            else
		            {
		            	lead_count=0;
		            	system.debug('*** Lead listSize = ' + 0);
		            }
	                system.debug('*** SOSL Results = ' + objs);
	            }
	        }catch (QueryException e) {
            	system.debug('*** ERROR = ' + e); 
        	}
		}      	
        
        //now that we have the results based on search criteria we try to group them
        contactGroupings = new List<g_ContactContainer>();
        //move all the contacts to the list before we start checking for matches
        system.debug('*** Building a grouping of Contacts');
        for(Integer idxContact=0; idxContact<contact_results.size(); idxContact++)
        {
            contactGroupings.add(new g_ContactContainer(contact_results[idxContact]));
        }
        
        system.debug('*** Finding Contacts for Orders');
        for(Integer idxOrder=0; idxOrder<order_results.size(); idxOrder++)  
        {
            Boolean contactFound = false;
            for(Integer idxContact=0; idxContact<contactGroupings.size(); idxContact++)
            {
                if(order_results[idxOrder].Contact__c==contactGroupings[idxContact].contact.Id)
                {
                    contactGroupings[idxContact].order_results.add(order_results[idxOrder]);
                    contactFound=true;  
                }               
            }
            if(contactFound==false)
            {
                Contact contactForList=findContactById(order_results[idxOrder].Contact__c, contactWhereString);
                if(contactForList!=null)
                {
                    g_ContactContainer newContainer = new g_ContactContainer(contactForList);
                    newContainer.order_results.add(order_results[idxOrder]);
                    contactGroupings.add(newContainer);
                }
            }
        }

		system.debug('*** Finding Contacts for OrderItems');
        for(Integer idxOrderItem=0; idxOrderItem<order_item_results.size(); idxOrderItem++) 
        {
            Boolean contactFound = false;

            //the contact ID isn't on the order Item, so we need to get it from the order table
            string term = order_item_results[idxOrderItem].Order__c; 
            List<Order__c> order_results_forID = [select  Id, Contact__c                     
                    from Order__c where Id = :term];
            if(order_results_forID.size()>0)
            {
                string order_item_contact_Id = order_results_forID[0].Contact__c;                           
                for(Integer idxContact=0; idxContact<contactGroupings.size(); idxContact++)
                {
                    if(order_item_contact_Id==contactGroupings[idxContact].contact.Id)
                    {
                        contactGroupings[idxContact].order_item_results.add(order_item_results[idxOrderItem]);
                        contactFound=true;  
                    }               
                }
                if(contactFound==false)
                {
                    Contact contactForList=findContactById(order_item_contact_Id, contactWhereString);
                    if(contactForList!=null)
                    {
                        g_ContactContainer newContainer = new g_ContactContainer(contactForList);
                        newContainer.order_item_results.add(order_item_results[idxOrderItem]);
                        contactGroupings.add(newContainer);
                    }
                }           
            }
        }

		system.debug('*** Finding Contacts for Cases');
        for(Integer idxCase=0; idxCase<case_results.size(); idxCase++)  
        {
            Boolean contactFound = false;
            for(Integer idxContact=0; idxContact<contactGroupings.size(); idxContact++)
            {
                if(case_results[idxCase].Contact.Id==contactGroupings[idxContact].contact.Id)
                {
                    contactGroupings[idxContact].case_results.add(case_results[idxCase]);
                    contactFound=true;  
                }               
            }
            if(contactFound==false)
            {
                Contact contactForList=findContactById(case_results[idxCase].Contact.Id, contactWhereString);
                if(contactForList!=null)
                {
                    g_ContactContainer newContainer = new g_ContactContainer(contactForList);
                    newContainer.case_results.add(case_results[idxCase]);
                    contactGroupings.add(newContainer);
                }
            }           
        }
        
        List<g_ContactContainer> temporary_contactGroupings = new List<g_ContactContainer>();
        system.debug('*** Removing contacts that do not match constraints'); 
        for(Integer idxContact=0; idxContact<contactGroupings.size(); idxContact++)
        {
            contactGroupings[idxContact].updateCounts();
			if( (itemSearch==false || contactGroupings[idxContact].order_item_count>0) &&  
				(orderSearch==false || contactGroupings[idxContact].order_count>0) &&
				(caseSearch==false || contactGroupings[idxContact].case_count>0) )
			{
				temporary_contactGroupings.add(contactGroupings[idxContact]);
			}
			else
			{
				system.debug('*** Does not match constraint:' + contactGroupings[idxContact].contact.id); 
			}				
        }
        contactGroupings = temporary_contactGroupings;
        contact_count=contactGroupings.size();
        
        exceededInitialMaxResults=false;        
		exceededFinalMaxResults=false;
		
		if(expandedSearch==false)
  		{  
	        if(contact_count>initialLimit)
	        {
	        	while(contactGroupings.size()>initialLimit)    
	        		contactGroupings.remove(contactGroupings.size()-1);    	
	        	contact_count=initialLimit;
	        	exceededInitialMaxResults=true;
	        }
	       	if(lead_count>initialLimit)
	        {
	        	while(lead_results.size()>initialLimit)    
	        		lead_results.remove(lead_results.size()-1);   	
	        	lead_count=initialLimit;
	        	exceededInitialMaxResults=true;
	        }
  		}
  		else
  		{
	        if(contact_count>finalLimit)
	        {        	
	        	while(contactGroupings.size()>finalLimit)    
	        		contactGroupings.remove(contactGroupings.size()-1);    	
	        	contact_count=finalLimit;
	        	exceededFinalMaxResults=true;
	        	searchMessage += searchMessage.indexOf(tooManyResults)<0 ? tooManyResults : '';
	        }
	       	if(lead_count>finalLimit)
	        {
	        	while(lead_results.size()>finalLimit)    
	        		lead_results.remove(lead_results.size()-1);   	
	        	lead_count=finalLimit;
	        	exceededFinalMaxResults=true;
	        	searchMessage += searchMessage.indexOf(tooManyResults)<0 ? tooManyResults : '';
	        }
  		}
  		if(expandedSearch)
  			system.debug('*** expanded search complete');
		else
  			system.debug('*** regular search complete');
  		
    }
  
    public Contact findContactById(string contactId, String whereClause)
    {
    	String contactQuery = 'select Account.Name, Id, Name, FirstName, LastName, MailingStreet, EMail, Contact_Type__c, Customer_Login_Email__c, LastActivityDate, Owner.Alias, Phone, MobilePhone, HomePhone, AssistantPhone, OtherPhone from contact where Id = \'' + contactId + '\'';
    	if(whereClause!=null && whereClause!='')
    		contactQuery += ' AND ' + whereClause;
    	system.debug('*** findContactById Query = ' + contactQuery);
    	List<Contact> new_contact_results = Database.query(contactQuery);
                
        if(new_contact_results.size()>0)
            return new_contact_results[0];
        else
            return null;                
    }
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
  
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}