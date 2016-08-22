Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'users', to: 'users#create'
  delete 'users', to: 'users#destroy'
  put 'sign_in', to: 'users#sign_in'
  put 'sign_in_primary', to: 'users#sign_in_primary'
  post 'calculate', to: 'calculations#analyse'
  post 'correlate', to: 'calculations#correlate'
end
