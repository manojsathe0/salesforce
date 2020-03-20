@isTest
public class PCI_LocalhostControllerTest {
    
    static testMethod void PCI_LocalhostControllerTest(){
        
        IADApiGeeEndPoint__mdt config = new IADApiGeeEndPoint__mdt();
        config.Link__c='http://localhost:5050/';
        config.Label='PCILocalhost';
        
        PCI_LocalhostController pc= new PCI_LocalhostController();
    }

}