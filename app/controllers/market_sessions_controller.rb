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
    if @market_session.max_survivors > 0 
      Stock.all.order('investment DESC').each do |stock|
        if index >= @market_session.max_survivors
          stock.active = false
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
