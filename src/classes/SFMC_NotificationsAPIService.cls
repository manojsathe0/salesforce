/************************************************************
	MC Phase 2 functionality.
	Delivering an API endpoint to perform a contact Search in Salesforce and pass the contact infromation further to Marketing Cloud
	Stories: B-27980, B-28913
	Developer: Artyom M.
***************************************************************************
* Change Log
* Modified By                       Date                                    Description
* Haritha Ravuru                  3/7/2019                                #B-39282 Added new method Marketing cloud reset password Trigger Send

*/

public class SFMC_NotificationsAPIService {
	public static SFMC_ContractBeans.MainResponse response;
	public static String jorneyId{get;}
	public static String status{get;set;}
    public static String message{get;set;}
    public static String categoryName{get;set;}
    public static Map<String, String> SFMCResponse{get;set;}
    public static Integer SFMCResponseStatusCode{get;set;}
    public static Boolean contactFound{get;set;}
    public static Boolean accountFound{get;set;}
    public static Boolean matchingRecordFound{get;set;}
    public static Contact contact{get;set;}
    public static Account account{get;set;}
    public static Map<String, String> optionalData{get;set;}
    public static Boolean contactTypePrimary{get;set;}
    public static Boolean contactTypeLogin{get;set;}
    public static Boolean contactTypeOther{get;set;}
    
    public SFMC_NotificationsAPIService() {
    
    	jorneyId = '';
    	status = '';
    	message = '';
    	categoryName = '';
    	contactFound = false;
    	accountFound = false;
    	matchingRecordFound = false;
    	SFMCResponse = new Map<String, String>();
    	contactTypePrimary = false;
    	contactTypeLogin = false;
    	contactTypeOther = false;
    }
    

    public static String getJSONResponse() {
    	response = new SFMC_ContractBeans.MainResponse();
    	response.status = status;
    	response.message = message;
    	response.categoryName = categoryName;
    	response.SFMCResponse = SFMCResponse;
    	String str = JSON.serializePretty(response);
        System.debug('Response: ' + str);
        return str;
    }
    
	public static void getJorneyIdFromCategory(SFMC_ContractBeans.InboundRequest inboundRequest) {
		if (inboundRequest.metaData.categoryName != null) {
			categoryName = inboundRequest.metaData.categoryName;
			List<Marketing_Cloud_Journey_Mapping__mdt> mappingMtdList = new List<Marketing_Cloud_Journey_Mapping__mdt>(); 
			try {
				mappingMtdList = [SELECT Campaign_Name__c, Message_Category__c FROM Marketing_Cloud_Journey_Mapping__mdt WHERE Campaign_Name__c = :categoryName];
				Marketing_Cloud_Journey_Mapping__mdt mappingMtd = new Marketing_Cloud_Journey_Mapping__mdt();
				if(!mappingMtdList.isEmpty()) {
					mappingMtd = mappingMtdList[0];
					jorneyId = mappingMtd.Message_Category__c;
				}
				else {
					status = 'failed';
	            	message = 'No matching record found to the categoryName';
				}
			}
			catch (Exception e) {
				System.Debug(e.getMessage());
	            status = 'failed';
	            message = 'In getJorneyIdFromCategory method: ' + e.getMessage();
			}
			
			
		}
	}
	
