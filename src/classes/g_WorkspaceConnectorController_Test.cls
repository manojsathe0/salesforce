@isTest
private class g_WorkspaceConnectorController_Test {

static testMethod void updateActivity_Test() {
        String ID = '';
        Map<String,String> fieldsMap = new Map<String,String>();
        //create map
        fieldsMap.put('Genesys Call Type','Inbound');
        fieldsMap.put('LOOKUP','4444');
        fieldsMap.put('Call Duration','35');
        fieldsMap.put('DATE','June1');
        fieldsMap.put('Comments','');
        fieldsMap.put('ANI','4444');
        fieldsMap.put('IXN Type','Phone');
        fieldsMap.put('Media Type','');
        fieldsMap.put('sfdc Object Id',ID);
        fieldsMap.put('StartDate','2015/06/06 12:12:12');
        fieldsMap.put('EndDate','2015/06/06 12:12:13');

        //Activity created as orhpan
        String newActivityResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(newActivityResult != null);
        fieldsMap.put('Comments','Done');        
        newActivityResult = g_WorkspaceConnectorController.updateActivity(fieldsMap, newActivityResult);
        System.assert(newActivityResult != null);  
        
        //Create Contact test data
        Contact con1 = new Contact(Genesys_Interaction_Id__c = '123123', FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        insert con1;
        Contact myContact = [SELECT Id FROM Contact WHERE Email = 'john.doer@somewhere.com'];
        g_WorkspaceConnectorController.linkActivityToObjectSelected(con1.Id, '123123');  
}

 static testMethod void findOrderFromNumber_Test()
 {
    //error leg
    String result = g_WorkspaceConnectorController.findOrderFromNumber('1', '');
    System.assert(result == 'not found');
     
    //Create Case test data
    Order__c order1 = new Order__c(Name = '1000');
    insert order1;
    result = g_WorkspaceConnectorController.findOrderFromNumber('1', '');
    System.assert(result!=null);
 }
    
 static testMethod void findCaseFromNumber_Test()
 {
    String test_subject = '123test321test';
    //error leg
    Case result = g_WorkspaceConnectorController.findCaseFromNumber('1');
    System.assert(result == null);
     
    //Create Case test data
    Case test_case = new Case(Subject = test_subject);
    insert test_case;
    Case myCase = [SELECT CaseNumber FROM Case WHERE Subject = :test_subject];  
    result = g_WorkspaceConnectorController.findCaseFromNumber(myCase.CaseNumber);
        System.assert(result!=null);
 }
    

static testMethod void findObjectFromANI_Test() {
        Object result = g_WorkspaceConnectorController.findObjectFromANI('5555');
        System.assert(result == 'not found');
        
    /* From Salesforce documentation: Adding SOSL Queries to Unit Tests
    To ensure that test methods always behave in a predictable way, any Salesforce Object Search Language (SOSL) query that is 
    added to an Apex test method returns an empty set of search results when the test method executes.
    Need to use setFixedSearchResults to set the results.       
    */    
        //Create Account test data
        Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        insert acc;
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '5555'];
        Id [] fixedSearchResultsACC= new Id[1];
        fixedSearchResultsACC[0] = newACC.Id;
        Test.setFixedSearchResults(fixedSearchResultsACC);
        result = g_WorkspaceConnectorController.findObjectFromANI('5555');
        System.assert(result!=null);
        
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        insert con1;
        Contact myContact = [SELECT Id FROM Contact WHERE Email = 'john.doer@somewhere.com'];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = myContact.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        result = g_WorkspaceConnectorController.findObjectFromANI('4444');       
        System.assert(result!=null);  
        
        //Create Lead test data
        Lead lead = new Lead(FirstName = 'John', LastName = 'Doer', Phone = '2424', Company = 'ABC', Genesys_Interaction_Id__c= '12345');
        insert lead;
        Lead myLead = [SELECT Id FROM Lead WHERE Phone = '2424'];
        Id [] fixedSearchResultsLead= new Id[1];
        fixedSearchResultsLead[0] = myLead.Id;
        Test.setFixedSearchResults(fixedSearchResultsLead);
        result = g_WorkspaceConnectorController.findObjectFromANI('2424');       
        System.assert(result!=null); 
}

static testMethod void findLeadFromGenesysID_Test() {
        Object result = g_WorkspaceConnectorController.findLeadFromGenesysID('test', '', '');       
        System.assert(result=='');  

        //Create Lead test data
        Lead lead1 = new Lead(FirstName = 'John', LastName = 'Doer', Phone = '2424', Company = 'ABC');
        insert lead1;
        result = g_WorkspaceConnectorController.findLeadFromGenesysID('test', '', '');       
        System.assert(result!=null);    

}

static testMethod void findLeadFromANI_Test() {
        Object result = g_WorkspaceConnectorController.findLeadFromANI('2424', 'test');       
        System.assert(result=='not found');     

        //Create Lead test data
        Lead lead1 = new Lead(FirstName = 'John', LastName = 'Doer', Phone = '24245', Company = 'ABC');
        insert lead1;
        Id [] fixedSearchResults = new Id[1];
        fixedSearchResults[0] = lead1.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        result = g_WorkspaceConnectorController.findLeadFromANI('2424', 'test');       
        System.assert(result!=null);    

        g_WorkspaceConnectorController.updateObjectById(lead1.Id, 'Test');

        Lead lead2 = new Lead(FirstName = 'John', LastName = 'Rob', Phone = '2424', Company = 'ABC');
        insert lead2;
        fixedSearchResults = new Id[2];
        fixedSearchResults[0] = lead1.Id;
        fixedSearchResults[1] = lead2.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        result = g_WorkspaceConnectorController.findLeadFromANI('2424', 'test');       
        System.assert(result=='multiple found');    

}
    
static testMethod void findContactFromANI_Test() {
        Object id;

        //Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        //insert acc;
        //Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '5555'];
        
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333', contact_type__c = 'Primary Contact');
        //con1.AccountId = newACC.Id;
        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Doer', Phone = '4444', contact_type__c = 'Primary Contact');
        //con2.AccountId = newACC.Id;

        g_WorkspaceConnectorController.updateObjectById(con1.Id, 'Test');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromANI('4444', '', false);
        System.assert(id == 'not found');
        
        insert con1;
        String test_phone = '4444';
        Id [] fixedSearchResults = new Id[1];
        Contact myCon = [SELECT Id FROM Contact WHERE Phone = :test_phone];
        fixedSearchResults[0] = myCon.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        System.debug('*** Id = '+myCon.Id);
           
        id = g_WorkspaceConnectorController.findContactFromANI('4444', '', true);
        System.assert(id != null && id!='not found' && id != 'multiple found');
        System.debug('*** single match');
        
        insert con2;
        fixedSearchResults = new Id[2];
        fixedSearchResults[0] = con1.Id;
        fixedSearchResults[1] = con2.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        id = g_WorkspaceConnectorController.findContactFromANI('4444', '', true);
        System.assert(id == 'multiple found');
        System.debug('*** multiple match');
}  


static testMethod void findContactFromEmailAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromEmailAddress('john.doer@somewhere.com');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromEmailAddress('john.doer@somewhere.com');
        System.assert(id != null);        
}


