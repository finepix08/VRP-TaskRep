public with sharing class Participation {

    public Participation(ApexPages.StandardSetController part1)
    {
        CourcesList = new List<Cource__c>([Select Id, Name FROM Cource__c]);
        GradeList = new List<Participation__c>([Select Id, Grade__c FROM Participation__c]);
        SelectedCource='';
    }
    
    public List<Cource__c> CourcesList {get;set;}
    public List<Participation__c> GradeList {get;set;}
    public String SelectedCource {get;set;}
    public String matchGradeId  {get;set;}
    public List<Participation__c> participant2 { get; set; }
    
    public List<selectOption> getaccts() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectoption('','Select one'));
        for (Cource__c cource : CourcesList) { 
            options.add(new selectOption(cource.Id, cource.Name)); 
        }
        return options;
    }
    
    public List<selectOption> getgrades() {
        List<selectOption> options = new List<selectOption>();
        Set<string>grades = new set<string>();
        for (Participation__c grade : GradeList) {
            if(grades.contains(grade.Grade__c)) {
            } else {
            grades.add(grade.Grade__c);
                if (grade.Grade__c==null) {
                    options.add(new selectOption(grade.Id, ' '));
                    matchGradeId = grade.Id;
                } else {
                    options.add(new selectOption(grade.Id, grade.Grade__c));
                    matchGradeId = grade.Id;
                }
            }
        }
        
        return options;
    }

    public List <Participation__c> getparticipations1(){
        List<Participation__c> participant = new List<Participation__c>
        ([Select Id, Name,Grade__C,Result__c,Student__r.Name from participation__c where Cource__r.Id=:SelectedCource]);
        return participant;
        
    }
    
    public PageReference getDetails(){
    participant2 = new List <Participation__c>();
    for (Participation__c PartObj:getparticipations1()){
        participant2.add(PartObj);
    }
    return null;
    }
}