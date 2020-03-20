@isTest
public with sharing class VersionOneAPITest
{

    static testMethod void testCallVersionOneAsync()
    {
        Salesforce_Request__c theSFRequest = new Salesforce_Request__c();
        theSFRequest.Desired_Completion_Date__c = Date.today();
        insert theSFRequest;
        ApexPages.StandardController sc = new ApexPages.StandardController(theSFRequest);
               
        PageReference pageRef = Page.VersionOne;
        pageRef.getParameters().put('id', String.valueOf(theSFRequest.Id));
        Test.setCurrentPage(pageRef);
        
        VersionOneAPI controller = new VersionOneAPI(sc);
        Continuation conti = (Continuation)controller.callVersionOneAsync();
        //Verify that the continuation has the proper requests
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1 , 'Size should be 1');
        system.assert(requests.get(controller.requestLabel) != null);
        
        // Perform mock callout 
        // (i.e. skip the callout and call the callback method)
        HttpResponse response = new HttpResponse();
        response.setBody('<Asset href="/LegalZoom/rest-1.v1/Data/Story/103309/322121" id="Story:103309:322121"></Asset>');   
        // Set the fake response for the continuation     
        Test.setContinuationResponse(controller.requestLabel, response);
        // Invoke callback method
        Object result = Test.invokeContinuationMethod(controller, conti);
        // result is the return value of the callback
        System.assertEquals(null, result , 'Result should have been null');
        // Verify that the controller's result variable
        // is set to the mock response.
        System.assertEquals('Story:103309:322121' , controller.v1StoryNumber , 'Right Story number should have been populated');
    }
}