public with sharing class NewEmailController extends EmailControllerBase
{
	 public Boolean refreshPage {get; set;}
     public  String  statusResend {get; set;}
     public  String  resendMessage {get; set;}
     public  String theObjectId {get;set;}
     public String theObjectName {get;set;}
	 
	 public NewEmailController (ApexPages.StandardController stdController)
	 {
	      theObjectId = null;
	      
	      Map<String,String> currentParams = ApexPages.currentPage().getParameters();
	      if(currentParams.containsKey('objectId'))
	 	 	theObjectId = currentParams.get('objectId');
	 	 	
	      theCase = (Case)stdController.getRecord();
	 	  if(currentParams.containsKey('sObjectName'))
	     	theObjectName = currentParams.get('sObjectName');
     	  
     	  if(theObjectId != null)
          {
         	 objectId = theObjectId;
         	 sObjectName = theObjectName;
         	 getMessageDetail();
          }
     }
     
     public String indexRowNum
     {
	       get{return   ApexPages.currentPage().getParameters().get('indexRowNum');}
	       private set;
     }
     
     public static String attstrMessage
     {
	       get
	       {
	             if(attstrMessage != null)
	                return  attstrMessage;
	              else
	                return '';
	        }
	       private set;
      } 
      
     public void getMessageDetail()
     {
     	AttachmentDetail currentDetailObject;
     	for(AttachmentDetail aDetail : ListOfEmail)
     	{
     		if(aDetail.Id == objectId)
     		{
     			currentDetailObject = aDetail;
     			break;
     		}
     	}
		
		currentDetailObject.isExpanded = true;     	
     	if(currentDetailObject.textBody == null)
     	{
	     	
	     	if(sObjectName == 'EmailMessage')
	     	{
	     	  List<EmailMessage> theMessage = [SELECT Id, textbody, HtmlBody ,  
	     	  							(SELECT Id, Name, CreatedDate,ContentType FROM Attachments) FROM 
	     	  							EmailMessage WHERE Id = :objectId];
	          if(!theMessage.isEmpty())
	          {
		          if(theMessage[0].HtmlBody != null)
		          {
		              currentDetailObject.textBody = theMessage[0].HtmlBody;
		          }
		          else if(theMessage[0].TextBody != null)
		          {
		              String formattedMessage = theMessage[0].TextBody.replaceAll('\n' , '<br />');
		              currentDetailObject.textBody = formattedMessage;
		          }
		          currentDetailObject.link = new List<FileDetail>();
			      List<Attachment> allAttachments = theMessage[0].Attachments; 
			      if(!allAttachments.isEmpty())
			      {
				     currentDetailObject.link.addAll(constructFileDetails(allAttachments));
			      }
	          }    
	          
	     	}
	     	
	     	else if (sObjectName == 'HVCR_Email_New__c')
	     	{
		     	List<HVCR_Email_New__c> hvcrMessage  = [SELECT Id, Body__c, BodyPlainText__c , 
		     	  										(SELECT Id, Name, CreatedDate,ContentType FROM Attachments) 
		     	  										FROM HVCR_Email_New__c WHERE Id =:objectId];
		     		
		     	if(!hvcrMessage.isEmpty())
		     	{	 
		            if(hvcrMessage[0].body__c != null)
		            {
		                currentDetailObject.textBody = hvcrMessage[0].Body__c;
		            }
		            else if(hvcrMessage[0].BodyPlainText__c != null)
		            {
		                String formattedMessage = hvcrMessage[0].BodyPlainText__c.replaceAll('\n' , '<br/>');
		                currentDetailObject.textBody = formattedMessage;
		            }
		            currentDetailObject.link = new List<FileDetail>();
			        List<Attachment> allAttachments = hvcrMessage[0].Attachments; 
			        if(!allAttachments.isEmpty())
			        {
				       currentDetailObject.link.addAll(constructFileDetails(allAttachments));
			        }
		     	}
	     	}
	     	
	     	else if(sObjectName  == 'Task')
	     	{
	     		List<Task> theTask = [Select Id , Description ,  (Select Id, name,ContentType, CreatedDate From Attachments) From Task  WHERE Id = :objectId ALL ROWS];
	     		
	     		if(!theTask.isEmpty())
	     		{
		     		 if(theTask[0].description != null)
			         {
			              String formattedMessage = theTask[0].description.replaceAll('\n' , '<br />');
			              currentDetailObject.textBody = formattedMessage;
			         }
		     		currentDetailObject.link = new List<FileDetail>();
			        List<Attachment> allAttachments = theTask[0].Attachments; 
			        if(!allAttachments.isEmpty())
			        {
				       currentDetailObject.link.addAll(constructFileDetails(allAttachments));
			        }
	     		}
	     	
	     	}
	     	
     	}
     }
     
     private List<FileDetail> constructFileDetails(List<Attachment> allAttachments)
     {
     	  Integer separator = 0 ;
	      List<FileDetail> fileDetails = new List<FileDetail>();
	      for(Attachment theAttachment : allAttachments)
	      {
	      	separator++;
	      	String strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/servlet/servlet.FileDownload?file='  + theAttachment.Id;                                                                                 
	        strURL= strURL+ '&fname=' + theAttachment.Name; 
	        FileDetail   fileDetail = new FileDetail();
	        fileDetail.link = strURL;
	        fileDetail.name = theAttachment.Name;
	        if(allAttachments.size()==1)
	        {
	              fileDetail.sep = '';                               
	        }
	        if(separator < allAttachments.size())
	        {
	              fileDetail.sep = '|';
	        }else
	        {
	              fileDetail.sep = '';
	      	}
     	 	fileDetails.add(fileDetail);
     	 }
     	 
     	 return fileDetails;
     	 
     }
       
        public List<AttachmentDetail> ListOfEmail{
            get
            {
              if(ListOfEmail == null)
              {
                  ListOfEmail= new List<AttachmentDetail>();
                  ListOfEmail.addAll(EmailAttachments);
                  ListOfEmail.addAll(HVCRAttachments);
                  ListOfEmail.addAll(TaskAttachments);
               	  sortAllAttachmentDetails(ListOfEmail);	
               }
               return ListOfEmail;	 
            }        
            private set;
        }
        
        
      public List<AttachmentDetail> EmailAttachments
      {
          get 
           {
            if (EmailAttachments == null)
             {
              List<EmailMessage> allEmailMessages = AttachmentsQuery.getEmailMessages(false , theCase.Id);
              EmailAttachments = getEmailAttachmentDetail(allEmailMessages);
             }
          	
          return EmailAttachments;	
          }//end get
          
          private set;
        }              
        
       public List<AttachmentDetail> HVCRAttachments
       {
         get 
         {
            if (HVCRAttachments == null) 
            {
                List<HVCR_Email_New__c> messages = AttachmentsQuery.getHVCREmail(false , theCase.Id);
                HVCRAttachments = getHVCRAttachmentDetail(messages);
            }
          return HVCRAttachments;
         }//end get
          private set;
        }
        
       public List<AttachmentDetail> TaskAttachments
       {
          get
          {
            if (TaskAttachments == null)
            {
              List<Task> tasks = AttachmentsQuery.getTasks(false , theCase.Id);
              TaskAttachments = getTaskAttachmentDetail(tasks);
             }                   
          
           return TaskAttachments;	
          }//end get            
          private set;
        }
        
     public PageReference SendEmail()
     {
    	PageReference thePage = SendEmailHelper.SendEmail('NewEmailList');
    	return thePage;
     }
     
     public void updateExpandValue()
     {
      	AttachmentDetail currentDetailObject;
     	for(AttachmentDetail aDetail : ListOfEmail)
     	{
     		if(aDetail.Id == objectId)
     		{
     			currentDetailObject = aDetail;
     			break;
     		}
     	}
     	
     	currentDetailObject.isExpanded = false;
     }  
}