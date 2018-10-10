Rails.application.routes.draw do
  match "/users/invitations", to: redirect("/404"), via: [:get, :post]
  match "/users/invitations/*", to: redirect("/404"), via: [:get, :post]
  match "/account/invitations", to: redirect("/404"), via: [:get, :post]
  match "/account/invitations/*", to: redirect("/404"), via: [:get, :post]

  if Rails.env.development?
	mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  mount Decidim::Core::Engine => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
