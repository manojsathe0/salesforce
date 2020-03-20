<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Mobile_Lead_Ownership_Change_Alert</fullName>
        <description>Mobile Lead Ownership Change Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>djin@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jbagwell@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jlgamel@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mrosal@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>New_Mobile_Lead_Alert</fullName>
        <description>New Mobile Lead Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Lead_Owner</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_Integration_User</fullName>
        <field>OwnerId</field>
        <lookupValue>integration@legalzoom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Integration User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Assigned</fullName>
        <field>Date_Time_Assigned__c</field>
        <formula>NOW()</formula>
        <name>Date/Time Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Created_Date_Time_Update</fullName>
        <field>Date_Time_Created_Adjusted__c</field>
        <formula>if ( 
Hour_Created__c &lt; 24 &amp;&amp; ((Daylight_Saving_Created_Date__c = &quot;Yes&quot; &amp;&amp; Hour_Created__c &gt;= 19) || (Daylight_Saving_Created_Date__c = &quot;No&quot; &amp;&amp; Hour_Created__c &gt;= 18)), 

( 

if (VALUE(MID(TEXT(CreatedDate),9,2)) = 1, 
if (VALUE(MID(TEXT(CreatedDate),6,2)) = 1, &quot;12&quot;, TEXT(VALUE(MID(TEXT(CreatedDate),6,2))-1)), 
TEXT(VALUE(MID(TEXT(CreatedDate),6,2))) 
)
 
&amp; &quot;/&quot; &amp; 

if (VALUE(MID(TEXT(CreatedDate),9,2)) = 1, 

if (VALUE(MID(TEXT(CreatedDate),6,2)) = 5 || VALUE(MID(TEXT(CreatedDate),6,2)) = 7 || VALUE(MID(TEXT(CreatedDate),6,2)) = 10 || VALUE(MID(TEXT(CreatedDate),6,2)) = 12, 
&quot;30&quot;,
if (VALUE(MID(TEXT(CreatedDate),6,2)) = 3, 
if (MOD(VALUE(MID(TEXT(CreatedDate),1,4)),4) = 0, 
&quot;29&quot;, 
&quot;28&quot;
), 
&quot;31&quot;
)
)

, 
TEXT(VALUE(MID(TEXT(CreatedDate),9,2))-1) 

&amp; &quot;/&quot; &amp; 

if (VALUE(MID(TEXT(CreatedDate),9,2)) = 1 &amp;&amp; VALUE(MID(TEXT(CreatedDate),6,2)) = 1,
TEXT(VALUE(MID(TEXT(CreatedDate),1,4))-1),
MID(TEXT(CreatedDate),1,4)
)

) 

), 


TEXT(VALUE(MID(TEXT(CreatedDate),6,2))) &amp; &quot;/&quot; &amp; TEXT(VALUE(MID(TEXT(CreatedDate),9,2))) &amp; &quot;/&quot; &amp; MID(TEXT(CreatedDate),1,4) 

) 

&amp; &quot; &quot; &amp; 

if(Hour_Created__c&gt;12, 
TEXT(Hour_Created__c-12) &amp; &quot;:&quot; &amp; MID(TEXT(CreatedDate),15,2) &amp;&quot; PM CST&quot;, 
if(Hour_Created__c=0, 
&quot;12&quot; &amp; &quot;:&quot; &amp; MID(TEXT(CreatedDate),15,2) &amp; &quot; AM CST&quot;, 
if(Hour_Created__c=12, 
TEXT(Hour_Created__c) &amp; &quot;:&quot; &amp; MID(TEXT(CreatedDate),15,2) &amp; &quot; PM CST&quot;, 
TEXT(Hour_Created__c) &amp; &quot;:&quot; &amp; MID(TEXT(CreatedDate),15,2) &amp; &quot; AM CST&quot;)))</formula>
        <name>Lead Created Date Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Last_Modified_Date_Time_Update</fullName>
        <description>Update Date_Time_Last_Modified_Adjusted__c field to Central Time</description>
        <field>Date_Time_Last_Modified_Adjusted__c</field>
        <formula>if ( 
Hour_Last_Modified__c &lt; 24 &amp;&amp; ((Daylight_Saving_Last_Modified__c = &quot;Yes&quot; &amp;&amp; Hour_Last_Modified__c &gt;= 19) || (Daylight_Saving_Last_Modified__c = &quot;No&quot; &amp;&amp; Hour_Last_Modified__c &gt;= 18)), 

( 

if (VALUE(MID(TEXT(LastModifiedDate),9,2)) = 1, 
if (VALUE(MID(TEXT(LastModifiedDate),6,2)) = 1, &quot;12&quot;, TEXT(VALUE(MID(TEXT(LastModifiedDate),6,2))-1)), 
TEXT(VALUE(MID(TEXT(LastModifiedDate),6,2))) 
)
 
&amp; &quot;/&quot; &amp; 

if (VALUE(MID(TEXT(LastModifiedDate),9,2)) = 1, 

if (VALUE(MID(TEXT(LastModifiedDate),6,2)) = 5 || VALUE(MID(TEXT(LastModifiedDate),6,2)) = 7 || VALUE(MID(TEXT(LastModifiedDate),6,2)) = 10 || VALUE(MID(TEXT(LastModifiedDate),6,2)) = 12, 
&quot;30&quot;,
if (VALUE(MID(TEXT(LastModifiedDate),6,2)) = 3, 
if (MOD(VALUE(MID(TEXT(LastModifiedDate),1,4)),4) = 0, 
&quot;29&quot;, 
&quot;28&quot;
), 
&quot;31&quot;
)
)

, 
TEXT(VALUE(MID(TEXT(LastModifiedDate),9,2))-1) 

&amp; &quot;/&quot; &amp; 

if (VALUE(MID(TEXT(LastModifiedDate),9,2)) = 1 &amp;&amp; VALUE(MID(TEXT(LastModifiedDate),6,2)) = 1,
TEXT(VALUE(MID(TEXT(LastModifiedDate),1,4))-1),
MID(TEXT(LastModifiedDate),1,4)
)

) 

), 


TEXT(VALUE(MID(TEXT(LastModifiedDate),6,2))) &amp; &quot;/&quot; &amp; TEXT(VALUE(MID(TEXT(LastModifiedDate),9,2))) &amp; &quot;/&quot; &amp; MID(TEXT(LastModifiedDate),1,4) 

) 

