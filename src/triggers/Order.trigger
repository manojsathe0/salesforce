trigger Order on Order__c (after insert , before insert , after update , before update)
{
   
     Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            for(Order__c theOrder : Trigger.new)
            {
                if(theOrder.Contact_Phone__c != null && theOrder.Contact_Phone__c != '')
                {
                    String formattedPhone = PhoneFormatter.formatPhone(theOrder.Contact_Phone__c);
                    theOrder.Contact_Phone__c = formattedPhone;
                } 
            }
            OrderService.populateParentOrderLookUp(Trigger.new);
            OrderService.markFirstRenewalOrder(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
          OrderService.createOnboardingOpportunityForBizOrders(Trigger.New);
            Set<Id> contactIds = new Set<Id>();
             set<id> ordersllc = new set<Id>();
              set<string> processingnumbers = new set<string>();
            Map<id,id> contactidtoorder = new map<id,id>();
            for(Order__c theOrder : Trigger.new)
            {
                if(theOrder.Contact__c != null)
                {
                    contactIds.add(theOrder.Contact__c);
                     contactidtoorder.put(theOrder.Contact__c,theorder.id);
                }
                if(theOrder.Product__c=='LLC'&& Integer.valueof(theOrder.name)>54000000 && theOrder.Base_Product_Name__c!=null&&theOrder.Base_Product_Name__c.containsIgnoreCase('LLC'))
                {
                    
                    ordersllc.add(theOrder.id);
                }
                
                     if(theorder.User_Order_ID__c !=null)
                {
                processingnumbers.add(theorder.User_Order_ID__c);
                
                }
            }
            if(!contactIds.isEmpty())
            {
                List<Contact> primaryContacts = [SELECT Id , Email , Phone , AccountId,FKUser__c FROM Contact WHERE Id IN :contactIds];
                DuplicateChecker.findMatchingLeadsByContacts(primaryContacts);
                
            }
            if(!CampaignLogic.hasCampaignLogicRun)
            {
                CampaignFutureHandler.removeCampaignMembersForPrePurchase(Trigger.newMap.keySet());
                CampaignFutureHandler.removeCampaignMemberForPostPurchaseByOrders(Trigger.new);
            }
            OrderService.countNumberOfOrders(Trigger.new); 
            if((p.Name).containsIgnoreCase('System Admin') && !system.isBatch()){
               // OrderService.CreateOppOnboard(ordersllc);  
              Orderservice.updateonboardfuture(ordersllc ,true);
            }
            
            //OrderService.closeExceptionsAndCasesOnCleanRevisions(Trigger.new);
            orderservice.relateoppstorders(contactids, processingnumbers,contactidtoorder);           
            
        }
    }
    
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            //OrderService.preserveOriginalOrderCreatedDateTime(Trigger.new ,Trigger.oldMap);
            for(Order__c theOrder : Trigger.new)
            {
                if(theOrder.Contact_Phone__c != null && theOrder.Contact_Phone__c != '')
                {
                    String formattedPhone = PhoneFormatter.formatPhone(theOrder.Contact_Phone__c);
                    theOrder.Contact_Phone__c = formattedPhone;
                }
            }
        }
        else
            if(Trigger.isAfter) {
                 set<id> ordersllc = new set<Id>();
                Map<String ,Order__c> processnumbertoorder = new Map<String ,Order__c>();
                OrderService.closeExceptionsAndCasesOnCancellation(Trigger.new ,Trigger.oldMap);
                for(Order__c theOrder : Trigger.new)
                {
                    if(theOrder.Product__c=='LLC'&& theOrder.Base_Product_Name__c!=null&&theOrder.Base_Product_Name__c.containsIgnoreCase('LLC')&& Integer.valueof(theOrder.name)>54000000)
                    {
                        String PCN = theOrder.Parent_User_Order__c!=null? theOrder.Parent_User_Order__c : theOrder.User_Order_ID__c;
                        ordersllc.add(theOrder.id);
                        processnumbertoorder.put(PCN ,theOrder);
                        
                    } 
                    
                }
               
                if((p.Name).containsIgnoreCase('System Admin') && !system.isBatch())
               
                {
                    //OrderService.UpdateOppOnboard(ordersllc,processnumbertoorder);
                     Orderservice.updateonboardfuture(ordersllc ,false);
                }
                
            }
        
    }
}