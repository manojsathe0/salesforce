/****************************************************************************
	
	API endpoint created as part of the DDS project and as foundation for the future QC project.
	The purpose of this API is to create QC Cases for the agents to review doucments generated in FileNet
	Stories: B-39556
	Developer: Artyom M.
	 
****************************************************************************/
@RestResource(urlMapping='/v1/DocumentReviewRequestAPI')
global class DocumentReviewRequestAPI {
	public static DocumentReviewRequestBeans.DocumentReviewRequestResponse responseBodyWrapper;
	@HttpPost
	global static void handleHTTPRequest() {
		responseBodyWrapper = new DocumentReviewRequestBeans.DocumentReviewRequestResponse();
		RestRequest req = RestContext.request;
		String requestBody = req.requestBody.toString();
		System.debug(requestBody);
		DocumentReviewRequestBeans.DocumentReviewInboundRequest inboundRequest;
		
		
		RestResponse res = Restcontext.response;
		res.addHeader('Content-Type', 'application/json');
		if (String.isNotBlank(requestBody)) {
			try {
				inboundRequest = (DocumentReviewRequestBeans.DocumentReviewInboundRequest) JSON.deserialize(requestBody, DocumentReviewRequestBeans.DocumentReviewInboundRequest.class);
			}
			catch (JSONException e) {
				responseBodyWrapper.status = 'Failed';
				responseBodyWrapper.caseNumber = null;
				responseBodyWrapper.description = 'Not a valid JSON: ' + e.getMessage();
				
				res.responseBody = Blob.valueOf(getJSONResponse());
				res.statusCode = 400;
				//APIEndpointStatisticsService.incrementResponseCodeValue('DocumentReviewRequestAPI', 400);
				return;
			}
            
            if (inboundRequest.productProcessingId != null) {
                String processingNumber = String.valueOf(inboundRequest.productProcessingId);
                
                List<Order_Exception__c> listOfExceptions = new List<Order_Exception__c>();
        		listOfExceptions = [SELECT Id, Name, Processing_Number__c, Order_Number__c FROM Order_Exception__c WHERE Processing_Number__c = :processingNumber];
                if (!listOfExceptions.isEmpty()) {
                	Order_Exception__c queriedException = listOfExceptions[0];
                	System.debug('starting case creation for ' + queriedException);
			        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Document QC Request').getRecordTypeId();
			        System.debug('recordTypeId = ' + recordTypeId);

			        Case caseToCreate = new Case();
			        caseToCreate.Processing_Number__c = processingNumber;
			        caseToCreate.Subject = 'Document Review Required';
			        caseToCreate.Order_Exception__c = queriedException.Id;
			        caseToCreate.RecordTypeId = recordTypeId;
			        
			        try {
			        	insert caseToCreate;
			        	Case queriedCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseToCreate.Id];
			        	
			        	System.debug(caseToCreate);
			        	if (queriedCase != null) {
			        		responseBodyWrapper.status = 'Success';
			        		responseBodyWrapper.caseNumber = queriedCase.caseNumber;
							responseBodyWrapper.description = 'Case was created for the Order Exception ' + queriedException.Name;
							res.responseBody = Blob.valueOf(getJSONResponse());
							res.statusCode = 200;
							//APIEndpointStatisticsService.incrementResponseCodeValue('DocumentReviewRequestAPI', 400);
							return;
						}
			        	
						
						
						
						
			        }
			        catch (DMLException e) {
			        	System.debug(e.getMessage());	
			        }
			        

                }
                else {
                    responseBodyWrapper.status = 'Failed';
                    responseBodyWrapper.caseNumber = null;
                    responseBodyWrapper.description = 'No order exception found with Processing Number ' + processingNumber;
                    res.responseBody = Blob.valueOf(getJSONResponse());
                    res.statusCode = 404;
                    return;
                }
                
                
            }
            else {
                responseBodyWrapper.status = 'Failed';
				responseBodyWrapper.caseNumber = null;
				responseBodyWrapper.description = 'productProcessingId is a required field.';
				res.responseBody = Blob.valueOf(getJSONResponse());
				res.statusCode = 400;
				return;
            }
            
            
			
		}
        else {
            responseBodyWrapper.status = 'Failed';
			responseBodyWrapper.caseNumber = null;
			responseBodyWrapper.description = 'Request body is empty.';
			res.responseBody = Blob.valueOf(getJSONResponse());
			res.statusCode = 400;
			return;
        }
		
	}
	
	public static String getJSONResponse() {
		String str = JSON.serializePretty(responseBodyWrapper);
		System.debug('Response: ' + str);
		return str;
	}
    
}