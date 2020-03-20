@isTest
public class IADApiGeeIntegrationWorkerTest 
{
    @isTest static void testGetToken()
    {
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getApigeeTokenResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADApiGeeIntegrationWorker.getApiGeeToken();
        IADHelper helper = new IADHelper();
        IADHelper.saveAccessToken('1234');
        IADHelper.saveAccessToken('1234');
        IADHelper.getAppIdToAppURL();
        
        APIRequestResponseWrapper wrapper = new APIRequestResponseWrapper();
        
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
    }
    @isTest static void testGetTokenFailure()
    {
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getApigeeTokenResponseFailure();
        mock.statusCode=401;
        Test.setMock(HttpCalloutMock.class, mock);
        try{
            IADApiGeeIntegrationWorker.getApiGeeToken();
        }
        catch(Exception e){
        }
    }
}