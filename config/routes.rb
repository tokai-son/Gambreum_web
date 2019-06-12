Rails.application.routes.draw do
  # top
	get '/' => 'top#main'
  get 'top/main' => 'top#main'

  # battle
  get 'uuu' => 'battle#result'

  # Error
  get '*path', controller: 'application', action: 'render_404'
end
