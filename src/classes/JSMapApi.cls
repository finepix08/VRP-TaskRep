public class JSMapApi {
	public String contactName { get; set; }
    public static List<Contact> contactList { get; set; }
    public JSMapApi() { } // empty constructor


    public static List<Contact> getContacts () {
        List<Contact> contactList = [SELECT Id, Name, MailingAddress
                   FROM Contact];
        return contactList;
    }
}