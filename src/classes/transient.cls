/**
 * Created by nadudike on 8/1/2018.
 */

public with sharing class transient {
    private final Id accountId ;
    transient public final String accountName {get; set; }

    public transient() {
        Account account = [select Id, Name from Account limit 1];
        accountId = account.Id;
        accountName = account.Name;
    }

    public PageReference save() {
        Account myAccount = [select name from Account where id = :accountId];
        myAccount.name = accountName ;
        update myAccount;
        return null;
    }
}