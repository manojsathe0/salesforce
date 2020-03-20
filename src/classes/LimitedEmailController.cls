public with sharing class LimitedEmailController extends NewEmailControllerBase{
     
    public LimitedEmailController (ApexPages.StandardController stdController){
        theCase = (Case)stdController.getRecord();
    }
    
    public String indexRowNum{
      get{return   ApexPages.currentPage().getParameters().get('indexRowNum');}
      private set;
    }
    
    public List<AttachmentDetail> ListOfEmail{
      get{
        if(ListOfEmail == null){
          ListOfEmail= new List<AttachmentDetail>();
          ListOfEmail.addAll(EmailAttachments);
          ListOfEmail.addAll(HVCRAttachments);
          ListOfEmail.addAll(TaskAttachments);
          ListOfEmail.addAll(DraftAttachments);
          //sortAllAttachmentDetails(ListOfEmail);
          ListOfEmail.sort();
        }
        return ListOfEmail;   
      }        
      private set;
    }
    
    
    public List<AttachmentDetail> EmailAttachments{
      get {
        if(EmailAttachments == null){
          List<EmailMessage> allEmailMessages = NewAttachmentsQuery.getEmailMessages(true , theCase.Id);
          EmailAttachments = getEmailAttachmentDetail(allEmailMessages);
        }
        return EmailAttachments;  
      }//end get
      private set;
    }              
    
    public List<AttachmentDetail> HVCRAttachments{
      get{
        if(HVCRAttachments == null){
          List<HVCR_Email_New__c> messages = NewAttachmentsQuery.getHVCREmail(true , theCase.Id);
          HVCRAttachments = getHVCRAttachmentDetail(messages);
        }
        return HVCRAttachments;
      }//end get
      private set;
    }
    
    public List<AttachmentDetail> TaskAttachments{
      get{
        if(TaskAttachments == null){
          List<Task> tasks = NewAttachmentsQuery.getTasks(true , theCase.Id);
          TaskAttachments = getTaskAttachmentDetail(tasks);
        }                   
        return TaskAttachments;  
      }//end get            
      private set;
    }
    
    public List<AttachmentDetail> DraftAttachments{
      get{
        if(DraftAttachments == null){
          List<Draft_Email__c> drafts = NewAttachmentsQuery.getCustomEmailMessages(true , theCase.Id);
          DraftAttachments = getDraftAttachmentDetails(drafts);
        }                   
        return DraftAttachments; 
      }//end get            
      private set;
    }
      
    public PageReference SendEmail(){
        PageReference pRef = Page.LimitedEmailList;
        return  NewSendEmailHelper.SendEmail(pRef);
    }
    
    public PageReference SendEmailDraft(){
        PageReference pRef = Page.LimitedEmailList;
        return  NewSendEmailHelper.sendEmailDraft(pRef);
    }
    
     public PageReference DeleteEmailDraft(){
        PageReference pRef = Page.EmailList;
        return  NewSendEmailHelper.DeleteEmailDraft(pRef);
    }
}