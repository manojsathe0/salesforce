/**
     *  @author         Saikiran Salla - ssalla@legalzoom.com
     *  @description    Utility class for DNC
     *  @history        2019-March-22   -   Created
*/

public class DNC_Utility {

	public final static String DML_UPDATE = 'update';
	public final static String DML_INSERT = 'insert';
	public final static String DML_DELETE = 'delete';
	public final static String ORDER = 'Order__c';
	public final static String LEAD = 'Lead';
	public final static String CONTACT = 'Contact';
	public final static String EPNAME = 'DNCGetPhoneNumber';

	public static Boolean dmlSobject(String dmlMethod, sObject obj) {
		return dmlSobjectList(dmlMethod, new List<sObject> {obj});
	}

	//TO perform DML statements
	public static Boolean dmlSobjectList(String dmlMethod, List<sObject> objList) {
		if (dmlMethod == DML_UPDATE)
			update objList;

		if (dmlMethod == DML_INSERT)
			insert objList;

		if (dmlMethod == DML_DELETE)
			delete objList;

		return true;
	}


	//Clean the phone number and formats to plain numbers. XXXXXXXXXX
	public static Set<String> cleanPhoneNumber(Set<String> phNumbers) {
		Set<String> cleanPhList = new Set<String>();
		for (String ph : phNumbers) {
			cleanPhList.add(ph.replaceAll('[^0-9]+', ''));
		}
		return cleanPhList;
	}

	public static String parseReservedKeywords(String jsonStr) {
		if (jsonStr != null) {
			if (jsonStr.contains('\"Number\"')) {
				jsonStr = jsonStr.replace('\"Number\"', '\"sNumber\"');
			}
		}
		return jsonStr;
	}

	//Looks for the W character that is after 3rd ";"
	//B-41245
	public static String cleanAndextractReasonCode(String reason) {
		if (!String.isBlank(reason)) {
			reason = reason.replaceAll('[\\s]', '').toUpperCase();		//Removes all nulls
			List<String> resonSplit = reason.split(';');
			reason = resonSplit.size() > 3 ? resonSplit[3] : '';
		}
		return reason;
	}
}