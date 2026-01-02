class Api::MessagesController < ApplicationController
  before_action :authenticate_user!
  def index
    messages = current_user.messages.order(created_at: :desc)
    render json: messages
  end

  def create
    twilio = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )

    sms = twilio.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: message_params[:to],
      body: message_params[:body],
      status_callback: webhook_url
    )

    message = current_user.messages.create!(
      to: message_params[:to],
      body: message_params[:body],
      twilio_sid: sms.sid,
      status: sms.status
    )
    
    render json: message, status: :created
  end

  private

  def message_params
    params.require(:message).permit(:to, :body)
  end

  def webhook_url
    "#{ENV['BASE_URL']}/api/twilio/status"
  end
end