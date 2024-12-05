class Api::V1::ConfigsController < ApplicationController
  skip_before_action :verify_authenticity_token

  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotUnique, with: :record_already_exists
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :parse_error

  # GET api/v1/configs/name
  def show
    config = Config.friendly.find(params[:name])

    render json: config.body, status: :ok
  end

  # POST api/v1/configs/name
  def create
    current_user.configs.create!(get_config)

    render json: {
             message: "Config #{params[:name]} was successfully created.",
             show_instruction: "If you want to see the saved body, send a GET request to /api/v1/configs/#{params[:name]}"
           },
           status: :created
  end

  # PATCH/PUT api/v1/configs/name
  def update
    current_config.update!(get_config)

    render json: { message: "Config #{params[:name]} was successfully updated." }, status: :ok
  end

  # DELETE api/v1/configs/name
  def destroy
    current_config.destroy

    render json: { message: "Config #{params[:name]} was successfully deleted." }, status: :ok
  end

  private

  def current_config
    current_user.configs.friendly.find(params[:name])
  end

  def get_config
    config = {}
    config[:name] = params[:name]
    config[:body] = get_body if request.raw_post.present?
    config[:description] = params[:description] if params[:description]
    config[:is_public] = params[:is_public] if params[:is_public]

    config
  end

  def get_body
    body_obj =
      if params.has_key?(:"entity types") || params.has_key?(:"relation types")
        {
          "autocompletion_ws": params.fetch(:"autocompletion_ws", ""),
          "entity types": params.fetch(:"entity types", []),
          "relation types": params.fetch(:"relation types", []),
          "attribute types": params.fetch(:"attribute types", []),
          "delimiter characters": params.fetch(:"delimiter characters", []),
          "non-edge characters": params.fetch(:"non-edge characters", [])
        }.keep_if{|k, v| v.present?}
      else
        JSON.parse(request.raw_post)
      end

    JSON.pretty_generate(body_obj)
  end

  def handle_standard_error(e)
    render json: { error: e.message }, status: :internal_server_error
  end

  def record_invalid(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def record_already_exists
    render json: { error: "#{params[:name]} has already been taken." }, status: :conflict
  end

  def record_not_found
    render json: { error: "Could not find the config #{params[:name]}" }, status: :not_found
  end

  def parse_error
    render json: { error: 'Invalid JSON format.' }, status: :bad_request
  end

end