&amp; &quot; &quot; &amp; 

if(Hour_Last_Modified__c&gt;12, 
TEXT(Hour_Last_Modified__c-12) &amp; &quot;:&quot; &amp; MID(TEXT(LastModifiedDate),15,2) &amp;&quot; PM CST&quot;, 
if(Hour_Last_Modified__c=0, 
&quot;12&quot; &amp; &quot;:&quot; &amp; MID(TEXT(LastModifiedDate),15,2) &amp; &quot; AM CST&quot;, 
if(Hour_Last_Modified__c=12, 
TEXT(Hour_Last_Modified__c) &amp; &quot;:&quot; &amp; MID(TEXT(LastModifiedDate),15,2) &amp; &quot; PM CST&quot;, 
TEXT(Hour_Last_Modified__c) &amp; &quot;:&quot; &amp; MID(TEXT(LastModifiedDate),15,2) &amp; &quot; AM CST&quot;)))</formula>
        <name>Lead Last Modified Date Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_IsChanged_WF</fullName>
        <field>LeadOwnerChanged__c</field>
        <formula>IF(ISCHANGED(OwnerId) ,NOW(), LeadOwnerChanged__c )</formula>
        <name>Lead Owner IsChanged WF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Recordtype_Update_to_BS</fullName>
        <description>Update Lead object Recordtype field to Business Services</description>
        <field>RecordTypeId</field>
        <lookupValue>Business_Services</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead Recordtype Update to BS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Team_Update_To_Attorney_Services</fullName>
        <field>Team__c</field>
        <formula>&apos;Attorney Services&apos;</formula>
        <name>Lead Team Update To Attorney Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Team_Update_To_Business_Services</fullName>
        <description>Lead object Team field update to Business Services</description>
        <field>Team__c</field>
        <formula>&apos;Business Services&apos;</formula>
        <name>Lead Team Update To Business Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Team_Update_to_IP_Services</fullName>
        <description>Lead object Team field update to Business Services (IP Not Sure/Copyright/Trademark/Patent)</description>
        <field>Team__c</field>
        <formula>&apos;IP Services&apos;</formula>
        <name>Lead Team Update to IP Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Line_Attorney_Services</fullName>
        <description>Attorney Services Mobile Leads update Product Line field to Attorney Services</description>
        <field>Product_Line__c</field>
        <literalValue>Attorney Services</literalValue>
        <name>Product Line - Attorney Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Line_Business_Formations</fullName>
        <description>If Business Service field is LLC, Incorporation, DBA, Nonprofit, Other, or Biz Not Sure, then update Product Line field to Business Formations</description>
        <field>Product_Line__c</field>
        <literalValue>Business Formations</literalValue>
        <name>Product Line - Business Formations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Line_IP_Services</fullName>
        <field>Product_Line__c</field>
        <literalValue>Intellectual Property</literalValue>
        <name>Product Line - IP Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Phone_Field</fullName>
        <field>Phone</field>
        <name>Reset Phone Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Response</fullName>
        <field>First_Response__c</field>
        <formula>NOW()</formula>
        <name>Update First Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Description2</fullName>
        <description>Update Lead Description2 from Lead Description.
 Description2 is mapped to Lead Description field in opportunity object</description>
        <field>Description_2__c</field>
        <formula>Description</formula>
        <name>Update Lead Description2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Email_From_Company</fullName>
        <field>Email</field>
        <formula>Company</formula>
        <name>Update Lead Email From Company</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_RecordType_to_AS</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Attorney_Services</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Lead RecordType to AS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Ownership</fullName>
        <field>OwnerId</field>
        <lookupValue>saleslist@legalzoom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Ownership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_to_Quick_Start</fullName>
        <description>Updates the Team to Quick Start</description>
        <field>Team__c</field>
        <formula>&quot;Quick Start&quot;</formula>
        <name>Update Team to Quick Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Today_to_SOB</fullName>
        <field>Today__c</field>
        <formula>IF( Day_of_the_Week__c = &quot;Saturday&quot;, DATETIMEVALUE(TEXT(DATEVALUE(  LastModifiedDate ))&amp;&quot; 15:00:00&quot;), DATETIMEVALUE(TEXT(DATEVALUE(  LastModifiedDate ))&amp;&quot; 13:00:00&quot;))</formula>
        <name>Update Today to SOB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_End_of_Business_1</fullName>
        <field>End_of_Business_Sales__c</field>
        <formula>IF( Day_of_the_Week__c = &quot;Saturday&quot;, DATETIMEVALUE(TEXT(DATEVALUE( CreatedDate ))&amp;&quot; 22:00:00&quot;), DATETIMEVALUE(TEXT(DATEVALUE( CreatedDate)+1)&amp;&quot; 03:00:00&quot;))</formula>
        <name>Update to End of Business</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Start_of_Business_1</fullName>
        <field>Start_of_Business_Sales__c</field>
        <formula>IF( Day_of_the_Week__c = &quot;Saturday&quot;, DATETIMEVALUE(TEXT(DATEVALUE( CreatedDate ))&amp;&quot; 16:00:00&quot;), DATETIMEVALUE(TEXT(DATEVALUE( CreatedDate))&amp;&quot; 14:00:00&quot;))</formula>
        <name>Update to Start of Business</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assigned to Scott Facebook leads</fullName>
        <actions>
            <name>Assign_to_Integration_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Facebook</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Scott Luikart</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Created and Last Modified Date Time Update</fullName>
        <actions>
            <name>Lead_Created_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Last_Modified_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_to_End_of_Business_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_to_Start_of_Business_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update lead created and last modified date time field to central time with daylight saving adjusted</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Description IsChanged</fullName>
        <actions>
            <name>Update_Lead_Description2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Description) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Owner IsAssigned</fullName>
        <actions>
            <name>Date_Time_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Owner IsChanged WF</fullName>
        <actions>
            <name>Lead_Owner_IsChanged_WF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>2 AND (1 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>SalesListOwner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Integration User</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Source Detail Attorney Services</fullName>
        <actions>
            <name>Lead_Team_Update_To_Attorney_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Line_Attorney_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_RecordType_to_AS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail__c</field>
            <operation>equals</operation>
            <value>Attorney Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Mobile,Web</value>
        </criteriaItems>
        <description>If the lead source detail custom field is Attorney Services, update record type to Attorney Services</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Source Detail Quick Start</fullName>
        <actions>
            <name>Lead_Recordtype_Update_to_BS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Line_Business_Formations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail__c</field>
            <operation>equals</operation>
            <value>Quick Start</value>
        </criteriaItems>
        <description>If lead source detail is Quick Start, then set team to Quick Start, product line to business formations, record type to business services</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Source Mobile Business Services</fullName>
        <actions>
            <name>Lead_Recordtype_Update_to_BS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Team_Update_To_Business_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Line_Business_Formations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail__c</field>
            <operation>equals</operation>
            <value>Business Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Mobile</value>
        </criteriaItems>
        <description>If the lead source detail custom field is Business Services, update record type to Business Services and team field to Business Services</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Source Mobile IP Services</fullName>
        <actions>
            <name>Lead_Recordtype_Update_to_BS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Team_Update_to_IP_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Line_IP_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail__c</field>
            <operation>equals</operation>
            <value>Business Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Mobile</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Business_Service__c</field>
            <operation>equals</operation>
            <value>Copyright,Patent,Trademark,IP Not Sure</value>
        </criteriaItems>
        <description>If the lead source detail custom field is Business Services, update record type to Business Services and team field to IP Services</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Team To  Quick Start</fullName>
        <actions>
            <name>Update_Team_to_Quick_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail__c</field>
            <operation>equals</operation>
            <value>Quick Start</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Review_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Order_No__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow rule to update the Lead Team to Quick Start</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Update Email From Company</fullName>
        <actions>
            <name>Update_Lead_Email_From_Company</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail__c</field>
            <operation>equals</operation>
            <value>Attorney Services,Business Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Mobile</value>
        </criteriaItems>
        <description>Update lead email field from company field</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Leads - First Response WF</fullName>
        <actions>
            <name>Update_First_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Today_to_SOB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(PRIORVALUE ( Status ), &quot;New&quot;) &amp;&amp;  NOT(ISPICKVAL( Status , &quot;New&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prevent Anonymous Phone</fullName>
        <actions>
            <name>Reset_Phone_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Phone</field>
            <operation>equals</operation>
            <value>anonymous</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Phone</field>
            <operation>equals</operation>
            <value>Anonymous</value>
        </criteriaItems>
        <description>Prevents anonymous value from populating into lead phone field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Owner for Mobile Leads</fullName>
        <actions>
            <name>Update_Ownership</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Mobile</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Unqualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>System</value>
        </criteriaItems>
        <description>This changes the lead owner from Syst to SalesListOwner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
