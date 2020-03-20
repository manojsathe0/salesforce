/*
(default customization: out of the box functionality)
Implement out of the box logic. Includes IWS events handling, event routing, search calls, screen pop calls.

Listens to events:
"workspace/message"

*/

(function(window, jQuery, undefined) {

var _log = Log ? Log.log : console.log;

jQuery.subscribe("workspace/message", processMessage);


function createAttDataArray(userData) {
	var businessAttributes = Workspace.getBusinessAttributes();
	var attData = new Array();
	$.each(userData, function(key, value) {
		if (! (key in businessAttributes)) {
			return;
		}
		var attr = $.extend(true, {}, businessAttributes[key]);
		attr.value = value;
		attData.push(attr);
	});
	return attData;
}

function showAttachedData(userData) {
    if (!userData) {
    	return;
    }

    Connector.showAttachedData(createAttDataArray(userData));
    if(Workspace.getAutoOpenDataDisplay == 'true')
    	sforce.interaction.setVisible(true);
}

////////////////////////////////////////////////////////////////////////////////////////
// event processing
//
// processMessage is called for all received communications from Interaction Workspace
// that contains valid work to be performed.
////////////////////////////////////////////////////////////////////////////////////////

function processMessage(obj) {
    if (obj.action == "OpenObject") {
        _log("in OpenObject");
        
    	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
    	{
    		var Genesys_activeInteraction = (obj.id === undefined) ? "" : obj.id;
    		window.sessionStorage.setItem("Genesys_activeInteraction", Genesys_activeInteraction);
    		_log("setting Genesys_activeInteraction = " + Genesys_activeInteraction);
    	}
        if(Salesforce.inServiceCloudConsole())
        	showAttachedData(obj.userData);

        // open based on type attribute
        if (obj.type == "Voice") {
            // if we have a userData attribute of MainMenu, then go to case processing
            if (obj.userData.MainMenu !== undefined) {
                _log("processMessage: Voice Case handling for menu = " + obj.userData.MainMenu);
                performCaseAction(obj);
            } else {
                // Inbound or internal voice
                //if (obj.calltype == "Inbound" || obj.calltype == "Internal") {
                if (obj.calltype == "Inbound" || obj.calltype == "Internal" || obj.calltype == "Consult") {
                    _log("processMessage: Inbound Voice handling for caller ID = " + obj.source);
                    performInboundVoiceAction(obj);
                }

                // Outbound voice
                if (obj.calltype == "Outbound") {
                    // attempt to open on outbound
                    _log("processMessage: Outbound Voice handling for party = " + obj.destination);
                    performOutboundVoiceAction(obj);
                }
                if (obj.calltype == "Unknown") {
                    _log("processMessage: Unknown, clickToDialNum = " + clickToDialNum + ", destination = " + obj.destination);
                    clickToDialNum = "";
                    //performOutboundVoiceAction(obj);
                }
            }
        }
        else if (obj.type == "Email") {
            _log("processMessage: Email pop action");
            performEmailAction(obj);
        }
        else if (obj.type == "Chat") {
            _log("processMessage: Chat pop action");
            performChatAction(obj);
        }
        else if (obj.type == "InteractionWorkItem") {
            _log("processMessage: Workitem pop action for mediaType: " + obj.mediaType);
            performWorkItemAction(obj);
        }
        else if (obj.type == "Sms") {
            _log("processMessage: Sms pop action");
            performSmsAction(obj);
        }
        else if (obj.type == "WebCallback") {
            _log("processMessage: WebCallback pop action");
            performWebCallbackAction(obj);
        }
        else if (obj.type == "OpenMedia") {
            _log("processMessage: OpenMedia pop action");
            performOpenMediaAction(obj);
        }

    }
    else if (obj.action == "CreateActivity") {
    	//LZ - Activity is created at the beginning of the interaction
    	//this is really a request to update that activity
    	lz_update_activity(obj);
    	return;
    	
    	//var ixnId = Salesforce.getIxnId(obj.id);
    	var objectIdForActivity = "";
    	
    	//TODO 
        //_log("CreateActivity for connID " + obj.id + " delete Windows - " + ixnId);
        //Salesforce.removeIxnWindow(ixnId);
    	
    	var activityCallType = (obj.userData.activityCallType === undefined) ? "" : obj.userData.activityCallType;
    	if(activityCallType == "Consult"){
    		_log("activityCallType = " + activityCallType + ", don't create activity");
    		return;
    	}

    	var useFocusedRecord = obj.useFocusedRecord;
    	_log("useFocusedRecord " + useFocusedRecord);
	    
    	if(useFocusedRecord!=null && (useFocusedRecord=="True" || useFocusedRecord=="true") && (!Salesforce.inServiceCloudConsole()))
    	{
	    	sforce.interaction.getPageInfo(function(o) {
	    		if(o!=null && o.result!=null)
	    		{ 
	    			var jsonResult = jQuery.parseJSON(o.result);
	    			if(jsonResult!=null && jsonResult.objectId!=null)
	    			{
			            objectIdForActivity = jsonResult.objectId;
				        _log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);
				
				        // create the task
				        createTask(obj, objectIdForActivity);	    			
	    				return;
	    			}
	    		}
    			prepareCreateTask(obj, objectIdForActivity);
	    	});	    
	    	clickToDialNum = "";
	    	return;
    	}
    	else
    	{
	        //check for attached data sfdcObjectId - if it is there, then use that
	        if (obj.userData.sfdcObjectId != null) 
	        {
	            objectIdForActivity = obj.userData.sfdcObjectId;
		        _log("CreateActivity for voice using object " + objectIdForActivity);
		
		        // create the task
		        createTask(obj, objectIdForActivity);
		        
		        clickToDialNum = "";
	    		return;		        	    
	        }
    	}
    	prepareCreateTask(obj, objectIdForActivity);
    }
    else if (obj.action == "MarkedDone") {
    	//TODO
    	//var ixnId = Salesforce.getIxnId(obj.id);
        //_log("MarkedDone for connID " + obj.id + " delete Windows - " + ixnId);
        //Salesforce.removeIxnWindow(ixnId);
    }
    else if (obj.action == "FocusTab") {
        _log("FocusTab for " + obj.id);
        //TODO
        //Salesforce.focusIxnTab(obj.id);
    }
    else if (obj.action == 'ConnectionDenied') {
    	//PJB: Don't reconnect if denied
    	_log("Connection denied, do not retry");
    	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
    	{
    		window.sessionStorage.setItem("Genesys_sfdc_Banned", "True");
    	}
    }
    else if (obj.action == 'PerformSFDCRequest') {
    	_log("PerformSFDCRequest");
    }    
    
    clickToDialNum = "";
}

//PJB: Moved some code that I would have had to move to a function to create the task
function prepareCreateTask(obj, objectIdForActivity)
{
	if (obj.type == "Voice")
	{        		
    	var lookupNumber='';
        if (obj.calltype == "Inbound" || obj.calltype == "Internal"  || obj.calltype=="Consult" || obj.calltype=="Conference") {
		    lookupNumber = obj.source;
		    if (obj.role == 'RoleOrigination') {
		        lookupNumber = obj.destination;
		    }
		}
		else if(obj.calltype == "Outbound") {
            lookupNumber = obj.destination;
        }
		
		if(obj.userData.CaseNumber !== undefined)
		{
			_log("CreateActivity for voice under User since CaseNumber processing did not yield a match");
			createTask(obj, objectIdForActivity);
			return;
		}
		
		if(obj.fieldName != undefined && obj.fieldValue != undefined){
        	var searchFieldName = obj.fieldName;
        	var searchFieldValue = obj.fieldValue;
        	_log("CreateActivity for voice using search field " + searchFieldName + " for a value of " + searchFieldValue);
        	 g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {
        	     if (o != null) {
		      			objectIdForActivity = o.Id;
		      			_log("Id found " + objectIdForActivity);
        	     } else {
        	    	 	_log("Id not found ");
        	     }
 	             _log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);
	             createTask(obj, objectIdForActivity);
        	 });
        }
		else{		
			_log("CreateActivity for voice with lookup " + lookupNumber);
			
	        g_WorkspaceConnectorController.findObjectFromANI(lookupNumber, function(o) {
	            if (o != null) {
		      		if(o != 'not found' && o != 'multiple found')
		      		{
		      			objectIdForActivity = o.Id;
		      			_log("Id found " + objectIdForActivity);
		      		}
		      		else if(o == 'multiple found')
					{
						_log("Multiple results");
						//find the one with the most recent completed activity and create the task there
						//findMostRecentlyCompletedActivity(lookupNumber, false, obj.id, obj);
						//return;
					}
	            }
	            else
	            {
	            	_log("No results");
	            }		
	            _log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);
	            createTask(obj, objectIdForActivity);		            
			});
		}
		clickToDialNum = "";
		return;
	}

    _log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);

    // create the task
    createTask(obj, objectIdForActivity);
}

