<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assign_to_SPAM_queue</fullName>
        <field>Queue__c</field>
        <literalValue>SPAM</literalValue>
        <name>Assign to SPAM queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EmailMessage_Set_Case_Status_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>EmailMessage: Set Case Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Updated_by_Customer2</fullName>
        <field>Status</field>
        <literalValue>Updated by Customer</literalValue>
        <name>Set Status Updated by Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Close Case and Change to SPAM</fullName>
        <actions>
            <name>Assign_to_SPAM_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EmailMessage_Set_Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Close Case and Assign to Spam queue if subject and from address are in conditions.</description>
        <formula>(FromAddress = &apos;NoReply_StateBoardofEqualization@state.ca.gov&apos; &amp;&amp; Subject = &apos;state of equilization, california&apos;)   || (FromAddress = &apos;Ndse@docusign.net&apos; &amp;&amp; Subject = &apos;DocuSign Email Delivery Status Notification&apos;)   || (FromAddress = &apos;mailer-daemon@googlemail.com&apos; &amp;&amp; Subject = &apos;Delivery Status Notification (Failure)&apos;)  || (Subject = &apos;Mail delivery failed&apos; &amp;&amp; (FromAddress = &apos;mailer-daemon@p02c12o149.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c12o148.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c12o147.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c12o145.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c12o144.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c12o143.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c12o142.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o149.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o148.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o147.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o145.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o144.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o143.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o142.mxlogic.net&apos; || FromAddress = &apos;mailer-daemon@p02c11o141.mxlogic.net&apos; || FromAddress = &apos;Mailer-Daemon@eigbox.net &apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Inbound Email - New</fullName>
        <actions>
            <name>Set_Status_Updated_by_Customer2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 ) AND ((4 OR 7 OR 8) OR (5 AND 6) )</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Number_Inbound_Emails__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed,Closed – First Response,Waiting on Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Total_Manual_Outbound_Emails__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.USPTO_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Number_Inbound_Emails__c</field>
            <operation>notEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.created_date__c</field>
            <operation>lessOrEqual</operation>
            <value>10/29/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Problem Case</value>
        </criteriaItems>
        <description>Sets the case status when a new email is received.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
