@isTest
public class EmailInsertedUpdatedProductTest {
    public final static String TO_ADDRESS = 'Product Email Alert';
    public final static String TARGET_OBJECT_ID = [SELECT ID FROM User WHERE User.Name = 'Nattachet Tepupatum'][0].Id;
    static testMethod void testSent(){
        createEmail(); 
        List<Product2> productToInsertList = new List<Product2>();
        Relationship_Type__c relationship = new Relationship_Type__c();
        relationship.Name = 'AddOn';
        relationship.Active__c = true;
        relationship.Relationship_Type_ID__c = '3';
        insert relationship;
        
        Product2 productToInsert = TestUtils.createProducts(1,'TEST_PRODUCT', false)[0];
        productToInsert.Relationship_Type__c = relationship.Id;
        productToInsertList.add(productToInsert);
        insert productToInsertList;
        Test.startTest();   
            Integer emailBefore = Limits.getEmailInvocations();
            List<Product2> updatedProduct = EmailInsertedUpdatedProduct.getUpdatedProduct();
            EmailInsertedUpdatedProduct.sendMail();
            try{
                system.assertEquals(productToInsertList.size(),updatedProduct.size());
                system.assertNotEquals(emailBefore,Limits.getEmailInvocations());
            }catch(Exception e){
                System.debug(e);
            }
            
        Test.stopTest();
    }
    
    static testMethod void testNotSent(){
        createEmail(); 
        List<Product2> productToInsert = TestUtils.createProducts(0,'TEST_PRODUCT', true);
        Test.startTest();   
            Integer emailBefore = Limits.getEmailInvocations();
            List<Product2> updatedProduct = EmailInsertedUpdatedProduct.getUpdatedProduct();
            EmailInsertedUpdatedProduct.sendMail();
            try{
                system.assertEquals(productToInsert.size(),updatedProduct.size());
                system.assertEquals(emailBefore,Limits.getEmailInvocations());
            }catch(Exception e){
                System.debug(e);
            }
            
        Test.stopTest();
    }
    
    static testMethod void testBulkSent(){
        createEmail(); 
        Relationship_Type__c relationship = new Relationship_Type__c();
        relationship.Name = 'AddOn';
        relationship.Active__c = true;
        relationship.Relationship_Type_ID__c = '3';
        insert relationship;
        
        List<Product2> productsToCreate = new List<Product2>();
        for(Integer i = 0 ;i<200 ;++i)
        {
            Product2 theProduct = new Product2();
            theProduct.Name = 'TEST_PRODUCT' + i;
            theProduct.LZ_Product_ID__c = i;
            theProduct.Relationship_Type__c = relationship.Id;
            productsToCreate.add(theProduct);
        }
        insert productsToCreate;
        
        Test.startTest();   
            Integer emailBefore = Limits.getEmailInvocations();
            List<Product2> updatedProduct = EmailInsertedUpdatedProduct.getUpdatedProduct();
            EmailInsertedUpdatedProduct.sendMail();
            try{
                system.assertEquals(productsToCreate.size(),updatedProduct.size());
                system.assertNotEquals(emailBefore,Limits.getEmailInvocations());
            }catch(Exception e){
                System.debug(e);
            }
            
        Test.stopTest();
    }
    
    static testMethod void testRunAs(){
        User u = TestUtils.ADMIN_USER;
        createEmail();
        Relationship_Type__c relationship = new Relationship_Type__c();
        relationship.Name = 'AddOn';
        relationship.Active__c = true;
        relationship.Relationship_Type_ID__c = '3';
        insert relationship;
        List<Product2> productToInsertList = new List<Product2>();
        Product2 productToInsert = TestUtils.createProducts(1,'TEST_PRODUCT', false)[0];
        productToInsert.Relationship_Type__c = relationship.Id;
        productToInsertList.add(productToInsert);
        insert productToInsertList;
        
        Test.startTest();
        System.runAs(u){
            Integer emailBefore = Limits.getEmailInvocations();
            List<Product2> updatedProduct = EmailInsertedUpdatedProduct.getUpdatedProduct();
            EmailInsertedUpdatedProduct.sendMail();
            try{
                system.assertEquals(productToInsertList.size(),updatedProduct.size());
                system.assertNotEquals(emailBefore,Limits.getEmailInvocations());
            }catch(Exception e){
                System.debug(e);
            }
        }   
        Test.stopTest();
    }
    
    static void createEmail(){
        Product_Email_Alert__c mail = new Product_Email_Alert__c(Name=TO_ADDRESS,   
                                                                 email__c='ntepupatum@legalzoom.com',
                                                                 targetObjectId__c=TARGET_OBJECT_ID);
        insert mail;
    }
   
}