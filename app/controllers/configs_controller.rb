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
    respond_to do |format|
      format.html
      format.json { render json: @config.body }
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
    @config = current_user.configs.new(config_params)

    respond_to do |format|
      if @config.save
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
    result = if params.has_key?(:config) && params[:config].present?
      begin
        @config.update(config_params)
      rescue
        flash[:notice] = 'body was not a valid JSON.'
        nil
      end
    elsif params.has_key?(:"entity types") || params.has_key?(:"relation types")
      _body = {
        "autocompletion_ws": params.fetch(:"autocompletion_ws", ""),
        "entity types": params.fetch(:"entity types", []),
        "relation types": params.fetch(:"relation types", []),
        "attribute types": params.fetch(:"attribute types", []),
        "delimiter characters": params.fetch(:"delimiter characters", []),
        "non-edge characters": params.fetch(:"non-edge characters", [])
      }
      _body.keep_if{|k, v| v.present?}
      @config.update(body: _body)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_config
      @config = Config.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
      _config = params.require(:config).permit(:name, :description, :body, :is_public)
      _config[:body] = JSON.parse("{}")
      _config
    end

    def config_body_params
      params.require(:"entity types")
    end
end
