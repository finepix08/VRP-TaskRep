@isTest
public class ProductTableControllerTest {
	@testSetup 
        static void createDataFactory() {
            List<Product_Table__c> product = new List<Product_Table__c>();
            for(Integer i = 0; i < 10; i++) {
                product.add(new Product_Table__c(Name = 'TestProduct'+i, Unit_Price__c = 100, Product_Description__c = 'aaaa', Units_Available__c = 10));
            }
			
            List<Contact> contact = new List<Contact>();
            for(Integer i = 0; i < 2; i++) {
                contact.add(new Contact(FirstName = 'TestContact'+i, LastName = 'TestContactLast'+i, Email = 'nadudik1993' + i + '@gmail.com'));
            }
            
            insert product;
            insert contact;
    	}
    
    public static testMethod void testProductTable() {
        integer OffsetSize = 0;
		integer LimitSize= 1;
        List <Product_Table__c> prodLists = [SELECT Name, Unit_Price__c, Product_Description__c, ID  FROM Product_Table__c LIMIT :LimitSize OFFSET :OffsetSize];
        integer totalrecs= [SELECT count() FROM Product_Table__c];
        
        Test.startTest();
        Test.setCurrentPage(Page.ProductTable);
        PruductTableController prod = new PruductTableController();
        Test.stopTest();
        
        System.assertEquals(prodLists, prod.getProducts());
        
        prod.FirstPage();
        System.assertEquals(0, prod.OffsetSize);
        
        prod.next();
        System.assertEquals(1, prod.OffsetSize); 
        
		prod.previous();
		System.assertEquals(0, prod.OffsetSize);
        
        prod.LastPage();
		System.assertEquals(9, prod.OffsetSize);
        
		prod.getnxt();
        System.assertEquals(true, prod.getnxt());
        
        prod.FirstPage();
        System.assertEquals(true, prod.getprev());
        
        prod.next();
        System.assertEquals(false, prod.getnxt());
        System.assertEquals(false, prod.getprev());
    }
	
    public static testMethod void testProductSelectedProduct() {

        List <Product_Table__c> prodLists = [SELECT Name, Image_Url__c, Title__c, Product_Description__c, Unit_Price__c, Units_Available__c  FROM Product_Table__c limit 1];
		Product_Table__c product = prodLists[0];
        Test.startTest();
        PageReference pageRef = Page.SelectedProduct;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',product.id);
        selectedProductController selectprods = new selectedProductController();
        System.assertNotEquals(null, selectprods.prodSelectedList);
        
        Test.stopTest();
		
    }
    
    public static testMethod void testProductInformation() {

        List <Product_Table__c> prodLists = [SELECT Unit_Price__c, NAME, Units_Available__c  FROM Product_Table__c limit 1];
		Product_Table__c product = prodLists[0];
        PageReference pageRef = Page.ProductInformation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',product.id);
        ProductInformationController prods = new ProductInformationController();
        
        System.assertEquals(product, prods.getcontProdList());
        
        prods.quantity = 5;
        prods.countAmount();
        System.assertEquals(500, prods.totalAmount);
        
        prods.quantity = -1;
        prods.countAmount();
		System.assertEquals(0, prods.totalAmount);
        
        prods.buy();
        System.assertEquals('', prods.messageSuccess);
        
        prods.quantity = 5;
        
        prods.cont.Email = 'nadudik19930@gmail.com';
        
        //prods.cont.FirstName = 'TestContact0';
        system.debug('saaaaaa' +prods.cont.Email);
		List<Contact> contact1 =  [SELECT FirstName, LastName, Email  FROM Contact];
        system.debug('ssss' + contact1);
        
        Contact contact =  [SELECT FirstName, LastName, Email  FROM Contact WHERE Email =: prods.cont.Email];
        
        prods.cont.FirstName = contact.FirstName;
        prods.cont.LastName = contact.LastName;
        
        prods.buy();
        System.assertEquals('TestContact0', contact.FirstName);
        
        prods.cont.Email = 'nadudik19930@gmail.com';
        prods.buy();
        System.assertEquals('TestContact0', contact.FirstName);
        
        prods.cont.Email = 'nadudik@gmail.com';
        prods.buy();
        
        prods.quantity = 100;
        prods.buy();
        System.assertEquals('', prods.messageSuccess);
        
        prods.valueupdate();
        System.assertEquals(10000, prods.totalAmount);
    }
    
}