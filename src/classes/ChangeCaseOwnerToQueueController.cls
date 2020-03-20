public with sharing class ChangeCaseOwnerToQueueController
{
    ApexPages.StandardSetController setCon;
    public Boolean isResetAssignedUser{get;set;}
    Public String filterid;
    public ChangeCaseOwnerToQueueController(ApexPages.StandardSetController controller) {
        filterid=controller.getfilterid();
         filterid= String.valueOf(filterid).substring(0, 15);
        setCon = controller;
        isResetAssignedUser = false;
    }
    
    public PageReference Save()
    { 
     List<Case> selectedRecords = (List<Case>)setCon.getSelected();
    //system.debug('selectedRecords beforeloop' + selectedRecords);
     if(isResetAssignedUser)
     {
         
         system.debug('selectedRecords insidecondition' + selectedRecords);
         for(Case theCase : selectedRecords)
         {
             theCase.Assigned_User__c = null;
         }
         system.debug('selectedRecords afterloop' + selectedRecords);
         
     }
     update selectedRecords;
     //system.debug('selectedRecords aftercondition' + selectedRecords);
     
     return new PageReference('/' + Case.sObjectType.getDescribe().getKeyPrefix()+'?fcf='+filterid);
    }
    
    public Pagereference Save1()
    {
        List<Case> selectedRecords;
        selectedRecords = (List<Case>)setCon.getSelected();
        update selectedRecords;
        return new PageReference('/' + Case.sObjectType.getDescribe().getKeyPrefix()+'?fcf='+filterid);
    }
    public Pagereference Cancel()
    {
        return new PageReference('/' + Case.sObjectType.getDescribe().getKeyPrefix()+'?fcf='+filterid);
        
    }
}