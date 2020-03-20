@istest
Private class Dnc_test
{


static testmethod void testleaddncnophone()
{

 List<Lead> testLeads;
     testLeads = TestUtils.createLeads(5 , 'Johnson', false);
    insert testLeads;
        Test.startTest();
            
    
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(testleads[0].id, null, null);
        Test.stopTest();
    
}
    static testmethod void testcontactdnc()
{
     Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',	MobilePhone='123456789',otherphone='123456789');
		insert con1;
 
        Test.startTest();
     
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(con1.id, 'test', 'test');
        Test.stopTest();
    
}
        static testmethod void testcontactdncnophone()
{
     Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer');
		insert con1;
 
        Test.startTest();
     
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(con1.id, 'test', 'test');
        Test.stopTest();
    
}
static testmethod void testleaddnc()
{

 List<Lead> testLeads;
     testLeads = TestUtils.createLeads(5 , 'Johnson', false);
    testleads[0].phone='123456789';
    insert testLeads;
   
        Test.startTest();
            
    
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(testleads[0].id, null, null);
        Test.stopTest();
    
}
static testmethod void testleadcheckinternal()
{

 List<Lead> testLeads;
     testLeads = TestUtils.createLeads(5 , 'Johnson', false);
    insert testLeads;
        Test.startTest();
            
    
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.checkdncinternal(testleads[0].id);
        Test.stopTest();
    
}
        static testmethod void testcontactdncfuture()
{
     Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',	MobilePhone='123456789',otherphone='123456789');
		insert con1;
 
        Test.startTest();
     
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(con1.id, null, null);
        Test.stopTest();
    
}
        static testmethod void testcontactdncnotvalidresponse()
{
     Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',	MobilePhone='123456789',otherphone='123456789');
		insert con1;
 
        Test.startTest();
     
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  '';
      mock.statusCode=500;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(con1.id, 'test', 'test');
        Test.stopTest();
    
}
           static testmethod void testcontactdncfuturenotvalid()
{
     Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',	MobilePhone='123456789',otherphone='123456789');
		insert con1;
 
        Test.startTest();
     
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody = '';
      mock.statusCode=500;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(con1.id, null, null);
        Test.stopTest();
    
}
   static testmethod void testleadfuturenotvalid()
{
     Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',  MobilePhone='123456789',otherphone='123456789');
    insert con1;
  List<Lead> testLeads;
     testLeads = TestUtils.createLeads(5 , 'Johnson', false);
    insert testLeads;
    Lead newlead =new lead();
    newlead.FirstName='test';
    newlead.LastName='dhchjd';
    newlead.Phone='7047249550';
    newlead.Company='test';
    insert newlead;
        Test.startTest();
     
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody = '';
      mock.statusCode=500;
       
         Test.setMock(HttpCalloutMock.class, mock);
       
    DNCController_ltng.PostDncIntetnal(newlead.id, 'test', 'test');
        Test.stopTest();
}
    
}