Rails.application.routes.draw do
  # top
	get '/' => 'top#main'
  get 'top/main' => 'top#main'
	get 'top/warning_page' => 'top#warning_page'

	# login
	get 'top/login' => 'top#login' # For executing js file

  # battle
  get 'battle/result' => 'battle#result'

  # Error
  get '*path', controller: 'application', action: 'render_404'
end
