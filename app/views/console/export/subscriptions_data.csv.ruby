require 'csv'

CSV.generate do |csv|
  column_names = %w(No Nama_Bengkel Nama_Owner Bengkel_ID Address Area_Code Product No_VA VA_Name Email No_Subscription Due_Date_Payment_of_New_Bengkel Date_of_Received_Money Sign_Date_of_Subscription Name_of_Sales Sales_Invoice Date_Sales_Invoice Amount Start_Period End_Period)
  csv << column_names
  @subscriptions_data.each_with_index do |v, i|
    column_values = [
      i + 1,                                                        # Number
      v.shop.name,                                                  # Bengkel Name
      v.shop_group.owner_name,                                      # Bengkel Owner Name
      v.shop.bengkel_id,                                            # Bengkel ID
      v.shop.address,                                               # Bengkel Address
      "#{v.va_code_area&.area_name} - #{v.va_code_area&.va_code}",  # Subscription Code Area
      "#{v.plan.capitalize} - #{v.subscription_period}",            # Subscription Product
      v.shop.virtual_bank_no,                                       # Bengkel VA Number
      "ONI QQ #{v.shop.name.upcase}",                               # Bengkel VA Name
      v.shop_group.owner_email,                                     # Bengkel Owner Email
      v.form_number,                                                # Subscription Form Number
      formatedDate(v.shop.expiration_date),                         # Subscription Due Date
      formatedDate(v.payment_date),                                 # Subscription Received Money Date
      formatedDate(v.created_at),                                   # Subscription Sign Date
      v.sales_name,                                                 # Subscription Sales Name
      v.invoice_number,                                             # Subscription Invoice Number
      formatedDate(v.payment_date),                                 # Subscription Invoice Date
      v.fee,                                                        # Subscription Fee
      formatedDate(v.start_date),                                   # Subscription Start Date
      formatedDate(v.end_date)                                      # Subscription End Date
    ]
    csv << column_values
  end
end
