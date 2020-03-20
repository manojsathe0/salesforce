@isTest
public class UserOrderExtensionTest
{
     public static List<Order__c> orders;
     public static List<User_Order_Extension__c> userOrderExtensionToCreateForPackage;
     public static List<User_Order_Extension__c> userOrderExtensionToCreateForSubscriptionUsage;
     public static List<Order_Item__c> orderItemsToCreateForPackage;
     public static List<Order_Item__c> orderItemsToCreateForSubscriptionUsage;
     public static List<User_Order_Extension__c> allUserOrderExtension;
     public static Set<String> lzOrderItemForPackage;
	 public static Set<String> lzOrderItemForSubscriptionUsage;

     public static void setupData()
     {
     	Processing_Status__c cancelledStatus = new Processing_Status__c();
     	cancelledStatus.Name = 'Cancelled';
     	insert cancelledStatus;
     	
     	Processing_Status__c readyStatus = new Processing_Status__c();
     	readyStatus.Name = 'Ready for Download';
     	insert readyStatus;
     	
     	orders = TestUtils.createOrders(200 , null , true);
		
		orderItemsToCreateForPackage = new List<Order_Item__c>();
		orderItemsToCreateForSubscriptionUsage = new List<Order_Item__c>();
		
		Relationship_Type__c packageRelationshipType = TestUtils.createRelationshipTypesTypes(1 , null , false)[0];
		packageRelationshipType.Name = 'Package';
		insert packageRelationshipType;
		
		Relationship_Type__c subscriptionUsageRelationshipType = TestUtils.createRelationshipTypesTypes(2 , null , false)[0];
		subscriptionUsageRelationshipType.Name = 'SubscriptionUsage';
		insert subscriptionUsageRelationshipType;
		
		for(Integer i = 0 ; i<100 ;++i)
		{
			Order_Item__c theItem = TestUtils.createOrderItems(1, orders[i].Id , false)[0];
			theItem.LZ_Order_Item_ID__c = i+'';
			theItem.Relationship_Type__c = packageRelationshipType.Id;
			orderItemsToCreateForPackage.add(theItem);
		}
		
		Integer j = 100;
		for(Integer i = 100 ; i<200 ;++i)
		{
			
			Order_Item__c theItem = TestUtils.createOrderItems(1, orders[j].Id , false)[0];
			theItem.LZ_Order_Item_ID__c = i+'';
			theItem.Relationship_Type__c = subscriptionUsageRelationshipType.Id;
			orderItemsToCreateForSubscriptionUsage.add(theItem);
			++j;
		}
		List<Order_Item__c> allOrderItems = new List<Order_Item__c>();
		allOrderItems.addAll(orderItemsToCreateForPackage);
		allOrderItems.addAll(orderItemsToCreateForSubscriptionUsage);
		
		insert allOrderItems;
		
		
        userOrderExtensionToCreateForPackage = new List<User_Order_Extension__c>();
		
		userOrderExtensionToCreateForSubscriptionUsage = new List<User_Order_Extension__c>();
		allUserOrderExtension = new List<User_Order_Extension__c>();

		lzOrderItemForPackage = new Set<String>();
		lzOrderItemForSubscriptionUsage = new Set<String>();
		for(Integer i = 0 ; i<100 ;++i)
		{
			User_Order_Extension__c theExtension = new User_Order_Extension__c();
			theExtension.LZ_Order_Item_ID__c = i+'';
            theExtension.LZ_User_Order_ID__c=i+'';
			theExtension.Processing_Status__c = cancelledStatus.Id;
			userOrderExtensionToCreateForPackage.add(theExtension);
			lzOrderItemForPackage.add(theExtension.LZ_Order_Item_ID__c);
		}
		for(Integer i = 100 ; i<200 ;++i)
		{
			
			User_Order_Extension__c theExtension = new User_Order_Extension__c();
			theExtension.LZ_Order_Item_ID__c = i+'';
            theExtension.LZ_User_Order_ID__c=i+'';
            theExtension.Processing_Status__c = readyStatus.Id;
			userOrderExtensionToCreateForPackage.add(theExtension);
			lzOrderItemForSubscriptionUsage.add(theExtension.LZ_Order_Item_ID__c);
		}
		
		allUserOrderExtension.addAll(userOrderExtensionToCreateForPackage);
		allUserOrderExtension.addAll(userOrderExtensionToCreateForSubscriptionUsage);
				
     }


