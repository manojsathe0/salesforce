public with sharing class LookupSalesQAController 
{
	public String query {get; set;}
	public List<User> salesQAList {get; set;}
	
	public PageReference runQuery()
	{

		if(query.length() >= 3)
		{
			List<List<User>> searchResults=[FIND :query IN ALL FIELDS RETURNING User (id, name, Sales_Team__c, IsActive)];
			salesQAList=searchResults[0];
		}

  		return null;
	}
}