/*
Contract Bean class to be used primarily within DDSWebService
Corresponds to the body of JSON request that comes to this API.
Created by: Artyom M.
Per story: B-24116
*/
public class DDSContractBeans {
	public class CaseBean {
		public String caseId{get;set;}
		public String firstName{get;set;}
        public String lastName{get;set;}
        public String uuid{get;set;}
        public String email{get;set;}
        public String customerId{get;set;}
        public String phone{get;set;}
        public String orderNumber{get;set;}
        public String processingNumber{get;set;}
        public String customerLogin{get;set;}
        public List<ValidatedRules> validatedRules{get;set;}
        
	}
    
    public class ValidatedRules {
    	public String description{get;set;}
    }
    
}