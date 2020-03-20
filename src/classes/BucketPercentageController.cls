public class BucketPercentageController {

    public Decimal Total {get; set;} 
    public String bucketName {get; set;}
    public Boolean shouldUpdateCriteria{get; set;}
    public List<Lead_Scoring_Bucket__c> buckets;
    public list<Lead_Scoring_Bucket_Criteria__c> bucketCriteria = new List<Lead_Scoring_Bucket_Criteria__c>();
    public static string bucketId{get; set;}
    
    public List<Lead_Scoring_Bucket__c> getBuckets() 
    {
      if(ApexPages.currentPage().getParameters().get('BUCKETID') != null)
        bucketId = ApexPages.currentPage().getParameters().get('BUCKETID');
      buckets = [Select id, 
                     Name, 
                     Bucket_percentage__c, 
                     Delete__c,
                     Total_Bucket_Score__c
                     From Lead_Scoring_Bucket__c];
                     
      total =0;  
      for(Lead_Scoring_Bucket__c bucket : buckets)
      {
        total = total+bucket.Bucket_percentage__c;
      }
      return buckets;
    }

    public List<Lead_Scoring_Bucket_Criteria__c> getbucketCriteria()
    {
      if(ApexPages.currentPage().getParameters().get('BUCKETID') != null)
        bucketCriteria = [SELECT Id,
                                    Name,
                                    Criteria__C,
                                    Active__c,
                                    Points__c,
                                    Time_Sensitive__c,
                                    Lead_Scoring_Bucket__r.Id,
                                    Lead_Scoring_Bucket__r.Name
                                    From Lead_Scoring_Bucket_Criteria__c 
                                    WHERE Lead_Scoring_Bucket__r.Id = :ApexPages.currentPage().getParameters().get('BUCKETID')];
        system.debug(bucketCriteria);
        return bucketCriteria;        
                
    }
    
    public PageReference updateCriteria()
   {

     PageReference bucketPercentagePage = Page.bucketPercentage;
     if(!bucketCriteria.isEmpty())
     {
       try
       {
         update bucketCriteria;
       }
       catch(System.DmlException e)
       {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to Update bucketCriteria. Error: '+ e));
       }  
     }
     return null;
   }
  
   public void updateBuckets()
   {  
       Decimal count = 0;
       for(Lead_Scoring_Bucket__c bucket : buckets)
       {
         count = count + bucket.Bucket_percentage__c;
         Total= count;
       }
        
       if(count==100 || count==0)
       {
          try
          {
               update buckets;
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'Successfully updated the bucket percentages'));
          }
          catch(System.DmlException e)
          {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to Update buckets. Error: '+ e));
          }      
       }
       else
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Total Percentage should be 100'));      
   }

   public pagereference insertBucket()
   {
       Lead_Scoring_Bucket__c bucket = new Lead_Scoring_Bucket__c();
       bucket.Name = bucketName;
       bucket.Bucket_Percentage__c = 0;
       try
       {
          Insert bucket;
       }
       catch(System.DmlException e)
       {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to insert bucket. Error: '+ e));
       }
       return null;
  }
   /*
   public pagereference deleteBucket(){
        
        Boolean percentNotZero = true;
       List<Id> ids = new List<Id>();
        Decimal count = 0;
      for(Lead_Scoring_Bucket__c bucket : buckets)
      {
        count = count + bucket.Bucket_percentage__c;
        system.debug(bucket);
        if(bucket.Bucket_percentage__c !=0)
        {
            if(bucket.Delete__c == True)
            {
                ids.add(bucket.Id);
                percentNotZero = false;
                break;
            }
          }
          else
          {
            if(bucket.Delete__c == True)
            {
                ids.add(bucket.Id);
                percentNotZero = True;

            }
          }
        }

      system.debug(percentNotZero);
          List<Lead_Scoring_Bucket_Criteria__c> criteriaList = new List<Lead_Scoring_Bucket_Criteria__c>();
          
          if(!ids.isEmpty())
          criteriaList = [Select Id,
                                    Active__c,
                                    Lead_Scoring_Bucket__r.Id 
                                    From Lead_Scoring_Bucket_Criteria__c 
                                    Where Active__c = True 
                                    And Lead_Scoring_Bucket__r.Id In: ids];
    
          Map<ID,List<Lead_Scoring_Bucket_Criteria__c>> bucketIdToCriteriaMap = new Map<ID,List<Lead_Scoring_Bucket_Criteria__c>>();
          
          for(Lead_Scoring_Bucket_Criteria__c criteria : criteriaList)
          {
            if(bucketIdToCriteriaMap.containsKey(criteria.Lead_Scoring_Bucket__r.Id ))
            {
                bucketIdToCriteriaMap.get(criteria.Lead_Scoring_Bucket__r.Id).add(criteria);
            }
            else
            {
                bucketIdToCriteriaMap.put(criteria.Lead_Scoring_Bucket__r.Id , new List<Lead_Scoring_Bucket_Criteria__c> {criteria});
            }
          }
    
          Boolean canDelete = True;
          List<Lead_Scoring_Bucket__c> bucketsToDelete = new List<Lead_Scoring_Bucket__c>();
          
          If(bucketIdToCriteriaMap != null)
          {
          for(Id bucketID : ids)
           {
               Lead_Scoring_Bucket__c bucket = new Lead_Scoring_Bucket__c(Id = bucketID);
               IF(!bucketIdToCriteriaMap.containsKey(bucketId))
               {
                    bucketsToDelete.add(bucket);
               }
               else
               {
                    IF(bucketIdToCriteriaMap.get(bucketId).size() != 0)
                   {
                        canDelete = false;   
                   }
               }
           }
          }
          system.debug(percentNotZero);
          if(count== 100 || count== 0)
          {
          if(percentNotZero)
          {
               If(canDelete == True)
               {  
                   if(bucketsToDelete.size() != 0)
                   {
                    try{
                         delete bucketsToDelete;
                         //update buckets;
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Bucket has been deleted successfully'));
                       }catch(System.DmlException e){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to delete bucket. Error: '+ e));
                       }
                   }
                   else
                   {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,  'Please select a bucket to delete')); 
                   }
                   return null;
               }
               else
               {
                shouldUpdateCriteria = True;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,  'Some of the buckets have active criteria associated with them. Please deactivate them before deleting the bucket.'+'<a href="/a1W?fcf=00B17000000MNUc&rolodexIndex=-1&page=1&sdtd=1">Update Bucket Criteria</a>'));
                return null;
               }
          }
          else
          {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,  'Please update the bucket percentage to 0 before deleting'));
            return null;             
          }
          }
          else
          {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,  'Total Percentage of rest of the buckets should be 100'));
            return null;
          }

   }*/
}