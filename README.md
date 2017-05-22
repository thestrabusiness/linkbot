# Linkbot

This repo contains the Linkbot server and it's associated web portal. Linkbot is a slackbot that watches your channels for
links that you post or send to your team members, collects and organizes them for you.

**To run Linkbot:**

* Clone the repo && `bundle install` && `rake db:create db:migrate`
* Configure a new bot application on Slack API with
* Configure .ENV file:

     `SLACK_CLIENT_ID= <YOUR CLIENT ID>`\
     `SLACK_CLIENT_SECRET= <YOU CLIENT SECRET>`\
     `PORT=9292`

* Start the servers:

    `foreman start`
    
* Register your team on the root page of the app
* Invite the bot to a channel

With the bot in a channel, you can post links. Visit `/links` to see the list of links you've posted!
