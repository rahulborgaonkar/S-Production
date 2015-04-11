trigger CaseCommentBeforeTrigger on CaseComment (before insert, before update) 
{
    system.debug('CaseCommentBeforeTrigger Trigger.new - ' + Trigger.new);
    List<ID> caseid = new List<ID> ();
    if(Trigger.isInsert == true || Trigger.isUpdate == true)
    {
        for(CaseComment cc : Trigger.new)
        {
            caseid.add(cc.parentid);
        }

        if(caseid.size() > 0)
        {
            system.debug('List<ID> caseid - ' + caseid);
            List<String> portalusers = new List<String>();
            for(User u : [SELECT Name FROM User where usertype = 'CSPLitePortal'])
            {
                portalusers.add(u.name);
            }
        
            List<Case> apicase = [SELECT Id, type, owner.name, case_owned_by__c FROM Case where id = :caseid AND (type = 'Development (API Team)' OR owner.name = 'API Team') AND case_owned_by__c = :portalusers];
            if(apicase.size() > 0)
            {
        		for(CaseComment cc : Trigger.new)
        		{
                	system.debug('CaseComment cc Before - ' + cc);
            		cc.isPublished = false;
                	system.debug('CaseComment cc After - ' + cc);
        		}
                //update apicasecommants;
            }
        }
    }
}