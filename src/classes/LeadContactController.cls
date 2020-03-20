global with sharing class LeadContactController {
    public List<LeadContactInfo> leadAndContacts{get;set;}
    final static String THE_CONTACT = 'Contact';
    final static String THE_LEAD = 'Lead';
    public Map<String,Integer> fieldToOrder;
    public String sortString{get;set;}
    public Contact dummyContact{get;set;}
    public boolean changeOwner{get;set;}
    public boolean changeStatus{get;set;}
    public String selectedLeadStatusOption{get;set;}
    public String selectedRecordIds{get;set;}
    public final static String CONTACT_PREFIX = '003';
    public final static String LEAD_PREFIX = '00Q';
    public final static String DATE_TIME_FORMAT = 'MM/dd/yyyy hh:mm:ss a'; 
    public final static String STANDARD_RECORD_DEVELOPER_NAME = 'Standard_Contact';
    public final static String ABANDONERS = 'Abandoners'; 
    public final static String NO_ABANDONER_MESSAGE = 'There are no leads available for assignment.';
    public final static String NOT_ALLOWED_MESSAGE = 'You are not allowed to receive any leads.';
    
    public LeadContactController()
    {
        selectedRecordIds = '';
        changeOwner = false;  
        changeStatus = false;
        dummyContact = new Contact();
        dummyContact.OwnerId = UserInfo.getUserId();

        sortString = '[11,\'desc\']';
        leadAndContacts = getLeadsAndContacts();
       // myTasks = getMyTasks();
        fieldToOrder = new Map<String,Integer>{'Name'=>1,'Object'=>2, 'State' =>3,'Product' =>4,'Status'=>5,'Last Activity'=>6, 'Total Activities' => 7,'Campaign Name' =>8, 'Email' =>9,'Phone' =>10, 'Date/Time Modified'=>11, 'Date/Time Created'=>12};
        //availableAbandoners = 0;
    }
    
    public List<SelectOption> LeadStatusOptions
    {
        get
        {
            if(LeadStatusOptions == null)
            {
               LeadStatusOptions = new List<SelectOption>();
               Schema.DescribeFieldResult fieldResult= Lead.Status.getDescribe();
               
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
               LeadStatusOptions.add(new SelectOption('' , '--Select Status--'));
               for( Schema.PicklistEntry f : ple)
               {
                  LeadStatusOptions.add(new SelectOption(f.getValue(), f.getLabel()));
               }    
            }
            return LeadStatusOptions;
        }
        set;
    }
    
    public void constructSortString()
    {
        String tempString = '';
        for(FieldWrapper fWrapper : fieldsForSorting.values())
        {
            if(fWrapper.selectedField != null && fWrapper.sortOrder != null) 
            {
                tempString += '['+fieldToOrder.get(fWrapper.selectedField)+',\''+fWrapper.sortOrder+'\'],';
            }
        }
        if(tempString != '')
            sortString = tempString.subString(0, tempString.length()-1);//get last comma out
        system.debug(sortString);
    } 
    
    public List<Integer> orderList 
    {
        get
        {
            if(orderList == null)
            {
                orderList = new List<Integer>{0,1,2};
            }
            
            return orderList;
        }
        set;
    }

     public void retrieveFreshLeadsAndContacts()
    {
        constructSortString();
        leadAndContacts = getLeadsAndContacts();
    }
    
    public List<LeadContactInfo> getLeadsAndContacts()
    {
        leadAndContacts = new List<LeadContactInfo>();
        leadAndContacts.addAll(getAllContactsInfo());
        leadAndContacts.addAll(getAllLeadsInfo());
        return leadAndContacts;
    } 

    public List<LeadContactInfo> getAllContactsInfo() 
    {
        List<LeadContactInfo> contactsInfo = new List<LeadContactInfo>();
        List<Contact> ContactsByOwner = [SELECT Id ,RecordTypeId, Name, Contact_Type__c , HomePhone , CreatedDate , LastModifiedDate , MailingState,
                                             Owner.Name, AccountId, Email , Sales_opportunity_latest_campaign__c, Lead_Status__c , Contact_Status__c, Total_Activities__c, Temperature__c, Product2__c
                                        FROM Contact WHERE ownerId = :UserInfo.getUserId() AND Lead_Status__c != 'Closed Lost' ORDER BY LastModifiedDate DESC limit 500];
        for(Contact theContact : ContactsByOwner)
        {
            String createdDateTime = theContact.CreatedDate.format(DATE_TIME_FORMAT);
            String modifiedDateTime = theContact.LastModifiedDate.format(DATE_TIME_FORMAT);

            LeadContactInfo contactInfo = new LeadContactInfo(theContact.Id, theContact.Name , theContact.Lead_Status__c,null,
                                            theContact.HomePhone , theContact.MailingState, theContact.Email , createdDateTime,
                                            modifiedDateTime , theContact.Owner.Name , THE_CONTACT , theContact.AccountId, theContact.Sales_opportunity_latest_campaign__c, theContact.Contact_Status__c,
                                             theContact.Total_Activities__c, theContact.Temperature__c, theContact.Product2__c );
            contactsInfo.add(contactInfo);
        }
        return contactsInfo;

    }

    public List<LeadContactInfo> getAllLeadsInfo()
    {
        List<Lead> leadsByOwner = [SELECT Id , Name ,  RecordType.Name  , Status , Phone , State , State_of_Formation__c, Email , Lead_Call_Status__c,Total_Activities__c, Temperature__c,
                                    Date_Time_Created__c , Date_Time_Modified__c , Owner.Name , Account__c, Product2__c
                                  FROM Lead WHERE ownerId = :UserInfo.getUserId() AND IsConverted = false AND Status != 'Closed Lost' ORDER BY Date_Time_Modified__c DESC limit 500];
        List<LeadContactInfo> leadsInfo = new List<LeadContactInfo>();
        for(Lead theLead : leadsByOwner)
        {
            String createdDateTime = theLead.Date_Time_Created__c.format(DATE_TIME_FORMAT);
            String modifiedDateTime = theLead.Date_Time_Modified__c.format(DATE_TIME_FORMAT);
            LeadContactInfo leadInfo = new LeadContactInfo(thelead.Id , thelead.Name , theLead.Status , 'n/a' ,
                                            theLead.Phone , theLead.State , theLead.Email , createdDateTime,
                                            modifiedDateTime , theLead.Owner.Name , THE_LEAD , theLead.Account__c, null, theLead.Lead_Call_Status__c,
                                            theLead.Total_Activities__c, theLead.Temperature__c, thelead.Product2__c);
            if(theLead.State_of_Formation__c != null)
                leadInfo.state = theLead.State_of_Formation__c;
            leadsInfo.add(leadInfo);
        }
        
        return leadsInfo;
    }
    
    public Map<Integer,FieldWrapper> fieldsForSorting
    {
        get
        {
            if(fieldsForSorting == null)
            {
                fieldsForSorting = new Map<Integer,FieldWrapper>();
                fieldsForSorting.put(0 , new FieldWrapper());
                fieldsForSorting.put(1 , new FieldWrapper());
                fieldsForSorting.put(2 , new FieldWrapper());
            }
            return fieldsForSorting;        
        }
        set;
    }
    
    public void changeOwner()
    {
        if(changeOwner)
        {
            changeOwner = false;
        }
        else
        {
            changeOwner = true;
        }
        changeStatus = false;
        
    }
    
    public void changeStatus()
    {
        if(changeStatus)
        {
            changeStatus = false;
        }
        else
        {
            changeStatus = true;
        }
        changeOwner = false;
    }

    public void updateOwner()
    {
        List<Id> selectedIds = selectedRecordIds.split(',');
        List<Id> contactIds = new List<Id>();
        List<Id> leadIds = new List<Id>();
        for(String theId : selectedIds)
        {
            if(theId.startsWith(CONTACT_PREFIX))
            {
                contactIds.add(theId);
            }
            else if(theId.startsWith(LEAD_PREFIX))
            {
                leadIds.add(theId);
            }
            
        }
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> contacsToUpdate = new List<Contact>();
        
        for(Id theContactId : contactIds)
        {
            contacsToUpdate.add(new Contact(Id = theContactId , ownerId = dummyContact.ownerId));
        }
        
        for(Id theLeadId : leadIds)
        {
            leadsToUpdate.add(new Lead(Id = theLeadId , ownerId = dummyContact.ownerId));
        }
        try
        {
            update leadsToUpdate;
            update contacsToUpdate;
        }
        catch(DMLException dmlEx)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , dmlEx.getMessage()));
        }
        retrieveFreshLeadsAndContacts();
    }
    
    public void updateStatus()
    {
        List<Id> selectedIds = selectedRecordIds.split(',');
        List<Id> leadIds = new List<Id>();
        for(String theId : selectedIds)
        {
             if(theId.startsWith(LEAD_PREFIX))
                {
                    leadIds.add(theId);
                }
            
        }
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for(Id theLeadId : leadIds)
        {
            leadsToUpdate.add(new Lead(Id = theLeadId , status = selectedLeadStatusOption));
        }
        try
        {
            update leadsToUpdate;
        }
        catch(DMLException dmlEx)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , dmlEx.getMessage()));
        }
        retrieveFreshLeadsAndContacts();
    }
    
    public class FieldWrapper
    {
        public List<SelectOption> fieldNames{get;set;}
        public List<SelectOption> sortOrders{get;set;}
        public String selectedField{get;set;}
        public String sortOrder{get;set;}
        FieldWrapper()
        {
            fieldNames = new List<SelectOption>();
            fieldNames.add(new SelectOption('','--Select Field--'));
            fieldNames.add(new SelectOption('Name' , 'Name'));
            fieldNames.add(new SelectOption('Object' , 'Object'));
            fieldNames.add(new SelectOption('State' , 'State'));
            fieldNames.add(new SelectOption('Product' , 'Product'));
            fieldNames.add(new SelectOption('Status' , 'Status'));
            fieldNames.add(new SelectOption('Last Activity' , 'Last Activity'));
            fieldNames.add(new SelectOption('Total Activities' , 'Total Activities'));
            fieldNames.add(new SelectOption('Campaign Name' , 'Campaign Name'));
            fieldNames.add(new SelectOption('Email' , 'Email'));
            fieldNames.add(new SelectOption('Phone' , 'Phone'));
            fieldNames.add(new SelectOption('Date/Time Modified' , 'Date/Time Modified'));
            fieldNames.add(new SelectOption('Date/Time Created' , 'Date/Time Created'));
                        
            sortOrders = new List<SelectOption>();
            sortOrders.add(new SelectOption('','--Select Order--'));
            sortOrders.add(new SelectOption('asc','asc'));
            sortOrders.add(new SelectOption('desc','desc'));
        }
    }
    
    @RemoteAction 
    global static LeadContactMessage assignNewAbandoners()
    {
        GetNextAbandonerLeadContact nextAbandoner = new GetNextAbandonerLeadContact();
        
        Integer checkAvailabilityStatus = nextAbandoner.checkIfAllowedNewAbandoner();
        system.debug(checkAvailabilityStatus + 'Availability status');
        List<LeadContactInfo> abandonersToAssign;
        LeadContactMessage theMessage;
        if(checkAvailabilityStatus == 0)
        {
            abandonersToAssign = nextAbandoner.getNextAbandoner();
            while(abandonersToAssign.size() == 0)
                abandonersToAssign = nextAbandoner.getNextAbandoner();
            if(!abandonersToAssign.isEmpty())
                theMessage = new LeadContactMessage(abandonersToAssign[0].Name, abandonersToAssign[0].objectId, null , checkAvailabilityStatus);
        }

        else if(checkAvailabilityStatus == 1)
        {
            theMessage = new LeadContactMessage(null, null, NOT_ALLOWED_MESSAGE , checkAvailabilityStatus);
        }
        else if(checkAvailabilityStatus == 2)
        {
            theMessage = new LeadContactMessage(null, null, NO_ABANDONER_MESSAGE , checkAvailabilityStatus);
        }
        return theMessage;
    }

    global class LeadContactMessage
    {
        public LeadContactInfo theAbandoner{get;set;}
        public Id id{get;set;}
        public String Name{get;set;}
        public String message{get;set;}
        public Integer statusId{get;set;}
        
        public LeadContactMessage(String theName, Id theId, String theMessage , Integer theStatusId)
        {
            Name = theName;
            id = theId;
            message = theMessage;
            statusId = theStatusId;
        }
    }
}