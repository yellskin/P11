/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Test of OrderHandler
*
*/
@isTest
private class OrderHandler_TEST {

    /*
    Test for one order without orderItem then throwing error message
    */
    @isTest static void testCheckHasProducts(){
        Account account1 = TestDataFactory.generateAccount('account1');
        insert account1;
        System.debug('account1: ' + account1);

        Contract contract1 = TestDataFactory.generateContract(account1.Id);
        insert contract1;
        System.debug('contract1: ' + contract1);

        Order order1 = TestDataFactory.generateOrder(account1.Id, contract1.Id);
        insert order1;
        System.debug('order1: ' + order1);

        order1.Status = 'Activated';

            try{
                update order1;
            }catch(exception e){
                System.assert(e.getMessage().contains('Veuillez saisir'));
                System.debug('KO');
                System.debug(e.getMessage());
            }

    }

    /*
    Test for one account. If insert new order, account's Actif__c field should be true
    */
    @isTest static void testCheckInsertOrderInAccount(){
        Account accountBefore = TestDataFactory.generateAccount('accountBefore');
        insert accountBefore;
        System.debug('accountBefore : '+accountBefore);
        System.assertEquals(false, accountBefore.Actif__c);

        Contract contract1 = TestDataFactory.generateContract(accountBefore.Id);
        insert contract1;
        System.debug('contract1 : '+contract1);

        Order order1 = TestDataFactory.generateOrder(accountBefore.Id, contract1.Id);

        Test.startTest();
        insert order1;
        System.debug('order1 : '+order1);
        Test.stopTest();

        Account accountAfter = [SELECT Id, Name, Actif__c FROM Account WHERE Name =:'accountBefore'];
        System.debug('accountAfter.Actif__c: ' + accountAfter.Actif__c);
        System.assertEquals(true, accountAfter.Actif__c);

    }

    /*
    Test for one account. If no order anymore, account's Actif__c field should be false
    */
    @isTest static void testCheckHasOrderDeactivate(){
        Account accountBefore = TestDataFactory.generateAccount('accountBefore');
        accountBefore.Actif__c = true;
        insert accountBefore;
        System.debug('accountBefore.Actif__c: '+accountBefore.Actif__c);

        Contract contract1 = TestDataFactory.generateContract(accountBefore.Id);
        insert contract1;
        System.debug('contract1 : '+contract1);

        Order order1 = TestDataFactory.generateOrder(accountBefore.Id, contract1.Id);
        Order order2 = TestDataFactory.generateOrder(accountBefore.Id, contract1.Id);
        System.debug('order1 : '+order1);
        System.debug('order2 : '+order2);
        insert order1;
        insert order2;

        Test.startTest();
        delete order1;
        delete order2;
        System.debug('Delete order1 and order2');
        Test.stopTest();

        Account accountAfter = [SELECT Id, Name, Actif__c FROM Account WHERE Name =:'accountBefore'];
        System.debug('accountAfter.Actif__c: '+accountAfter.Actif__c);
        System.assertEquals(false, accountAfter.Actif__c);

    }

    /*
    Test for one account. If still has one order, account's Actif__c field should be true
    */
    @isTest static void testCheckHasOrderActive(){
        Account accountBefore = TestDataFactory.generateAccount('accountBefore');
        accountBefore.Actif__c = true;
        insert accountBefore;
        System.debug('accountBefore.Actif__c: '+accountBefore.Actif__c);

        Contract contract1 = TestDataFactory.generateContract(accountBefore.Id);
        insert contract1;
        System.debug('contract1 : '+contract1);

        Order order1 = TestDataFactory.generateOrder(accountBefore.Id, contract1.Id);
        Order order2 = TestDataFactory.generateOrder(accountBefore.Id, contract1.Id);
        System.debug('order1 : '+order1);
        System.debug('order2 : '+order2);
        insert order1;
        insert order2;

        Test.startTest();
        delete order1;
        System.debug('Delete order1');
        Test.stopTest();

        Account accountAfter = [SELECT Id, Name, Actif__c FROM Account WHERE Name =:'accountBefore'];
        System.debug('accountAfter.Actif__c: '+ accountAfter.Actif__c);
        System.assertEquals(true, accountAfter.Actif__c);

    }
}