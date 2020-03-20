<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RoundRobinRule_Set_Object_Field_To_Lead</fullName>
        <description>Set object field to Lead.</description>
        <field>Object__c</field>
        <literalValue>Lead</literalValue>
        <name>RoundRobinRule Set Object Field To Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RoundRobinRule_Set_Object_Field_To_Oppor</fullName>
        <description>Set object field to Opportunity</description>
        <field>Object__c</field>
        <literalValue>Opportunity</literalValue>
        <name>RoundRobinRule Set Object Field To Oppor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Object_Filed_To_Order</fullName>
        <field>Object__c</field>
        <literalValue>Order</literalValue>
        <name>Update Object Filed To Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RRR%3A Update Object Field to Lead</fullName>
        <actions>
            <name>RoundRobinRule_Set_Object_Field_To_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RoundRobin_Rule__c.Team__c</field>
            <operation>equals</operation>
            <value>Attorney Services,Business Services,Quick Start</value>
        </criteriaItems>
        <description>REQ: RRR - FOR: Field Update. - WHY: Object field updated to Lead when the Team field values equal Attorney Services, Business Services, or Quick Start.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RRR%3A Update Object Field to Opportunity</fullName>
        <actions>
            <name>RoundRobinRule_Set_Object_Field_To_Oppor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RoundRobin_Rule__c.Team__c</field>
            <operation>equals</operation>
            <value>Chargebacks,IP Abandoners,AS BAP Courtesy,RA Renewal,IP Services,Declines,Abandoners,Order Save</value>
        </criteriaItems>
        <description>REQ: RRR - FOR: Field Update. - WHY: Object field updated to Opportunity when the Team field values equal Chargebacks, IP Abandoners, AS BAP Courtesy, RA Renewal, IP Services, Declines, or Abandoners.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RRR%3A Update Object Field to Order</fullName>
        <actions>
            <name>Update_Object_Filed_To_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RoundRobin_Rule__c.Team__c</field>
            <operation>equals</operation>
            <value>Trademark Account Services</value>
        </criteriaItems>
        <description>REQ: RRR - FOR: Field Update. - WHY: Object field updated to Order when the Team field value equals Trademark Account Services.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
