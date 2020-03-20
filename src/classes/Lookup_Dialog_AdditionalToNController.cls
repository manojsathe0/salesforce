public with sharing class Lookup_Dialog_AdditionalToNController {

public String relateToList{           
get{               
return   ApexPages.currentPage().getParameters().get('relateToList');           
}           
private set;       
}

public String textData;

public String getTextData()
{
  return textData;
}

public void setTextData(String newTD)
{
   textData=newTD;
}

public List<Contact> searchR
{
   get {
   return [select id,email,firstname,lastname from contact where firstname like : '%'+textData+'%'];
   }
   set;   
}

public List<Contact> searchRN
{
   get {
   return [select id,email,firstname,lastname from contact];
   }
   set;   
}

public List<Case> searchRrelateTo
{
   get {
       List<Case> tmp=new List<Case>();    
       
           tmp = [select casenumber from case where casenumber like : '%'+textData+'%'];
       
       return tmp;       
   }
   set;   
}
}