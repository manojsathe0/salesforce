<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Filling_Fee_equals_True</fullName>
        <description>This field updates to True when the relationship type = Filing Fee</description>
        <field>Filling_Fee__c</field>
        <literalValue>1</literalValue>
        <name>Filling Fee equals True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LZ_Product_Id</fullName>
        <field>LZ_Product_ID_Commission__c</field>
        <formula>Product__r.LZ_Product_ID__c</formula>
        <name>Update LZ Product Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Name</fullName>
        <field>Product_Name__c</field>
        <formula>Product__r.Name</formula>
        <name>Update Product Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SBR_Product</fullName>
        <description>Update SBR_Product__c field</description>
        <field>SBR_Product__c</field>
        <literalValue>1</literalValue>
        <name>Update - SBR Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ORDI%3A Update Filing Fee</fullName>
        <actions>
            <name>Filling_Fee_equals_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Item__c.Relationship_Type_Text__c</field>
            <operation>equals</operation>
            <value>Filing Fee</value>
        </criteriaItems>
        <description>REQ: ORDI - FOR: Field Update. - WHY: When the Relationship Type equals Filing Fee check the Filing Fee checkbox.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ORDI%3A Update LZ Product ID</fullName>
        <actions>
            <name>Update_LZ_Product_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Item__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>REQ: ORDI - FOR: Field Update. - WHY: When the Order Item ID is populated the LZ Product ID should populate with the corresponding Product number from the Product.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ORDI%3A Update Product Name</fullName>
        <actions>
            <name>Update_Product_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>REQ: ORDI - FOR: Field Update. - WHY: When the Product Name equates to true then the Product Name should populate with the corresponding Product name from the Product.</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ORDI%3A Update SBR Product</fullName>
        <actions>
            <name>Update_SBR_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Order_Item__c.LZ_Product_ID_Text__c</field>
            <operation>equals</operation>
            <value>1174,1170,1178,1339,1180,1015,1364,1288,2810,2809,2808,2807,2806,2805,597575,2114,1863,1899,1030,1999,1029,1334,2422,2421,2420,2916,2917,2915,2913,2919,2914,3422,3421,3286,3285,3284,3283,3282,3281,2703,2430,2705,2704,2702,2706,2292,2295,2294,3359,3358</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order_Item__c.LZ_Product_ID_Text__c</field>
            <operation>equals</operation>
            <value>,2293,2296,810,3188,815,1366,808,2692,2691,2690,2689,2694,3418,2566,2089,1336,1272,1020,1274,1277,1018,1285,1945,1944,3057,3055,3054,3053,3052,3056,3051,1289,1176,1171,1179,1181,1017,1365,1335,1021,1991,1340,1869,1019,1284,1942,2301,1925,3208,2069,1167</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order_Item__c.LZ_Product_ID_Text__c</field>
            <operation>equals</operation>
            <value>,3795,1286,1163,3616,3615,3612,3613,3614,2789,3629,3628,3627,3626,3623,3625,3624,3796,3798,3795,3799,3801,3800,3797</value>
        </criteriaItems>
        <description>REQ: ORDI - FOR: Field Update. - WHY: When the LZ Product ID equates to specific criteria the SBR Product checkbox should be checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
