@isTest
public  class Test_Redirect_Controller_Test {
static testMethod void myUnitTest(){
        PageReference pageRef = Page.TestRedirect;
        Test.setCurrentPage(pageRef);
        Test_Redirect_Controller controller = new Test_Redirect_Controller();
        controller.go();
  } 
}