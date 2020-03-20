<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Escalation_Manager_Call_Back_Alert</fullName>
        <description>Case Escalation Manager Call Back Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Request_Templates/New_Hire_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_ALert_Biz_QC_Approval</fullName>
        <ccEmails>bizqc@legalzoom.com</ccEmails>
        <description>Email ALert Biz QC Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BIZ_QC_Approval_Email_Template/BIZ_QC_Approval_Revision_Required</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_Biz_QC_Revision_Complete</fullName>
        <ccEmails>bizqc@legalzoom.com</ccEmails>
        <description>Email Alert - Biz QC Revision Complete</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BIZ_QC_Approval_Email_Template/BIZ_QC_Approval_Email_Revision_Complete</template>
    </alerts>
    <alerts>
        <fullName>Notification_email</fullName>
        <description>Notification email - Queue is Null and Status is Updated by Customer or New</description>
        <protected>false</protected>
        <recipients>
            <recipient>bkhakurel@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cwong2@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cwong@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>keich@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>reporting@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Common_Templates/Queue_is_null</template>
    </alerts>
    <alerts>
        <fullName>Send_Auto_Response_Email</fullName>
        <description>Send Auto Response Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@legalzoom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SUPPORTNewCaseReceived</template>
    </alerts>
    <fieldUpdates>
        <fullName>Biz_BSI_Queue_Assignment_Update</fullName>
        <field>Queue__c</field>
        <literalValue>Biz BSI</literalValue>
        <name>Biz BSI - Queue Assignment Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Biz_HA_Pre_Filing_Completed_By</fullName>
        <description>Updates the name of the person who clicked the Biz HA Pre-filing Checkbox</description>
        <field>Biz_HA_Pre_Filing_Completed_By__c</field>
        <formula>LastModifiedBy.FirstName+&apos; &apos;+LastModifiedBy.LastName</formula>
        <name>Biz HA Pre-Filing Completed By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Biz_HA_Pre_Filing_Completed_Date</fullName>
        <description>Updates Date Biz HA Pre-filing checkbox was clicked.</description>
        <field>Biz_HA_Pre_Filing_Completed_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Biz HA Pre-Filing Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CC_Biz_Update_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>CC Biz - Update Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CC_Real_Estate_Lease_Case_Origin_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>CC Real Estate Lease - Case Origin Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Call_Log_Attempts</fullName>
        <field>Call_Log_Attempts__c</field>
        <formula>Call_Log_Attempts__c +1</formula>
        <name>Call Log Attempts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Call_Log_Contact_Attempts</fullName>
        <field>Call_Log_Contact_Attempts__c</field>
        <formula>Case( Call_Status__c,

&quot;Yes-Talk&quot;,  Call_Log_Contact_Attempts__c +1,
&quot;Yes-SNE&quot;,  Call_Log_Contact_Attempts__c +1, 

Call_Log_Contact_Attempts__c)</formula>
        <name>Call Log - Contact Attempts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Description</fullName>
        <field>Description</field>
        <name>Clear Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_previous_problem_resolution</fullName>
        <field>Previous_Problem_resolution__c</field>
        <formula>Text(PRIORVALUE( Problem_Order_Resolution__c ))</formula>
        <name>Copy previous problem resolution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Customer_Contacted_Update</fullName>
        <field>Date_Time_Customer_Contacted__c</field>
        <formula>Case( Call_Status__c,

&quot;Yes-Talk&quot;, NOW(),
Null)</formula>
        <name>Date/Time Customer Contacted Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Resolved</fullName>
        <field>Date_Time_Resolved__c</field>
        <formula>NOW()</formula>
        <name>Field Updat: Date/Time Resolved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Revision_Complete</fullName>
        <field>Date_Time_Revision_Complete__c</field>
        <formula>now()</formula>
        <name>Date/Time Revision Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Revision_Required_Update</fullName>
        <field>Date_Time_Sent_for_Revision__c</field>
        <formula>now()</formula>
        <name>Date/Time  Revision Required Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Case_Origin_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Field Update - Case Origin Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Queue_Biz_HA_Pre_Filing</fullName>
        <field>OwnerId</field>
        <lookupValue>Biz_HA_Pre_Filing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Field Update - Queue - Biz HA Pre-Filing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Queue_Ownership</fullName>
        <field>OwnerId</field>
        <lookupValue>Biz_HA_Sweeps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Field Update - Queue Ownership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Resolved_By</fullName>
        <field>Problem_Order_Resolved_By__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Field Update: Resolved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_Update</fullName>
        <field>Flag_Value__c</field>
        <literalValue>Red</literalValue>
        <name>Flag Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Inquiry</fullName>
        <description>Set Category to:
