({
  // Fetch the SEAD config child from the Apex controller
  getCChildren: function(component, tabval, objectType ) {
      var action = component.get('c.getScoringChildren');     
    
      // Set up the callback
      var self = this;
      var test = "Testo";
      action.setParams({"param": tabval, "objectType": objectType});
      action.setCallback(this, function(actionResult) {
       component.set('v.configChildren', actionResult.getReturnValue());
          
      });
    
      $A.enqueueAction(action); 
  },
  
 // Fetch the SEAD cnfig percent from apex controller
 getPercent: function(component,val, objectType) {
  var action = component.get('c.getpercentage');

  // Set up the callback
  var self = this;
  action.setParams({"param":val, "objectType": objectType}); 
  action.setCallback(this, function(actionResult) {
   component.set('v.configPercentage', actionResult.getReturnValue());
  });
  $A.enqueueAction(action);
},

getConfigOppOnboardScoringHelper : function(cmp) {
      console.log('---in helper');
  var action = cmp.get("c.getConfigByName");
  action.setParams({
      "seadConfigName": cmp.get("v.switchOnboardingOpp")
  });
  action.setCallback(this, function(res) {
      var state = res.getState();
      console.log('---state',state);
      if(state === "SUCCESS"){
      console.log('---res',res.getReturnValue());
          cmp.set("v.configOnBoardingScoring", res.getReturnValue());
      }
  });
  $A.enqueueAction(action);
},

saveConfigHelper : function(cmp, selectedValue, hlp) {

  var configRec = selectedValue === 'Default' ? cmp.get('v.config') : cmp.get('v.configOnBoardingScoring');
  var isOppOnboaringScore = selectedValue === 'Default' ? false : true;

      var action = cmp.get("c.updateConfig");
       action.setParams({
          "config" : configRec,
          "isOppOnboardScoring" : isOppOnboaringScore
       });
      var spinner = cmp.find("spinner");
      $A.util.toggleClass(spinner, "slds-hide");
      
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              toast = cmp.find("success");
              $A.util.removeClass(toast, "hideContainer")
              $A.get('e.force:refreshView').fire();
          }
          else if (state === "INCOMPLETE") {
              toast = cmp.find("failure");
              $A.util.removeClass(toast, "hideContainer");
          }
          else if (state === "ERROR") {
              var errors = response.getError();
              if (errors) {
                  if (errors[0] && errors[0].message) {
                      console.log("Error message: " + errors[0].message);
                      var errorMessage = cmp.get("v.errorMessage");
                      cmp.set("v.errorMessage", errors[0].message);
                  }
              } else {
                  console.log("Unknown error");
              }
              toast = cmp.find("failure");
              $A.util.removeClass(toast, "hideContainer");
              }
          spinner = cmp.find("spinner");
          $A.util.toggleClass(spinner, "slds-hide");
          window.setTimeout(
                  $A.getCallback(function() {
                      $A.util.addClass(toast, "hideContainer")
                  }), 5000);
      });
      $A.enqueueAction(action);

      this.initializeHelper(cmp);
},

hideOppScoreBtn : function(cmp)
{
  var saveOppBtn = cmp.find("saveOppOnboardBtn");
      $A.util.removeClass(saveOppBtn, "slds-show");
      $A.util.addClass(saveOppBtn, "slds-hide");
},


showSaveBtn : function(cmp)
{
  var saveBtn = cmp.find("saveBtn");
      $A.util.addClass(saveBtn, "slds-show");
      $A.util.removeClass(saveBtn, "slds-hide");
},


hideSaveBtn : function(cmp)
{
  var saveBtn = cmp.find("saveBtn");
      $A.util.removeClass(saveBtn, "slds-show");
      $A.util.addClass(saveBtn, "slds-hide");
},

initializeHelper: function(component) {
  var action = component.get("c.getConfig");
      
      
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              console.log("GET SUCCESS From server: " +  JSON.stringify(response.getReturnValue(), null, 4));
              component.set("v.config", response.getReturnValue());
              
              var numList = [];
              var maxNum = 60;
              
              for(var i =0; i <= maxNum; i++){
                  numList.push(i);
              }
              component.set("v.selectOptions", numList);
              
              var percent =[];
              var maxPercent = 100;
              for(var i =0; i <= maxPercent; i++){
                  percent.push(i);
              }
              component.set("v.selectOptionsPercentage", percent);
              
              //helper.getChildren(component, component.get("v.config"));
              //helper.getCChildren(component, component.get("v.tabId"));
              //helper.getPercent(component, component.get("v.tabId"));
              
              
              
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
              }
      });
      $A.enqueueAction(action);
}
})