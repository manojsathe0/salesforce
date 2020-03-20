public without sharing class MergeFieldParser 
{
    public static String parseMergeFields(String emailBody , Id caseId)
    {
        List<EmailTemplate> emtList = [select name,subject,folderid,body from emailtemplate where folder.name='Variable'];
        if(!emtList.isEmpty())
        {
            for(EmailTemplate e:emtList)
            {   
                if(e.name!=null && e.body!=null)
                {            
                    emailBody = emailBody.replaceAll('\\{' + '!' + e.name + '\\}',''+e.body);
                }
            }
        }
        
        String sbody = emailBody;
       //Start Merge Field
        Id accId;Id conId;
        //Case
        String queryCase = 'SELECT ';
        Map<String, Schema.SobjectField> cas = Schema.SobjectType.Case.fields.getMap();
        for (String s : cas.keySet())
        {
            if(s != 'Id') queryCase += s + ', ';
        }
        queryCase += ' Id FROM Case Where Id = '+'\''+caseId+'\'';
        SObject[] queryObjectCase = Database.query(queryCase);
        
        for (SObject record : queryObjectCase)
        { 
            for (String s : cas.keySet())
            {
                if(s == 'AccountId')
                {
                    if(record.get(s) != null)
                    accId = (Id)record.get(s);
                }
                if(s == 'ContactId')
                {
                    if(record.get(s) != null)
                        conId = (Id)record.get(s);
                }
                Object fieldValue = record.get(s); 
                sbody = sbody.replaceAll('(?i)'+'\\{'+'!Case.'+s+'\\}',fieldValue == null?'':String.valueOf(fieldValue));
             }
         }
        //Account
        if(accId != null)
        {
            String queryAcc = 'SELECT ';
            Map<String, Schema.SobjectField> acc = Schema.SobjectType.Account.fields.getMap();
            for (String s : acc.keySet())
            {
                if(s != 'Id') queryAcc += s + ', ';
            }
            SObject[] queryObjectAccount;
            if(accId != null)
            {
             queryAcc += ' Id FROM Account Where Id = '+'\''+accId+'\'';
             queryObjectAccount = Database.query(queryAcc);
            }
            for (SObject record : queryObjectAccount)
            { 
            for (String s : acc.keySet())
            {
                    Object fieldValue = record.get(s); 
                    sbody = sbody.replaceAll('(?i)'+'\\{'+'!Account.'+s+'\\}',fieldValue == null?'':String.valueOf(fieldValue));
             }
            }
        }
        //Contact
        if(conId != null)
        {
            String queryContact = 'SELECT ';
            Map<String, Schema.SobjectField> con = Schema.SobjectType.Contact.fields.getMap();
            for (String s : con.keySet()) 
            {
                if(s != 'Id') queryContact += s + ', ';
            }
            SObject[] queryObjectContact;
            if(conId != null)
            {
                queryContact += ' Id FROM Contact Where Id = '+'\''+conId+'\'';
                queryObjectContact = Database.query(queryContact);
            }
            for (SObject record : queryObjectContact)
            { 
                for (String s : con.keySet())
                {
                        Object fieldValue = record.get(s); 
                        sbody = sbody.replaceAll('(?i)'+'\\{'+'!Contact.'+s+'\\}',fieldValue == null?'':String.valueOf(fieldValue));
                }
            }
        }
        //User
        String queryUser = 'SELECT ';
        Map<String, Schema.SobjectField> us = Schema.SobjectType.User.fields.getMap();
        for (String s : us.keySet())
        {
            if(s != 'Id') queryUser += s + ', ';
        }
        queryUser += ' Id FROM User Where Id = '+'\''+UserInfo.getUserId() +'\'';
        SObject[] queryObject  = Database.query(queryUser);
        String address = '';
        for (SObject record : queryObject)
        { 
            for (String s : us.keySet())
                
            {
                    Object fieldValue = record.get(s); 
                    if(s == 'street' && fieldValue != null)
                      address += fieldValue+' ';
                    if(s == 'state' && fieldValue != null)
                      address += fieldValue+' ';
                    if(s == 'city' && fieldValue != null)
                      address += fieldValue+' ';
                    if(s == 'postalcode' && fieldValue != null)
                      address += fieldValue+' ';
                                      
                    sbody = sbody.replaceAll('(?i)'+'\\{'+'!User.'+s+'\\}',fieldValue == null?'':String.valueOf(fieldValue));
            }
        
        }
         sbody = sbody.replaceAll('(?i)'+'\\{'+'!User.Address\\}',address == ''?'':address);
        
        //End Merge Field
        
            return sbody;
    }   

}