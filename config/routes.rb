Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    root "clients#welcome"
    post "auth/signin",  to: "auth#authenticate"

    get  "users/unique", to: "users#unique_field"
    get  "users/me",     to: "users#me"

    resources :users, except: :show

    get  "invoices/unique", to: "invoices#unique_code"
    get  "invoices/download/monthly", to: "invoices#download_monthly_email"
    get  "invoices/download/annual", to: "invoices#download_annual_email"
    post "invoices/search", to: "invoices#search"
    post "invoices/report", to: "invoices#report"
    post "invoices/report/monthly", to: "invoices#send_monthly_email"
    post "invoices/report/annual", to: "invoices#send_annual_email"

    resources :clients do
      resources :invoices
      resources :attachments, except: :update
    end

    resources :locations, only: [:index, :create, :destroy]
  end
end
