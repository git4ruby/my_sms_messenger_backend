class Api::TwilioController < ApplicationController
  def status
    message = Message.find_by(twilio_sid: params[:MessageSid])
    message.update(status: params[:MessageStatus]) if message
    head :ok
  end
end
