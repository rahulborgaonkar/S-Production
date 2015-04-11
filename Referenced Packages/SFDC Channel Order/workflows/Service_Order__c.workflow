<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Date_Order_Received_by_SFDC</fullName>
        <field>Date_Service_Order_Received_by_SFDC__c</field>
        <formula>NOW()</formula>
        <name>Date Order Received by SFDC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Service_Order_Must_be_Draft_Status</fullName>
        <field>Service_Order_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>New Service Order - Must be Draft Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>New Service Order - Must be Draft Status</fullName>
        <actions>
            <name>New_Service_Order_Must_be_Draft_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Order__c.Service_Order_Status__c</field>
            <operation>notEqual</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Order Date Received</fullName>
        <actions>
            <name>Date_Order_Received_by_SFDC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(ischanged( Service_Order_Status__c ), ispickval(Service_Order_Status__c,&quot;Received&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
