module LoginSupport

  def log_in(user)
    post login_path, params: { session: { email: user.email, password: user.password } }
    current_user = user
  end

  def log_out
    delete logout_path
    current_user = nil
  end

  def is_logged_in?
    !current_user.nil?
  end

end

RSpec.configure do |config|
  config.include LoginSupport
end
