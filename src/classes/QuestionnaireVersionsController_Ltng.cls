/*
Migration of Questionnaire Versions functionality to Salesforce
Story: B-22668, B-22671
By Artyom M.
*/

public with sharing class QuestionnaireVersionsController_Ltng {
	@AuraEnabled public static QuestionnaireVersionsService_Ltng questService{get;set;}
	
	
	@AuraEnabled
	public static QuestionnaireVersionsService_Ltng getQuestionnaireVersionsByProcessingNumber(String processingNumber) {
		System.Debug('Inside getQuestionnaireVersionsByProcessingNumber! = ' + processingNumber);
		try {
			questService = new QuestionnaireVersionsService_Ltng();
			IADServiceBase_ltng.initWrapper(QuestionnaireVersionsService_Ltng.GETQUESTVERSIONSBYPROCESSINGNUM);
	    	QuestionnaireVersionsService_Ltng.getQuestVersions(processingNumber);
		}
		catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	throw new AuraHandledException('From getQuestionnaireVersionsByProcessingNumber: ' + theException.getMessage());
        }
		
		
		return questService;
	}
	
	@AuraEnabled
	public static QuestionnaireVersionsService_Ltng getQuestionnaireByProcessingNumber(String processingNumber, Integer revision, Integer subrevision) {
		System.Debug('Inside getQuestionnaireByProcessingNumber! = ' + processingNumber);
		try {
			questService = new QuestionnaireVersionsService_Ltng();
			IADServiceBase_ltng.initWrapper(QuestionnaireVersionsService_Ltng.GETQUESTVERSIONSBYPROCESSINGNUM);
	    	QuestionnaireVersionsService_Ltng.getQuestAnswers(processingNumber, revision, subrevision);
		}
		catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	throw new AuraHandledException('From getQuestionnaireVersionsByProcessingNumber: ' + theException.getMessage());
        }
		
		
		return questService;
	}
	
    
}