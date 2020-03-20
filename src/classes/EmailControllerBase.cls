public virtual with sharing class EmailControllerBase 
{
	 
	 public Case theCase {get;set;}
	 public final String datetime_format = 'M/d/yyyy h:mm:ss a';
	 public  Boolean refreshPage {get; set;}
	 public  String  statusResend {get; set;}
	 public  String  resendMessage {get; set;}
	 public  String sObjectName {get;set;}
	 public  String objectId {get; set;}
	 public  String internalRowNum {get; set;}
	 
	public Map<String,String> picklistOptionToLabel
        {
	        get
	        {
	        	if(picklistOptionToLabel == null)
	        	{
	        		picklistOptionToLabel = new Map<String,String>();
	        		Schema.sObjectType sobject_type = EmailMessage.getSObjectType();
                    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
                    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
                    List<Schema.Picklistentry> pick_list = field_map.get('status').getDescribe().getPickListValues();
                    for (Schema.PicklistEntry s : pick_list)
                    {
                       picklistOptionToLabel.put(s.getValue() , s.getLabel());
                    }     
	        	}
	        return 	picklistOptionToLabel;
	        }
	        
	        private set;
     }
         
	public List<AttachmentDetail> getEmailAttachmentDetail(List<EmailMessage> allEmailMessages)
	{
		List<AttachmentDetail> emailAttachmentsDetails = new List<AttachmentDetail>();
        for(EmailMessage eMessage : allEmailMessages) 
        {   
              List<Attachment> attachments = eMessage.Attachments;
              AttachmentDetail attLink = new AttachmentDetail();
              attLink.id = eMessage.id;
              attLink.subjectLink = 'https://' + ApexPages.currentPage().getHeaders().get('Host')+'/'+eMessage.Id;
              attLink.subject = eMessage.Subject;
              attLink.sObjectName = 'EmailMessage';
              attLink.fromAddress = eMessage.FromAddress;
              attLink.toAddress = eMessage.ToAddress;
              attLink.ccAddress = eMessage.CcAddress;
              attLink.bccAddress = eMessage.BccAddress;
              attLink.CreatedDate = eMessage.MessageDate.format(datetime_format);
              attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';
              attLink.Status = picklistOptionToLabel.get(eMessage.status);
              attLink.link = new List<FileDetail>();
              
              if(Integrated_Email_List_Constants.EMAIL_STATUS_NEW.equals(attLink.status))
              {
                  attLink.inboundPicture = 'EmailPicture/emailInbound.gif';
                  attLink.statusTip='Inbound';
                  attLink.email = eMessage.fromAddress;
              }else if(Integrated_Email_List_Constants.EMAIL_STATUS_READ.equals(attLink.status))
              {
                  attLink.inboundPicture = 'EmailPicture/emailInbound.gif';
                  attLink.statusTip='Inbound';
                  attLink.email = eMessage.fromAddress;
              }else if(Integrated_Email_List_Constants.EMAIL_STATUS_REPLIED.equals(attLink.status))
              {
                  attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';
                  attLink.statusTip='Inbound';
                  attLink.email = eMessage.fromAddress;
              }else if(Integrated_Email_List_Constants.EMAIL_STATUS_SENT.equals(attLink.status))
              {
                  attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';
                  attLink.statusTip='Outbound';
                  attLink.email = eMessage.toAddress;
              }else if(Integrated_Email_List_Constants.EMAIL_STATUS_FORWARDED .equals(attLink.status))
              {
                  attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';
                  attLink.statusTip='Outbound';
                  attLink.email = eMessage.toAddress;
              }
             
              if (!attachments.isEmpty())
              {
                    for(Attachment theAttachment : attachments)
                    {
                    	 attLink.attachmentPicture = 'EmailPicture/emailHasAttach.gif';  
                    }
              }
              
              emailAttachmentsDetails.add(attLink);                  
           }                          
          
        return emailAttachmentsDetails;
	}
	
	public List<AttachmentDetail> getHVCRAttachmentDetail(List<HVCR_Email_New__c> hvcrMessages)
	{
		       List<AttachmentDetail> HVCRAttachments = new List<AttachmentDetail>();
                
                for(HVCR_Email_New__c hvcrMessage : hvcrMessages)
                {   
                    AttachmentDetail attLink = new AttachmentDetail();
                    attLink.id = hvcrMessage.Id;
                    if(hvcrMessage.isdraft__c==true)
                    {
                       attLink.status = Integrated_Email_List_Constants.EMAIL_STATUS_DRAFT;
                    }
                    else
                    {
                       if(hvcrMessage.issent__c==true)
                       {
                                attLink.status = Integrated_Email_List_Constants.EMAIL_STATUS_SENT;
                       }
                       else
                       {
                            if(hvcrMessage.isinbound__c==true && hvcrMessage.isread__c==false)
                            {
                                    attLink.status = Integrated_Email_List_Constants.EMAIL_STATUS_NEW;
                            }
                            else
                            {
                                    if(hvcrMessage.isinbound__c==true && hvcrMessage.isread__c==true)
                                    {
                                        attLink.status = Integrated_Email_List_Constants.EMAIL_STATUS_READ;
                                    }
                                }
                         }
                      } 
                      attLink.subject = hvcrMessage.Subject__c;
                      attLink.subjectLink = 'https://' + ApexPages.currentPage().getHeaders().get('Host') +'/'+hvcrMessage.Id;
                      attLink.sObjectName = 'HVCR_Email_New__c';
                       
                      attLink.fromAddress  = hvcrMessage.FromAddress__c != null ? hvcrMessage.FromAddress__c : hvcrMessage.FromAddressLong__c;  
                      attLink.ccAddress = hvcrMessage.CcAddresses__c !=null ? hvcrMessage.CcAddresses__c :  hvcrMessage.CCAddressesLong__c; 
                      attLink.bccAddress = hvcrMessage.BccAddresses__c != null ? hvcrMessage.BccAddresses__c : hvcrMessage.BCCAddressesLong__c;  
                      attLink.CreatedDate = hvcrMessage.sentdate__c !=null ? hvcrMessage.sentdate__c.format(datetime_format) : hvcrMessage.createddate.format(datetime_format); 
                                
                      if(Integrated_Email_List_Constants.EMAIL_STATUS_PENDING.equals(attLink.status) 
                            || Integrated_Email_List_Constants.EMAIL_STATUS_RESOLVED.equals(attLink.status)
                            || Integrated_Email_List_Constants.EMAIL_STATUS_UNRESOLVED .equals(attLink.status)
                            || Integrated_Email_List_Constants.EMAIL_STATUS_NEW.equals(attLink.status)
                            || Integrated_Email_List_Constants.EMAIL_STATUS_READ.equals(attLink.status)
                            || Integrated_Email_List_Constants.EMAIL_STATUS_REPLIED.equals(attLink.status))
                      {
                      	if(null != hvcrMessage.ToAddresses__c)
                        {
                            attLink.toAddress = hvcrMessage.ToAddresses__c;
                            attLink.email =hvcrMessage.fromAddress__c;
                        }
                        else
                        {
                            if(null != hvcrMessage.ToAddressesLong__c)
                            {
                                attLink.email =hvcrMessage.fromAddressLong__c;
                                attLink.toAddress = hvcrMessage.ToAddressesLong__c;
                            }
                        }       
                            
                       }
                       else
                       {
	                        if(null != hvcrMessage.ToAddresses__c)
	                        {
	                            attLink.toAddress = hvcrMessage.ToAddresses__c;
	                            attLink.email =hvcrMessage.ToAddresses__c;
	                        }
	                        else
	                        {
	                            if(null != hvcrMessage.ToAddressesLong__c)
	                            {
	                                attLink.email =hvcrMessage.ToAddressesLong__c;
	                                attLink.toAddress = hvcrMessage.ToAddressesLong__c;
	                            }
	                        }
                        
                         
                        }                                    
                          
                        if(Integrated_Email_List_Constants.EMAIL_STATUS_PENDING.equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailInbound.gif';attLink.statusTip='Inbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_RESOLVED.equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailInbound.gif';attLink.statusTip='Inbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_UNRESOLVED .equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailInbound.gif';attLink.statusTip='Inbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_NEW.equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailInbound.gif';attLink.statusTip='Inbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_READ.equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailInbound.gif';attLink.statusTip='Inbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_REPLIED.equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';attLink.statusTip='Inbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_SENT.equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';attLink.statusTip='Outbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_FORWARDED .equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';attLink.statusTip='Outbound';
                        }else if(Integrated_Email_List_Constants.EMAIL_STATUS_DRAFT .equals(attLink.status)){
                            attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';attLink.statusTip='Outbound';
                        }                      
                       
                    	 if(! hvcrMessage.Attachments.isEmpty())
		                 {
		                    attLink.attachmentPicture = 'EmailPicture/emailHasAttach.gif'; 
		                 }
                    	 
                    	 HVCRAttachments.add(attLink);
                    }
                    
                    return HVCRAttachments;
	}
	
	
	public List<AttachmentDetail> getTaskAttachmentDetail(List<Task> tasks)
	{
		List<AttachmentDetail> TaskAttachments = new List<AttachmentDetail>();
        for(Task theTask : tasks)
        {
        	if(theTask.legacy_id__c != null)
        	{   
              AttachmentDetail attLink = new AttachmentDetail();
              attLink.id = theTask.id;
              
              attLink.subjectLink = 'https://' + ApexPages.currentPage().getHeaders().get('Host')+'/'+theTask.id;
              attLink.email = theTask.Legacy_CC_Email__c;
              attLink.subject = theTask.Subject;
              attLink.legacyid = theTask.legacy_id__c;
              attLink.ccAddress = theTask.Legacy_CC_Email__c;
              attLink.sObjectName = 'Task';
                                        
              attLink.CreatedDate = theTask.CreatedDate.format(datetime_format);
              attLink.inboundPicture = 'EmailPicture/emailOutbound.gif';
              attLink.status = theTask.Status;
              
              if(!theTask.Attachments.isEmpty())
              {  
                 attLink.attachmentPicture = 'EmailPicture/emailHasAttach.gif';
              }
          	  TaskAttachments.add(attLink);
          }
        }
        return TaskAttachments;
	}
	
	public void sortAllAttachmentDetails(List<AttachmentDetail> ListOfEmail)
	{
		  AttachmentDetail temp;
          boolean swap=true;
          Integer j=0;
          String tempd='',tempm='',tempy='',temph='',tempn='',tempo='';
          String tempd2='',tempm2='',tempy2='',temph2='',tempn2='',tempo2='';
          Integer ampm=0,ampm2=0,ampmm=0,ampmm2=0;
          while(swap)
          {
              swap=false;
              j++;                   
              for(Integer k=0;k<ListOfEmail.size()-j;k++)
              {
                 tempm=ListOfEmail.get(k).createddate.substring(0,ListOfEmail.get(k).createddate.indexOf('/'));
                 tempd=ListOfEmail.get(k).createddate.substring(ListOfEmail.get(k).createddate.indexOf('/')+1,ListOfEmail.get(k).createddate.lastindexOf('/'));
                 tempy=ListOfEmail.get(k).createddate.substring(ListOfEmail.get(k).createddate.lastindexOf('/')+1,ListOfEmail.get(k).createddate.lastindexOf('/')+5);
                 temph=ListOfEmail.get(k).createddate.substring(ListOfEmail.get(k).createddate.indexOf(' ')+1,ListOfEmail.get(k).createddate.indexOf(':'));
                 tempn=ListOfEmail.get(k).createddate.substring(ListOfEmail.get(k).createddate.indexOf(':')+1,ListOfEmail.get(k).createddate.indexOf(':')+3);
                 tempo=ListOfEmail.get(k).createddate.substring(ListOfEmail.get(k).createddate.lastindexOf(':')+1,ListOfEmail.get(k).createddate.lastindexOf(':')+3);
                 ampm=ListOfEmail.get(k).createddate.indexOf('PM');
                 tempm2=ListOfEmail.get(k+1).createddate.substring(0,ListOfEmail.get(k+1).createddate.indexOf('/'));
                 tempd2=ListOfEmail.get(k+1).createddate.substring(ListOfEmail.get(k+1).createddate.indexOf('/')+1,ListOfEmail.get(k+1).createddate.lastindexOf('/'));
                 tempy2=ListOfEmail.get(k+1).createddate.substring(ListOfEmail.get(k+1).createddate.lastindexOf('/')+1,ListOfEmail.get(k+1).createddate.lastindexOf('/')+5);
                 temph2=ListOfEmail.get(k+1).createddate.substring(ListOfEmail.get(k+1).createddate.indexOf(' ')+1,ListOfEmail.get(k+1).createddate.indexOf(':'));
                 tempn2=ListOfEmail.get(k+1).createddate.substring(ListOfEmail.get(k+1).createddate.indexOf(':')+1,ListOfEmail.get(k+1).createddate.indexOf(':')+3);
                 tempo2=ListOfEmail.get(k+1).createddate.substring(ListOfEmail.get(k+1).createddate.lastindexOf(':')+1,ListOfEmail.get(k+1).createddate.lastindexOf(':')+3);
                 ampm2=ListOfEmail.get(k+1).createddate.indexOf('PM');
                 
                 if(ampm!=-1){
                     ampmm=12*60*60;
                 }else{
                     ampmm=0;
                 }
                 if(ampm2!=-1){
                     ampmm2=12*60*60;
                 }else{
                     ampmm2=0;
                 }
                 if(temph=='12'){
                       temph='0'; 
                 }
                 if(temph2=='12'){
                       temph2='0'; 
                 }                         
                 if((decimal.valueof(tempy)*750*24*60*60+decimal.valueof(tempm)*100*24*60*60+decimal.valueof(tempd)*24*60*60+decimal.valueof(temph)*60*60+decimal.valueof(tempn)*60+decimal.valueof(tempo)+ampmm)<(decimal.valueof(tempy2)*750*24*60*60+decimal.valueof(tempm2)*100*24*60*60+decimal.valueof(tempd2)*24*60*60+decimal.valueof(temph2)*60*60+decimal.valueof(tempn2)*60+decimal.valueof(tempo2)+ampmm2)){
                     temp=ListOfEmail[k+1];
                     ListOfEmail[k+1]=ListOfEmail[k];
                     ListOfEmail[k]=temp;
                     swap=true;                             
                 }                         
              }
           }
	}
	
	
    public class AttachmentDetail
    {
	  public id  id{get;set;}
      public List<FileDetail> link {get; set;}
      public String subject {get; set;}
      public String subjectLink{get;set;}
      public String status {get;set;}
      public String email {get;set;}
      public String CreatedDate {get; set;}
      public String ContentType {get; set;}
      public String inboundPicture{get;set;}
      public String attachmentPicture{get;set;}
      public String statusTip{get;set;}
      public String textBody{get;set;}
      public String legacyid{get;set;}
      public String fromAddress{get;set;}
      public String toAddress{get;set;}
      public String ccAddress{get;set;}
      public String bccAddress{get;set;}
      public String sObjectName {get; set;}
      public Boolean isExpanded{get;set;}
      
      public AttachmentDetail()
      {
      	isExpanded = false;
      }
    }
    public class FileDetail
    {
        public String link{get;set;}
        public String name{get;set;}
        public String sep{get;set;}            
    }
}