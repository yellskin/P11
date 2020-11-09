/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Handler trigger by OrderTrigger on Order Object.
*
*
*/
public with sharing class OrderHandler {

    public static void checkHasProducts(List<Order> newOrders, Map<Id, Order> oldMapOrders) {
        map<Id,Order> mapOrder = new map<Id,Order>([SELECT Id, (SELECT Id FROM Orderitems LIMIT 1) FROM Order WHERE Id IN:newOrders]);

        for(Order o:newOrders){
            if(
                (mapOrder.get(o.Id).Orderitems.size()==0) &&
                (oldMapOrders.get(o.Id).Status == 'Draft') &&
                (o.Status != oldMapOrders.get(o.Id).Status)
            )
            {
                o.addError('Veuillez saisir un ou des produits avant d\'activer l\'order');
            }
        }
    }

    public static void checkHasOrder(List<Order> orders){

        List<Account> accountListToUpdate = new List<Account>();

        Set<Id> accountSetWithOrdersDeleted = new Set<Id>();
        Set<Id> accountSetWithOrdersAfterDeleted = new Set<Id>();

        for(Order o1:orders){
            if(o1.AccountId != null || o1.AccountId !=''){
                accountSetWithOrdersDeleted.add(o1.AccountId);
            }
        }

        if(!(accountSetWithOrdersDeleted.isEmpty())){
            List<Account> accountsListWithOrdersDeleted = [SELECT Id, Actif__c FROM Account WHERE Id IN:accountSetWithOrdersDeleted];
            List<Order> orderWithTheAccountId = [SELECT Id, AccountId FROM Order WHERE AccountId IN:accountSetWithOrdersDeleted];

            if(!(orderWithTheAccountId.isEmpty())) {
                for(Order o2:orderWithTheAccountId) {
                    accountSetWithOrdersAfterDeleted.add(o2.AccountId);
                }
            }

            if(!(accountsListWithOrdersDeleted.isEmpty())){
                for(Account a1:accountsListWithOrdersDeleted){
                    if((accountSetWithOrdersAfterDeleted.isEmpty()) || (!(accountSetWithOrdersAfterDeleted.contains(a1.Id)))){
                        a1.Actif__c = false;
                        accountListToUpdate.add(a1);
                    }
                }
            }
        }
        if(accountListToUpdate.size()>0){
            update(accountListToUpdate);
        }
    }


    public static void checkInsertOrderInAccount(List<Order> newOrders){
        List<Account> accountListToUpdate = new List<Account>();
        Set<Id> accountsWithOrders = new Set<Id>();

        for(Order o1:newOrders){
            if(o1.AccountId != null || o1.AccountId !=''){
                accountsWithOrders.add(o1.AccountId);
            }
        }

        List<Account> accountList = [SELECT Id FROM Account WHERE Id IN:accountsWithOrders];
        for(Account a1:accountList){
            a1.Actif__c = true;
            accountListToUpdate.add(a1);
        }

        if(accountListToUpdate.size()>0){
            update(accountListToUpdate);
        }
    }
}