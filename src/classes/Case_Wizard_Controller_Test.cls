@isTest
public  class Case_Wizard_Controller_Test {
static testMethod void myUnitTest(){
        PageReference pageRef = Page.Case_Wizard_Page;
        Test.setCurrentPage(pageRef);
        Case_Wizard_Controller controller = new Case_Wizard_Controller();
        controller.id = '123';
        controller.getTheEnd();
        controller.getReturnId();
    }
}