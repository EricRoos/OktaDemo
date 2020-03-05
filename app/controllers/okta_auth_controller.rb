class OktaAuthController < ApplicationController
	def callback
    query = {
      client_id: client_id,
      redirect_uri: redirect_uri,
      scope: scopes,
      response_type: 'code',
      state: generate_state,
      nonce: generate_nonce
    }

		if authorization_server_url === params[:iss]
			authorize_url = "#{authorization_server_url}#{authorization_path}?#{query.to_query}"
			redirect_to authorize_url
		end
  end

  def exchange_token
    login_response = login(params[:code])
    if login_response[:user].present?
      render json:  login_response
    elsif login_response[:error].present?
      render json:  login_response
    else
      render json:  login_response
    end
  end
	
	private

  def login(auth_code)
    query = {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'authorization_code',
      redirect_uri: redirect_uri,
      code: auth_code
    }
		connection = Faraday.new(url: authorization_server_url)
    token_resp = connection.post token_path, query
    if token_resp.success?
			token_body = JSON.parse(token_resp.body)
			access_token = token_body["access_token"]
			id_token = token_body["id_token"]

			user_resp = connection.post user_info_path, {} do |request|
				request.headers["Authorization"] = "Bearer #{access_token}"
			end

      if user_resp.success?
        groups = JWT.decode(access_token, nil, false)[0]["groups"]
        user = JSON.parse(user_resp.body).merge({auth_groups: groups})
				return { user: user }
			else
				return { error: 'could not fetch userinfo' }
			end
		else
			return { error: 'could not fetch id token' }
		end
  end

	def	authorization_path
		'/oauth2/default/v1/authorize'
	end
	def token_path
		'/oauth2/default/v1/token'
	end
	def user_info_path
		'/oauth2/default/v1/userinfo'
	end

	def generate_state
		SecureRandom.hex(16)
	end

	def generate_nonce
		precision = 1000000000000
		(SecureRandom.rand * precision).to_i
	end

	def scopes
		'openid profile groups'
	end

	def authorization_server_url
    "https://dev-783528.okta.com"
	end
	def client_id
    "0oa2znwwsd382IjLF4x6"
	end
	def client_secret
    "4pFP532pejr0DbWSJPtM3AQGx1BYPc5T22ofFIU-"
	end

	def redirect_uri
		'http://localhost:8080/okta/exchange_token'
	end
end
