public with sharing class ScoringService {

     public static Set<Id> leadIds = new Set<Id>();
     public static Set<Id> contactIds = new Set<Id>();
     public static List<Lead_Attribute__c> scoringPoints = new List<Lead_Attribute__c> ();
     public static List<Lead_Attribute__c> contactScoringPoints = new List<Lead_Attribute__c> ();
     public static Map<Id,Map<Id,Decimal>> recordIDToBucketToBucketScore = new Map<Id,Map<Id,Decimal>>(); 
     public static Map<Id,Decimal> bucketIdToPercentage = new Map<Id,Decimal>();
     public static Map<Id,Decimal> bucketIdToTotalScore = new Map<Id,Decimal>();
     public static Map<String,Lead_Scoring_Bucket_Criteria__c>  bucketCriteriaIdToBucketCriteria = new Map<String, Lead_Scoring_Bucket_Criteria__c>();
     public static List<sObject> objectsToUpdateTotalScore = new List<sObject>();
     public static Map<Id,sObject> objectsToUpdate = new Map<Id,sObject>(); 
     public static List<Lead_Scoring_Bucket_Criteria__c> allBucketCriteria = new List<Lead_Scoring_Bucket_Criteria__c>();
     public static Decimal score = 0;
     public static final string objectStartString = '00Q';
     public static final string TIME_SENSITIVE_DEVELOPER_NAME = 'Time_Sensitive';
     public static final string NON_TIME_SENSITIVE_DEVELOPER_NAME = 'Non_Time_Sensitive';
     
     
     // Method to calculate total score under each individual bucket when a new Lead scoring point is created
     // Also, it calls the duplicateLeadPointDelete method to delete any duplicate scoring points
     public static void scoringServiceMain(List<Lead_Attribute__c> newPoints)
     {
        system.debug(recordIDToBucketToBucketScore);
        Set<String> criteriaNames = new Set<string>();
        Map<ID,Map<String,Lead_Attribute__c>> recordIdToPointNameToPoint = new Map<ID,Map<String,Lead_Attribute__c>>();
        for(Lead_Attribute__c points : newPoints)
        {
            if(Points.Lead__c != null)
            {
                leadIds.add(Points.Lead__c);
            }
            else 
            {
                contactIds.add(Points.Contact__c);
            } 
            if(recordIdToPointNameToPoint.containsKey(points.Parent_id__c)) 
            {
                recordIdToPointNameToPoint.get(points.Parent_id__c).put(points.Name,points);
            }
            else
            {
                Map<String,Lead_Attribute__c> pointNameToPoint = new Map<String,Lead_Attribute__c>();
                pointNameToPoint.put(points.Name,points);
                recordIdToPointNameToPoint.put(points.Parent_id__c, pointNameToPoint);
            }
        }
        
        List<Lead_Attribute__c> existingPoints = new List<Lead_Attribute__c>();
        existingPoints = ScoringServiceHelper.getExistingScoringPoints(leadIds, contactIds);                                                                      
        scoringPoints.addAll(ScoringServiceHelper.identifyDuplicatePoints(existingPoints,recordIdToPointNameToPoint));          
        scoringPoints.addAll(newPoints);
        system.debug(scoringpoints);

        for(Lead_Attribute__c scoringpoint : scoringPoints)
        {
            if(scoringPoint.Name!= null)
            criteriaNames.add(scoringPoint.Name);   
        }                                                  
         allBucketCriteria = [Select Id, 
                                   Name, 
                                   Lead_Scoring_Bucket__r.Id,
                                   Lead_Scoring_Bucket__r.Bucket_Percentage__c, 
                                   Lead_Scoring_Bucket__r.Total_Bucket_Score__c,
                                   Points__c, 
                                   Value__c,
                                   RecordType.DeveloperName,
                                   Lead_API_Field_Name__c,
                                   Show_on_record__c,
                                   Active__c From 
                                   Lead_Scoring_Bucket_Criteria__c Where
                                   Active__c = True And
                                   Name In: criteriaNames];                                                     
                                                                    
        for(Lead_Scoring_Bucket_Criteria__c bucketCriteria : allBucketCriteria)
        {
            bucketCriteriaIdToBucketCriteria.put(bucketcriteria.Name,bucketcriteria);
            bucketIdToPercentage.put(bucketcriteria.Lead_Scoring_Bucket__r.Id,bucketcriteria.Lead_Scoring_Bucket__r.Bucket_Percentage__c);
            bucketIdToTotalScore.put(bucketcriteria.Lead_Scoring_Bucket__r.Id,bucketcriteria.Lead_Scoring_Bucket__r.Total_Bucket_Score__c);
        }
        
        for(Lead_Attribute__c leadPoint : scoringPoints)
        {   Lead_Scoring_Bucket_Criteria__c criteria;
            if(bucketCriteriaIdToBucketCriteria.containsKey(leadPoint.Name))
            {
                criteria = bucketCriteriaIdToBucketCriteria.get(leadPoint.Name);
                leadPoint.Criteria__c = criteria.Id;
            }
            system.debug('Criteri' + criteria); 
            if(criteria != null && criteria.RecordType.DeveloperName == NON_TIME_SENSITIVE_DEVELOPER_NAME)
            {
                if(leadPoint.Parent_id__c.startsWith(objectStartString)) 
                    createNonTimeSenesitivePointsMap(leadPoint,criteria,'Lead');
                else
                    createNonTimeSenesitivePointsMap(leadPoint,criteria, 'Contact');
            }
            else
            {
                if(leadPoint.Parent_id__c.startsWith(objectStartString)) 
                    createTimeSensitivePointsMap(leadPoint,criteria,'Lead');
                else
                    createTimeSensitivePointsMap(leadPoint,criteria, 'Contact');        
            }
        }
        
        if(!recordIDToBucketToBucketScore.isEmpty())
        UpdateTotalScoreOnRecord();
        
        if(!objectsToUpdate.isEmpty())
        updateSobjects(objectsToUpdate);        
    }
    
    //This method creates a map of each lead to bucket to its total score for non time sensitive fields
    public static void createNonTimeSenesitivePointsMap(Lead_Attribute__c leadPoint,Lead_Scoring_Bucket_Criteria__c criteria, String objectName)
    {
        leadPoint.Lead_Scoring_Bucket__c = criteria.Lead_Scoring_Bucket__r.Id;
        if(ScoringServiceHelper.checkScoreingPointValue(leadPoint,criteria))
        {
            system.debug(leadPoint);
            if(leadPoint.Activity__c == false) 
                leadPoint.Points__c = criteria.Points__c;

            if(leadPoint.Activity__c == True && leadPoint.Points__c >criteria.Points__c)
                leadPoint.Points__c = criteria.Points__c;

            addScoringPointToMap(leadPoint, criteria);
            
        }
        else
        {
            leadPoint.Points__c = 0;
            addScoringPointToMap(leadPoint, criteria);
        }
        if(criteria.Show_on_record__c == true)
        {
            sObject objectToUpdate = Schema.getGlobalDescribe().get(objectName).newSObject();
            objectToUpdate.put('ID',leadPoint.Parent_Id__c);
            boolean isBoolean = false;
            system.debug(leadPoint.Value__c);
            system.debug(Boolean.valueOf(leadPoint.Value__c));
            if(leadPoint.Value__c == 'true' || leadPoint.Value__c == 'false')
            {
                isBoolean = true;
            }
            
            if(objectsToUpdate.containsKey(objectToUpdate.Id))
            {
                if(isBoolean)
                    objectsToUpdate.get(objectToUpdate.Id).put(criteria.Lead_API_Field_Name__c, Boolean.valueOf(leadPoint.Value__c));
                else
                    objectsToUpdate.get(objectToUpdate.Id).put(criteria.Lead_API_Field_Name__c, leadPoint.Value__c);
            }
            else
            {
                if(isBoolean)
                    objectToUpdate.put(criteria.Lead_API_Field_Name__c, Boolean.valueOf(leadPoint.Value__c));
                else
                    objectToUpdate.put(criteria.Lead_API_Field_Name__c, leadPoint.Value__c);
                objectsToUpdate.Put(objectToUpdate.Id,objectToUpdate);
            }
        }
        system.debug(objectsToUpdate);
        system.debug(recordIDToBucketToBucketScore);
    }

    
    public static void createTimeSensitivePointsMap(Lead_Attribute__c leadPoint,Lead_Scoring_Bucket_Criteria__c criteria, String objectName)
    {
        system.debug(leadPoint);
        system.debug(criteria);
        
        if(criteria != null && criteria.RecordType.DeveloperName == TIME_SENSITIVE_DEVELOPER_NAME)
        {
            leadPoint.Lead_Scoring_Bucket__c = criteria.Lead_Scoring_Bucket__r.Id;
            
            boolean isdDateTime = true;
            Datetime dateTimeValue;
            system.debug(criteria.Lead_Scoring_Bucket__r.Bucket_Percentage__c);
            /*if(leadPoint.Value__c.contains(','))
            {
                isdDateTime = false;
                List<String> times = leadPoint.Value__c.split(',',2);
                leadPoint.Start_Time__c = Datetime.valueOf(times[0]);
                leadPoint.End_Time__c = Datetime.valueOf(times[1]);
                dataTimeValue = string.valueOf((leadPoint.End_Time__c.getTime()-leadPoint.Start_Time__c.getTime())/(1000*60));
            }*/
            if(leadPoint.Value__c != null)
            {
            
                            dateTimeValue = DateTime.newInstance(Long.valueOf(leadPoint.Value__c));
                        
            
            system.debug(objectsToUpdate);
            sObject objectToUpdate = Schema.getGlobalDescribe().get(objectName).newSObject();
            objectToUpdate.put('ID',leadPoint.Parent_Id__c);
            
            if(objectsToUpdate.containsKey(objectToUpdate.Id))
            {
                objectsToUpdate.get(objectToUpdate.Id).put('Lead_score_time_sensitive_bucket_total__c',criteria.Lead_Scoring_Bucket__r.Total_Bucket_Score__c);
                objectsToUpdate.get(objectToUpdate.Id).put('Lead_Score_Time_sensitive_bucket_percent__c',criteria.Lead_Scoring_Bucket__r.Bucket_Percentage__c);
                if(isdDateTime)
                    objectsToUpdate.get(objectToUpdate.Id).put(criteria.Lead_API_Field_Name__c,dateTimeValue);
            
            }
            else
            {
                objectToUpdate.put('Lead_score_time_sensitive_bucket_total__c',criteria.Lead_Scoring_Bucket__r.Total_Bucket_Score__c);
                objectToUpdate.put('Lead_Score_Time_sensitive_bucket_percent__c',criteria.Lead_Scoring_Bucket__r.Bucket_Percentage__c);
                system.debug(criteria.Lead_API_Field_Name__c);
                system.debug(dateTimeValue);
                objectToUpdate.put(criteria.Lead_API_Field_Name__c,dateTimeValue);
                
                objectsToUpdate.Put(objectToUpdate.Id,objectToUpdate);
            }system.debug(objectsToUpdate);
        }
        else
        {
            leadPoint.Points__c = 0;
        }
     }
    }

    public static void UpdateTotalScoreOnRecord()
    {
        objectsToUpdateTotalScore = new List<sObject>();
        Set<ID> recordIds = leadIds;
        recordIds.addAll(contactIds);
        for(ID objectId : recordIds)
        {
            if(objectsToUpdate.containsKey(objectId))
            {
                objectsToUpdate.get(objectId).put('Lead_Score_Non_Time_Sensitive__c',ScoringServiceHelper.getTotalScore(objectId,recordIDToBucketToBucketScore,bucketIdToTotalScore,bucketIdToPercentage));
            }
            else
            {
                sObject objectToUpdate;
                if(string.ValueOf(objectId).startsWith(objectStartString))
                objectToUpdate = Schema.getGlobalDescribe().get('Lead').newSObject();
                else
                objectToUpdate = Schema.getGlobalDescribe().get('Contact').newSObject();
                objectToUpdate.put('ID',objectId);
                objectToUpdate.put('Lead_Score_Non_Time_Sensitive__c',ScoringServiceHelper.getTotalScore(objectId,recordIDToBucketToBucketScore,bucketIdToTotalScore,bucketIdToPercentage));
                objectsToUpdate.put(objectId,objectToUpdate);
                }
        }
        
        
        
    }
    
    //method to update Lead and contact with time sensitive scoring points  
    public static void updateSobjects(Map<id,sObject> sObjectMap)
    {
        list<sObject> sObjects = new List<sObject>();
        for(id sObjectid : sObjectMap.keySet())
        {
            sObjects.add(sObjectMap.get(sObjectid));
        }
        
        if(!sObjects.isEmpty())
        {
            try
            {
                ContactManagerController.canUpdateContact = true;
                system.debug(sObjects);
                update sObjects;
            }
            catch(System.DmlException e)
            {
                for(Integer i = 0 ;i <e.getNumDml(); ++i)
                {
                    sObjects[e.getDmlIndex(i)].addError('Failed to update the record with time sensitive information'+ e.getDmlMessage(i)+', ID: '+ e.getDmlId(i));
                }
            }
        }
    }

    public static void addScoringPointToMap(Lead_Attribute__c leadPoint, Lead_Scoring_Bucket_Criteria__c bucketCriteria)
    {
        if(recordIDToBucketToBucketScore.containsKey(leadPoint.Parent_id__c))
            {
                if(recordIDToBucketToBucketScore.get(leadPoint.Parent_id__c).containsKey(bucketCriteria.Lead_Scoring_Bucket__r.Id))
                {
                    score = leadPoint.Points__c + recordIDToBucketToBucketScore.get(leadPoint.Parent_id__c).get(bucketCriteria.Lead_Scoring_Bucket__r.Id);
                    recordIDToBucketToBucketScore.get(leadPoint.Parent_id__c).put(bucketCriteria.Lead_Scoring_Bucket__r.Id,score);
                }
                else
                {
                    Map<Id,List<Decimal>> tempMap = new Map<Id,List<Decimal>>();
                    recordIDToBucketToBucketScore.get(leadPoint.Parent_id__c).put(bucketCriteria.Lead_Scoring_Bucket__r.Id,leadPoint.Points__c);
                }
            }
            else
            {
                Map<Id,Decimal> tempMap = new Map<Id,Decimal>();
                tempMap.put(bucketCriteria.Lead_Scoring_Bucket__r.Id,leadPoint.Points__c);
                recordIDToBucketToBucketScore.put(leadPoint.Parent_id__c,tempMap);
            }
    }
}