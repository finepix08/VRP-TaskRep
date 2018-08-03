/**
 * Created by user on 03.06.2018.
 */

public with sharing class ProductToWarehouseTriggerHandler {
    public static List<Warehouse__c> ProductToWarehouse(List<Product_Table__c> ListNewProduct) {
        List<Warehouse__c> NewWarehouses = new List<Warehouse__c>();
        List<Warehouse__c> WarehouseDates = new List<Warehouse__c>([Select Period_End__c, Period_Start__c FROM Warehouse__c]);
        Org_Configuration__c  OrgConfigPeriod = Org_Configuration__c.getInstance();
        Integer periodTerm = (Integer)OrgConfigPeriod.Period_Term__c;
        for (Product_Table__c newProduct: ListNewProduct) {
            for (Warehouse__c warehouse : WarehouseDates) {
                if (warehouse.Period_Start__c <= newProduct.Added_Date__c
                && warehouse.Period_End__c >= newProduct.Added_Date__c) {
                    newProduct.Warehouse__c = warehouse.Id;
                } else {
                    NewWarehouses.add(new Warehouse__c(
                            Name = 'Warehouse ' + newProduct.Added_Date__c + ' ' + (newProduct.Added_Date__c.addDays(periodTerm)),
                            Period_Start__c = newProduct.Added_Date__c,
                            Period_End__c = newProduct.Added_Date__c.addDays(periodTerm)
                            ));
                    newProduct.Warehouse__c = NewWarehouses[0].Id;
                    system.debug(NewWarehouses);
                }
            }
        }

        insert NewWarehouses;
        return NewWarehouses;

    }
}