global class updateDateTime implements Process.Plugin {

// Invoke method
global Process.PluginResult invoke(Process.PluginRequest request) {
String vSneId = (String) request.inputParameters.get('vSneId');
DateTime vSneDate = (DateTime)request.inputParameters.get('vSneDate');
String vSNETime = (String) request.inputParameters.get('vSneTime');
DateTime datetimes ;
			if(vSneDate != null  && vSNETime != null && vSNETime != ''){
			   	Date tempDate = Date.valueOf(vSneDate.date());
             	String datetemp = String.valueOf(tempDate);
				datetimes = stringToDateTime(datetemp,vSNETime);
			     if(vSneId != ''){
	               Task tasksRecord = [select ReminderDateTime,IsReminderSet from Task where Id =:vSneId];
	        		tasksRecord.ReminderDateTime = datetimes;
	        		tasksRecord.IsReminderSet = true;
	        	try{
	                update tasksRecord;
	                System.debug('-----Updated  Task Complete-----');
	        	}catch(DmlException e){
	        		for(Integer i=0;i<e.getNumDml();i++){
	        		System.debug('-------Updated Task Error-----'+e.getDmlMessage(i));
	        		}
	        	  }
	           }
			}		

Map<String,Object> result = new Map<String,Object>();

// Add value to output parameter and return.

return new Process.PluginResult(result);
}

// Describe method. Returns the describe information for the interface
global Process.PluginDescribeResult describe() {
Process.PluginDescribeResult result = new Process.PluginDescribeResult();
result.Name = 'updateDateTime';
result.Tag = 'UPDATEDATETIME';

result.inputParameters = new
List<Process.PluginDescribeResult.InputParameter> {
new Process.PluginDescribeResult.InputParameter('vSneId',Process.PluginDescribeResult.ParameterType.STRING, true),
new Process.PluginDescribeResult.InputParameter('vSneDate',Process.PluginDescribeResult.ParameterType.Date, true),
new Process.PluginDescribeResult.InputParameter('vSneTime',Process.PluginDescribeResult.ParameterType.STRING, true)
};

return result;
}
public  DateTime stringToDateTime(String dateValue,String timeValue){
         
      // Date String is in the format yyyy-mm-dd
      String[] stringDate = dateValue.split('-');
      Integer year =  Integer.valueOf(stringDate[0]);
      Integer month = Integer.valueOf(stringDate[1]);
      Integer day = Integer.valueOf(stringDate[2]);
      //Time String is in th format hh:mm
      String[] stringTime = timeValue.split(':');
      Integer hour = Integer.valueOf(stringTime[0]);
      Integer minute = Integer.valueOf(stringTime[1]);
      DateTime datetimetemp = datetime.newInstance(year, month, day, hour, minute, 0);
      Map<String, String> mappedValues = new Map<String, String>();
        mappedValues = Integrated_Email_List_Utility.LocaleMap();
        String user_locale = UserInfo.getLocale();
        String datetime_format = '';
        if (mappedValues.containsKey(user_locale)) {
           datetime_format = mappedValues.get(user_locale); 
         }
          String dateTimeFormat =  datetimetemp.format(datetime_format);
          Datetime dateTimeValue = DateTime.parse(dateTimeFormat);
      return dateTimeValue;
 } 
}