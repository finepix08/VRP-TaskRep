public class ProductInformationController {
	String currentID = ApexPages.currentPage().getParameters().get('id');
    public Product_Table__c contProdList {get; set;}
    public Integer quantity {get; set;}
    public Decimal totalAmount {get; set;}
    public String messageError {get; set;}
    public String messageSuccess {get; set;}
    public Contact cont {get; set;}
    public Boolean displaySuccess {get; set;} 
   
    
    public ProductInformationController() {
        contProdList = [SELECT Unit_Price__c, NAME, Units_Available__c FROM Product_Table__c WHERE Id=:currentID];
        cont = new Contact();
        displaySuccess = true;
        
    }
    
   
    
    public Product_Table__c getcontProdList() {
		return contProdList;
	}
    
    public PageReference countAmount(){
        if(quantity <= 0) {
            messageError = 'Not correct unit count';
            messageSuccess = '';
            totalAmount = 0;
        } else {
            totalAmount = contProdList.Unit_Price__c * quantity; 
            messageError = '';
        }
        return null; 
    }
    
	 public void buy() {  
         if(quantity <= 0) {
             messageError = 'Not correct unit count';
             messageSuccess = '';
         } else {
             Order_Table__c newOrder = new Order_Table__c();
         	 Product_Table__c productUnits = [SELECT Unit_Price__c, NAME, Units_Available__c  FROM Product_Table__c WHERE Id = : currentID];
             Contact contact =  [SELECT FirstName, LastName, Email  FROM Contact WHERE Email = : cont.Email];
     
             Contact cont2 = new Contact();
             cont2.FirstName = cont.FirstName;
             cont2.LastName = cont.LastName;
             cont2.Email = cont.Email;
             upsert cont2 Contact.field.Email; 
             
             newOrder.Contact__c =  cont2.Id;
             newOrder.Product__c = currentID;
             newOrder.Units__c = quantity;
             newOrder.Order_Amount__c = totalAmount;
             
             Integer difference = Integer.valueOf(productUnits.Units_Available__c) - quantity;
                 
             if (difference >= 0) {
                 productUnits.Units_Available__c = difference;
                 update productUnits;
                 messageError = '';
                 messageSuccess = 'Well done!';
                 insert newOrder;
             } else { 
                 messageError = 'Error: There are ' + productUnits.Units_Available__c + ' units available';
                 messageSuccess = '';
             }
         }
     }


    
     
    public PageReference valueupdate() {
        totalAmount = contProdList.Unit_Price__c * quantity;
        return null;
	}
    
   
}