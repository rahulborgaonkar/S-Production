trigger SynetyPluginBeforeTrigger on Synety_Plugin__c (before update) 
{
    List<ID> casechgid = new List<ID> ();

    for(Synety_Plugin__c sp : Trigger.new)
    {
        if(UserInfo.getUserType() == 'CSPLitePortal' && (Trigger.oldMap.get(sp.id).Name != sp.Name || Trigger.oldMap.get(sp.id).Plugin_Version_Number__c != sp.Plugin_Version_Number__c || Trigger.oldMap.get(sp.id).Release_Date__c != sp.Release_Date__c))
        {
            system.debug('User.UserType - ' + UserInfo.getUserType());
            casechgid.add(sp.id);
        }

        //if(sp.QA_Status__c == 'App Approved and Live' && sp.Software_Ready_for_Release__c == 'Yes')
        if(sp.QA_Status__c == 'QA - App QA Passed' && sp.Software_Ready_for_Release__c == 'Yes')
        {
            List<Attachment> attachment = [SELECT Id, Body, BodyLength, ContentType, Description, Name, OwnerId, ParentId, IsPrivate FROM Attachment WHERE ParentId = :sp.id LIMIT 1];
            if(attachment.size() > 0)
            {
                List<String> filename = attachment[0].name.split('\\.');
                Document doc = new Document();
                doc.name = attachment[0].name;
                doc.body = attachment[0].body;
                doc.AuthorId = UserInfo.getUserId();
                doc.folderid = [SELECT AccessType, Id, DeveloperName, Name, NamespacePrefix, Type FROM Folder where Developername = 'PLUGINS_Download'].id;
                doc.Description = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
                doc.Keywords = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
                doc.ContentType = filename[filename.size() - 1];
                try
                {
                    insert doc;
                }
                catch (DMLException e) 
                {
                    trigger.new[0].addError('Uploading Release Software File - ' + doc.name + ' ' + doc.id);
                } 

                //sp.Install_Link__c = 'https://c.na11.content.force.com/servlet/servlet.FileDownload?file=' + doc.id;
				sp.Install_Link__c = 'http://synety.force.com/orders/servlet/servlet.FileDownload?file=' + doc.id;
				sp.Release_Date__c = DateTime.Now();
/*
                try
                {
                    delete attachment;
                }
                catch (DMLException e) 
                {
                    trigger.new[0].addError('Deleting Attachment File - ' + attachment[0].name + ' ' + attachment[0].id);
                } 
*/
            }

			List<Synety_Plugin__c> old_sp = [SELECT CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, Id, QA_Status__c FROM Synety_Plugin__c where crm__c = :sp.crm__c and name = :sp.name and id != :sp.id and qa_status__c = 'App Approved and Live'];
			system.debug('List<Synety_Plugin__c> old_sp - ' + old_sp);
		    if(old_sp.size() > 0)
			{
				for(Synety_Plugin__c s : old_sp)
	            {
		            s.QA_Status__c = 'QA - App Archived';
				}
	        }
		    update old_sp;
        }
        
    }

    system.debug('List<ID> casechgid - ' + casechgid);

    if(casechgid.size() > 0)
    {
        trigger.new[0].addError('You cannot Update Plugin Details from Here');
    }
}