General Inquiry</description>
        <field>Category__c</field>
        <literalValue>General Inquiry</literalValue>
        <name>General Inquiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ISEscalated_to_True</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>ISEscalated to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Case_Pass_Counter</fullName>
        <description>Increments the # Case Passes field by 1</description>
        <field>Case_Passes__c</field>
        <formula>IF (ISNULL( Case_Passes__c), 1, Case_Passes__c + 1)</formula>
        <name>Increment Case Pass Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Originally_Escalated</fullName>
        <description>Populates Originally Escalated with agents first and last name.</description>
        <field>Originally_Escalated__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>Populate Originally Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Problem_Order_Resolution_Update</fullName>
        <description>Problem Order Resolution status updates to Unresolved - Auto Closed</description>
        <field>Problem_Order_Resolution__c</field>
        <literalValue>Unresolved – Auto Closed</literalValue>
        <name>Problem Order Resolution Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Set_to_Legal_Form</fullName>
        <description>Product Set to: Legal Form</description>
        <field>Products__c</field>
        <literalValue>Legal Form</literalValue>
        <name>Product Set to: Legal Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Set_to_Living_Will</fullName>
        <description>Product Set to; Living Will</description>
        <field>Products__c</field>
        <literalValue>Living Will</literalValue>
        <name>Product Set to: Living Will</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Queue_PSD_Update_Case_Origin_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Queue PSD - Update Case Origin Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_CC_Email_Queue</fullName>
        <field>CC_Email_Queue__c</field>
        <name>Remove CC Email Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_from_Escalation</fullName>
        <field>IsEscalated</field>
        <literalValue>0</literalValue>
        <name>Remove from Escalation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assigned_User_to_null</fullName>
        <description>Set Assigned User to null</description>
        <field>Assigned_User__c</field>
        <name>Set Assigned User to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Status_Closed</fullName>
        <description>Set Case Status to Closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Set Case Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Category_to_Registered_Agents</fullName>
        <description>Set Category to: Registered Agents</description>
        <field>Category__c</field>
        <literalValue>Registered Agents</literalValue>
        <name>Set Category to: Registered Agents</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Category_to_Submit_my_materials</fullName>
        <description>Set Category to: Submit my materials</description>
        <field>Category__c</field>
        <literalValue>Submit my Materials</literalValue>
        <name>Set Category to: Submit my materials</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Order_Submitted_To_No</fullName>
        <description>Set Order Submitted To: No</description>
        <field>Order_Submitted__c</field>
        <literalValue>0</literalValue>
        <name>Set Order Submitted To: No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Order_Submitted_To_YES</fullName>
        <description>Set Order Submitted To: YES</description>
        <field>Order_Submitted__c</field>
        <literalValue>1</literalValue>
        <name>Set Order Submitted To: YES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Corporation</fullName>
        <description>Set the Product to Corporations</description>
        <field>Products__c</field>
        <literalValue>Incorporation</literalValue>
        <name>Set Product Corporation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Deed_Transfer</fullName>
        <description>Set the product to Deed Transfer</description>
        <field>Products__c</field>
        <literalValue>Real Estate Deed Transfer</literalValue>
        <name>Set Product Deed Transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Immigration</fullName>
        <description>Set the Product to Immigration</description>
        <field>Products__c</field>
        <literalValue>Immigration - Citizenship</literalValue>
        <name>Set Product Immigration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_No_Specific_Service</fullName>
        <description>Set Product to No Specific Service</description>
        <field>Products__c</field>
        <literalValue>No Specific Service</literalValue>
        <name>Set Product No Specific Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Other_Services</fullName>
        <description>Set the Product to Other Business Services</description>
        <field>Products__c</field>
        <literalValue>Other</literalValue>
        <name>Set Product Other Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Small_Claims</fullName>
        <description>Set Product to Small Claims</description>
        <field>Products__c</field>
        <literalValue>Small Claims</literalValue>
        <name>Set Product Small Claims</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Spotlight</fullName>
        <description>Set the Product to Business Development</description>
        <field>Products__c</field>
        <literalValue>LegalZoom Business Development</literalValue>
        <name>Set Product Spotlight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_To_Design_Patents</fullName>
        <description>Set Product To: Design Patents</description>
        <field>Products__c</field>
        <literalValue>Design Patent</literalValue>
        <name>Set Product To: Design Patents</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_To_Real_Estate_Leases</fullName>
        <description>Products: Real Estate Leases</description>
        <field>Products__c</field>
        <literalValue>Real Estate Lease</literalValue>
        <name>Set Product To: Real Estate Leases</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_To_Trademarks</fullName>
        <description>Set Product To: Trademarks</description>
        <field>Products__c</field>
        <literalValue>Trademark</literalValue>
        <name>Set Product To: Trademarks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Bankruptcy</fullName>
        <description>Set Product to: Bankruptcy</description>
        <field>Products__c</field>
        <literalValue>Bankruptcy</literalValue>
        <name>Set Product to: Bankruptcy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Copyright_applications</fullName>
        <description>Set Product to: Copyright applications</description>
        <field>Products__c</field>
        <literalValue>Copyright</literalValue>
        <name>Set Product to: Copyright applications</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_DBA</fullName>
        <description>Set Product to: DBA</description>
        <field>Products__c</field>
        <literalValue>DBA</literalValue>
        <name>Set Product to: DBA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Design_Patent</fullName>
        <field>Product2__c</field>
        <literalValue>Design Patent</literalValue>
        <name>Set Product to: Design Patent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Divorce</fullName>
        <description>Set Product to: Divorce</description>
        <field>Products__c</field>
        <literalValue>Divorce</literalValue>
        <name>Set Product to: Divorce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_EIN</fullName>
        <description>Set the Product to Federal Tax ID/EIN</description>
        <field>Products__c</field>
        <literalValue>EIN Obtainment</literalValue>
        <name>Set Product to EIN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_LLC</fullName>
        <description>Set Product to: LLC</description>
        <field>Products__c</field>
        <literalValue>LLC</literalValue>
        <name>Set Product to: LLC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Last_Will_and_Testament</fullName>
        <description>Set Product to: Last Will and Testament</description>
        <field>Products__c</field>
        <literalValue>Last Will and Testament</literalValue>
        <name>Set Product to: Last Will and Testament</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Name_Change</fullName>
        <description>Set Product to: Name Change</description>
        <field>Products__c</field>
        <literalValue>Name Change</literalValue>
        <name>Set Product to: Name Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Non_Profit</fullName>
        <description>Set Product to: Non-Profit</description>
        <field>Products__c</field>
        <literalValue>NonProfit</literalValue>
        <name>Set Product to: Non-Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Patents</fullName>
        <description>Set Product to: Patents</description>
        <field>Products__c</field>
        <literalValue>Patent Search</literalValue>
        <name>Set Product to: Patents</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Registered_Agents</fullName>
        <field>Products__c</field>
        <literalValue>Registered Agent</literalValue>
        <name>Set Product to: Registered Agents</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Trademark_Monitoring</fullName>
        <description>Set Product to: Trademark Monitoring</description>
        <field>Products__c</field>
        <literalValue>Trademark Monitoring</literalValue>
        <name>Set Product to: Trademark Monitoring</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_to_Trademark_Search</fullName>
        <description>Set Product to: Trademark Search</description>
        <field>Products__c</field>
        <literalValue>Trademark Search</literalValue>
        <name>Set Product to: Trademark Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_QC_Fulfillment_Subject</fullName>
        <description>Set QC Fulfillment Case Subject</description>
        <field>Subject</field>
        <formula>&quot;Your Legalzoom Order # &quot; +  Order_Number__c + &quot;  – URGENT ACTION REQUIRED&quot;</formula>
        <name>Set QC Fulfillment Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Send_for_Approval_True</fullName>
        <description>Sets submit for approval to true</description>
        <field>Email_Review_Mode__c</field>
        <literalValue>1</literalValue>
        <name>Set Send for Approval True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Escalated</fullName>
        <description>Set case status to escalated</description>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Set Status Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SubReason_Cancel_Order</fullName>
        <description>Set the SubReason to Cancel Order</description>
        <field>Case_Sub_Reason__c</field>
        <literalValue>Cancel Order</literalValue>
        <name>Set SubReason Cancel Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SubReason_Change_To_Order</fullName>
        <description>Set the Secondary reason to Change to Order</description>
        <field>Case_Sub_Reason__c</field>
        <literalValue>Change to Order</literalValue>
        <name>Set SubReason Change To Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SubReason_GI</fullName>
        <description>Set Case Reason to General Inquiry</description>
        <field>Reason</field>
        <literalValue>General Inquiry</literalValue>
        <name>Set Reason General Inquiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SubReason_Order_Fulfillment</fullName>
        <description>Set the Secondary Reason to Order/Fulfillment task</description>
        <field>Case_Sub_Reason__c</field>
        <literalValue>Ordering &amp; Fulfillment Question</literalValue>
        <name>Set SubReason Order Fulfillment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SubReason_to_Registered_Agent</fullName>
        <field>Case_Sub_Reason__c</field>
        <literalValue>Registered Agents</literalValue>
        <name>Set SubReason to: Registered Agent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SubReason_to_Submit_my_Materials</fullName>
        <description>Set the Case Secondary Reason to Submit my Materials</description>
        <field>Case_Sub_Reason__c</field>
        <literalValue>Submit my materials</literalValue>
        <name>Set SubReason to: Submit my Materials</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Subreason_Liason_Inquiry</fullName>
        <description>Set the SubReason to Liason Inquiry</description>
        <field>Case_Sub_Reason__c</field>
        <literalValue>Liaison Inquiry</literalValue>
        <name>Set Subreason Liason Inquiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_to_Closed</fullName>
        <description>Status updates to Closed to initiate Problem Order Resolution selection.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Status Update to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ASD_Legal_Plan_Sales_Queue</fullName>
        <field>Queue__c</field>
        <literalValue>ASD-LegalPlan_Sales</literalValue>
        <name>Update ASD Legal Plan Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Biz_QC_Processor</fullName>
        <field>Biz_QC_Processor__c</field>
        <formula>Assigned_User__r.FirstName+&apos; &apos;+Assigned_User__r.LastName</formula>
        <name>Update Biz QC Processor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CC_Divorce_Case_Origin_to_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update CC Divorce - Case Origin to Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CC_EP_Case_origin_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update CC EP - Case origin = Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CC_General_Case_Origin_to_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update CC General - Case Origin to Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CC_IP_Case_Origin_to_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update CC IP - Case Origin to Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CC_Name_Change_Case_Origin_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update CC Name Change - Case Origin Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_Manager_Call_Back_Assig</fullName>
        <field>Date_Time_Assigned_Manager_Call_Back__c</field>
        <formula>NOW()</formula>
        <name>Update Date/Time Manager Call Back Assig</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_gets_Assigned</fullName>
        <field>Date_Time_Last_Queue_Assigned__c</field>
        <formula>now()</formula>
        <name>Update Date/Time gets Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Subject</fullName>
        <field>Email_Subject__c</field>
        <formula>Order_Number__c</formula>
        <name>Update Email Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Phone_Call_Date</fullName>
        <field>Date_First_Phone_Call__c</field>
        <formula>TODAY()</formula>
        <name>Update First Phone Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IP_BSI_Case_Origin_to_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update IP BSI - Case Origin to Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IP_Copyrights_Case_Origin_to_We</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update IP Copyrights - Case Origin to We</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IP_Patents_Case_Origin_to_Web</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update IP Patents - Case Origin to Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IP_Trademark_Search_Approval</fullName>
        <description>Update Queue Ownership</description>
        <field>OwnerId</field>
        <lookupValue>IPTrademarkSearchApprovals</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update - IP Trademark Search Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IP_Trademarks_Case_Origin_to_We</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update IP Trademarks - Case Origin to We</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Manager_Call_Back_Completed</fullName>
        <field>Date_Time_Manager_Call_Back_Complete__c</field>
        <formula>NOW()</formula>
        <name>Update Manager Call-Back Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Old_Owner</fullName>
        <field>Old_Owner__c</field>
        <formula>PRIORVALUE(OwnerId)</formula>
        <name>Update Old Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_IP_Trademark_Materials</fullName>
        <field>OwnerId</field>
        <lookupValue>IPTrademarkMaterials297451</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner - IP Trademark Materials</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_QC_Error_Identified_By</fullName>
        <field>QC_Errors_Identified_By__c</field>
        <formula>LastModifiedBy.FirstName+&apos; &apos;+LastModifiedBy.LastName</formula>
        <name>Update QC Error Identified By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue</fullName>
        <description>Queue will be changed from CC-PS Outgoing to PS-EP Problem Orders.</description>
        <field>Queue__c</field>
        <literalValue>PS EP Problem Orders</literalValue>
        <name>Update Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_Field</fullName>
        <description>Update Queue Field to CC General Support when case origin = Email</description>
        <field>Queue__c</field>
        <literalValue>CC General Support</literalValue>
        <name>Update Queue Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_Field_To_SPAM</fullName>
        <description>Update queue field to SPAM when Case Origin is invitations@linkedin.com</description>
        <field>Queue__c</field>
        <literalValue>SPAM</literalValue>
        <name>Update Queue Field To SPAM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_to_CC_BizRR</fullName>
        <field>Queue__c</field>
        <literalValue>CC Biz Email</literalValue>
        <name>Update Queue to CC Biz RR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_to_CC_IP_RR</fullName>
        <field>Queue__c</field>
        <literalValue>CC IP Email</literalValue>
        <name>Update Queue to CC IP RR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_to_CC_PS_RR</fullName>
        <field>Queue__c</field>
        <literalValue>CC PS Email</literalValue>
        <name>Update Queue to CC PS RR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Escalated</fullName>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Update Status to Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_To_Fulfillment_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Fulfillment_QC_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update To Fulfillment Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_BIZ_BSI_Registered_Agent</fullName>
        <field>Queue__c</field>
        <literalValue>Biz BSI Registered Agents</literalValue>
        <name>Update queue to BIZ BSI Registered Agent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_CC_Attorney_Services</fullName>
        <field>Queue__c</field>
        <literalValue>CC Attorney Services</literalValue>
        <name>Update queue to CC Attorney Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_CC_General_Support</fullName>
        <field>Queue__c</field>
        <literalValue>CC General Support</literalValue>
        <name>Update queue to CC General Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_IP_BSI</fullName>
        <field>Queue__c</field>
        <literalValue>IP BSI</literalValue>
        <name>Update queue to IP BSI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_IP_Copyright</fullName>
        <field>Queue__c</field>
        <literalValue>IP Copyright Materials</literalValue>
        <name>Update queue to IP Copyright</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_IP_Patents</fullName>
        <field>Queue__c</field>
        <literalValue>IP Patent Materials</literalValue>
        <name>Update queue to IP Patents</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_IP_Trademarks</fullName>
        <field>Queue__c</field>
        <literalValue>IP Trademarks</literalValue>
        <name>Update queue to IP Trademarks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_queue_to_PSD_BSI</fullName>
        <field>Queue__c</field>
        <literalValue>PSD-BSI</literalValue>
        <name>Update queue to PSD BSI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_CC_Attorney_Services_Case_O</fullName>
        <field>Origin</field>
        <literalValue>Web</literalValue>
        <name>Update to CC Attorney Services - Case O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Was_Escalated</fullName>
        <field>Was_Escalated__c</field>
        <literalValue>1</literalValue>
        <name>Was Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign to CC Biz</fullName>
        <actions>
            <name>Remove_CC_Email_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_BizRR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CC_Email_Queue__c</field>
            <operation>equals</operation>
            <value>CC Biz Email</value>
        </criteriaItems>
        <description>Assign to CC Biz Email team for RR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign to CC IP</fullName>
        <actions>
            <name>Remove_CC_Email_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_IP_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CC_Email_Queue__c</field>
            <operation>equals</operation>
            <value>CC IP Email</value>
        </criteriaItems>
        <description>Assign to CC IP Email team for RR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign to CC PS</fullName>
        <actions>
            <name>Remove_CC_Email_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_PS_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CC_Email_Queue__c</field>
            <operation>equals</operation>
            <value>CC PS Email</value>
        </criteriaItems>
        <description>Assign to CC PS Email team for RR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Biz HA Pre-Filing - New Case - Case Origin</fullName>
        <actions>
            <name>Field_Update_Queue_Biz_HA_Pre_Filing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>bsdhaprefiling@legalzoom.com</value>
        </criteriaItems>
        <description>This workflow triggers queue ownership update for new biz ha pre-filing cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Biz HA Pre-Filing Checkbox</fullName>
        <actions>
            <name>Biz_HA_Pre_Filing_Completed_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Biz_HA_Pre_Filing_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Biz_HA_Pre_Filing_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>this workflow triggers the Biz Pre-filing Completed By and Completed Date fields to auto populate.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Biz HA Sweeps - New Case - Case Origin</fullName>
        <actions>
            <name>Field_Update_Queue_Ownership</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>bsdhasweeps@legalzoom.com</value>
        </criteriaItems>
        <description>This workflow triggers queue ownership update for new biz ha sweeps cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Call Log Attempts</fullName>
        <actions>
            <name>Call_Log_Attempts</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Call_Log_Contact_Attempts</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Date_Time_Customer_Contacted_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.AM_Call_Log__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalated</fullName>
        <actions>
            <name>Set_Status_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Was_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>Case is escalated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalated - Call Back Complete</fullName>
        <actions>
            <name>Remove_from_Escalation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Manager_Call_Back_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>Account Mgmt Manager Call-Back,Biz BCS Manager Call-Back,CC Manager Call-Back,IP Fulfillment Manager Call-Back,Order Save Manager Call-Back,PS Fulfillment Manager Call-Back,Sales Manager Call-Back</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Date_Time_Assigned_Manager_Call_Back__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Case is removed from escalation once call back is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalated - Manager Call Back</fullName>
        <actions>
            <name>ISEscalated_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Date_Time_Manager_Call_Back_Assig</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_to_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>Account Manager Manager Call-Back,Biz BCS Manager Call-Back,CC Manager Call-Back,IP Fulfillment Manager Call-Back,Order Save Manager Call-Back,PS Fulfillment Manager Call-Back,Sales Manager Call-Back</value>
        </criteriaItems>
        <description>Case is escalated to Manager Call Back</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Owner is Changed</fullName>
        <actions>
            <name>Increment_Case_Pass_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow executes when a case owner changes</description>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Submitted from Web</fullName>
        <actions>
            <name>Send_Auto_Response_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14 AND 15 AND 16 AND 17 AND 18 AND 19 AND 20 AND 21 AND 22</booleanFilter>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>equals</operation>
            <value>LZWTC Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>support@legalzoom.com,Biz_BCS_Fax@legalzoom.com,AnswerCenter@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>support@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>CROrders@legalzoom.com,CRbilling@legalzoom.com,Contact@legalzoom.com,CustomerMatch@legalzoom.com,DNB@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>Ep0859a@legalzoom.com,Ep0859b@legalzoom.com,IPBSIOutgoing@legalzoom.com,IPCROutreach@legalzoom.com,IPTMOutreach@legalzoom.com,Ip0859a@legalzoom.com,Ip0859b@legalzoom.com,LAC@legalzoom.com,LNDivorce@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>LRS@legalzoom.com,altnames@legalzoom.com,copyright@legalzoom.com,copyrights@legalzoom.com,epsupport@legalzoom.com,epservices@legalzoom.com,estateplanningsupport@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>nonprofit@legalzoom.com,ostprojects@legalzoom.com,PatentBilling@legalzoom.com,PatentOrders@legalzoom.com,PatentSearchApprove@legalzoom.com,RELCourtesy@legalzoom.com,TMBilling@legalzoom.com,TMCompSearchApprove@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>TMDirectSearchApprove@legalzoom.com,TMMonitor@legalzoom.com,advantageplans@legalzoom.com,advantagesupport@legalzoom.com,alternatenames@legalzoom.com,attorneylocatordiv@legalzoom.com,biz_bsi_fax@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>lzserve.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>biznonprofitsupport@legalzoom.com,bus0859a@legalzoom.com,bus0859b@legalzoom.com,businessservices@legalzoom.com,businesssupport@legalzoom.com,bzsales@legalzoom.com,bzsupport@legalzoom.com,canadianep@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>cono@legalzoom.com,customercare@legalzoom.com,customerservice@legalzoom.com,customersupport@legalzoom.com,dba@legalzoom.com,dbas@legalzoom.com,dbasupport@legalzoom.com,deedscompletedconfirm@legalzoom.com,deedsupport@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>designpatent@legalzoom.com,designpatents@legalzoom.com,divorce@legalzoom.com,divorcerevisions@legalzoom.com,divorcerevisions@legalzoom.com,divorcesupport@legalzoom.com,drefund@legalzoom.com,einsupport@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>fastdivorce@legalzoom.com,fax3233890530@legalzoom.com,fax3233890539@legalzoom.com,fax3233890540@legalzoom.com,fax3233890598@legalzoom.com,fax3233891491@legalzoom.com,fax3234467120@legalzoom.com,fax3234467128@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>fax3234467133@legalzoom.com,fax3234468308@legalzoom.com,fax3234468334@legalzoom.com,freelivingwillrev@legalzoom.com,goodsandservices@legalzoom.com,illustration(s)@legalzoom.com,immigration@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>incorporations@legalzoom.com,ippartners@legalzoom.com,ipsales@legalzoom.com,ipsalesabandoners@legalzoom.com,ipsaleschargepayment@legalzoom.com,ipsalesdeclined@legalzoom.com,ipsupport@legalzoom.com,iptmout@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>livingtrusts@legalzoom.com,llcs@legalzoom.com,logo@legalzoom.com,logoworks@legalzoom.com,maria@legalzoom.com,namechangecl@legalzoom.com,namechangesupport@legalzoom.com,onlinefilings@legalzoom.com,patent@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>patentsearch@legalzoom.com,personalservices@legalzoom.com,ppasupport@legalzoom.com,proxilaw@legalzoom.com,psinfo@legalzoom.com,pssales@legalzoom.com,pssupport@legalzoom.com,raservice@legalzoom.com,raservices@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>revisions@legalzoom.com,services@legalzoom.com,smallclaims@legalzoom.com,smallclaimscl@legalzoom.com,smallclaimsupport@legalzoom.com,specialfilingsupport@legalzoom.com,spotlight@legalzoom.com,startupnation@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>,tmofficeactions@legalzoom.com,tmsearch@legalzoom.com,tmupdates@legalzoom.com,trademarks@legalzoom.com,trademark@legalzoom.com,tv@legalzoom.com,vault@legalzoom.com,eventhandlercopy@legalzoom.com,immigrationsupport@legalzoom.com,kitconfir</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>patents@legalzoom.com,resupport@legalzoom.com,tmgsoutreach@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>kitconfirm@legalzoom.com</value>
        </criteriaItems>
        <description>Send Auto Response when case submitted from web</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A 7 Day Problem Case Auto-Close</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>CC PS Outgoing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Problem Case</value>
        </criteriaItems>
        <description>REQ: POR - FOR: Automation. - WHY: When unresolved problem cases are in the CC-PS Outgoing queue, they should automatically close out 7 days after the date/time of problem identification.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Problem_Order_Resolution_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Update_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.DateTime_Problem_Identified__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case%3A Resolved Agent</fullName>
        <actions>
            <name>Date_Time_Resolved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Field_Update_Resolved_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Problem_Order_Resolution__c</field>
            <operation>equals</operation>
            <value>Resolved – Revision Placed on LZ.com,Resolved – New Information Provided,Resolved – Customer Wants to Proceed “As Is”,Resolved – Customer Submitting Revision,Resolved – Order Cancelled,Resolved – Not a Problem,Resolved – Other</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Originally Escalated</fullName>
        <actions>
            <name>Populate_Originally_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Originally_Escalated__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Problem Case</value>
        </criteriaItems>
        <description>REQ: POR - FOR: Automation, Field Update. - WHY: When the Status is updated to Escalated for the first time Originally Escalated is populated with the agent&apos;s first and last name.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Queue when Customer Responds</fullName>
        <actions>
            <name>Update_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Problem Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>CC PS Outgoing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Updated by Customer</value>
        </criteriaItems>
        <description>REQ: POR - FOR: Field Update. - WHY: When a Customer responds via email the Case should be assigned to the correct Queue to be worked on.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cases 24 Hours Old</fullName>
        <actions>
            <name>Flag_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>this workflow rule Flags a case that has been opened for greater than the 1 day</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clear Out Assigned User</fullName>
        <actions>
            <name>Set_Assigned_User_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clear out Assigned User field when status = Updated by Customer for all queues except for IP Production, Biz Starter and Quick Start Team.</description>
        <formula>AND(AND($User.Alias == &apos;wcase&apos; , ISPICKVAL(Status, &apos;Updated by Customer&apos;)) ,  NOT  (  OR(  ISPICKVAL(Queue__c , &apos;IP Copyright Order Updates&apos;),  ISPICKVAL( Queue__c , &apos;IP Copyright Billing Updates&apos;),  ISPICKVAL(Queue__c , &apos;IP Copyright Materials&apos;),  ISPICKVAL(Queue__c , &apos;IP Copyrights&apos;), ISPICKVAL(Queue__c , &apos;IP Fulfillment Team View&apos;), ISPICKVAL(Queue__c , &apos;IP Legal Assistant&apos;),  ISPICKVAL(Queue__c , &apos;IP Patent Billing Updates&apos;),  ISPICKVAL(Queue__c , &apos;IP Patent Drawings&apos;),  ISPICKVAL(Queue__c , &apos;IP Patent Materials&apos;), ISPICKVAL(Queue__c , &apos;IP Patent Order Updates&apos;),  ISPICKVAL(Queue__c , &apos;IP Patents&apos;), ISPICKVAL(Queue__c , &apos;IP Patent Search Approval&apos;),  ISPICKVAL(Queue__c , &apos;IP Sales Abandoners&apos;), ISPICKVAL(Queue__c , &apos;IP Sales Charge Payment&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Billing Updates&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Faxes&apos;), ISPICKVAL(Queue__c , &apos;IP Trademark Goods and Services&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Materials&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Monitoring&apos;), ISPICKVAL(Queue__c , &apos;IP Trademark Office Actions&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Order Updates&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Outbound&apos;), ISPICKVAL(Queue__c , &apos;IP Trademarks&apos;), ISPICKVAL(Queue__c , &apos;IP Trademark Search&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademark Search Approvals&apos;),  ISPICKVAL(Queue__c , &apos;IP Trademarks Goods and Services&apos;),  ISPICKVAL( Queue__c , &apos;Account Manager Biz Starter&apos;),  ISPICKVAL( Queue__c , &apos;Account Manager EP Starter&apos;),  ISPICKVAL( Queue__c , &apos;Quick Start LLC&apos;),  ISPICKVAL( Queue__c , &apos;Account Manager TM&apos;),  ISPICKVAL( Queue__c , &apos;Account Manager&apos;)    )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Out Description</fullName>
        <actions>
            <name>Clear_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears out the description field for email to case.</description>
        <formula>AND(NOT(ISPICKVAL(Origin ,&apos;Web&apos;)) , CreatedBy.Alias = &apos;wcase&apos;, NOT(OR(  ISPICKVAL(Origin, &apos;FileNet Enhanced Alert&apos;),  ISPICKVAL(Origin, &apos;alternatenames@legalzoom.com&apos;),  ISPICKVAL(Origin, &apos;onlinefilings@legalzoom.com&apos;),  ISPICKVAL(Origin, &apos;bsdhaprefiling@legalzoom.com&apos;),  ISPICKVAL(Origin, &apos;bsdhasweeps@legalzoom.com&apos;)  )))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Copyright Orders%2FBilling</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Copyright_applications</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>CROrders@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>CRbilling@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
CROrders@legalzoom.com OR
CRbilling@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CustomerMatch%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_No</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Bankruptcy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_GI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>CustomerMatch@legalzoom.com</value>
        </criteriaItems>
        <description>this workflow rule updates the case.order submitted field to NO, case.product field to Bankruptcy and case.reason field to General Inquiry when the Case Origin equals CustomerMatch@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DBA Case</fullName>
        <actions>
            <name>Set_Product_to_DBA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>dba@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>dbas@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>dbasupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=
                dba@legalzoom.com
                dbas@legalzoom.com
                dbasupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deed Support Case</fullName>
        <actions>
            <name>Set_Product_Deed_Transfer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>deedsupport@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>deedscompletedconfirm@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
                deedsupport@legalzoom.com
                deedscompletedconfirm@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Divorce Case</fullName>
        <actions>
            <name>Set_Product_to_Divorce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>divorce@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>LNDivorce@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fastdivorce@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>divorcerevisions@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>divorcesupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
                divorce@legalzoom.com
                LNDivorce@legalzoom.com
                fastdivorce@legalzoom.com
                divorcerevisions@legalzoom.com
                divorcesupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Divorce Case Auto Close</fullName>
        <actions>
            <name>Set_Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Divorce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>divorce@lz.com Started,divorce@lz.com Finished,divorce@lz.com Shipped</value>
        </criteriaItems>
        <description>Case Origin = divorce@lz.com Started, divorce@lz.com Finished, divorce@lz.com Shipped</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fulfillment Update Record Type</fullName>
        <actions>
            <name>Update_To_Fulfillment_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>Biz QC Approval</value>
        </criteriaItems>
        <description>this workflow triggers a date/time stamp everytime a case gets assigned to a new queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IP Trademark Materials - New Case - Case Origin</fullName>
        <actions>
            <name>Update_Owner_IP_Trademark_Materials</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>mytrademarks@legalzoom.com,mytrademark@legalzoom.com</value>
        </criteriaItems>
        <description>This workflow triggers queue ownership update for new ip trademark materials cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IP Trademark Outreach Case</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_To_Trademarks</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>iptmout@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>IPTMOutreach@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
iptmout@legalzoom.com
IPTMOutreach@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IP Trademark Search Approval - New Case - Case Origin</fullName>
        <actions>
            <name>Update_IP_Trademark_Search_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tmcompsearchapprove@legalzoom.com,trademarkssearch@legalzoom.com,trademarksearches@legalzoom.com,trademarksearch@legalzoom.com,TMDirectSearchApprove@legalzoom.com,trademarksearchs@legalzoom.com</value>
        </criteriaItems>
        <description>This workflow triggers queue ownership update for new ip trademark search approval cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IPBSIOutgoing%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>IPBSIOutgoing@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=  IPBSIOutgoing@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPCROutreach%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Copyright_applications</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>IPCROutreach@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=                 IPCROutreach@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Immigration Case</fullName>
        <actions>
            <name>Set_Product_Immigration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>immigration@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>immigrationsupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
                immigration@legalzoom.com
                immigrationsupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Legal Advantage Plan Case</fullName>
        <actions>
            <name>General_Inquiry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Order_Submitted_To_No</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_No_Specific_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_GI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>LRS@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>advantageplans@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>advantagesupport@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>LAC@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=                
LRS@legalzoom.com OR
advantageplans@legalzoom.com OR
 advantagesupport@legalzoom.com OR
 LAC@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LegalZoom Spotlight Case</fullName>
        <actions>
            <name>Set_Product_Spotlight</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>spotlight@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Contact@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
                spotlight@legalzoom.com
                Contact@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Log Call - Case Status Update</fullName>
        <actions>
            <name>Close_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Status__c</field>
            <operation>equals</operation>
            <value>Yes-SNE,Yes-Talk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.AM_Call_Log__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Log First Phone Call Date</fullName>
        <actions>
            <name>Update_First_Phone_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Total_Phone_Contacts__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Problem Case</value>
        </criteriaItems>
        <description>This workflow will write the date first phone call that was made for the Case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Logo Design Service Case</fullName>
        <actions>
            <name>Set_Product_To_Design_Patents</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>maria@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>cono@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
                maria@legalzoom.com
                cono@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted is False</fullName>
        <actions>
            <name>Set_Order_Submitted_To_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>bizdev@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>attorneylocatordiv@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logoworks@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=                 
bizdev@legalzoom.com OR
attorneylocatordiv@legalzoom.com OR
 logoworks@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted is TRUE</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>onlinefilings@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>revisions@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>smallclaimscl@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>TMMonitor@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tmofficeactions@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>vault@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fax3233890598@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=     onlinefilings@legalzoom.com OR
revisions@legalzoom.com OR
smallclaimscl@legalzoom.com OR
TMMonitor@legalzoom.com OR
tmofficeactions@legalzoom.com OR
vault@legalzoom.com OR
fax3233890598@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Change</fullName>
        <actions>
            <name>Update_Old_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Patent Case</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Patents</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>IPPTOutreach@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>patent(s)@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>illustration(s)@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals = 
IPPTOutreach@legalzoom.com
patent(s)@legalzoom.com
illustration(s)@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QC Fulfillment Case</fullName>
        <actions>
            <name>Set_QC_Fulfillment_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Send_for_Approval_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fulfillment QC Case</value>
        </criteriaItems>
        <description>Set default values for QC Fulfillment Cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RELCourtesy%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_To_Real_Estate_Leases</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Subreason_Liason_Inquiry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>RELCourtesy@legalzoom.com</value>
        </criteriaItems>
        <description>Case Orgin Equals:                 RELCourtesy@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Registered Agent Services Case</fullName>
        <actions>
            <name>Set_Category_to_Registered_Agents</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Registered_Agents</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_to_Registered_Agent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>raservice@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>raservices@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
                raservice@legalzoom.com
                raservices@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Email Subject at time case is created or edited</fullName>
        <actions>
            <name>Update_Email_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Order_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email_Subject__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If Email Subject is not populated by Case Wizard Flow, insert value from order number field into Email Subject Field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Store Previous problem resolution</fullName>
        <actions>
            <name>Copy_previous_problem_resolution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Problem_Order_Resolution__c ) &amp;&amp;  PRIORVALUE(Problem_Order_Resolution__c) != &apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TMCompSearchApprove%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Trademark_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tmcompsearchapprove@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
TMCompSearchApprove@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>US Trademark Case</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_To_Trademarks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>goodsandservices@legalzoom.com,trademark@legalzoom.com,trademarks@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>trademark(s)@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tmgsoutreach@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>TMBilling@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>TMDirectSearchApprove@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=
goodsandservices@legalzoom.com OR
trademark(s)@legalzoom.com OR
tmgsoutreach@legalzoom.com OR
TMBilling@legalzoom.com OR
TMDirectSearchApprove@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to ASD Legal Plan Sales</fullName>
        <actions>
            <name>Update_ASD_Legal_Plan_Sales_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Business Advantage Pro Standalone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update queue to ASD Legal Plan Sales</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to BIZ BSI Registered Agents</fullName>
        <actions>
            <name>Update_queue_to_BIZ_BSI_Registered_Agent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Registered Agent-Standalone,Registered Agent Renewal,Registered Agent</value>
        </criteriaItems>
        <description>Update queue to BIZ BSI Registered Agents</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to Biz BSI</fullName>
        <actions>
            <name>Biz_BSI_Queue_Assignment_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Field_Update_Case_Origin_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 OR 2 or 3) AND 4) or (3 and 5)</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>501(c)3 Preparation,Incorporation,LLP,Bylaws &amp; Resolutions,DBA,Annual Reports,LP,Amendment,LLC,Immigration - Greencards,Corporate Minutes,Immigration - Citizenship,NonProfit,Conversion,Foreign Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Corporate Dissolution,501(c)3 Preparation,S-Corp Preparation,Seller&apos;s Permit,State Tax ID</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>LegalZoom Business Development,EIN Obtainment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to Biz BSI</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC Attorney Services</fullName>
        <actions>
            <name>Update_queue_to_CC_Attorney_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_to_CC_Attorney_Services_Case_O</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Legal Advantage Plus Standalone,Business Advantage Pro Standalone,Bankruptcy</value>
        </criteriaItems>
        <description>Update queue to CC Attorney Services from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC Biz</fullName>
        <actions>
            <name>CC_Biz_Update_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_BizRR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Amendment,Incorporation,Bylaws &amp; Resolutions,Immigration - Greencards,Corporate Minutes,DBA,Immigration - Citizenship,Corporate Dissolution,Conversion,EIN Obtainment,Annual Reports,Foreign Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>,501(c)3 Preparation,Seller&apos;s Permit,S-Corp Preparation,LLC,LLP,NonProfit,State Tax ID,LP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to CC Biz</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC Divorce</fullName>
        <actions>
            <name>Update_CC_Divorce_Case_Origin_to_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_PS_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Divorce</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to CC Divorce</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC General</fullName>
        <actions>
            <name>Update_CC_General_Case_Origin_to_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_queue_to_CC_General_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Other,No Specific Service,LegalZoom Marketing,LegalZoom Policies</value>
        </criteriaItems>
        <description>Update queue to CC General from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC General when Case Origin %3D Email</fullName>
        <actions>
            <name>Update_Queue_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <description>Update queue to CC General when Case Origin = Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC IP</fullName>
        <actions>
            <name>Update_CC_IP_Case_Origin_to_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_IP_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>( 1 AND 2 AND 3 ) OR ( 4 AND 5 AND 6 )</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Patent Search,Provisional Patent,Trademark Section 8 Declaration,Trademark,Design Patent,Utility Patent Step II,Professional Patent Drawings,Utility Patent,Trademark Monitoring,Trademark Assignment,Copyright,Trademark Search</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>LegalZoom.com Information,Product Information,Questions About My Order,Registered Agents,Satisfaction Guarantee,Privacy &amp; Security,General Inquiry,Technical Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Trademark Section 9 Renewal,Trademark Section 8 Declaration,Trademark Statement of Use,Trademark,Trademark Monitoring,Trademark Assignment,Trademark Statement of Use Extension,Trademark Search</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Satisfaction Guarantee,General Inquiry</value>
        </criteriaItems>
        <description>Update queue to CC IP from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC Name Change</fullName>
        <actions>
            <name>Update_CC_Name_Change_Case_Origin_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_PS_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Name Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to CC Name Change  from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC PS</fullName>
        <actions>
            <name>Update_CC_EP_Case_origin_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_PS_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 2) and 3</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Power of Attorney,Living Trust,Last Will and Testament,Real Estate Deed Transfer,Living Will,Prenuptial Agreement,Pet Protection Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Last Will and Testament,Power of Attorney,Real Estate Deed Transfer,Living Will,Living Trust,Pet Protection Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to CC PS</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC Real Estate Leases</fullName>
        <actions>
            <name>CC_Real_Estate_Lease_Case_Origin_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Queue_to_CC_PS_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Real Estate Lease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to CC Real Estate Leases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to CC Small Claims</fullName>
        <actions>
            <name>Update_Queue_to_CC_PS_RR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Small Claims</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to CC Small Claims</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to IP BSI</fullName>
        <actions>
            <name>Update_IP_BSI_Case_Origin_to_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_queue_to_IP_BSI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>( 1 OR 6 OR 7 ) AND ( 2 AND ( 3 OR 4 )) OR ( 1 OR 6 OR 7) AND ( 4 AND 5 )</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Patent Search,Provisional Patent,Trademark Section 8 Declaration,Trademark,Design Patent,Utility Patent Step II,Professional Patent Drawings,Utility Patent,Trademark Monitoring,Trademark Assignment,Copyright,Trademark Search</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>LegalZoom.com Information,Product Information,Placing an Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>LegalZoom.com Information,Product Information,Questions About My Order,Registered Agents,Placing an Order,Privacy &amp; Security,General Inquiry,Technical Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Trademark Statement of Use Extension,Trademark Section 9 Renewal,Trademark Statement of Use</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Trademark Assignment,Trademark Section 8 Declaration,Trademark,Trademark Search,Trademark Monitoring</value>
        </criteriaItems>
        <description>Update queue to IP BSI from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to IP Copyright</fullName>
        <actions>
            <name>Update_IP_Copyrights_Case_Origin_to_We</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_queue_to_IP_Copyright</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND ( 3 OR 4 )</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Copyright</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Submit My Materials</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update queue to IP Copyright from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to IP Patent</fullName>
        <actions>
            <name>Update_IP_Patents_Case_Origin_to_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_queue_to_IP_Patents</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1  AND 2 AND (3 OR 4 )</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Patent Search,Provisional Patent,Utility Patent Step II,Design Patent,Utility Patent,Professional Patent Drawings</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Submit My Materials</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update queue to IP Patents from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to IP Trademarks</fullName>
        <actions>
            <name>Update_IP_Trademarks_Case_Origin_to_We</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_queue_to_IP_Trademarks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 4 AND (2 OR 3 )</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Trademark Section 9 Renewal,Trademark Section 8 Declaration,Trademark,Trademark Statement of Use,Trademark Monitoring,Trademark Assignment,Trademark Search,Trademark Statement of Use Extension</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Submit My Materials</value>
        </criteriaItems>
        <description>Update queue to IP Trademarks from Web to Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to PSD BSI</fullName>
        <actions>
            <name>Queue_PSD_Update_Case_Origin_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_queue_to_PSD_BSI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 and 3) or (2 and 4)</booleanFilter>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Power of Attorney,Real Estate Lease,Divorce,Living Trust,Last Will and Testament,Small Claims,Real Estate Deed Transfer,Living Will,Prenuptial Agreement,Pet Protection Agreement,Name Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Products__c</field>
            <operation>equals</operation>
            <value>Prenuptial Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Order_Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update queue to PSD BSI</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update queue to SPAM</fullName>
        <actions>
            <name>Update_Queue_Field_To_SPAM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>invitations@linkedin.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>noreply_stateboardofequalization@state.ca.gov</value>
        </criteriaItems>
        <description>Update Queue field to SPAM when Case Web Email equal invitations@linkedin.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update the Date%2FTime Case - Revision Complete</fullName>
        <actions>
            <name>Email_Alert_Biz_QC_Revision_Complete</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Date_Time_Revision_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Revision Complete</value>
        </criteriaItems>
        <description>this workflow triggers a date/time stamp everytime a case gets assigned to a new queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update the Date%2FTime Case - Revision Required</fullName>
        <actions>
            <name>Email_ALert_Biz_QC_Approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Date_Time_Revision_Required_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Biz_QC_Processor</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_QC_Error_Identified_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Revision Required</value>
        </criteriaItems>
        <description>this workflow triggers a date/time stamp everytime a case gets assigned to a new queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update the Date%2FTime Queue gets assigned</fullName>
        <actions>
            <name>Update_Date_Time_gets_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>this workflow triggers a date/time stamp everytime a case gets assigned to a new queue</description>
        <formula>Ischanged( Queue__c ) ||  (CreatedDate =   LastModifiedDate )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>alternatenames%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Change_To_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>alternatenames@legalzoom.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>alternatenames@legalzoom.com-no-subject</value>
        </criteriaItems>
        <description>Case Origin Equals 
