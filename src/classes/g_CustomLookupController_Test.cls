@isTest

private class g_CustomLookupController_Test {
	static testMethod void searchbyNumber_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
		lookup.startSearching();
		
		Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789');
		insert con1;
		Contact con2 = new Contact(FirstName = 'Pat', LastName = 'Doer', Phone = '(123) 456-7890');
		insert con2;
		Contact con3 = new Contact(FirstName = 'Patty', LastName = 'Ty', Phone = '(234) 567-8901');
		insert con3;
		Contact con4 = new Contact(FirstName = 'Jane', LastName = 'Doer', Phone = '21234567890');
		insert con4;


        Id [] fixedSearchResults= new Id[4];
  		fixedSearchResults[0] = con1.Id;
  		fixedSearchResults[1] = con2.Id;
  		fixedSearchResults[2] = con3.Id;
  		fixedSearchResults[3] = con4.Id;
  		Test.setFixedSearchResults(fixedSearchResults);

		lookup.searchString = '123456789';
		PageReference pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);

		lookup.searchString = '1234567890';
		pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);

		lookup.searchString = '12345678901';
		pr = lookup.search();
		lookup.resultDraw();
		lookup.finalRefresh();
		
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);

		lookup.searchString = '21234567890';
		pr = lookup.searchMore();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);
	}  	
	
	static testMethod void searchbyName_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
		Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333', Email = 'john@gmail.com');
		insert con1;
		Contact con2 = new Contact(FirstName = 'Pat', LastName = 'Doer', Phone = '1111');
		insert con2;
		Contact con3 = new Contact(FirstName = 'Patty', LastName = 'Ty', Phone = '2222');
		insert con3;
		Contact con4 = new Contact(FirstName = 'Jane', LastName = 'Doer', Email = 'test@gmail.com');
		insert con4;

		lookup.searchString = '4444';
		lookup.firstName = 'John';
		lookup.lastName = 'Doer';
		lookup.email = 'john@gmail.com';
		lookup.profile_override = 'Sales';

        Id [] fixedSearchResults= new Id[1];
  		fixedSearchResults[0] = con1.Id;
  		Test.setFixedSearchResults(fixedSearchResults);

		PageReference pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);
	}  	
	static testMethod void searchbyEntity_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
		Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333');
		insert con1;
		Contact con2 = new Contact(FirstName = 'Pat', LastName = 'Doer', Phone = '1111');
		insert con2;
		Contact con3 = new Contact(FirstName = 'Patty', LastName = 'Ty', Phone = '2222');
		insert con3;
		Contact con4 = new Contact(FirstName = 'Jane', LastName = 'Doer', Email = 'test@gmail.com');
		insert con4;
		Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01));
		insert order1;
		Order__c order2 = new Order__c(Name = '1100', Contact__c = con2.Id, State_of_Formation__c = '13', Entity_Name__c = '14', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01));
		insert order2;
		Order_Item__c orderItem1 = new Order_Item__c(Name = '1000', Order__c = order1.Id);
		insert orderItem1;
		Order_Item__c orderItem2 = new Order_Item__c(Name = '1100', Order__c = order2.Id);
		insert orderItem2;
		
		lookup.searchString = '4444';
		lookup.firstName = 'John';
		lookup.lastName = 'Doer';
		lookup.profile_override = 'Sales';
		
		lookup.stateOfFormation='11';
		lookup.entityName='12';

        Id [] fixedSearchResults= new Id[2];
  		fixedSearchResults[0] = order1.Id;
  		fixedSearchResults[1] = con1.Id;
  		
  		Test.setFixedSearchResults(fixedSearchResults);

		PageReference pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);
	}  
	static testMethod void searchbyOrder_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
		Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333');
		insert con1;
		Contact con2 = new Contact(FirstName = 'Pat', LastName = 'Doer', Phone = '1111');
		insert con2;
		Contact con3 = new Contact(FirstName = 'Patty', LastName = 'Ty', Phone = '2222');
		insert con3;
		Contact con4 = new Contact(FirstName = 'Jane', LastName = 'Doer', Email = 'test@gmail.com');
		insert con4;
		Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01));
		insert order1;
		Order__c order2 = new Order__c(Name = '1100', Contact__c = con2.Id, Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01));
		insert order2;
		Order_Item__c orderItem1 = new Order_Item__c(Name = '1000', Order__c = order1.Id);
		insert orderItem1;
		Order_Item__c orderItem2 = new Order_Item__c(Name = '1100', Order__c = order2.Id);
		insert orderItem2;
		
		lookup.searchString = '4444';
		lookup.firstName = 'John';
		lookup.lastName = 'Doer';
		lookup.profile_override = 'Sales';
		
		lookup.orderNumber='1000';
//		lookup.processingNumber='1100';
		
        Id [] fixedSearchResults= new Id[2];
        fixedSearchResults[0] = con1.Id;
  		fixedSearchResults[1] = order1.Id;
  		Test.setFixedSearchResults(fixedSearchResults);
		
		PageReference pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);
	}
	static testMethod void searchbyId_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
		Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333');
		insert con1;
	
		lookup.searchString = '4444';
		lookup.firstName = 'Pat';
		lookup.lastName = 'Ty';
		lookup.email = '@';
		lookup.profile_override = 'Sales';
		
		Contact cResult = lookup.findContactById(con1.Id,'');
		System.assert(cResult != null);
	}
	static testMethod void searchbyProcessingNumber_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
		Id [] fixedSearchResults= new Id[4];	
		Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333');
		insert con1;
		fixedSearchResults[0] = con1.id;
		Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01));
		insert order1;
		fixedSearchResults[1] = order1.id;
		Order_Item__c orderItem1 = new Order_Item__c(Name = '1000', Order__c = order1.Id, User_Order_ID__c='10');
		insert orderItem1;
		fixedSearchResults[2] = orderItem1.id;
	
	
		lookup.searchString = '4444';
		lookup.firstName = 'John';
		lookup.lastName = 'Doer';
		lookup.processingNumber = '10';
		lookup.profile_override = 'CC';
		
  		Test.setFixedSearchResults(fixedSearchResults);
		
		PageReference pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);
	}
	static testMethod void searchbyCase_Test() {
		g_CustomLookupController lookup = new g_CustomLookupController();
        Id [] fixedSearchResults= new Id[22];	
        Integer currentI=0;	

		Contact con3 = new Contact(FirstName = 'Patty', LastName = 'Ty', Phone = '2222');
		insert con3;
		fixedSearchResults[currentI++] = con3.Id;
		Contact con4 = new Contact(FirstName = 'Jane', LastName = 'Doer', Email = 'test@gmail.com');
		insert con4;
		fixedSearchResults[currentI++] = con4.Id;
		
		for(Integer i=0; i<20; i++)
		{
			Case newCase = new Case(Contact = con3);
			insert newCase;
			System.debug('*** CaseNumber Created:' + newCase.CaseNumber);			
			fixedSearchResults[currentI++] = newCase.Id;
		}

		lookup.searchString = '2222';
		lookup.firstName = 'Patty';
		lookup.lastName = 'Ty';
		lookup.profile_override = 'Sales';
		lookup.caseNumber='1';

  		Test.setFixedSearchResults(fixedSearchResults);
		
		PageReference pr = lookup.search();
		System.debug('*** results = ' + lookup.contactGroupings);
		System.assert(lookup.contactGroupings.size() != 0);
	}		  	
}