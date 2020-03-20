<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Below_60_of_Total_Score</fullName>
        <description>Below 60% of Total Score</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Rep_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Compliance_Review_Templates/Below_60_of_Total_Score</template>
    </alerts>
    <alerts>
        <fullName>Compliance_Review_Disputed_By_Dept_Mgr</fullName>
        <description>Compliance Review Disputed By Dept Mgr</description>
        <protected>false</protected>
        <recipients>
            <recipient>cgallion@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sbyun@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Compliance_Review_Dept_Mgr_Disputed</template>
    </alerts>
    <alerts>
        <fullName>Compliance_Review_Disputed_By_QA_Mgr</fullName>
        <description>Compliance Review Disputed By QA Mgr</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Compliance_Review_Templates/Compliance_Review_QA_Mgr_Disputed</template>
    </alerts>
    <alerts>
        <fullName>Compliance_Review_Sales_Mgr_Approval_Reminder</fullName>
        <description>Compliance Review Sales Mgr Approval Reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>ntepupatum@legalzoom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Sales_Rep_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Compliance_Review_Templates/Compliance_Review_Sales_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Compliant_Coaching_Suggested</fullName>
        <description>Compliant Coaching Suggested</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Rep_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Compliance_Review_Templates/Coaching_Suggested</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Manager_for_Review</fullName>
        <description>Email to Manager for Review</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Rep_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Compliance_Review_Templates/Email_to_Manager_for_Review</template>
    </alerts>
    <fieldUpdates>
        <fullName>Awaiting_Rep_Coaching</fullName>
        <description>Changes the Compliance_Review__c.Status__c field to &quot;Awaiting Rep Coaching&quot;</description>
        <field>Status__c</field>
        <literalValue>Awaiting Rep Coaching</literalValue>
        <name>Awaiting Rep Coaching</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Caculate_Handling_A1_Score</fullName>
        <field>Handling_A1_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A1__c ,&quot;Y(A)&quot;), 12, 
IF(ISPICKVAL(Handling_A1__c ,&quot;Y(P)&quot;), 5, 
IF(ISPICKVAL(Handling_A1__c ,&quot;N&quot;), 0, 0)))</formula>
        <name>Caculate Handling A1 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Caculate_Handling_A2_Possible_Score</fullName>
        <field>Handling_A2_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A2__c , &quot;N/A&quot;) || ISPICKVAL(Handling_A2__c , &quot;&quot;), 0,12)</formula>
        <name>Caculate Handling A2 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Caculate_Handling_A3_Possible_Score</fullName>
        <field>Handling_A3_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A3__c , &quot;N/A&quot;) || ISPICKVAL(Handling_A3__c , &quot;&quot;), 0,10)</formula>
        <name>Caculate Handling A3 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A1_Possible_Score</fullName>
        <field>Handling_A1_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A1__c , &quot;N/A&quot;) || ISPICKVAL(Handling_A1__c , &quot;&quot;), 0,12)</formula>
        <name>Calculate Handling A1 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A2_Score</fullName>
        <field>Handling_A2_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A2__c ,&quot;Y(A)&quot;), 12, 
IF(ISPICKVAL(Handling_A2__c ,&quot;Y(P)&quot;), 5, 
IF(ISPICKVAL(Handling_A2__c ,&quot;N&quot;), 0, 0)))</formula>
        <name>Calculate Handling A2 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A3_Score</fullName>
        <field>Handling_A3_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A3__c ,&quot;Y(A)&quot;), 10, 
IF(ISPICKVAL(Handling_A3__c ,&quot;Y(P)&quot;), 4, 
IF(ISPICKVAL(Handling_A3__c ,&quot;N&quot;), 0, 0)))</formula>
        <name>Calculate Handling A3 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A4_Possible_Score</fullName>
        <field>Handling_A4_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A4__c , &quot;N/A&quot;) || ISPICKVAL(Handling_A4__c , &quot;&quot;), 0,10)</formula>
        <name>Calculate Handling A4 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A4_Score</fullName>
        <field>Handling_A4_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A4__c ,&quot;Y(A)&quot;), 10, 
