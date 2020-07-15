class FooMapper
  include ::Dozer::Mapperable

  mapping from: 'foo/firstName', to: :first_name
  mapping from: 'foo/lastName',  to: :last_name
  mapping from: 'foo/gender',    to: :gender
end