alternatenames@legalzoom.com OR
alternatenames@legalzoom.com-no-subject</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>biznonprofitsupport%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Non_Profit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>biznonprofitsupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=                 biznonprofitsupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>businessservices%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Category_to_Submit_my_materials</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_to_Submit_my_Materials</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>businessservices@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=
businessservices@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>copyright%28s%29%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Category_to_Submit_my_materials</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Copyright_applications</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_to_Submit_my_Materials</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>copyright@legalzoom.com,copyright(s)@legalzoom.com,copyrights@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
copyright(s)@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>designpatent%28s%29%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_to_Design_Patent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>designpatent@legalzoom.com,designpatents@legalzoom.com,designpatent(s)@legalzoom.com</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>designpatents%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_To_Design_Patents</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>designpatents@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=designpatents@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>divorce%40lz%2Ecom CA Follow Up</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Divorce</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Order_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>divorce@lz.com CA Follow Up</value>
        </criteriaItems>
        <description>Case Origin Equals=divorce@lz.com CA Follow Up</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>drefund%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Divorce</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_Cancel_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>drefund@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals =     drefund@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>einsupport%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_to_EIN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>einsupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= einsupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eventhandlercopy%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Order_Submitted_To_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>eventhandlercopy@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=  eventhandlercopy@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>forms%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Product_Set_to_Legal_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>forms@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
