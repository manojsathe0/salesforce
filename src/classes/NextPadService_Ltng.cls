/*
Migration of NextPad functionality to Salesforce
Story: B-26835
By Artyom M.
*/


public without sharing class NextPadService_Ltng {
    
    @AuraEnabled public List<NoteWrapper_Ltng> noteWrappers{get;set;}
    public final static String CASE_COMMENT = 'Case Comment';
    public final static String THE_CASE = 'Case';
    public final static String ORDER_NOTE = 'Order Note';
    public final static String COMMENT = 'Comment';
    public final static String PROBLEM_ORDER = 'Problem Order';
    public final static String PROCESS_NUMBER = 'processingNumber';
    public final static String ORDER_NUMBER = 'CustomerOrderNumber';
    public final static String DESC_ORDER = 'desc';
    public final static String ASC_ORDER = 'asc';
    public final static String ALL = 'all';
    public final static String ACTIVITY = 'Activity';
    final static String NONE = '--None--';
    public Id orderId{get;set;}
    public String orderNumber{get;set;}
    public String processingNumber{get;set;}
    public String customerOrderNumber{get;set;}
    public String filterNoteType{get;set;}
    public String customerName{get;set;}
    List<Case> cases;
    List<Task> allOrderActivities;
    public String productName{get;set;}
    public String productLine{get;set;}
    public String contactState{get;set;}
    public String processingStatus{get;set;}
    public Id contactId{get;set;}
    public static final String SALESFORCE_BASED_URL = 'Salesforce Based URL'; 
    public String tsid{get;set;}
    public String hostURL{get;set;}
    public String escapedCustomerName{get;set;}
    public Map<Id,Boolean> caseIdToIsGeneral{get;set;}
    public Map<Id,Boolean> orderNoteToIsGeneral{get;set;}
    
    public Set<Id> orderIds{get;set;}
    public String stateOfFormation;

    public NextPadService_Ltng() 
    {
        allOrderActivities = new List<Task>();
        cases = new List<Case>(); 
        filterNoteType = ALL;
        noteWrappers = new List<NoteWrapper_Ltng>();
        getTSID();
        getHostURL();
        caseIdToIsGeneral = new Map<Id,Boolean>();
        orderNoteToIsGeneral = new Map<Id,Boolean>();
        orderIds = new Set<Id>();
    }

    //Pulls Cases,Comments and Order Activities by processing Number
    //Story B-19202 SF Archival Ledger Update - Added customerOrderNumber to parse the parameter and use to 
    //get Order details in case of no Order items due to archival -  
 
    public void populateAllInformationByProcessingNumber(String theProcessingNumber , String orderItemId, String thecustomerOrderNumber)
    {
                    
        if((theProcessingNumber == '' || theProcessingNumber == null || theProcessingNumber == '0') && orderItemId == null && thecustomerOrderNumber == null)
            return;    
            
        processingNumber = theProcessingNumber;
        customerOrderNumber = thecustomerOrderNumber;
        if(orderIds.isEmpty())
            populateOrderInformation(processingNumber , orderItemId, customerOrderNumber);
        
        
        allOrderActivities = getActivitiesByOrderIds(orderIds);
        Set<Id> caseIds = getAllCasesIds();
        if(!caseIds.isEmpty())
            cases = getCasesByCaseIdFilterByOrderAndProcessingNumber(caseIds);
        //do empty check    
        populateNotesWrappers();
        
    }


    public void populateNotesWrappers()
    {
        noteWrappers = new List<NoteWrapper_Ltng>();
        Map<Id,User> userIdToName = getUserIdToName(getUserIds(cases,allOrderActivities));
        for(Case theCase : cases)
        {
            if(filterNoteType == THE_CASE || filterNoteType == ALL)
            {
                Boolean isGeneral = false;
                if(caseIdToIsGeneral.containsKey(theCase.Id))
                    isGeneral = true;

                NoteWrapper_Ltng theWrapper = createNoteWrapper(theCase.Id , theCase.CreatedDate , userIdToName.get(theCase.CreatedById).Name , THE_CASE , theCase.Status ,  theCase.Subject , theCase.Description ,  THE_CASE , theCase.CaseNumber , null , isGeneral);
                noteWrappers.add(theWrapper);
                if(!theCase.caseComments.isEmpty())
                {
                    
                    for(CaseComment theComment : theCase.CaseComments)
                    {
                        
                        NoteWrapper_Ltng commentWrapper = createNoteWrapper(theComment.Id , theComment.CreatedDate , userIdToName.get(theComment.CreatedById).Name , CASE_COMMENT , null ,  null , theComment.commentBody , COMMENT , null , null , isGeneral);
                        theWrapper.caseComments.add(commentWrapper);
                    }
                }
                
            }
        }
        //Activities under the Order
        for(Task theTask : allOrderActivities)
        {
            
            if(filterNoteType == ORDER_NOTE || filterNoteType == ALL)
            {
                Boolean isGeneral = false;
                if(orderNoteToIsGeneral.containsKey(theTask.Id))
                    isGeneral = true;
                DateTime taskDateTime;
                if(theTask.Datetime_Created_External_System__c != null)
                {
                    taskDateTime = theTask.Datetime_Created_External_System__c;
                }
                else
                    taskDateTime = theTask.CreatedDate;

                NoteWrapper_Ltng theWrapper = createNoteWrapper(theTask.Id , taskDateTime , userIdToName.get(theTask.CreatedById).Name , ORDER_NOTE , theTask.Status ,  theTask.Subject , theTask.Description , ORDER_NOTE , null , theTask.User_Order_ID__c ,isGeneral);
                noteWrappers.add(theWrapper);
                
            }
        }
        System.debug('after populateNotesWrappers: ' + noteWrappers.size());
        
    }


    public Set<Id> getAllCasesIds()
    {
        Set<Id> caseIds = new Set<Id>();
        Set<String> processingNumbers = new Set<String>();
        if(processingNumber != null && processingNumber != '' && processingNumber != '0') // B-21649 Padma modified for 0 processingnumber
            processingNumbers.add(processingNumber);

        for(Order_Case__c theOrderCase : [SELECT Case__c FROM Order_Case__c WHERE Order__c IN :orderIds OR User_Order_ID__c IN: processingNumbers])
        {
            caseIds.add(theOrderCase.Case__c);
        }
        if(orderNumber != '' && orderNumber != null )
        {
            for(Case theCase : [SELECT Id FROM Case WHERE Processing_Number__c IN :processingNumbers OR Order_Number__c = :orderNumber])
            {
                caseIds.add(theCase.Id);
            }
        }
        else
        {
            for(Case theCase : [SELECT Id FROM Case WHERE Processing_Number__c IN :processingNumbers])
            {
                caseIds.add(theCase.Id);
            }
         
        }
        return caseIds;
    }


    public Set<Id> getUserIds(List<Case> cases , List<Task> allOrderActivities)
    {
        Set<Id> userIds = new Set<Id>();
        for(Case theCase : cases)
        {
            for(CaseComment theComment : theCase.CaseComments)
            {
                userIds.add(theComment.CreatedById);
            }
            userIds.add(theCase.CreatedById);
        }
        for(Task theTask : allOrderActivities)
        {
            userIds.add(theTask.CreatedById);
        }
        return userIds;
    }


    public NoteWrapper_Ltng createNoteWrapper(String theObjectId , DateTime theDateTime , String theName  , String theType ,  String theStatus , String theSubject , String theDescription , String theInfoType , String theCaseNumber , String theProcessingNumber , Boolean theIsGeneral)
    {
        return new NoteWrapper_Ltng(theObjectId , theDateTime , theName , theType , theStatus , theSubject , theDescription , theInfoType , theCaseNumber , theProcessingNumber , theIsGeneral);
    }


    public Map<Id,User> getUserIdToName(Set<Id> allUserIds)
    {
        return new Map<Id,User>([SELECT Id , Name FROM User WHERE Id IN : allUserIds]);
    }


    public List<Case> getCasesByCaseIdFilterByOrderAndProcessingNumber(Set<Id> caseIds)
    {
       
        List<Case> casesToConsider = new List<Case>();
        List<Case> cases =  [SELECT Id , Description , CreatedById , CreatedDate , LastModifiedDate ,Status ,  Subject , Order_Number__c  , Processing_Number__c, CaseNumber, 
                (SELECT Id , commentBody , CreatedDate , CreatedById ,LastModifiedDate  FROM CaseComments ORDER By LastModifiedDate DESC) FROM Case WHERE Id IN :caseIds];
        for(Case theCase : cases)
        {
            Set<String> orderNumbers = new Set<String>();
            if(theCase.Order_Number__c != null)
            {
                 for(String theOrderNumber : theCase.Order_Number__c.split(','))
                 {
                    orderNumbers.add(theOrderNumber);
                 }
            }
            Set<String> processingNumbers = new Set<String>();
            if(theCase.Processing_Number__c != null)
            {
                for(String theProcessingNumber : theCase.Processing_Number__c.split(','))
                {
                    processingNumbers.add(theProcessingNumber);
                }
            }
            if((orderNumbers.contains(orderNumber) && processingNumbers.isEmpty()) || processingNumbers.contains(processingNumber))
            {
                if((orderNumbers.contains(orderNumber)) && processingNumbers.isEmpty())
                {
                    caseIdToIsGeneral.put(theCase.Id , true);
                }
                casesToConsider.add(theCase);
            }
            
        }
        return casesToConsider;
    }
    

    public List<Task> getActivitiesByOrderIds(Set<Id> orderIds)
    {
        
        Map<Id,Task> tasksToConsider = new Map<Id,Task>();
        for(Task theTask : [SELECT Id, Type , Description , User_Order_ID__c , CreatedDate , LastModifiedDate , CreatedById , Subject , Status , Datetime_Created_External_System__c  FROM Task WHERE WhatId IN :orderIds 
                AND (User_Order_ID__c = :processingNumber OR User_Order_ID__c = null)])
        {
            tasksToConsider.put(theTask.Id , theTask);
            if(theTask.User_Order_ID__c == null)
                orderNoteToIsGeneral.put(theTask.Id , true);
        }
        if(processingNumber != null && processingNumber != '' && processingNumber != '0' ) // B-21649 Padma modified for 0 processingnumber
        {
            for(Task theTask : [SELECT Id, Type , Description , User_Order_ID__c , CreatedDate , LastModifiedDate , CreatedById , Subject , Status , Datetime_Created_External_System__c  FROM Task WHERE User_Order_ID__c = :processingNumber])
            {
                if(!tasksToConsider.containsKey(theTask.Id))
                {
                    tasksToConsider.put(theTask.Id , theTask);
                }
            }
        }
        return tasksToConsider.values(); 
    }   


    public void populateOrderInformation(String theProcessingNumber , String orderItemId, String thecustomerOrderNumber)
    {
      
        List<Order_Item__c> orderItems = new List<Order_Item__c>();
        List<Order__c> ordersIncaseNoOrderItems = new List<Order__c>();
        //If it comes with Order Item Id (On Standard SF Page , comes with Order Item Id) try to find ProcessingNumber.We can have multiple order items on different order with Same Processing Number
        if(orderItemId != null)
        {
            orderItems = [SELECT Id , Order__c , User_Order_ID__c ,
            Product__c , User_Order_Extension__c FROM Order_Item__c WHERE Id = :orderItemId ORDER BY LastModifiedDate desc];
            if(!orderItems.isEmpty())
            {
                theProcessingNumber = orderItems[0].User_Order_ID__c;
                processingNumber = theProcessingNumber; //store the processing Number to pull Activity with only Processing Number when processing Number is not provided in URL param
            }
        }

        //Pull back all the Order Items with the given Processing Number
        if(theProcessingNumber != null && theProcessingNumber != '')
        {
            orderItems = [SELECT Id , Order__c , 
            Product__c , User_Order_Extension__c FROM Order_Item__c WHERE User_Order_ID__c = :theProcessingNumber ORDER BY LastModifiedDate desc];
           
           
        }
        //Story B-19202 SF Archival Ledger Update - Added ordersIncaseNoOrderItems list to 
        //get Order details in case of no Order items due to archival - 
       if(orderItems.isEmpty()&& thecustomerOrderNumber !=null){
       		ordersIncaseNoOrderItems = [SELECT Id ,
            Product__c , User_Order_Extension__c, Base_Product__c FROM Order__c WHERE name =: thecustomerOrderNumber LIMIT 1];
       }
       

        if(!orderItems.isEmpty())
        {
            for(Order_Item__c theItem : orderItems)
            {
                if(theItem.Order__c != null)
                {
                    orderIds.add(theItem.Order__c);
                }
            }
        }
        if(orderItems.isEmpty() && !ordersIncaseNoOrderItems.isEmpty())
            orderIds.add(ordersIncaseNoOrderItems[0].id);

        if(!orderItems.isEmpty() || !ordersIncaseNoOrderItems.isEmpty())
        {
            List<Order__c> orders = new List<Order__c>();   
            List<Product2> products = new List<Product2>();
            List<User_Order_Extension__c> processingStatuses = new List<User_Order_Extension__c>();
            if(!orderItems.isEmpty()){
	            Order_Item__c theItem = orderItems[0];	            
            if(theItem.Order__c != null) 
                orders = [SELECT Id , Contact__c , OrderID__c , Contact_Name__c , Contact_State__c , State_of_Formation__c FROM Order__c WHERE Id = :theItem.Order__c];
            if(theItem.Product__c != null)
                products = [SELECT Id ,Name , Product_Line__r.Name FROM Product2 WHERE Id = :theItem.Product__c];
            if(theItem.User_Order_Extension__c != null)
                processingStatuses = [SELECT Id , Processing_Status__r.Name FROM User_Order_Extension__c WHERE Id = :theItem.User_Order_Extension__c];
                
            
            orderId = theItem.Order__c;
            }
            else
            {
                //Story B-19202 SF Archival Ledger Update - Assign ordersIncaseNoOrderItems list to 
        		//create new cases in case of no Order items due to archival
            	if(ordersIncaseNoOrderItems[0].id != null) 
	                orders = [SELECT Id , Contact__c , OrderID__c , Contact_Name__c , Contact_State__c , State_of_Formation__c FROM Order__c WHERE id = :ordersIncaseNoOrderItems[0].id];
	            if(ordersIncaseNoOrderItems[0].Product__c != null)
	                products = [SELECT Id ,Name , Product_Line__r.Name FROM Product2 WHERE Id = :ordersIncaseNoOrderItems[0].Base_Product__c];
	            if(ordersIncaseNoOrderItems[0].User_Order_Extension__c != null)
	                processingStatuses = [SELECT Id , Processing_Status__r.Name FROM User_Order_Extension__c WHERE Id = :ordersIncaseNoOrderItems[0].User_Order_Extension__c];
	                
	            
	            orderId = ordersIncaseNoOrderItems[0].id;
            }
            if(!orders.isEmpty())
            {
                customerName = orders[0].Contact_Name__c;
                if(customerName != null)
                    escapedCustomerName = String.escapeSingleQuotes(customerName);
                orderNumber = orders[0].OrderID__c;
                contactState = orders[0].Contact_State__c;
                contactId = orders[0].Contact__c;
                stateOfFormation = orders[0].State_of_Formation__c;
            }
            if(!products.isEmpty())
            {
                productName = products[0].Name;
                productLine = products[0].Product_Line__r.Name;
            }
            if(!processingStatuses.isEmpty())
                processingStatus = processingStatuses[0].Processing_Status__r.Name;
            
        }
    }
  
    public List<SelectOption> noteTypes
    {
        get
        {
            if(noteTypes == null)
            {
               noteTypes = new List<SelectOption>();
              
               noteTypes.add(new SelectOption(ORDER_NOTE , ORDER_NOTE));
               noteTypes.add(new SelectOption(PROBLEM_ORDER , PROBLEM_ORDER));
                 
            }
             return noteTypes;
             
        }
         set;
    }
    
    public void getTSID()
    {
        String userProfile = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        try
        {           
            Profile_Map_App_ID__c profileMapAppId = Profile_Map_App_ID__c.getInstance(userProfile);
            
            if(profileMapAppId != null)
            {
                tsid = profileMapAppId.TSID__c;
            }
            
        }catch(System.DmlException ex){
            System.debug(ex.getMessage());
        }
       
    }
    
    public void getHostURL()
    {
        if(URL.getSalesforceBaseUrl().getHost().contains('cs'))
        {
            hostURL = 'https://'+URL.getSalesforceBaseUrl().getHost();
        }
        else
        {
            Salesforce_Host_URL__c host = Salesforce_Host_URL__c.getInstance(SALESFORCE_BASED_URL);
            if(host != null)
                hostURL = host.Host_URL__c;
        }    
        
    }

    public String NotePadURL
    {
        get
        {
            if(NotePadURL == null)
            {
                External_Endpoint__c theEndPoint = ExternalEndpointService.getEndpointCustomSetting();
                if(theEndPoint != null)
                {
                    NotePadURL = theEndPoint.Notepad_URL__c;    
                }
                else
                {
                    NotePadURL = 'http://';
                }
            }
              
            return NotePadURL;
        }
        set;
    }
        
}