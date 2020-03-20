/**
     *  @author         Saikiran Salla - ssalla@legalzoom.com
     *  @description    Batch Class for processing DNC phone number checking in LZ InternalList
     *  @history        2019-March-22   -   Created
*/

global class DNC_CheckDNCList_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {

	String query;
	String queryFrom;
	String objectName;
	String queryWhere;
	String contactType;
	Datetime dd;

	global DNC_CheckDNCList_Batch(String objName, Id conRecTypeID, Id leadRecTypeID) {

		objectName = objName;
		contactType = 'Primary Contact';

		query = 'SELECT ';
		for (Schema.FieldSetMember fs : DNC_CheckDNCList_Impl.getFields(objectName))
			query += fs.getFieldPath() + ',';

		if (objectName == DNC_Utility.CONTACT) {
			queryFrom = 'Id FROM Contact';
			query += queryFrom;
			queryWhere = ' WHERE Internal_List__c = false AND Contact_Type__c =: contactType';
		}
		if (objectName == DNC_Utility.LEAD) {
			queryFrom = 'Id FROM Lead';
			query += queryFrom;
			queryWhere = ' WHERE Internal_List__c = false';
		}

		Boolean isSandbox = [select isSandbox from organization].isSandbox;
		if (isSandbox) {
			dd = System.now().addDays(-3);
			queryWhere = queryWhere + ' AND createddate >: dd';
		}

		query += queryWhere;
		system.debug('---' + query);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		DNC_CheckDNCList_Impl.checkDNCList(objectName, scope);
	}

	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [Select Id, Status, ExtendedStatus, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = :BC.getJobId()];
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject(objectName + '\'s DNC Internal Check list: ' + a.Status);
		mail.setPlainTextBody('records processed ' + a.TotalJobItems +
		                      'with ' + a.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

}

// Sample code for save results
// DML statement
//Database.SaveResult[] srList = Database.insert(acctList, false);

//// Iterate through each returned result
//for (Database.SaveResult sr : srList) {
//    if (sr.isSuccess()) {
//        // Operation was successful, so get the ID of the record that was processed
//        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
//    }
//    else {
//        // Operation failed, so get all errors
//        for(Database.Error err : sr.getErrors()) {
//            System.debug('The following error has occurred.');
//            System.debug(err.getStatusCode() + ': ' + err.getMessage());
//            System.debug('Account fields that affected this error: ' + err.getFields());
//        }
//    }
//}