class Console::WhatsAppTemplatesController < Console::ApplicationConsoleController

  def index
    @whats_app_templates = WhatsAppTemplate.get_production_templates()
    @whats_app_services = WhatsAppService.all()
    @whats_app_available_templates = @whats_app_templates.pluck(:template_name, :id)
  end

  def new
    @shop_id = params[:id]
    @whats_app_template = WhatsAppTemplate.new()
  end

  def create
    @shop_id = whats_app_params[:shop_id]

    @whats_app_template = WhatsAppTemplate.new(whats_app_params)
    
    @whats_app_template.environment = WhatsAppTemplate.environmentTypes[:production]
    if @whats_app_template.save
        redirect_to console_whats_app_templates_path, notice: 'Whats App template was successfully created.' 
    else
        render :new
    end
  end

  def edit
    @whats_app_template = WhatsAppTemplate.find(params[:id])
  end

  def update
    @whats_app_template = WhatsAppTemplate.find(params[:id])
    @whats_app_template.assign_attributes(whats_app_params)

    if @whats_app_template.save
        redirect_to console_whats_app_templates_path, notice: 'Whats App template was successfully updated.'
    else
        render :edit
    end
  end

  def update_default_template
    begin
      @shop_id = params[:id]
      @items = params[:whats_app_services]

      @items.each do |index, item|
        unless item["id"].empty?
          service = WhatsAppService.find(item["whats_app_service_id"])
          service.whats_app_template_id = item["id"]
          service.save
        end
      end
      redirect_to console_whats_app_templates_path, notice: 'Whats App template was successfully updated.'
    rescue
      redirect_to console_whats_app_templates_path, notice: 'Error updating Whats App template.'
    end
  end

  def update_shop_default_template
    begin

      @shop_id = params[:id]
      @items = params[:whats_app_services]

      @items.each do |index, item|
        unless item["id"].empty?
          shop_template = ShopWhatsAppTemplate.find_or_create_by(shop_id: @shop_id, whats_app_service_id: item["whats_app_service_id"])
          shop_template.whats_app_template_id = item["id"]
          shop_template.save
        end
      end
      redirect_to console_shop_path(@shop_id), notice: 'Whats App template was successfully updated.'
    rescue
      redirect_to console_shop_path(@shop_id), notice: 'Error updating Whats App template.'
    end
  end

  def destroy
  end
  
  private
    def whats_app_params
      params.fetch(:whats_app_template, {}).permit(
        :id, :template_name, :whats_app_service_id, :environment, :shop_id
      )
    end
    
  end
  