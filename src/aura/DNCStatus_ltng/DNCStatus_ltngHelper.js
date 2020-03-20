({
	checkinternal : function(component, event, helper)    {
        
        var action = component.get("c.checkinternallist");
        action.setParams({
            "recordid" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var str =component.get("v.recordId");
            if(state == "SUCCESS"){ 
               
                  if( response.getReturnValue()===true)
                  {   if(str.startsWith('00Q'))
                         {
                      component.set("v.dncStatusMessage" ,'No Proactive Selling on Outbound Calls');
                         component.set("v.toggleNotification",true);
                        }
                
                   else
                   {
                    component.set("v.dncStatusMessage" ,'No Proactive Selling on Any Calls'); 
                       component.set("v.toggleNotification",true);
                   }
                  }
                  else {
                    component.set("v.dncStatusMessage","");
                    component.set("v.toggleNotification",false);
                  }
            }
        });
        $A.enqueueAction(action);
    }
})