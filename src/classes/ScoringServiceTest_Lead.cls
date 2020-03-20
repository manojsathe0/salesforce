@isTest
public class ScoringServiceTest_Lead {

public static list<string> fields = new String[5];
public static List<Lead_Scoring_Bucket_Criteria__c> NonTimeSensitivecriteria = new List<Lead_Scoring_Bucket_Criteria__c>();
public static List<Lead_Scoring_Bucket_Criteria__c> TimeSensitivecriteria = new List<Lead_Scoring_Bucket_Criteria__c>();
public static List<Lead> leadsToInsert = new LIST<Lead>();
public static List<ID> leadIds = new LIST<ID>();
public static final string TIME_SENSITIVE_DEVELOPER_NAME = 'Time_Sensitive';
public static final string NON_TIME_SENSITIVE_DEVELOPER_NAME = 'Non_Time_Sensitive';
public static final string FIELD_API_NAME_BOOLEAN = 'Viewed_Pricing_Page__c';
public static final string FIELD_API_NAME_NOT_BOOLEAN = 'Questionnaire_Lead_Milestone__c';
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
    static testMethod void testUpdateCriteriaWithDiffBuckets()
    {
        insertData();
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteria1 = [Select Id, Active__c, Lead_Scoring_Bucket__r.Name from Lead_Scoring_Bucket_Criteria__c where Lead_Scoring_Bucket__r.Name = : 'Bucket1'];
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteria2 = [Select Id, Active__c,Lead_Scoring_Bucket__r.Name from Lead_Scoring_Bucket_Criteria__c where Lead_Scoring_Bucket__r.Name = : 'Bucket2'];
        for( Lead_Scoring_Bucket_Criteria__c criteria : bucketCriteria1)
        {
            criteria.Lead_Scoring_Bucket__c = bucketCriteria2[0].Lead_Scoring_Bucket__c;
        }
        Test.startTest();
         update bucketCriteria1;
        Test.stopTest();

        List<Lead_Scoring_Bucket__c> buckets = [Select Id, Total_Bucket_Score__c From Lead_Scoring_Bucket__c where Name =: 'Bucket1'];
        system.assertEquals(buckets[0].Total_Bucket_Score__c,5);

    }
    static testMethod void testAllDataPoints_InitiailDataPoints() {
        insertData();
        Test.StartTest();
        insertBasicScoringPoints();
        Test.StopTest();

        List<Lead_Scoring_Bucket__c> buckets = [Select Id, Name,Total_Bucket_Score__c From Lead_Scoring_Bucket__c WHERE Name =: 'Bucket4' Limit 1];
        system.assertEquals(buckets[0].Total_Bucket_Score__c,25);

        Lead lead = [Select Id,Lead_Score__c From Lead Where Id =: leadsToInsert[1].Id];
        system.debug(lead);
         //Lead Score becomes 70+30 = 100.Any leads that are created today gets flat score of 30 on top od existing score.If that is changed
        //this assertion has to be adjusted
        system.assertEquals(lead.Lead_Score__c,100);
    }


    static testMethod void testWrongDataPoints_UpdateDataPoints() {
        insertData();
        insertBasicScoringPoints();

        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                    scoringPoint.Name = 'Test';
                    scoringPoint.Value__c = '40';
                    scoringPoint.Lead__c = leadsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);

        Lead_Attribute__c scoringPoint2 = new Lead_Attribute__c();
                    scoringPoint2.Name = 'Test2';
                    scoringPoint2.Value__c = 'True';
                    scoringPoint2.Lead__c = leadsToInsert[1].Id;
        pointsToInsert.add(scoringPoint2);

        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();

