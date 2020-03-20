/*
	Created by: Artyom M.
	Per story: B-28448
*/
global class OrderExceptionOwnerChangeBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
		List<Group> orderDueQueues = new List<Group>();
		orderDueQueues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Order Due%'];
		System.debug('orderDueQueues size = ' + orderDueQueues.size());
		Set<ID> orderDueQueuesIds = new Set<Id>();
		if (!orderDueQueues.isEmpty()) {
			for (Group grp : orderDueQueues) {
				orderDueQueuesIds.add(grp.Id);
			}
		}
		String query;
		if (!orderDueQueuesIds.isEmpty()) {
			query = 'SELECT ID, Name, Product__c, Due_Date__c, Days_To_Due_Date_Formula__c FROM Order_Exception__c WHERE OwnerId IN :orderDueQueuesIds';
		}
		else {
			query = 'SELECT ID, Product__c, Due_Date__c, Days_To_Due_Date_Formula__c FROM Order_Exception__c WHERE Id = null';
		}
		System.debug('query = ' + query);
		return Database.getQueryLocator(query);
	}
	/*
    global void execute(Database.BatchableContext bc, List<Order_Exception__c> scope) {
    	System.debug('scope size = ' + scope.size());
        Flow.Interview.Assign_Owner_for_DDS_Process assignOwner;
        Map<String, Object> params = new Map<String, Object>();
        
        for (Order_Exception__c excp : scope) {
            params.put('orderIdget', excp.Id);
            assignOwner = new Flow.Interview.Assign_Owner_for_DDS_Process(params);
            assignOwner.start();
        }
  	
    	
    }*/
    global void execute(Database.BatchableContext bc, List<Order_Exception__c> scope) {
    	System.debug('scope size = ' + scope.size());
    	try {
    		List<Group> orderDueQueues = new List<Group>();
			orderDueQueues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Order Due%'];
			System.debug('orderDueQueues size in execute = ' + orderDueQueues.size());
			Map<String, String> queueNameToIdMap = new Map<String, String>();
			if (!orderDueQueues.isEmpty()) {
				for (Group grp : orderDueQueues) {
					queueNameToIdMap.put(grp.Name, grp.Id);
				}		
			}
			System.Debug(queueNameToIdMap);

			
			List<Product_Full_Name_to_Acronym__mdt> productNames = new List<Product_Full_Name_to_Acronym__mdt>();
		    productNames = [SELECT Acronym_Name__c, Full_Name__c FROM Product_Full_Name_to_Acronym__mdt LIMIT 200];
			Map<String, String> productNameMap = new Map<String, String>();
			if (!productNames.isEmpty()) {
				for (Product_Full_Name_to_Acronym__mdt prdct : productNames) {
					productNameMap.put(prdct.Full_Name__c, prdct.Acronym_Name__c);
				}		
			}
			System.Debug(productNameMap);
			
			if (!orderDueQueues.isEmpty()) {
				
				List<Order_Exception__c> exceptionsToUpdate = new List<Order_Exception__c>();
	        
			    for (Order_Exception__c excp : scope) {
			    	if (excp.Due_Date__c != null && String.isNotBlank(excp.Product__c)) {
			    		//Date todayDate = Date.today();
						//Date excpDueDate = excp.Due_Date__c.date();
						Integer daysToDueDate = Integer.valueOf(excp.Days_To_Due_Date_Formula__c);
						String queueNameToFind = '';
						if (productNameMap.get(excp.Product__c) != null) {
							queueNameToFind = productNameMap.get(excp.Product__c) + ' - ';
						}
						queueNameToFind += 'Order Due ';
						if (daysToDueDate <= 1) {
							queueNameToFind += 'Today';
						}
						else
						if (daysToDueDate >= 7) {
							queueNameToFind += '7 Day';
						}
						else {
							queueNameToFind += daysToDueDate + ' Day';
						}
						
						System.Debug('Searching for queue: ' + queueNameToFind);
						if (queueNameToIdMap.get(queueNameToFind) != null) {
							excp.OwnerId = queueNameToIdMap.get(queueNameToFind);
							excp.Days_to_Due_Date__c = daysToDueDate;
							exceptionsToUpdate.add(excp);
						}

						
			    	}
			       	
						
			    }
	  			update exceptionsToUpdate;
			}
		
			
    	}
    	
    	catch(Exception e) {
    		System.Debug(e);
    	}
    }
    
    global void finish(Database.BatchableContext bc) {
    	System.debug('OrderExceptionOwnerChangeBatch is completed!');
    	AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug(job);
            
            if (job.NumberOfErrors > 0) {
            	String errorMessage = 'OrderExceptionOwnerChangeBatch failed with status ' + job.Status;
            	SendExceptionEmail.sendDatabaseBatchExceptionEmail(errorMessage , 'OrderExceptionOwnerChangeBatch');
            }
    }
	
    @InvocableMethod(label='Assign Queues to Order Exceptions' description='Assign Queues to Order Exceptions by passing record refference.')
    public static void orderExceptionQueueAssignmentById(List<Id> exceptionRecords) {
        System.debug('Inside orderExceptionQueueAssignmentById with ' + exceptionRecords);
        List<Order_Exception__c> orderExceptionList = new List<Order_Exception__c>();
        try {
            orderExceptionList = [SELECT ID, Name, Product__c, Due_Date__c, Days_To_Due_Date_Formula__c FROM Order_Exception__c WHERE Id IN :exceptionRecords];
            System.debug(orderExceptionList);
            OrderExceptionOwnerChangeBatch execHelper = new OrderExceptionOwnerChangeBatch();
  		    execHelper.execute(null, orderExceptionList);
        }
        catch (Exception e) {
            System.debug(e);
        }
        
    	
    }
    

}