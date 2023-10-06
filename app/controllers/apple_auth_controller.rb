# app/controllers/apple_auth_controller.rb

class AppleAuthController < ApplicationController
  def create
    id_token = request.headers['Authorization']

    if id_token
      decoded_token = verify_apple_id_token(id_token)

      if decoded_token
        apple_user_id = decoded_token['sub']
        email = decoded_token['email']

        user = User.find_or_create_by(apple_user_id: apple_user_id) do |u|
          u.email = email
        end

        if user.save
          render json: { message: 'User authenticated successfully.', user: user }, status: :ok
        else
          render json: { message: 'Failed to authenticate user.' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Invalid or expired ID token.' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Authorization header is missing.' }, status: :bad_request
    end
  end

  private

  def verify_apple_id_token(id_token)
    # Appleの公開鍵を取得
    apple_public_keys = get_apple_public_keys
    id_token = id_token.gsub('Bearer ', '')
    Rails.logger.info("ID token: #{id_token}")
    p "ID token: #{id_token}"

    # トークンをデコードして検証
    begin
      JWT.decode(id_token, nil, true, {
                   algorithm: 'RS256',
                   iss: 'https://appleid.apple.com',
                   verify_iss: true,
                   aud: Rails.application.credentials.apple_client_id, # Apple Client IDを設定してください
                   verify_aud: true,
                   jwks: apple_public_keys
                 })[0]
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT decode error: #{e.message}")
      nil
    end
  end

  def get_apple_public_keys
    apple_public_keys_url = 'https://appleid.apple.com/auth/keys'

    response = Faraday.get(apple_public_keys_url)
    json_response = JSON.parse(response.body)

    JSON::JWK::Set.new(json_response)
  end
end
