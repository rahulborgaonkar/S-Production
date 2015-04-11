public class SynetyPluginController
{
    // Constructor - this only really matters if the autoRun function doesn't work right
    public String SynetyPluginTab = '/a0y/o';
    public String fileLink = 'https://c.na11.content.force.com/servlet/servlet.FileDownload?file=';
    public Synety_Plugin__c sp {get; set;}
    private final ApexPages.StandardController theController;
    public List<Contact> cnct_l {get; set;}
    public Set<String> cncts {get;set;}

    public String selectedPlugin {get;set;}
    public String selectedCRM {get;set;}
    public String qastatus {get;set;}
    public String licenseKey {get;set;}
    public String pluginVersion {get;set;}
    public String pluginVersionNumber {get;set;}
    public String prevPluginVersionNumber {get;set;}
    public DateTime releaseDate {get;set;}
    public String newFeatures {get;set;}
    public String bugFixes {get;set;}
    public String installInstruction {get;set;}
    public String installLink {get;set;}
    public String releaseNotes {get;set;}
    public String releaseOption {get;set;}
    public String releaseFileName {get;set;}
    public String supportedProductVersion {get;set;}
    public String supportedBrowserVersion {get;set;}
    
    public Boolean isFile {get;set;}
    public Boolean isLink {get;set;}
    public Boolean isCRM {get;set;}
    public Boolean isSave {get;set;}
    public String current_user { get;set;}
    public Date stDate { get;set;}
    public Date enDate { get;set;}
    
//    public Document software {get;set;}
//    public List<Document> software_exists {get;set;}
    public Attachment attachment {get;set;}
    public Attachment additional_notes {get;set;}
    public Case qacase {get;set;}

    public Synety_Plugin__c tmp_plugin {get; set;}
    public List<Synety_Plugin__c> all_plugins {get; set;}
    public List<Synety_Plugin__c> qa_process_plugins {get; set;}
    public List<User> all_users {get; set;}
    public List<ID> selected_users_id {get; set;}
    public List<ID> selected_qa_users_id {get; set;}
    public Boolean isSF {get; set;}
                
    public class PluginSummary
    {
        public Id PluginId {get;set;}
        public string PluginName {get;set;}
        public string PluginVersion {get;set;}
        public string PluginVersionNumber {get;set;}
        public DateTime LastModifiedDate {get;set;}
        public Integer submission {get;set;}
        public Integer passed {get;set;}
        public Integer failed {get;set;}
        public Integer firstTimePassedPluginCount {get;set;}
        public Double averageFailure {get;set;}
        public Id CaseId {get;set;}
        
        public PluginSummary(Id PluginId, String PluginName, String PluginVersion, String PluginVersionNumber, DateTime LastModifiedDate, Integer submission, Integer passed, Integer failed, Integer firstTimePassedPluginCount, Double averageFailure, Id CaseId)
        {
            system.debug('In Plugin Summary Constructor');

            this.PluginId = PluginId;
            this.PluginName = PluginName;
            this.PluginVersion = PluginVersion;
            this.PluginVersionNumber = PluginVersionNumber;
            this.LastModifiedDate = LastModifiedDate;
            this.submission = submission;
            this.passed = passed;
            this.failed = failed;
            this.firstTimePassedPluginCount = firstTimePassedPluginCount;
            this.averageFailure = averageFailure;
            this.CaseId = CaseId;
        }
    }

    public List<PluginSummary> getPluginSummary()
    {
        system.debug('Inside getPluginSummary');
        Date tdt1, tdt2;
        List<Synety_Plugin__c> plugins = new List<Synety_Plugin__c>();
        Set<String> plugin_names = new Set<String>();
        List<PluginSummary> pluginSummary = new List<PluginSummary>();
        
        tdt1 = tmp_plugin.stDate__c;
        tdt2 = tmp_plugin.enDate__c;
        system.debug('tdt1 - ' + tdt1);
        system.debug('tdt2 - ' + tdt2);

        system.debug('current_user - ' + current_user);
        //SELECT Name, IsActive, profile.name, usertype, userrole.name FROM User where (profile.name = 'Customer Community User Developer' or userrole.name = 'QA Engineer') and isactive = true        
        selected_users_id.clear();
        selected_qa_users_id.clear();
        if(current_user == 'QA')
        {
            for(User q : all_users)
            {
                if(q.userrole.name == 'QA Engineer')
                {
                    selected_qa_users_id.add(q.id);
                }
            }
        }
        else if(current_user == 'DEV')
        {
            for(User q : all_users)
            {
                if(q.profile.name == 'High Volume Customer Portal User - Clone' || q.profile.name == 'Customer Community User Developer')
                {
                    selected_users_id.add(q.id);
                }
            }
        }
        else if(current_user != 'ALL')
        {
            for(User q : all_users)
            {
                if(q.id == current_user && (q.profile.name == 'High Volume Customer Portal User - Clone' || q.profile.name == 'Customer Community User Developer'))
                {
                    selected_users_id.add(q.id);
                }
                else if(q.id == current_user && q.userrole.name == 'QA Engineer')
                {
                    selected_qa_users_id.add(q.id);
                }
            }
        }

        system.debug('List<User> selected_users_id - ' + selected_users_id);
        if(selected_qa_users_id.size() > 0)
        {
            List<Case> plugin_cases = [SELECT id, status, synetyplugin__c FROM Case where owner.id = :selected_qa_users_id and DAY_ONLY(LastModifiedDate) >= :tdt1 AND DAY_ONLY(LastModifiedDate) <= :tdt2];
            List<ID> selected_plugin_id = new List<ID>();
            for(Case c : plugin_cases)
            {
                selected_plugin_id.add(c.synetyplugin__c);
            }
//            plugins = [SELECT Id, CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, QA_Ticket_Reference__c, CreatedById, CreatedDate, LastModifiedDate FROM Synety_Plugin__c where name = 'Test API' and id = :selected_plugin_id and DAY_ONLY(LastModifiedDate) >= :tdt1 AND DAY_ONLY(LastModifiedDate) <= :tdt2 order by Name, Plugin_Version__c, LastModifiedDate];
            plugins = [SELECT Id, CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, QA_Ticket_Reference__c, CreatedById, CreatedDate, LastModifiedDate, StatusUpdate__c FROM Synety_Plugin__c where id = :selected_plugin_id and StatusUpdate__c >= :tdt1 AND StatusUpdate__c <= :tdt2 order by Name, Plugin_Version__c, StatusUpdate__c];
        }
        else if(selected_users_id.size() > 0)
        {
//            plugins = [SELECT Id, CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, QA_Ticket_Reference__c, CreatedById, CreatedDate, LastModifiedDate FROM Synety_Plugin__c where name = 'Test API' and owner.id = :selected_users_id and DAY_ONLY(LastModifiedDate) >= :tdt1 AND DAY_ONLY(LastModifiedDate) <= :tdt2 order by Name, Plugin_Version__c, LastModifiedDate];
			plugins = [SELECT Id, CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, QA_Ticket_Reference__c, CreatedById, CreatedDate, LastModifiedDate, StatusUpdate__c FROM Synety_Plugin__c where owner.id = :selected_users_id and StatusUpdate__c >= :tdt1 AND StatusUpdate__c <= :tdt2 order by Name, Plugin_Version__c, StatusUpdate__c];
        }
        else
        {
//            plugins = [SELECT Id, CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, QA_Ticket_Reference__c, CreatedById, CreatedDate, LastModifiedDate FROM Synety_Plugin__c where name = 'Test API' and DAY_ONLY(LastModifiedDate) >= :tdt1 AND DAY_ONLY(LastModifiedDate) <= :tdt2 order by Name, Plugin_Version__c, LastModifiedDate];
            plugins = [SELECT Id, CRM__c, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, QA_Ticket_Reference__c, CreatedById, CreatedDate, LastModifiedDate, StatusUpdate__c FROM Synety_Plugin__c where StatusUpdate__c >= :tdt1 AND StatusUpdate__c <= :tdt2 order by Name, Plugin_Version__c, StatusUpdate__c];
        }
        
        for(Synety_Plugin__c s : plugins)
        {
            plugin_names.add(s.name+ ' ' + s.Plugin_Version__c);
        }
        system.debug('Set<Synety_Plugin__c> plugin_names - ' + plugin_names);

        for(String p : plugin_names)
        {
            DateTime lmd = datetime.newInstance(1900, 1, 1);
            Integer submitCount = 0, passedCount = 0, failedCount = 0, failedPluginCount = 0, firstTimePassedPluginCount = 0;
            Synety_Plugin__c tsp = new Synety_Plugin__c ();
            for(Synety_Plugin__c s : plugins)
            {
                if(s.name+' '+s.Plugin_Version__c == p)
                {
//                    if(lmd < s.LastModifiedDate)
                    if(lmd < s.StatusUpdate__c)
                    {
                        tsp = s;
                    }
                    if(s.QA_Status__c == 'QA - App QA Passed' || s.QA_Status__c == 'App Approved and Live' || s.QA_Status__c == 'QA - App Archived')
                    {
                        passedCount ++;
                    }
                   
                    submitCount++;
                    system.debug('Synety_Plugin__c s - ' + s);
                    List<SObject> sof = [SELECT count(Id) failedcount FROM Case where status = 'QA - App QA Failed' AND SynetyPlugin__c = :s.id and DAY_ONLY(LastModifiedDate) >= :tdt1 AND DAY_ONLY(LastModifiedDate) <= :tdt2];
                    List<SObject> sop = [SELECT count(Id) passedcount FROM Case where (status = 'QA - App QA Passed' or status = 'App Approved and Live' or status = 'QA - App Archived') AND SynetyPlugin__c = :s.id and DAY_ONLY(LastModifiedDate) >= :tdt1 AND DAY_ONLY(LastModifiedDate) <= :tdt2];
                    system.debug('List<SObject> sof - ' + sof);
                    system.debug('List<SObject> sop - ' + sop);
                    
                    if((Integer)sof[0].get('failedcount') > 0)
                    {
                        failedCount += (Integer)sof[0].get('failedcount');
                        failedPluginCount++;
                    }
                    else if((Integer)sof[0].get('failedcount') == 0 && (Integer)sop[0].get('passedcount') > 0)
                    {
                        firstTimePassedPluginCount++;
                    }
                }
            }
			Integer ftpassed = 0;
		    Double avgFailure = 0;      
		    if(passedCount >0)
		    {
				ftpassed = (100 * firstTimePassedPluginCount) / passedCount;
			}

			if(failedPluginCount > 0)
			{
				avgFailure = (Double)failedCount/(Double)failedPluginCount;
			}

			PluginSummary ps = new PluginSummary(tsp.id, tsp.name, tsp.Plugin_Version__c, tsp.Plugin_Version_Number__c, tsp.StatusUpdate__c, submitCount, passedCount, failedCount, ftpassed, avgFailure, null);
//            PluginSummary ps = new PluginSummary(tsp.id, tsp.name, tsp.Plugin_Version__c, tsp.Plugin_Version_Number__c, tsp.LastModifiedDate, submitCount, passedCount, failedCount, 0, 0, null);            
            pluginSummary.add(ps);
        }

        return pluginSummary;
    }

    public SynetyPluginController(ApexPages.StandardController stdController) 
    {
        sp = (Synety_Plugin__c)stdController.getRecord();
        theController = stdController;
        system.debug('sp1 - ' + sp);
        //software = new Document();
        //software_exists = new List<Document> ();

        if(sp.id != null)
        {
            sp = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c, Supported_Product_Versions__c, Supported_Browser_Versions__c FROM Synety_Plugin__c 
                    WHERE id =:sp.id]; 
            system.debug('sp2 - ' + sp);
            //system.debug('software - ' + software);
        }
        attachment = new Attachment();
        additional_notes = new Attachment();
        system.debug('Date.today().month() - ' + Date.today().month());
        system.debug('Date.today().year() - ' + Date.today().year());
        tmp_plugin = new Synety_Plugin__c ();
        tmp_plugin.stDate__c = Date.today().toStartOfMonth();
        tmp_plugin.enDate__c = Date.today().addMonths(1).toStartOfMonth();
        current_user = 'All';
        all_users = [SELECT Id, Name, IsActive, profile.name, usertype, userrole.name FROM User where (profile.name = 'High Volume Customer Portal User - Clone' or profile.name = 'Customer Community User Developer' or userrole.name = 'QA Engineer') and isactive = true];
        selected_users_id = new List<ID>();
        selected_qa_users_id = new List<ID>();
    }

    public void getChangedMonth()
    {
        //system.debug('getChangedMonth - ' + current_month);
    }

    public List<SelectOption> getUsers() 
    {
        system.debug('In getUsers');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('ALL', 'All'));
        options.add(new SelectOption('QA', 'All QA Engineers'));        
        options.add(new SelectOption('DEV', 'All Developers'));

        List<User> developers = [SELECT Id, Name, IsActive, profile.name, usertype, userrole.name FROM User where (profile.name = 'High Volume Customer Portal User - Clone' or profile.name = 'Customer Community User Developer' or userrole.name = 'QA Engineer') and isactive = true];
        if(developers.size() > 0)
        {
            for(User u : developers)
            {
                options.add(new SelectOption(u.id, u.name));
            }
        }
        return options;
    }

    public PageReference newcancel() 
    {
        system.debug('Inside newcancel');
        return new Pagereference(SynetyPluginTab);
    }

    public PageReference newsave() 
    {
        system.debug('Inside newsave');
/*
        List<Synety_Plugin__c> new_sp = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c FROM Synety_Plugin__c 
                    WHERE name = :selectedPlugin and CRM__c = :selectedCRM and Plugin_Version__c = :pluginVersion and Plugin_Version_Number__c = :pluginVersionNumber LIMIT 1];

        system.debug('List<Synety_Plugin__c> new_sp - ' + new_sp);
*/
        system.debug('selectedPlugin - ' + selectedPlugin);
        system.debug('releaseOption - ' + releaseOption);
        system.debug('Attachment additional_notes - ' + additional_notes);

//        if(selectedPlugin != '-None-' && releaseOption != 'None' && (installLink != null || software != null))
        if(selectedPlugin != '-None-' && releaseOption != 'None' && (installLink != null || attachment != null))        
        {
            sp.name = selectedPlugin;
            sp.CRM__c = selectedCRM;
            sp.QA_Status__c = 'No Status';
            sp.License_Key__c = licenseKey;
            sp.Plugin_Version__c = pluginVersion;
            sp.Plugin_Version_Number__c = pluginVersionNumber;
            sp.Release_Date__c = releaseDate;
            sp.New_Features__c = newFeatures;
            sp.Bugs_Fixed__c = bugFixes;
            sp.Install_Instructions__c = installInstruction;
            sp.Install_Link__c = installLink;
            sp.Release_Notes__c = releaseNotes;
            sp.Release_Code__c = releaseOption;
            sp.CRM_Logo__c = sp.CRM_Logo__c;
            sp.Quickstart_Guide__c = sp.Quickstart_Guide__c;
            sp.Supported_Product_Versions__c = supportedProductVersion;
            sp.Supported_Browser_Versions__c = supportedBrowserVersion;

            system.debug('Synety_Plugin__c sp - ' + sp);
    
            upsert sp;

            Group qaqueue = [SELECT Id, Name, Type FROM Group where type = 'Queue' and name = 'QA Queue' LIMIT 1];
            List<Attachment> prev_attachment = [SELECT Id, ContentType, Description, Name, OwnerId, ParentId FROM Attachment WHERE ParentId = :sp.id AND (NOT Name LIKE '% - Notes.%')]; 
            if(prev_attachment.size() > 0)
            {
                try 
                {
                    delete prev_attachment;
                } 
                catch (DMLException e) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                    return null;
                } 
            }

            if(releaseOption == 'Upload Software File')
            {
/*
                software.AuthorId = UserInfo.getUserId();
                software.folderid = '00lG00000019Hf6';

                String sf_name = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c + '%';
                software_exists = [SELECT AuthorId, Body, BodyLength, Description, IsBodySearchable, Id, Name, DeveloperName, IsPublic, Type, 
                            FolderId, IsInternalUseOnly, Keywords, ContentType, NamespacePrefix, Url FROM Document 
                            WHERE name like :sf_name LIMIT 1];

                system.debug('software_exists - ' + software_exists);

                if(software_exists.size() > 0)
                {
                    software_exists[0].body = software.body;
                }
                else
                {
                    if(filename.size() > 0)
                    {
                        software.name = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c + '.' + filename[filename.size() - 1];
                    }
                    else
                    {
                        software.name = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
                    }
                    software.Description = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
                    software.Keywords = sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
                    software.ContentType = filename[filename.size() - 1];
                    software_exists.add(software);
                }
                
                try 
                {
                    upsert software_exists;
                } 
                catch (DMLException e) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Software'));
                    return null;
                } 
*/

                List<String> filename = attachment.name.split('\\.');
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId = sp.id; // the record the file is attached to

                if(filename.size() > 0)
                {
                    attachment.name = sp.CRM__c + ' ' + sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c + '.' + filename[filename.size() - 1];
                }
                else
                {
                    attachment.name = sp.CRM__c + ' ' + sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
                }

                try 
                {
                    insert attachment;
                } 
                catch (DMLException e) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                    return null;
                } 

//                sp.Install_Link__c = 'https://c.na11.content.force.com/servlet/servlet.FileDownload?file=' + software.id;
                sp.Install_Link__c = fileLink + attachment.id;

            }

            qacase = new Case();
            if(qaqueue != null)
            {
                qacase.ownerid = qaqueue.id;
            }
            else
            {                
                qacase.ownerid = UserInfo.getUserId();
            }
            qacase.status = 'QA - App Test Requested';
            qacase.type = 'QA Test Process';
            qacase.subject = 'QA Testing for ' + sp.CRM__c + ' ' + sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c;
            qacase.reason = 'Testing Synety Plugin';
            if(sp.QA_Ticket_Reference__c == null)
            {
                system.debug('First Case');
                qacase.Origin = 'DevCenter';
            }
            else
            {
                system.debug('All Other Cases');
                qacase.Origin = 'Customer Service';
            }

            qacase.Software_Download_Link__c = sp.Install_Link__c;

            try 
            {
                insert qacase;
            }
            catch (DMLException e) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error inserting Case'));
                return null;
            } 

            List<Case> old_cases = [SELECT Id, createddate FROM Case where SynetyPlugin__c = :sp.id order by createddate desc LIMIT 1];
            system.debug('List<Case> old_cases - ' + old_cases);
            if(old_cases.size() > 0)
            {
                List<Attachment> qa_doc = [SELECT Id, Body, BodyLength, ContentType, Description, Name, OwnerId, ParentId, IsPrivate FROM Attachment where parentid = :old_cases[0].id Limit 1];
                system.debug('List<Attachment> qa_doc - ' + qa_doc);
                if(qa_doc.size() > 0)
                {
                    List<String> extension = qa_doc[0].name.split('\\.');
                    system.debug('List<String> extension - ' + extension);
                    
                    Case tc = [SELECT id, casenumber FROM case where id = :qacase.id];
                    system.debug('Case tc - ' + tc);

                    Attachment tmp_att = new Attachment();
                    tmp_att.body = qa_doc[0].body;
                    tmp_att.Name = 'QA Test Results template - ' + tc.CaseNumber + '.' + extension[extension.size() - 1];
                    tmp_att.OwnerId = qa_doc[0].OwnerId;
                    tmp_att.ParentId = qacase.Id;
                    tmp_att.IsPrivate = qa_doc[0].IsPrivate;

                    system.debug('Attachment tmp_att - ' + tmp_att);

                    insert tmp_att;

                }
            }

            sp.QA_Ticket_Reference__c = qacase.id;
            sp.QA_Status__c = 'QA - App Test Requested';// Need this assignment at the end to populate Install Link

            try 
            {
                update sp;
            }
            catch (DMLException e) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Updating QA Ticket Reference.'));
                return null;
            } 

            if(additional_notes != null && (String.isblank(additional_notes.name) != true || String.isempty(additional_notes.name) != true))
            {
                system.debug('additional_notes is not null');
                List<String> filename = additional_notes.name.split('\\.');
                additional_notes.OwnerId = UserInfo.getUserId();
                additional_notes.ParentId = sp.id; // the record the file is attached to
                additional_notes.name = sp.CRM__c + ' ' + sp.Plugin_Version__c + ' ' + sp.Plugin_Version_Number__c + ' - Notes.' +  + filename[filename.size() - 1];
                try 
                {
                    insert additional_notes;
                }
                catch (DMLException e) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Inserting Additional Notes.'));
                    return null;
                }

            }
            else
            {
                system.debug('additional_notes is null');
            }

            system.debug('Return page now');
            //return new Pagereference('/apex/SynetyPluginThankYou');
            return new Pagereference(SynetyPluginTab);

        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check New Plugin details are correct.'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check New Plugin Version Number is correct.'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check if correct Release Code option selected.'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check if latest code is released using option - Upload Software File Or Paste Link.'));
            return null;
        }
    }

    public PageReference display()
    {
        system.debug('Inside display');
        List<Synety_Plugin__c > tsp = new List<Synety_Plugin__c >();
        
        if(sp.id != null)
        {
            tsp = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c, Supported_Product_Versions__c, Supported_Browser_Versions__c FROM Synety_Plugin__c 
                    WHERE id =:sp.id and (QA_Status__c = 'QA - App Test Requested' or QA_Status__c = 'QA - App QA Failed')]; 
            system.debug('sp2 - ' + sp);
        }
        if(tsp.size() > 0)
        {
            sp = tsp[0];
            isSave = true;
            selectedPlugin = sp.name;
            selectedCRM = sp.CRM__c;
            qastatus = 'QA - App Test Requested';
            licenseKey = sp.License_Key__c;
            pluginVersion = sp.Plugin_Version__c;
            if(selectedCRM == 'Salesforce')
            {
                isSF = true;
                prevPluginVersionNumber = sp.Plugin_Version_Number__c + ' (Previous Ver.)';
                List<String> pvn = sp.Plugin_Version_Number__c.split('\\.');
                if(pvn.size() > 0)
                {
                    system.debug('pvn.size() - ' + pvn.size());
                    system.debug('pvn - ' + pvn);
                    pvn[pvn.size() - 1] = String.valueof(Integer.valueof(pvn[pvn.size() - 1]) + 1);
                    pluginVersionNumber = String.join(pvn,'.');
                }
                else
                {
                    pluginVersionNumber = 'No Previous Version';
                }
            }
            else
            {
                isSF = false;
                PluginVersionNumber = sp.Plugin_Version_Number__c;
            }

            releaseDate = sp.Release_Date__c;
            newFeatures = sp.New_Features__c;
            bugFixes = sp.Bugs_Fixed__c;
            installInstruction = sp.Install_Instructions__c;
            installLink = sp.Install_Link__c;
            releaseNotes = sp.Release_Notes__c;
            supportedProductVersion = sp.Supported_Product_Versions__c;
            supportedBrowserVersion = sp.Supported_Browser_Versions__c;
            releaseOption = sp.Release_Code__c;
    
            if(releaseOption == 'Upload Software File')
            {
                isFile = true;
                isLink = false;
            }
            if(releaseOption == 'Paste Link')
            {
                isFile = false;
                isLink = true;
            }
    
            system.debug('releaseOption - ' + releaseOption);
    
            return null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Plugin in the middle of QA process, Please Press <Cancel> to go back'));
            return null;
        }

    }
    
    public PageReference initialise() 
    {
        system.debug('Inside initialise');
        List<String> qa_plugin_names = new List<String> ();
        List<String> qa_plugin_version = new List<String> ();
        if(sp.id != null)
        {
            sp = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c, Supported_Product_Versions__c, Supported_Browser_Versions__c FROM Synety_Plugin__c 
                    WHERE id =:sp.id]; 
            system.debug('sp2 - ' + sp);
        }

        qa_process_plugins = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c, Supported_Product_Versions__c, Supported_Browser_Versions__c FROM Synety_Plugin__c
                    WHERE QA_Status__c != 'App Approved and Live' and QA_Status__c != 'QA - App Archived'];

       
        for(Synety_Plugin__c q : qa_process_plugins)
        {
            qa_plugin_names.add(q.name);
            qa_plugin_version.add(q.Plugin_Version__c);
        }

        all_plugins = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c, Supported_Product_Versions__c, Supported_Browser_Versions__c FROM Synety_Plugin__c
                    WHERE QA_Status__c = 'App Approved and Live' and name != :qa_plugin_names];// and Plugin_Version__c != :qa_plugin_version];
        
        system.debug('all_plugins - ' + all_plugins);
        system.debug('qa_process_plugins - ' + qa_process_plugins);
        isFile = true;
        isLink = true;

