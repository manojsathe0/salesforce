public with sharing class OrderMatcherHelper 
{
	
    
    public static Set<String> RAProductNames
	{
		get
		{
			if(RAProductNames == null)
			{
				 RAProductNames = new Set<String>();
				 List<RA_Renewal_Product_Name__c> rAproducts = RA_Renewal_Product_Name__c.getall().values();
				 for(RA_Renewal_Product_Name__c theProduct : rAproducts)
				 {
						RAProductNames.add(theProduct.Product_Name__c);
				 }
			}
		
			return RAProductNames;
		}
		set;
	}
	
	public static Set<Id> RAProductIds
	{
		get
		{
			if(RAProductIds == null)
			{
				
				 RAProductIds = new Set<Id>();
				 for(Product2 theProduct : [SELECT Id FROM Product2 WHERE Name IN :RAProductNames])
				 {
				 	 RAProductIds.add(theProduct.Id);
				 }
			}
		
			return RAProductIds;
		}
		set;
	}

	
	public static Map<String,Order_Matching_Activity__c> getMatchingActivitiesToUpsert(Map<Id,Map<Id,String>> orderIdToTaskIdAgent , Set<Id> allActivityIds)
	{
		
		Map<String,Order_Matching_Activity__c> matchingActivitiesToUpsert = new Map<String,Order_Matching_Activity__c>(); 
		for(Order_Matching_Activity__c previouslyMatchedActivity : [SELECT Id , Agent__c ,Lead__c, Order__c, Activity_SFDC_Id__c  FROM Order_Matching_Activity__c WHERE Order__c IN :orderIdToTaskIdAgent.keySet()])
		{
			Order_Matching_Activity__c theMatchingActivity = new Order_Matching_Activity__c(Id = previouslyMatchedActivity.Id);
			theMatchingActivity.Agent__c = null;
			matchingActivitiesToUpsert.put(previouslyMatchedActivity.Order__c+'-'+previouslyMatchedActivity.Activity_SFDC_Id__c , theMatchingActivity);
		}
		System.debug('Matched Orders '+orderIdToTaskIdAgent.size());
		Set<Id> usedUpKeys = new Set<Id>();
		for(Order_Matching_Activity__c matchingActivity : [SELECT Id ,Contact__c , Activity_Created_By__c,Activity_Created_DateTime__c,Activity_Owner__c,Activity_Type__c,Activity_Contacted__c, 
														 Activity_Commission_Eligible__c, Activity_SFDC_Id__c , Lead__c , Order__c,Call_Type__c,Queue__c, Total_Activities__C,
														 Assistant_Manager__c,Manager__c, Lead_Supervisor__c , Inbound_Outbound__c , Pilot_Group_Contact__c,Lead_Score__c , Lead_Status__c , Contact_Status__c 
														  FROM Order_Matching_Activity__c WHERE Activity_SFDC_Id__c IN :allActivityIds])
		{
			for(Id theOrderId : orderIdToTaskIdAgent.keySet())
			{
				Map<Id,String> taskIdToAgent =  orderIdToTaskIdAgent.get(theOrderId);
				for(Id theTaskId : taskIdToAgent.keySet())
				{
					Order_Matching_Activity__c theMatch;
					String theUniqueKey = theOrderId+'-'+theTaskId;
					if(theTaskId == matchingActivity.Activity_SFDC_Id__c)  
					{
						if(matchingActivitiesToUpsert.containsKey(theUniqueKey))
						{
							theMatch = matchingActivitiesToUpsert.get(theUniqueKey);
							theMatch.Agent__c = taskIdToAgent.get(theTaskId);
						}
						else if(matchingActivity.Order__c == null && !usedUpKeys.contains(matchingActivity.Id))
						{
							theMatch = new Order_Matching_Activity__c(Id = matchingActivity.Id);
							theMatch.Order__c = theOrderId;
							usedUpKeys.add(matchingActivity.Id);
							theMatch.Agent__c = taskIdToAgent.get(theTaskId);
						}
						else
						{
							theMatch = new Order_Matching_Activity__c(
							Contact__c =  matchingActivity.Contact__c ,
							Activity_Created_DateTime__c = matchingActivity.Activity_Created_DateTime__c ,
							Activity_Created_By__c = matchingActivity.Activity_Created_By__c , Activity_Type__c = matchingActivity.Activity_Type__c,
							Activity_SFDC_Id__c = matchingActivity.Activity_SFDC_Id__c , Activity_Contacted__c = matchingActivity.Activity_Contacted__c,
							Activity_Owner__c = matchingActivity.Activity_Owner__c, ownerId =  matchingActivity.Activity_Created_By__c ,Activity_Commission_Eligible__c = matchingActivity.Activity_Commission_Eligible__c,
							Order__c = theOrderId ,Call_Type__c = matchingActivity.Call_Type__c , Queue__c = matchingActivity.Queue__c,Assistant_Manager__c = matchingActivity.Assistant_Manager__c ,Manager__c = matchingActivity.Manager__c , 
							Lead_Supervisor__c = matchingActivity.Lead_Supervisor__c , Inbound_Outbound__c = matchingActivity.Inbound_Outbound__c , 
							Pilot_Group_Contact__c = matchingActivity.Pilot_Group_Contact__c , Lead_Score__c = matchingActivity.Lead_Score__c,  
							Lead_Status__c = matchingActivity.Lead_Status__c , Contact_Status__c = matchingActivity.Contact_Status__c , Agent__c = taskIdToAgent.get(theTaskId),
							Total_Activities__C = matchingActivity.Total_Activities__C);
						}   	
						matchingActivitiesToUpsert.put(theUniqueKey , theMatch);
					}
					
				}
			}
		}
		
		return matchingActivitiesToUpsert;
	}
	
}