RSpec.describe Dozer do
  it "has a version number" do
    expect(Dozer::VERSION).not_to be nil
  end

  it 'should successfull map data from one schema to another schema' do
    hash = { 'legal_first_name' => 'Ryan', legal_last_name: 'Lyu' }
    result = Dozer.map(hash, BarMapper)

    expect(result[:first_name]).to eq('Ryan')
    expect(result[:last_name]).to eq('Lyu')
  end
end
