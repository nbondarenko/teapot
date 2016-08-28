require 'spec_helper'

describe CalculationsController, type: :controller do
  describe 'POST /calculate' do
    context 'with valid parameters' do
      it 'returns hash with answer without outliers' do
        post 'analyse', params: { dataset: { set1: ['2','3','4'] } }
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['answer']).to eq 'min' => 2, 'max' => 4, 'avg' => 3,
         'median' => 3, 'q1' => 2, 'q3' => 4, 'outl' => []
      end
      it 'returns hash with answer without outliers' do
        post 'analyse', params: { dataset: { set1: ['2','8','5','3','4','50'] } }
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['answer']).to eq 'min' => 2, 'max' => 50, 'avg' => 12,
         'median' => 4.5, 'q1' => 3, 'q3' => 8, 'outl' => [50]
      end
    end
    context 'with invalid parameters' do
      it 'returns 400 status if set is empty' do
        post 'analyse', params: { dataset: { set1: [''] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if set contains characters' do
        post 'analyse', params: { dataset: { set1: ['we','8','5','3','4','50'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain characters in the start' do
        post 'analyse', params: { dataset: { set1: ['5','8','test5','3','4','50'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain characters in the end' do
        post 'analyse', params: { dataset: { set1: ['2we','8','5','3','4','50'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain spaces at the start' do
        post 'analyse', params: { dataset: { set1: ['2','8','5',' 3','4','50'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain spaces at the end' do
        post 'analyse', params: { dataset: { set1: ['2','8','5','3 ','4','50'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain spaces in the middle' do
        post 'analyse', params: { dataset: { set1: ['2','8','5','3 40','4','50'] } }
        expect(response.status).to eq 400
      end
    end
  end
  describe 'POST /correlate' do
    context 'with valid parameters' do
      it 'returns number' do
        post 'correlate', params: { dataset: { set1: ['2','100','4'], set2: ['2','3','4'] } }
        expect(response.status).to eq 200
      end
    end
    context 'with invalid parameters' do
      it 'returns 400 status if set is empty' do
        post 'correlate', params: { dataset: { set1: [''], set2: ['2','3','4'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if set contains characters' do
        post 'correlate', params: { dataset: { set1: ['2','100','4'], set2: ['2','r','4'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain characters in the start' do
        post 'correlate', params: { dataset: { set1: ['2','100','wr4'], set2: ['2','3','4'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain characters in the end' do
        post 'correlate', params: { dataset: { set1: ['2','100','4'], set2: ['2','3','4r'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain spaces at the start' do
        post 'correlate', params: { dataset: { set1: ['2','100','4'], set2: ['2',' 3','4'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain spaces at the end' do
        post 'correlate', params: { dataset: { set1: ['2','100','4'], set2: ['2 ','3','4'] } }
        expect(response.status).to eq 400
      end
      it 'returns 400 status if elements contain spaces in the middle' do
        post 'correlate', params: { dataset: { set1: ['2','100 4','4'], set2: ['2','3','4'] } }
        expect(response.status).to eq 400
      end
    end
  end
end
