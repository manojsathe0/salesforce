({
    doInit : function(component, event, helper) {
        
        helper.getAccountStatus(component,event,helper);
        
        
        
    },
    //method to deactivate
    deactivate  : function(component, event, helper) {
        var miscItemPanel = component.find('miscItemPanel1234');
        miscItemPanel.getElement().style.display = 'block';
        
    },
    
    deactivateaccount  : function(component, event, helper) {
       
            helper.callDeactivateAccount(component,event,helper);  
                    
    },
    
    hidedeactivatemodal : function(component, event, helper) {
        var miscItemPanel = component.find('miscItemPanel1234');
        miscItemPanel.getElement().style.display = 'none';
        
    },showDetailsToEnter  : function(component, event, helper) {       
        component.set("v.invitationFlag",true);
        component.set("v.showSendCancelButtonFlag",true); 
        component.set("v.itpfirstname",component.get("v.firstname")); 
         component.set("v.itplastname",component.get("v.lastname"));
         component.set("v.itpEmail",component.get("v.Email"));
           component.set("v.popupMessage",'Are you sure you want to send a new invitation link?');
        
    },
    cancel  : function(component, event, helper) {
        //component.set("v.showSendCancelButtonFlag",false); 
       // component.set("v.invitationFlag",false);
         //component.set("v.itpfirstname",null); 
         //component.set("v.itplastname",null);
         //component.set("v.itpEmail",null);
        //helper.getInvitationDetails(component, event, helper);
        helper.cancel(component, event, helper);
    },
    showPopup  : function(component, event, helper) {
       var emailflag=true;
        if(component.get("v.itpEmail")!=''&& component.get("v.itpEmail")!=null){
            var email=component.get("v.itpEmail"); //Anvesh @B-33787
            var atpos = email.indexOf("@");
            var dotpos = email.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {                
                emailflag=false;
                helper.showToast(component , event, helper, '', 'ERROR', 'You have entered an invalid email address!'); 
            }
        }
        if(component.get("v.itpEmail")!=null &&component.get("v.itpEmail")!=''  && component.get("v.itpfirstname")!=null &&component.get("v.itpfirstname")!=''&&component.get("v.itplastname")!=null &&component.get("v.itplastname")!=''){
            if(emailflag){
            component.set("v.showPopup",true); 
            component.set("v.cancelInvite",false);
            }
        }else{
            helper.showToast(component , event, helper, '', 'ERROR', 'Please fill all mandatory fields'); 
            
        }         
    },
    closeModel  : function(component, event, helper) {
        component.set("v.showPopup",false); 
        component.set("v.showSendCancelButtonFlag",false); 
        component.set("v.invitationFlag",false);
    },
    sendOrResendInvitation : function(component, event, helper) {        
        component.set("v.showPopup",false);        
        helper.sendInvitations(component, event, helper);
        helper.getInvitationDetails(component, event, helper);
        helper.cancel(component, event, helper);

        
    }
})