@isTest(seeAllData=true)
public class IADApiGeeIntegrationWorker_ltngTest 
{
    @isTest static void testGetToken()
    {
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getApigeeTokenResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADApiGeeIntegrationWorker_ltng.getApiGeeToken();
        IADHelper helper = new IADHelper();
        IADHelper.saveAccessToken('1234');
        IADHelper.saveAccessToken('1234');
        IADHelper.getAppIdToAppURL();
        
        APIRequestResponseWrapper_ltng wrapper = new APIRequestResponseWrapper_ltng();
        
        wrapper.statusCode = '200';
        wrapper.checkIsValidResponse();
        
        IADContractBeans.FaultError fe = new IADContractBeans.FaultError();
        fe.fault = new IADContractBeans.APIFault();
        fe.fault.faultString = 'test';
        wrapper.responseData = JSON.serialize(fe);
        wrapper.statusCode = '401';
        wrapper.checkIsValidResponse();
        
        
        IADContractBeans.ErrorResponse eResponse = new IADContractBeans.ErrorResponse();
        eResponse.errors = new List<IADContractBeans.Errors>();
        IADContractBeans.Errors error = new IADContractBeans.Errors();
        error.message = 'test';
        error.code = '401';
        eResponse.errors.add(error);
        wrapper.responseData = JSON.serialize(eResponse);
        wrapper.statusCode = '401';
        wrapper.checkIsValidResponse();
        
        IADApiGeeEndPoint__mdt endPointConfig = [select label, Request_Type__c, link__c ,Is_Async__c from IADApiGeeEndPoint__mdt where label ='PutContactInfoByCustomerAndContactId'];
        wrapper.endPointConfig = endPointConfig;
        
        wrapper.requestLabelContinuation = 'test';
        wrapper.isAsync = true;
        wrapper.callBackMethod = 'test';
        wrapper.theToken = 'test';
        
        List<Object> resultObjects = new List<Object> ();
        wrapper.resultObjects = resultObjects;
        HTTPResponse theResponse = new HTTPResponse();
        wrapper.theResponse = theResponse;
        IADApiGeeIntegrationWorker_ltng intworkObject = new IADApiGeeIntegrationWorker_ltng();
        try{
            intworkObject.callApiGee(wrapper);
        }
        catch(Exception e){
        }
        /*
        IADRefundController theController = new IADRefundController();

        theController.balanceService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
        theController.paymentsService.APItoAsync.put(IADPendingPaymentsService.GETPAYMENTSBYORDERID, true);
        theController.profileService.APItoAsync.put(IADPaymentProfilesService.GETPROFILESBYUSERID, true);
        Continuation conti = (continuation)theController.startRequestsInParallel();
        try{
            IADApiGeeIntegrationWorker_ltng.callApiGeeAsync(conti,wrapper);
        }
        catch(Exception e){
        } */
    }
    @isTest static void testGetTokenFailure()
    {
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getApigeeTokenResponseFailure();
        mock.statusCode=401;
        Test.setMock(HttpCalloutMock.class, mock);
        try{
            IADApiGeeIntegrationWorker_ltng.getApiGeeToken();
        }
        catch(Exception e){
        }
    }


    @isTest static void testgetApiGeeTokenDNC()
    {
        IADApiGeeIntegrationWorker_ltng.getApiGeeTokenDNC();
    }
    
    @isTest static void testgetApiGeeTokenDNC2()
    {
        IADApiGeeIntegrationWorker_ltng.mapCurrentToken.put(System.Now(), 'accesstoken');
        IADApiGeeIntegrationWorker_ltng.getApiGeeTokenDNC();
    }
}