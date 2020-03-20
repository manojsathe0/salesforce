/*Author : Padma S
 * Story : @B-22215 Kollaborate
 * Date  : 3/22/2018
 * Description: This is a test class for IADOrderStatusController
 */

@isTest
public class IADOrderStatusControllerTest {
     static Contact con1;
    static Order__c order1;
    
    public static void setupData() 
    {
        con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con1;
        
        order1 = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order1;
    }
    
  
    static testMethod void IADorderStatusController1TEST(){
       
        
         //IADApiGeeEndPoint__mdt cmdt = [select label, Request_Type__c, link__c ,Is_Async__c from IADApiGeeEndPoint__mdt where label ='GetStatusPlan'];
         IADTestMockGenerator mock = new IADTestMockGenerator();    
        mock.testBody =IADTestDataUtil.getOrdersResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
       Map<string, Object> responseobj= IADOrderStatuscontroller.IADorderStatuscontroller1('123');
        
        
    }

}