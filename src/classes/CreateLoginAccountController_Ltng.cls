public with sharing class CreateLoginAccountController_Ltng {
	
	@AuraEnabled
	public static String createAccount(String email) {
		
		return makeAPICall(email);
	}
	private static String makeAPICall(String email){
		String JSONString = generateJSONReqtestString(email);
		System.debug('JSONString: '+ JSONString);
		String endPointURL;
		endPointURL = 'callout:CreateNewAccount';
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		
		Http http = new Http();
        req.setEndpoint(endPointURL);
		
		req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
		req.setTimeout(IADConstants.TIMEOUT);
		
		req.setBody(JSONString);
        req.setMethod('POST');
        
        try {
			res = http.send(req);
		} catch(Exception e) {
			System.debug('Callout error: '+ e);
			throw new AuraHandledException('Callout error: '+ e.getMessage());
		}

		return res.getBody();	
		
	}
	
	private static String generateJSONReqtestString(String email) {
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeStringField('email', email);
		gen.writeStringField('password', 'string');
		gen.writeEndObject();
		String pretty = gen.getAsString();
		
		return pretty;
		
	}
    
}