@isTest(SeeAllData=true)
public  class Email_CcBcc_Controller_Test {
static testMethod void myUnitTestCOLLEAGUE(){ 
     PageReference pageRef = Page.Email_CCBCC_Page;
	 Test.setCurrentPage(pageRef);
	 Email_CcBcc_Controller controller = new Email_CcBcc_Controller();
	 List<User> contactList = new List<User>([Select Name, Id From User  LIMIT 1]);
	    Account acc = new Account(Name='tet');
	    insert acc;
	    Contact con = new Contact(Phone='1234', LastName='test',FirstName='test', Email='test@test.com', Alt_Email_2__c ='test@test.com',
	                              Alt_Email_1__c='test@test.com',AccountId=acc.Id);
	    insert con;
	    Case c = new Case(OwnerId = contactList.get(0).id,status = 'New',Origin ='Phone',subject= 'Test Case',AccountId=acc.Id);
        insert c;
        Apexpages.currentPage().getParameters().put('id',c.Id);
        Apexpages.currentPage().getParameters().put('c_type','COLLEAGUE');
        controller.searchR = null;
	    List<Email_CcBcc_Controller.ShowOption> searchR = controller.searchR;
	    List<Email_CcBcc_Controller.ContactDetail> seracgN = controller.searchRN;
 }
 static testMethod void myUnitTestCONTACT_ACC(){ 
     PageReference pageRef = Page.Email_CCBCC_Page;
	 Test.setCurrentPage(pageRef);
	 Email_CcBcc_Controller controller = new Email_CcBcc_Controller();
	 List<User> contactList = new List<User>([Select Name, Id From User  LIMIT 1]);
	    Account acc = new Account(Name='tet');
	    insert acc;
	    Contact con = new Contact(Phone='1234', LastName='test',FirstName='test', Email='test@test.com', Alt_Email_2__c ='test@test.com',
	                              Alt_Email_1__c='test@test.com',AccountId=acc.Id);
	    insert con;
	    Case c = new Case(OwnerId = contactList.get(0).id,status = 'New',Origin ='Phone',subject= 'Test Case',AccountId=acc.Id);
        insert c;
        Apexpages.currentPage().getParameters().put('id',c.Id);
        Apexpages.currentPage().getParameters().put('c_type','CONTACT_ACC');
        controller.searchR = null;
	    List<Email_CcBcc_Controller.ShowOption> searchR = controller.searchR;
	    List<Email_CcBcc_Controller.ContactDetail> seracgN = controller.searchRN;
 }
}