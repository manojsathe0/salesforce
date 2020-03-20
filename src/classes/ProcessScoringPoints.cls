public without sharing class ProcessScoringPoints{
    public MAP<string, string> pageParameters;
     public static final string EMAIL = 'unknown@unknown.com';
    public PageReference processUrlParameters()
     {
        pageParameters = ApexPages.currentPage().getParameters();
        system.debug(pageParameters);
        PageReference pageToSend = Page.ScoringPointsResult;
          Id recordId;
          DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        if(pageParameters != null)
        {
            try
            {
                    Lead theLead = new Lead();
                    if(pageParameters.containsKey('user_fname'))
                        theLead.FirstName = pageParameters.get('user_fname');
                    if(pageParameters.containsKey('user_lname'))
                         theLead.LastName = pageParameters.get('user_lname'); 
                    if(pageParameters.containsKey('user_email')  && !String.isBlank(pageParameters.get('user_email')) && pageParameters.get('user_email')!= null)
                         theLead.Email = pageParameters.get('user_email');
                    if(pageParameters.containsKey('formation_state'))
                         theLead.State_of_Formation__c = pageParameters.get('formation_state');
                    if(pageParameters.containsKey('business_phone') && !String.isBlank(pageParameters.get('business_phone')) && pageParameters.get('business_phone')!= null)
                         theLead.Phone = pageParameters.get('business_phone');
                    if(pageParameters.containsKey('tealium_id') && !String.isBlank(pageParameters.get('tealium_id')) && pageParameters.get('tealium_id')!= null)
                         theLead.Tealium_Id__c = pageParameters.get('tealium_id');
                    if(pageParameters.containsKey('user_id') && !String.isBlank(pageParameters.get('user_id')) && pageParameters.get('user_id') != null)
                         theLead.FkUser__c = pageParameters.get('user_id');
                    system.debug(theLead);
                    if(pageParameters.containsKey('active_processing_id'))
                        theMessage.userOrderId = pageParameters.get('active_processing_id');//store active proceesing id
                    recordId = DuplicateChecker.getLeadOrContact(theLead , theMessage);
                    system.debug(recordId);
                    insert createScoringPoints(recordId);
                  
                    pageToSend.getParameters().put('Result','Success');
            }
            catch(DmlException exp)
            {
                

                system.debug(exp);
                pageToSend.getParameters().put('Result','Failed');
                pageToSend.getParameters().put('error',exp.getMessage());
                SendExceptionEmail.sendDMLExceptionEmail(exp, 'Error In creating Lead Scoring Points from Tealium');
        
            }   
        }
        
        logRequest(recordId , theMessage);                                                                                             
        return pageToSend;
     }

     public void logRequest(Id recordId , DuplicateChecker.MessageInfo theMessage)
     {
        
        String theId = recordId;
        Tealium_Request__c theRequest = new Tealium_Request__c();
        if(recordId != null)
        {
            if(theId.startsWith('003'))
            {
                theRequest.Contact__c = recordId;

            }
            else
            {
                theRequest.Lead__c = recordId;
            }
        }
        String keyValuePairs = '';
        for(String theKey : pageParameters.keySet())
        {
            keyValuePairs += theKey +'='+pageParameters.get(theKey)+',';
        }
        theRequest.Request_Body__c = keyValuePairs;
        theRequest.Matched_Field__c = theMessage.matchedField;
        theRequest.User_Order_Id__c = theMessage.userOrderId;
        insert theRequest;
            
     }

     public List<Lead_Attribute__c> createScoringPoints(ID objectId)
     {
        List<Lead_Attribute__c> scoringPointsToInsert = new List<Lead_Attribute__c>();
        for(Lead_Scoring_Bucket_Criteria__c bucketCriteria : [Select Name, Active__c From Lead_Scoring_Bucket_Criteria__c Where Active__c = True And Name In : pageParameters.keySet()]) // include pageParameter
        {
               system.debug(bucketCriteria+'point :'+pageParameters.get(bucketCriteria.Name));
            if(pageParameters.containsKey(bucketCriteria.Name))
               {
                    if(pageParameters.get(bucketCriteria.Name) != null && !String.isBlank(pageParameters.get(bucketCriteria.Name)))
                     {
                         Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                         scoringPoint.Name = bucketCriteria.Name;
                         scoringPoint.Value__c = pageParameters.get(bucketCriteria.Name);
                         if(SendToCustomEmailController.findObjectName(objectId) == SendToCustomEmailController.LEAD)
                             scoringPoint.Lead__c = objectId;
                         else
                             scoringPoint.Contact__c = objectId;
                         scoringPointsToInsert.add(scoringPoint);
                         system.debug(scoringPointsToInsert+'ScoringPoints');
                     }
               }
        }
        return scoringPointsToInsert;

     }
}