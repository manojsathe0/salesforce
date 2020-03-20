trigger CaseTrigger on Case (before insert, before update , after insert , after update){
   
    if(Trigger.isUpdate && Trigger.isBefore)
    {
        List<Case> changedCases = CaseService.getCasesWithQueueChanged(Trigger.old , Trigger.newMap);
        if(!changedCases.isEmpty())
        {
            CaseService.populateCaseOwnerForChangedQueue(changedCases);
            
        }
        CaseService.caseSubjectUpdate(Trigger.new);
        //@Sai - B-40970
        CaseService.updateContactOnCase(Trigger.new);
       
        
    }
    else if (Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            CaseService.populateCaseOwnerForNewIncomingCases(Trigger.new);
            //  @sai - B-40970
            //  Description: Update the OER's Status to and when new case's ManualRuleStatus is Problem
            CaseService.populateStatusOnOER(Trigger.new);
        }
        
    }
    //Padma @B-28019
    if(Trigger.isUpdate && Trigger.isAfter){
        List<Id> csids = new List<Id>();
        for ( Case c : trigger.new){
           
            case oldcase = Trigger.oldMap.get(c.Id); 
            if( c.Status != oldcase.Status && c.Status == 'Closed' && c.Order_Exception__c != null){
                if(c.Processing_Number__c != null && c.Processing_Number__c !=''){
                    csIds.add(c.Id);
                    
                }
            }
        }
        if(!csIds.isEmpty()){
            CaseService.problemCaseCloseUpdates(csIds);
        }
        CaseService.caseClosedCheck(Trigger.new, Trigger.oldMap);
        CaseService.PORClosedByUpdate(Trigger.new, Trigger.oldMap);  
        
    }
}