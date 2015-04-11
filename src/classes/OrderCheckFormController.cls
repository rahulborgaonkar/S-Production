public with sharing class OrderCheckFormController
{
    public opportunity objOpp {get; set;}
    public Order_Check_Form__c objForm {get; set;}
    public boolean boolInfoCorrect {get; set;}
    public boolean isOrderCancelled {get; set;}
    
    public boolean showNetworkInfoSection {get; set;}
    public boolean showSiteAddressSection {get; set;}
    public boolean showClickPhoneDeviceSection {get; set;}
    
    public boolean sec1Complete {get; set;}
    public boolean sec2Complete {get; set;}
    public boolean sec3Complete {get; set;}
    public boolean sec4Complete {get; set;}    
    public boolean sec5Complete {get; set;}
    
    public boolean isFormCompleted{get; set;}
    
    public String AccName {get;set;}
    public String AccDDINumber {get;set;}
    public string SelectedAccountId { get; set; }
    
    public Integer Order_Form_Check_Detail_Size {get; set;}

    public PageReference DeleteDevices()
    {
        system.debug('DeleteDevices');
        system.debug('SelectedAccountId - ' + SelectedAccountId);
        system.debug('AccName - ' + AccName);
        system.debug('AccDDINumber - ' + AccDDINumber);
        AccName = ''; 
        AccDDINumber = '';
        
        if(SelectedAccountId != '')
        {
            List<Order_Check_Form_Detail__c> ocfd = new List<Order_Check_Form_Detail__c> ();
            ocfd = [select AccName__c, AccDDINUmber__c from Order_Check_Form_Detail__c where Id = :SelectedAccountId LIMIT 1 ];
            if(ocfd.size() > 0)
            {
                system.debug('Found Details - ' + ocfd);
                delete ocfd;
            }
            else
            {
                system.debug('Empty Object');
            }
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check the value.');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }

    public PageReference AddDevices()
    {
        system.debug('AddDevices');
        system.debug('AccName - ' + AccName);
        system.debug('AccDDINumber - ' + AccDDINumber);
        Id ocf = ApexPages.CurrentPage().getParameters().get('i');
        if(AccName != '' && AccDDINumber != '' && AccDDINumber.isNumeric() == true)
        {
            Order_Check_Form_Detail__c ocfd = new Order_Check_Form_Detail__c();
            ocfd.AccName__c = AccName;
            ocfd.AccDDINumber__c = AccDDINumber;
            ocfd.Opportunity__c = ocf;
            insert ocfd;
            AccName = ''; 
            AccDDINumber = '';
        }
        else
        {
            AccDDINumber = 'Error:Numeric Values Only';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check Click Device (DDI Phone Number). It should be NUMERIC only.');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }


    public List<Order_Check_Form_Detail__c> getFetchAccount()
    {
        system.debug('getFetchAccount');
        List<Order_Check_Form_Detail__c> ocfd = new List<Order_Check_Form_Detail__c> ();
        String ocf = ApexPages.CurrentPage().getParameters().get('i');
        ocfd = [select AccName__c, AccDDINUmber__c from Order_Check_Form_Detail__c where Opportunity__c = :ocf order by LastModifiedDate desc];
        if(AccDDINumber !=null && AccDDINumber.isNumeric() == true)
        {
            AccName = ''; 
            AccDDINumber = '';
        }
        system.debug('Order Check Form - ' + objForm);
        return ocfd;
    }

    
    public List<SelectOption> getType() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getConnectionType() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Internet_Connection_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }

    public List<SelectOption> getDisplayExistingNumber() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Display_existing_number_when_dialing_out__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }

    public List<SelectOption> getUseCloudCallCommunicatorSoftPhone() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.CloudCall_Communicator_SoftPhone__c.getDescribe();
        List<Schema.PicklistEntry> ccs = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ccs)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        system.debug('getUseCloudCallCommunicatorSoftPhone - ' + options);
        return options;
    }

    public List<SelectOption> getPOE() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Is_it_POE__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getNetworkType() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Network_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getPortExisting() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Port_existing_phone_numbers__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getSharedDedicated() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Shared_or_Dedicated_Internet__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getUseVOIP() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Use_VOIP__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getBusinessType() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Account.Business_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getPhoneSystemConnection() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Order_Check_Form__c.Phone_System_Connection__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
        
    public void init()
    {
        showSiteAddressSection = true;
        showNetworkInfoSection = true;
        isFormCompleted = false;
        isOrderCancelled = false;
        
        oppId = ApexPages.CurrentPage().getParameters().get('i');
        if(oppId != null && oppId != '')
        {
            list<Opportunity> lObjOpp = [select id, name, account.name, accountid, account.owner.name,
                                                                account.Company_Registration_No__c, account.Business_Type__c, 
                                                                order_number__c, Requires_VoIP__c, Next_Steps__c
                                        from Opportunity where Id =: oppId limit 1];
            
            if(lObjOpp.size() > 0)
            {
                objOpp = lObjOpp[0];
                string accountName = objOpp.Account.Name;
                string accountId = objOpp.AccountId;
                showNetworkInfoSection = objOpp.Requires_VoIP__c;
                
                if(objOpp.Next_Steps__c == 'Customer: Order Cancelled')
                {
                        isOrderCancelled = true;
                        return;
                }
                
                List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem 
                                                where pricebookentry.product2.Type_of_Product_Service__c in 
                                                ('Hardware Purchase', 'Hardware Order', 'Hardware Rental', 'Professional Services')
                                                and OpportunityId =: objOpp.Id];
                
                if(lstOLI.size() > 0)
                        showSiteAddressSection = true;
                else
                        showSiteAddressSection = false;

                Order_Form_Check_Detail_Size = [select AccName__c, AccDDINUmber__c from Order_Check_Form_Detail__c where Opportunity__c = :oppId order by LastModifiedDate desc].size();
                system.debug('Order_Form_Check_Detail_Size - ' + Order_Form_Check_Detail_Size);
                
                list<Order_Check_Form__c> lstForms = 
                        [SELECT Status__c, Percentage_Complete__c, Display_existing_number_when_dialing_out__c, CloudCall_Communicator_SoftPhone__c,
                        Download_Speed_mb_s__c,Email_Address__c,First_Name__c,Id,Internet_Connection_Provider__c,
                        Internet_Connection_Type__c,Is_it_POE__c,Landline_Number__c,Last_Name__c,
                        Make_and_model_of_ethernet_switch__c,Make_and_model_of_wireless_access_point__c,
                        Mobile_Number__c,Network_Type__c,Phone_numbers_to_be_Ported__c,Phone_number_to_be_displayed__c,
                        Port_existing_phone_numbers__c,Shared_or_Dedicated_Internet__c,Site_Address__c,Site_Contact__c,
                        Site_Name__c,Technical_Contact__c,Type__c,Upload_Speed_mb_s__c, Use_VOIP__c,
                        Serviced_Site_Network_Info_Sent__c, Owns_or_has_the_right_to_use_the_number__c,
                        Copy_Attachment__c, Company_Registration_No__c, Business_Type__c, New_Phone_Numbers__c,
                        Second_Site_info_Additional_Notes__c, Additional_Network_Information__c,
                        Phone_System_Connection__c
                        FROM Order_Check_Form__c 
                        where Opportunity__c =: oppId];
                
                if(lstForms.size() > 0)
                {
                    objForm = lstForms[0];
                    if(objForm.Status__c == 'Completed')
                        isFormCompleted = true;
                }
                else
                {
                    objForm = new Order_Check_Form__c(Status__c = 'Not Complete', Percentage_Complete__c = 0);
                    objForm.Opportunity__c = oppId;
                    objForm.Business_Type__c = objOpp.Account.Business_Type__c;
                    objForm.Company_Registration_No__c = objOpp.Account.Company_Registration_No__c;
                    
                    if(objOpp.Requires_VoIP__c)
                        objForm.Use_VOIP__c = 'Yes';
                }
                
                if(objForm.Status__c != 'Completed')
                        this.updateProgressPercentage();
            }
            
        }        
        else
        {
            //show message that url is incorrect
            objOpp = null;
        }
        system.debug('init - ' + objForm);
    }
    
    public void SaveProgress()
    {
        updateProgressPercentage();
        if(saveForm())
        {
            //redirect
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,
                'The data entered on the form has been saved. You will have to submit the form after completing it to proceed with the order.');
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void updateProgressPercentage()
    {
        sec1Complete = true;
        sec2Complete = true;
        sec3Complete = true;
        sec4Complete = true;
        
        integer totalSections = 2;
        
        if(showSiteAddressSection)
                totalSections++;
        
        if(showNetworkInfoSection)
                totalSections++;
        
        integer sectionsCompleted = 0;
        
        boolean nextSectionCompleted = true;    
        if(objForm.Business_Type__c == '' || 
        objForm.Business_Type__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Company_Registration_No__c == '' || 
        objForm.Company_Registration_No__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.First_Name__c == '' || 
        objForm.First_Name__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Last_Name__c == '' || 
        objForm.Last_Name__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Email_Address__c == '' || 
        objForm.Email_Address__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Landline_Number__c == '' || 
        objForm.Landline_Number__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Mobile_Number__c == '' || 
        objForm.Mobile_Number__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(nextSectionCompleted)
                sectionsCompleted++;
        else
                sec1Complete = false;
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,
        //        'Section 1 completed = '+nextSectionCompleted);
        //ApexPages.addMessage(myMsg);
            
        ////for site info validation
        if(showSiteAddressSection)
        {
                nextSectionCompleted = true;
                if(objForm.Site_Name__c == '' || 
                        objForm.Site_Name__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Site_Contact__c == '' || 
                        objForm.Site_Contact__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Technical_Contact__c == '' || 
                        objForm.Technical_Contact__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Type__c == '' || 
                        objForm.Type__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Site_Address__c == '' || 
                        objForm.Site_Address__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(nextSectionCompleted)
                        sectionsCompleted++;
                else
                        sec2Complete = false;
        }        
        
        //myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,
        //        'Section 2 completed = '+nextSectionCompleted);
        //ApexPages.addMessage(myMsg);
        
        ////for network info validation
        if(showNetworkInfoSection)
        {
                nextSectionCompleted = true;
                
                if(objForm.Internet_Connection_Type__c == '' || 
                        objForm.Internet_Connection_Type__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Upload_Speed_mb_s__c == null || objForm.Upload_Speed_mb_s__c <= 0)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Download_Speed_mb_s__c == null || objForm.Download_Speed_mb_s__c <= 0)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Shared_or_Dedicated_Internet__c == '' || 
                        objForm.Shared_or_Dedicated_Internet__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Internet_Connection_Provider__c == '' || 
                        objForm.Internet_Connection_Provider__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Use_Voip__c == '' || 
                        objForm.Use_Voip__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Network_Type__c == '' || 
                        objForm.Network_Type__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Make_and_model_of_ethernet_switch__c == '' || 
                        objForm.Make_and_model_of_ethernet_switch__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Is_it_POE__c == '' || 
                        objForm.Is_it_POE__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(objForm.Make_and_model_of_wireless_access_point__c == '' || 
                        objForm.Make_and_model_of_wireless_access_point__c == null)
                {
                    nextSectionCompleted = false;
                }
                
                if(nextSectionCompleted)
                        sectionsCompleted++;
                else
                        sec3Complete = false;
                
        }
        
        //myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,
        //        'Section 3 completed = '+nextSectionCompleted);
        //ApexPages.addMessage(myMsg);
        
        nextSectionCompleted = true;
        if(objForm.Port_existing_phone_numbers__c == '' || 
                objForm.Port_existing_phone_numbers__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Port_existing_phone_numbers__c == 'Yes' && 
                (objForm.Phone_numbers_to_be_Ported__c == '' || objForm.Phone_numbers_to_be_Ported__c == null))
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Port_existing_phone_numbers__c == 'No' && 
                (objForm.New_Phone_Numbers__c == '' || objForm.New_Phone_Numbers__c == null))
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Display_existing_number_when_dialing_out__c == '' || 
                objForm.Display_existing_number_when_dialing_out__c == null)
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Display_existing_number_when_dialing_out__c == 'Yes' && 
                (objForm.Phone_number_to_be_displayed__c == '' || objForm.Phone_number_to_be_displayed__c == null))
        {
            nextSectionCompleted = false;
        }
        
        if(objForm.Display_existing_number_when_dialing_out__c == 'Yes' && 
                objForm.Owns_or_has_the_right_to_use_the_number__c == false)
        {
            nextSectionCompleted = false;
        }       
        
        if(nextSectionCompleted)
                sectionsCompleted++;
        else
                sec4Complete = false;
        
        //myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,
        //        'Section 4 completed = '+nextSectionCompleted);
        //ApexPages.addMessage(myMsg);
        
        
        objForm.Percentage_Complete__c = (Integer)((decimal.valueof(sectionsCompleted) / decimal.valueof(totalSections)) * decimal.valueof(100));
        if(objForm.Percentage_Complete__c == 100)
                objForm.Status__c = 'Completed Not Submitted';
        else
                objForm.Status__c = 'Not Complete';
        
        //myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,
        //        sectionsCompleted + ' / '+totalSections+' * 100 = '+objForm.Percentage_Complete__c);
        //ApexPages.addMessage(myMsg);
        
                  
    }
    
    public boolean validateForm()
    {
        boolean errors = false;
        
        boolean nextSectionCompleted = true;    
        if(objForm.Business_Type__c == '' || 
        objForm.Business_Type__c == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please Select Business Type.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Company_Registration_No__c == '' || 
        objForm.Company_Registration_No__c == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Company Registration # is Required.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.First_Name__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'First Name is Required.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Last_Name__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Last Name is Required.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Email_Address__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Email Address is Required.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Landline_Number__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Landline Number is Required.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Mobile_Number__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Mobile Number is Required.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        ////for site info validation
        if(showSiteAddressSection)
        {
                if(objForm.Site_Name__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Site Name is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Site_Contact__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Site Contact is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Technical_Contact__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Technical Contact is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Type__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Site Type is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Site_Address__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Site Address is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
        }        
        
        ////for network info validation
        if(showNetworkInfoSection)
        {
                if(objForm.Internet_Connection_Type__c == '' || 
                        objForm.Internet_Connection_Type__c == null)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please select a Internet Connection Type.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Upload_Speed_mb_s__c == null || objForm.Upload_Speed_mb_s__c <= 0)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please enter valid upload speed.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Download_Speed_mb_s__c == null || objForm.Download_Speed_mb_s__c <= 0)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please enter valid download speed.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Shared_or_Dedicated_Internet__c == '' || 
                        objForm.Shared_or_Dedicated_Internet__c == null)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please select if you have a Shared or Dedicated Internet Connection.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Internet_Connection_Provider__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Internet Connection Provider is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Use_Voip__c == '' || 
                        objForm.Use_Voip__c == null)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please select if you want to Use VoIP or not.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Network_Type__c == '' || 
                        objForm.Network_Type__c == null)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please select a Network Type.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Make_and_model_of_ethernet_switch__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Make and model of your ethernet switch is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Is_it_POE__c == '' || 
                        objForm.Is_it_POE__c == null)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Please select if your Network is POE or not.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
                
                if(objForm.Make_and_model_of_wireless_access_point__c == '')
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Make and model of your wireless access point is Required.');
                    ApexPages.addMessage(myMsg);
                    errors = true;
                }
            }
        
        if(objForm.Port_existing_phone_numbers__c == '' || 
                objForm.Port_existing_phone_numbers__c == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please select if you want to port your existing phone numbers or not.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Port_existing_phone_numbers__c == 'Yes' && 
                objForm.Phone_numbers_to_be_Ported__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please enter your existing phone numbers that you want ported.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Port_existing_phone_numbers__c == 'No' && 
                (objForm.New_Phone_Numbers__c == '' || objForm.New_Phone_Numbers__c == null))
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please enter the additional new phone numbers that you require.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Display_existing_number_when_dialing_out__c == '' || 
                objForm.Display_existing_number_when_dialing_out__c == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please select if you want to display existing phone number when dialing out.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Display_existing_number_when_dialing_out__c == 'Yes' && 
                objForm.Phone_number_to_be_displayed__c == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please enter phone number that you want displayed when dialing out.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        if(objForm.Display_existing_number_when_dialing_out__c == 'Yes' && 
                objForm.Owns_or_has_the_right_to_use_the_number__c == false)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Please tick the box that confirms that you own or have the right to use the dialing out phone number.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }       
        
        if(!boolInfoCorrect)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'You must tick the box that confirms that the information supplied is true and accurate.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
            
        return !errors;
    }

    public PageReference SubmitForm()
    {
        if(objOpp != null && isFormCompleted == false)
        {
            //objOpp.Next_Steps__c = 'Customer - Network checks completed - Awaiting DocuSign';
            //update objOpp;
            
            if(validateForm())
            {
                objForm.Percentage_Complete__c = 100;
                objForm.Status__c = 'Completed';
                if(saveForm())
                {
                        
                         
                    Opp_Order_Check_List__c newObj = new Opp_Order_Check_List__c(Name = objOpp.Id);
                    insert newObj;
                    
                    isFormCompleted = true;
                    
                    return New PageReference('/orders/GenerateOrderCheckFormPDF?i=' + objOpp.Id ); 
                }
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'The form cannot be submitted due to the errors listed above.');
                ApexPages.addMessage(myMsg);
            }            
        }
        
        return null;
    }
    
    public boolean saveForm()
    {
        try
        {
                if(objForm.Port_existing_phone_numbers__c != 'Yes')
                        objForm.Phone_numbers_to_be_Ported__c = '';
                
                if(objForm.Display_existing_number_when_dialing_out__c != 'Yes')
                        objForm.Phone_number_to_be_displayed__c = '';
                
                
            upsert objForm; 
        }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
            return false;
        }
        
        return true;
    }
    
    public string oppId {get; set;}
    
    public PageReference GetPDFAndAttachToOpp()
    {
        oppId = ApexPages.CurrentPage().getParameters().get('i');
        if(oppId != null && oppId != '')
        {
            list<Order_Check_Form__c> lstForms = 
                    [SELECT Id, Copy_Attachment__c 
                    FROM Order_Check_Form__c 
                    where Opportunity__c =: oppId];
            
            if(lstForms.size() > 0)
            {
                objForm = lstForms[0];
                
                PageReference pr = New PageReference('/orders/OrderCheckFormPDF?i=' + oppId ); 
                        blob pdf = null;
                        if(!Test.isRunningTest())
                        {
                                pdf = pr.getContentAsPDF();
                        }
                        else
                        {
                                pdf = Blob.valueOf('Test PDF');
                        }
                        
                        Attachment attachment1 = new Attachment();
                        attachment1.ParentId = objForm.Id;//objOpp.Id;
                        attachment1.Body = pdf;
                        attachment1.Name = 'Customer Order Check Form.pdf';
                        
                        insert attachment1;
                        
                        objForm.Copy_Attachment__c = true;
                        update objForm;
            }
        }
                
                DateTime d = System.now();
        String timestamp = ''+ d.year() + '-' +
        d.month() + '-' +
        d.day() + '\'T\'' +
        d.hour() + ':' +
        d.minute() + ':' +
        d.second() + '.' +
        d.millisecond() + '\'Z\'';
        String timeFormat = d.formatGmt(timestamp);

        String urlEncodedTimestamp = EncodingUtil.urlEncode(timestamp, 'UTF-8');
      
        return null;//New PageReference('/orders/OrderCheckForm?i=' + oppId + '&'+urlEncodedTimestamp ); 
        
    }
}