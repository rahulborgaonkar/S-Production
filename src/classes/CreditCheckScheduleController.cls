global class CreditCheckScheduleController implements Schedulable
{

    //constructor
    public CreditCheckScheduleController(){
    
    }
    
    //execute method
    global void execute(SchedulableContext SC)
    {
         CreditCheckBatchController batchController = new CreditCheckBatchController();    
         Database.executeBatch(batchController,1);
    } 
}