public class IADLoginAsUserController
{


@AuraEnabled public static string LoginUser(String leadid)
{
 string url;
 List<lead> leads =[select  Email ,CustomerId__c from lead where id =:leadid];
 
 List<Account> Accounts=[select Name,Customer_ID__c from Account   where Name=:leads[0].Email];
 if(leads.size()>0)
 {
   if(leads[0].CustomerId__c!=null)
   
   {
 url= IADHighlightsPanelContactController_ltng.postLoginToken(leads[0].CustomerId__c);
   
   } else if(accounts.size()>0)
   {
   
   url= IADHighlightsPanelContactController_ltng.postLoginToken(Accounts[0].Customer_ID__c);
   
   }
   else
   {
   
   url='The Customer Does not Exist Please use Create Customer to use Login As User';
   }
 
 
 }
return url;
}

@AuraEnabled public static IADContactManagerController_ltng ResetPassword(String leadid)
{
 IADContactManagerController_ltng url;
 List<lead> leads =[select  Email ,CustomerId__c from lead where id =:leadid];
 
 List<Account> Accounts=[select Name,Customer_ID__c from Account   where Name=:leads[0].Email];
 if(leads.size()>0)
 {
    if(accounts.size()>0)
   
   {
  url= IADContactManagerController_ltng.resetPassword(Accounts[0].Name);
   
   } else if(leads[0].Email!=null)
   {
   
  
   url= IADContactManagerController_ltng.resetPassword(leads[0].Email);
   }
   else if(leads[0].Email==null)
   {
    url= IADContactManagerController_ltng.resetPassword(leads[0].Email);
    
   }
  
   
 
 
 }
return url;
}


}