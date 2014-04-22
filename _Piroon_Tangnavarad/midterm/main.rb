require 'pry'
require_relative 'lib/google_books_client.rb'

#methods

def welcome
	puts "Welcome to Google Books Search Command Line API!"
end

def getInput
	puts "Please enter any search terms for your book (author, title etc.) or '99' to exit program"
	term = gets.chomp.strip
end

def validateInput(input)
	if (input.include? '^') || (input.include? '&')  || (input.include? '[') || (input.include? ']') || (input.include? '*') || (input.empty?)
		puts "You've entered an invalid character, please try again"
		return false
	else
		return true
	end
end



#main

welcome
done = false
googleClient = GoogleBooksClient.new()

until done do
	searchTerm = getInput
	if  (!validateInput(searchTerm))
		next
	end

	if  searchTerm == "99"
		done = true
		puts "Thank you for using Google Books Search API!"
	else
		googleClient.get(searchTerm)
		puts googleClient
		googleClient.clear
	end
end


