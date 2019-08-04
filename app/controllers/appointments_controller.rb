class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def new
  	@appointment = Appointment.new
  end

  def create
  	@appointment = Appointment.new(appointment_params)
  	if @appointment.save
  		redirect_to appointments_list_path
  	else
  		render :new
  	end
  end

  def list
  	@appointments = Appointment.all.order('created_at DESC')
  end

  def appointment_params
  	params.require(:appointment).permit(:first_name, :last_name, :email, :mobile_number, :date_of_visit, :reason_of_visit)
  end
end
