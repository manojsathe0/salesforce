public with sharing class AttachmentsQuery
{
	public static List<EmailMessage> getEmailMessages(Boolean isLimit , Id theCaseId)
	{
		if(isLimit)
			return [SELECT Id, Subject,status,toaddress,MessageDate,fromaddress,ccaddress,bccaddress, (SELECT Id, Name, CreatedDate,ContentType FROM Attachments LIMIT 1) FROM EmailMessage WHERE ParentId = :theCaseId order by CreatedDate DESC LIMIT 5];
		else
			return [SELECT Id, Subject,status,toaddress,MessageDate,fromaddress,ccaddress,bccaddress, (SELECT Id, Name, CreatedDate,ContentType FROM Attachments LIMIT 1) FROM EmailMessage WHERE ParentId = :theCaseId order by CreatedDate DESC];
	}
	
	public static List<HVCR_Email_New__c> getHVCREmail(Boolean isLimit ,  Id theCaseId)
	{
		if(isLimit)
			return [SELECT Id,SystemModstamp, isDraft__c, ToAddresses__c, Subject__c, Status__c,
                                                                                            ToAddressesLong__c,CCAddressesLong__c,BCCAddressesLong__c,ReplyToAddressLong__c,FromAddressLong__c,
                                                                                            SentDate__c, ReplyToAddress__c, IsSent__c, IsRepliable__c, IsRead__c,
                                                                                            IsInbound__c, FromAddress__c, Contact__c, Case__c, CCAddresses__c, 
                                                                                            BCCAddresses__c, Name, LastModifiedDate, LastModifiedById,
                                                                                            IsDeleted, CreatedDate,CreatedById, (SELECT Id, Name, CreatedDate,ContentType FROM Attachments LIMIT 1) FROM HVCR_Email_New__c WHERE Case__c = :theCaseId order by createddate desc LIMIT 5];
		else
			return [SELECT Id,SystemModstamp, isDraft__c, ToAddresses__c, Subject__c, Status__c,
                                                                                            ToAddressesLong__c,CCAddressesLong__c,BCCAddressesLong__c,ReplyToAddressLong__c,FromAddressLong__c,
                                                                                            SentDate__c, ReplyToAddress__c, IsSent__c, IsRepliable__c, IsRead__c,
                                                                                            IsInbound__c, FromAddress__c, Contact__c, Case__c, CCAddresses__c, 
                                                                                            BCCAddresses__c, Name, LastModifiedDate, LastModifiedById,
                                                                                            IsDeleted, CreatedDate,CreatedById, (SELECT Id, Name, CreatedDate,ContentType FROM Attachments LIMIT 1) FROM HVCR_Email_New__c WHERE Case__c = :theCaseId order by createddate desc];
	}
	
	
	public static List<Task> getTasks(Boolean isLimit ,  Id theCaseId)
	{
		if(isLimit)
			return [Select Subject, Status, Legacy_CC_Email__c, Id, CreatedDate,legacy_id__c, (Select Id, name,ContentType, CreatedDate From Attachments limit 1) From Task  WHERE WhatId =: theCaseId and isdeleted=false order by createdDate desc LIMIT 5 ALL ROWS];
			
		else
			return [Select Subject, Status, Legacy_CC_Email__c, Id, CreatedDate,legacy_id__c, (Select Id, name,ContentType, CreatedDate From Attachments limit 1) From Task  WHERE WhatId =: theCaseId and isdeleted=false order by createdDate desc ALL ROWS];	
	}
}