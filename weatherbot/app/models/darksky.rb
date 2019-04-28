class Darksky
  SECRET_KEY = ENV['DARKSKY_TOKEN']
  PORTLAND_LAT_LONG = '45.515,-122.679'.freeze

  def weather_now
    currently = weather['currently']
    unless currently
      return 'There is no weather today!'
    end
    currently['summary']
  end

  def weather_tomorrow
    data = weather['daily'].try(:[], 'data')
    unless data && data.is_a?(Array)
      return 'There is no weather tomorrow!'
    end
    data[1].try(:[], 'summary')
  end

  private

  def weather
    @weather ||= JSON(Faraday.get(request_url).body)
  end

  def request_url
    "https://api.darksky.net/forecast/#{SECRET_KEY}/#{PORTLAND_LAT_LONG}"
  end
end
