/*
Screen pop functions that open SF tabs, subtabs or browser tabs for certain types of SF objects.
Search functions that search for specified object types by specified criteria. 
	Search functions will return results to a callback function that decides how to act 
	(screen pop, display list, other action).
Receive click-to-dial, click-to-email events and route them via Events object.
Functions to enable/disable SF features (e.g. stop routing click-to events).
Functions to create new SF objects (allow hooks on before/after creation).

*/

(function(window, undefined) {

var _log = Log ? Log.log : console.log;

var _inServiceCloudConsole;
var ixnWindows = []; // interaction ID -> SF Tab object ID

////////////////////////////////////////////////////////////////////////////////////////
// *** Search Handling **** //
////////////////////////////////////////////////////////////////////////////////////////

function openCustomSearch(
	phoneField, first, last, email, 
	stateOfFormation, caseNumber, 
	orderNumber, processingNumber, entity, 
	ixnId, profile) {
    var searchString ="";
    searchString += phoneField!=null ? (searchString!="" ? "&" : "") + "lksrch=" + phoneField : "";
    searchString += first!=null ? (searchString!="" ? "&" : "") + "lkfirst=" + first : "";
    searchString += last!=null ? (searchString!="" ? "&" : "") + "lklast=" + last : "";
    searchString += email!=null ? (searchString!="" ? "&" : "") + "lkemail=" + email : "";
    searchString += stateOfFormation!=null ? (searchString!="" ? "&" : "") + "lkformation=" + stateOfFormation : "";
    searchString += caseNumber!=null ? (searchString!="" ? "&" : "") + "lkcase=" + caseNumber : "";
    searchString += orderNumber!=null ? (searchString!="" ? "&" : "") + "lkorder=" + orderNumber : "";
    searchString += processingNumber!=null ? (searchString!="" ? "&" : "") + "lkprocessing=" + processingNumber : "";
    searchString += entity!=null ? (searchString!="" ? "&" : "") + "lkentity=" + entity : "";
    searchString += profile!=null ? (searchString!="" ? "&" : "") + "lkprofile=" + profile : "";
    
   // var url = "https://legalzoom--qa.cs12.my.salesforce.com/apex/IADSearch?" + (searchString!="" ? searchString + "&" : "") + "ixnId=" + ixnId + "&inServiceCloudConsole=" + inServiceCloudConsole();
   // var url = "https://legalzoom--qa.lightning.force.com/one/one.app#/alohaRedirect/apex/IADSearch?" + (searchString!="" ? searchString + "&" : "") + "ixnId=" + ixnId + "&inServiceCloudConsole=" + inServiceCloudConsole();
	var url = "/one/one.app#/alohaRedirect/apex/IADSearch?" + (searchString!="" ? searchString + "&" : "") + "ixnId=" + ixnId + "&inServiceCloudConsole=" + inServiceCloudConsole();
    //var url = "/one/one.app#/n/Lead_Scoring";
    
    var openCustomSearch = encodeURIComponent(url);
    _log("openCustomSearch url = " + url);
    url = url + "&openCustomSearch=" + openCustomSearch;

	openSearchAsync(url);
	
   

}
function openSearchAsync(url) {
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
      console.log('enterd the openSearchAsync '+ url);

      sforce.opencti.screenPop({
      			type: sforce.opencti.SCREENPOP_TYPE.URL,
      			params: { url: url },
      			deferred: true,
      			callback:callback
         });
	}, 2500);
  });
  return d.promise();
}

function openSearch(searchField, ixnId) {
    _log("openSearch for " + searchField);
    //var urlString = "/apex/CustomContactLookupBA?lksrch="+searchField + "&ixnId=" + ixnId;
    var url = "apex/IADSearch?lksrch=" + searchField + "&ixnId=" + ixnId
    	+ "&inServiceCloudConsole=" + inServiceCloudConsole();
    _log("openSearch url = " + url);

   screenPop(url, "Search");
}

