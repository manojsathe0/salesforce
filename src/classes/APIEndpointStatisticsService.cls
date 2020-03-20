/*************************
Updated by Haritha on 3/12
**************************/
public without sharing class APIEndpointStatisticsService {
	/*
	private APIEndpointStatistics__c APIEndpoint;
	private String endpointName;
    public APIEndpointStatisticsService(String endpointName) {
    	APIEndpoint = new APIEndpointStatistics__c();
    	List<APIEndpointStatistics__c> APIEndpointList = new List<APIEndpointStatistics__c>();
    	this.endpointName = endpointName;
    	try {
    		APIEndpointList = [SELECT Machine_Name__c, Runtime_Version__c, Request_Count__c, Response_Count_for_200__c, Response_Count_for_400__c, Response_Count_for_404__c, Response_Count_for_500__c FROM APIEndpointStatistics__c WHERE Name = :endpointName LIMIT 1];
    		System.Debug('Stats loaded on first run: ' + APIEndpointList.size());
    		if(APIEndpointList.isEmpty()) {
    			APIEndpointStatistics__c APIEndpointToInsert = new APIEndpointStatistics__c();
    			APIEndpointToInsert.Name = endpointName;
    			APIEndpointToInsert.Request_Count__c = 0;
    			APIEndpointToInsert.Response_Count_for_200__c = 0;
    			APIEndpointToInsert.Response_Count_for_400__c = 0;
    			APIEndpointToInsert.Response_Count_for_404__c = 0;
    			APIEndpointToInsert.Response_Count_for_500__c = 0;
    			APIEndpointToInsert.Runtime_Version__c = '1.0.0';
    			APIEndpointToInsert.Machine_Name__c = 'Salesforce';
    			insert APIEndpointToInsert;
    			APIEndpointList = [SELECT Machine_Name__c, Runtime_Version__c, Request_Count__c, Response_Count_for_200__c, Response_Count_for_400__c, Response_Count_for_404__c, Response_Count_for_500__c FROM APIEndpointStatistics__c WHERE Name = :endpointName LIMIT 1];
    			System.Debug('Stats loaded after insert: ' + APIEndpointList.size());
    		}
			
			if(!APIEndpointList.isEmpty()) {
				APIEndpoint = APIEndpointList[0];
				if (APIEndpoint.Response_Count_for_200__c == null) {
					APIEndpoint.Response_Count_for_200__c = 0;
				}
				if (APIEndpoint.Response_Count_for_400__c == null) {
					APIEndpoint.Response_Count_for_400__c = 0;
				}
				if (APIEndpoint.Response_Count_for_404__c == null) {
					APIEndpoint.Response_Count_for_404__c = 0;
				}
				if (APIEndpoint.Response_Count_for_500__c == null) {
					APIEndpoint.Response_Count_for_500__c = 0;
				}
				APIEndpoint.Request_Count__c++;
				update APIEndpoint;
			}
			
		}
		catch (Exception e) {
			System.Debug(e.getMessage());
		}
    }
    */
	@future
	public static void incrementResponseCodeValue(String endpointName, Integer statusCode) {
		System.debug('in future static incrementResponseCodeValue with statusCode ' + statusCode);
		APIEndpointStatistics__c APIEndpoint = new APIEndpointStatistics__c();
		List<APIEndpointStatistics__c> APIEndpointList = new List<APIEndpointStatistics__c>();

		try {
			APIEndpointList = [SELECT Request_Count__c, Response_Count_for_200__c, Response_Count_for_400__c, Response_Count_for_404__c, Response_Count_for_500__c FROM APIEndpointStatistics__c WHERE Name = :endpointName LIMIT 1];
			System.Debug('Stats loaded on first run: ' + APIEndpointList.size());

			if(!APIEndpointList.isEmpty()) {
				APIEndpoint = APIEndpointList[0];
				System.Debug('APIEndpoint: ' + APIEndpoint);


				if (APIEndpoint.Request_Count__c == null) {
					APIEndpoint.Request_Count__c = 0;
				}
				if (APIEndpoint.Response_Count_for_200__c == null) {
					APIEndpoint.Response_Count_for_200__c = 0;
				}
				if (APIEndpoint.Response_Count_for_400__c == null) {
					APIEndpoint.Response_Count_for_400__c = 0;
				}
				if (APIEndpoint.Response_Count_for_404__c == null) {
					APIEndpoint.Response_Count_for_404__c = 0;
				}
				if (APIEndpoint.Response_Count_for_500__c == null) {
					APIEndpoint.Response_Count_for_500__c = 0;
				}

				APIEndpoint.Request_Count__c++;
				if (statusCode == 200) {
					APIEndpoint.Response_Count_for_200__c++;
				}
				else
						if (statusCode == 400) {
							APIEndpoint.Response_Count_for_400__c++;
						}
						else
								if (statusCode == 404) {
									APIEndpoint.Response_Count_for_404__c++;
								}
								else
										if (statusCode == 500) {
											APIEndpoint.Response_Count_for_500__c++;
										}

				update APIEndpoint;
			}

		}
		catch (Exception e) {
			System.Debug(e.getMessage());
		}
	}
	/*
    public void incrementResponseCodeValue(Integer statusCode) {
        System.debug('in incrementResponseCodeValue');
        if (statusCode == 200) {
            APIEndpoint.Response_Count_for_200__c++;
        }
        else
        if (statusCode == 404) {
            APIEndpoint.Response_Count_for_404__c++;
        }



        try {
            update APIEndpoint;
        }
        catch (Exception e) {
            System.Debug(e.getMessage());
        }
  
    }
    */

	public static void incrementResponseCodeValueAndLog(String endpointName, Integer statusCode,String payload,String response,String endpoint,String customerId,String userId ) {
		System.debug('in future static incrementResponseCodeValue with statusCode ' + statusCode);
		APIEndpointStatistics__c APIEndpoint = new APIEndpointStatistics__c();
		List<APIEndpointStatistics__c> APIEndpointList = new List<APIEndpointStatistics__c>();

		try {
			APIEndpointList = [SELECT Request_Count__c, Response_Count_for_200__c, Response_Count_for_400__c, Response_Count_for_404__c, Response_Count_for_500__c FROM APIEndpointStatistics__c WHERE Name = :endpointName LIMIT 1];
			System.Debug('Stats loaded on first run: ' + APIEndpointList.size());

			if(!APIEndpointList.isEmpty()) {
				APIEndpoint = APIEndpointList[0];
				System.Debug('APIEndpoint: ' + APIEndpoint);


				if (APIEndpoint.Request_Count__c == null) {
					APIEndpoint.Request_Count__c = 0;
				}
				if (APIEndpoint.Response_Count_for_200__c == null) {
					APIEndpoint.Response_Count_for_200__c = 0;
				}
				if (APIEndpoint.Response_Count_for_400__c == null) {
					APIEndpoint.Response_Count_for_400__c = 0;
				}
				if (APIEndpoint.Response_Count_for_404__c == null) {
					APIEndpoint.Response_Count_for_404__c = 0;
				}
				if (APIEndpoint.Response_Count_for_500__c == null) {
					APIEndpoint.Response_Count_for_500__c = 0;
				}

				APIEndpoint.Request_Count__c++;
				if (statusCode == 200) {
					APIEndpoint.Response_Count_for_200__c++;
				}
				else
						if (statusCode == 400) {
							APIEndpoint.Response_Count_for_400__c++;
						}
						else
								if (statusCode == 404) {
									APIEndpoint.Response_Count_for_404__c++;
								}
								else
										if (statusCode == 500) {
											APIEndpoint.Response_Count_for_500__c++;
										}

				update APIEndpoint;
			}
			//create a record in Error Log
			Error_Log__c log = new Error_Log__c();
			log.End_Point__c = endPoint;
			log.Payload__c = payload;
			log.response__c = response;
			log.Status_Code__c = String.valueOf(statusCode);
			log.User__c = userId;
			log.Error_Type__c = 'Notification - ResetPassword';
			log.Error_Message__c = customerId;
			if(!Test.isRunningTest())
			{
				insert log;
			}

		}
		catch (Exception e) {
			System.Debug(e.getMessage());
		}
	}

	public static String getAPIStatisticsAsJSONByEndpointName(String endpointName) {
		List<APIEndpointStatistics__c> APIEndpointList = new List<APIEndpointStatistics__c>();
		APIEndpointStatistics__c APIEndpoint = new APIEndpointStatistics__c();
		String JSONResponse = '{"status" : "failed", "Reason" : "Endpoint not found."}';
		APIStatisticsResponseWrapper statisticsRecord = new APIStatisticsResponseWrapper();
		try {
			APIEndpointList = [SELECT Uptime__c, Machine_Name__c, Runtime_Version__c, Request_Count__c, Response_Count_for_200__c, Response_Count_for_400__c, Response_Count_for_404__c, Response_Count_for_500__c FROM APIEndpointStatistics__c WHERE Name = :endpointName LIMIT 1];
			System.Debug('Loaded APIEndpointStatistics__c records: ' + APIEndpointList.size());
			if(!APIEndpointList.isEmpty()) {
				APIEndpoint = APIEndpointList[0];
				System.Debug('APIEndpoint: ' + APIEndpoint);
				statisticsRecord.runtimeVersion = '1.0.0';
				statisticsRecord.assemblyName = endpointName;
				statisticsRecord.machineName = 'Salesforce';
				statisticsRecord.uptime = APIEndpoint.Uptime__c;

				statisticsRecord.requestCount = APIEndpoint.Request_Count__c;//Integer.valueOf();
				statisticsRecord.responseCodes = new Map<String, Decimal>();
				statisticsRecord.responseCodes.put('200', APIEndpoint.Response_Count_for_200__c);
				statisticsRecord.responseCodes.put('400', APIEndpoint.Response_Count_for_400__c);
				statisticsRecord.responseCodes.put('404', APIEndpoint.Response_Count_for_404__c);
				statisticsRecord.responseCodes.put('500', APIEndpoint.Response_Count_for_500__c);
				JSONResponse = JSON.serializePretty(statisticsRecord);

			}

		}
		catch (Exception e) {
			System.Debug(e.getMessage());
		}
		return JSONResponse;
	}
	class APIStatisticsResponseWrapper {
		public String runtimeVersion{get;set;}
		public String assemblyName{get;set;}
		public String machineName{get;set;}
		public String uptime{get;set;}
		public Decimal requestCount{get;set;}
		Map<String, Decimal> responseCodes{get;set;}

	}
}