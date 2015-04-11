public with sharing class CommissionSetupController 
{
	public boolean showFrame {get; set;}
	
	public void init()
	{
		showFrame = false;
		if(UserInfo.getUserName().contains('mohsin.raza@synety.com') ||
			UserInfo.getUserName().contains('mark.seemann@synety.com') ||
			UserInfo.getUserName().contains('simon.cleaver@synety.com') ||
			UserInfo.getUserName().contains('rachel.harris@synety.com') ||
			UserInfo.getUserName().contains('paul.williams@synety.com'))
		{
			showFrame = true;
		}
	}
	
	static testMethod void myUnitTest() 
    {
    	CommissionSetupController o = new CommissionSetupController();
    	o.init();
    }
}