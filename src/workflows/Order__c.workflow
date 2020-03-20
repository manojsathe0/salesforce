<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assign_to_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Closed_Vindicia</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_in_Queue</fullName>
        <field>Date_Declined__c</field>
        <formula>TODAY()</formula>
        <name>Date in Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Decline_Orders</fullName>
        <field>OwnerId</field>
        <lookupValue>Decline_Orders</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Decline Orders</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Order_Contact_Notes_Update</fullName>
        <description>Append order contact_notes_last_c to contact_notes_all__c.</description>
        <field>Contact_Notes_All__c</field>
        <formula>Text(Month(DATEVALUE( LastModifiedDate ))) + &apos;/&apos; + 
Text(Day(DATEVALUE( LastModifiedDate ))) + &apos;/&apos; + 
Text(Year(DATEVALUE( LastModifiedDate ))) + 
&apos; (&apos; + TEXT(Last_Touch_Point__c) + &apos;): &apos; + Contact_Notes_Last__c + BR() +  PRIORVALUE( Contact_Notes_All__c )</formula>
        <name>Order Contact Notes Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PRT_Lead_Status</fullName>
        <field>PRT_Lead_Status__c</field>
        <literalValue>Closed-Vindicia</literalValue>
        <name>PRT Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Declined_Orders_from_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>integration@legalzoom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Remove Declined Orders from Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AM_Account</fullName>
        <field>AM_Account__c</field>
        <literalValue>1</literalValue>
        <name>Update AM Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PRT_Lead_Status_to_blank</fullName>
        <field>PRT_Lead_Status__c</field>
        <name>Update PRT Lead Status to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_Field_To_Biz</fullName>
        <description>Updates the Vertical Team Field for Order Round Robin for Biz Order</description>
        <field>Team__c</field>
        <formula>&apos;LLC/INC Business Account Services&apos;</formula>
        <name>Update Team Field To Biz</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Trademark_Status_URL</fullName>
        <description>Update Trademark Status URL field</description>
        <field>Trademark_Status__c</field>
        <formula>IF( ISBLANK( USPTO_Serial_Number__c ), NULL , &apos;http://tsdr.uspto.gov/#caseNumber=&apos;+ TRIM(USPTO_Serial_Number__c)+&apos;&amp;caseType=SERIAL_NO&amp;searchType=statusSearch&apos;)</formula>
        <name>Update Trademark Status URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Declined Orders to Queue</fullName>
        <actions>
            <name>Date_in_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Decline_Orders</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_PRT_Lead_Status_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Order__c.Order_Payment_Status_Text__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Second_Installment_Status__c</field>
            <operation>equals</operation>
            <value>Past Due - Will Reharvest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Third_Installment_Status__c</field>
            <operation>equals</operation>
            <value>Past Due - Will Reharvest</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Decline Orders to vendicia</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Order__c.Order_Payment_Status_Text__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Second_Installment_Status__c</field>
            <operation>equals</operation>
            <value>Past Due - Will Reharvest,Past Due - Will Not Reharvest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Third_Installment_Status__c</field>
            <operation>equals</operation>
            <value>Past Due - Will Reharvest,Past Due - Will Not Reharvest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Date_Declined__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Assign_to_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>PRT_Lead_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>26</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ORDR%3A Update AM Account</fullName>
        <actions>
            <name>Update_AM_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>REQ: ORDR - FOR: Field Update. - WHY: When a Business Account Manager is the Owner of the Account check the AM Account checkbox.</description>
        <formula>Account__r.Business_Account_Manager__r.UserRole.Name= &quot;Business Account Manager&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ORDR%3A Update Contact Notes</fullName>
        <actions>
            <name>Order_Contact_Notes_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>REQ: ORDR - FOR: Field Update. - WHY: When the Contact Notes Last is not blank and is updated from it&apos;s preivous value update Contact Notes All to reflect updates with Last Modified timestamp, Last Touch Point picklist selection and prior ContactNotesAll.</description>
        <formula>NOT  ISBLANK(Contact_Notes_Last__c) &amp;&amp; Contact_Notes_Last__c !=  PRIORVALUE(Contact_Notes_Last__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Order Trademark Status URL</fullName>
        <actions>
            <name>Update_Trademark_Status_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the Trademark Status URL field based on the USPTO Serial # field</description>
        <formula>(ISNEW() &amp;&amp; NOT ISBLANK(USPTO_Serial_Number__c) ) || ISCHANGED(USPTO_Serial_Number__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Vertical Biz Team</fullName>
        <actions>
            <name>Update_Team_Field_To_Biz</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule populates the vertical team field value based on vertical field and several other criteria.</description>
        <formula>AND(      AND(ISBLANK(PRIORVALUE(Vertical__c)),NOT(ISBLANK(Vertical__c)) ),  ISBLANK(Account__r.Business_Account_Manager__c) , 
OR(Contact_State__c == &apos;CA&apos;,Contact_State__c == &apos;TX&apos;,Contact_State__c == &apos;NY&apos;,Contact_State__c == &apos;FL&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remove Declined Orders from Queue</fullName>
        <actions>
            <name>Remove_Declined_Orders_from_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) or 5</booleanFilter>
        <criteriaItems>
            <field>Order__c.Order_Payment_Status_Text__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.OwnerId</field>
            <operation>equals</operation>
            <value>Decline Orders</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Second_Installment_Status__c</field>
            <operation>notEqual</operation>
            <value>Past Due - Will Reharvest,Past Due - Will Not Reharvest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Third_Installment_Status__c</field>
            <operation>notEqual</operation>
            <value>Past Due - Will Reharvest,Past Due - Will Not Reharvest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Payment_Status_Text__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
