class Array #so that partial works
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def html(filename)
    send_file "./views/#{filename.to_s}.html"
  end

  # Convert a hash to a querystring for form population   #not used
  def hash_to_query_string(hash)
    hash.delete 'password'
    hash.delete 'password_confirmation'
    hash.collect { |k, v| "#{k}=#{v}" }.join('&')
  end

  # Redirect to last page or root     #I've deprecated this, as sinatra has 'redirect back'.
  def redirect_last
    if session[:redirect_to]
      redirect_url          = session[:redirect_to]
      session[:redirect_to] = nil
      redirect redirect_url
    else
      redirect '/'
    end
  end

  # Require login to view page
  def login_required #Not sure why rack.url_scheme doesnt work without HTTP_X_.... Also, need to be able to log in on unsecure localhost
    if current_user
      return true
    else
      flash[:info]          = 'Login required to view this page'
      session[:redirect_to] = request.fullpath
      redirect '/login'
      return false
    end
  end

  # Require admin flag to view page
  def admin_required
    if current_user && is_admin?
      return true
    else
      flash[:info] = 'Admin required to view this page'
      redirect '/'
      return false
    end
  end

  # Check user has admin flag
  def is_admin?
    if current_user
      return !!current_user.admin?
    else
      return false
    end
  end

  def is_parent? #not yet implemented
    if current_user
      return !!current_user.parent?
    else
      return false
    end
  end

  def no_parent #not yet implemented
    if current_user and is_parent?
      flash[:info] = 'Parents aren\'t allowed on this page'
      redirect '/'
      return false
    else
      return true
    end
  end

  # Check logged in user is the owner    #used this for blog editing.
  # random protip: typing # while having text selected in RubyMine converts to "#{this}"
  def is_owner? owner_id
    if current_user and is_admin? || current_user.id.to_i==owner_id.to_i
      return true
    else
      return false
    end
  end

  def owner_required owner_id
    if is_owner?(owner_id)
      return true
    else
      flash[:info] = 'You do not own this document.'
      redirect '/'
      return false
    end
  end

  # Return current_user record if logged in
  def current_user
    return @current_user ||= User.first(:token => request.cookies["user"]) if request.cookies["user"]
    @current_user ||= User.first(:token => session[:user]) if session[:user]
  end

  # check if user is logged in?
  def logged_in?
    !!session[:user]
  end

  def partial(template, *args)
    options = args.extract_options!
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then #I know that the "then" here is bad style, but I didn't write this!
      collection.inject([]) do |buffer, member|
        buffer << erb(template, options.merge(
            :layout => false,
            :locals => {template.to_sym => member}
        )
        )
      end.join("\n")
    else
      erb(template, options)
    end
  end

  def glorify_blog(id, text, options = {})
    return $blog_cache[id] if $blog_cache[id]
    rendered        = Sinatra::Glorify::Renderer.new(options).parse(text.force_encoding('UTF-8'))
    $blog_cache[id] = rendered
  end

	def info(text, title: nil, direction: "top")
		%(<button class="btn btn-link" data-toggle="popover" data-trigger="hover" data-title="#{title}" data-placement="#{direction}" data-content="#{text}"><i class="fa fa-info-circle info"></i></button>)
	end

end
