({

	validateIfFinanceUserIsLoggedIn: function (component) {
		//console.log('Inside validateIfFinanceUserIsLoggedIn');

		component.set('v.spinner', true);
		var action = component.get("c.isFinanceUser");
		action.setCallback(this, function (response) {
			var title;
			var type;
			var message;
			var state = response.getState();

			if (state === 'SUCCESS') {
				//console.log('response.getReturnValue() ~~~~~>   '+response.getReturnValue());
				if (!$A.util.isUndefinedOrNull(response.getReturnValue()) && response.getReturnValue() === true) {
					component.set("v.isNotAFinanceUser", false);
				} else {
					component.set("v.isNotAFinanceUser", true);
				}
				//console.log('isNotAFinanceUser--->'+component.get("v.isNotAFinanceUser"));
				this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
			} else if (state === 'ERROR') {
				title = "Error";
				type = "error";
				message = "Unable to verify if the logged in user is a Finance user!";
				this.showToast(title, type, message);
			}
			component.set('v.spinner', false);
		});
		$A.enqueueAction(action);
	},

	getpaymentrefunddetails: function (component, transactionid, transactiontype) {
		component.set('v.spinner', true);

		component.set('v.showClearOrDeclineDate', false);
		component.set('v.showSubmit', false);
		component.set('v.showCheckFields', false);
		component.set('v.showReasonFields', false);

		var action = component.get("c.populatePayments");
		action.setParams({
			orderId: transactionid,
			transactionType: transactiontype
		});
		action.setCallback(this, function (response) {
			var title;
			var type;
			var message;
			var state = response.getState();

			if (state === "SUCCESS") {
				var exceptionMessages = response.getReturnValue().exceptions;
				if (exceptionMessages) {
					var i = 0;
					for (; i < exceptionMessages.length; i = i + 1) {
						title = exceptionMessages[i].msgType;
						type = exceptionMessages[i].msgType;
						message = exceptionMessages[i].message;
						this.showToast(title, type, message);
					}
				}
				component.set("v.paymentdetails", response.getReturnValue().thePayment);
				component.set("v.transactionlabel", response.getReturnValue().transactionTypeLabel);
				//console.log('the value is '+JSON.stringify(response.getReturnValue()));
				if (!$A.util.isUndefinedOrNull(response.getReturnValue().thePayment) && !$A.util.isUndefinedOrNull(response.getReturnValue().thePayment.paymentProfileId)) {
					component.set("v.profilelabel", response.getReturnValue().thePayment.paymentProfileId);
				}
				this.firelabel(component, component.get("v.profilelabel"))

				component.set("v.refundtrasactionlabel", response.getReturnValue().transactionLabel);
				// <!-- STORY B-39061 -->
				if (!$A.util.isUndefinedOrNull(response.getReturnValue().thePayment)
					&& !$A.util.isUndefinedOrNull(response.getReturnValue().transactionTypeLabel)
					&& response.getReturnValue().transactionTypeLabel === 'Refund'
					&& response.getReturnValue().thePayment.paymentType === '3'
					&& component.get("v.isNotAFinanceUser") === false) {
					this.refundManual(component);
				}
				// <!-- STORY B-39061 -->
			} else if (state === 'ERROR') {
				title = "Error";
				type = "error";
				message = "An error occured when trying to load the Payment/Refund ";
				this.showToast(title, type, message);
			}
			component.set('v.spinner', false);
		});
		$A.enqueueAction(action);
	},

	updateTransactionStatusAndDate: function (component) {
		try {
			var state;
			var returnValue;
			component.set('v.spinner', true);
			var action = component.get("c.updateManualCheckStatus");
			action.setParams({
				//paymentDetails: JSON.stringify(component.get("v.paymentdetails")),
				clearedDeclinedDate: component.get("v.clearedDeclinedDate"),
				paymentTransactionId: component.get("v.paymentdetails.paymentTransactionId"),
				iadStatus: component.get("v.paymentdetails.iadStatus")
			});
			action.setCallback(this, function (response) {
				state = response.getState();
				if (state === 'SUCCESS') {
					returnValue = response.getReturnValue();
					// added By Harsha  - 04/08 - Bug TASK TK-87070 - STORY B-40440 - Starts Here
					if ($A.util.isUndefinedOrNull(returnValue) ? false : (returnValue === 'SUCCESS')) {
						this.showToast('SUCCESS', 'success', 'Success! Payment Transaction updated.');
						this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
					} else {
						this.showToast('FAIL', 'error', 'Unable to update Payment Transaction. Please try again later!');
					}
                    /*
                    if($A.util.isUndefinedOrNull(returnValue) ? false:($A.util.isUndefinedOrNull(returnValue.manualCheckStatusUpdated) ? false : returnValue.manualCheckStatusUpdated)){
                        this.showToast('SUCCESS', 'success', 'Success! Payment Transaction updated.');
                        this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
                    } else {
                        this.showToast('FAIL', 'error', 'Unable to update Payment Transaction.');
                    }
                    */
					// added By Harsha  - 04/08 - Bug TASK TK-87070 - STORY B-40440 - Ends Here
					//this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
				} else {
					this.showToast('FAIL', 'error', 'Unable to update Payment Transaction. Please try again later!');
				}
				component.set('v.spinner', false);
			});
			$A.enqueueAction(action);
		} catch (Err) {
			this.showToast('FAIL', 'error', 'Unable to update Payment Transaction :' + Err);
		}
	},

	setFocusedTabLabel: function (component, helper) {
		//var res;
		var workspaceAPI = component.find("workspace");
		workspaceAPI.getFocusedTabInfo().then(function (response) {
			//var focusedTabId = response.tabId;

			var taburl = response.url;

			var transactionid;
			var transactiontype;
			if (taburl.includes("?")) {
				var sParameterName;
				var sURLAndParams = taburl.split('?');
				//console.log('sURLAndParams: '+sURLAndParams);
				var sParams = sURLAndParams[1].split('&');
				//console.log('sParams: '+sParams);  
				//var customerId;
				for (var i = 0; i < sParams.length; i = i + 1) {
					sParameterName = sParams[i].split('='); //to split the key from the value.
					//console.log('sParameterName: '+sParameterName); 
					if (sParameterName[0] === 'transactionid') {
						transactionid = (sParameterName[1] !== null || sParameterName[1] !== '' || sParameterName[1] !== undefined) ? sParameterName[1] : '';
					} else if (sParameterName[0] === 'transactiontype') {
						transactiontype = (sParameterName[1] !== null || sParameterName[1] !== '' || sParameterName[1] !== undefined) ? sParameterName[1] : '';
					}
				}
			}
			component.set("v.transactionid", transactionid);
			component.set("v.transactiontype", transactiontype);
			helper.validateIfFinanceUserIsLoggedIn(component);

		})
			.catch(function (error) {
				console.log(error);
			});
	},

	showToast: function (title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		//console.log('toastEvent: ');
		//console.log(toastEvent);
		toastEvent.setParams({
			title: title,
			type: type,
			message: message
		});
		toastEvent.fire();
	},

	firelabel: function (component, myValue) {
		var appEvent = $A.get("e.c:IADPaymentProfileLabel");
		appEvent.setParams({
			"payProfileId": myValue
		});
		appEvent.fire();
	},

	/*STORY B-38496 - Changes Starts Here */
	handleStatusUpdate: function (component) {
		try {
			this.callApexToUpdate(component, component.get("v.paymentdetails.iadStatus"));
		} catch (Err) {
			this.resetAndToastError(component);
		}
	},

	callApexToUpdate: function (component, selectedOptionValue) {
		try {
			component.set('v.spinner', true);
			var transId = $A.util.isUndefinedOrNull(component.get("v.paymentdetails.paymentTransactionId")) ? '' : component.get("v.paymentdetails.paymentTransactionId");
			var reasonId = $A.util.isUndefinedOrNull(component.get("v.reasonCode")) ? '' : component.get("v.reasonCode");
			var reasonText = $A.util.isUndefinedOrNull(component.get("v.reasonText")) ? '' : component.get("v.reasonText");
			var resp;
			var state;

			var action = component.get('c.sendUpdatePaymentStatus');
			action.setParams({
				transactionId: transId,
				status: selectedOptionValue,
				reasonId: reasonId,
				reasonText: reasonText
			});
			action.setCallback(this, function (response) {
				state = response.getState();
				if (state === "SUCCESS") {
					resp = response.getReturnValue();
					if (!$A.util.isEmpty(resp)) {
						if (resp === "SUCCESS") {
							this.sucessAndToast(component, selectedOptionValue);
							this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
						} else if (resp === "FAILURE") {
							this.resetAndToastError(component);
						} else {
							this.showToast('Fail', 'error', 'Failed. Changes were not successfully updated : ' + resp);
						}
					} else {
						this.resetAndToastError(component);
					}
				} else {
					this.resetAndToastError(component);
				}
				component.set('v.spinner', false);
			});
			$A.enqueueAction(action);

		} catch (Err) {
			this.resetAndToastError(component);
			component.set('v.spinner', false);
		}
	},

	resetAndToastError: function (component) {
		this.showToast('Fail', 'error', 'Failed. Changes were not successfully updated');
	},

	sucessAndToast: function (component, selectedOptionValue) {
		this.showToast('SUCCESS', 'success', 'Success! Transaction changes saved.');
	},
	/*STORY B-38496 - Changes Ends Here */


	/*STORY B-38746 - Starts Here */
	callApexToRefundUpdate: function (component) {
		try {
			component.set('v.spinner', true);
			var transId = component.get("v.paymentdetails.paymentTransactionId");
			var action = component.get('c.sendRefundUpdateDetails');
			var state;
			var resp;

			action.setParams({
				transactionId: transId,
				status: component.find("creditCardStatusId").get("v.value"),
				checkDate: component.find("checkDateId").get("v.value"),
				checkNumber: component.find("checkNumberId").get("v.value")
			});
			action.setCallback(this, function (response) {
				state = response.getState();
				if (state === "SUCCESS") {
					resp = response.getReturnValue();
					if (!$A.util.isEmpty(resp)) {
						if (resp === 'SUCCESS') {
							this.showToast('SUCCESS', 'success', 'Success! Refund transaction updated.');
							this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
						} else if (resp === 'FAILURE') {
							this.showToast('Fail', 'error', 'Unable to update refund transaction.');
						} else {
							this.showToast('Fail', 'error', 'Unable to update refund transaction : ' + resp);
						}
					} else {
						this.showToast('Fail', 'error', 'Unable to update refund transaction.');
					}
				} else {
					this.showToast('Fail', 'error', 'Unable to update refund transaction.');
				}
				component.set('v.spinner', false);
			});
			$A.enqueueAction(action);
		} catch (Err) {
			this.showToast('Fail', 'error', 'Unable to update refund transaction.');
			component.set('v.spinner', false);
		}
	},

	handleRefundSubmitHelper: function (component) {
		var validate = this.validateSubmmit(component);
		if (validate === true) {
			//this.callApexToRefundUpdate(component);
			// <!-- STORY B-39061 -->
			this.callApexToRefundManual(component);
			// <!-- STORY B-39061 -->
		} else {
			return;
		}
	},

	validateSubmmit: function (component) {
		try {
			var errorMessages = [];
			var message = '';
			component.set("v.errorMessage", '');
			// <!-- STORY B-39061 -->
			if (component.get("v.showCheckFields")) {
				var statusValue = component.find("creditCardStatusId").get("v.value");
				var checkNumber = component.find("checkNumberId").get("v.value");
				var checkDate = component.find("checkDateId").get("v.value");
				if ($A.util.isEmpty(statusValue)) {
					errorMessages.push("Status");
				}
				if ($A.util.isEmpty(checkNumber)) {
					errorMessages.push("check number");
				}
				if ($A.util.isEmpty(checkDate)) {
					errorMessages.push("check Date");
				}
			}

			// check Address fields.
			if ($A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.addressLine1"))) {
				errorMessages.push("Address Line 1");
			}
			if ($A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.addressLine2"))) {
				errorMessages.push("Address Line 2");
			}

			if ($A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.city"))) {
				errorMessages.push("City");
			}
			if ($A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.stateId"))) {
				errorMessages.push("State");
			}
			if ($A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.zipCode"))) {
				errorMessages.push("Zip Code");
			}
			if ($A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.country"))) {
				errorMessages.push("Country");
			}
			if ($A.util.isEmpty(errorMessages) || errorMessages.length === 0) {
				return true;
			} else {
				message = 'Please complete these fields before saving : ';
				for (var i = 0; i < errorMessages.length; i++) {
					if (!$A.util.isUndefinedOrNull(errorMessages[i])) {
						//this.showToast( 'Fields are Missing', 'error', errorMessages[i]);
						message = message + ' ' + errorMessages[i];
					}
				}
				component.set("v.errorMessage", message);
				return false;
			}
			return true;
		} catch (Err) {
			component.set("v.errorMessage", JSON.stringify(Err));
			return false;
		}
	},
	/*STORY B-38746 -  Ends Here*/

	/* STORY B-39093 - Starts Here*/
    /*
    handleRefundStoreCreHelper : function (component){
        try{
            this.callApexToRefundStoreCredit(component);
        } catch (Err) {
            //console.log('Error in handleRefundStoreCreHelper Method ~~~~~> '+Err);
            this.showToast( 'Fail', 'error', 'Failed! Store Credit changes were not saved.');
        }
    },
    
    callApexToRefundStoreCredit: function (component) {
		try {
			component.set('v.spinner', true);
			var transId = $A.util.isUndefinedOrNull(component.get("v.paymentdetails.paymentTransactionId")) ? '':component.get("v.paymentdetails.paymentTransactionId") ;
            var reasonId = $A.util.isUndefinedOrNull(component.get("v.reasonCode")) ? '' : component.get("v.reasonCode");
            var reasonText = $A.util.isUndefinedOrNull(component.get("v.reasonText")) ? '':component.get("v.reasonText") ;
			var action = component.get('c.sendRefundStoreCreditUpdate');
			var state;
			var resp;
            
			action.setParams({
				transactionId: transId,
				status: component.find("creditCardStatusId").get("v.value"),
				reasonId: reasonId,
                reasonText: reasonText
			});
            
			action.setCallback(this, function (response) {
				state = response.getState();
				if (state === "SUCCESS") {
					resp = response.getReturnValue();
					if (!$A.util.isEmpty(resp)) {
						if (resp === 'SUCCESS') {
							this.showToast( 'SUCCESS', 'success', 'Success! Store Credit changes saved.');
                            this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
						} else if (resp === 'FAILURE') {
							this.showToast('Fail', 'error', 'Failed! Store Credit changes were not saved.');
						} else {
							this.showToast('Fail', 'error', 'Failed! Store Credit changes were not saved : ' + resp);
						}
					} else {
						this.showToast('Fail', 'error', 'Failed! Store Credit changes were not saved.');
					}
				} else {
					this.showToast( 'Fail', 'error', 'Failed! Store Credit changes were not saved.');
				}
				component.set('v.spinner', false);
			});
			$A.enqueueAction(action);
		} catch (Err) {
			//console.log('Error in callApexToRefundStoreCredit Method  ~~~~> ' + Err);
			this.showToast( 'Fail', 'error', 'Failed! Store Credit changes were not saved.');
			component.set('v.spinner', false);
		}
	},
    */
	/* STORY B-39093 - Ends Here */

	validateFormHelper: function (component) {
		try {
			//console.log('inside validateFormAndupdateTransactionStatus');
			if (component.get('v.changeType') === 'creditCard') {
				this.handleStatusUpdate(component);
			} else if (component.get('v.changeType') === 'manualCheckPayment') {
                /*
				var validForm = component.find('manualCheckForm').reduce(function (validSoFar, inputCmp) {
					// Displays error messages for invalid fields
					inputCmp.showHelpMessageIfInvalid();
					return validSoFar && inputCmp.get('v.validity').valid;
				}, true);
                
				*/
				var validForm = false;
				validForm = this.manualCheckFormValidate(component);
				if (validForm) {
					this.updateTransactionStatusAndDate(component);
				} else {
					return;
				}
			} else if (component.get('v.changeType') === 'refundManual') {
				this.handleRefundSubmitHelper(component);
			}
			/*else if(component.get('v.changeType') === 'storeCreditRefund'){
			this.handleRefundStoreCreHelper(component);
		}
		*/
		} catch (Err) {
			console.log('Error ~~~~~> ' + Err);
		}
	},

	handleStatusChangeHelper: function (component, event) {
		var seelctId = event.getSource().getLocalId();
		var selectedOptionValue = event.getParam("value");
		var oldValue = component.get('v.paymentdetails.iadStatus');
		if ($A.util.isUndefinedOrNull(oldValue)) {
			return;
			//console.log('I am Here ');
		}
		var transistionNotAllowed = false;
		//console.log('v.paymentdetails.iadStatus ~~~>'+component.get('v.paymentdetails.iadStatus'));
		//console.log(' var selectedOptionValue = event.getParam("value"); ~~~> '+selectedOptionValue);
		if (seelctId === 'creditCardStatusId') {
			if (component.get('v.transactionlabel') === 'Refund' && component.get('v.paymentdetails.paymentType') === '3') {
				if (selectedOptionValue === 'Approved' || selectedOptionValue === 'Pending' || selectedOptionValue === 'Declined') {
					component.set("v.changeType", 'refundManual');
					component.set("v.showCheckFields", true);
					component.set('v.showSubmit', true);
				} else {
					transistionNotAllowed = true;
				}
			} else if (component.get('v.transactionlabel') === 'Payment' && component.get('v.paymentdetails.paymentType') === '1') {
				//if(selectedOptionValue === 'Approved' || selectedOptionValue === 'Declined' ){
				if (selectedOptionValue === 'Approved' && component.get('v.paymentdetails.iadStatus') === 'Declined') {
					component.set("v.changeType", 'creditCard');
					component.set("v.showReasonFields", true);
					component.set('v.showSubmit', true);
				} else {
					transistionNotAllowed = true;
				}
                /*
            } else if(component.get('v.transactionlabel') === 'Refund' && component.get('v.paymentdetails.paymentType') === '4'){
                if(selectedOptionValue === 'Approved' || selectedOptionValue === 'Declined' ){
                    component.set("v.changeType", 'storeCreditRefund');
                    component.set("v.showReasonFields",true);
                    component.set('v.showSubmit', true);
                } else {
                    transistionNotAllowed = true;
                }
                */
			} else if (component.get('v.transactionlabel') === 'Payment' && component.get('v.paymentdetails.paymentType') === '3') {
				if (selectedOptionValue === 'Approved' || selectedOptionValue === 'Declined') {
					component.set("v.changeType", 'manualCheckPayment');
					component.set("v.showClearOrDeclineDate", true);
					component.set('v.showSubmit', true);
				} else {
					transistionNotAllowed = true;
				}
			}
			if (transistionNotAllowed) {
				this.showToast('Transistion Not Allow', 'error', 'This Status Transistion is not allowed');
				component.find("creditCardStatusId").set("v.value", oldValue);
				component.set('v.paymentStatus', oldValue);
				return;
			} else {
				component.set('v.paymentdetails.iadStatus', selectedOptionValue);
				component.set('v.paymentStatus', selectedOptionValue);
			}
		}
	},

	manualCheckFormValidate: function (component) {
		try {
			var statusValue = component.find("creditCardStatusId").get("v.value");
			var clearDate = component.find("manualCheckForm").get("v.value");

			var errorMessages = [];
			if ($A.util.isEmpty(statusValue)) {
				errorMessages.push("Please select value in Status Field");
			}
			if ($A.util.isEmpty(clearDate)) {
				errorMessages.push("Please select Cleared/Declined Date");
			}
			if ($A.util.isEmpty(errorMessages) || errorMessages.length === 0) {
				return true;
			} else {
				var i = 0;
				for (; i < errorMessages.length; i++) {
					if (!$A.util.isUndefinedOrNull(errorMessages[i])) {
						this.showToast('Fields are Missing', 'error', errorMessages[i]);
					}
				}
				return false;
			}
		} catch (Err) {
			this.showToast('FAIL', 'error', 'Unable to update Payment Transaction.');
		}
	},
	// <!-- STORY B-39061 -->
	refundManual: function (component) {
		component.set("v.changeType", 'refundManual');
		component.set('v.showSubmit', true);
		component.set("v.showCheckFields", true);
		return;
	},

	callApexToRefundManual: function (component) {
		try {
			component.set('v.spinner', true);
			var transId = component.get("v.paymentdetails.paymentTransactionId");
			var action = component.get('c.sendRefundUpdateDetails1');
			var state;
			var resp;
			let paramObj;
			paramObj = {
				customerId: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.customerId")) ? '' : component.get("v.paymentdetails.customerId"),
				transactionStatusDate: $A.util.isUndefinedOrNull(component.find("checkDateId").get("v.value")) ? '' : component.find("checkDateId").get("v.value"),
				status: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.iadStatus")) ? '' : component.get("v.paymentdetails.iadStatus"),
				checkNumber: $A.util.isUndefinedOrNull(component.find("checkNumberId").get("v.value")) ? '' : component.find("checkNumberId").get("v.value"),
				firstName: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.firstName")) ? '' : component.get("v.paymentdetails.mailingAddress.firstName"),
				lastName: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.lastName")) ? '' : component.get("v.paymentdetails.mailingAddress.lastName"),
				orderId: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.orderId")) ? '' : component.get("v.paymentdetails.orderId"),
				address1: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.addressLine1")) ? '' : component.get("v.paymentdetails.mailingAddress.addressLine1"),
				address2: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.addressLine2")) ? '' : component.get("v.paymentdetails.mailingAddress.addressLine2"),
				city: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.city")) ? '' : component.get("v.paymentdetails.mailingAddress.city"),
				stateId: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.stateId")) ? '' : component.get("v.paymentdetails.mailingAddress.stateId"),
				zipCode: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.zipCode")) ? '' : component.get("v.paymentdetails.mailingAddress.zipCode"),
				country: $A.util.isUndefinedOrNull(component.get("v.paymentdetails.mailingAddress.country")) ? '' : component.get("v.paymentdetails.mailingAddress.country")
			};
			action.setParams({
				'reqWrapStr': JSON.stringify(paramObj),
				'paymentTransactionId': transId
			});
			action.setCallback(this, function (response) {
				state = response.getState();
				resp = response.getReturnValue();
				if ((state === "SUCCESS") ? (($A.util.isEmpty(resp)) ? false : (resp === 'SUCCESS')) : false) {
					this.showToast('SUCCESS', 'success', 'Success! Refund transaction updated.');
					this.getpaymentrefunddetails(component, component.get("v.transactionid"), component.get("v.transactiontype"));
				} else if ((state === "SUCCESS") ? ($A.util.isEmpty(resp) ? false : (resp !== 'FAILURE')) : false) {
					this.showToast('Fail', 'error', 'Unable to update refund transaction : ' + resp);
				} else {
					this.showToast('Fail', 'error', 'Unable to update refund transaction.');
				}
				component.set('v.spinner', false);
			});
			$A.enqueueAction(action);
		} catch (Err) {
			this.showToast('Fail', 'error', 'Unable to update refund transaction : ' + JSON.stringify(Err));
			component.set('v.spinner', false);
		}
	},
	// <!-- STORY B-39061 -->
})
