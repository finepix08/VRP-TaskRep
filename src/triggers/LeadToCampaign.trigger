/**
 * Created by nadudike on 6/6/2018.
 */

trigger LeadToCampaign on Lead (after insert) {
    LeadToCampaignHandler.AssignLeadToCampaign(trigger.new);
}