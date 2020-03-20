public without sharing class CaseService{
    public static Map<String,Id> queueDeveloperNameToQueueId = new Map<String,Id>();
    public static final String DEFAULT_QUEUEMAP = 'QueueMap';
    public static final String PROBLEM = 'Problem';
    
    public static List<Case> getCasesWithQueueChanged(List<Case> oldCases , Map<Id, Case> newCases){
        List<Case> changedCases = new List<Case>();
        for(Case oldCase : oldCases){
            Case newCase = newCases.get(oldCase.Id);
            if(oldCase.Queue__c != newCase.Queue__c || oldCase.OwnerId != newCase.OwnerId)
                changedCases.add(newCase);
        }
        return changedCases;
    }
    
    public static void populateCaseOwnerForNewIncomingCases(List<Case> newCases){
        Map<String,Id> queueNameToQueueId = getQueueNameToQueueId();
        Map<String, QueueMap__c> emailOriginToQueueMap = new Map<String, QueueMap__c>();
        for(QueueMap__c qMap : QueueMap__c.getAll().values())
            if(qMap.Origin__c != null)
                emailOriginToQueueMap.put(qMap.Origin__c.toLowerCase(), qMap);
        
        Map<ID, ID> mapContactIdToAcctMgrId = getContactIdToAcctMgrId(newCases);
        updateCaseOwnerForInsert(newCases, queueNameToQueueId, emailOriginToQueueMap, mapContactIdToAcctMgrId);
    }
    
    public static void populateCaseOwnerForChangedQueue(List<Case> newCases){
        Map<String,Id> queueNameToQueueId = getQueueNameToQueueId();
        Map<ID, ID> mapContactIdToAcctMgrId = getContactIdToAcctMgrId(newCases);
        updateCaseOwnerForUpdate(newCases, queueNameToQueueId, new Map<String, QueueMap__c>(), mapContactIdToAcctMgrId);
    }
    
    public static Set<String> getAMoverrideOrigins(Map<String, QueueMap__c> queueMapping){
        Set<String> setAMoverrideOrigins = new Set<String>();
        for(QueueMap__c qMap : queueMapping.values())
            if(qMap.AM_Queue_Name__c != null && qMap.Origin__c != null)
                setAMoverrideOrigins.add(qMap.Origin__c);
        
        return setAMoverrideOrigins;
    }
    
    public static Map<ID, ID> getContactIdToAcctMgrId(List<Case> newCases){
        Set<String> setAMoverrideOrigins = getAMoverrideOrigins(QueueMap__c.getAll());
        Map<ID, ID> mapContactIdToAcctMgrId = new Map<ID, ID>();
        Set<ID> setContactIds = new Set<ID>();
        for(Case theCase : newCases)
            if(theCase.ContactId != null && setAMoverrideOrigins.contains(theCase.Origin))
                setContactIds.add(theCase.ContactId);
        
        Contact[] lstContacts = [SELECT Id, Account.Business_Account_Manager__c 
                                 FROM Contact 
                                 WHERE Id IN :setContactIds 
                                   AND Account.Business_Account_Manager__c != null];
        for(Contact c : lstContacts)
            mapContactIdToAcctMgrId.put(c.Id, c.Account.Business_Account_Manager__c);
        
        return mapContactIdToAcctMgrId;
    }
    
    public static Map<String, Id> getQueueNameToQueueId(){
        Map<String,Id> queueNameToQueueId = new Map<String,Id>();
        for(Group q : [SELECT Id,Name, DeveloperName FROM Group WHERE Type = 'Queue']){
            queueNameToQueueId.put(q.Name, q.Id); 
            queueDeveloperNameToQueueId.put(q.DeveloperName , q.Id);
            
        }
        return queueNameToQueueId;
    }
    
    public static Map<String, String> getQueueDevNameToName(){
        Map<String,String> queueDevNameToName = new Map<String,String>();
        for(Group q : [SELECT DeveloperName, Name FROM Group WHERE Type = 'Queue'])
            queueDevNameToName.put(q.DeveloperName , q.Name);  
        return queueDevNameToName;
    }
    
    public static String EmailAddress{
        get{
            if(EmailAddress == null){
                Map<String,SalesforceTeamEmail__c> salesforceTeamEmails = SalesforceTeamEmail__c.getAll();
                if(!salesforceTeamEmails.isEmpty())
                    EmailAddress = salesforceTeamEmails.get('Salesforce Team').Email__c;
            }
            return EmailAddress;    
        }
    }
    
    public static void updateCaseOwnerForUpdate(List<Case> newCases, Map<String, Id> queueNameToQueueId, Map<String , QueueMap__c> emailOriginToQueueMap, Map<ID, ID> mapContactIdToAcctMgrId){
        List<Case> casesToUpdate = new List<Case>();
        Map<String, String> queueDevNameToName = getQueueDevNameToName();
        for(Case theCase : newCases){
            System.debug('Entering case loop in updateCaseOwner');
            
            // Use Case.Queue__c field to set owner if it is not null
            if(theCase.Queue__c != null){
                System.debug('theCase.Queue__c: ' + theCase.Queue__c);
                if(queueNameToQueueId.containsKey(theCase.Queue__c)){
                    Id ownerId = queueNameToQueueId.get(theCase.Queue__c);
                    theCase.OwnerId = ownerId;
                    if(theCase.ContactId != null && mapContactIdToAcctMgrId.containsKey(theCase.ContactId))
                        theCase.Assigned_User__c = mapContactIdToAcctMgrId.get(theCase.ContactId);
                }
            }
        }
    }
    
    public static void updateCaseOwnerForInsert(List<Case> newCases, Map<String, Id> queueNameToQueueId, Map<String , QueueMap__c> emailOriginToQueueMap, Map<ID, ID> mapContactIdToAcctMgrId){
        List<Case> casesToUpdate = new List<Case>();
        Map<String, String> queueDevNameToName = getQueueDevNameToName();
        for(Case theCase : newCases){
            System.debug('Entering case loop in updateCaseOwner');
            String lowerCaseOrigin = '';
            if(theCase.Origin != null)
                lowerCaseOrigin = theCase.Origin.toLowerCase();
            else
                lowerCaseOrigin = theCase.Origin;
            // Use Case.Queue__c field to set owner if it is not null
            if(theCase.Queue__c != null){
                System.debug('theCase.Queue__c: ' + theCase.Queue__c);
                if(queueNameToQueueId.containsKey(theCase.Queue__c)){
                    Id ownerId = queueNameToQueueId.get(theCase.Queue__c);
                    theCase.ownerId = ownerId;
                    if(theCase.ContactId != null && mapContactIdToAcctMgrId.containsKey(theCase.ContactId))
                        theCase.Assigned_User__c = mapContactIdToAcctMgrId.get(theCase.ContactId);
                }
            // Use origin if Case.Queue__c field is null
            }else if(emailOriginToQueueMap.containsKey(lowerCaseOrigin) && emailOriginToQueueMap.get(lowerCaseOrigin) != null){
                System.debug(emailOriginToQueueMap.get(lowerCaseOrigin));
                // If Case has account manager, set owner to AM Queue
                if(mapContactIdToAcctMgrId.containsKey(theCase.ContactId) && emailOriginToQueueMap.get(lowerCaseOrigin).AM_Queue_Name__c != null){
                    theCase.OwnerId = queueDeveloperNameToQueueId.get(emailOriginToQueueMap.get(lowerCaseOrigin).AM_Queue_Name__c);
                    theCase.Queue__c = queueDevNameToName.get(emailOriginToQueueMap.get(lowerCaseOrigin).AM_Queue_Name__c);
                    theCase.Assigned_User__c=mapContactIdToAcctMgrId.get(theCase.ContactId);
                // Otherwise, set owner to regular Queue for that origin
                }else if(!mapContactIdToAcctMgrId.containsKey(theCase.ContactId) && emailOriginToQueueMap.get(lowerCaseOrigin).Queue_Name__c != null){
                    Id ownerId = queueDeveloperNameToQueueId.get(emailOriginToQueueMap.get(lowerCaseOrigin).Queue_Name__c);
                    String queuename = queueDevNameToName.get(emailOriginToQueueMap.get(lowerCaseOrigin).Queue_Name__c);
                    // If owner = null, assign default queuemap to owner to let case to be created
                    If (ownerId == null){
                         QueueMap_Default__c defaultqueue = QueueMap_Default__c.getinstance(DEFAULT_QUEUEMAP);
                         queuename = defaultqueue.Default_Queue_Name__c;
                         ownerId = queueNameToQueueId.get(defaultqueue.Default_Queue_Name__c);
                    }
                    theCase.OwnerId = ownerId;
                    theCase.Queue__c = queuename;
                }
            }
        }
    }
    
    @future (callout=true)
    //Padma @B-28019
   // @InvocableMethod(label='problemCaseCloseUpdates' description='updates the case and related records on clase closure')
    public static void problemCaseCloseUpdates( List<ID> closedIds){ 
        system.debug(' list of ids '+closedIds);
        set<id> manualoes = new set<id>();
        set<id> triggerdds = new set<id>();
        List<case> manualcases = new list<case>();
        List<Case> closedcases = New List<Case>([SELECT Id,Processing_Number__c,Order_Exception__c,Count_of_unresolved_Manual_Rules__c FROM Case WHERE Id IN :closedIds ]);
        system.debug(' closedcases '+closedcases);
        List<Order_Exception__c> closedOEs = New List<Order_Exception__c> ([SELECT Id, Processing_Number__c,status__c, Exception_Type__c, Resolution_Reason__c ,Trigger_DDS_Process__c, Closed_by_Agent__c,Count_of_unresolved_Manual_Rules__c FROM Order_Exception__c  WHERE ID IN :closedIds]);
        system.debug(' closedcases '+closedOEs);
        list<ID> OEIDs = new List<ID>(); 
        if(!closedcases.isEmpty()){
            for (Case cc: closedcases) {
               system.debug(' closedcases '+closedcases);
                 if(cc.Processing_Number__c != null && cc.Processing_Number__c != '') {
                    IADOrderWithOrderItemsService_ltng lt= new IADOrderWithOrderItemsService_ltng();
                    IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS);
            
                    String validationRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(cc.Processing_Number__c,'1');
                    String businessRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(cc.Processing_Number__c,'2');
                    System.debug('validationRuleStatus '+validationRuleStatus + ' businessRuleStatus ' +businessRuleStatus);
                    if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed' && cc.Count_of_unresolved_Manual_Rules__c <1){
                       OEIDs.add(cc.Order_Exception__c);
                       
                        
                    }
                    
                }
            }
        }
        // if an exception record is taken off hold    
        if(!closedOEs.isEmpty()){
            system.debug(' closedcases '+closedOEs);
            for (Order_Exception__c oe:  closedOEs){
                if(oe.Processing_Number__c != null && oe.Processing_Number__c != '') {
                    IADOrderWithOrderItemsService_ltng lt= new IADOrderWithOrderItemsService_ltng();
                    IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS);
            
                    String validationRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(oe.Processing_Number__c,'1');
                    String businessRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(oe.Processing_Number__c,'2');
                    System.debug('validationRuleStatus '+validationRuleStatus + ' businessRuleStatus ' +businessRuleStatus);
                    if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed' && oe.Count_of_unresolved_Manual_Rules__c < 1){
                       OEIDs.add(oe.id);
                       
                        
                    } else if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed' && oe.Count_of_unresolved_Manual_Rules__c >= 1){
                    
                    manualoes.add(oe.id);
                    
                    }
                    //else if(validationRuleStatus A='Failed' || businessRuleStatus =='Failed') {
                    //else if (oe.Count_of_unresolved_Manual_Rules__c >1){
                    else if((validationRuleStatus !='Passed' ||  businessRuleStatus !='Passed' )&& oe.Count_of_unresolved_Manual_Rules__c >=1)  {                  
                        system.debug('------>padma Entered fail' );
                        triggerdds.add(oe.id);
                    }
                    
                }   
            }
        }
        
        
        list<Order_Exception__c> oesToUpdate = new List<Order_Exception__c>([SELECT Id,Exception_Type__c, Status__c,Resolution_Reason__c ,Trigger_DDS_Process__c, Closed_by_Agent__c,Count_of_unresolved_Manual_Rules__c FROM Order_Exception__c  WHERE ID IN :OEIDs]);
        list<Order_Exception__c> manualoestoupdate = new List<Order_Exception__c>([SELECT Id,Exception_Type__c, Status__c,Resolution_Reason__c ,Trigger_DDS_Process__c, Closed_by_Agent__c,Count_of_unresolved_Manual_Rules__c,First_Name__c,Last_Name__c,Email__c,CustomerID__c,Processing_Number__c,Order_Number__c,Product__c FROM Order_Exception__c  WHERE ID IN :manualoes]);
        list<Order_Exception__c> triggerddsoestoupdate = new List<Order_Exception__c>([SELECT Id,Exception_Type__c,Order_Number__r.Name, Order_Number__c,Processing_Number__c,Status__c,Resolution_Reason__c ,Trigger_DDS_Process__c, Closed_by_Agent__c,Count_of_unresolved_Manual_Rules__c FROM Order_Exception__c  WHERE ID IN : triggerdds]);
        list<Order_Exception__c> updateoes =  new list<Order_Exception__c>();
        system.debug('----->tirggerddsoestoupdate '+triggerddsoestoupdate);
        for (Order_Exception__c ordexp: oesToUpdate){
            ordexp.Exception_Type__c = 'Resolved';
            
            if(ordexp.Status__c =='Production Review Complete')
            {
                System.debug('ordexp.Status__c2 is  '+ordexp.Status__c);
                ordexp.Resolution_Reason__c = 'Not a problem order';
                ordexp.Production_Review_Result__c='No Business Rule Problems';
            }
            else
            {
                System.debug('ordexp.Status__c1 is  '+ordexp.Status__c);
                if (!ordexp.Status__c.equals('Resolved')) {
                    ordexp.Status__c='Resolved';
                	ordexp.Resolution_Reason__c = 'Problem(s) resolved by CC'; 
                }
                
            }
            
                      
            ordexp.Closed_by_Agent__c=null;            
            updateoes.add(ordexp);
        }
        update updateoes;  
        
        for( Order_Exception__c ordexp: manualoestoupdate)
        {
        
         ordexp.Exception_Type__c='Problem';
         ordexp.Production_Review_Result__c='No Business Rule Problems';
         //ordexp.Status__c='Problem';
          Case theCase = new Case();
          theCase.Order_Exception__c = ordexp.id;
          theCase.Status = 'Waiting on Customer';
          theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
          theCase.Status_Reasons__c = 'Email Sent, Pending Response';          
    	  theCase.Product2__c =ordexp.Product__c;
          //theCase.Product2__c = 'Power of Attorney';
          theCase.SuppliedName=ordexp.First_Name__c+ordexp.Last_Name__c;
          theCase.SuppliedEmail=ordexp.Email__c;
          theCase.CustomerID__c =ordexp.CustomerID__c;
          theCase.Processing_Number__c=ordexp.Processing_Number__c;
          theCase.Order__c=ordexp.Order_Number__c;
          theCase.ManualruleStatus__c='Problem';
          manualcases.add(thecase);
        }
        
        update manualoestoupdate;
        insert  manualcases;
        
        //per B-31936
        Map<Id,Id> orderExceptionIdToCaseIdMap = new Map<Id,Id>();
        for (Case manualCase : manualcases) {
        	orderExceptionIdToCaseIdMap.put(manualCase.Order_Exception__c, manualCase.Id);
        }
        System.Debug('orderExceptionIdToCaseIdMap: ' + orderExceptionIdToCaseIdMap);
        
        if (!manualoes.isEmpty()) {
        	List<Failed_Rules__c> manualRules = new List<Failed_Rules__c>();
        	manualRules = [SELECT Id, Parent_Case__c, Parent_Exception__c FROM Failed_Rules__c WHERE (Parent_Exception__c IN :manualoes AND Rule_Type__c = 'Manual' AND Status__c = 'Active')];
        	System.Debug('Manual rules to update with case: ' + manualRules.size());
            for (Failed_Rules__c mRule : manualRules) {
            	mRule.Parent_Case__c = orderExceptionIdToCaseIdMap.get(mRule.Parent_Exception__c);
            }
            update manualRules;
        }
         for( Order_Exception__c ordexp: triggerddsoestoupdate)
        {
            system.debug(' inside the for loop '+ordexp);
            POR_PNInjectionButtonController_Ltng.injectProcessingNumber(ordexp.Order_Number__r.Name,  ordexp.Processing_Number__c,'');
                //ordexp.Trigger_DDS_Process__c=true;
        }
        //update triggerddsoestoupdate;
         //update manualoestoupdate;
        //insert  manualcases;
    }
    //EOC @ B-28019
   @future (callout=true)
    public static void ccCaseClosure(Id recordId, String Processingnumber){
        Case cs=[SELECT Id, Order_Number__c,  Product_Line__c,POR_Closed_By__c, Status,Count_of_Unresolved_manual_Rules__c, Status_Reasons__c, Queue__c, Description, RecordTypeId , Assigned_User__c,Processing_Number__c, ContactId,Order_Exception__c,Order_Exception__r.Id FROM Case WHERE ID =:recordId];
        set<Id> ordexceptions = new set<Id>();
        ordexceptions.add(cs.Order_Exception__r.Id);
        String OverallruleStatus;
        list<Order_Exception__c> queriedExceptions = new list<Order_Exception__c>();
       queriedExceptions = [SELECT Id, Status__c, Processing_Number__c, Order_Number__r.Name,Count_of_unresolved_Manual_Rules__c,Exception_Type__c,Production_Review_Result__c, Resolution_Reason__c,Closed_by_Agent__c FROM Order_Exception__c WHERE Id = :ordexceptions];
        Order_Exception__c ordexp;
        if(!queriedExceptions.isEmpty()){
            ordexp=queriedExceptions[0];
        }
        IADOrderWithOrderItemsService_ltng lt= new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS);        
        String validationRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(Processingnumber,'1');
        String businessRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(Processingnumber,'2');
        System.debug('validationRuleStatus '+validationRuleStatus + ' businessRuleStatus ' +businessRuleStatus);
        
        if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed'){
            OverallruleStatus='Passed';
        }
        else{
            OverallruleStatus='Failed';
        }
        System.debug('overallrulestatus is '+OverallruleStatus);
        if( (cs.Count_of_Unresolved_manual_Rules__c >=1 && businessRuleStatus !='Passed')){
            POR_PNInjectionButtonController_Ltng.injectProcessingNumber(cs.Order_Number__c,  cs.Processing_Number__c,'');
           // InBinDateService_ltng.updateProcessingstatus(cs.Processing_Number__c,'Started');            
            OrderExceptionservice.inbindatenonfuture(ordexceptions,true);            
            
        }
        else if(cs.Count_of_Unresolved_manual_Rules__c>=1 && validationRuleStatus!='Passed' && businessRuleStatus =='Passed'){
           POR_PNInjectionButtonController_Ltng.injectProcessingNumber(cs.Order_Number__c,  cs.Processing_Number__c,'');
        }
        else if(cs.Count_of_Unresolved_manual_Rules__c>=1 && OverallruleStatus=='Passed'){
            POR_ExceptionAPIService.reopenCase(cs.Id);            
            
        }
    }


    //BELOW CODE ADDED PER PB MIGRATION
    //, Map<Id, Case> oldCasesMap
    public static void caseSubjectUpdate(List<Case> newCases) {
        System.Debug('In caseSubjectUpdate with ' + newCases);
        List<Case> casesToUpdate = new List<Case>();
        Set<Id> orderExceptionToQueryIds = new Set<Id>();
        List<Order_Exception__c> orderExceptionToQuery = new List<Order_Exception__c>();

        for (Case thisCase : newCases) {
            if (thisCase.Order_Exception__c != null) {
                orderExceptionToQueryIds.add(thisCase.Order_Exception__c);
            }
        }

        try {
            Map<Id, Order_Exception__c> orderExpceionIdToIdToRecordMap = new Map<Id, Order_Exception__c>([SELECT Id, Subject_Formula__c, Order_Number__c FROM Order_Exception__c WHERE Id IN:orderExceptionToQueryIds]);

            if (!orderExpceionIdToIdToRecordMap.isEmpty()) {
                for (Case thisCase : newCases) {
                    if (thisCase.Order_Exception__c != null && orderExpceionIdToIdToRecordMap.get(thisCase.Order_Exception__c) != null) {
                        System.Debug('Parent Exception is here: ' + orderExpceionIdToIdToRecordMap.get(thisCase.Order_Exception__c));
                        if (orderExpceionIdToIdToRecordMap.get(thisCase.Order_Exception__c).Subject_Formula__c != null && orderExpceionIdToIdToRecordMap.get(thisCase.Order_Exception__c).Order_Number__c != null) {
                            thisCase.Subject = orderExpceionIdToIdToRecordMap.get(thisCase.Order_Exception__c).Subject_Formula__c;
                        }
                    }
                }
            }
        } catch (QueryException e) {
            System.Debug(e);
        }
    }

    public static void PORClosedByUpdate(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        System.Debug('In PORClosedByUpdate with ' + newCases);
        Map<Id, Id> exceptionIdToUserMap = new Map<Id, Id>();
        for (Case cs : newCases) {
            if (cs.POR_Closed_By__c != oldCasesMap.get(cs.Id).POR_Closed_By__c && cs.POR_Closed_By__c != null) {
                exceptionIdToUserMap.put(cs.Order_Exception__c, cs.POR_Closed_By__c);
            }
        }

        if (!exceptionIdToUserMap.isEmpty()) {
            List<Order_Exception__c> exceptionsToQuery = new List<Order_Exception__c>();
            exceptionsToQuery = [SELECT Id, Closed_by_Agent__c FROM Order_Exception__c WHERE Id IN :exceptionIdToUserMap.keySet()];
            for (Order_Exception__c exc : exceptionsToQuery) {
                exc.Closed_by_Agent__c = exceptionIdToUserMap.get(exc.Id);
            }
            update exceptionsToQuery;
        }
    }
    
    public static void caseClosedCheck(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        System.Debug('In caseClosedCheck with ' + newCases);
        Set<Id> orderExceptionIdsToQuery = new Set<Id>();
        Set<Id> caseIdsForFailedRulesToQuery = new Set<Id>();
        if (!UserInfo.getFirstName().equals('Integration') && !UserInfo.getFirstName().equals('Data2')) {
            for (Case newCase : newCases) {
                Case oldCase = oldCasesMap.get(newCase.Id);
                if (newCase.status != oldCase.status && newCase.status.equals('Closed') && newCase.Order_Exception__c != null && newCase.Status_Reasons__c != 'Revision Placed for Customer' && newCase.Status_Reasons__c != 'Order Cancelled' ) {
                    orderExceptionIdsToQuery.add(newCase.Order_Exception__c);
                    caseIdsForFailedRulesToQuery.add(newCase.Id);
                }
            }
            if (!orderExceptionIdsToQuery.isEmpty()) {
                List<Order_Exception__c> exceptionsToQuery = new List<Order_Exception__c>();
                exceptionsToQuery = [SELECT Id, Count_of_unresolved_Manual_Rules__c, Trigger_DDS_Process__c, Trigger_Order_due_date__c FROM Order_Exception__c WHERE Id IN: orderExceptionIdsToQuery];
                for (Order_Exception__c excp : exceptionsToQuery) {
                    if (excp.Count_of_unresolved_Manual_Rules__c == 0) {
                        excp.Trigger_DDS_Process__c = true;
                        excp.Trigger_Order_due_date__c = true;
                    }
                }
                List<Failed_Rules__c> faildRules = new List<Failed_Rules__c>();
                faildRules = [SELECT Id, Rule_Type__c, Status__c FROM Failed_Rules__c WHERE Parent_Exception__c In :orderExceptionIdsToQuery AND Rule_Type__c != 'Manual' AND Status__c != 'Inactive'];
                for (Failed_Rules__c failedRule : faildRules) {
                    failedRule.Status__c = 'Inactive';
                }

                update exceptionsToQuery;
                update faildRules;
            }

        }
    }

    

    //  @sai - B-40970
    //  Description: Update the OER's Status to and when new case's ManualRuleStatus is Problem
    public static void populateStatusOnOER(List<Case> newCases) {
        List<Order_Exception__c> oerList = new List<Order_Exception__c>();
    for (case cs : newCases) {
                if (!String.isEmpty(cs.Order_Exception__c) && cs.ManualruleStatus__c == PROBLEM) {
                    oerList.add(new Order_Exception__c(Id = cs.Order_Exception__c, Status__c = PROBLEM));
                }
            }

        if (!oerList.isEmpty() && !Test.isRunningTest()) {
            update oerList;
        }
    }
    

    //@Sai - B-40970
    public static void updateContactOnCase(List<Case> newCases) {

        System.Debug('In updateContactOnCase with ' + newCases);
        List<Id> orderIdsToQuery = new List<Id>();
        Map<String, Integer> oerIdSumTotalEmails = new Map<String, Integer>();
        Set<Id> oerIdList = new Set<Id>();

        Id problemCaseId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);

        for (Case cs : newCases) {
            if (cs.Order__c != null && cs.Order_Exception__c != null && cs.RecordTypeId == problemCaseId) {
                system.debug('---Y in cases filter');
                orderIdsToQuery.add(cs.Order__c);
                if (cs.Order_Exception__c != null) {
                    oerIdList.add(cs.Order_Exception__c);
                }
            }
        }

        if (!orderIdsToQuery.isEmpty()) {
            List<Order__c> ordersToQuery = new List<Order__c>();
            ordersToQuery = [SELECT Id, Contact__c FROM Order__c WHERE Id IN :orderIdsToQuery];
            Map<Id, Order__c> orderIdToRecordMap = new Map<Id, Order__c>(ordersToQuery);

            for (Case cs : newCases) {
                cs.ContactId = orderIdToRecordMap.get(cs.Order__c).Contact__c;
            }

            if (!oerIdList.isEmpty()) {
                List<AggregateResult> aggrList = [select SUM(Total_outbound_emails__c), Order_Exception__c FROM Case where Order_Exception__c IN: oerIdList group by Order_Exception__c];
                for (AggregateResult agg : aggrList) {
                    oerIdSumTotalEmails.put(agg.get('Order_Exception__c').toString(), Integer.valueOf(agg.get('expr0')));
                }
            }

            List<Order_Exception__c> ordExpList = new List<Order_Exception__c>();
            for (Id orExpId : oerIdSumTotalEmails.keySet()) {
                Order_Exception__c ordExp = new Order_Exception__c();
                ordExp.Total__c = oerIdSumTotalEmails.get(orExpId);
                ordExp.Id = orExpId;
                ordExpList.add(ordExp);
            }

            if (!ordExpList.isEmpty())
                update ordExpList;
        }
    }
}