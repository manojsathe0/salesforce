public class SFMC_ContractBeans {
	public class TokenRequest {
		public String clientId{get;set;}
		public String clientSecret{get;set;}
	}
	public class TokenResponse {
		public String accessToken{get;set;}
		public Integer expiresIn{get;set;}
	}
	/*
	public class InboundRequest {
		public String contactId{get;set;}
		public String notificationId{get;set;}
		public String notificationCategory{get;set;}
		public String contactType{get;set;}
	}
	*/
	public class InboundRequest {
		public MainRequest_MetaData metaData{get;set;}
		public MainRequest_RD referenceData{get;set;}
		public Map<String,String> optionalData{get;set;}
	}
	//Haritha Added as part of new payload for password reset MC API # B-39282
	public class ResetPwdInboundRequest {
		public MainRequest_To To{get;set;}
		public MainRequest_Options Options{get;set;}
	}
	public class ResetPwdResponse {
		public String requestId;
		public List<ResetPwdResponse_responses> responses;
	}
	public class ResetPwdResponse_responses {
		public String recepientSendId;
		public String hasErrors;
		public List<String> messages;
		public Map<String,String> messageErrors;
	}
	public class MainRequest_To{
		public String Address{get;set;}
		public String SubscriberKey{get;set;}
		public MainRequest_To_ContactAttributes ContactAttributes{get;set;}
	}
	public class MainRequest_Options{
		public String RequestType;
	}
	public class MainRequest_To_ContactAttributes{
		public MainRequest_To_ContactAttributes_SubAttributes SubscriberAttributes{get;set;}
	}
	public class MainRequest_To_ContactAttributes_SubAttributes{
		public String notificationId{get;set;}
		public String OrderType{get;set;}
		public String PasswordLink{get;set;}
		public String zip{get;set;}
		public String address1{get;set;}
		public String state{get;set;}
		public String city{get;set;}
		public String phone{get;set;}
		public String lastName{get;set;}
		public String firstName{get;set;}
		public String emailAddress{get;set;}
		public String ContactKey{get;set;}
	}
	//Haritha End
	public class MainRequest_MetaData {
		public String version{get;set;}
		public String dateCreated{get;set;}
		public String correlationId{get;set;}
		public String notificationId{get;set;}
		public String categoryName{get;set;}

	}

	public class MainRequest_RD {
		public MainRequest_RD_Customer customer{get;set;}
		public MainRequest_RD_Order order{get;set;}
		public MainRequest_RD_Payment payment{get;set;}
		public List<MainRequest_RD_ExternalContent> externalContent{get;set;}

	}

	public class MainRequest_RD_Customer {
		public Integer customerId{get;set;}
		public String contactType{get;set;}
		public Integer contactId{get;set;}
		public String thirdPartyId{get;set;}

	}
	public class MainRequest_RD_Order {
		public Integer orderId{get;set;}
		public Integer processingOrderId{get;set;}
		public Integer processId{get;set;}
		public Integer processingStatusId{get;set;}

	}
	public class MainRequest_RD_Payment {
		public Integer profileId{get;set;}
	}

	public class MainRequest_RD_ExternalContent {
		public String name{get;set;}
		public String uri{get;set;}
		public String contenttype{get;set;}

	}

	public class EventsCalloutWrapper {
		public String ContactKey{get;set;}
		public String EventDefinitionKey{get;set;}
		public Boolean EstablishContactKey{get;set;}
		public Map<String, String> Data{get;set;}
		//public EventsCalloutWrapper_Data Data{get;set;}
	}
	/*
	public class EventsCalloutWrapper_Data {
		public String emailAddress{get;set;}
		public String ContactKey{get;set;}
		public String PASSWORDLINK{get;set;}
		public String ORDER_TYPE{get;set;}
	}
	*/
	public class MainResponse {
		public String status{get;set;}
		public String categoryName{get;set;}
		public String message{get;set;}
		//public String SFMCResponse{get;set;}
		public Map<String,String> SFMCResponse;
	}

	public class GetContactResponse {
		public CustomerInfo customerInfo{get;set;}
		public ContactInfo contactInfo{get;set;}
		public AccountInfo accountInfo{get;set;}
		public SecurityQuestion securityQuestion{get;set;}
		public List<ThirdPartyUserInfo> thirdPartyUserInfo{get;set;}
	}

	public class CustomerInfo {
		public String uuid{get;set;}
		public Integer customerId{get;set;}
		public String loginUsername{get;set;}
	}

	public class ContactInfo {
		public Integer userContactInfoId{get;set;}
		public Integer customerId{get;set;}

		public String description{get;set;}
		public String firstName{get;set;}
		public String lastName{get;set;}
		public String addressLine1{get;set;}
		public String addressLine2{get;set;}
		public String city{get;set;}

		public Integer stateId{get;set;}
		public Integer county{get;set;}

		public String zipcode{get;set;}
		public String email1{get;set;}
		public String email2{get;set;}
		public String email3{get;set;}
		public String homePhone{get;set;}
		public String workPhone{get;set;}
		public String cellPhone{get;set;}
		public String fax{get;set;}

		public Integer country{get;set;}

		public String state{get;set;}

		public Integer taxID{get;set;}



		public String active{get;set;}
		public String statusChanged{get;set;}
		public String statusChangedBy{get;set;}
		public String crmContactId{get;set;}

		public Integer contactInfoType{get;set;}
		public Integer updateSource{get;set;}
		public String stateFullName{get;set;}
		public String abbr{get;set;}

		public Boolean existingContact{get;set;}
		public Boolean contactCreated{get;set;}
		public Boolean contactUpdated{get;set;}

		public String message{get;set;}


	}

	public class AccountInfo {

	}
	public class SecurityQuestion {
		public Integer questionId{get;set;}
		public String question{get;set;}
		public String answer{get;set;}
	}
	public class ThirdPartyUserInfo {
		public Integer userId{get;set;}
		public String thirdPartyId{get;set;}
		public Integer thirdPartyTypeId{get;set;}
		public String createdBy{get;set;}
		public Boolean hasLifePlan{get;set;}
	}
}