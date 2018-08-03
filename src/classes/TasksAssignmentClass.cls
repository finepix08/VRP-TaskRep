/**
 * Created by nadudike on 5/21/2018.
 */

public with sharing class TasksAssignmentClass {
    public static List<Task> reassignRecords2NewUsers(List<Task> newTasks) {


        List<Id> NeccesseryAccounts = new List<Id>();
        for (Task acc: newTasks) {
            NeccesseryAccounts.add(acc.WhatId);
        }
        system.debug('нужные аккаунты' + NeccesseryAccounts);
        Map<String, String> allAccountsMap = new Map<String, String>();
        for (Account acc: [SELECT Sales_Associate_Number__c, Id from Account where Sales_Associate_Number__c != null AND Id IN :NeccesseryAccounts]) {
            allAccountsMap.put(acc.Id, acc.Sales_Associate_Number__c);
        }

        List<String> NeccesserySANumbers = new List<String>();
        for (String sa: allAccountsMap.keySet()) {
            NeccesserySANumbers.add(allAccountsMap.get(sa));
        }


        Map<String, String> allUsersMap = new Map<String, String>();
        for (User user : [SELECT Sales_Associate_Number__c, Id from User where Sales_Associate_Number__c != null AND Sales_Associate_Number__c IN :NeccesserySANumbers]) {
            allUsersMap.put(user.Sales_Associate_Number__c , user.Id );
        }




        Map<String, String> AccUsers = new Map<String, String>();
        for (String accId: allAccountsMap.keyset()) {
            String saNumberAcc = allAccountsMap.get(accId);
            String userId = allUsersMap.get(saNumberAcc);
            if (userId != null) {
                AccUsers.put(accId, userId );
            }
        }

        for (Task t: newTasks) {
            String userId = AccUsers.get(t.whatid);
            system.debug(userId);
            if(userid != NULL) {
            t.ownerId = userId;
            }
        }

        update newTasks;
        return newTasks;
    }
}