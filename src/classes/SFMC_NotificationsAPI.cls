/*
	MC Phase 2 functionality.
	Delivering an API endpoint to perform a contact Search in Salesforce and pass the contact infromation further to Marketing Cloud
	Stories: B-27980, B-28913
	Developer: Artyom M. 
***************************************************************************
* Change Log
* Modified By                       Date                                    Description
* Haritha Ravuru                  3/7/2019                                #B-39282 Added new method Marketing cloud reset password Trigger Send
*/

@RestResource(urlMapping='/v1/notificationAPI')
global class SFMC_NotificationsAPI {
	@HttpPost
    global static void handleHTTPRequest() {
    	RestResponse res = Restcontext.response;
    	res.addHeader('Content-Type', 'application/json');
    	
		Set<String> TriggerSendcategoryNames = new Set<String>();
    	
    	RestRequest req = RestContext.request;
    	String requestBody = req.requestBody.toString();
    	System.debug(requestBody);
    	SFMC_NotificationsAPIService notificationService = new SFMC_NotificationsAPIService(); 
    	
    	
    	SFMC_ContractBeans.InboundRequest inboundRequest;
		if (UtilityLibrary.isNotNullOrBlank(requestBody)) {
        	try {
        		inboundRequest = (SFMC_ContractBeans.InboundRequest) JSON.deserialize(requestBody, SFMC_ContractBeans.InboundRequest.class);
				for(Notification_Category__mdt category : [select DeveloperName from Notification_Category__mdt]){
					TriggerSendcategoryNames.add(category.DeveloperName);
				}
                System.debug('TriggeSend category names ### '+TriggerSendcategoryNames);
        	}
        	catch (JSONException e) {
	        	SFMC_NotificationsAPIService.status = 'failed';
	        	SFMC_NotificationsAPIService.message = 'Invalid JSON: ' + e.getMessage();
	        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
	        	res.statusCode = 400;
	        	APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
	        	return;
        	}
        	if (inboundRequest.metaData == null || inboundRequest.referenceData == null || inboundRequest.referenceData.customer == null) {
        		SFMC_NotificationsAPIService.status = 'failed';
	        	SFMC_NotificationsAPIService.message = 'One or more required nodes are missing in the request: metaData, referenceData';
	        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
	        	res.statusCode = 400;
	        	APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
	        	return;
        	}
        	
        }
        else {
        	SFMC_NotificationsAPIService.status = 'failed';
        	SFMC_NotificationsAPIService.message = 'Empty requests are not allowed.';
        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
        	res.statusCode = 400;
        	APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
        	return;
        }
        
        SFMC_NotificationsAPIService.getJorneyIdFromCategory(inboundRequest);
        if (String.isBlank(inboundRequest.metaData.categoryName)) {
			SFMC_NotificationsAPIService.status = 'failed';
        	SFMC_NotificationsAPIService.message = 'No categoryName was found in the request.';
        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
        	res.statusCode = 400;
        	APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
        	return;
        }
        if (String.isBlank(inboundRequest.metaData.notificationId)) {
			SFMC_NotificationsAPIService.status = 'failed';
        	SFMC_NotificationsAPIService.message = 'The notificationId parametr in the request is not valid.';
        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
        	res.statusCode = 400;
        	APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
        	return;
        }
        if (String.isNotBlank(SFMC_NotificationsAPIService.jorneyId)) {
        	if (inboundRequest.referenceData.customer.customerId != null) {
        		
        		if (String.isNotBlank(inboundRequest.referenceData.customer.contactType)) {
        			String contactType = inboundRequest.referenceData.customer.contactType;
        			if (contactType.equals('Primary')) {
        				SFMC_NotificationsAPIService.contactTypePrimary = true;
        				SFMC_NotificationsAPIService.contactTypeLogin = false;
						SFMC_NotificationsAPIService.contactTypeOther = false;
        			}
					else
        			if (contactType.equals('Login')) {
        				SFMC_NotificationsAPIService.contactTypePrimary = false;
								SFMC_NotificationsAPIService.contactTypeOther = false;
        				SFMC_NotificationsAPIService.contactTypeLogin = true;
        			}
							else
									if (contactType.equals('Override')) {
										SFMC_NotificationsAPIService.contactTypePrimary = false;
										SFMC_NotificationsAPIService.contactTypeLogin = false;

										SFMC_NotificationsAPIService.contactTypeOther = true;
									}
									else {
										SFMC_NotificationsAPIService.status = 'failed';
										SFMC_NotificationsAPIService.message = 'contactType parameter should have one of the following values: Primary, Login, Override. You passed: ' + contactType;
										res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
										res.statusCode = 400;
										APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
										return;
									}
				}


				String fkUser = String.valueOf(inboundRequest.referenceData.customer.customerId);
				SFMC_NotificationsAPIService.queryContactByCustumerId(fkUser);
				SFMC_NotificationsAPIService.queryAccountByCustumerId(fkUser);
				System.debug('matchingRecordFound: ' + SFMC_NotificationsAPIService.matchingRecordFound);


				if (SFMC_NotificationsAPIService.matchingRecordFound || (SFMC_NotificationsAPIService.contactTypeOther && SFMC_NotificationsAPIService.matchingRecordFound)) {
					SFMC_NotificationsAPIService.optionalData = inboundRequest.optionalData;
					SFMC_NotificationsAPIService.optionalData.put('notificationId', inboundRequest.metaData.notificationId);
                    System.debug('category name that i have in the request ### '+inboundRequest.metaData.categoryName);
					if(TriggerSendcategoryNames.contains(inboundRequest.metaData.categoryName)){
						if((SFMC_NotificationsAPIService.contactTypeOther && SFMC_NotificationsAPIService.matchingRecordFound ) || SFMC_NotificationsAPIService.matchingRecordFound  ) {
							String resetPasswordPayload = SFMC_NotificationsAPIService.buildresetPasswordPayloadAndGetAsJSON();
							System.debug('Modified payload for reset password notifications ### ' + resetPasswordPayload);
							String orderType = SFMC_NotificationsAPIService.optionalData.containsKey('orderType') ? SFMC_NotificationsAPIService.optionalData.get('orderType') : SFMC_NotificationsAPIService.optionalData.get('OrderType');
							System.debug('order Type ### ' + orderType);
							if (String.isBlank(orderType))
								orderType = 'LegalZoom';
							SFMC_OauthIntegration.makeEventsCalloutResetPwd(resetPasswordPayload, orderType, inboundRequest.metaData.categoryName);
						}
					}else {
						SFMC_OauthIntegration.makeEventsCallout(SFMC_NotificationsAPIService.buildEventsCalloutWrapperAndGetAsJSON());
					}
        			
        			if (SFMC_OauthIntegration.eventsResponseStatusCode == 201) {
        				SFMC_NotificationsAPIService.status = 'Success';
	        			SFMC_NotificationsAPIService.message = 'Request was successfully passed to SFMC.';
	        			if (String.isNotBlank(SFMC_OauthIntegration.eventsResponse)) {
	        				SFMC_NotificationsAPIService.SFMCResponse = (Map<String, String>) JSON.deserialize(SFMC_OauthIntegration.eventsResponse, Map<String, String>.class);	
	        			}
	        			res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());//SFMC_NotificationsAPIService.buildEventsCalloutWrapperAndGetAsJSON()
				        res.statusCode = 200;
				        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 200);
				        return;	
					}else if (SFMC_OauthIntegration.eventsResponseStatusCode == 202){
						System.debug('received 202 response from Trigger send ### '+SFMC_OauthIntegration.eventsResponse);
						SFMC_NotificationsAPIService.status = 'Success';
						SFMC_NotificationsAPIService.message = 'Request was successfully passed to SFMC.';
						//SFMC_ContractBeans.ResetPwdResponse resetPwdResponse = (SFMC_ContractBeans.ResetPwdResponse) JSON.deserialize(SFMC_OauthIntegration.eventsResponse, SFMC_ContractBeans.ResetPwdResponse.class);
						Map<String,Object> resetPwdResponse = (Map<String,Object>)Json.deserializeUntyped(SFMC_OauthIntegration.eventsResponse);
						//System.debug('reset pwd response ### '+resetPwdResponse);
						if(resetPwdResponse != null){
							List<Object> responses = new List<Object>();
                            if(resetPwdResponse.containsKey('responses'))
                            responses = (List<Object>)resetPwdResponse.get('responses');
							Map<String,Object> responseData = new Map<String,Object>();
							if(!responses.isEmpty()){
								responseData = (Map<String,object>)responses[0];
								//System.debug('response has errors ### '+responseData.get('hasErrors')+' recepient Send Id ### '+responseData.get('recipientSendId')+' messages ## '+responseData.get('messages'));
							}
                            if(responseData != null && responseData.containsKey('recipientSendId'))
							SFMC_NotificationsAPIService.SFMCResponse.put('eventInstanceId',String.valueOf(responseData.get('recipientSendId')));

							if(responseData.containsKey('hasErrors') && String.valueOf(responseData.get('hasErrors')).equalsIgnoreCase('false')){
								res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
								res.statusCode = 200;
								APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 200);
							}else if(responseData.containsKey('hasErrors') && String.valueOf(responseData.get('hasErrors')).equalsIgnoreCase('true')){
								if(responseData.containsKey('messageErrors')){
									System.debug('response has msg errors ### '+responseData.get('messageErrors'));
									List<Object> messageInfo = (List<Object>)responseData.get('messageErrors');
									Map<String,Object> msgErrors = (Map<String,Object>)messageInfo[0];
									//System.debug('response has msg errors ### '+messageInfo[0]);
									System.debug('error code ### '+msgErrors.get('messageErrorCode')+' msg ## '+msgErrors.get('messageErrorStatus'));
                                    if(msgErrors.containsKey('messageErrorCode'))
									SFMC_NotificationsAPIService.SFMCResponse.put('errorcode',String.valueOf(msgErrors.get('messageErrorCode')));
                                    if(msgErrors.containsKey('messageErrorStatus'))
									SFMC_NotificationsAPIService.SFMCResponse.put('message',String.valueOf(msgErrors.get('messageErrorStatus')));
								}
								res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
								res.statusCode = 200;
                                APIEndpointStatisticsService.incrementResponseCodeValueAndLog('notificationAPI', 400,SFMC_NotificationsAPIService.buildresetPasswordPayloadAndGetAsJSON(),String.valueOf(SFMC_OauthIntegration.eventsResponse),String.valueOf(SFMC_OauthIntegration.endpointMtd.Events_URL__c),fkUser,userInfo.getUserId());
							}
						}

						return;
					}
        			else
        			if (SFMC_OauthIntegration.eventsResponseStatusCode != null) {
        				SFMC_NotificationsAPIService.status = 'failed';
	        			SFMC_NotificationsAPIService.message = 'Request was successfully passed to SFMC, but SFMC responded with code ' + SFMC_OauthIntegration.eventsResponseStatusCode;
								if(TriggerSendcategoryNames.contains(inboundRequest.metaData.categoryName)){
									Map<String,Object> resetPwdResponse = (Map<String,Object>)Json.deserializeUntyped(SFMC_OauthIntegration.eventsResponse);
									System.debug('reset pwd response ### '+resetPwdResponse);
									if(resetPwdResponse != null){
										List<Object> responses = new List<Object>();
										if(resetPwdResponse.containsKey('responses'))
										responses = (List<Object>)resetPwdResponse.get('responses');
										Map<String,Object> responseData = new Map<String,Object>();
										if(responses != null && responses.size() > 0){
											responseData = (Map<String,object>)responses[0];
											//System.debug('response has errors ### '+responseData.get('hasErrors')+' recepient Send Id ### '+responseData.get('recipientSendId')+' messages ## '+responseData.get('messages'));
										}
                                        if(responseData != null && responseData.containsKey('recipientSendId'))
										SFMC_NotificationsAPIService.SFMCResponse.put('eventInstanceId',String.valueOf(responseData.get('recipientSendId')));
										res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
										System.debug('response Body sending back to AWS ### '+res.responseBody);
										if(responseData.containsKey('hasErrors') && String.valueOf(responseData.get('hasErrors')).equalsIgnoreCase('true')){
											System.debug('trigger send for reset password API returns Same Code 400 for invalid payload ### in hasErrors false');
											if(responseData.containsKey('messages'))
                                            SFMC_NotificationsAPIService.message = String.valueOf(responseData.get('messages'));
											res.statusCode = 400;
                                            APIEndpointStatisticsService.incrementResponseCodeValueAndLog('notificationAPI', 400,SFMC_NotificationsAPIService.buildresetPasswordPayloadAndGetAsJSON(),String.valueOf(SFMC_OauthIntegration.eventsResponse),String.valueOf(SFMC_OauthIntegration.endpointMtd.Events_URL__c),fkUser,userInfo.getUserId());
										}
									}
								}else {
	        			if (String.isNotBlank(SFMC_OauthIntegration.eventsResponse)) {
	        				SFMC_NotificationsAPIService.SFMCResponse = (Map<String, String>) JSON.deserialize(SFMC_OauthIntegration.eventsResponse, Map<String, String>.class);	
	        			}
	        			
	        			res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());//SFMC_NotificationsAPIService.buildEventsCalloutWrapperAndGetAsJSON()
				        res.statusCode = 400;
				        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
				        return;	
        			}
							}
        			else {
        				SFMC_NotificationsAPIService.status = 'failed';
	        			SFMC_NotificationsAPIService.message = 'An error occurred while calling SFMC API.';
	        			if (String.isNotBlank(SFMC_OauthIntegration.eventsResponse)) {
	        				SFMC_NotificationsAPIService.SFMCResponse = (Map<String, String>) JSON.deserialize(SFMC_OauthIntegration.eventsResponse, Map<String, String>.class);	
	        			}
	        			
	        			res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());//SFMC_NotificationsAPIService.buildEventsCalloutWrapperAndGetAsJSON()
				        res.statusCode = 500;
				        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 500);
				        return;	
        			}
        			
        		}
        		else {
        			ContactAPIService cntAPIService = new ContactAPIService();
					IADServiceBase_ltng.initWrapper('GetContactsByCustomerId');
					ContactAPIService.getContactByCustomerId(fkUser);
					System.debug('ContactAPIService.contactCreated: ' + ContactAPIService.contactCreated);
					System.debug('ContactAPIService.accountCreated: ' + ContactAPIService.accountCreated);
					if (ContactAPIService.contactDataLoadedSuccessfully && (ContactAPIService.contactCreated || ContactAPIService.accountCreated)) {
						SFMC_NotificationsAPIService.status = 'failed';
	        			SFMC_NotificationsAPIService.message = 'A Contact record for ' + fkUser + ' is being created. Repeat the request within a minute.';
	        			res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
				        res.statusCode = 404;
				        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 404);
				        return;
					}
					else {
						SFMC_NotificationsAPIService.status = 'failed';
						if (ContactAPIService.errorMessage != '') {
							SFMC_NotificationsAPIService.message = fkUser + ': ' + ContactAPIService.errorMessage;
						}
						else {
							SFMC_NotificationsAPIService.message = 'Contact does not exist in LZ systems: ' + fkUser;
						}
	        			
	        			res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
				        res.statusCode = 404;
				        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 404);
				        return;
					}
        			
        			
        			
        		}
        	}
        	else {
	        	SFMC_NotificationsAPIService.status = 'failed';
	        	SFMC_NotificationsAPIService.message = 'No customerId was found in the request.';
	        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
		        res.statusCode = 400;
		        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 400);
		        return;
	        }

        }
        else {
        	
        	res.responseBody = Blob.valueOf(SFMC_NotificationsAPIService.getJSONResponse());
	        res.statusCode = 404;
	        APIEndpointStatisticsService.incrementResponseCodeValue('notificationAPI', 404);
	        return;
        }

    }
    
}