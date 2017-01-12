module ParentHelper
  def sms_button_text
    if @parent.welcome_sms_sent
      "Welcome SMS already sent. Send again?"
    else
      "Send welcome SMS"
    end
  end

  def get_students
    more = true
    students = Array.new
    page = 1
    results = 200 # 200 max
    url = "https://api.wonde.com/v1.0/schools/" + @schoolId + "/students?per_page=#{results}&include=contacts,contacts.contact_details&page="

    begin
      uri = URI("#{url}#{page}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
      request = Net::HTTP::Get.new(uri.request_uri)
      request["authorization"] = "Bearer 355d00547bb356865fc5ec2addc9e48096df4915"
      res = http.request(request)
      if res.code == '200'
        res = JSON.parse(res.body, object_class: OpenStruct)
        students += res.data unless res.data.nil?
        more = res.meta.pagination.more.inspect unless res.meta.nil?
      end
      page += 1
    end while more == 'true' && page < 10

    return students

  end

  def get_parents
    newParents = Array.new
    students = get_students

    Array(students).each do |student|
      if student.date_of_birth.date > @year.to_time # get students born after this date
        student.contacts.data.each do |contact| # get the details for the first contact with a mobile phone number
          phones = contact.contact_details.data.phones
          phones.to_h.each do |k,v|
            phone = v.to_s.gsub(/\s+/, "")
            # return parents with a mobile phone number that is not in this pod already
            if phone.start_with?('07') && phone.length == 11 && !@parents.detect{|p| p.phone == phone}
              student.dob = student.date_of_birth.date.to_date.to_s
              student.phone = phone
              student.name = contact.forename
              student.relationship = contact.relationship.relationship
              student.surname = contact.surname
              newParents << student
            end
          end
        end
      end
    end
    return newParents
  end

end
