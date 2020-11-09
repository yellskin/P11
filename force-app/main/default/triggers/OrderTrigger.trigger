/**
* @author:		 Frédéric VO
* @date:		 04/10/2020
* @description:	 Trigger on Order object calling apex class OrderHandler
*
*/
trigger OrderTrigger on Order (before update, after delete, after insert) {
  switch on Trigger.operationType {
    when BEFORE_UPDATE {
      OrderHandler.checkHasProducts(Trigger.new,Trigger.oldMap);
    }
    when AFTER_DELETE {
      OrderHandler.checkHasOrder(trigger.old);
    }
    when AFTER_INSERT {
      OrderHandler.checkInsertOrderInAccount(trigger.new);
    }
  }
}