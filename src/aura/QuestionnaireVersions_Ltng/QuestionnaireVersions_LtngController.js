/*
Migration of Questionnaire Versions functionality to Salesforce
Story: B-22668, B-22671
By Artyom M.
*/

({
    doInit : function(component, event, helper) {
        console.log('inside init method Ledger(Questionnaire)');
		console.log(window.location.href);
        
        var appUrl = window.location.href;
        if(appUrl.includes("Questionnaire"))
        {    
            component.set("v.isQuestionnaireApp", true);
            var sURLAndParams = appUrl.split('?');
            console.log('sURLAndParams: '+sURLAndParams);
            var sParams = sURLAndParams[1].split('&');
            console.log('sParams: '+sParams);
            var sParameterName;
            var processingNumber;
            
            for (var i = 0; i < sParams.length; i++) {
                sParameterName = sParams[i].split('='); //to split the key from the value.
                console.log('sParameterName: '+sParameterName);
                if(sParameterName[0] === 'processingNumber'){
                    processingNumber = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }
            }
            
            component.set("v.processingNumber", processingNumber);  
            helper.getVersions(component, component.get("v.processingNumber"), helper);
        }
    },
    
    getVersion : function(component, event, helper) {
        
        var processingNumber = component.get("v.processingNumber");
        var questVersions = component.get("v.questVersions");
        //var selectedQuest = component.get("v.selectedQuest");
        var selectedQuest = parseInt(component.find("questVersion").get("v.value"));
        console.log("Inside getVersion: " + questVersions[selectedQuest].revision + " : " + questVersions[selectedQuest].subRevision); 
        helper.getQuestionnaireVersion(component, processingNumber, questVersions[selectedQuest].revision, questVersions[selectedQuest].subRevision);
    },
    
    closeQuestVersions : function(component, event, helper){
        var questionnairePanel = component.find('questionnairePanel');
        console.log(questionnairePanel);
        component.set("v.questVersions", null);
        component.set("v.questFields", null);
        $A.util.addClass(questionnairePanel, 'hideOrderHistory');
        $A.util.removeClass(questionnairePanel, 'showOrderHistory');
    },
    
    openQuestVersions : function(component, event, helper){
        
        var questionnairePanel = component.find('questionnairePanel');
        console.log(questionnairePanel);
        var params = event.getParam('arguments');
        
        helper.getVersions(component, params.processingNumberParam, helper);
        $A.util.addClass(questionnairePanel, 'showOrderHistory');
        $A.util.removeClass(questionnairePanel, 'hideOrderHistory');
    },
    
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
     printquestionnaire: function(component, event, helper) {
          
        var processingNumber = component.get("v.processingNumber");
        var questVersions = component.get("v.questVersions");
        //var selectedQuest = component.get("v.selectedQuest");
        var selectedQuest = parseInt(component.find("questVersion").get("v.value"));
       
         if(selectedQuest)
         {
             var url='http://zoomreportsqa/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/Reports/OM/QuestionnaireAnswers.rdl&rp:fkUserOrder='+processingNumber+'&rp:iRevision'+ questVersions[selectedQuest].revision +'&rp:iSubRevision='+questVersions[selectedQuest].subRevision+'&rp:ProductName='+questVersions[selectedQuest].revisionname+'&rv:ParamMode=Hidden';
         }
         else
         {
             var url='http://zoomreportsqa/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/Reports/OM/QuestionnaireAnswers.rdl&rp:fkUserOrder='+processingNumber+'&rp:iRevision=0&rp:iSubRevision=0&rp:ProductName=Original%20Order&rv:ParamMode=Hidden';
         }
             window.open(url);
        
    }
})