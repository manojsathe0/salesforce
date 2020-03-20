/*
Migration of NextPad functionality to Salesforce
Story: B-26835
By Artyom M.
*/

({
	doInit : function(component, event, helper) {
            console.log('inside init method Ledger(NextPad)');
            console.log(window.location.href);
            
            var appUrl = window.location.href;
            if(appUrl.includes("Ledger"))
            {    
                component.set("v.isLedgerApp", true);
                var sURLAndParams = appUrl.split('?');
                console.log('sURLAndParams: '+sURLAndParams);
                var sParams = sURLAndParams[1].split('&');
                console.log('sParams: '+sParams);
                var sParameterName;
                var processingNumber;
                var customerOrderNumber;
                var orderItemNumber;
                var orderRecordId;
                for (var i = 0; i < sParams.length; i++) {
                    sParameterName = sParams[i].split('='); //to split the key from the value.
                    console.log('sParameterName: '+sParameterName);
                    if(sParameterName[0] === 'processingNumber'){
                        processingNumber = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }else if(sParameterName[0] === 'customerOrderNumber'){
                        customerOrderNumber = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }else if(sParameterName[0] === 'orderItemNumber'){
                        orderItemNumber = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }else if(sParameterName[0] === 'orderRecordId'){
                        orderRecordId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }
                }
                component.set("v.processingNumber", processingNumber);
                component.set("v.customerOrderNumber", customerOrderNumber);
                component.set("v.orderItemNumber", orderItemNumber);
                component.set("v.orderRecordId", orderRecordId);
                
                console.log('processingNumber ' + processingNumber);
                console.log('customerOrderNumber ' + customerOrderNumber);
                console.log('orderItemNumber ' + orderItemNumber);
                console.log('orderRecordId ' + orderRecordId);
                
                helper.loadExistingData(component, event, helper);
                helper.filterByH(component, event, helper, "All");
                helper.sortByH(component, event, helper, "Recent");
            }
	},
	
	openRecordDetail : function(component, event, helper) {
        console.log('inside openRecordDetail');
		var sObjectId = event.target.getAttribute("data-id");
        var objectName = event.target.getAttribute("data-objectName");
		var label = event.target.getAttribute("data-label");
        console.log('Params: ' + sObjectId + '  ' + label);
        var subtaburl;
        if(objectName != 'CaseComments'){
        	subtaburl = '/lightning/r/' + objectName + '/' + sObjectId + '/view';
        }else{
            subtaburl = '/lightning/r/' + sObjectId + '/related/CaseComments/view';
        }
        var tabLabel = label;
        var tabIcon = 'edit';		
		if(component.get("v.isLedgerApp")){
            window.open(subtaburl);
        }else{
            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
        }	
	},
	
	clear : function(component, event, helper) {
		console.log('inside clear');
		
		component.set("v.descriptionArea", "");
	},
	
	submit : function(component, event, helper) {
		var processingNumber = component.get("v.processingNumber");
		var customerOrderNumber = component.get("v.customerOrderNumber");
		var orderItemNumber = component.get("v.orderItemNumber");
		
		var descriptionArea = component.get("v.descriptionArea");
		var selectedObject = component.get("v.selectedObject");
		if (descriptionArea === "" || descriptionArea === undefined) {
			helper.showToast(component, event, helper, "Error occured", "warning", "Please enter description");
			return;
		}
		
		var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        
		console.log('inside submitRecord');
		var action = component.get("c.submitRecord");

        action.setParams({
            "theProcessingNumber" : processingNumber, 
            "orderItemId" : orderItemNumber , 
        	"thecustomerOrderNumber" : customerOrderNumber, 
            "description" : descriptionArea, 
            "objectType" : selectedObject,
            "createdBy" : '' //should be empty when invoked from Lightning component.. field reference created for api purposes
        });
        
        action.setCallback(this, function(response) {
            console.log('inside setCallback');
            var state = response.getState();
            console.log('state = ' + state);
            if (state === "SUCCESS") {
            	console.log('state SUCCESS = ' + response.getReturnValue());

                helper.loadExistingData(component, event, helper);
                helper.toggleSpinner(component, event);
                component.set("v.descriptionArea", "");
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
    filterBy : function(component, event, helper) {
        var param = event.target.getAttribute("data-filter");
        helper.filterByH(component, event, helper, param);
        
    },
    sortBy : function(component, event, helper) {
        var param = event.target.getAttribute("data-order");
        helper.sortByH(component, event, helper, param);
    },
    
	
	
	open_NextPadModal : function(component, event, helper){
        console.log('Inaide open_NextPadModal. line 174');
        var nextPadModalPanel = component.find('nextPadModalPanel');
        console.log(nextPadModalPanel);
        var params = event.getParam('arguments');
        
        component.set("v.processingNumber", params.processingNumber_arg);
		component.set("v.customerOrderNumber", params.customerOrderNumber_arg);
		component.set("v.orderItemNumber", params.orderItemNumber_arg);
        component.set("v.orderRecordId", params.orderRecordId_arg);
		console.log('var1 ' + params.processingNumber_arg);
        console.log('var2 ' + params.customerOrderNumber_arg);
        console.log('var3 ' + params.orderItemNumber_arg);
        console.log('var4 ' + params.orderRecordId_arg);
        
		//helper.loadContact(component, event, helper);
        helper.loadExistingData(component, event, helper);
        helper.filterByH(component, event, helper, "All");
        helper.sortByH(component, event, helper, "Recent");
        //helper.getVersions(component, params.processingNumberParam, helper);
        $A.util.addClass(nextPadModalPanel, 'showOrderHistory');
        $A.util.removeClass(nextPadModalPanel, 'hideOrderHistory');
    },
    
    close_NextPadModal : function(component, event, helper){
        var nextPadModalPanel = component.find('nextPadModalPanel');
        console.log(nextPadModalPanel);

        $A.util.addClass(nextPadModalPanel, 'hideOrderHistory');
        $A.util.removeClass(nextPadModalPanel, 'showOrderHistory');
    },
    
    
    goToArchive : function(component, event, helper) {
    	var url = "http://zoomreports/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/Reports/Operations/SalesforceCaseComments.rdl&rv:ParamMode=Hidden&rp:ProcessingNumber=";
		window.open(url+component.get("v.processingNumber"));
	}
})