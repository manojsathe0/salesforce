@isTest
public  class DNCContractBeansTest_ltng {
    
    static testmethod void dncrequestandresponse(){
      Test.startTest();
      
        DNCContractBeans_ltng.DNCaddNumber dncnumber = new DNCContractBeans_ltng.DNCaddNumber();
        dncnumber.PhoneNumber=null;
        
        DNCContractBeans_ltng.test();
        
       
        Test.stoptest();
    }

}