public with sharing class PruductTableController {
    
    public List<Product_Table__c> prodList = new List<Product_Table__c>();
    public String idPass { get; set; }
    public integer OffsetSize = 0;
	public integer LimitSize= 1;
    public integer totalRecs = 0;
    

    public List<Product_Table__c> prodListDescr {
    	get { 
            totalrecs = [SELECT count() FROM Product_Table__c] - 1;
            List<Product_Table__c> prodListShortDescr = new List<Product_Table__c>();
            prodList = [SELECT Name, Image_Url__c, Title__c, Product_Description__c, Unit_Price__c FROM Product_Table__c LIMIT :LimitSize OFFSET :OffsetSize];
            for (Product_Table__c prod: prodList) {
                if (prod.Product_Description__c.length() > 100 && prod.Product_Description__c.indexOfChar(32, 100) != -1 ) {
                    prod.Product_Description__c = prod.Product_Description__c.substring(0, prod.Product_Description__c.indexOfChar(32, 100));
                }
               prodListShortDescr.add(prod);
            }
            return prodListShortDescr;
        }
    set; 
    }
    
     
    public List<Product_Table__c> getProducts () {
        List<Product_Table__c> pr = new List<Product_Table__c>();
        
        return prodListDescr;
    }
    
    
    public void FirstPage() { 
        OffsetSize = 0;
        //getProducts();
	}
    
    public void previous() {
        OffsetSize = (OffsetSize-LimitSize);
        //getProducts();
    }
    
    public void next() {
        OffsetSize = OffsetSize + LimitSize;
        //getProducts();
    }
    
    public void LastPage() {
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        //getProducts();
    }
    
    public boolean getprev() {
		if(OffsetSize == 0) {
			return true;
		} else {
			return false;
		}
	}
    
    public boolean getnxt() {
        if((OffsetSize + LimitSize) > totalRecs) {
            return true;
        } else { 
            return false;
        }
	}
        
}