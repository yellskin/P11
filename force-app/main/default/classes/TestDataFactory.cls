/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Create data for test class
*
*/
public with sharing class TestDataFactory {
    public static Account generateAccount(String name){
        Account account = new Account();
        account.Name = name;
        account.Actif__c = false;

        return account;
    }

    public static Contract generateContract(Id accountId){
        Contract contract = new Contract();
        contract.AccountId = accountId;
        contract.Status = 'Draft';
        contract.StartDate = Date.newInstance(2020, 10, 05);
        contract.ContractTerm = 5;

        return contract;
    }

    public static Order generateOrder(Id accountId, Id contractId){
        Order order = new Order();
        order.AccountId = accountId;
        order.contractId = ContractId;
        order.Status = 'Draft';
        order.EffectiveDate = Date.newInstance(2020, 10, 06);

        return order;
    }

}