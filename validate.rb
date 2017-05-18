class Validate
  def initialize rack_input
    @rack_input = rack_input
    @status = false
  end

  def sleepy
    max_time_request = @rack_input['max_time_request'].to_i
    @status = true if max_time_request >= 1 and max_time_request <= 10 if max_time_request.is_a? Integer
    
    @rack_input['urls'].each do |url|
      return false unless 0 == (url =~ /#{URI::regexp(['http', 'https'])}/)

      
    end

    return @status
  end 
end