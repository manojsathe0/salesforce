/*
Created per story: B-25593		
By: Artyom M.
A button to open the search window with custom search URL from the contact.  
*/

({	
	doInit : function(component, event, helper) {
		console.log('Current URL: ' + window.location.href);
    },
	differentContact : function(component, event, helper) {
		function getURLParameter(name) {
			var url = window.location.href;
			return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(url) || [, ""])[1].replace(/\+/g, '%20')) || null
		}
		
		
		function getNewURL() {
		    if (getURLParameter('openCustomSearch') != null) {
		        var rebuiltURL = getURLParameter('openCustomSearch').replace('IADSearch|', 'apex/IADSearch?');
		        while (rebuiltURL.indexOf('|') >= 0) {
		            rebuiltURL = rebuiltURL.replace('|', '&');
		        }
		        rebuiltURL += '&isdtp=vw&isWsVw=true';
		        if (getURLParameter('sfdcIFrameOrigin') != null)
		            rebuiltURL += '&sfdcIFrameOrigin=' + getURLParameter('sfdcIFrameOrigin');
		        if (getURLParameter('nonce') != null)
		            rebuiltURL += '&nonce=' + getURLParameter('nonce');
		        rebuiltURL += '&openCustomSearch=' + getURLParameter('openCustomSearch');
		        return rebuiltURL;
		    } else
		        return '';
		}
		var fullURL = getNewURL();
		if (fullURL != '') {
		    if (typeof(srcUp) == 'function') {
		    	console.log("Going to1: " + fullURL);
		    	helper.gotoURL(component, fullURL);
		    } else {
		    	console.log("Going to2: " + fullURL);
		    	helper.gotoURL(component, fullURL);
		    }
		}
		else {
			helper.showMessage(component, "Not Opened from Search Page.");
		}
    },
    closeMessage : function(component, event, helper) {
        component.set("v.displayMessage", false);
    }
    
})