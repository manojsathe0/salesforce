public with sharing class IADCaseHelper {
   
     public static void createActivityForCaseInsert(Case theCase , String description)
   {
       createActivity(theCase , description , false);
       if(theCase.Status == 'Closed')
           theCase.Closed_When_Opened__c = true;
            
       update theCase;
   }
   
   public static void createActivityForCaseUpdate(Case theCase , String description)
   {
       createActivity(theCase , description , true);
   }
    public static void createActivity(Case theCase , String description , Boolean isCreateComment)
    {   
        Recordtype ccRecType = [select id, name from recordtype where sobjecttype = 'Task' and name = 'CC Task' limit 1];
        Task theTask = new Task();
        theTask.CallObject = theCase.Contact.Genesys_Interaction_Id__c ;
        theTask.Subject = 'Case Activity';
        theTask.Status = 'Completed';
        theTask.Case_Status__c = theCase.Status;
        theTask.Status_Reasons__c = theCase.Status_Reasons__c;
        theTask.whatId = theCase.Id;
        theTask.whoId = theCase.ContactId;
        theTask.Case_Status__c = theCase.Status;
        theTask.recordtype = ccRecType;
        theTask.Description = description;
        
        insert theTask;
        if(isCreateComment)
        {
            CaseComment theComment = new CaseComment();
            theComment.commentBody = theTask.Description;
            theComment.ParentId = theCase.Id;
            insert theComment;
        }        
      
    }
    
}