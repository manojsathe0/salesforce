public interface IADISubServiceClassFactory
{
    void clearMessages();
    void initEndpoints(List<String> endpoints);
    void initWrapper(String endpointLabel, String callBackMethod);
    Object makeRequest(String calloutURL, String endpointLabel, String payload);
    void initHTTPResponse(String endpointLabel);
    Map<String, APIRequestResponseWrapper> getAPItoWrapper();
    List<IADMessage> getIadMessages();
    Integer getErrorCount();
    IADContractBeans.IADSubscriptionBean getSubscriptions();
    //only used for dynamic invokation

    void populateSuccessMessage(String theSuccess);
    void populateErrorMessage(String theException);
    Object getSubscriptionsyByOrderId(String orderId);
    void populateSubscription();
    Object getSubscriptionBySubscriptionId(String subscriptionId);
    void populateSubscriptionBySubcriptionId();
    Object putSubscriptionBySubscriptionId(String subscriptionId, Integer renew, Integer profileId);
    void populatePutSubscriptionBySubcriptionId();
    void addMessages(List<IADMessage> messages, Integer count);
}