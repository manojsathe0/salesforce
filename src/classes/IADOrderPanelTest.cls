@isTest

private class IADOrderPanelTest {
    static testMethod void getOrders() {



        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con1;
        List<Order__c> ordersToInsert = new List<Order__c>();

        Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        ordersToInsert.add(order1);
        Order__c order2 = new Order__c(Name = '1100', Contact__c = con1.Id, State_of_Formation__c = '13', Entity_Name__c = '14', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01), User_Order_ID__c='123');
        ordersToInsert.add(order2);
        Order__c order3 = new Order__c(Name = '1200', Contact__c = con1.Id, State_of_Formation__c = '13', Entity_Name__c = '14', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 10, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01), User_Order_ID__c='1234');
        ordersToInsert.add(order3);
        insert ordersToInsert;

        List<Order_Item__c> oiToInsert = new List<Order_Item__c>();

        Order_Item__c orderItem1 = new Order_Item__c(Name = '1000', Order__c = order1.Id);
        oiToInsert.add(orderItem1);

        Order_Item__c orderItem2 = new Order_Item__c(Name = '1100', Order__c = order2.Id);
        oiToInsert.add(orderItem2);

        insert oiToInsert;

        
        PageReference pageRef = Page.IADOrdersPanelPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', con1.Id);
      
        IADOrderPanelController cntrl = new IADOrderPanelController();

        for(IADOrderPanelController.OrderWrapper o : cntrl.orderWrappers)
        {
            System.assertEquals(o.theOrder.Contact__c, con1.Id);
        }
        

    }   
    
    
}