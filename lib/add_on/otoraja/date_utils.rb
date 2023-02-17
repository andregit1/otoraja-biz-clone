module Otoraja
  class DateUtils 
    def self.parse_date_tz(date, tz: '+0700')
      day = Date.parse(date)
      DateTime.parse("#{day.year}-#{day.month}-#{day.day} 00:00:00 #{tz}").in_time_zone('UTC')
    end

    def self.parse_end_date_tz(date, tz: '+0700')
      day = Date.parse(date)
      parsed_date = DateTime.parse("#{day.year}-#{day.month}-#{day.day} 00:00:00 #{tz}")
      (parsed_date.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')
    end
  end
end