# frozen_string_literal: true

shared_examples_for 'Attachable' do
  describe 'attachments' do
    let(:attach_response) { attachs_response.first }

    it 'returns list of links' do
      expect(attachs_response.size).to eq 1
    end

    it 'returns public fields' do
      expect(attach_response).to eq Rails.application.routes.url_helpers.rails_blob_path(attachable.files.first, only_path: true)
    end
  end
end
