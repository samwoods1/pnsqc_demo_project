module DemoWebRequestHelper

  # Makes a simple web request and returns the response
  def make_request(url, method, headers, body = '', acceptable_response_codes=[200])
    uri = URI.parse(url)

    response = nil
    # Retry up to 2 times
    2.downto 0 do |retries|
      begin
        Net::HTTP::start(uri.host, uri.port,
                         :use_ssl => uri.scheme == 'https') do |http|
          # Create the correct request type depending on the method
          case
            when method.downcase == 'get'
            then
              request = Net::HTTP::Get.new uri
            when method.downcase == 'post'
            then
              request = Net::HTTP::Post.new uri
              request.body = body
            when method.downcase == 'post'
            then
              request = Net::HTTP::Put.new uri
              request.body = body
            when method.downcase == 'delete'
            then
              request = Net::HTTP::Delete.new uri
          end

          # Add all of the headers from the headers hash
          headers.each_key { |key|
            request[key] = headers[key]
          }
          response = http.request request
          if !acceptable_response_codes.map!(&:to_s).include? response.code.to_s
            raise("The response code '#{response.code}' from request #{url} did not match any of the provided acceptable response codes")
          end
          return response
        end
        break
      rescue StandardError => ex
        DemoLogger.log.warn "Web request failed due to Exception: #{ex}. Retrying #{retries} times"
        sleep 5 if retries > 0
        raise(ex, 'Web request failed') if retries == 0
      end
    end

  end

  def parse_json(json)
    JSON.parse(json)
  end

end
