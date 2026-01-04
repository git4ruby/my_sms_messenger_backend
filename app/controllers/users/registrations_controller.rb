class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: {
        message: "User created successfully"
      }, status: :created
    else
      render json: {
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  protected

  def sign_up(resource_name, resource)

  end

  def sign_in(resource_name, resource)

  end
end