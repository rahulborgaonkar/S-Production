trigger CaseBeforeUpdate on Case (before update) 
{
    for(Case c: trigger.new)
    {
        if(Trigger.oldMap.get(c.id).Status != c.Status 
            && c.Status == 'Closed')
        {
            if(c.ContactId != null)
            {
                List<Case> contactCases = [select id from Case 
                                            where ContactId =: c.ContactId
                                            and ClosedDate = This_Month];
                if(contactCases.size() < 2)
                {
                    c.Trigger_Rating_Feedback_Request__c = true;
                }
            }
        }
    }

    List<Case> failedcases = new List<Case> ();
    List<Case> livecases = new List<Case> ();
    List<Case> inprocesscases = new List<Case> ();    
    List<ID> casefailid = new List<ID> ();
    List<ID> caseliveid = new List<ID> ();
    List<ID> caseprocessid = new List<ID> ();
    
    for(Case c: trigger.new)
    {
        if(c.status == 'QA - In Process' && Trigger.oldMap.get(c.id).status != c.status)
        {
            caseprocessid.add(c.id);
            inprocesscases.add(c);
        }
        if(c.status == 'QA - App QA Failed' && Trigger.oldMap.get(c.id).status != c.status)
        {
            casefailid.add(c.id);
            failedcases.add(c);
        }
        if(c.status == 'App Approved and Live' && Trigger.oldMap.get(c.id).status != c.status)
        {
            caseliveid.add(c.id);
            livecases.add(c);
        }

    }
    system.debug('List<Case> failedcases - ' + failedcases);

	Group qaqueue = [SELECT Id, Name, Type FROM Group where type = 'Queue' and name = 'QA Queue' LIMIT 1];
    system.debug('Group qaqueue - ' + qaqueue);

    if(caseprocessid.size() > 0)
    {
        for(Case c : inprocesscases)
        {
			if(c.ownerid == qaqueue.id)
			{
            	c.ownerid = UserInfo.getuserid();
			}
        }
    }
    if(casefailid.size() > 0)
    {
        List<Synety_Plugin__c> sp = [SELECT QA_Status__c, Software_Ready_for_Release__c FROM Synety_Plugin__c where QA_Ticket_Reference__c = :casefailid order by Release_Date__c desc LIMIT 1];
        system.debug('List<Synety_Plugin__c> sp - ' + sp);
		for(Case c : failedcases)
		{
			if(sp.size() > 0)
			{
            	c.SynetyPlugin__c = sp[0].id;
            }
            List<Attachment> att = [SELECT id FROM attachment WHERE parentid = :c.id ORDER BY createddate DESC LIMIT 1];
            system.debug('List<Attachment> att - ' + att);
            c.Test_Document_Download_Link__c = 'https://c.na11.content.force.com/servlet/servlet.FileDownload?file=' + att[0].id;
        }
    }
    if(caseliveid.size() > 0)
    {
        List<Synety_Plugin__c> sp = [SELECT QA_Status__c, Software_Ready_for_Release__c FROM Synety_Plugin__c where QA_Ticket_Reference__c = :caseliveid order by Release_Date__c desc LIMIT 1];
        system.debug('List<Synety_Plugin__c> sp - ' + sp);
        for(Case c : livecases)
        {
            if(sp.size() > 0)
            {
            	c.SynetyPlugin__c = sp[0].id;
            }
        }
    }

}