Rails.application.routes.draw do
  # top
	get '/' => 'top#main'
  get 'top/main' => 'top#main'
	get 'top/warning_page' => 'top#warning_page'

	# login
	post 'top/login' => 'top#login' # For executing js file
	post 'top/register' => 'top#register' # register user on the blockchain

  # battle
	post 'top/duel' => 'top#duel'

  # Error
  get '*path', controller: 'application', action: 'render_404'
end
