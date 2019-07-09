class ApplicationController < ActionController::Base
	before_action :set_login_user

	# common before action
	def set_login_user
		@logined_user = session[:logined]
	end

	# Error Methods
	def render_404
  	render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
	end

	def render_500
		render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
	end

	# Data Type Checker
	class Module
		def define_typed_method name, *sig, &define_typed_method
			valid = -> other {sig.size == other.size && sig.zip(other).all? {|a,b| a === b} }
			define_method(name){ |*args|
				valid === args ? defmethod.call(*args) :super(*args)
			}
		end
	end

end
