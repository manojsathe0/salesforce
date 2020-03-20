<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Commission_Eligible_Update_Field</fullName>
        <field>Commission_Eligible__c</field>
        <formula>IF 
( 
TEXT(Agent__c )= &quot;Agent 1&quot; &amp;&amp; 
Sales_Cycle__c =&quot;Day 5&quot; &amp;&amp; 
Order__r.Order_Created_By__c &lt;&gt; &quot;RB.ConsoleApp&quot; &amp;&amp; 
CONTAINS(Order__r.Base_Product__r.Name, &apos;RA Renewal&apos;) 
, 1, 


IF 
( 
TEXT(Agent__c )= &quot;Agent 2&quot; &amp;&amp; 
Order__r.Order_Created_By__c &lt;&gt; &quot;RB.ConsoleApp&quot; &amp;&amp; 
CONTAINS(Order__r.Base_Product__r.Name, &apos;RA Renewal&apos;) 
, null, 


If 
( 
Order__r.Commission_Eligible_Agent_1__r.Id &lt;&gt; Order__r.Commission_Eligible_Agent_2__r.Id &amp;&amp; 
TEXT(Agent__c )= &quot;Agent 2&quot; &amp;&amp; 
((Order__r.Is_First_RA_Renewal__c =True) ||(Sales_Cycle__c =&quot;Day 1&quot;)) 
, 0.25, 


IF 
( 
Order__r.Commission_Eligible_Agent_1__r.Id = Order__r.Commission_Eligible_Agent_2__r.Id &amp;&amp; 
TEXT(Agent__c )= &quot;Agent 1&quot;&amp;&amp; 
((Order__r.Is_First_RA_Renewal__c =True) || (Sales_Cycle__c =&quot;Day 1&quot;)) 
, 1, 


IF 
( 
Order__r.Commission_Eligible_Agent_1__r.Id &lt;&gt; Order__r.Commission_Eligible_Agent_2__r.Id&amp;&amp; 
TEXT(Agent__c )= &quot;Agent 1&quot;&amp;&amp; 
((Order__r.Is_First_RA_Renewal__c =True &amp;&amp;  DATEVALUE(Order__r.Parent_Order__r.Order_Date_Time_Created__c)  &gt; DATE(2013,06,01)) || (Sales_Cycle__c =&quot;Day 1&quot;&amp;&amp; Hours_Between_Order_and_Activity_Agent_2__c &lt;=24)) 
, 0.75, 


IF 
( 
Order__r.Commission_Eligible_Agent_1__r.Id &lt;&gt; Order__r.Commission_Eligible_Agent_2__r.Id&amp;&amp; 
TEXT(Agent__c )= &quot;Agent 1&quot;&amp;&amp; 
Hours_Between_Order_and_Activity_Agent_2__c &gt;24&amp;&amp; 
Sales_Cycle__c =&quot;Day 1&quot; 
, 1, 



null 




))))))</formula>
        <name>Commission Eligible % - Update Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OMA_Date_Time_Matching_Adjusted_Set</fullName>
        <description>Set OMA Date/Time Matching Adjusted field to current time</description>
        <field>Date_Time_Matching_Adjusted__c</field>
        <formula>NOW()</formula>
        <name>OMA Date/Time Matching Adjusted Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Cycle_30_Update</fullName>
        <field>Sales_Cycle_30__c</field>
        <formula>If( Hours_between_Order_and_Activity__c &lt;=24, 1, 
If( Hours_between_Order_and_Activity__c &lt;=48, 2, 
If( Hours_between_Order_and_Activity__c &lt;=72, 3, 
If( Hours_between_Order_and_Activity__c &lt;=96, 4, 
If( Hours_between_Order_and_Activity__c &lt;=120, 5, 
If( Hours_between_Order_and_Activity__c &lt;=144, 6, 
If( Hours_between_Order_and_Activity__c &lt;=168, 7, 
If( Hours_between_Order_and_Activity__c &lt;=192, 8, 
If( Hours_between_Order_and_Activity__c &lt;=216, 9, 
If( Hours_between_Order_and_Activity__c &lt;=240, 10, 
If( Hours_between_Order_and_Activity__c &lt;=264, 11, 
If( Hours_between_Order_and_Activity__c &lt;=288, 12, 
If( Hours_between_Order_and_Activity__c &lt;=312, 13, 
If( Hours_between_Order_and_Activity__c &lt;=336, 14, 
If( Hours_between_Order_and_Activity__c &lt;=360, 15, 
If( Hours_between_Order_and_Activity__c &lt;=384, 16, 
If( Hours_between_Order_and_Activity__c &lt;=408, 17, 
If( Hours_between_Order_and_Activity__c &lt;=432, 18, 
If( Hours_between_Order_and_Activity__c &lt;=456, 19, 
If( Hours_between_Order_and_Activity__c &lt;=480, 20, 
If( Hours_between_Order_and_Activity__c &lt;=504, 21, 
If( Hours_between_Order_and_Activity__c &lt;=528, 22, 
If( Hours_between_Order_and_Activity__c &lt;=552, 23, 
If( Hours_between_Order_and_Activity__c &lt;=576, 24, 
If( Hours_between_Order_and_Activity__c &lt;=600, 25, 
If( Hours_between_Order_and_Activity__c &lt;=624, 26, 
If( Hours_between_Order_and_Activity__c &lt;=648, 27, 
If( Hours_between_Order_and_Activity__c &lt;=672, 28, 
If( Hours_between_Order_and_Activity__c &lt;=696, 29, 
If( Hours_between_Order_and_Activity__c &lt;=720, 30, 

Null 
))))))))))))))))))))))))))))))</formula>
        <name>Sales Cycle 30 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Activities_From_Lead</fullName>
        <field>Total_Activities__c</field>
        <formula>IF(!ISBLANK(Lead__c), Lead__r.Total_Activities__c , Contact__r.Total_Activities__c )</formula>
        <name>Update Total Activities From Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OMA%3A Update Commission Eligible %25</fullName>
        <actions>
            <name>Commission_Eligible_Update_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Matching_Activity__c.Activity_Commission_Eligible__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>REQ: OMA - FOR: Field Update. - WHY: When the Activity Commission Eligible equates to true then the Commission Eligible % will be updated with specific caluclations detailed in the Field Update.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OMA%3A Update Date%2FTime Matching Adjusted Date</fullName>
        <actions>
            <name>OMA_Date_Time_Matching_Adjusted_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>REQ: OMA - FOR: Date/Time Update. - WHY: When the Adjustment Type is changed and is not blank the Date/Time Matching Adjusted should be timestamped for NOW().</description>
        <formula>ISCHANGED(Adjustment_Type__c) &amp;&amp; NOT ISPICKVAL(Adjustment_Type__c, &apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OMA%3A Update Sales Cycle %2830%29</fullName>
        <actions>
            <name>Sales_Cycle_30_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Matching_Activity__c.Activity_Commission_Eligible__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order_Matching_Activity__c.Order_Commission_Eligible_Total__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>REQ: OMA - FOR: Field Update. - WHY: When the Activity Commission Eligible equates to true and the Order Commission Eligible Total is not null then the Sales Cycle (30) will be updated with specific caluclations detailed in the Field Update.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Write Information From Lead To OMA</fullName>
        <actions>
            <name>Update_Total_Activities_From_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Matching_Activity__c.Activity_Created_By__c</field>
            <operation>notEqual</operation>
            <value>Integration User</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
