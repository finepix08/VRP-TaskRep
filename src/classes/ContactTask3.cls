public with sharing class ContactTask3 {
    private static final String QUERY = 'SELECT  LastName, Title, Account.Name, Phone, MobilePhone, email, Owner.Name FROM Contact ORDER BY ';
    public Integer list_size { get; set; }
    public String fields { get; set; }
    public String itemId { get; set; }
    public String phoneId { get; set; }
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public Id updatedContactId { get; set; }

    public ContactTask3() {
        list_size = 50;
    }

    public List<SelectOption> getAllfields() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('LastName', Contact.LastName.getDescribe().Name));
        options.add(new SelectOption('Title', Contact.Title.getDescribe().Name));
        options.add(new SelectOption('Account.Name', Contact.AccountId.Name.getDescribe().getName()));
        options.add(new SelectOption('Phone', Contact.Phone.getDescribe().Name));
        options.add(new SelectOption('Email', Contact.Email.getDescribe().Name));
        options.add(new SelectOption('MobilePhone', Contact.MobilePhone.getDescribe().Name));
        options.add(new SelectOption('Owner.Name', Contact.Owner.Name.getDescribe().getName()));
        return options;
    }

    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp) {
                sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC';
            } else {
                sortDirection = 'ASC';
                sortExp = value;
            }
        }
    }

    public String getSortDirection()
    {
        //if not column is selected
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
                return sortDirection;
    }

    public void setSortDirection(String value)
    {
        sortDirection = value;
    }


    public ApexPages.StandardSetController setCon {
        get {
            if (fields == null) {
                fields = 'LastName';
            }
            if (setcon == null) {
                stSetContr(fields);
            }
            return setCon;
        }
        set;
    }

    public List<Contact> getContacts() {
        setCon.setPageSize(list_size);
        return (List<Contact>) setCon.getRecords();
    }

    public PageReference sorting() {
        setcon = null;
        return null;
    }

    public void doDelete() {
        List<Contact> cont = [SELECT Id FROM Contact WHERE Id=:itemId];
        if(!cont.isEmpty()){
            delete cont[0];
            stSetContr(fields);
        }
    }

    public void doEdit() {
        system.debug('---updatedContact ' + updatedContactId);
        for (Contact cnt : (List<Contact>) setCon.getRecords()) {
            if (cnt.Id == updatedContactId) {
                system.debug('---cnt ' + cnt);
                update cnt;
                break;
            }
        }
    }

    public PageReference stSetContr(String sortField) {
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(QUERY + sortField));
        setCon.setPageSize(list_size);
        return null;
    }

    public void ViewData() {
        //build the full sort expression
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        //query the database based on the sort expression
        stSetContr(sortFullExp);
    }


}