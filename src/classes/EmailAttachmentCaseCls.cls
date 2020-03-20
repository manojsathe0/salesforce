public without sharing class EmailAttachmentCaseCls {
	
	private static Set<Id> attID = new Set<Id>();
	private static Set<Id> EmailMessageParentID = new Set<Id>();
	private static Set<ID> emailID = new Set<ID>();	
	private static String mNewAttachmentID;
	private static Id caseId;
	private static ID scc_bccaseEmail;
	private static ID draft_email;
	private static ID emailMessageID;
	private static List<Case> newCase = new List<Case>();
	private static List<Case> emailCase = new List<Case>();
	
	public static void emailAttachmentCaseEmailInsert(List<Attachment> attNew){
		for(Attachment att : attNew)
		{
			if(att.ParentId != null)
			{
				attID.add(att.ParentId);
				mNewAttachmentID = att.ParentId;
			}		
		}
		//Check type of attachment
		caseId = mNewAttachmentID;
		Schema.Sobjecttype theToken = caseId.getSObjectType();
		if(theToken == Case.sObjectType){
			List<Case> caseList = [SELECT Id, IsHasAttachment__c FROM Case WHERE Id IN: attID];
			if(caseList.size() > 0)
			{
				update getCaseHasAttachment(caseList);
			}
		}else if(theToken == Draft_Email__c.sObjectType){
			draft_email = [SELECT Case__c FROM Draft_Email__c WHERE Id IN: attID].Case__c;
			List<Case> caseList = [SELECT Id, IsHasAttachment__c FROM Case WHERE Id =: draft_email];
			if(caseList.size() > 0)
			{
				update getCaseHasAttachment(caseList);
			}
		}else if(theToken == EmailMessage.sObjectType){	
			emailMessageID = [SELECT ParentId FROM EmailMessage WHERE Id IN: attID].ParentId;		
			List<Case> caseList = [SELECT Id, IsHasAttachment__c FROM Case WHERE Id =: emailMessageID];
			if(caseList.size() > 0)
			{
				update getCaseHasAttachment(caseList);
			}
		}
		
	}
	
	//Email Message Attachment
	public static void emailMessageAttachmentCaseBeforeInsert(List<EmailMessage> EmailMessageNew){			
		for(EmailMessage message : EmailMessageNew)
		{
			if(message.HasAttachment==true)
			{
				EmailMessageParentID.add(message.ParentId);
			}			
		}
		
		List<Case> caseList = [SELECT Id, IsHasAttachment__c FROM Case WHERE Id IN: EmailMessageParentID];
		if(caseList.size() > 0)
		{
			update getCaseHasAttachment(caseList);
		}
		
	}
	
	public static List<Case> getCaseHasAttachment(List<Case> caseList){
		List<Case> emailMessageCase = new List<Case>();
		for(Case c : caseList)
		{		
			Case mCase = new Case(Id = c.Id);
			mCase.IsHasAttachment__c = true;
			emailMessageCase.add(mCase);
		}
		return emailMessageCase;
	}
}