public with sharing class IADUpdateCaseController
{
    
    public String contactId{get;set;}
    public Case theCase{get;set;}
    public Boolean showModal{get;set;}
    public String selectedProduct{get;set;}
    public String selectedtype{get;set;}
    public String selectedStatus{get;set;}
    public String selectedStatusReason{get;set;}
    public List<IAD_Case_Status_Reasons__c> allStatusReasons = new List<IAD_Case_Status_Reasons__c>();
    public static String PROBLEM_TYPE = 'Problem';
    public static String SERVICE_INQUIRY = 'Service Inquiry';
    public final String NONE = '--None--';
    public List<IADMessage> iadMessages{get;set;}
    public String description{get;set;}
    public Boolean isSuccess{get;set;}
    public String queueBeforeUpdate;
    public final String CLOSED = 'Closed'; 
    public final String ASSIGNEDFORRESOLUTION = 'Assigned for Resolution';
    public Boolean isReadOnly{get;set;}
    final static String MOCK_LAUNCH_QUEUE = 'CC Mock Launch Requests';
    public boolean displayPopup {get; set;}
    public boolean updateCase {get; set;}
    
 
    
    public IADUpdateCaseController(ApexPages.StandardController stdController) 
    {   
        isReadOnly = false;
        system.debug('inside constructer');
        iadMessages = new List<IADMessage>();
        theCase  = (Case)stdController.getRecord();
        contactId = theCase.ContactId;
        showModal = false;
        allStatusReasons = [SELECT Status_Reason__c, Product__c, Record_Type__c, Status__c FROM IAD_Case_Status_Reasons__c];
        theCase = [SELECT Id, Product_Line__c,Reason_for_Extreme_Revision__c,POR_Closed_By__c, Status, Status_Reasons__c, Queue__c, Description, RecordTypeId , Assigned_User__c,Processing_Number__c, ContactId,Order_Exception__c FROM Case WHERE ID =: theCase.Id];

        if(theCase.Product_Line__c != null && theCase.Product_Line__c != '')
        for(IAD_Case_Status_Reasons__c theReason : allStatusReasons)
        {
            if(theReason.Product__c == theCase.Product_Line__c)
            {
                selectedProduct = theCase.Product_Line__c;
                isReadOnly = true;
            }

        }

        selectedStatusReason = theCase.Status_Reasons__c;


        queueBeforeUpdate = theCase.Queue__c;

        if(theCase.RecordTypeId != null)
            {
                if(theCase.RecordTypeId == ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE))
                    selectedtype = PROBLEM_TYPE;
                else
                    selectedtype = SERVICE_INQUIRY;
            }

        
       
        if(theCase.Status != null)
            selectedStatus = theCase.Status;
        if(theCase.Status == 'New' || theCase.Status == 'Open')
        {
            selectedStatus = 'LZ Working on Case';
        }
        isSuccess = false;
    }
    public void dismiss()
    {
       
        showModal = false;
        
        IADOpenCasesModalController.logDismissal();
    }
    public void closePopup() {
        displayPopup = false;
    }
   /* public  PageReference updateCaseandclose1(){
        system.debug('in updateCaseandclose');
        updatecase = true;  
     List<Failed_Rules__c> flList = new List<Failed_Rules__c>([SELECT Id, Status__c, Parent_Exception__c, Rule_Type__c,Parent_Case__c FROM Failed_Rules__c WHERE (Parent_Case__C =:thecase.Id OR Parent_Exception__c = :thecase.Order_Exception__c)  AND Rule_Type__c = 'Manual' AND Status__c != 'Resolved' ]);
        //List<Failed_Rules__c>  flBizList = new List<Failed_Rules__c>([SELECT Id, Status__c, Parent_Exception__c, Rule_Type__c,Parent_Case__c FROM Failed_Rules__c WHERE (Parent_Case__C =:thecase.Id OR Parent_Exception__c = :thecase.Order_Exception__c)  AND Rule_Type__c = 'Business Rule' AND Status__c ='Active' ]);
       system.debug('fllis is  ' + flList.size());
        If(flList.size() >0 ) {
            
            thecase.Status  ='LZ Working on Case';
            thecase.Status_Reasons__c='Assigned for Customer Outreach';
            thecase.Assigned_User__c=null;
			//theCase.POR_Closed_By__c = UserInfo.getUserId();
            update thecase;
            closePopup();  
            iadMessages.add(IADMessageFactory.createMessage('success' , 'Case Updated!!'));
            showModal = true;
            isSuccess = true;
            POR_ExceptionAPIService.reopenCase(theCase.Id);
            
        }
        else{
                  
            updateCase();
            closePopup();
       }

        return null;
      //return null;
    }*/
    public  PageReference updateCaseandclose(){
        system.debug('in updateCaseandclose');
        updatecase = true;     
        try{
             updateCase();
            closePopup();
       	 	CaseService.ccCaseClosure(thecase.Id, thecase.Processing_Number__c);
        }
               
         catch(DMLEXception dmlEx)
        {

            iadMessages.add(IADMessageFactory.createMessage('error' , 'Failed Updating Case'+dmlEx));
            
        }
           
	
        return null;
      //return null;
    }
   
    
    
    
    
    public PageReference updateCase()
    {
       
        iadMessages.clear();
        if(selectedProduct==null || selectedProduct == '' )
        {
            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must Select a Product'));
            return null;
        }

        if(description == null || description == '')
        {
             iadMessages.add(IADMessageFactory.createMessage('error' , 'Enter the description'));
             return null;
        }
        //Padma @ B-28486 
        if(updateCase != true && selectedStatus == 'Closed' && (selectedStatusReason != 'Revision Placed for Customer' && selectedStatusReason != 'Order Cancelled' ) && theCase.Order_Exception__c != null){
            displayPopup = true;  
            theCase.POR_Closed_By__c = UserInfo.getUserId();
             return null;
        }
        
        //Padma @B-28486 EOC 
        system.debug(queueBeforeUpdate+'---'+theCase.Queue__c);
        if(queueBeforeUpdate != theCase.Queue__c)
        {
            theCase.Assigned_User__c = null;
        }
        else
        {
            if(theCase.Queue__c != MOCK_LAUNCH_QUEUE)// don't change Assigned User if the Case is in Mock Launch Request Queue
            {
                theCase.Assigned_User__c = UserInfo.getUserId();
            }
        }


        if(queueBeforeUpdate == theCase.Queue__c && theCase.Status_Reasons__c != ASSIGNEDFORRESOLUTION && selectedStatusReason == ASSIGNEDFORRESOLUTION)
        {
            iadMessages.add(IADMessageFactory.createMessage('error' , 'Queue should be changed if status reason is Assigned for Resolution'));
            return null;
        }
        
        
    
        isSuccess = false;
        theCase.Product_Line__c = selectedProduct;
        if(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE.contains(selectedtype))
            theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
        theCase.Status = selectedStatus;
        theCase.Status_Reasons__c = selectedStatusReason;
       
       
        try
        {
            system.debug(theCase);
            update theCase;
            theCase = [SELECT Id , Contact.Genesys_Interaction_Id__c , Reason_for_Extreme_Revision__c , Status, Status_Reasons__c , Processing_Number__c, ContactId , Queue__c ,Order_Exception__c FROM Case WHERE Id = :theCase.Id];
            IADCaseHelper.createActivityForCaseUpdate(theCase , description);
            system.debug('updatedtheCase ' );
            iadMessages.add(IADMessageFactory.createMessage('success' , 'Case Updated!!'));
            showModal = true;
            isSuccess = true;
            
        }
        catch(DMLEXception dmlEx)
        {

            iadMessages.add(IADMessageFactory.createMessage('error' , 'Failed Updating Case'+dmlEx));
            if(UtilityLibrary.sendEmail)
                SendExceptionEmail.sendExceptionEmail(dmlEx , 'IAD Exception');
        }
        return null;
    }

     public List<selectOption> getproducts()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Case_Status_Reasons__c.Product__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        system.debug(pickListValues);
        if(selectedProduct == null || selectedProduct == '')
            options.add(new SelectOption('', 'Please select a product'));
        for( Schema.PicklistEntry value : pickListValues)
           {
              if(value.getLabel() == selectedProduct || selectedProduct == ''|| selectedProduct == null)
                options.add(new SelectOption(value.getLabel(), value.getValue()));
           }    
        system.debug(options);  
        return options;
    }  

    public List<selectOption> getStatus()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Case_Status_Reasons__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : pickListValues)
        {
         if(value.getLabel() != 'Problem')
          options.add(new SelectOption(value.getLabel(), value.getValue()));
        }       
        return options;
    }

    public List<selectOption> getTypes()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Case_Status_Reasons__c.Record_Type__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : pickListValues)
        {
          if(value.getLabel() == selectedtype)
            options.add(new SelectOption(value.getLabel(), value.getValue()));
       }       
        return options;
    }

    public List<selectOption> getStatusReasons()
    {
        List<selectOption> options = new List<selectOption>();
        if(selectedProduct == null || selectedProduct == '')
                     options.add(new SelectOption('', 'Please select a product to see status reasons'));
        system.debug(allStatusReasons);
        for(IAD_Case_Status_Reasons__c theReason : allStatusReasons)
        {
            system.debug(theReason.Product__c + '---' + theReason.Record_Type__c + '---' + theReason.Status__c+'---'+theReason.Status_Reason__c+'---'+theReason.Id);
            system.debug(selectedProduct+'---'+selectedtype+'----'+selectedStatus);

            if(theReason.Product__c == selectedProduct && theReason.Record_Type__c == selectedtype && theReason.Status__c == selectedStatus)
            {
                system.debug('Inside');
                for(String theStatusReason : theReason.Status_Reason__c.Split(';'))
                 options.add(new SelectOption(theStatusReason, theStatusReason));
            }
        }

        //if(selectedStatus == 'Escalated')
            //theCase.Queue__c = 'CC Manager Call-Back';

        system.debug(options);
        return options;
    }
    
   
    
}