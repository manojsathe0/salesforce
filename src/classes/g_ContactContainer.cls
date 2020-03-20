global class g_ContactContainer {

	public Contact contact {get;set;} // contact for this wrapper
	public List<Order__c> order_results {get;set;} // search results
	public List<Order_Item__c> order_item_results {get;set;} // search results
	public List<Case> case_results {get;set;} //search results

	public Integer order_count {get;set;}
	public Integer order_item_count {get;set;}
	public Integer case_count {get;set;}
	
	public g_ContactContainer(Contact contactToWrap)
	{
		contact=contactToWrap;

		order_count=0;
		order_item_count=0;
		case_count=0;
		order_results=new List<Order__c>();
		order_item_results=new List<Order_Item__c>();
		case_results=new List<Case>();
	}
	
	public void updateCounts()
	{
		order_count = order_results.size() > 0 ? order_results.size(): 0;
		order_item_count = order_item_results.size()>0 ? order_item_results.size() : 0;
		case_count = case_results.size()>0 ? case_results.size() : 0;		
	}
}