({
    doInit: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function () {
                    helper.setFocusedTabLabel(component, helper);
                }
            ),
            1000
        );
    },

    validateFormAndupdateTransactionStatus: function (component, event, helper) {
        helper.validateFormHelper(component);
    },

    closeFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({
                tabId: focusedTabId
            });
        })
            .catch(function (error) {
                console.log(error);
            });
    },

    /*STORY B-38496 - Changes Starts Here */
    handleStatusChange: function (component, event, helper) {
        helper.handleStatusChangeHelper(component, event);
    },
    /*STORY B-38496 - Changes Ends Here */
    // <!-- STORY B-39061 -->
    handleAddressChanges: function (component, event, helper) {
        var msg = event.getParam('mAddress') || '';
        component.set("v.paymentdetails.mailingAddress", msg);
    },
    // <!-- STORY B-39061 -->
})