function openSearchCase(searchField, ixnId) {
    _log("openSearchCase for " + searchField);
    //PJB: use custom case search
    return openCustomSearch(
		null, null, null, null, 
		null, searchField, 
		null, null, null, 
		ixnId,
		null);
    //var urlString = "/apex/CustomContactLookupBA?lksrch="+searchField + "&ixnId=" + ixnId;
    var url = "apex/g_CustomCaseLookup?lksrch=" + searchField + "&ixnId=" + ixnId + "&inServiceCloudConsole=" + inServiceCloudConsole();
    _log("openSearchCase url = " + url);

    screenPop(url, "Search");
}

function screenPopNoFocus(url,subject){

url = "/" + url;

//openSearchAsync(url);
	sforce.opencti.screenPop({
			type: sforce.opencti.SCREENPOP_TYPE.URL,
			params: { url: url }
   });
}

//EOC Padma
// url should not include leading slash, "/".
// url may consist of SF Object ID only.
function screenPop(id, caseNumber, urlIn) {
	_log("screenPop id:" + id + " caseNumber:" + caseNumber + " urlIn:" + urlIn);
	var SF_obj = id;
	var url = "/" + SF_obj;
	if(urlIn)
		url = urlIn;
    if (inServiceCloudConsole()) {
        sforce.console.openPrimaryTab(null, url, true, caseNumber, function(result) {
			if(result.success == false){
				//tab is already open 
				//need to find tab
				_log("screenPop already opened");
				sforce.console.getPrimaryTabIds(function(getResult) {
			       //result is an array of open primary tab IDs , in order of appearance.
					if(urlIn)
						reloadPrimaryTab(getResult, SF_obj, 0, url);
					else
						processPrimaryTabs(getResult, SF_obj, 0);
				});
			}
        });
    }
    else {
        //sforce.interaction.screenPop(url, function(response) {});

       /* sforce.opencti.screenPop({
      			type: sforce.opencti.SCREENPOP_TYPE.URL,
      			params: { url: url },
      			deferred: true,
      			callback:function(response){}
         }); */
         openSearchAsync(url);
    }

}
function openTabAsync(SF_obj) {
	var checkScreenpopStatus = function(response) {
		 if (response.success) {
			console.log('API method call executed successfully! returnValue:', response.returnValue);
		 } else {
			console.error('Something went wrong! Errors:', response.errors);
		 }
	};
  var d = $.Deferred(function (d) {
    setTimeout(function () {
      d.resolve("Ok");
      sforce.opencti.screenPop({
			type: sforce.opencti.SCREENPOP_TYPE.SOBJECT,
			params: { recordId: SF_obj },
			callback: checkScreenpopStatus
		});
	}, 2500);
  });
  return d.promise();
}

function reloadPrimaryTab(primaryTabs, SF_obj, count, newURL)
{
	_log("in reloadPrimaryTab");
	//primaryTabs is an array of open primary tab IDs , in order of appearance.
	var numOpenTabs = primaryTabs.ids.length;
	_log("numOpenTabs = " + numOpenTabs);
	if(count == numOpenTabs){
		_log("no match");
		return;
	}
    sforce.console.getPageInfo(primaryTabs.ids[count] , function(pageResult){
        //pageResult of getPageInfo = {"objectId":"001c000000YZ0Sp","url":"https://srmkaplanedu--dev2.cs14.my.salesforce.com/001c000000YZ0Sp"}
    	var myObj = JSON.parse(pageResult.pageInfo);
    	if(myObj != null && myObj.objectId != undefined)
    		_log("myObj.objectId = " + myObj.objectId);
        if(myObj != null && myObj.objectId != undefined && (SF_obj.indexOf(myObj.objectId) > -1)){
        	_log("found match primaryTabId");
        	var primaryTabId = primaryTabs.ids[count];
/*        	sforce.console.closeTab(primaryTabId, function(closeResult){
        		sforce.console.openPrimaryTab(null, newURL, true);
        	});*/

        	sforce.opencti.screenPop({
					type: sforce.opencti.SCREENPOP_TYPE.URL,
					params: { url: newURL },
					callback: doRefresh
		   });
        }
        _log("check next tab");
        count = count + 1;
        reloadPrimaryTab(primaryTabs, SF_obj, count, newURL);
    });
}