	public static void queryAccountByCustumerId(String fkUser) {
		List<Account> accList = new List<Account>();
        System.debug('fkuser ## '+fkUser);
		accList = [SELECT Id, Customer_ID__c, Name,Life_Plan__c FROM Account WHERE Customer_ID__c = :fkUser];
		System.Debug(accList);
		if (!accList.isEmpty()) {
			matchingRecordFound = true;
			accountFound = true;
			account = accList[0];
			System.Debug(account);
		}
		else {
			accountFound = false;
			account = null;
		}
	}
	public static void queryContactByCustumerId(String fkUser) {
		List<Contact> cntList = new List<Contact>();
        System.debug('fkuser ## '+fkUser);
		cntList = [SELECT Id, FkUser__c, Contact_Type__c, Email, FirstName, LastName, Phone, MailingCity, MailingStreet, MailingState, MailingPostalCode,Life_Plan__c FROM Contact WHERE (FkUser__c = :fkUser AND Contact_Type__c = 'Primary Contact') LIMIT 1];
		System.Debug(cntList);
		if (!cntList.isEmpty()) {
			matchingRecordFound = true;
			contactFound = true;
			contact = cntList[0];
			System.Debug(contact);
		}
		else {
			contactFound = false;
			contact = null;
		}

	}

	public static String buildEventsCalloutWrapperAndGetAsJSON() {
		SFMC_ContractBeans.EventsCalloutWrapper calloutWrapper = new SFMC_ContractBeans.EventsCalloutWrapper();
		calloutWrapper.Data = new Map<String, String>();
		calloutWrapper.EventDefinitionKey = jorneyId;
		calloutWrapper.EstablishContactKey = true;

		if (contactTypeOther) {
			System.Debug('Override scenario');
			if (contactFound) {
				System.Debug('Override contact found scenario');
				calloutWrapper.ContactKey = contact.Id;
				calloutWrapper.Data.put('ContactKey', contact.Id);
                calloutWrapper.Data.put('firstName', contact.FirstName);
                calloutWrapper.Data.put('lastName', contact.LastName);
                calloutWrapper.Data.put('phone', contact.Phone);
                calloutWrapper.Data.put('city', contact.MailingCity);
                calloutWrapper.Data.put('state', contact.MailingState);
                calloutWrapper.Data.put('address1', contact.MailingStreet);
                calloutWrapper.Data.put('zip', contact.MailingPostalCode);
                if(optionalData.containsKey('orderType')){
                   if(contact.Life_Plan__c){
                       optionalData.put('orderType','LifePlan');
                   }
                }else{
                    if(contact.Life_Plan__c){
                        optionalData.put('OrderType','LifePlan');
                    }
                }
			}
			else
					if (accountFound) {
						System.Debug('Override account found scenario');
						calloutWrapper.ContactKey = account.Id;
						calloutWrapper.Data.put('ContactKey', account.Id);
                        if(optionalData.containsKey('orderType')){
                            if(account.Life_Plan__c){
                                optionalData.put('orderType','LifePlan');
                            }
                        }else{
                            if(account.Life_Plan__c){
                                optionalData.put('OrderType','LifePlan');
                            }
                        }
					}
					else {
						calloutWrapper.ContactKey = optionalData.containsKey('emailAddress') ? optionalData.get('emailAddress') : optionalData.get('EmailAddress');
						calloutWrapper.Data.put('ContactKey', optionalData.containsKey('emailAddress') ? optionalData.get('emailAddress') : optionalData.get('EmailAddress'));
					}

		}
		else
				if (contactFound) {

					System.Debug('non-override contact found scenario');
    		calloutWrapper.ContactKey = contact.Id;
    		calloutWrapper.Data.put('ContactKey', contact.Id);
    		
    		if (contactTypePrimary) {
    			System.Debug('contactTypePrimary scenario');
    			calloutWrapper.Data.put('emailAddress', contact.Email);
                        if(optionalData.containsKey('orderType')){
                            if(contact.Life_Plan__c){
                                optionalData.put('orderType','LifePlan');
                            }
                        }else{
                            if(contact.Life_Plan__c){
                                optionalData.put('OrderType','LifePlan');
                            }
                        }
					}
					if (contactTypeLogin) {
						System.Debug('contactTypeLogin scenario');
						calloutWrapper.Data.put('emailAddress', account.Name);
                        if(optionalData.containsKey('orderType')){
                            if(account.Life_Plan__c){
                                optionalData.put('orderType','LifePlan');
                            }
                        }else{
                            if(account.Life_Plan__c){
                                optionalData.put('OrderType','LifePlan');
                            }
                        }
					}


					calloutWrapper.Data.put('firstName', contact.FirstName);
					calloutWrapper.Data.put('lastName', contact.LastName);
					calloutWrapper.Data.put('phone', contact.Phone);
					calloutWrapper.Data.put('city', contact.MailingCity);
					calloutWrapper.Data.put('state', contact.MailingState);
					calloutWrapper.Data.put('address1', contact.MailingStreet);
					calloutWrapper.Data.put('zip', contact.MailingPostalCode);

				}
				else {
					System.Debug('non-override account found scenario');
    		calloutWrapper.ContactKey = account.Id;
    		calloutWrapper.Data.put('emailAddress', account.Name);
    		calloutWrapper.Data.put('ContactKey', account.Id);
    	}
        
        calloutWrapper.Data.putAll(optionalData);
    	
    	String str = JSON.serializePretty(calloutWrapper);
        return str;
    	
    	
	}
public static String buildresetPasswordPayloadAndGetAsJSON() {
		SFMC_ContractBeans.ResetPwdInboundRequest resetPasswordWrapper = new SFMC_ContractBeans.ResetPwdInboundRequest();
		SFMC_ContractBeans.MainRequest_To to = new SFMC_ContractBeans.MainRequest_To();
		SFMC_ContractBeans.MainRequest_Options options = new SFMC_ContractBeans.MainRequest_Options();
		SFMC_ContractBeans.MainRequest_To_ContactAttributes conAttributes = new SFMC_ContractBeans.MainRequest_To_ContactAttributes();
		SFMC_ContractBeans.MainRequest_To_ContactAttributes_SubAttributes subAttributes = new SFMC_ContractBeans.MainRequest_To_ContactAttributes_SubAttributes();

		//calloutWrapper.EventDefinitionKey = jorneyId;
		//calloutWrapper.EstablishContactKey = true;
		//resetPasswordWrapper.MainRequest_To.MainRequest_To_ContactAttributes.SFMC_ContractBeans.MainRequest_To_ContactAttributes_SubAttributes.notificationId = jorneyId;
		subAttributes.notificationId = optionalData.get('notificationId');
		subAttributes.orderType = optionalData.containsKey('orderType')?optionalData.get('orderType'):optionalData.get('OrderType');
		subAttributes.passwordLink = optionalData.get('PasswordLink');
		options.requestType = 'SYNC';

		if (contactTypeOther) {
			System.Debug('Override scenario');
			if (contactFound) {
				System.Debug('Override contact found scenario');
				//resetPasswordWrapper.ContactKey = contact.Id;
				to.subscriberKey = contact.Id;
				subAttributes.ContactKey = contact.Id;
				to.Address = optionalData.get('EmailAddress');
				subAttributes.emailAddress = optionalData.get('EmailAddress');
				if(optionalData.containsKey('emailAddress') || optionalData.containsKey('EmailAddress')){
					subAttributes.emailAddress = optionalData.containsKey('emailAddress') ? optionalData.get('emailAddress') : optionalData.get('EmailAddress');
				}else if(account != null && account.Name != null) {
					subAttributes.emailAddress = account.Name;
				}
				subAttributes.firstName = contact.FirstName;
				subAttributes.lastName = contact.LastName;
				subAttributes.phone = contact.Phone;
				subAttributes.city = contact.MailingCity;
				subAttributes.state = contact.MailingState;
				subAttributes.address1 = contact.MailingStreet;
				subAttributes.zip = contact.MailingPostalCode;
				subAttributes.notificationId = optionalData.get('notificationId');
                if(contact.Life_Plan__c)
                    subAttributes.orderType = 'LifePlan';
                else
				    subAttributes.orderType = optionalData.containsKey('orderType')?optionalData.get('orderType'):optionalData.get('OrderType');
				subAttributes.passwordLink = optionalData.get('PasswordLink');
			}
			else
					if (accountFound) {
						System.Debug('Override account found scenario');
						//calloutWrapper.ContactKey = account.Id;
						to.subscriberKey = account.Id;
						subAttributes.ContactKey = account.Id;
						to.Address = optionalData.get('EmailAddress');
						if(optionalData.containsKey('emailAddress') || optionalData.containsKey('EmailAddress')){
							subAttributes.emailAddress = optionalData.containsKey('emailAddress') ? optionalData.get('emailAddress') : optionalData.get('EmailAddress');
						}else if(account != null && account.Name != null) {
							subAttributes.emailAddress = account.Name;
						}
						//subAttributes.firstName = contact.FirstName;
						//subAttributes.lastName = contact.LastName;
						//subAttributes.phone = contact.Phone;
						//subAttributes.city = contact.MailingCity;
						//subAttributes.state = contact.MailingState;
						//subAttributes.address1 = contact.MailingStreet;
						//subAttributes.zip = contact.MailingPostalCode;
						subAttributes.notificationId = optionalData.get('notificationId');
                        if(account.Life_Plan__c)
                            subAttributes.orderType = 'LifePlan';
                        else
						    subAttributes.orderType = optionalData.containsKey('orderType')?optionalData.get('orderType'):optionalData.get('OrderType');
						subAttributes.passwordLink = optionalData.get('PasswordLink');
					}
			/*else {
                to.Address = optionalData.get('emailAddress');
                //calloutWrapper.ContactKey = optionalData.get('emailAddress');
                subAttributes.emailAddress = optionalData.get('emailAddress');
            }*/

		}
		else
				if (contactFound) {

					System.Debug('non-override contact found scenario');
					//calloutWrapper.ContactKey = contact.Id;
					//calloutWrapper.Data.put('ContactKey', contact.Id);
					to.subscriberKey = contact.Id;
					subAttributes.ContactKey = contact.Id;

					if (contactTypePrimary) {
						System.Debug('contactTypePrimary scenario');
						to.Address = contact.Email;
						subAttributes.emailAddress = contact.Email;
					}
					if (contactTypeLogin) {
						System.Debug('contactTypeLogin scenario');
						to.Address = account.Name;
						subAttributes.emailAddress = account.Name;
					}


					subAttributes.firstName = contact.FirstName;
					subAttributes.lastName = contact.LastName;
					subAttributes.phone = contact.Phone;
					subAttributes.city = contact.MailingCity;
					subAttributes.state = contact.MailingState;
					subAttributes.address1 = contact.MailingStreet;
					subAttributes.zip = contact.MailingPostalCode;
					subAttributes.notificationId = optionalData.get('notificationId');
                    if(contact.Life_Plan__c)
                        subAttributes.orderType = 'LifePlan';
                    else
					subAttributes.orderType = optionalData.containsKey('orderType')?optionalData.get('orderType'):optionalData.get('OrderType');
					subAttributes.passwordLink = optionalData.get('PasswordLink');
				}
				else {
					System.Debug('non-override account found scenario');
					subAttributes.ContactKey = account.Id;
					subAttributes.emailAddress = account.Name;
					to.Address = account.Name;
					to.subscriberKey = account.Id;
                    if(account.Life_Plan__c)
                        subAttributes.orderType = 'LifePlan';
                    else
                        subAttributes.orderType = optionalData.containsKey('orderType')?optionalData.get('orderType'):optionalData.get('OrderType');
				}
				
		conAttributes.subscriberAttributes = subAttributes;
		to.contactAttributes = conAttributes;
		//resetPasswordWrapper.to.contactAttributes = conAttributes;
		resetPasswordWrapper.to = to;
		resetPasswordWrapper.options = options;
		String str = JSON.serializePretty(resetPasswordWrapper);
		return str;


	}


}