////////////////////////////////////////////////////////////////////////////////////////
// Inbound and Outbound Voice handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for inbound voice. If role is RoleDestination, then this is inbound, if
// RoleOrigination, then it is an manual outbound dial
function performInboundVoiceAction(obj) {
    _log("in performInboundVoiceAction()");
    
    var callDirection = 'Inbound';
    // determine number to use based on role
    _log("Role is " + obj.role);
    var lookupNumber = obj.source;
    if (obj.role == 'RoleOrigination') {
        lookupNumber = obj.destination;
    }
	if(obj.calltype == "Consult" && obj.userData.primaryANI != undefined && obj.userData.primaryANI != ""){
		_log("Using primaryANI from Consult");
		lookupNumber = obj.userData.primaryANI;
		callDirection='Consult';
	}

	//LZ check for Sales or CC
	var LZCallType = (obj.userData.CallType === undefined) ? "" : obj.userData.CallType;
	perform_voice_screenpop(obj, lookupNumber, callDirection, LZCallType);
}

function perform_voice_screenpop(obj, lookupNumber, direction, LZCallType){
	//don't create a new lead for outgoing calls
	var createNewLead=false;	
	if(direction==='Inbound' || direction==='Consult')
		createNewLead=true;

    // if contains a CaseNumber attached data, pop on it
    if (obj.userData.CaseNumber !== undefined) {
        g_WorkspaceConnectorController.findCaseFromNumber(obj.userData.CaseNumber, function(o) {
            if (o != null) {
                _log("Screen popping CASE record: " + o.Name);
                if (Salesforce.inServiceCloudConsole()) {
                	Salesforce.screenPop(o.Id); 
                }
                else Workspace.sendFocusChange(o.Id, true);
                var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
                Workspace.sendAttachData(newData);                
            } else {
                _log("No records found with Case Number containing: " + obj.userData.CaseNumber);
				lz_create_activity(obj,"")			        
				Salesforce.openCustomSearch(
			        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
			        null, null, null, null, 
			        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
			        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
			        null, null,			         
			        obj.id,
			        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
                return;
                
            }
        });
    } else {
    	if(LZCallType.indexOf("Sales") == 0 || LZCallType.indexOf("CC") == 0 || LZCallType.indexOf("Prod") == 0){
    		//LZ - check for consult or transfer; activity is created at start of interaction
    		var sfdcActivityId_present = (obj.userData.sfdcActivityId === undefined) ? "" : obj.userData.sfdcActivityId;
    		if(sfdcActivityId_present !=""){
	    		var continueProcessing = false;
	    		continueProcessing = lz_check_consult_transfer(obj);
	    		_log("continueProcessing = " + continueProcessing);
	    		if(continueProcessing == false)
	    			return;
    		}
	        if (Salesforce.screenPopUser(obj)) {
	            return;
	        }
	        if(obj.fieldName != undefined && obj.fieldValue != undefined){
	        	var searchFieldName = obj.fieldName;
	        	var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
	        	_log("search field " + searchFieldName + " for a value of " + searchFieldValue);
	        	 g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {
	        	     if (o != null) {
	        	    	 if (Salesforce.inServiceCloudConsole()) {
	        	    			Salesforce.screenPop(o.Id); 
	        	    	 }
	        	    	 else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
	        	         //inform workspace of SFobject id for subsequent use in activity creation and transfer
	        	         var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
	        	         Workspace.sendAttachData(newData);
	        	     } else {
	        	         _log("performInboundVoiceAction: result = " + o);
	        	         //open search
						lz_create_activity(obj,""); 
						Salesforce.openCustomSearch(
					        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
					        null, null, null, null, 
					        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
					        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
					        null, null, 
					        obj.id,
					        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
	        	     }
	        	 });
	        }
	        else{
	        	//LZ check for Sales or CC
	        	var OrderNo  = (obj.userData.OrderNumber  === undefined) ? "" : obj.userData.OrderNumber;
	
	        	if(LZCallType.indexOf("Sales") == 0){
	        		if(lookupNumber != undefined && lookupNumber != ""){ 
	        			lz_search_contact(obj,lookupNumber,createNewLead);
	        		} else if(createNewLead==true){
	        			lz_open_new_lead(obj,lookupNumber);
	        		} else {
						lz_create_activity(obj,"");
		        		Salesforce.openCustomSearch(
					        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
					        null, null, null, null, 
					        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
					        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
					        null, null, 
					        obj.id,
					        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
	        		}
	        		return;
	        	}
	        	else if(LZCallType.indexOf("CC") == 0 || LZCallType.indexOf("Prod") == 0){
	        		if(OrderNo != undefined && OrderNo != ""){ 
	        			lz_search_order(obj,OrderNo,lookupNumber);
	        			return;
	        		}
	        		if(lookupNumber != undefined && lookupNumber != ""){ 
	        			lz_search_contact(obj,lookupNumber,createNewLead);
	        			return;
	        		}
					lz_create_activity(obj,"");
	        		Salesforce.openCustomSearch(
				        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
				        null, null, null, null, 
				        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
				        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
				        null, null, 
				        obj.id,
				        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
	        		return;
	        	}
	        	
	          	//using the source attribute locate the account/contact/lead
	        	_log("Using lookupNumber = " + lookupNumber);
		        g_WorkspaceConnectorController.findObjectFromANI(lookupNumber, function(o) {
		            if (o != null) {
		                if (o == 'multiple found' || o == 'not found') {
							lz_create_activity(obj,"");    	                    
							Salesforce.openCustomSearch(
						        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
						        null, null, null, null, 
						        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
						        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
						        null, null, 
						        obj.id,
						        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
		                    return;
		                }
		                Salesforce.addIxnWindow(obj.id, o.Id);
		                if (Salesforce.inServiceCloudConsole()) {
		                	Salesforce.screenPop(o.Id); 
		                }
		                else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
		                //inform workspace of SFobject id for subsequent use in activity creation and transfer
		                var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
		                Workspace.sendAttachData(newData);
		            } else {
						lz_create_activity(obj,"");
						Salesforce.openCustomSearch(
					        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
					        null, null, null, null, 
					        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
					        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
					        null, null, 
					        obj.id,
					        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));    
		                _log("No records found with phone field containing: " + lookupNumber);
		            }
		        });
	        }
    	}
    }
}

function lz_search_contact(obj,lookupNumber,createNewLead){
	_log("lz_search_contact");
	var genesysID = (obj.id === undefined) ? "" : obj.id;
	//only Sales needs to check for primary contact
	var checkForPrimary = false;
	var LZCallType = (obj.userData.CallType === undefined) ? "" : obj.userData.CallType;
	if(LZCallType.indexOf("Sales") == 0)
		checkForPrimary = true;
    g_WorkspaceConnectorController.findContactFromANI(lookupNumber, genesysID, checkForPrimary, function(o) {
        if (o != null) {
        	_log("findContactFromANI returns " + o);
            if (o == 'multiple found') {
		    	lz_create_activity(obj,"");
                Salesforce.openCustomSearch(
			        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null,
			         null, null, null, null,
			        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
			        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
			        null, null, 
			        genesysID,
			        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
                return;
            }
            if (o == 'not found' ) {
	            if(	obj.userData.CallType != undefined && obj.userData.CallType.indexOf("Sales") == 0)
	            	lz_search_lead(obj,lookupNumber,createNewLead);
	            else {
			    	lz_create_activity(obj,"");
	                Salesforce.openCustomSearch(
				        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null,
				         null, null, null, null,
				        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
				        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
				        null, null, 
				        genesysID,
				        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));            
	            }
            	return;
            }

			if(genesysID!="")
			{
			lz_create_activity(obj,o.Id);
				//PJB: Need to add UPDATE Call here
				_log("Preparing Contact Update");			
				g_WorkspaceConnectorController.updateObjectById(o.Id, obj.id, function(){
					_log("Contact Update Complete");
					Salesforce.screenPop(o.Id);
					/*sforce.opencti.screenPop({
			            type: sforce.opencti.SCREENPOP_TYPE.SOBJECT,
			            params: { recordId: o.Id }
			    	});*/
				});
			}
			else
			lz_create_activity(obj,o.Id);
				//Salesforce.screenPop(o.Id);
				sforce.opencti.screenPop({
			            type: sforce.opencti.SCREENPOP_TYPE.SOBJECT,
			            params: { recordId: o.Id }
			    	});

             
            var newData = '{"sfdcObjectId":"' + o.Id + '","sfdcContactId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
            
            //need to create activity
        	//lz_create_activity(obj,o.Id);
            
        } else {
            _log("No records found with phone field containing: " + lookupNumber);
            //LZ check for Sales or CC
            if(	obj.userData.CallType != undefined && obj.userData.CallType.indexOf("Sales") == 0)
            	lz_search_lead(obj,lookupNumber,createNewLead);
            else {
		    	lz_create_activity(obj,"");
                Salesforce.openCustomSearch(
			        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null,
			         null, null, null, null,
			        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
			        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
			        null, null, 
			        genesysID,
			        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));            
            }
        }
    });
}

function lz_search_lead(obj,lookupNumber,createNewLead){
	_log("lz_search_lead");
	var genesysID = (obj.id === undefined) ? "" : obj.id;
    g_WorkspaceConnectorController.findLeadFromANI(lookupNumber,genesysID, function(o) {
        if (o != null) {
            if (o == 'multiple found' || (o == 'not found' && createNewLead==false)) {
		    	lz_create_activity(obj,"");
            	Salesforce.openCustomSearch(
			        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
			        null, null, null, null,         
			        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
        			((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
					null, null, 
			        genesysID,
			        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
                return;
            }
            if (o == 'not found' ) {
            	lz_create_activity(obj,"");
            	lz_open_new_lead(obj,lookupNumber);
            	

            	return;
            }

			if(genesysID!="")
			{
			lz_create_activity(obj,o.Id);
				//PJB: Need to add UPDATE Call here
				_log("Preparing Lead Update");
				g_WorkspaceConnectorController.updateObjectById(o.Id, obj.id, function(){
					_log("Lead Update Complete");
					Salesforce.screenPop(o.Id);
				});
			}
			else{
			lz_create_activity(obj,o.Id);
				Salesforce.screenPop(o.Id);
			}
		

            var newData = '{"sfdcObjectId":"' + o.Id + '","sfdcLeadId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
            
            //need to create activity
            //lz_create_activity(obj,o.Id);
            
        } else {
            _log("No records found with phone field containing: " + lookupNumber);
		    lz_create_activity(obj,"");
        	Salesforce.openCustomSearch(
		        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
		        null, null, null, null,         
		        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
    			((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
				null, null, 
		        genesysID,
		        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
        }
    });	
}

function lz_search_order(obj,orderNo,lookupNumber){
	_log("lz_search_order for " + orderNo);
	var genesysID = (obj.id === undefined) ? "" : obj.id;
	g_WorkspaceConnectorController.findOrderFromNumber(orderNo, genesysID, function(o) {
        if (o != null) {
        	_log("return from findOrderFromNumber = " + o);
            if (o == 'not found' ) {
            	lz_find_contact_CC(obj,lookupNumber);
            	return;
            }
            //return is orderID,contactID
            var IDs = o.split(",");
            if(IDs[0] != "")
            {
				//PJB: Need to add UPDATE Call here
				if(genesysID!="")
				{
					_log("Preparing Object Update");				
					g_WorkspaceConnectorController.updateObjectById(IDs[0], genesysID, function(){
						_log("Object Update Complete");
						Salesforce.screenPop(IDs[0]);
					});
				}
				else
            		Salesforce.screenPop(IDs[0]);
        	}
            if(IDs[1] != "")
            {
				if(genesysID!="")
				{
					_log("Preparing Object Update");
					g_WorkspaceConnectorController.updateObjectById(IDs[1], genesysID, function(){
						_log("Object Update Complete");
						Salesforce.screenPop(IDs[1]);
					});
				}
				else
            		Salesforce.screenPop(IDs[1]);
        	}
            var newData = '{"sfdcObjectId":"' + IDs[1] + 
            	'","sfdcOrderId":"' + IDs[0] +
            	'","sfdcContactId":"' + IDs[1] +
            	'","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
            
            //need to create activity
            lz_create_activity(obj,IDs[1]);
            
        } else {
            _log("No records found for orderNo - search Contact");
            lz_find_contact_CC(lookupNumber)
        }
    });
}

function lz_find_contact_CC(obj,lookupNumber){
	_log("lz_find_contact_CC");
	var genesysID = (obj.id === undefined) ? "" : obj.id;
	//only Sales needs to check for primary contact
    g_WorkspaceConnectorController.findContactFromANI(lookupNumber, genesysID, false, function(o) {
        if (o != null) {
        	_log("findContactFromANI returns " + o);
            if (o == 'multiple found' || o == 'not found') {
			    lz_create_activity(obj,"");
            	Salesforce.openCustomSearch(
			        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
			        null, null, null, null, 
			        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
			        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
			        null, null, 
			        genesysID,
			        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
                return;
            }

			//PJB: Need to add UPDATE Call here
			if(genesysID!="")
			{
				_log("Preparing Contact Update");
				g_WorkspaceConnectorController.updateObjectById(o.Id, genesysID, function(){
					_log("Contact Update Complete");
					Salesforce.screenPop(o.Id);
				});
			}
			else
				Salesforce.screenPop(o.Id);

            var newData = '{"sfdcObjectId":"' + o.Id + '","sfdcContactId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
            
            //need to create activity
            lz_create_activity(obj,o.Id);
            
        } else {
            _log("No records found with phone field containing: " + lookupNumber);
		    lz_create_activity(obj,"");        	
        	Salesforce.openCustomSearch(
		        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
		        null, null, null, null, 
		        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
		        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
		        null, null, 
		        genesysID,
		        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));
        }
    });
}
//Padma 
function openSearchAsyncLead(lookupNumber,_GENESYSID) {
	var callback = function(response) {
    		 if (response.success) {
    			console.log('API method call executed successfully! returnValue:', response.returnValue);
    		 } else {
    			console.error('Something went wrong! Errors:', response.errors);
    		 }
    	};
  var d = $.Deferred(function (d) {
    setTimeout(function () {
      d.resolve("Ok");
      console.log('enterd the openSearchAsync ');

      sforce.opencti.screenPop({
      			type: sforce.opencti.SCREENPOP_TYPE.NEW_RECORD_MODAL,
      			params: { entityName: 'Lead', defaultFieldValues: {'Phone':lookupNumber ,	Genesys_Interaction_Id__c :_GENESYSID}},
      			deferred: true,
      			callback:callback
         });
	}, 2500);

  });
  return d.promise();
}
//EOC Padma

function lz_open_new_lead(obj,lookupNumber){
	_log("lz_open_new_lead");
	var wsParams = Workspace.getParameters();
	var _GENESYS_FIELD_ID = (wsParams.LeadGenesysID === undefined) ? "" : wsParams.LeadGenesysID;
	var _GENESYSID = (obj.id === undefined) ? "" : obj.id;
	var _EMAIL_FIELD_AND_VALUE = (obj.userData.EmailAddress === undefined) ? "" : '&lea11=' + obj.userData.EmailAddress;
	var _FIRSTNAME_FIELD_AND_VALUE = (obj.userData.FirstName === undefined) ? "" : '&name_firstlea2=' + obj.userData.FirstName;
	//var	url = '00Q/e?lea8=' + lookupNumber;
	var url = '00Q/e?lea8=' + lookupNumber + '&' + _GENESYS_FIELD_ID + '=' + _GENESYSID + _EMAIL_FIELD_AND_VALUE + _FIRSTNAME_FIELD_AND_VALUE;
	_log("url = " + url);
	/*sforce.opencti.screenPop({
            type: sforce.opencti.SCREENPOP_TYPE.NEW_RECORD_MODAL,
            params: { entityName: 'Lead' }
    }); */
   /* sforce.opencti.screenPop({
            type: sforce.opencti.SCREENPOP_TYPE.NEW_RECORD_MODAL,
            params: { entityName: 'Lead', defaultFieldValues: {'Phone':lookupNumber ,	Genesys_Interaction_Id__c :_GENESYSID}}
    });*/

	openSearchAsyncLead(lookupNumber,_GENESYSID);
    //need to create activity
    //lz_create_activity(obj,"");
}

function lz_check_consult_transfer(obj){
	_log("in lz_check_consult_transfer");
	var LZCallType = (obj.userData.CallType === undefined) ? "" : obj.userData.CallType;
	var sfdcContactId_popped = (obj.userData.sfdcContactId === undefined) ? "" : obj.userData.sfdcContactId;
	var sfdcLeadId_popped = (obj.userData.sfdcLeadId === undefined) ? "" : obj.userData.sfdcLeadId;
	var sfdcOrderId_popped = (obj.userData.sfdcOrderId === undefined) ? "" : obj.userData.sfdcOrderId;
	
	var continueProcessing = true;
	if(LZCallType.indexOf("Sales") == 0){
		if(sfdcLeadId_popped != ""){
			//for Sales
			Salesforce.screenPop(sfdcLeadId_popped);
        	lz_create_activity(obj,sfdcLeadId_popped);
	        //done processing so return false
	        return continueProcessing;
		}
/*		else if((obj.userData.sfdcObjectId != undefined){
			//for Sales
			Salesforce.screenPop(obj.userData.sfdcObjectId);
        	lz_create_activity(obj.userData.sfdcObjectId);
	        //done processing so return false
	        return false;
		}*/
		else{
			//need to check if a Lead was created before the call was transferred
			var _GENESYSID = (obj.id === undefined) ? "" : obj.id;
		    var startDateForTransfer = (obj.startDate === undefined) ? "" : obj.startDate;
		    var _ENDTIME = getDateNow();
		    var _GENESYSID = (obj.id === undefined) ? "" : obj.id;
			_log("startDateForTransfer = " + startDateForTransfer);
		    _log("endDate = " + _ENDTIME);
		    g_WorkspaceConnectorController.findLeadFromGenesysID(_GENESYSID,startDateForTransfer,_ENDTIME, function(o) {
	    		if(o != ""){
	    			Salesforce.screenPop(o); 
	    	        //done processing so return false
	    	        return continueProcessing;
	    		}
	    	});
		}
	}
	
	if(sfdcOrderId_popped != ""){
		//for CC
		Salesforce.screenPop(sfdcOrderId_popped); 
    	lz_create_activity(obj,sfdcOrderId_popped);
      //done processing so return false
        continueProcessing = false;
	}
	
	if(sfdcContactId_popped != ""){
		//for Sales or CC
		Salesforce.screenPop(sfdcContactId_popped); 
    	lz_create_activity(obj,sfdcContactId_popped);
      //done processing so return false
        continueProcessing = false;
	}
	
/*	if( obj.userData.sfdcObjectId != undefined){
		Salesforce.screenPop(obj.userData.sfdcObjectId);
    	lz_create_activity(obj,obj.userData.sfdcObjectId);
        //done processing so return false
        return continueProcessing;
	}*/
	return continueProcessing;
}

// screen pop for outbound voice
function performOutboundVoiceAction(obj) {
    _log("in performOutboundVoiceAction()");

    if (Salesforce.screenPopUser(obj)) {
       	lz_create_activity(obj,obj.userData.sfdcObjectId); 
        return;
    }

    var lookupNumber = obj.destination;
    
    g_WorkspaceConnectorController.getProfileName(function(o)
	{
		perform_voice_screenpop(obj, lookupNumber, 'Outbound', o);	
	});
    
/*    
    // using the destination attribute locate the contact
    g_WorkspaceConnectorController.findObjectFromANI(lookupNumber, function(o) {
        if (o != null) {
            if (o == 'multiple found' || o == 'not found') {
//                Salesforce.openSearch(lookupNumber, obj.id);
			    lz_create_activity(obj,"");            
				Salesforce.openCustomSearch(
			        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
			        null, null, null, null, 
			        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
			        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
			        null, null, 
			        obj.id,
			        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));    
                return;
            }
            _log("Screen popping record: " + o.Id);
            if (Salesforce.inServiceCloudConsole()) {
            	Salesforce.screenPop(o.Id); 
            }
            else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
            //inform workspace of SFobject id for subsequent use in activity creation and transfer
            var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
        } else {
		    lz_create_activity(obj,"");            
			Salesforce.openCustomSearch(
		        (lookupNumber != undefined && lookupNumber != "") ? lookupNumber : null, 
		        null, null, null, null, 
		        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
		        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
		        null, null, 
		        obj.id,
		        ((obj.userData.CallType  === undefined) ? null : obj.userData.CallType));    
            _log("No records found with phone field containing: " + lookupNumber);
        }
    });
    */
}

////////////////////////////////////////////////////////////////////////////////////////
// Email handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for email

function performEmailAction(obj) {
    _log("in performEmailAction()");
    if (Salesforce.screenPopUser(obj)) {
        return;
    }
    var searchFieldName = "";
    var searchFieldValue = "";
    var lookupContact;
    if(obj.source != undefined && obj.source != '') {
    	lookupContact = obj.source;
    	searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
    	searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
    }
    else{
    	if(obj.destination != undefined){
        	var emailAddr = obj.destination;
    		//remove trailing ; or ,
    		var lastChar1 = emailAddr.lastIndexOf(";");
    		var lastChar2 = emailAddr.lastIndexOf(",");
    		if(lastChar1 == (emailAddr.length-1) || lastChar2 == (emailAddr.length-1)){
    			//remove last character
    			emailAddr = emailAddr.slice(0,-1);			
    		}			
    		_log("emailAddr " + emailAddr);
    		lookupContact = emailAddr;
    		searchFieldName = "email";
    		searchFieldValue = emailAddr;
    	}
    }
	_log("search field " + searchFieldName + " for a value of " + searchFieldValue);
    //g_WorkspaceConnectorController.findContactFromEmailAddress(lookupContact, function(o) {
    g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {
        if (o != null) {
        	if (Salesforce.inServiceCloudConsole()) {
        		Salesforce.screenPop(o.Id); 
        	}
        	else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
            //inform workspace of SFobject id for subsequent use in activity creation and transfer
            var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
        } else {
        	 _log("performEmailAction: No records found");
            Salesforce.openSearch("", obj.id);
        }
    });
}

////////////////////////////////////////////////////////////////////////////////////////
// Chat handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for chat
// screen pop for chat
function performChatAction(obj) {
        _log("in performChatAction()");
        // check for attached data sfdcObjectId - if it is already there, then pop that
        if (Salesforce.screenPopUser(obj)) {
				lz_create_activity(obj,obj.userData.sfdcObjectId);
                return;
        }

        //LZ check for Sales or CC
        var LZCallType = (obj.userData.SkillName === undefined) ? "" : obj.userData.SkillName;
        var LZEmailAddress = (obj.userData.EmailAddress === undefined) ? "" : obj.userData.EmailAddress;
        
        if(LZCallType.indexOf("Sales") == 0 || LZCallType.indexOf("CC") == 0)
        {
                g_WorkspaceConnectorController.findObjectFromEmail(LZEmailAddress, LZCallType, obj.id, function(o) 
                {           
                        if (o != null)
                        {
                                if(o == 'multiple found' || (o == 'not found' && LZCallType.indexOf("CC") == 0)) {
                                        _log("performChatAction: Search required: " + o);
                                        //open search
                                        lz_create_activity(obj,""); 
                                        Salesforce.openCustomSearch(
                                                null, 
                                                null, null, 
                                                ((obj.userData.EmailAddress === undefined)? null : obj.userData.EmailAddress), 
                                                null, 
                                                ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
                                                ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 

                                                null, null, 
                                                obj.id,
                                                LZCallType
                                        );
                                } else if(o == 'not found' && LZCallType.indexOf("Sales") == 0) {
                                        lz_open_new_lead(obj, '');
                                } else {
//                                        Workspace.updateObjectById(o);//to add the IXN id to contact/lead
                                		lz_create_activity(obj,o.Id);
                                        if (Salesforce.inServiceCloudConsole()) {
                                        		//PJB: Need to add UPDATE Call here
                                        		_log("Preparing Object Update");
												g_WorkspaceConnectorController.updateObjectById(o.Id, obj.id, function(){
													_log("Object Update Complete");
													Salesforce.screenPop(o.Id);
												}); 
                                        }
                                        else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
                                        //inform workspace of SFobject id for subsequent use in activity creation and transfer
                                        var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
                                        Workspace.sendAttachData(newData);                        
                                }
                        } else {
                        	if(LZCallType.indexOf("Sales") == 0) {
                                lz_open_new_lead(obj, '');
                            }
                            else
                            {
                                //open search
                                lz_create_activity(obj,""); 
                                Salesforce.openCustomSearch(
                                        null, 
                                        null, null, 
                                        ((obj.userData.EmailAddress === undefined)? null : obj.userData.EmailAddress), 
                                        null, 
                                        ((obj.userData.CaseNumber === undefined) ? null : obj.userData.CaseNumber), 
                                        ((obj.userData.OrderNumber  === undefined) ? null : obj.userData.OrderNumber), 
                                        null, null, 
                                        obj.id,
                                        LZCallType
                                );
                            }
                        }
                });
        }        
}


////////////////////////////////////////////////////////////////////////////////////////
// WorkItem handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for WorkItem
function performWorkItemAction(obj) {
    _log("in performWorkItemAction()");
    // check for attached data sfdcObjectId - if it is already there, then pop that
    if (Salesforce.screenPopUser(obj)) {
        return;
    }

    var name = obj.source;
    var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
    var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
    _log("search field " + searchFieldName + " for a value of " + searchFieldValue);
    
    // using the source attribute locate the contact
    //g_WorkspaceConnectorController.findContactFromWorkItemAddress(name, function(o) {
    g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {    	
        if (o != null) {
        	if (Salesforce.inServiceCloudConsole()) {
        		Salesforce.screenPop(o.Id); 
        	}
        	else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
            //inform workspace of SFobject id for subsequent use in activity creation and transfer
            var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
        } else {
            _log("performWorkItemAction: No records found");
            //open search
            Salesforce.openSearch("", obj.id);      
        }
    });
}

////////////////////////////////////////////////////////////////////////////////////////
//SMS handling
////////////////////////////////////////////////////////////////////////////////////////

//screen pop for SMS
function performSmsAction(obj) {
 _log("in performSmsAction()");
 // check for attached data sfdcObjectId - if it is already there, then pop that
 if (Salesforce.screenPopUser(obj)) {
     return;
 }

 var name = obj.source;
 var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
 var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
 _log("search field " + searchFieldName + " for a value of " + searchFieldValue);

 // using the source attribute locate the contact
 //g_WorkspaceConnectorController.findContactFromOpenMediaAddress(name, function(o) {
 g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {
     if (o != null) {
    	 if (Salesforce.inServiceCloudConsole()) {
    			Salesforce.screenPop(o.Id); 
    	 }
    	 else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
         //inform workspace of SFobject id for subsequent use in activity creation and transfer
         var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
         Workspace.sendAttachData(newData);
     } else {
         _log("performSmsAction: result = " + o);
         //open search
         Salesforce.openSearch("", obj.id); 
     }
 });
}

////////////////////////////////////////////////////////////////////////////////////////
//WebCallback handling
////////////////////////////////////////////////////////////////////////////////////////

//screen pop for WebCallback
function performWebCallbackAction(obj) {
	_log("in performWebCallbackAction()");
	 // check for attached data sfdcObjectId - if it is already there, then pop that
	 if (Salesforce.screenPopUser(obj)) {
	     return;
	 }

	 var name = obj.source;
	 var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
	 var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
	 _log("search field " + searchFieldName + " for a value of " + searchFieldValue);

	 // using the source attribute locate the contact
	 //g_WorkspaceConnectorController.findContactFromOpenMediaAddress(name, function(o) {
	 g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {
	     if (o != null) {
	    	 if (Salesforce.inServiceCloudConsole()) {
	    			Salesforce.screenPop(o.Id); 
	    	 }
	    	 else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
	         //inform workspace of SFobject id for subsequent use in activity creation and transfer
	         var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
	         Workspace.sendAttachData(newData);
	     } else {
	         _log("performWebCallbackAction: result = " + o);
	         //open search
	         Salesforce.openSearch("", obj.id); 
	     }
	 });
}

////////////////////////////////////////////////////////////////////////////////////////
// Open Media handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for OpenMedia
function performOpenMediaAction(obj) {
    _log("in performOpenMediaAction()");
    // check for attached data sfdcObjectId - if it is already there, then pop that
    if (Salesforce.screenPopUser(obj)) {
        return;
    }

    var name = obj.source;

    // using the source attribute locate the contact
    g_WorkspaceConnectorController.findContactFromOpenMediaAddress(name, function(o) {
        if (o != null) {
        	if (Salesforce.inServiceCloudConsole()) {
        		Salesforce.screenPop(o.Id); 
        	}
        	else Workspace.sendFocusChange(o.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
            //inform workspace of SFobject id for subsequent use in activity creation and transfer
            var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
            Workspace.sendAttachData(newData);
        } else {
            _log("performOpenMediaAction: No records found with Name containing: " + name);
            //open search
            Salesforce.openSearch("", obj.id); 
        }
    });
}


////////////////////////////////////////////////////////////////////////////////////////
// Case handling
////////////////////////////////////////////////////////////////////////////////////////

/*
 Opens an existing Case if MainMenu = 'Existing Ticket'
 or creates a new Case if MainMenu = 'New Ticket'
 */
function performCaseAction(openObj) {
    _log("in performCaseAction() with main menu=" + openObj.userData.MainMenu);

    // Existing Ticket
    if (openObj.userData.MainMenu == 'Existing Ticket') {
        _log("Opening an Existing CASE with number: " + openObj.userData.TicketNumber);
        g_WorkspaceConnectorController.findCaseFromNumber(openObj.userData.TicketNumber,
            function(result, event) {
                if (result != null) {
                    _log("found Case.Id=" + result.Id + " (CaseNumber " + result.CaseNumber + ")");
                    if (Salesforce.inServiceCloudConsole()) {
                    	Salesforce.screenPop(result); 
                    }
                    else Workspace.sendFocusChange(result.Id, true); //PJB: Had to move screenpop so that it wasn't called while we were still sending events
                }
                else {
                    _log('No case found, defaulting to navigator tab for user search');
                    try {
                        // display the CaseNotFound page allowing the user to correct
                        // correct the input case and re-pop.
                        Salesforce.consolePop("apex/WSC_CaseNotFound?CaseNumber=" + openObj.userData.TicketNumber, 
                        	"Case Not Found");
                    } catch (e) {
                        //alert("Error=" + e);
                    }
                }
            });
    }

    // New Ticket
    if (openObj.userData.MainMenu == 'New Ticket') {
        _log("New Ticket requested");
        var displayDate = getDisplayDate();
        var mediaType = (openObj.mediaType === undefined) ? "" : openObj.mediaType;
	    var mapCase = {
	    		"IXN Type" : openObj.type,
	    		"Media Type" : mediaType,
	    		"DATE": displayDate
	    }
	    g_WorkspaceConnectorController.createCase(mapCase, function(result){
	    	_log("createCase result = " + result);
	    	if(result != null && result != 'case not created'){
	            //display the case
	            Salesforce.screenPop(result);
	    	}
	    });
        
        // fetch the product line and product IDs
        var canPop = false;            // indicates if all data attributes available to pop form
        /*
        g_WorkspaceConnectorController.getProductFromName(openObj.userData.FunctionalGroup, function(pl) {
            if (pl != null) {
                g_WorkspaceConnectorController.getProductFromName(openObj.userData.ProductGroup, function (sp) {
                    if (sp != null) {
                        _log("Opening new Product Case for " + openObj.userData.Employer + " using product line: " + openObj.userData.FunctionalGroup + " and product: " + openObj.userData.ProductGroup);
                        // open the New Case page forcing bypass of first two forms with prefilled contacts and products
                        Salesforce.consolePop('apex/Portal_Select_Case_Type?isSaas=true&RecordType=012J0000000CsVB'
                            + '&sto=' + openObj.userData.SoldToSFDCId
                            + '&eu=' + openObj.userData.EndUserSFDCId
                            + '&pl=' + pl.Id
                            + '&sp=' + sp.Id
                            + '&conid=' + openObj.userData.ContactSFDCId,
                            'New Case');
                        canPop = true;        // we have popped
                    }
                });
            }
        });
        */
    }

    // Something Else
    if (openObj.userData.MainMenu == 'Something Else') {
        _log("Something else requested");
        // do nothing
    }
}

////////////////////////////////////////////////////////////////////////////////////////
// Task handling
//
// Writes a simple task from provided disposition information
////////////////////////////////////////////////////////////////////////////////////////

function getDisplayDate() {
    var date = new Date();
    var hrs = date.getHours();
    if(hrs < 10)
    	hrs = "0" + hrs;
    var min = date.getMinutes();
    if(min < 10)
    	min = "0" + min;
    var sec = date.getSeconds();
    if(sec < 10)
    	sec = "0" + sec;
    return (date.getMonth() + 1) + '/' + (date.getDate()) + '/' + date.getFullYear()
        //+ " " + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
        + " " + hrs + ':' + min + ':' + sec;
}


function lz_create_activity(createObj,objIdForActivity){
	_log("lz_create_activity");
	if(createObj.calltype == "Consult")
	{
		_log("lz_create_activity aborted for consult");
		return;
	}	
    g_WorkspaceConnectorController.getUserId(function(userIdResult){
    _log("g_WorkspaceConnectorController.getUserId");
	    g_WorkspaceConnectorController.getProfileName(function(profileNameResult)
		{
		_log("g_WorkspaceConnectorController.getProfileName");
	    	//try to get callType from userdata
			var callType = (createObj.userData.SkillName != null && createObj.userData.SkillName != '') ? createObj.userData.SkillName : ((createObj.userData.CallType != null && createObj.userData.CallType != '') ? createObj.userData.CallType : '');
			//if it's not on userdata then use the one from the profile
			if(callType==null || callType=='')
				callType = profileNameResult;						
			if(callType.indexOf("Sales") != 0 && 
				callType.indexOf("Equip") != 0 &&
				callType.indexOf("CC") != 0 &&
				callType.indexOf("Prod") != 0)
			{
				_log("lz_create_activity aborted;" + callType + " is not Sales, CC, or Prod");
				return;
			}		
	    
			if(userIdResult!=null && userIdResult!='' && createObj.userData['sfdcActivityId'+userIdResult]!=undefined && createObj.userData['sfdcActivityId'+userIdResult]!='')
			{
				_log("lz_create_activity aborted because acitivity already exists");
				Salesforce.screenPop(result);
				return;
			} 
			
			var createObjType = (createObj.type === undefined) ? getDisplayDate() : createObj.type;
		    _log("lz createTask for " + createObjType);
		    var displayDate = (createObj.startDate === undefined) ? getDisplayDate() : createObj.startDate;
		    var lookupSource = "";
		    var ixnType = "";
		    var mediaType = "";
		    var startDate = (createObj.startDate === undefined) ? getDisplayDate() : createObj.startDate;
		    var endDate = (createObj.endDate === undefined) ? "" : createObj.endDate;   
		    var transferredFrom = (createObj.transferredFrom===undefined) ? "" : createObj.transferredFrom;
		    var _FIELDNAME = (createObj.fieldName === undefined) ? "" : createObj.fieldName;
		    var _FIELDVALUE = (createObj.fieldValue === undefined) ? "" : createObj.fieldValue;
			var callDirection = null;
			
		    switch (createObjType) {
		        case "Voice":
		            // if outbound then use destination as source
		            if (createObj.calltype == "Outbound") {
		                lookupSource = createObj.destination;
		                //ixnType = "Outbound";
		                mediaType = (createObj.mediatype === undefined) ? "" : createObj.mediatype;
		                if(createObj.mediatype === undefined || createObj.mediatype === ""){
		                	ixnType = "Voice-Outbound Dial"; 
		                }
		                else ixnType = "Voice-Outbound";
		                callDirection = "Outbound";
		            }
		            else {
		                if (createObj.role == 'RoleOrigination') {
		                    lookupSource = createObj.destination;
		                    ixnType = "Voice-Outbound Dial";
		                    callDirection = "Outbound";
		                }
		                else {
		                    lookupSource = createObj.source;
		                    ixnType = "Voice-Inbound";
		                    callDirection = "Inbound";
		                }
		            }
		            break;
		        case "Chat":
		            //lookupSource=createObj.userData.FirstName + ' ' + createObj.userData.LastName
		            lookupSource = createObj.source;
		            //ixnType = createObj.type;
		            ixnType = "Chat-Inbound";
		    		_FIELDNAME = "";
		    		_FIELDVALUE = "";       
		    		callDirection = "Inbound";     
		            break;
		        
		        default:
		            _log("activity not created for " + createObj.type);
		            return;
		    }
		
		    if (objIdForActivity != "") {
		        _log("createTask: " + ixnType + " using objIdForActivity " + objIdForActivity);
		    }
		    else {
		        //_log("createTask: " + ixnType + " using field " + _FIELDNAME + " to search for a value of " + _FIELDVALUE);
		        _log("1340");

		    }
		
		    var _CALL_DURATION = (createObj.duration === undefined) ? "" : createObj.duration;
		    var _IXNTYPE = ixnType;
		    var _COMMENTS = (createObj.notes === undefined) ? "" : createObj.notes;
		    var _DISP = (createObj.userData.DispositionCode === undefined) ? "" : createObj.userData.DispositionCode;
		    var _DNIS = (createObj.destination === undefined) ? "" : createObj.destination;
		    var _GENESYSID = ((createObj.userData.id === undefined) ? ((createObj.id === undefined) ? "" : createObj.id) : createObj.userData.id);
		    var _ANI = (createObj.source === undefined) ? "" : createObj.source;
		    var _SFDC_OBJECT_ID = objIdForActivity;
		    var verificationTimeStamp = (createObj.userData.sfdc_verified_timestamp === undefined) ? "" : createObj.userData.sfdc_verified_timestamp;
		    var isVerified = (createObj.userData.sfdc_verified_indication === undefined) ? "" : createObj.userData.sfdc_verified_indication;
		    
		    //email specific
		    var _Attachment_Flag = (createObj.Attachment_Flag === undefined) ? "" : createObj.Attachment_Flag;
		    var _EMAIL_DESC = (createObj.emailDescription === undefined) ? "" : createObj.emailDescription;
		    if(_EMAIL_DESC != ""){
		    	_EMAIL_DESC = "\n" + "***EMAIL***" + _EMAIL_DESC;
		    }
		    
		    var _CHAT_TRANSCRIPT = (createObj.transcript === undefined) ? "" : createObj.transcript;
		    if(_CHAT_TRANSCRIPT != ""){
		    	_CHAT_TRANSCRIPT = "\n" + "***CHAT***" + "\n" + _CHAT_TRANSCRIPT;
		    }
		    
		    if(_COMMENTS != ""){
		    	_COMMENTS = "*** NOTES ***" + "\n" + _COMMENTS;
		    }
		    if(_EMAIL_DESC != ""){
		    		_COMMENTS = "\n" +_COMMENTS + _EMAIL_DESC;
		    }
		    if(_CHAT_TRANSCRIPT != ""){
		    		_COMMENTS = "\n" +_COMMENTS + _CHAT_TRANSCRIPT;
		    }
		
		    
		    var _SFDC1value = (createObj.SFDC1value === undefined) ? "" : createObj.SFDC1value;
		    var _SFDC2value = (createObj.SFDC2value === undefined) ? "" : createObj.SFDC2value;
		    var _SFDC3value = (createObj.SFDC3value === undefined) ? "" : createObj.SFDC3value;
		    var _SFDC4value = (createObj.SFDC4value === undefined) ? "" : createObj.SFDC4value;
		    var _SFDC5value = (createObj.SFDC5value === undefined) ? "" : createObj.SFDC5value;
		    var _SFDC1field = (createObj.SFDC1field === undefined) ? "" : createObj.SFDC1field;
		    var _SFDC2field = (createObj.SFDC2field === undefined) ? "" : createObj.SFDC2field;
		    var _SFDC3field = (createObj.SFDC3field === undefined) ? "" : createObj.SFDC3field;
		    var _SFDC4field = (createObj.SFDC4field === undefined) ? "" : createObj.SFDC4field;
		    var _SFDC5field = (createObj.SFDC5field === undefined) ? "" : createObj.SFDC5field;
		
		    _log("creating task map");
		    var mapActivity = {
		    	"Call Duration": _CALL_DURATION,
		        "IXN Type": _IXNTYPE,
		        "Comments": _COMMENTS,
		        "Disposition": _DISP, 
				"DNIS": _DNIS,
		        "GenesysId": _GENESYSID, "ANI": _ANI,
		        "sfdc Object Id": _SFDC_OBJECT_ID,
		        "SFDC1value": _SFDC1value, "SFDC2value": _SFDC2value, "SFDC3value": _SFDC3value,
		        "SFDC4value": _SFDC4value, "SFDC5value": _SFDC5value,
		        "SFDC1field": _SFDC1field, "SFDC2field": _SFDC2field, "SFDC3field": _SFDC3field,
		        "SFDC4field": _SFDC4field, "SFDC5field": _SFDC5field,
		        "Media Type": mediaType,
		        "DATE": displayDate, 
		        "fieldName" : _FIELDNAME, "fieldValue" : _FIELDVALUE,
		        "StartDate": startDate,"EndDate": endDate,
		        "TransferredFrom": transferredFrom,
		        "IsVerified": isVerified,
		        "VerificationTimeStamp" : verificationTimeStamp,
		        "Call Direction" : callDirection 
		    };
		
		    g_WorkspaceConnectorController.createActivity(mapActivity, function(result, event) {
		        _log("createActivity RESULT = " + result);
		
		        if (result != null && result != "not found") {
		            _log("new activity - " + result);
		            //refresh for click to dial
		            var clickToDialCall = (createObj.userData.SFinteraction==undefined) ?  createObj.SFinteraction : createObj.userData.SFinteraction;
		            if(clickToDialCall == "True")
		            	Salesforce.screenPop(objIdForActivity);
		            //Salesforce.screenPop(result);
		            var subject = ixnType + ' ' + mediaType + ' ' + displayDate;
		            Salesforce.screenPopNoFocus(result, subject);
	            	var newData;	
	            	var callId = (createObj.userData.id==undefined) ?  createObj.id : createObj.userData.id;
	            	if(userIdResult==null || userIdResult=='')
		            	newData = '{"sfdcActivityId":"' + result + '","id":"' + callId + '"}';
		            else
		            	newData = '{"sfdcActivityId' + userIdResult + '":"' + result + '","id":"' + callId + '","sfdcActivityId":"' + result + '"}';
	            	Workspace.sendAttachData(newData);
		            
		            if(_Attachment_Flag == 'True'){
		            	_log("Get attachment info");
			        	//Attachment info is in the form of :
			        	//	"attachments": [
			            //		{"id":"1", "name":"a.zip", "desc":"file a", "mimeType":"gzip"},
			            //		{"id":"2", "name":"b.zip", "desc":"file b", "mimeType":"gzip"}
			        	//	]
			
			        	var attachmentInfo = createObj.attachments;
			            getAttachment(attachmentInfo,createObj.id,0,result);
		            }
		        }
		        else {
		            _log("Could not create task");
		        }
		
		    });
	   });
	});	   
}


function lz_update_activity(updateObj){
	_log("lz_update_activity");	
    g_WorkspaceConnectorController.getUserId(
	    function(userId)
	    {
			var sfdcActivityId;	
			if(userId!=null || userId!='')
		    	sfdcActivityId = (updateObj.userData['sfdcActivityId'+userId] === undefined) ? "" : updateObj.userData['sfdcActivityId'+userId];
		    else
		    	sfdcActivityId = (updateObj.userData.sfdcActivityId === undefined) ? "" : updateObj.userData.sfdcActivityId;
		    	
			_log("sfdcActivityId = " + sfdcActivityId);
		
			if(sfdcActivityId != ""){
				//update Activity
				var _CALL_DURATION = (updateObj.duration === undefined) ? "" : updateObj.duration;
			    var _COMMENTS = (updateObj.notes === undefined) ? "" : updateObj.notes;
			    var _TRANSCRIPT = (updateObj.transcript === undefined) ? "" : updateObj.transcript;
			    var _DISP = (updateObj.dispositionCode === undefined) ? "" : updateObj.dispositionCode;
			    var _GENESYSID = (updateObj.id === undefined) ? "" : updateObj.id;
			    var _STARTDATE = (updateObj.startDate === undefined) ? "" : updateObj.startDate;
			    var _ENDDATE = (updateObj.endDate === undefined) ? "" : updateObj.endDate;
				var _SFDC_ID = (updateObj.userData.sfdcObjectId === undefined) ? "" : updateObj.userData.sfdcObjectId;
			    var verificationTimeStamp = (updateObj.userData.sfdc_verified_timestamp === undefined) ? "" : updateObj.userData.sfdc_verified_timestamp;
			    var isVerified = (updateObj.userData.sfdc_verified_indication === undefined) ? "" : updateObj.userData.sfdc_verified_indication;

			    var mapActivityUpdate = {
			    		"Call Duration": _CALL_DURATION,
			    		"Comments": _COMMENTS,
			    		"Transcript": _TRANSCRIPT,
			            "Disposition": _DISP,
			            "EndDate": _ENDDATE,
			    		"GenesysId": _GENESYSID,
			    		"StartDate": _STARTDATE,
			    		"sfdc Object Id": _SFDC_ID,
				        "IsVerified": isVerified,
				        "VerificationTimeStamp" : verificationTimeStamp
			    }
		        		
				g_WorkspaceConnectorController.updateActivity(mapActivityUpdate, sfdcActivityId, function(result) {
			        _log("lz_update_activity RESULT = " + result);
			        //refreshTabsById(sfdcActivityId, true);
			        refreshTabsById(sfdcActivityId, false);
			    });
			    
			}
			else
			{
				lz_create_activity(updateObj,((updateObj.userData.sfdcObjectId === undefined) ? "" : updateObj.userData.sfdcObjectId));
				return;	
			}		
			resetActiveInteraction();	    	
		}
	);

}

function refreshTabsById(sfdcActivityId, openIfNotFound)
{
	sforce.console.getPrimaryTabIds(function(primaryTabs){
		refreshPrimaryTabsBasedOnObjectId(primaryTabs, sfdcActivityId, openIfNotFound);
	});
}

function refreshPrimaryTabsBasedOnObjectId(primaryTabIds, sfdcActivityId, openIfNotFound) {
    var tabFound=false;
    for(var idx = 0; idx<primaryTabIds.ids.length; idx++)
    {
    	var id = primaryTabIds.ids[idx];
    	sforce.console.getPageInfo(id , function(pageResult){
            var pageObj = JSON.parse(pageResult.pageInfo);
        	if(pageObj != null && pageObj.objectId != undefined && (sfdcActivityId.indexOf(pageObj.objectId) > -1)){
        		tabFound=true;		        	
                sforce.console.refreshPrimaryTabById(id, true);                
            }
        });
        sforce.console.getSubtabIds(id,function(subTabs) {
            refreshSubTabsBasedOnObjectId(subTabs, sfdcActivityId);
		});
    }
    if(openIfNotFound==true && tabFound==false)
    {
    	sforce.console.openPrimaryTab(null, '/' + sfdcActivityId, true);  
    }
}	

function refreshSubTabsBasedOnObjectId(subTabIds, sfdcActivityId) {
    for(var idx = 0; idx<subTabIds.ids.length; idx++)
    {
    	var id = subTabIds.ids[idx];
        sforce.console.getPageInfo(id , function(pageResult){
            var pageObj = JSON.parse(pageResult.pageInfo);
        	if(pageObj != null && pageObj.objectId != undefined && (sfdcActivityId.indexOf(pageObj.objectId) > -1)){		        	
                sforce.console.refreshSubtabById(id, true);
            }
        });
    }
}	

	

function createTask(createObj, objIdForActivity) {
	_log("in createTask");
	var createObjType = (createObj.type === undefined) ? getDisplayDate() : createObj.type;
    _log("createTask for " + createObjType);
    var displayDate = (createObj.startDate === undefined) ? getDisplayDate() : createObj.startDate;
    var lookupSource = "";
    var ixnType = "";
    var mediaType = "";
    var startDate = createObj.startDate;
    var endDate = createObj.endDate;    
    var transferredFrom = (createObj.transferredFrom===undefined) ? "" : createObj.transferredFrom;
    var _FIELDNAME = (createObj.fieldName === undefined) ? "" : createObj.fieldName;
    var _FIELDVALUE = (createObj.fieldValue === undefined) ? "" : createObj.fieldValue;

    switch (createObjType) {
        case "Voice":
            // if outbound then use destination as source
            if (createObj.calltype == "Outbound") {
                lookupSource = createObj.destination;
                //ixnType = "Outbound";
                mediaType = (createObj.mediatype === undefined) ? "" : createObj.mediatype;
                if(createObj.mediatype === undefined || createObj.mediatype === ""){
                	ixnType = "Voice-Outbound Dial"; 
                }
                else ixnType = "Voice-Outbound";
            }
            else {
                if (createObj.role == 'RoleOrigination') {
                    lookupSource = createObj.destination;
                    ixnType = "Voice-Outbound Dial";
                }
                else {
                    lookupSource = createObj.source;
                    ixnType = "Voice-Inbound";
                }
            }
            break;
        case "Email":        	
        	if(createObj.calltype == "Inbound" && createObj.source != undefined && createObj.source != ''){
        		lookupSource = createObj.source;
        		ixnType = "Email-Inbound";
        	}
        	else if(createObj.calltype == "Outbound" && createObj.destination != undefined && createObj.destination != ''){
        			lookupSource = createObj.destination;
        			ixnType = "Email-Outbound";
				 }
            break;
        case "Chat":
            //lookupSource=createObj.userData.FirstName + ' ' + createObj.userData.LastName
            lookupSource = createObj.source;
            ixnType = createObj.type;
            break;
        case "InteractionWorkItem":
            //lookupSource=createObj.userData.FirstName + ' ' + createObj.userData.LastName
            lookupSource = createObj.source;
            ixnType = createObj.type;
            mediaType = createObj.mediaType;
            break;
        case "Sms":
            //lookupSource=createObj.userData.FirstName + ' ' + createObj.userData.LastName
            lookupSource = createObj.source;
            //ixnType = createObj.type;
            //mediaType = createObj.mediaType;
            ixnType = createObj.type;
            break;
        case "WebCallback":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            break;            
        case "OpenMedia":
            //lookupSource=createObj.userData.FirstName + ' ' + createObj.userData.LastName
            lookupSource = createObj.source;
            //ixnType = createObj.type;
            //mediaType = createObj.mediaType;
            ixnType = createObj.mediaType;
            break;
        case "Social":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            break;
        default:
            _log("activity not created for " + createObj.type);
            return;
    }

    if (objIdForActivity != "") {
        _log("createTask: " + ixnType + " using objIdForActivity " + objIdForActivity);
    }
    else {
        _log("createTask: " + ixnType + " using field " + _FIELDNAME + " to search for a value of " + _FIELDVALUE);
        //_log("createTask: " + ixnType + " using lookupSource " + lookupSource + ", not objIdForActivity");
    }

    var _CALL_DURATION = (createObj.duration === undefined) ? "" : createObj.duration;
    var _IXNTYPE = ixnType;
    var _COMMENTS = (createObj.notes === undefined) ? "" : createObj.notes;
    var _DISP = (createObj.userData.DispositionCode === undefined) ? "" :
        createObj.userData.DispositionCode;
    var _DNIS = (createObj.destination === undefined) ? "" : createObj.destination;
    var _GENESYSID = (createObj.id === undefined) ? "" : createObj.id;
    var _ANI = (createObj.source === undefined) ? "" : createObj.source;
    var _SFDC_OBJECT_ID = objIdForActivity;
    
    //email specific
    var _Attachment_Flag = (createObj.Attachment_Flag === undefined) ? "" : createObj.Attachment_Flag;
    var _EMAIL_DESC = (createObj.emailDescription === undefined) ? "" : createObj.emailDescription;
    if(_EMAIL_DESC != ""){
    	_EMAIL_DESC = "\n" + "***EMAIL***" + _EMAIL_DESC;
    }
    
    var _CHAT_TRANSCRIPT = (createObj.transcript === undefined) ? "" : createObj.transcript;
    if(_CHAT_TRANSCRIPT != ""){
    	_CHAT_TRANSCRIPT = "\n" + "***CHAT***" + "\n" + _CHAT_TRANSCRIPT;
    }
    
    if(_COMMENTS != ""){
    	_COMMENTS = "*** NOTES ***" + "\n" + _COMMENTS;
    }
    if(_EMAIL_DESC != ""){
    		_COMMENTS = "\n" +_COMMENTS + _EMAIL_DESC;
    }
    if(_CHAT_TRANSCRIPT != ""){
    		_COMMENTS = "\n" +_COMMENTS + _CHAT_TRANSCRIPT;
    }

    
    var _SFDC1value = (createObj.SFDC1value === undefined) ? "" : createObj.SFDC1value;
    var _SFDC2value = (createObj.SFDC2value === undefined) ? "" : createObj.SFDC2value;
    var _SFDC3value = (createObj.SFDC3value === undefined) ? "" : createObj.SFDC3value;
    var _SFDC4value = (createObj.SFDC4value === undefined) ? "" : createObj.SFDC4value;
    var _SFDC5value = (createObj.SFDC5value === undefined) ? "" : createObj.SFDC5value;
    var _SFDC1field = (createObj.SFDC1field === undefined) ? "" : createObj.SFDC1field;
    var _SFDC2field = (createObj.SFDC2field === undefined) ? "" : createObj.SFDC2field;
    var _SFDC3field = (createObj.SFDC3field === undefined) ? "" : createObj.SFDC3field;
    var _SFDC4field = (createObj.SFDC4field === undefined) ? "" : createObj.SFDC4field;
    var _SFDC5field = (createObj.SFDC5field === undefined) ? "" : createObj.SFDC5field;

    _log("creating task map");
    var mapActivity = {
    	"Call Duration": _CALL_DURATION,
        "IXN Type": _IXNTYPE,
        "Comments": _COMMENTS,
        "Disposition": _DISP, "DNIS": _DNIS,
        "GenesysId": _GENESYSID, "ANI": _ANI,
        "sfdc Object Id": _SFDC_OBJECT_ID,
        "SFDC1value": _SFDC1value, "SFDC2value": _SFDC2value, "SFDC3value": _SFDC3value,
        "SFDC4value": _SFDC4value, "SFDC5value": _SFDC5value,
        "SFDC1field": _SFDC1field, "SFDC2field": _SFDC2field, "SFDC3field": _SFDC3field,
        "SFDC4field": _SFDC4field, "SFDC5field": _SFDC5field,
        "Media Type": mediaType,
        "DATE": displayDate, 
        "fieldName" : _FIELDNAME, "fieldValue" : _FIELDVALUE,
        "StartDate": startDate, "EndDate": endDate,
        "TransferredFrom": transferredFrom
    };

    g_WorkspaceConnectorController.createActivity(mapActivity, function(result, event) {
        _log("createActivity RESULT = " + result);

        if (result != null && result != "not found") {
            _log("redirect to new activity - " + result);
            if(_Attachment_Flag == 'True'){
            	_log("Get attachment info");
	        	//Attachment info is in the form of :
	        	//	"attachments": [
	            //		{"id":"1", "name":"a.zip", "desc":"file a", "mimeType":"gzip"},
	            //		{"id":"2", "name":"b.zip", "desc":"file b", "mimeType":"gzip"}
	        	//	]
	
	        	var attachmentInfo = createObj.attachments;
	            getAttachment(attachmentInfo,createObj.id,0,result);
            }
        }
        else {
            _log("Could not create task for");
        }
    	resetActiveInteraction();
    });
}

function getAttachment(arrAttachId,interactionId,idx,myTaskID){
	_log("in getAttachment");
    
    if(arrAttachId.length > idx ){
    	var wsParams = Workspace.getParameters();	
    	var msgJ;
    	if(arrAttachId.length == (idx+1))
    		//final request
    		msgJ = '{"action":"RequestAttachment",' + wsParams.CI_connectionData + ',"actionData":{"id":"' + interactionId + '","attachmentID":"' + arrAttachId[idx].id + '","attachmentName":"' + arrAttachId[idx].name + '","finalRequest":"true"}}';
    	else
    		msgJ = '{"action":"RequestAttachment",' + wsParams.CI_connectionData + ',"actionData":{"id":"' + interactionId + '","attachmentID":"' + arrAttachId[idx].id + '","attachmentName":"' + arrAttachId[idx].name + '"}}';
    	
        //this.requestUrl = wsParams.pollUrl + ":" + wsParams.pollPort + "/request=" + msgJ;
    	//_log("getAttachment url = " + this.requestUrl);
        this.requestUrl = wsParams.pollUrl + ":" + wsParams.pollPort;
        _log("getAttachment data = " + msgJ);
	    $.ajax({
	        url: requestUrl,
	        data: "/request=" + msgJ,
	        timeout: 20000,
	        async: true,
	        crossDomain: true,
	        cache: false,
	        //dataType: 'text',
	        dataType: 'jsonp',
	        success: function (data) {
	            // call the callback on retrieval

            	//setup first time call info
    			var attachmentInfo = arrAttachId[idx];
    			attachmentInfo.positionIndex = 0;
    			var attachmentId = null;
    			uploadAttachment(attachmentId,data,attachmentInfo,myTaskID);
    			getAttachment(arrAttachId,interactionId,idx+1,myTaskID);
        	},
	        error: function (xhr, ajaxOptions, thrownError) {
	            if (thrownError == 'timeout')
	                _log("Failed to connect for attachment request");
	            else
	                _log('Request error ' + xhr.status + ' ' + thrownError);
	        }
	    });
    }
}

/*
* Process the attachment data response
*/


var maxStringSize = 6000000;    //Maximum String size is 6,000,000 characters
var maxFileSize =   4350000;    
var chunkSize =      950000;    //Maximum Javascript Remoting message size is 1,000,000 characters


function uploadAttachment(attachmentId,attachmentData,attachmentInfo,myTaskID) {
    var attachmentBody = "";
    //var descriptionText = "";
    //var nameText = "";
    //var mimeType = "";
    var doneUploading = false;
    var positionIndex = attachmentInfo.positionIndex;
    var attachment = (attachmentData.attachment === undefined) ? "" : attachmentData.attachment;
    var descriptionText = (attachmentInfo.desc === undefined) ? "" : attachmentInfo.desc;
    var nameText = (attachmentInfo.name === undefined) ? "" : attachmentInfo.name;
    var mimeType = (attachmentInfo.mimeType === undefined) ? "" : attachmentInfo.mimeType;
    var fileSize = attachment.length;
    _log("uploadAttachment " + nameText + ", fileSize = " + fileSize);
    //temporary check to prevent this APEX error
    // String length exceeds maximum: 6000000
    if(fileSize > maxStringSize){
    	_log("error adding attachment - String length exceeds maximum: 6000000");
    	return;
    }
    
    _log("mimeType = " + mimeType);
    if(fileSize <= positionIndex + chunkSize) {
      attachmentBody = attachment.substring(positionIndex);
      doneUploading = true;
    } else {
      attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
    }
    

    _log("Uploading " + attachmentBody.length + " chars of " + fileSize);
    g_WorkspaceConnectorController.addAttachment(myTaskID,descriptionText,nameText,mimeType,attachmentBody,attachmentId, function(result){
    	_log("addAttachment result = " + result);
    	if(result != null && result != "error") {
        	//OOP = Attachment
          if(result.substring(0,3) == '00P') { 
            if(doneUploading == true) {
              _log("doneUploading");
              //refresh the attachment
              Salesforce.screenPopRefresh(myTaskID);
            } else {
              _log("continueUploading");             
              attachmentInfo.positionIndex += chunkSize; 
              _log("total uploaded so far = " + attachmentInfo.positionIndex);
              uploadAttachment(result,attachmentData,attachmentInfo,myTaskID);
            }
          }
        } else {
          _log("error adding attachment");
        }
      }
    );
  }

var tabId = function tabId(result){
		_log("tabId result = "+result.id);
		sforce.console.refreshPrimaryTabById(result.id,true,function(refreshResult){
			_log("refreshPrimaryTabById result = "+refreshResult.success);
		});
}

function getDateNow() {
    var date = new Date();
    var hrs = date.getHours();
    if(hrs < 10)
    	hrs = "0" + hrs;
    var min = date.getMinutes();
    if(min < 10)
    	min = "0" + min;
    var sec = date.getSeconds();
    if(sec < 10)
    	sec = "0" + sec;
    var day = date.getDate();
    if(day < 10)
    	day = "0" + day;
    var month = date.getMonth() + 1;
    if(month < 10)
    	month = "0" + month;
    return (date.getFullYear()) + '-' + month + '-' + day
        + " " + hrs + ':' + min + ':' + sec;
}


function resetActiveInteraction(){
	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
	{
		window.sessionStorage.setItem("Genesys_activeInteraction", "");
		_log("resetting Genesys_activeInteraction ");
	}	

}

})(window, jQuery, undefined);
