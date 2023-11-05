# frozen_string_literal: true

shared_examples_for 'Commentable' do
  describe 'comments' do
    let(:comment_public_fields) { %w[id user_id body created_at updated_at] }
    let(:comment_response) { comments_response.first }

    it 'returns list of links' do
      expect(comments_response.size).to eq 2
    end

    it 'returns public fields' do
      comment_public_fields.each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
