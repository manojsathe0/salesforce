({
    init : function(component, event, helper) {
        
        
        helper.initializeHelper(component);
    },
    
    /*  The following section adds Opp functionality
        Created by Artyom M.
        Per Stories: B-16778, B-18406, B-18408, B-18409, B-18410
        
        START
     */ 
    
    
    focusLeadTab : function(component, event, helper) {

        helper.hideOppScoreBtn(component);
        helper.showSaveBtn(component);
        
        //moving to fist tab
        var leadScoreTab = component.find("leadScoreTab");
        var leadEntryExitTab = component.find("leadEntryExitTab");
        var questTab = component.find("questTab");
        var webTab = component.find("webTab");
        var custTab = component.find("custTab");
        
        $A.util.addClass(leadScoreTab, "slds-active");
        $A.util.removeClass(leadEntryExitTab, "slds-active");
        $A.util.removeClass(questTab, "slds-active");
        $A.util.removeClass(webTab, "slds-active");
        $A.util.removeClass(custTab, "slds-active");
        
        
        var leadScorePage = component.find("leadScorePage");
        var leadEntryExitPage = component.find("leadEntryExitPage");
        var questPage = component.find("questPage");
        
        $A.util.removeClass(leadScorePage, "slds-hide");
        $A.util.addClass(leadEntryExitPage, "slds-hide");
        $A.util.addClass(questPage, "slds-hide");
        
        $A.util.addClass(leadScorePage, "slds-show");
        $A.util.removeClass(leadEntryExitPage, "slds-show");
        $A.util.removeClass(questPage, "slds-show");
        component.set("v.tabId", 'leadScore');
        component.set("v.objectType", 'Lead');
        
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        
        //end
        var currtab = component.get("v.tabId");
        helper.getCChildren(component,currtab, component.get("v.objectType"));
        var leadSuperTab = component.find("leadSuperTab");
        var oppSuperTab = component.find("oppSuperTab");
        
        $A.util.removeClass(oppSuperTab, "slds-active");
        $A.util.addClass(leadSuperTab, "slds-active");
        
        var leadSuperPage = component.find("leadSuperPage");
        var oppSuperPage = component.find("oppSuperPage");
        
        $A.util.addClass(oppSuperPage, "slds-hide");
        $A.util.removeClass(leadSuperPage, "slds-hide");
        
        $A.util.removeClass(oppSuperPage, "slds-show");
        $A.util.addClass(leadSuperPage, "slds-show");
    },
    
    focusOppTab : function(component, event, helper) {
        
        //moving to fist tab
        
        helper.hideOppScoreBtn(component);
        helper.showSaveBtn(component);
        
        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
        var opponboard =component.find("opponboardTab");//onboarding scoring 
        
        // var saveBtn = component.find("saveBtn");
        
        // $A.util.addClass(saveBtn, "slds-show");
        
        $A.util.addClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppWebTab, "slds-active");
        $A.util.removeClass(oppCustTab, "slds-active");
        $A.util.removeClass(opponboard, "slds-active");
        
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        var opponboardPage = component.find("opponboardPage"); //onboarding scoring 
        
        
        $A.util.addClass(opponboardPage, "slds-hide");
        $A.util.removeClass(opponboardPage, "slds-show ");//onboarding scoring 
        
        $A.util.removeClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppEntryExitPage, "slds-hide");
        $A.util.addClass(oppQuestPage, "slds-hide");
        
        $A.util.addClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppEntryExitPage, "slds-show");
        $A.util.removeClass(oppQuestPage, "slds-show");
        component.set("v.tabId", 'Score');
        component.set("v.objectType", 'Opp');
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        
        //end
        
        
        var leadSuperTab = component.find("leadSuperTab");
        var oppSuperTab = component.find("oppSuperTab");
        
        
        $A.util.addClass(oppSuperTab, "slds-active");
        $A.util.removeClass(leadSuperTab, "slds-active");
        
        var leadSuperPage = component.find("leadSuperPage");
        var oppSuperPage = component.find("oppSuperPage");
        
        $A.util.removeClass(oppSuperPage, "slds-hide");
        $A.util.addClass(leadSuperPage, "slds-hide");
        
        $A.util.addClass(oppSuperPage, "slds-show");
        $A.util.removeClass(leadSuperPage, "slds-show");
        
    },
    
    focusOppScore : function(component, event, helper) {
        
        helper.hideOppScoreBtn(component);
        helper.showSaveBtn(component);

        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
        
        // var saveBtn = component.find("saveBtn");
        
        var opponboard =component.find("opponboardTab");
        $A.util.removeClass(opponboard, "slds-active");
        var opponboardPage = component.find("opponboardPage"); //onboarding scoring 
        $A.util.addClass(opponboardPage, "slds-hide");
        $A.util.removeClass(opponboardPage, "slds-show ");
        
        // $A.util.addClass(saveBtn, "slds-show");
        
        $A.util.addClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppWebTab, "slds-active");
        $A.util.removeClass(oppCustTab, "slds-active");
        
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        
        $A.util.removeClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppEntryExitPage, "slds-hide");
        $A.util.addClass(oppQuestPage, "slds-hide");
        
        $A.util.addClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppEntryExitPage, "slds-show");
        $A.util.removeClass(oppQuestPage, "slds-show");
        component.set("v.tabId", 'Score');
        component.set("v.objectType", 'Opp');
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
    },
    focusOppEntryExit : function(component, event, helper) {
        
        
        helper.hideOppScoreBtn(component);
        helper.showSaveBtn(component);

        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
        
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        var opponboard =component.find("opponboardTab");
        $A.util.removeClass(opponboard, "slds-active");
        var opponboardPage = component.find("opponboardPage");  //onboarding scoring 
        $A.util.addClass(opponboardPage, "slds-hide");
        $A.util.removeClass(opponboardPage, "slds-show ");
        $A.util.addClass(toast, "hideContainer");
        
        // $A.util.addClass(saveBtn, "slds-show");
        $A.util.addClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppWebTab, "slds-active");
        $A.util.removeClass(oppCustTab, "slds-active");
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        
        $A.util.removeClass(oppEntryExitPage, "slds-hide");
        $A.util.addClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppQuestPage, "slds-hide");
        
        $A.util.addClass(oppEntryExitPage, "slds-show");
        $A.util.removeClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppQuestPage, "slds-show");
        component.set("v.tabId", 'EntryTab');
        component.set("v.objectType", 'Opp');
        
    },
    
    focusOppQuest : function(component, event, helper) {
        
        
        helper.hideOppScoreBtn(component);
        helper.hideSaveBtn(component);

        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        
        var oppPercentBlock = component.find("oppPercentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        var opponboard =component.find("opponboardTab");
       
        $A.util.removeClass(opponboard, "slds-active");
        var opponboardPage = component.find("opponboardPage");  //onboarding scoring 
        $A.util.addClass(opponboardPage, "slds-hide");
        $A.util.removeClass(opponboardPage, "slds-show ");
        
        $A.util.addClass(toast, "hideContainer");
        
        
        $A.util.addClass(oppPercentBlock,"slds-show");
        $A.util.addClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppCustTab, "slds-active");
        $A.util.removeClass(oppWebTab, "slds-active");
        
        // $A.util.addClass(saveBtn, "slds-hide");
        // $A.util.removeClass(saveBtn, "slds-show");
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        
        $A.util.removeClass(oppQuestPage, "slds-hide");
        $A.util.addClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppEntryExitPage, "slds-hide");
        
        $A.util.addClass(oppQuestPage, "slds-show");
        $A.util.removeClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppEntryExitPage, "slds-show");   
        component.set("v.tabId", 'Questionnaire');
        component.set("v.objectType", 'Opp');
        
        helper.getCChildren(component,param, objectType);
        helper.getPercent(component,param, objectType);
    },
    
    focusOppWeb: function (component, event, helper) {
        
        helper.hideOppScoreBtn(component);
        helper.hideSaveBtn(component);

        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
      
        var opponboard =component.find("opponboardTab");
        $A.util.removeClass(opponboard, "slds-active");
        var opponboardPage = component.find("opponboardPage"); //onboarding scoring 
        $A.util.addClass(opponboardPage, "slds-hide");
        $A.util.removeClass(opponboardPage, "slds-show ");
        
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        var oppPercentBlock = component.find("oppPercentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        
        $A.util.addClass(toast, "hideContainer");
        $A.util.removeClass(oppPercentBlock,"slds-show");
        $A.util.addClass(oppWebTab, "slds-active");
        $A.util.removeClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppCustTab, "slds-active");
        // $A.util.addClass(saveBtn, "slds-hide");
        // $A.util.removeClass(saveBtn, "slds-show");
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        
        $A.util.removeClass(oppQuestPage, "slds-hide");
        $A.util.addClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppEntryExitPage, "slds-hide");
        
        $A.util.addClass(oppQuestPage, "slds-show");
        $A.util.removeClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppEntryExitPage, "slds-show");
        
        component.set("v.tabId", 'Website');
        component.set("v.objectType", 'Opp');
        helper.getCChildren(component,param, objectType);
        helper.getPercent(component,param, objectType);
        
    },
    
    focusOppCust: function (component, event, helper) {
        
        helper.hideOppScoreBtn(component);
        helper.hideSaveBtn(component);

        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
        
        var opponboard =component.find("opponboardTab");
        $A.util.removeClass(opponboard, "slds-active");
        var opponboardPage = component.find("opponboardPage"); //onboarding scoring 
        $A.util.addClass(opponboardPage, "slds-hide");
        $A.util.removeClass(opponboardPage, "slds-show ");
        
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        var oppPercentBlock = component.find("oppPercentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        
        $A.util.addClass(toast, "hideContainer");
        $A.util.removeClass(oppPercentBlock,"slds-show");
        
        $A.util.addClass(oppCustTab, "slds-active");
        $A.util.removeClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppWebTab, "slds-active");
        // $A.util.addClass(saveBtn, "slds-hide");
        // $A.util.removeClass(saveBtn, "slds-show");
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        
        $A.util.removeClass(oppQuestPage, "slds-hide");
        $A.util.addClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppEntryExitPage, "slds-hide");
        
        $A.util.addClass(oppQuestPage, "slds-show");
        $A.util.removeClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppEntryExitPage, "slds-show");
        
        helper.getCChildren(component,param, objectType);
        helper.getPercent(component,param, objectType);
        component.set("v.tabId", 'Customer');
        component.set("v.objectType", 'Opp');
    },
    
      // onboard scoring functionality
    focusOpponboard: function (component, event, helper) {

        helper.hideSaveBtn(component);

        var oppScoreTab = component.find("oppScoreTab");
        var oppEntryExitTab = component.find("oppEntryExitTab");
        var oppQuestTab = component.find("oppQuestTab");
        var oppWebTab = component.find("oppWebTab");
        var oppCustTab = component.find("oppCustTab");
        var opponboard =component.find("opponboardTab");
        
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        var oppPercentBlock = component.find("oppPercentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        
        
        
        
        $A.util.addClass(opponboard, "slds-active");
        $A.util.removeClass(oppCustTab, "slds-active");
        $A.util.removeClass(oppScoreTab, "slds-active");
        $A.util.removeClass(oppEntryExitTab, "slds-active");
        $A.util.removeClass(oppQuestTab, "slds-active");
        $A.util.removeClass(oppWebTab, "slds-active");
        // $A.util.removeClass(saveBtn, "slds-show");
        // $A.util.addClass(saveBtn, "slds-hide");
        
        var oppScorePage = component.find("oppScorePage");
        var oppEntryExitPage = component.find("oppEntryExitPage");
        var oppQuestPage = component.find("oppQuestPage");
        var opponboardPage = component.find("opponboardPage");
        
        
        $A.util.addClass(opponboardPage, "slds-show");
        $A.util.removeClass(opponboardPage, "slds-hide ");
        $A.util.addClass(oppQuestPage, "slds-hide");
        $A.util.addClass(oppScorePage, "slds-hide");
        $A.util.addClass(oppEntryExitPage, "slds-hide");
        
        $A.util.removeClass(oppQuestPage, "slds-show");
        $A.util.removeClass(oppScorePage, "slds-show");
        $A.util.removeClass(oppEntryExitPage, "slds-show");
        
        
        component.set("v.tabId", 'Customer');
        component.set("v.objectType", 'Opp');

        var saveOppBtn = component.find("saveOppOnboardBtn");
        $A.util.addClass(saveOppBtn, "slds-show");
        $A.util.removeClass(saveOppBtn, "slds-hide");
    },
    
    
    
    
    oppAddNewScore : function(component, event, helper) {
        var addEditBlock = component.find("oppAddEditBlock");
        var addNewBtn = component.find("oppAddNewBtn");
        
        $A.util.toggleClass(addEditBlock, "slds-show");
        $A.util.toggleClass(addEditBlock, "slds-hide");
        
        
        $A.util.removeClass(addNewBtn, "slds-show");
        $A.util.addClass(addNewBtn, "slds-hide");
        
        var currtab = component.get("v.tabId");
        helper.getCChildren(component,currtab, component.get("v.objectType"));
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
    },
    oppAddNewPercent : function(component, event, helper) {
        var addEditBlockPercent = component.find("oppAddEditBlockPercent");
        var addPercent = component.find("oppAddPercent");
        var savePercent = component.find("oppSavePercent");
        
        $A.util.toggleClass(addEditBlockPercent, "slds-show");
        $A.util.toggleClass(addEditBlockPercent, "slds-hide");
        //$A.util.toggleClass(addPercent, "slds-hide");        
        $A.util.addClass(addPercent, "slds-hide");  
        $A.util.removeClass(addPercent, "slds-show");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
    },
    
    oppEditScore : function(component, event, helper) {
        var addEditBlock = component.find("oppAddEditBlock");
        var addNewBtn = component.find("oppAddNewBtn");
        //var saveScore = component.find("saveScore");
        var recordId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        
        
        $A.util.toggleClass(addEditBlock, "slds-show");
        $A.util.toggleClass(addEditBlock, "slds-hide");
        $A.util.addClass(addNewBtn, "slds-hide");
        $A.util.removeClass(addNewBtn, "slds-show");
        
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        component.find("oppWarnings").set("v.value",null);
        component.set("v.recId", recordId);
        
        var action =component.get("c.gettimeRecord");
        action.setParams({ "Id":recordId });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.configChild", response.getReturnValue());                 
                
                component.find("oppMinSelected").set("v.value", ''+(component.get("v.configChild.Minimum__c")));
                component.find("oppMaxSelected").set("v.value", ''+(component.get("v.configChild.Maximum__c")));
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    oppEditPercent : function(component, event, helper) {
        var addEditBlockPercent= component.find("oppAddEditBlockPercent");
        var addPercent = component.find("oppAddPercent");
        //var savPercent = component.find("savPercent");
        var precordId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        
        
        $A.util.toggleClass(addEditBlockPercent, "slds-show");
        $A.util.toggleClass(addEditBlockPercent, "slds-hide");
        $A.util.addClass(addPercent, "slds-hide");  
        $A.util.removeClass(addPercent, "slds-show");
        
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        
        component.find("oppPerwarnings").set("v.value",null);
        component.set("v.precId", precordId);
        
        var action =component.get("c.getpercentRecord");
        action.setParams({ "Id":precordId });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.configPercent", response.getReturnValue());
                component.find("oppMinPercent").set("v.value", ''+(component.get("v.configPercent.Minimum__c")));
                component.find("oppMaxPercent").set("v.value", ''+(component.get("v.configPercent.Maximum__c")));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    oppDeleteScore: function(component, event, helper){
        var action = component.get("c.deleteconfigChild");
        var parentId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        action.setParams({"parentId": parentId});
        $A.enqueueAction(action);
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        // component.updatetable();
        helper.getCChildren(component,component.get("v.tabId"), component.get("v.objectType"))
    },
    oppDeletePercent: function(component, event, helper){
        var action = component.get("c.deleteconfigPercent");
        var perId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        action.setParams({"perId": perId});
        $A.enqueueAction(action);
        //component.updatetable();
        helper.getPercent(component,component.get("v.tabId"), component.get("v.objectType"));
        
    },
    oppCancelConfigChild : function(component, event, helper){
        
        var addEditBlock = component.find("oppAddEditBlock");
        var addNewBtn = component.find("oppAddNewBtn");
        //var saveScore = component.find("saveScore");
        
        $A.util.toggleClass(addEditBlock, "slds-show");
        $A.util.toggleClass(addEditBlock, "slds-hide");
        $A.util.addClass(addNewBtn, "slds-show");
        //$A.util.removeClass(saveScore, "slds-show");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        //clearing the selected values
        component.set("v.configChild.Minimum__c",0);
        component.set("v.configChild.Maximum__c","∞");          
        
        component.set("v.configChild.Score__c",0);
        component.find("oppWarnings").set("v.value",null);
    },
    oppCancelConfigPercent:function(component, event, helper){
        var addEditBlockPercent= component.find("oppAddEditBlockPercent");
        var addPercent = component.find("oppAddPercent");
        //var savPercent = component.find("savPercent");
        
        $A.util.toggleClass(addEditBlockPercent, "slds-show");
        $A.util.toggleClass(addEditBlockPercent, "slds-hide");
        $A.util.removeClass(addPercent, "slds-hide");       
        //$A.util.removeClass(savPercent, "slds-show");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        //clearing the selected values
        component.set("v.configPercent.Minimum__c",0);
        component.set("v.configPercent.Maximum__c",100);            
        
        component.set("v.configPercent.Score__c",0);
        component.find("oppPerwarnings").set("v.value",null);
        
    },
    oppSaveConfigChild : function(component, event, helper) {
        
        var minSelected=Number(component.find("oppMinSelected").get("v.value"));        
        var maxSelected= Number(component.find("oppMaxSelected").get("v.value"));
        
        
        var currtab = component.get("v.tabId");
        var rId = component.get("v.recId");
        var currentObject = component.get("v.objectType");
        
        var action = component.get("c.saveconfigChild");
        var addEditBlock = component.find("oppAddEditBlock");
        var addNewBtn = component.find("oppAddNewBtn");
        
        
        if(maxSelected <minSelected){
            component.find("oppWarnings").set("v.value","Max Time has to be greater than Minimum Time");
        }
        else{
            component.find("oppWarnings").set("v.value",null);
            $A.util.toggleClass(addEditBlock, "slds-show");
            $A.util.toggleClass(addEditBlock, "slds-hide");
            //$A.util.removeClass(saveScore, "slds-hide");
            $A.util.removeClass(addNewBtn, "slds-hide");
            
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            
            var toast = component.find("success");
            $A.util.addClass(toast, "hideContainer");
            toast = component.find("failure");
            $A.util.addClass(toast, "hideContainer");
            
            var configChild = component.get("v.configChild");
            configChild.Minimum__c = minSelected;
            configChild.Maximum__c=maxSelected;
            action.setParams({"configChild":configChild, "type":currtab, "recordId":rId, "objectType": currentObject});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log("SAVE SUCCESS From server: " + JSON.stringify(response.getReturnValue(), null, 4));
                    toast = component.find("success");
                    $A.util.toggleClass(toast, "hideContainer");
                    
                    //clearing the selected values
                    component.set("v.recId",'');
                    component.set("v.configChild", {'sobjectType': 'SEAD_Scoring_Time__c', 'Name': '', 'Score__c':'', 'Time_Type__c':''});
                    component.find("oppMinSelected").set("v.value",0);
                    component.find("oppMaxSelected").set("v.value",99);
                    
                }
                else if (state === "INCOMPLETE") {
                    toast = component.find("failure");
                    $A.util.toggleClass(toast, "hideContainer");
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                var errorMessage = component.get("v.errorMessage");
                                component.set("v.errorMessage", errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        toast = component.find("failure");
                        $A.util.toggleClass(toast, "hideContainer");
                    }
                spinner = component.find("spinner");
                $A.util.toggleClass(spinner, "slds-hide");
            });
            
            $A.enqueueAction(action);
            //component.updatetable();
            helper.getCChildren(component,currtab, component.get("v.objectType"));
            
        }
        
        
    },
    
    oppSaveConfigPercent: function(component, event,helper) {
        
        var minPercent=Number(component.find("oppMinPercent").get("v.value"));        
        var maxPercent= Number(component.find("oppMaxPercent").get("v.value"));
        var rId = component.get("v.precId");
        var currtab = component.get("v.tabId");
        var currentObject = component.get("v.objectType");
        var action = component.get("c.saveconfigPercent");
        var addEditBlockPercent = component.find("oppAddEditBlockPercent");
        var addPercent = component.find("oppAddPercent");
        var savePercent = component.find("oppSavePercent");
        
        if(maxPercent <minPercent){
            component.find("oppPerwarnings").set("v.value","Max percentage has to be greater than Min percentage");
        }
        else{
            component.find("oppPerwarnings").set("v.value",null);
            $A.util.toggleClass(addEditBlockPercent, "slds-show");
            $A.util.toggleClass(addEditBlockPercent, "slds-hide");
            $A.util.toggleClass(savePercent, "slds-hide");
            $A.util.toggleClass(addPercent, "slds-hide");
            
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            
            var toast = component.find("success");
            $A.util.addClass(toast, "hideContainer");
            toast = component.find("failure");
            $A.util.addClass(toast, "hideContainer");
            
            var configPercent = component.get("v.configPercent");
            configPercent.Minimum__c = minPercent;
            configPercent.Maximum__c= maxPercent;
            action.setParams({"configPercent": configPercent,"type":currtab,"recordId":rId, "objectType":currentObject});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("SAVE SUCCESS From server: " + JSON.stringify(response.getReturnValue(), null, 4));
                    toast = component.find("success");
                    $A.util.toggleClass(toast, "hideContainer");
                    //clearing the values
                    component.set("v.precId", '');
                    component.set("v.configPercent", {'sobjectType': 'SEAD_Scoring_Percent__c', 'Name': '', 'Score__c':''});
                    component.find("oppMinPercent").set("v.value",0);
                    component.find("oppMaxPercent").set("v.value",100);
                }
                else if (state === "INCOMPLETE") {
                    toast = component.find("failure");
                    $A.util.toggleClass(toast, "hideContainer");
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                var errorMessage = component.get("v.errorMessage");
                                component.set("v.errorMessage", errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        toast = component.find("failure");
                        $A.util.toggleClass(toast, "hideContainer");
                    }
                spinner = component.find("spinner");
                $A.util.toggleClass(spinner, "slds-hide"); 
            });
            
            $A.enqueueAction(action);
            //component.updatetable();
            //component.updatePtable()
            
            helper.getPercent(component,component.get("v.tabId"), component.get("v.objectType"));
            
        } 
    },
    
    /*  The following section adds Opp functionality
        Created by Artyom M.
        Per Stories: B-16778, B-18406, B-18408, B-18409, B-18410
        
        END
     */ 
    
    focusLeadScore : function(component, event, helper) {


        helper.hideOppScoreBtn(component);
        helper.showSaveBtn(component);

        var leadScoreTab = component.find("leadScoreTab");
        var leadEntryExitTab = component.find("leadEntryExitTab");
        var questTab = component.find("questTab");
        var webTab = component.find("webTab");
        var custTab = component.find("custTab");
        // var saveBtn = component.find("saveBtn");
        
        // $A.util.addClass(saveBtn, "slds-show");
        
        $A.util.addClass(leadScoreTab, "slds-active");
        $A.util.removeClass(leadEntryExitTab, "slds-active");
        $A.util.removeClass(questTab, "slds-active");
        $A.util.removeClass(webTab, "slds-active");
        $A.util.removeClass(custTab, "slds-active");
        
        
        var leadScorePage = component.find("leadScorePage");
        var leadEntryExitPage = component.find("leadEntryExitPage");
        var questPage = component.find("questPage");
        
        $A.util.removeClass(leadScorePage, "slds-hide");
        $A.util.addClass(leadEntryExitPage, "slds-hide");
        $A.util.addClass(questPage, "slds-hide");
        
        $A.util.addClass(leadScorePage, "slds-show");
        $A.util.removeClass(leadEntryExitPage, "slds-show");
        $A.util.removeClass(questPage, "slds-show");
        component.set("v.tabId", 'leadScore');
        component.set("v.objectType", 'Lead');
        
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
    },
    focusLeadEntryExit : function(component, event, helper) {


        helper.hideOppScoreBtn(component);
        helper.showSaveBtn(component);
        
        var leadScoreTab = component.find("leadScoreTab");
        var leadEntryExitTab = component.find("leadEntryExitTab");
        var questTab = component.find("questTab");
        var webTab = component.find("webTab");
        var custTab = component.find("custTab");
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        // $A.util.addClass(saveBtn, "slds-show");
        $A.util.addClass(leadEntryExitTab, "slds-active");
        $A.util.removeClass(leadScoreTab, "slds-active");
        $A.util.removeClass(questTab, "slds-active");
        $A.util.removeClass(webTab, "slds-active");
        $A.util.removeClass(custTab, "slds-active");
        
        var leadScorePage = component.find("leadScorePage");
        var leadEntryExitPage = component.find("leadEntryExitPage");
        var questPage = component.find("questPage");
        
        $A.util.removeClass(leadEntryExitPage, "slds-hide");
        $A.util.addClass(leadScorePage, "slds-hide");
        $A.util.addClass(questPage, "slds-hide");
        
        $A.util.addClass(leadEntryExitPage, "slds-show");
        $A.util.removeClass(leadScorePage, "slds-show");
        $A.util.removeClass(questPage, "slds-show");
        component.set("v.tabId", 'leadEntryTab');
        component.set("v.objectType", 'Lead');
    },
    focusQuest : function(component, event, helper) {
        

        helper.hideOppScoreBtn(component);
        helper.hideSaveBtn(component);

        var leadScoreTab = component.find("leadScoreTab");
        var leadEntryExitTab = component.find("leadEntryExitTab");
        var questTab = component.find("questTab");
        var webTab = component.find("webTab");
        var custTab = component.find("custTab");
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        
        var percentBlock = component.find("percentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        
        $A.util.addClass(toast, "hideContainer");
        
        
        $A.util.addClass(percentBlock,"slds-show");
        $A.util.addClass(questTab, "slds-active");
        $A.util.removeClass(leadScoreTab, "slds-active");
        $A.util.removeClass(leadEntryExitTab, "slds-active");
        $A.util.removeClass(custTab, "slds-active");
        $A.util.removeClass(webTab, "slds-active");
        
        // $A.util.addClass(saveBtn, "slds-hide");
        // $A.util.removeClass(saveBtn, "slds-show");
        
        var leadScorePage = component.find("leadScorePage");
        var leadEntryExitPage = component.find("leadEntryExitPage");
        var questPage = component.find("questPage");
        
        $A.util.removeClass(questPage, "slds-hide");
        $A.util.addClass(leadScorePage, "slds-hide");
        $A.util.addClass(leadEntryExitPage, "slds-hide");
        
        $A.util.addClass(questPage, "slds-show");
        $A.util.removeClass(leadScorePage, "slds-show");
        $A.util.removeClass(leadEntryExitPage, "slds-show");   
        component.set("v.tabId", 'Questionnaire');
        component.set("v.objectType", 'Lead');
        
        
        helper.getCChildren(component,param, objectType);
        helper.getPercent(component,param, objectType);
    },
    
    focusWeb: function (component, event, helper) {

        helper.hideOppScoreBtn(component);
        helper.hideSaveBtn(component);

        var leadScoreTab = component.find("leadScoreTab");
        var leadEntryExitTab = component.find("leadEntryExitTab");
        var questTab = component.find("questTab");
        var webTab = component.find("webTab");
        var custTab = component.find("custTab");
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        var percentBlock = component.find("percentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        
        $A.util.addClass(toast, "hideContainer");
        $A.util.removeClass(percentBlock,"slds-show");
        $A.util.addClass(webTab, "slds-active");
        $A.util.removeClass(leadScoreTab, "slds-active");
        $A.util.removeClass(leadEntryExitTab, "slds-active");
        $A.util.removeClass(questTab, "slds-active");
        $A.util.removeClass(custTab, "slds-active");
        // $A.util.addClass(saveBtn, "slds-hide");
        // $A.util.removeClass(saveBtn, "slds-show");
        
        var leadScorePage = component.find("leadScorePage");
        var leadEntryExitPage = component.find("leadEntryExitPage");
        var questPage = component.find("questPage");
        
        $A.util.removeClass(questPage, "slds-hide");
        $A.util.addClass(leadScorePage, "slds-hide");
        $A.util.addClass(leadEntryExitPage, "slds-hide");
        
        $A.util.addClass(questPage, "slds-show");
        $A.util.removeClass(leadScorePage, "slds-show");
        $A.util.removeClass(leadEntryExitPage, "slds-show");
        
        component.set("v.tabId", 'Website');
        component.set("v.objectType", 'Lead');
        helper.getCChildren(component,param, objectType);
        helper.getPercent(component,param, objectType);
        
    },
    
    focusCust: function (component, event, helper) {


        helper.hideOppScoreBtn(component);
        helper.hideSaveBtn(component);

        var leadScoreTab = component.find("leadScoreTab");
        var leadEntryExitTab = component.find("leadEntryExitTab");
        var questTab = component.find("questTab");
        var webTab = component.find("webTab");
        var custTab = component.find("custTab");
        // var saveBtn = component.find("saveBtn");
        var toast = component.find("success");
        var percentBlock = component.find("percentBlock");
        var param = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        var objectType = event.target.getAttribute("data-object-type") || event.target.parentNode.getAttribute("data-object-type");
        $A.util.addClass(toast, "hideContainer");
        $A.util.removeClass(percentBlock,"slds-show");
        $A.util.addClass(custTab, "slds-active");
        $A.util.removeClass(leadScoreTab, "slds-active");
        $A.util.removeClass(leadEntryExitTab, "slds-active");
        $A.util.removeClass(questTab, "slds-active");
        $A.util.removeClass(webTab, "slds-active");
        // $A.util.addClass(saveBtn, "slds-hide");
        // $A.util.removeClass(saveBtn, "slds-show");
        
        var leadScorePage = component.find("leadScorePage");
        var leadEntryExitPage = component.find("leadEntryExitPage");
        var questPage = component.find("questPage");
        
        $A.util.removeClass(questPage, "slds-hide");
        $A.util.addClass(leadScorePage, "slds-hide");
        $A.util.addClass(leadEntryExitPage, "slds-hide");
        
        $A.util.addClass(questPage, "slds-show");
        $A.util.removeClass(leadScorePage, "slds-show");
        $A.util.removeClass(leadEntryExitPage, "slds-show");
        helper.getCChildren(component,param, objectType);
        helper.getPercent(component,param, objectType);
        component.set("v.tabId", 'Customer');
        component.set("v.objectType", 'Lead');
        
    },
    
    addNewScore : function(component, event, helper) {
        var addEditBlock = component.find("addEditBlock");
        var addNewBtn = component.find("addNewBtn");
        
        $A.util.toggleClass(addEditBlock, "slds-show");
        $A.util.toggleClass(addEditBlock, "slds-hide");
        
        
        $A.util.removeClass(addNewBtn, "slds-show");
        $A.util.addClass(addNewBtn, "slds-hide");
        
        var currtab = component.get("v.tabId");
        helper.getCChildren(component,currtab, component.get("v.objectType"));
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
    },
    addNewPercent : function(component, event, helper) {
        var addEditBlockPercent = component.find("addEditBlockPercent");
        var addPercent = component.find("addPercent");
        var savePercent = component.find("savePercent");
        
        $A.util.toggleClass(addEditBlockPercent, "slds-show");
        $A.util.toggleClass(addEditBlockPercent, "slds-hide");
        //$A.util.toggleClass(addPercent, "slds-hide");        
        $A.util.addClass(addPercent, "slds-hide");  
        $A.util.removeClass(addPercent, "slds-show");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
    },
    
    editScore : function(component, event, helper) {
        var addEditBlock = component.find("addEditBlock");
        var addNewBtn = component.find("addNewBtn");
        //var saveScore = component.find("saveScore");
        var recordId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        
        
        $A.util.toggleClass(addEditBlock, "slds-show");
        $A.util.toggleClass(addEditBlock, "slds-hide");
        $A.util.addClass(addNewBtn, "slds-hide");
        $A.util.removeClass(addNewBtn, "slds-show");
        
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        component.find("warnings").set("v.value",null);
        component.set("v.recId", recordId);
        
        var action =component.get("c.gettimeRecord");
        action.setParams({ "Id":recordId });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.configChild", response.getReturnValue());                 
                
                component.find("minSelected").set("v.value", ''+(component.get("v.configChild.Minimum__c")));
                component.find("maxSelected").set("v.value", ''+(component.get("v.configChild.Maximum__c")));
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    editPercent : function(component, event, helper) {
        var addEditBlockPercent= component.find("addEditBlockPercent");
        var addPercent = component.find("addPercent");
        //var savPercent = component.find("savPercent");
        var precordId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        
        
        $A.util.toggleClass(addEditBlockPercent, "slds-show");
        $A.util.toggleClass(addEditBlockPercent, "slds-hide");
        $A.util.addClass(addPercent, "slds-hide");  
        $A.util.removeClass(addPercent, "slds-show");
        
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        
        
        component.find("perwarnings").set("v.value",null);
        component.set("v.precId", precordId);
        
        var action =component.get("c.getpercentRecord");
        action.setParams({ "Id":precordId });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.configPercent", response.getReturnValue());
                component.find("minPercent").set("v.value", ''+(component.get("v.configPercent.Minimum__c")));
                component.find("maxPercent").set("v.value", ''+(component.get("v.configPercent.Maximum__c")));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    deleteScore: function(component, event, helper){
        var action = component.get("c.deleteconfigChild");
        var parentId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        action.setParams({"parentId": parentId});
        $A.enqueueAction(action);
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        // component.updatetable();
        helper.getCChildren(component,component.get("v.tabId"), component.get("v.objectType"))
    },
    deletePercent: function(component, event, helper){
        var action = component.get("c.deleteconfigPercent");
        var perId = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data");
        action.setParams({"perId": perId});
        $A.enqueueAction(action);
        //component.updatetable();
        helper.getPercent(component,component.get("v.tabId"), component.get("v.objectType"));
        
    },
    cancelConfigChild : function(component, event, helper){
        
        var addEditBlock = component.find("addEditBlock");
        var addNewBtn = component.find("addNewBtn");
        //var saveScore = component.find("saveScore");
        
        $A.util.toggleClass(addEditBlock, "slds-show");
        $A.util.toggleClass(addEditBlock, "slds-hide");
        $A.util.addClass(addNewBtn, "slds-show");
        //$A.util.removeClass(saveScore, "slds-show");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        //clearing the selected values
        component.set("v.configChild.Minimum__c",0);
        component.set("v.configChild.Maximum__c","∞");          
        
        component.set("v.configChild.Score__c",0);
        component.find("warnings").set("v.value",null);
    },
    cancelConfigPercent:function(component, event, helper){
        var addEditBlockPercent= component.find("addEditBlockPercent");
        var addPercent = component.find("addPercent");
        //var savPercent = component.find("savPercent");
        
        $A.util.toggleClass(addEditBlockPercent, "slds-show");
        $A.util.toggleClass(addEditBlockPercent, "slds-hide");
        $A.util.removeClass(addPercent, "slds-hide");       
        //$A.util.removeClass(savPercent, "slds-show");
        var toast = component.find("success");
        $A.util.addClass(toast, "hideContainer");
        //clearing the selected values
        component.set("v.configPercent.Minimum__c",0);
        component.set("v.configPercent.Maximum__c",100);            
        
        component.set("v.configPercent.Score__c",0);
        component.find("perwarnings").set("v.value",null);
        
    },
    saveConfigChild : function(component, event, helper) {
        
        var minSelected=Number(component.find("minSelected").get("v.value"));        
        var maxSelected= Number(component.find("maxSelected").get("v.value"));
        
        
        var currtab = component.get("v.tabId");
        var rId = component.get("v.recId");
        var currentObject = component.get("v.objectType");
        
        var action = component.get("c.saveconfigChild");
        var addEditBlock = component.find("addEditBlock");
        var addNewBtn = component.find("addNewBtn");
        
        
        if(maxSelected <minSelected){
            component.find("warnings").set("v.value","Max Time has to be greater than Minimum Time");
        }
        else{
            component.find("warnings").set("v.value",null);
            $A.util.toggleClass(addEditBlock, "slds-show");
            $A.util.toggleClass(addEditBlock, "slds-hide");
            //$A.util.removeClass(saveScore, "slds-hide");
            $A.util.removeClass(addNewBtn, "slds-hide");
            
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            
            var toast = component.find("success");
            $A.util.addClass(toast, "hideContainer");
            toast = component.find("failure");
            $A.util.addClass(toast, "hideContainer");
            
            var configChild = component.get("v.configChild");
            configChild.Minimum__c = minSelected;
            configChild.Maximum__c=maxSelected;
            action.setParams({"configChild":configChild, "type":currtab, "recordId":rId, "objectType": currentObject});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log("SAVE SUCCESS From server: " + JSON.stringify(response.getReturnValue(), null, 4));
                    toast = component.find("success");
                    $A.util.toggleClass(toast, "hideContainer");
                    
                    //clearing the selected values
                    component.set("v.recId",'');
                    component.set("v.configChild", {'sobjectType': 'SEAD_Scoring_Time__c', 'Name': '', 'Score__c':'', 'Time_Type__c':''});
                    component.find("minSelected").set("v.value",0);
                    component.find("maxSelected").set("v.value",99);
                    
                }
                else if (state === "INCOMPLETE") {
                    toast = component.find("failure");
                    $A.util.toggleClass(toast, "hideContainer");
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                var errorMessage = component.get("v.errorMessage");
                                component.set("v.errorMessage", errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        toast = component.find("failure");
                        $A.util.toggleClass(toast, "hideContainer");
                    }
                spinner = component.find("spinner");
                $A.util.toggleClass(spinner, "slds-hide");
            });
            
            $A.enqueueAction(action);
            //component.updatetable();
            helper.getCChildren(component,currtab, component.get("v.objectType"));
            
        }
        
        
    },
    
    saveConfigPercent: function(component, event,helper) {
        
        var minPercent=Number(component.find("minPercent").get("v.value"));        
        var maxPercent= Number(component.find("maxPercent").get("v.value"));
        var rId = component.get("v.precId");
        var currtab = component.get("v.tabId");
        var currentObject = component.get("v.objectType");
        var action = component.get("c.saveconfigPercent");
        var addEditBlockPercent = component.find("addEditBlockPercent");
        var addPercent = component.find("addPercent");
        var savePercent = component.find("savePercent");
        
        if(maxPercent <minPercent){
            component.find("perwarnings").set("v.value","Max percentage has to be greater than Min percentage");
        }
        else{
            component.find("perwarnings").set("v.value",null);
            $A.util.toggleClass(addEditBlockPercent, "slds-show");
            $A.util.toggleClass(addEditBlockPercent, "slds-hide");
            $A.util.toggleClass(savePercent, "slds-hide");
            $A.util.toggleClass(addPercent, "slds-hide");
            
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            
            var toast = component.find("success");
            $A.util.addClass(toast, "hideContainer");
            toast = component.find("failure");
            $A.util.addClass(toast, "hideContainer");
            
            var configPercent = component.get("v.configPercent");
            configPercent.Minimum__c = minPercent;
            configPercent.Maximum__c= maxPercent;
            action.setParams({"configPercent": configPercent,"type":currtab,"recordId":rId, "objectType":currentObject});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("SAVE SUCCESS From server: " + JSON.stringify(response.getReturnValue(), null, 4));
                    toast = component.find("success");
                    $A.util.toggleClass(toast, "hideContainer");
                    //clearing the values
                    component.set("v.precId", '');
                    component.set("v.configPercent", {'sobjectType': 'SEAD_Scoring_Percent__c', 'Name': '', 'Score__c':''});
                    component.find("minPercent").set("v.value",0);
                    component.find("maxPercent").set("v.value",100);
                }
                else if (state === "INCOMPLETE") {
                    toast = component.find("failure");
                    $A.util.toggleClass(toast, "hideContainer");
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                var errorMessage = component.get("v.errorMessage");
                                component.set("v.errorMessage", errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        toast = component.find("failure");
                        $A.util.toggleClass(toast, "hideContainer");
                    }
                spinner = component.find("spinner");
                $A.util.toggleClass(spinner, "slds-hide"); 
            });
            
            $A.enqueueAction(action);
            //component.updatetable();
            //component.updatePtable()
            
            helper.getPercent(component,component.get("v.tabId"), component.get("v.objectType"));
            
        } 
    },
    
    saveConfig : function(component, event, helper) {
        // var action = component.get("c.updateConfig");

        helper.saveConfigHelper(component, 'Default');
    },

    switchOnboardOpp : function(cmp, evt, hlp) {
        console.log('---in switchOnboardOpp');
         var selectedOption = cmp.find('switchOnboardSelect').get('v.value');
        cmp.set("v.switchOnboardingOpp",selectedOption);
        console.log('---in calling helper');
            // hlp.getConfigINCHelper(cmp, selectedOption);
            hlp.getConfigOppOnboardScoringHelper(cmp);
    },

    saveConfigOppOnboardScoring : function(cmp, evt, hlp) {
            hlp.saveConfigHelper(cmp, cmp.get("v.switchOnboardingOpp"));
    }
})