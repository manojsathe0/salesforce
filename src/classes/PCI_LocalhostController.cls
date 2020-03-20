public class PCI_LocalhostController {
    
    public string PCIbaseURL{get; set;}
    public string SFbaseURL{get; set;}

    public PCI_LocalhostController(){
        
         IADApiGeeEndPoint__mdt baseUrl= [Select Id, Link__c from IADApiGeeEndPoint__mdt where label='PCILocalhost' limit 1]; 
         PCIbaseURL=baseUrl.Link__c;
         SFbaseURL=Url.getSalesforceBaseUrl().toExternalForm();
    }
    
    
}