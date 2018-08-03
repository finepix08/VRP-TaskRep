/**
 * Created by nadudike on 6/1/2018.
 */

trigger ProductToWarehouseTrigger on Product_Table__c (before insert) {
    if (trigger.isBefore) {
        if (trigger.isInsert) {
            ProductTableTriggerHandler.ProductToWarehouse(trigger.new);
        }
    }
}