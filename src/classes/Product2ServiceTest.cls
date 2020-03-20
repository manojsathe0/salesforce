@isTest
private class Product2ServiceTest {

    final static String NAME = 'test';
    final static Integer PRODUCT_SIZE = 50;
    static List<Component_Type__c> testComponentTypes;
    static List<Process__c> testProcesses;
    static List<Product_Line__c> testProductLines;
    static List<Product2> testProducts;
    static Id relationshipTypeId;
    
    public static List<Product2> createProducts (Integer size , String nameValue, Boolean doInsert)
    {
        List<Product2> productsToCreate = new List<Product2>();
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        for(Integer i = 0 ;i<size ;++i)
        {
            Product2 theProduct = new Product2();
            theProduct.Name = nameValue + i;
            theProduct.LZ_Product_ID__c = i;
            theProduct.LZ_Component_Type_ID__c = 0;
            theProduct.LZ_Process_ID__c = 0;
            theProduct.LZ_Product_Line_ID__c = 0;
            theProduct.LZ_Parent_Product_ID__c = i-1;
            theProduct.Relationship_Type__c = relationshipTypeId;
            productsToCreate.add(theProduct);
        }
        
        if(doInsert)
            insert productsToCreate;
        
        return productsToCreate;
    }
    
    static void setupData()
    {
        testProductLines = TestUtils.createProductLines(10, NAME, true);
        testComponentTypes = TestUtils.createComponentTypes(10, NAME, true);
        testProcesses = TestUtils.createProcesses(150, NAME, true);
        testProducts = createProducts(PRODUCT_SIZE, NAME, false);
    }
    
    static testMethod void testMatchingComponentTypeProcessProductLine()
    {
        setupData();

        Test.startTest();
        upsert testProducts;
        Test.stopTest();
        
        List<Product2> updatedProducts = [SELECT Id , Component_Type__c, Process__c, Product_Line__c FROM Product2];
        List<Component_Type__c> componentTypes = [SELECT Id FROM Component_Type__c WHERE Component_Type_ID__c = 0];
        List<Process__c> processes = [SELECT Id FROM Process__c WHERE Process_ID__c = 0];
        List<Product_Line__c> productLines = [SELECT Id FROM Product_Line__c WHERE Product_Line_ID__c = 0];

        System.assertEquals(updatedProducts.size(), PRODUCT_SIZE, 'There should be ' + PRODUCT_SIZE + ' products.');
        System.assertEquals(updatedProducts[0].Component_Type__c, componentTypes[0].Id, '');
        System.assertEquals(updatedProducts[0].Process__c, processes[0].Id, '');
        System.assertEquals(updatedProducts[0].Product_Line__c, productLines[0].Id, '');
    }
    
    static testMethod void testMatchingParentProduct()
    {
        setupData();

        upsert testProducts;
        
        Test.startTest();
        upsert testProducts;
        Test.stopTest();
        
        List<Product2> productsWithParent = [SELECT Id, Parent__c FROM Product2 WHERE Parent__c <> NULL];
        List<Product2> productsWithoutParent = [SELECT Id, Parent__c FROM Product2 WHERE Parent__c = NULL];
        
        Integer productsWithParentCount = PRODUCT_SIZE - 1;
        
        System.assertEquals(productsWithParent.size(), productsWithParentCount, 'There should be ' + productsWithParentCount + ' products.');
        System.assertEquals(productsWithoutParent.size(), 1, 'There should be 1 product.');
    }
}