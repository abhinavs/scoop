class ExampleController < ApplicationController
  helpers Sinatra::Jsonp
  mime_type :json, "application/json"
  before { content_type :json }

  not_found do
    jsonp({:error => "not found"})
  end

  helpers do
    def deliver_output(record_array)
      if record_array.nil? || record_array.empty?
        not_found
      else
        jsonp(record_array.map(&:attrs))
      end
    end
  end


  get '/' do
    content_type :html
    erb :about
  end

end