function processPrimaryTabs(primaryTabs, SF_obj, count){
	_log("in processPrimaryTabs");
	//primaryTabs is an array of open primary tab IDs , in order of appearance.
	var numOpenTabs = primaryTabs.ids.length;
	_log("numOpenTabs = " + numOpenTabs);
	if(count == numOpenTabs){
		_log("no match");
		return;
	}
    sforce.console.getPageInfo(primaryTabs.ids[count] , function(pageResult){
        //pageResult of getPageInfo = {"objectId":"001c000000YZ0Sp","url":"https://srmkaplanedu--dev2.cs14.my.salesforce.com/001c000000YZ0Sp"}
    	var myObj = JSON.parse(pageResult.pageInfo);
    	if(myObj != null && myObj.objectId != undefined)
    		_log("myObj.objectId = " + myObj.objectId);
        if(myObj != null && myObj.objectId != undefined && (SF_obj.indexOf(myObj.objectId) > -1)){
        	_log("found match primaryTabId");
        	var primaryTabId = primaryTabs.ids[count];
        	sforce.console.refreshPrimaryTabById(primaryTabId, false);
        	return;
        }
        _log("check next tab");
        count = count + 1;
        processPrimaryTabs(primaryTabs, SF_obj, count);
    });
}

function refreshClickToDial(SF_obj){
	_log("in refreshClickToDial");
	sforce.console.getPrimaryTabIds(function(getResult) {
	       //result is an array of open primary tab IDs , in order of appearance.
			processPrimaryTabs(getResult, SF_obj, 0);
		});
}

function refreshPrimaryTab(result) {
    if (result.id != null) {
        _log("refreshPrimaryTab result.id = " + result.id);
        sforce.console.refreshPrimaryTabById(result.id, false);
    }
}

function screenPopRefresh(url, caseNumber) {
	url = "/" + url;
	var doRefresh = function(response) {
		 if (response.success) {
			console.log('API method call executed successfully! returnValue:', response.returnValue);
			var param = {};

			sforce.opencti.refreshView(param);

		 } else {
			console.error('Something went wrong! Errors:', response.errors);
		 }
	};
    sforce.opencti.screenPop({
			type: sforce.opencti.SCREENPOP_TYPE.URL,
			params: { url: url },
			callback: doRefresh
   });
}

function consolePop(url, caseNumber) {
    sforce.opencti.screenPop({
			type: sforce.opencti.SCREENPOP_TYPE.URL,
			params: { url: url }
   });
}

// returns true if screen pop performed
function screenPopUser(obj) {
    // check for attached data sfdcObjectId - if it is already there, then pop that
    var id = obj.userData.sfdcObjectId;
    if (id !== undefined) {
        _log("sfdcObjectId = " + id);
        screenPop(id);
        return true;
    }
    return false;
}

function inServiceCloudConsole() {
	return _inServiceCloudConsole;
} 
/*function inServiceCloudConsole() {
	_inServiceCloudConsole = true;
	console.log('value of _inServiceCloudConsole is '+_inServiceCloudConsole);
	return _inServiceCloudConsole;
}*/

function setInServiceCloudConsole(inConsole) {
	_inServiceCloudConsole = inConsole;
}

////////////////////////////////////////////////////////////////////////////////////////
// Interaction Windows (tabs) tracking
////////////////////////////////////////////////////////////////////////////////////////

