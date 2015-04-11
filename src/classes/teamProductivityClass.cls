public class teamProductivityClass
{
    public String current_month {get; set;}
    public String old_month {get; set;}
    public String current_department {get; set;}
    List<AccountData> deserializedAccounts = new List<AccountData> ();
    List<AccountCallStatisticsData> deserializedAccountCallStatistics = new List<AccountCallStatisticsData> ();
    List<AccountCallCategoriesData> deserializedAccountCallCategories = new List<AccountCallCategoriesData> ();

    AccountCallCategoriesData accd = new AccountCallCategoriesData(0, 0, 0, '', 0, 0);
    AccountCallStatisticsData acsd = new AccountCallStatisticsData('', 0, 0, 0, 0);
    AccountData ad = new AccountData('', '', '', '', true, true, '', '', '', '', '');
    TeamMembersData tm = new TeamMembersData();

    List<TeamProductivityReportData> reportData = new List<TeamProductivityReportData> ();
    List<BarChartData> barData = new List<BarChartData> ();
    List<PieChartData> emailPieData = new List<PieChartData> ();
    List<PieChartData> taskPieData = new List<PieChartData> ();
    
    public teamProductivityClass ()
    {
        system.debug('deserializedAccounts teamProductivityClass - ' + deserializedAccounts);

        current_department = 'Sales';
        system.debug('current_month - ' + Date.today().month().format() + ' ' + Date.today().year().format().remove(','));
        current_month = Date.today().month().format() + ' ' + Date.today().year().format().remove(',');
        old_month = current_month;

        system.debug('Calling SYNETY API');
        getAllSynetyAccountCallData(current_month);
        getChangedMonth();
    }

    public class TeamMembersData
    {
        public String Name { get;set;}
        public Integer NoofAccountsUpdated { get;set;}
        public Integer NoofOpportunityUpdated { get;set;}
        public Integer NoofCasesUpdated { get;set;}
        public Integer NoofEmails { get;set;}
        public Integer NoofTasks { get;set;}
        public Integer NoofCallNotes { get;set;}
        public Integer NoofCallCategorised { get;set;}
        public Integer NoofCalls { get;set;}
        public Integer TotalCallTime { get;set;}

        public TeamMembersData()
        {
        }

        public TeamMembersData(String Name, Integer NoofAccountsUpdated, Integer NoofOpportunityUpdated, Integer NoofCasesUpdated, Integer Noofemails, Integer NoofTasks, Integer NoofCallNotes, Integer NoofCallCategorised, Integer NoofCalls, Integer TotalCallTime)
        {
            system.debug('In TeamMembersData Constructor');
            this.Name = Name;
            this.NoofAccountsUpdated = NoofAccountsUpdated;
            this.NoofOpportunityUpdated = NoofOpportunityUpdated;
            this.NoofCasesUpdated = NoofCasesUpdated;
            this.NoofEmails = NoofEmails;
            this.NoofTasks = NoofTasks;
            this.NoofCallNotes = NoofCallNotes;
            this.NoofCallCategorised = NoofCallCategorised;
            this.NoofCalls = NoofCalls;
            this.TotalCallTime = TotalCallTime;
        }
    }

    public class AccountCallCategoriesData
    {
        Double TotalCharges;
        Integer CategoryId;
        Integer Direction;
        String i_account;
        Integer NumberOfCalls;
        Integer TotalDuration;
        public AccountCallCategoriesData(Double TotalCharges, Integer CategoryId, Integer Direction, String i_account, Integer NumberOfCalls, Integer TotalDuration)
        {
            this.TotalCharges = TotalCharges;
            this.CategoryId = CategoryId;
            this.Direction = Direction;
            this.i_account = i_account;
            this.NumberOfCalls = NumberOfCalls;
            this.TotalDuration = TotalDuration;
        }
    }

    public class AccountCallStatisticsData
    {
        String i_account;
        Integer NumberOfCalls;
        Integer TotalCallTime;
        Integer NumberOfMissedCalls;
        Double TotalCharges;
        
        public AccountCallStatisticsData(String i_account, Integer NumberOfCalls, Integer TotalCallTime, Integer NumberOfMissedCalls, Double TotalCharges)
        {
            this.i_account = i_account;
            this.NumberOfCalls = NumberOfCalls;
            this.TotalCallTime = TotalCallTime;
            this.NumberOfMissedCalls = NumberOfMissedCalls;
            this.TotalCharges = TotalCharges;
        }
    }

    public class AccountData
    {
        String AccountNumber;
        String Password;
        String i_account;
        String i_customer;
        Boolean CanDownloadRecordings;
        Boolean CanDownloadAllRecordings;
        String Login;
        String Firstname;
        String Surname;
        String NotificationToken;
        String Departments;


        public AccountData(String AccountNumber, String Password, String i_account, String i_customer, Boolean CanDownloadRecordings, Boolean CanDownloadAllRecordings, String Login, String Firstname, String Surname, String NotificationToken, String Departments)
        {
            this.AccountNumber = AccountNumber;
            this.Password = Password;
            this.i_account = i_account;
            this.i_customer = i_customer;
            this.CanDownloadRecordings = CanDownloadRecordings;
            this.CanDownloadAllRecordings = CanDownloadAllRecordings;
            this.Login = Login;
            this.Firstname = Firstname;
            this.Surname = Surname;
            this.NotificationToken = NotificationToken;
            this.Departments = Departments;
        }
    }

    public class TeamProductivityReportData
    {        
        public String Manager { get;set;}
        public List<TeamMembersData> TeamMembers {get;set;}

        public TeamProductivityReportData(String manager, List<TeamMembersData> TeamMembers)        
        {            
            system.debug('In TeamProductivityReportData Constructor');
            this.manager = manager;
            this.TeamMembers = TeamMembers;
        }    
    }

    public class BarChartData
    {
        public String senior_sales_manager { get;set;}
        public Integer no_of_accounts { get;set;}
        public Integer no_of_opportunity { get;set;}
        public Integer no_of_cases { get;set;}
        public BarChartData(String senior_sales_manager, Integer no_of_accounts, Integer no_of_opportunity, Integer no_of_cases)
        {
            system.debug('In BarChartData Constructor');
            this.senior_sales_manager = senior_sales_manager;
            this.no_of_accounts = no_of_accounts;
            this.no_of_opportunity = no_of_opportunity;
            this.no_of_cases = no_of_cases;
        }
    }

    public class PieChartData
    {
        public String name { get;set;}
        public Integer count { get;set;}
        public PieChartData(String name, Integer count)
        {
            system.debug('In PieChartData Constructor');
            this.name = name;
            this.count = count;
        }
    }

    public List<BarChartData> getBarChart()
    {
        system.debug('BarData before sending - ' + BarData);
        system.debug('deserializedAccounts.size() - ' + deserializedAccounts.size());
        return BarData;
    }

    public List<PieChartData> getEmailPieChart()
    {
        system.debug('emailPieData before sending - ' + emailPieData);
        system.debug('deserializedAccounts.size() - ' + deserializedAccounts.size());
        return emailPieData;
    }

    public List<PieChartData> getTaskPieChart()
    {
        system.debug('taskPieData before sending - ' + taskPieData);
        system.debug('deserializedAccounts.size() - ' + deserializedAccounts.size());
        return taskPieData;
    }

    public HttpResponse getAllSynetyAccountCallData(String current_month) 
    {
        String body = '';
        String [] mmyy = current_month.split(' ', 2);
        Integer mm = Integer.valueof(mmyy[0]);
        Integer yy = Integer.valueof(mmyy[1]);
        Integer dd = Date.daysInMonth(yy, mm);
        String FromDate = datetime.newinstance(yy, mm, 1).Format('yyyy-MM-dd');
        String ToDate = datetime.newinstance(yy, mm, dd).Format('yyyy-MM-dd');
        system.debug('In Side getAllSynetyAccounts');
        system.debug('FromDate - ' + FromDate);
        system.debug('ToDate - ' + ToDate);
        Http htp = new Http();
        HttpRequest req = new HttpRequest(); 
        HttpResponse res = new HttpResponse(); 
        req = new HttpRequest();
        if(body != null && body.length()>0)
            req.setBody(body);
        req.setMethod('GET');
        req.setHeader('username', 'mark.seemann@synety.com');
        req.setHeader('Password', 'SynV0verip413');
        req.setHeader('LicenseKey', '81A76B94-6ACD-4A70-BDC9-C4D9A549D356');
        req.setHeader('Origin', 'http://www.salesforce.com');
        req.setTimeout(120000);
        req.setHeader('Content-Length', '0');

        system.debug('Get All Synety Accounts');

        String endPoint = 'https://api.synety.com/customers/mark.seemann@synety.com/Accounts';
        system.debug('endPoint - ' + endPoint);
        req.setEndpoint(endPoint);
        system.debug('req - ' + req);
        res = htp.send(req);
        if(res.getStatusCode() != 200)
        {
            system.debug('API call is not successful.');
        }
        system.debug('res.getStatus - ' + res.getStatus());
        system.debug('res - '+ res);
        system.debug('res.getBody - '+res.getBody());
        deserializedAccounts = (List<AccountData>)JSON.deserialize(res.getBody(), List<AccountData>.class);
        system.debug('deserializedAccounts.size() - ' + deserializedAccounts.size());
        system.debug('deserializedAccounts - ' + deserializedAccounts);

        system.debug('Get All Synety Account Call Statistics');

        endPoint = 'https://api.synety.com/customers/mark.seemann@synety.com/CallStatistics?from='+FromDate+'&to='+ToDate;
        system.debug('endPoint - ' + endPoint);
        req.setEndpoint(endPoint);
        system.debug('req - ' + req);
        res = htp.send(req);
        if(res.getStatusCode() != 200)
        {
            system.debug('API call is not successful.');
        }
        system.debug('res.getStatus - ' + res.getStatus());
        system.debug('res - '+ res);
        system.debug('res.getBody - '+res.getBody());
        deserializedAccountCallStatistics = (List<AccountCallStatisticsData>) JSON.deserialize(res.getBody(), List<AccountCallStatisticsData>.class);
        system.debug('deserializedAccountCallStatistics.size() - ' + deserializedAccountCallStatistics.size());
        system.debug('deserializedAccountCallStatistics - ' + deserializedAccountCallStatistics);

        system.debug('Get All Synety Account Call Categories');

        endPoint = 'https://api.synety.com/customers/mark.seemann@synety.com/CallCategoriesAnalysis?from='+FromDate+'&to='+ToDate;
        system.debug('endPoint - ' + endPoint);
        req.setEndpoint(endPoint);
        system.debug('req - ' + req);
        res = htp.send(req);
        if(res.getStatusCode() != 200)
        {
            system.debug('API call is not successful.');
        }
        system.debug('res.getStatus - ' + res.getStatus());
        system.debug('res - ' + res);
        system.debug('res.getBody - ' + res.getBody());
        deserializedAccountCallCategories = (List<AccountCallCategoriesData>) JSON.deserialize(res.getBody(), List<AccountCallCategoriesData>.class);
        system.debug('deserializedAccountCallCategories.size() - ' + deserializedAccountCallCategories.size());
        system.debug('deserializedAccountCallCategories - ' + deserializedAccountCallCategories);

        return res;
    }

    public TeamMembersData getNoofCalls(User usr, Integer mm, Integer yy)
    {
        TeamMembersData callStats = new TeamMembersData ('', 0, 0, 0, 0, 0, 0, 0, 0,0);
        String phone = usr.phone.remove(' ').replaceFirst('\\+*', '').replaceFirst('0*', '');
        usr.phone = (phone.startswith('44') == false ? '44' + phone : phone);
        system.debug('Inside getNoofCalls');
        system.debug('deserializedAccounts getNoofCalls - ' + deserializedAccounts);
        for(AccountData ad : deserializedAccounts)
        {
            system.debug('usr.phone - ' + usr.phone);
            if(usr.phone == ad.AccountNumber)
            {
                system.debug('AccountData - ' + ad);
                for(AccountCallStatisticsData acsd : deserializedAccountCallStatistics)
                {
                    if(ad.i_account == acsd.i_account)
                    {
                        system.debug('AccountCallStatisticsData - ' + acsd);
                        callStats.NoofCalls = acsd.NumberOfCalls;
                        callStats.TotalCallTime = (acsd.TotalCallTime / 60);
                    }
                }

                for(AccountCallCategoriesData accd : deserializedAccountCallCategories)
                {
                    if(ad.i_account == accd.i_account && accd.CategoryId != -1)
                    {
                        system.debug('AccountCallCategoriesData - ' + accd);
                        callStats.NoofCallCategorised += accd.NumberOfCalls;
                    }
                }
            }
        }
        return callStats;
    }

    public Map<String, Integer> getNoofNotes(List<User> usr, Integer mm, Integer yy)
    {
        system.debug('Inside getNoofNotes');
        List<Id> usrids = new List<Id>();
        Map<String, Integer> NoofNotes = new Map<String, Integer>();
        for(User u : usr)
        {
            usrids.add(u.id);
        }

        system.debug('usrids - ' + usrids);
        system.debug('mm - ' + mm);
        system.debug('yy - ' + yy);

        List<Sobject> returnCount = [SELECT LastModifiedById, count(Id) totalnotes FROM Note WHERE LastModifiedById = :usrids AND CALENDAR_MONTH(LastModifiedDate) = :mm AND CALENDAR_YEAR (LastModifiedDate) = :yy GROUP BY LastModifiedById];
        system.debug('getNoofNotes returnCount - ' + returnCount);

        if(returnCount.size() > 0)
        {
            for(User u2 : usr)
            {
                for(Sobject s : returnCount)
                {
                    if(u2.id == s.get('LastModifiedById'))
                    {
                        NoofNotes.put(u2.name, (Integer)s.get('totalnotes'));
                    }
                    else
                    {
                        NoofNotes.put(u2.name, 0);
                    }
                }
            }
        }
        else
        {
            for(User u2 : usr)
            {
                NoofNotes.put(u2.name, 0);
            }
        }
        system.debug('NoofNotes - ' + NoofNotes);
        return NoofNotes;
    }

    public Map<String, Integer> getNoofTasks(List<User> usr, Integer mm, Integer yy)
    {
        system.debug('Inside getNoofTasks');
        List<Id> usrids = new List<Id>();
        Map<String, Integer> NoofTasks = new Map<String, Integer>();
        for(User u : usr)
        {
            usrids.add(u.id);
        }

        List<SObject> returnCount = [SELECT LastModifiedById, count(Id) totaltasks FROM Task WHERE LastModifiedById  = :usrids AND CALENDAR_MONTH(LastModifiedDate) = :mm AND CALENDAR_YEAR (LastModifiedDate) = :yy AND (NOT Subject LIKE 'Email%') GROUP BY LastModifiedById];
        system.debug('getNoofTasks returnCount - ' + returnCount);

        if(returnCount.size() > 0)
        {
            for(User u2 : usr)
            {
                for(Sobject s : returnCount)
                {
                    if(u2.id == s.get('LastModifiedById'))
                    {
                        NoofTasks.put(u2.name, (Integer)s.get('totaltasks'));
                    }
                    else
                    {
                        NoofTasks.put(u2.name, 0);
                    }
                }
            }
        }
        else
        {
            for(User u2 : usr)
            {
                NoofTasks.put(u2.name, 0);
            }
        }
        system.debug('NoofTasks - ' + NoofTasks);
        return NoofTasks;
    }

    public Map<String, Integer> getNoofEmails(List<User> usr, Integer mm, Integer yy)
    {
        system.debug('Inside getNoofEmails');
        List<Id> usrids = new List<Id>();
        Map<String, Integer> NoofEmails = new Map<String, Integer>();
        for(User u : usr)
        {
            usrids.add(u.id);
        }

        List<SObject> returnCount = [SELECT LastModifiedById, count(id) totalemails FROM Task WHERE LastModifiedById = :usrids AND CALENDAR_MONTH(LastModifiedDate) = :mm AND CALENDAR_YEAR (LastModifiedDate) = :yy AND Subject LIKE 'Email%' GROUP BY LastModifiedById];
        system.debug('getNoofEmails returnCount - ' + returnCount);

        if(returnCount.size() > 0)
        {
            for(User u2 : usr)
            {
                for(Sobject s : returnCount)
                {
                    if(u2.id == s.get('LastModifiedById'))
                    {
                        NoofEmails.put(u2.name, (Integer)s.get('totalemails'));
                    }
                    else
                    {
                        NoofEmails.put(u2.name, 0);
                    }
                }
            }
        }
        else
        {
            for(User u2 : usr)
            {
                NoofEmails.put(u2.name, 0);
            }
        }
        system.debug('NoofEmails - ' + NoofEmails);
        return NoofEmails;
    }

    public Map<String, Integer> getNoofCasesUpdated(List<User> usr, Integer mm, Integer yy)
    {
        system.debug('Inside getNoofCasesUpdated');
        List<Id> usrids = new List<Id>();
        Map<String, Integer> NoofCasesUpdated = new Map<String, Integer>();
        for(User u : usr)
        {
            usrids.add(u.id);
        }

        system.debug('usrids - ' + usrids);
        
        List<SObject> returnCount = [SELECT LastModifiedById, COUNT(Id) totalcase FROM Case WHERE LastModifiedById  = :usrids AND CALENDAR_MONTH(LastModifiedDate) = :mm AND CALENDAR_YEAR (LastModifiedDate) = :yy GROUP BY LastModifiedById];
        system.debug('getNoofCasesUpdated returnCount - ' + returnCount);

        if(returnCount.size() > 0)
        {
            for(User u2 : usr)
            {
                for(Sobject s : returnCount)
                {
                    if(u2.id == s.get('LastModifiedById'))
                    {
                        NoofCasesUpdated.put(u2.name, (Integer)s.get('totalcase'));
                    }
                    else
                        NoofCasesUpdated.put(u2.name, 0);
                }
            }
        }
        else
        {
            for(User u2 : usr)
            {
                NoofCasesUpdated.put(u2.name, 0);
            }
        } 
        system.debug('NoofCasesUpdated - ' + NoofCasesUpdated);
        return NoofCasesUpdated;
    }
    
    public Map<String, Integer> getNoofOpportunityUpdated(List<User> usr, Integer mm, Integer yy)
    {
        system.debug('Inside getNoofAccountsUpdated');
        List<Id> usrids = new List<Id>();
        Map<String, Integer> NoofOpportunityUpdated = new Map<String, Integer>();
        for(User u : usr)
        {
            usrids.add(u.id);
        }

        system.debug('usrids - ' + usrids);

        List<SObject> returnCount = [SELECT LastModifiedById, COUNT(Id) totaloppt FROM Opportunity WHERE LastModifiedById  = :usrids AND CALENDAR_MONTH(LastModifiedDate) = :mm AND CALENDAR_YEAR (LastModifiedDate) = :yy GROUP BY LastModifiedById];
        system.debug('getNoofOpportunityUpdated returnCount - ' + returnCount);

        if(returnCount.size() > 0)
        {
            for(User u2 : usr)
            {
                for(Sobject s : returnCount)
                {
                    if(u2.id == s.get('LastModifiedById'))
                    {
                        NoofOpportunityUpdated.put(u2.name, (Integer)s.get('totaloppt'));
                    }
                    else
                        NoofOpportunityUpdated.put(u2.name, 0);
                }
            }
        }
        else
        {
            for(User u2 : usr)
            {
                NoofOpportunityUpdated.put(u2.name, 0);
            }
        } 
        system.debug('NoofOpportunyUpdated - ' + NoofOpportunityUpdated);
        return NoofOpportunityUpdated;
    }

    public Map<String, Integer> getNoofAccountsUpdated(List<User> usr, Integer mm, Integer yy)
    {
        system.debug('Inside getNoofAccountsUpdated');
        List<Id> usrids = new List<Id>();
        Map<String, Integer> NoofAccountsUpdated = new Map<String, Integer>();
        for(User u : usr)
        {
            usrids.add(u.id);
        }

        system.debug('usrids - ' + usrids);

        List<SObject> returnCount = [SELECT LastModifiedById, COUNT(Id) totalacct FROM Account WHERE LastModifiedById = :usrids AND CALENDAR_MONTH(LastModifiedDate) = :mm AND CALENDAR_YEAR(LastModifiedDate) = :yy GROUP BY LastModifiedById];
        system.debug('getNoofAccountsUpdated returnCount - ' + returnCount);

        if(returnCount.size() > 0)
        {
            for(User u2 : usr)
            {
                for(Sobject s : returnCount)
                {
                    if(u2.id == s.get('LastModifiedById'))
                    {
                        NoofAccountsUpdated.put(u2.name, (Integer)s.get('totalacct'));
                    }
                    else
                        NoofAccountsUpdated.put(u2.name, 0);
                }
            }
        }
        else
        {
            for(User u2 : usr)
            {
                NoofAccountsUpdated.put(u2.name, 0);
            }
        } 
        system.debug('NoofAccountsUpdated - ' + NoofAccountsUpdated);
        return NoofAccountsUpdated;
    }

    public List<TeamMembersData> getTeamMembersData(List<User> team)
    {
        system.debug('getTeamMembersData - ' + team);

        String [] mmyy = current_month.split(' ', 2);
        Integer mm = Integer.valueof(mmyy[0]);
        Integer yy = Integer.valueof(mmyy[1]);
        List<TeamMembersData> team_mem = new List<TeamMembersData> ();
        Integer NoofAccountsUpdated = 0, NoofOpportunityUpdated = 0, NoofCasesUpdated = 0, NoofEmails = 0, NoofTasks = 0, NoofNotes = 0, NoofCalls = 0;
        Map<String, Integer> EmailMap = new Map<String, Integer>();
        Map<String, Integer> AccountMap = new Map<String, Integer>();
        Map<String, Integer> OpportunityMap = new Map<String, Integer>();
        Map<String, Integer> CaseMap = new Map<String, Integer>();
        Map<String, Integer> TaskMap = new Map<String, Integer>();
        Map<String, Integer> NoteMap = new Map<String, Integer>();

        TeamMembersData callStats;
        AccountMap = getNoofAccountsUpdated(team, mm, yy);
        OpportunityMap = getNoofOpportunityUpdated(team, mm, yy);
        CaseMap = getNoofCasesUpdated(team, mm, yy);
        EmailMap = getNoofEmails(team, mm, yy);
        TaskMap = getNoofTasks(team, mm, yy);
        NoteMap = getNoofNotes(team, mm, yy);

        for(User ut : team)
        {
            NoofAccountsUpdated = AccountMap.get(ut.name);
            NoofOpportunityUpdated = OpportunityMap.get(ut.name);
            NoofCasesUpdated = CaseMap.get(ut.name);
            NoofEmails = EmailMap.get(ut.name);
            NoofTasks = TaskMap.get(ut.name);
            NoofNotes = NoteMap.get(ut.name);
            callStats = getNoofCalls(ut, mm, yy);
            team_mem.add(new TeamMembersData(ut.name, NoofAccountsUpdated, NoofOpportunityUpdated, NoofCasesUpdated, NoofEmails, NoofTasks, NoofNotes, callStats.NoofCallCategorised, callStats.NoofCalls, callStats.TotalCallTime));
            if(NoofEmails > 0)
            {
                emailPieData.add(new PieChartData(ut.name, NoofEmails));
            }
            if(NoofTasks > 0)
            {
                taskPieData.add(new PieChartData(ut.name, NoofTasks));
            }
        }
        return team_mem;
    }

    public List<TeamProductivityReportData> getReportData()
    {
        system.debug('In getReportData');
        system.debug('old_month - ' + old_month);
        system.debug('deserializedAccounts getReportData - ' + deserializedAccounts);
        return reportData;
    }
        
    public List<SelectOption> getDepartments()
    {        
        system.debug('In getDepartments');
        String [] departments = new String[] {'Sales', 'Support', 'Provisioning', 'TeleSales'};
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 0; i < departments.size(); i++)
        {
            options.add(new SelectOption(departments[i],  departments[i] + ' Department'));
        }
        return options;
    }

    public List<SelectOption> getMonths()
    {        
        system.debug('In getMonths');
        String [] months = new String[] {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        Date this_date = Date.today().toStartOfMonth();
        Date past_date = this_date.addmonths(-5);
        system.debug('this_date - ' + this_date);
        system.debug('past_date - ' + past_date);
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 0; i <= 5; i++)
        {
            Integer j = 0 - i;
            Date dt = this_date.addmonths(j);
            String MMYYYY = months[dt.month() - 1] + ' ' + dt.year();
            options.add(new SelectOption(dt.month() + ' ' + dt.year(), MMYYYY));
        }
        return options;
    }

    public void getChangedMonth()
    {
        system.debug('getChangedMonth - ' + current_month);
        
        String dept;
        User [] manager;
        system.debug('Current Department - ' + current_department);
        system.debug('Current Month - ' + current_month);
        system.debug('Old Month - ' + old_month);

        Integer NoofAccountsUpdated = 0;
        Integer NoofOpportunityUpdated = 0;
        Integer NoofCasesUpdated = 0;

        emailPieData.clear();
        taskPieData.clear();
        barData.clear();

        List<TeamProductivityReportData> manager_team = new List<TeamProductivityReportData> ();

        if(current_month != old_month)
        {
            system.debug('Calling SYNETY API - Change of Month');
            getAllSynetyAccountCallData(current_month);
            old_month = current_month;
        }

        if(current_department.compareTo('Sales') == 0)
        {
            dept = '%' + current_department + ' Manager%';
            manager = [SELECT Name, Phone from User where UserRoleId in (SELECT Id FROM UserRole where name like :dept)];
            for(User u : manager)
            {
                system.debug('Manager - ' + u.name);
                List<User> team = new List<User> ();
                team.add(u);
                team.addAll([Select Name, Phone From User where ManagerId =: u.Id]);
                manager_team.add(new TeamProductivityReportData(u.name, getTeamMembersData(team)));
                system.debug('Whole team - '+ manager_team);
                for(TeamProductivityReportData tprd : manager_team)
                {
                    system.debug('manager_team - ' + manager_team);
                    for(TeamMembersData tmd : tprd.TeamMembers)
                    {
                        system.debug('TeamMembersData - ' + tmd);
                        NoofAccountsUpdated += tmd.NoofAccountsUpdated;
                        NoofOpportunityUpdated += tmd.NoofOpportunityUpdated;
                        NoofCasesUpdated += tmd.NoofCasesUpdated;
                    }
                }
                barData.add(new BarChartData(u.name, NoofAccountsUpdated, NoofOpportunityUpdated, NoofCasesUpdated));
            }
            system.debug('barData - ' + barData);
        }
        else if(current_department.compareTo('Support') == 0 || current_department.compareTo('Provisioning') == 0)
        {
            dept = '% Support Manager%';
            manager = [SELECT Name, Phone from User where UserRoleId in (SELECT Id FROM UserRole where name like :dept)];
            for(User u : manager)
            {
                system.debug('Manager - ' + u.name);
                String team_dept = '%'+current_department+'%';
                List<User> team = new List<User> ();
                team.add(u);
                team.addAll([Select Name, Phone From User where ManagerId =: u.Id and UserRoleId in (SELECT Id FROM UserRole where name like :team_dept)]);
                manager_team.add(new TeamProductivityReportData(u.name, getTeamMembersData(team)));
                system.debug('Whole team - '+ manager_team);
                for(TeamProductivityReportData tprd : manager_team)
                {
                    for(TeamMembersData tmd : tprd.TeamMembers)
                    {
                        NoofAccountsUpdated += tmd.NoofAccountsUpdated;
                        NoofOpportunityUpdated += tmd.NoofOpportunityUpdated;
                        NoofCasesUpdated += tmd.NoofCasesUpdated;
                    }
                }
                barData.add(new BarChartData(u.name, NoofAccountsUpdated, NoofOpportunityUpdated, NoofCasesUpdated));
                system.debug('barData.add - ' + barData);
            }
        }
        else if(current_department.compareTo('TeleSales') == 0)
        {
            LIST<AggregateResult> managerids = [select managerid from user where userrole.name = 'Desk Sales Agent' group by managerid LIMIT 1];
            system.debug('Manager - ' + managerids);
            String m_id = (String)managerids[0].get('managerid');
            system.debug('Manager id - ' + m_id);
            manager = [select name, phone from user where id = :m_id];
            for(User u : manager)
            {
                system.debug('Manager - ' + manager);
                List<User> team = new List<User> ();
                team.add(u);
                team.addAll([Select Name, Phone From User where UserRoleId in (SELECT Id FROM UserRole where name like 'Desk Sales Agent')]);
                manager_team.add(new TeamProductivityReportData(u.name, getTeamMembersData(team)));
                system.debug('Whole team - '+ manager_team);
                for(TeamProductivityReportData tprd : manager_team)
                {
                    for(TeamMembersData tmd : tprd.TeamMembers)
                    {
                        NoofAccountsUpdated += tmd.NoofAccountsUpdated;
                        NoofOpportunityUpdated += tmd.NoofOpportunityUpdated;
                        NoofCasesUpdated += tmd.NoofCasesUpdated;
                    }
                }
                barData.add(new BarChartData(u.name, NoofAccountsUpdated, NoofOpportunityUpdated, NoofCasesUpdated));
                system.debug('barData.add - ' + barData);
            }
            system.debug('barData.add - ' + barData);
        }
        
        reportData = manager_team;
    }
}