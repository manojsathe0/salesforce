public with sharing class ScoringServiceHelper {
	
	//Method to update total bucket score when a new criteria is added, updated or deleted.
	 public static void updateTotalBucketScore(Set<Id> bucketIds)
	 {
	 	List<Lead_Scoring_Bucket_Criteria__c> allActiveBucketCriteria = [Select Id, 										
																		Name, 
																		Lead_Scoring_Bucket__r.Id,
																		Lead_Scoring_Bucket__r.Bucket_Percentage__c, 
																		Points__c, 
																		Value__c,
																		Active__c From  
																		Lead_Scoring_Bucket_Criteria__c];
		
		Map<Id,Decimal> bucketIdToScore = calculateTotalBUcketScore(allActiveBucketCriteria);
		
		List<Lead_Scoring_Bucket__c> bucketsToUpdate = new List<Lead_Scoring_Bucket__c>();														
		for(Id bucketId: bucketIdToScore.keySet())
		{
			Lead_Scoring_Bucket__c bucket = new Lead_Scoring_Bucket__c(Id = bucketID);
			bucket.Total_Bucket_Score__c = bucketIdToScore.get(bucketId);
			bucketsToUpdate.add(bucket);
		}
		if(!bucketsToUpdate.isEmpty())
		{
			try
			{
				update bucketsToUpdate;
			}
			catch(System.DmlException e)
			{
				for(Integer i = 0 ;i <e.getNumDml(); ++i)
				{
					bucketsToUpdate[e.getDmlIndex(i)].addError('Failed to update the total bucket score'+ e.getDmlMessage(i)+', ID: '+ e.getDmlId(i));
				}
			}
		}
	 }
	 
	 public static List<Lead_Attribute__c> getExistingScoringPoints(Set<ID> leadIds, Set<ID> contactIds)
		{
			List<Lead_Attribute__c> existingPoints = new List<Lead_Attribute__c>();
			if(!leadIds.isEmpty())
			existingPoints = [Select ID,
	 							    Lead__c,
		 						    Name,
		 						    Lead_Scoring_Bucket__c,
	 							    Points__c,
	 							    Value__c,
	 							    Start_Time__c,
	 							    Parent_id__c,
	 							    Activity__c,
	 							    End_Time__c FROM
	 							    Lead_Attribute__c WHERE
	 							    Lead__c In :leadIds];
 		if(!contactIds.isEmpty())
 		existingPoints.addAll([Select ID,
		 							    Contact__c,
			 						    Name,
			 						    Activity__c,
			 						    Lead_Scoring_Bucket__c,
		 							    Points__c,
		 							    Value__c,
		 							    Start_Time__c,
		 							    Parent_id__c,
		 							    End_Time__c FROM
		 							    Lead_Attribute__c WHERE
		 							    contact__c In :contactIds]);
 			return existingPoints;
		} 	
		
		public static List<Lead_Attribute__c> identifyDuplicatePoints(List<Lead_Attribute__c> existingPoints, Map<ID,Map<String,Lead_Attribute__c>> recordIdToPointNameToPoint)
		{
			List<Lead_Attribute__c> pointsToReturn = new List<Lead_Attribute__c>();
	 		for(Lead_Attribute__c point : existingPoints)
	 		{
	 			if(recordIdToPointNameToPoint.containsKey(point.Parent_id__c))
	 			{
	 				system.debug(recordIdToPointNameToPoint.get(point.Parent_id__c));
	 				if(recordIdToPointNameToPoint.get(point.Parent_id__c).containsKey(point.Name))
	 				{
	 					recordIdToPointNameToPoint.get(point.Parent_id__c).get(point.Name).Original_Attribute_Id__c = point.Id;
	 				}
	 				else
	 				pointsToReturn.add(point);
	 			}
	 		}	
			return pointsToReturn;
		}

		public static void deleteDuplicateAttributs(List<Lead_Attribute__c> newAttributes)
		{
			system.debug(newAttributes);
			List<Id> originalIds = new List<Id>();
			List<Lead_Attribute__c> attributesToDelete = new List<Lead_Attribute__c>();
			Map<Id,Lead_Attribute__c> idToAttributeValue = new Map<Id,Lead_Attribute__c>();
			List<Lead_Attribute__c> qeriednewAttributes = [Select Id, Value__c, Original_Attribute_Id__c,Points__c From Lead_Attribute__c Where Id in: newAttributes];
			for(Lead_Attribute__c attribute : qeriednewAttributes)
			{
				if(attribute.Original_Attribute_Id__c != null && attribute.Original_Attribute_Id__c != '')
				{
					attributesToDelete.add(attribute);
					idToAttributeValue.put(attribute.Original_Attribute_Id__c, attribute);
				}
			}

			List<Lead_Attribute__c> queriedAttributes = [Select Id, Value__c From Lead_Attribute__c Where Id in: idToAttributeValue.keySet()];
			for(Lead_Attribute__c attribute : queriedAttributes)
			{
				attribute.Value__c = idToAttributeValue.get(attribute.Id).Value__c;
				attribute.Points__c = idToAttributeValue.get(attribute.Id).Points__c;
			}
			update queriedAttributes;
			delete attributesToDelete;
		}
		
	 
	 public static decimal getTotalScore(Id recordId,Map<Id,Map<Id,Decimal>> recordToBucketToBucketScore, Map<Id,Decimal> bucketIdToTotalScore,Map<Id,Decimal> bucketIdToPercentage)
		{
			Decimal totalScore=0;
			for(Id bucketId : recordToBucketToBucketScore.get(recordId).keySet())
				{
					totalScore = (totalScore + (((recordToBucketToBucketScore.get(recordId).get(bucketId)/bucketIdToTotalScore.get(bucketID)) * bucketIdToPercentage.get(bucketId))));
				} 
			return totalScore; 
		}

	
	//method to create a map of bucket id to bucket total score
	public static Map<Id,Decimal> calculateTotalBUcketScore(List<Lead_Scoring_Bucket_Criteria__c> allActiveBucketCriteria)
	{
		Map<Id,Decimal> bucketScore = new Map<Id,Decimal>();
		for(Lead_Scoring_Bucket_Criteria__c criteria : allActiveBucketCriteria)
		{
			decimal points;
			if(criteria.Active__c == true)
				points = criteria.Points__c;
			else
				points = 0;
			if(bucketScore.containsKey(criteria.Lead_Scoring_Bucket__r.Id))
			{
				bucketScore.put(criteria.Lead_Scoring_Bucket__r.Id,(bucketScore.get(criteria.Lead_Scoring_Bucket__r.Id) + points));
			}
			else
			{
				bucketScore.put(criteria.Lead_Scoring_Bucket__r.Id,points);
			}
		}
		return bucketScore;	
	}
	
	
	//methos to check if the datapoint value is contained in the criteria value
	public static Boolean checkScoreingPointValue(Lead_Attribute__c leadPoint,Lead_Scoring_Bucket_Criteria__c criteria)
	{
		system.debug(leadPoint+',,'+criteria);
		boolean contains = false;
		if(leadPoint.Activity__c == false)
		{
			If(criteria.Value__c == null && leadPoint.Value__c != null && leadPoint.Value__c != ' ')
			{
				contains = true;
				return contains;
			}
			else
			{
				system.debug(criteria.Value__c);
				List<String> criteriaValues = criteria.value__c.split(',');
				for(String value : criteriaValues)
				{
					if(value.trim() == leadPoint.Value__c)
					{
						contains = true;
						break;
					}
				}return contains;
			}
		}
		else
		{
			return true;
		}
	}
	
	public static Set<Id> getBucketIdsForRecalcuationForUpdate(Map<Id , Lead_Scoring_Bucket_Criteria__c> oldBucketCriteria , Map<Id, Lead_Scoring_Bucket_Criteria__c> newBucketCriteria)
	{
		Set<Id> bucketIdsToConsider = new Set<Id>();
		for(Lead_Scoring_Bucket_Criteria__c oldCriteria : oldBucketCriteria.values())
		{
			Lead_Scoring_Bucket_Criteria__c newCriteria = newBucketCriteria.get(oldCriteria.Id);
			if(newCriteria.Lead_Scoring_Bucket__c != oldCriteria.Lead_Scoring_Bucket__c)
			{
				if(!bucketIdsToConsider.contains(newCriteria.Lead_Scoring_Bucket__c))
					bucketIdsToConsider.add(newCriteria.Lead_Scoring_Bucket__c);
				
				if(!bucketIdsToConsider.contains(oldCriteria.Lead_Scoring_Bucket__c))
					bucketIdsToConsider.add(oldCriteria.Lead_Scoring_Bucket__c);
			}
			if(newCriteria.Active__c != oldCriteria.Active__c || newCriteria.Points__c != oldCriteria.Points__c)
			{
				if(!bucketIdsToConsider.contains(newCriteria.Lead_Scoring_Bucket__c))
					bucketIdsToConsider.add(newCriteria.Lead_Scoring_Bucket__c);	
			}
		}	
		
		return bucketIdsToConsider;
	}

	public static Set<Id> getBucketIdsForRecalcuation(List<Lead_Scoring_Bucket_Criteria__c>  bucketCriteria)
	{
		Set<Id> bucketIdsToConsider = new Set<Id>();
		for(Lead_Scoring_Bucket_Criteria__c theCriteria : bucketCriteria)
		{
			if(theCriteria.Lead_Scoring_Bucket__c != null)
			{
				bucketIdsToConsider.add(theCriteria.Lead_Scoring_Bucket__c);
			}
		}	
		
		return bucketIdsToConsider;
	}
		
}