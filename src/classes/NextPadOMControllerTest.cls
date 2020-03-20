@isTest
public class NextPadOMControllerTest
{
    static testMethod void testSetParams()
    {
        PageReference pageRef = Page.NextPadOM;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        
        
        ApexPages.currentPage().getParameters().put('processingNumber', '1234');
        NextPadOMController theController = new NextPadOMController();
        theController.forWardRequest();
        
        Test.stopTest();
    }
}