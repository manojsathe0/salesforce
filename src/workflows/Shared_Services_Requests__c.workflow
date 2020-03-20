<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Assigned_Approver_Notificaiton_Clare_Gmur_Dewi_Smith</fullName>
        <description>Assigned Approver Notificaiton - Clare Gmur &amp; Dewi Smith</description>
        <protected>false</protected>
        <recipients>
            <recipient>cgmur@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dxsmith@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Approval_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Assigned_Approver_Notificaiton_Dewi_Smith</fullName>
        <description>Assigned Approver Notificaiton - Dewi Smith</description>
        <protected>false</protected>
        <recipients>
            <recipient>dxsmith@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Approval_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Assigned_Approver_Notificaiton_Kasey_Cromer</fullName>
        <description>Assigned Approver Notificaiton - Kasey Cromer</description>
        <protected>false</protected>
        <recipients>
            <recipient>kcromer@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Approval_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Assigned_Approver_Notificaiton_Kim_Schroeppel_and_Clare_Gmur</fullName>
        <description>Assigned Approver Notificaiton - Kim Schroeppel and Clare Gmur</description>
        <protected>false</protected>
        <recipients>
            <recipient>cgmur@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kschroeppel@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Approval_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Assigned_Approver_Notificaiton_Nina_Otchis_Clare_Gmur</fullName>
        <description>Assigned Approver Notificaiton - Nina Otchis &amp; Clare Gmur</description>
        <protected>false</protected>
        <recipients>
            <recipient>cgmur@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>notchis@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Approval_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Assigned_Approver_Notificaiton_Stan_Holmes</fullName>
        <description>Assigned Approver Notificaiton - Stan Holmes</description>
        <protected>false</protected>
        <recipients>
            <recipient>fsalazar@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rthomas@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sholmes@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Approval_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_Status_Change</fullName>
        <description>Email Notification - Status Change</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Project_Implementer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Request_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Notification_On_Date_Needed_By</fullName>
        <description>Notification On Date Needed By</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Project_Implementer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Request_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Before_Alert_Date_Need_By</template>
    </alerts>
    <alerts>
        <fullName>Notification_one_day_before_Date_Needed_By</fullName>
        <description>Notification one day before Date Needed By</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Project_Implementer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Request_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Shared_Services_Request_Before_Alert_Date_Need_By</template>
    </alerts>
    <alerts>
        <fullName>Rejected_Project_Request_Notification</fullName>
        <description>Rejected Project Request Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Request_Templates/Article_Project_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Completed_Date_Update_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>Today()</formula>
        <name>Completed Date - Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Update Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Approval_Status</fullName>
        <field>Request_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Update - Pending Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Project_Submitter</fullName>
        <field>Project_Request_Submitter__c</field>
        <formula>CreatedBy.FirstName+&apos; &apos;+CreatedBy.LastName</formula>
        <name>Update Project Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <flowActions>
        <fullName>Assign_to_Clare</fullName>
        <flow>Assign_to_Clare</flow>
        <flowInputs>
            <name>RecordID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Assign to Clare</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <flowActions>
        <fullName>Assign_to_Dewi</fullName>
        <flow>Assign_to_Dewi</flow>
        <flowInputs>
            <name>RecordID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Assign to Dewi</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <flowActions>
        <fullName>Assign_to_Kasey</fullName>
        <flow>Assing_to_Kasey</flow>
        <flowInputs>
            <name>RecordID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Assign to Kasey</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <flowActions>
        <fullName>Assign_to_Kim</fullName>
        <flow>Assign_to_Kim</flow>
        <flowInputs>
            <name>RecordID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Assign to Kim</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <flowActions>
        <fullName>Assign_to_Nina</fullName>
        <flow>Assign_to_Nina</flow>
        <flowInputs>
            <name>RecordID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Assign to Nina</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <flowActions>
        <fullName>Assign_to_Stan</fullName>
        <flow>Assign_to_Stan</flow>
        <flowInputs>
            <name>RecordID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Assign to Stan</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <rules>
        <fullName>PRAK%3A Date Needed By Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Date_Needed_By_If_Applicable__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Request_Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>REQ: PRAK - FOR: Notification. - WHY: When a Project Request Date Needed By is not null and the Status is not Completed an email alert will be sent on the day before and of the Date Needed By to the requestor, approver, and implementer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_On_Date_Needed_By</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Shared_Services_Requests__c.Date_Needed_By_If_Applicable__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_one_day_before_Date_Needed_By</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Shared_Services_Requests__c.Date_Needed_By_If_Applicable__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PRAK%3A Ops Rejected Notification</fullName>
        <actions>
            <name>Rejected_Project_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Operations Shared Services Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>REQ: PRAK - FOR: Notification. - WHY: When a Project Request, as an Operations Record Type, Status is updated to Rejected an email alert is sent to the Request creator.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRAK%3A Ops Update Completed Date</fullName>
        <actions>
            <name>Update_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Operations Shared Services Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <description>REQ: PRAK - FOR: Date/Time Update. - WHY: When the Status equals Approved or Rejected the Completed Date is timestamped with the Last Modified Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRAK%3A Ops Update Submitter and Status</fullName>
        <actions>
            <name>Update_Pending_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Project_Submitter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Operations Shared Services Request</value>
        </criteriaItems>
        <description>REQ: PRAK - FOR: Field Update. - WHY: When a Project Request is submitted as an Operations Record Type The Project Submitter is updated with Created By First and Last name then the Status is updated to Pending Approval.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRAK%3A Status Change Notification</fullName>
        <actions>
            <name>Email_Notification_Status_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>REQ: PRAK - FOR: Notification. - WHY: Any time when a Project Request Status is changed an email alert will be sent to the requestor, approver, and implementer.</description>
        <formula>ISCHANGED(Request_Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PRAK%3A Update Completed Date</fullName>
        <actions>
            <name>Completed_Date_Update_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>REQ: PRAK - FOR: Date/Time Update. - WHY: When the Status equals Complete the Completed Date is timestamped for TODAY().</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to Clare Gmur</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Nina_Otchis_Clare_Gmur</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Clare</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Communication,Change Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Requesting_Department__c</field>
            <operation>equals</operation>
            <value>Customer Care,Fulfillment,Other</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Clare Gmur and Notify Dewi</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Clare_Gmur_Dewi_Smith</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Clare</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Communication</value>
        </criteriaItems>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Requesting_Department__c</field>
            <operation>equals</operation>
            <value>Knowledge Management</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Dewi Smith</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Dewi_Smith</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Dewi</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Article (Customer-Facing),Article (Internal)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Kasey Cromer</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Kasey_Cromer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Kasey</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Training Delivery</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Kim Schroeppel</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Kim_Schroeppel_and_Clare_Gmur</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Kim</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Training Materials</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Nina Otchis</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Nina_Otchis_Clare_Gmur</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Nina</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Communication,Change Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Requesting_Department__c</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Stan Holmes</fullName>
        <actions>
            <name>Assigned_Approver_Notificaiton_Stan_Holmes</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Stan</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shared_Services_Requests__c.Project_Request_Type__c</field>
            <operation>equals</operation>
            <value>Workforce Management</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
