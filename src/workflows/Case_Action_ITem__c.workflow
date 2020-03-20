<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>X0_Day_email_alert</fullName>
        <description>0 Day email alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Item_s/Default_Case_Action_Item</template>
    </alerts>
    <alerts>
        <fullName>X1_Day_email_alert</fullName>
        <description>1 Day email alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Item_s/Default_Case_Action_Item</template>
    </alerts>
</Workflow>
