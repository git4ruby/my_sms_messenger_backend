class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, type: String
  field :body, type: String
  field :twilio_sid, type: String
  field :status, type: String
  field :session_id, type: String

  belongs_to :user, optional: true

end
