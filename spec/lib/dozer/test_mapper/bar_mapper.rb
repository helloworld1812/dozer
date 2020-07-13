class BarMapper
  include ::Dozer::Mapperable

  mapping from: 'legal_first_name',  to: :first_name
  mapping from: 'legal_last_name',   to: :last_name
  mapping from: 'legal_m',           to: :middle_name
end
