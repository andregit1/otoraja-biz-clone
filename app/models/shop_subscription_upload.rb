class ShopSubscriptionUpload
	include ActiveModel::Model

	attr_accessor :file
	validate :valid_data?

	def initialize(attribute = {})
		@file = attribute.fetch(:file, nil)
		@spreadsheet = @file.blank? ? nil : open_spreadsheet(@file)
	end

	def valid_data?
		rows = parse(@spreadsheet)
		tmp_subscription_data = []

		rows.each_with_index do |row, index|
			tmp_subscription_data << row
		end

		@subscription_data_list = tmp_subscription_data
	end

	def import_subscription_data
		tmp_result_import = []
		ActiveRecord::Base.transaction do
			begin
				@subscription_data_list.each do |subs_data|
					shop = Shop.find_by(bengkel_id: subs_data[:bengkel_id])
					if shop != nil
						va_code_area = VaCodeArea.find_by(va_code: subs_data[:va_code])
						subs_data[:reason] = 'Bengkel has been updated.'
						if va_code_area != nil
							add_subscription(shop, subs_data, va_code_area.id)
							tmp_result_import << subs_data
						else
							if subs_data[:va_code] == '00'
								add_subscription(shop, subs_data, 0)
								tmp_result_import << subs_data
							else
								add_subscription(shop, subs_data, nil)
								tmp_result_import << subs_data
							end
						end
					else
						subs_data[:reason] = 'Bengkel ID not found.'
						tmp_result_import << subs_data
					end
				end
			end
		end
		@import_data = tmp_result_import
	end

	private

	def open_spreadsheet(file)
		case File.extname(file.original_filename)
			when '.csv'  then Roo::CSV.new(file.path)
			when '.xls'  then Roo::Excel.new(file.path)
			when '.xlsx' then Roo::Excelx.new(file.path)
		end
	end

	def parse(spreadsheet)
		spreadsheet.parse(
			bengkel_id: "bengkel_id",
			start_date: "start_date",
			end_date: "end_date",
			expiration_date: "expiration_date",
			plan: "plan",
			period: "period",
			fee: "fee",
			payment_date: "payment_date",
			form_number: "form_number",
			invoice_number: "invoice_number",
			va_code: "va_area_code",
			va_number: "va_bank_no",
			sales_name: "sales_name",
			status: "status",
		)
	end

	def add_subscription(shop, subs_data, va_code_area_id)
		va_bank_number = "8162000#{subs_data[:va_code]}#{subs_data[:bengkel_id]}" 
		end_date = !subs_data[:end_date].blank? ? subs_data[:end_date] : subs_data[:expiration_date]
		expired_date = !subs_data[:expiration_date].blank? ? subs_data[:expiration_date] : subs_data[:end_date]

		if subs_data[:start_date].present? && subs_data[:period].present?
			subscription = Subscription.new(
				shop_group: shop.shop_group,
				plan: subs_data[:plan].to_i,
				start_date: subs_data[:start_date],
				end_date: end_date,
				fee: subs_data[:fee],
				period:subs_data[:period].to_i,
				status: :finalized,
				payment_expired: Date.today + ENV['PAYMENT_PERIOD'].to_i.days + 14.hours,
				form_number: subs_data[:form_number],
				invoice_number: subs_data[:invoice_number],
				payment_date: subs_data[:payment_date],
				va_code_area_id: va_code_area_id,
				sales_name: subs_data[:sales_name],
				shop: shop
			)
			subscription.save!
		end
		
		subscriber_type = Subscription.status_subs[subs_data[:status]] if subs_data[:status].present?
		# subscriber_type = 0 if subs_data[:expiration_date].present? && Date.parse(subs_data[:expiration_date]) < Date.today

		shop.expiration_date = expired_date
		shop.active_plan = subscription.id if subscription.present?
		shop.virtual_bank_no = subs_data[:va_number] == va_bank_number ? va_bank_number : subs_data[:va_number] 
		shop.subscriber_type = subscriber_type if subs_data[:status].present?
		shop.is_reactivated = 0	
		shop.save!
	end
end