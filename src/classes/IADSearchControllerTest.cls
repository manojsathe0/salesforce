@isTest
public class IADSearchControllerTest {
    static testMethod void searchbyNumber_Test() {
		List<String> params = new List<String>();
		for (Integer i = 0; i < 9; i++) {
			params.add('21234567890');
		}
		Id fakeId = null;
		IADSearchController srch = new IADSearchController();
		IADSearchController.doSOSLSearch(params);
		IADSearchController.performSearch(params);
		IADSearchController.getLeadTableFieldsCommaSeparated();

		IADSearchController.getOrderItemsTableFieldsSerialized();
		IADSearchController.getOrderTableFieldsSerialized();
		IADSearchController.getContactTableFieldsSerialized();
		IADSearchController.getCaseTableFieldsSerialized();
		IADSearchController.getLeadTableFieldsSerialized();
		//IADSearchController.findContactById(fakeId, null);
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


		
		IADSearchController.doSOSLSearch(params);
		IADSearchController.performSearch(params);
		IADSearchController.findContactById(con4.id, null);
        IADSearchController.updateObjectById(con4.id, '12345');
        IADSearchController.linkActivityToObjectSelected(con4.id, '12345');
		
		
		
		
	}  	
}