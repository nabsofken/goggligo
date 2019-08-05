class Api::V1::AppointmentsController < ApiController
  include Concerns::UserAuthentication

  def index
    appointments = current_user.appointments.order('created_at DESC')
    success(data: ActiveModelSerializers::SerializableResource.new(appointments, each_serializer: AppointmentSerializer, scope: {current_user: @current_user}))
  end

  def create
    appointment = current_user.appointments.build(appointment_params)
    appointment.current_user = current_user
  	if appointment.save
      created(data: AppointmentSerializer.new(appointment))
  	else
      unprocessable_entity(appointment.errors)
  	end
  end

  def appointment_params
  	params.require(:appointment).permit(:first_name, :last_name, :email, :mobile_number, :date_of_visit, :reason_of_visit).tap do |whitelisted|
    	whitelisted[:answer_values] = params[:appointment][:answer_values]
  	end
  end

end
