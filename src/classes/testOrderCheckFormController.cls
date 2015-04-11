@isTest(seealldata=true)
private class testOrderCheckFormController
{
    @isTest
    static void testOCFController() 
    {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        acc.bottomline__creditSafeLimit__c = '1000';
        acc.bottomline__creditSafeLastRefreshed__c = system.now().date();
        update acc;
        
        Contact c = new Contact();
        c.LastName = 'Name';
        c.email = 'a@b.com';
        c.AccountId = acc.Id;
        insert c;

        PricebookEntry pbe = [select id, Pricebook2Id from PricebookEntry
                                where Product2.Name = 'CloudCall Communicator'
                                and Pricebook2.IsActive = true
                                and pricebook2.name = 'Standard Price Book'
                                and IsActive = true limit 1];

        
        PricebookEntry pbe2 = [select id, Pricebook2Id from PricebookEntry
                                where Product2.Requires_VoIP__c = true
                                and Pricebook2.IsActive = true
                                and Pricebook2Id =: pbe.Pricebook2Id 
                                and currencyisocode = 'GBP'
                                and IsActive = true limit 1];

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.now().date();
        opp.StageName = 'Closed Won';
        opp.Pricebook2Id = pbe.Pricebook2Id;
        opp.Requires_VoIP__c = true;
        opp.Opportunity_Contact__c = c.Id;
        //opp.currencyisocode = 'GBP';
        insert opp;
        
        system.debug('Step 1');

        List<OpportunityLineItem> lstOli = new List<OpportunityLineItem> ();
                                 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.Quantity = 1;
        oli.UnitPrice = 20;
        lstOli.add(oli);
    
        //insert oli;
        system.debug('Step 1.1');
        
        oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe2.Id;
        oli.Quantity = 1;
        oli.UnitPrice = 20;
        lstOli.add(oli);

        //insert oli;
        system.debug('Step 1.2');
        insert lstOli;
        
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = c.Id;
        ocr.Role = 'Decision Maker';
        ocr.IsPrimary = true;
        insert ocr;
        system.debug('Step 1.3');

        OrderClassController occ = new OrderClassController();

        ApexPages.CurrentPage().getParameters().put('Id',opp.Id);
        acc.Date_of_Last_Credit_Check__c = acc.bottomline__creditSafeLastRefreshed__c;
        update acc;

        occ.processOrder();
        system.debug('Step 4');
        
         
        ApexPages.CurrentPage().getParameters().put('Id',acc.Id);
        occ.creditCheckComplete();
        
        OrderCheckFormController ocfc = new OrderCheckFormController();
        ApexPages.CurrentPage().getParameters().put('i',opp.Id);
        ocfc.boolInfoCorrect = false;
        ocfc.getType();
        ocfc.getBusinessType();
        ocfc.getConnectionType();
        ocfc.getDisplayExistingNumber();
        ocfc.getUseCloudCallCommunicatorSoftPhone();
        ocfc.getNetworkType();
        ocfc.getPOE();
        ocfc.getUseVOIP();
        ocfc.getPortExisting();
        ocfc.getSharedDedicated();
        ocfc.getPhoneSystemConnection();
        ocfc.init();
        ocfc.AccDDINumber = '0777777777'; 
        ocfc.getFetchAccount();

        ocfc.AccName = 'John';
        ocfc.AccDDINumber = '0777777777'; 
        ocfc.AddDevices(); 

        ocfc.AccName = 'Rahul';
        ocfc.AccDDINumber = '0888888888'; 
        ocfc.AddDevices(); 

        ocfc.AccName = 'Tanushree';
        ocfc.AccDDINumber = '0999999999'; 
        ocfc.AddDevices(); 

        ocfc.AccName = 'John';
        ocfc.AccDDINumber = 'John'; 
        ocfc.AddDevices(); 

        List<Order_Check_Form_Detail__c> ordCFD = new List<Order_Check_Form_Detail__c> ();

        ordCFD = [SELECT id, AccName__c, AccDDINumber__c FROM Order_Check_Form_Detail__c WHERE AccName__c = 'John' and Opportunity__c = :opp.Id LIMIT 1];
        
        ocfc.SelectedAccountId = ordCFD[0].id;
        ocfc.DeleteDevices(); 

        ocfc.SelectedAccountId = '';
        ocfc.DeleteDevices(); 

        ocfc.validateForm();
        
        ocfc.SaveProgress();
        ocfc.boolInfoCorrect = true;
        ocfc.objForm.Port_existing_phone_numbers__c = 'No';
        ocfc.SubmitForm();
        
        ocfc.objForm.Business_Type__c = 'Limited Company (Ltd)';
        ocfc.objForm.Company_Registration_No__c = '12345678';
        ocfc.objForm.First_Name__c = 'First';
        ocfc.objForm.Last_Name__c = 'Last';
        ocfc.objForm.Email_Address__c = 'a@b.com';
        ocfc.objForm.Landline_Number__c = '11111111';
        ocfc.objForm.Mobile_Number__c = '11111111';
        
        ocfc.objForm.Site_Name__c = 'Test';
        ocfc.objForm.Site_Contact__c = 'Test';
        ocfc.objForm.Technical_Contact__c = 'Test';
        ocfc.objForm.Type__c = 'Serviced Office';
        ocfc.objForm.Site_Address__c = 'Test';
        ocfc.objForm.Internet_Connection_Type__c = 'Test';
        ocfc.objForm.Upload_Speed_mb_s__c = 10;
        ocfc.objForm.Download_Speed_mb_s__c = 10;
        ocfc.objForm.Shared_or_Dedicated_Internet__c = 'Shared Internet Connection  ';
        ocfc.objForm.Internet_Connection_Provider__c = 'Test';
        ocfc.objForm.Use_Voip__c = 'Yes';
        ocfc.objForm.Network_Type__c = 'Test';
        ocfc.objForm.Make_and_model_of_ethernet_switch__c = 'Test';
        ocfc.objForm.Is_it_POE__c = 'Yes';
        ocfc.objForm.Make_and_model_of_wireless_access_point__c = 'Test';
        ocfc.objForm.Port_existing_phone_numbers__c = 'Yes';
        ocfc.objForm.Phone_numbers_to_be_Ported__c = '3432432';
        ocfc.objForm.New_Phone_Numbers__c = '23432432';
        ocfc.objForm.Display_existing_number_when_dialing_out__c = 'Yes';
        ocfc.objForm.Phone_number_to_be_displayed__c = '32423432';
        ocfc.objForm.Owns_or_has_the_right_to_use_the_number__c = true;
        ocfc.updateProgressPercentage();
        ocfc.SubmitForm();
        
        ocfc.init();
        
        opp.Next_Steps__c = 'Customer - Credit check complete - Awaiting Provisioning';
        update opp;
        
        ocfc.GetPDFAndAttachToOpp();
        
        dsfs__DocuSign_Status__c dss = new dsfs__DocuSign_Status__c();
        dss.dsfs__DocuSign_Envelope_ID__c = '93DE5AC0-4595-4860-89E5-E399EB9995EC';
        dss.dsfs__Opportunity__c = opp.Id;
        dss.dsfs__Envelope_Status__c = 'Sent';
        insert dss;
        
        DocusignConnector.testResult = false;
        DocusignConnector.doVoidEnvelope(opp.Id, 'TEST001', Opp.OwnerId);
        
        dss = new dsfs__DocuSign_Status__c();
        dss.dsfs__DocuSign_Envelope_ID__c = '93DE5AC0-4595-4860-89E5-E399EB9995EZ';
        dss.dsfs__Opportunity__c = opp.Id;
        dss.dsfs__Envelope_Status__c = 'Sent';
        insert dss;
        
        Attachment attDss = new Attachment();
        attDss.ParentId = dss.id;
        attDss.Name = 'Test.PDF';
        attDss.Body = Blob.valueOf('Test PDF');
        insert attDss;

        opp.Next_Steps__c = 'Customer - Credit check complete - Awaiting owner review';
        update opp;
        
        opp.Next_Steps__c = 'Customer - Order DocuSigned - Awaiting BACS payment';
        update opp;
        
        opp.On_going_Payment_Method__c = 'Direct Debit';
        update opp;
        
        opp.Order_Docusigned__c = false;
        update opp;

        dss.dsfs__Envelope_Status__c = 'Completed';
        update dss;

        Test.stopTest();

    }

}