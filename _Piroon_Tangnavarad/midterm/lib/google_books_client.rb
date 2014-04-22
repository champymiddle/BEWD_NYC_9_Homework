require 'json'
require 'google/api_client'

#This is a wrapper class for Google API client, specificly for Google Books Search API
class GoogleBooksClient
	attr_reader 	:google_api_client, :google_api_type
	attr_accessor	:parsed_response

	def self.api_key
		"AIzaSyDi2cBHVKR50u0UQE_Dm2Z8fDu4-5uqCAU"
	end
	def self.host
		"www.googleapis.com"
	end
	def self.app_name
		"Ruby Google Books"
	end
	def self.app_v
		"1.0.0"
	end
	def self.api_type
		"books"
	end
	def self.api_v
		"v1"
	end

	#Constructor
	def initialize
		@google_api_client = Google::APIClient.new(
				     :application_name => GoogleBooksClient.app_name,
			             :application_version => GoogleBooksClient.app_v,
			             :key => GoogleBooksClient.api_key,
				     :host => GoogleBooksClient.host)

		#This turns off OAuth2 and forces google client to use public API key
		@google_api_client.authorization = nil 

		#Google API type
		@google_api_type = @google_api_client.discovered_api(GoogleBooksClient.api_type, GoogleBooksClient.api_v)
	end

	def get (search)
		result = google_api_client.execute(
			 :api_method => google_api_type.volumes.list,
		         :parameters => {'q' => search})

		json_res = JSON.parse(result.response.env.body)
		@parsed_response = parse(json_res)
	end

	def clear
		@parsed_response.clear
	end

	def to_s
		puts
		parsed_response.map do |book|
		puts "[Title: #{book[:title]} - #{book[:subtitle]} | Author(s): #{book[:author]} | Published Date: #{book[:date]}]"
		end
		puts
	end

	def parse(res)
		res['items'].map do |book| 
			{ title: book['volumeInfo']['title'], 
			subtitle: book['volumeInfo']['subtitle'],
			author: book['volumeInfo']['authors'], 
			date: book['volumeInfo']['publishedDate'], 
			description: book['volumeInfo']['description'] }	
		end
	end

end
