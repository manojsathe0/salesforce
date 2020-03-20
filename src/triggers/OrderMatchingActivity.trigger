trigger OrderMatchingActivity on Order_Matching_Activity__c (before insert) {

    //if(!OrderMatchingActivityService.hasCountByCampaignRun) //prevent recursive call.
    //{
        OrderMatchingActivityService.populateMatchedCampaign(Trigger.new);
        OrderMatchingActivityService.processForActivityCountByCampaign(Trigger.new);
    //}   
}