IF(ISPICKVAL(Handling_A4__c ,&quot;Y(P)&quot;), 4, 
IF(ISPICKVAL(Handling_A4__c ,&quot;N&quot;), 0, 0)))</formula>
        <name>Calculate Handling A4 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A5_Possible_Score</fullName>
        <field>Handling_A5_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A5__c , &quot;N/A&quot;) || ISPICKVAL(Handling_A5__c , &quot;&quot;), 0,6)</formula>
        <name>Calculate Handling A5 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Handling_A5_Score</fullName>
        <field>Handling_A5_Score__c</field>
        <formula>IF(ISPICKVAL(Handling_A5__c ,&quot;Y&quot;), 6, 
IF(ISPICKVAL(Handling_A5__c ,&quot;N&quot;), 0, 0))</formula>
        <name>Calculate Handling A5 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A1</fullName>
        <field>Opening_A1_Score__c</field>
        <formula>IF(ISPICKVAL(Opening_A1__c,&quot;Yes&quot;), 1,0)</formula>
        <name>Calculate Opening A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A1_Possible_Score</fullName>
        <field>Opening_A1_Possible_Score__c</field>
        <formula>IF (ISPICKVAL(Opening_A1__c,&quot;N/A&quot;) || ISPICKVAL(Opening_A1__c,&quot;&quot;) , 0,1)</formula>
        <name>Calculate Opening A1 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A2</fullName>
        <field>Opening_A2_Score__c</field>
        <formula>IF(ISPICKVAL(Opening_A2__c,&quot;Yes&quot;), 1,0)</formula>
        <name>Calculate Opening A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A2_Possible_Score</fullName>
        <field>Opening_A2_Possible_Score__c</field>
        <formula>IF (ISPICKVAL(Opening_A2__c, &quot;N/A&quot;) || ISPICKVAL(Opening_A2__c, &quot;&quot;) , 0,1)</formula>
        <name>Calculate Opening A2 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A4</fullName>
        <field>Opening_A4_Score__c</field>
        <formula>IF(ISPICKVAL(Opening_A4__c,&quot;Yes&quot;), 1,0)</formula>
        <name>Calculate Opening A4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A4_Possible_Score</fullName>
        <field>Opening_A4_Possible_Score__c</field>
        <formula>IF (ISPICKVAL(Opening_A4__c, &quot;N/A&quot;) || ISPICKVAL(Opening_A4__c, &quot;&quot;), 0,1)</formula>
        <name>Calculate Opening A4 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A5</fullName>
        <field>Opening_A5_Score__c</field>
        <formula>IF(ISPICKVAL(Opening_A5__c,&quot;Yes&quot;), 1,0)</formula>
        <name>Calculate Opening A5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A5_Possible_Score</fullName>
        <field>Opening_A5_Possible_Score__c</field>
        <formula>IF (ISPICKVAL(Opening_A5__c, &quot;N/A&quot;) || ISPICKVAL(Opening_A5__c, &quot;&quot;), 0,1)</formula>
        <name>Calculate Opening A5 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Opening_A6_Possible_Score</fullName>
        <field>Opening_A6_Possible_Score__c</field>
        <formula>0</formula>
        <name>Calculate Opening A6 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Compliant</fullName>
        <field>Status__c</field>
        <literalValue>Compliant</literalValue>
        <name>Change Status to Compliant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Disqualified</fullName>
        <field>Disqualified__c</field>
        <literalValue>0</literalValue>
        <name>Clear Disqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A1_Possible_Score</fullName>
        <field>Communication_A1_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Communication_A1__c ,&quot;N/A&quot;) || ISPICKVAL(Communication_A1__c ,&quot;&quot;), 0,15)</formula>
        <name>Communication A1 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A1_Score</fullName>
        <field>Communication_A1_Score__c</field>
        <formula>CASE(TEXT(Communication_A1__c), &quot;N&quot;, 0 , &quot;Y(P)&quot;,0.46 * Communication_A1_Possible_Score__c ,&quot;Y(A)&quot;, 1 * Communication_A1_Possible_Score__c,0)</formula>
        <name>Communication A1 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A2_Possible_Score</fullName>
        <field>Communication_A2_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Communication_A2__c ,&quot;N/A&quot;) || ISPICKVAL(Communication_A2__c ,&quot;&quot;), 0,15)</formula>
        <name>Communication A2 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A2_Score</fullName>
        <field>Communication_A2_Score__c</field>
        <formula>CASE(TEXT(Communication_A2__c), &quot;N&quot;, 0 , &quot;Y(P)&quot;, 0.46 * Communication_A2_Possible_Score__c ,&quot;Y(A)&quot;, 1 * Communication_A2_Possible_Score__c,0)</formula>
        <name>Communication A2 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A3_Possible_Score</fullName>
        <field>Communication_A3_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Communication_A3__c ,&quot;N/A&quot;) || ISPICKVAL(Communication_A3__c ,&quot;&quot;), 0,8)</formula>
        <name>Communication A3 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A3_Score</fullName>
        <field>Communication_A3_Score__c</field>
        <formula>CASE(TEXT(Communication_A3__c), &quot;N&quot;, 0 , &quot;Y&quot;, 1 * Communication_A3_Possible_Score__c,0)</formula>
        <name>Communication A3 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A4_Possible_Score</fullName>
        <field>Communication_A4_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Communication_A4__c,&quot;N/A&quot;) || ISPICKVAL(Communication_A4__c,&quot;&quot;), 0,8)</formula>
        <name>Communication A4 Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_A4_Score</fullName>
        <field>Communication_A4_Score__c</field>
        <formula>CASE(TEXT(Communication_A4__c), &quot;N&quot;, 0 , &quot;Y&quot;, 1 * Communication_A4_Possible_Score__c,0)</formula>
        <name>Communication A4 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compliance_Review_QA_Mgr_Disputed</fullName>
        <field>Status__c</field>
        <literalValue>QA Mgr Disputed</literalValue>
        <name>Compliance Review QA Mgr Disputed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Need_To_Submit_For_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Need to Submit for Approval</literalValue>
        <name>Need To Submit For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QA_Disputed</fullName>
        <field>QA_Disputed__c</field>
        <literalValue>1</literalValue>
        <name>QA Disputed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QA_Mgr_Approval_Needed</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting QA Mgr Approval</literalValue>
        <name>QA Mgr Approval Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rep_Coaching_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Rep Coaching Completed</literalValue>
        <name>Rep Coaching Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rep_Coaching_Requested</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting Rep Coaching</literalValue>
        <name>Rep Coaching Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Approval_Needed</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting Sales Approval</literalValue>
        <name>Sales Approval Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Disputed</fullName>
        <field>Sales_Disputed__c</field>
        <literalValue>1</literalValue>
        <name>Sales Disputed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CallHandling_Score_Convert_A1</fullName>
        <field>CallHandling_Score_Convert_A1__c</field>
        <formula>CASE(TEXT(CallHandling_A1__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set CallHandling Score Convert A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CallHandling_Score_Convert_A2</fullName>
        <field>CallHandling_Score_Convert_A2__c</field>
        <formula>CASE(TEXT(CallHandling_A2__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set CallHandling Score Convert A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Callhandling_Cal_Possible_A1</fullName>
        <field>CallHandling_Cal_Possible_A1__c</field>
        <formula>IF( TEXT(CallHandling_A1__c) = &quot;N/A&quot;,0,CallHandling_Possible_Score_A1__c)</formula>
        <name>Set Callhandling Cal Possible A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Callhandling_Cal_Possible_A2</fullName>
        <field>CallHandling_Cal_Possible_A2__c</field>
        <formula>IF( TEXT(CallHandling_A2__c) = &quot;N/A&quot;,0, CallHandling_Possible_Score_A2__c )</formula>
        <name>Set Callhandling Cal Possible A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Corrective_Discount_1st_Written</fullName>
        <field>Corrective_Plan_Discounts__c</field>
        <literalValue>1st Written</literalValue>
        <name>Set Corrective Discount 1st Written</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Corrective_Plan_Start_Date</fullName>
        <field>Corrective_Plan_Start_Date__c</field>
        <formula>Now()</formula>
        <name>Set Corrective Plan Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Corrective_Service_Coaching</fullName>
        <field>Corrective_Plan_Service__c</field>
        <literalValue>Coaching</literalValue>
        <name>Set Corrective Service Coaching</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Corrective_Service_Verbal</fullName>
        <field>Corrective_Plan_Service__c</field>
        <literalValue>Verbal</literalValue>
        <name>Set Corrective Service Verbal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Disqualified</fullName>
        <field>Disqualified__c</field>
        <literalValue>1</literalValue>
        <name>Set Disqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Greeting_Cal_Possible_A1</fullName>
        <field>Greeting_Cal_Possible_A1__c</field>
        <formula>Greeting_Possible_Score_A1__c</formula>
        <name>Set Greeting Cal Possible A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Greeting_Score_Convert_A1</fullName>
        <field>Greeting_Score_Convert_A1__c</field>
        <formula>CASE(TEXT(Greeting_A1__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set Greeting Score Convert A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NeedAnalysis_Cal_Possible_A1</fullName>
        <field>NeedAnalysis_Cal_Possible_A1__c</field>
        <formula>NeedAnalysis_Possible_Score_A1__c</formula>
        <name>Set NeedAnalysis Cal Possible A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NeedAnalysis_Cal_Possible_A2</fullName>
        <field>NeedAnalysis_Cal_Possible_A2__c</field>
        <formula>IF(  TEXT(Need_Analysis_A2__c) = &quot;N/A&quot;,0,NeedAnalysis_Possible_Score_A2__c)</formula>
        <name>Set NeedAnalysis Cal Possible A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NeedAnalysis_Score_Convert_A1</fullName>
        <field>NeedAnalysis_Score_Convert_A1__c</field>
        <formula>CASE(TEXT(Need_Analysis_A1__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set NeedAnalysis Score Convert A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NeedAnalysis_Score_Convert_A2</fullName>
        <field>NeedAnalysis_Score_Convert_A2__c</field>
        <formula>CASE(TEXT( Need_Analysis_A2__c ), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set NeedAnalysis Score Convert A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PPK_Cal_Possible_A1</fullName>
        <field>PPK_Cal_Possible_A1__c</field>
        <formula>IF( TEXT(PPK_A1__c) = &quot;N/A&quot;,0,PPK_Possible_Score_A1__c)</formula>
        <name>Set PPK Cal Possible A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PPK_Cal_Possible_A2</fullName>
        <field>PPK_Cal_Possible_A2__c</field>
        <formula>IF( TEXT( PPK_A2__c ) = &quot;N/A&quot;,0, PPK_Possible_Score_A2__c )</formula>
        <name>Set PPK Cal Possible A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PPK_Cal_Possible_A3</fullName>
        <field>PPK_Cal_Possible_A3__c</field>
        <formula>IF( TEXT( PPK_A3__c ) = &quot;N/A&quot;,0, PPK_Possible_Score_A3__c )</formula>
        <name>Set PPK Cal Possible A3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PPK_Score_Convert_A1</fullName>
        <field>PPK_Score_Convert_A1__c</field>
        <formula>CASE(TEXT( PPK_A1__c ), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set PPK Score Convert A1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PPK_Score_Convert_A2</fullName>
        <field>PPK_Score_Convert_A2__c</field>
        <formula>CASE(TEXT(PPK_A2__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.3, 
&quot;Good&quot;, 0.65, 
&quot;Excellent&quot;, 1, 
0)</formula>
        <name>Set PPK Score Convert A2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PPK_Score_Convert_A3</fullName>
        <field>PPK_Score_Convert_A3__c</field>
        <formula>CASE(TEXT(PPK_A3__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.5, 
&quot;Good&quot;, 1,
0)</formula>
        <name>Set PPK Score Convert A3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sales_Coaching_Reject</fullName>
        <field>Sales_Reject_Coaching__c</field>
        <literalValue>1</literalValue>
        <name>Set Sales Coaching Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sales_Coaching_Reject_Status</fullName>
        <field>Status__c</field>
        <literalValue>Rep Coaching Rejection</literalValue>
        <name>Set Sales Coaching Reject Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Violation_Cal_Possible_A5</fullName>
        <field>Violation_Cal_Possible_A5__c</field>
        <formula>IF( TEXT( Violation_A5__c ) = &quot;N/A&quot;,0, Violation_Possible_Score_A5__c )</formula>
        <name>Set Violation Cal Possible A5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Violation_Cal_Possible_A6</fullName>
        <field>Violation_Cal_Possible_A6__c</field>
        <formula>IF( TEXT(Violation_A6__c) = &quot;N/A&quot;,0,  Violation_Possible_Score_A6__c)</formula>
        <name>Set Violation Cal Possible A6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Violation_Cal_Possible_A7</fullName>
        <field>Violation_Cal_Possible_A7__c</field>
        <formula>IF( TEXT(Violation_A7__c) = &quot;N/A&quot;,0, Violation_Possible_Score_A7__c)</formula>
        <name>Set Violation Cal Possible A7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Violation_Score_Convert_A5</fullName>
        <field>Violation_Score_Convert_A5__c</field>
        <formula>CASE(TEXT(Violation_A5__c), 
&quot;Poor&quot;, 0, 
&quot;Weak&quot;, 0.5, 
&quot;Good&quot;, 1,
0)</formula>
        <name>Set Violation Score Convert A5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Violation_Score_Convert_A6</fullName>
        <field>Violation_Score_Convert_A6__c</field>
        <formula>CASE(TEXT(Violation_A6__c), 
&quot;Yes&quot;, 0, 
&quot;No&quot;, 1, 
0)</formula>
        <name>Set Violation Score Convert A6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Violation_Score_Convert_A7</fullName>
        <field>Violation_Score_Convert_A7__c</field>
        <formula>CASE(TEXT(Violation_A7__c), 
&quot;Yes&quot;, 0, 
&quot;No&quot;, 1, 
0)</formula>
        <name>Set Violation Score Convert A7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Need_to_submit_for_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Need to Submit for Approval</literalValue>
        <name>Status Need to submit for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Sales_Manager_Disputed</fullName>
        <field>Status__c</field>
        <literalValue>Sales Mgr Disputed</literalValue>
        <name>Status Sales Manager Disputed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ALC_Possible_Score_Field</fullName>
        <field>ALC_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(ALC_Were_all_customer_concerns_addressed__c,&quot;N/A&quot;) || ISPICKVAL(ALC_Were_all_customer_concerns_addressed__c,&quot;&quot;), 0, 8) +

IF(ISPICKVAL( ALC_Was_information_provided_complete__c ,&quot;N/A&quot;) || ISPICKVAL(ALC_Was_information_provided_complete__c,&quot;&quot;), 0, 7) +

IF(ISPICKVAL(ALC_Did_rep_understand_how_LZ__c, &quot;N/A&quot;) || ISPICKVAL(ALC_Did_rep_understand_how_LZ__c,&quot;&quot;), 0, 7) + 

IF(ISPICKVAL(ALC_Validate_customers_understanding__c,&quot;N/A&quot;)||
ISPICKVAL(ALC_Validate_customers_understanding__c,&quot;&quot;), 0, 5)+

IF(ISPICKVAL(ALC_Was_information_provided_accurate__c, &quot;N/A&quot;)||
ISPICKVAL(ALC_Was_information_provided_accurate__c, &quot;&quot;), 0, 13)</formula>
        <name>Update ALC Possible Score Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AVB_Total_possible_score</fullName>
        <description>Added Value Behaviors total possible score update</description>
        <field>Added_value_total_Possible_Points__c</field>
        <formula>IF(ISPICKVAL(Explain_how_LZ_can_assist__c,&quot;N/A&quot;) || ISPICKVAL(Explain_how_LZ_can_assist__c,&quot;&quot;), 0, 6) + 

IF(ISPICKVAL(Obtain_highest_level_of_commitment__c,&quot;N/A&quot;)|| ISPICKVAL(Obtain_highest_level_of_commitment__c,&quot;&quot;), 0, 6)+

IF(ISPICKVAL(Present_appropriate_and_accurate_SBRs__c, &quot;N/A&quot;)|| ISPICKVAL(Present_appropriate_and_accurate_SBRs__c, &quot;&quot;), 0, 5) +

IF(ISPICKVAL(Asked_sales_related_questions__c, &quot;N/A&quot;)|| ISPICKVAL(Asked_sales_related_questions__c, &quot;&quot;), 0, 6) +

IF(ISPICKVAL(Presented_Products_Services__c, &quot;N/A&quot;)|| ISPICKVAL(Presented_Products_Services__c, &quot;&quot;), 0, 6) +

IF(ISPICKVAL(Upsell_Products_Services__c, &quot;N/A&quot;)|| ISPICKVAL(Upsell_Products_Services__c, &quot;&quot;), 0, 6) +

IF(ISPICKVAL(My_Account_Assistance__c, &quot;N/A&quot;)|| ISPICKVAL(My_Account_Assistance__c, &quot;&quot;), 0, 5)</formula>
        <name>Update AVB Total possible score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Awaiting_Sales_Approval_Date</fullName>
        <field>Awaiting_Sales_Approval_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Awaiting Sales Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CH_Total_Possible_Score</fullName>
        <description>Call Handling Total Possible Score Update</description>
        <field>Sales_Call_Handling_Total_Possible_Score__c</field>
        <formula>IF(ISPICKVAL(Sales_Acknowledge_Customer__c,&quot;N/A&quot;) || ISPICKVAL(Sales_Acknowledge_Customer__c,&quot;&quot;), 0, 2) + 

IF(ISPICKVAL(Sales_Expressed_empathy_concern__c, &quot;N/A&quot;) || ISPICKVAL(Sales_Expressed_empathy_concern__c,&quot;&quot;), 0, 2) + 

IF(ISPICKVAL(Sales_Engaged_in_Conversation__c,&quot;N/A&quot;)|| ISPICKVAL(Sales_Engaged_in_Conversation__c,&quot;&quot;), 0, 2)+ 

IF(ISPICKVAL(Sales_Proper_phone_etiquette__c, &quot;N/A&quot;)|| ISPICKVAL(Sales_Proper_phone_etiquette__c, &quot;&quot;), 0, 2) + 

IF(ISPICKVAL(Courteous_and_professional_tone__c, &quot;N/A&quot;)|| ISPICKVAL(Courteous_and_professional_tone__c, &quot;&quot;), 0, 2)</formula>
        <name>Update CH Total Possible Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Interaction_Total_Possible_Points</fullName>
        <field>Interaction_Total_Possible_Points__c</field>
        <formula>IF(ISPICKVAL(Interaction_A1__c,&quot;N/A&quot;) || ISPICKVAL(Interaction_A1__c,&quot;&quot;), 0, 2) +
IF(ISPICKVAL(Interaction_A2__c,&quot;N/A&quot;) || ISPICKVAL(Interaction_A2__c,&quot;&quot;), 0, 2) +
IF(ISPICKVAL(Interaction_A3__c,&quot;N/A&quot;) || ISPICKVAL(Interaction_A3__c,&quot;&quot;), 0, 2) +
IF(ISPICKVAL(Interaction_A4__c,&quot;N/A&quot;) || ISPICKVAL(Interaction_A4__c,&quot;&quot;), 0, 2) +
IF(ISPICKVAL(Interaction_A5__c,&quot;N/A&quot;) || ISPICKVAL(Interaction_A5__c,&quot;&quot;), 0, 2)</formula>
        <name>Update Interaction Total Possible Points</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Score_CH</fullName>
        <description>Update Total Score for Call Hadnling</description>
        <field>Sales_Call_Handling_Score__c</field>
        <formula>IF(ISPICKVAL(Sales_Acknowledge_Customer__c,&quot;Yes&quot;) , 2,0) + 
IF(ISPICKVAL(Sales_Engaged_in_Conversation__c,&quot;Yes&quot;), 2,0)+
IF(ISPICKVAL(Sales_Expressed_empathy_concern__c, &quot;Yes&quot;) , 2,0) + 

IF(ISPICKVAL(Sales_Proper_phone_etiquette__c,&quot;Yes&quot;), 2,0) + 

IF(ISPICKVAL(Sales_LZ_terminology_acronyms__c,&quot;Yes&quot;), -3,0) +
IF(ISPICKVAL(Courteous_and_professional_tone__c,&quot;Yes&quot;), 2,0)</formula>
        <name>Update Total Score CH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Score_for_AVB</fullName>
        <description>Added Value Behaviors total score update</description>
        <field>Score_Added_Value_Behaviors__c</field>
        <formula>IF(ISPICKVAL(Explain_how_LZ_can_assist__c,&quot;Yes&quot;) , 6,0) +

IF(ISPICKVAL(Obtain_highest_level_of_commitment__c,&quot;Yes&quot;), 6,0) +

IF(ISPICKVAL(Present_appropriate_and_accurate_SBRs__c, &quot;Yes&quot;), 5,0) +

IF(ISPICKVAL(Asked_sales_related_questions__c, &quot;Yes&quot;), 6,0) +

IF(ISPICKVAL(Presented_Products_Services__c, &quot;Yes&quot;), 6,0) +

IF(ISPICKVAL(Upsell_Products_Services__c, &quot;Yes&quot;), 6,0) +

IF(ISPICKVAL(My_Account_Assistance__c, &quot;Yes&quot;), 5,0)</formula>
        <name>Update Total Score for AVB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Violation_Comment_Summary</fullName>
        <field>Violation_Comments_Summary__c</field>
        <formula>IF(ISPICKVAL(Violation_A1__c, &quot;Disqualified&quot;), &quot;UPL:&quot; &amp;  Violation_A1_Comments__c &amp; BR(),&quot;&quot;) &amp;
IF(ISPICKVAL(Violation_A2__c, &quot;Disqualified&quot;), &quot;Business Practice:&quot; &amp;  Violation_A2_Comments__c &amp; BR(),&quot;&quot;) &amp;
IF(ISPICKVAL(Violation_A3__c, &quot;No&quot;), &quot;Disclaimer:&quot; &amp;  Violation_A3_Comments__c &amp; BR(),&quot;&quot;) &amp;
IF(ISPICKVAL(Violation_A4__c, &quot;Yes&quot;), &quot;Discount:&quot; &amp;  Violation_A4_Comments__c &amp; BR(),&quot;&quot;) &amp;
IF(ISPICKVAL(Violation_A5__c, &quot;Poor&quot;), &quot;Security:&quot; &amp;  Violation_A5_Comments__c &amp; BR(),&quot;&quot;) &amp;
IF(ISPICKVAL(Violation_A6__c, &quot;Yes&quot;), &quot;Service:&quot; &amp;  Violation_A6_Comments__c &amp; BR(),&quot;&quot;) &amp;
IF(ISPICKVAL(Violation_A7__c, &quot;Yes&quot;), &quot;Taxation:&quot; &amp;  Violation_A7_Comments__c &amp; BR(),&quot;&quot;)</formula>
        <name>Update Violation Comment Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Below 60%25 of Total Score Notification</fullName>
        <actions>
            <name>Below_60_of_Total_Score</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Compliant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.Call_Quality_Score_Percentage__c</field>
            <operation>lessThan</operation>
            <value>60</value>
        </criteriaItems>
        <description>Send an email alert if the total score is below 60% for Sales ScoreCard</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CCS Calculating Score</fullName>
        <actions>
            <name>Calculate_Opening_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A1_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A2_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A4_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCS ScoredBased,CCS Training</value>
        </criteriaItems>
        <description>Populate all scores for CCS</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CCS Calculating Score2</fullName>
        <actions>
            <name>Calculate_Opening_A5_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Opening_A6_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A1_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A1_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A2_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A2_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A3_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A3_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A4_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Communication_A4_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCS ScoredBased,CCS Training</value>
        </criteriaItems>
        <description>Populate all scores for CCS</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CCS Calculating Score3</fullName>
        <actions>
            <name>Caculate_Handling_A1_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Caculate_Handling_A2_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Caculate_Handling_A3_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A1_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A2_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A3_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A4_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A4_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A5_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Handling_A5_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCS ScoredBased,CCS Training</value>
        </criteriaItems>
        <description>Populate all scores for CCS</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Disqualified</fullName>
        <actions>
            <name>Clear_Disqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Unethical_Business_Practice_Violation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.UPL_Violation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Clear violation if it is deselected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Compliance Calculation1</fullName>
        <actions>
            <name>Set_Greeting_Cal_Possible_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Greeting_Score_Convert_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_NeedAnalysis_Cal_Possible_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_NeedAnalysis_Cal_Possible_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_NeedAnalysis_Score_Convert_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_NeedAnalysis_Score_Convert_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PPK_Cal_Possible_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PPK_Cal_Possible_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PPK_Cal_Possible_A3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PPK_Score_Convert_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Skip,ScoredBased,Training</value>
        </criteriaItems>
        <description>Populate all scores for Sales</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Compliance Calculation2</fullName>
        <actions>
            <name>Set_CallHandling_Score_Convert_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_CallHandling_Score_Convert_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Callhandling_Cal_Possible_A1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Callhandling_Cal_Possible_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PPK_Score_Convert_A2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PPK_Score_Convert_A3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Violation_Cal_Possible_A5</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Violation_Cal_Possible_A6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Violation_Cal_Possible_A7</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Violation_Score_Convert_A5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Skip,ScoredBased,Training</value>
        </criteriaItems>
        <description>Populate all scores for Sales</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Compliance Calculation3</fullName>
        <actions>
            <name>Set_Violation_Score_Convert_A6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Violation_Score_Convert_A7</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_ALC_Possible_Score_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_AVB_Total_possible_score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CH_Total_Possible_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Interaction_Total_Possible_Points</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Total_Score_CH</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Total_Score_for_AVB</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Violation_Comment_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Skip,ScoredBased,Training</value>
        </criteriaItems>
        <description>Populate all scores for Sales</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Compliance Review Awaiting Sales Mgr Approval</fullName>
        <actions>
            <name>Compliance_Review_Sales_Mgr_Approval_Reminder</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send an email alert if the violation has not been coached within 3 days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Compliance Review Has Violations</fullName>
        <actions>
            <name>Need_To_Submit_For_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update compliance status in case there is a violation</description>
        <formula>((TEXT(Violation_A1__c) = &quot;Disqualified&quot; || TEXT(Violation_A2__c) = &quot;Disqualified&quot; || TEXT(Violation_A3__c) = &quot;No (1st Contact)&quot; || TEXT(Violation_A3__c) = &quot;No (2nd Contact)&quot;|| TEXT(Violation_A4__c) = &quot;Yes&quot; || TEXT(Violation_A5__c) = &quot;No&quot; || TEXT( Violation_A6__c ) = &quot;Yes&quot; || TEXT( Violation_A7__c ) = &quot;Yes&quot; || TEXT( Violation_A8__c ) = &quot;No&quot;) &amp;&amp; (TEXT(Status__c) = &quot;Draft&quot; || TEXT(Status__c) = &quot;Compliant&quot; || TEXT(Status__c) = &quot;Need to Submit for Approval&quot;)) || ((TEXT(CCS_UPL_Violation__c) = &quot;Disqualified&quot; || TEXT( CCS_Disclaimer_Violation__c) = &quot;No (1st Contact)&quot; || TEXT( CCS_Disclaimer_Violation__c) = &quot;No (2nd Contact)&quot;|| TEXT( CCS_Security_Violation__c) = &quot;No&quot; || TEXT(CCS_Tax_Violation__c) = &quot;Yes&quot;) &amp;&amp; (TEXT(Status__c) = &quot;Draft&quot; || TEXT(Status__c) = &quot;Compliant&quot; || TEXT(Status__c) = &quot;Need to Submit for Approval&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Compliance Review No Violations</fullName>
        <actions>
            <name>Change_Status_to_Compliant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update compliance status in case there is no violation</description>
        <formula>(TEXT(Violation_A1__c) &lt;&gt; &quot;Disqualified&quot; &amp;&amp; TEXT(Violation_A2__c) &lt;&gt; &quot;Disqualified&quot; &amp;&amp;  TEXT(Violation_A3__c) &lt;&gt; &quot;No (1st Contact)&quot; &amp;&amp;  TEXT(Violation_A3__c) &lt;&gt; &quot;No (2nd Contact)&quot; &amp;&amp; TEXT(Violation_A5__c) &lt;&gt; &quot;No&quot; &amp;&amp; TEXT( Violation_A7__c ) &lt;&gt; &quot;Yes&quot; &amp;&amp; TEXT( Violation_A8__c ) &lt;&gt; &quot;No&quot; &amp;&amp; NOT(ISNEW()) &amp;&amp; NOT(ISChanged( Recorded_Call_ID__c)) &amp;&amp; (TEXT(Status__c) = &quot;Draft&quot; || TEXT(Status__c) = &quot;Compliant&quot; || TEXT(Status__c) = &quot;Need to Submit for Approval&quot;) &amp;&amp; ( RecordType.DeveloperName = &quot;ScoredBased&quot; || RecordType.DeveloperName = &quot;Training&quot; ))  || (TEXT(CCS_UPL_Violation__c) &lt;&gt; &quot;Disqualified&quot; &amp;&amp; TEXT( CCS_Disclaimer_Violation__c) &lt;&gt; &quot;No (1st Contact)&quot; &amp;&amp; TEXT( CCS_Disclaimer_Violation__c) &lt;&gt; &quot;No (2nd Contact)&quot; &amp;&amp; TEXT( CCS_Security_Violation__c) &lt;&gt; &quot;No&quot; &amp;&amp;  TEXT(CCS_Tax_Violation__c) &lt;&gt; &quot;Yes&quot; &amp;&amp; NOT(ISNEW()) &amp;&amp; NOT(ISChanged( Recorded_Call_ID__c)) &amp;&amp; (TEXT(Status__c) = &quot;Draft&quot; || TEXT(Status__c) = &quot;Compliant&quot; || TEXT(Status__c) = &quot;Need to Submit for Approval&quot;) &amp;&amp; ( RecordType.DeveloperName = &quot;CCS_ScoredBased&quot; || RecordType.DeveloperName = &quot;CCS_Training&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Discount Corrective Plan 1st Written Warning</fullName>
        <actions>
            <name>Set_Corrective_Discount_1st_Written</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update corrective plan for discount violation</description>
        <formula>(Corrective_Plan_Discount_Text__c   = &quot;1st Written&quot;) &amp;&amp; CP_Written_Warning_Number_Formula__c +  LCP_Written_Warning_Number__c   &lt;  3</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to Manager for Review</fullName>
        <actions>
            <name>Email_to_Manager_for_Review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Manager_Alert__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Email to Manager for Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QA Mgr Approve After Sales Dispute</fullName>
        <actions>
            <name>Rep_Coaching_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Compliance_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Sales Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.Sales_Disputed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule fires when the QA Mgr approves a Compliance Review after a Sales Mgr dispute.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Corrective Plan Coaching</fullName>
        <actions>
            <name>Set_Corrective_Service_Coaching</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update corrective plan for service violation</description>
        <formula>Corrective_Plan_Service_Text__c = &quot;Coaching&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Corrective Plan Verbal</fullName>
        <actions>
            <name>Set_Corrective_Service_Verbal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update corrective plan for service violation</description>
        <formula>Corrective_Plan_Service_Text__c = &quot;Verbal&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Disqualified</fullName>
        <actions>
            <name>Set_Disqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Compliance_Review__c.Unethical_Business_Practice_Violation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Compliance_Review__c.UPL_Violation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update &quot;Disqualified&quot; checkbox for Xactly integration</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
