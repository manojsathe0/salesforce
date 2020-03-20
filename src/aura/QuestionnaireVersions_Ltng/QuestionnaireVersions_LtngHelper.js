({
    getVersions : function(component, processingNumber, helper) {
        
        console.log('inside questionnaire with #' + processingNumber);
        var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        
        var action = component.get("c.getQuestionnaireVersionsByProcessingNumber");
        
        action.setParams({
            "processingNumber" : processingNumber,
            "ordernumber" :component.get("v.ordernumber")
        });
        action.setCallback(this, function(response) {
            console.log('inside setCallback');
            var state = response.getState();
            console.log('state = ' + state);
            if (state === "SUCCESS") {
                var QuestionnaireVersionsService_Ltng = response.getReturnValue();
                if (QuestionnaireVersionsService_Ltng.questVersionsObtained) {
                    component.set("v.questVersions", QuestionnaireVersionsService_Ltng.questVersions);
                    
                    if(!$A.util.isEmpty(QuestionnaireVersionsService_Ltng.questVersions)){
                        helper.getQuestionnaireVersion(component,processingNumber,QuestionnaireVersionsService_Ltng.questVersions[0].revision,QuestionnaireVersionsService_Ltng.questVersions[0].subRevision ); 
                    } else {
                        helper.getQuestionnaireVersion(component, processingNumber, 0, 0); 
                    }
                                  
                }
                else {
                    title = "Error";
                    type = "error";
                    message = "An error occured: !" + QuestionnaireVersionsService_Ltng.iadServiceMessages[0].message;
                    this.showToast(component, event, helper, title, type, message);
                    console.log("Failed with state: " + state);
                }
                this.toggleSpinner(component, event);
                
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured: Please refresh and try again!";
                this.showToast(component, event, helper, title, type, message);
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    getQuestionnaireVersion : function(component, processNumber, revision, subRevision) {
        console.log('in getQuestionnaireVersion with: ' + processNumber);
        //alert("GETTING: " + processNumber);
        var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        
        var getQuestFields = component.get("c.getQuestionnaireByProcessingNumber");
        getQuestFields.setParams({
            "processingNumber" : processNumber, 
            "revision" : revision, 
            "subrevision" : subRevision
        });
        getQuestFields.setCallback(this, function(response) {
            console.log('in setCallback  of getQuestionnaireVersion: ');
            
            var state = response.getState();
            console.log('state = ' + state);
            if (state === "SUCCESS") {
                var QuestionnaireVersionsService_Ltng = response.getReturnValue();
                console.log('QuestionnaireVersionsService_Ltng.questVersionsObtained = ' + QuestionnaireVersionsService_Ltng.questGivenVersionObtained);
                if (QuestionnaireVersionsService_Ltng.questGivenVersionObtained) {
                    component.set("v.questFields", QuestionnaireVersionsService_Ltng.questionnaireFields);
                }
                else {
                    component.set("v.questFields", null);
                    title = "Error";
                    type = "error";
                    message = "An error occured: !" + QuestionnaireVersionsService_Ltng.iadServiceMessages[0].message;
                    this.showToast(component, event, helper, title, type, message);
                    console.log("Failed with state: " + state);
                }
                this.toggleSpinner(component, event);
                
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured: Please refresh and try again!";
                this.showToast(component, event, helper, title, type, message);
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(getQuestFields);
    },
    
    toggleSpinner : function(component, event) {
        console.log('ready to close the spinner');
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'showSpinner');
        $A.util.addClass(spinner, 'hideSpinner');
    },
    
    showToast : function(component, event, helper, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        console.log('toastEvent: ');
        console.log(toastEvent);
        toastEvent.setParams({
            title: title,
            type: type,
            message: message
        });
        toastEvent.fire();
    }
    
})
