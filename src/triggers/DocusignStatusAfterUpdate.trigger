trigger DocusignStatusAfterUpdate on dsfs__DocuSign_Status__c (after update) 
{
/*
    List<Opportunity> lOpps = new List<Opportunity>();
    List<Task> lstOrderTasks = new List<Task>();

    for(dsfs__DocuSign_Status__c ds: Trigger.New)
    {   
        system.debug('Inside for DocusignStatusAfterUpdate');
        if(ds.dsfs__Opportunity__c != null
            && ds.dsfs__Opportunity__r.Order_Docusigned__c == false
            && ds.dsfs__Envelope_Status__c == 'Completed'
            && ds.dsfs__Envelope_Status__c != Trigger.oldMap.get(ds.Id).dsfs__Envelope_Status__c)
            {
                
                Opportunity opp = [select id, Order_Docusigned__c, OwnerId, Order_Number__c
                                    from Opportunity 
                                    where Id=: ds.dsfs__Opportunity__c];
                
                opp.Order_Docusigned__c = true;
                
                Task t = new Task();
                t.WhatId = opp.Id;
                t.OwnerId = opp.OwnerId;
                t.Subject = 'Order form DocuSigned';
                t.Status = 'Completed';
                t.Description = 'DocuSigned order form for order # '+opp.Order_Number__c+' received @ '+datetime.now()+' GMT.';
                t.ActivityDate = datetime.now().date();
                
                lstOrderTasks.add(t);
                
                lOpps.add(opp);
            }
    }

    system.debug('Old Task - ' + lstOrderTasks);
 
    system.debug('Old lOpps - ' + lOpps);

    if(lOpps.size() > 0)
        update lOpps;

    if (lstOrderTasks.size() > 0) 
    {
        //insert lstOrderTasks;
        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.EmailHeader.triggerUserEmail = true;
        database.insert(lstOrderTasks, dmlo);
    }
*/

/* - Changed Trigger */

    List<Opportunity> new_lOpps = new List<Opportunity>();
    List<Task> new_lstOrderTasks = new List<Task>();

    List<ID> docusign_ord = new List<ID> ();

    for(dsfs__DocuSign_Status__c ds: Trigger.New)
    {   
        if(ds.dsfs__Opportunity__c != null && ds.dsfs__Opportunity__r.Order_Docusigned__c == false && ds.dsfs__Envelope_Status__c == 'Completed' && ds.dsfs__Envelope_Status__c != Trigger.oldMap.get(ds.Id).dsfs__Envelope_Status__c)
        {
            docusign_ord.add(ds.dsfs__Opportunity__c);
        }
    }

    system.debug('Opp Docusign Id - ' + docusign_ord);

    List<Opportunity> tmp_opp = new List<Opportunity> ();
    
    if(docusign_ord.size() > 0)
    {
        tmp_opp = [select id, Order_Docusigned__c, OwnerId, Order_Number__c from Opportunity where Id=: docusign_ord];
    }

    if(tmp_opp.size() > 0)
    {
        for( Opportunity topp :  tmp_opp)
        {
            topp.Order_Docusigned__c = true;

            Task t = new Task();
            t.WhatId = topp.Id;
            t.OwnerId = topp.OwnerId;
            t.Subject = 'Order form DocuSigned';
            t.Status = 'Completed';
            t.Description = 'DocuSigned order form for order # '+topp.Order_Number__c+' received @ '+datetime.now()+' GMT.';
            t.ActivityDate = datetime.now().date();

            new_lstOrderTasks.add(t);
                
            new_lOpps.add(topp);
        }
    }

    system.debug('New Task - ' + new_lstOrderTasks);

    system.debug('New lOpps - ' + new_lOpps);

    if(new_lOpps.size() > 0)
        update new_lOpps;

    if (new_lstOrderTasks.size() > 0) 
    {
        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.EmailHeader.triggerUserEmail = true;
        database.insert(new_lstOrderTasks, dmlo);
    }

}