class MarketSessionsController < ApplicationController
  before_action :set_market_session, only: [:show, :edit, :update, :destroy, :end_session]

  layout 'local'

  # GET json
  def active_session
    @market_session = MarketSession.order('created_at DESC').first
    @market_session_start_seconds = ( @market_session.nil? ? -1 : @market_session.created_at.to_i )
    @market_session_end_seconds = ( @market_session.nil? ? -1 : @market_session_start_seconds + @market_session.duration * 60 )
    render json: {start: @market_session_start_seconds, end: @market_session_end_seconds} 
  end

  def end_session 
    index = 0
    num_active_stocks = Stock.where(:active => true).count
    
    if @market_session.max_survivors < num_active_stocks 
      Stock.all.order('investment DESC').each do |stock|
        if index >= @market_session.max_survivors
          stock.active = false
          
          # distribute utopist balance to stock holders
          
          # how much stocks are left for the players
          total_player_stocks = 100 - stock.utopist.portfolio[:stocks][stock.id][:amount]
          
          if total_player_stocks > 0
            total_cash = stock.utopist.balance 
            end_price = total_cash / total_player_stocks
          
            # who gets the money?
            stock.ownerships.where('amount > 0').each do |ownership|              
              if ownership.user.role == 'player'
                player = ownership.user
                transaction = Transaction.new
                transaction.transaction_type_id = 0
                transaction.stock_id = stock.id
                transaction.buyer_id = stock.utopist.id
                transaction.seller_id = player.id
                transaction.price = end_price
                transaction.amount = player.portfolio[:stocks][stock.id][:amount]
                transaction.save
                transaction.update_users_stocks
              end
            
            end
          end
          
        else 
          stock.active = true
        end
        stock.save
        index += 1
      end  
    end
    render json: {status: 1}
  end

  # GET /market_sessions
  # GET /market_sessions.json
  def index
    @market_sessions = MarketSession.all
  end

  # GET /market_sessions/1
  # GET /market_sessions/1.json
  def show
  end

  # GET /market_sessions/new
  def new
    @market_session = MarketSession.new
  end

  # GET /market_sessions/1/edit
  def edit
  end

  # POST /market_sessions
  # POST /market_sessions.json
  def create
    @market_session = MarketSession.new(market_session_params)

    respond_to do |format|
      if @market_session.save
        format.html { redirect_to @market_session, notice: 'Market session was successfully created.' }
        format.json { render action: 'show', status: :created, location: @market_session }
      else
        format.html { render action: 'new' }
        format.json { render json: @market_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /market_sessions/1
  # PATCH/PUT /market_sessions/1.json
  def update
    respond_to do |format|
      if @market_session.update(market_session_params)
        format.html { redirect_to @market_session, notice: 'Market session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @market_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /market_sessions/1
  # DELETE /market_sessions/1.json
  def destroy
    @market_session.destroy
    respond_to do |format|
      format.html { redirect_to market_sessions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market_session
      @market_session = MarketSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def market_session_params
      params.require(:market_session).permit(:duration, :max_survivors)
    end
end
