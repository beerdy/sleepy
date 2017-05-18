# encoding: UTF-8

module FakeResponse
  def fake_response urls, params

    # For debug
    console = params[:console]

    # max_time_request - in sec.
    max_time_request = params[:max_time_request]

    th = []

    urls.count.times do 
      th << Thread.new do
        url = urls.pop
        timestamp = Time.now

        Thread.current[:data_request] = HTTPClient.get_content url
     
        Thread.current[:time_request] = (Time.now - timestamp) * 1000.0
      end
    end

    sleep max_time_request

    puts "\nRequests terminated." if console

    responses = Hash.new

    th.each_with_index do |thread,(i)|
      response = Hash.new

      unless thread[:data_request].nil?
      begin
        response[:data_request] = JSON.parse thread[:data_request].gsub('=>', ':')
        response[:time_request] = thread[:time_request] # Time request in milisec.
      rescue Exception => e
        response = { :error => "#{e} -> #{data_request}" }
      end
      else
        response = { :error => "Request not completed or no response" }
      end

      responses[i] = response

    end

    puts "\nData prepared." if console

    pp responses if console
    
    return processing(responses)

  end

  def processing responses
    sum = 0.0
    errors = []
    data = {}

    responses.each do |key,hash|
      begin
        slept = hash[:data_request]['slept']
        # If error this not do
        sum += slept
      rescue Exception => e
      end

      if hash.has_key?(:error)
        errors << {"\"Error request\"" => hash[:error]}
        responses.delete(key)
      end
    end

    data[:data] = responses
    data[:sum] = sum
    data[:errors] = errors if errors
    
    return data
  end

end