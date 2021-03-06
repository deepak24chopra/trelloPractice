class UsersController < ApplicationController

    before_action :set_user, only: [:edit,:update,:show]
    before_action :require_same_user, only: [:edit,:update,:destroy]
    before_action :require_admin_user, only: [:destroy,:index]

    def index
        @users = User.all
    end

    def new
       @user = User.new 
    end

    def create
        #debugger
        @user = User.new(user_params)
        if(params[:user][:password] != params[:user][:confirm_password])
            @user.errors.add(:password, "Passwords do not match.")
            render "new" and return
        end
        if(@user.save)
            session[:user_id] = @user.id
            flash[:success] = "You have successfully signed up."
            redirect_to user_path(@user) and return
        else
            flash.now[:warning] = "Cannot create your account right now."
            render "new"
        end
    end

    def edit
    end

    def update
        if @user.update(user_params)
            flash[:success] = "Account updated successfully."
            redirect_to user_path(@user) and return
        else
            flash.now[:warning] = "Cannot update your account right now."
            render 'edit'
        end
    end

    def show
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        flash[:success] = "User and all boards created by the user have been deleted."
        redirect_to users_path and return
    end

    private #---------------------------------------------------------------------

    def set_user
        @user = User.includes(:boards).find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username,:email,:password)
    end

    def require_same_user
        if current_user != @user and !current_user.admin?
            flash[:info] = "You can only edit your own account."
            redirect_to root_path
        end
    end

    def require_admin_user
        if logged_in and !current_user.admin?
            flash[:danger] = "Only admin users can perform that action."
            redirect_to root_path
        end
    end

end