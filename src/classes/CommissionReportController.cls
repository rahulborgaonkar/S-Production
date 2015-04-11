public with sharing class CommissionReportController 
{
	public boolean isAllowed {get; set;}
	
	public string monthStart {get; set;}
	public string monthEnd {get; set;}
	public string userName {get; set;}
	public string userNamesForReport {get; set;}
	
	public List<SelectOption> lstUsers {get; set;}
	public List<SelectOption> lstMonths {get; set;}
	public string selUser {get; set;}
	public string selMonth {get; set;}
	
	public boolean showResult {get; set;}
	public string reportTitle {get; set;}
	
	public string[] arrMonths = new string[]{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
	
	//commission calculated
	public double HardwareSold {get; set;}
	public double NewSeatsSold {get; set;}
	public double PaidSeats {get; set;}
	public double PaidSeatsCommission {get; set;}
	public double HardwareCommission {get; set;}
	public double Clawback {get; set;}
	public double TotalCommission {get; set;}
	//config values for telesales
	public double DemosBooked {get; set;}
	public double DemosCompleted {get; set;}
	public double PaidCompDemos {get; set;}
	public double PaidCompDemosCommission {get; set;}
	
	//config values
	public double MinSeats {get; set;}
	public double PaidSeatsCommRate {get; set;}
	public double OTETarget {get; set;}
	public double OTEBonus {get; set;}
	public double HardwareCommRate {get; set;}
	public string role {get; set;}
	public string team {get; set;}
	public double adjustmentSeats {get; set;}
	public string adjustmentNotes {get; set;}
	public boolean doAdjustment {get; set;}
	//config values for telesales
	public double minDemos {get; set;}
	public double DemosCommRate {get; set;}
	
	public CommissionReportController()
	{
		doAdjustment = false;
	}
	
	public PageReference cancelAdjustment()
	{
		return backToReport();
	}
	
	public PageReference voidAdjustment()
	{
		
			Date dSelMonth = date.valueOf(selMonth);
			List<Commission_Setup__c> lCS = [SELECT Id, Adjusted_License_Count__c,
											Adjustment_Notes__c
											FROM Commission_Setup__c
											where Sales_Rep__c =: selUser 
											and Month_of_Year__c =: dSelMonth];
		
			if(lCS.size() > 0)
			{
				lCS[0].Adjusted_License_Count__c = null;
				lCS[0].Adjustment_Notes__c = null;
				
				update lCS[0];
			}
		
		
		return backToReport();
	}
	
	public PageReference commitAdjustment()
	{
		if(adjustmentSeats == null || 
			adjustmentNotes == null || adjustmentNotes == '')
		{
			if (Apexpages.currentPage() != null) 
            {
                apexPages.Message msg = new apexPages.Message(apexPages.Severity.Error,'Please enter new license count and reason for the adjustment in the notes area.');
                apexPages.addMessage(msg);
            }
			return null;	
		}
		else
		{
			Date dSelMonth = date.valueOf(selMonth);
			List<Commission_Setup__c> lCS = [SELECT Id, Adjusted_License_Count__c,
											Adjustment_Notes__c
											FROM Commission_Setup__c
											where Sales_Rep__c =: selUser 
											and Month_of_Year__c =: dSelMonth];
		
			if(lCS.size() > 0)
			{
				lCS[0].Adjusted_License_Count__c = adjustmentSeats;
				lCS[0].Adjustment_Notes__c = adjustmentNotes;
				
				update lCS[0];
			}
		}
		
		return backToReport();
	}
	
	public PageReference backToReport()
	{
		PageReference pg = new PageReference('/apex/CommissionReport?runReport=1&user='+selUser+'&month='+selMonth);
		pg.setRedirect(true); 
		return pg;
	}
	
	public void initAdjustment()
	{
		doAdjustment = true;
		init();
		selUser = apexPages.currentPage().getParameters().get('user');
		selMonth = apexPages.currentPage().getParameters().get('month');
		runReport();
		if(UserInfo.getUserName().contains('mohsin.raza@synety.com') || 
			UserInfo.getUserName().contains('mark.seemann@synety.com') || 
			UserInfo.getUserName().contains('simon.cleaver@synety.com') || 
			UserInfo.getUserName().contains('paul.williams@synety.com')
			)
		{
			isAllowed = true;
		}
		else
		{
			isAllowed = false;
		}
		
	}
	
	public void init()
	{
		selUser = '';
		selMonth = '';
		showResult = false;
		lstUsers = new List<SelectOption>();
		lstMonths = new List<SelectOption>();
		
		lstUsers.add(new selectoption('', 'Select...'));
		lstMonths.add(new selectoption('', 'Select...'));
		
		List<User> lUsers = null;
		
		if(UserInfo.getUserName().contains('mohsin.raza@synety.com') || 
			UserInfo.getUserName().contains('mark.seemann@synety.com') || 
			UserInfo.getUserName().contains('rachel.harris@synety.com') ||
			UserInfo.getUserName().contains('simon.cleaver@synety.com') || 
			UserInfo.getUserName().contains('paul.williams@synety.com')
			)
		{
			lUsers = [select Id, Name from User where isActive = true and  
					UserRole.Name in ('Desk Sales Agent', 'Senior Sales Managers', 'Account Managers')
					and Username not in ('sales@synety.com')
					order by Name];
			isAllowed = true;
		}
		else
		{
			lUsers = [select Id, Name from User where isActive = true and  
					UserRole.Name in ('Desk Sales Agent', 'Senior Sales Managers', 'Account Managers')
					and Id =: UserInfo.getUserId()];
			if(lUsers.size() > 0)
				isAllowed = true;
			else
				isAllowed = false;
		}
		for(User u: lUsers)
		{
			lstUsers.add(new selectoption(u.Id, u.Name));
		}
		
		for(integer a=0; a<12; a++)
		{
			DateTime dt = DateTime.now().addMonths(0-a);
			string monthVal = string.valueOf(dt.year()) + '-' + string.valueOf(dt.month()) + '-01';
			string monthLbl = arrMonths[dt.month()-1] + ' ' + string.valueOf(dt.year());
			
			lstMonths.add(new selectoption(monthVal, monthLbl));
		}
		
		if(apexPages.currentPage().getParameters().get('runReport') != null)
		{
			selUser = apexPages.currentPage().getParameters().get('user');
			selMonth = apexPages.currentPage().getParameters().get('month');
			runReport();
		}
	}
	
	public string reportBody {get; set;}
	public void GenerateReportAndExport()
	{
		if(UserInfo.getUserName().contains('mohsin.raza@synety.com') || 
			UserInfo.getUserName().contains('mark.seemann@synety.com') || 
			UserInfo.getUserName().contains('rachel.harris@synety.com') ||
			UserInfo.getUserName().contains('simon.cleaver@synety.com') || 
			UserInfo.getUserName().contains('paul.williams@synety.com')
			)
		{
			isAllowed=true;
	    	
	    	selUser = '';
			selMonth = '';
			showResult = false;
			lstUsers = new List<SelectOption>();
			lstMonths = new List<SelectOption>();
			
			lstUsers.add(new selectoption('', 'Select...'));
			lstMonths.add(new selectoption('', 'Select...'));
			
			List<User> lUsers = null;
			
			
			
			for(integer a=0; a<12; a++)
			{
				DateTime dt = DateTime.now().addMonths(0-a);
				string monthVal = string.valueOf(dt.year()) + '-' + string.valueOf(dt.month()) + '-01';
				string monthLbl = arrMonths[dt.month()-1] + ' ' + string.valueOf(dt.year());
				
				lstMonths.add(new selectoption(monthVal, monthLbl));
			}
			
			selMonth = apexPages.currentPage().getParameters().get('month');
			
			CommissionReportSchedule crc = new CommissionReportSchedule();
	    	reportBody = crc.GetReportBody(SelMonth);
		}
		else
		{
			isAllowed=false;
		}
	}
	
	public void GenerateReport()
	{
		if(UserInfo.getUserName().contains('mohsin.raza@synety.com') || 
			UserInfo.getUserName().contains('mark.seemann@synety.com') || 
			UserInfo.getUserName().contains('rachel.harris@synety.com') ||
			UserInfo.getUserName().contains('simon.cleaver@synety.com') || 
			UserInfo.getUserName().contains('paul.williams@synety.com')
			)
		{
			//string month = System.today().addMonths(-1).year() + '-' 
	    	//				+ System.today().addMonths(-1).month() + '-01';
	    	CommissionReportSchedule crc = new CommissionReportSchedule();
	    	crc.GenerateReportAndEmail(SelMonth);
	    	
	    	if (Apexpages.currentPage() != null) 
            {
                apexPages.Message msg = new apexPages.Message(apexPages.Severity.Confirm,'The report has been generated and emailed. Please check your inbox.');
                apexPages.addMessage(msg);
            }
		}
		else
		{
			if (Apexpages.currentPage() != null) 
            {
                apexPages.Message msg = new apexPages.Message(apexPages.Severity.Error,'Unauthorized access not allowed.');
                apexPages.addMessage(msg);
            }
		}
	}
	
	public void runReport()
	{
		if(selUser == '' || selMonth == ''
			|| selUser == null || selMonth == null)
		{
			apexPages.Message msg = new apexPages.Message(apexPages.Severity.Error,'Please select all report parameters.');
            apexPages.addMessage(msg);
            showResult = false;	
			return;
		}
		
		//Date dSelMonth = date.valueOf(selMonth);
		string result = '';
		
		if(doAdjustment)		
			result = this.calculateCommission(selUser,SelMonth, false);
		else
			result = this.calculateCommission(selUser,SelMonth, true);
			
		if(result != null)
		{
			showResult = false;	
			apexPages.Message msg = new apexPages.Message(apexPages.Severity.Error,result);
            apexPages.addMessage(msg);
			return;
		}
		
		showResult = true;	
		
	}
	
	public PageReference gotoAdjustmentScreen()
	{
		PageReference pg = new PageReference('/apex/AdjustLicenseCount?user='+selUser+'&month='+selMonth);
		pg.setRedirect(true);  
		return pg;
	}
	
	public string calculateCommission(String userId, string month, boolean calcTeam)
	{
		
		
		Date dSelMonth = date.valueOf(month);
		List<Commission_Setup__c> lCS = [SELECT Commission_Per_Seat_after_min__c,
												Hardware_Commission__c,
												Min_Seats__c,
												Month_of_Year__c,
												OTE_Bonus__c,
												OTE_target__c,
												Sales_Rep__c,
												Team__c, Role__c,
												Last_Month_Commission_Clawback__c,
												Adjusted_License_Count__c,
												Adjustment_Notes__c,
												Min_Completed_Demos_Required__c,
												Commission_Per_Demo_after_min__c 
										FROM Commission_Setup__c
										where Sales_Rep__c =: userId 
										and Month_of_Year__c =: dSelMonth];
		
		if(lCS.size()  == 0)
		{	
			showResult = false;
            return 'The commission config values have not been setup for this sales rep and month. Please contact system administrator about this.';
		}
		
		OTEBonus = 0;
		
		HardwareSold = 0;
		NewSeatsSold = 0;
		PaidSeats = 0;
		PaidSeatsCommission = 0;
		HardwareCommission = 0;
		TotalCommission = 0;
		
		DemosBooked = 0;
		DemosCompleted = 0;
		PaidCompDemos = 0;
		PaidCompDemosCommission = 0;
		minDemos = 0;
		DemosCommRate = 0;
		
		role = lCS[0].Role__c;
		team = lCS[0].Team__c;
		Clawback = lCS[0].Last_Month_Commission_Clawback__c;
		
		showResult = true;
		if(Clawback == null)
			Clawback = 0;
			
		
		string monthName = '';
		
		for(SelectOption so: lstUsers)
		{
			if(userId == so.getValue())
			{
				userName = so.getLabel();
			}
		}
		
		for(SelectOption so: lstMonths)
		{
			if(month == so.getValue())
			{
				monthName = so.getLabel();
			}
		}
		
		monthStart = dSelMonth.month() + '/01/' + dSelMonth.year();
		Date monthEndDate = dSelMonth.addMonths(1).addDays(-1);
		monthEnd = monthEndDate.month() + '/' + monthEndDate.day() + '/' + monthEndDate.year();
		
		reportTitle = 'Commission for ' + userName + ' - ' + monthName;
		
			
		if(role == 'Telesales Rep')
		{
			DemosCommRate = lCS[0].Commission_Per_Demo_after_min__c;
			minDemos = lCS[0].Min_Completed_Demos_Required__c;
		
			list<Contact> lDemoContacts = [SELECT id, 
												(SELECT whoid, status FROM tasks 
												WHERE subject = 'WEB DEMO' 
												AND whoid != null 
												and CALENDAR_MONTH(CreatedDate) =: dSelMonth.month()
												and CALENDAR_YEAR(CreatedDate) =: dSelMonth.year()
												) 
											FROM contact 
											WHERE account.partner_sales_person__c =: userName
											AND account.partner_sales_person__c != null];
			system.debug('lDemoContacts='+lDemoContacts);
			for(Contact c: lDemoContacts)
			{
				for(Task t: c.Tasks)
				{
					DemosBooked++;
					if(t.Status == 'Completed')
						DemosCompleted++;
				}
			}
			
			if(DemosCompleted > minDemos)
			{
				PaidCompDemos = DemosCompleted - minDemos;
				PaidCompDemosCommission = PaidCompDemos * DemosCommRate;
			}
		}
		else
		{
			MinSeats = lCS[0].Min_Seats__c;
			PaidSeatsCommRate = lCS[0].Commission_Per_Seat_after_min__c;
			HardwareCommRate = lCS[0].Hardware_Commission__c;
			OTEBonus = lCS[0].OTE_Bonus__c;
			OTETarget = lCS[0].OTE_target__c;
			adjustmentSeats = lCS[0].Adjusted_License_Count__c;
			adjustmentNotes = lCS[0].Adjustment_Notes__c;
		
																				
			
			List<Opportunity> lstOppsToSkip = [select id from Opportunity 
										where Account.Name like '%zzz%'];
			
			List<Id> lstOppIdsToSkip = new List<Id>();
			for(Opportunity o: lstOppsToSkip)
				lstOppIdsToSkip.add(o.Id);
			
			List<Id> lstUserIds = new List<Id>();
			lstUserIds.add(userId);
			userNamesForReport = userName;
			List<Commission_Setup__c> lTeamReps = new List<Commission_Setup__c>(); 
			if(role == 'Team Lead' && calcTeam)
			{
				userNamesForReport = '';
				lTeamReps = [SELECT Sales_Rep__c, Sales_Rep__r.Name,
									Team__c, Role__c,
									Adjusted_License_Count__c,
									Adjustment_Notes__c  
							FROM Commission_Setup__c
							where Team__c =: lCS[0].Team__c 
							and Month_of_Year__c =: dSelMonth];
				lstUserIds = new List<Id>();
				for(Commission_Setup__c cs: lTeamReps)
				{
					userNamesForReport += cs.Sales_Rep__r.Name +',';
					lstUserIds.add(cs.Sales_Rep__c);
				}
			}
			List<AggregateResult> lstSeatsSold = 
										[SELECT sum(Total_Seats__c) seatsSold, ownerId
										//, sum(total_yearly_value__c) 
										FROM Opportunity 
										where Order_Processed__c = True 
										and Next_Steps__c = 'Customer - Provisioned' 
										and CALENDAR_MONTH(CloseDate) =: dSelMonth.month()
										and CALENDAR_YEAR(CloseDate) =: dSelMonth.year()
										and StageName not in ('Closed Lost','Closed Cancelled') 
										//and Accountid not in (select id from account where name like '%zzz%')
										and Id not in: lstOppIdsToSkip
										and OwnerId in: lstUserIds
										group by ownerId];
			
			List<AggregateResult> lstHardwareSold = 
									[SELECT sum(Total_Initial_Fee__c) hardwareSale
									FROM OpportunityLineItem 
	                				where pricebookentry.product2.Type_of_Product_Service__c in 
	                				('Hardware Purchase', 'Hardware Order')
	                				and Opportunity.Order_Processed__c = True 
									and Opportunity.Next_Steps__c = 'Customer - Provisioned' 
									and CALENDAR_MONTH(Opportunity.CloseDate) =: dSelMonth.month()
									and CALENDAR_YEAR(Opportunity.CloseDate) =: dSelMonth.year()
									and Opportunity.StageName not in ('Closed Lost','Closed Cancelled') 
									//and Opportunity.Accountid not in (select id from account where name like '%zzz%')
									and OpportunityId not in: lstOppIdsToSkip
									and Opportunity.OwnerId =: userId];
									//and Opportunity.OwnerId in: lstUserIds];
			
			HardwareSold = double.valueOf(lstHardwareSold[0].get('hardwareSale'));
			if(HardwareSold == null)
				HardwareSold = 0;
			
			
			if(role == 'Team Lead' && calcTeam)
			{
				NewSeatsSold = 0;
				adjustmentSeats = null;
				adjustmentNotes = '';
				for(AggregateResult ar: lstSeatsSold)
				{
					Double tmpNewSeatsSold = double.valueOf(ar.get('seatsSold'));
					string ownerId = string.valueOf(ar.get('OwnerId'));
					if(tmpNewSeatsSold == null)
						tmpNewSeatsSold = 0;
					
					NewSeatsSold += tmpNewSeatsSold;
					
					Double tmpAdjustmentSeats = null;
					for(Commission_Setup__c cs: lTeamReps)
					{
						system.debug(ownerId + '==' + cs.Sales_Rep__c);
						if(ownerId == cs.Sales_Rep__c)
						{
							tmpAdjustmentSeats = cs.Adjusted_License_Count__c;
							
							system.debug('tmpAdjustmentSeats=' + tmpAdjustmentSeats);
							
							if(adjustmentSeats==null)
								adjustmentSeats = 0;
								
							if(tmpAdjustmentSeats != null)
							{
									
								adjustmentSeats += tmpAdjustmentSeats;
								if(cs.Adjustment_Notes__c != null)
									adjustmentNotes += cs.Adjustment_Notes__c + ', ';
							}
							else
							{
								//if(NewSeatsSold > 0)
								//{
									adjustmentSeats += tmpNewSeatsSold;
								//}											
							}
							
							system.debug('adjustmentSeats=' + adjustmentSeats);
						}
					}
				}
			}
			else
			{
				if(lstSeatsSold.size() > 0)
					NewSeatsSold = double.valueOf(lstSeatsSold[0].get('seatsSold'));
				
				if(NewSeatsSold == null)
					NewSeatsSold = 0;
			}
			
			if(adjustmentSeats == NewSeatsSold)
			{
				adjustmentSeats = null;
				adjustmentNotes = null;
			}
			
			if(adjustmentSeats != null)
			{
				if(adjustmentSeats > MinSeats)
				{
					PaidSeats = adjustmentSeats - MinSeats;
				}
			}
			else
			{	
				if(NewSeatsSold > MinSeats)
				{
					PaidSeats = NewSeatsSold - MinSeats;
				}
			}
			
			PaidSeatsCommission = PaidSeats * PaidSeatsCommRate;
			HardwareCommission = HardwareSold * HardwareCommRate / 100;
			
			if(NewSeatsSold < OTETarget)
				OTEBonus = 0;
		}
			
		TotalCommission = PaidCompDemosCommission + OTEBonus + PaidSeatsCommission + HardwareCommission - Clawback;
		
		return null;
	}
	
	public static void prepareData()
	{
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
        						and IsActive = true limit 1];
        
        PricebookEntry pbe2 = [select id, Pricebook2Id from PricebookEntry
        						where Pricebook2.IsActive = true
        						and Pricebook2Id =: pbe.Pricebook2Id 
        						and Product2.Type_of_Product_Service__c in ('Hardware Purchase', 'Hardware Order')
        						and IsActive = true limit 1];
        						
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.now().date();
        opp.StageName = 'Closed Won';
        opp.Pricebook2Id = pbe.Pricebook2Id;
        insert opp;
        
        
        						 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.Quantity = 1;
        oli.UnitPrice = 20;
        insert oli;
        
        oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe2.Id;
        oli.Quantity = 1;
        oli.UnitPrice = 20;
        insert oli;
        
        Commission_Setup__c cs = new Commission_Setup__c();
        cs.Min_Seats__c = 10;
		cs.Commission_Per_Seat_after_min__c = 10;
		cs.Hardware_Commission__c = 10;
		cs.OTE_Bonus__c = 10;
		cs.OTE_target__c = 20;
		cs.Month_of_Year__c = System.today().toStartOfMonth();
		cs.Sales_Rep__c = UserInfo.getUserId();
		cs.Role__c = 'Team Lead';
		cs.Team__c = 'Leicester Sales Team';
		cs.Last_Month_Commission_Clawback__c = 0;
		insert cs;
		
		User u = [select id from user where id !=: UserInfo.getUserId()
					and UserRole.Name in ('Desk Sales Agent', 'Senior Sales Managers', 'Account Managers')
					limit 1];   
		Commission_Setup__c cs1 = new Commission_Setup__c();
        cs1.Min_Completed_Demos_Required__c = 10;
		cs1.Commission_Per_Demo_after_min__c = 10;
		cs1.Month_of_Year__c = System.today().addYears(1).toStartOfMonth();
		cs1.Sales_Rep__c = u.Id;
		cs1.Role__c = 'Telesales Rep';
		cs1.Last_Month_Commission_Clawback__c = 0;
		insert cs1;
	}
	
	static testMethod void myUnitTest1() 
    {
    	
		CommissionReportController.prepareData();
		
		Test.startTest();
		CommissionReportController crc = new CommissionReportController();
		crc.init();
		crc.runReport();
		crc.selMonth = System.today().year() + '-' + System.today().month() + '-01';
		crc.selUser = UserInfo.getUserId();
		crc.runReport();
		crc.GenerateReport();
		
		//Date month = Date.valueOf(System.today().year() + '-' + System.today().month() + '-01');
		string month = System.today().year() + '-' + System.today().month() + '-01';
		string userId = UserInfo.getUserId();
		crc.calculateCommission(userId, month, true);
		
		crc.initAdjustment();
		crc.cancelAdjustment();
		crc.initAdjustment();
		crc.selMonth = System.today().year() + '-' + System.today().month() + '-01';
		crc.selUser = UserInfo.getUserId();
		crc.commitAdjustment();
		crc.adjustmentSeats = 100;
		crc.adjustmentNotes = 'Test';
		crc.commitAdjustment();
		crc.voidAdjustment();
		Test.stopTest();
		
		
    }
    
    static testMethod void myUnitTest2() 
    {
    	
		CommissionReportController.prepareData();
		
		Test.startTest();
		CommissionReportController crc = new CommissionReportController();
		crc.selMonth = System.today().year() + '-' + System.today().month() + '-01';
		ApexPages.currentPage().getParameters().put('month',crc.selMonth);
		crc.GenerateReportAndExport();
		Test.stopTest();
    }

}