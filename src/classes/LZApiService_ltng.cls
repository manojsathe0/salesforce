public with sharing class LZApiService_ltng 
{
    final static String ALGORITHM_NAME = 'hmacSHA256';
    public static String userid;
    public static String usercontactinfoid;
    public static String theType;//1 for primary,3 for authorized
    public static String firstname;
    public static String lastname;
    public static String address1;
    public static String address2;
    public static String city;
    public static String state;
    public static String zip;
    public static String email1;
    public static String cellphone;
    public static String homephone;
    public static String workphone;
    public static String active;
    public static String type;
    public static String isActive;
    public static String thePostData;    
    
    
    public static String CONTACT_ENDPOINT
    {
        get
        {
            if(CONTACT_ENDPOINT == null)
            {
                External_Endpoint__c theEndPoint = ExternalEndpointService_ltng.getEndpointCustomSetting();
                if(theEndPoint != null)
                {
                    CONTACT_ENDPOINT = theEndPoint.Api_Endpoint_URL__c; 
                    system.debug(CONTACT_ENDPOINT);
                }
            }
            
            return CONTACT_ENDPOINT;
        }
        set;
    }
    
    public static String SECRET_KEY
    {
        get
        {
            if(SECRET_KEY == null)
            {
                External_Endpoint__c theEndPoint = ExternalEndpointService_ltng.getEndpointCustomSetting();
                if(theEndPoint != null)
                {
                    SECRET_KEY = theEndPoint.Secret_key__c;    
                    system.debug(SECRET_KEY);
                }
            }
            
            return SECRET_KEY;
        }
        set;
    }
    
    public static String ACCESS_KEY
    {
        get
        {
            if(ACCESS_KEY == null)
            {
                External_Endpoint__c theEndPoint = ExternalEndpointService_ltng.getEndpointCustomSetting();
                if(theEndPoint != null)
                {
                    ACCESS_KEY = theEndPoint.Access_Key__c; 
                    system.debug(ACCESS_KEY);
                }
            }
            
            return ACCESS_KEY;
        }
        set;
    }
    
    public static String getEncodedValue(String theValue)
    {
        system.debug(theValue + 'before encode');
        if(theValue != null && theValue != ''){
            return EncodingUtil.urlEncode(theValue , 'UTF-8');
        }
        else{
            return null;
        }
    }
    
    public static ContactApiResponse_ltng callLzAPIContactService(Contact theContact, String operation, string fkUser)
    {
        system.debug('contact: '+theContact);
        system.debug('operation: '+operation);
        system.debug('fkUser: '+fkUser);
        if(theContact.Contact_Type__c == 'Primary Contact'){
            type = '1';
        }
        
        if(theContact.Contact_Type__c == 'Authorized Contact'){
            type = '3';
        }
        
        if(theContact.Inactive__c == true){
            isActive = '0';
        }
        else{
            isActive = '1';
        }
        
        DateTime currentTime = DateTime.now().addMinutes(10);
        Long dateTimeWithOffset = ((currentTime.getTime())/1000);
        
        theType  = type;//1 for primary,3 for authorized
        if(theContact.firstname != null){
            firstname=  theContact.firstName;
        }
        
        if(theContact.lastname != null){
            lastname=  theContact.lastName;
        }
        else{
            lastname = null;
        }
        if(theContact.MailingStreet != null){
            address1 =  theContact.MailingStreet;
        }
        
        if(theContact.Address_2__c != null){    
            address2 =  theContact.Address_2__c;
        }
        
        if(theContact.MailingCity != null){   
            city =  theContact.MailingCity;
        }
        
        if(theContact.MailingState != null){
            state =  theContact.MailingState;
        }
        
        if(theContact.MailingPostalCode != null){    
            zip =  theContact.MailingPostalCode;    
        }
        if(theContact.Email != null){     
            email1 =  theContact.Email;
        }
        
        if(theContact.MobilePhone != null){     
            cellphone =  theContact.MobilePhone;
        }
        
        if(theContact.HomePhone != null){     
            homephone =  theContact.HomePhone;
        }
        
        if(theContact.OtherPhone != null){     
            workphone =  theContact.OtherPhone;
        }
        
        active =  isActive;
        
        HttpRequest req = new HttpRequest();
        if(operation == 'Update')
        {
            if(theContact.LegalZoom_Contact_ID__c != null){
                usercontactinfoid=  theContact.LegalZoom_Contact_ID__c;
            }
            
            if(theContact.FkUser__c != null){
                userid = theContact.FkUser__c;
            }
            
            thePostData = 'usercontactinfoid='+usercontactinfoid+'&userid='+userid+'&firstname='+firstName+
                '&lastname='+lastname+'&address1='+address1+'&address2='+address2+'&city='+city+'&state='+state+
                '&zip='+zip+'&email1='+email1+'&cellphone='+cellphone+'&homephone='+homephone+
                '&workphone='+workphone+'&type='+theType+'&active='+active+'&expires='+dateTimeWithOffset;
            
            CONTACT_ENDPOINT = CONTACT_ENDPOINT + operation;
        }
        else
        {
            userid = fkUser;
            thePostData = 'userid='+userid+'&firstname='+firstName+
                '&lastname='+lastname+'&address1='+address1+'&address2='+address2+'&city='+city+'&state='+state+
                '&zip='+zip+'&email1='+email1+'&cellphone='+cellphone+'&homephone='+homephone+
                '&workphone='+workphone+'&type='+theType+'&active='+active+'&expires='+dateTimeWithOffset;
            CONTACT_ENDPOINT =CONTACT_ENDPOINT + operation;
        }
        system.debug('POST DATA: '+thePostData);
        system.debug('Algorithm Name: '+ALGORITHM_NAME);
        system.debug('SECRET_KEY: '+SECRET_KEY);
        String lowerCasePostData = thePostData.toLowerCase();
        Blob mac = Crypto.generateMac(ALGORITHM_NAME,  Blob.valueOf(lowerCasePostData), Blob.valueOf(SECRET_KEY));
        String theSignature = EncodingUtil.convertToHex(mac);
        system.debug(CONTACT_ENDPOINT);
        req.setEndpoint(CONTACT_ENDPOINT);
        
        if(operation == 'Update')
        {
            req.setBody('usercontactinfoid='+getEncodedValue(usercontactinfoid)+
                        '&userid='+getEncodedValue(userid)+
                        '&firstname='+getEncodedValue(firstname)+
                        '&lastname='+getEncodedValue(lastname)+
                        '&address1='+getEncodedValue(address1)+
                        '&address2='+getEncodedValue(address2)+
                        '&city='+getEncodedValue(city)+
                        '&state='+getEncodedValue(state)+
                        '&zip='+getEncodedValue(zip)+
                        '&email1='+getEncodedValue(email1)+
                        '&cellphone='+getEncodedValue(cellphone)+
                        '&homephone='+getEncodedValue(homephone)+
                        '&workphone='+getEncodedValue(workphone)+
                        '&type='+getEncodedValue(theType)+
                        '&active='+getEncodedValue(active)+
                        '&expires='+dateTimeWithOffset+
                        '&signature='+theSignature+
                        '&accessKey='+ACCESS_KEY);
        }
        else
        {
            req.setBody('userid='+getEncodedValue(userid)+
                        '&firstname='+getEncodedValue(firstname)+
                        '&lastname='+getEncodedValue(lastname)+
                        '&address1='+getEncodedValue(address1)+
                        '&address2='+getEncodedValue(address2)+
                        '&city='+getEncodedValue(city)+
                        '&state='+getEncodedValue(state)+
                        '&zip='+getEncodedValue(zip)+
                        '&email1='+getEncodedValue(email1)+
                        '&cellphone='+getEncodedValue(cellphone)+
                        '&homephone='+getEncodedValue(homephone)+
                        '&workphone='+getEncodedValue(workphone)+
                        '&type='+getEncodedValue(theType)+
                        '&active='+getEncodedValue(active)+
                        '&expires='+dateTimeWithOffset+
                        '&signature='+theSignature+
                        '&accessKey='+ACCESS_KEY);
        }
        System.debug('HOHO '+req.getBody());
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        Http http = new Http();
        try
        {
            HttpResponse res;
            if(!Test.isRunningTest()){
                res = http.send(req);
            }
            else{
                if(operation == 'create'){
                	res = MockHttpResponseGenerator.createContact(req);
                }
           		else{
                	res = MockHttpResponseGenerator.updateContact(req);
                }                
            }
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode());
            System.debug('BODY: '+res.getBody());
            return (ContactApiResponse_ltng)JSON.deserialize(res.getBody(), ContactApiResponse_ltng.class);
        } 
        catch(System.CalloutException e)
        {
            System.debug('ERROR: '+ e);
            ContactApiResponse_ltng response = new ContactApiResponse_ltng();
            response.message = string.valueOf(e);
            return response;
        }
    }   
}