function addIxnWindow(ixnId, tabId) {
	/* TODO
	_log("addIxnWindow - " + ixnId + ", " + tabId);
	ixnWindows[ixnId] = tabId;
	*/
}

function removeIxnWindow(ixnId) {
	/* TODO
	_log("removeIxnWindow - " + ixnId);
	delete ixnWindows[ixnId];
	*/
}

function getIxnTabId(ixnId) {
	_log("getIxnTabId from ixnWindow - " + ixnId);
	return ixnWindows[ixnId];
}

function getIxnId(tabId) {
	_log("getIxnId from ixnWindow - " + tabId);
	var index = jQuery.inArray(tabId, ixnWindows);
	for (var id in ixnWindows) {
		  if (ixnWindows.hasOwnProperty(id)) { 
		    _log("id: " + id + " value: " + ixnWindows[id])
		    if(ixnWindows[id].indexOf(tabId) > -1){
		    	return id;
		    }
		  }
	}

	$.each(ixnWindows, function( k, v ) {
		_log( "Key: " + k + ", Value: " + v );
		});
	return null;
	//return (index < 0) ? null : ixnWindows[index];
}

// bring a primary tab to front
function focusIxnTab(ixnId) {
    _log("focusIxnTab for " + ixnId);
    var tabId = Salesforce.getIxnTabId(ixnId);
    if (tabId) {
    	Salesforce.consolePop(tabId);
    }
}

////////////////////////////////////////////////////////////////////////////////////////
//Using Salesforce search and search page
////////////////////////////////////////////////////////////////////////////////////////

function SF_SearchAndPop_inboundV(obj) {
	_log("SF_SearchAndPop_inboundV");
	var ANI = '';
	var OtherDN = '';
	if(obj.source != undefined && obj.source != '')
		ANI = obj.source;
	
	if(obj.OtherDN != undefined && obj.OtherDN != '')
		OtherDN = '';
	
	if(ANI == '' && OtherDN == '' ){
		//nothing to search
		SF_default_search(ANI);
		return;
	}	
	
	var multiFind = false;
	
	if(ANI != ''){
		//sforce.interaction.searchAndScreenPop(ANI,'','inbound',function(response1) {
		sforce.opencti.searchAndScreenPop({searchParams :ANI,queryParams :'', callType : sforce.opencti.CALL_TYPE.INBOUND ,deferred:true,function(response1) {
			if(response1.result && (response1.result.indexOf("Name")>-1) && ((response1.result.match(/Name/g).length > 1))){
				multiFind = true;
				_log('ANI search result = ' + response1.result);
			}
			if(!response1.error && response1.result != "{}" && !multiFind){
				_log("SF_search_and_pop success ANI");
			}  else {
			    _log("SF_search_and_pop fail");
			    multiFind = false;
			    if(OtherDN != ''){
			    	//sforce.interaction.searchAndScreenPop(OtherDN,'','inbound',function(response2) {
			    	sforce.opencti.searchAndScreenPop({searchParams :OtherDN,queryParams :'', callType : sforce.opencti.CALL_TYPE.INBOUND ,deferred:true, function(response2) {
			    		if(response2.result && (response2.result.indexOf("Name")>-1 )&& ((response2.result.match(/Name/g).length > 1))){
							multiFind = true;	
							_log('OtherDN search result = ' + response2.result);
						}
			    		if(!response2.error && response2.result != "{}" && !multiFind){
							_log("SF_search_and_pop success OtherDN");
						} 
			    		else
			    			SF_default_search(OtherDN);
    			    }});
			    	//});
			    }
			    else
			    	//Screen pop failed for ANI and no OtherDN so pop default search
			    	SF_default_search(ANI);
			}
		}});
		//});
	}
	else //ANI is blank, use OtherDN
	{
		//sforce.interaction.searchAndScreenPop(OtherDN,'','inbound',function(response2) {
		sforce.opencti.searchAndScreenPop({searchParams :OtherDN, queryParams :'', callType : sforce.opencti.CALL_TYPE.INBOUND , deferred:true, function(response2) {
    		if(response2.result && (response2.result.indexOf("Name")>-1 )&& ((response2.result.match(/Name/g).length > 1))){
				multiFind = true;	
				_log('OtherDN search result (no ANI) = ' + response2.result);
			}
    		if(!response2.error && response2.result != "{}" && !multiFind){
				_log("SF_search_and_pop success OtherDN");
			} 
    		else
    			SF_default_search(OtherDN);
		}});
    	//});
	}
	
}


