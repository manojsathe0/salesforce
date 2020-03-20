/*
Contract Bean class to be used primarily within DDSWebService
Corresponds to the body of JSON request that comes to this API.
Created by: Artyom M.
@Updated By: Sai
Per story: B-24116
*/
public class POR_DDSContractBeans {
    public class ExceptionBean {
        public String caseId {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String uuid {get; set;}
        public String correlationId {get; set;}
        public String email {get; set;}
        public String customerId {get; set;}
        public String phone {get; set;}
        public String orderNumber {get; set;}
        public String processingNumber {get; set;}
        public String customerLogin {get; set;}
        public Datetime exceptionDateTime {get; set;}

        //@Sai - B-35645, Adding SOS properties to the Payload
        public BusinessProcessFailure einFailure;
        public BusinessProcessFailure stateFailure;
        public List<FailedRules> failedBusinessRules {get; set;}
        public List<FailedRules> failedValidationRules {get; set;}
    }
    
    public class BusinessProcessFailure {
    	public String name;
        public String description;
        public String failureDate;
    }
/*
    public class EINFailure {
        public String name;
        public String description;
        public String failureDate;
    }

    public class StateFilingFailure {
        public String name;
        public String description;
        public String failureDate;
    }
*/
    public class FailedRules {
        public String name {get; set;}
        public String description {get; set;}

    }
    public class ResponseBean {
        public String orderNumber {get; set;}
        public String status {get; set;}
        public String description {get; set;}
    }

    public class InBinDateUpdateBean {
        public String orderNumber {get; set;}
        public String inBinDate {get; set;}
        public Boolean expedite {get; set;}
    }

    public class OrderComplete {
        public String requestedBy;
        public String processingOrderId;
        public String revisionType;
    }
    public class  UpdateProcessingBean {
        public String orderNumber;
        public String processingStatus;
    }
}