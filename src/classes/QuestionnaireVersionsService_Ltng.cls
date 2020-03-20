/*
Migration of Questionnaire Versions functionality to Salesforce
Story: B-22668, B-22671
By Artyom M.
*/

public with sharing class QuestionnaireVersionsService_Ltng extends IADServiceBase_ltng {
	public final static String GETORDERBYORDERID = 'GetOrderByOrderId';
	public final static String GETQUESTVERSIONSBYPROCESSINGNUM = 'GetQuestVersionsByProcessingNum';
	public static QuestionnaireVersionsResponseWrapper questVersionsResponse = new QuestionnaireVersionsResponseWrapper();
	public static QuestionnaireResponseWrapper questResponse = new QuestionnaireResponseWrapper();
	@AuraEnabled public static List<QuestionnaireFieldWrapper> questionnaireFields{get;set;}
	@AuraEnabled public static List<QuestionnaireVersionsBean> questVersions{get;set;}
	@AuraEnabled public static boolean questVersionsObtained{get;set;}
	@AuraEnabled public static boolean questGivenVersionObtained{get;set;}
	@AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    public static string ordernumber ;
	public QuestionnaireVersionsService_Ltng() {
		super();
		List <String> endpoints = new List <String> ();
        endpoints.add(GETORDERBYORDERID);
        endpoints.add(GETQUESTVERSIONSBYPROCESSINGNUM);
        initEndpoints(endpoints);
        questVersionsObtained = false;
        questGivenVersionObtained = false;
        questionnaireFields = new List<QuestionnaireFieldWrapper>();
        questVersions = new List<QuestionnaireVersionsBean>();
        iadServiceMessages = new List<IADMessage_ltng>();
	}
	
	public static void getQuestVersions(String processingNumber) {
		System.Debug('Inside getQuestVersions: ' + processingNumber);
		String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM).endPointConfig.link__c;
		calloutURL = calloutURL.replace('{ProcessingNumber}', processingNumber) + 'versions';
		IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM).setInfo(APIRequestResponseWrapper_ltng.ORDER, processingNumber);
		
		IADServiceBase_ltng.makeRequestMulti(calloutURL, GETQUESTVERSIONSBYPROCESSINGNUM, '');
		APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM);
		populateQuestVersions();
	//	System.Debug('theResponse = ' + theResponse);
	}
	
	public static void populateQuestVersions() {
		System.Debug('Inside populateQuestVersions');
		try {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM);
            System.Debug('theResponse = ' + theResponse);
            System.Debug('checkIsValidResponse = ' + theResponse.checkIsValidResponse());
            if(theResponse.checkIsValidResponse()) {
            	System.Debug('responseData = ' + theResponse.responseData);
                if(theResponse.responseData != null) {
                	questVersionsObtained = true;
                	questVersionsResponse = (QuestionnaireVersionsResponseWrapper) JSON.deserialize(theResponse.responseData, QuestionnaireVersionsResponseWrapper.class);
                	Integer index = 0;
                	for (QuestionnaireVersionsBean qvw: questVersionsResponse.versions) {
                		if(qvw.orderId==Integer.valueOf(ordernumber))
                        {
                            qvw.initilizeName();
                            qvw.index = index;
                            qvw.indexStr = String.valueOf(index);
                            questVersions.add(qvw);
							index++;                            
                        }
					}
                    questVersions.sort(); /* Added for Story - Story B-38259  */ 
                }
                else {
					IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else {	
				IADServiceBase_ltng.populateNullErrorMessage(theResponse);
				iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {

        }
	}
	
	public static void getQuestAnswers(String processingNumber, Integer revision, Integer subrevision) {
		system.Debug('Inside getQuestAnswers: ' + processingNumber);
        system.debug('Revision--->' + revision + 'Subrevision--->' + subrevision);
		String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM).endPointConfig.link__c;
		calloutURL = calloutURL.replace('{ProcessingNumber}', processingNumber) + 'answerBank';
		if (revision != null) {
			calloutURL = calloutURL + '?revision=' + revision;
		}
		if (subrevision != null) {
			if (revision != null) {
				calloutURL = calloutURL + '&subRevision=' + subrevision;
			}
			else {
				calloutURL = calloutURL + '?subRevision=' + subrevision;
			}
		}
		IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM).setInfo(APIRequestResponseWrapper_ltng.ORDER, processingNumber);
		
		IADServiceBase_ltng.makeRequestMulti(calloutURL, GETQUESTVERSIONSBYPROCESSINGNUM, '');
		APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM);
		populateQuest();
	
	}
	
	public static void populateQuest() {
		System.Debug('Inside populateQuest');
		try {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETQUESTVERSIONSBYPROCESSINGNUM);
            System.Debug('theResponse = ' + theResponse);
            System.Debug('checkIsValidResponse = ' + theResponse.checkIsValidResponse());
            if(theResponse.checkIsValidResponse()) {
            	System.Debug('responseData = ' + theResponse.responseData);
                if(theResponse.responseData != null) {
                	questGivenVersionObtained = true;
                	questResponse = (QuestionnaireResponseWrapper) JSON.deserialize(theResponse.responseData, QuestionnaireResponseWrapper.class);
                	Integer rowNum = 1;
                	for (QuestionnaireFieldWrapper qa : questResponse.questionnaireFieldGroupAnswers.fieldAnswers) {
                		//if (qa.fieldId != null) {}
                			qa.rowNumber = rowNum;
	                		//qa.fieldQuestionText = 'test ' + rowNum;
	                		questionnaireFields.add(qa);
	                		rowNum++;
                		
                		
                	}
                	for (QuestionnaireFieldWrapper qa : questResponse.questionnaireFieldGroupAnswers.groupAnswers) {
                		qa.rowNumber = rowNum;
                		//qa.fieldQuestionText = 'test ' + rowNum;
                		qa.fieldName = qa.groupName + ' : ' + qa.fieldName;
                		questionnaireFields.add(qa);
                		rowNum++;
                	}
                	
                }
                else {
					IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
				IADServiceBase_ltng.populateNullErrorMessage(theResponse);
				iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {

        }
	}
	
    // Added Implements Comparable - Story B-38259
	public class QuestionnaireVersionsBean implements Comparable {
		@AuraEnabled public String revisionName{get;set;}
		@AuraEnabled public Integer revision{get;set;}
		@AuraEnabled public Integer subRevision{get;set;}
		@AuraEnabled public Integer questionnaire{get;set;}
		@AuraEnabled public Integer index{get;set;}
        @AuraEnabled public String indexStr{get;set;}
		@AuraEnabled public Datetime dateCreated{get;set;}
		@AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public Integer orderId{get;set;}
		public void initilizeName() {
			if (revision == 0 && subRevision == 0) {
				revisionName = 'Original Order';
			}
			else if (revision == 0 && subRevision != 0) {
				revisionName = 'Original Order - Subrevision #' + subRevision + ': ' + dateCreated;
			}
			else {
				revisionName = 'Revision ' + revision + ' - Subrevision ' + subRevision;
			}
			
			System.Debug('QuestionnaireVersionsWrappers created:' + revisionName);
		}
        
        /* Added for Story - Story B-38259  - Starts Here */
        public Integer compareTo (Object compareTo){

            integer returnValue =1;
            QuestionnaireVersionsBean compareToQues = (QuestionnaireVersionsBean)compareTo;
            
            if(dateCreated > compareToQues.dateCreated){
                return -1;
            } 
            if (dateCreated == compareToQues.dateCreated){
                return 0;
            }
           
            return returnValue;
        }
        /* Added for Story - Story B-38259  - Ends Here */
		
	}
	public class QuestionnaireVersionsResponseWrapper {
		@AuraEnabled public List<QuestionnaireVersionsBean> versions{get;set;}
		
	}
	
	public class QuestionnaireResponseWrapper {
		@AuraEnabled QuestionnaireFieldGroupAnswers questionnaireFieldGroupAnswers{get;set;}

	}
	public class QuestionnaireFieldGroupAnswers {
		@AuraEnabled Boolean isMajorRevision{get;set;}
		@AuraEnabled public List<QuestionnaireFieldWrapper> fieldAnswers{get;set;}
		@AuraEnabled public List<QuestionnaireFieldWrapper> groupAnswers{get;set;}
	}
	public class QuestionnaireFieldWrapper {
		@AuraEnabled Integer fieldId{get;set;}
		@AuraEnabled String groupName{get;set;}
		@AuraEnabled String fieldName{get;set;}
		@AuraEnabled String questionText{get;set;}
		@AuraEnabled String fieldValue{get;set;}
		@AuraEnabled Integer optionId{get;set;}
		@AuraEnabled Integer responseType{get;set;}
		@AuraEnabled Integer rowNumber{get;set;}
	}
	
	
	
    
}