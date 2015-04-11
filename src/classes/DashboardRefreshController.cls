////////////////////////////////////////////////////////////
//
// Custom controller for dashboard refresh Visualforce page
//
// Author: Keir Bowden
//
////////////////////////////////////////////////////////////
public with sharing class DashboardRefreshController
{
	public Boolean needsRefresh {get; set;}
	public Boolean canRefresh {get; set;}
	public Id dbIdent {get; set;}
	public Integer minutes {get; set;}
	
	public DashboardRefreshController()
	{
		needsRefresh=true;
		setup();
		minutes=1;
	}
	
	public void setup()
	{
		Map<String, String> headers=ApexPages.currentPage().getHeaders();
		String referrer=headers.get('Referer');
		
		if (null==referrer)
		{
			canRefresh=false;
		}
		else
		{
			Integer lastSlashPos=referrer.lastIndexOf('/');
			lastSlashPos++;
			Integer paramPos=referrer.indexOf('?', lastSlashPos);
			
			
			String result='';
			if (-1!=paramPos)
			{
				result=referrer.substring(lastSlashPos, paramPos);
			}
			else
			{
				result=referrer.substring(lastSlashPos);
			}
		
			try
			{
				dbIdent=result;
				canRefresh=true;
			}
			catch (Exception e)
			{
				canRefresh=false; 
			}
		}
	}
	
	public PageReference refreshDashboard()
	{
		minutes--;
		if (-1==minutes)
		{
			needsRefresh=false;
			String refUrlStr='/dash/dashboardRefresh.apexp?id='+dbIdent;
			Boolean refreshed=false;
			Integer idx=0;
			while ( (!refreshed) && (idx<10) )
			{
				PageReference pr=new PageReference(refUrlStr);
				Blob body=null;
				if(test.isRunningTest())
				{
					body=blob.valueOf('Last refreshed');
				}
				else
					body=pr.getContent();
					
				String bodyStr=body.toString();
				refreshed=(-1!=bodyStr.indexOf('Last refreshed'));
				idx++;
			}
		}
		
		return null;
	}
	
	static testMethod void myUnitTest() 
    {
    	ApexPages.currentPage().getHeaders().put('Referer','https://na6.salesforce.com/01Z80000000lf7nEAA');
    	DashboardRefreshController o = new DashboardRefreshController();
    	o.refreshDashboard();
    	o.minutes = 0;
    	o.refreshDashboard();
    	
    	//ApexPages.currentPage().getHeaders().put('Referer',null);
    	//o = new DashboardRefreshController();
    	
    }
}