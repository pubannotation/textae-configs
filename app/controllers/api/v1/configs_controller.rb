class Api::V1::ConfigsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_access_token, only: %i[create update destroy]

  rescue_from StandardError, with: :render_standard_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_error
  rescue_from ActiveRecord::RecordNotUnique, with: :render_record_already_exists_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_error
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :render_parse_error

  # GET api/v1/configs/name
  def show
    config = Config.friendly.find(params[:name])

    render json: config.pretty_body, status: :ok
  end

  # POST api/v1/configs/name
  def create
    current_user.configs.create!(new_config)

    render json: {
             message: "Config #{params[:name]} was successfully created.",
             show_instruction: "If you want to see the saved body, send a GET request to /api/v1/configs/#{params[:name]}"
           },
           status: :created
  end

  # PATCH/PUT api/v1/configs/name
  def update
    current_config.update!(new_config)

    render json: { message: "Config #{params[:name]} was successfully updated." }, status: :ok
  end

  # DELETE api/v1/configs/name
  def destroy
    current_config.destroy

    render json: { message: "Config #{params[:name]} was successfully deleted." }, status: :ok
  end

  private

  def authenticate_access_token
    if token
      sign_in(token.user)
    else
      render_token_invalid_error
    end
  end

  def token
    bearer_token = bearer_token_in(request.headers)
    AccessToken.find_by(token: bearer_token) if bearer_token
  end

  def bearer_token_in(headers)
    case headers['Authorization']
    in /^Bearer (.+)$/
      Regexp.last_match(1)
    else
      nil
    end
  end

  def current_config
    current_user.configs.friendly.find(params[:name])
  end

  def new_config
    config = {}
    config[:name] = params[:name]
    config[:body] = Config.format_body(request.raw_post) if request.raw_post.present?
    config[:description] = params[:description] if params[:description]
    config[:is_public] = params[:is_public] if params[:is_public]

    config
  end

  def render_standard_error(e)
    render json: { error: e.message }, status: :internal_server_error
  end

  def render_token_invalid_error
    render json: { error: "The access token is missing or invalid." }, status: :unauthorized
    response.headers['WWW-Authenticate'] = 'Bearer'
  end

  def render_record_invalid_error(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def render_record_already_exists_error
    render json: { error: "#{params[:name]} has already been taken." }, status: :conflict
  end

  def render_record_not_found_error
    render json: { error: "Could not find the config #{params[:name]}" }, status: :not_found
  end

  def render_parse_error
    render json: { error: 'Invalid JSON format.' }, status: :bad_request
  end

end
