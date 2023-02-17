class ShopExpiredUpload
	include ActiveModel::Model

	attr_accessor :file
	validate :valid_data?

	def initialize(attribute = {})
		@file = attribute.fetch(:file, nil)
		@spreadsheet = @file.blank? ? nil : open_spreadsheet(@file)
	end

	def valid_data?
		rows = parse(@spreadsheet)
		tmp_expiration_date = []

		rows.each_with_index do |row, index|
			tmp_expiration_date << row
		end

		@expiration_date_list = tmp_expiration_date
	end

	def import_expiration_date
		tmp_result_import = []
		@expiration_date_list.each do |exp_date|
			shop = Shop.find_by(bengkel_id: exp_date[:bengkel_id])
			if shop.present?
				shop.expiration_date = exp_date[:expiration_date]
				shop.save!
				# exp_date[:reason] = 'Bengkel has been updated.'
				# tmp_result_import << exp_date
			else 
				exp_date[:reason] = 'Bengkel ID not found.'
				tmp_result_import << exp_date
			end
		end
		@import_data = tmp_result_import
		#@import_status = true
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
			expiration_date: "expiration_date",
		)
	end
end
  