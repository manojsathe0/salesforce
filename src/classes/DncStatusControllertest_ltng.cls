@istest
public class DncStatusControllertest_ltng {

    
    static testmethod void checkinternal()
    {
       Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',    MobilePhone='123456789',otherphone='123456789');
        insert con1;
        
        List<Lead> testLeads;
     testLeads = TestUtils.createLeads(5 , 'Johnson', false);
    insert testLeads;
        DncStatusController.checkinternallist(con1.id) ;
         DncStatusController.checkinternallist(testleads[0].id) ;
    }

    static testmethod void order_test()
    {
       Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '123456789' ,HomePhone='123456789',    MobilePhone='123456789',otherphone='123456789');
        insert con1;
        
        Product2 testProduct = TestUtils.createProducts( 1 , '', false)[0];
        testProduct.Name = 'Business Advantage Pro Attorney Consultation';
        Product_Line__c testProductLine = TestUtils.createProductLines(1 , 'Test ProductLine' , false)[0];
        testProductLine.Name = 'Test ProductLine';
        insert testProductLine;
        id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct;
        
        Account testAccount = TestUtils.createAccounts( 1 , 'Test Account ', true)[0];
        List<Order__c> testOrders = TestUtils.createOrders( 2 , testProduct.Id, false);
        testOrders[0].Account__c = testAccount.Id;
        testOrders[1].Account__c = testAccount.Id;
        
        insert testOrders;
        
        DncStatusController.checkinternallist(testOrders[0].id) ;
    }
}