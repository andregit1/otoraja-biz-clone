class AddReferenceToCampaignTypes < ActiveRecord::Migration[5.2]
  def change
    add_reference :campaign_types, :reminder_body_template, index: false, :after => :campaign_type_code

    CampaignType.create(code_type: :customer_remind, campaign_type_code: 'MNTE')
  end
end
