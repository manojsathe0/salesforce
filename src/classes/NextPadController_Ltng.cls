/*
Migration of NextPad functionality to Salesforce
Story: B-26835
By Artyom M.
*/
public with sharing class NextPadController_Ltng { 
	public static List<NoteWrapper_Ltng> allNotes{get;set;}
	public static NextPadService_Ltng nextPadService{get;set;}
	
	public String processingNumber{get;set;}
    public String customerOrderNumber{get;set;}
    public String description{get;set;}
    public NextPadService theNextPadService{get;set;}  
    public String selectedNoteType{get;set;}
    public String productName{get;set;}
    public String productLine{get;set;}
    public String contactState{get;set;}
    public String processingStatus{get;set;}
    public static Id contactId{get;set;}
    public static String orderId{get;set;}
    public String orderNumber{get;set;}
   
    public Map<String,NoteWrapper> objectIdToWrapper{get;set;}
    
    public String sortOrder{get;set;}
    public String filterNoteType{get;set;}
    
    public String userSortOrder{get;set;}
    private final Order_Item__c theItem;
    public Boolean showEdit{get;set;}
    final  static String NO_EDIT = 'noEdit';
    public String orderItemId{get;set;}
    public String stateOfFormation{get;set;}
    final static String BUSINESS_FORMATIONS = 'Business Formations';

	public static Map<String,String> productLineToQueueName
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
    
	@AuraEnabled
	public static Contact getContactName(String theProcessingNumber, String orderItemId, String thecustomerOrderNumber) {
		nextPadService = new NextPadService_Ltng();
		nextPadService.populateAllInformationByProcessingNumber(theProcessingNumber, orderItemId, thecustomerOrderNumber);
		Contact cnt = new Contact();
		cnt.LastName = nextPadService.customerName;
		cnt.Id = nextPadService.contactId;
        System.debug('cnt.Id = ' + cnt.Id);
		return cnt;
	}
	
	@AuraEnabled
	public static List<NoteWrapper_Ltng> getDataSortedBy(String theProcessingNumber, String orderItemId, String thecustomerOrderNumber, String sortingField, String sortingOrder, String filter) {
		System.Debug('theProcessingNumber = ' + theProcessingNumber);
		System.Debug('orderItemId = ' + orderItemId);
		System.Debug('thecustomerOrderNumber = ' + thecustomerOrderNumber);
		System.Debug('sortingField = ' + sortingField);
		System.Debug('sortingOrder = ' + sortingOrder);
		System.Debug('filter = ' + filter);
		nextPadService = new NextPadService_Ltng();
		/* */
		if (filter.equals('all')) {
			nextPadService.filterNoteType = NextPadService_Ltng.ALL;
		}
		if (filter.equals('cases')) {
			nextPadService.filterNoteType = NextPadService_Ltng.THE_CASE;
		}
		if (filter.equals('notes')) {
			nextPadService.filterNoteType = NextPadService_Ltng.ORDER_NOTE;
		}
		

		
		nextPadService.populateAllInformationByProcessingNumber(theProcessingNumber, orderItemId, thecustomerOrderNumber);
		allNotes = nextPadService.noteWrappers;
        
        System.Debug('nextPadService.orderId = ' + nextPadService.orderId);
        orderId = nextPadService.orderId;
        contactId = nextPadService.contactId;
        
		if (sortingField.equals('date')) {
			NoteWrapper_Ltng.SORT_FIELD = NoteWrapper_Ltng.SortField.DateTimeCreated;
		}
		else {
			NoteWrapper_Ltng.SORT_FIELD = NoteWrapper_Ltng.SortField.Name;
		}
		
		if (sortingOrder.equals('ascending')) {
			NoteWrapper_Ltng.SORT_DIR = NoteWrapper_Ltng.SortDirection.ASCENDING;
		}
		else {
			NoteWrapper_Ltng.SORT_DIR = NoteWrapper_Ltng.SortDirection.DESCENDING;
		}
		

		allNotes.sort();
		return allNotes;
	}
	
	@AuraEnabled
	public static void submitRecord(String theProcessingNumber, String orderItemId, String thecustomerOrderNumber, String description, String objectType, String createdBy) {
		System.Debug('theProcessingNumber = ' + theProcessingNumber);
		System.Debug('orderItemId = ' + orderItemId);
		System.Debug('thecustomerOrderNumber = ' + thecustomerOrderNumber);
		System.Debug('description = ' + description);
		System.Debug('objectType = ' + objectType);
		System.debug('createdBy = '+createdBy);
        
		nextPadService = new NextPadService_Ltng();
		nextPadService.populateAllInformationByProcessingNumber(theProcessingNumber, orderItemId, thecustomerOrderNumber);//
		
        System.Debug('nextPadService.orderId = ' + nextPadService.orderId);
		orderId = nextPadService.orderId;
        contactId = nextPadService.contactId;		
        String productline = nextPadService.productline;
		String stateOfFormation = nextPadService.stateOfFormation;
		String productName = nextPadService.productName;
		String processingStatus = nextPadService.processingStatus;
		String contactState = nextPadService.contactState;
		String fileNetUserId;
        Integer counter = 0; 
        
        Set<String> userNames = new Set<String>();
        String filenetUsrName = 'filenet' + '@' + UserInfo.getUserName().substringAfter('@');
        String usrName = createdBy + '@' + UserInfo.getUserName().substringAfter('@');
        userNames.add(usrName);
        userNames.add(filenetUsrName);
        system.debug('usrName-->' + usrName + 'filenetUsrName--->' + filenetUsrName);                
        
		if (objectType.equals('case')) {
			Case theCase = new Case();
	        String theState = '';
	        
	        if(productline == BUSINESS_FORMATIONS && (stateOfFormation != null && stateOfFormation != '')){
	            theState = stateOfFormation;
            }else{
	            theState = contactState;
            }
            
	        theCase.Subject = theProcessingNumber + ' - ' + productName + ' - ' + theState;
	        theCase.description = description;
	        theCase.Processing_Number__c = theProcessingNumber;
	        theCase.Order_Number__c = thecustomerOrderNumber;
	        theCase.Processing_Status__c = processingStatus;
	        theCase.Origin = 'Fulfillment';
	        theCase.ContactId = contactId;
	        
	        if(productLineToQueueName.containsKey(productLine)){
	            theCase.Queue__c = productLineToQueueName.get(productLine);
            }else{
	            theCase.Queue__c = 'CC General Support';
            }
            
            if(String.isNotBlank(createdBy)){
                counter = 0;
                for(User user: [SELECT Id, UserName From User WHERE UserName IN: userNames AND isActive = true LIMIT 2]){
                    system.debug('user-->'+user);
                    if(!user.UserName.containsIgnoreCase('filenet')){	
                        theCase.CreatedById = user.Id;
                        counter++;
                    }
                    if(user.UserName.containsIgnoreCase('filenet')){
                        fileNetUserId = user.Id;
                    }
                }
                
                if(counter == 0){
                    theCase.CreatedById = fileNetUserId;
                }
            }
            
	        try
	        {
	            insert theCase;
	        }
	        catch(DMlException dmlEx)
	        {
	            system.debug('Failed Creating Case ');
	        }
		}
		
		if (objectType.equals('note')) {
			Task theTask = new Task();
	        theTask.Description = description;
	        theTask.WhatId = nextPadService.orderId;
	        theTask.Subject = NextPadService_Ltng.ORDER_NOTE;
	        theTask.Status = 'Completed';
	        theTask.ActivityDate = Date.today();
	        theTask.Type = 'Note';
	        theTask.User_Order_ID__c = theProcessingNumber;
	                    
            if(String.isNotBlank(createdBy)){
                counter = 0;
                
                for(User user: [SELECT Id, UserName From User WHERE UserName IN: userNames AND isActive = true LIMIT 2]){
                    system.debug('user-->'+user);
                    if(!user.UserName.containsIgnoreCase('filenet')){	
                        theTask.CreatedById = user.Id;
                        counter++;
                    }
                    if(user.UserName.containsIgnoreCase('filenet')){
                        fileNetUserId = user.Id;
                    }
                }
                
                if(counter == 0){
                    theTask.CreatedById = fileNetUserId;
                }
            }
	        try {
	            insert theTask;
	        }
	        catch(DMLException dmlEx) {
	            system.debug('Failed Creating Order Note');
	        }
		}
	} 
	
    
}