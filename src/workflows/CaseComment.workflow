<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_LLC_NPS_DL</fullName>
        <description>Alert LLC NPS DL</description>
        <protected>false</protected>
        <recipients>
            <recipient>llcnps@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LLC_NPS_DL_Alert</template>
    </alerts>
    <rules>
        <fullName>LLC NPS - Order %23</fullName>
        <actions>
            <name>Alert_LLC_NPS_DL</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>LLC NPS – Order</value>
        </criteriaItems>
        <description>when a case comment is made and the subject of the case starts with &quot;LLC NPS - Order #&quot; that we send an email alert to DL-LLCNPS with template</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
