# frozen_string_literal: true

shared_examples_for 'Linkable' do
  describe 'links' do
    let(:link_public_fields) { %w[id name url created_at updated_at] }
    let(:link_response) { links_response.first }

    it 'returns list of links' do
      expect(links_response.size).to eq 2
    end

    it 'returns public fields' do
      link_public_fields.each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end
  end
end
