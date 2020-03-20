public without sharing class MyCasesViewController
{
    //Controller
    public String selectedValue {get; set;}
    private String queryBaseString;
    final static String OPEN_CASES = 'My Open Cases';
    final static String ALL_CASES = 'My All Cases';
    final static String CLOSED_CASES = 'My Closed Cases';
    final static Integer PAGE_SIZE = 50;
    
    public ApexPages.StandardSetController con{get; set;}
     
    public MyCasesViewController()
    {
        queryBaseString = 'SELECT Id, IsClosed, IsEscalated,  CaseNumber, Queue__c, Contact.Name, ContactId, Subject, Status, ' +
                'Assigned_User__r.Name, CreatedDate, LastModifiedDate, Due_Date__c FROM Case WHERE Assigned_User__c = \''+UserInfo.getUserId()+'\''; 
        selectedValue = OPEN_CASES;
        initialize();
    }
    
    public List<Case> allCases  
    {  
        get  
        {  
            if(con != null)  
                return (List<Case>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
   
    //Boolean to check if there are more records after the present displaying records
    public Boolean hasNext
    {
        get { return con.getHasNext(); }
        set;
    }
 
    //Boolean to check if there are more records before the present displaying records
    public Boolean hasPrevious
    {
        get { return con.getHasPrevious(); }
        set;
    }
 
    //Page number of the current displaying records
    public Integer pageNumber
    {
        get { return con.getPageNumber(); }
        set;
    }

    //Returns the previous page of records
    public void previous()
    {
        con.previous();
    }
 
    //Returns the next page of records
    public void next()
    {
        con.next();
    }
    
    public List<SelectOption> getOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(OPEN_CASES , OPEN_CASES));
        options.add(new SelectOption(CLOSED_CASES , CLOSED_CASES));
        options.add(new SelectOption(ALL_CASES , ALL_CASES));
        return options;
    }
    
    public void initialize()
    {
        String query = '';
        String limitQuery = ' ORDER BY LastModifiedDate DESC LIMIT 500';
        if(selectedValue == ALL_CASES)
        {
            query = queryBaseString + limitQuery;
            con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            con.setPageSize(PAGE_SIZE);
        }
        else if(selectedValue == OPEN_CASES)
        {
            query = queryBaseString + ' AND isClosed = false'+limitQuery;
            con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            con.setPageSize(PAGE_SIZE);
        }
        else if(selectedValue == CLOSED_CASES)
        {
            query = queryBaseString + ' AND isClosed = true'+limitQuery;
            con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            con.setPageSize(PAGE_SIZE);
        }
    }
    
}