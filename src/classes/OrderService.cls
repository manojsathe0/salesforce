public with sharing class OrderService 
{
    public final static List<String> DEV_RECORD_TYPE_NAME = new List<String>{'Abandoner','Standard_Opportunity','ChargeBacks','Declines','Business_Development_Opportunity','Pilot_Group','Account_Manager'};
        public static Boolean  hasUpdateTriggerRun = false;
    public static Boolean hasMatchingTriggerRun = false;
    public static Boolean hasLeadConvertStarted = false;
    public static final String ORDER_CREATED_FIELD = 'Order_Date_Time_Created__c';
    public static final String DECLINED_TO_APPROVED_FIELD = 'Declined_To_Approved_Time__c';
    public static final String DATE_FORMAT = 'yyyy-MM-dd HH:mm';
    public static final String REGISTERED_AGENT = 'Registered Agent';
    public final static String CROSS_SELL = 'Cross-sell';
    public static Boolean hasOrderMatchingTriggerRun = false;
    
    public static Set<Id> oppsRecordTypeIds
    {
        get
        {
            if(oppsRecordTypeIds == null)
            {
                oppsRecordTypeIds = new Set<Id>();
                oppsRecordTypeIds.add(developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[0]));
                oppsRecordTypeIds.add(developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[1]));
                oppsRecordTypeIds.add(developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[5]));
                oppsRecordTypeIds.add(developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[6]));
            }
            
            return oppsRecordTypeIds;
        }
        
        set;
    }
    
    public static String oppsRecordTypeIdsCommaSeparated
    {
        get
        {
            if(oppsRecordTypeIdsCommaSeparated == null)
            {
                oppsRecordTypeIdsCommaSeparated = '(\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[0])+'\',';
                oppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[5])+'\',';
                oppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[6])+'\',';
                oppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[1])+'\')';
            }
            
            return oppsRecordTypeIdsCommaSeparated;
        }
        
        set;
    }
    
    public static String allOppsRecordTypeIdsCommaSeparated
    {
        get
        {
            if(allOppsRecordTypeIdsCommaSeparated == null)
            {
                allOppsRecordTypeIdsCommaSeparated = '(\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[0])+'\',';
                allOppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[1])+'\',';
                allOppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[5])+'\',';
                allOppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[6])+'\',';
                allOppsRecordTypeIdsCommaSeparated += '\''+developerNameToRecordTypeIds.get(DEV_RECORD_TYPE_NAME[3])+'\')';
            }
            
            return allOppsRecordTypeIdsCommaSeparated;
        }
        
        set;
    }
    
    public static Map<String,Id> developerNameToRecordTypeIds
    {
        get
        {
            if(developerNameToRecordTypeIds == null)
            {
                /*List<RecordType> recordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity'];    
                developerNameToRecordTypeIds = new Map<String,Id>();
                if(!recordTypes.isEmpty())
                {
                    for(RecordType theRecordType : recordTypes)
                    {
                        developerNameToRecordTypeIds.put(theRecordType.DeveloperName , theRecordType.Id);
                    }
                }*/
  String objectAPIName = 'Opportunity' ; //any object api
  Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
   List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
    developerNameToRecordTypeIds = new Map<String,Id>();
    for(Schema.RecordTypeInfo info : recordTypeInfo){
     developerNameToRecordTypeIds.put(info.getName(),info.getRecordTypeId());
            }
            }
            
            return developerNameToRecordTypeIds;
        }
        set;
    }
    
    public static DateTime dateRange
    {
        get
        {
            if(dateRange == null)
            {
                dateRange = DateTime.now().addDays(-14);
            }
            
            return dateRange;
        }
        set;
    }
    
    
    
    public static void populateParentOrderLookUp(List<Order__c> childOrders)
    {
        Set<String> lzParentOrderIds = new Set<String>();
        for(Order__c childOrder :childOrders)
        {
            if(childOrder.LZ_Parent_Order__c != null)
            {
                lzParentOrderIds.add(childOrder.LZ_Parent_Order__c);
            }
        }
        List<Order__c> parentOrders = [SELECT Id , OrderID__c FROM Order__c WHERE OrderID__c IN :lzParentOrderIds];
        Map<String,Id> lzOrderIdToParentSFDCId = new Map<String,Id>();
        for(Order__c parentOrder : parentOrders)
        {
            lzOrderIdToParentSFDCId.put(parentOrder.OrderID__c , parentOrder.Id);
        }
        for(Order__c childOrder : childOrders)
        {
            if(lzOrderIdToParentSFDCId.containsKey(childOrder.LZ_Parent_Order__c))
            {
                childOrder.Parent_Order__c = lzOrderIdToParentSFDCId.get(childOrder.LZ_Parent_Order__c);
            }
        }
    }
    
    public static void markFirstRenewalOrder(List<Order__c> childOrders)
    {
        Set<Id> parentOrderIds = new Set<Id>();
        Map<Id,List<String>> parentOrderIdToChildOrderNumbers = new Map<Id,List<String>>();
        Map<String,Order__c> lzOrderIdsToChildOrder = new Map<String,Order__c>(); 
        for(Order__c childOrder : childOrders)
        {
            if(childOrder.Base_Product__c != null && childOrder.Parent_Order__c != null && OrderMatcherHelper.RAProductIds.contains(childOrder.Base_Product__c))
            {
                parentOrderIds.add(childOrder.Parent_Order__c);
                if(!parentOrderIdToChildOrderNumbers.containsKey(childOrder.Parent_Order__c))
                {
                    parentOrderIdToChildOrderNumbers.put(childOrder.Parent_Order__c , new List<String>());
                }
                parentOrderIdToChildOrderNumbers.get(childOrder.Parent_Order__c).add(childOrder.OrderID__c);
                lzOrderIdsToChildOrder.put(childOrder.OrderID__c , childOrder);
            }
        }
        if(!parentOrderIds.isEmpty())
        {
            Set<Id> crossSellOrders = new Set<Id>();
            for(Order__c parentOrder : [SELECT Id ,OrderID__c, (SELECT Id,Product__r.Name , Relationship_Type__r.Name FROM Order_Items__r), (SELECT Id FROM Orders__r WHERE Base_Product__c IN :OrderMatcherHelper.RAProductIds) FROM Order__c WHERE Id IN :parentOrderIds])
            {
                for(Order_Item__c theItem : parentOrder.Order_Items__r)
                {
                    if(theItem.Product__r.Name != null && theItem.Relationship_Type__r.Name != null)
                    {
                        if(theItem.Product__r.Name.contains(REGISTERED_AGENT) && theItem.Relationship_Type__r.Name == CROSS_SELL)
                        {
                            crossSellOrders.add(parentOrder.Id);
                            break;
                        }
                    }
                }
                
                if(parentOrder.Orders__r.isEmpty())
                {
                    if(crossSellOrders.contains(parentOrder.Id))
                    {
                        List<String> childOrderNumbers = parentOrderIdToChildOrderNumbers.get(parentOrder.Id);
                        if(!childOrderNumbers.isEmpty())
                        {
                            lzOrderIdsToChildOrder.get(childOrderNumbers[0]).Is_First_RA_Renewal__c = true;
                        }
                    }
                }
            }
            
        }
    }
    
    public static void preserveOriginalOrderCreatedDateTime(List<Order__c> newOrders , Map<Id,Order__c> oldOrders)
    {
        for(Order__c newOrder : newOrders)
        {
            newOrder.Order_Date_Time_Created__c = oldOrders.get(newOrder.Id).Order_Date_Time_Created__c;
        }
    }
    
    public static void processForCampaigns(Set<Id> orderIds)
    {
        CampaignFutureHandler.removeCampaignMembersForPrePurchase(orderIds);
    }  
    
    public static void countNumberOfOrders(List<Order__C> newOrders)
    {
        Map<Id,Decimal> contactIdToOrderCount = new Map<Id,Decimal>();
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Order__c theOrder : newOrders)
        {
            contactIds.add(theOrder.Contact__c);
            if(contactIdToOrderCount.containsKey(theOrder.Contact__c))
                contactIdToOrderCount.put(theOrder.Contact__c, contactIdToOrderCount.get(theOrder.Contact__c) + 1);
            else
                contactIdToOrderCount.put(theOrder.Contact__c, 1);
        }
        
        if(!contactIds.isEmpty())
            contactsToUpdate = [SELECT ID, Total_Phone_Contacts__c , Total_Activities_when_Order_placed__c , Total_Emails__c FROM Contact WHERE Id In: contactIds];
        
        for(Contact theContact : contactsToUpdate)
        {
            if(theContact.Total_Phone_Contacts__c != null && theContact.Total_Emails__c!= null)
                theContact.Total_Activities_when_Order_placed__c = theContact.Total_Phone_Contacts__c + theContact.Total_Emails__c;
            else if(theContact.Total_Emails__c == null && theContact.Total_Phone_Contacts__c != null)
                theContact.Total_Activities_when_Order_placed__c = theContact.Total_Phone_Contacts__c;
            else if(theContact.Total_Emails__c != null && theContact.Total_Phone_Contacts__c == null)
                theContact.Total_Activities_when_Order_placed__c = theContact.Total_Emails__c;
        }
        try
        {
            update contactsToUpdate;
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to Calculate total no of Orders on contact.');
        }
        
    }
    /*
Exception and case closure,
per  B-25352
By Artyom M.
*/
    
    /* */
    public static void closeExceptionsAndCasesOnCancellation(List<Order__c> newOrders, Map<Id,Order__c> oldOrders) {
        System.debug('inside CloseExceptionsAndCasesOnCancellation.');
        System.debug('newOrders size: ' + newOrders.size());
        Set<Id> idsOfAllOrdersWithCurrentProcessingNumbers = new Set<Id>();
        Set<String> currentProcessingNumbers = new Set<String>();
        
        for (Order__c newOrder : newOrders) {
            if (newOrder.Order_Payment_Status_Text__c != null && newOrder.Order_Payment_Status_Text__c.contains('Cancelled') && !String.isBlank(newOrder.User_Order_ID__c))  {
                Order__c oldOrder = oldOrders.get(newOrder.Id);
                if (oldOrder.Order_Payment_Status_Text__c != null && !oldOrder.Order_Payment_Status_Text__c.contains('Cancelled')) {
                    System.debug(newOrder.Name + ' is cancelled.');
                    idsOfAllOrdersWithCurrentProcessingNumbers.add(newOrder.Id);
                    currentProcessingNumbers.add(newOrder.User_Order_ID__c);
                }
            }
        }
        System.debug('idsOfAllOrdersWithCurrentProcessingNumbers size: ' + idsOfAllOrdersWithCurrentProcessingNumbers.size());
        System.debug('currentProcessingNumbers size: ' + currentProcessingNumbers.size());
        if (!currentProcessingNumbers.isEmpty()) {
            List<Order__c> ordersToQuery = new List<Order__c>();
            ordersToQuery = [SELECT Id, User_Order_ID__c FROM Order__c WHERE User_Order_ID__c IN :currentProcessingNumbers LIMIT 5000];
            System.debug('ordersToQuery size: ' + ordersToQuery.size());
            if (!ordersToQuery.isEmpty()) {
                for (Order__c ordr : ordersToQuery) {
                    idsOfAllOrdersWithCurrentProcessingNumbers.add(ordr.Id);
                }
                POR_ExceptionAPIService.closeExceptionsAndCases(idsOfAllOrdersWithCurrentProcessingNumbers, 'Closed', 'Order Cancelled', 'Order Cancelled');
            }
            
        }
        
    }
    
    
    /*
Exception and case closure,
per B-26122 
By Artyom M.
*/
    /*
public static void closeExceptionsAndCasesOnCleanRevisions(List<Order__c> newOrders) {
System.debug('inside closeExceptionsAndCasesOnCleanRevisions.');
Set<Id> cleanRevisionIds = new Set<Id>();
Set<Id> currentOrderIdSet = new Set<Id>();
Map<String, Id> orderProcessingNumberToId = new Map<String, Id>(); 
System.debug('newOrders size: ' + newOrders.size());
for (Order__c newOrder : newOrders) {
currentOrderIdSet.add(newOrder.Id);
System.debug('newOrder status: ' + newOrder.Processing_Status__c);
if (newOrder.Processing_Status__c != null && !newOrder.Processing_Status__c.contains('Problem'))  {

orderProcessingNumberToId.put(newOrder.User_Order_ID__c, newOrder.Id);
}
}
System.debug('orderIdToProcessingNumberMap.keySet() size: ' + orderProcessingNumberToId.keySet().size());
Set<Id> revisionOrderIds = new Set<Id>(); 
List<Order__c> existingOrderLists = new List<Order__c>();
existingOrderLists = [SELECT Id, User_Order_ID__c FROM Order__c WHERE User_Order_ID__c IN :orderProcessingNumberToId.keySet() LIMIT 1000];
if (existingOrderLists.size() > 0) {
System.debug('existingOrderLists size: ' + existingOrderLists.size());
for (Order__c ord : existingOrderLists) {
revisionOrderIds.add(ord.Id);
}
}
System.debug('revisionOrderIds size: ' + revisionOrderIds.size());
revisionOrderIds.removeAll(currentOrderIdSet);//to exclude the current orders

System.debug('revisionOrderIds size after removing: ' + revisionOrderIds.size());
POR_ExceptionAPIService.closeExceptionsAndCases(revisionOrderIds, 'Resolved', 'Clean Revision Placed', 'Revision placed on LZ.com');
}
*/
/*
    public static  void CreateOppOnboard(List<Order__c> ordersllc)
    {
        system.debug('Inside create opporunity onboard-->'+ordersllc.size());
        List<opportunity> opptinsllc  = new List<opportunity>(); 
        set<String> processingids = new set<string>();
        Map<String, opportunity> mapofprocestoOppty = new Map<String,opportunity>();
        set<Opportunity> oppset = new set<Opportunity>();
        
        for(Order__c orderllc: ordersllc)
        {
            
            //String processingnum = orderllc.Parent_User_Order__c!=null? orderllc.Parent_User_Order__c : orderllc.User_Order_ID__c;
            String processingnum = orderllc.User_Order_ID__c!=null? orderllc.User_Order_ID__c : '';   
            if(String.isNotBlank(processingnum) && !mapofprocestoOppty.containsKey(processingnum))
            {
                opportunity  opptinllc = new opportunity();
                opptinllc.order__c =orderllc.id;
                opptinllc.name='LLC';
                opptinllc.State_of_Formation__c  =   orderllc.State_of_Formation__c;
                if(orderllc.ra__c)
                {
                    opptinllc.ra__c=orderllc.ra__c;
                }
                opptinllc.Score__c=100;
                opptinllc.Product2__c='LLC';
                opptinllc.LeadSource='On-Boarding';
                if(orderllc.bap__c)
                {
                    opptinllc.bap__c=orderllc.bap__c;
                }
                if(orderllc.tax__c)
                {
                    opptinllc.tax__c=orderllc.tax__c;
                }
                
                if(orderllc.Compliance__c)
                {
                    opptinllc.Compliance__c=orderllc.Compliance__c;
                }
                opptinllc.User_Order_ID_c__c=processingnum;
                
                opptinllc.onboarding__c =true;
                opptinllc.accountid=orderllc.Account__c;
                opptinllc.Contact__c=orderllc.Contact__c;
                opptinllc.stagename='new';
                opptinllc.closedate=date.today().adddays(30);
                
                mapofprocestoOppty.put(processingnum,  opptinllc);
                
                for(string proc:mapofprocestoOppty.keySet())
                {
                    oppset.add(mapofprocestoOppty.get(proc));
                }              
            }
            
        }
        opptinsllc.addAll(oppset);
        if(opptinsllc.size()>0)
        {
           upsert opptinsllc User_Order_ID_c__c;
           
        }
        
    }*/
    
    /*
    public static  void UpdateOppOnboard(List<Order__c> ordersllc ,map<string ,order__c> processnumbertoorder)
    {
        List<opportunity> opptinsllc  = new List<opportunity>();
        set<String> processingNumbers = new  set<String>();
        map<id,order__c> contactidtoorder = new  map<id,order__c>();
        List<Task> taskstoupdate = new List<task>();
        set<id> contactids = new set<id>();
        
        for(Order__c orderllc: ordersllc)
        {
            
            //String processingnum = orderllc.Parent_User_Order__c!=null? orderllc.Parent_User_Order__c : orderllc.User_Order_ID__c;
            String processingnum = orderllc.User_Order_ID__c!=null? orderllc.User_Order_ID__c : '';
            if(String.isNotBlank(processingnum)){
                processingNumbers.add(processingnum);
            }
            
            contactids.add(orderllc.contact__c);
            contactidtoorder.put(orderllc.contact__c,orderllc);
        }
        List<contact> contacts =[select id ,(select ra__c ,tax__c ,bap__c from tasks order by CreatedDate  desc limit 1) from contact where id IN : contactids];
        List<opportunity> opportunitiesbyprocessing =[select User_Order_ID__c,User_Order_ID_c__c,id,ra__c ,tax__c ,bap__c ,compliance__c from opportunity where  User_Order_ID_c__c IN :processingNumbers];
        for (opportunity opp : opportunitiesbyprocessing)
        {
            if(processnumbertoorder.get(opp.User_Order_ID_c__c)!=null)
            {    if(processnumbertoorder.get(opp.User_Order_ID_c__c).ra__c)
            {
                opp.ra__c=processnumbertoorder.get(opp.User_Order_ID_c__c).ra__c;
            }
             if( processnumbertoorder.get(opp.User_Order_ID_c__c).tax__c)
             {
                 opp.tax__c= processnumbertoorder.get(opp.User_Order_ID_c__c).tax__c;
             }
             if(processnumbertoorder.get(opp.User_Order_ID_c__c).bap__c)
             {
                 opp.bap__c=processnumbertoorder.get(opp.User_Order_ID_c__c).bap__c;
             }
             if(processnumbertoorder.get(opp.User_Order_ID_c__c).compliance__c)
             {
                 opp.compliance__c =processnumbertoorder.get(opp.User_Order_ID_c__c).compliance__c;
             }
            
            // if(opp.ra__c&&opp.tax__c&&opp.bap__c&&opp.compliance__c)
            // {
              //   opp.stagename='Closed won';
                 
             //}
             
             opp.State_of_Formation__c  =   processnumbertoorder.get(opp.User_Order_ID_c__c).State_of_Formation__c;
             opptinsllc.add(opp);
             
            }
        }
        for(contact con :contacts)
        {
            
            for(task ts :con.tasks)
            {
                if(contactidtoorder.get(con.id)!=null)
                {   
                    if(contactidtoorder.get(con.id).ra__c)
                    {
                        ts.ra__c=contactidtoorder.get(con.id).ra__c;
                    }
                    if(contactidtoorder.get(con.id).tax__c)
                    {
                        ts.tax__c= contactidtoorder.get(con.id).tax__c;
                    }
                    if(contactidtoorder.get(con.id).bap__c)
                    {
                        ts.bap__c=contactidtoorder.get(con.id).bap__c;
                    }
                    
                    if(contactidtoorder.get(con.id).compliance__c)
                    {
                        ts.compliance__c=contactidtoorder.get(con.id).compliance__c;
                    }
                    taskstoupdate.add(ts);
                }
                
            }
            
        }
        if(opptinsllc.size()>0)
        {
            update opptinsllc;
        }
        if(taskstoupdate.size()>0)
        {
            update taskstoupdate;
        }
    }*/
    // future method for onbordaing creation and update
     @future 
    public static void updateonboardfuture(set<id> orderids, boolean insertorupdate)
    {
    
      if(insertorupdate)
    {
    
    List<opportunity> opptinsllc  = new List<opportunity>(); 
        set<String> processingids = new set<string>();
        Map<String, opportunity> mapofprocestoOppty = new Map<String,opportunity>();
        set<Opportunity> oppset = new set<Opportunity>();
        SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
         List<order__c>  ordersllc = [select Parent_User_Order__c, User_Order_ID__c,Product__c,State_of_Formation__c ,Contact__c ,Standard__c, Account__c ,EIN__c ,TM_Search__c,Economy__c, Express_Gold__c,id,ra__c ,tax__c ,bap__c ,compliance__c from order__c where id IN : orderids];
        //Artyom@B-37295
         Set<Id> parentContactIds = new Set<Id>();
         for (Order__c thisOrder : ordersllc) {
         	parentContactIds.add(thisOrder.Contact__c);
         }
         List<Contact> parentContactList = new List<Contact>();
         Map<Id,Id> contactToAccountId = new Map<Id,Id>();
         List<Id> contactsThatHaveOMA = new List<Id>(); 
         if (!parentContactIds.isEmpty()) {
         	parentContactList = [SELECT Id,AccountId, (SELECT Id FROM Order_Matching_Activities__r) FROM Contact WHERE ID IN :parentContactIds];
         	if (!parentContactList.isEmpty()) {
         		for (Contact thisContact : parentContactList) {
                    if(thisContact.AccountId != null){
                        contactToAccountId.put(thisContact.Id,thisContact.accountId);
                    }
         			if (!thisContact.Order_Matching_Activities__r.isEmpty()) {
         				contactsThatHaveOMA.add(thisContact.Id);
         			}
         			
         		}
         	}
         }
         System.debug('parentContactList size: ' + parentContactList.size());
        
        for(Order__c orderllc: ordersllc)
        {
       //Artyom@B-37295
            Boolean parentContactHasOma = false;
            if (contactsThatHaveOMA.contains(orderllc.Contact__c)) {
            	parentContactHasOma = true;
            }
            System.Debug('parentContactHasOma = ' + parentContactHasOma);
            //String processingnum = orderllc.Parent_User_Order__c!=null? orderllc.Parent_User_Order__c : orderllc.User_Order_ID__c;
            String processingnum = orderllc.User_Order_ID__c!=null? orderllc.User_Order_ID__c : '';   
            System.debug('processingnum = ' + processingnum); 
            if(String.isNotBlank(processingnum) && !mapofprocestoOppty.containsKey(processingnum) && !parentContactHasOma) ////Artyom@B-37295
            {
            
                opportunity  opptinllc = new opportunity();
                opptinllc.Score__c=0;
                opptinllc.order__c =orderllc.id;
                opptinllc.name='LLC';
                opptinllc.State_of_Formation__c  =   orderllc.State_of_Formation__c;
                if(orderllc.ra__c)
                {
                    opptinllc.ra__c=orderllc.ra__c;
                  opptinllc.Score__c=opptinllc.Score__c+config.ra__c;
                }
               // opptinllc.Score__c=100;
                opptinllc.Product2__c='LLC';
                opptinllc.LeadSource='On-Boarding';
                if(orderllc.bap__c)
                {
                    opptinllc.bap__c=orderllc.bap__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.bap__c;
                }
                if(orderllc.tax__c)
                {
                    opptinllc.tax__c=orderllc.tax__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.tax__c;
                }
                
                if(orderllc.Compliance__c)
                {
                    opptinllc.Compliance__c=orderllc.Compliance__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.compliance__c;
                }
                if(orderllc.EIN__c)
                {
                    opptinllc.EIN__c=orderllc.EIN__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.EIN__c;
                }
                if(orderllc.Standard__c)
                {
                    opptinllc.Standard__c=orderllc.Standard__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.Standard__c;
                }
                if(orderllc.TM_Search__c)
                {
                    opptinllc.TM_Search__c=orderllc.TM_Search__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.TM_Search__c;
                }
                if(orderllc.Economy__c)
                {
                    opptinllc.Economy__c=orderllc.Economy__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.Economy__c;
                }
                if(orderllc.Express_Gold__c)
                {
                    opptinllc.Express_Gold__c=orderllc.Express_Gold__c;
                    opptinllc.Score__c=opptinllc.Score__c+config.Express_Gold__c;
                }
                opptinllc.User_Order_ID_c__c=processingnum;
                
                opptinllc.onboarding__c =true;

                opptinllc.Contact__c=orderllc.Contact__c;
                //D-07502
                if(contactToAccountId.containsKey(orderllc.Contact__c)) {
                    opptinllc.accountid = contactToAccountId.get(orderllc.Contact__c);
                }else{
                    opptinllc.accountid=orderllc.Account__c;  
                }
                opptinllc.stagename='new';
                opptinllc.closedate=date.today().adddays(30);
                
                mapofprocestoOppty.put(processingnum,  opptinllc);
                
                for(string proc:mapofprocestoOppty.keySet())
                {
                    oppset.add(mapofprocestoOppty.get(proc));
                }              
            }
            
        }
        opptinsllc.addAll(oppset);
        if(opptinsllc.size()>0)
        {
           upsert opptinsllc User_Order_ID_c__c;
           
        }
    }
    else{
     Map<String ,Order__c> processnumbertoorder = new Map<String ,Order__c>();
     
     List<order__c> ordersforonboard = [select Parent_User_Order__c, User_Order_ID__c,Standard__c,State_of_Formation__c, Product__c,contact__c,EIN__c ,TM_Search__c,Economy__c, Express_Gold__c,id,ra__c ,tax__c ,bap__c ,compliance__c from order__c where id IN : orderids];
    
    for(Order__c theOrder : ordersforonboard)
                {
                    
                        String PCN = theOrder.Parent_User_Order__c!=null? theOrder.Parent_User_Order__c : theOrder.User_Order_ID__c;
                       // ordersllc.add(theOrder);
                        processnumbertoorder.put(PCN ,theOrder);
                        
                    
                    
                }
               
      List<opportunity> opptinsllc  = new List<opportunity>();
       List<Contact> contacts = new List<Contact>();
        set<String> processingNumbers = new  set<String>();
        map<id,order__c> contactidtoorder = new  map<id,order__c>();
        List<Task> taskstoupdate = new List<task>();
        set<id> contactids = new set<id>();
        SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
        List<opportunity> opportunitiesbyprocessing = new List<opportunity>();
        for(Order__c orderllc: ordersforonboard)
        {
            
            //String processingnum = orderllc.Parent_User_Order__c!=null? orderllc.Parent_User_Order__c : orderllc.User_Order_ID__c;
            String processingnum = orderllc.User_Order_ID__c!=null? orderllc.User_Order_ID__c : '';
            if(String.isNotBlank(processingnum)){
                processingNumbers.add(processingnum);
            }
            
            contactids.add(orderllc.contact__c);
            contactidtoorder.put(orderllc.contact__c,orderllc);
        }
        
        if(contactids.size()>0)
        {
         contacts =[select id ,(select ra__c ,tax__c ,bap__c from tasks order by CreatedDate  desc limit 1) from contact where id IN : contactids];
        }
        
        if(processingNumbers.size()>0)
        {
        opportunitiesbyprocessing =[select User_Order_ID__c, Score__c,EIN__c,Standard__c,User_Order_ID_c__c,TM_Search__c,Economy__c, Express_Gold__c,id,ra__c ,tax__c ,bap__c ,compliance__c from opportunity where  User_Order_ID_c__c IN :processingNumbers and OnBoarding__c=true];
        }
        if(!opportunitiesbyprocessing.isEmpty()){
	        for (opportunity opp : opportunitiesbyprocessing)
	        {
	            if(processnumbertoorder.get(opp.User_Order_ID_c__c)!=null)
	            {    
	            opp.Score__c=0;
	            
	            if(processnumbertoorder.get(opp.User_Order_ID_c__c).ra__c)
	            {
	                opp.ra__c=processnumbertoorder.get(opp.User_Order_ID_c__c).ra__c;
	                opp.Score__c=opp.Score__c+config.ra__c;
	                
	            }
	             if( processnumbertoorder.get(opp.User_Order_ID_c__c).tax__c)
	             {
	                 opp.tax__c= processnumbertoorder.get(opp.User_Order_ID_c__c).tax__c;
	                 opp.Score__c=opp.Score__c+config.tax__c;
	             }
	             if(processnumbertoorder.get(opp.User_Order_ID_c__c).bap__c)
	             {
	                 opp.bap__c=processnumbertoorder.get(opp.User_Order_ID_c__c).bap__c;
	                   opp.Score__c=opp.Score__c+config.bap__c;
	             }
	             if(processnumbertoorder.get(opp.User_Order_ID_c__c).compliance__c)
	             {
	                 opp.compliance__c =processnumbertoorder.get(opp.User_Order_ID_c__c).compliance__c;
	                 opp.Score__c=opp.Score__c+config.compliance__c;
	             }
	            
	              if(processnumbertoorder.get(opp.User_Order_ID_c__c).EIN__c)
	             {
	                 opp.EIN__c =processnumbertoorder.get(opp.User_Order_ID_c__c).EIN__c;
	                 opp.Score__c=opp.Score__c+config.EIN__c;
	             }
	             
	              if(processnumbertoorder.get(opp.User_Order_ID_c__c).Standard__c)
	             {
	                 opp.Standard__c =processnumbertoorder.get(opp.User_Order_ID_c__c).Standard__c;
	                 opp.Score__c=opp.Score__c+config.Standard__c;
	             }
	             
	              if(processnumbertoorder.get(opp.User_Order_ID_c__c).TM_Search__c)
	             {
	                 opp.TM_Search__c =processnumbertoorder.get(opp.User_Order_ID_c__c).TM_Search__c;
	                 opp.Score__c=opp.Score__c+config.TM_Search__c;
	             }
	              if(processnumbertoorder.get(opp.User_Order_ID_c__c).Economy__c)
	             {
	                 opp.Economy__c =processnumbertoorder.get(opp.User_Order_ID_c__c).Economy__c;
	                 opp.Score__c=opp.Score__c+config.Economy__c;
	             }
	             
	              if(processnumbertoorder.get(opp.User_Order_ID_c__c).Express_Gold__c)
	             {
	                 opp.Express_Gold__c =processnumbertoorder.get(opp.User_Order_ID_c__c).Express_Gold__c;
	                  opp.Score__c=opp.Score__c+config.Express_Gold__c;
	             }
	             
	            
	             opp.State_of_Formation__c  =   processnumbertoorder.get(opp.User_Order_ID_c__c).State_of_Formation__c;
	             opptinsllc.add(opp);
	             
	            }
	        }
        }
        for(contact con :contacts)
        {
            
            for(task ts :con.tasks)
            {
                if(contactidtoorder.get(con.id)!=null)
                {   
                    if(contactidtoorder.get(con.id).ra__c)
                    {
                        ts.ra__c=contactidtoorder.get(con.id).ra__c;
                    }
                    if(contactidtoorder.get(con.id).tax__c)
                    {
                        ts.tax__c= contactidtoorder.get(con.id).tax__c;
                    }
                    if(contactidtoorder.get(con.id).bap__c)
                    {
                        ts.bap__c=contactidtoorder.get(con.id).bap__c;
                    }
                    
                    if(contactidtoorder.get(con.id).compliance__c)
                    {
                        ts.compliance__c=contactidtoorder.get(con.id).compliance__c;
                    }
                     if(contactidtoorder.get(con.id).EIN__c)
                    {
                        ts.EIN__c=contactidtoorder.get(con.id).EIN__c;
                    }
                    
                     if(contactidtoorder.get(con.id).Standard__c)
                    {
                        ts.Standard__c=contactidtoorder.get(con.id).Standard__c;
                    }
                    
                     if(contactidtoorder.get(con.id).TM_Search__c)
                    {
                        ts.TM_Search__c=contactidtoorder.get(con.id).TM_Search__c;
                    }
                    
                     if(contactidtoorder.get(con.id).Economy__c)
                    {
                        ts.Economy__c=contactidtoorder.get(con.id).Economy__c;
                    }
                    
                     if(contactidtoorder.get(con.id).Express_Gold__c)
                    {
                        ts.Express_Gold__c=contactidtoorder.get(con.id).Express_Gold__c;
                    }
                    taskstoupdate.add(ts);
                }
                
            }
            
        }
        if(opptinsllc.size()>0)
        {
            update opptinsllc;
        }
        if(taskstoupdate.size()>0)
        {
            update taskstoupdate;
        }
    
    }
    }
    // Converted process builder to code
    public static void relateoppstorders(Set<id> contactids , set<string> processingnumbers, map<id,id> contactmap)
    {
    List<opportunity> opportunities;
   
     opportunities =[select    User_Order_ID__c,Contact_Account__c,contact__c from opportunity where  User_Order_ID__c IN :processingnumbers AND contact__c IN : contactids];
    
    
    for(opportunity opp : opportunities)
    {
    
    opp.Order__c=contactmap.get(opp.contact__c);
    opp.AccountId=opp.Contact_Account__c;
    opp.StageName='Closed Won';
    opp.CloseDate=Date.today();
    
    }
    
        if(opportunities.size()>0)
        {
          update opportunities ;  
            
        }
    
    }
    
    
    /*
    	The following code was added by Artyom M. per story B-37567
    	Should additional products needs to be added to onboarding flow, modify this method and ignore the one before this!
    */
    
    public static void createOnboardingOpportunityForBizOrders(List<Order__c> orderList) {
    	System.debug('inside createOnboardingOpportunityForBizOrders');
    	
    	Set<Id> parentContactIds = new Set<Id>();
        Map<Id,Id> contactToAccountId = new Map<Id,Id>();
    	for (Order__c thisOrder : orderList) {
         	parentContactIds.add(thisOrder.Contact__c);
        }
        
		List<Contact> parentContactList = new List<Contact>();
        List<Id> contactsThatHaveOMA = new List<Id>(); 
        if (!parentContactIds.isEmpty()) {
         	parentContactList = [SELECT Id,AccountId, (SELECT Id FROM Order_Matching_Activities__r) FROM Contact WHERE ID IN :parentContactIds];
         	if (!parentContactList.isEmpty()) {
         		for (Contact thisContact : parentContactList) {
                    if(thisContact.AccountId != null){
                        contactToAccountId.put(thisContact.Id,thisContact.accountId);
                    }
         			if (!thisContact.Order_Matching_Activities__r.isEmpty()) {
         				contactsThatHaveOMA.add(thisContact.Id);
         			}
         		}
         	}
         }
    	
    	
    	SEAD_Configuration__c seadConfig = SEAD_Configuration__c.getValues('Default');
    	System.Debug(seadConfig);
    	 
    	
    	List<Opportunity> oppsToInsert = new List<Opportunity>();
    	
    	for (Order__c thisOrder : orderList) {
    		System.debug('thisOrder.Product__c = ' + thisOrder.Product__c);
    		
    		Boolean parentContactHasOma = false;
            if (contactsThatHaveOMA.contains(thisOrder.Contact__c)) {
            	parentContactHasOma = true;
            }
            System.Debug('parentContactHasOma = ' + parentContactHasOma);
    		
    		if (thisOrder.Product__c != null && thisOrder.Product__c.contains('Inc') && !parentContactHasOma) {
    			System.Debug('INC Scenario');
    			Opportunity newOpp = new Opportunity();
    			newOpp.Name = 'TestOpp' + thisOrder.Id;
    			newOpp.Contact__c = thisOrder.Contact__c;
    			newOpp.Order__c = thisOrder.Id;
                if(contactToAccountId.containsKey(thisOrder.Contact__c)) {
                    newOpp.AccountId = contactToAccountId.get(thisOrder.Contact__c);
                }
    			newOpp.StageName = 'New';
    			newOpp.Product2__c = 'INC';
                newOpp.LeadSource = 'On-Boarding';
                if(thisOrder.User_Order_ID__c != null) {
                    newOpp.User_Order_ID_c__c = thisOrder.User_Order_ID__c;
                }
    			newOpp.CloseDate = System.today().addDays(30);

    			
    			newOpp.EIN__c = thisOrder.EIN__c;
    			newOpp.RA__c = thisOrder.RA__c;
    			newOpp.Express_Gold__c = thisOrder.Express_Gold__c;
    			newOpp.Standard__c = thisOrder.Standard__c;
    			newOpp.Economy__c = thisOrder.Economy__c;
    			newOpp.Tax__c = thisOrder.Tax__c;
    			newOpp.BAP__c = thisOrder.BAP__c;
    			newOpp.Compliance__c = thisOrder.Compliance__c;
    			
    			
    			//scoring here
    		
    			
    			oppsToInsert.add(newOpp);
    		}
    	}
    	try {
    		System.debug('oppsToInsert size = ' + oppsToInsert.size());
    		insert oppsToInsert;
    		System.debug('oppsToInsert after insert');
    		List<Opportunity> oppsToUpdate = new List<Opportunity>();
    		for (Opportunity newOpp : oppsToInsert) {
    			System.debug('newOpp = ' + newOpp);
    			Decimal score = 0;
    			if (newOpp.EIN__c) {
    				score+= seadConfig.EIN__c;
    			}
    			if (newOpp.RA__c) {
    				score+= seadConfig.RA__c;
    			}
    			if (newOpp.Express_Gold__c) {
    				score+= seadConfig.Express_Gold__c;
    			}
    			if (newOpp.Standard__c) {
    				score+= seadConfig.Standard__c;
    			}
    			if (newOpp.Economy__c) {
    				score+= seadConfig.Economy__c;
    			}
    			if (newOpp.Tax__c) {
    				score+= seadConfig.Tax__c;
    			}
    			if (newOpp.BAP__c) {
    				score+= seadConfig.BAP__c;
    			}
    			if (newOpp.Compliance__c) {
    				score+= seadConfig.Compliance__c;
    			}
    			System.Debug('score = ' + score);
    			
    			newOpp.Score__c = score;
    			oppsToUpdate.add(newOpp);
    		}
    		update oppsToUpdate;
    	}
    	catch(DMLException e) {
    		System.debug(e);	
    	}
    	
    }
    
    
    
}