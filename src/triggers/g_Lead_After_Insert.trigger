trigger g_Lead_After_Insert on Lead (after insert) {
	//Padma @B-33310
    /*String genesysId = trigger.new[0].Genesys_Interaction_Id__c;
    if(genesysId != null){
            g_WorkspaceConnectorController.linkActivityToObjectSelected(trigger.new[0].Id,genesysId);
    }*/
    
}