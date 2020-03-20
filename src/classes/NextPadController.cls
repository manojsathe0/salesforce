public with sharing class NextPadController
{
    
    public String processingNumber{get;set;}
    public String customerOrderNumber{get;set;}
    public String description{get;set;}
    public NextPadService theNextPadService{get;set;}  
    public String selectedNoteType{get;set;}
    public String productName{get;set;}
    public String productLine{get;set;}
    public String contactState{get;set;}
    public String processingStatus{get;set;}
    public Id contactId{get;set;}
    public String orderId{get;set;}
    public String orderNumber{get;set;}
   
    public Map<String,NoteWrapper> objectIdToWrapper{get;set;}
    
    public String sortOrder{get;set;}
    public String filterNoteType{get;set;}
    
    public transient List<NoteWrapper> allNotes{get;set;}
    public String userSortOrder{get;set;}
    private final Order_Item__c theItem;
    public Boolean showEdit{get;set;}
    final  static String NO_EDIT = 'noEdit';
    public String orderItemId{get;set;}
    public String stateOfFormation{get;set;}
    final static String BUSINESS_FORMATIONS = 'Business Formations';
	public Boolean getIsClassic() {
    	return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    public NextPadController(ApexPages.StandardController stdController) 
    {
         
        showEdit = true;
        theNextPadService = new NextPadService();
        filterNoteType = NextPadService.ALL;
        sortOrder = NextPadService.DESC_ORDER;
        userSortOrder = '';   
        if(stdController.getRecord() != null)
        {
            orderItemId = stdController.getId();
            for(Order_Item__c theItem : [SELECT Id , User_Order_ID__c FROM Order_Item__c WHERE Id = :stdController.getId()])
            {
                processingNumber = theItem.User_Order_ID__c;
                
            }
            if(orderItemId != null)
                showEdit = false;//don't show NextPadEdit Section inside Salesforce
        }
        Map<String, String> currentParams = ApexPages.currentPage().getParameters();
        if(currentParams.containsKey(NextPadService.PROCESS_NUMBER))
        {
           processingNumber = currentParams.get(NextPadService.PROCESS_NUMBER);
           
        }
        //Story B-19202 SF Archival Ledger Update - Added customerOrderNumber to parse the parameter and use to 
        //get Order details in case of no Order items due to archival - 
        if(currentParams.containsKey(NextPadService.ORDER_NUMBER))
        {
           customerOrderNumber = currentParams.get(NextPadService.ORDER_NUMBER);
           
        }
        system.debug ('customerOrderNumber:'+customerOrderNumber);
        if((processingNumber != null && processingNumber != '0' && processingNumber != '') || orderItemId != null || customerOrderNumber !=null)
        {
            theNextPadService.processingNumber = processingNumber;
            theNextPadService.customerOrderNumber = customerOrderNumber;
            theNextPadService.populateAllInformationByProcessingNumber(processingNumber , orderItemId, customerOrderNumber);
            allNotes = theNextPadService.noteWrappers;
            sortNotes();         
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Order note cannot be entered since there is no processing number'));
        }
    
    }
    public PageReference Save()
    {
        return null;
    }
  
    public PageReference SaveNote()
    {
               
        if(description == '' || description == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter description'));
        }
        else
        {
            processingNumber = theNextPadService.processingNumber;
            orderNumber = theNextPadService.orderNumber;
            orderId = theNextPadService.orderId;
            productLine = theNextPadService.productLine;
            contactState = theNextPadService.contactState;
            processingStatus = theNextPadService.processingStatus;
            stateOfFormation = theNextPadService.stateOfFormation;
            contactId = theNextPadService.contactId;
            productName = theNextPadService.productName;
       
            if(selectedNoteType == NextPadService.ORDER_NOTE)
            {
                
                createOrderNotes(description);
                description = '';
                //Create Order Activity
            }
            else if(selectedNoteType == NextPadService.PROBLEM_ORDER)
            {
                createCase(description);
                description = '';
                //Create Case
            }
        }
        populateAllNotes(); 
        sortNotes();
        return null;
    }

    public PageReference clear()
    {
        description = '';
        populateAllNotes();
        sortNotes(); 
        return null;
    }

  
  
      //Needs to create Activity
    public void createOrderNotes(String description)
    {
        Task theTask = new Task();
        theTask.Description = description;
        theTask.WhatId = orderId;
        theTask.Subject = NextPadService.ORDER_NOTE;
        theTask.Status = 'Completed';
        theTask.ActivityDate = Date.today();
        theTask.Type = 'Note';
        theTask.User_Order_ID__c = processingNumber;
        
        try
        {
            insert theTask;//TODO-Error Handling
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Order Note Created'));
        }
        catch(DMLException dmlEx)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Failed Creating Order Note'));
        }
    }

    public void createCase(String description)
    {
        Case theCase = new Case();
        String theState = '';
        if(productline == BUSINESS_FORMATIONS && (stateOfFormation != null && stateOfFormation != ''))
            theState = stateOfFormation;
        else
            theState = contactState;

        theCase.Subject = processingNumber+' - '+productName+' - '+theState;
        theCase.description = description;
        theCase.Processing_Number__c = processingNumber;
        theCase.Order_Number__c = orderNumber;
        theCase.Processing_Status__c = processingStatus;
        theCase.Origin = 'Fulfillment';
        theCase.ContactId = contactId;
        
        if(productLineToQueueName.containsKey(productLine))
            theCase.Queue__c = productLineToQueueName.get(productLine);
        else
            theCase.Queue__c = 'CC General Support';
        try
        {
            insert theCase;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Case Created'));

        }
        catch(DMlException dmlEx)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Failed Creating Case '+dmlEx.getMessage()));
        }
    }


    public void populateAllNotes()
    {
       
        theNextPadService.populateAllInformationByProcessingNumber(processingNumber ,orderItemId, customerOrderNumber);
        allNotes = theNextPadService.noteWrappers;
    }
    
    public void sortNotesByDateTime()
    {
        
        userSortOrder = '';
      
        NoteWrapper.SORT_FIELD = NoteWrapper.SortField.DateTimeCreated;
        if(sortOrder == NextPadService.DESC_ORDER)
            NoteWrapper.SORT_DIR = NoteWrapper.SortDirection.DESCENDING;
        else
            NoteWrapper.SORT_DIR = NoteWrapper.SortDirection.ASCENDING;
        
        if(allNotes == null)
            populateAllNotes();
                
        if(allNotes != null)
        {
            allNotes.sort();
            for(NoteWrapper theWrapper : allNotes)
            {
                theWrapper.caseComments.sort();
            }
        }

    }

    public void sortNotesByUser()
    {
        sortOrder = '';
       
        NoteWrapper.SORT_FIELD = NoteWrapper.SortField.Name;
        if(userSortOrder == NextPadService.DESC_ORDER)
            NoteWrapper.SORT_DIR = NoteWrapper.SortDirection.DESCENDING;
        else
            NoteWrapper.SORT_DIR = NoteWrapper.SortDirection.ASCENDING;
        
        if(allNotes == null)
            populateAllNotes();

        if(allNotes != null)
        {
            allNotes.sort();
            for(NoteWrapper theWrapper : allNotes)
            {
                theWrapper.caseComments.sort();
            }
        }   
    }

    public void filterNotes()
    {
        
        theNextPadService.filterNoteType = filterNoteType;
        populateAllNotes();
        sortNotes();
    }
    
   

    public void sortNotes()
    {
        if(sortOrder != '')
            sortNotesByDateTime();
        else if(userSortOrder != '')
            sortNotesByUser();
    }

    public Map<String,String> productLineToQueueName
    {
        get
        {
            if(productLineToQueueName == null)
            {
                productLineToQueueName = new Map<String,String>();
                for(ProductLine_Queue_Map__c theMap : ProductLine_Queue_Map__c.getAll().values())
                {
                    productLineToQueueName.put(theMap.Name , theMap.Queue_Name__c);
                }
                
            }
            return productLineToQueueName;
        }
        set;
    }

}