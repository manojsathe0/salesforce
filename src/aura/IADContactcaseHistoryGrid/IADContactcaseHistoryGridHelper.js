({
    setFocusedTabLabel : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "ALL Cases"
            }); 
            var taburl = response.url;
            
            if(taburl.includes("?")){
                var sURLAndParams = taburl.split('?');
                console.log('sURLAndParams: '+sURLAndParams);
                var sParams = sURLAndParams[1].split('&');
                console.log('sParams: '+sParams);
                var sParameterName;
                var contactId;
                
                for (var i = 0; i < sParams.length; i++) {
                    sParameterName = sParams[i].split('='); //to split the key from the value.
                    console.log('sParameterName: '+sParameterName);
                    if(sParameterName[0] === 'contactid'){
                        contactId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }
                }
                helper.setFocusedTabIcon(component,event ,helper);
                helper.getAllCases(component,event,helper,contactId);
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    getOpenedTabURL : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getTabURL({
            tabId: response
        }).then(function(response) {
            
            console.log(response);
        })
        
        .catch(function(error) {
            console.log(error);
        });
    },
    
    getAllCases : function(component,event ,helper,contactid)
    {
        helper.getfieldlabel(component,event,helper,contactid);
    },
    
    intial :function(component,event ,helper,contactid)
    {
        var action =component.get("c.intialsetup");
        action.setParams({ recid : contactid });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('Thefresponse'+JSON.stringify(response.getReturnValue()));
                component.set('v.numberofcases',response.getReturnValue().length);
                component.set("v.problemCasesAll",response.getReturnValue());
                helper.toggle(component,event);
                //helper.getfieldpath(component,event,helper);
                
            }
            
        });
        $A.enqueueAction(action);   
    },
    
    getfieldpath : function(component,event,helper)
    {
        var action =component.get("c.getFieldPaths");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('the paths '+response.getReturnValue() );
                component.set("v.fieldpaths",response.getReturnValue());
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getfieldlabel : function(component,event,helper,contactid)
    {
        var action =component.get("c.getFieldLabels");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('the labels '+response.getReturnValue() );
                component.set("v.fieldlabels",response.getReturnValue()); 
                helper.intial(component,event,helper,contactid);
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    sortBy: function(component, field) {
        
        if(field=='Case Number')
            field ='CaseNumber';
        if(field=='Record Type ID')
            field='RecordTypeId';
        if(field=='created date')
            field ='created_date__c';
        if(field=='Product Category')
            field ='Product_Line__c';
        if(field=='Product')
            field='Product2__c';
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.problemCasesAll");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.problemCasesAll", records);
    },
    
    setFocusedTabIcon : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:case",
                iconAlt: "Cases"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})