public class cloneWebDemoBookingPerfClass
{
    public String monthlybookings { get; set; }
    public String contact { get; set; }
    private Integer month = 0;
    private Date current_or_past_month;
    public String current_month { get; set; }
    List<String> deskAgentName = new List<String> ();
    Map<Id, User> deskAgent = new Map<Id, User>();

    public String salesperson { get; set; }

    public cloneWebDemoBookingPerfClass()
    {
        current_or_past_month = Date.today().addmonths(month).toStartOfMonth();
        system.debug('current_or_past_month - ' + current_or_past_month);
        deskAgent = new Map<Id, User>([SELECT Id, Name from User WHERE UserRole.name = 'Desk Sales Agent' LIMIT 3]);
        system.debug('deskAgent - ' + deskAgent);
        for(User U : deskagent.values())
        {
            system.debug('User - ' + U);
            deskagentname.add(U.name);
        }
        system.debug('deskagentname - ' + deskagentname);
    }

    public class BarChartData
    {
        public string partner_sales_person { get;set;}
        public integer book_count { get;set;}

        public BarChartData(String partner_sales_person, Integer book_count)
        {
            system.debug('In BarChartData Constructor');

            this.partner_sales_person = partner_sales_person;
            this.book_count = book_count;
        }
    }

    public class CRMBarChartData
    {
        public string crm_product { get;set;}
        public integer crm_count { get;set;}

        public CRMBarChartData(String crm_product, Integer crm_count)
        {
            system.debug('In CRMBarChartData Constructor');

            this.crm_product = crm_product;
            this.crm_count = crm_count;
        }
    }

    public class LineChartData
    {
        public string month_year {get;set;}
        public Integer data1 {get;set;}
        public Integer data2 {get;set;}
        public Integer data3 {get;set;}
        
        public LineChartData(String month_year, Integer data1, Integer data2, Integer data3)
        {
            system.debug('In LineChartData Constructor');

            this.month_year = month_year;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }

    public class BookingSummary
    {
        public Date StartDt {get;set;}
        public Date EndDt {get;set;}
        public string partner_sales_person {get;set;}
        public Integer InProgress {get;set;}
        public Integer Completed {get;set;}
        public Integer Cancelled {get;set;}
        public Integer Deferred {get;set;}
        public Integer Opportunities {get;set;}
        public Decimal CrmSeats {get;set;}
        public Decimal SoldSeats {get;set;}
        
        public BookingSummary(Date StartDt, Date EndDt, String partner_sales_person, Integer InProgress, Integer Completed, Integer Cancelled, Integer Deferred, Integer Opportunities, Decimal CrmSeats, Decimal SoldSeats)
        {
            system.debug('In BookingSummary Constructor');

            this.StartDt = StartDt;
            this.EndDt = EndDt;
            this.partner_sales_person = partner_sales_person;
            this.InProgress = InProgress;
            this.Completed = Completed;
            this.Cancelled = Cancelled;
            this.Deferred = Deferred;
            this.Opportunities = Opportunities;
            this.CrmSeats = CrmSeats;
            this.SoldSeats = SoldSeats;
        }
    }

    public class CRMPieChartData
    {
        public String crm_product_type { get;set;}
        public Integer type_count { get;set;}
        public CRMPieChartData(String crm_product_type, Integer type_count)
        {
            system.debug('In PieChartData Constructor');
            this.crm_product_type = crm_product_type;
            this.type_count = type_count;
        }
    }

    public class AccountList
    {
        public string name { get;set;}
        public string status { get;set;}
        public string owner { get;set;}

        public AccountList(String name, string status, string owner)
        {
            system.debug('In AccountList Constructor');

            this.name = name;
            this.status = status;
            this.owner = owner;
        }
    }

    public class OpportunityList
    {
        public string account_name { get;set;}
        public string opportunity_name { get;set;}
        public integer probability { get;set;}
        public decimal crm_seats { get;set;}

        public OpportunityList(String account_name, string opportunity_name, integer probability, decimal crm_seats)
        {
            system.debug('In OpportunityList Constructor');

            this.account_name = account_name;
            this.opportunity_name = opportunity_name;
            this.probability = probability;
            this.crm_seats = crm_seats;
        }
    }

