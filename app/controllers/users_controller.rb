class UsersController < ApplicationController
  before_action :set_user, only: [:show, :show_public, :edit, :update, :destroy]

  layout "admin"
  
  # PUBLIC ACTIONS

  def new_public
    @user = User.new
    render layout: "local" 
  end

  def create_public
    @user = User.new(user_params) 
    
    @user.name.strip!
    @user.name.capitalize!
    
    if User.where(:name => @user.name).length > 0
        @notice = 'Dieser Name ist bereits vergeben.'
    	render layout: 'local', action: 'new_public' and return
    end
    
    @user.role = 'player';
    @user.status = 1;
    
    respond_to do |format|
      if @user.save
        @user.add_cash(Setting.first.base_cash_in)
    	@user.add_base_stocks
    
        format.html { redirect_to action: 'show_public', id: @user.id, notice: 'User was successfully created.' }
      else
        format.html { render layout: 'local', action: 'new_public', notice: 'There was an error.' }
      end
    end
    
  end
  
  def show_public
    render layout: "local"
  end  

  def all_portfolios
    @users = User.where(:role => 'player').order('name ASC')
    render layout: "local"
  end  

  
  def ranks 
    @ranks = User.all_ranks    
    if params[:sort_key]
      sort_key = params[:sort_key]
    else
      sort_key = 'balance'
    end  
    @ranks_sorted = @ranks.sort_by {|key, value| -value[sort_key.to_sym][:value]}
  end
  
  # ADMIN ACTIONS

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :balance, :type, :status)
    end
end
