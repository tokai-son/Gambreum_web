Rails.application.routes.draw do
  # top
	get '/' => 'top#main'
  get 'top/main' => 'top#main'

	# login
	post 'login/metamask' => 'login#metamask'

  # battle
  get 'battle/result' => 'battle#result'

  # Error
  get '*path', controller: 'application', action: 'render_404'
end
