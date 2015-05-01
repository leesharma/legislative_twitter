require 'test_helper'

module API
  module V1
    class BillsControllerTest < ActionController::TestCase
      context 'bills API' do
        setup do
          @headers = { 'Accept:' => 'application/vnd.troycitycouncil.v1+json' }
        end

        context 'bills' do
          should 'get index' do
            get :index, { format: :json }, @headers

            assert_response :success
            assert_not_nil assigns(:bills), '@bills not set'
          end
        end

        context 'bill' do
          setup do
            @bill = create(:bill)
          end
          should 'show' do
            get :show, { id: @bill, format: :json }, @headers

            assert_response :success
          end
        end
      end
    end
  end
end