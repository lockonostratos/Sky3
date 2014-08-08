class SessionsController < MerchantApplicationController
  skip_before_filter :check_account_permission, :only => [:new, :create]

  def index
    render json: current_account
  end

  def current_user
    @account = current_account
  end

  def current_merchant_user
    @merchant_account = current_merchant_account
  end

  def new
    render layout: "empty"
  end

  def create
    account = Account.find_by_email(params[:email])
    if account && account.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = account.auth_token
      else
        cookies[:auth_token] = account.auth_token
      end
      redirect_to home_path
    else
      render 'new', layout: "empty"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to signin_path
  end

  private

  def session_params
    params[:session]
  end
end
