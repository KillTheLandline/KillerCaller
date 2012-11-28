require 'sinatra'

before do
  content_type 'text/plain'
end

get '*' do
  numbers = params[:splat].first[1..-4].split('_')
  if numbers.length == 1
    formattedNumber = "'+1#{numbers.first}'"
  else
    formattedNumber = "["
    numbers.each do |n|
      formattedNumber <<  "'+1#{n}',"
    end
    formattedNumber << ']'
  end
  "answer\ntransfer #{formattedNumber}\nhangup"
end
