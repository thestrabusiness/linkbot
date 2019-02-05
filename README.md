# Linkboy

This repo contains the Linkboy server and its associated web portal. Linkboy is a slackbot that watches your channels for
links that you post or send to your team members, collects and organizes them for you.

**To run Linkboy:**

* Clone the repo && `bundle install` && `rake db:create db:migrate`
* Configure a new application with a bot user on the Slack API (note your client id/tokens)
* Configure .ENV file:

     `SLACK_CLIENT_ID= <YOUR CLIENT ID>`\
     `SLACK_CLIENT_SECRET= <YOU CLIENT SECRET>`\

* Start the application:

    `rails s`
    
* Register your team on the root page of the app using the Slack button
* Invite the bot to a channel

With the bot in a channel, you can post links. Visit `/links` to see the list of links you've posted!
