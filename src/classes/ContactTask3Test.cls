@isTest
public class ContactTask3Test {
	@testSetup 
        static void createContact() {
            List<Contact> testContacts = new List<Contact>();
            for(Integer i = 0; i < 500; i++) {
                testContacts.add(new Contact(LastName = 'TestAcct'+i));
            }
            insert testContacts;        
    	}
    public static testMethod void testContactsSorting(){
        List <Contact> contList = [SELECT ID  FROM Contact];
        System.assertEquals(500,contList.size()); 
        Test.startTest();
        Test.setCurrentPage(Page.task3VF);
        ContactTask3 ext = new ContactTask3 ();
        ApexPages.StandardSetController stdSetController = ext.setcon;
        system.debug(ext.getAllfields().size());
        
        Test.stopTest();
        System.assertEquals(5, stdSetController.getRecords().size());
        System.assertEquals(500, stdSetController.getResultSize());
        System.assertEquals(5, ext.getContacts().size());
        System.assertEquals(7, ext.getAllfields().size());
        System.assertEquals(null, ext.sorting());
        
    }
}