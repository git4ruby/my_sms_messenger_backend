class Api::MessagesController < ApplicationController
  def index
    messages = current_user.messages
    render json: messages.order(created_at: :desc)
  end

  def create
    twilio = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )

    sms = twilio.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: params[:to],
      body: params[:body],
      status_callback: "#{ENV['BASE_URL']}/api/twilio/status"
    )

    message = current_user.messages.create!(
      to: params[:to],
      body: params[:body],
      twilio_sid: sms.sid,
      status: sms.status
    )
    
    render json: message, status: :created
  end

  private

  def webhook_url
    "#{ENV['BASE_URL']}/api/twilio/status"
  end
end