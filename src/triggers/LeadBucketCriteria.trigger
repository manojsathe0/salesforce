trigger LeadBucketCriteria on Lead_Scoring_Bucket_Criteria__c (after delete,after update, after insert) {

//get Changed Buckets
Set<Id> bucketIds = new Set<Id>();
if(Trigger.isDelete)
{
	bucketIds = ScoringServiceHelper.getBucketIdsForRecalcuation(Trigger.old);
}
else if(Trigger.isUpdate)
{
	bucketIds = ScoringServiceHelper.getBucketIdsForRecalcuationForUpdate(Trigger.oldMap , Trigger.newMap);

}
else if(Trigger.isInsert)
{
	bucketIds = ScoringServiceHelper.getBucketIdsForRecalcuation(Trigger.new);
}
ScoringServiceHelper.updateTotalBucketScore(bucketIds);

}