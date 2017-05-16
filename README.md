# Linkbot

This repo contains the Linkbot server and it's associated web portal. Linkbot is a slackbot that watches your channels for
links that you post or send to your team members, collects and organizes them for you.

**To run Linkbot:**

* Clone the repo & bundle install
* Configure a new bot application on Slack API with 
* Configure .ENV file:
  
     `SLACK_CLIENT_ID= <YOUR CLIENT ID>`
     `SLACK_CLIENT_SECRET= <YOU CLIENT SECRET>`
     
* Start the server:
 
    `rails s -p 9292`
    
* Invite the bot to a channel
* @linkbot say hi
