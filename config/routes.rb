Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'users', to: 'users#create'
  delete 'users', to: 'users#destroy'
  post 'sign_in', to: 'users#sign_in'
  post 'calculate', to: 'calculations#analyse'
  post 'correlate', to: 'calculations#correlate'
end
