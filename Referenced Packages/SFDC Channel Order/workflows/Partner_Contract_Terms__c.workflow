<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Partner_Contract_Term_External_ID</fullName>
        <field>Partner_Contract_Term_External_ID__c</field>
        <formula>Name</formula>
        <name>Partner Contract Term External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Partner Contract Term External ID</fullName>
        <actions>
            <name>Partner_Contract_Term_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Or(Isnew(),Ischanged( Name ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
