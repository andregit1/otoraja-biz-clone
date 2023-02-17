class SubscriptionReceiptA4Pdf < Prawn::Document
  MAX_DETAIL_ROW = 1

  def initialize(subscription)
    super(
      page_size: 'A4',
      top_margin: 40,
      bottom_margin: 30,
      left_margin: 50,
      right_margin: 50
    )
    @subscription = subscription
    
    header
    body
    footer

    # ページフッター
    number_pages(
      'Terima kasih telah memilih PT OTORAJA NETWORK INDONESIA',
      {
        :at => [0, 0],
        :width => 500,
        :align => :center,
        :size => 10
      }
    )
  end

  private
  def header
    image (Rails.root.join('app/assets/images/otoraja-horizontal_256x80.png')), :position => :center
    move_down 15
  end

  def body
    data = []
    shop_detail = []
    form_number = @subscription.form_number || ""

    invoice = [ '','INVOICE' ]
    data << invoice

    from = [
      {
        :content => '<b>LUNAS</b>',
        :align => :center,
        :valign=> :center,
        :inline_format => true,
        :size => 30
      },
      {
        :content => "<b>PT. OTORAJA NETWORK INDONESIA</b> <br/> Sinarmas MSIG Tower Lantai 41 <br/> Jl. Jend Sudirman Kav 21, Setiabudi <br/> Jakarta Selatan 12920 <br/> Telepon : 021-5214077/ 5214078 <br/> Email : #{ENV['FINANCE_EMAIL']}",
        :inline_format => true,
        :size => 10,
        :leading => 4
      }
    ]
    data << from

    table(
      data,
      :position => :center,
      :column_widths => [245, 243]
    )do
      cells.borders = []
      cells.padding = [1,2]
    end

    move_down 15

    row_1 = [
      {
        :content => 'Kepada Yth.Pelanggan: ',
        :inline_format => true,
        :height => 17,
        :colspan => 3
      },
      {
        :content => 'No. Invoice',
        :inline_format => true,
      },
      {
        :content => ': ' + @subscription.invoice_number,
        :inline_format => true,
      }
    ]    
    shop_detail << row_1

    row_2 = [
      {
        :content => 'Nama ',
        :inline_format => true,
        :height => 17,
        :width => 50
      },
      {
        :content => ':',
        :inline_format => true,
        :width => 5
      },
      {
        :content => @subscription.shop.shop_group.name,
        :inline_format => true,
        :width =>189
      },
      {
        :content => 'Tanggal Invoice',
        :inline_format => true,
        :width => 125,
      },
      {
        :content => ': ' + formatedMonthSpace(@subscription.created_at),
        :inline_format => true,
        :width => 120,
      }
    ]    
    shop_detail << row_2

    row_3 = [
      {
        :content => 'Bengkel ID ',
        :inline_format => true,
        :height => 17,
      },
      ': ',
      @subscription.shop.bengkel_id.to_s,
      {
        :content => 'No. Formulir Berlangganan',
        :inline_format => true,
      },
      {
        :content => ': ' + form_number,
        :inline_format => true,
      }
    ]    
    shop_detail << row_3

    row_4 = [
      {
        :content => 'Alamat',
        :inline_format => true
      },
      ':',
      @subscription.shop.address,
      {
        :content => 'Tanggal Bayar',
        :inline_format => true,
      },
      {
        :content => ': ' + formatedMonthSpace(@subscription.payment_date),
        :inline_format => true,
      }
    ]    
    shop_detail << row_4

    table(
      shop_detail,
      :position => :center,
      :cell_style => {
        :size => 10,
      }
    )do
      cells.borders = []
      cells.padding = [2,2]
    end

  end

  def footer
    footer_package = []
    footer_total = []
    footer_account= []

    header = [
      {
        :content => '<b>Deskripsi</b>',
        :inline_format => true,
      },
      {
        :content => '<b>Total</b>',
        :inline_format => true,
        :align => :center,
      },
    ]
    footer_package << header
    
    period = SubscriptionPeriod.find_by(period: Subscription.periods[@subscription.period])

    stroke do
      move_down 30
    end

    data = [
      {
        :content => "Biaya Berlangganan Otoraja Biz Selama #{period.label} <br/><br/> Masa aktif mulai #{formatedDateUseSpace(@subscription.start_date)} s.d #{formatedDateUseSpace(@subscription.end_date - 1.day)}",
        :inline_format => true,
      },
      {
        :content => "Rp#{formatedRupiah(@subscription.fee)}",
        :align => :center,
        :valign => :center,
      },
    ]
    footer_package << data

    total = [
      {
        :content => '',
        :borders => [],
      },
      'Total',
      {
        :content => "Rp#{formatedRupiah(@subscription.fee)}",
        :align => :center,
      },
    ]
    footer_total << total

    account_header = [
      'Informasi Akun',
    ]
    footer_account << account_header

    virtual_account = [
      'Nomor Virtual Akun',
      ": #{@subscription.shop.virtual_bank_no}",
    ]
    footer_account << virtual_account

    bank = [
      'Nama Bank',
      ': PT Bank Sinarmas, Tbk.',
    ]
    footer_account << bank

    name = [
      'Nama Akun',
      ": ONI QQ #{@subscription.shop.name}",
    ]
    footer_account << name

    table(
      footer_package,
      :position => :center,
      :column_widths => [395, 100],
      :cell_style => {
        :size => 10
      },

    )

    table(
      footer_total,
      :position => :left,
      :column_widths => [300,95,100],
      :cell_style => {
        :size => 10,
      },
    )

    stroke do
      move_down 20
    end

    table(
      footer_account,
      :position => :left,
      :column_widths => [100, 140],
      :cell_style => {
        :size => 10,
        :height => 17,
      },
    ) do
      cells.borders = []
      cells.padding = [1,1]
    end

    image Rails.root.join('app/assets/images/sign-invoice.png'), :at => [300, 250], :width => 200
    text_box('PT OTORAJA NETWORK INDONESIA', options = {:size => 9, :at => [320,150]}) 
  end

  def formatedRupiah(value)
    ApplicationController.helpers.formatedRupiah(value)
  end

  def formatedDateUseSpace(date)
    ApplicationController.helpers.formatedDateUseSpace(date)
  end

  def formatedDateUseSlash(date)
    ApplicationController.helpers.formatedDateUseSlash(date)
  end

  def formatedMonthSpace(date)
    ApplicationController.helpers.formatedMonthSpace(date)
  end

end