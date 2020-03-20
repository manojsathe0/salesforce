global class ComplianceReviewChangeCallIDController 
{
    public static List<Compliance_Review__c> complianceUpdate = new List<Compliance_Review__c>();
    public Compliance_Review__c complianceReviewObj{get; set;}
    public String recordCallId{get; set;}
    public String complianceID{get; set;}
    public boolean IsError {get;set;}
    public string errormessage {get;set;}
    public Pagereference p {get;set;}
    public static final String DUPLICATED_RECORD_CALL_ID_MESSAGE = 'This Recorded Call ID has been used before. Please select another call.';
    public static final String NULL_RECORD_CALL_ID_MESSAGE = 'Please enter value in Record Call ID.';
    public static final String DRAFT_STATUS = 'Draft';
    
    public PageReference save()
    { 
        if(recordCallId !=null && recordCallId != '')
        {
        	//Check Record Call ID# duplicated or not
            if(!isUnique(recordCallId))
	        {
	            showPopup(); 
	            errormessage = DUPLICATED_RECORD_CALL_ID_MESSAGE;  
	        }
	        else
	        {
	            complianceID = ApexPages.currentPage().getParameters().get('ComplianceID');
		        List<Compliance_Review__c> complianceReviewList = [ SELECT Id, Compliance_Review__c.Recorded_Call_ID__c 
															        FROM Compliance_Review__c 
															        WHERE ID =: complianceID AND Compliance_Review__c.Status__c =: DRAFT_STATUS];
		        if(complianceReviewList.size() > 0)
		        {
		            for(Compliance_Review__c comp : complianceReviewList)
		            {
		                if(recordCallId != '')
		                {
		                    comp.Recorded_Call_ID__c = recordCallId;
		                    complianceUpdate.add(comp);
		                }   
		            }
		            update complianceUpdate;
		            //If update complete it will return javascript for close child window
		            return new PageReference('javascript:window.close();');    
		        } 
	        }
        }
        else
        {
        	//Show Popup when input Record Call ID empty or null
            showPopup(); 
            errormessage = NULL_RECORD_CALL_ID_MESSAGE;    
        }
        return null;
    }
    
    private Boolean isUnique(String callId)
    {
        Compliance_Review__c[] lstReviews = [SELECT Id, Recorded_Call_ID__c FROM Compliance_Review__c WHERE Recorded_Call_ID__c = :callId AND Recorded_Call_ID__c != null];
        if(lstReviews.size() > 0)
        {
            complianceReviewObj = lstReviews[0];
            return false;
        }
        else
        {
            return true;
        }
    } 
    
    public void showPopup() 
    {        
        IsError = true; 
    }
    public void closePopup() 
    {        
        IsError = false;    
    }
}