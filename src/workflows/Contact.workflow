<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Authorized_Contact_Field_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Authorized_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Authorized Contact - Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Date_Time_Assigned</fullName>
        <field>Date_Time_Assigned__c</field>
        <formula>NOW()</formula>
        <name>Contact: Date/Time Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Contact_Field_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Standard_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Primary Contact - Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Time_Sensitive_Score_On_Contact</fullName>
        <field>Lead_Score_Time_Sensitive_Score__c</field>
        <formula>(((Lead_Score_Last_time_on_DBA_Q_Score__c +  Lead_Score_Last_time_on_INC_Q_score__c + Lead_Score_Last_time_on_LLC_Q_score__c + Lead_Score_Last_time_on_NP_Q_score__c + Lead_score_last_time_on_website_score__c+Lead_Score_last_called_in_time_score__c+Lead_Score_last_emailed_in_time_score__c)/ Lead_score_time_sensitive_bucket_total__c )* Lead_score_time_sensitive_bucket_percent__c )</formula>
        <name>Update Time Sensitive Score on contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_time_sensitive_score_to_Zero</fullName>
        <field>Lead_Score_Time_Sensitive_Score__c</field>
        <formula>0</formula>
        <name>Update time sensitive score to Zero</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Authorized Contact - Update Record Type</fullName>
        <actions>
            <name>Authorized_Contact_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Authorized Contact</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Owner IsAssigned</fullName>
        <actions>
            <name>Contact_Date_Time_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Primary Contact - Update Record Type</fullName>
        <actions>
            <name>Primary_Contact_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Primary Contact</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update time sensitive score on Contact</fullName>
        <actions>
            <name>Update_Time_Sensitive_Score_On_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_total__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_percent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_percent__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_total__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update time sensitive score to Zero</fullName>
        <actions>
            <name>Update_time_sensitive_score_to_Zero</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_percent__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_total__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_percent__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Lead_score_time_sensitive_bucket_total__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
