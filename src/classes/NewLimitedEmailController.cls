public with sharing class NewLimitedEmailController extends EmailControllerBase
{
	 
	 public NewLimitedEmailController (ApexPages.StandardController stdController)
	 {
         theCase = (Case)stdController.getRecord();
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
              List<EmailMessage> allEmailMessages = AttachmentsQuery.getEmailMessages(true , theCase.Id);
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
                List<HVCR_Email_New__c> messages = AttachmentsQuery.getHVCREmail(true , theCase.Id);
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
              List<Task> tasks = AttachmentsQuery.getTasks(true , theCase.Id);
              TaskAttachments = getTaskAttachmentDetail(tasks);
             }                   
          
           return TaskAttachments;	
          }//end get            
          private set;
        }
        
     public PageReference SendEmail()
     {
    	PageReference thePage = SendEmailHelper.SendEmail('NewLimitedEmailList');
    	return thePage;
     }
        
}