static testMethod void findContactFromChatAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromChatAddress('John Doer');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromChatAddress('John Doer');
        System.assert(id != null);        
}

    static testMethod void findContactFromWorkItemAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromWorkItemAddress('John Doer');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromWorkItemAddress('John Doer');
        System.assert(id != null);        
}
    
    static testMethod void findContactFromOpenMediaAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromOpenMediaAddress('John Doer');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromOpenMediaAddress('John Doer');
        System.assert(id != null);        
}    

static testMethod void createCase_Test() {
        Map<String,String> fieldsMap = new Map<String,String>();
        //create map  
        fieldsMap.put('IXN Type','Call');
        fieldsMap.put('Media Type','');
        fieldsMap.put('DATE','June1');
        String result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != 'case not created');
}
    
static testMethod void createActivity_Test() {
        String ID = '';
        Map<String,String> fieldsMap = new Map<String,String>();
        //create map
        fieldsMap.put('Genesys Call Type','Inbound');
        fieldsMap.put('LOOKUP','4444');
        fieldsMap.put('Call Duration','35');
        fieldsMap.put('DATE','June1');
        fieldsMap.put('Comments','');
        fieldsMap.put('ANI','4444');
        fieldsMap.put('IXN Type','Phone');
        fieldsMap.put('Media Type','');
        fieldsMap.put('sfdc Object Id',ID);

        //Activity created as orhpan
        String noIDResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(noIDResult != null);
    
        //Create Account test data
        Account acc = new Account(Name = 'testAccount',Phone = '7654321'); 
        insert acc;
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '7654321'];
        //Create Contact test data
        Contact con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        con.AccountId = newACC.Id;  //account id
        insert con;
        
        //Activity created under Contact using search
        String contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);

        fieldsMap.put('IXN Type','Email');
        fieldsMap.put('LOOKUP','john.doer@somewhere.com');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);

        fieldsMap.put('IXN Type','Chat');
        fieldsMap.put('LOOKUP','John Doer');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null); 
        
        fieldsMap.put('IXN Type','OpenMedia');
        fieldsMap.put('LOOKUP','John Doer');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);        
    
        //Activity created under Contact using ID
        Contact newCon = [SELECT Id FROM Contact WHERE Phone = '4444'];
        ID = newCon.Id;
        System.Debug('sfdc Object Id = '+ID);
        fieldsMap.put('sfdc Object Id',ID);
        fieldsMap.put('SFDC1field','Description');
        fieldsMap.put('SFDC1value','Test1');
        fieldsMap.put('SFDC2field','Description');
        fieldsMap.put('SFDC2value','Test2');
        fieldsMap.put('SFDC3field','Description');
        fieldsMap.put('SFDC3value','Test3');
        fieldsMap.put('SFDC4field','Description');
        fieldsMap.put('SFDC4value','Test4');
        fieldsMap.put('SFDC5field','Description');
        fieldsMap.put('SFDC5value','Test5');    
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);
} 

