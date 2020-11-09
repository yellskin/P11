/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Batch use for create task for all account which doesn't have order or task callback
*
*/
global class AccountBatch implements Database.Batchable<sObject>, Database.Stateful{
    global AccountBatch() {

    }

    public String query;

    global Database.QueryLocator start(Database.BatchableContext bc){
        this.query = 'SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)';
        return Database.getQueryLocator(this.query);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope){
        List<Task> taskWithSubjectCall = [SELECT Id, Subject FROM Task WHERE Subject =: 'Call'];
        List<Task> taskToCreate = new List<Task>();
        Set<Id> accountWithTask = new Set<Id>();

        for(Task t:taskWithSubjectCall) {
            accountWithTask.add(t.WhatId);
        }

        for(Account a:scope){
            if(!(accountWithTask.contains(a.Id))){
                Task tsk = new Task();
                        tsk.WhatId = a.Id;
                        tsk.Subject = 'Call';
                        tsk.Status = 'Not Started';
                        tsk.Priority = 'Normal';
                        tsk.IsReminderSet = true;
                        tsk.ReminderDateTime = System.today()+5;
                taskToCreate.add(tsk);
            }
        }
        if(taskToCreate.size()>0){
            insert(taskToCreate);
        }
    }

    global void finish(Database.BatchableContext bc){
        System.debug('JOB IS DONE');
    }
}