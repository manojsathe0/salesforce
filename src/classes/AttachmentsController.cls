public class AttachmentsController {
    
    public AttachmentsController (ApexPages.StandardController stdController) {        
        }
        
        public List<AttachmentDetail> StdAttachments {
        	get {
        		if (StdAttachments == null) {
		        	List<Attachment> ATT = new List<Attachment>([SELECT Id, Name, CreatedDate, ContentType FROM Attachment WHERE parentId = :ApexPages.currentPage().getParameters().get('Id')]);
		        	StdAttachments = new List<AttachmentDetail>();
		        	
		        	for(Attachment a : ATT) {
			            String strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') 
			                + '/servlet/servlet.FileDownload?file='  + a.Id;    
			            strUrl = strUrl + '&fname=' + a.Name; 
			            
			            AttachmentDetail attLink = new AttachmentDetail();
			            attLink.link = strUrl;
			            attLink.name = a.Name;
				        attLink.CreatedDate = a.CreatedDate;
				        attLink.ContentType = a.ContentType;
			            
			            StdAttachments.add(attLink);    
		        	}
	            }
	            
	            return StdAttachments;
        	}
        	private set;
        }
        
        public List<AttachmentDetail> EmailAttachments {
        	get {
        		if (EmailAttachments == null) {
		        	List<EmailMessage> messages = new List<EmailMessage>([SELECT Id, Subject, (SELECT Id, Name, CreatedDate, ContentType FROM Attachments LIMIT 100) FROM EmailMessage WHERE (ParentId = :ApexPages.currentPage().getParameters().get('Id')) LIMIT 100]);
		        	EmailAttachments = new List<AttachmentDetail>();
						
			       for(EmailMessage E:messages) {   
		        	
						List<Attachment> ATT = E.Attachments;
						if (!CT_Utility.ValidateList(ATT)) continue;
						
						for(Attachment a : ATT) {
					        String strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') 
					            + '/servlet/servlet.FileDownload?file='  + a.Id;    
					        strUrl = strUrl + '&fname=' + a.Name; 
					        
					        AttachmentDetail attLink = new AttachmentDetail();
					        attLink.link = strUrl;
					        attLink.name = a.Name;
					        attLink.subject = E.Subject;
					        attLink.CreatedDate = a.CreatedDate;
					        attLink.ContentType = a.ContentType;
					        
					        EmailAttachments.add(attLink);    
					    }
					}
        		}
            
            return EmailAttachments;
        	}
        	private set;
        }
        
        public List<AttachmentDetail> ActivityAttachments {
        	get {
        		if (ActivityAttachments == null) {	
        	
		        	List<Task> messages = new List<Task>([SELECT Id, Subject, (SELECT Id, Name, CreatedDate, ContentType FROM Attachments LIMIT 100) FROM Task WHERE (WhatId = :ApexPages.currentPage().getParameters().get('Id')) LIMIT 100]);
		        	ActivityAttachments = new List<AttachmentDetail>();
						
			       for(Task E:messages) {   
		        	
						List<Attachment> ATT = E.Attachments;
						if (!CT_Utility.ValidateList(ATT)) continue;
						
						for(Attachment a : ATT) {
					        String strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') 
					            + '/servlet/servlet.FileDownload?file='  + a.Id;    
					        strUrl = strUrl + '&fname=' + a.Name; 
					        
					        AttachmentDetail attLink = new AttachmentDetail();
					        attLink.link = strUrl;
					        attLink.name = a.Name;
					        attLink.subject = E.Subject;
					        attLink.CreatedDate = a.CreatedDate;
					        attLink.ContentType = a.ContentType;
					        
					        ActivityAttachments.add(attLink);    
					    }
					}
        		}
            
            	return ActivityAttachments;
        	}
        	private set;
        }
        
        public List<AttachmentDetail> HVCRAttachments {
        	get {
        		if (HVCRAttachments == null) {
		        	List<HVCR_Email_New__c> messages = new List<HVCR_Email_New__c>([SELECT Id, Subject__c, (SELECT Id, Name, CreatedDate, ContentType FROM Attachments LIMIT 100) FROM HVCR_Email_New__c WHERE (Case__c = :ApexPages.currentPage().getParameters().get('Id')) LIMIT 100]);
		        	HVCRAttachments = new List<AttachmentDetail>();
						
			       for(HVCR_Email_New__c E:messages) {   
		        	
						List<Attachment> ATT = E.Attachments;
						if (!CT_Utility.ValidateList(ATT)) continue;
						
						for(Attachment a : ATT) {
					        String strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') 
					            + '/servlet/servlet.FileDownload?file='  + a.Id;    
					        strUrl = strUrl + '&fname=' + a.Name; 
					        
					        AttachmentDetail attLink = new AttachmentDetail();
					        attLink.link = strUrl;
					        attLink.name = a.Name;
					        attLink.subject = E.Subject__c;
					        attLink.CreatedDate = a.CreatedDate;
					        attLink.ContentType = a.ContentType;
					        
					        HVCRAttachments.add(attLink);    
					    }
					}
        		}
            
           		return HVCRAttachments;
        	}
        	private set;
        }
        
        public class AttachmentDetail {
        	public String link {get; set;}
        	public String name {get; set;}
        	public String subject {get; set;}
        	
        	public DateTime CreatedDate {get; set;}
        	public String ContentType {get; set;}
        }
        
        

    static testmethod void mytest(){
        Account testAccount = TestUtils.createAccounts(1 , 'TestAccount@yahoo.com', true)[0];
        List<Contact> contact = TestUtils.createContacts(1 , 'Buffet', testAccount.Id, true);
        PageReference pg = Page.AllAttachmentsPage;
        Test.setCurrentPage(pg);
        Blob testBlob = Blob.valueOf('fgdfgddgdgdgftrtjtumvbnvn');
        Case c = new Case(ContactId= contact[0].Id);
        insert c;        
        pg.getParameters().put('Id', c.Id);
        System.debug('TEST CASE URL: ' + pg.getUrl());  
        Attachment a = new Attachment(ParentId= c.Id, Name = 'testname', Body = testBlob );  
        insert a;
        
        EmailMessage em = new EmailMessage(ParentId =c.Id);
        insert em;
        
        if (contact.size() > 0) {            
            ApexPages.StandardController controller = new ApexPages.StandardController(c);
            
            AttachmentsController  obj = new AttachmentsController (controller);
            //obj.getAttLinks();
            List<AttachmentDetail> lst1 = obj.EmailAttachments;
            List<AttachmentDetail> lst2 = obj.HVCRAttachments;
            List<AttachmentDetail> lst3 = obj.StdAttachments;
            List<AttachmentDetail> lst4 = obj.ActivityAttachments;
            
            }
    }
 }