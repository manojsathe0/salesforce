/*
This Web Service application was created to be the API for case creation.
Once the API is hit with a valid request, this will result in a creation of a Case in Salesforce
Created by: Artyom M.
@Updated: Sai
Per story: B-24116
**/

@RestResource(urlMapping = '/DDSExceptionAPI/*')
global class POR_ExceptionAPI {
    private static String messageToReturn;
    private static Order__c matchingOrder;
    private static Boolean isHaveBusnValidationRules = false;
    

    @HttpPost
    global static void handleDDSException () {
        messageToReturn = 'blank';
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.addHeader('Content-Type', 'application/json');
        String requestBody = req.requestBody.toString();
        System.debug(requestBody);
        POR_DDSContractBeans.ExceptionBean exceptionContent;
        if (UtilityLibrary.isNotNullOrBlank(requestBody)) {
            try {
                exceptionContent = (POR_DDSContractBeans.ExceptionBean) JSON.deserialize(requestBody, POR_DDSContractBeans.ExceptionBean.class);
            } catch (JSONException e) {
                messageToReturn = 'Invalid JSON: ' + e.getMessage();
                System.debug(messageToReturn);
                POR_ExceptionAPIService.errorMessage = messageToReturn;
                res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
                res.statusCode = 400;
                return;
            }
        } else {
            messageToReturn = 'Empty requests are not accepted.';
            System.debug(messageToReturn);
            POR_ExceptionAPIService.errorMessage = messageToReturn;
            res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
            res.statusCode = 400;
            return;
        }

        Id einMsgRecId = Schema.SObjectType.Business_Process_Exception__c.getRecordTypeInfosByName().get('EIN Exception').getRecordTypeId();
        Id stateMsgRecId = Schema.SObjectType.Business_Process_Exception__c.getRecordTypeInfosByName().get('State Filing Exception').getRecordTypeId();

        String orderToSearchStr;
        List<Order__c> matchingOrders = new List<Order__c>();
        System.Debug('exceptionContent.orderNumber = ' + exceptionContent.orderNumber);
        System.Debug('exceptionContent.processingNumber = ' + exceptionContent.processingNumber);
        if (UtilityLibrary.isNotNullOrBlank(exceptionContent.orderNumber) && UtilityLibrary.isNotNullOrBlank(exceptionContent.processingNumber)) {
            /* MAIN LOGIC */
            POR_ExceptionAPIService.exceptionContent = exceptionContent;
            POR_ExceptionAPIService.processingNumber = exceptionContent.processingNumber;
            POR_ExceptionAPIService.orderNumber = exceptionContent.orderNumber;
			POR_ExceptionAPIService.isEntityNameRulePresent = false;
            orderToSearchStr = exceptionContent.orderNumber;
            try {
                matchingOrders = [SELECT Id, Contact__c, Contact_State__c, Package__c, State_of_Formation__c FROM Order__c WHERE Name = :orderToSearchStr LIMIT 1];//order by created date
            } catch (QueryException e) {
                messageToReturn = e.getMessage();
                System.debug(messageToReturn);
            }

            if (!matchingOrders.isEmpty()) {
                POR_ExceptionAPIService.theOrder = matchingOrders[0];
                POR_ExceptionAPIService.searchExistingException();
                if (POR_ExceptionAPIService.matchedCorrelationId) {
                    res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getSkippedJSONResponse());
                    res.statusCode = 200;
                    return;
                }

                if (exceptionContent.failedBusinessRules != null && !exceptionContent.failedBusinessRules.isEmpty()) {
                	for (POR_DDSContractBeans.FailedRules fRule : exceptionContent.failedBusinessRules) {
                		if (fRule.name != null && fRule.name.contains('Entity Name')) {
                			POR_ExceptionAPIService.isEntityNameRulePresent = true;
                		}
                	}

                    isHaveBusnValidationRules = true;
                    POR_ExceptionAPIService.processBusinessRuleFailure(matchingOrders[0].id);
                    if (POR_ExceptionAPIService.status.equals('success')) {
                        //POR_ExceptionAPIService.searchExistingCase(exceptionContent.processingNumber);
                        res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getSuccessJSONResponse());//POR_ExceptionAPIService.caseFound + ' = ' + POR_ExceptionAPIService.existingCaseId
                        res.statusCode = 200;
                    } else {
                        res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
                        res.statusCode = 400;
                    }
                } else if (exceptionContent.failedValidationRules != null && !exceptionContent.failedValidationRules.isEmpty()) {
                    isHaveBusnValidationRules = true;
                    POR_ExceptionAPIService.processValidationRuleFailure(matchingOrders[0].id);
                    if (POR_ExceptionAPIService.status.equals('success')) {
                        res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getSuccessJSONResponse());
                        res.statusCode = 200;
                    } else {
                        res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
                        res.statusCode = 400;
                    }
                } else {
                    POR_ExceptionAPIService.errorMessage = 'Invalid content';
                    res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
                    res.statusCode = 400;
                }

                //@Sai - B-35645, If got SOS failures in Paylaod, process them.
                //Inititally if No Business and Validation failures, and No OER exist, create OER as "Production Review"
                //  Else, Update the OER with new Correlation ID.
                Savepoint sp = Database.setSavepoint();
                if (!POR_ExceptionAPIService.exceptionFound && String.isBlank(POR_ExceptionAPIService.exceptionId) && !isHaveBusnValidationRules)
                    POR_ExceptionAPIService.upsertException(matchingOrders[0].id, 'Production Review', 'Production Review');
                else if (!isHaveBusnValidationRules)
                    POR_ExceptionAPIService.updateExceptionCorelationID();

                //@Sai - If found Both State and EIN failures, Inactive all existing SOS Messages.
                if (exceptionContent.stateFailure != null && exceptionContent.einFailure != null) {
                    String query = 'SELECT Id, Status__c from Business_Process_Exception__c';
                    POR_ExceptionAPIService.inActivateExisitingSOSFailures(query, null);
                }

                //@sai - Process SOS State failures, If No Error found in previous process.
                //@param - OrderId, EIN recordType ID, Failure Message, Failure Date
                if (exceptionContent.stateFailure != null && !POR_ExceptionAPIService.anyException) {
                    POR_ExceptionAPIService.processSOSFailures(matchingOrders[0].id, einMsgRecId, exceptionContent.stateFailure.name, exceptionContent.stateFailure.failureDate);
                }

                //@Sai - B-35648, Processing EIN failures, If No Error found in previous process.
                //@param - OrderId, State recordType ID, Failure Message, Failure Date
                if (exceptionContent.einFailure != null && !POR_ExceptionAPIService.anyException) {
                    POR_ExceptionAPIService.processSOSFailures(matchingOrders[0].id, stateMsgRecId, exceptionContent.einFailure.name, exceptionContent.einFailure.failureDate);
                }

                //@Sai - If found any Error while processing records, Rollback all changes and return 400 and error message.
                if (POR_ExceptionAPIService.status.equals('failure') && POR_ExceptionAPIService.anyException) {
                    Database.rollback(sp);
                    res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
                    res.statusCode = 400;
                    return;
                } else {
                    res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getSuccessJSONResponse());
                    res.statusCode = 200;
                }
            } else {
                messageToReturn = POR_ExceptionAPIService.getNoOrderFoundJSONResponse();
                res.responseBody = Blob.valueOf(messageToReturn);
                res.statusCode = 404;
                System.debug(messageToReturn);
            }
            /* MAIN LOGIC END */
        } else {
            POR_ExceptionAPIService.errorMessage = 'Order Number is a required parametr in the request.';
            res.responseBody = Blob.valueOf(POR_ExceptionAPIService.getErrorMessageJSONResponse());
            res.statusCode = 400;
            System.debug(messageToReturn);
        }
        //Padma added @D-07334,B-37176 to capture DDS API request body for troubleshooting. these records will be deleted through a batch job ' DDSRequestbodyCleanupBatch'
        POR_ExceptionAPIService.copyRequestBody(requestBody);
    }
}