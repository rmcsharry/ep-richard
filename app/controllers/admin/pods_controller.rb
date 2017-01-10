require 'net/http'
require 'uri'

class Admin::PodsController < AdminController

  def index
    @pods = Pod.order('LOWER(name)')
  end

  def new
    @pod = Pod.new
  end

  def getStudents

    uri = URI('https://api.wonde.com/v1.0/schools/' + @schoolId + '/students?per_page=1000&include=contacts,contacts.contact_details')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
    request = Net::HTTP::Get.new(uri.request_uri)
    request["authorization"] = "Bearer 355d00547bb356865fc5ec2addc9e48096df4915"
    res = http.request(request)
    return JSON.parse(res.body, object_class: OpenStruct).data

  end

  def show
    @pod = Pod.find(params[:id])
    @parents = @pod.parents.order('LOWER(name)')

    year = Date.today.year.to_i - 6
    @year = params[:year].presence || year.to_s + '-01-01'
    @schoolId = @pod.school_id #|| 'A1930499544'

    if @schoolId.blank?

      @newParents = Array.new

    else

      students = getStudents

      @newParents = Array.new

        students.each do |student|
          if student.date_of_birth.date > @year.to_time
            student.contacts.data.each do |contact|
              phones = contact.contact_details.data.phones
              phones.to_h.each do |k,v|
                phone = v.to_s.gsub(/\s+/, "")
                if phone.start_with?('07') && phone.length == 11 && !@parents.detect{|p| p.phone == phone}
                  student.dob = student.date_of_birth.date.to_date.to_s
                  student.phone = phone
                  student.name = contact.forename
                  student.relationship = contact.relationship.relationship
                  student.surname = contact.surname
                  @newParents << student
                end
              end
            end
          end
        end

    end

  end

  def create
    @pod = Pod.new(pod_params)
    if @pod.save
      flash[:success] = "New pod successfully added!"
      redirect_to admin_pods_path
    else
      render 'new'
    end
  end

  def create_multiple
    @pod = Pod.find(params[:id])
    count = 0
    params['parents'].each_with_index do |parent, i|
      if parent.has_key?('add')
        @parent = Parent.new({name: parent['name'], phone: parent['phone']})
        @parent.pod = @pod
        if !@parent.save
          puts @parent.errors.full_messages
        end
        count = i
      end
    end
    flash[:success] = "#{count+1} new parent(s) were added to your pod"
    redirect_to admin_pod_path
  end

  def edit
    @pod = Pod.find(params[:id])
    @parents = @pod.parents.order('LOWER(name)')
  end

  def update
    @pod = Pod.find(params[:id])
    @pod.update!(pod_params)
    if @pod.valid?
      flash[:success] = "Pod successfully updated!"
      redirect_to edit_admin_pod_path(params['id'])
    else
      render 'edit'
    end
  end

  def update_multiple
    params['parent'].each do |k,v|
      @parent = Parent.find(k.to_i)
      @parent.update_attributes(v)
    end
    flash[:success] = "Parents updated"
    redirect_to edit_admin_pod_path(params['id'])
  end

  def destroy
    pod = Pod.find(params[:id])
    pod.delete
    flash[:success] = "Pod successfully deleted!"
    redirect_to admin_pods_path
  end

  private

    def pod_params
      params.require(:pod).permit(:name, :description, :inactive_date, :is_test, :school_id)
    end

    def parent_params
      params.permit(:name, :phone)
    end

end
