@isTest
public class testAPICustomerClass
{
    @isTest 
    static void testAPICustomerClass_Method1()
    {
        List<APICustomerClass.APICustomerStructure> api_acc = new List<APICustomerClass.APICustomerStructure>();
        APICustomerClass.APICustomerStructure api_acc_1 = new APICustomerClass.APICustomerStructure(2012, 'Insur Sales Marketing Solutions Ltd', 'barbara@thetelemarketingagency.co.uk', 'barbara@thetelemarketingagency.co.uk', 'Insur Sales Marketing Solutions Ltd', '20klojhum287', Datetime.now());
        api_acc.add(api_acc_1);
        APICustomerClass.doPost(api_acc);
    }

    @isTest 
    static void testAPICustomerClass_Method2()
    {
        List<APICustomerClass.APICustomerStructure> api_acc = new List<APICustomerClass.APICustomerStructure>();
        APICustomerClass.APICustomerStructure api_acc_1 = new APICustomerClass.APICustomerStructure(2012, 'Insur Sales Marketing Solutions Ltd', 'barbara@thetelemarketingagency.co.uk', 'barbara@thetelemarketingagency.co.uk', 'Insur Sales Marketing Solutions Ltd', '20klojhum287', Datetime.now());
        api_acc.add(api_acc_1);
        APICustomerClass.doPost(api_acc);
        APICustomerClass.APICustomerStructure api_acc_2 = new APICustomerClass.APICustomerStructure(2012, 'Insur Sales Marketing Solutions Ltd', 'barbara@thetelemarketingagency.co.uk', 'barbara@thetelemarketingagency.co.uk', 'Insur Sales Marketing Solutions Ltd', '20klojhum287', Datetime.now());
        api_acc.clear();
        api_acc.add(api_acc_2);
        APICustomerClass.doPost(api_acc);
    }

}