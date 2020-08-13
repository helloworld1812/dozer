class AdpMapper
  include ::Dozer::Mapperable

  mapping from: :first_name,          to: '/applicant/person/legalName/givenName'
  mapping from: :last_name,           to: '/applicant/person/legalName/familyName1'
  mapping from: :phone_country_code,  to: '/applicant/person/communication/mobiles/countryDialing'
  mapping from: :phone_number,        to: '/applicant/person/communication/mobiles/dialNumber'
  mapping from: :email,               to: '/applicant/person/communication/emails/emailUri'
  mapping from: :birthday,            to: '/applicant/person/birthDate'
  mapping from: :gender,              to: '/applicant/person/genderCode/codeValue', func: ->(val) { {male: 'M', female: 'F'}.fetch(val, nil) }
  mapping from: :marital_status,      to: '/applicant/person/maritalStatusCode/codeValue', func: :transform_marital_status


  def transform_marital_status
    return '1' if @input[:marital_status] == 'married'
    return '2' if @input[:marital_status] == 'single'
    return '3' if @input[:marital_status] == 'divorced'
    'U'
  end
end
