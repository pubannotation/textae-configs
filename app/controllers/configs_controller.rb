class ConfigsController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /configs
  # GET /configs.json
  def index
    @configs_grid = initialize_grid(Config.accessibles(current_user),
      include: :user
    )
  end

  # GET /configs/1
  # GET /configs/1.json
  def show
    @formatted_body = @config.pretty_body

    respond_to do |format|
      format.html
      format.json { render json: @formatted_body }
    end
  end

  # GET /configs/new
  def new
    @config = Config.new
  end

  # GET /configs/1/edit
  def edit
  end

  # POST /configs
  # POST /configs.json
  def create
    @config = current_user.configs.new(get_config)

    respond_to do |format|
      if @config && @config.save
        format.html { redirect_to @config, notice: 'Config was successfully created.' }
        format.json { render :show, status: :created, location: @config }
      else
        format.html { render :new }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/name
  # PATCH/PUT /configs/name.json
  def update
    begin
      result = if params.has_key?(:config) && params[:config].present?
        @config.update(get_config)
      elsif params.has_key?(:"entity types") || params.has_key?(:"relation types")
        @config.update(body: get_body)
      else
        nil
      end
    rescue => e
      flash.now[:notice] = e.message
    end

    respond_to do |format|
      if result
        format.html { redirect_to @config, notice: 'Config was successfully updated.' }
        format.json { render :show, status: :ok, location: @config }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configs/1
  # DELETE /configs/1.json
  def destroy
    @config.destroy
    respond_to do |format|
      format.html { redirect_to configs_url, notice: 'Config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_config
      @config = Config.friendly.find(params[:id])
    end

    def get_body
      body_obj =
        if params.has_key?(:config) && params[:config].present?
          _config = params.require(:config).permit(:name, :description, :body, :is_public)
          if _config[:body].present?
            begin
              JSON.parse _config[:body]
            rescue => e
              flash.now[:notice] = e.message
              nil
            end
          else
            {}
          end
        elsif params.has_key?(:"entity types") || params.has_key?(:"relation types")
          {
            "autocompletion_ws": params.fetch(:"autocompletion_ws", ""),
            "entity types": params.fetch(:"entity types", []),
            "relation types": params.fetch(:"relation types", []),
            "attribute types": params.fetch(:"attribute types", []),
            "delimiter characters": params.fetch(:"delimiter characters", []),
            "non-edge characters": params.fetch(:"non-edge characters", [])
          }.keep_if{|k, v| v.present?}
        else
          nil
        end

      body_obj.nil? ? nil : JSON.generate(body_obj)
    end

    def get_config
      _config = params.require(:config).permit(:name, :description, :body, :is_public)
      _config[:body] = get_body
      _config
    end
end
