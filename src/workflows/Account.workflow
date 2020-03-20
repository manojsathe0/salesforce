<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atty_Consult_Notes_Update</fullName>
        <description>Append Account Atty_Tax_Consult_Log__c update to account Atty_Tax_Consult_Log_All__c field</description>
        <field>Atty_Tax_Consult_Log_All__c</field>
        <formula>Text(Month(DATEVALUE( LastModifiedDate ))) + &apos;/&apos; + 
Text(Day(DATEVALUE( LastModifiedDate ))) + &apos;/&apos; + 
Text(Year(DATEVALUE( LastModifiedDate ))) + 
&apos; (&apos; + TEXT(Last_Touch_Point__c) + &apos;): &apos; + Atty_Tax_Consult_Log__c + BR() + PRIORVALUE( Atty_Tax_Consult_Log_All__c )</formula>
        <name>Atty Consult Notes Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_AM_Last_Mod_Set_to_Now</fullName>
        <description>Set Date/Time Acct Mgr Last Modified field to current time</description>
        <field>Date_Time_Acct_Mgr_Last_Modified__c</field>
        <formula>Now()</formula>
        <name>Date/Time AM Last Mod Set to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Opt_In_Field_Update</fullName>
        <field>Date_Time_Opt_In__c</field>
        <formula>now()</formula>
        <name>Date/Time Opt In Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Package_Offer_Field_Update</fullName>
        <field>Date_Time_Package_Offer__c</field>
        <formula>NOW()</formula>
        <name>Date/Time Package Offer Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Trial_15</fullName>
        <field>Date_Time_Trial_15__c</field>
        <formula>NOW()</formula>
        <name>Date/Time Trial 15</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Trial_30</fullName>
        <field>Date_Time_Trial_30__c</field>
        <formula>NOW()</formula>
        <name>Date/Time Trial 30</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Status_Active</fullName>
        <field>Service_Status2__c</field>
        <formula>&quot;Active&quot;</formula>
        <name>Service Status - Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Status_Not_Active</fullName>
        <field>Service_Status2__c</field>
        <formula>&quot;Not Active&quot;</formula>
        <name>Service Status - Not Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Status_Supervised</fullName>
        <field>Service_Status2__c</field>
        <formula>&quot;Supervised&quot;</formula>
        <name>Service Status - Supervised</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Time_AM_Type</fullName>
        <description>Set the date/time am type field to current time</description>
        <field>Date_Time_AM_Type__c</field>
        <formula>Now()</formula>
        <name>Set Date/Time AM Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Time_to_Now</fullName>
        <field>Date_Time_Acct_Mgr_Assigned__c</field>
        <formula>Now()</formula>
        <name>Set Date/Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Trial_15_True</fullName>
        <field>Trial_15__c</field>
        <literalValue>1</literalValue>
        <name>Trial 15 - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Trial_30_True</fullName>
        <field>Trial_30__c</field>
        <literalValue>1</literalValue>
        <name>Trial 30 - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AM_Status_History</fullName>
        <field>AM_Status_History__c</field>
        <formula>AM_Status_History__c+AM_Status_Text__c</formula>
        <name>Update AM Status History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_AM_Assigned_to_Now</fullName>
        <field>Date_Time_Latest_Acct_Mgr_Assigned__c</field>
        <formula>NOW()</formula>
        <name>Update Date/Time AM Assigned to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_Acct_Name_Changed</fullName>
        <description>Update field Date/Time Acct Name Changed</description>
        <field>Date_Time_Acct_Name_Changed__c</field>
        <formula>NOW()</formula>
        <name>Update Date/Time Acct Name Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_Latest_AM_gets_Assigned</fullName>
        <field>Date_Time_Latest_Acct_Mgr_Assigned__c</field>
        <formula>now()</formula>
        <name>Update Date/Time Latest AM gets Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_Not_Active</fullName>
        <field>Date_Time_Not_Active__c</field>
        <formula>NOW()</formula>
        <name>Update Date/Time Not Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Atty%2FConsult Log Update</fullName>
        <actions>
            <name>Atty_Consult_Notes_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update order Atty_Tax_Consult_Log_All__c field to include all attorney consult notes.</description>
        <formula>NOT ISBLANK( Atty_Tax_Consult_Log__c ) &amp;&amp; Atty_Tax_Consult_Log__c != PRIORVALUE(Atty_Tax_Consult_Log__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Login%2FEmail Changed</fullName>
        <actions>
            <name>Update_Date_Time_Acct_Name_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Stamp time when Login/Email has not changed by Integration User</description>
        <formula>NOT( $User.Id = &quot;005G0000001qcaP&quot;) &amp;&amp; ( ISNEW() || ISChanged(Name))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Set Date%2FTime AM Changes</fullName>
        <actions>
            <name>Date_Time_AM_Last_Mod_Set_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set last modified date/time of account manager related fields</description>
        <formula>(ISNEW() &amp;&amp; NOT ISBLANK( Business_Account_Manager__c )) || ISCHANGED( Business_Account_Manager__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Set Date%2FTime AM First Assigned</fullName>
        <actions>
            <name>Set_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Date_Time_AM_Assigned_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the date/time when an account manager is first assigned to an account.</description>
        <formula>Business_Account_Manager__r.UserRole.Name = &quot;Business Account Manager&quot;  &amp;&amp;  ISBLANK(PRIORVALUE( Date_Time_Acct_Mgr_Assigned__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date%2FTime AM Type Change</fullName>
        <actions>
            <name>Set_Date_Time_AM_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the datetime whenever AM Type field changes</description>
        <formula>ISCHANGED(Opt_In_Type__c) ||  (ISNEW() &amp;&amp; NOT ISPICKVAL(Opt_In_Type__c,&apos;&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date%2FTime Latest AM gets Assigned</fullName>
        <actions>
            <name>Update_Date_Time_Latest_AM_gets_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the date/time when an account manager get assigned to an account. update time every time a AM is assigned</description>
        <formula>Ischanged(Business_Account_Manager__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date%2FTime Opt In Workflow</fullName>
        <actions>
            <name>Date_Time_Opt_In_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date%2FTime Package Offer</fullName>
        <actions>
            <name>Date_Time_Package_Offer_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Paid_Offer__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Status Update - Active</fullName>
        <actions>
            <name>Date_Time_AM_Last_Mod_Set_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Status_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>3 OR (1 and 2) OR (4 AND 5) OR (6 AND 7)</booleanFilter>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Not Yet Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Opt_In_Type__c</field>
            <operation>equals</operation>
            <value>Biz Starter,Sales Pilot,EP Starter,Quick Start</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Completed - Sales Starter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Opt_In_Type__c</field>
            <operation>equals</operation>
            <value>Alpha,Biz AM,TM-AM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Opt_In_Type__c</field>
            <operation>equals</operation>
            <value>Biz AM,Biz Starter,Sales Pilot,TM-AM,EP Starter,Quick Start</value>
        </criteriaItems>
        <description>updates Service Status FIeld based on AM Status and AM Type selection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Status Update - Not Active</fullName>
        <actions>
            <name>Date_Time_AM_Last_Mod_Set_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Status_Not_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Date_Time_Not_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR  (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Opt-Out - Customer,Opt-Out - EOM,Opt-Out - Bandwidth</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Opt_In_Type__c</field>
            <operation>equals</operation>
            <value>Alpha,Biz AM,Biz Starter,Sales Pilot,TM-AM,EP Starter,Quick Start</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Completed - Sales Starter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Opt_In_Type__c</field>
            <operation>equals</operation>
            <value>Biz Starter,Sales Pilot,EP Starter,Quick Start</value>
        </criteriaItems>
        <description>updates Service Status FIeld based on AM Status and AM Type selection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Status Update - Supervised</fullName>
        <actions>
            <name>Date_Time_AM_Last_Mod_Set_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Status_Supervised</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Not Yet Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Opt_In_Type__c</field>
            <operation>equals</operation>
            <value>TM-AM,Biz AM,Alpha</value>
        </criteriaItems>
        <description>updates Service Status FIeld based on AM Status and AM Type selection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trial 15 - Update</fullName>
        <actions>
            <name>Date_Time_Trial_15</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Trial_15_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Trial 15</value>
        </criteriaItems>
        <description>updates trial 15 checkbox based on AM status Trial 15 selection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trial 30 - Update</fullName>
        <actions>
            <name>Date_Time_Trial_30</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Trial_30_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Free_Offer__c</field>
            <operation>equals</operation>
            <value>Trial 30</value>
        </criteriaItems>
        <description>updates trial 30 checkbox based on AM status Trial 30 selection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update AM Status History</fullName>
        <actions>
            <name>Update_AM_Status_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT ISBLANK( AM_Status_Text__c ) &amp;&amp; AM_Status_Text__c != PRIORVALUE(AM_Status_Text__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
