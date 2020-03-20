public with sharing class CT_WebToCase_Model
{
    private String CLASSNAME = '\n\n**** CT_WebToCase_Model.@@METHODNAME()';
    
    public Case NewCase {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String OrderSubmitted {get;set;}
       
    public User CurrentUser{get; private set;}
    
    public transient Blob fileAttachmentBody {get; set;}
    public transient String fileAttachmentName {get; set;}
    public transient String fileAttachmentContentType {get; set;}
    
    // list of new attachments to add
    public list<Attachment> newAttachments {get; set;}
    public list<String> attachmentFileNames {get; set;}
    public Attachment fileAttachment{get; set;}
    
    // the number of new attachments to add to the list when the user clicks 'Add More'
    public static final Integer NUM_ATTACHMENTS_TO_ADD=1;
    
    private CaseAttachment__c caseAttObj = null;

    //@author : CloudTrigger, Inc.
    //@date : 11/18/2011
    //@description : method to 
    //@paramaters : none
    //@returns : nothing
    public static CT_WebToCase_Model NewModel(String pUserId)
    {
        CT_WebToCase_Model newModel = new CT_WebToCase_Model(pUserId);
        return newModel;
    }

    //@author : CloudTrigger, Inc.
    //@date : 11/18/2011
    //@description : method to 
    //@paramaters : none
    //@returns : nothing
    private CT_WebToCase_Model(String pUserId)
    {
        NewCase = new Case();
        caseAttObj = new CaseAttachment__c();
        NewCase.RecordTypeId = CT_Utility.GetRecordTypeIdBySobjectTypeAndRecordTypeName('Case', 'Web Case');
        OrderSubmitted = 'N';
        if(!CT_Utility.StringIsNullOrEmpty(pUserId))
        	CurrentUser = [SELECT Id, Username, Email, Name, FirstName, LastName FROM User WHERE Id = :pUserId];
        else
        	CurrentUser = new User();
        

        // instantiate the list with a single attachment
        newAttachments = new list<Attachment>();
        attachmentFileNames = new list<String>(); 
        fileAttachment = new Attachment();
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 12/17/2011
    //@description : method to add set the Case WebName from the First and Last name properties
    //@paramaters : none
    //@returns : nothing
    private void SetCaseWebName()
    {
    	if(!CT_Utility.StringIsNullOrEmpty(FirstName) && !CT_Utility.StringIsNullOrEmpty(LastName))
    	{
    		NewCase.SuppliedName = FirstName + ' ' + LastName;
    	}
    	else if(!CT_Utility.StringIsNullOrEmpty(FirstName))
    	{
    		NewCase.SuppliedName = FirstName;
    	}
    	else if(!CT_Utility.StringIsNullOrEmpty(LastName))
    	{
			NewCase.SuppliedName = LastName;
    	}
    }

    private void SetContact()
    {
        if(!CT_Utility.StringIsNullOrEmpty(NewCase.SuppliedEmail))
        {
           List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :NewCase.SuppliedEmail limit 1];
           if(!contacts.isEmpty())
                NewCase.ContactId = contacts[0].Id; 
        }
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 12/17/2011
    //@description : method to set the Case Order_Submitted__c to true or false
    //@paramaters : none
    //@returns : nothing
    private void SetOrderSubmitted()
    {
    	if(OrderSubmitted == 'Y')
    	{
    		NewCase.Order_Submitted__c = true;
    	}
    	else
    	{
    		NewCase.Order_Submitted__c = false;
    	}
    }

    //@author : CloudTrigger, Inc.
    //@date : 11/30/2011
    //@description : method to add more attachments
    //@paramaters : none
    //@returns : nothing
    public void AddMoreAttachments()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'AddMoreAttachments');
		system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');		
			
		if(!CT_Utility.StringIsNullOrEmpty(fileAttachmentName))
		{
			attachmentFileNames.add(fileAttachmentName);
			
			if(caseAttObj == null) {
				caseAttObj = new CaseAttachment__c();
			}
        	upsert caseAttObj;
			
            if (fileAttachmentBody != null)
            {
            	
            	Attachment newAttachment = new Attachment();
            	newAttachment.Name = fileAttachmentName;
            	newAttachment.Body = fileAttachmentBody;
                newAttachment.parentId = caseAttObj.Id;
            	newAttachment.ContentType = fileAttachmentContentType;
                insert newAttachment;
            }
            
			
			
			//newAttachments.add(fileAttachment);
			//fileAttachment = new Attachment();
		}
    }

    //@author : CloudTrigger, Inc.
    //@date : 11/18/2011
    //@description : method to 
    //@paramaters : none
    //@returns : nothing
    public void SaveAll()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'SaveAll');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');

        //Savepoint sp = Database.setSavepoint();
        try
        {        
        	SetCaseWebName();
        	SetOrderSubmitted();
            SetContact();
        		
        	Database.DMLOptions dmo = new Database.DMLOptions();
			dmo.assignmentRuleHeader.useDefaultRule= true;
			NewCase.setOptions(dmo);

            Database.SaveResult srCase = Database.insert(NewCase);
            
            if(srCase.isSuccess())
            {
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: Case insert was SUCCESSFUL.\n\n');
                
                //Case nCase = [Select Id From Case Where Id = :srCase.getId()];
            	
            	//add remaining attachments to newAttachment list
            	AddMoreAttachments();
            	
            	if(caseAttObj != null && caseAttObj.Id != null) {
	            	caseAttObj.Related_Case__c = srCase.getId();
	            	update caseAttObj;
	            	Database.executeBatch(new BatchAssociateAttachments(caseAttObj));
            	}
            	
                //newAttachments.clear();
                //newAttachments = new list<Attachment>();
                //newAttachments.add(new Attachment());
                //Use Future

            }else{
            	if(caseAttObj != null) {
            		delete caseAttObj;
            	}
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: Case insert FAILED.\n\n');
                throw CT_BaseApplicationException.NewException(METHODNAME, 'Case insert FAILED!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.');
            }
        }
        catch(CT_BaseApplicationException bex)
        {
            //Database.rollback(sp);
            throw bex;
        }
        catch(DMLException dmle)
        {
            //Database.rollback(sp);
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION BEG ********************************\n');
            for (Integer i=0; i < dmle.getNumDml(); i++)
            {
                system.debug(LoggingLevel.INFO,'\n' + dmle.getDmlMessage(i) + '\n');
            }
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION END ********************************\n');
            
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'DML Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', dmle);
        }
        catch(Exception e)
        {
            //Database.rollback(sp);
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', e);
        }
    }

}