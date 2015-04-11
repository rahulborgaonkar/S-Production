trigger CaseCommentAfterTrigger on CaseComment (after insert) 
{
    system.debug('CaseCommentAfterTrigger Trigger.new - ' + Trigger.new);
	List<ID> caseid = new List<ID> ();
	List<ID> casecommentid = new List<ID> ();
	if(Trigger.isInsert == true)
	{
		for(CaseComment cc : Trigger.new)
		{
			caseid.add(cc.parentid);
			casecommentid.add(cc.id);
		}

		if(caseid.size() > 0 && casecommentid.size() > 0)
		{
    		system.debug('List<ID> caseid - ' + caseid);
    		system.debug('List<ID> casecommentid - ' + casecommentid);
			List<String> portalusers = new List<String>();
			for(User u : [SELECT Name FROM User where usertype = 'CSPLitePortal' AND isactive = true])
			{
				portalusers.add(u.name);
			}
    		
			List<CaseComment> apicasecommants = [SELECT Id, Parent.type, Parent.owner.name, parent.case_owned_by__c, IsPublished FROM CaseComment where id = :casecommentid AND parentid = :caseid AND (Parent.type = 'Development (API Team)' OR Parent.owner.name = 'API Team') AND parent.case_owned_by__c = :portalusers];
			if(apicasecommants.size() > 0)
			{
    			system.debug('List<CaseComment> apicasecommants Before - ' + apicasecommants);

				for(CaseComment cc : apicasecommants)
				{
					cc.IsPublished = false;
				}
    			system.debug('List<CaseComment> apicasecommants After - ' + apicasecommants);
				update apicasecommants;
			}
		}
	}
}