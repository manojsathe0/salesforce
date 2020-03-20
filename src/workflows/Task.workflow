<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activity_Type</fullName>
        <field>Activity_Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Activity Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_Time_Spent_Now</fullName>
        <field>Time_Spent_Now_min__c</field>
        <name>Blank Time Spent Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Minisite_Update_Object_Date_Time</fullName>
        <field>DateTime_Object__c</field>
        <formula>NOW()</formula>
        <name>Minisite:Update Object Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Minisite_Update_Read_Script_Date_Time</fullName>
        <field>Read_Script_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Minisite:Update Read Script Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Activity_Email_Field_Update</fullName>
        <field>Type</field>
        <literalValue>Email</literalValue>
        <name>Sales Activity Email - Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Activity_Field_Update_CE</fullName>
        <field>Commission_Eligible__c</field>
        <literalValue>1</literalValue>
        <name>Sales Activity - Field Update CE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Activity_Field_Update_Contacted</fullName>
        <field>Contacted__c</field>
        <literalValue>1</literalValue>
        <name>Sales Activity - Field Update Contacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Activity_Field_Update_Email_CE</fullName>
        <field>Commission_Eligible__c</field>
        <literalValue>1</literalValue>
        <name>Sales Activity - Field Update Email CE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Activity_Field_Update_Lead_Statu</fullName>
        <description>Update Lead Status to Qualified-Interested On creation of Commission Eligible Activity</description>
        <field>Lead_Status__c</field>
        <literalValue>Qualified (Interested)</literalValue>
        <name>Sales Activity - Field Update Lead Statu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Task_Call_Field_Update</fullName>
        <field>Type</field>
        <literalValue>Call</literalValue>
        <name>Sales Task Call - Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Type</fullName>
        <description>Update Email Type to Outgoing.</description>
        <field>Email_Type__c</field>
        <literalValue>Outgoing</literalValue>
        <name>Update Email Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Time_Spent</fullName>
        <field>Total_Time_Spent__c</field>
        <formula>Time_Spent_Now_min__c + Total_Time_Spent__c</formula>
        <name>Update Total Time Spent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <flowActions>
        <fullName>Update_Order_from_Task</fullName>
        <flow>Order_Status_Updates_from_Activity</flow>
        <flowInputs>
            <name>TaskID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Update Order from Task</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <rules>
        <fullName>Sales Activity Contacted - Update Task</fullName>
        <actions>
            <name>Sales_Activity_Field_Update_CE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Activity_Field_Update_Contacted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Activity_Field_Update_Lead_Statu</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Task.Contact_Status__c</field>
            <operation>equals</operation>
            <value>Contacted/Spoke - Commission Eligible</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Contact_Status__c</field>
            <operation>equals</operation>
            <value>Chat</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Activity Email - Update Task</fullName>
        <actions>
            <name>Sales_Activity_Email_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Activity_Field_Update_Email_CE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Contact_Status__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Activity Not Contacted - Update Task</fullName>
        <actions>
            <name>Sales_Task_Call_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Contact_Status__c</field>
            <operation>equals</operation>
            <value>VM Attempt 1,NM Attempt 2,NM Attempt 3,NM Attempt 4,VM Final Attempt,Contacted/Spoke - Ineligible,Call Transferred,Service Unavailable</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TASK%3A Activity Type</fullName>
        <actions>
            <name>Activity_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FOR: Reportable Field. - WHY: To copy the values for the activity type field into a new custom field on Activities.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TASK%3A Minisite-Update Object Date%2FTime</fullName>
        <actions>
            <name>Minisite_Update_Object_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Customer_did_NOT_Object__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FOR: Date/Time Update. - WHY: To time stamp when Customer did NOT Object was checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TASK%3A Ministe-Update Read Script Date%2FTime</fullName>
        <actions>
            <name>Minisite_Update_Read_Script_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Did_you_read_the_entire_script__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FOR: Date/Time Update. - WHY: To time stamp when Did you read the entire script? was checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TASK%3A Update Email Type</fullName>
        <actions>
            <name>Update_Email_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CreatedById</field>
            <operation>equals</operation>
            <value>Integration User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Automated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>REQ: POR - FOR: Automation. - WHY: When an automated email is sent the Email Type should be updated as Outgoing.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TASK%3A Update Time Spent</fullName>
        <actions>
            <name>Blank_Time_Spent_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Total_Time_Spent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Time_Spent_Now_min__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FOR: Calculation Automation. - WHY: To update any time entered in Time Spent Now (min) as a summary in Total Time Spent (min).</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Order</fullName>
        <actions>
            <name>Update_Order_from_Task</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Is_Decline_Activity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Start_Order_Decline_Flow__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Decline Orders</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
