require 'spec_helper'

describe UsersController, type: :controller do
   describe 'POST /create' do
     context 'with valid user parameters' do
       it 'sends user object' do
         post :create, params: { user: { email: 'test@mail.com', password: 'password' } }
         body = JSON.parse(response.body)
         expect(response.status).to eq 201
         expect(User.count).to eq 1
         expect(User.first.email).to eq 'test@mail.com'
         expect(body['email']).to eq 'test@mail.com'
       end
     end
      context 'with invalid user parameters' do
        it 'sends errors' do
          post :create, params: { user: { email: 'testmail.com', password: 'password' } }
          body = JSON.parse(response.body)
          expect(response.status).to eq 400
          expect(User.count).to eq 0
          expect(body['error']).to eq "Email is invalid"
        end
      end
   end
   describe 'PUT /sign_in' do
     context 'if user exists' do
       it 'sends user object' do
         User.create(email: 'test@test.com', password: 'test')
         put 'sign_in', params: { user: { email: 'test@test.com', password: 'test' } }
         body = JSON.parse(response.body)
         expect(response.status).to eq 200
         expect(User.count).to eq 1
         expect(body['email']).to eq 'test@test.com'
       end
     end
     context 'without password parameter' do
       it 'sends error message' do
         put 'sign_in', params: { user: { email: 'test@mail.com' } }
         body = JSON.parse(response.body)
         expect(response.status).to eq 400
         expect(body['error']).to eq 'All fields must be filled'
       end
     end
     context 'without email parameter' do
       it 'sends error message' do
         put 'sign_in', params: { user: { password: 'test@mail.com' } }
         body = JSON.parse(response.body)
         expect(response.status).to eq 400
         expect(body['error']).to eq 'All fields must be filled'
       end
     end
     context 'if user doesn\'t exist' do
       it 'sends error message' do
         put 'sign_in', params: { user: { email: 'test@mail.com', password: 'test' } }
         body = JSON.parse(response.body)
         expect(response.status).to eq 400
         expect(body['error']).to eq 'No such user'
       end
     end
   end
   describe 'PUT /sign_in_primary' do
     context 'if session for user exists' do
       it 'sends user object' do
         post :create, params: { user: { email: 'test@mail.com', password: 'password' } }
         put 'sign_in_primary', params: { user: { primary: 'true'}}
         expect(response.status).to eq 200
         body = JSON.parse(response.body)
         expect(body['hadAuth']).to eq true
         expect(body['user']['email']).to eq 'test@mail.com'
       end
     end
     context 'if session for user doesn\'t exist' do
       it 'sends 400 status' do
         put 'sign_in_primary', params: { user: { primary: 'true'}}
         expect(response.status).to eq 200
         body = JSON.parse(response.body)
         expect(body['hadAuth']).to eq false
       end
     end
   end

   describe 'DELETE /users' do
     context 'if session for user exists' do
      let!(:user) { User.create(email: 'test123@test.com', password: 'test') }
       it 'sends 200 status' do
         delete :destroy, params: { id: user.id }
         expect(response.status).to eq 200
         expect(User.find(user.id).token).to eq nil
       end
     end
     context 'if session for user doesn\'t exist' do
       it 'sends 400 status' do
         delete :destroy, params: { id: 0 }
         expect(response.status).to eq 404
       end
     end
   end
end
