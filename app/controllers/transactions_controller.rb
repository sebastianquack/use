class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy, :transaction_result]
  
  layout "admin"

  # Public Actions

  def new_public
    @transaction = Transaction.new
    render layout: "local"
  end

  def new_public_utopist
    @transaction = Transaction.new
    render layout: "local"
  end
  
  def add_cash_public
    @transaction = Transaction.new
    render layout: "local"
  end

  def create_public
    @transaction = Transaction.new(transaction_params)

    seller = User.find(@transaction.seller_id)
    buyer = User.find(@transaction.buyer_id)

    if params['seller_role'] == 'utopist'
      # redirect to correct action
      error_action = 'new_public_utopist'
      
      # utopists only sell their own stock
      @transaction.stock_id = seller.buyer_transactions.first.stock_id
      logger.debug @transaction.stock_id
    else
      error_action = 'new_public'      
    end

    # ist the buyer differnt from the seller?
    if seller.id == buyer.id
      redirect_to action: error_action, notice: "Buyer and seller are identical"
      return
    end


    # check if amount is > 0
    if @transaction.amount.to_i == 0 
      redirect_to action: error_action, notice: "Transaction with 0 amount"
      return
    end
    
    # check if seller actually owns enough of the stock
    if seller.portfolio[@transaction.stock_id]
      logger.debug seller.portfolio[@transaction.stock_id][:amount]
      if seller.portfolio[@transaction.stock_id][:amount] < @transaction.amount
        redirect_to action: error_action, notice: "Seller doesn't own enough stock"
        return
      end
    else
      redirect_to action: error_action, notice: "Seller doesn't own enough stock"
      return
    end
        
    # check if buyer has enough money
    if buyer.balance < @transaction.price * @transaction.amount 
        redirect_to action: error_action, notice: "Buyer doesn't have enough money"
        return
    end

    respond_to do |format|
      if @transaction.save
        if @transaction.transaction_type_id == 0
            format.html { redirect_to action: 'transaction_result', id: @transaction.id, notice: 'Transaction logged.' }
        else
            format.html { redirect_to controller: 'users', action: 'show_public', id: @transaction.seller_id, notice: 'Transaction logged.' }
          end
          
      else
        format.html { render action: 'new_public', notice: 'There was an error.' }
      end
    end
  end
  
  def transaction_result  
    render layout: 'local'
  end


  # Admin Actions 

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:transaction_type_id, :seller_id, :buyer_id, :price, :amount, :stock_id)
    end
end
