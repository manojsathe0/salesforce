@isTest
private class BucketPercentageControllerTest {
public static List<Lead_Scoring_Bucket__c> bucketsToInsert  = new List<Lead_Scoring_Bucket__c>();
public static List<Lead_Scoring_Bucket_Criteria__c> bucketCriteria = new List<Lead_Scoring_Bucket_Criteria__c>();
static void setupData()
{
    for(integer i=1;i<=3;i++)
    {
        Lead_Scoring_Bucket__c bucket = new Lead_Scoring_Bucket__c();
        bucket.Name = 'Bucket' + i;
        bucket.Bucket_Percentage__c = 100/3;
        bucketsToInsert.add(bucket);
    }insert bucketsToInsert;
        
    for(integer i=1;i<=9;i++)
    {
        Lead_Scoring_Bucket_Criteria__c criteria = new Lead_Scoring_Bucket_Criteria__c();
        criteria.Active__c = True;
        criteria.criteria__c = 'Test Criteria' + i;
        criteria.Lead_Scoring_Bucket__c = bucketsToInsert[math.Mod(i,3)].Id;
        criteria.Points__c = 1;
        criteria.value__c = 'True';
        bucketCriteria.add(criteria);
    }insert bucketCriteria;
    system.debug(bucketsToInsert);
    system.debug(bucketCriteria);
} 
static testMethod void testGetBucket()
{
    setupData();
    BucketPercentageController bucketController = new BucketPercentageController();
    List<Lead_Scoring_Bucket__c> bucketsToTest =  bucketController.getBuckets();
    system.assertEquals(3,bucketsToTest.size());
}

static testMethod void testGetBucketCriteria()
{
    setupData();
    PageReference pageRef = Page.BucketPercentage;
    pageRef.getParameters().put('BUCKETID', bucketsToInsert[0].id);
    Test.setCurrentPage(pageref);
    BucketPercentageController bucketController = new BucketPercentageController();
    List<Lead_Scoring_Bucket_Criteria__c> bucketCriteriaToTest =  bucketController.getbucketCriteria();
    system.assertEquals(3,bucketCriteriaToTest.size());
}
static testMethod void testUpdateBucketCriteria()
{
    setupData();
    PageReference pageRef = Page.BucketPercentage;
    system.debug(bucketsToInsert[0].id);
    pageRef.getParameters().put('BUCKETID', bucketsToInsert[0].id);
    Test.setCurrentPage(pageref);
    system.debug(pageRef.getParameters().get('BUCKETID'));
    BucketPercentageController bucketController = new BucketPercentageController();
    system.debug(bucketCriteria);
    bucketController.bucketCriteria = bucketCriteria;
    bucketController.bucketCriteria[0].Active__c = False;
    bucketController.updateCriteria();
    List<Lead_Scoring_Bucket_Criteria__c> bucketCriteriaToTest =  [Select ID,Active__c,Lead_Scoring_Bucket__r.Id FROM Lead_Scoring_Bucket_Criteria__c Where Id = :bucketCriteria[0].ID Limit 1];
    system.debug(bucketCriteriaToTest);
    system.assertEquals(False,bucketCriteriaToTest[0].Active__c);
}


static testMethod void testinsertBucket()
{
    PageReference pageRef = Page.BucketPercentage;
    Test.setCurrentPage(pageref);
    BucketPercentageController controller = new BucketPercentageController();
    controller.bucketName = 'test';
    controller.insertBucket();
    
    List<Lead_Scoring_Bucket__c> bucketForAssert = [Select Id,Name,Bucket_Percentage__c From Lead_Scoring_Bucket__c];
    system.assertEquals(bucketForAssert.size(), 1);
    system.assertEquals(bucketForAssert[0].Name, 'test');
    system.assertEquals(bucketForAssert[0].Bucket_Percentage__c,0);
}
/*
static testMethod void testDeleteBucket_WithInactiveCriteria()
{
    setupData();
    
    List<Lead_Scoring_Bucket_Criteria__c> leadBucketCriteria = [Select Id,Active__c,Lead_Scoring_Bucket__c From Lead_Scoring_Bucket_Criteria__c Where Lead_Scoring_Bucket__r.Id =: bucketsToInsert[0].Id];

    for(integer i=2;i>=1;i--)
    {
        bucketsToInsert[i].Bucket_Percentage__c = 50;
    }
    bucketsToInsert[0].Bucket_Percentage__c = 0;
    update bucketsToInsert;
    for(Lead_Scoring_Bucket_Criteria__c criteria : leadBucketCriteria)
    {
        criteria.Active__c = False;
    }update leadBucketCriteria;
    
    PageReference pageRef = Page.BucketPercentage;
    Test.setCurrentPage(pageref);
    BucketPercentageController controller = new BucketPercentageController();
    List<Lead_Scoring_Bucket__c> bucketsForDelete = new List<Lead_Scoring_Bucket__c>();
    bucketsToInsert[0].Delete__c = True;
    bucketsForDelete.add(bucketsToInsert[0]);
    controller.buckets = bucketSForDelete;
    
    Test.StartTest();
    controller.deleteBucket();
    Test.StopTest();
    
    List<Lead_Scoring_Bucket__c> assertBuckets = [Select Id From Lead_Scoring_Bucket__c];
    system.assertEquals(assertBuckets.size(),2);
    system.assertEquals(ApexPages.GetMessages().get(0).getSummary(), 'Bucket has been deleted successfully');
}*/
/*
static testMethod void testDeleteBucket_withActiveCriteria()
{
    setupData();
    for(integer i=2;i>=1;i--)
    {
        bucketsToInsert[i].Bucket_Percentage__c = 50;
    }
    bucketsToInsert[0].Bucket_Percentage__c = 0;
    update bucketsToInsert;
    
    PageReference pageRef = Page.BucketPercentage;
    Test.setCurrentPage(pageref);
    BucketPercentageController controller = new BucketPercentageController();

    List<Lead_Scoring_Bucket__c> bucketsForDelete = new List<Lead_Scoring_Bucket__c>();
    bucketsToInsert[0].Delete__c = True;
    bucketsForDelete.add(bucketsToInsert[0]);
    controller.buckets = bucketSForDelete;
    
    Test.StartTest();
    controller.deleteBucket();
    Test.StopTest();
    
    List<Lead_Scoring_Bucket__c> assertBuckets = [Select Id From Lead_Scoring_Bucket__c];
    system.assertEquals(assertBuckets.size(),3);
    system.assertEquals(ApexPages.GetMessages().get(0).getSummary(), 'Some of the buckets have active criteria associated with them. Please deactivate them before deleting the bucket.<a href="/a1W?fcf=00B17000000MNUc&rolodexIndex=-1&page=1&sdtd=1">Update Bucket Criteria</a>');
}*/
/*
static testMethod void testDeleteNullBucket()
{
    setupData();
    PageReference pageRef = Page.BucketPercentage;
    Test.setCurrentPage(pageref);
    BucketPercentageController controller = new BucketPercentageController();
    List<Lead_Scoring_Bucket__c> bucketsForDelete = new List<Lead_Scoring_Bucket__c>();
    controller.buckets = bucketSForDelete;
    Test.StartTest();
    controller.deleteBucket();
    Test.StopTest();
    
    List<Lead_Scoring_Bucket__c> assertBuckets = [Select Id From Lead_Scoring_Bucket__c];
    system.assertEquals(ApexPages.GetMessages().get(0).getSummary(), 'Please select a bucket to delete');
}*/

static testMethod void testUpdateBucket_percentNotEqualTo100()
{
    setupData();
    List<Lead_Scoring_Bucket__c> buckets = [Select Id,Name,Bucket_Percentage__c From Lead_Scoring_Bucket__c];
    
    for(Lead_Scoring_Bucket__c bucket : buckets)
    {
        bucket.Bucket_Percentage__c = 20;
    }
    
    PageReference pageRef = Page.BucketPercentage;
    Test.setCurrentPage(pageref);
    BucketPercentageController controller = new BucketPercentageController();
    controller.buckets = buckets;
    
    Test.StartTest();
    controller.updateBuckets();
    Test.StopTest();
    
    List<Lead_Scoring_Bucket__c> assertBuckets = [Select Id,Bucket_Percentage__c From Lead_Scoring_Bucket__c];
    system.assertEquals(assertBuckets[0].Bucket_Percentage__c, 33);
    system.assertEquals(ApexPages.GetMessages().get(0).getSummary(), 'Total Percentage should be 100');
}

static testMethod void testUpdateBucket_percentEqualTo100()
{
    setupData();
    List<Lead_Scoring_Bucket__c> buckets = [Select Id,Name,Bucket_Percentage__c From Lead_Scoring_Bucket__c];
    system.debug(buckets);
    
    buckets[0].Bucket_Percentage__c = 20;
    buckets[1].Bucket_Percentage__c = 60;
    buckets[2].Bucket_Percentage__c = 20;
    system.debug(buckets);
    PageReference pageRef = Page.BucketPercentage;
    Test.setCurrentPage(pageref);
    BucketPercentageController controller = new BucketPercentageController();
    controller.buckets = buckets;
    
    Test.StartTest();
    controller.updateBuckets();
    Test.StopTest();
    
    List<Lead_Scoring_Bucket__c> assertBuckets = [Select Id,Name,Bucket_Percentage__c From Lead_Scoring_Bucket__c];
    system.assertEquals(assertBuckets[0].Bucket_Percentage__c, 20);
    system.assertEquals(ApexPages.GetMessages().get(0).getSummary(), 'Successfully updated the bucket percentages');
}
}