function SF_SearchAndPop_outboundV(obj) {
	_log("SF_SearchAndPop_inboundV");
	var phoneField = '';
	if(obj.destination != undefined && obj.destination != '')
		phoneField = obj.destination;
	if(phoneField != ''){
		//sforce.interaction.searchAndScreenPop(phoneField,'','inbound',function(response1) {
		sforce.opencti.searchAndScreenPop({searchParams :phoneField, queryParams :'', callType : sforce.opencti.CALL_TYPE.INBOUND , deferred:true, function(response1) {
			if(response1.result && (response1.result.indexOf("Name")>-1) && ((response1.result.match(/Name/g).length > 1))){
				multiFind = true;
				_log('phoneField search result = ' + response1.result);
			}
    		if(!response1.error && response1.result != "{}" && !multiFind){
				_log("SF_search_and_pop success phoneField");
			} 
    		else
    			SF_default_search(phoneField);
		}});
		//});
	}
	else
		SF_default_search(phoneField);
}

function SF_SearchAndPop_email(emailAddr){
	_log("SF_SearchAndPop_email");
	if(emailAddr != '') {
		sforce.interaction.searchAndGetScreenPopUrl(emailAddr, '','inbound', function(response) {
			//result for match = "{"003i0000019vXt5":{"Name":"Pat Thompson","object":"Contact","Title":""},"screenPopUrl":"/003i0000019vXt5"}"
			if(response.result){
				_log("URL = " + response.result);
				var jParse = JSON.parse(response.result);
				if(jParse.screenPopUrl!=null) {
					var numEntries=Object.keys(jParse).length;
					_log("numEntries = "+ numEntries);
					if(numEntries == 2){
						sforce.interaction.screenPop(jParse.screenPopUrl, function(response) {});
						return;
					}
				}
			}
			SF_default_search(emailAddr);
		});
	}
	else
		SF_default_search(emailAddr);
}


function SF_default_search(searchField){
	_log("SF_default_search");
	var url = '/_ui/search/ui/UnifiedSearchResults?isdtp=nv&searchType=2&sen=003&sen=00Q&searchType=2&str=' + searchField;
	sforce.interaction.screenPop(url, function(response) {});
}


var Salesforce = {
	"openSearch": openSearch,
	"openCustomSearch": openCustomSearch,
	"openSearchCase": openSearchCase,
	"screenPop": screenPop,
	"screenPopRefresh": screenPopRefresh,
	"consolePop": consolePop,
	"screenPopUser": screenPopUser,
	"inServiceCloudConsole": inServiceCloudConsole,
	"setInServiceCloudConsole": setInServiceCloudConsole,
	"addIxnWindow": addIxnWindow,
	"removeIxnWindow": removeIxnWindow,
	"getIxnTabId": getIxnTabId,
	"getIxnId": getIxnId,
	"focusIxnTab": focusIxnTab,
	"SF_SearchAndPop_inboundV": SF_SearchAndPop_inboundV,
	"SF_SearchAndPop_outboundV": SF_SearchAndPop_outboundV,
	"SF_SearchAndPop_email": SF_SearchAndPop_email,
	"refreshClickToDial":refreshClickToDial,
	"screenPopNoFocus": screenPopNoFocus

};

window["Salesforce"] = Salesforce;

})(window, undefined);