    public List<Opportunity> getOpportunityList()
    {
        system.debug('IN GETOPPORTUNITYLIST');
        List<Opportunity> opportunity_list = new List<Opportunity>();
        List<Task> web_acct_id = new List<Task>();

        String status = ApexPages.currentPage().getParameters().get('status');
        String desksalesperson = ApexPages.currentPage().getParameters().get('desksalesperson');
        String stdt1 = ApexPages.currentPage().getParameters().get('tdt1');
        String stdt2 = ApexPages.currentPage().getParameters().get('tdt2');
       
        Date tdt1 = Date.parse(stdt1);

        system.debug('Status - ' + status);
        system.debug('desksalesperson - ' + desksalesperson);
        system.debug('tdt1 Month - ' + tdt1.month());
        system.debug('tdt1 Year - ' + tdt1.year());

        if(String.isNotempty(stdt2))
        {
            system.debug('Opportunity stdt2 is not empty');
            Date tdt2 = Date.parse(stdt2);
            system.debug('tdt2 Month - ' + tdt2.month());
            system.debug('tdt2 Year - ' + tdt2.year());

            if(Status == 'Soldseats')
            {
                web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :desksalesperson AND (ReminderDateTime >= :tdt1 AND ReminderDateTime < :tdt2) and accountid in (select accountid from opportunity)];
            }
            else
            {
                web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :desksalesperson and status = 'Completed' AND (ReminderDateTime >= :tdt1 AND ReminderDateTime < :tdt2) and accountid in (select accountid from opportunity)];
            }
            system.debug('web_acct_id - ' + web_acct_id);

        }
        else
        {
            if(Status == 'Soldseats')
            {
                web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :desksalesperson AND (CALENDAR_MONTH(ReminderDateTime ) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year()) and accountid in (select accountid from opportunity)];
            }
            else
            {
                web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :desksalesperson and status = 'Completed' AND (CALENDAR_MONTH(ReminderDateTime ) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year()) and accountid in (select accountid from opportunity)];
            }
            system.debug('web_acct_id - ' + web_acct_id);
        }        

        List<Id> acct_crm_id = new List<Id>();
        for(Task t : web_acct_id)
        {
            acct_crm_id.add(t.accountid);
        }
        system.debug('acct_crm_id - ' + acct_crm_id);
        if(Status == 'Soldseats')
        {
            opportunity_list = [SELECT account.name, name, probability, total_seats__c, account.owner.name from opportunity where accountid = :acct_crm_id and StageName = 'Closed Won'];
        }
        else
        {
            opportunity_list = [SELECT account.name, name, probability, total_seats__c, account.owner.name from opportunity where accountid = :acct_crm_id];
        }
        system.debug('opportunity_list - ' + opportunity_list);

        return opportunity_list;
    }

    public List<Task> getAccountList()
    {
        system.debug('IN GETACCOUNTLIST');
        List<Task> account_list = new List<Task>();

        String status = ApexPages.currentPage().getParameters().get('status');
        String desksalesperson = ApexPages.currentPage().getParameters().get('desksalesperson');
        String stdt1 = ApexPages.currentPage().getParameters().get('tdt1');
        String stdt2 = ApexPages.currentPage().getParameters().get('tdt2');
        system.debug('stdt1 - ' + stdt1);
        system.debug('stdt2 - ' + stdt2);
        Date tdt1 = Date.parse(stdt1);

        system.debug('Status - ' + status);
        system.debug('desksalesperson - ' + desksalesperson);
        system.debug('tdt1 Month - ' + tdt1.month());
        system.debug('tdt1 Year - ' + tdt1.year());

        if(String.isNotempty(stdt2))
        {
            system.debug('Account stdt2 is not empty');
            Date tdt2 = Date.parse(stdt2);
            system.debug('tdt2 Month - ' + tdt2.month());
            system.debug('tdt2 Year - ' + tdt2.year());
            account_list = [SELECT account.name, status, account.owner.name from task where subject = 'Web Demo' and account.partner_sales_person__c = :desksalesperson and status = :status AND (ReminderDateTime >= :tdt1 AND ReminderDateTime < :tdt2)];
        }
        else
        {
            account_list = [SELECT account.name, status, account.owner.name from task where subject = 'Web Demo' and account.partner_sales_person__c = :desksalesperson and status = :status AND (CALENDAR_MONTH(ReminderDateTime) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year())];
        }
        system.debug('account_list - ' + account_list);

        return account_list;
    }
    
    public void getChangedMonth()
    {
        system.debug('getChangedMonth - ' + current_month);
    }

    public List<SelectOption> getMonths() 
    {
        system.debug('In getMonths');

        String [] months = new String[] {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

        Date this_date = Date.today().toStartOfMonth();
        Date past_date = this_date.addmonths(-5);

        system.debug('this_date - ' + this_date);
        system.debug('past_date - ' + past_date);
        system.debug('past_date month & Year - ' + (past_date.month()) + ' ' + past_date.year());
        system.debug('this_date month & Year - ' + (this_date.month()) + ' ' + this_date.year());
        system.debug('All - ' + past_date.month() + ' ' + past_date.year() + ' ' + this_date.month() + ' ' + this_date.year());

        List<SelectOption> options = new List<SelectOption>();

        for(Integer i = 0; i <= 5; i++)
        {
            Integer j = 0 - i;
            Date dt = this_date.addmonths(j);
            String MMYYYY = months[dt.month() - 1] + ' ' + dt.year();
            system.debug('Month - ' + MMYYYY);
            options.add(new SelectOption(dt.month() + ' ' + dt.year(), MMYYYY));
        }

        options.add(new SelectOption(past_date.month() + ' ' + past_date.year() + ' ' + this_date.month() + ' ' + this_date.year(), months[past_date.month() - 1] + ' ' + past_date.year() + ' to ' + months[this_date.month() - 1] + ' ' + this_date.year()));

        return options;
    }

    public List<CRMPieChartData> getCRMPieChart()
    {
        List<CRMPieChartData> aggr_crm_product_type = new List<CRMPieChartData>();
        List<SObject> aggr_crm_data = new List<SObject>();

        aggr_crm_data = [select account.crm_product__r.type, count(id) crm_count from task where account.partner_sales_person__c = :deskagentname AND subject = 'Web Demo' and whoid in (select id from contact where web_demo_booking_date_time__c != null) and account.crm_product__c != null group by account.crm_product__r.type];
        system.debug('Pie Chart aggr_crm_data - ' + aggr_crm_data);

        //aggr_crm_data.clear();

        if(aggr_crm_data.size() > 0)
        {
            aggr_crm_product_type.add(new CRMPieChartData('Bespoke CRM', 0));
            for(sobject w : aggr_crm_data)
            {
                system.debug('W - ' + w);
                if((String)w.get('Type') == 'CRM Software Partner - Integrated' || (String)w.get('Type') == 'CRM Software Partner - Prospect')
                {
                    aggr_crm_product_type.add(new CRMPieChartData((String)w.get('Type'), (Integer)w.get('crm_count')));
                }
                else
                {
                    aggr_crm_product_type[0].type_count++;
                }
            }
        }
        else
        {
            system.debug('Empty Data');
            aggr_crm_product_type.add(new CRMPieChartData('NO CRM', 0));
        }

        if(aggr_crm_product_type[0].type_count == 0 && aggr_crm_product_type[0].crm_product_type != 'NO CRM')
        {
            aggr_crm_product_type.remove(0);
        }
        system.debug('Pie Chart aggr_crm_product_type - ' + aggr_crm_product_type);
        return aggr_crm_product_type;
    }
    
    public List<CRMBarChartData> getCRMBarChart()
    {
        system.debug('INSIDE CRM BAR CHART');

        List<CRMBarChartData> crm_data = new List<CRMBarChartData>();
        List<SObject> aggr_crm_data = new List<SObject>();
        Set<String> int_crm_list = new Set<String>{'Salesforce (Salesforce CRM)', 'Microsoft (Microsoft Dynamics CRM)' , 'Bullhorn CRM', 'FrontRange Solutions (GoldMine)', 'Sage (Sage CRM)', 'CallPro CRM LLC', 'Swiftpage (ACT!)'};

        aggr_crm_data = [select account.crm_product__r.name, count(id) crm_count from task where account.partner_sales_person__c = :deskagentname AND subject = 'Web Demo' and whoid in (select id from contact where web_demo_booking_date_time__c != null) and account.crm_product__c != null group by account.crm_product__r.name];
        system.debug('aggr_crm_data - ' + aggr_crm_data);

        //aggr_crm_data.clear();

        if(aggr_crm_data.size() > 0)
        {
            Integer all_other_crm_cnt = 0;
            for(sobject w : aggr_crm_data)
            {
                system.debug('CRM Name - ' + (String)w.get('name'));
                system.debug('CRM Count - ' + (Integer)w.get('crm_count'));

                if(int_crm_list.contains((String)w.get('name')))
                {
                    crm_data.add(new CRMBarChartData((String)w.get('name'), (Integer)w.get('crm_count')));
                }
                else
                {
                    all_other_crm_cnt += (Integer)w.get('crm_count');
                }                       
            }
            system.debug('all_other_crm_cnt - ' + all_other_crm_cnt);
            crm_data.add(new CRMBarChartData('All Other CRMs', all_other_crm_cnt ));
        }
        else
        {
            system.debug('Empty Data');
            crm_data.add(new CRMBarChartData('NO CRM', 0));
        }
        system.debug('Bar Chart Data - ' + crm_data);
        return crm_data;
    }

    public List<BarChartData> getBarChart()
    {
        system.debug('INSIDE BAR CHART');

        List<SObject> contact_salesp = new List<SObject>();
        List<BarChartData> web_data = new List<BarChartData>();

        contact_salesp = [select account.partner_sales_person__c, count(id) demo_count from task where account.partner_sales_person__c in :deskAgentName and subject = 'Web Demo' and whoid in (select id from contact where web_demo_booking_date_time__c != null) and (CreatedDate >= THIS_MONTH AND CreatedDate < NEXT_MONTH) group by account.partner_sales_person__c];
        system.debug('Get Sales Persons - ' + contact_salesp);

        if(contact_salesp.size() == 0)
        {        
            web_data.add(new BarChartData('No Demos', 0));
        }
        else
        {
            for(sobject w : contact_salesp)
            {
                web_data.add(new BarChartData((String)w.get('partner_sales_person__c'), (Integer)w.get('demo_count')));
            }
        }
        system.debug('web_data init - ' + web_data);

        return web_data;
    }

    public List<LineChartData> getLineChart()
    {
        system.debug('INSIDE LINE CHART');

        Integer months_to_compare = 3;
        Integer no_of_telesalesagent = 3;

        List<SObject> web_contact = new List<SObject>();
        List<LineChartData> web_data = new List<LineChartData>();
        
        String [] months = new String[] {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

        Date tdt1 = current_or_past_month.addmonths(-3);
        Date tdt2 = current_or_past_month.addmonths(1);

        system.debug('tdt1 - ' + tdt1);
        system.debug('tdt2 - ' + tdt2);

        for(Integer mcnt = 0; mcnt <= months_to_compare; mcnt++)
        {
            String month_year = months[tdt1.addmonths(mcnt).month() - 1] + ' ' + tdt1.addmonths(mcnt).year();
            system.debug('month_year - ' + month_year);
            web_data.add(new LineChartData(month_year, 0, 0, 0));
        }
        system.debug('web_data Month and Year added - ' + web_data);

        web_contact = [select account.partner_sales_person__c, calendar_month(reminderdatetime) month, calendar_year(reminderdatetime) year, count(id) bookings from task where account.partner_sales_person__c in :deskAgentName and subject = 'Web Demo' and (reminderdatetime >= :tdt1 AND reminderdatetime <= :tdt2) and whoid in (select id from contact where web_demo_booking_date_time__c != null) GROUP BY account.partner_sales_person__c, calendar_month(reminderdatetime), calendar_year(reminderdatetime) order by calendar_month(reminderdatetime), calendar_year(reminderdatetime)];
        system.debug('web_contact - ' + web_contact);

        Integer salesper_cnt = 1;

        for(String s : deskAgentName)
        {
            system.debug('deskAgentName - ' + s);
            for(sobject w : web_contact)
            {
                system.debug('web_contact - ' + w);

                if(s == w.get('partner_sales_person__c'))
                {
                    system.debug('partner_sales_person__c - ' + s);
                    
                    String mmyy = months[(Integer)w.get('month') - 1]+ ' ' + w.get('year');
                    system.debug('Month & Year - ' + mmyy);
                    for(LineChartData lcd : web_data)
                    {
                        system.debug('salesper_cnt - ' + salesper_cnt);
                        if(lcd.month_year == mmyy && salesper_cnt == 1)
                        {
                            lcd.data1 = (Integer)w.get('bookings');
                        }

                        if(lcd.month_year == mmyy && salesper_cnt == 2)
                        {
                            lcd.data2 = (Integer)w.get('bookings');
                        }

                        if(lcd.month_year == mmyy && salesper_cnt == 3)
                        {
                            lcd.data3 = (Integer)w.get('bookings');
                        }
                    }
                }
            }
            salesper_cnt++;
        }

        system.debug('web_data for Line chart - ' + web_data);

        return web_data;
    }

    public List<Task> getBookingDetails()
    {
        system.debug('INSIDE Web Demo Monthly Bookings');

        List<Id> web_id = new List<Id>();
        List<Task> web_task = new List<Task>();

        web_task = [select account.name, account.crm_product__r.name, account.owner.name, account.partner_sales_person__c, reminderdatetime, createddate, status from task where subject = 'WEB DEMO' and whoid in (select id from contact) AND reminderdatetime >= THIS_WEEK AND account.partner_sales_person__c in :deskAgentName ORDER BY reminderdatetime];

        system.debug('web_task - ' + web_task);
        return web_task;
    }

    public List<BookingSummary> getBookingSummary()
    {
        system.debug('INSIDE getBookingSummary');

        List<SObject> web_task = new List<SObject>();
        List<SObject> web_opp = new List<SObject>();
        List<Task> web_acct_id = new List<Task>();
        List<SObject> web_crm = new List<SObject>();
        List<SObject> web_sold = new List<SObject>();
        List<BookingSummary> web_booking_summary = new List<BookingSummary>();
        String [] month_year = new String []{};
        Date tdt1, tdt2;

        if(current_month == null)
        {
            tdt1 = Date.today().toStartofmonth();
            web_task = [SELECT account.partner_sales_person__c, status, count(subject) cnt from task where subject = 'Web Demo' and account.partner_sales_person__c = :deskagentname and status != null AND (CALENDAR_MONTH(ReminderDateTime ) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year()) group by account.partner_sales_person__c, status];
            system.debug('web_task - ' + web_task);
            web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :deskagentname and status = 'Completed' AND (CALENDAR_MONTH(ReminderDateTime ) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year()) and accountid in (select accountid from opportunity)];
            system.debug('web_acct_id - ' + web_acct_id);

            for(String s : deskagentname)
            {
                web_booking_summary.add(new BookingSummary(tdt1, null, s, 0, 0, 0, 0, 0, 0, 0));
            }
            system.debug('web_booking_summary - ' + web_booking_summary);
        }
        else
        {
            system.debug('current_month - ' + current_month);
            month_year = current_month.split(' ');
            system.debug('month_year - ' + month_year + ' ' + month_year.size());
            if(month_year.size() == 4)
            {
                String stringDate = month_year[1] + '-' + month_year[0] + '-01 00:00:00';
                system.debug('Start Date - ' + stringDate);
                tdt1 = Date.valueOf(stringDate);

                stringDate = month_year[3] + '-' + month_year[2] + '-01 00:00:00';
                system.debug('End Date - ' + stringDate);
                tdt2 = Date.valueOf(stringDate);
                tdt2 = tdt2.toStartofMonth().addmonths(1);
                system.debug('tdt1 - ' + tdt1);
                system.debug('tdt2 - ' + tdt2);

                web_task = [SELECT account.partner_sales_person__c, status, count(subject) cnt from task where subject = 'Web Demo' and account.partner_sales_person__c = :deskagentname and status != null AND (ReminderDateTime >= :tdt1 AND ReminderDateTime < :tdt2) group by account.partner_sales_person__c, status];
                system.debug('All web_task - ' + web_task);
                web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :deskagentname and status = 'Completed' AND (ReminderDateTime >= :tdt1 AND ReminderDateTime < :tdt2) and accountid in (select accountid from opportunity)];
                system.debug('All web_acct_id - ' + web_acct_id);

                for(String s : deskagentname)
                {
                    web_booking_summary.add(new BookingSummary(tdt1, tdt2, s, 0, 0, 0, 0, 0, 0, 0));
                }
                system.debug('web_booking_summary - ' + web_booking_summary);
            }
            else
            {
                String stringDate = month_year[1] + '-' + month_year[0] + '-01 00:00:00';
                system.debug('stringDate - ' + stringDate);
                tdt1 = Date.valueOf(stringDate);
                system.debug('tdt1 - ' + tdt1.month().format() + ' ' + tdt1.year());

                web_task = [SELECT account.partner_sales_person__c, status, count(subject) cnt from task where subject = 'Web Demo' and account.partner_sales_person__c = :deskagentname and status != null AND (CALENDAR_MONTH(ReminderDateTime ) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year()) group by account.partner_sales_person__c, status];
                system.debug('web_task - ' + web_task);
                web_acct_id = [SELECT accountid from task where subject = 'Web Demo' and account.partner_sales_person__c = :deskagentname and status = 'Completed' AND (CALENDAR_MONTH(ReminderDateTime ) = :tdt1.month() AND CALENDAR_YEAR(ReminderDateTime ) = :tdt1.year()) and accountid in (select accountid from opportunity)];
                system.debug('web_acct_id - ' + web_acct_id);

                for(String s : deskagentname)
                {
                    web_booking_summary.add(new BookingSummary(tdt1, null, s, 0, 0, 0, 0, 0, 0, 0));
                }
                system.debug('web_booking_summary - ' + web_booking_summary);
            }
        }            

       
        List<Id> acct_crm_id = new List<Id>();
        for(Task t : web_acct_id)
        {
            acct_crm_id.add(t.accountid);
        }
        system.debug('acct_crm_id - ' + acct_crm_id);

        web_opp = [SELECT account.partner_sales_person__c, count(id) opp_cnt from opportunity where accountid = :acct_crm_id group by account.partner_sales_person__c];
        system.debug('web_opp - ' + web_opp);

        web_crm = [SELECT account.partner_sales_person__c, sum(Total_Seats__c) crmseat_cnt from opportunity where accountid = :acct_crm_id group by account.partner_sales_person__c];
        system.debug('web_crm - ' + web_crm);

        web_sold = [SELECT account.partner_sales_person__c, sum(Total_Seats__c) sold_cnt from opportunity where accountid = :acct_crm_id and stagename = 'Closed Won' group by account.partner_sales_person__c];
        system.debug('web_sold - ' + web_sold);

        for(SObject t : web_task)
        {
            system.debug('Get Task - ' + t);
            for(BookingSummary bs : web_booking_summary)
            {
                if((bs.partner_sales_person == t.get('partner_sales_person__c')) && t.get('status') == 'In Progress')
                {
                    bs.InProgress = (Integer)t.get('cnt');
                }

                if((bs.partner_sales_person == t.get('partner_sales_person__c')) && t.get('status') == 'Completed')
                {
                    bs.Completed =  (Integer)t.get('cnt');
                }

                if((bs.partner_sales_person == t.get('partner_sales_person__c')) && t.get('status') == 'Cancelled')
                {
                    bs.Cancelled =  (Integer)t.get('cnt');
                }

                if((bs.partner_sales_person == t.get('partner_sales_person__c')) && t.get('status') == 'Deferred')
                {
                    bs.Deferred = (Integer)t.get('cnt');
                }
            }
        }

        for(SObject t : web_opp)
        {
            system.debug('Get Opportunity - ' + t);
            for(BookingSummary bs : web_booking_summary)
            {
                if(bs.partner_sales_person == t.get('partner_sales_person__c'))
                {
                    bs.Opportunities = (Integer)t.get('opp_cnt');
                }
            }
        }

        for(SObject t : web_crm)
        {
            system.debug('Get CRM Seats- ' + t);
            for(BookingSummary bs : web_booking_summary)
            {
                if(bs.partner_sales_person == t.get('partner_sales_person__c'))
                {
                    bs.CrmSeats = (Decimal)t.get('crmseat_cnt');
                }
            }
        }

        for(SObject t : web_sold)
        {
            system.debug('Get Sold Seats- ' + t);
            for(BookingSummary bs : web_booking_summary)
            {
                if(bs.partner_sales_person == t.get('partner_sales_person__c'))
                {
                    bs.SoldSeats = (Decimal)t.get('sold_cnt');
                }
            }
        }


        if(web_booking_summary.size() == 0)
        {
            web_booking_summary.add(new BookingSummary(tdt1, null, 'No Booked Demos', 0, 0, 0, 0, 0, 0, 0));
        }
        system.debug('web_booking_summary - ' + web_booking_summary);
        return web_booking_summary;
    }
}