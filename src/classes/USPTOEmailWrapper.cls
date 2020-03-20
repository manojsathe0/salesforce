public with sharing class USPTOEmailWrapper 
{
	public String USPTOUniqueId{get;set;}
	public String serialNumber{get;set;}
	public String trademarkName{get;set;}
	public String userOrderNumber{get;set;}
	public String emailType{get;set;}
	public Id emailMessageId{get;set;}
	public Id caseId{get;set;}
	public EmailMessage emailMessage{get;set;}
}