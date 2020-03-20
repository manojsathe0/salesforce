public with sharing class CampaignEngineHelper {
    public CampaignEngineHelper() {
        
    }
    public static Set<String> multiPicklistFields = new Set<String>();
    public static Map<Id,Lead> getQueriedLeads(List<Lead> newLeads)
    {
        String leadIds='';
        for(Lead theLead : newLeads)
        {
            leadIds+='\''+theLead.Id+'\',';
        }

        if(leadIds != '')
            leadIds = '('+leadIds.substring(0 , leadIds.length()-1)+')';

        String leadQuery = 'SELECT ';
        Map<String, Schema.SobjectField> leadFields = Schema.SobjectType.Lead.fields.getMap();
        for (String s : leadFields.keySet())
        {
            if(leadFields.get(s).getDescribe().getType() == Schema.DisplayType.MultiPicklist)             
                multiPicklistFields.add(s);

            if(s != 'Id') leadQuery += s + ', ';
        }
        leadQuery += ' Id FROM Lead Where Id IN '+leadIds;
        System.debug('Lead Query :'+leadQuery);
        List<SObject> theLeads = Database.query(leadQuery);
        return new Map<Id,Lead>((List<Lead>)theLeads);
       
    }

    public static Map<Id,Contact> getQueriedContacts(List<Contact> contacts)
    {
    
        String contactIds='';
        for(Contact theContact : contacts)
        {
            contactIds+='\''+theContact.Id+'\',';
        }

        if(contactIds != '')
            contactIds = '('+contactIds.substring(0 , contactIds.length()-1)+')';

        /*
        String contactQuery = 'SELECT ';
        Map<String, Schema.SobjectField> contactFields = Schema.SobjectType.Contact.fields.getMap();
        for (String s : contactFields.keySet())
        {
          
            if(contactFields.get(s).getDescribe().getType() == Schema.DisplayType.MultiPicklist)             
                multiPicklistFields.add(s);
            if(s != 'Id') contactQuery += s + ', ';
          
        }
        

        contactQuery += ' Id FROM Contact Where Id IN '+contactIds;
        */
        List<SObject> theContacts = new List<SObject>();
        if(contactIds != '')
        {
            String contactQuery = 'SELECT Id , name, HomePhone, phone , LastModifiedDate, Contact_Status__c ,LeadSource,LastModifiedById,Last_Sales_Activity__c FROM Contact WHERE Id IN '+contactIds;
            System.debug('Contact Query '+contactQuery);
            theContacts = Database.query(contactQuery);
            
        }
        return new Map<Id,Contact>((List<Contact>)theContacts); 
    }
    

    public static Map<Id,Order__c> getQueriedOrders(List<Order__c> orders)
    {
    
        String orderIds='';

        for(Order__c theOrder : orders)
        {
            orderIds+='\''+theOrder.Id+'\',';
        }

        if(orderIds != '')
            orderIds = '('+orderIds.substring(0 , orderIds.length()-1)+')';

        String orderQuery = 'SELECT ';
        Map<String, Schema.SobjectField> orderFields = Schema.SobjectType.Order__c.fields.getMap();
        for (String s : orderFields.keySet())
        {
            if(orderFields.get(s).getDescribe().getType() == Schema.DisplayType.MultiPicklist)             
                multiPicklistFields.add(s);
            if(s != 'Id') orderQuery += s + ', ';
        }
        String orderItemQuery = ', ( SELECT ';
        Map<String, Schema.SobjectField> orderItemFields = Schema.SobjectType.Order_Item__c.fields.getMap();
        for (String s : orderItemFields.keySet())
        {
            if(s != 'Id') orderItemQuery += s + ', ';
        }
        orderItemQuery += ' Id '+' FROM Order_Items__r)';

        orderQuery += ' Id '+orderItemQuery+' FROM Order__c Where Id IN '+orderIds;
        
        System.debug('HOHO '+orderQuery);
        List<SObject> theOrders = Database.query(orderQuery);

        return new Map<Id,Order__c>((List<Order__c>)theOrders);
        
    }
    public static Map<Id,Task> getQueriedActivities(List<Task> newTasks)
    {
        String taskIds='';
        for(Task theTask : newTasks)
        {
            taskIds+='\''+theTask.Id+'\',';
        }

        if(taskIds != '')
            taskIds = '('+taskIds.substring(0 , taskIds.length()-1)+')';

        String taskQuery = 'SELECT ';
        Map<String, Schema.SobjectField> taskFields = Schema.SobjectType.Task.fields.getMap();
        for (String s : taskFields.keySet())
        {
            if(taskFields.get(s).getDescribe().getType() == Schema.DisplayType.MultiPicklist)             
                multiPicklistFields.add(s);

            if(s != 'Id') taskQuery += s + ', ';
        }
        taskQuery += ' Id FROM Task Where Id IN '+taskIds;
        System.debug('Task Query :'+taskQuery);
        List<SObject> theTasks = Database.query(taskQuery);
        return new Map<Id,Task>((List<Task>)theTasks);
       
    }
}