forms@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>freelivingwillrev%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Product_Set_to_Living_Will</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>freelivingwillrev@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
freelivingwillrev@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>incorporations%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_Corporation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>incorporations@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=
incorporations@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>livingtrusts%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_to_Last_Will_and_Testament</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>livingtrusts@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
                livingtrusts@legalzoom.com
                TV/Radio Test</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>llcs%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_to_LLC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>llcs@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals
llcs@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>namechangecl%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Name_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>namechangecl@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
namechangecl@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>namechangesupport%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_to_Name_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>namechangesupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= namechangesupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nonprofit%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Category_to_Submit_my_materials</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Non_Profit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SubReason_to_Submit_my_Materials</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>nonprofit@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= nonprofit@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>patentsearch%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Patents</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>patentsearch@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
patentsearch@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>smallclaims%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_Small_Claims</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>smallclaims@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals=  smallclaims@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>specialfilingsupport%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_Other_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>specialfilingsupport@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
specialfilingsupport@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>tmsearch%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Product_to_Trademark_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tmsearch@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
tmsearch@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>tmupdates%40legalzoom%2Ecom</fullName>
        <actions>
            <name>Set_Order_Submitted_To_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Product_to_Trademark_Monitoring</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tmupdates@legalzoom.com</value>
        </criteriaItems>
        <description>Case Origin Equals= 
tmupdates@legalzoom.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
