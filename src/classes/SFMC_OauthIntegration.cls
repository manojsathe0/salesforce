/**********************************************************************************
 *
 * Change Log
 * Modified By                       Date                      Description
 * Haritha Ravuru                   3/7/2019                  #B-39282 added new methods for Reset password Marketting cloud triggersend
 */
public with sharing class SFMC_OauthIntegration {
	public static String accessToken{get;set;}
	public static Integer expiresInSeconds{get;set;}
	public static String eventsResponse{get;set;}
	public static Integer eventsResponseStatusCode{get;set;}
	public static Marketing_Cloud_Endpoint__mdt endpointMtd{get;set;}

	public static void loadSupportingCustomMetadata() {
		System.debug('Inside loadSupportingCustomMetadata');
		List<Marketing_Cloud_Endpoint__mdt> SFMCEndpoints = new List<Marketing_Cloud_Endpoint__mdt>(); 
		SFMCEndpoints = [SELECT Client_Id__c, Client_Secret__c, Token_Request_URL__c, Events_URL__c FROM Marketing_Cloud_Endpoint__mdt WHERE DeveloperName = 'Default' LIMIT 1];
		if (!SFMCEndpoints.isEmpty()) {
			endpointMtd = SFMCEndpoints[0];
			System.debug('endpointMtd.Client_Id__c = ' + endpointMtd.Client_Id__c);
			System.debug('endpointMtd.Client_Secret__c = ' + endpointMtd.Client_Secret__c);
			System.debug('endpointMtd.Token_Request_URL__c = ' + endpointMtd.Token_Request_URL__c);
			System.debug('endpointMtd.Events_URL__c = ' + endpointMtd.Events_URL__c);
		}
		else {
			System.debug('No Marketing_Cloud_Endpoint__mdt records found!.');
		}
		
		
	}

	public static void loadSupportingCustomMetadataResetPwd(String orderType,String categoryName) {
		System.debug('Inside loadSupportingCustomMetadata ResetPwd');
		List<Marketing_Cloud_Endpoint__mdt> SFMCEndpoints = new List<Marketing_Cloud_Endpoint__mdt>();
		SFMCEndpoints = [SELECT Client_Id__c, Client_Secret__c, Token_Request_URL__c, Events_URL__c FROM Marketing_Cloud_Endpoint__mdt where Order_Type__c=:orderType and Category_Name__c = :categoryName];
		if (!SFMCEndpoints.isEmpty()) {
			//endpointMtd = SFMCEndpoints[0];
			System.debug(SFMCEndPoints.size()+' endpointMtd ' + SFMCEndpoints);
			endpointMtd = SFMCEndpoints[0];
			System.debug('endpointMtd.Client_Id__c = ' + endpointMtd.Client_Id__c);
			System.debug('endpointMtd.Client_Secret__c = ' + endpointMtd.Client_Secret__c);
			System.debug('endpointMtd.Token_Request_URL__c = ' + endpointMtd.Token_Request_URL__c);
			System.debug('endpointMtd.Events_URL__c = ' + endpointMtd.Events_URL__c);

		}
		else {
			System.debug('No Marketing_Cloud_Endpoint__mdt records found!.');
		}


	}
    public static void getOauthToken() {
    	System.debug('Inside getOauthToken');
		//loadSupportingCustomMetadata();
    	
    	if (endpointMtd != null) {
    		SFMC_ContractBeans.TokenRequest tokenRequestWrapper = new SFMC_ContractBeans.TokenRequest();
    		tokenRequestWrapper.clientId = endpointMtd.Client_Id__c;
    		tokenRequestWrapper.clientSecret = endpointMtd.Client_Secret__c;
    		String JSONPayload = JSON.serialize(tokenRequestWrapper);
    		System.debug('JSONPayload = ' + JSONPayload);
    		
    		HttpRequest req = new HttpRequest();
	    	req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
	    	req.setEndpoint(endpointMtd.Token_Request_URL__c);
	    	req.setMethod('POST');
	    	req.setBody(JSONPayload);
	    	
	    	try {
	    		Http http = new Http();
	    		HTTPResponse res = http.send(req);
	    		
	    		if (res.getBody() != null) {
	    			SFMC_ContractBeans.TokenResponse oauthResponse = (SFMC_ContractBeans.TokenResponse) JSON.deserialize(res.getBody(), SFMC_ContractBeans.TokenResponse.class);
	    			accessToken = oauthResponse.accessToken;
	    			expiresInSeconds = oauthResponse.expiresIn;
	    		}
	    		System.debug(res.getBody());
	    		
	    	}
	    	catch(System.CalloutException e) {
	    		System.debug('Error while getting access token: ' + e.getMessage());
	    	}
    	}

    }
    //@future(callout=true)
    public static void makeEventsCallout(String JSONbody) {
    	System.debug('Inside makeEventsCallout');
        System.debug(JSONbody);
		loadSupportingCustomMetadata();
    	SFMC_OauthIntegration.getOauthToken();
    	if (accessToken != null) {
    		HttpRequest req = new HttpRequest();
	    	req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
	    	req.setHeader('Authorization', 'Bearer ' + accessToken);
	    	req.setEndpoint(endpointMtd.Events_URL__c);
	    	req.setMethod('POST');
	    	req.setBody(JSONbody);
	    	
	    	try {
	    		Http http = new Http();
	    		HTTPResponse res = http.send(req);
	    		eventsResponseStatusCode = res.getStatusCode();

	    		if (res.getBody() != null) {
	    			eventsResponse = res.getBody();
		    		System.debug(res.getBody());
	    		}

	    	}
	    	catch(System.CalloutException e) {
	    		System.debug('Error while calling Events API: ' + e.getMessage());
	    	}
    	}
    	
    	
    	
	}

	public static void makeEventsCalloutResetPwd(String JSONbody,String orderType,String categoryName) {
		System.debug('Inside makeEventsCallout ResetPwd');
		System.debug(JSONbody);
		System.debug('order Type ### '+orderType+' category name ### '+categoryName);
		SFMC_OauthIntegration.loadSupportingCustomMetadataResetPwd(orderType,categoryName);
		SFMC_OauthIntegration.getOauthToken();

		if (accessToken != null) {
			HttpRequest req = new HttpRequest();
			req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
			req.setHeader('Authorization', 'Bearer ' + accessToken);
			req.setEndpoint(endpointMtd.Events_URL__c);
			req.setMethod('POST');
			req.setBody(JSONbody);

			try {
				Http http = new Http();
				HTTPResponse res = http.send(req);
				eventsResponseStatusCode = res.getStatusCode();

				if (res.getBody() != null) {
					eventsResponse = res.getBody();
					System.debug(res.getBody());
				}
				System.debug(eventsResponseStatusCode+' events response ## '+eventsResponse);
			}
			catch(System.CalloutException e) {
				System.debug('Error while calling Events API: ' + e.getMessage());
			}
		}



	}
}