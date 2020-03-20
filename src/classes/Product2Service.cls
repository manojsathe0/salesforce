public with sharing class Product2Service {

	public static void productMatchLookupValue(List<Product2> productUpsertList)
	{
	    Component_Type__c[] ComponentType = [SELECT Id, Component_Type_ID__c from Component_Type__c];
	    Product2[] Product = [SELECT Id, LZ_Product_ID__c from Product2];
	    Map<Decimal, Id> ProductMap = new Map<Decimal, Id> {}; 
	    Process__c[] Process = [SELECT Id, Process_ID__c from Process__c];
	    Product_Line__c[] ProductLine = [SELECT Id, Product_Line_ID__c from Product_Line__c];
	    
	    for (Product2 prod: Product) {
	        ProductMap.put(prod.LZ_Product_ID__c, prod.Id);
	    }
	   
	    for (Product2 p: productUpsertList) {
	        if (ComponentType.size() > 0) {
	            for (Component_Type__c c: ComponentType) {
	                if (p.LZ_Component_Type_ID__c == c.Component_Type_ID__c) {
	                    p.Component_Type__c = c.Id;
	                    break;
	                }
	            }
	        }
			
			
	        if (ProductMap.containsKey(p.LZ_Parent_Product_ID__c)) {
	            p.Parent__c = ProductMap.get(p.LZ_Parent_Product_ID__c);
	        }
	       
	
	        if (Process.size() > 0) {
	            for (Process__c proc: Process) {
	                if (p.LZ_Process_ID__c == proc.Process_ID__c) {
	                    p.Process__c = proc.Id;
	                    break;
	                }
	            }
	        }
	        if (ProductLine.size() > 0) {
	            for (Product_Line__c pl: ProductLine) {
	                if (p.LZ_Product_Line_ID__c == pl.Product_Line_ID__c) {
	                    p.Product_Line__c = pl.Id;
	                    break;
	                }
	            }
	        }
	    }
    }
}