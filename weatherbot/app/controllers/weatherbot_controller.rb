# Controller for simple weather slackbot
class WeatherbotController < ApplicationController
  # POST /weatherbot
  def create
    # Return forbidden status unless token matches
    if !validate_token(params[:token])
      render status: 403
      return
    end

    # Verify url with slack:
    # this ensures that requests are coming from a trusted source
    if params[:challenge]
      render json: { challenge: params[:challenge] }
      return
    end

    # Return a prompt 200 status then process the handle_event
    render status: 200

    handle_event(params[:event])
  end

  private

  def validate_token(token)
    # Verification token for blaker-bot
    # This really shouldn't be hard-coded in here
    token == 'wsdR0X6RG5o5bNWfbPXf9km1'
  end

  # The main behavior logic
  def handle_event(event)
    return unless should_respond?(event)

    channel = event[:channel]
    text = event[:text]

    response = bot_response(text)
    client.chat_postMessage(channel: channel, text: response)
  end

  # Rules for deciding whether the bot should return a response
  def should_respond?(event)
    # Don't respond to other bots
    return false if event[:subtype] == 'bot_message'
    # Don't respond to hidden messages (like message deletions)
    return false if event[:hidden]
    # Don't repond to missing events.
    return false if event[:channel].nil? || event[:text].nil?
    true
  end

  def client
    @client ||= ::Slack::Web::Client.new
  end

  def darksky
    @darksky ||= Darksky.new
  end

  def bot_response(text)
    heading = 'Darksky says: '
    case text
    when /weather.*(today|now)/i
      heading + darksky.weather_now
    when /weather tomorrow/i
      heading + darksky.weather_tomorrow
    else
      'Hi! I can answer "what is the weather right now" and '\
      '"what is the weather tomorrow"!'
    end
  end
end
