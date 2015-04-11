@RestResource(urlMapping='/Account/*')
global class updateAccountCloudCallSectionClass
{
    global class updateAccount
    {
        public String i_customer;
        public String CompanyName;
        public String Email;
        public String Login;
        public String Password;
        public String ContactName;
        public DateTime CreationDate;
        public Decimal last_month_minutes;
        public Decimal TotalCallTime;
        public DateTime SIP_Account_last_used;
        public Integer type;

        global updateAccount()
        {
        }

        global updateAccount(String i_customer, String CompanyName, String Email, String Login, String Password, String ContactName, DateTime CreationDate, Decimal last_month_minutes, Decimal TotalCallTime, DateTime SIP_Account_last_used, Integer type)
        {
            this.i_customer = i_customer;
            this.CompanyName = CompanyName;
            this.Email = Email;
            this.Login = Login;
            this.Password = Password;
            this.ContactName = ContactName;
            this.last_month_minutes = last_month_minutes;
            this.CreationDate = CreationDate;
            this.TotalCallTime = TotalCallTime;
            this.SIP_Account_last_used = SIP_Account_last_used;
            this.type = type;
        }
    }

    @HttpPost
    global static Boolean doPost(List<updateAccount> accts)
    {
        system.debug('Data from API - ' + accts);

        List<Account> AllAccounts = new List<Account>();
        List<String> i_customer = new List<String>();

        Integer mth_yesterday = Date.today().addDays(-1).month();
        Integer mth_today = Date.today().month();

        for(updateAccount uA : accts)
        {
            i_customer.add(uA.i_customer);
        }

        List<Account> acct = [SELECT i_customer__c, name, SIP_Account_first_used__c, SIP_Account_last_used__c, Last_month_minutes__c, This_month_minutes__c FROM account WHERE i_customer__c = :i_customer and type = 'Customer'];
        system.debug('Matching Data from SFDC - ' + acct);
        system.debug('Matching Account Count from SFDC - ' + acct.size());
        
        for(updateAccount uA : accts)
        {
            system.debug('Checking for uA.CompanyName - ' + uA.CompanyName);

            for(Account at : acct)
            {
                if(uA.type == 1 && uA.i_customer == at.i_customer__c)
                {
                    system.debug('Last Month Update');
                    system.debug('uA.CompanyName - ' + uA.CompanyName);
                    system.debug('at.name - ' + at.name);
                    if(uA.CreationDate != null)
                    {
                        at.SIP_Account_first_used__c = uA.CreationDate.date();
                    }
                    if(at.Last_month_minutes__c == null)
                    {
                        at.Last_month_minutes__c = 0;
                    }
                    at.Last_month_minutes__c = math.round(uA.last_month_minutes/60);
                    system.debug('at.Last_month_minutes__c - ' + at.Last_month_minutes__c);
                    system.debug('Last Month Update - ' + at);
                    AllAccounts.add(at);
                }
                else if(uA.type == 2 && uA.i_customer == at.i_customer__c)
                {
                    system.debug('Current Month Update');
                    system.debug('uA.CompanyName - ' + uA.CompanyName);
                    system.debug('at.name - ' + at.name);
                    if(uA.SIP_Account_last_used != null)
                    {
                      at.SIP_Account_last_used__c = uA.SIP_Account_last_used.date();
                    }
                    at.This_month_minutes__c = math.round(uA.TotalCallTime/60);
                    system.debug('at.This_month_minutes__c - ' + at.This_month_minutes__c);
                    system.debug('Current Month Update - ' + at);
                    AllAccounts.add(at);
                }
                else if(uA.type == 3 && uA.i_customer == at.i_customer__c)
                {
                    system.debug('Previous Day Update');
                    system.debug('uA.CompanyName - ' + uA.CompanyName);
                    system.debug('at.name - ' + at.name);
                    if(uA.SIP_Account_last_used != null)
                    {
                      at.SIP_Account_last_used__c = uA.SIP_Account_last_used.date();
                    }
                    if(at.This_month_minutes__c == null)
                    {
                        at.This_month_minutes__c = 0;
                    }
                    if(mth_yesterday != mth_today)
                    {
                        at.Last_month_minutes__c = math.round(at.This_month_minutes__c);
                        at.This_month_minutes__c = math.round(uA.TotalCallTime/60);
                    }
                    else
                    {
                        at.This_month_minutes__c += math.round(uA.TotalCallTime/60);
                    }
                    system.debug('at.SIP_Account_last_used__c - ' + at.SIP_Account_last_used__c);
                    system.debug('at.This_month_minutes__c - ' + at.This_month_minutes__c);
                    system.debug('Previous Day Update - ' + at);
                    AllAccounts.add(at);
                }
                else
                {
                    system.debug('No Account Found in Salesforce - ' + uA.CompanyName);
                }
            }
        }

        system.debug('AllAccounts - ' + AllAccounts);

        if(AllAccounts.size() > 0 )
        {
            Database.SaveResult [] srList = Database.update(AllAccounts, false);

            for(Database.SaveResult sr : srList)
            {
                system.debug('Save Result - ' + sr);
            }
        }

        return true;
    }
}