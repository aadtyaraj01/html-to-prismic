require 'sinatra'
require 'json'
require 'kramdown-prismic'

post '/convert' do
  content_type :json
  
  # Get the HTML content from the request body
  begin
    request.body.rewind if request.body.respond_to?(:rewind)
    html_content = request.body.read
  rescue => e
    # If there's an error reading the body, try getting it from params
    html_content = params['html_content']
  end

  if html_content.nil? || html_content.empty?
    status 400
    return { error: 'No HTML content provided' }.to_json
  end

  begin
    # Convert HTML to Prismic format
    prismic_document = Kramdown::Document.new(html_content, input: :html).to_prismic

    # Return the Prismic document as JSON
    prismic_document.to_json
  rescue => e
    status 500
    { error: "Conversion failed: #{e.message}" }.to_json
  end
end

# Optional: Add a simple GET route for testing
get '/' do
  'HTML to Prismic conversion API is running'
end