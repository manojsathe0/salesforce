public without sharing class LogCallCaseController
{
  public Task theTask {get; set;}
  public String lastError {get; set;}
  ApexPages.StandardController theController;
  public Id caseId;
  public String status{get; set;}
  public String resolution{get; set;}
  public String resolutionOther{get; set;}
  public Set<String> EXCLUDE_CASE_STATUS = new Set<String>{'Escalated' , 'Revision Required' , 'Revision Complete' , 'Closed – First Response' , 'Ready for Retest' , 'Open' , 'New' , 'Updated by Customer'};
  public Set<String> EXCLUDE_PROBLEM_RESOLUTION_NOT_CLOSED = new Set<String>{'Unresolved – Auto Closed' , 'Unresolved – Internal LZ research required' , 'Resolved – Revision Placed on LZ.com' , 'Unresolved – Initial Email Sent' , 'Unresolved – 2nd Email Sent'};
  public Set<String> INCLUDE_PROBLEM_RESOLUTION_RESEARCHING = new Set<String>{'Unresolved – Internal LZ research required' , 'Unresolved – Other'};

  public LogCallCaseController(ApexPages.StandardController controller) 
  {
    theController = controller;
    theTask = new Task();
    caseId = theController.getRecord().Id;    
    lastError = '';
  }
  
  public List<SelectOption> getCaseStatus()
    {
      List<SelectOption> picklistOptions = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
       List<Schema.PicklistEntry> statusPicklist = fieldResult.getPicklistValues();
       picklistOptions.add(new SelectOption('','--None--'));     
       for( Schema.PicklistEntry theValue : statusPicklist)
       {
        if(!EXCLUDE_CASE_STATUS.contains((theValue.getLabel())))
          picklistOptions.add(new SelectOption(theValue.getLabel(), theValue.getValue()));
       }       
       return picklistOptions;
    }

    public List<SelectOption> getCaseProblemResolution()
    {
      List<SelectOption> picklistOptions = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Case.Problem_Order_Resolution__c.getDescribe();
       List<Schema.PicklistEntry> statusPicklist = fieldResult.getPicklistValues();
        picklistOptions.add(new SelectOption('','--None--'));
      
      if(status == 'Waiting on Customer')
       for( Schema.PicklistEntry theValue : statusPicklist)
       {
          if(!EXCLUDE_PROBLEM_RESOLUTION_NOT_CLOSED.contains(theValue.getLabel()) && !theValue.getLabel().contains('Resolved'))
            picklistOptions.add(new SelectOption(theValue.getLabel(), theValue.getValue()));
       }
       if(status == 'Closed')
          for( Schema.PicklistEntry theValue : statusPicklist)
          {
            if(theValue.getLabel() != 'Resolved – Revision Placed on LZ.com'  && !theValue.getLabel().contains('Unresolved') && !theValue.getLabel().contains('Resolved – New Information Provided'))
            {
              picklistOptions.add(new SelectOption(theValue.getLabel(), theValue.getValue()));
            }
          }
      if(status == 'Researching')
        for( Schema.PicklistEntry theValue : statusPicklist)
          {
            if(INCLUDE_PROBLEM_RESOLUTION_RESEARCHING.contains(theValue.getLabel()))
            {
              picklistOptions.add(new SelectOption(theValue.getLabel(), theValue.getValue()));
            }
          }   
       return picklistOptions;
    }

   public PageReference createTask()
   {
       try 
       {
            if(!status.contains(ProblemOrderConstants.CLOSED_STATUS) && resolution.contains('Resolved'))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ProblemOrderConstants.RESOLVED_REASON_ERROR));
            }
                else if(resolution.contains(ProblemOrderConstants.OTHER) && (resolutionOther == '' || resolutionOther == null))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ProblemOrderConstants.RESOLUTION_OTHER_ERROR));
                    }
                    else
                    {
                        Case theCase = new Case(Id = caseId);
                        theCase.Status = status;
                        theCase.Problem_Order_Resolution__c = resolution;
                        theCase.Problem_Order_Other_Reason__c = resolutionOther;            
                        update theCase;

                        CaseComment theComment = new CaseComment();
                        theComment.commentBody = theTask.Description;
                        theComment.ParentId = theCase.Id;
                        insert theComment;

                        theTask.Status = 'Completed';
                        theTask.ActivityDate = Date.today();
                        theTask.WhatId = caseId;
                        theTask.Case_Status__c = status;
                        theTask.Problem_Order_Resolution__c = resolution;
                        theTask.Type = 'Call';
                        theTask.Subject = theTask.Inbound_Outbound__c + ' Activity';
                        theTask.RecordTypeId = CCTaskRecordTypeId;
                        system.debug(theTask.Inbound_Outbound__c+'inbound/outbound');
                        insert theTask;
                        
                        theTask = new Task();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Activity Logged'));
                    }
            
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
        }
        return null;
     }    

public static Id CCTaskRecordTypeId
    {
        get
        {
            if(CCTaskRecordTypeId == null)
            {
                List<RecordType> recordTypes = [SELECT Id , DeveloperName FROM RecordType WHERE sObjectType = 'Task' AND DeveloperName = 'CC_Task'];
                if(!recordTypes.isEmpty())
                    CCTaskRecordTypeId = recordTypes[0].Id;
            }
            return CCTaskRecordTypeId;
        }
        set;
    }

}