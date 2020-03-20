public with sharing class USPTOEmailParser 
{
	//First Emai// Subject: 555216956; Trademark Name requests you to e-sign the Trademark/Service Mark Application, Principal Register
	//Second Email// Subject:  Submission link for Trademark/Service Mark Application, Principal Register
	//Third Email// Subject: Serial number 86343742: Received Your Trademark/Service Mark Application, Principal Register
	public final static String FIRST = 'first';
	public final static String SECOND = 'second';
	public final static String THIRD = 'third';
	public final static String USPTOAddedText = 'requests you to e-sign the Trademark/Service';	

	public List<USPTOEmailWrapper> getUSPTOEmailWrappers(List<EmailMessage> USPTOEmailMessages)
	{
		List<USPTOEmailWrapper> USPTOEmailWrappers = new List<USPTOEmailWrapper>();
		for(EmailMessage USPTOEmailMessage : USPTOEmailMessages)
		{
			USPTOEmailWrapper theUSPTOEmailWrapper = new USPTOEmailWrapper();
			theUSPTOEmailWrapper.emailMessageId  = USPTOEmailMessage.Id;
			theUSPTOEmailWrapper.caseId = USPTOEmailMessage.ParentId;
			theUSPTOEmailWrapper.emailMessage = USPTOEmailMessage;
			theUSPTOEmailWrapper.USPTOUniqueId = getUSPTOUniqueId(USPTOEmailMessage.textBody);
			if(theUSPTOEmailWrapper.USPTOUniqueId != null)
			{

				theUSPTOEmailWrapper.emailType = getEmailType(USPTOEmailMessage.Subject);
				if(theUSPTOEmailWrapper.emailType == FIRST)
				{
					processFirstEmail(USPTOEmailMessage.Subject , theUSPTOEmailWrapper);
				}
				else if(theUSPTOEmailWrapper.emailType == THIRD)
				{
					theUSPTOEmailWrapper.trademarkName = getTrademarkName(USPTOEmailMessage.textBody);
					if(theUSPTOEmailWrapper.trademarkName != null)
						processthirdEmail(USPTOEmailMessage.subject , theUSPTOEmailWrapper);
				}
				USPTOEmailWrappers.add(theUSPTOEmailWrapper);			
			}
		}
		return USPTOEmailWrappers;
	}


	public String getEmailType(String emailSubject)
	{
		String emailType;
		if(emailSubject.contains(USPTOAddedText))
		{
			emailType = FIRST;
		}
		else if(emailSubject.startsWith('Submission'))
		{
			emailType = SECOND;
		}
		else if(emailSubject.startsWith('Serial'))
		{
			emailType = THIRD;
		}
		return emailType;
	}

	public void processFirstEmail(String emailSubject , USPTOEmailWrapper theUSPTOEmailWrapper)
	{
		
		Integer indexOfUSPTOAddedText = emailSubject.indexOfIgnoreCase(USPTOAddedText);
		Integer indexOfColumn = emailSubject.indexOfIgnoreCase(';');
        try
        {
			String userOrderNumber = emailSubject.substring(0 , indexOfColumn);
			if(userOrderNumber != null && userOrderNumber != '')
				theUSPTOEmailWrapper.userOrderNumber = userOrderNumber.trim();
			String trademarkName = emailSubject.substring(indexOfColumn+1 , indexOfUSPTOAddedText);
			if(trademarkName != null && trademarkName != '' && trademarkName != ' ')
				theUSPTOEmailWrapper.trademarkName = trademarkName.trim();

		}
		catch(Exception theException)
		{

		}
	}

	
	public void processThirdEmail(String emailSubject , USPTOEmailWrapper theUSPTOEmailWrapper)
	{

		Integer startIndex = emailSubject.indexOfIgnoreCase('Serial number ');
		Integer endIndex = emailSubject.indexOfIgnoreCase(': Received Your');
		try
		{
			String serialNumber = emailSubject.substring(startIndex+14 , endIndex);
			if(serialNumber != null)
				theUSPTOEmailWrapper.serialNumber = serialNumber.trim();
		}
		catch(Exception theException)
		{

		}
	}

	public  String getUSPTOUniqueId(String theEmailBody)
	{
		Pattern firstPattern = Pattern.compile('STAMP:\nUSPTO.*');//sometimes I observed STAMP: and then line break in some email.So using this as a catch.Ideally STAMP: and the value should be in single line.
		Pattern secondPattern = Pattern.compile('STAMP: USPTO.*');
		Matcher firstMatcher = firstPattern.matcher(theEmailBody);
		Matcher secondMatcher = secondPattern.matcher(theEmailBody);
		String trimmedUSPTOUniqueId;
		String USPTOUniqueId;
		if(firstMatcher.find())
		{
			USPTOUniqueId = theEmailBody.subString(firstMatcher.start()+7 ,firstMatcher.end()); 
		}
		if(secondMatcher.find())
		{
		    
		    USPTOUniqueId = theEmailBody.subString(secondMatcher.start()+7 ,secondMatcher.end()); 
		}
		if(USPTOUniqueId != null)
			trimmedUSPTOUniqueId = USPTOUniqueId.trim();
		
		return trimmedUSPTOUniqueId;
	}

	public  String getTrademarkName(String theEmailBody)
	{
		
		
		Pattern thePattern = Pattern.compile('YOUR MARK:.*');
		Matcher theMatcher = thePattern.matcher(theEmailBody);
		String trimmedTrademarkName;
		
		if(theMatcher.find())
		{
		    
			String trademarkline = theEmailBody.subString(theMatcher.start()+11 ,theMatcher.end()); 
			Integer lastIndexOfOpeningBrace = trademarkline.lastIndexOf('(');
			String trademarkName = trademarkline.subString(0,lastIndexOfOpeningBrace);
			if(trademarkName != null && trademarkName != '' && trademarkName != ' ')
				trimmedTrademarkName = trademarkName.trim();
		}

		return trimmedTrademarkName;
	}
}