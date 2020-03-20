public class NewComplianceReviewController{
    public static String SKIP_RECORDTYPE{
      get{
        if(SKIP_RECORDTYPE == null)
            SKIP_RECORDTYPE = [SELECT Id FROM RecordType WHERE Name = 'Skip' AND SobjectType = 'Compliance_Review__c' LIMIT 1][0].Id;
        return SKIP_RECORDTYPE;
      }
      set;
    }
    public static String SCOREDBASED_RECORDTYPE{
      get{
        if(SCOREDBASED_RECORDTYPE == null)
            SCOREDBASED_RECORDTYPE = [SELECT Id FROM RecordType WHERE Name = 'ScoredBased' AND SobjectType = 'Compliance_Review__c' LIMIT 1][0].Id;
        return SCOREDBASED_RECORDTYPE;
      }
      set;
    }
    
    public static String CCS_SCOREDBASED_RECORDTYPE{
      get{
        if(CCS_SCOREDBASED_RECORDTYPE == null)
            CCS_SCOREDBASED_RECORDTYPE = [SELECT Id FROM RecordType WHERE developername = 'CCS_ScoredBased' AND SobjectType = 'Compliance_Review__c' LIMIT 1][0].Id;
        return CCS_SCOREDBASED_RECORDTYPE;
      }
      set;
    }
    
    public static String TRAINING_RECORDTYPE{
      get{
        if(TRAINING_RECORDTYPE == null)
            TRAINING_RECORDTYPE = [SELECT Id FROM RecordType WHERE Name = 'Training' AND SobjectType = 'Compliance_Review__c' LIMIT 1][0].Id;
        return TRAINING_RECORDTYPE;
      }
      set;
    }
    
    public static String CCS_TRAINING_RECORDTYPE{
      get{
        if(CCS_TRAINING_RECORDTYPE == null)
            CCS_TRAINING_RECORDTYPE = [SELECT Id FROM RecordType WHERE developername = 'CCS_Training' AND SobjectType = 'Compliance_Review__c' LIMIT 1][0].Id;
        return CCS_TRAINING_RECORDTYPE;
      }
      set;
    }
    
    public static String CCS_TEAM_RECORDTYPE{
      get{ 
        if(CCS_TEAM_RECORDTYPE == null)
            CCS_TEAM_RECORDTYPE = [SELECT Id FROM RecordType WHERE developername = 'Service_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        return CCS_TEAM_RECORDTYPE;
      }
      set;
    }
    
    public static String SALES_TEAM_RECORDTYPE{
      get{
        if(SALES_TEAM_RECORDTYPE == null)
            SALES_TEAM_RECORDTYPE = [SELECT Id FROM RecordType WHERE developername = 'Sales_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;
        return SALES_TEAM_RECORDTYPE;
      }
      set;
    }
    
    public User chosenRep{get; set;}
    public Compliance_Review__c compReview{get; set;}
    public String recordedCallId{get; set;}
    public String repName{get; set;}
    public ID repID{get; set;}
    public ID compID{get; set;}
    public Decimal lengthOfCall{get; set;}
    public static final String DUPLICATED_RECORD_CALL_ID_MESSAGE = 'This Recorded Call ID has been used before. Please select another call. Click here to view the record';
    public static final String REP_CANNOT_SELECTED_ANOTHER_EVALUATION_PROCESS_MESSAGE = 'This rep cannot be selected since he/she is in another evaluation process.';
    public static final String CHOOSE_REP_MORE_THAN_LIMIT = 'This rep cannot be selected since he/she is review over limit per month.';
    public static final String COMPLIANCE_REVIEW_EXCLUDE_STATUS = 'Exclude Complete Status';
    public static final String COMPLIANCE_REVIEW_REP_COACHING_COMPLETED_STATUS = 'Rep Coaching Completed';
    public static final String COMPLIANCE_REVIEW_DAY_DELAY = '24Hours';
    public static final String THE_COMPLIANCE_REVIEW = 'Compliance_Review__c';
    public static final String THE_COMPLIANCE_REVIEW_DEVELOPER_NAME = 'ScoredBased';
    public static final String COMPLIANCE_REVIEW_LIMIT_CHOSEN_REP = 'Limit Chosen Rep';
    public static final String CCS_COMPLIANCE_REVIEW_LIMIT_CHOSEN_REP = 'CCS Limit Chosen Rep';
    
    public NewComplianceReviewController(ApexPages.StandardController controller){ 
        this.compReview = new Compliance_Review__c();
    }
    public NewComplianceReviewController(ApexPages.StandardSetController controller){ }
    
    public PageReference newReview()
    { 
        if(!isUnique(this.recordedCallId))
        {
            String URL_SF = '<a href=\''+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.compID + '\'target="_blank">'+DUPLICATED_RECORD_CALL_ID_MESSAGE+''+'</a>';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, URL_SF));
            return null;
        }

        //Get Excluded Reps
        Set<ID> excludedReps = getRepFromComplianceWithoutCompleteStatus();
        List<User> salesRep = [ SELECT Id, Name 
                                FROM User 
                                WHERE ID =: this.repID
                                AND ID NOT IN: excludedReps 
                                AND User.IsActive = true]; 
                                
        //Count Chosen Rep 
        Set<Id> resultCountChosenRep = getComplianceReviewCountLimit_ChosenRep();
        if(salesRep.size() > 0 && resultCountChosenRep.size() > 0)
        {
            if(resultCountChosenRep.contains(salesRep[0].Id))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, CHOOSE_REP_MORE_THAN_LIMIT));
                return null;
            }
        }  
          
        Map<ID, Team_Management__c> mapTM = new Map<ID, Team_Management__c>();  
        for (Team_Management__c allreps: [SELECT id, User__c, Pulled__c, Compliance_Status__c, Recordtypeid FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND User__c IN: salesRep])
        {
            mapTM.put(allreps.User__c, allreps);
        }
        Compliance_Review__c complianceReview = new Compliance_Review__c();
        if(salesRep.size() > 0 && mapTM.size() != 0)
        {
            if(mapTM.get(salesRep[0].Id).pulled__c != true)
            {
                mapTM.get(salesRep[0].Id).pulled__c = true;
                upsert mapTM.values();
            }

            if(mapTM.get(salesRep[0].Id).Compliance_Status__c == 'Training')
            {
                if (mapTM.get(salesRep[0].Id).recordtypeid == CCS_TEAM_RECORDTYPE)
                {
                    complianceReview.RecordTypeId = CCS_TRAINING_RECORDTYPE;
                } else
                {
                  complianceReview.RecordTypeId = TRAINING_RECORDTYPE;  
                }
                
            }
            else
            {
                if (mapTM.get(salesRep[0].Id).recordtypeid == CCS_TEAM_RECORDTYPE)
                {
                   complianceReview.RecordTypeId = CCS_SCOREDBASED_RECORDTYPE; 
                }else
                {
                   complianceReview.RecordTypeId = SCOREDBASED_RECORDTYPE; 
                }
                
            }
            
            complianceReview.Representative__c = salesRep[0].Id;
            complianceReview.Recorded_Call_ID__c = this.recordedCallId;
            complianceReview.Length_of_Call__c = this.lengthOfCall;
                    
            insert complianceReview;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, REP_CANNOT_SELECTED_ANOTHER_EVALUATION_PROCESS_MESSAGE));
            return null;
        }
        
        return new PageReference('/'+complianceReview.Id);
    }
    
    public PageReference skipAndNext()
    {     
        if(this.chosenRep != null)
        {
            this.repID = chosenRep.Id;
        }
        else if(this.chosenRep == null)
        {
            this.repName = null;
            this.repID = null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please choose a rep first'));
            return null;
        }
        
        if(this.repID != null)
        {
            
            List<User> salesRepList = [SELECT Id, Name FROM User WHERE ID =: this.repID AND User.IsActive = true];
            if(salesRepList.size() < 1)
            {
                this.repName = null;
                this.repID = null;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please choose another Rep.'));
                return null;
            }else{
                this.chosenRep = salesRepList[0];
            }
        }

        Compliance_Review__c cr = getSkippedCR();
        
        List<Team_Management__c> listTM = new List<Team_Management__c>();  
        for (Team_Management__c allreps: [SELECT id,User__c, Pulled__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND User__c = :cr.Representative__c])
        {
            allreps.Pulled__c = True;
            listTM.add(allreps);
        }
        update listTM;
        
        insert cr;
        this.chosenRep = null;
        this.repName = null;
        this.repID = null;
        this.recordedCallId = null;
        this.lengthOfCall = null;
        return null;
    }
    
    private Compliance_Review__c getSkippedCR()
    {
        Compliance_Review__c cr = new Compliance_Review__c();
        cr.Representative__c = this.chosenRep.Id;
        cr.RecordTypeId = SKIP_RECORDTYPE;
        cr.Status__c = 'Skipped';
        return cr;
    }
 
    private void checkCycle()
    {
          // Get set of users to include from Team Mgt object
          Map<ID, Team_Management__c> CCSIncludedReps = new Map<ID, Team_Management__c>();
          Map<ID, Team_Management__c> SalesIncludedReps = new Map<ID, Team_Management__c>();
          Map<ID, Team_Management__c> MapCCSIncludedReps = new Map<ID, Team_Management__c>();
          Map<ID, Team_Management__c> MapSalesIncludedReps = new Map<ID, Team_Management__c>();
        
		  Map<ID, Team_Management__c> TrainingCCSIncludedReps = new Map<ID, Team_Management__c>();
          Map<ID, Team_Management__c> TrainingSalesIncludedReps = new Map<ID, Team_Management__c>();
          Map<ID, Team_Management__c> TrainingMapCCSIncludedReps = new Map<ID, Team_Management__c>();
          Map<ID, Team_Management__c> TrainingMapSalesIncludedReps = new Map<ID, Team_Management__c>(); 

          String MonitorDep;
          List<Team_Management__c> usersInSameDept = new List<Team_Management__c>();
          for (Team_Management__c currectuser: [Select Monitored_Department__c, Compliance_Status__c from Team_Management__c where User__c =: Userinfo.getUserId() limit 1]) 
           {
               MonitorDep = currectuser.Monitored_Department__c;               
           }   

           if(MonitorDep == 'Sales')
              usersInSameDept = [SELECT id,User__c, Pulled__c, RecordtypeId, Compliance_Status__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND User__r.IsActive = True AND User__r.ManagerId != null AND recordtypeid =:SALES_TEAM_RECORDTYPE];
           else if(MonitorDep == 'CCS')
              usersInSameDept = [SELECT id,User__c, Pulled__c, RecordtypeId, Compliance_Status__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND User__r.IsActive = True AND User__r.ManagerId != null AND recordtypeid =:CCS_TEAM_RECORDTYPE];

        
          for(Team_Management__c IncludeQA : usersInSameDept)
          {
              
               
                  If(IncludeQA.RecordTypeId == CCS_TEAM_RECORDTYPE && IncludeQA.Compliance_Status__c == 'Live')
                  {
                    if(!IncludeQA.Pulled__c) 
                      CCSIncludedReps.put(IncludeQA.User__c, IncludeQA);
                    MapCCSIncludedReps.put(IncludeQA.Id, IncludeQA);
                  }
                  
                  If(IncludeQA.RecordTypeId == SALES_TEAM_RECORDTYPE && IncludeQA.Compliance_Status__c == 'Live')
                  {
                    if(!IncludeQA.Pulled__c) SalesIncludedReps.put(IncludeQA.User__c, IncludeQA); 
                    MapSalesIncludedReps.put(IncludeQA.Id, IncludeQA);  
                  }
              
              	  If(IncludeQA.RecordTypeId == CCS_TEAM_RECORDTYPE && IncludeQA.Compliance_Status__c == 'Training')
                  {
                    if(!IncludeQA.Pulled__c) TrainingCCSIncludedReps.put(IncludeQA.User__c, IncludeQA);
                    TrainingMapCCSIncludedReps.put(IncludeQA.Id, IncludeQA);
                  }
                  
                  If(IncludeQA.RecordTypeId == SALES_TEAM_RECORDTYPE && IncludeQA.Compliance_Status__c == 'Training')
                  {
                    if(!IncludeQA.Pulled__c) TrainingSalesIncludedReps.put(IncludeQA.User__c, IncludeQA); 
                    TrainingMapSalesIncludedReps.put(IncludeQA.Id, IncludeQA);  
                  }
                  
                
             
          }
        System.debug('CCSIncludedReps' + CCSIncludedReps) ;  
        System.debug('SalesIncludedReps' + SalesIncludedReps);
        
        for( ID UserID : getRepFromComplianceWithoutCompleteStatus())
        {
            CCSIncludedReps.remove(UserID);
            SalesIncludedReps.remove(UserID);
            TrainingCCSIncludedReps.remove(UserID);
            TrainingSalesIncludedReps.remove(UserID);
        }
        
        for( ID UserID : getComplianceReviewCountLimit_ChosenRep())
        {
            CCSIncludedReps.remove(UserID);
            SalesIncludedReps.remove(UserID);
            TrainingCCSIncludedReps.remove(UserID);
            TrainingSalesIncludedReps.remove(UserID);
        }

        
        List<Team_Management__c> pulledUsers = new List<Team_Management__c>();
          
        if(CCSIncludedReps.size() == 0)
        {
              for(Team_Management__c sqa : MapCCSIncludedReps.values())
              {
                  sqa.Pulled__c = false;
                  pulledUsers.add(sqa);
              }
        }
        
        if(SalesIncludedReps.size() == 0)
        {
          	  for(Team_Management__c sqa : MapSalesIncludedReps.values())
              {
                  sqa.Pulled__c = false;
                  pulledUsers.add(sqa);
              }   
        }
        
        if(TrainingCCSIncludedReps.size() == 0)
        {
              for(Team_Management__c sqa : TrainingMapCCSIncludedReps.values())
              {
                  sqa.Pulled__c = false;
                  pulledUsers.add(sqa);
              }
        }
        
        if(TrainingSalesIncludedReps.size() == 0)
        {
          	  for(Team_Management__c sqa : TrainingMapSalesIncludedReps.values())
              {
                  sqa.Pulled__c = false;
                  pulledUsers.add(sqa);
              }   
        }
        
        
        if (pulledUsers.size() != 0) update pulledUsers;
 
    }
    
    public void chooseRandomRep()
    {
        checkCycle();
        try
        {
            this.chosenRep = randomRep;
            this.repName = this.chosenRep.Name;
            this.repID = this.chosenRep.Id;
            this.lengthOfCall = null;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Unable to find a rep.'));
        }
    }
    
    private User randomRep
    {
        get
        {
          // Get Monitored Department from Team Management Object
          String MonitorDep;
          String ComplianceStatus;
            
           for (Team_Management__c currectuser: [Select Monitored_Department__c, Compliance_Status__c from Team_Management__c where User__c =: Userinfo.getUserId() limit 1]) 
           {
               MonitorDep = currectuser.Monitored_Department__c;
			   ComplianceStatus = currectuser.Compliance_Status__c;                
           }
               
     
          // Get set of users to include from Team Mgt object
          Set<ID> IncludedReps = new Set<ID>();
          If (MonitorDep == 'CCS' && ComplianceStatus == 'Live')
          {
            for(Team_Management__c IncludeQA : [SELECT User__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND Compliance_Status__c = 'Live' AND Pulled__c = False AND Recordtypeid =: CCS_TEAM_RECORDTYPE])
          	{
              	IncludedReps.add(IncludeQA.User__c);
          	}  
              
          }else if (MonitorDep == 'CCS' && ComplianceStatus == 'Training')
          {
            for(Team_Management__c IncludeQA : [SELECT User__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND Compliance_Status__c = 'Training' AND Pulled__c = False AND Recordtypeid =: CCS_TEAM_RECORDTYPE])
          	{
              	IncludedReps.add(IncludeQA.User__c);
          	}  
              
          }else if (MonitorDep == 'Sales' && ComplianceStatus == 'Training')
          {
            for(Team_Management__c IncludeQA : [SELECT User__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND Compliance_Status__c = 'Training' AND Pulled__c = False AND Recordtypeid =: SALES_TEAM_RECORDTYPE])
          	{
              	IncludedReps.add(IncludeQA.User__c);
          	}     
          }else
          {
            for(Team_Management__c IncludeQA : [SELECT User__c FROM Team_Management__c WHERE Compliance_Round_Robin__c = True AND Compliance_Status__c = 'Live' AND Pulled__c = False AND Recordtypeid =: SALES_TEAM_RECORDTYPE])
          	{
              	IncludedReps.add(IncludeQA.User__c);
          	}     
          }
          

          //Exclude Rep
          IncludedReps.removeall(getRepFromComplianceWithoutCompleteStatus());  
          IncludedReps.removeall(getComplianceReviewCountLimit_ChosenRep());
          
          // Populate list of eligible Round Robin cycle reps
          Map<ID, User> eligibleReps = new Map<ID, User>(
                                       [SELECT Id, Name, FirstName, LastName, Alias, Login_ID_del__c 
                                        FROM User 
                                        WHERE Id IN :IncludedReps
                                          AND IsActive = true 
                                          AND ManagerId != null 
                                        ORDER BY CreatedDate ASC
                                       ]);
          // Create random list
          List<ID> RandomedUsers = new List<ID>();
          for(User RandomUser: eligibleReps.values()){
            RandomedUsers.add(RandomUser.id);   
          }
          
          if(RandomedUsers.size() > 0){
              Integer rnd = Integer.valueOf(Math.rint(Math.random()*RandomedUsers.size()));
              if(rnd >= RandomedUsers.size()) rnd = RandomedUsers.size() - 1;
              return eligibleReps.get(RandomedUsers[rnd]);
          }
          
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Unable to find a rep.'));
          return null;
        }
    }
    
    private Boolean isUnique(String callId)
    {
        Compliance_Review__c[] lstReviews = [SELECT Id FROM Compliance_Review__c WHERE Recorded_Call_ID__c = :callId AND Recorded_Call_ID__c != null];
        if(lstReviews.size() > 0)
        {
            this.compID = lstReviews[0].Id;
            return false;
        }else{
            return true;
        }
    }

    public Id scoredBasedRecordTypeId
    {
        get
        {
            if(scoredBasedRecordTypeId == null)
            {
                scoredBasedRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType= :THE_COMPLIANCE_REVIEW AND DeveloperName = :THE_COMPLIANCE_REVIEW_DEVELOPER_NAME limit 1].Id;
    
            }
            
            return scoredBasedRecordTypeId;
        }
        set;
    }
    
    public Set<ID> getRepFromComplianceWithoutCompleteStatus()
    {
          Compliance_Review_Status__c compExcludeCompleteStatus = Compliance_Review_Status__c.getInstance(COMPLIANCE_REVIEW_EXCLUDE_STATUS);
          Compliance_Review_Status__c compRepCoachingCompleteStatus = Compliance_Review_Status__c.getInstance(COMPLIANCE_REVIEW_REP_COACHING_COMPLETED_STATUS);
          Compliance_Review_Day_Delay__c compDayDelay = Compliance_Review_Day_Delay__c.getInstance(COMPLIANCE_REVIEW_DAY_DELAY);
          String completeStatus = compExcludeCompleteStatus.Compliance_Status__c;
          List<String> completeStatusComplete = completeStatus.split(', ');

          //Get set of user to exclude for that user already had exist record
          Set<ID> excludedReps = new Set<ID>();
          for(Compliance_Review__c compOld : [SELECT Compliance_Review__c.ID, 
                                                     Compliance_Review__c.Representative__c,
                                                     Compliance_Review__c.Name,
                                                     Compliance_Review__c.Status__c,
                                                     Compliance_Review__c.CreatedDate
                                               FROM Compliance_Review__c 
                                               WHERE (Compliance_Review__c.Status__c NOT IN: completeStatusComplete 
                                               OR (Compliance_Review__c.Status__c =: compRepCoachingCompleteStatus.Compliance_Status__c AND Hours_After_Coaching_Completed__c <=: compDayDelay.Hours_Delay__c))
                                               AND (Compliance_Review__c.RecordTypeId =: scoredBasedRecordTypeId OR compliance_Review__c.RecordTypeId =: CCS_SCOREDBASED_RECORDTYPE)
                                               order by Compliance_Review__c.CreatedDate ASC])
          {
            excludedReps.add(compOld.Representative__c);
          }
          return excludedReps;
    }
    
    public Set<ID> getComplianceReviewCountLimit_ChosenRep()
    {
        //Count Chosen Rep 
        Set<Id> excludeRepChooseMoreThanLimit = new Set<Id>();
        Compliance_Review_Limit_Chosen_Rep__c limitChosenRep = Compliance_Review_Limit_Chosen_Rep__c.getInstance(COMPLIANCE_REVIEW_LIMIT_CHOSEN_REP);
        Compliance_Review_Limit_Chosen_Rep__c CCSlimitChosenRep = Compliance_Review_Limit_Chosen_Rep__c.getInstance(CCS_COMPLIANCE_REVIEW_LIMIT_CHOSEN_REP);
        Integer LIMIT_CHOSEN_REP = Integer.valueOf(limitChosenRep.Limit_Chosen_Rep__c);
        Integer CCS_LIMIT_CHOSEN_REP = Integer.valueOf(CCSlimitChosenRep.Limit_Chosen_Rep__c);
        
        for(AggregateResult results : [Select Representative__c, Recordtypeid, Count(ID) from compliance_review__c WHERE CreatedDate = THIS_MONTH and (RecordTypeId =: SCOREDBASED_RECORDTYPE OR RecordTypeId =:CCS_SCOREDBASED_RECORDTYPE) group by Representative__c, RecordTypeId])
        {
            If((ID)results.get('Recordtypeid') == SCOREDBASED_RECORDTYPE)
            {
                If((Integer)results.get('expr0') >= LIMIT_CHOSEN_REP) 
                  excludeRepChooseMoreThanLimit.add((ID)results.get('Representative__c'));
            }
            
            If((ID)results.get('Recordtypeid') == CCS_SCOREDBASED_RECORDTYPE)
            {
                If((Integer)results.get('expr0') >= CCS_LIMIT_CHOSEN_REP) 
                  excludeRepChooseMoreThanLimit.add((ID)results.get('Representative__c'));
            }
        }
        
        return excludeRepChooseMoreThanLimit;
    }
}