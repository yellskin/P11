/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Test batch named AccountBatch
*
*/
@isTest
private class  AccountBatch_TEST {
    @isTest static void testAccountBatch(){
        Account accountOld = TestDataFactory.generateAccount('accountOld');
        insert accountOld;
        System.debug('accountOld: '+accountOld);

        Test.startTest();
        Database.executeBatch(new AccountBatch());
        Test.stopTest();

        Account accountUpdate = [SELECT Id FROM Account WHERE Id =:accountOld.Id];
        Task newTask = [SELECT Id, WhatId, Subject FROM Task WHERE WhatId =:accountUpdate.Id];
        System.debug('newTask: '+newTask);
        System.assertEquals('Call',newTask.Subject);
    }
}