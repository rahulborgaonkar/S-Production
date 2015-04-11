@isTest
public class testAPIAuditTrailClass
{
    @isTest 
    static void testAPIAuditTrailClass_Method1()
    {
        account acct = new Account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5, i_customer__c='1');
        insert acct;

        List<APIAuditTrailClass.APIAuditTrailStructure> apt_ats = new List<APIAuditTrailClass.APIAuditTrailStructure>();
        APIAuditTrailClass.APIAuditTrailStructure apt_ats_1 = new APIAuditTrailClass.APIAuditTrailStructure(1, 'Outlook', 'B471366F-1B5F-42D8-887E-240818453CF0', Date.parse('11/01/2013'), 10, 1);

        apt_ats.add(apt_ats_1);

        APIAuditTrailClass.doPost(apt_ats);
    }

    @isTest 
    static void testAPIAuditTrailClass_Method2()
    {
        account acct = new Account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5, i_customer__c='1');
        insert acct;

        List<APIAuditTrailClass.APIAuditTrailStructure> apt_ats = new List<APIAuditTrailClass.APIAuditTrailStructure>();
        APIAuditTrailClass.APIAuditTrailStructure apt_ats_1 = new APIAuditTrailClass.APIAuditTrailStructure(1, 'Outlook', 'B471366F-1B5F-42D8-887E-240818453CF0', Date.parse('11/01/2013'), 10, 1);
        apt_ats.add(apt_ats_1);
        APIAuditTrailClass.doPost(apt_ats);
        APIAuditTrailClass.APIAuditTrailStructure apt_ats_2 = new APIAuditTrailClass.APIAuditTrailStructure(1, 'Outlook', 'B471366F-1B5F-42D8-887E-240818453CF0', Date.parse('11/01/2013'), 10, 1);
        apt_ats.clear();
        apt_ats.add(apt_ats_2);
        APIAuditTrailClass.doPost(apt_ats);
    }

}