public with sharing class ACRSOrderController {
	 private final Account acct;
	 Set<String> productNames = new Set<String>{'Business Advantage Pro Attorney Consultation','Legal Advantage Plus Attorney Consultation'};
	 public List<Order__c> acrsOrders{get;set;}
	 public ACRSOrderController(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
     	acrsOrders = [SELECT Id , Base_Product__r.Name , Order_Date_Time_Created__c , ACR_Date_Time__c , Legal_Matter__c ,  Fulfillment_Status__c , Name FROM Order__c WHERE Account__c =:acct.Id AND Base_Product__r.Name IN :productNames];
     }
}