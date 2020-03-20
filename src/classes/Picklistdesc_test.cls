@istest
Public class Picklistdesc_test
{

static testmethod void recordtypestest()
{


PageReference pageRef = Page.PicklistDesc;//Observe how we set the Page here
    Test.setCurrentPage(pageRef);
 ApexPages.currentPage().getParameters().put('recordTypeName', 'Standard_Contact');
 ApexPages.currentPage().getParameters().put('sobjectType', 'contact');
 ApexPages.currentPage().getParameters().put('picklistFieldName', 'Advisory__c');
 Id recordtypeid=[select id from Recordtype where DeveloperName ='Standard_Contact'].id;
 ApexPages.currentPage().getParameters().put('recordTypeId', recordtypeid);
 
    PickListDescController pc = new     PickListDescController();
    Test.starttest();
    
    
     Test.stoptest();
}
static testmethod void recordtypestestnoid()
{


PageReference pageRef = Page.PicklistDesc;//Observe how we set the Page here
    Test.setCurrentPage(pageRef);
 ApexPages.currentPage().getParameters().put('recordTypeName', 'Standard_Contact');
 ApexPages.currentPage().getParameters().put('sobjectType', 'contact');
 ApexPages.currentPage().getParameters().put('picklistFieldName', 'Advisory__c');
 Id recordtypeid=[select id from Recordtype where DeveloperName ='Standard_Contact'].id;
  Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;
 
    PickListDescController pc = new     PickListDescController();
    Test.starttest();
    PicklistDescriber.describe('contact','Standard_Contact','Advisory__c');
    PicklistDescriber.describe('contact',recordtypeid,'Advisory__c');
    PicklistDescriber.describe(con1.id,'Advisory__c');
    
     Test.stoptest();
}

static testmethod void recordtypestestnosobject()
{


PageReference pageRef = Page.PicklistDesc;//Observe how we set the Page here
    Test.setCurrentPage(pageRef);
 ApexPages.currentPage().getParameters().put('recordTypeName', 'Standard_Contact');
 //ApexPages.currentPage().getParameters().put('sobjectType', 'contact');
 ApexPages.currentPage().getParameters().put('picklistFieldName', 'Advisory__c');
 Id recordtypeid=[select id from Recordtype where DeveloperName ='Standard_Contact'].id;
 ApexPages.currentPage().getParameters().put('recordTypeId', recordtypeid);
 Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;
            ApexPages.currentPage().getParameters().put('id', con1.id);
    PickListDescController pc = new     PickListDescController();
    Test.starttest();
    
    
     Test.stoptest();
}


}