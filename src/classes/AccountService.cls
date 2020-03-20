//Padma @B-25288
public class AccountService {
    //below method is fired when account company name contains lifeplan and removes the lifeplan from the company name.
    public static void updatecompanyname(List<Account> accs){
        for (Account acc: accs){
                  
            string company = acc.Life_Plan_Company__c;               
            string acclower= company.toLowerCase();
            string lp='LifePlan';
            string lplower=lp.toLowerCase();
            system.debug('lplower is'+lplower);
            integer index = acclower.indexOf(lplower);
            system.debug('index is '+index);
            string lpActual;
            
            if (index == -1){
                index=0;
                
            }
            
            lpActual=company.substring(index,index+lplower.length());
            acc.Life_Plan_Company__c = company.replace(lpActual,'');
            acc.Life_Plan_Company__c=acc.Life_Plan_Company__c.replace('.','');
                
        	
            
        }
       
    }

}