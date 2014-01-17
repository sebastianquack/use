class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy, :show_gallery, :chart, :chart_data]
  layout "admin"

  # Public Actions

  def chart
  end
    
  def chart_data
    chart = @stock.chart
    a = []
    chart.each_with_index do |c,i|
      if i >= params[:tick].to_i
        h = c.attributes
        h[:seconds] = c.created_at.to_i
        h[:tick] = i      
        a << h 
      end
    end 
    render json: a
  end
  
  def usx_data
    chart = Transaction.usx
    a = []
    chart.each_with_index do |c,i|
      if i >= params[:tick].to_i
        h=c
        h[:tick] = i
        a << h 
      end
    end     
    render json: a
  end
  
  def ranking 
    @investment_data = Stock.ranks
  end
  
  # Admin Actions

  def reset_utopists

    # get rid of old utopists
    User.where("role = 'utopist'").destroy_all
    
    # get rid of all transactions and reset Users
    Transaction.all.destroy_all
    Ownership.all.destroy_all
    
    User.where("role = 'player'").each do |u|
      u.add_cash(Setting.first.base_cash_in)
    end
    
    # for each stock
    Stock.where('active = true').each do |s|

      # create a new utopist
      utopist = User.new;
      utopist.role = 'utopist'
      utopist.name = s.utopist_name
      utopist.save

      # assign to stock
      s.utopist_id = utopist.id
      s.save 
      
      # give all stocks to utopist
      transaction = Transaction.new
      transaction.transaction_type_id = 0
      transaction.stock_id = s.id
      transaction.buyer_id = utopist.id
      transaction.price = 0
      transaction.amount = 100
      transaction.save
      transaction.update_users_stocks
      
    end
    
    redirect_to controller:'users', action:'index'
    
  end


  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end
  
  def show_gallery 
    render :partial => "show_gallery"
  end
  
  def next
    @stock = Stock.find(params[:id]).next
    render :partial => "show_gallery"
  end
  
  def previous
    @stock = Stock.find(params[:id]).previous
    render :partial => "show_gallery"
  end
  
  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stock }
      else
        format.html { render action: 'new' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:name, :symbol, :description, :utopist_name, :active, :tick, :base_price)
    end
end
