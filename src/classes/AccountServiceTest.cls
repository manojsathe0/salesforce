@isTest
public class AccountServiceTest {
    //Padma @@B-25288
    Static testmethod void updatecompanynameTest(){
        //
         List<Account> a = new List<Account>();
         for(integer i=1; i<= 101; i++) {
            a.add( new Account(Name = 'a......'+i+'test@test.com', Life_Plan_Company__c='Lifeplan. '+i) );
        }
        insert a;
        
        Test.startTest();
        List<Account> nonLPacc;
        nonLPacc=[Select Id, name from Account Where Life_Plan_Company__c like '%Lifeplan.'];        
        Test.stopTEST();
        system.assertEquals(nonLPacc.size(), 0);
        
    }

}