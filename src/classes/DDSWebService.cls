/*
This Web Service application was created to be the API for case creation.
Once the API is hit with a valid request, this will result in a creation of a Case in Salesforce
Created by: Artyom M.
Per story: B-24116
*/

@RestResource(urlMapping='/DDSWebService/*')
global class DDSWebService {
	private static String messageToReturn;
	private static Order__c matchingOrder;
    
    @HttpPost
    global static String createCase() {
    	messageToReturn = 'blank';
    	RestRequest req = RestContext.request;
		RestResponse res = Restcontext.response;
        String requestBody = req.requestBody.toString();
        /**/
        
        DDSContractBeans.CaseBean caseBody;
        if (UtilityLibrary.isNotNullOrBlank(requestBody)) {
        	try {
        		caseBody = (DDSContractBeans.CaseBean) JSON.deserialize(requestBody, DDSContractBeans.CaseBean.class);
        	}
        	catch (JSONException e) {
        		messageToReturn = e.getMessage();
        		System.debug(messageToReturn);
        		return messageToReturn;
        	}
        	
        }
        else {
        	messageToReturn = 'Empty requests are not accepted.';
        	return messageToReturn;
        }
        
        
        // 
        String orderToSearchStr;
        List<Order__c> matchingOrders = new List<Order__c>();
        if (UtilityLibrary.isNotNullOrBlank(caseBody.orderNumber)) {
        	orderToSearchStr = caseBody.orderNumber;
        	try {
        		matchingOrders = [SELECT Id, Contact__c FROM Order__c WHERE Name = :orderToSearchStr];
        	}
        	catch (QueryException e) {
        		messageToReturn = e.getMessage();
        		System.debug(messageToReturn);
        		return messageToReturn;
        	}
        	
        	if (!matchingOrders.isEmpty()) {
        		matchingOrder = matchingOrders[0];
        		Case theCase = new Case();

				populateCaseBody(theCase, caseBody);
        		try {
        			insert theCase;
        		}
        		catch (DMLException e) {
        			messageToReturn = e.getMessage();
        			System.debug(messageToReturn);
        			return messageToReturn;
        		}
        		messageToReturn = theCase.Id;
        		
        		
        		
        	}
        	else {
        		messageToReturn = 'No Order found: ' + orderToSearchStr;
        		System.debug(messageToReturn);
        		return messageToReturn;
        	}
        }
        else {
        	messageToReturn = 'Order Number is a required parametr in the request.';
        	System.debug(messageToReturn);
        	return messageToReturn;
        }
    	
    	
    	return messageToReturn;
    }
    private static void populateCaseBody(Case theCase, DDSContractBeans.CaseBean caseBody) {
    	theCase.CaseId__c = UtilityLibrary.ifNotBlankThenCopy(caseBody.caseId);
    	theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
    	
    	String firstName = UtilityLibrary.ifNotBlankThenCopy(caseBody.firstName);
    	String lastName = UtilityLibrary.ifNotBlankThenCopy(caseBody.lastName);
    	theCase.SuppliedName = firstName + ' ' + lastName;
    	
    	theCase.UUID__c = UtilityLibrary.ifNotBlankThenCopy(caseBody.uuid);

    	theCase.SuppliedEmail = UtilityLibrary.ifNotBlankThenCopy(caseBody.email);
    	

    	theCase.CustomerID__c = UtilityLibrary.ifNotBlankThenCopy(caseBody.customerId);
    	
    	if (UtilityLibrary.isNotNullOrBlank(caseBody.phone)) {
    		theCase.SuppliedPhone = PhoneFormatter.formatPhone(caseBody.phone);
    	}
    	
    	if (UtilityLibrary.isNotNullOrBlank(caseBody.orderNumber)) {
    		theCase.ContactId = matchingOrder.Contact__c;
    		theCase.Order__c = matchingOrder.Id;
    		theCase.Order_Number__c = caseBody.orderNumber;
    	}
    	
    	theCase.Processing_Number__c = UtilityLibrary.ifNotBlankThenCopy(caseBody.processingNumber);
    	if (UtilityLibrary.isNotNullOrBlank(caseBody.customerLogin)) {
    		List<Customer_Login__c> custLogin = new List<Customer_Login__c>();
    		
			custLogin = [SELECT Id, Name FROM Customer_Login__c WHERE Name = :caseBody.customerLogin];
			if (!custLogin.isEmpty()) {
				theCase.Customer_Login__c = custLogin[0].Id;
			}   		 
    		
    	}
    	
    	if (caseBody.validatedRules != null) {
    		if (!caseBody.validatedRules.isEmpty()) {
    			theCase.Validated_Rules__c = '';
		    	for (DDSContractBeans.ValidatedRules thisRule : caseBody.validatedRules) {
		    		theCase.Validated_Rules__c += thisRule.description + ';\n';
		    	}
    		}	
    	}
    	

    }
}