@RestResource(urlMapping='/APIAuditTrail/*')
global class APIAuditTrailClass
{
    global class APIAuditTrailStructure
    {
        public ID AccountId;
        public Integer RequestCount;
        public Integer i_customer;
        public String ApplicationName;
        public String License;
        public Date RequestStart;
        public Integer Type;

        global APIAuditTrailStructure()
        {
        }

        global APIAuditTrailStructure(Integer i_customer, String ApplicationName, String License, Date RequestStart, Integer RequestCount, Integer Type)
        {
            this.RequestCount = RequestCount;
            this.i_customer = i_customer;
            this.RequestStart = RequestStart;
            this.License = License;
            this.ApplicationName = ApplicationName;
            this.Type = Type;
        }        
    }

    @HttpPost
    global static Boolean doPost(List<APIAuditTrailStructure> APIAuditTrail)
    {

        system.debug('Data from API - ' + APIAuditTrail);

        Set<ID> all_account = new Set<ID> ();
        Set<Integer> all_i_customer = new Set<Integer> ();
        Set<String> all_i_customer_s = new Set<String> ();
        Set<String> all_licenses = new Set<String> ();
        Set<Integer> all_type_s = new Set<Integer> ();
        List<Integer> all_type_l = new List<Integer> ();
        Set<Date> all_request_date = new Set<Date> ();

        List<API_Audit_Trail__c> apiat_new = new List<API_Audit_Trail__c> ();
        List<API_Audit_Trail__c> apiat_old = new List<API_Audit_Trail__c> ();
        List<API_Audit_Trail__c> apiat_tot = new List<API_Audit_Trail__c> ();
        Map<ID, String> api_map = new Map<ID, String>();

        for(APIAuditTrailStructure ats : APIAuditTrail)
        {
            all_i_customer.add(ats.i_customer);
            all_i_customer_s.add(ats.i_customer.format().replace(',', ''));
            all_licenses.add(ats.license);
            all_type_s.add(ats.Type);
            all_request_date.add(ats.RequestStart);
        }

        all_type_l.addAll(all_type_s);
        
        system.debug('all_i_customer - ' + all_i_customer);
        system.debug('all_licenses - ' + all_licenses);
        system.debug('all_type_l - ' + all_type_l + ' ' + all_type_l.size());

        system.debug('account & customer - ' + [select id, i_customer__c from account where i_customer__c = :all_i_customer_s]);
        List<account> accts_l = new List<account>([select id, i_customer__c from account where i_customer__c = :all_i_customer_s]);
        system.debug('accts_l - ' + accts_l);
        
        Set<account> accts = new Set<account>(accts_l);
        system.debug('accts - ' + accts);

        for(Account a : accts_l)
        {
            api_map.put(a.id, a.i_customer__c);
        }
        system.debug('api_map - ' + api_map);

        for(ID id : api_map.keyset())
        {
            system.debug('Key - ' + id);
            system.debug('Value - ' + api_map.get(id));
            for(APIAuditTrailStructure ats : APIAuditTrail)
            {
                if(api_map.get(id) == ats.i_customer.format().replaceAll(',', ''))
                {
                    system.debug('Found record - ' + ats);
                    API_Audit_Trail__c apiat_1 = new API_Audit_Trail__c();
                    apiat_1.account__c = id;
                    apiat_1.i_customer__c = ats.i_customer;
                    apiat_1.Request_Count__c = ats.RequestCount;
                    apiat_1.Application_Name__c = ats.ApplicationName;
                    apiat_1.License_Key__c = ats.License;
                    apiat_1.Request_Date__c = ats.RequestStart;
                    apiat_new.add(apiat_1);
                }
            }
        }

        system.debug('api_map.keyset() - ' + api_map.keyset());
        all_account.addall(api_map.keyset());
        system.debug('all_account - ' + all_account);

        apiat_old = [select Account__c, Application_Name__c, i_customer__c, License_Key__c, Request_Count__c, Request_Date__c from API_Audit_Trail__c where account__c = :all_account and i_customer__c = :all_i_customer and license_key__c = :all_licenses and request_date__c = :all_request_date];
        system.debug('API_Audit_Trail__c old - ' + apiat_old);

        for(API_Audit_Trail__c apinew : apiat_new)
        {
            for(API_Audit_Trail__c apiold : apiat_old)
            {
                if(apinew.Account__c == apiold.Account__c && apinew.i_customer__c == apiold.i_customer__c && apinew.License_Key__c == apiold.License_Key__c && apinew.Request_Date__c == apiold.Request_Date__c)
                {
                    apinew.id = apiold.id;
                    if(all_type_l[0] == 1)
                    {
                        apinew.Request_Count__c += apiold.Request_Count__c;
                    }
                }
            }
        }
        system.debug('API_Audit_Trail__c new - ' + apiat_new);

        List<Database.upsertResult> uResults = Database.upsert(apiat_new,false);
        system.debug('Database.upsertResult - ' + uResults);

        return true;
    }
}