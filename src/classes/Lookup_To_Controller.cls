public without sharing class Lookup_To_Controller 
{
	public Id id{get;set;}
	public String textData{get;set;}
    public Contact newContact{get;set;}
    public Id accountId{get;set;}
    public Boolean showNewContactForm{get;set;}
    public Boolean showNewContactFormButton{get;set;}
    public Id selectedContactId{get;set;}
    public Case theCase{get;set;}
  
    
	public Lookup_To_Controller()
	{
	    Map<String,String> currentParams = ApexPages.currentPage().getParameters();
	    if(currentParams.containsKey('id'))
	    {
	        id = currentParams.get('id');
	     	theCase = [Select AccountId,ContactId From Case where Id =:id limit 1];
		    accountId = theCase.AccountId;	       
	    }
	    showNewContactForm = false;
	    showNewContactFormButton = true;
	    
	}
	
	public PageReference createNewContact()
	{
		newContact = new Contact();
		newContact.AccountId = accountId;
		showNewContactForm = true; 
		showNewContactFormButton = false;
		return null;
	}
	
	public PageReference saveNewContact()
	{
		insert newContact;
		showNewContactForm = false;
		showNewContactFormButton = true;
		return searchContact();
	}
	
	public void cancel()
	{
		newContact = null;
		showNewContactForm = false;
		showNewContactFormButton = true;
	}
		
	public String getTextData()
	{
	  return textData;
	}

	public void setTextData(String newTD)
	{
	   textData=newTD;
	}
	
	public PageReference searchContact()
	{
	    PageReference pageReference =  system.page.Lookup_To_Dialog;
	    getsearchR();
	    pageReference.getParameters().put('id',id);
	    return pageReference;
	}
	
	public List<Contact> getsearchR()
	{
	    return searchR;
	}
	
	public List<Contact> searchR
	{
	   get 
	   {
	    	
	    	searchR = new List<Contact>();
	    	if(accountId != null)
	    	{
				searchR =  [Select Phone, OwnerId, Contact_Type__c, Name, LastName, Id, FirstName, Email,AccountId,Account.Name,Owner.name  From Contact  where  AccountId = :accountId  ORDER by Contact_Type__c desc];
		    }
		    	
		    return searchR;
	    
	    }
	   	set;   
	}
	
	public void ClearResult()
	{
	    searchR = null;
	}
	
	public void updateCaseWithContact()
	{
		
		theCase.ContactId = selectedContactId;
		update theCase;
			
	}
}