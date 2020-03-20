public with sharing Class VersionOneAPI
{
    Salesforce_Request__c theRequest;
    public String requestLabel;
    public String theMessage{get;set;}
    public String v1StoryNumber{get;set;} 
  
    public VersionOneAPI(ApexPages.StandardController stdController)
    {
           
       theMessage = '';
       if(!Test.isRunningTest())
           stdController.addFields(new List<String>{'Name','Description__c','V1_Story_Number__c'});
       theRequest  = (Salesforce_Request__c)stdController.getRecord();
             
    }
   
    public Object callVersionOneAsync()
    {
         
         theMessage = '';
         if(theRequest.V1_Story_Number__c != null)
         {
             theMessage = 'Story Already Created! Here is the link '+'https://www9.v1host.com/LegalZoom/story.mvc/Summary?oidToken='+theRequest.V1_Story_Number__c;
             return null;
         }
         Continuation con = new Continuation(40);
         con.continuationMethod='processResponse';
         HttpRequest req = new HttpRequest();
         //BK : 1.fjovDyuqeHNVmPFlH0TLm8gLMRA=
         //SL: 1.3pWQkBvfOcSH/Yu/sMOWdGsdOog=
         String authString = 'Bearer ' + '1.3pWQkBvfOcSH/Yu/sMOWdGsdOog=';
         String reqPayload = '<Asset href="/LegalZoom/rest-1.v1/New/Story">'+
                            '<Attribute name="Name" act="set">'+theRequest.Name+'</Attribute>'+
                             '<Attribute name="Description" act="set">'+theRequest.Description__c+'</Attribute>'+
                            '<Relation name="Scope" act="set">'+
                                '<Asset href="/LegalZoom/rest-1.v1/Data/Scope/1004" idref="Scope:1004" />'+
                            '</Relation>'+
                            '<Relation name="Super" act="set">'+
                                '<Asset href="/LegalZoom/rest-1.v1/Data/Epic/1388" idref="Epic:1388" />'+
                            '</Relation>'+
                            '<Relation name="Team" act="set">'+
                                '<Asset href="/LegalZoom/rest-1.v1/Data/Team/1065" idref="Team:1065" />'+
                            '</Relation>'+
                            '<Relation name="Status" act="set">'+
                                '<Asset href="/LegalZoom/rest-1.v1/Data/StoryStatus/133" idref="StoryStatus:133" />'+
                            '</Relation>'+
                            
                        '</Asset>';
        req.setHeader('Content-Type', 'application/xml');
        req.setBody(reqPayload);
        req.setEndpoint('https://www9.v1host.com/LegalZoom/rest-1.v1/Data/Story');
        req.setHeader('Authorization', authString);
        req.setMethod('POST'); 
        req.setTimeout(12000);
        try
        {            
           this.requestLabel = con.addHttpRequest(req);
        }
        catch(Exception theException)
        {
           
            theMessage = theException.getMessage();
        }    
           
        return con;   
  
    }
       
     public Object processResponse()
     {   
      // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(this.requestLabel);
        Dom.Document doc = response .getBodyDocument();
        Dom.XMLNode asset = doc.getRootElement();
        v1StoryNumber = asset.getAttributeValue ('id',null);
        theRequest.V1_Story_Number__c  = v1StoryNumber;
        update theRequest;
        theMessage = 'Story Created! Here is the link '+'https://www9.v1host.com/LegalZoom/story.mvc/Summary?oidToken='+theRequest.V1_Story_Number__c;
        return null;
    }
      
 }