module ApplicationHelper

	class << self
		def get_json(endpoint)
			response = Faraday.get(endpoint, nil, request_headers)
			JSON.parse(response.body, symbolize_names: true)
		end

		private

		def request_headers
			headers = {'Accept' => 'application/vnd.github+json'}
			# todo: move to secrets manager
			token = ENV['GITHUB_API_TOKEN']
			headers['Authorization'] = "Bearer #{token}" unless token.blank?
			headers
		end
	end
end
