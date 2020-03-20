public class POR_ExceptionAPIService {
    public static POR_DDSContractBeans.ResponseBean response;
    public static String status {get; set;}
    public static String errorMessage {get; set;}
    public static Id exceptionId;
    public static Id caseId {get; set;}

    public static Boolean caseFound {get; set;}
    public static Id existingCaseId {get; set;}
    public static Case existingCase {get; set;}

    public static Boolean caseFoundClosedByAgent {get; set;}
    public static Id existingCaseClosedByAgentId {get; set;}
    public static Case existingCaseClosedByAgent {get; set;}

    public static Boolean isRevisionRequest {get; set;}
    public static Boolean exceptionFound {get; set;}
    public static Id existingExceptionId {get; set;}
    public static Order_Exception__c existingException {get; set;}

    public static Boolean isAfterReinjectionRequest {get; set;}
    public static Boolean exceptionInProductionReviewCompleteStatus {get; set;}
    public static Boolean exceptionInEscalateStatus {get; set;}
    public static Boolean isHoldStatus {get; set;}
    public static Boolean isRemovedFromHold {get; set;}
    public static Order__c theOrder {get; set;}

    public static POR_DDSContractBeans.ExceptionBean exceptionContent {get; set;}
    public static String processingNumber {get; set;}
    public static String orderNumber {get; set;}

    public static Boolean matchedCorrelationId {get; set;}
    public static Boolean anyException = false;
    public static Boolean sosInactivated = false;
    public static Boolean isEntityNameRulePresent{get; set;}

    public static String getNoOrderFoundJSONResponse() {
        response = new POR_DDSContractBeans.ResponseBean();
        response.orderNumber = orderNumber;
        response.status = 'failed';
        response.description = 'No order found';

        String str = JSON.serializePretty(response);
        return str;
    }

    public static String getErrorMessageJSONResponse() {
        response = new POR_DDSContractBeans.ResponseBean();
        response.orderNumber = orderNumber;
        response.status = 'failed';
        response.description = errorMessage;

        String str = JSON.serializePretty(response);
        return str;
    }

    public static String getSuccessJSONResponse() {
        response = new POR_DDSContractBeans.ResponseBean();
        response.orderNumber = orderNumber;
        response.status = 'success';
        response.description = 'Exception records created.';

        String str = JSON.serializePretty(response);
        return str;
    }

    public static String getSkippedJSONResponse() {
        response = new POR_DDSContractBeans.ResponseBean();
        response.orderNumber = orderNumber;
        response.status = 'skipped';
        response.description = errorMessage;

        String str = JSON.serializePretty(response);
        return str;
    }

    //@Sai - B-35645, processStateFailuresSOS() to process Failed SOS's
    public static void processSOSFailures(Id orderId, Id recTypeID, String name, String dt) {
        system.debug('---in processStateFailuresSOS');
        //Search existing SOS failures and Inactive them all
        if (!anyException && !sosInactivated) {
            String query = 'SELECT Id, Status__c FROM Business_Process_Exception__c';
            inActivateExisitingSOSFailures(query, recTypeID);
        }

        List<Business_Process_Exception__c> sosMsgList = new List<Business_Process_Exception__c>();
        Business_Process_Exception__c sosMsg = new Business_Process_Exception__c();
        //sosMsg.Name = exceptionContent.stateFailure.name;
        sosMsg.Name = name;
        sosMsg.Order__c = orderId;
        sosMsg.Status__c = 'Active';
        sosMsg.Order_Exception__c = String.isBlank(existingExceptionId) ? exceptionId : existingExceptionId;
        //sosMsg.Failure_Date__c = cleanDate(exceptionContent.stateFailure.failureDate);
        sosMsg.Failure_Date__c = cleanDate(dt);
        sosMsg.recordTypeID = recTypeID;
        sosMsgList.add(sosMsg);

        //Inserting new SOS Messages.
        //If exception occurred while DML, mark anyException flag is TRUE, It will put 400 code and error message in the response payload.
        if (!sosMsgList.isEmpty() && !anyException)
            dmlSObject(sosMsgList, 'insert');
    }

    public static DateTime cleanDate(String dt) {
        if (String.isNotBlank(dt)) {
            dt = dt.replace('T', ' ');
            dt = dt.replace('Z', ' ');
            try {
                return DateTime.valueOf(dt);
            } catch (Exception e) {
                status = 'failure';
                errorMessage = 'Invalid Date: ' + e.getMessage();
                anyException = true;
            }
        }
        return null;
    }

    //Search existing SOS Messages and close them.
    public static void inActivateExisitingSOSFailures(String query, String rt) {
        List<Business_Process_Exception__c> sosMsgList = new List<Business_Process_Exception__c>();
        String oerID = String.isNotBlank(exceptionId) ? exceptionId : existingExceptionId;
        query = query + ' WHERE Order_Exception__c =: oerID';
        query = String.isBlank(rt) ? query : query + ' AND recordTypeID =: rt';
        system.debug('--------q inactivate: ' + query);
        for (Business_Process_Exception__c sosMsg : Database.query(query)) {
            sosMsg.Status__c = 'Inactive';
            sosMsgList.add(sosMsg);
        }
        if (!sosMsgList.isEmpty()) {
            dmlSObject(sosMsgList, 'update');
            sosInactivated = true;
        }
    }

    //Sai - B-35645
    //if current OER correlation ID is not equal to current payload correlation ID, Update OER.
    //Use this method only when we got SOS/EIN failures in the payload.
    //SOS/EIN will not update OER, If we are not having Business/Validation rules. So this following method will just update the correlation ID on OER.
    public static void updateExceptionCorelationID() {
        //system.debug('----'+existingException.Correlation_Id__c);
        system.debug('----' + exceptionContent.correlationId);
        if (!existingException.Correlation_Id__c.equals(exceptionContent.correlationId)) {
            Order_Exception__c orderExp = new Order_Exception__c();
            orderExp.Correlation_Id__c = exceptionContent.correlationId;
            orderExp.Id = existingExceptionId;
            dmlSObject(orderExp, 'update');
        }
    }

    public static void processBusinessRuleFailure(Id orderId) {
        //searchExistingException();
        searchExistingCase();
        if (exceptionFound && isRevisionRequest && existingException.Exception_Type__c != null && existingException.Exception_Type__c.equals('Resolved')) {
            System.Debug('Resolution_Reason__c setting to blank');
            existingException.Resolution_Reason__c = '';
        }
        if (isRevisionRequest) {
            //per B-31938
            existingException.Reason_for_Escalation__c = '';
        }

        if (isRevisionRequest) {
            closeExistingCase('Revision placed on LZ.com');
        }
		if (isEntityNameRulePresent) {
			System.Debug('Entity Name scenario');
			closeExistingCase('My Account Update');
		}
        if (existingCaseClosedByAgentId != null && !exceptionInProductionReviewCompleteStatus) {
            upsertException(orderId, 'Production Review', 'Started');
        } else if (exceptionFound && exceptionInProductionReviewCompleteStatus && !isRevisionRequest) {
            System.Debug('exceptionInProductionReviewCompleteStatus = ' + exceptionInProductionReviewCompleteStatus);
            existingException.Production_Review_Result__c = 'Business Rule Problems';
            upsertException(orderId, 'Problem', 'Problem');
            createCase(orderId);
        } else if (exceptionFound && exceptionInEscalateStatus) {
            existingException.Production_Review_Result__c = 'Escalated to Production Supervisor';
            upsertException(orderId, existingException.Exception_Type__c, existingException.Status__c);
            //createCase(orderId);
        } else {
            if (isRemovedFromHold) {
                upsertException(orderId, 'Production Review', 'Started');
            } else {
                upsertException(orderId, 'Production Review', 'Production Review');
            }
        }

        if (status.equals('success')) {
            createFailedRules(orderId);
        }
    }

    public static void processValidationRuleFailure(Id orderId) {
        //searchExistingException();
        if (exceptionFound && isRevisionRequest && existingException.Exception_Type__c != null && existingException.Exception_Type__c.equals('Resolved')) {
            System.Debug('Resolution_Reason__c setting to blank');
            existingException.Resolution_Reason__c = '';
        }
        if (isRevisionRequest) {
            //per B-31938
            existingException.Reason_for_Escalation__c = '';
        }
        if (exceptionFound && exceptionInProductionReviewCompleteStatus) {
            existingException.Production_Review_Result__c = 'No Business Rule Problems';
            upsertException(orderId, 'Problem', 'Problem');
        } else if (exceptionFound && exceptionInEscalateStatus) {
            existingException.Production_Review_Result__c = 'Escalated to Production Supervisor';
            upsertException(orderId, existingException.Exception_Type__c, existingException.Status__c);
        }

        else if (exceptionFound && isHoldStatus) {
            upsertException(orderId, 'Hold', 'Hold');
            /* }
              else {
                  status = 'success';
                  exceptionId = existingExceptionId;
              }*/
        } else {
            upsertException(orderId, 'Problem', 'Problem');
        }
        searchExistingCase();
        if (isRevisionRequest) {
            closeExistingCase('Revision placed on LZ.com');
        }

        if (!exceptionInEscalateStatus) {
            if (existingCaseClosedByAgent != null && !isAfterReinjectionRequest) {
                System.Debug('caseFoundClosedByAgent = ' + caseFoundClosedByAgent);
                reopenCase(existingCaseClosedByAgentId);
            } else {
                createCase(orderId);
            }
        }

        System.debug('Line 147 with status = ' + status);
        if (status.equals('success')) {

            createFailedRules(orderId);
        }
    }
    public static void createFailedRules(Id orderId) {
        System.debug('in createFailedRules with case ID: ' + caseId);
        Id rtId_Biz = Schema.SObjectType.Failed_Rules__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Id rtId_ORCO = Schema.SObjectType.Failed_Rules__c.getRecordTypeInfosByName().get('ORCO').getRecordTypeId();
        List<Failed_Rules__c> existingFailedRules = new List<Failed_Rules__c>();
        List<Failed_Rules__c> existingFailedManualRules = new List<Failed_Rules__c>();
        List<Failed_Rules__c> existingFailedRulesToUpdate = new List<Failed_Rules__c>();
        if (existingExceptionId != null) {
            existingFailedRules = [SELECT Id, Status__c FROM Failed_Rules__c WHERE Parent_Exception__c = :existingExceptionId AND Status__c != 'Ignore' AND  Rule_Type__c != 'Manual' LIMIT 100];
            System.Debug('existingFailedRules found: ' + existingFailedRules.size());
            if (!existingFailedRules.isEmpty()) {
                for (Failed_Rules__c fRule : existingFailedRules) {
                    fRule.Status__c = 'Inactive';
                    existingFailedRulesToUpdate.add(fRule);
                }
            }
            if (isRevisionRequest) {
                System.Debug('Its revision request, so deactivation manual rules');
                existingFailedManualRules = [SELECT Id, Status__c FROM Failed_Rules__c WHERE Parent_Exception__c = :existingExceptionId AND Rule_Type__c = 'Manual' AND Status__c = 'Active' LIMIT 100];
                System.Debug('existingFailedManualRules found: ' + existingFailedManualRules.size());
                if (!existingFailedRules.isEmpty()) {
                    for (Failed_Rules__c fRule : existingFailedManualRules) {
                        fRule.Status__c = 'Resolved';
                        existingFailedRulesToUpdate.add(fRule);
                    }
                }
            }
            if (!existingFailedRulesToUpdate.isEmpty()) {
                try {
                    update existingFailedRulesToUpdate;
                } catch (DmlException e) {
                    System.Debug(e.getMessage());
                }
            }
        }
        List<Failed_Rules__c> failedRulesToIsert = new List<Failed_Rules__c>();
        if (exceptionContent.failedBusinessRules != null) {
            for (POR_DDSContractBeans.FailedRules fRule : exceptionContent.failedBusinessRules) {
                Failed_Rules__c rl = new Failed_Rules__c();
                rl.Parent_Exception__c = exceptionId;
                rl.Rule_Type__c = 'Business Rule';
                rl.Order__c = orderId;
                rl.Parent_Case__c = caseId;
                rl.RecordTypeId = rtId_Biz;
                if (UtilityLibrary.isNotNullOrBlank(fRule.name)) {
                    rl.Name = fRule.name.left(79);
                } else {
                    break;
                }
                rl.Description__c = fRule.description;
                rl.Status__c = 'Active';
                failedRulesToIsert.add(rl);
            }
        }

        if (exceptionContent.failedValidationRules != null) {
            for (POR_DDSContractBeans.FailedRules fRule : exceptionContent.failedValidationRules) {
                Failed_Rules__c rl = new Failed_Rules__c();
                if (UtilityLibrary.isNotNullOrBlank(fRule.name)) {
                    rl.Name = fRule.name.left(79);
                } else {
                    break;
                }
                rl.Description__c = fRule.description;
                rl.Parent_Exception__c = exceptionId;
                rl.Rule_Type__c = 'Proofer Validation Rule';
                rl.Order__c = orderId;
                rl.Parent_Case__c = caseId;
                rl.RecordTypeId = rtId_ORCO;
                rl.Status__c = 'Active';
                failedRulesToIsert.add(rl);
            }
        }

        System.Debug(failedRulesToIsert.size());
        try {
            insert failedRulesToIsert;
            status = 'success';
        } catch (DmlException e) {
            System.Debug(e.getMessage());
            status = 'failure';
            errorMessage = 'In createFailedRules method: ' + e.getMessage();
        }
    }
    public static void upsertException(Id orderId, String exceptionType, String exceptionStatus) {
        Order_Exception__c ex = new Order_Exception__c();
        /* */
        if (exceptionFound) {
            ex = existingException;
            System.Debug('existingException assigned for upsert.');
        }

        ex.Order_Number__c = orderId;
        ex.Exception_Type__c = exceptionType;
        ex.Status__c = exceptionStatus;
        ex.Trigger_DDS_Process__c = false;
        ex.Trigger_Order_due_date__c = false;
        ex.Reinjection_Request_Submitted__c = false;
        ex.Closed_by_Agent__c = null;
        ex.Is_Removed_From_Hold__c = false;
        if (String.isNotBlank(exceptionContent.correlationId)) {
            ex.Correlation_Id__c = exceptionContent.correlationId;
        }

        if (exceptionContent.exceptionDateTime != null) {
            ex.Exception_DateTime__c = exceptionContent.exceptionDateTime;
        }

        ex.CustomerID__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.customerId);
        ex.CustomerLogin__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.customerLogin);

        ex.Email__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.email);

        ex.First_Name__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.firstName);
        ex.Last_Name__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.lastName);

        if (UtilityLibrary.isNotNullOrBlank(exceptionContent.phone)) {
            ex.Phone__c = PhoneFormatter.formatPhone(exceptionContent.phone);
        }

        // = UtilityLibrary.ifNotBlankThenCopy(caseBody.uuid);

        ex.Processing_Number__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.processingNumber);
        //ex.Subject__c = ex.Processing_Number__c + ' - ' + theOrder.Package__c + ' - ' + theOrder.State_of_Formation__c;
        //ex.Subject__c = ex.Processing_Number__c + ' - ' + theOrder.Package__c + ' - ' + theOrder.Contact_State__c;
        try {
            upsert ex Processing_Number__c;
            status = 'success';
            exceptionId = ex.id;
        } catch (DmlException e) {
            status = 'failure';
            errorMessage = 'In upsertException method: ' + e.getMessage();
        }
    }
    public static void reopenCase(Id caseToreopenId) {
        System.debug('In reopenCase with id ' + caseToreopenId);
        System.debug('this.caseId id ' + caseId);
        caseId = caseToreopenId;
        Case caseToreopen = new Case();
        caseToreopen.Id = caseToreopenId;
        caseToreopen.POR_Closed_By__c = null;
        caseToreopen.Status = 'LZ Working on Case';
        caseToreopen.Status_Reasons__c = 'Assigned for Customer Outreach';
        caseToreopen.Assigned_User__c = null;
        // padma Modified @B-29678 issues
        QueueSObject QueueID = [SELECT Queue.Id, Queue.Name, Queue.Type FROM QueueSObject WHERE Queue.Type = 'Queue' AND Queue.Name = 'CC PS Outgoing'];
        /*

        List<Group> orderDueQueues = new List<Group>();
        orderDueQueues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'CC PS Outgoing'];
        */
        //Group QueueID = [SELECT Id,Name, DeveloperName FROM Group WHERE Type = 'Queue' and DeveloperName='CC_PS_Outgoing' ][0];
        System.debug('QueueID  = ' + QueueID + ' and name: ' + QueueID.Queue.Name);
        if (QueueID.Id != null) {
            caseToreopen.Queue__c = QueueID.Queue.Name;
            caseToreopen.OwnerId = QueueID.Queue.Id;
            //caseToreopen.Queue__c=QueueId.DeveloperName;
            //caseToreopen.OwnerId = QueueID.DeveloperName;
            try {
                update caseToreopen;
                caseId = caseToreopen.Id; //padma added
            } catch (Exception e) {
                status = 'failure';
                errorMessage = 'In upsertException method: ' + e.getMessage();
                System.debug('Exception: ' + e);
            }
        }
    }

    //Sai - D-07421 ::: It will upsert the case.
    public static void createCase(Id orderId) {
        Case theCase = new Case();
        //@Sai - If existing case is exist, then upsert the case with existing case ID.
        theCase.Id = String.isNotBlank(existingCaseId) ? existingCaseId : null;

        theCase.Order_Exception__c = exceptionId;
        //theCase.CaseId__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.caseId);
        theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);

        String firstName = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.firstName);
        String lastName = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.lastName);
        theCase.SuppliedName = firstName + ' ' + lastName;

        theCase.UUID__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.uuid);

        theCase.SuppliedEmail = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.email);

        theCase.CustomerID__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.customerId);

        if (UtilityLibrary.isNotNullOrBlank(exceptionContent.phone)) {
            theCase.SuppliedPhone = PhoneFormatter.formatPhone(exceptionContent.phone);
        }

        if (UtilityLibrary.isNotNullOrBlank(exceptionContent.orderNumber)) {
            //theCase.ContactId = matchingOrder.Contact__c;
            theCase.Order__c = orderId;
            theCase.Order_Number__c = exceptionContent.orderNumber;
        }

        theCase.Processing_Number__c = UtilityLibrary.ifNotBlankThenCopy(exceptionContent.processingNumber);
        //START PER STORY B-26405
        theCase.Status = 'Waiting on Customer';
        theCase.Status_Reasons__c = 'Email Sent, Pending Response';

        if (exceptionId != null) {

            List<Order_Exception__c> orderexceptions = [select Product__c from Order_Exception__c where id = :exceptionId];
            theCase.Product2__c = orderexceptions[0].Product__c;
        }
        //String subject = theCase.Processing_Number__c + '-' + theOrder.Package__c;
        //theCase.Subject = theCase.Processing_Number__c + ' - ' + theOrder.Package__c + ' - ' + theOrder.State_of_Formation__c;

        //END PER STORY B-26405


        if (UtilityLibrary.isNotNullOrBlank(exceptionContent.customerLogin)) {
            List<Customer_Login__c> custLogin = new List<Customer_Login__c>();

            custLogin = [SELECT Id, Name FROM Customer_Login__c WHERE Name = :exceptionContent.customerLogin LIMIT 100];
            if (!custLogin.isEmpty()) {
                theCase.Customer_Login__c = custLogin[0].Id;
            }
        }

        try {
            upsert theCase;
            caseId = theCase.Id;

            List<Failed_Rules__c> manualRules = new List<Failed_Rules__c>();
            manualRules = [SELECT Id, Parent_Case__c FROM Failed_Rules__c WHERE (Parent_Exception__c = :exceptionId AND Rule_Type__c = 'Manual' AND Status__c = 'Active')];
            System.Debug('Manual rules to update with case: ' + manualRules.size());
            for (Failed_Rules__c mRule : manualRules) {
                mRule.Parent_Case__c = caseId;
            }
            update manualRules;
            /*
            if (existingCase != null) {
                closeExistingCase('');
            }
            */
        } catch (DMLException e) {
            status = 'failure';
            errorMessage = 'In createCase method: ' + e.getMessage();
        }

    }

    public static void searchExistingCase() {
        System.Debug('in searchExistingCase with ' + processingNumber);
        List<Case> existingCases = new List<Case>();
        List<Case> allExistingCases = new List<Case>();
        if (processingNumber != null) {
            System.Debug('Before query with ' + processingNumber);
            //existingCases = [SELECT Id, Processing_Number__c FROM Case WHERE (Processing_Number__c = :processingNumber AND Status != 'Closed') LIMIT 100];
            Id problemRecTypeID = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
            existingCases = [SELECT Id, Processing_Number__c FROM Case WHERE (Processing_Number__c = :processingNumber AND Status != 'Closed' AND RecordTypeId =: problemRecTypeID) LIMIT 100];
            System.Debug('existingCases size = ' + existingCases.size());
            if (existingCases.size() > 0) {
                caseFound = true;
                existingCaseId = existingCases[0].id;
                existingCase = existingCases[0];
            }

            allExistingCases = [SELECT Id, POR_Closed_By__c, Processing_Number__c FROM Case WHERE (Status = 'Closed' AND Processing_Number__c = :processingNumber AND POR_Closed_By__c != null) ORDER BY ClosedDate DESC];
            System.Debug('allExistingCases size = ' + allExistingCases.size());
            if (allExistingCases.size() > 0) {
                System.Debug('Last Case ID = ' + allExistingCases[0].id);
                caseFoundClosedByAgent = true;
                existingCaseClosedByAgentId = allExistingCases[0].id;
                existingCaseClosedByAgent = allExistingCases[0];
            }
        }
    }

    public static void searchExistingException() {
        matchedCorrelationId = false;
        List<Order_Exception__c> existingExceptions = new List<Order_Exception__c>();
        if (processingNumber != null) {
            existingExceptions = [SELECT Id, Status__c, Exception_Type__c, Reinjection_Request_Submitted__c, Correlation_Id__c, Is_Removed_From_Hold__c, Order_Number__r.Name, Production_Review_Result__c, Product__c, Processing_Number__c FROM Order_Exception__c WHERE Processing_Number__c = :processingNumber LIMIT 100];
            System.Debug('existingExceptions for processingNumber ' +  ' size = ' + existingExceptions.size());
            if (existingExceptions.size() > 0) {
                existingException = existingExceptions[0];
                exceptionFound = true;
                existingExceptionId = existingException.id;
                if (String.isNotBlank(exceptionContent.correlationId)) {
                    System.debug('correlationId = ' + exceptionContent.correlationId);
                    if (String.isNotBlank(existingException.Correlation_Id__c) && existingException.Correlation_Id__c.equals(exceptionContent.correlationId)) {
                        System.debug('existingException.Correlation_Id__c = ' + existingException.Correlation_Id__c);
                        matchedCorrelationId = true;
                        errorMessage = 'Duplicate call with the same Correlation Id: ' + exceptionContent.correlationId;
                    }
                }
                if (existingException.Status__c != null && existingException.Status__c.equals('Production Review Complete')) {
                    exceptionInProductionReviewCompleteStatus = true;
                } else {
                    exceptionInProductionReviewCompleteStatus = false;
                }
                if (existingException.Status__c != null && existingException.Status__c.equals('Escalate')) {
                    exceptionInEscalateStatus = true;
                } else {
                    exceptionInEscalateStatus = false;
                }
                if (existingException.Status__c != null && existingException.Status__c.equals('Hold')) {
                    isHoldStatus = true;
                } else {
                    isHoldStatus = false;
                }

                if (existingException.Reinjection_Request_Submitted__c) {
                    isAfterReinjectionRequest = true;
                } else {
                    isAfterReinjectionRequest = false;
                }

                System.Debug('exceptionInProductionReviewCompleteStatus = ' + exceptionInProductionReviewCompleteStatus);
                System.Debug('this.orderNumber ' +  orderNumber);

                if (!orderNumber.equals(existingExceptions[0].Order_Number__r.Name)) {
                    isRevisionRequest = true;
                } else {
                    isRevisionRequest = false;
                }
                if (existingException.Is_Removed_From_Hold__c) {
                    isRemovedFromHold = true;
                } else {
                    isRemovedFromHold = false;
                }
                System.Debug('isRevisionRequest = ' + isRevisionRequest);
            } else {
                exceptionFound = false;
                isRevisionRequest = false;
                exceptionInEscalateStatus = false;
                isRemovedFromHold = false;
                isHoldStatus = false;
                isAfterReinjectionRequest = false;
            }
        }
    }

    public static void closeExistingCase(String statusReason) {
        System.Debug('in closeExistingCase: ' + existingCase);
        if (existingCase != null) {
            existingCase.Status = 'Closed';
            existingCase.Status_Reasons__c = statusReason;
            try {
                update existingCase;
            } catch (DMLException e) {
                System.Debug(e.getMessage());
            }
        }
    }
    public static void closeExceptionsAndCases(Set<Id> orderIds, String exceptionType, String exceptionClosureReason, String caseClosureReason) {
        System.debug('inside closeExceptionsAndCases with ' + orderIds.size());
        System.debug('exceptionClosureReason is ' + exceptionClosureReason);
        if (orderIds.size() > 0) {
            List<Order_Exception__c> exceptionList = new List<Order_Exception__c>();
            exceptionList = [SELECT Id, Exception_Type__c, Status__c, Reinjection_Request_Submitted__c, Resolution_Reason__c, Closed_by_Agent__c FROM Order_Exception__c WHERE Order_Number__c IN: orderIds LIMIT 1000];
            System.debug('exceptionList size: ' + exceptionList.size());
            System.debug('exceptionList : ' + exceptionList);

            Set<Id> revisionExceptionIdSet = new Set<Id>();
            Set<Id> exceptionIdSet = new Set<Id>();
            for (Order_Exception__c excp : exceptionList) {
                System.debug('excp status : ' + excp.Status__c);
                if (excp.Status__c != null && excp.Status__c.equals('Resolved')) {
                    System.debug('status Resolved');

                } else if (excp.Status__c != null && excp.Status__c.equals('Production Review Complete')) {
                    System.debug('status Complete');
                    excp.Exception_Type__c = exceptionType;
                    excp.Status__c = exceptionType;
                } else if (excp.Reinjection_Request_Submitted__c) {
                    System.debug('status Reinjection_Request_Submitted__c');
                    excp.Exception_Type__c = exceptionType;
                    excp.Status__c = exceptionType;
                } else {
                    System.debug('status else');
                    revisionExceptionIdSet.add(excp.Id);
                    excp.Exception_Type__c = exceptionType;
                    excp.Status__c = exceptionType;
                    excp.Resolution_Reason__c = exceptionClosureReason;
                }
                /*
                System.debug('closed by agent is'+excp.Closed_by_Agent__c);
                if(excp.Closed_by_Agent__c == null ) { // padma added

                    system.debug('Padma inside ifcondition ');

                }
                */
                excp.Reinjection_Request_Submitted__c = false;
                exceptionIdSet.add(excp.Id);
            }
            update exceptionList;
            if (!revisionExceptionIdSet.isEmpty()) {
                System.Debug('revisionExceptionIdSet = ' + revisionExceptionIdSet.size());
                List<Failed_Rules__c> existingFailedManualRules = new List<Failed_Rules__c>();
                existingFailedManualRules = [SELECT Id, Status__c FROM Failed_Rules__c WHERE Parent_Exception__c = :revisionExceptionIdSet AND Rule_Type__c = 'Manual' AND Status__c = 'Active' LIMIT 100];
                System.Debug('existingFailedManualRules found: ' + existingFailedManualRules.size());
                if (!existingFailedManualRules.isEmpty()) {
                    for (Failed_Rules__c fRule : existingFailedManualRules) {
                        fRule.Status__c = 'Resolved';
                    }
                    try {
                        update existingFailedManualRules;
                    } catch (DmlException e) {
                        System.Debug(e.getMessage());
                    }
                }
            }

            if (exceptionIdSet.size() > 0) {
                List<Case> casesToUpdate = new List<Case>();
                casesToUpdate = [SELECT Id, POR_Closed_By__c, Order_Exception__c FROM Case WHERE (Order_Exception__c IN :exceptionIdSet AND Status != 'Closed') LIMIT 1000];
                System.debug('casesToUpdate size: ' + casesToUpdate.size());
                for (Case cs : casesToUpdate) {
                    cs.Status = 'Closed';
                    if (cs.POR_Closed_By__c == null) {
                        cs.Status_Reasons__c = caseClosureReason;
                    }
                }
                update casesToUpdate;
            }
        }
    }

    public static void dmlSObject(sObject sobj, String type) {
        List<SObject> sobjList = new List<sObject>();
        sobjList.add(sobj);
        dmlSObject(sobjList, type);
    }
    public static void dmlSObject(List<sObject> sobjList, String type) {
        try {
            status = 'success';
            if (type == 'insert')
                insert sobjList;
            if (type == 'update')
                update sobjList;
            if (type == 'delete')
                delete sobjList;
        } catch (Exception e) {
            system.debug('------------err:' + e.getMessage());
            String objName = String.valueof(sobjList[0].getSObjectType());
            status = 'failure';
            String errMsg = 'Updating ' + objName + ' Object failed: ' + e.getMessage();
            errorMessage = String.isBlank(errorMessage) ? errMsg : errorMessage + '\n' + errMsg;
            anyException = true;
        }
    }

    //Padma added @D-07334,B-37176 to capture DDS API request body for troubleshooting. these records will be deleted through a batch job ' POR_RequestbodyCleanupBatch'
    public static void copyRequestBody(String requestbody) {
        if (requestbody != null && requestbody != '') {
            POR_Request__c ddsreq = new POR_Request__c();
            ddsreq.POR_Request_Body__c = requestbody;
            ddsreq.Order_Number__c = orderNumber;
            try {
                insert  ddsreq;
            }
            //Writing catch block in single line for more code coverage
            catch (DmlException e) {SendExceptionEmail_ltng.createErrorLog(e.getMessage(), null, null, null, null, null, null, null, UserInfo.getUserId()); }
        }
    }
}