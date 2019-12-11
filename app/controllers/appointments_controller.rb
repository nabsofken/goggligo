class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:show]

  def new
  	@appointment = Appointment.new
  end

  def create
  	@appointment = Appointment.new(appointment_params)
  	if @appointment.save
      redirect_to appointments_path
  	else
  		render :new
  	end
  end

  def show
  end

  def statistic
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil

    @appointments = current_user.appointments if current_user.doctor?

    if current_user.admin?
      @appointments = Appointment.all if params[:user_id].blank?
      user = User.find_by_id(params[:user_id])
      @appointments = user.appointments if user.present?
    end
    @current_month_count = @appointments.between(Time.now.utc.to_date.beginning_of_month, Time.now.utc.to_date.end_of_month).count
    @current_year_count = @appointments.between(Time.now.utc.to_date.beginning_of_year, Time.now.utc.to_date.end_of_year).count
  end

  def index
  	@appointments = current_user.appointments.order('created_at DESC') if current_user.doctor?
    if current_user.admin?
      @appointments = Appointment.all.order('created_at DESC') if params[:user_id].blank?
      user = User.find_by_id(params[:user_id])
      @appointments = user.appointments if user.present?
    end

    @appointments = @appointments.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{params[:search].downcase}%", "%#{params[:search].downcase}%") if params[:search].present?
  end

  def generate_csv
  	start_date = params[:start_date] || 1.year.ago
  	end_date = params[:end_date] || Date.today
    @appointments = current_user.admin? ? Appointment.all : current_user.appointments

    if current_user.admin?
      @appointments = Appointment.all if params[:user_id].blank?
      user = User.find_by_id(params[:user_id])
      @appointments = user.appointments if user.present?
    end

  	@appointments = @appointments.between(start_date, end_date).order('created_at DESC')

    if @appointments.length < 1
      session[:error] = 'Sorry! No results found for this data range'
      return redirect_to statistic_path(start_date: params[:start_date], end_date: params[:end_date], user_id: params[:user_id])
    end

  	respond_to do |format|
      format.html
      format.csv { send_data Appointment.to_csv(@appointments), filename: "Visitors-#{Date.today}.csv" }
    end
  end

  def generate_report
  	header = '<h1 style="text-align: center; color: #2dad68;">New Visitor Report</h1>'
  	body = '<table><tr><th>Full Name</th><th>Email</th><th>Mobile</th><th>Date</th><th>Reason</th><th>Questions</th></tr>'
  	next_column = '</td><td>'

    @appointments = current_user.admin? ? Appointment.all : current_user.appointments
  	@appointments = @appointments.order('created_at DESC')

  	@appointments.each do |appointment|
  		body = body + '<tr><td>' + appointment.first_name.to_s + ' ' + appointment.last_name.to_s + next_column + appointment.email.to_s + next_column + appointment.mobile_number.to_s + next_column + appointment.date_of_visit.to_s + next_column + appointment.reason_of_visit.to_s

		body = body + '</td><td><ul>'
        appointment.answer_values.keys.each do |key|
            body = body + '<li>' + Question.find_by_id(key.to_s).try(:title) + ': <strong>' + appointment.answer_values[key].to_s + '</strong></li>'
        end

  		body + '</ul></td></tr>'
  	end

  	footer = '</table><h1 style="text-align: center; color: #2dad68;">Gliggo</h1>'
	pdf = WickedPdf.new.pdf_from_string(header + body + footer)


	UserMailer.generate_report(current_user, pdf).deliver_now

	# attachments['report.pdf'] = pdf#File.read('path/to/file.pdf')
 #    mail(:to => current_user.email, :subject => "Patient Report")

    redirect_to appointments_path
  end

  def set_appointment
  	@appointment = Appointment.find_by(id: params[:id])
    redirect_to appointments_path if @appointment.blank?
  end

  def appointment_params
  	params.require(:appointment).permit(:first_name, :last_name, :email, :mobile_number, :date_of_visit, :reason_of_visit)
  end
end
