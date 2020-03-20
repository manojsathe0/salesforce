global class MockHttpResponseGenerator implements HttpCalloutMock {
    global static string CREATED_ACCOUNT_ID = '9999991';
    global static HTTPResponse respond(HTTPRequest req ) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ExistingAccount":0,"AccountCreated":1,"AccountUpdated":0,"UserContactId":9999991,"Message":"Account Created."}');
        res.setStatusCode(200);
        return res;
    }
    
    global static HTTPResponse updateContact(HTTPRequest req ) {
    HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ExistingAccount":0,"AccountCreated":0,"AccountUpdated":1,"UserContactId":0,"Message":"Account Updated."}');
        res.setStatusCode(200);
        return res;
    }
    
    global static HTTPResponse createContact(HTTPRequest req ) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ExistingAccount":0,"AccountCreated":1,"AccountUpdated":0,"UserContactId":9999991,"Message":"Account Created."}');
        res.setStatusCode(200);
        return res;
    }
    
    
}