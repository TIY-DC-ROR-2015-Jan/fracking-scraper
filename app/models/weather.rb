class Weather
  include HTTParty
  base_uri "http://thefuckingweather.com/"

  def self.at location=nil
    response = get("/")
    doc = Nokogiri::HTML(response.body)

    temp    = doc.css('.temperature').first['tempf']
    remarks = doc.css('.remark')
    raise "Expected 1 remark, not #{remarks.count}" unless remarks.count == 1
    remark = remarks.first.text
    flavors = doc.css('.flavor')
    raise "Expected 1 flavor, not #{flavors.count}" unless flavors.count == 1
    flavor = flavors.first.text

    new temp, remark, flavor
  end

  attr_reader :temp, :summary, :quip

  def initialize temp, summary, quip
    @temp, @summary, @quip = temp, summary, quip
  end
end
