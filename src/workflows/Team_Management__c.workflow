<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Compliance_Round_Robin</fullName>
        <field>Compliance_Round_Robin__c</field>
        <literalValue>1</literalValue>
        <name>Update Compliance Round Robin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Excluded_Compliance_Round_Robin</fullName>
        <field>Compliance_Round_Robin__c</field>
        <literalValue>0</literalValue>
        <name>Update Excluded Compliance Round Robin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TM%3A Excluded Compliance Round Robin</fullName>
        <actions>
            <name>Update_Excluded_Compliance_Round_Robin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Team_Management__c.Compliance_RR__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Team_Management__c.Compliance_Status__c</field>
            <operation>notEqual</operation>
            <value>Live,Training</value>
        </criteriaItems>
        <description>FOR: Compliance Round Robin - WHY: To mark Final RR checkbox false.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TM%3A Included Compliance Round Robin</fullName>
        <actions>
            <name>Update_Compliance_Round_Robin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Team_Management__c.Compliance_Status__c</field>
            <operation>equals</operation>
            <value>Live,Training</value>
        </criteriaItems>
        <criteriaItems>
            <field>Team_Management__c.Compliance_RR__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>FOR: Compliance Round Robin - WHY: To mark Final RR checkbox true.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
