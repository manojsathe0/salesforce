public with sharing class USPTOHandler
{
	
	public final static String SENT_TO_CUSTOMER = 'Sent to Customer';
	public final static String OPEN = 'Open';
	public final static String SIG_RECEIVED = 'Sig Received';
	public final static String USPTO_PAID = 'USPTO Paid';
	public static Boolean hasUSPTOTriggerRun = false;

	private Map<Id,Case> finalCasesToUpdate;
	private Map<Id,Case> finalCasesToDelete;
	private Map<String,Case> casesToUpdate;
	private Map<String,Case> secondEmailcasesToDelete;
	private Map<String,Case> thirdEmailcasesToDelete;

	private Map<String,EmailMessage> usptoIdToEmailMessage;
	private Map<String,USPTOEmailWrapper> userOrderNumberToFirstUSPTOEmailWrappers;
	private Map<String,USPTOEmailWrapper> secondUSPTOEmailWrappers;
	private Map<String,USPTOEmailWrapper> thirdUSPTOEmailWrappers;
	private Set<String> usptoUniqueId;
	private Set<String> userOrderNumbers;
	private List<EmailMessage> emailMessagesToCreate;
	private Map<String,Case> usptoIdToCase;
	private Map<String,Case> trademarkNameToCase;
	private Map<String,Order__c> userOrderNumberToOrder;
	private Map<String,Id> userOrderNumberToContactId;
	
	private Map<String,EmailMessage> trademarkNameToEmailMessage;
	private Set<String> trademarkNames; 

	private USPTOHandlerHelper theUSPTOHelper;
	private USPTOEmailParser theUSPTOEmailParser;

	public USPTOHandler()
	{
		finalCasesToUpdate = new Map<Id,Case>();
		finalCasesToDelete = new Map<Id,Case>();
		casesToUpdate = new Map<String,Case>();
		secondEmailcasesToDelete = new Map<String,Case>();
		thirdEmailcasesToDelete = new Map<String,Case>();
		usptoIdToEmailMessage = new Map<String,EmailMessage>();
		userOrderNumberToFirstUSPTOEmailWrappers = new Map<String,USPTOEMailWrapper>();
		secondUSPTOEmailWrappers = new Map<String,USPTOEMailWrapper>();
		thirdUSPTOEmailWrappers = new Map<String,USPTOEMailWrapper>();
		usptoUniqueId = new Set<String>();
		userOrderNumbers = new Set<String>();
		emailMessagesToCreate = new List<EmailMessage>();
		usptoIdToCase = new Map<String,Case>();
		trademarkNameToCase = new Map<String,Case>();
		userOrderNumberToOrder = new Map<String,Order__c>();
		userOrderNumberToContactId = new Map<String,Id>();
	

		trademarkNameToEmailMessage = new Map<String,EmailMessage>();
		trademarkNames = new Set<String>();

		theUSPTOHelper = new USPTOHandlerHelper();
		theUSPTOEmailParser = new USPTOEmailParser();
	
	}

	public void processEmails(Map<Id,EmailMessage> emailMessages)
	{
		try
		{
			List<EmailMessage> USPTOEmailMessages = theUSPTOHelper.getUSPTOEmailMessages(emailMessages); 
			System.debug('Valid USPTO EmailMessages:  '+USPTOEmailMessages);
			List<USPTOEmailWrapper> USPTOEmailWrappers  = theUSPTOEmailParser.getUSPTOEmailWrappers(USPTOEmailMessages);
			System.debug('USPTO Email Wrappers '+USPTOEmailWrappers);
			processUSPTOEmails(USPTOEmailWrappers);
			
			prepareObjectsForDML();
			
			System.debug('USPTO Id To Case '+usptoIdToCase);
			System.debug('Final Cases to Update '+finalCasesToUpdate);

			performDML();
		}
		catch(Exception theException)
		{
			System.debug('EXCEPTION ERROR '+theException.getMessage());
			System.debug('EXCPETION ERROR '+theException.getStackTraceString());
		}
	}



	public void processUSPTOEmails(List<USPTOEmailWrapper> USPTOEmailWrappers)
	{
		for(USPTOEmailWrapper theUSPTOEmailWrapper : USPTOEmailWrappers)
		{
			usptoIdToEmailMessage.put(theUSPTOEmailWrapper.USPTOUniqueId , theUSPTOEmailWrapper.emailMessage);
			if(theUSPTOEmailWrapper.emailType == USPTOEmailParser.FIRST && theUSPTOEmailWrapper.userOrderNumber != null)
			{
				
				Case theCase = new Case(Id = theUSPTOEmailWrapper.caseId);
				theCase.Processing_Number__c = theUSPTOEmailWrapper.userOrderNumber;
				theCase.App_Stage__c = SENT_TO_CUSTOMER;
				theCase.Status = OPEN;
				theCase.USPTO_Id__c = theUSPTOEmailWrapper.USPTOUniqueId;
				theCase.Is_Updated_By_USPTO__c = true;
				theCase.Trademark_Name__c = theUSPTOEmailWrapper.trademarkName;
				casesToUpdate.put(theUSPTOEmailWrapper.userOrderNumber ,theCase);
				userOrderNumbers.add(theUSPTOEmailWrapper.userOrderNumber);
				userOrderNumberToFirstUSPTOEmailWrappers.put(theUSPTOEmailWrapper.userOrderNumber , theUSPTOEmailWrapper);
			}
			else if(theUSPTOEmailWrapper.emailType == USPTOEmailParser.SECOND)
			{
		
				if(theUSPTOEmailWrapper.USPTOUniqueId != null)
				{
					usptoUniqueId.add(theUSPTOEmailWrapper.USPTOUniqueId);
					Case newCase = new Case(Id = theUSPTOEmailWrapper.caseId);
					secondEmailcasesToDelete.put(theUSPTOEmailWrapper.USPTOUniqueId,newCase);
					usptoIdToEmailMessage.put(theUSPTOEmailWrapper.USPTOUniqueId , theUSPTOEmailWrapper.emailMessage);
					secondUSPTOEmailWrappers.put(theUSPTOEmailWrapper.USPTOUniqueId , theUSPTOEmailWrapper);

				}
				
			}
			else if(theUSPTOEmailWrapper.emailType == USPTOEmailParser.THIRD && theUSPTOEmailWrapper.serialNumber != null)
			{
				if(theUSPTOEmailWrapper.trademarkName != null)
				{
					trademarkNames.add(theUSPTOEmailWrapper.trademarkName);
					Case newCase = new Case(Id = theUSPTOEmailWrapper.caseId);
					thirdEmailcasesToDelete.put(theUSPTOEmailWrapper.trademarkName , newCase);
					trademarkNameToEmailMessage.put(theUSPTOEmailWrapper.trademarkName , theUSPTOEmailWrapper.emailMessage);
					thirdUSPTOEmailWrappers.put(theUSPTOEmailWrapper.trademarkName , theUSPTOEmailWrapper);

				}
				
			}
		}

		
	}


	public void prepareObjectsForDML()
	{
		System.debug('Second Email Cases to Delete '+secondEmailcasesToDelete);
		System.debug('USPTO Unique Ids '+usptoUniqueId);
		if(!secondEmailcasesToDelete.isEmpty())
		{
			usptoIdToCase = theUSPTOHelper.getExistingUSPTOUniqueIdToCase(usptoUniqueId);
		}
		if(!thirdEmailcasesToDelete.isEmpty())
		{
			trademarkNameToCase = theUSPTOHelper.getExistingTrademarkNameToCase(trademarkNames);
		}
				
		populateCasesToDeleteAndUpdate();

		if(!userOrderNumbers.isEmpty())
		{
			userOrderNumberToContactId = theUSPTOHelper.getUserOrderNumberToContact(userOrderNumbers, userOrderNumberToOrder);
		}

		System.debug('Cases to Update :'+casesToUpdate);
		
		if(!casesToUpdate.isEmpty())
		{
			populateContactOnCases();
			Map<String,Boolean> userOrderNumberToDeliveryStatus = theUSPTOHelper.sendEmailToCustomer(userOrderNumberToOrder, userOrderNumberToFirstUSPTOEmailWrappers);
			System.debug('Delivery Map '+userOrderNumberToDeliveryStatus);
			for(String userOrderNumber : casesToUpdate.keySet())
			{
						
				if(userOrderNumberToDeliveryStatus.containsKey(userOrderNumber))
				{
					finalCasesToUpdate.put(casesToUpdate.get(userOrderNumber).Id , casesToUpdate.get(userOrderNumber));
				}
			}

		}
		
		System.debug('Final Cases to Delete '+finalCasesToDelete);
		System.debug('Final Cases to Update '+finalCasesToUpdate);
		System.debug('Email Messages to Create '+ emailMessagesToCreate);
	}


	public void populateContactOnCases()
	{
		System.debug('User Order Number ContactId '+userOrderNumberToContactId);
		for(String userOrderNumber : casesToUpdate.keySet())
		{
			if(userOrderNumberToContactId.containsKey(userOrderNumber))
			{
				Id contactId = userOrderNumberToContactId.get(userOrderNumber);
				Case theCase = casesToUpdate.get(userOrderNumber);
				theCase.ContactId = contactId;
				
			}
			
			
		}
	}


	public void  populateCasesToDeleteAndUpdate()
	{

		System.debug('USPTO Id To EmailMessage '+usptoIdToEmailMessage);
		System.debug('USPTO Id To Case '+usptoIdToCase);

		if(!usptoIdToCase.isEmpty())
		{
			for(String usptoId : usptoIdToEmailMessage.keySet())
			{
				if(usptoIdToCase.containsKey(usptoId))
				{
					Case oldCase = usptoIdToCase.get(usptoId);
					
					if(secondUSPTOEmailWrappers.containsKey(usptoId))
					{
						oldCase.App_Stage__c = SIG_RECEIVED;
						oldCase.Is_Updated_By_USPTO__c = true;
						finalCasesToUpdate.put(oldCase.Id , oldCase);
						finalCasesToDelete.put(secondEmailcasesToDelete.get(usptoId).Id , secondEmailcasesToDelete.get(usptoId));
						EmailMessage theMessage = getClonedEmailMessageObject(usptoIdToEmailMessage.get(usptoId));
						System.debug('Old Case Id :'+oldCase.Id);
						theMessage.parentId = oldCase.Id;
						emailMessagesToCreate.add(theMessage);
					}
							
					
					
				}
			}

		}

		System.debug('Trademark name To EmailMessage '+trademarkNameToEmailMessage);
		System.debug('Trademark name  To Case '+trademarkNameToCase);

		if(!trademarkNameToCase.isEmpty())
		{
			for(String trademarkName : trademarkNameToEmailMessage.keySet())
			{
				
				if(trademarkNameToCase.containsKey(trademarkName))
				{
					Case oldCase = trademarkNameToCase.get(trademarkName);
					
					if(thirdUSPTOEmailWrappers.containsKey(trademarkName))
					{
						oldCase.USPTO_Serial_Number__c = thirdUSPTOEmailWrappers.get(trademarkName).serialNumber;
						oldCase.App_Stage__c = USPTO_PAID;
						oldCase.Is_Updated_By_USPTO__c = true;
						finalCasesToUpdate.put(oldCase.Id , oldCase);
						finalCasesToDelete.put(thirdEmailcasesToDelete.get(trademarkName).Id , thirdEmailcasesToDelete.get(trademarkName));
						EmailMessage theMessage = getClonedEmailMessageObject(trademarkNameToEmailMessage.get(trademarkName));
						System.debug('Old Case Id :'+oldCase.Id);
						theMessage.parentId = oldCase.Id;
						emailMessagesToCreate.add(theMessage);
					}
				}
			}
		}
	}

	
	public EmailMessage getClonedEmailMessageObject(EmailMessage theEmailMessage)
	{
		EmailMessage newEmailMessage = new EmailMessage();
		newEmailMessage.BCCAddress = theEmailMessage.BccAddress;
		newEmailMessage.CcAddress = theEmailMessage.CcAddress;
		newEmailMessage.FromAddress = theEmailMessage.FromAddress;
		newEmailMessage.FromName = theEmailMessage.FromName;
		newEmailMessage.Headers = theEmailMessage.Headers;
		newEmailMessage.HtmlBody = theEmailMessage.HtmlBody;
		newEmailMessage.Incoming = theEmailMessage.Incoming;
		newEmailMessage.Status = theEmailMessage.Status;
		newEmailMessage.Subject = theEmailMessage.Subject;
		newEmailMessage.TextBody = theEmailMessage.TextBody;
		newEmailMessage.ToAddress = theEmailMessage.ToAddress;
		newEmailMessage.MessageDate = theEmailMessage.MessageDate;
		return newEmailMessage;
	}


	public void performDML()
	{
	    Savepoint sp;
	    try
	    {
	      sp = Database.setSavepoint();
	      hasUSPTOTriggerRun = true;
	      
	      if(!finalCasesToUpdate.isEmpty())
	        update finalCasesToUpdate.values();
	      if(!emailMessagesToCreate.isEmpty())
	        insert emailMessagesToCreate;
	      if(!finalCasesToDelete.isEmpty())
	        delete finalCasesToDelete.values();
	      if(!theUSPTOHelper.emailMessagesToCreate.isEmpty())
	        insert theUSPTOHelper.emailMessagesToCreate;
	      if(!theUSPTOHelper.tasksToCreate.isEmpty())
	        insert theUSPTOHelper.tasksToCreate;
	    }
	    catch(DMLException dmlEx)
	    {
	      Database.rollback(sp);
	    }
	}

	public static Map<Id,EmailMessage> getNonAutoResponseEmailMessages(List<EmailMessage> emailMessages)
	{

    	Map<Id,EmailMessage> nonAutoResponseEmailMessages = new Map<Id,EmailMessage>();
    	for(EmailMessage theMessage : emailMessages)
    	{

    		if(theMessage.Subject != null)
    		{
	    		if(!theMessage.Subject.startsWith('LegalZoom Auto-Reply'))
	    		{

	    			nonAutoResponseEmailMessages.put(theMessage.Id , theMessage);
	    		}
    		}
    	}

    	return nonAutoResponseEmailMessages;
	}
}