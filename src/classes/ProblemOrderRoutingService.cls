public without Sharing class ProblemOrderRoutingService
{
    public static Map<Id,Order__c> orderIdToOrderMap = new Map<Id,Order__c>();
    public static  Map<String,String> processingNumberToProduct = new Map<String,String>();
    public static Map<String,POR_case_routing_queues__c> productToPORInfo
    {
        get
        {
            if(productToPORInfo == null) 
            {
                productToPORInfo = new Map<String,POR_case_routing_queues__c>();
                for (POR_case_routing_queues__c productToQueueMap : [SELECT Name , Queue_Name__c FROM POR_case_routing_queues__c])
                {
                    productToPORInfo.put(productToQueueMap.Name,productToQueueMap);
                }
            }
            return productToPORInfo;
        } 
        set;
    }

    public static Map<String,Id> developerNameToRecordTypeIds
    { 
        get
        {
            if(developerNameToRecordTypeIds == null)
            {
                List<RecordType> recordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE sObjectType = 'Case'];    
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


    public static void createCaseForProblemOrder(List<Task> tasksWithProblem)
    {
        List<Case> problemCasesToInsert = new List<Case>();
        Set<Id> orderIds = new Set<Id>();
        Set<String> processingNumbers = new Set<String>();
        List<Order_Item__c> orderItems = new List<Order_Item__c>();

        for(Task theTask : tasksWithProblem)
        {
            orderIds.add(theTask.WhatId);
            if(theTask.User_Order_ID__c != null || theTask.User_Order_ID__c != '')
                processingNumbers.add(theTask.User_Order_ID__c); 
        }
        system.debug(processingNumbers);
        if(!orderIds.isEmpty())
            orderIdToOrderMap = new Map<Id,Order__c>([Select Id, Name, Base_Product_Text__c ,Contact__c, User_Order_ID__c , Contact_State__c , Customer_Login__c , OrderID__c From Order__c Where Id IN: orderIds]);

        if(!processingNumbers.isEmpty())
            for(Order_Item__c theOrderItem : [SELECT ID, User_Order_ID__c , Product__r.Name FROM Order_Item__c Where User_Order_ID__c IN: processingNumbers])// AND Product__r.Name IN: ])
            {
                processingNumberToProduct.put(theOrderItem.User_Order_ID__c, theOrderItem.Product__r.Name);
            }
        system.debug(processingNumberToProduct);
        for(Task theTask : tasksWithProblem)
        {
            problemCasesToInsert.add(createProblemCase(theTask));
        }
        if(!problemCasesToInsert.isEmpty())
            try
            {
                insert problemCasesToInsert;
                POREmailSender emailSender = new POREmailSender();
                emailSender.sendEmailsToCustomer(problemCasesToInsert);

            }
            catch(DmlException exp)
            {
                system.debug(exp+'exception');
                SendExceptionEmail.sendDMLExceptionEmail(exp, ProblemOrderConstants.PROBLEM_CASE_ERROR_MESSAGE);
            }
    }

    public static Case createProblemCase(Task theTask)
    {

        Case newCase = new Case();
            Order__c relatedOrder = orderIdToOrderMap.get(theTask.WhatId);
            newCase.Order__c = theTask.WhatId;
            newCase.Order_Number__c = relatedOrder.OrderID__c;
            newCase.Product__c = processingNumberToProduct.get(theTask.User_Order_ID__c); //from map
            newCase.Product2__c = ProblemOrderConstants.POA; // hardcode
            newCase.Problem_Order_Type__c = theTask.Action_type__c;
            newCase.ContactId = relatedOrder.Contact__c;
            newCase.Customer_Login__c = relatedOrder.Customer_Login__c;
            newCase.RecordTypeId =  developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
            newCase.Subject = theTask.User_Order_ID__c +'-'+processingNumberToProduct.get(theTask.User_Order_ID__c)+'-'+relatedOrder.Contact_State__c;
            newCase.Processing_Number__c = theTask.User_Order_ID__c; 
            newCase.DateTime_Problem_Identified__c= theTask.Datetime_Created_External_System__c;
            newCase.POR_Email_Status__c = ProblemOrderConstants.FIRST_EMAIL;
            if(productToPORInfo.containsKey(ProblemOrderConstants.POA))
                newCase.Queue__c = productToPORInfo.get(ProblemOrderConstants.POA).Queue_Name__c;
        return newCase;
    }

    public static void closeRelatedOpenCasesForRevisedOrder(List<Order_Item__c> newOrderItems)
    {
        Set<String> processingNummbers = new Set<String>();
        List<Case> casesToClose = new List<Case>();
        for(Order_Item__c theOrderItem : newOrderItems)
        {
            system.debug(theOrderItem.Relationship_Type_Text__c);
            system.debug(theOrderItem.Relationship_Type__c);
            if(theOrderItem.Relationship_Type_Text__c == ProblemOrderConstants.REVISION)
            {
                processingNummbers.add(theOrderItem.User_Order_ID__c);
            }
        }
        
        if(!processingNummbers.isEmpty())
            for(Case caseToClose : [Select Id, Processing_Number__c, Order_Exception__c, Status, Problem_Order_Resolution__c From Case Where Processing_Number__c In: processingNummbers AND  RecordTypeId = : developerNameToRecordTypeIds.get('Problem_Case')])
            {
                    caseToClose.Status = ProblemOrderConstants.CLOSED_STATUS;
                    if(caseToClose.Problem_Order_Resolution__c != ProblemOrderConstants.UNRESOLVED_CLOSED)
                        caseToClose.Problem_Order_Resolution__c = ProblemOrderConstants.REVISED_ORDER_RESOLUTION_REASON;
                    else if(caseToClose.Problem_Order_Resolution__c == ProblemOrderConstants.UNRESOLVED_CLOSED)
                            caseToClose.Problem_Order_Resolution__c = ProblemOrderConstants.REVISION_AFTER_7DAY_STATUS;
                if (caseToClose.Order_Exception__c == null) {
                    casesToClose.add(caseToClose); 
                }
                    
            }


        if(!casesToClose.isEmpty())
            try
            {
                Update casesToClose;
            }
            catch(DmlException exp)
            {
                SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to Close cases for revised order.');
            }
    }

    public static void countNumberOfOutboundEmails(List<EmailMessage> newEmails)
    {
        system.debug(UserInfo.getName()+'Current User Name');
        List<Case> casesToUpdate = new List<Case>();
        Set<Id> caseIds = new Set<Id>();
        Map<Id,Integer> idToNoOfEmails = new Map<Id,Integer>();
        Map<Id,Integer> idToNoOfAutoEmails = new Map<Id,Integer>();
        for(EmailMessage theEmail : newEmails)
        {
           if(theEmail.Incoming == false)
           {
             caseIds.add(theEmail.ParentId);
             if(idToNoOfEmails.containsKey(theEmail.ParentId))
             {
                 idToNoOfEmails.put(theEmail.ParentId, idToNoOfEmails.get(theEmail.ParentId)+1);
             }
             else
             {
                 idToNoOfEmails.put(theEmail.ParentId,1);
             }
           }
           //if(theEmail.CreatedById == CampaignFutureHandler.integrationUser.Id || theEmail.CreatedById == TaskService.emailToCaseUser.Id)
           //removed the reference of integration user from CampaignFutureHandler class and used the Utility library instead: B-38758
           if(UtilityLibrary.allIntegrationUserIds.contains(theEmail.CreatedById) || theEmail.CreatedById == TaskService.emailToCaseUser.Id)
           {
                if(idToNoOfAutoEmails.containsKey(theEmail.ParentId))
                 {
                     idToNoOfAutoEmails.put(theEmail.ParentId, idToNoOfAutoEmails.get(theEmail.ParentId)+1);
                 }
                 else
                 {
                     idToNoOfAutoEmails.put(theEmail.ParentId,1);
                 }
           }
        }

        Map<Id,Case> caseIdToCase = new Map<Id,Case>();
        if(!caseIds.isEmpty())
        caseIdToCase = new Map<Id,Case>([Select Id, Total_Outbound_Emails__c , Total_Automatic_Outbound_Emails__c From Case Where Id IN :caseIds]);
        
        for(Case theCase : caseIdToCase.values())
        {
            //Total emails
            if(idToNoOfEmails.containsKey(theCase.Id))
            {
                if(theCase.Total_Outbound_Emails__c != null)
                    theCase.Total_Outbound_Emails__c = theCase.Total_Outbound_Emails__c + idToNoOfEmails.get(theCase.Id);
                else
                    theCase.Total_Outbound_Emails__c = idToNoOfEmails.get(theCase.Id);
            }

            //Total Automatic emails
            if(idToNoOfAutoEmails.containsKey(theCase.Id))
            {
                if(theCase.Total_Automatic_Outbound_Emails__c != null)
                    theCase.Total_Automatic_Outbound_Emails__c = theCase.Total_Automatic_Outbound_Emails__c + idToNoOfAutoEmails.get(theCase.Id);
                else
                    theCase.Total_Automatic_Outbound_Emails__c =  idToNoOfAutoEmails.get(theCase.Id);
            }

            casesToUpdate.add(theCase);
        }
        try
        {
            if(!casesToUpdate.isEmpty())
                Update casesToUpdate;
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to Calculate total no of Outbound Emails on case.');
        }
    }

}