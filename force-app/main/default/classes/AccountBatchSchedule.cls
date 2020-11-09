/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Batch schedulable to invoke Apex classes to run at specific times
*
*/
global class AccountBatchSchedule implements Schedulable{
    global void execute(SchedulableContext ctx){
        AccountBatch batch = new AccountBatch();
        Database.executeBatch(batch,200);
    }
}