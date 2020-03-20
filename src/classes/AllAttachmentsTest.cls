@isTest
private class  AllAttachmentsTest{

    static testmethod void mytest(){
        List<Case> inquiries = TestUtils.createCases(1 , true);
        if (inquiries.size() > 0) {
            Case inquiry = inquiries[0];
            ApexPages.StandardController controller = new ApexPages.StandardController(inquiry);
            //controller.reset();
            
            AllAttachmentsController  obj = new AllAttachmentsController (controller);
            obj.getAttLinks();
            }
    }
}