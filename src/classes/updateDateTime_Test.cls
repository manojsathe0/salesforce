@isTest
public with sharing class updateDateTime_Test {
static testmethod void flowChatTests() {
updateDateTime plugin = new updateDateTime();
Map<String,Object> inputParams = new Map<String,Object>();
        Lead l = new Lead(Company = 'test1@test.com', FirstName = 'first1', LastName = 'last1');
    	insert l;
    	Id lid = l.Id;
    	Task temp = new Task(Type='Email',Status='Completed',Subject= 'Email: ',ActivityDate=Date.today());
	    insert temp;
InputParams.put('vSneId', temp.Id);
InputParams.put('vSneDate',DateTime.now());
InputParams.put('vSneTime',  '11:30');
Process.PluginRequest request = new Process.PluginRequest(inputParams);
plugin.describe();
plugin.invoke(request);
}
}