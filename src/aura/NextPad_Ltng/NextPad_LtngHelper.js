({
	loadContact : function(component, event, helper) {
	
		var processingNumber = component.get("v.processingNumber");
		var customerOrderNumber = component.get("v.customerOrderNumber");
		var orderItemNumber = component.get("v.orderItemNumber");
		
		var action = component.get("c.getContactName");

        action.setParams({"theProcessingNumber" : processingNumber, "orderItemId" : orderItemNumber, "thecustomerOrderNumber" : customerOrderNumber});
        action.setCallback(this, function(response) {
            console.log('inside getContactName');
            var state = response.getState();
            console.log('state = ' + state);
            if (state === "SUCCESS") {
            	console.log('state SUCCESS = ' + response.getReturnValue());
            	var contact = response.getReturnValue();
                component.set("v.contact", contact);
            }
            else {
            	var title = "Error";
                var type = "error";
                var message = "An error occured: Please refresh and try again!";
                helper.showToast(component, event, helper, title, type, message);
                console.log("Failed with state: " + state); 
            }
           
        });
        $A.enqueueAction(action);
	
	},
	loadExistingData : function(component, event, helper) {
		console.log('inside loadExistingData');
		var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        
		var processingNumber = component.get("v.processingNumber");
		var customerOrderNumber = component.get("v.customerOrderNumber");
		var orderItemNumber = component.get("v.orderItemNumber");
		var field = component.get("v.sortField");
		var sortingOrder = component.get("v.sortOrder");
		var filterBy = component.get("v.filter");

		
		console.log('inside loadExistingData: ' + processingNumber + customerOrderNumber + orderItemNumber + " " + field + " " + sortingOrder + " " + filterBy);
		var action = component.get("c.getDataSortedBy");
        
        action.setParams({"theProcessingNumber" : processingNumber, "orderItemId" : orderItemNumber , 
        "thecustomerOrderNumber" : customerOrderNumber, "sortingField" : field, "sortingOrder" : sortingOrder, "filter" : filterBy});
        
        action.setCallback(this, function(response) {
            console.log('inside setCallback');
            var state = response.getState();
            console.log('state = ' + state);
            
            if (state === "SUCCESS") {
             console.log('state SUCCESS = ' + response.getReturnValue());
                var notes = response.getReturnValue();
                component.set("v.allNotes", notes);

                
            }
            else {
            /**/
               var title = "Error";
               var type = "error";
               var message = "An error occured: Please refresh and try again!";
                this.showToast(component, event, helper, title, type, message);
                console.log("Failed with state: " + state); 
            }
            this.toggleSpinner(component, event);
            
        });
        $A.enqueueAction(action);
        
	},
	sortByH : function(component, event, helper, param) {
		console.log('inside sortBy');
        var RecentID = component.find('RecentID');
        var OldestID = component.find('OldestID');
        var CreatedID = component.find('CreatedID');
        
        $A.util.removeClass(RecentID, 'selected');
        $A.util.removeClass(OldestID, 'selected');
        $A.util.removeClass(CreatedID, 'selected');
        $A.util.addClass(RecentID, 'notSelected');
        $A.util.addClass(OldestID, 'notSelected');
        $A.util.addClass(CreatedID, 'notSelected');
		
		console.log('inside sortBy1');
		if (param === "Recent") {
            
        	$A.util.removeClass(RecentID, 'notSelected');
        	$A.util.addClass(RecentID, 'selected');
            
            
			component.set("v.sortField", "date");
			component.set("v.sortOrder", "descending");
			//component.set("v.filter", "descending");
			helper.loadExistingData(component, event, helper);
			//
		}
		
		if (param === "Oldest") {
            $A.util.removeClass(OldestID, 'notSelected');
        	$A.util.addClass(OldestID, 'selected');
            
			component.set("v.sortField", "date");
			component.set("v.sortOrder", "ascending");
			//component.set("v.filter", "ascending");
			helper.loadExistingData(component, event, helper);
		}
		
		if (param === "Created by") {
            $A.util.removeClass(CreatedID, 'notSelected');
        	$A.util.addClass(CreatedID, 'selected');
            
			component.set("v.sortField", "name");
			component.set("v.sortOrder", "ascending");
			//component.set("v.filter", "ascending");
			helper.loadExistingData(component, event, helper);
		} 
	},
	
	filterByH : function(component, event, helper, param) {
		console.log('inside filterBy');
        
        var AllID = component.find('AllID');
        var CaseID = component.find('CaseID');
        var NotesID = component.find('NotesID');
        
        $A.util.removeClass(AllID, 'selected');
        $A.util.removeClass(CaseID, 'selected');
        $A.util.removeClass(NotesID, 'selected');
        $A.util.addClass(AllID, 'notSelected');
        $A.util.addClass(CaseID, 'notSelected');
        $A.util.addClass(NotesID, 'notSelected');
        
		

		if (param === "All") {
            $A.util.removeClass(AllID, 'notSelected');
        	$A.util.addClass(AllID, 'selected');
            
			component.set("v.filter", "all");
			helper.loadExistingData(component, event, helper);
		}
		
		if (param === "Case") {
            $A.util.removeClass(CaseID, 'notSelected');
        	$A.util.addClass(CaseID, 'selected');
            
			component.set("v.filter", "cases");
			helper.loadExistingData(component, event, helper);
		}
		
		if (param === "Order Notes") {
            $A.util.removeClass(NotesID, 'notSelected');
        	$A.util.addClass(NotesID, 'selected');
            
			component.set("v.filter", "notes");
			helper.loadExistingData(component, event, helper);
		} 

		
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
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        console.log('path url: '+window.location.href);
        
        var parentTabUrl = '/lightning/r/Order__c/' + component.get("v.orderRecordId") + '/view';
        console.log('parentTabUrl: '+parentTabUrl);
        console.log('subtaburl: '+subtaburl);
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.openTab({
            url: parentTabUrl,
            focus: false
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: subtaburl,
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: tabLabel
                }).then(function(response){
                    console.log('the tab Id to set label'+response.tabId);
                    workspaceAPI.setTabIcon({
                        tabId: response.tabId,
                        icon: tabIcon,
                        iconAlt: tabIcon
                    });
                }).catch(function(error) {
                    console.log('Error: '+error);
                });
            }).catch(function(error) {
                console.log('Error: '+error);
            });
        })
        .catch(function(error) {
            console.log('Error: '+error);
        });
    }
	
})