/*
        selectedPlugin = sp.name;
        selectedCRM = sp.CRM__c;
        qastatus = sp.QA_Status__c;
        licenseKey = sp.License_Key__c;
        pluginVersion = sp.Plugin_Version__c;
        pluginVersionNumber = sp.Plugin_Version_Number__c;
        releaseDate = sp.Release_Date__c;
        newFeatures = sp.New_Features__c;
        bugFixes = sp.Bugs_Fixed__c;
        installInstruction = sp.Install_Instructions__c;
        installLink = sp.Install_Link__c;
        releaseNotes = sp.Release_Notes__c;
        releaseOption = sp.Release_Code__c;
        //releaseLink = sp.Install_Link__c;

        if(releaseOption == 'Upload Software File')
        {
            isFile = true;
            //releaseLink = '';
            isLink = false;
        }
        if(releaseOption == 'Paste Link')
        {
            isFile = false;
            isLink = true;
        }
*/
        system.debug('releaseOption - ' + releaseOption);

        return null;
    }

    public List<SelectOption> getPlugins() 
    {
        system.debug('Inside getPlugins');

        List<SelectOption> pluginOptionLst = new List<SelectOption>();
        Set<String> pluginSet = new Set<String>();
        List<String> pluginLst = new List<String>();

        for(Synety_Plugin__c p : all_plugins)
        {
            pluginSet.add(p.name);
        }
        pluginLst.addAll(pluginSet);
        pluginLst.sort();

        pluginOptionLst.add(new SelectOption('-None-', '-None-'));

        for(String pg : pluginLst)
        {
            pluginOptionLst.add(new SelectOption(pg, pg));
        }

        system.debug('pluginOptionLst - ' + pluginOptionLst);

        return pluginOptionLst;
    }

    public void releaseFunctionMethod()
    {
        system.debug('releaseOption - ' + releaseOption);
        if(releaseOption == 'Upload Software File')
        {
            isFile = true;
            //releaseLink = '';
            isLink = false;
        }
        else if(releaseOption == 'Paste Link')
        {
            isFile = false;
            isLink = true;
        }
        else
        {
            isFile = true;
            isLink = true;
        }
        system.debug('isFile - ' + isFile);
        system.debug('isLink - ' + isLink);
    }

    public void getCRM() 
    {
        system.debug('selectedPlugin - ' + selectedPlugin);

        Synety_Plugin__c p = new Synety_Plugin__c();

        List<Synety_Plugin__c> plugins = [SELECT Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, 
                    New_Features__c, OwnerId, Name, Plugin_Version__c, Plugin_Version_Number__c, QA_Status__c, 
                    QA_Ticket_Reference__c, Quickstart_Guide__c, Id, Release_Date__c, Release_Notes__c, Release_Code__c, 
                    Remaining_Bugs__c, ismailsent__c, Software_Ready_for_Release__c, Supported_Product_Versions__c, Supported_Browser_Versions__c FROM Synety_Plugin__c
                    WHERE name = :selectedPlugin order by Release_Date__c desc limit 1];
 
        system.debug('List<Synety_Plugin__c> plugins - ' + plugins);

        for(Synety_Plugin__c tp : plugins)
        {
            if(tp.Name == selectedPlugin)
            {
                p = tp;
                break;
            }
        }

        if(selectedPlugin != '-None-')
        {
            isCRM = true;
            selectedCRM = p.CRM__c;
            qastatus = 'QA - App Test Requested';
            licenseKey = p.License_Key__c;
            pluginVersion = p.Plugin_Version__c;
            pluginVersionNumber = p.Plugin_Version_Number__c;
            prevPluginVersionNumber = p.Plugin_Version_Number__c + ' (Previous Ver.)';
            List<String> pvn = p.Plugin_Version_Number__c.split('\\.');
            if(pvn.size() > 0)
            {
                system.debug('pvn.size() - ' + pvn.size());
                system.debug('pvn - ' + pvn);
                pvn[pvn.size() - 1] = String.valueof(Integer.valueof(pvn[pvn.size() - 1]) + 1);
                pluginVersionNumber = String.join(pvn,'.');
            }
            else
            {
                pluginVersionNumber = 'No Previous Version';
            }
            releaseDate = DateTime.NOW();
            bugFixes = p.Bugs_Fixed__c;
            installInstruction = p.Install_Instructions__c;
            releaseNotes = p.Release_Notes__c;
            supportedProductVersion = p.Supported_Product_Versions__c;
            supportedBrowserVersion = p.Supported_Browser_Versions__c;

            system.debug('installInstruction - ' + installInstruction);
            system.debug('isCRM - ' + isCRM);
        }
        else
        {
            isCRM = false;
            isFile = false;
            isLink = false;
            selectedCRM = '';
            licenseKey = '';
            pluginVersion = '';
            pluginVersionNumber = '';
            releaseDate = null;
            installInstruction = '';
            releaseNotes = '';
            supportedProductVersion = '';
            supportedBrowserVersion = '';
        }
    }


    public PageReference mailList() 
    {
        List<Id> acct_ids = new List<Id>();

        String theId = ApexPages.currentPage().getParameters().get('id');

        if (theId == null) 
        {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
 
        Synety_Plugin__c s = [select id, License_Key__c from Synety_Plugin__c where id =:theId]; 
        List<API_Audit_Trail__c> aat_l = [select id, account__c, License_Key__c from API_Audit_Trail__c where License_Key__c = :s.License_Key__c];
        system.debug('Synety_Plugin__c - ' + s);
        for(API_Audit_Trail__c aat : aat_l)
        {
            acct_ids.add(aat.account__c);
        }
        system.debug('Accounts - ' + acct_ids);
        cnct_l = [Select id, name, email From Contact where accountid in :acct_ids and email != null and primary_contact__c = true order by name];
        system.debug('cnct_l - ' + cnct_l);
        cncts = new Set<String>();
        for(contact c : cnct_l)
        {
            system.debug('c.email - ' + c.email);
            cncts.add(c.email);
        }

        system.debug('cncts - ' + cncts);

        return null;
    }
         
    // Code we will invoke on page load.
    public PageReference autoRun() 
    {
        String theId = ApexPages.currentPage().getParameters().get('id');

        if (theId == null) 
        {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
 
        Synety_Plugin__c s = [select id, name, Bugs_Fixed__c, CRM__c, CRM_Logo__c, Install_Instructions__c, Install_Link__c, License_Key__c, New_Features__c, Plugin_Version__c, Plugin_Version_Number__c, Quickstart_Guide__c, Release_Date__c, Release_Notes__c, Remaining_Bugs__c, ismailsent__c from Synety_Plugin__c where id =:theId]; 

        if(s.ismailsent__c == false)
        {
            List<Id> acct_ids = new List<Id>();
            system.debug('Synety_Plugin__c - ' + s);
            List<API_Audit_Trail__c> aat_l = [select id, account__c, License_Key__c from API_Audit_Trail__c where License_Key__c = :s.License_Key__c];
            system.debug('API_Audit_Trail__c - ' + aat_l);
            for(API_Audit_Trail__c aat : aat_l)
            {
                acct_ids.add(aat.account__c);
            }
            system.debug('Accounts - ' + acct_ids);
            s.ismailsent__c = true;
            update s;

            String spc_query = 'Select Id, Name, email From Contact where accountid in :acct_ids and email != null and primary_contact__c = true';
        
            SynetyPluginBatchClass batchApex = new SynetyPluginBatchClass(spc_query, acct_ids, s);
            ID batchprocessid = Database.executeBatch(batchApex, 10);

            return theController.view().setRedirect(true);
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mail is already sent for this update, Please change Both Plugin Version and Release Date to send Updated Version'));
            return null;
        }
    }
}