     public static testmethod void testUOEPopulatedOnOrderItem_OnInsert(){
     	
     	setupData();
				
		
		Test.startTest();
			insert allUserOrderExtension;
		Test.stopTest();
		
		Map<String,Id> expectedOrderItemNumberToUserExtensionLookUpForPackage = new Map<String,Id>();
		Map<String,Id> expectedOrderItemNumberToUserExtensionLookUpForSubscriptionUsage = new Map<String,Id>();
		
		for(User_Order_Extension__c theExtension : [SELECT Id , LZ_Order_Item_ID__c FROM User_Order_Extension__c WHERE LZ_Order_Item_ID__c IN :lzOrderItemForPackage])
		{
			expectedOrderItemNumberToUserExtensionLookUpForPackage.put(theExtension.LZ_Order_Item_ID__c , theExtension.Id);
		}
		
		for(User_Order_Extension__c theExtension : [SELECT Id , LZ_Order_Item_ID__c FROM User_Order_Extension__c WHERE LZ_Order_Item_ID__c IN :lzOrderItemForSubscriptionUsage])
		{
			expectedOrderItemNumberToUserExtensionLookUpForSubscriptionUsage.put(theExtension.LZ_Order_Item_ID__c , theExtension.Id);
		}
		
		List<Order_Item__c> updatedPackageOrderItems = [SELECT Id , User_Order_Extension__c ,LZ_Order_Item_ID__c,Order__r.User_Order_Extension__c FROM Order_Item__c WHERE Id IN :orderItemsToCreateForPackage];
		System.assertEquals(100 , updatedPackageOrderItems.size() , '100 Order items should have been created');
		for(Order_Item__c theItem : updatedPackageOrderItems)
		{
			Id expectedUserOrderExtensionId = expectedOrderItemNumberToUserExtensionLookUpForPackage.get(theItem.LZ_Order_Item_ID__c);
			System.assertEquals(expectedUserOrderExtensionId , theItem.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order Item');
		}
		
		List<Order_Item__c> updatedSubscriptionUsageOrderItems = [SELECT Id , User_Order_Extension__c ,LZ_Order_Item_ID__c FROM Order_Item__c WHERE Id IN :orderItemsToCreateForSubscriptionUsage];
		System.assertEquals(100 , updatedSubscriptionUsageOrderItems.size() , '100 Order items should have been created');
		for(Order_Item__c theItem : updatedSubscriptionUsageOrderItems)
		{
			Id expectedUserOrderExtensionId = expectedOrderItemNumberToUserExtensionLookUpForSubscriptionUsage.get(theItem.LZ_Order_Item_ID__c);
			System.assertEquals(expectedUserOrderExtensionId , theItem.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order Item');
		}
       
    }

    static testMethod void testUpdateEntityNameOnOrderOnUserOrderExtension_Update()
    {
    	
		setupData();
				
		insert allUserOrderExtension;
        Processing_Status__c cancelledStatus = new Processing_Status__c();
     	cancelledStatus.Name = 'Cancelled';
     	insert cancelledStatus;

		for(User_Order_Extension__c theExtension : allUserOrderExtension)
		{
			theExtension.Entity_Name__c = 'My Entity';
             theExtension.Processing_Status__c = cancelledStatus.id;
		
		}
		
		//Update the User Order Extension
		Test.startTest();
			update allUserOrderExtension;
		Test.stopTest();
	
		
		List<Order__c> updatedOrders = [SELECT Entity_Name__c FROM Order__c WHERE Id IN : orders];
    	System.assertEquals(200 , updatedOrders.size() , 'Correct number of orders should have been returned');
    	for(Order__c theOrder : updatedOrders)
    	{
    		System.assertEquals('My Entity' , theOrder.Entity_Name__c , 'Correct Entity Name should have been populated');
    	}
    }
    
    static testMethod void testUpdateReadyfordownloadonUOE_Update()
    {
    	
		setupData();
				
		insert allUserOrderExtension;
        Processing_Status__c readyStatus = new Processing_Status__c();
     	readyStatus.Name = 'Ready for Download';
     	insert readyStatus;

		for(User_Order_Extension__c theExtension : allUserOrderExtension)
		{
			theExtension.Entity_Name__c = 'My Entity';
             theExtension.Processing_Status__c = readyStatus.id;
		
		}
		
		//Update the User Order Extension
		Test.startTest();
			update allUserOrderExtension;
		Test.stopTest();
	
		
		List<Order__c> updatedOrders = [SELECT Entity_Name__c FROM Order__c WHERE Id IN : orders];
    	System.assertEquals(200 , updatedOrders.size() , 'Correct number of orders should have been returned');
    	for(Order__c theOrder : updatedOrders)
    	{
    		System.assertEquals('My Entity' , theOrder.Entity_Name__c , 'Correct Entity Name should have been populated');
    	}
    }
	

	//@Sai - B-41703
	static testMethod void updateOppStageToClose_Test() {

		Id profileId = [select id from profile where name = 'System Administrator'].Id;
		User newUser = new User(FirstName = 'Integration', LastName = 'User', UserName = 'test54321@test.test', Email = 'test91@legalzoom.com', Alias = 'tester91',
		                        LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', CommunityNickname = 'test91',
		                        ProfileId = profileId, TimeZoneSidKey = 'America/New_York', isActive = true );

		insert newUser;

		Processing_Status__c readyStatus = new Processing_Status__c();
		readyStatus.Name = 'Ready for Download';
		insert readyStatus;

		Processing_Status__c procStatus = new Processing_Status__c();
		procStatus.Name = 'Sent to SOS';
		insert procStatus;

		User_Order_Extension__c theExtension = new User_Order_Extension__c();
		theExtension.LZ_Order_Item_ID__c = '1';
		theExtension.LZ_User_Order_ID__c = '2';
		theExtension.Entity_Name__c = 'My Entity';
		theExtension.Processing_Status__c = readyStatus.id;
		insert theExtension;


		List<Order__c> ordersTestList = TestUtils.createOrders(2 , null , false);
		ordersTestList[0].User_Order_Extension__c = theExtension.Id;
		insert ordersTestList[0];

		List<Opportunity> oppList = TestUtils.createOpportunities(1, 'oppName', false);
		oppList[0].Order__c = ordersTestList[0].Id;
		oppList[0].StageName = 'New';
		oppList[0].Product2__c = 'LLC';
		oppList[0].OnBoarding__c = true;
		system.runas(newUser) {
			insert oppList;
		}

		theExtension.Processing_Status__c = procStatus.id;
		Test.startTest();
		update theExtension;
		Test.stopTest();
	}
}