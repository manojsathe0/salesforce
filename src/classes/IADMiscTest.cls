@isTest
private class IADMiscTest {
    
    @isTest static void test_method_one() {
        //IADOrderLinksController cntrl = new IADOrderLinksController();
        IADSGVIconStrings ctrl = new IADSGVIconStrings();
        
        IADMessageBoxController ctrl2 = new IADMessageBoxController();
        ctrl2.theMessages = new  List<IADMessage> ();
        
        IADMessage msg = new IADMessage();
        msg = new IADMessage('Error', 'bad error');

        IADMessageFactory factory = new IADMessageFactory();
        IADMessageFactory.clearMessage();
        
        IADConstants consts = new IADConstants();
        
    }
    
    
}