        Lead lead = [Select Id,Lead_Score__c From Lead Where Id =: leadsToInsert[1].Id];
        //Lead Score becomes 70+30 = 100.Any leads that are created today gets flat score of 30 on top od existing score.If that is changed
        //this assertion has to be adjusted
        system.assertEquals(lead.Lead_Score__c,100);

    }

    static testMethod void testNullCriteria() {
        insertData();
        insertBasicScoringPoints();
        Lead lead2 = [Select Id,Lead_Score__c From Lead Where Id =: leadsToInsert[1].Id];
        List<Lead_Scoring_Bucket__c> bucket = [Select Id From Lead_Scoring_Bucket__c where name = : 'Bucket1' Limit 1];
        Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.Name = 'TestCriteria_Null';
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
                    scoringPoint.Lead__c = leadsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);

        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();

        Lead lead = [Select Id,Lead_Score__c From Lead Where Id =: leadsToInsert[1].Id];
        //Lead Score becomes 70+30 = 100.Any leads that are created today gets flat score of 30 on top od existing score.If that is changed
        //this assertion has to be adjusted
        system.assertEquals(lead.Lead_Score__c,100);

        List<Lead_Attribute__c> point = [Select id,points__c, name From Lead_Attribute__c Where Name =: criteria.Name Limit 1];
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
            scoringPoint.Lead__c = leadsToInsert[1].Id;
            insert scoringPoint;

        system.assertEquals(True,ScoringServiceHelper.checkScoreingPointValue(scoringPoint,Criteria));

        Lead_Attribute__c scoringPoint2 = new Lead_Attribute__c();
            scoringPoint2.Name = bucketCriteria[0].name;
            scoringPoint2.Value__c = 'False';
            scoringPoint2.Lead__c = leadsToInsert[1].Id;
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

    static testMethod void testInsertDuplicatePointsOnMultipleLeads()
    {
        insertData();
        insertBasicScoringPoints();
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteriaNonTimeSensitive = [Select ID,Name from Lead_Scoring_Bucket_Criteria__c Where RecordType.DeveloperName = :NON_TIME_SENSITIVE_DEVELOPER_NAME ];
        List<Lead_Scoring_Bucket_Criteria__c> bucketCriteriaTimeSensitive = [Select ID,Name from Lead_Scoring_Bucket_Criteria__c Where RecordType.DeveloperName = :TIME_SENSITIVE_DEVELOPER_NAME];

        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        for(Integer leadNumber = 0; leadNumber<=1; leadNumber++)
        {
            for(Integer i =0;i<bucketCriteriaNonTimeSensitive.size();i++)
            {
                Lead_Attribute__c point = new Lead_Attribute__c();
                point.Name = bucketCriteriaNonTimeSensitive[i].name;
                point.Lead__c = leadsToInsert[leadNumber].Id;
                point.Value__c = 'True';
                pointsToInsert.add(point);
            }
            Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                scoringPoint.Name = bucketCriteriaTimeSensitive[0].name;
                scoringPoint.Value__c = String.valueOf(CURRENT_DATETIME.getTime());
                scoringPoint.Lead__c = leadsToInsert[leadNumber].Id;
            pointsToInsert.add(scoringPoint);

        }
        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();

        List<Lead> lead = [Select Id,Lead_Score__c From Lead Where Id In: leadsToInsert Limit 2];
        system.assertEquals(lead[0].Lead_Score__c,lead[1].Lead_Score__c);
    }
    static testMethod void testPopulateDataOnRecordBoolean() {
        insertData();
        insertBasicScoringPoints();
        Lead lead2 = [Select Id,Lead_Score__c From Lead Where Id =: leadsToInsert[1].Id];
        List<Lead_Scoring_Bucket__c> bucket = [Select Id From Lead_Scoring_Bucket__c where name = : 'Bucket1' Limit 1];
        Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.Name = 'Data_on_Record';
                    criteria.RecordTypeId = developerNameToRecordTypeIds.get(NON_TIME_SENSITIVE_DEVELOPER_NAME);
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test_populate_on_record';
                    criteria.Lead_Scoring_Bucket__c = bucket[0].Id;
                    criteria.Value__c = ' ';
                    Criteria.Show_on_record__c = true;
                    Criteria.Lead_API_Field_Name__c =  FIELD_API_NAME_BOOLEAN;
                    criteria.points__c = 1;
                    insert criteria;

        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        List<Lead_Scoring_Bucket_Criteria__c> BucketCriteria = [Select Id,Criteria__c,Name From Lead_Scoring_Bucket_Criteria__c where Criteria__c = : 'Test_populate_on_record' Limit 1];
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                    scoringPoint.Name = 'Data_on_Record';
                    scoringPoint.Value__c = 'true';
                    scoringPoint.Lead__c = leadsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);
        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();

        Lead lead = [Select Id,Lead_Score__c, Viewed_Pricing_Page__c From Lead Where Id =: leadsToInsert[1].Id];
        system.assertEquals(Lead.Viewed_Pricing_Page__c,true);

        List<Lead_Attribute__c> point = [Select id,points__c From Lead_Attribute__c Where Id =: scoringPoint.id Limit 1];
        system.assertEquals(point[0].points__c, 1);
    }

    static testMethod void testPopulateDataOnRecordNotBoolean() {
        insertData();
        insertBasicScoringPoints();
        Lead lead2 = [Select Id,Lead_Score__c From Lead Where Id =: leadsToInsert[1].Id];
        List<Lead_Scoring_Bucket__c> bucket = [Select Id From Lead_Scoring_Bucket__c where name = : 'Bucket1' Limit 1];
        Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.Name = 'Data_on_Record';
                    criteria.RecordTypeId = developerNameToRecordTypeIds.get(NON_TIME_SENSITIVE_DEVELOPER_NAME);
                    criteria.Active__c = True;
                    criteria.Criteria__c = 'Test_populate_on_record';
                    criteria.Lead_Scoring_Bucket__c = bucket[0].Id;
                    criteria.Value__c = ' ';
                    Criteria.Show_on_record__c = true;
                    Criteria.Lead_API_Field_Name__c =  FIELD_API_NAME_NOT_BOOLEAN;
                    criteria.points__c = 1;
                    insert criteria;

        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        List<Lead_Scoring_Bucket_Criteria__c> BucketCriteria = [Select Id,Criteria__c,Name From Lead_Scoring_Bucket_Criteria__c where Criteria__c = : 'Test_populate_on_record' Limit 1];
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
                    scoringPoint.Name = 'Data_on_Record';
                    scoringPoint.Value__c = 'Test';
                    scoringPoint.Lead__c = leadsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);
        Test.startTest();
        insert pointsToInsert;
        Test.stopTest();

        Lead lead = [Select Id,Lead_Score__c, Viewed_Pricing_Page__c,Questionnaire_Lead_Milestone__c From Lead Where Id =: leadsToInsert[1].Id];
        system.assertEquals(Lead.Questionnaire_Lead_Milestone__c,'Test');

        List<Lead_Attribute__c> point = [Select id,points__c From Lead_Attribute__c Where Id =: scoringPoint.id Limit 1];
        system.assertEquals(point[0].points__c, 1);
    }


    static void insertData()
    {
        //create leads
        leadsToInsert =TestUtils.createLeads(2,'LeadScoreTest',false);
        insert leadsToInsert;
        for(Lead lead : leadsToInsert)
        {
            leadIds.add(lead.id);
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
                    criteria.Name = 'Criteri'+i;
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
                    criteria.Name = 'CriteriTS'+i;
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
    /*
    public static Map<String,String> insertActivityScoringBucketCriteria()
    {
        insertData();
        Map<String,String> criteriaToCriteriaName = new Map<String,String>();
        List<Lead_Scoring_Bucket__c> nonTimeSensitivebucket = [Select Id,Name From Lead_Scoring_Bucket__c Where Name = : 'Bucket1' Limit 1];
        List<Lead_Scoring_Bucket__c> timeSensitivebucket = [Select Id,Name From Lead_Scoring_Bucket__c Where Name = : 'Bucket4' Limit 1];
        List<Lead_Scoring_Bucket_Criteria__c> scoringBucketCriteriaToInsert = new  List<Lead_Scoring_Bucket_Criteria__c>();
        for(String customSettingName : TaskService.allScoringCustomSettingNonTimeSensitive)
        {
            Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.RecordTypeId = developerNameToRecordTypeIds.get(NON_TIME_SENSITIVE_DEVELOPER_NAME);
                    criteria.Active__c = True;
                    criteria.Criteria__c = customSettingName;
                    criteria.Lead_Scoring_Bucket__c = nonTimeSensitivebucket[0].Id;
                    criteria.Value__c = 'True,Test';
                    criteria.points__c = 5;
                    scoringBucketCriteriaToInsert.add(criteria);
        }
        integer i = 5;
        for(String customSettingName : TaskService.allScoringCustomSettingTimeSensitive)
        {
            Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
                    criteria.RecordTypeId = developerNameToRecordTypeIds.get(TIME_SENSITIVE_DEVELOPER_NAME);
                    criteria.Active__c = True;
                    criteria.Criteria__c = customSettingName;
                    criteria.Lead_Scoring_Bucket__c = timeSensitivebucket[0].Id;
                    criteria.Value__c = 'True,Test';
                    Criteria.Lead_API_Field_Name__c = fields[i];
                    //criteria.Time_Sensitive__c = true;
                    criteria.points__c = 5;
                    scoringBucketCriteriaToInsert.add(criteria);
                    i++;
        }

        insert scoringBucketCriteriaToInsert;

        List<Lead_Scoring_Bucket_Criteria__c> insertedCriteria = [Select Id, Name, Criteria__c 
                                                                  From Lead_Scoring_Bucket_Criteria__c 
                                                                  Where Criteria__c in: TaskService.allScoringCustomSettingNonTimeSensitive 
                                                                  or Criteria__c in: TaskService.allScoringCustomSettingTimeSensitive];
        for(Lead_Scoring_Bucket_Criteria__c theCriteria : insertedCriteria)
        {
            criteriaToCriteriaName.put(theCriteria.Criteria__c, theCriteria.Name);
        }
        return criteriaToCriteriaName;
    }*/

    static void insertBasicScoringPoints()
    {
        List<Lead_Attribute__c> pointsToInsert = new List<Lead_Attribute__c>();
        for(Integer i =0;i<NonTimeSensitivecriteria.size();i++)
        {
            Lead_Attribute__c point = new Lead_Attribute__c();
            point.Name = NonTimeSensitivecriteria[i].name;
            point.Lead__c = leadsToInsert[1].Id;
            point.Value__c = 'True';
            pointsToInsert.add(point);
        }
        Lead_Attribute__c scoringPoint = new Lead_Attribute__c();
            scoringPoint.Name = TimeSensitivecriteria[0].name;
            scoringPoint.Value__c =  String.valueOf(CURRENT_DATETIME.getTime());
            scoringPoint.Lead__c = leadsToInsert[1].Id;
        pointsToInsert.add(scoringPoint);


        for(Lead_Attribute__c point : pointsToInsert)
        {
            system.debug(point+'Point test');
        }
        insert pointsToInsert;
        ScoringService.recordIDToBucketToBucketScore.clear();
        ScoringService.scoringPoints.clear();
    }
}