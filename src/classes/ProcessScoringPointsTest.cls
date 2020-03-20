@isTest
private class ProcessScoringPointsTest
{
    public static List<String> criteriaNames;
    public static void setupDate()
    {
        criteriaNames = new List<String> {'viewed_inc_pricing' , 'viewed_inc_overview' , 'viewed_llc_pricing' , 'viewed_llc_overview'};

        Lead_Scoring_Bucket__c bucket = new Lead_Scoring_Bucket__c();
        bucket.Name = 'Bucket1';
        bucket.Bucket_Percentage__c = 100;
        insert bucket;

        List<Lead_Scoring_Bucket_Criteria__c> criteriaToInsert = new List<Lead_Scoring_Bucket_Criteria__c>();
        for(integer i=0; i<criteriaNames.size(); i++)
        {
            Lead_Scoring_Bucket_Criteria__c  criteria = new Lead_Scoring_Bucket_Criteria__c();
            criteria.Name = criteriaNames[i]; 
            criteria.Active__c = True;
            criteria.Criteria__c = 'Test Criteria';
            criteria.Lead_Scoring_Bucket__c = bucket.Id; 
            criteria.Value__c = 'True,Test';
            criteria.points__c = 1;
            criteriaToInsert.add(criteria);
        }
        insert criteriaToInsert;
  
    }
    static testMethod void postScoringInformationLead()
    {
        setupDate();
        PageReference pageRef = Page.ScoringPoints;
        pageRef.getParameters().put('user_lname','testHttp');
        pageRef.getParameters().put('company','testCompany');
        pageRef.getParameters().put('user_email','testhttpPost@testHttpPost.com');
        pageRef.getParameters().put('user_id',' ');
        pageRef.getParameters().put('business_name','Test bussiness');
        pageRef.getParameters().put('formation_state','California');
        pageRef.getParameters().put('tealium_id',' ');
        pageRef.getParameters().put('business_phone','9909909999');
        pageRef.getParameters().put(criteriaNames[0],'true');
        pageRef.getParameters().put(criteriaNames[1],'true');
        pageRef.getParameters().put(criteriaNames[2],'true');
        pageRef.getParameters().put(criteriaNames[3],'true');

        Test.setCurrentPage(pageRef);
        Test.startTest();
              ProcessScoringPoints pointsProcessor = new ProcessScoringPoints();
              pointsProcessor.processUrlParameters();
        Test.stopTest();
        //Lead Score becomes 100+30 = 130.Any leads that are created today gets flat score of 30 on top od existing score.If that is changed
        //this assertion has to be adjusted
        List<Lead> insertedLead = [Select Id , Lead_Score__c , Email From Lead Where Email = 'testhttpPost@testHttpPost.com' Limit 1];
        system.assertEquals(130,insertedLead[0].Lead_Score__c);

        List<Lead_Attribute__c> insertedPoints = [Select Id From Lead_Attribute__c];
        system.assertEquals(4,insertedPoints.size());
    }

    static testMethod void postScoringInformationContact()
    {
        setupDate();
        Account theAccount =  TestUtils.createAccounts(1, 'Test Accoubt', true)[0];
        Contact theContact = TestUtils.createContacts(1, 'LeadScorinTest', theAccount.Id, true)[0];
        theContact.Email = 'contactEmial@leadScore.test';
        theContact.Phone = '9909909999';
        theContact.FkUser__c = '9966554';
        theContact.Contact_Type__c = 'Primary Contact';
        update theContact;
        PageReference pageRef = Page.ScoringPoints;
        pageRef.getParameters().put('user_lname','testHttp');
        pageRef.getParameters().put('company','testCompany');
        pageRef.getParameters().put('user_email','contactEmial@leadScore.test');
        pageRef.getParameters().put('user_id','9966554');
        pageRef.getParameters().put('business_name','Test bussiness');
        pageRef.getParameters().put('formation_state','California');
        pageRef.getParameters().put('tealium_id',' ');
        pageRef.getParameters().put('business_phone','9909909999');
        pageRef.getParameters().put(criteriaNames[0],'true');
        pageRef.getParameters().put(criteriaNames[1],'true');
        pageRef.getParameters().put(criteriaNames[2],'true');
        pageRef.getParameters().put(criteriaNames[3],'true');

        Test.setCurrentPage(pageRef);
        Test.startTest();
              ProcessScoringPoints pointsProcessor = new ProcessScoringPoints();
              pointsProcessor.processUrlParameters();
        Test.stopTest();

        List<Contact> insertedContact = [Select Id , Contact_Score__c , Email From Contact Where Email = 'contactEmial@leadScore.test' Limit 1];
        system.assertEquals(100,insertedContact[0].Contact_Score__c);

        List<Lead_Attribute__c> insertedPoints = [Select Id,points__c, Contact__c From Lead_Attribute__c];
        system.assertEquals(4,insertedPoints.size());
        system.debug(insertedPoints);
    }

    static testMethod void postScoringInformationContact_Log()
    {
        setupDate();
        Account theAccount =  TestUtils.createAccounts(1, 'Test Accoubt', true)[0];
        Contact theContact = TestUtils.createContacts(1, 'LeadScorinTest', theAccount.Id, true)[0];
        theContact.Email = 'contactEmial@leadScore.test';
        theContact.Phone = '9909909999';
        theContact.FkUser__c = '9966554';
        theContact.Contact_Type__c = 'Primary Contact';
        update theContact;
        PageReference pageRef = Page.ScoringPoints;
        pageRef.getParameters().put('user_lname','testHttp');
        pageRef.getParameters().put('company','testCompany');
        pageRef.getParameters().put('user_email','contactEmial@leadScore.test');
        pageRef.getParameters().put('user_id','99661554');
        pageRef.getParameters().put('business_name','Test bussiness');
        pageRef.getParameters().put('formation_state','California');
        pageRef.getParameters().put('tealium_id',' ');
        pageRef.getParameters().put('business_phone','9909909999');
        pageRef.getParameters().put(criteriaNames[0],'true');
        pageRef.getParameters().put(criteriaNames[1],'true');
       

        Test.setCurrentPage(pageRef);
        Test.startTest();
              ProcessScoringPoints pointsProcessor = new ProcessScoringPoints();
              pointsProcessor.processUrlParameters();
        Test.stopTest();

      
        List<Tealium_Request__c> tealiumRequests = [SELECT Id , Contact__c , Request_Body__c , Matched_Field__c FROM Tealium_Request__c];
        System.assert(!tealiumRequests.isEmpty() , 'Should not be empty');
        System.assertEquals(theContact.Id ,tealiumRequests[0].Contact__c  , 'Right Contact Id should have been populated');
        System.assert(tealiumRequests[0].Request_Body__c.contains('user_lname') , 'user_lname should have been present');
        System.assertEquals('Email' , tealiumRequests[0].Matched_Field__c , 'Should have Matched on Email');
    }

}