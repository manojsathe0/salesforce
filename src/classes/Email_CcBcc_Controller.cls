public with sharing class Email_CcBcc_Controller {
public class ContactDetail{
    public  String email{get;set;}
    public  String name{get;set;}
}
public class ShowOption{
    public  String value{get;set;}
    public  String text{get;set;}
    public  String selected{get;set;}
}
public List<ShowOption> searchR 
{
   get {
     if(searchR == null){
        String c_type = ApexPages.currentPage().getParameters().get('c_type');
        Id id = ApexPages.currentPage().getParameters().get('id');
    List<Account> nn =null;
    List<Contact> cc=null; 
    String acc = '';
    List<Case> ct = [Select AccountId From Case where Id =:id];
    for(Case c :ct){
             nn = [Select Name From Account where Id =:c.AccountId];
            for(Account g :nn){
                acc = g.Name;
            }
            system.debug(c.AccountId);
            if(c.AccountId != null)
            cc = [Select Name, LastName, Id, FirstName, Email From Contact where AccountId =:c.AccountId];
        }
        List<ShowOption> con = new List<ShowOption>();
    if(c_type == 'COLLEAGUE' || c_type == null){
            ShowOption temp = new ShowOption();
            ShowOption temp2 = new ShowOption();
            temp.value = 'COLLEAGUE';
            temp.text = 'All Co-workers in Company';
            temp.selected = 'selected';
            con.add(temp);
         if(acc != ''){
            temp2.value = 'CONTACT_ACC';
            temp2.text = 'Contacts: Account '+acc;
            con.add(temp2);
         }
    }else{ 
            if(c_type == 'CONTACT_ACC'){
            ShowOption temp = new ShowOption();
            ShowOption temp2 = new ShowOption();
            if(acc != ''){
            temp.value = 'CONTACT_ACC';
            temp.text = 'Contacts: Account '+acc;
            con.add(temp); 
            }
            temp2.value = 'COLLEAGUE';
            temp2.text = 'All Co-workers in Company';
            temp2.selected = 'selected';
            con.add(temp2);
            }
    }
    return con;
   }else{
    return searchR;
   }
   }
  public set;   
}
public List<ContactDetail> searchRN
{
   get {
    if(searchRN == null){
    String c_type = ApexPages.currentPage().getParameters().get('c_type');
    Id id = ApexPages.currentPage().getParameters().get('id');
    List<Account> nn =null;
    List<Contact> cc=null; 
    String acc = '';
    List<Case> ct = [Select AccountId From Case where Id =:id];
    for(Case c :ct){
             nn = [Select Name From Account where Id =:c.AccountId];
            for(Account g :nn){
                acc = g.Name;
            }
            if(c.AccountId != null)
            cc = [Select Name, LastName, Id, FirstName, Email From Contact where AccountId =:c.AccountId];
        } 
    List<ContactDetail> con = new List<ContactDetail>();
    if(c_type == 'COLLEAGUE' || c_type == null){
         for(User a :[select email,Name from user where UserPermissionsSupportUser = true AND IsActive = true  order by Name]){
            ContactDetail temp = new ContactDetail();
            temp.email = a.email;
            temp.name = a.name;
            con.add(temp);
         }
    }else{ 
            if(c_type == 'CONTACT_ACC'){
             for(Contact dd :cc){
            ContactDetail temp = new ContactDetail();
            temp.email = dd.email;
            temp.name = dd.name;
            con.add(temp);
         }
            }
    }
    return con;
   }else{
    return searchRN;
    }
   }
  public  set;   
 }
}