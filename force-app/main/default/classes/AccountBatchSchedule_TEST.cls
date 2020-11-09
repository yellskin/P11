/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Test batch named AccountBatchSchedule
*
*/
@isTest
private class  AccountBatchSchedule_TEST {
    @isTest static void testAccountBatchSchedule(){
    Test.startTest();
    System.schedule('AccountBatchSchedule', '0 0 3 * * ?', new AccountBatchSchedule());
    Test.stopTest();
    }
}