static testMethod void addAttachment_Test(){
    Task t = new Task (
          Type = 'Call',
          Status = 'Completed',
          Subject = 'Testttt',
          Priority = 'Normal',
          ActivityDate = System.today()
        );
        insert t;
        Task myTask = [SELECT Id FROM Task WHERE Subject = 'Testttt'];
        String blobString= 'This is a string';
        Blob b = Blob.valueOf(blobString);
        String result = g_WorkspaceConnectorController.addAttachment(myTask.Id,'Test Description','TestName1','txt',b,null);
    System.assert(result != 'error');
}

static testMethod void testConnection_Test(){
    Object result = g_WorkspaceConnectorController.testConnection();
}

static testMethod void findObject_Test() {
        Object result = g_WorkspaceConnectorController.findObject('Phone','5');
        System.assert(result == null);
        
    /* From Salesforce documentation: Adding SOSL Queries to Unit Tests
    To ensure that test methods always behave in a predictable way, any Salesforce Object Search Language (SOSL) query that is 
    added to an Apex test method returns an empty set of search results when the test method executes.
    Need to use setFixedSearchResults to set the results.       
    */
        //Create Account test data
        Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        insert acc;
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '5555'];
        Id [] fixedSearchResultsACC= new Id[1];
        fixedSearchResultsACC[0] = newACC.Id;
        Test.setFixedSearchResults(fixedSearchResultsACC);
        result = g_WorkspaceConnectorController.findObject('Phone','5555');
        System.assert(result!=null);
        
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        insert con1;
        Contact myContact = [SELECT Id FROM Contact WHERE Email = 'john.doer@somewhere.com'];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = myContact.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        result = g_WorkspaceConnectorController.findObject('Phone','4444');       
        System.assert(result!=null);
        
        //Create Lead test data
        Lead lead = new Lead(FirstName = 'John', LastName = 'Doer', Phone = '2424', Company = 'ABC');
        insert lead;
        Lead myLead = [SELECT Id FROM Lead WHERE Phone = '2424'];
        Id [] fixedSearchResultsLead= new Id[1];
        fixedSearchResultsLead[0] = myLead.Id;
        Test.setFixedSearchResults(fixedSearchResultsLead);
        result = g_WorkspaceConnectorController.findObject('Phone','2424');       
        System.assert(result!=null);
}

static testMethod void findObjectFromEmail_Test() {
    /* From Salesforce documentation: Adding SOSL Queries to Unit Tests
    To ensure that test methods always behave in a predictable way, any Salesforce Object Search Language (SOSL) query that is 
    added to an Apex test method returns an empty set of search results when the test method executes.
    Need to use setFixedSearchResults to set the results.       
    */    

    Object result = g_WorkspaceConnectorController.findObjectFromEmail('', 'Sales', '123');
    System.assert(result == null);

    result = g_WorkspaceConnectorController.findObjectFromEmail('john.smith@genesys.com', 'Sales', '123');
    System.assert(result == 'not found');

    Customer_Login__c newLogin1 = new Customer_Login__c(Name = 'john.smith1@genesys.com', Customer_ID__c = '1');
    insert newLogin1;
    result = g_WorkspaceConnectorController.findObjectFromEmail('john.smith1@genesys.com', 'Sales', '123');
    System.assert(result == 'not found');
    
    Contact newContact2 = new Contact(FirstName = 'john', LastName = 'smith2');
    insert newContact2;
    Customer_Login__c newLogin2 = new Customer_Login__c(Name = 'john.smith2@genesys.com', Customer_ID__c = '2', Primary_Contact__c = newContact2.Id);
    insert newLogin2;
    result = g_WorkspaceConnectorController.findObjectFromEmail('john.smith2@genesys.com', 'Sales', '123');
    System.assert(result != null);
        
    Contact newContact3 = new Contact(FirstName = 'john', LastName = 'smith3', Email = 'john.smith3@genesys.com');
    insert newContact3;
    result = g_WorkspaceConnectorController.findObjectFromEmail('john.smith3@genesys.com', 'Sales', '123');
    System.assert(result != null);
        
    Lead newLead4 = new Lead(FirstName = 'john', LastName = 'smith4', Company = 'none', Email = 'john.smith4@genesys.com');
    insert newLead4;
    result = g_WorkspaceConnectorController.findObjectFromEmail('john.smith4@genesys.com', 'Sales', '123');
    System.assert(result != null);
}
static testMethod void getProfileName_Test() {
    String result = g_WorkspaceConnectorController.getProfileName();
    System.assert(result != null);
}

static testMethod void getUserId_Test() {
    String result = g_WorkspaceConnectorController.getUserId();
    System.assert(result != null);
}


}