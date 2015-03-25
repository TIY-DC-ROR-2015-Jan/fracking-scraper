class Weather
  include HTTParty
  base_uri "http://thefuckingweather.com/"

  def self.find_one_class doc, klass
    selector = ".#{klass}"
    hits = doc.css selector
    raise "Expected 1 match for '#{selector}', got #{hits.count}" unless hits.count == 1
    hits.first
  end

  def self.throttle interval
    now = Time.now
    if @_next_allowed_call && @_next_allowed_call > now
      wait = @_next_allowed_call - now
      Rails.logger.debug "Rate limiting for #{wait}s"
      sleep wait
    end
    @_next_allowed_call = now + interval
  end

  def self.at location=nil
    location ||= "Arlington, VA"

    throttle 5.seconds
    response = get("/", query: { where: location })
    doc = Nokogiri::HTML(response.body)

    temp   = doc.css('.temperature').first['tempf']
    remark = find_one_class(doc, "remark").text
    flavor = find_one_class(doc, "flavor").text

    new temp, remark, flavor

  rescue => e
    if response.code == 503
      Rails.logger.info "#{base_uri} is down; retrying"
      retry
    else
      raise
    end
  end

  attr_reader :temp, :summary, :quip

  def initialize temp, summary, quip
    @temp, @summary, @quip = temp, summary, quip
  end
end
