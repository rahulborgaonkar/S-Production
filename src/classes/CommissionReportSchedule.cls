global class CommissionReportSchedule implements Schedulable
{
	string reportTitle = '';
	
	//constructor
    public CommissionReportSchedule(){
    
    }
    
    //execute method
    global void execute(SchedulableContext SC)
    {
    	string month = System.today().addMonths(-1).year() + '-' 
    					+ System.today().addMonths(-1).month() + '-01';
    	this.GenerateReportAndEmail(month);
    	   
    }
    
    public string GetReportBody(string month)
    {
    	CommissionReportController crc = new CommissionReportController();
    	crc.init();
    	//string month = System.today().addMonths(-1).year() + '-' 
    	//				+ System.today().addMonths(-1).month() + '-01';
		
		List<User> lUsers = [select Id, Name from User where isActive = true and  
					UserRole.Name in ('Desk Sales Agent', 'Senior Sales Managers', 'Account Managers')
					and Username not in ('sales@synety.com')
					order by UserRole.Name, Name];
		
		string monthName = '';
		for(SelectOption so: crc.lstMonths)
		{
			if(month == so.getValue())
			{
				monthName = so.getLabel();
			}
		}
		string emailBodyTelesales = '';
		
		reportTitle = 'Commission Report for ' + monthName;
		string emailBody = '<div style="width:100%;text-align:center;font-family:Verdana, Geneva, sans-serif"><b>' + reportTitle + '</b></div>';
		emailBody += '<br /><div style="width:100%;text-align:center;font-family:Verdana, Geneva, sans-serif">Commission Calculation for Account Managers and Team Leads</div><br />' ;
		emailBody += '<table width="100%" border="1" bordercolor="#000000" cellspacing="0" cellpadding="5">';
  		emailBody += '    <tr>';
    	emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Sales Rep.</b></td>';
    	emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Role</b></td>';
    	emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Team</b></td>';
    	emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Min. Licenses</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Commission Per License</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>OTE (target)</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Hardware Commission</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>New Licenses</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Adjusted License Count</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Adjustment Notes</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Paid Licenses</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Paid License Commission</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>OTE Bonus</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Hardware Sold</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Hardware Commission</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Last Month\'s Commission Clawback</b></td>';
		emailBody += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Total Commission</b></td>';
		emailBody += '    </tr>';
		
		emailBodyTelesales += '<table width="100%" border="1" bordercolor="#000000" cellspacing="0" cellpadding="5">';
  		emailBodyTelesales += '    <tr>';
    	emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Sales Rep.</b></td>';
    	emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Role</b></td>';
    	emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Min. Completed Demos Required</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Commission Per Demo &pound; (after min)</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Demos Booked</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Demos Completed</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Paid Completed Demos</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Web Demo Commission</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Last Month\'s Commission Clawback</b></td>';
		emailBodyTelesales += '        <td style="text-align:center;font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Total Commission</b></td>';
		emailBodyTelesales += '    </tr>';
		
		double total_NewSeats = 0;
		double total_PaidSeats = 0;
		double total_PaidSeatsCommission = 0;
		double total_HardwareSold = 0;
		double total_HardwareCommission = 0;
		double total_OTEBonus = 0;
		double total_Clawback = 0;
		double total_TotalCommission = 0;
		
		double total_DemosBooked = 0;
		double total_DemosCompleted = 0;
		double total_PaidDemos = 0;
		double total_PaidDemosComm = 0;
		
		double totalTelesales_Clawback = 0;
		double totalTelesales_TotalCommission = 0;
		
		for(User u: lUsers)
		{
						
			string userId = u.Id;
			string result = crc.calculateCommission(userId, month, true);
				
			if(result == null)
			{
				
				if(crc.role == 'Telesales Rep')
				{
					totalTelesales_TotalCommission += crc.TotalCommission;
					totalTelesales_Clawback += crc.Clawback;
				
					total_DemosBooked += crc.DemosBooked;
					total_DemosCompleted += crc.DemosCompleted;
					total_PaidDemos += crc.PaidCompDemos;
					total_PaidDemosComm += crc.PaidCompDemosCommission;
					
					emailBodyTelesales += '    <tr>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+u.Name+'</td>';
				  	emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+crc.Role+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.minDemos,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.DemosCommRate,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.DemosBooked,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.DemosCompleted,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.PaidCompDemos,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.PaidCompDemosCommission,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.Clawback,false)+'</td>';
					emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(crc.TotalCommission,false)+'</b></td>';
					emailBodyTelesales += '    </tr>';
				}
				else
				{
					total_TotalCommission += crc.TotalCommission;
					total_Clawback += crc.Clawback;
				
					total_NewSeats += crc.NewSeatsSold;
					total_PaidSeats += crc.PaidSeats;
					total_PaidSeatsCommission += crc.PaidSeatsCommission;
					total_HardwareSold += crc.HardwareSold;
					total_HardwareCommission += crc.HardwareCommission;
					total_OTEBonus += crc.OTEBonus;
					
				  	emailBody += '    <tr>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+u.Name+'</td>';
				  	emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+crc.Role+'</td>';
				  	emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+crc.Team+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.MinSeats,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.PaidSeatsCommRate,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.OTETarget,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.HardwareCommRate,false)+'%</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><a title="click here to see details" target="_blank" href="https://na11.salesforce.com/00OG0000004dusA?pv6='+crc.userNamesForReport+'&pv2='+crc.monthStart+'&pv7='+crc.monthEnd+'">'+formatDouble(crc.NewSeatsSold,false)+'</a></td>';
					
					if(crc.adjustmentSeats != null)
						emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.adjustmentSeats,false)+'</td>';
					else
						emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">-</td>';
					
					if(crc.adjustmentNotes != null)				
						emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+crc.adjustmentNotes+'</td>';
					else
						emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">-</td>';
						
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">'+formatDouble(crc.PaidSeats,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.PaidSeatsCommission,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.OTEBonus,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><a title="click here to see details" target="_blank" href="https://na11.salesforce.com/00OG0000004dusU?pv8='+crc.userName+'&pv3='+crc.monthStart+'&pv4='+crc.monthEnd+'">&pound;'+formatDouble(crc.HardwareSold,false)+'</a></td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.HardwareCommission,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;">&pound;'+formatDouble(crc.Clawback,false)+'</td>';
					emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(crc.TotalCommission,false)+'</b></td>';
					emailBody += '    </tr>';
				}
				
				
			}
			else
			{
				emailBody += '<tr>';
				emailBody += '  <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+u.Name+'</td>';
				emailBody += '	<td colspan="16" style="font-family:Verdana, Geneva, sans-serif;font-size:10px">'+result+'</td>';
				emailBody += '</tr>';
			}
			
			
		}
		
		emailBody += '    <tr>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Total</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>'+formatDouble(total_NewSeats,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>'+formatDouble(total_PaidSeats,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_PaidSeatsCommission,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_OTEBonus,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_HardwareSold,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_HardwareCommission,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_Clawback,false)+'</b></td>';
		emailBody += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_TotalCommission,false)+'</b></td>';
		emailBody += '    </tr>';
		emailBody += '</table>';
		
		emailBodyTelesales += '    <tr>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px"><b>Total</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&nbsp;</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>'+formatDouble(total_DemosBooked,false)+'</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>'+formatDouble(total_DemosCompleted,false)+'</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>'+formatDouble(total_PaidDemos,false)+'</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(total_PaidDemosComm,false)+'</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(totalTelesales_Clawback,false)+'</b></td>';
		emailBodyTelesales += '        <td style="font-family:Verdana, Geneva, sans-serif;font-size:10px;text-align:right;"><b>&pound;'+formatDouble(totalTelesales_TotalCommission,false)+'</b></td>';
		emailBodyTelesales += '    </tr>';
		emailBodyTelesales += '</table>';
		
		total_TotalCommission += totalTelesales_TotalCommission;
		
		emailBody += '<br /><br /><div style="width:100%;text-align:center;font-family:Verdana, Geneva, sans-serif">Commission Calculation for Telesales Reps</div><br />' + emailBodyTelesales;
		
		emailBody += '<br /><div style="width:100%;text-align:right;font-family:Verdana, Geneva, sans-serif"><b>Total Commission: &pound;'+formatDouble(total_TotalCommission,false)+'</b></div>';
		
		//system.debug('emailBody='+emailBody);
		
		return emailBody;
    }
    public void GenerateReportAndEmail(string month)
    {
    	string emailBody = this.GetReportBody(month);
		
		List<User> lstAdminUser = [select id from User 
									where 
									UserName like 'mohsin.raza@synety.com%' 
									or 
									UserName like 'mark.seemann@synety.com%' 
									or 
									UserName like 'rachel.harris@synety.com%'
									or 
									UserName like 'simon.cleaver@synety.com%'
									or 
									UserName like 'paul.williams@synety.com%'
									];
			
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		for(User u :lstAdminUser)
		{   
		   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		     
		   mail.setSubject(reportTitle);
		   mail.setTargetObjectId(u.Id);
		   mail.setSaveAsActivity(false);
		   mail.setHtmlBody(emailBody);
		   mails.add(mail);
		}
		Messaging.sendEmail(mails);
		
    } 
    
    public String formatDouble(double myNumber,Boolean isCurrency)
    {
		String formattedString = '';
		
		string sNum = string.valueof(myNumber);
		sNum = sNum.replace('.',':');

		string fraction = sNum.split(':')[1];
		
		String myNumberAsString = sNum.split(':')[0];
		/*
		if (isCurrency){
			formattedString = '$';
		}
		*/
		if(myNumber>999999999)
		{
			formattedString += myNumberAsString.substring(0,myNumberAsString.length()-9)+ ',' + myNumberAsString.substring(myNumberAsString.length()-9,myNumberAsString.length()-6) + ',' + myNumberAsString.substring(myNumberAsString.length()-6,myNumberAsString.length()-3) + ',' + myNumberAsString.substring(myNumberAsString.length()-3,myNumberAsString.length());
		}
		else if(myNumber>999999)
		{
			formattedString += myNumberAsString.substring(0,myNumberAsString.length()-6)+ ',' + myNumberAsString.substring(myNumberAsString.length()-6,myNumberAsString.length()-3) + ',' + myNumberAsString.substring(myNumberAsString.length()-3,myNumberAsString.length());
		}
		else if(myNumber>999)
		{
			formattedString += myNumberAsString.substring(0,myNumberAsString.length()-3)+ ',' + myNumberAsString.substring(myNumberAsString.length()-3,myNumberAsString.length());
		}
		else 
		{
			formattedString += myNumberAsString;
		}
		
		if(fraction.length()>2)
		{
			fraction = fraction.substring(0,2);
		}
		
		if(integer.valueOf(fraction) < 10 && fraction.length()==1)
		{
			fraction = fraction+'0';
		}
		
		formattedString += '.' + fraction;
		return formattedString;
	}
	
    static testMethod void myUnitTest() 
    {
    	string month = System.today().addMonths(-1).year() + '-' 
    					+ System.today().addMonths(-1).month() + '-01';
    	CommissionReportSchedule crc = new CommissionReportSchedule();
    	crc.GenerateReportAndEmail(month);
    	crc.formatDouble(double.valueof('100.50'),false);
    }
}