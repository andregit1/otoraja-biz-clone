class ReceiptA4Pdf < Prawn::Document
  MAX_DETAIL_ROW = 24

  def initialize(checkin, is_cost_estimation = false)
    super(
      page_size: 'A4',
      top_margin: 40,
      bottom_margin: 30,
      left_margin: 20,
      right_margin: 20
    )
    # 開発環境は罫線を出す
    # stroke_axis if Rails.env.development?
    @checkin = checkin
    @maintenance_log = @checkin.maintenance_log
    @is_cost_estimation = is_cost_estimation
    @order_total = 0
    @order_subtotal = 0
    @discount_total = 0
    @total_order_discount = 0
    @row_count = 0
    @has_adjustment = false
    @has_discount = false
    @inner_max_detail_row = MAX_DETAIL_ROW - 5

    checkin_no

    shop_info
    customer_info

    move_down 10

    if is_cost_estimation
      stroke_horizontal_rule
      pad(5) {text "NOTA BENGKEL ESTIMASI", :size => 8, :align => :center}
      stroke_horizontal_rule
      move_down 10
    end

    maintenance_log_detail

    free_area

    # ページフッター
    number_pages(
      'page <page> of <total>',
      {
        :at => [bounds.right - 150, 0],
        :width => 150,
        :align => :right,
        :start_count_at => 1,
        :color => "000000"
      }
    )
  end

  private
    def checkin_no
      move_cursor_to 790
      bounding_box([10, cursor], :width => 180, :height => 20) do
        text "#{I18n.t("receipt.nomor")} : #{ @checkin.id.present? ? @checkin.checkin_no : "--"}", :size => 8
      end
    end

    def shop_info
      move_cursor_to 790
      shop = @checkin.shop
      tel = shop.tel || Prawn::Text::NBSP
      shop_name = shop.name
      text_box "#{shop_name}",
              :at => [10, cursor],
              :width => 300, :height => 32,
              :overflow => :shrink_to_fit,
              :size => 30,
              :min_font_size => 8
      move_cursor_to 760
      bounding_box([10, cursor], :width => 280, :height => 80) do
        text "#{shop.address}", :size => 8
        text "Telp.#{tel}", :size => 8
        text "Resepsionis:#{@checkin.updated_staff_name}", :size => 8
      end
    end

    def customer_info
      customer = @checkin.customer
      maintenance_log = @checkin.maintenance_log
      # name = maintenance_log.name || customer.name
      # tel = customer.tel || ' '
      number_plate = ApplicationController.helpers.formatedNumberPlate(maintenance_log) || ''
      checkin_date = ApplicationController.helpers.formatedDate(@checkin.datetime.in_time_zone('Jakarta').to_date)
      checkin_time = ApplicationController.helpers.formatedTime(@checkin.datetime, 'Jakarta')
      checkin_datetime = "#{checkin_date} #{checkin_time}"
      checkout_date = ApplicationController.helpers.formatedDate(@checkin.checkout_datetime.in_time_zone('Jakarta').to_date)
      checkout_time = ApplicationController.helpers.formatedTime(@checkin.checkout_datetime, 'Jakarta')
      checkout_datetime = "#{checkout_date} #{checkout_time}"
      move_cursor_to 760
      nbsp = Prawn::Text::NBSP
      span(260, :position => :right, :height => 100) do
        font 'Courier'
        label_w = 12
        value_w = 20
        # text "<font size='10'>#{'Nama Pelanggan:'.ljust(label_w, nbsp)}</font><u>#{name.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true, :align => :justify
        # text "<font size='10'>#{'No Telpon:'.ljust(label_w, nbsp)}</font><u>#{tel.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true
        text "<font size='10'>#{'No Polisi:'.ljust(label_w, nbsp)}</font><u>#{number_plate.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true
        text "<font size='10'>#{'Masuk:'.ljust(label_w, nbsp)}</font><u>#{checkin_datetime.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true
        text "<font size='10'>#{'Selesai:'.ljust(label_w, nbsp)}</font><u>#{checkout_datetime.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true
        font 'Helvetica'
      end
    end

    def maintenance_log_detail
      related_product_count = 0
      data = []
      header = ['', 'Jenis servis / Jenis produk', 'Jumlah', 'Harga', 'Diskon', 'Subtotal']
      data << header
      @maintenance_log.maintenance_log_details.each.with_index(1) do |detail, i|
        item_name = "#{detail.name} #{detail.product_no || ''}"
        quantity = detail.quantity || 0
        unit_price = detail.unit_price || 0
        discount = detail.discount_amount || 0
        subtotal = detail.subtotal || 0

        @order_subtotal += (unit_price*quantity)
        @order_total += subtotal
        @discount_total += discount

        data << [
          i,
          {
            :content => item_name,
            :inline_format => true,
          },
          {
            :content => formatedRupiah(quantity),
            :align => :right
          },
          {
            :content => formatedRupiah(unit_price),
            :align => :right
          },
          {
            :content => "-#{formatedRupiah(discount)}",
            :align => :right
          },
          {
            :content => formatedRupiah(subtotal),
            :align => :right
          }
        ]
        related_product_count += detail.maintenance_log_detail_related_products.count
        detail.maintenance_log_detail_related_products.each do |related_product|
          nbsp = Prawn::Text::NBSP
          data << [
            '',
            {
              :content => "#{nbsp}#{nbsp}#{related_product.item_name}#{nbsp}#{related_product.product_no || ''}",
              :inline_format => true,
            },
            ' ', ' ', ' ', ' '
          ]
        end
        unless discount == 0
          @has_discount = true
        end
        @row_count = i;
      end
      adjustment(data)
      order_discount(data)
      if(@has_adjustment)
        @inner_max_detail_row -= 1
      end
      if(@has_discount)
        @inner_max_detail_row -= 1
      end
      @inner_max_detail_row -= related_product_count
      (@row_count + 1).upto(@inner_max_detail_row).with_index do |i|
        data << [i, ' ', ' ', ' ', ' ', ' ']
      end

      data << [
        {
          :colspan => 6,
        }
      ]
      last_row = @inner_max_detail_row + related_product_count + 1
      totals(data)
      table(
        data,
        :position => :center,
        :width => 500,
        :header => true,
        :column_widths => [30, 230, 50, 60, 60, 70],
        :cell_style => {
          :size => 10,
        },
        :row_colors => ['F0F0F0', 'FFFFFF']
      ) do
        cells.borders = []
        # サービス一覧ヘッダ
        row(0).background_color = '000000'
        row(0).text_color = 'FFFFFF'
        # 詳細罫線
        row(1..MAX_DETAIL_ROW - 1).columns(0..header.length).borders = [:right, :left]
        row(last_row).background_color = '000000'
        row(last_row).height = 25
        row(MAX_DETAIL_ROW).columns(0..header.length).borders = [:right, :left, :bottom]
        # 合計フッター
        row(MAX_DETAIL_ROW + 1).background_color = '000000'
        row(MAX_DETAIL_ROW + 1).text_color = 'FFFFFF'
      end
    end

    def adjustment(data)
      unless @maintenance_log.adjustment.nil? || @maintenance_log.adjustment == 0
        data << [
          @row_count,
          {
            :content => I18n.t("receipt.adjustment"),
            :inline_format => true,
          },
          {
          },
          {
          },
          {
          },
          {
            :content => formatedRupiah(@maintenance_log.adjustment),
            :align => :right
          }
        ]
        @has_adjustment = true
        @row_count += 1
      end
      data
    end

    def order_discount(data)
      unless (@order_total - @maintenance_log.total_price) == 0
        discount_area_total = (@order_total - @maintenance_log.total_price)
        data << [
          @row_count,
          {
            :content => I18n.t("receipt.discount"),
            :inline_format => true,
          },
          {
            
          },
          {
            
          },
          {
            
          },
          {
            :content => "-#{formatedRupiah(discount_area_total)}",
            :align => :right
          }
        ]
        @has_discount = true
        @row_count += 1
      end
      data
    end

    def totals(data)
      data << [
        '',
        {
          :content => I18n.t("receipt.sub_total"),
          :inline_format => true,
        },
        {
        },
        {
        },
        {
        },
        {
          :content => formatedRupiah(@order_subtotal),
          :align => :right
        }
      ]
      unless @maintenance_log.adjustment.nil? || @maintenance_log.adjustment == 0
        data << [
          '',
          {
            :content => I18n.t("receipt.adjustment"),
            :inline_format => true,
          },
          {
          },
          {
          },
          {
          },
          {
            :content => formatedRupiah(@maintenance_log.adjustment),
            :align => :right
          }
        ]
      end
      
      @total_order_discount = @discount_total + (@order_total - @maintenance_log.total_price)
      unless @total_order_discount == 0
        data << [
          '',
          {
            :content => I18n.t("receipt.discount"),
            :inline_format => true,
          },
          {
          },
          {
          },
          {
          },
          {
            :content => formatedRupiah(@total_order_discount),
            :align => :right
          }
        ]
      end
  
      @order_subtotal = (@order_subtotal - @total_order_discount)+(@maintenance_log.adjustment || 0)
      @total_paid = if @is_cost_estimation
        0
      elsif @maintenance_log.amount_paid.nil?
        @order_subtotal
      else
        @maintenance_log.amount_paid
      end

      data << [
        '',
        {
          :content => I18n.t("receipt.total"),
          :inline_format => true,
        },
        {
        },
        {
        },
        {
        },
        {
          :content => formatedRupiah(@order_subtotal),
          :align => :right
        }
      ]
  
      data << [
        '',
        {
          :content => I18n.t("receipt.paid"),
          :inline_format => true,
        },
        {
        },
        {
        },
        {
        },
        {
          :content => formatedRupiah(@total_paid),
          :align => :right
        }
      ]

      order_change = @maintenance_log.amount_paid.nil?  ? 0 : @maintenance_log.amount_paid - @order_subtotal
      data << [
        '',
        {
          :content => I18n.t("receipt.change"),
          :inline_format => true,
        },
        {
        },
        {
        },
        {
        },
        {
          :content => formatedRupiah(order_change),
          :align => :right
        }
      ]
      data
    end

    def free_area
      bounding_box([28, 130], :width => 500, :height => 125) do
        stroke_bounds
        if @maintenance_log.has_remarks
          move_down 10
          indent(10, 15) do
            text "Catatan:", :size => 8
            text @maintenance_log.remarks, :size => 8
          end
        end
      end
    end

    def formatedRupiah(value)
      ApplicationController.helpers.formatedRupiah(value)
    end
end
