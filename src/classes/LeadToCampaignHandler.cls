/**
 * Created by nadudike on 6/6/2018.
 */

public with sharing class LeadToCampaignHandler {
    public static void AssignLeadToCampaign(List<Lead> newLeadsList) {
        List<Campaign> CampaignFields = [Select Name, StartDate, EndDate, Parent.Name From Campaign where parent.id !=null];
        List<String> ParentCampaignName = new List<String>();
        for (Campaign campaign: CampaignFields) {
            ParentCampaignName.add(campaign.Parent.Name);
        }
        List<CampaignMember> FinalList = new List<CampaignMember>();
        for (Lead newLead:  newLeadsList) {
            if (!ParentCampaignName.contains(newLead.LeadSource) || newLead.LeadSource ==null) {
                newLead.addError('не выбран Сampaign!');
            } else {
                for (Campaign rightChildCompany: CampaignFields) {
                    if (newLead.CreatedDate.month() >= rightChildCompany.StartDate.month() &&
                            newLead.CreatedDate.month() <= rightChildCompany.EndDate.month() &&
                            newLead.LeadSource == rightChildCompany.Parent.Name ) {
                        CampaignMember LeadCampaign = new CampaignMember(LeadId=newLead.Id,CampaignId=rightChildCompany.Id);
                        FinalList.add(LeadCampaign);
                    }
                }
            }
        }
        insert FinalList;
    }
}