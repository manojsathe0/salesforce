({
    // DNC API method call 
     saveToDNC : function(component, event, helper, reason)    {
         var action = component.get("c.PostDncIntetnal");
         action.setParams({
             "recordid" : component.get("v.recordId"),
             "selectedValue":component.get("v.selectedValue"),
             "otherreason":reason
         });
         action.setCallback(this, function(response){
             var title;
             var type;
             var message;
             var state = response.getState();
             if(state == "SUCCESS"){ 
                 var exceptionMessages = response.getReturnValue().iadServiceMessages;
                 if(exceptionMessages){                
                     for (var i = 0; i < exceptionMessages.length; i++) {
                         title = exceptionMessages[i].msgType; 
                         type = exceptionMessages[i].msgType;
                         message = exceptionMessages[i].message;
                         helper.showToast(component, event, helper, title, type, message);
                     }
                 }
                 helper.toggleModalHelper(component);
                 $A.get('e.force:refreshView').fire(); 
             }
         });
         $A.enqueueAction(action);
     },
     
     showToast : function(component, event, helper, title, type, message) {
         var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
             title: title,
             type: type,
             message: message
         });
         toastEvent.fire();
     },
     
  checkinternaldisplay : function(component, event, helper)    {
         
         var action = component.get("c.checkdncinternal");
         action.setParams({
             "recordid" : component.get("v.recordId")
         });
         action.setCallback(this, function(response){
             var state = response.getState();
             if(state == "SUCCESS"){
                component.set("v.dncinternal",response.getReturnValue().dncinternal);
                 component.set("v.dncpermission",response.getReturnValue().dncpermission);
             }
         });
         $A.enqueueAction(action);
     },
 
     toggleModalHelper : function(cmp) {
         var isModalOpen = cmp.get("v.toggleModal");
         cmp.set("v.toggleModal", !isModalOpen);
     },
 
     toggleSpinner: function (cmp, event) {
         var spinner = cmp.find("mySpinner");
         $A.util.toggleClass(spinner, "slds-hide");
     }
     
 })