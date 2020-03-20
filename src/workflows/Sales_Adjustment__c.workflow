<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Sales_Adjustment_Approved_Email</fullName>
        <description>Sales Adjustment Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>aleinweber@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>echoi@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyip@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>svirani@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Adjustment/Sales_Adjustment_Approved</template>
    </alerts>
    <alerts>
        <fullName>Sales_Adjustment_Rejected_Email</fullName>
        <description>Sales Adjustment Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>aleinweber@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>echoi@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyip@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>svirani@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Adjustment/Sales_Adjustment_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_Approved_Amount_of_Adjustment</fullName>
        <field>Approved_Amount_of_Adjustment__c</field>
        <formula>IF(ISPICKVAL(Status__c, &quot;Approved&quot;),  Amount_of_Adjustment__c, NULL)</formula>
        <name>Populate Approved Amount of Adjustment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approved_Amt_of_Adj_Values</fullName>
        <field>Approved_Amount_of_Adjustment__c</field>
        <name>Remove Approved Amt of Adj Values</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Adjustment_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Sales Adjustment Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Adjustment_Awaiting_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting Approval</literalValue>
        <name>Sales Adjustment Awaiting Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Adjustment_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Sales Adjustment Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Adjustment_Submit_for_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Submit for Approval</literalValue>
        <name>Sales Adjustment Submit for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>SA%3A Update Approved Amt of Adj</fullName>
        <actions>
            <name>Remove_Approved_Amt_of_Adj_Values</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sales_Adjustment__c.Status__c</field>
            <operation>equals</operation>
            <value>Submit for Approval,Awaiting Approval,Rejected</value>
        </criteriaItems>
        <description>REQ: SA - FOR: Field Update. - WHY: Remove value from Approved Amount of Adjustment if Status of record ever changes from Approved as Agents should only see approved amounts.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
