public class DocumentReviewRequestBeans {
    public class DocumentReviewInboundRequest {
    	public String requestBy{get;set;}
    	public Integer processId{get;set;}
    	public Integer productProcessingId{get;set;}
    	public Integer referenceId{get;set;}
    	public Integer stateId{get;set;}
    }
    public class DocumentReviewRequestResponse {
    	public String status{get;set;}
    	public String caseNumber{get;set;}
    	public String description{get;set;}
    }
}