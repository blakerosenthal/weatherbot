# weatherbot
Simple weather bot for Slack

Server setup:
- clone this repository and `cd weatherbot`
- run `bundle update && bundle install` to install the required gems
- (optional) I'm using `ngrok` to tunnel web connections to my local server (https://api.slack.com/tutorials/tunneling-with-ngrok)

Bot setup:
- create a bot in slack (https://api.slack.com/bot-users)
- Give your bot the following features
  - Incoming Webhooks (so your bot can post using Slack's Web API)
  - Bots (so you can interact with the bot)
  - Event Subscriptions (so your bot can listen for weather mentions)
- You will need to add http://<your-server.com>/weatherbot to the Event Subscriptions config
- Also under Event Subscriptions, subscribe to 'app_mention' and 'message.im' events
- Install your bot

Now you can restart your server using the bot's access token:
`SLACK_API_TOKEN=<token> DARKSKY_TOKEN=<token> bundle exec rails s`

NOTE: My bot's verification token is hard-coded into the controller, so if you're using a different bot you will need to change it in weatherbot/app/controllers/weatherbot_controller.rb
