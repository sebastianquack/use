class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy, :transaction_result]
  
  layout "local"

  # Public Actions

  def new_public
    @transaction = Transaction.new
  end

  def new_public_utopist
    @transaction = Transaction.new
  end
  
  def add_cash_public
    @transaction = Transaction.new
  end

  def create_public
    @transaction = Transaction.new(transaction_params)

    if params['seller_role'] == 'utopist'
      # redirect to correct action
      error_action = 'new_public_utopist'      
    else
      error_action = 'new_public'      
    end

    if @transaction.seller_id.blank? || @transaction.buyer_id.blank?
      @notice = "Form not complete"
      render action: error_action and return
    end

    seller = User.find(@transaction.seller_id)
    buyer = User.find(@transaction.buyer_id)

    # utopists only sell their own stock
    if params['seller_role'] == 'utopist'
      @transaction.stock_id = seller.buyer_transactions.first.stock_id
    end
        
    if @transaction.stock_id.blank?
      @notice = "Form not complete"
      render action: error_action and return
    end
    
    # ist the buyer differnt from the seller?
    if seller.id == buyer.id
      @notice = "Buyer and seller are identical"
      render action: error_action and return
    end


    # check if amount is > 0
    if @transaction.amount.to_i == 0 
      @notice = "Transaction with 0 amount"
      render action: error_action and return
    end
    
    # check if seller actually owns enough of the stock
    portfolio = seller.portfolio
    if portfolio[:stocks][@transaction.stock_id]
      if portfolio[:stocks][@transaction.stock_id][:amount] < @transaction.amount
        @notice = "Seller doesn't own enough stock"
        render action: error_action and return
      end
    else
      @notice = "Seller doesn't own enough stock"
      render action: error_action and return
    end
        
    # check if buyer has enough money
    if buyer.balance < @transaction.price.to_i * @transaction.amount.to_i
        @notice = "Buyer doesn't have enough money"
        render action: error_action and return
    end

    if @transaction.save
      if @transaction.transaction_type_id == 0
          redirect_to action: 'transaction_result', id: @transaction.id and return
      else
          redirect_to controller: 'users', action: 'show_public', id: @transaction.seller_id, notice: 'Transaction logged.' and return
      end  
    else
      @notice = 'There was an error saving the transaction.' 
      render action: error_action and return
    end
  end
  
  def transaction_result  
    render layout: 'local'
  end

  def usx
  end


  # Admin Actions 

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all.order('created_at DESC')
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
