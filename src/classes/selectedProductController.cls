public class selectedProductController {
	String currentID = ApexPages.currentPage().getParameters().get('id');
    public Product_Table__c prodSelectedList {get; set;}
    
    public selectedProductController() {
       prodSelectedList = [SELECT Name, Image_Url__c, Title__c, Product_Description__c, Unit_Price__c, Units_Available__c FROM Product_Table__c WHERE Id=:currentID];
    }
    
    
    
}