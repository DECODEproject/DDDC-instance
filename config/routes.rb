require "sidekiq/web"
Rails.application.routes.draw do
  match "/users/invitations", to: redirect("/404"), via: [:get, :post]
  match "/users/invitations/*", to: redirect("/404"), via: [:get, :post]
  match "/account/invitations", to: redirect("/404"), via: [:get, :post]
  match "/account/invitations/*", to: redirect("/404"), via: [:get, :post]
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Decidim::Core::Engine => '/'
end
