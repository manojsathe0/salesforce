<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Adjustment_Approval_Email</fullName>
        <description>Adjustment Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>cwong@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>reporting@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Approved_Rejected_Request_New</template>
    </alerts>
    <alerts>
        <fullName>Adjustment_Approval_Email_New</fullName>
        <description>Adjustment Approval Email - New</description>
        <protected>false</protected>
        <recipients>
            <recipient>VPSales</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Adjustment_Request_New</template>
    </alerts>
    <alerts>
        <fullName>Adjustment_Rejected_Email</fullName>
        <description>Adjustment Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>cwong@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>reporting@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Approved_Rejected_Request_New</template>
    </alerts>
    <alerts>
        <fullName>Completed_Email_Alert_Salesforce_Request</fullName>
        <ccEmails>SalesForceSupport@legalzoom.com</ccEmails>
        <description>Completed Email Alert - Salesforce Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_Administrator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Salesforce_Request_Closed</template>
    </alerts>
    <alerts>
        <fullName>New_Email_Salesforce_Request_Alert</fullName>
        <ccEmails>SalesForceSupport@legalzoom.com</ccEmails>
        <description>New Email - Salesforce Request Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jkellum@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Salesforce_Request_New</template>
    </alerts>
    <alerts>
        <fullName>Salesforce_Request_Assigned_Administrator</fullName>
        <description>Salesforce Request - Assigned Administrator</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_Administrator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Salesforce_Request_Assigned_Administrator</template>
    </alerts>
    <alerts>
        <fullName>Salesforce_Request_Estimated_Completion_Date</fullName>
        <description>Salesforce Request - Estimated Completion Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_Administrator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Salesforce_Request_Customer_Reply</template>
    </alerts>
    <alerts>
        <fullName>Salesforce_Request_Status_Change_Email_Template</fullName>
        <description>Salesforce Request - Status Change Email Template</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_Administrator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Salesforce_Request_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Transfer_Request_Dewi_Smith</fullName>
        <description>Transfer Request - Dewi Smith</description>
        <protected>false</protected>
        <recipients>
            <recipient>dxsmith@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/Salesforce_Request_New</template>
    </alerts>
    <fieldUpdates>
        <fullName>Completed_Date_Field_Update</fullName>
        <description>this field updates to todays date when the request has been completed.</description>
        <field>Completed_Date__c</field>
        <formula>Today()</formula>
        <name>Completed Date - Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjustment_Approved_Status</fullName>
        <field>Status__c</field>
        <literalValue>Adjustment Approved</literalValue>
        <name>Update Adjustment Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjustment_Rejected_Status</fullName>
        <field>Status__c</field>
        <literalValue>Adjustment Rejected</literalValue>
        <name>Update Adjustment Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Contacted</fullName>
        <field>First_Contacted__c</field>
        <formula>NOW()</formula>
        <name>Update First Contacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>SFI%3A Assigned Adminstrator Notification</fullName>
        <actions>
            <name>Salesforce_Request_Assigned_Administrator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>REQ: SFI - FOR: Notification. - WHY: Email sent to User when they have been added to the Assigned Administrator field.</description>
        <formula>ISCHANGED(Assigned_Administrator__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFI%3A Completed Notification %26 Timestamp</fullName>
        <actions>
            <name>Completed_Email_Alert_Salesforce_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Completed_Date_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Salesforce_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed - Now Live,Completed</value>
        </criteriaItems>
        <description>REQ: SFI - FOR: Notification, Date/Time Update. - WHY: Email sent to User and Assigned Administrator when the Status is changed to Completed as well as timestamp Completed Date for TODAY().</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFI%3A Estimated Completion Date Notification</fullName>
        <actions>
            <name>Salesforce_Request_Estimated_Completion_Date</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Salesforce_Request__c.Assigned_Administrator__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Salesforce_Request__c.Estimated_Completion_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>REQ: SFI - FOR: Notification. - WHY: Email sent to User and Assigned Administrator when the Estimated Completion Date is changed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFI%3A New Request Notification</fullName>
        <actions>
            <name>New_Email_Salesforce_Request_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Salesforce_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted,Reopened</value>
        </criteriaItems>
        <description>REQ: SFI - FOR: Notification. - WHY: Email sent to Record Creator and Assigned Administrator when the Status equals submitted or reopened.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFI%3A Status Change Notification</fullName>
        <actions>
            <name>Salesforce_Request_Status_Change_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Salesforce_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Researching,In Progress,In Project Queue,Ready for UAT,In Servicedesk Queue,In TFS Queue</value>
        </criteriaItems>
        <description>REQ: SFI - FOR: Notification. - WHY: Email sent to User and Assigned Administrator when a request has been submitted with a certain status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFI%3A Update First Contacted</fullName>
        <actions>
            <name>Update_First_Contacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>REQ: SFI - FOR: Date/Time Update. - WHY: Timestamp when a request is marked as first contacted by evaluating when the Estimation Completion Date is changed to a different value and the First Contacted field is null.</description>
        <formula>AND (     AND      (        ISCHANGED( Estimated_Completion_Date__c ),          !ISNULL(Estimated_Completion_Date__c)       )  ,      ISNULL( First_Contacted__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
