require 'json'
require 'rubygems'
require 'mailgun-ruby'

mg_client = Mailgun::Client.new ENV["API_KEY"]

def hello(event:, context:)
  if event["to"] == "" || event["subject"] == "" || event["text"] == ""
    {
      statusCode: 200,
      body: {
        message: 'Go Serverless v1.0! Your function executed successfully!',
        input: event
    }.to_json}
  else
    send_email(event["to"],event["subject"],event["text"])
  end
end


def send_email(to, subject, text)
  message_params =  { from: 'bob@'+ENV.DOMAIN,
                    to:   to,
                    subject: subject,
                    text:    text
                  }

  # Send your message through the client
  return mg_client.send_message ENV["DOMAIN"], message_params
end
