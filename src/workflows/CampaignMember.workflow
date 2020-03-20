<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_DateTime_added_to_Campaign</fullName>
        <field>DateTime_Added_to_Campaign__c</field>
        <formula>NOW()</formula>
        <name>Update DateTime added to Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update DateTime added to campaign when added to Campaign</fullName>
        <actions>
            <name>Update_DateTime_added_to_Campaign</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>Added,Sent</value>
        </criteriaItems>
        <description>This WF rule updates the &apos;DateTime Added to Campaign&apos; field whenever a campaign memebr is added to campaign</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
