trigger OrderExceptionTrigger on Order_Exception__c (before insert , after insert, before update, after update ) {
    
      if (Trigger.isInsert)
    {
        if(Trigger.isAfter)
        {
            
            set<id> orderexceptionids = new set<id>();
          for (Order_Exception__c orderexception : Trigger.new) 
          {
             orderexceptionids.add(orderexception.id) ;
          }
            
           OrderExceptionservice.inbindate(orderexceptionids,false);
        }
        
    }
    
    
        if (Trigger.isUpdate && Trigger.isAfter) {
            OrderExceptionService.checkIfProcessingStatusChanged(Trigger.new, Trigger.oldMap);
            
                
                //Padma @Case closure story B-28019
                set<id> orderExp = new set<id>();
                List<Id> prodreviewOE = new List<Id>();
                
                List<Order_Exception__c> orderExpforDDS = new List<Order_Exception__c>();
                
                for (Order_Exception__c OE : Trigger.new) 
                      {
                        Order_Exception__c  OEold = Trigger.oldMap.get(OE.Id);
                          If(OE.Trigger_Order_due_date__c == true && (OE.Trigger_Order_due_date__c != OEold.Trigger_Order_due_date__c) && !OrderExceptionService.inbinrquested)
                          {
                              orderExp.add(OE.id) ;
                          }
                         //Trigger DDS Reinject process 
                          If((OE.Trigger_DDS_Process__c != OEold.Trigger_DDS_Process__c) && OE.Trigger_DDS_Process__c ==true) 
                          {
                              orderExpforDDS.add(OE);
                          }
                          
                          // Padma @B-25806
                          If((OE.Status__c != OEold.Status__c) && OE.Status__c =='Production Review Complete')
                          {
                              System.debug('oe.sttus__c is '+OE.Status__c);
                              prodreviewOE.add(OE.Id);
                          }
                          // EOC B-25806


                      }
                                
                
                if(orderExp.size()>0)
                {
                    OrderExceptionservice.inbindate(orderExp,true); 
                }
                List<Order_Exception__c> listoed = new list<Order_Exception__c>([SELECT  id ,Processing_Number__c, Order_Number__c, Order_Number__r.Name, Status__c from  Order_Exception__c where Id IN :orderExpforDDS]);
                for( Order_Exception__c  oed :listoed)
                {
                    
                    if(oed.Order_Number__c !=null && oed.Processing_Number__c != null)
                    {
                        system.debug('order Number is '+oed.Order_Number__r.Name);
                        POR_PNInjectionButtonController_Ltng.TriggerDDS(oed.Order_Number__r.Name, oed.Processing_Number__c);
                    }
                    
                }
                //Padma EOC
                
                if(!system.isFuture())
                {
                    OrderExceptionService.checkIfInbinDateModified(Trigger.oldMap , Trigger.newMap);
                }
                set<id> orderexceptionids = new set<id>();
                for (Order_Exception__c orderexception : Trigger.new) 
                {
                    if(orderexception.Status__c!=null&&( orderexception.Status__c=='problem' ||  orderexception.Status__c=='hold'   ||  orderexception.Status__c=='Production Review') && Trigger.oldMap.get(orderexception.id).Status__c!= Trigger.newMap.get(orderexception.id).Status__c)
                        orderexceptionids.add(orderexception.id) ;
                }
               
                //if(orderexceptionids.size()>0 &&( UserInfo.getFirstName()!='Integration' || UserInfo.getFirstName()!='Data2'))
                if(orderexceptionids.size()>0 && ( !UserInfo.getName().containsIgnoreCase('Integration User') || UserInfo.getFirstName() != 'Data2')){ //// excluded all integration users from triggering the order exception service : B-38758
                    OrderExceptionservice.UpdateProcessingStatus(orderexceptionids);
        		}
                If(!prodreviewOE.isEmpty()){
                    System.debug('entered to trigger problemcasecloseupdates');
                     CaseService.problemCaseCloseUpdates(prodreviewOE); // Padma @B-25806
                }

        }
}