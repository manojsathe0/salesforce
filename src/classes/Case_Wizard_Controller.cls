public with sharing class Case_Wizard_Controller {
 public Flow.Interview.Case_Wizard_Customer_Care CaseWizard{get;set;} 
    public String id{get;set;}
    public String getTheEnd() {
        String theEnd;
        if(CaseWizard != null){
            theEnd = CaseWizard.vEnd;
        }
        return theEnd;
    }
    
    public String getReturnId() {
        if(CaseWizard != null){
            id = CaseWizard.vCase ;
        }
        return id;
    }
}