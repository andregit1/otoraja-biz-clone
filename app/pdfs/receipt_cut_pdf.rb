class ReceiptCutPdf < Prawn::Document
  include ActiveStorage::Downloading
  MAX_DETAIL_ROW = 14

  # recipt最大高さ
  MOVE_CURSOR_TO_MAX = 841.89

  def initialize(checkin, reason = false)
    @checkin = checkin
    @is_checkout = @checkin.is_checkout?
    @maintenance_log = @checkin.maintenance_log
    @shop = @checkin.shop
    @is_cost_estimation = reason == :cost ? true : false
    @is_down_payment = reason == :down_payment ? true : false
    @has_logo = @shop.shop_logo.attached? ? 55 : 0
    @adjust_height = @shop.shop_logo.attached? ? 170 : 200
    @grayscle = true
    @order_total = 0
    @order_subtotal = 0
    @discount_total = 0
    @total_order_discount = 0
    @has_order_discount = false
    @has_adjustment = false
    # reciptの高さ算出後に格納する変数
    @receipt_height = 0
    # 高さ算出
    receiptHeightCalc

    super(
      page_size: [198.43, @receipt_height],
      top_margin: 10,
      bottom_margin: 10,
      left_margin: 10,
      right_margin: 10
    )
    # 開発環境は罫線を出す
    # stroke_axis if Rails.env.development?

    checkin_no
    
    shop_info

    move_down 10
    dash(3, phase: 3)
    stroke_horizontal_line 0, 180
    pad(5) {text "#{I18n.t("receipt.nota")}#{" - " if @is_cost_estimation || @is_checkout}#{I18n.t("receipt.estimate") if @is_cost_estimation}#{I18n.t("receipt.sattled") if @is_checkout}", :size => 8, :align => :center}
    stroke_horizontal_rule
    move_down 5

    # update layout 8 Desc without header
    # maintenance_log_detail_header

    maintenance_log_detail
    move_down 5

    order_discount

    totals

    memo

    thanks

    # ページフッター
    # number_pages(
    #   '<page> / <total>',
    #   {
    #     :at => [bounds.right - 30, 18],
    #     :width => 30,
    #     :align => :right,
    #     :start_count_at => 1,
    #     :color => "000000"
    #   }
    # )
  end

  def checkin_no
    move_cursor_to @receipt_height - 21.89
    bounding_box([0, cursor], :width => 180, :height => 20) do
      text "#{I18n.t("receipt.nomor").upcase} : #{ @checkin.id.present? ? @checkin.checkin_no : "--"}", :size => 8
    end
  end

  def shop_info
    move_cursor_to @receipt_height - 41.89
    shop = @checkin.shop
    
    if @shop.shop_logo.attached?
      shop_logo
    end
    move_cursor_to @receipt_height - (41.89 + @has_logo)
    tel = shop.tel || Prawn::Text::NBSP
    shop_name = shop.name
    staff_name = @checkin.updated_staff_name|| Prawn::Text::NBSP
    text_box "#{shop_name.upcase}",
            :at => [0, cursor],
            :width => 180, :height => 32,
            :overflow => :shrink_to_fit,
            :min_font_size => 8,
            :align => :center
    # bounding_box([0, cursor], :width => 180, :height => 80, :overflow => :shrink_to_fit) do
    #   text "#{shop.address.upcase}", :size => 8
    #   # text "#{I18n.t("receipt.tel")}#{tel}", :size => 8
    #   # text "#{I18n.t("receipt.staff")}#{@checkin.updated_staff_name}", :size => 8
    # end
    data = [
      [
        {
          :content =>check_empty(shop.address),
          :colspan => 5,
          :align => :left
        }
      ],
      [
        {
          :content =>"",
          :colspan => 5,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.tel').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(tel),
          :colspan => 3,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.staff').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(staff_name),
          :colspan => 3,
          :align => :left
        }
      ]
    ]
    data += customer_info if @is_cost_estimation == false 

    move_cursor_to @receipt_height - (54.89 + + @has_logo)
    table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [60,10,110],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
    ) do
      cells.borders = []
    end
    
    # nbsp = Prawn::Text::NBSP
    
    # span(180, :position => :right, :height => 100) do
    #   #font 'Courier'
    #   label_w = 20
    #   value_w = 20
    #   text "#{I18n.t('receipt.tel').upcase.ljust(label_w, nbsp)}#{tel.ljust(value_w, nbsp)}", :size => 8
    #   text "#{I18n.t('receipt.staff').upcase.ljust(label_w, nbsp)}#{staff_name.ljust(value_w, nbsp)}", :size => 8
    #   #font 'Courier'
    # end
  end

  def customer_info
    customer = @checkin.customer
    maintenance_log = @checkin.maintenance_log
    
    # name = maintenance_log.name || customer.name
    # tel = customer.tel || ' '
    number_plate = ApplicationController.helpers.formatedNumberPlate(maintenance_log) || ''
    bikes_maker = @maintenance_log.maker || ''
    bikes_model = @maintenance_log.model || ''
    bikes = "#{bikes_maker} #{bikes_model}"
    odometer = @maintenance_log.odometer.to_s || ''
    checkin_date = ApplicationController.helpers.formatedDate(@checkin.datetime.in_time_zone('Jakarta').to_date)
    checkin_time = ApplicationController.helpers.formatedTime(@checkin.datetime, 'Jakarta')
    checkin_datetime = "#{checkin_date} #{checkin_time}"
    checkout_date = ApplicationController.helpers.formatedDate(@checkin.checkout_datetime.in_time_zone('Jakarta').to_date) if @checkin.checkout_datetime.present?
    checkout_time = ApplicationController.helpers.formatedTime(@checkin.checkout_datetime, 'Jakarta') if @checkin.checkout_datetime.present?
    checkout_datetime = "#{checkout_date} #{checkout_time}"
    
    data = [
      [
        {
          :content => I18n.t('receipt.motor').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(bikes),
          :colspan => 3,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.licence_no').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(number_plate),
          :colspan => 3,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.odometer').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(odometer),
          :colspan => 3,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.mechanic').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(@maintenance_log&.maintained_staff&.name),
          :colspan => 3,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.checkin').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(checkin_datetime),
          :colspan => 3,
          :align => :left
        }
      ],
      [
        {
          :content => I18n.t('receipt.checkout').upcase,
          :align => :left
        },
        {
          :content => ":",
          :align => :center
        },
        {
          :content => check_empty(checkout_datetime),
          :colspan => 3,
          :align => :left
        }
      ]
    ]
    return data
    # move_cursor_to @receipt_height - (109.89 + @has_logo)
    # table(
    #   data,
    #   :position => :center,
    #   :width => 180,
    #   :header => true,
    #   :column_widths => [60,10,110],
    #   :cell_style => {
    #     :size => 8,
    #     :padding => 2,
    #   },
    # ) do
    #   cells.borders = []
    # end
    # nbsp = Prawn::Text::NBSP
    # span(180, :position => :right, :height => 100) do
    #   #font 'Courier'
    #   label_w = 20
    #   value_w = 25
    #   # text "<font size='10'>#{'Nama Pelanggan:'.ljust(label_w, nbsp)}</font><u>#{name.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true, :align => :justify
    #   # text "<font size='10'>#{'No Telpon:'.ljust(label_w, nbsp)}</font><u>#{tel.ljust(value_w, nbsp)}</u>", :size => 14, :inline_format => true
    #   text "<font size='8'>#{I18n.t('receipt.licence_no').upcase.ljust(label_w, nbsp)}</font><font size='8'>#{number_plate.ljust(value_w, nbsp)}</font>", :size => 8, inline_format: true
    #   text "<font size='8'>#{I18n.t('receipt.odometer').upcase.ljust(label_w, nbsp)}</font><font size='8'>#{odometer.ljust(value_w, nbsp)}</font>", :size => 8, inline_format: true
    #   text "<font size='8'>#{I18n.t('receipt.checkin').upcase.ljust(label_w, nbsp)}</font><font size='8'>#{checkin_datetime.ljust(value_w, nbsp)}</font>", :size => 8, inline_format: true
    #   text "<font size='8'>#{I18n.t('receipt.checkout').upcase.ljust(label_w, nbsp)}</font><font size='8'>#{checkout_datetime.ljust(value_w, nbsp)}</font>", :size => 8, inline_format: true
    #   #font 'Helvetica'
    # end
  end

  def maintenance_log_detail_header
    data = []
    header_area = [
      {
        :content => "Qty",
        :align => :left
      },
      {
        :content => 'Nama Produk',
        :colspan => 3,
        :align => :left
      },
      {
        :content => "Total",
        :align => :right
      }
    ]
    data << header_area
    table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [20, 30, 40, 40, 50],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
    ) do
      cells.borders = []
    end
    stroke do
      move_down 2
      horizontal_rule()
    end
  end

  def maintenance_log_detail
    data = []
    @maintenance_log.maintenance_log_details.each do |detail|
      
      item_name = "#{detail.name}\n#{detail.product_no || ''}"
      quantity = detail.quantity || 0
      unit_price = detail.unit_price || 0
      discount = detail.discount_amount || 0
      subtotal = detail.subtotal || 0
      totalPrice = unit_price * quantity || 0

      @order_subtotal += (unit_price*quantity)
      @order_total += subtotal
      @discount_total += discount

      data << [
        {
          :content => formatedRupiah(quantity),
          :align => :left,
          :colspan => 1
        },
        {
          :content => check_empty(item_name),
          :inline_format => true,
          :colspan => 3,
          :align => :left,
        },
        {
          :content => formatedRupiah(totalPrice),
          :align => :right
        },
      ]
      nbsp = Prawn::Text::NBSP
      # detail.maintenance_log_detail_related_products.each do |related_product|
      #   data << [
      #     {
      #       :content => "#{nbsp}#{nbsp}#{related_product.item_name.upcase}#{nbsp}#{related_product.product_no}",
      #       :inline_format => true,
      #       :colspan => 5,
      #     },
      #   ]
      # end
      if discount > 0
        @has_order_discount = true
        data << [
          {
            :content => nbsp+nbsp+nbsp+nbsp+I18n.t('receipt.discount_small').upcase,
            :inline_format => true,
            :colspan => 4,
            :align => :right,
          },
          {
            :content => "-#{formatedRupiah(discount)}",
            :align => :right
          },
        ]
        data << [
          :content => '',
          :inline_format => true,
        ]
      end
    end

    # (maintenance_log.maintenance_log_details.length + 1).upto(MAX_DETAIL_ROW).with_index do |i|
    #   data << [' ',]
    #   data << [' ', ' ', ' ', ' ',]
    # end
    table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [20, 50, 50, 20, 40],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
      # :row_colors => ['F0F0F0', 'FFFFFF']
    ) do
      cells.borders = []
      # サービス一覧ヘッダ
      # row(0).background_color = '000000'
      # row(0).text_color = 'FFFFFF'
      # 詳細罫線
      # row(1..MAX_DETAIL_ROW - 1).columns(0..4).borders = [:right, :left]
      # row(MAX_DETAIL_ROW).columns(0..4).borders = [:right, :left, :bottom]
      # 合計フッター
      # row(MAX_DETAIL_ROW + 1).background_color = '000000'
      # row(MAX_DETAIL_ROW + 1).text_color = 'FFFFFF'
    end
    stroke do
      move_down 2
      horizontal_rule()
    end
  end

  def memo
    if @maintenance_log.has_remarks
      stroke do
        move_down 2
        horizontal_rule()
      end
      data = []
      title = [
        {
          :content => 'MEMO:',
          :align => :left
        }
      ]
      data << title
      memo = [
        {
          :content => @maintenance_log.remarks,
          :align => :left
        }
      ]
      data << memo
      table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [180],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
    ) do
      cells.borders = []
    end
      stroke do
        move_down 5
      end
    end
  end

  def order_discount
    data = []
    unless (@order_total - @maintenance_log.total_price) == 0
      @has_order_discount = true
      discount_area_total = (@order_total - @maintenance_log.total_price)
      discount_area = [
        {
          :content => 'Diskon',
          :colspan => 3,
          :align => :left
        },
        {
          :content => "-#{formatedRupiah(discount_area_total)}",
          :colspan => 2,
          :align => :right
        }
      ]
      data << discount_area
      table(
        data,
        :position => :center,
        :width => 180,
        :header => true,
        :column_widths => [20, 30, 40, 40, 50],
        :cell_style => {
          :size => 8,
          :padding => 2,
        },
      ) do
        cells.borders = []
      end
      stroke do
        move_down 2
        horizontal_rule()
      end
    end
  end

  def totals
    data = []
    
    sub_total_line = [
      {
        :content => I18n.t('receipt.sub_total').upcase,
        :colspan => 3,
        :align => :left
      },
      {
        :content => "#{formatedRupiah(@order_subtotal || 0)}",
        :colspan => 2,
        :align => :right
      }
    ]
    data << sub_total_line

    #unless @maintenance_log.adjustment.nil? || @maintenance_log.adjustment == 0
      adjustment_line = [
        {
          :content => I18n.t('receipt.adjustment').upcase,
          :colspan => 3,
          :align => :left
        },
        {
          :content => "#{formatedRupiah(@maintenance_log.adjustment || 0)}",
          :colspan => 2,
          :align => :right
        }
      ]
      data << adjustment_line
    #end
    
    @total_order_discount = @discount_total + (@order_total - @maintenance_log.total_price)
    @order_subtotal = (@order_subtotal - @total_order_discount)+(@maintenance_log.adjustment || 0)
    @down_payment = @maintenance_log.total_down_payment_amount 
    @total_paid = if @is_cost_estimation || @is_down_payment
      0
    elsif @maintenance_log.amount_paid.nil?
      @order_subtotal - @down_payment
    else
      @maintenance_log.amount_paid - @down_payment
    end
    
    @bill_payment = @maintenance_log.total_price - @down_payment
    subtotal_line = [
      {
        :content => I18n.t('receipt.total').upcase,
        :colspan => 3,
        :align => :left
      },
      {
        :content => "#{formatedRupiah(@order_subtotal)}",
        :colspan => 2,
        :align => :right
      }
    ]
    data << subtotal_line

    downpayment_line = [
      {
        :content => I18n.t('receipt.downpayment').upcase,
        :colspan => 3,
        :align => :left
      },
      {
        :content => "#{formatedRupiah(@down_payment)}",
        :colspan => 2,
        :align => :right
      }
    ]
    data << downpayment_line

    downpayment_line = [
      {
        :content => I18n.t('receipt.bill_payment').upcase,
        :colspan => 3,
        :align => :left
      },
      {
        :content => "#{formatedRupiah(@bill_payment)}",
        :colspan => 2,
        :align => :right
      }
    ]
    data << downpayment_line
    table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [20, 30, 40, 40, 50],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
    ) do
      cells.borders = []
    end
    stroke do
      move_down 2
      horizontal_rule()
    end
    data = []

    amount_paid_line = [
      {
        :content => I18n.t('receipt.paid').upcase,
        :colspan => 3,
        :align => :left
      },
      {
        :content => "#{formatedRupiah(@total_paid)}",
        :colspan => 2,
        :align => :right
      }
    ]
    data << amount_paid_line

    order_change = @maintenance_log.amount_paid.nil? ? 0 : @maintenance_log.amount_paid - @order_subtotal
    change_line = [
      {
        :content => I18n.t('receipt.change').upcase,
        :colspan => 3,
        :align => :left
      },
      {
        :content => "#{formatedRupiah(order_change)}",
        :colspan => 2,
        :align => :right,
        :borders => [:bottom]
      }
    ]
    data << change_line
    
    table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [20, 30, 40, 40, 50],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
    ) do
      cells.borders = []
    end
    move_down 5
  end

  def formatedRupiah(value)
    ApplicationController.helpers.formatedRupiah(value)
  end

  def receiptHeightCalc
    lines = 0
    @checkin.maintenance_log.maintenance_log_details.each do |detail|
      if detail.name.length > 0
        lines += ((detail.name.length.to_f / 20)).ceil
      else
        lines += 1
      end
    end
    discount_lines = (@checkin.maintenance_log.maintenance_log_details.where('discount_type IS NOT NULL').size.to_f / 20).ceil

    # @receipt_height = 160 + ((discount_lines+lines)*15) + 120 + 30
    logo_height = @shop.shop_logo.attached? ? 50 : 0
    customer_info_height = @is_cost_estimation ? 0 : @adjust_height
    @receipt_height = 160 + ((discount_lines+lines)*12) + 50 + customer_info_height + logo_height
  end

  def thanks
    move_down 5
    horizontal_rule()
    data = []
    if @is_cost_estimation || @is_down_payment
      cost_estimation_start = [
        {
          :content => 'NOTA INI DIBUAT PADA',
          :align => :center
        }
      ]
      cost_estimation_date = [
        {
          :content => "#{DateTime.now.in_time_zone('Jakarta').strftime('%d-%b-%Y %H:%M:%S')}",
          :align => :center
        }
      ]
      cost_estimation_end = [
        {
          :content => 'DAN MASIH DAPAT BERUBAH',
          :align => :center
        }
      ]
      data << cost_estimation_start
      data << cost_estimation_date
      data << cost_estimation_end
    else
      thank = [
        {
          :content => 'TERIMA KASIH',
          :align => :center
        }
      ]
      thank_date = [
        {
          :content => "#{DateTime.now.in_time_zone('Jakarta').strftime('%d-%b-%Y %H:%M:%S')}",
          :align => :center
        }
      ]
      data << thank
      data << thank_date
    end
    table(
      data,
      :position => :center,
      :width => 180,
      :header => true,
      :column_widths => [180],
      :cell_style => {
        :size => 8,
        :padding => 2,
      },
    ) do
      cells.borders = []
    end
    stroke do
      move_down 2
      horizontal_rule()
    end
  end

  def blob 
    return @shop.shop_logo.attachment.blob
  end
  
  def shop_logo 
    if @shop.shop_logo.attached?
      download_blob_to_tempfile do |file|
        if @grayscle
          system("convert #{file.path} -colorspace Gray #{file.path} ")
          # blend_modes = %i[
          #   Difference Exclusion
          #  ]
          image "#{file.path}", position: :center, height: 50
          # blend_mode(:Difference) do
          #   image "#{file.path}", at: [60, cursor],  height: 50
          # end
        else 
          image "#{file.path}", position: :center, height: 50
        end
      end
    end
  end
  def check_empty(var)
    var.present? ? var&.upcase : "--"
  end
end
