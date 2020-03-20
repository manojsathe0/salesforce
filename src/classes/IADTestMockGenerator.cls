@isTest
global class IADTestMockGenerator implements HttpCalloutMock
{
    public string testBody{get;set;}
    public integer statusCode{get;set;}
    public IADTestMockGenerator() {
        
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200); 
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        if(testBody != null)
        {
             res.setBody(testBody);
             res.setStatusCode(statusCode);
        }
        else
        {
            /*if(req.getEndpoint().contains('core/billing/payments/orders/'))
            {
               
                //String apiResponse = [SELECT id , API_Response__c FROM APIMock_Data__c WHERE API_Name__c = 'getPaymentsByOrderId'][0].API_Response__c;
                String apiResponse = IADTestDataUtil.getPaymentsByOrderIdResponse(1);
                res.setBody(apiResponse);
            }
            */
            if(req.getEndpoint().contains('customers/password'))
            {
                String apiResponse = IADTestDataUtil.postResetPasswordResponse();
                res.setBody(apiResponse);
            }
            /*
            if(req.getEndpoint().contains('billing/profiles/'))
            {
                String apiResponse = IADTestDataUtil.postNewPaymentResponse();
                res.setBody(apiResponse);
                res.setStatusCode(201); 
            }
            */
            if(req.getEndpoint().contains('/history'))
            {
                String apiResponse = IADTestDataUtil.getCustomerHistoryResponse(5);
                res.setBody(apiResponse);
            }
            
            if(req.getEndpoint().contains('/contacts/'))
            {
                String apiResponse = IADTestDataUtil.updateContactResponse();
                res.setBody(apiResponse);
            }
        }
        
        

        return res;
    }

   
}