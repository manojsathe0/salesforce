public class AllAttachmentsController {
    public List<Attachment> ATT {get;set;}
    public List<Attachment> HVCR {get;set;}
    
    public AllAttachmentsController (ApexPages.StandardController stdController) {        
        }
    
     public List<String> getAttLinks() {
        Id caseid = ApexPages.currentPage().getParameters().get('Id');        
        List<String> attLinks = new List<String>();
        String strURL;
        String strResult ;
        //
        // FIRST:  Standard attachments
        //        
        ATT=[SELECT Id, Name FROM Attachment 
             WHERE parentId = :ApexPages.currentPage().getParameters().get('Id')]; 
        integer j = ATT.size();
        
        for(integer i=0; i<j; i++) {                      
            
            strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') 
                + '/servlet/servlet.FileDownload?file='  + ATT[i].Id;    
            strUrl = strUrl + '&fname=' + ATT[i].Name; 
            attLinks.add(strURL);    
            }
        //
        // SECOND:  HVCR Attachments
        //
        HVCR = [SELECT Id, Name FROM Attachment 
            WHERE  ParentID IN (
            SELECT Id FROM HVCR_Email_New__c 
            WHERE Case__c = :ApexPages.currentPage().getParameters().get('Id'))];
        
        j = HVCR.size();
        for(integer i=0; i<j; i++) {                                  
            strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host') 
                + '/servlet/servlet.FileDownload?file=' + HVCR[i].Id
                + '&fname=' + HVCR[i].Name; 
            
            attLinks.add(strURL);    
            }
       
        return attLinks;
        }        
 }