@isTest
private class ScoringServiceTest_Contact {

public static list<string> fields = new String[5];
public static List<Lead_Scoring_Bucket_Criteria__c> NonTimeSensitivecriteria = new List<Lead_Scoring_Bucket_Criteria__c>();
public static List<Lead_Scoring_Bucket_Criteria__c> TimeSensitivecriteria = new List<Lead_Scoring_Bucket_Criteria__c>();    
public static List<Contact> contactsToInsert = new LIST<Contact>();
public static List<ID> contactIds = new LIST<ID>();
public static final string TIME_SENSITIVE_DEVELOPER_NAME = 'Time_Sensitive';
public static final string NON_TIME_SENSITIVE_DEVELOPER_NAME = 'Non_Time_Sensitive';
public static final Datetime CURRENT_DATETIME = system.now();

static
{
        fields.add(0,'Lead_Score_Last_time_on_DBA_Q__c');
        fields.add(1,'Lead_Score_Last_time_on_INC_Q__c'); 
        fields.add(2,'Lead_Score_last_time_on_LLC_Q__c');
        fields.add(3,'Lead_Score_Last_time_on_NP_Q__c');
        fields.add(4,'Lead_score_last_time_on_website__c');
}

public static Map<String,Id> developerNameToRecordTypeIds
    {
        get
        { 
            if(developerNameToRecordTypeIds == null)
            {
                List<RecordType> recordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE sObjectType = 'Lead_Scoring_Bucket_Criteria__c'];    
                developerNameToRecordTypeIds = new Map<String,Id>();
                if(!recordTypes.isEmpty())
                {
                    for(RecordType theRecordType : recordTypes)
                    {
                        developerNameToRecordTypeIds.put(theRecordType.DeveloperName , theRecordType.Id);
                    }
                }
            }
            
            return developerNameToRecordTypeIds;
        }
        set;
    }
 
    static testMethod void testAllDataPoints_InntiailDataPoints() {
        insertData();
        Test.StartTest();
        insertBasicScoringPoints();
        Test.StopTest();

        List<Lead_Scoring_Bucket__c> buckets = [Select Id, Name,Total_Bucket_Score__c From Lead_Scoring_Bucket__c WHERE Name =: 'Bucket4' Limit 1];
        system.assertEquals(buckets[0].Total_Bucket_Score__c,25);

        Contact contact = [Select Id,Contact_Score__c From Contact Where Id =: contactsToInsert[1].Id];
        system.assertEquals(Contact.Contact_Score__c,70);
    }
    
    
    static testMethod void testWrongDataPoints_UpdateDataPoints() {
        insertData();
        insertBasicScoringPoints();
        
        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();                                                                     
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                    scoringPoint.Name = 'Test';
                    scoringPoint.Value__c = '40';
                    scoringPoint.Contact__c = contactsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);
        
        Lead_Attribute__c scoringPoint2 = new Lead_Attribute__c();
                    scoringPoint2.Name = 'Test2';
                    scoringPoint2.Value__c = 'True';
                    scoringPoint2.Contact__c = contactsToInsert[1].Id;
        pointsToInsert.add(scoringPoint2);
        
        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();
        
        Contact contact = [Select Id,Contact_Score__c From Contact Where Id =: contactsToInsert[1].Id];
        system.assertEquals(contact.Contact_Score__c,70);
        
    }
    
    static testMethod void testNullCriteria() {
        insertData();
        insertBasicScoringPoints();
        Contact contact2 = [Select Id,Contact_Score__c From Contact Where Id =: contactsToInsert[1].Id];
        List<Lead_Scoring_Bucket__c> bucket = [Select Id From Lead_Scoring_Bucket__c where name = : 'Bucket1' Limit 1];
        Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test nullCriteria';
                    criteria.Lead_Scoring_Bucket__c = bucket[0].Id;
                    criteria.Value__c = ' ';
                    criteria.points__c = 1;
                    insert criteria;
        
        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();   
        List<Lead_Scoring_Bucket_Criteria__c> nullBucketCriteria = [Select Id,Criteria__c,Name From Lead_Scoring_Bucket_Criteria__c where Criteria__c = : 'Test nullCriteria' Limit 1];                                                               
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                    scoringPoint.Name = nullBucketCriteria[0].name;
                    scoringPoint.Value__c = 'TestNull';
                    scoringPoint.Contact__c = contactsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);
        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();
        
        Contact contact = [Select Id,Contact_Score__c From Contact Where Id =: contactsToInsert[1].Id];
        system.assertEquals(contact.Contact_Score__c,70);
        
        List<Lead_Attribute__c> point = [Select id,points__c From Lead_Attribute__c Where Id =: scoringPoint.id Limit 1];
        system.assertEquals(point[0].points__c, 1);
    }
    
    static testMethod void testUpdateTotalBucketScore() {
        insertData();
        List<Lead_Scoring_Bucket__c> bucket = [Select Id From Lead_Scoring_Bucket__c Limit 1];
        Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test Criteria';
                    criteria.Lead_Scoring_Bucket__c = bucket[0].Id; 
                    criteria.Value__c = 'True';
                    criteria.points__c = 5;
                    
        Test.startTest();
        insert criteria;
        Test.stopTest();
        
        List<Lead_Scoring_Bucket__c> testBucket = [Select Id, Total_Bucket_Score__c From Lead_Scoring_Bucket__c Where Id =: bucket[0].id Limit 1];
        system.assertEquals(testBucket[0].Total_Bucket_Score__c , 10);
    }
    
    static testMethod void testcheckScoreingPointValue()
    {
        insertData();
        List<Lead_Scoring_Bucket__c> bucket = [Select Id From Lead_Scoring_Bucket__c Limit 1];
        
        Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test Criteria';
                    criteria.Lead_Scoring_Bucket__c = bucket[0].Id;
                    criteria.Value__c = 'True,Test';
                    criteria.points__c = 1;
                    insert criteria;
                    
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteria = [Select ID,Name from Lead_Scoring_Bucket_Criteria__c Where Id =: criteria.id Limit 1];
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
            scoringPoint.Name = bucketCriteria[0].name;
            scoringPoint.Value__c = 'True';
            scoringPoint.Contact__c = contactsToInsert[1].Id;
            insert scoringPoint;
            
        system.assertEquals(True,ScoringServiceHelper.checkScoreingPointValue(scoringPoint,Criteria));

        Lead_Attribute__c scoringPoint2 = new Lead_Attribute__c();
            scoringPoint2.Name = bucketCriteria[0].name;
            scoringPoint2.Value__c = 'False';
            scoringPoint2.Contact__c = contactsToInsert[1].Id;
            insert scoringPoint2;
            
        system.assertEquals(False,ScoringServiceHelper.checkScoreingPointValue(scoringPoint2,Criteria));
    } 
    
    static testMethod void testCalculateTotalBUcketScore()
    {
        insertData();
        List<Lead_Scoring_Bucket_Criteria__c> allCriteria = [Select Id,Name,Lead_Scoring_Bucket__r.Id, Points__c,Active__c From Lead_Scoring_Bucket_Criteria__c Where Active__c=True];
        Map<Id,Decimal> bucketScore = ScoringServiceHelper.calculateTotalBUcketScore(allCriteria);
        
        List<Lead_Scoring_Bucket__c> bucket = [Select Id,Total_Bucket_Score__c From Lead_Scoring_Bucket__c Where Name =: 'Bucket1' Limit 1];
        system.assertEquals(bucketScore.get(bucket[0].Id), bucket[0].Total_Bucket_Score__c);
    }
    
    static testMethod void testInsertDuplicatePointsOnMultipleContacts()
    {
        insertData();
        insertBasicScoringPoints();
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteriaNonTimeSensitive = [Select ID,Name from Lead_Scoring_Bucket_Criteria__c Where RecordType.DeveloperName =: NON_TIME_SENSITIVE_DEVELOPER_NAME ];
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteriaTimeSensitive = [Select ID,Name from Lead_Scoring_Bucket_Criteria__c Where RecordType.DeveloperName =: TIME_SENSITIVE_DEVELOPER_NAME];
        
        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        for(Integer contactNumber = 0; contactNumber<=1; contactNumber++)
        {
            for(Integer i =0;i<bucketCriteriaNonTimeSensitive.size();i++)
            {
                Lead_Attribute__c point = new Lead_Attribute__c();
                point.Name = bucketCriteriaNonTimeSensitive[i].name;
                point.Contact__c = contactsToInsert[contactNumber].Id;
                point.Value__c = 'True';
                pointsToInsert.add(point);
            }
            Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                scoringPoint.Name = bucketCriteriaTimeSensitive[0].name;
                scoringPoint.Value__c = String.valueOf(CURRENT_DATETIME.getTime());
                scoringPoint.Contact__c = contactsToInsert[contactNumber].Id;
            pointsToInsert.add(scoringPoint);

        }
        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();
        
        List<Contact> contact = [Select Id,Contact_Score__c From Contact Where Id In: contactsToInsert Limit 2];
        system.assertEquals(contact[0].Contact_Score__c,contact[1].Contact_Score__c);
    }
    
    
    static void insertData()
    {   
        //create account
        List<Account> account = TestUtils.createAccounts(1,'Test Account',True);

        //create contacts
        contactsToInsert =TestUtils.createcontacts(2,'contactScoreTest',account[0].Id,false);
        insert contactsToInsert;
        for(Contact contact : contactsToInsert)
        {
            contactIds.add(contact.id);
        }
        
        //create buckets
        //1. insert non time sensitive bucket
        List<Lead_Scoring_Bucket__c> bucketsToInsert = new List<Lead_Scoring_Bucket__c>();
            for(Integer i = 1; i<=3; i++)
            {
                Lead_Scoring_Bucket__c bucket = new Lead_Scoring_Bucket__c();
                bucket.Name = 'Bucket' + i;
                bucket.Bucket_Percentage__c = 20;
                bucketsToInsert.add(bucket);
            }
            
        //2. insert time sensitive bucket    
            Lead_Scoring_Bucket__c bucket2 = new Lead_Scoring_Bucket__c();
                bucket2.Name = 'Bucket' + 4;
                bucket2.Bucket_Percentage__c = 40;
                bucketsToInsert.add(bucket2);
            insert bucketsToInsert;
        
        //create bucket criteria
        //1. create non time sensitive criteria
            List<Lead_Scoring_Bucket_Criteria__c> criteriaToInsert = new List<Lead_Scoring_Bucket_Criteria__c>();
                for(Integer i =1; i<=15;i++)
                {
                    Integer index = Math.MOD(i,3);
                    Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.RecordTypeId = developerNameToRecordTypeIds.get(NON_TIME_SENSITIVE_DEVELOPER_NAME);
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test Criteria';
                    criteria.Lead_Scoring_Bucket__c = bucketsToInsert[index].Id;
                    criteria.Value__c = 'True,Test';
                    criteria.points__c = 1;
                    criteriaToInsert.add(criteria);
                }
        //2. create time sensitive criteria
            for(Integer i =0; i<=4;i++)
                {
                    Integer index = Math.MOD(i,4);
                    Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.RecordTypeId = developerNameToRecordTypeIds.get(TIME_SENSITIVE_DEVELOPER_NAME);
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test Criteria' + i;
                    criteria.Lead_Scoring_Bucket__c = bucket2.Id;
                    criteria.Value__c = ' ';
                    criteria.points__c = 5;
                    criteria.Lead_API_Field_Name__c = fields[i];
                    criteriaToInsert.add(criteria);
                }insert criteriaToInsert;
                
                NonTimeSensitivecriteria = [select Id,
                                                      Name 
                                                      From Lead_Scoring_Bucket_Criteria__c 
                                                      Where RecordType.DeveloperName = :NON_TIME_SENSITIVE_DEVELOPER_NAME 
                                                      AND Active__c = TRUE];
                TimeSensitivecriteria = [select Id,
                                                  Name 
                                                  From Lead_Scoring_Bucket_Criteria__c 
                                                  Where RecordType.DeveloperName = :TIME_SENSITIVE_DEVELOPER_NAME 
                                                  AND Active__c = TRUE];
    }
    
    static void insertBasicScoringPoints()
    {
                                                                              
        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        for(Integer i =0;i<NonTimeSensitivecriteria.size();i++)
        {
            Lead_Attribute__c point = new Lead_Attribute__c();
            point.Name = NonTimeSensitivecriteria[i].name;
            point.Contact__c = contactsToInsert[1].Id;
            point.Value__c = 'True';
            pointsToInsert.add(point);
        }
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
            scoringPoint.Name = TimeSensitivecriteria[0].name;
            scoringPoint.Value__c = String.valueOf(CURRENT_DATETIME.getTime());
            scoringPoint.Contact__c = contactsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);

        insert pointsToInsert;
        ScoringService.recordIDToBucketToBucketScore.clear(); 
        ScoringService.scoringPoints.clear();
    }
}