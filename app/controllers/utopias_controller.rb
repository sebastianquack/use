class UtopiasController < ApplicationController
  before_action :set_utopia, only: [:show, :edit, :update, :destroy]
  layout "admin", except: [:create_public]

  # GET /utopias
  # GET /utopias.json
  def index
    @utopias = Utopia.all
  end

  # GET /utopias/1
  # GET /utopias/1.json
  def show
  end

  # GET /utopias/new
  def new
    @utopia = Utopia.new
  end

  # GET /utopias/1/edit
  def edit
  end

  # POST /utopias
  # POST /utopias.json
  def create
    @utopia = Utopia.new(utopia_params)

    respond_to do |format|
      if @utopia.save
        format.html { redirect_to @utopia, notice: 'Utopia was successfully created.' }
        format.json { render action: 'show', status: :created, location: @utopia }
      else
        format.html { render action: 'new' }
        format.json { render json: @utopia.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_public
    @utopia = Utopia.new(utopia_params)

    respond_to do |format|
      if @utopia.save
        #SubmissionMailer.confirmation(@utopia).deliver
        format.html { redirect_to :controller => 'welcome', :action => 'index' }
        format.json { render action: 'show_public', status: :created, location: @utopia }
      else
        format.html { render action: 'new' }
        format.json { render json: @utopia.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /utopias/1
  # PATCH/PUT /utopias/1.json
  def update
    respond_to do |format|
      if @utopia.update(utopia_params)
        format.html { redirect_to @utopia, notice: 'Utopia was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @utopia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /utopias/1
  # DELETE /utopias/1.json
  def destroy
    @utopia.destroy
    respond_to do |format|
      format.html { redirect_to utopias_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_utopia
      @utopia = Utopia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def utopia_params
      params.require(:utopia).permit(:title, :description, :realization, :risks, :effect_body, :effect_economy, :effect_politics, :effect_spirituality, :effect_technology, :effect_environment, :effect_fun, :email, :image)
    end
end
