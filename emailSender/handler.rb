# __   __  _______  ___   ___      _______  _______  ______    ______    _______  ___     
# |  |_|  ||   _   ||   | |   |    |  _    ||   _   ||    _ |  |    _ |  |       ||   |    
# |       ||  |_|  ||   | |   |    | |_|   ||  |_|  ||   | ||  |   | ||  |    ___||   |    
# |       ||       ||   | |   |    |       ||       ||   |_||_ |   |_||_ |   |___ |   |    
# |       ||       ||   | |   |___ |  _   | |       ||    __  ||    __  ||    ___||   |___ 
# | ||_|| ||   _   ||   | |       || |_|   ||   _   ||   |  | ||   |  | ||   |___ |       |
# |_|   |_||__| |__||___| |_______||_______||__| |__||___|  |_||___|  |_||_______||_______|
# Made by : A01334390
# Creation Date: October 22nd 2019

require 'json'
require 'rubygems'
require 'mailgun-ruby'

# Lambda function main executer
# Params:
# +event:: POST Event Object
# +context:: Execution context
def hello(event:, context:)
  if event["to"] == "" || event["subject"] == "" || event["text"] == "" || event["first"] == "" || event["second"] == ""
    {
      statusCode: 200,
      body: {
        message: 'Go Serverless v1.0! Your function executed successfully!',
        input: event
    }.to_json}
  else
    send_email(event["to"],event["first"],event["second"],event["subject"],event["text"])
  end
end

# Sends an email to the desired recipient
# Params:
# +to:: Email of the recipient
# +first_name: First Name of the recipient
# +second_name: Second Name of the recipient
# +subject:: Subject of the email to send
# +text:: Email text
def send_email(to, from, first_name, second_name, subject, body)
  mg_client = Mailgun::Client.new ENV["API_KEY"]
  mb_obj = Mailgun::MessageBuilder.new
  mb_obj.set_from_address(from+"@"+ENV["DOMAIN"],{"first" => from, "last" => "@Right Donor"})
  mb_obj.add_recipient(:to,to,{"first" => first_name, "last" => second_name})
  mb_obj.set_subject(subject)
  mb_obj.set_html_body(body)
  return mg_client.send_message(ENV["DOMAIN"],mb_obj)
end
