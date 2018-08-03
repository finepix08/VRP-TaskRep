public with sharing class PencilController {

  public List<Pencil__c> Pencil { get; set; }
  public List<Pensil_Box1__c> Box { get; set; }
  
  public PencilController() {
      Pencil = [SELECT Name, OwnerId, Createddate from Pencil__c];
      Box = [SELECT Name from Pensil_Box1__c];
  }
  
  public PageReference UpdateMe() {
       update Pencil;
       update Box;
       return null;
  }
  

}