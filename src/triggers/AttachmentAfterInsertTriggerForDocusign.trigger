trigger AttachmentAfterInsertTriggerForDocusign on Attachment (after insert) 
{
	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
	Map<String,String> keyPrefixMap = new Map<String,String>{};
	Set<String> keyPrefixSet = gd.keySet();
	for(String sObj : keyPrefixSet)
	{
	   Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
	   String tempName = r.getName();
	   String tempPrefix = r.getKeyPrefix();
	   System.debug('Processing Object['+tempName + '] with Prefix ['+ tempPrefix+']');
	   keyPrefixMap.put(tempPrefix,tempName);
	}
	
	for(Attachment att: Trigger.New)
	{
		String tPrefix = att.ParentId;
		tPrefix = tPrefix.subString(0,3);
		string objectName = keyPrefixMap.get(tPrefix);
		System.debug('Task Id[' + att.id + '] is associated to Object of Type: ' + keyPrefixMap.get(tPrefix));
		
		if(objectName=='dsfs__DocuSign_Status__c')
		{
			dsfs__DocuSign_Status__c oDS = 
				[select id, dsfs__Opportunity__c 
				from dsfs__DocuSign_Status__c where Id =: att.ParentId];
			if(oDS.dsfs__Opportunity__c != null)
			{
				Attachment newAttach = new Attachment();
				newAttach.Name = att.Name;
				newAttach.Body = att.Body;
				newAttach.ParentId = oDS.dsfs__Opportunity__c;
				
				insert newAttach;
			}	
		}
	}
}