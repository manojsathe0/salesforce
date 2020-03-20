global class BatchAssociateAttachments implements Database.Batchable<sObject>, Database.Stateful {
	
	global String query;
	global CaseAttachment__c caseAttObj  {get; set;}
	global BatchAssociateAttachments(CaseAttachment__c caseAttObj) {
		query = 'select id, Body, Name from Attachment where ParentId = \'' + caseAttObj.Id + '\'';
		this.caseAttObj = caseAttObj;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(Query);
	}
   
	global void execute(Database.BatchableContext BC, List<sObject> attList) {
		
		List<Attachment> newAttList = new List<Attachment>();
		
		if(attList != null) {
			if(attList != null & attList.size() > 0) {
				for(Attachment a: (List<Attachment>)attList) {
					
					Attachment at = new Attachment();
					at.Body = a.Body;
					at.ParentId = caseAttObj.Related_Case__c;
					at.Name = a.Name;
					newAttList.add(at);
				}
				insert newAttList;
				delete attList;
				delete caseAttObj;
			}
		}
	}
	
	global void finish(Database.BatchableContext BC){

    }
    
    public static testmethod void testBatchAddClientAgency(){
        Test.StartTest();
        //Account
		Account a = new Account();
		a.Name = 'ACC';
		insert a;
		
		//Contact
		Contact obj = new Contact();
		obj.AccountId = a.Id;
		obj.LastName = 'lastname';
		insert obj;
		
		Case c = new Case();
		c.SuppliedName = 'Sandeep Singh';
		c.Order_Submitted__c = true;
        c.Status = 'New';
        c.Origin = 'Phone';
        insert c;
        
     	CaseAttachment__c caseAttObj = new CaseAttachment__c();
    	caseAttObj.Related_Case__c = c.Id;
    	insert caseAttObj;
        	
        Attachment att = new Attachment();
        att.Body = Encodingutil.base64Decode('Hello Sandeep');
        att.Name = 'Test Att';
        att.ParentId = caseAttObj.Id;
        insert att;	
        	
        List<Attachment> meList = [select id, Body, Name from Attachment where ParentId = : caseAttObj.Id];
        BatchAssociateAttachments b = new BatchAssociateAttachments(caseAttObj);
        b.execute(null, meList);
        ID batchprocessid = Database.executeBatch(b);
        Test.StopTest();
    
   }
}