public class APIRequestResponseWrapper
{
    public String requestLabelContinuation{get;set;}
    public List<Object> resultObjects{get;set;}
    public Boolean isAsync{get;set;}
    public String requestType{get;set;}
    public String callBackMethod{get;set;}
    public transient HTTPResponse theResponse{get;set;}
    public transient String responseData{get;set;}
    public String statusCode{get;set;}
    public String errorMessage{get;set;}
    public String theToken{get;set;}
    public Boolean isNewToken{get;set;}
    public String payload{get;set;}
    public String callURL{get;set;}
    public Map<String, String> objectTypeToId{get;set;}
    public final static string CUSTOMER = 'Customer';
    public final static string ORDER = 'Order';
    public final static string ORDERITEM = 'OrderItem';
    public final static string CONTACT = 'Contact';

    public APIRequestResponseWrapper()
    {
        isNewToken = false;
        objectTypeToId = new Map<String, String>();
    }

    public Boolean checkIsValidResponse()
    {
        Boolean isValidResponse = false;
       
        if(this.statusCode == '200' || this.statusCode == '201' || this.statusCode == '204')
        {
            isValidResponse = true;
        }
        else if(this.statusCode.startsWith('4') || this.statusCode.startsWith('5'))
        {
            if(this.statusCode == '401' || this.statusCode == '404' || this.statusCode== '503' || this.statusCode== '500' || this.statusCode=='504') //Unauthorized or any other Fault Error from Apigee
            {
                if(responseData == null || responseData == '')
                {
                    errorMessage = ' Blank response from server';
                    return isValidResponse;
                }
                if(responseData.contains('fault'))
                {
                    IADContractBeans.FaultError faultErrorResponse = (IADContractBeans.FaultError) JSON.deserialize(responseData ,IADContractBeans.FaultError.class);
                    errorMessage = faultErrorResponse.fault.faultString + ' Please try again.' ;
                    return isValidResponse;
                }
            }
            IADContractBeans.ErrorResponse deSerializedResponse = (IADContractBeans.ErrorResponse) JSON.deserialize(responseData ,IADContractBeans.ErrorResponse.class);
            errorMessage = '';
            for(IADContractBeans.Errors theError : deSerializedResponse.errors)
            {
                if(theError.message == null || theError.message == '')
                    errorMessage += theError.code;
                else
                    errorMessage += theError.message;
            }
        }
        return isValidResponse;
    }
    public IADApiGeeEndPoint__mdt endPointConfig
    {
        get;
        set
        {

            endPointConfig = value;
            //used to not have to do updates to every controller TODO: should go away in the future
            IADApiGeeEndPoint__mdt config = [select Request_Type__c from IADApiGeeEndPoint__mdt where label =: value.label limit 1];

            if(config != null)
            {
                requestType = config.Request_Type__c;
            }

        }
    }
    public void setInfo(string type, string id)
    {
        if(id == null)
            id = '';
        objectTypeToId.put(type, id);
    }
}