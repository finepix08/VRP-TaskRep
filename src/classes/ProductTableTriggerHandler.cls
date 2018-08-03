public class ProductTableTriggerHandler {
    public static void ProductToWarehouse(List<Product_Table__c> ListNewProduct) {
        Map<String, Warehouse__c> productTableName2WareHouse = new Map<String, Warehouse__c>();
        List<Warehouse__c> NewWarehouses = new List<Warehouse__c>();
        List<Warehouse__c> WarehouseDates = [Select Period_End__c, Period_Start__c FROM Warehouse__c];
        Org_Configuration__c  OrgConfigPeriod = Org_Configuration__c.getInstance();
        Integer periodTerm = (Integer)OrgConfigPeriod.Period_Term__c;
        for (Product_Table__c newProduct: ListNewProduct) {
            boolean needNewWarehouse = true;
            for (Warehouse__c warehouse : WarehouseDates) {
                if (warehouse.Period_Start__c <= newProduct.Added_Date__c
                    && warehouse.Period_End__c >= newProduct.Added_Date__c) {
                    newProduct.Warehouse__c = warehouse.Id;

                    system.debug('------------');
                    needNewWarehouse = false;
                    break;
                }
            }
            if(needNewWarehouse) {
                Warehouse__c NewWarehouses1  = new Warehouse__c();
                NewWarehouses1.Name = 'Warehouse '+ newProduct.Added_Date__c + ' ' + (newProduct.Added_Date__c.addDays(periodTerm));
                NewWarehouses1.Period_Start__c = newProduct.Added_Date__c;
                NewWarehouses1.Period_End__c = newProduct.Added_Date__c.addDays(periodTerm);
                productTableName2WareHouse.put(newProduct.name,  NewWarehouses1 );
            }
        }
        insert productTableName2WareHouse.values();

        for (Product_Table__c newProduct: ListNewProduct) {
            System.debug('!!! newProduct.name ' + newProduct.name);
            if(productTableName2WareHouse.containsKey(newProduct.name)) {
                newProduct.Warehouse__c = productTableName2WareHouse.get(newProduct.name).Id;
            }
        }
    }
}