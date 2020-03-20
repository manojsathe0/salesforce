global class g_CustomCaseLookupController {
	public List<Case> case_results {get;set;} // search results
  
	public string searchString {get;set;} // search keyword, set either by invoking page or via URI
	public static string ixnId {get;set;} // interaction id 
	public string caseNumber {get;set;} //set by invoking page 
	public string subject {get;set;}    // set by invoking page
	public string createdDate {get;set;} 
	public string inServiceCloudConsole {get;set;} // set in constructor     
  
	public g_CustomCaseLookupController() {
		// get the current search string
		searchString = System.currentPageReference().getParameters().get('lksrch');
		ixnId = System.currentPageReference().getParameters().get('ixnId');
		inServiceCloudConsole = System.currentPageReference().getParameters().get('inServiceCloudConsole');
		system.debug('*** CustomCaseLookupController ixnId ' + ixnId);
		system.debug('*** CustomCaseLookupController search for ' + searchString);     
		  
		if (searchString != '' && searchString != null) {
			runSearch();
		}
	}
	
	
	// performs the keyword search
	global PageReference search() {
		system.debug('*** search');
		runSearch();
		return null;
	}
    
  
	// prepare the query and issue the search command
	private void runSearch() {
		system.debug('*** runSearch');
		performSearch(searchString);         
	} 
  
  
	// run the search and save the records found. 
	private void performSearch(string searchString) {
		system.debug('*** performSearch for ' + searchString);
		
		case_results = new List<Case>();
		Integer listSize = 0;
		system.debug('*** caseNumber = ' + caseNumber);
		system.debug('*** subject = ' + subject);
		system.debug('*** createdDate = ' + createdDate);

		if (searchString != null && searchString != '') {
			List<Case> case_result = [select Id, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate 
					from case where CaseNumber = :searchString];
			case_results.addAll(case_result);

		}
		try {
			if (Subject != null && Subject != '') {
				string term = '%' + Subject + '%'; 
				List<Case> case_results1 = [select Id, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate 
						from case where Subject like :term];
				system.debug('*** case_results1 size = ' + case_results1.size());
				system.debug('*** case_results1 = ' + case_results1);
				case_results.addAll(case_results1);
			}
		}
		catch (QueryException e) {
			system.debug('*** ERROR = ' + e); 
		}
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