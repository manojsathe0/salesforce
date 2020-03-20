public interface IADIServiceClassFactory
{
    void clearMessages();
    void initEndpoints(List<String> endpoints);
    void initWrapper(String endpointLabel, String callBackMethod);
    Object makeRequest(String calloutURL, String endpointLabel, String payload);
    void initHTTPResponse(String endpointLabel);
    Map<String, APIRequestResponseWrapper> getAPItoWrapper();
    List<IADMessage> getIadMessages();
    IADContractBeans.IADInstallmentsWrapper getInstallments();
    Integer getErrorCount();
    //only used for dynamic invokation
    Object getInstallmentByInstallmentId(String installmentId);
    void populateInstallment();
    Object getInstallmentsByOrderId(String orderId);
    void populateInstallments();
    Object putInstallmentByInstallmentId(String body, String installmentId);
    void populateInstallmentUpdateReponse();
    void populateSuccessMessage(String theSuccess);
    void populateErrorMessage(String theException);

    void addMessages(List<IADMessage> messages, Integer count);
}