@RestResource(urlMapping='/APICustomer/*')
global class APICustomerClass
{
    global class APICustomerStructure
    {
        public Integer i_customer;
        public String CompanyName;
        public String Email;
        public String Login;
        public String Name;
        public String Password;
        public Datetime CreationDate;

        global APICustomerStructure()
        {
        }

        global APICustomerStructure(Integer i_customer, String CompanyName, String Email, String Login, String Name, String Password, Datetime CreationDate)
        {
            this.i_customer = i_customer;
            this.CompanyName = CompanyName;
            this.Email = Email;
            this.Login = Login;
            this.Name = Name;
            this.Password = Password;
            this.CreationDate = CreationDate;
        }        
    }

    @HttpPost
    global static Boolean doPost(List<APICustomerStructure> APICustomer)
    {
        List<Double> i_customer = new List<Double>();
        List<API_Customer__c> apic_new = new List<API_Customer__c>();
        Map<Double, API_Customer__c> apic_map = new Map<Double, API_Customer__c>();
        system.debug('Data from API - ' + APICustomer);

        for(APICustomerStructure aps : APICustomer)
        {
            API_Customer__c apic = new API_Customer__c();
            
            apic.i_customer__c = aps.i_customer;
            apic.Name = aps.Name.removeEnd(' ');
            apic.Email__c = aps.Email;
            apic.Login__c = aps.Login;
            apic.CompanyName__c = aps.CompanyName;
            apic.CreationDate__c = aps.CreationDate;
            apic_new.add(apic);
            i_customer.add(apic.i_customer__c);
        }

        system.debug('List<API_Customer__c> apic_new - ' + apic_new);
        system.debug('List<Integer> i_customer - ' + i_customer);

        List<API_Customer__c> apic_old = [SELECT i_customer__c, Name, Login__c, Email__c, CompanyName__c, CreationDate__c  FROM API_Customer__c where i_customer__c in :i_customer];
        system.debug('List<API_Customer__c> apic_old.size - ' + apic_old.size());

        for(API_Customer__c apicold : apic_old)
        {
            apic_map.put(apicold.i_customer__c, apicold);
        }

        system.debug('Map<Integer, API_Customer__c> apic_map - ' + apic_map);

        for(API_Customer__c apicnew : apic_new)
        {
            API_Customer__c apicold = apic_map.get(apicnew.i_customer__c);
            
            if(apicold != null)
            {
                apicnew.id = apicold.id;
                apicnew.i_customer__c = apicold.i_customer__c;
                apicnew.Email__c = apicold.Email__c;
                apicnew.Login__c = apicold.Login__c;
                apicnew.Name = apicold.Name;
                apicnew.CompanyName__c = apicold.CompanyName__C;
                apicnew.CreationDate__c = apicold.CreationDate__c;
            }
        }            

        system.debug('List<API_Customer__c> apic_new - ' + apic_new);
        system.debug('List<API_Customer__c> apic_new.size - ' + apic_new.size());

        upsert apic_new;
        return true;
    }
}